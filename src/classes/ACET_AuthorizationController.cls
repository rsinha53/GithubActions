/*
 * @Desc: US2154799 - Controller class for Authorization related callouts  
 * @Date: 23-12-2019
 * @Dev: Malinda
 */
public class ACET_AuthorizationController {
    public static String orginstance;

@AuraEnabled
public static SearchResultWrapper findAuthorizations(ACET_FindAuthorizationWebservice.FindAuthRequest requestObject) {
        System.debug(Logginglevel.INFO, '### FIND-AUTH-REQUEST');
        System.debug(Logginglevel.INFO, '### FIND-AUTH-REQUEST-OBJECT:' + requestObject);
        ACETWSCalloutResult returnObject = new ACET_FindAuthorizationWebservice().findAuth(requestObject);
        SearchResultWrapper wrapper = new SearchResultWrapper();
        wrapper.resultWrapper = (ACET_AuthorizationResult) returnObject.Response;
        wrapper.message = returnObject.Message;
        wrapper.statusCode = returnObject.statusCode; 
        System.debug(Logginglevel.INFO, '### FIND-AUTH-CTRL-RETURN:'+wrapper);
        return wrapper;

    }

    // US2154803 - View Authrizations and Notifications - Inpatient Details Integration
    // This methohd will return the Authorization Status Details
    @AuraEnabled
    public static SearchResultWrapperAuthStatus getAuthorizationStatus(ACET_GetAuthorizationStatusDetails.AuthDetailsRequest requestObject) {
        ACETWSCalloutResult returnObject = new ACET_GetAuthorizationStatusDetails().readAuth(requestObject);
        SearchResultWrapperAuthStatus wrapper = new SearchResultWrapperAuthStatus();
        wrapper.resultWrapper = (ACET_AuthorizationStatusResponse) returnObject.Response;
        wrapper.message = returnObject.Message;
        wrapper.statusCode = returnObject.statusCode; 
        return wrapper;
    }

    public class SearchResultWrapper{
        @AuraEnabled public ACET_AuthorizationResult resultWrapper {get;set;}
        @AuraEnabled public string message {get;set;}
        @AuraEnabled public integer statusCode {get;set;}
    }

    public class SearchResultWrapperAuthStatus{
        @AuraEnabled public ACET_AuthorizationStatusResponse resultWrapper {get;set;}
        @AuraEnabled public string message {get;set;}
        @AuraEnabled public integer statusCode {get;set;}
    }
    
    
    public static String getBaseURL(){
        String baseURL;
        baseURL = String.valueof(URL.getSalesforceBaseUrl().toExternalForm());
        system.debug('baseURL@@@ '+baseURL);
        for(ACETOrgInstanceURLToOrgNameMap__c orgname:ACETOrgInstanceURLToOrgNameMap__c.getAll().values()) {
            
            if(baseURL.containsIgnoreCase(orgname.Name)) {
                system.debug('tname '+orgname.name);
                orginstance = ACETOrgInstanceURLToOrgNameMap__c.getValues(orgname.name).Org_Name__c;
            }
        }
        orginstance = Test.isRunningTest() ? 'qa' : orginstance;
        if(orginstance != null){
            system.debug('orginstance is '+orginstance);
            baseURL += ACETURLEncryptionUtility.getICUEURL(orginstance+'_ICUECreateAuthorization');
        }
        return baseURL;
    }
    
    
    @AuraEnabled
    public static String GenerateICUEURL(String MemberId, String firstName, String lastName, String contactName, String policyNumber, String originatorType) {
        String baseURL;
        baseURL = getBaseURL();
        User usr = [select FederationIdentifier from user where id=:userinfo.getUserId()];
        String tempBaseURL = 'subscriberId={0}&firstName={1}&lastName={2}&userId={3}&contactName={4}&groupNumber={5}&functionId=Initiate_Hsc_Intake&landingPage=initiateHSCIntake&applicationId=ACET';
        if(originatorType == 'Member')
        {
            List<String> fillers = new String[]{MemberId,firstName,lastName, usr.FederationIdentifier, contactName,policyNumber};
                tempbaseURL = String.format(tempBaseURL, fillers);            
        }
        
        String orginstance;
        for(ACETOrgInstanceURLToOrgNameMap__c orgname:ACETOrgInstanceURLToOrgNameMap__c.getAll().values()) {
            if(baseURL.containsIgnoreCase(orgname.Name)) {
                orginstance = ACETOrgInstanceURLToOrgNameMap__c.getValues(orgname.name).Org_Name__c;
            }
        }
        if(orginstance != null){
            baseURL += ACETURLEncryptionUtility.GetEncryptedValue(ACETWrapEncryptionKey__c.getValues(orginstance+'_ICUEEncryptionKey').Key__c,'AES256',tempbaseURL);
        }
        return baseURL;
    }

    //US2079907 - Added by Avish
    @AuraEnabled
    public static String editICUEURL(String srnNumber,String originatorType){
        String baseURL;
        baseURL = getBaseURL();
        User usr = [select FederationIdentifier from user where id=:userinfo.getUserId()];
        system.debug('usr '+usr);
        String tempBaseURL = 'userId={0}&functionId=Initiate_Hsc_Intake&landingPage=initiateHSCIntake&applicationId=ACET&primaryServiceReferenceNum={1}';
        if(originatorType == 'Member')
        {            
            
            List<String> fillers = new String[]{usr.FederationIdentifier,srnNumber};
                tempbaseURL = String.format(tempBaseURL, fillers);            
        }
        
        String orginstance;
        for(ACETOrgInstanceURLToOrgNameMap__c orgname:ACETOrgInstanceURLToOrgNameMap__c.getAll().values()) {
            system.debug('orgname.name is '+orgname.Name);
            if(baseURL.containsIgnoreCase(orgname.Name)) {
                system.debug('tname '+orgname.name);
                orginstance = ACETOrgInstanceURLToOrgNameMap__c.getValues(orgname.name).Org_Name__c;
            }
        }
        if(orginstance != null){ 
            System.debug('ICUEEncryptionKey-->'+ACETWrapEncryptionKey__c.getValues(orginstance+'_ICUEEncryptionKey').Key__c);
            baseURL += ACETURLEncryptionUtility.GetEncryptedValue(ACETWrapEncryptionKey__c.getValues(orginstance+'_ICUEEncryptionKey').Key__c,'AES256',tempbaseURL);
        }
        return baseURL;
    }    
}