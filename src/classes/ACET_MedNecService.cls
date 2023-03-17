public without sharing class ACET_MedNecService {
    
    public static ACET_SAECalloutResult getMedNecHoverValues(medNecInputParams input){
        system.debug('@inputRequest@'+input);
        ACET_SAECalloutResult finalResult = new ACET_SAECalloutResult();
        List<String> lstofValues = new List<string>();
        ACET_SAECalloutResult topsResult = getToken();
        finalResult = topsResult;
        //finalResult.response = lstofValues;
        if(topsResult.statusCode == 200  && string.isNotBlank(string.valueof(topsResult.response))){
            input.securityToken = string.valueof(topsResult.response);
            ACET_SAECalloutResult medNecResult = callMedNec(input);
            finalResult = medNecResult;
            if(medNecResult.statusCode == 200){
                ACET_MedNecServiceResponse responseData = (ACET_MedNecServiceResponse) medNecResult.response;
                Map<string,string> resMap = processMedResponse(responseData);
                lstofValues = processHoverValues(resMap);
                finalResult.response = lstofValues;
            }
            else{
                finalResult.response = lstofValues;
            }
        }
        else{
           finalResult.response = lstofValues;
        }
        return finalResult;
    }
    
    public static List<string> processHoverValues(Map<string,string> valueMap){
        List<String> lstofValues = new List<string>();
        if(valueMap != null && !valueMap.isEmpty()){
            if(valueMap.get('Medical Necessity Prior Auth') != NULL){
                lstofValues.add('Medical Necessity Prior Auth - ' + valueMap.get('Medical Necessity Prior Auth')); 
            }
            if(valueMap.get('Radiology Prior Auth') != NULL){
                lstofValues.add('Radiology Prior Auth - ' + valueMap.get('Radiology Prior Auth')); 
            }
            if(valueMap.get('Radiology Notification') != NULL){
                lstofValues.add('Radiology Notification - ' + valueMap.get('Radiology Notification')); 
            }
            if(valueMap.get('Cardiology Prior Auth') != NULL){
                lstofValues.add('Cardiology Prior Auth - ' + valueMap.get('Cardiology Prior Auth')); 
            }
            if(valueMap.get('Cardiology Notification') != NULL){
                lstofValues.add('Cardiology Notification - ' + valueMap.get('Cardiology Notification')); 
            }
            if(valueMap.get('Chemotherapy') != NULL){
                lstofValues.add('Chemotherapy - ' + valueMap.get('Chemotherapy')); 
            }
            if(valueMap.get('Genetic Testing Prior Auth') != NULL){
                lstofValues.add('Genetic Testing Prior Auth - ' + valueMap.get('Genetic Testing Prior Auth')); 
            }  
        }
        system.debug('@lstofValues@'+lstofValues);
        return lstofValues;
    }
    
    public static string getRequestBody(medNecInputParams input){
        ACET_MedNecServiceRequest pr = new ACET_MedNecServiceRequest();
        ACET_MedNecServiceRequest.searchInput sI = new ACET_MedNecServiceRequest.searchInput();
        sI.searchType = '3';
        sI.policy = input.policy;
        sI.memberId = input.memberId;
        sI.firstName = input.firstName;
        sI.relationship = input.relationship;
        sI.firstServiceDate = input.firstServiceDate;
        sI.lastServiceDate = input.lastServiceDate;
        //US3412835
        sI.authorizationNumber = '';
        if(string.isNotBlank(input.authorizationNumber)){
            sI.authorizationNumber = input.authorizationNumber;
            sI.searchType = '5';
        }
        sI.claimLevelCauseCode = string.isNotBlank(input.claimLevelCauseCode) ? input.claimLevelCauseCode : '';
        sI.cptCodeFrom = string.isNotBlank(input.cptCodeFrom) ? input.cptCodeFrom : '';
        sI.cptCodeThru = string.isNotBlank(input.cptCodeThru) ? input.cptCodeThru : '';
        sI.remarkCode = string.isNotBlank(input.remarkCode) ? input.remarkCode : '';
        sI.revenueCodeFrom = string.isNotBlank(input.revenueCodeFrom) ? input.revenueCodeFrom : '';
        sI.revenueCodeThru = string.isNotBlank(input.revenueCodeThru) ? input.revenueCodeThru : '';
        sI.appliedToOopInd = string.isNotBlank(input.appliedToOopInd) ? input.appliedToOopInd : '';
        //US3412835
        ACET_MedNecServiceRequest.searchInputMeta sIM= new ACET_MedNecServiceRequest.searchInputMeta();
        sIM.sourceSystem ='TOPS';
        ACET_MedNecServiceRequest.topsSystemParameter tops = new ACET_MedNecServiceRequest.topsSystemParameter();
        tops.securityToken = input.securityToken;
        sIM.topsSystemParameter = tops;
        sI.searchInputMeta = sIM;
        pr.searchInput =sI;
        string body = JSON.serialize(pr);
        return body;
    }
    
    public static ACET_SAECalloutResult callMedNec(medNecInputParams req){
        ACET_SAECalloutResult calloutResult = new ACET_SAECalloutResult();
        calloutResult.isSuccess = false;
        calloutResult.statusCode = 999;
        try{
            ACET_WebserviceCalloutFramework wsCallOut = new ACET_WebserviceCalloutFramework();
            wsCallOut.serviceName = 'MedNecService';
            wsCallOut.requestBody = getRequestBody(req);
            HttpResponse response = wscallout.getResponse();
            string responseStr = response.getBody();
            system.debug('@responseStr@'+responseStr);
            if(response.getStatusCode() == 200){
                if(responseStr != null && String.isNotBlank(responseStr)){
                    ACET_MedNecServiceResponse responseData = ACET_MedNecServiceResponse.parse(responseStr);
                    system.debug('@responseData@'+responseData);
                    calloutResult.isSuccess = true;
                    calloutResult.Message = 'Success';
                    calloutResult.statusCode = response.getStatusCode();
                    calloutResult.Response = responseData;  
                }
            }
            else{
                calloutResult.isSuccess = false;
                calloutResult.Message = response.getBody();
                calloutResult.statusCode = response.getStatusCode();
            }
            
        }
        catch(Exception e){
            system.debug('@excep@'+e.getMessage());
            calloutResult.Message = e.getMessage(); 
        }
        
        return calloutResult;
    }
    
    public static Map<String,string> processMedResponse(ACET_MedNecServiceResponse resp){
        Map<string,string> resMap = new Map<String,string>();
        resMap.put('Medical Necessity Prior Auth','No');
        resMap.put('Radiology Prior Auth','No');
        resMap.put('Cardiology Prior Auth','No');
        resMap.put('Chemotherapy','No');
        resMap.put('Genetic Testing Prior Auth','No');
        if(resp!= null && resp.searchResult != null && resp.searchResult.searchOutput != null){
            string currentValue = '';
            if(string.isNotBlank(resp.searchResult.searchOutput.priorAuthorizationIndicator)){
                currentValue = resp.searchResult.searchOutput.priorAuthorizationIndicator;
                if(currentValue == 'A') resMap.put('Medical Necessity Prior Auth','Yes');
            }
            if(string.isNotBlank(resp.searchResult.searchOutput.radiologyAuthorizationIndicator)){
                currentValue = resp.searchResult.searchOutput.radiologyAuthorizationIndicator;
                if(currentValue == 'A') resMap.put('Radiology Prior Auth','Yes');
                else if(currentValue == 'N') {resMap.put('Radiology Notification','Yes'); resMap.remove('Radiology Prior Auth');}
                else if(currentValue == 'E') resMap.put('Radiology Notification','No'); 
            }
            if(string.isNotBlank(resp.searchResult.searchOutput.cardiologyAuthorizationIndicator)){
                currentValue = resp.searchResult.searchOutput.cardiologyAuthorizationIndicator;
                if(currentValue == 'A') resMap.put('Cardiology Prior Auth','Yes');
                else if(currentValue == 'N') {resMap.put('Cardiology Notification','Yes'); resMap.remove('Cardiology Prior Auth');}
                else if(currentValue == 'E') resMap.put('Cardiology Notification','No'); 
            }
            if(string.isNotBlank(resp.searchResult.searchOutput.chemotherapyPriorAuthorizationIndicator)){
                currentValue = resp.searchResult.searchOutput.chemotherapyPriorAuthorizationIndicator;
                if(currentValue == 'A') resMap.put('Chemotherapy','Yes');
            }
            if(string.isNotBlank(resp.searchResult.searchOutput.geneticTestingPriorAuthorizationIndicator)){
                currentValue = resp.searchResult.searchOutput.geneticTestingPriorAuthorizationIndicator;
                if(currentValue == 'A') resMap.put('Genetic Testing Prior Auth','Yes');
            }
        }
        system.debug('@resMap@'+resMap);
        return resMap;
    }
    
    public static ACET_SAECalloutResult getMockToken(){
        ACET_SAECalloutResult calloutResult = new ACET_SAECalloutResult();
        calloutResult.isSuccess = true;
        calloutResult.Message = 'Success';
        calloutResult.statusCode = 200;
        Map < String, ISL_Webservice_Config__c > islWebserviceData = ISL_Webservice_Config__c.getAll();
        string tName= 'LoginFlowMockSecurityToken';
        String token = islWebserviceData.get(tName) != NULL ? (islWebserviceData.get(tName).Is_Available__c ?
             (string.isBlank(islWebserviceData.get(tName).Value__c) ? '' : islWebserviceData.get(tName).Value__c ) : 'F:B7F3E0' ) : 'F:B7F3E0';
        calloutResult.Response = token;
        return calloutResult;
    }
    
    public static ACET_SAECalloutResult getToken(){
        ACET_SAECalloutResult calloutResult = new ACET_SAECalloutResult();
        Boolean isStaticResponseChecked = false;
        isStaticResponseChecked = SAEUtils.getMockStatus();
        if(isStaticResponseChecked && !Test.isRunningTest()) {
            calloutResult = getMockToken();
        }
        else{
            calloutResult = getRealToken();
        }
        return calloutResult;
    }
    
    public static ACET_SAECalloutResult getRealToken(){
        ACET_SAECalloutResult calloutResult = new ACET_SAECalloutResult();
        String strToken= null;
        try{
            /*HttpResponse response = new HttpResponse();
            string responseBody = null;
            List < Per_User_Credentials__c > userList =  [SELECT Id, UserName__c, Password__c FROM Per_User_Credentials__c WHERE User__c =: UserInfo.getUserId()];
            if(userList != null && !userList.isEmpty()){
                ACET_LoginFlowCtrl lfCtrl = new ACET_LoginFlowCtrl();
                response = lfCtrl.getTOPSResponse(userList[0].UserName__c, userList[0].Password__c);
                responseBody = response.getBody();
                System.debug('@responseBody:' + response.getBody());
                System.debug('@StatusCode:' + response.getStatusCode());
                ACET_PerUserCredentialResultWrapper loginData;
                if (String.isNotBlank(responseBody)) {
                    loginData = ACET_PerUserCredentialResultWrapper.parse(responseBody);
                }
                if(response.getStatusCode() == 200){
                    if (responseBody != null && responseBody.containsIgnoreCase('userProfile')) {
                        if(loginData.PostResult.userTokens != null && !loginData.PostResult.userTokens.isEmpty()){
                            for (ACET_PerUserCredentialResultWrapper.userTokens tokenData: loginData.PostResult.userTokens) {
                                if(string.isNotBlank(tokenData.userToken)){
                                    strToken = tokenData.userToken;
                                    break;
                                }
                            }  
                        }
                    }
                    calloutResult.isSuccess = true;
                    calloutResult.Message = 'Success';
                    calloutResult.statusCode = response.getStatusCode();
                    calloutResult.Response = strToken; 
                }
                else{
                    calloutResult.isSuccess = false;
                    calloutResult.Message = 'Failed';
                    calloutResult.statusCode = response.getStatusCode();
                    calloutResult.Response = response.getBody();
                }*/
            //get userToken
            String userToken = (String) Cache.Session.get('local.TOPSProfileInfo.userToken');
            if (String.isBlank(userToken)) {
                ACET_LoginFlowCtrl loginflow = new ACET_LoginFlowCtrl();
                loginflow.validateTopsCredentials();
                userToken = (String) Cache.Session.get('local.TOPSProfileInfo.userToken');
                }
            if (String.isNotBlank(userToken)) {
                calloutResult.isSuccess = true;
                calloutResult.Message = 'Success';
                calloutResult.statusCode = 200;
                calloutResult.Response = userToken;
            }
            else{
                calloutResult.isSuccess = false;
                calloutResult.Message = 'Secuirty token is Blank';
                calloutResult.statusCode = 999;
                calloutResult.Response = 'Secuiry token is Blank';
            }

        }
        catch(Exception e){
            System.debug('@exception:' + e.getMessage());
            calloutResult.isSuccess = false;
            calloutResult.Message = e.getMessage();
            calloutResult.statusCode = 999;
        }
        return calloutResult;
    }
    
    public class medNecInputParams{
        @AuraEnabled public string securityToken {get;set;}
        @AuraEnabled public string policy {get;set;}
        @AuraEnabled public string memberId {get;set;}
        @AuraEnabled public string firstName {get;set;}
        @AuraEnabled public string relationship {get;set;}
        @AuraEnabled public string firstServiceDate {get;set;}
        @AuraEnabled public string lastServiceDate {get;set;}
        @AuraEnabled public string authorizationNumber {get;set;}
        @AuraEnabled public string claimLevelCauseCode {get;set;}
        @AuraEnabled public string cptCodeFrom {get;set;}
        @AuraEnabled public string cptCodeThru{get;set;}
        @AuraEnabled public string remarkCode{get;set;}
        @AuraEnabled public string revenueCodeFrom{get;set;}
        @AuraEnabled public string revenueCodeThru{get;set;}
        @AuraEnabled public string appliedToOopInd{get;set;}
    }
}