/*
    Created By: Avish Pagote
    Created Date: 27th March 2019
    Description: Class used to call from Lightning Component for making member search callout.
*/

public class SAEProviderSearch extends ACETWebservice {
    public override void getEndpoint(){
        GetEndpointDetail('SAEProviderSearchEndpoint');       
    }    
    
/*    @AuraEnabled
    public static String findMembers(String memberId){
        system.debug(Logginglevel.INFO,'Calling findMembers...');
        String reqMethod='GET';
        String responseStr,requestStr;
        HttpResponse res;
        List<Object> resultsList;
        Map<String,Object> respMap;
        String endPoint = ISL_Webservice_Config__c.getInstance('SAE_ProviderSearch').Value__c;
        if(memberId == '77777777'){
            StaticResource responseJSONSR = [SELECT Body FROM StaticResource WHERE Name = 'SAEProviderSearchResponseJSON'];
            responseStr = responseJSONSR.Body.toString();
        }else{
            List<String> reqParaLst = new List<String>{'NameDateOfBirth','Name','Last','87726','ProviderLastName','ProviderFirstName','NPI','19500128'};
            requestStr = GetRequestBody('SAEProviderSearchRequest',reqParaLst);
            res = SAEWebservice.makeCallout(requestStr,endPoint,reqMethod);
            responseStr = res.getBody();
        }

        return responseStr;
    } */
    
    public class SearchResultWrapper{
        @AuraEnabled public SAEProviderMemberSearchInteractionResult resultWrapper {get;set;}
        @AuraEnabled public string message {get;set;}
        @AuraEnabled public integer statusCode {get;set;}
    }
    
     //Method to dynamically formed the Query String
    public static String formQueryString(List<String> strLst){
        String resultQuery = '?';
        resultQuery += 'searchOption=' + strLst[0] + '&firstName='+strLst[1] + '&lastName='+strLst[2] + '&payerID=' + strLst[3] + '&providerLastName=' + strLst[4] + '&providerFirstName=' + strLst[5] + '&npi=' + strLst[6] + '&dateOfBirth=' + strLst[7] + '&groupNumber=' + strLst[8] + '&memberId='+strLst[9];
        return resultQuery;
    }

    @AuraEnabled(cacheable=true) 
    public static SearchResultWrapper searchMembers(String memberDetails){
        MemberDetails md = (SAEProviderSearch.MemberDetails) System.JSON.deserialize(memberDetails, SAEProviderSearch.MemberDetails.class);
        System.debug('@@ SAEProviderSearch: md: ' + md);
        SAEProviderMemberSearchInteractionResult resultwrap = new SAEProviderMemberSearchInteractionResult();                 
        SAEMemberProviderWS MemberProviderService = new SAEMemberProviderWS();
        SAEMemberStandaloneSearchWebService findIndividualWS = new SAEMemberStandaloneSearchWebService();
        ACETWSCalloutResult CalloutResult = null;
        if(String.isNotBlank(md.memberId) && !String.isNotBlank(md.memberDOB) && !String.isNotBlank(md.firstName) && !String.isNotBlank(md.lastName) &&
           !String.isNotBlank(md.groupNumber)){
               system.debug('findIndividual');
               CalloutResult = findIndividualWS.findIndividual(md.memberId);
               system.debug('CalloutResult>>> ' + CalloutResult);
               if (CalloutResult.Success != null && CalloutResult.Success){
                   resultwrap= (SAEProviderMemberSearchInteractionResult)CalloutResult.Response;
                   System.debug('resultwrap.memberProviderResultlst@@@ ' + resultwrap.lstSAEMemberStandaloneSearch);
                   System.debug('resultwrap ' + resultwrap);
               }
        }else{
            //CalloutResult = MemberProviderService.getMemberWS(md.memberId,md.memberDOB,md.firstName,md.lastName,md.groupNumber,md.searchOption,'87726','LOTSOFF','DAVID','1205807328');
            CalloutResult = MemberProviderService.getMemberWS(md.memberId,md.memberDOB,md.firstName,md.lastName,md.groupNumber,md.searchOption,md.payerID,md.providerLastName,md.providerFirstName,md.npi,md.providerFlow);
            if (CalloutResult.Success){   
                resultwrap= (SAEProviderMemberSearchInteractionResult)CalloutResult.Response;
                System.debug('resultwrap.memberProviderResultlst@@@ ' + resultwrap.memberProviderResultlst);
                System.debug('resultwrap.@@@ ' + resultwrap);
            } 
        }
        System.debug('>>>resultwrap------'+resultwrap); 
        SearchResultWrapper dataWrap = new SearchResultWrapper();
        dataWrap.resultWrapper = resultwrap;
        dataWrap.message = CalloutResult.Message;
        dataWrap.statusCode = CalloutResult.statusCode;
        System.debug('dataWrap ->' + JSON.serialize(dataWrap));
        return dataWrap;
    }
	
