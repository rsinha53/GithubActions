/**
* Author: Hasara Disanayaka
* Description : Controller class to be used by Dahsboard to get data from web services.
* AuraEnabled : True
* Date Created: 24/9/2019
*/
public without sharing class ADBHealthAssessmentController {
    //  Constant Request parameter values
    final static String APPLICATION_ID = 'RALLY';
    final static String TRANSACTION_ID = '20200237stargateMPEv3change';
    final static Boolean INCLUDE_EXTENDED_ATTRIBUTES = false;
    final static Boolean APPLY_FILTERS = false;
    final static String REQUEST_TYPE = 'BIG5'; 
    final static String SEARCH_TYPE = 'ALL';
    @AuraEnabled
    public static String getCompletionDate(String memberId, String firstName, String lastName, String memberDob, String contractNumber) {
        String completionDate;
        String signtre ='';
        // to get signature to pass as endpoint params
        //	calling the general signature generation logic - Madhura : US2574136
        signtre = ADBWebservice.generateSignature('ADBHealthAssessmentSignature', 'JWT');
        system.debug('signature string'+ signtre);
        // Creating request body to pass to the service
        ADBHealthAssessmentServiceRequestWrapper request = new ADBHealthAssessmentServiceRequestWrapper();
        request.first_name = firstName;
        request.last_name = lastName;
        request.date_of_birth = memberDob;
        request.search_id = memberId;
        request.contract_number = contractNumber;
        String serializedBody = JSON.serialize(request); 
        //Creating headers for the service
        Map<String, String> headers = new map<String, String>{'Content-Type' => 'application/json'}; 
            Map<String, ACETOrgInstanceURLToOrgNameMap__c> OrgInstance2OrgNameMap = ACETOrgInstanceURLToOrgNameMap__c.getAll();
        String OrgName = ACETUtility.GetOrgName(OrgInstance2OrgNameMap);
        String label = OrgName + '_ADBHealthAssessmentParameters';
        // query custom metadatatype to get the constant parameters
        ADBHealthAssessmentParams__mdt params = [SELECT Id, 
                                                 API_KEY__c,
                                                 PARTNER_ID__c,
                                                 PRODUCT__c,
                                                 USER_ID__c,
                                                 Endpoint__c
                                                 FROM ADBHealthAssessmentParams__mdt 
                                                 WHERE MasterLabel =: label
                                                 LIMIT 1];
        // creating a endpoint/key parameters for the service(Bluesteel)
        String keyParams = '?api_key='+params.API_KEY__c+
            '&sig='+signtre+
            '&partnerId='+params.PARTNER_ID__c+
            '&product='+params.PRODUCT__c;
        system.debug('keyparams ::'+keyParams);
        String endpoint = params.Endpoint__c;
        system.debug('endpoint ::'+endpoint); 
        // Webservice callout to get the health assessment response
        HttpResponse response = ADBWebService.sendRequest(serializedBody, headers, endpoint+keyParams, 'POST');        
        if(response.getStatusCode() == 200) {
            // Deserializing response
            request = (ADBHealthAssessmentServiceRequestWrapper) JSON.deserialize(response.getBody(),
                                                                                  ADBHealthAssessmentServiceRequestWrapper.class);
            system.debug('Wrapper test test'+ request);
            if(request != null){
                for(ADBHealthAssessmentServiceRequestWrapper.surveys srveys : request.hra.surveys){
                    system.debug('completion date'+ srveys.completionTS); 
                    completionDate = srveys.completionTS;
                }
            }
        } else {
            request.responseCode = String.valueOf(response.getStatusCode());
            request.responseMsg = response.getStatus();
        }
        return completionDate;
    } 
    // get person Id && population Id for incentives (MPE service) - Not Completed 
    @AuraEnabled
    public static ADBMPEResponseWrapper getPersonId(String memberId, String firstName, String lastName, String memberDob, List<String> contractNumber){
        // Response Wrapper to store the response
        ADBMPEResponseWrapper responseWrapper = new ADBMPEResponseWrapper();
        // get current date for the request
        String currentDate = system.now().formatGMT('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'');
        Map<String, ACETOrgInstanceURLToOrgNameMap__c> OrgInstance2OrgNameMap = ACETOrgInstanceURLToOrgNameMap__c.getAll();
        String OrgName = ACETUtility.GetOrgName(OrgInstance2OrgNameMap);
        String label = OrgName + '_ADBMPEServiceParams';
        // query custom metadatatype to get the constant parameters
        ADBMPEServiceParameter__mdt params = [SELECT Id, 
                                              optum_cid_ext__c,
                                              scope__c,
                                              actor__c,
                                              Endpoint__c
                                              FROM ADBMPEServiceParameter__mdt 
                                              WHERE MasterLabel =: label 
                                              LIMIT 1];
        //Parameters/ enpoint parameters       
        String optum_cid_ext = params.optum_cid_ext__c;
        String scope = params.scope__c;
        String actor = params.actor__c;
        Map<String, String> requestBody = new map<String, String> {
            'optum-cid-ext' => optum_cid_ext,
                'scope' => scope,
                'actor' => actor
                };  
                    system.debug('request body$$$$$'+ requestBody); 
        // creating request for the service
        ADBMPERequestWrapper mpeRequest = new ADBMPERequestWrapper();
        mpeRequest.MemberProductEligibilityRequest  = new ADBMPERequestWrapper.memberProductEligibilityRequest();
        mpeRequest.MemberProductEligibilityRequest.requestHeader = new ADBMPERequestWrapper.RequestHeader();
        mpeRequest.MemberProductEligibilityRequest.requestHeader.applicationName = APPLICATION_ID;
        mpeRequest.MemberProductEligibilityRequest.requestHeader.transactionId = TRANSACTION_ID;
        mpeRequest.MemberProductEligibilityRequest.consumerDetails = new ADBMPERequestWrapper.ConsumerDetails();
        mpeRequest.MemberProductEligibilityRequest.consumerDetails.firstName = firstName;   //'Gregory';
        mpeRequest.MemberProductEligibilityRequest.consumerDetails.lastName = lastName; //'Zhangn';
        mpeRequest.MemberProductEligibilityRequest.consumerDetails.dateOfBirth = memberDob;    //'1966-06-10';
        mpeRequest.MemberProductEligibilityRequest.consumerDetails.searchId = memberId;   // '900100100';
        List<String> conNumbers = new List<String>();
        conNumbers.add('0168504');
        mpeRequest.MemberProductEligibilityRequest.consumerDetails.contractNumbers = contractNumber;
        mpeRequest.MemberProductEligibilityRequest.filteringAttributes = new ADBMPERequestWrapper.FilteringAttributes();
        mpeRequest.MemberProductEligibilityRequest.filteringAttributes.includeExtendedAttributes = INCLUDE_EXTENDED_ATTRIBUTES;
        mpeRequest.MemberProductEligibilityRequest.filteringAttributes.applyFilters = APPLY_FILTERS;
        mpeRequest.MemberProductEligibilityRequest.requestDetails = new ADBMPERequestWrapper.RequestDetails();
        mpeRequest.MemberProductEligibilityRequest.requestDetails.requestType = REQUEST_TYPE;
        mpeRequest.MemberProductEligibilityRequest.requestDetails.searchType = SEARCH_TYPE;
        mpeRequest.MemberProductEligibilityRequest.requestDetails.eventDate = currentDate;
        String serializedBody = JSON.serialize(mpeRequest);
        system.debug('personid serializedBody$$$$$'+ serializedBody);
        // Actual service call to get the MPE service response
        ACET_WebserviceCalloutFramework wsCallOutFW = new ACET_WebserviceCalloutFramework('ADBMPEServiceEndpoint', serializedBody, requestBody);
        HttpResponse response = wsCallOutFW.getResponse();
        system.debug('personid response$$$$$'+ response.getBody());
        //Checking the status code is success
        if(response.getStatusCode() == 200) {
            // Deserializing the response to response Wrapper
            responseWrapper = (ADBMPEResponseWrapper) JSON.deserialize(response.getBody(),
                                                                       ADBMPEResponseWrapper.class);
        } else {
            // Incase of the failure setting the statuscode and status to response wrapper
            responseWrapper.responseCode = String.valueOf(response.getStatusCode());
            responseWrapper.responseMsg = response.getStatus();
        }
        return responseWrapper;
    }
    // get Incentives details
    @AuraEnabled
    public static ADBHealthAssessmentResponceWrapper getIncentives(String dob, String firstName, String lastName, String memberNumber, String groupNumber) {
        Map<String, ACETOrgInstanceURLToOrgNameMap__c> OrgInstance2OrgNameMap = ACETOrgInstanceURLToOrgNameMap__c.getAll();
        String OrgName = ACETUtility.GetOrgName(OrgInstance2OrgNameMap);
        ADBRallyIncentiveRequestWrapper request = new ADBRallyIncentiveRequestWrapper();
        ADBHealthAssessmentResponceWrapper response = new ADBHealthAssessmentResponceWrapper();
        String personId;
        // get signature 
        //	calling the general signature generation logic - Madhura : US2574136
        String signtre = ADBWebservice.generateSignature('ADBIncentiveSignature', 'JWT'); 
        // To get the persond Id to for the Incentive service
        List<String> conNumbers = new List<String>();
        conNumbers.add(groupNumber);
        system.debug('big 5 for Incentives'+ memberNumber+ firstName+ lastName+ dob+ groupNumber);
        if(!Test.isRunningTest()){
            ADBMPEResponseWrapper personIdResponse = ADBHealthAssessmentController.getPersonId(memberNumber, firstName, lastName, dob, conNumbers);
            if(personIdResponse != null && personIdResponse.MemberProductEligibilityResponse != null 
               && personIdResponse.MemberProductEligibilityResponse.consumerDetails.size()>0){
                   system.debug('person id respose wrapper'+ personIdResponse.MemberProductEligibilityResponse.consumerDetails[0].idSet.personId);
                   personId = string.valueof(personIdResponse.MemberProductEligibilityResponse.consumerDetails[0].idSet.personId);
               }
        }
        else{
            personId = '181139358'; 
        }
        // query custom metadatatype to get the constant parameters
        String tokenMasterLabel = orgName + '_ADBRallyIncentiveParameter';
        ADBRallyIncentiveParameter__mdt params = [SELECT Id, API_KEY__c, Endpoint__c
                                                  FROM ADBRallyIncentiveParameter__mdt 
                                                  WHERE MasterLabel =: tokenMasterLabel
                                                  LIMIT 1];
        // get Config endpoint for Incentives        
        String endPoint = params.Endpoint__c;
        request.firstName = firstName;
        request.lastName = lastName;
        request.dob = dob;
        request.memberNumber = memberNumber;
        request.groupNumber = groupNumber;
        //	to cater the service difference in non prod and prod environments
        if('prd'.equals(OrgName)) {
            request.partnerUserId = personId;
        } else {
            endPoint += personId;
        }
        system.debug('incentive endPoint '+ endPoint);
        system.debug('incentive request '+ request);
        String serializedBody = JSON.serialize(request); 
        Map<String, String> headers = new map<String, String>{
            'Content-Type' => 'application/json'
                }; 
                    String keyParams = '?Api_key='+params.API_KEY__c+
                    '&sig='+signtre;
        system.debug('key params :::::'+keyParams);        
        HttpResponse getresponse = ADBWebService.sendRequest(serializedBody, headers, endPoint+keyParams, 'POST');
    //   if (firstName.toLowerCase().equals('bethel')) {
    //        String memberMockData = 'ADBCoinFixMockResponse';
    //        StaticResource mock = [SELECT body FROM StaticResource WHERE Name =: memberMockData];
    //        getresponse.setBody(mock.body.toString());
    //        getresponse.setStatusCode(200);
    //     }
    //     if (firstName.toLowerCase().equals('evelyn')) {
    //            String memberMockData = 'ADBCoinFixMockResponseDollar';
    //            StaticResource mock = [SELECT body FROM StaticResource WHERE Name =: memberMockData];
    //            getresponse.setBody(mock.body.toString());
    //            getresponse.setStatusCode(200);
    //         }
        system.debug('incentive responce '+ getresponse.getBody());
        String res;
        if(getresponse.getStatusCode() == 200) {
            res= getresponse.getBody();
            request = (ADBRallyIncentiveRequestWrapper) JSON.deserialize(res, ADBRallyIncentiveRequestWrapper.class);
            if(request != null){
                List<ADBRallyIncentiveRequestWrapper.Activities> completedActivitiesList = new List<ADBRallyIncentiveRequestWrapper.Activities>();
                List<ADBRallyIncentiveRequestWrapper.Activities> pendingActivitiesList = new List<ADBRallyIncentiveRequestWrapper.Activities>();
                List<ADBRallyIncentiveRequestWrapper.Activities> coinActivitiesList = new List<ADBRallyIncentiveRequestWrapper.Activities>();
                for(ADBRallyIncentiveRequestWrapper.Activities act : request.activities){
                    if(pendingActivitiesList.size() < 3 || completedActivitiesList.size() < 3){
                        if(act.activityStatus == 'PENDING'){
                            if(pendingActivitiesList.size() < 3){
                                pendingActivitiesList.add(act);
                                continue;
                            }    
                        } else if(act.activityStatus == 'COMPLETE'){
                            if(completedActivitiesList.size() < 3){
                                completedActivitiesList.add(act);
                                continue;
                            }
                        }
                    } else {  
                        break;
                    }
                }
                // Get Total coin value
                Integer totalCOinYield = 0;
                for(ADBRallyIncentiveRequestWrapper.Activities act : request.activities){
                    if(act.activityStatus == 'COMPLETE'){
                        if(act.coinYield!=null){
                            totalCOinYield = totalCOinYield + act.coinYield;
                        }
                    }
                }
                response.completedActivitiesList = completedActivitiesList;
                response.pendingActivitiesList = pendingActivitiesList;
                response.plan = request.plan;
                response.totalCOinYield = totalCOinYield;
                system.debug('completed - ' + completedActivitiesList.size());
                system.debug('pending - ' + pendingActivitiesList.size());
                system.debug('pending - ' + response.personId + response.populationId);
            }
        } else {
            response.responseCode = String.valueOf(getresponse.getStatusCode());
            response.responseMsg = getresponse.getStatus();
        }
        return response; 
    }
    @AuraEnabled
    public static String getWellnessHASummaryUrl (String cdbXrefId,String userId){
        String wellnessHSUrl = '';
        List<ADBIcueSsoApiUrlParams__mdt> urlParams = [SELECT URL__c  
                                                       FROM ADBIcueSsoApiUrlParams__mdt WHERE MasterLabel = 'HealthAssessmentUrl'];
        if(urlParams != null && !urlParams.isEmpty()){
            String prefilledUrl = urlParams[0].URL__c;
            System.debug('prefilledUrl'+prefilledUrl);
            List<String> fillers = new String[]{cdbXrefId};    
                prefilledUrl = String.format(prefilledUrl, fillers);  
            wellnessHSUrl = ADBICUESSOUtilController.generateUrlWithParams(prefilledUrl,userId);
            system.debug('wellnessHSUrl'+wellnessHSUrl);
            return wellnessHSUrl;
        }
        return wellnessHSUrl;
    }
    @AuraEnabled
    public static String getWellnessDefaultUrl (String cdbXrefId,String userId){
        String wellnessDefUrl = '';
        List<ADBIcueSsoApiUrlParams__mdt> urlParams = [SELECT URL__c  
                                                       FROM ADBIcueSsoApiUrlParams__mdt WHERE MasterLabel = 'IncentivesUrl'];
        if(urlParams != null && !urlParams.isEmpty()){
            String prefilledUrl = urlParams[0].URL__c;
            System.debug('prefilledUrl'+prefilledUrl);
            List<String> fillers = new String[]{cdbXrefId};    
                prefilledUrl = String.format(prefilledUrl, fillers);  
            wellnessDefUrl = ADBICUESSOUtilController.generateUrlWithParams(prefilledUrl,userId);
            return wellnessDefUrl;
        }
        return wellnessDefUrl;
    }
}