/*
* @Desc: US3323348 - Main Controller class for the Home Page
* @Date: 10th of Mar 2021
* @Dev: Vishnu
*/
public with sharing class ACET_WorkQueueController {
    
    @AuraEnabled
    public static ACET_RoutingScreenController.ORSRoutingWrapper getRoutingData() {
        ACET_RoutingScreenController.ORSRoutingWrapper wrapper = (ACET_RoutingScreenController.ORSRoutingWrapper)ACET_RoutingScreenController.getRoutingInfo();
        return wrapper;
    }
    @AuraEnabled
    public static List<String> getSubTypeValues(String topic, String type)
    {
        List <SAE_Reason_Codes__mdt > saeReasonCodes = [SELECT Subtype__c FROM SAE_Reason_Codes__mdt
                                                        WHERE (Topic__c =:topic) AND (Type__c=:type) AND (Subtype__c!=null)];
        Set<String> subTypeSet=new Set<String>();
        for(SAE_Reason_Codes__mdt src:saeReasonCodes)
        {
                subTypeSet.add(src.Subtype__c);
            
        }
       List<String> strs=new List<String>(subTypeSet);
       return strs;
    }
    @AuraEnabled
    public static List<String> getTopics()
    {
        List <SAE_Reason_Codes__mdt > saeReasonCodes = [SELECT Topic__c FROM SAE_Reason_Codes__mdt
                                                        WHERE (Topic__c !=null) AND (Type__c!=null) AND (Subtype__c!=null)];
        Set<String> topic=new Set<String>();
        List<String> myStrings = new List<String>{'Provider Details', 'Provider Lookup','View Claims'};
            for(SAE_Reason_Codes__mdt src:saeReasonCodes)
        {
            if(myStrings.contains(src.Topic__c))
            {
                topic.add(src.Topic__c);
            }
            
        }
       List<String> strs=new List<String>(topic);
       return strs;
    }


    // Method to close an ORS case. Will be calling ReadIssue API first & then UpdateORS API
    @AuraEnabled
    public static ACET_SAECalloutResult updateORSRecord(OrsRequestDetails orsRequestDetails){
        System.debug('@@@ ReadIssue API called');
        System.debug('@@@ ReadIssue API called ## orsRequestDetails ::: ' + orsRequestDetails);
        ACET_SAECalloutResult returnResponse = new ACET_SAECalloutResult();
        try{
            //Getting Loggedin User Details 
            ACET_UpdateORSRequest.OrsSourceSystemParameters userDetails = new ACET_UpdateORSRequest.OrsSourceSystemParameters();
            userDetails = getLoggedinUserDetails();
            //Forming ReadIssue RequestBody
            String readIssueRequestBody = '';
            System.debug('@@@ ReadIssue API called ## userDetails ::: ' + userDetails);
            readIssueRequestBody = ACET_ServiceRequestDetailCtrl.getRequestBody(userDetails.logonId,userDetails.logonOffice,orsRequestDetails.issueId);
            //Temp Hardcoding
            //readIssueRequestBody = '{"controlModifiers":{"orsSystemParameters":{"logonId":"CSM","logonOffice":"673"}},"issueId":D10822142546246};
            //Calling ReadIssue Service
            ACET_ORSWebservice orsWebService = new ACET_ORSWebservice();
            HttpResponse response;
            if(!Test.isRunningTest())
            {
                response = (HttpResponse)orsWebService.readIssueDetails(readIssueRequestBody);
            }else
            {
                HttpResponse mockCall = new HttpResponse();
                String responseString = [SELECT Body FROM StaticResource WHERE Name ='ReadIssue' LIMIT 1].Body.toString();
                mockCall.setBody(responseString);
                mockCall.setStatusCode(200);
                response =mockCall;
            }
            //ReadIssue API error handling
            if(response.getStatusCode() != 200){
                returnResponse.isSuccess = false;
                returnResponse.statusCode = response.getStatusCode();
                returnResponse.response = response.getBody();
                System.debug('@@@ ReadIssue API failed in HOME PAGE ::  ' + response.getStatusCode());
                return returnResponse;
            }
            // temp codes - Sarma
            // System.debug('@@@ ReadIssue API Success in HOME PAGE ::  ' + response.getBody());
            // returnResponse.isSuccess = true;
            // returnResponse.statusCode = response.getStatusCode();
            // returnResponse.response = response.getBody();
            // return returnResponse;
            // temp - end 
            System.debug('@@@ HOME PAGE @@ closeORSRecord METHOD :: readIssue Success!! ');
            ACET_ORSReadIssueWrapper issueDetails = ACET_ORSReadIssueWrapper.parse(response.getBody());
            System.debug('@@@ HOME PAGE @@ closeORSRecord METHOD :: readIssueResponse :: ' + issueDetails);

            //creating comment List from cooment String
            List<String> commentList = new List<String>();
            commentList = createCommentList(orsRequestDetails.comment);
            // forming request body
            ACET_UpdateORSRequest requestObject = ACET_UpdateORSForWorkQueue.createUpdateRequest(orsRequestDetails,issueDetails,commentList,userDetails);
            String updateOrsRequestBody = JSON.serialize(requestObject);
            System.debug('@@@ HOME PAGE @@ closeORSRecord METHOD :: updateOrsRequestBody :: ' + updateOrsRequestBody);
            updateOrsRequestBody = updateOrsRequestBody.replace('null', '""').replace('number_Z', 'number');
            System.debug('@@@ HOME PAGE @@ closeORSRecord METHOD :: updateOrsRequestBody After :: ' + updateOrsRequestBody);
            HttpResponse updateOrsResponse = (HttpResponse)ACET_ORSWebservice.updateORSIssue(updateOrsRequestBody,orsRequestDetails.issueId);
            Integer statusCode = updateOrsResponse.getStatusCode(); 
            
            if(statusCode == 201){
                returnResponse.isSuccess = true;
                returnResponse.Message = '';
                returnResponse.statusCode = statusCode;
                System.debug('@@@ Update ORS API Success in HOME PAGE ::  ' + response.getBody());
                return returnResponse;
            } else {
                returnResponse.isSuccess = false;
                returnResponse.statusCode = statusCode;//added by vishnu
                returnResponse.Message = String.valueOf(updateOrsResponse);
                System.debug('@@@ Update ORS API failed in HOME PAGE ::  ' + response.getBody());
            }
            
        }  catch(Exception e){
            System.debug('@@@ HOME PAGE @@ closeORSRecord METHOD :: ' + e.getMessage());
            System.debug('@@@ HOME PAGE @@ closeORSRecord METHOD :: ' + e.getLineNumber());
            returnResponse.isSuccess = false;
            returnResponse.statusCode = 999;
            returnResponse.message = e.getMessage();
        }

        return returnResponse; 
        
    }

    //Method to get Tops(Token API) details
    public static ACET_UpdateORSRequest.OrsSourceSystemParameters getLoggedinUserDetails(){
        ACET_UpdateORSRequest.OrsSourceSystemParameters orsSourceSystemParameters = new ACET_UpdateORSRequest.OrsSourceSystemParameters();
        //Get Tops details from Cache - Reusing logics from Oasis.
        String topsUserId = (String) Cache.Session.get('local.TOPSProfileInfo.userId'); //673/JR2
        List < String > searchInputParams = new List < String > ();
        if (!String.isBlank(topsUserId)) {
            searchInputParams = topsUserId.split('/');
        } else {
            ACET_LoginFlowCtrl loginflow = new ACET_LoginFlowCtrl();
            loginflow.validateTopsCredentials();
            topsUserId = (String) Cache.Session.get('local.TOPSProfileInfo.userId');
            if (!String.isBlank(topsUserId)) {
                searchInputParams = topsUserId.split('/');
            }
        }
        if(searchInputParams.size() > 0){
            orsSourceSystemParameters.logonId = searchInputParams[1];
            orsSourceSystemParameters.logonOffice = searchInputParams[0];
        }

        return orsSourceSystemParameters;
    }
	
	// Review and remove later - Vishnu & Sarma 
     public static List<String> getTopsUserCreds(){
        List<String> searchInputParams = new List<String> ();
        String topsUserId = (String) Cache.Session.get('local.TOPSProfileInfo.userId');
        if (!String.isBlank(topsUserId)) {
            searchInputParams = topsUserId.split('/');
        } else {
            if (!Test.isRunningTest()) {
                ACET_LoginFlowCtrl loginflow = new ACET_LoginFlowCtrl();
                loginflow.validateTopsCredentials();
                topsUserId = (String) Cache.Session.get('local.TOPSProfileInfo.userId');
                if (!String.isBlank(topsUserId)) {
                    searchInputParams = topsUserId.split('/');
                }
            }
        }

        return searchInputParams;
    } 

    //Method to create Comment List from Comment String
    public static List<String> createCommentList(String comment){
        List<String> commentList  = new List<String>();
        Integer length = comment.length();
        if (length > 71) {
            Integer noOfIterations = (Integer) length / 71;
            for (Integer i = 0; i <= noOfIterations; i++) {
                if (length > (i * 71) + 71) {
                    commentList.add(comment.subString(i * 71, (i * 71) + 71));
                } else {
                    commentList.add(comment.subString(i * 71, length));
                }
            }
        } else {
            commentList.add(comment);
        }
        return commentList;
    }

    @AuraEnabled
    public static ACET_SAECalloutResult callSelectWorkLoadService(){
        ACET_SAECalloutResult retResponse = new ACET_SAECalloutResult();
        retResponse = ACET_SelectWorkLoadService.callSelectWorkLoadService();
        return retResponse;
    }

    // Wrapper for update/Route request
    public class OrsRequestDetails {
        @AuraEnabled public String routeOrClose {get;set;}
        @AuraEnabled public String comment {get;set;}
        @AuraEnabled public String issueId {get;set;}
        @AuraEnabled public String officeId {get;set;}
        @AuraEnabled public String departmentCode {get;set;}
        @AuraEnabled public String teamCode {get;set;}
    }
     
}