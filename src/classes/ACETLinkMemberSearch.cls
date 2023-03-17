/*
Created By: Som
Created Date: 7th Aug 2019
Description: This class is replica of SAEProviderSearch but it contains ACET level naming and changes.
*/
public class ACETLinkMemberSearch  { //extends ACETWebservice

    public class SearchResultWrapper{
        //@AuraEnabled public ACETMemberSearchInteractionResult resultWrapper {get;set;} //Code Not Required for ITE-Required for SAE
        @AuraEnabled public ACETLinkCoveragesResult resultWrapper {get;set;} //Code Required for ITE
        @AuraEnabled public ACETHouseHoldWrapper houseHoldResultWrapper {get;set;}
        @AuraEnabled public ACETSNIWrapper SNIresultWrapper {get;set;}
        @AuraEnabled public string message {get;set;}
        @AuraEnabled public integer statusCode {get;set;}
    }
    @AuraEnabled
    public static Boolean fetchUser(){
        // query current user information
        Set<String> allProfiles = new Set<String>();
        Boolean profileCheck;
        //User oUser = [select id,Name,Profile.Name FROM User Where id =: userInfo.getUserId()];
        String usrProfileName = [select u.Profile.Name from User u where u.id = :Userinfo.getUserId()].Profile.Name;
        for(Profile_Routing__mdt s:[SELECT DeveloperName, Profile_Name__c,MasterLabel  FROM Profile_Routing__mdt where MasterLabel ='SNI']){
            allProfiles.add(s.Profile_Name__c);
        }
        system.debug('usrProfileName........'+usrProfileName);
        system.debug('allProfiles........'+allProfiles);
        if(allProfiles.contains(usrProfileName)){
            profileCheck = false;
        }else{
            profileCheck = true;
        }
        return profileCheck;
    }
    @AuraEnabled
    public static boolean checkUHGaccess(String policyId){
        system.debug('checkUHGaccess---------');
        system.debug('checkUHGaccess-----checkUHGPolicy----'+ACETUtility.checkUHGPolicy(policyId));
        if(ACETUtility.checkUHGPolicy(policyId)){
            system.debug('checkUHGaccess----checkUserUhgAccess-----'+ACETUtility.checkUserUhgAccess());
            if(! ACETUtility.checkUserUhgAccess()){
                return false;
            }
        }
        return true;
        /*
        string uhgPolicies = label.UHGPolicies;
        Boolean chkUhgAccess = true;
        if(uhgPolicies != null){
             
            List<string> lstUhgPol = new List<string>();
            if(uhgPolicies.contains(';')){
                lstUhgPol = uhgPolicies.split(';');
            }
            else{
                lstUhgPol.add(uhgPolicies);
            }
            Boolean checkPolicy = false;
            for(string pol:lstUhgPol){
                if(pol.equals(policyId)){
                    checkPolicy = true;
                   
                }
            }
            if(checkPolicy){
                string uId = userInfo.getUserId();
                string uhgAccess = [select UHG_Access__c from user where id =: uId].UHG_Access__c;
                if(uhgAccess != 'Yes' || uhgAccess != 'yes' || uhgAccess != 'YES'){
                   chkUhgAccess = false;
                }
            }
        }
        return chkUhgAccess;
        */
       // return true;    
    }
    @AuraEnabled
    public static SearchResultWrapper findSNIDetails(String memberId, String policyId,String firstName, String lastName, String memDob){
         SearchResultWrapper returnData = new SearchResultWrapper();
        try{
            system.debug('expiry time*****----findSNIDetails--');
           ISL_Webservice_Config__c csSNI = ISL_Webservice_Config__c.getInstance('SNIAPIAccessToken');

       // list<Token_Generation__c> lstToken = [select Id,Token_Name__c,Value__c,ExpiryTime__c from Token_Generation__c where Token_Name__c = 'SNIAPIAccessToken' limit 1];
       // 
        if(csSNI != null){
           // system.debug('expiry time*****------'+lstToken[0].ExpiryTime__c);
           // system.debug('date time now*****------'+datetime.now());
          if( csSNI.TokenExpiredBy__c != null && csSNI.TokenExpiredBy__c > datetime.now()){
            
            ACETLinkSNIWebService sniEligibilityCls = new ACETLinkSNIWebService();
            ACETSNIWrapper resultwrap = new ACETSNIWrapper();
            ACETWSCalloutResult CalloutResult  = sniEligibilityCls.getMemberWS(memberId, policyId, firstName, lastName, memDob);
            if (CalloutResult.Success){
                resultwrap= (ACETSNIWrapper)CalloutResult.Response;
            }
            system.debug('findSNIDetails snieligibility -----'+resultwrap.sniEligibility);
            system.debug('findSNIDetails snieligibility -----'+resultwrap.advisorFullName);
            returnData.SNIresultWrapper = resultwrap;
            returnData.message = CalloutResult.Message;
            returnData.statusCode = CalloutResult.statusCode;
            system.debug('findSNIDetails CalloutResult Message-----------'+CalloutResult.Message);
            system.debug('findSNIDetails CalloutResult statusCode-----------'+CalloutResult.statusCode);
           
          }
          else{
             system.debug('entered token get block-------------');
             Cache.OrgPartition orgPart = Cache.Org.getPartition('local.acetqa');
             if((Boolean)orgPart.get('calloutCheck') != null && (Boolean)orgPart.get('calloutCheck') ){
                 system.debug('entered token get block---cache exist----------');
		        returnData.message = 'Token Expired and Record Locked';
                returnData.statusCode = 839;
                system.debug('after un locked-------------');
		    }
		    else{
               system.debug('entered token get block---cache create----------');
			   Cache.Org.put('local.acetqa.calloutCheck', true);
			   getNewAccessToken(csSNI);
			   Cache.Org.put('local.acetqa.calloutCheck', false);
               returnData.message = 'Token Expired and Record Locked';
               returnData.statusCode = 839;
		   }
	      }
        }
      }
     catch(Exception e){
      System.debug('Exception occured while quering the token'+e);
         returnData.message = 'Token Expired and Record Locked';
            returnData.statusCode = 839;
     }
     return returnData;
    }
    
