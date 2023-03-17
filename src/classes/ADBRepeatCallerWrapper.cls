/*
 * Description : Used to capture required response elements from Repeat Caller response
 * Created : 2/10/2021
 * Created By : Madhura Priyadarshana
 */
public without sharing class ADBRepeatCallerWrapper {
    public GateResult gateResult;
    public class RepeatCaller{
        public Integer count;
        public String description;
    }
    
    public class ResponseObject{public RepeatCaller repeatCaller;}
    public class GateResult{
        public ResponseObject responseObject;
        public String responseMessage;
        public Integer responseCode;
    }
    
    @AuraEnabled public string Z_Request;
    @AuraEnabled public string Z_ENT_ContactFirstNm;
    @AuraEnabled public string Z_ENT_ContactLastNm;
    @AuraEnabled public string Z_ENT_ContactConstituentID;
    @AuraEnabled public string Z_ENT_ContactDOB;
}