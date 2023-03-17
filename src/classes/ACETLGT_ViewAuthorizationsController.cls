public with sharing class ACETLGT_ViewAuthorizationsController extends ACETErrorHandler{
    public class custException extends Exception {}
    
    public class SearchResultWrapper{
        @AuraEnabled public List<ACETLGT_AuthorizationSearchResult> resultWrapper {get;set;}
        @AuraEnabled public String ErrorMessage {get;set;}
    }
    public class getAuthbyTypeWrapper{
        @AuraEnabled public List<ACETLGT_AuthorizationSearchResult> inpatientWrapper{get;set;}
        @AuraEnabled public List<ACETLGT_AuthorizationSearchResult> outpatientWrapper{get;set;}
        @AuraEnabled public List<ACETLGT_AuthorizationSearchResult> outpatientfacilityWrapper{get;set;}
        
    }
    @AuraEnabled
    public static getAuthbyTypeWrapper getAuthorizationsByType(List<ACETLGT_AuthorizationSearchResult> allAuths, String authType) {
        system.debug('+++++Auths'+allAuths);
        system.debug('+++++AuthType'+authType);
        
        List<ACETLGT_AuthorizationSearchResult> resultwrap = new List<ACETLGT_AuthorizationSearchResult>(); 
        //ACETLGT_AuthorizationSearchResult wrapitem = new ACETLGT_AuthorizationSearchResult();
        getAuthbyTypeWrapper wrap = new getAuthbyTypeWrapper();
        wrap.inpatientWrapper = new List<ACETLGT_AuthorizationSearchResult>();
        wrap.outpatientWrapper = new List<ACETLGT_AuthorizationSearchResult>();
        wrap.outpatientfacilityWrapper = new List<ACETLGT_AuthorizationSearchResult>();
        
        if(allAuths.size()>0){
            for(ACETLGT_AuthorizationSearchResult asr:allAuths){
                //ACETLGT_AuthorizationSearchResult wrapitem = new ACETLGT_AuthorizationSearchResult();
                system.debug('Looping Auths');
                if(authType == asr.Case_Type_Desc && authType != 'All' || authType=='All'){
                    
                    if(asr.Case_Type_Desc == 'Inpatient'){
                        wrap.inpatientWrapper.add(asr);
                        system.debug('inpatients');
                
                    }
                    if(asr.Case_Type_Desc == 'Outpatient'){
                        wrap.outpatientWrapper.add(asr);
                        system.debug('outpatients');
                
                    }
                    if(asr.Case_Type_Desc == 'Outpatient Facility'){
                        wrap.outpatientfacilityWrapper.add(asr);
                        system.debug('outpatientFacility');
                
                    }
                }
            }
            
        }
        
        return  wrap;
    }
    @AuraEnabled
    public static SearchResultWrapper findAuthorizations(String srk, String DOB, String FirstName, String LastName, String StartDate, String EndDate) {
        SearchResultWrapper detWrap = new SearchResultWrapper();
        try{
        List<ACETLGT_AuthorizationSearchResult> resultwrap = new List<ACETLGT_AuthorizationSearchResult>(); 
        
        ACETLGT_FindAuthorizationWebservice ACTFAWS = new ACETLGT_FindAuthorizationWebservice();
        system.debug('--->controller request elements '+srk+firstname+lastname+dob+startdate+enddate);
        
        ACETWSCalloutResult oACETWSCalloutResult=ACTFAWS.FindAuthorizations(srk, DOB, FirstName, LastName,  StartDate,  EndDate,'',null);    
        
        if (oACETWSCalloutResult != null && oACETWSCalloutResult.Success)
        {   
            resultwrap= (list<ACETLGT_AuthorizationSearchResult>)oACETWSCalloutResult.Response;
                system.debug('>>>resultwrap findAuths------'+resultwrap);
                detWrap.resultWrapper = resultwrap;
				detWrap.ErrorMessage ='';
                return detWrap;
        } 
        else
        {
                detWrap.resultWrapper = new List<ACETLGT_AuthorizationSearchResult>();
		if(oACETWSCalloutResult.statusCode == 400)
	            	detWrap.ErrorMessage = setLightningErrorMsg('GN400B'); 
	            else
	            	detWrap.ErrorMessage = setLightningErrorMsg('GN'+oACETWSCalloutResult.statusCode );

                return detWrap;
        }           
        } catch(Exception ex) {
        
            detWrap.resultWrapper = new List<ACETLGT_AuthorizationSearchResult>();
            detWrap.ErrorMessage = setLightningErrorMsg('MGD997');
			return detWrap;
        }
    }

    
    @AuraEnabled
    public static String GenerateICUEURL(String MemberId, String firstName, String lastName, String contactName,String originatorType, String groupNumber) {
        system.debug(groupNumber+'====groupNumber');
        String baseURL;
        baseURL = String.valueof(URL.getSalesforceBaseUrl().toExternalForm());
        String orginstance ;
        for(ACETOrgInstanceURLToOrgNameMap__c orgname:ACETOrgInstanceURLToOrgNameMap__c.getAll().values()) {
            if(baseURL.toLowerCase().contains(orgname.Name)) {
                system.debug('tname '+orgname.name);
                orginstance = ACETOrgInstanceURLToOrgNameMap__c.getValues(orgname.name).Org_Name__c;
            }
        }
        if(orginstance != null){
            system.debug('orginstance is '+orginstance);
            baseURL += ACETURLEncryptionUtility.getICUEURL(orginstance+'_ICUECreateAuthorization');
        }
        
        User usr = [select FederationIdentifier from user where id=:userinfo.getUserId()];
        String tempBaseURL = 'subscriberId={0}&firstName={1}&lastName={2}&userId={3}&contactName={4}&groupNumber={5}&functionId=Initiate_Hsc_Intake&landingPage=initiateHSCIntake&applicationId=ACET';
        if(originatorType == 'Member')
        {
            //List<String> fillers = new String[]{MemberId,varContact.FirstName,varcontact.LastName, usr.FederationIdentifier, wrapper.interaction.Originator_Name__c};
            List<String> fillers = new String[]{MemberId,firstName,lastName, usr.FederationIdentifier, contactName,groupNumber};
                tempbaseURL = String.format(tempBaseURL, fillers);
            
        }
        /*else 
{
List<String> fillers = new String[]{MemberId,varContact.FirstName,varcontact.LastName, usr.FederationIdentifier, wrapper.AdditionalInfo.contactName};
tempbaseURL = String.format(tempBaseURL, fillers);

}*/
        System.debug('tempbaseURL-->'+tempBaseURL);
        baseURL += ACETURLEncryptionUtility.GetEncryptedValue(ACETWrapEncryptionKey__c.getValues(orginstance+'_ICUEEncryptionKey').Key__c,'AES256',tempbaseURL);
        System.debug('baseURL-->'+baseURL);
        
        return baseURL;
    }
    @AuraEnabled
    public static String buttonAccess(String userRole) {
        String allowedUser = 'false';
        
        List<Call_Topic_Access__c> accesses = (List<Call_Topic_Access__c>)ACETQueryUtil.query(null,'Call_Topic_Access__c', null, null);
        
        //system.debug('inside AUth access'+accesses.size());
        for(Call_Topic_Access__c acc : accesses){
            if(acc.Call_Topic__c == 'Create Authorization'){
                String roles = acc.Limit_To_Roles__c;
                system.debug('$$$$roles'+roles);
                if(roles.contains(';'))
                {
                    system.debug('$$$$multipleroles'+roles);
                    List<String> rolesList = new List<String>(roles.split(';'));
                    for(String role : rolesList){
                        if(role == userRole){
                            allowedUser = 'true';
                        }
                        system.debug('$$$$$$$'+ role + ' roles ' + userRole);
                    }
                }
                else if(String.isNotBlank(roles) && roles.containsNone(';') && roles == userRole)
                {
                    allowedUser = 'true';
                }
                
            }
            system.debug('$$$$$$$'+ acc.Call_Topic__c + 'roles ' + acc.Limit_To_Roles__c);
            
            
        } 
        return allowedUser;
    }
    
}