    public static void getNewAccessToken(ISL_Webservice_Config__c csSNI){
        
        system.debug('getNewAccessToken-------------');
        ACETSNIApiOAuthWebservice OAuthWS = new ACETSNIApiOAuthWebservice();
        String OAuthaccesstoken = OAuthWS.getAccessToken();
        if(OAuthaccesstoken!= null && OAuthaccesstoken!=''){ 
             if(OAuthaccesstoken.contains('_expiry_')){
                  
                        string[] splitVal = OAuthaccesstoken.split('_expiry_');
                        system.debug('getNewAccessToken----------token---'+ splitVal[0]);
                        csSNI.Value__c = splitVal[0]; // SNI aceess token;
                        datetime dtim = datetime.now();
                        datetime dtim1 = dtim.addSeconds(integer.valueOf(splitVal[1]));
                        csSNI.TokenExpiry__c	 = integer.valueOf(splitVal[1]);
                        csSNI.TokenExpiredBy__c	 = dtim1;
                        update csSNI;
            }
            
        }
       
    }
    
    @AuraEnabled
    public static SearchResultWrapper findMembers(String memberId, String memberDOB,String firstName, String lastName, String groupNumber,String searchOption){

        //Below code commented for ITE-But required for SAe
        //ACETMemberSearchInteractionResult resultwrap = new ACETMemberSearchInteractionResult(); //Code Added By Chandan
        ACETLinkCoveragesResult resultwrap = new ACETLinkCoveragesResult();
        ACETLinkEligibilityWebService MemberProviderService = new ACETLinkEligibilityWebService(); //Code Added By Chandan
        ACETWSCalloutResult CalloutResult = null;
        System.debug('parameters....'+'member'+memberId+'memberdob'+memberDOB+'first'+firstName+'last'+lastName+'group'+groupNumber+'search'+searchOption);
        //Call the below method for SAE
        //CalloutResult = MemberProviderService.getMemberWS(memberId,memberDOB,firstName,lastName,groupNumber,searchOption,'87726','LOTSOFF','DAVID','1205807328');
        //For Ite I am changing the method -Chandan -Code need to be tuned
        CalloutResult = MemberProviderService.getMemberWS(memberId,memberDOB,firstName,lastName,groupNumber,searchOption);

        if (CalloutResult.Success){
            resultwrap= (ACETLinkCoveragesResult)CalloutResult.Response; //Code Added By Chandan
            system.debug('CalloutResult.Response');
            system.debug(CalloutResult.Response);
            System.debug('resultwrap.@@@ ' + resultwrap);
            /*   if(resultwrap.memberProviderResultlst != null){
createAccountContact(resultwrap.memberProviderResultlst[0].firstName,resultwrap.memberProviderResultlst[0].middleName,resultwrap.memberProviderResultlst[0].lastName,resultwrap.memberProviderResultlst[0].dob,resultwrap.subjectCard.memberId);
} */
        }
        /* Som has modified the code for coverage api */
        //CalloutResult = MemberProviderService.getHouseHoldMembers(resultwrap.transactionId);

        SearchResultWrapper dataWrap = new SearchResultWrapper();
        dataWrap.resultWrapper = resultwrap;
        dataWrap.message = CalloutResult.Message;
        dataWrap.statusCode = CalloutResult.statusCode;
        return dataWrap;

    }
    public static list<SelectOption> getPicklistValues(SObject obj, String fld){
        list<SelectOption> options = new list<SelectOption>();
        // Get the object type of the SObject.
        Schema.sObjectType objType = obj.getSObjectType();
        // Describe the SObject using its object type.
        Schema.DescribeSObjectResult objDescribe = objType.getDescribe();
        // Get a map of fields for the SObject
        map<String, Schema.SObjectField> fieldMap = objDescribe.fields.getMap();
        // Get the list of picklist values for this field.
        list<Schema.PicklistEntry> values =
            fieldMap.get(fld).getDescribe().getPickListValues();
        // Add these values to the selectoption list.
        for (Schema.PicklistEntry a : values)
        {
            options.add(new SelectOption(a.getLabel(), a.getValue()));
        }
        return options;
    }