	@AuraEnabled(cacheable=true) 
    // String payerID - US1944108
    public static SearchResultWrapper findMembers(String memberId, String memberDOB,String firstName, String lastName, String groupNumber,String searchOption, String payerID,
                                                    String providerFN, String providerLN, String providerNPI, String providerFlow){
    
        SAEProviderMemberSearchInteractionResult resultwrap = new SAEProviderMemberSearchInteractionResult();                 
        SAEMemberProviderWS MemberProviderService = new SAEMemberProviderWS();
        SAEMemberStandaloneSearchWebService findIndividualWS = new SAEMemberStandaloneSearchWebService();
        ACETWSCalloutResult CalloutResult = null;
        if(String.isNotBlank(memberId) && !String.isNotBlank(memberDOB) && !String.isNotBlank(firstName) && !String.isNotBlank(lastName) &&
           !String.isNotBlank(groupNumber)){
               system.debug('findIndividual');
               CalloutResult = findIndividualWS.findIndividual(memberId);
               system.debug('CalloutResult>>> ' + CalloutResult);
               if (CalloutResult.Success != null && CalloutResult.Success){
                   resultwrap= (SAEProviderMemberSearchInteractionResult)CalloutResult.Response;
                   System.debug('resultwrap.memberProviderResultlst@@@ ' + resultwrap.lstSAEMemberStandaloneSearch);
                   System.debug('resultwrap ' + resultwrap);
               }
           }else{
               //payerID - US1944108
               CalloutResult = MemberProviderService.getMemberWS(memberId,memberDOB,firstName,lastName,groupNumber,searchOption, payerID, providerLN, providerFN, providerNPI, providerFlow);
               if (CalloutResult.Success != null && CalloutResult.Success){   
                   resultwrap= (SAEProviderMemberSearchInteractionResult)CalloutResult.Response;
                   System.debug('resultwrap.memberProviderResultlst@@@ ' + resultwrap.memberProviderResultlst);
                   System.debug('resultwrap.@@@ ' + resultwrap);
               }
           }
        system.debug('>>>resultwrap------'+resultwrap); 
        
        SearchResultWrapper dataWrap = new SearchResultWrapper();
        dataWrap.resultWrapper = resultwrap;
        dataWrap.message = CalloutResult.Message;
        dataWrap.statusCode = CalloutResult.statusCode;
        return dataWrap;
        
    }
   

    public class MemberDetails {
        @AuraEnabled public string memberId {get;set;}
        @AuraEnabled public string memberDOB {get;set;}
        @AuraEnabled public string firstName {get;set;}
        @AuraEnabled public string lastName {get;set;}
        @AuraEnabled public string groupNumber {get;set;}
        @AuraEnabled public string searchOption {get;set;}
        @AuraEnabled public string payerID {get;set;}
        @AuraEnabled public string providerLastName {get;set;}
        @AuraEnabled public string providerFirstName {get;set;}
        @AuraEnabled public string npi {get;set;}
        @AuraEnabled public String providerFlow {get;set;}
    }
    
    @testVisible // Thanish - Oct 8th 2019
    private static List<SAEProviderSearch.wrapperResponse> returnResponseData(SAEEligibilityResponseJSON2Apex.MemberPolicies pat){
        SAEProviderSearch.wrapperResponse returnObj = new SAEProviderSearch.wrapperResponse();
        List<SAEProviderSearch.wrapperResponse> wrapperLst = new List<SAEProviderSearch.wrapperResponse>();
        List<SAEEligibilityResponseJSON2Apex.PatientInfo> patInfoLst = null;
        if(pat.patientInfo != null){
            patInfoLst = pat.patientInfo;
            if(patInfoLst != null && patInfoLst.size() > 0){
                for(SAEEligibilityResponseJSON2Apex.PatientInfo patObj : patInfoLst){
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
    @AuraEnabled
    public static List<State__mdt> getStateValues() {
        List<State__mdt> stateList = [SELECT Id, DeveloperName, MasterLabel FROM State__mdt ORDER BY DeveloperName asc];
        return stateList;
    }
    
    //US2076634 - HIPAA Guidelines Button - Sravan
    @AuraEnabled
    public static String getHippaGuideLinesUrl(){
       String endPoint = SAEUtils.getHippaGuideLinesUrl();
        return endPoint;
    }


}