    @AuraEnabled
    public static SearchResultWrapper getHouseHoldData(String transactionId){
        System.debug('transactionId@@@:'+transactionId);
        ACETLinkExtendedCoverageWebservice callWS = new ACETLinkExtendedCoverageWebservice();
        ACETHouseHoldWrapper resultwrap = new ACETHouseHoldWrapper();
        ACETWSCalloutResult CalloutResult = null;
        CalloutResult = callWS.getHouseHoldData(transactionId);

        if (CalloutResult.Success)
        {
            system.debug('CalloutResult');
            system.debug(CalloutResult);
            resultwrap = (ACETHouseHoldWrapper)CalloutResult.Response;
            System.debug('resultwrap.houseHoldList@@@ ' + resultwrap.houseHoldList);
        }
        else
        {
            //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Webservice Error'));
        }
        system.debug('>>>resultwrap------'+resultwrap);
        SearchResultWrapper dataWrap = new SearchResultWrapper();
        dataWrap.houseHoldResultWrapper = resultwrap;
        dataWrap.message = CalloutResult.Message;
        dataWrap.statusCode = CalloutResult.statusCode;
        system.debug('dataWrap....'+dataWrap.message+CalloutResult.Message);
        system.debug('dataWrap....'+dataWrap.message+CalloutResult.statusCode);
        system.debug('dataWrap....'+dataWrap.message+dataWrap.statusCode);
        system.debug('dataWrap....'+dataWrap.message+dataWrap.statusCode);
        return dataWrap;
    }
    public static List<ACETLinkMemberSearch.wrapperResponse> returnResponseData(AcetLinkEligibilityJSON2Apex.MemberPolicies pat){
        ACETLinkMemberSearch.wrapperResponse returnObj = new ACETLinkMemberSearch.wrapperResponse();
        List<ACETLinkMemberSearch.wrapperResponse> wrapperLst = new List<ACETLinkMemberSearch.wrapperResponse>();
        List<AcetLinkEligibilityJSON2Apex.PatientInfo> patInfoLst = null;
        if(pat.patientInfo != null){
            patInfoLst = pat.patientInfo;
            if(patInfoLst != null && patInfoLst.size() > 0){
                for(AcetLinkEligibilityJSON2Apex.PatientInfo patObj : patInfoLst){
                    returnObj.name = patObj.firstName + ' ' + patObj.middleName + ' '  + patObj.lastName;
                    returnObj.dob = patObj.dateOfBirth;
                    returnObj.relationship = patObj.relationship;
                    wrapperLst.add(returnObj);

                }
            }
        }
        return wrapperLst;
    }
    public class wrapperResponse{

        @AuraEnabled public String name{get;set;}
        @AuraEnabled public String dob{get;set;}
        @AuraEnabled public String relationship{get;set;}
    }

    @future
    public static void createAccountContact(String firstName, String middleName, String lastName, String dob, String memberId){
        Account acc = new Account();
        acc.name = firstName + ' ' + middleName + ' ' + lastName;
        acc.EID__c = memberId + dob;
        Database.upsert(acc, Account.Fields.EID__c);

        Contact con = new Contact();
        con.accountid = acc.Id;
        con.LastName = lastName;
        con.EID__c = memberId + dob;
        Database.upsert(con, Contact.Fields.EID__c);
    }

    /* added it to test from the static resource in case if we need it. */
    @AuraEnabled
    public Static String getMemberResponse(){
        String responseStr;
        StaticResource responseJSONSR = [SELECT Body FROM StaticResource WHERE Name = 'SAEMemberSearchResponseJSON'];
        responseStr = responseJSONSR.Body.toString();
        return responseStr;
    }
    public static String GetRequestFormatByName(String StaticResourceName)  {
        system.debug(LoggingLevel.INFO, 'StaticResourceName: ' + StaticResourceName);
        String RequestBodyFormat = '';
        StaticResource RequestJSONSR;
        if (!test.isRunningTest())  {
            RequestJSONSR = [SELECT Body FROM StaticResource WHERE Name =:StaticResourceName];
            RequestBodyFormat = RequestJSONSR.Body.toString();
        }
        system.debug(LoggingLevel.INFO, 'RequestBodyFormat: ' + RequestBodyFormat);
        return RequestBodyFormat;
    }

    public static String GetRequestBody(String StaticResourceName, List<String> RequestParameters)  {
        String RequestBodyFormat = GetRequestFormatByName(StaticResourceName);
        String RequestBody;
        if (!test.isRunningTest())  {
            RequestBody = String.format(RequestBodyFormat, RequestParameters).replaceAll('~', '{');
        }
        system.debug(LoggingLevel.INFO, 'RequestBody: ' + RequestBody);
        return RequestBody;
    }

    /*@AuraEnabled
    public static List<State__mdt> getStateValues() {
        List<State__mdt> stateList = [SELECT Id, DeveloperName, MasterLabel FROM State__mdt ORDER BY DeveloperName asc];
        return stateList;
    }*/
}