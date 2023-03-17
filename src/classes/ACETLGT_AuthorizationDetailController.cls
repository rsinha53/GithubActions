public class ACETLGT_AuthorizationDetailController extends ACETErrorHandler {
    public class custException extends Exception {}
    
    public class DetailResultWrapper{
        @AuraEnabled public ACETLGT_AuthorizationDetailResult resultWrapper {get;set;}
        @AuraEnabled public List<ACETLGT_AuthorizationSearchResult> searchResultWrapper {get;set;}
        @AuraEnabled public String ErrorMessage {get;set;}
    }
    @AuraEnabled 
    public static DetailResultWrapper getAuthorizations(String AuthId, String srk,String authType, String jsonString) {
        DetailResultWrapper detWrap = new DetailResultWrapper();
        try {
            ACETLGT_AuthorizationDetailResult resultwrap = new ACETLGT_AuthorizationDetailResult(); 
            List<ACETLGT_AuthorizationSearchResult> resultwrapp = new List<ACETLGT_AuthorizationSearchResult>(); 
            
            ACETLGT_GetAuthorizationWebservice ACTFAWS = new ACETLGT_GetAuthorizationWebservice();
            system.debug('--->controller request elements '+AuthId+srk);
            
            ACETWSCalloutResult oACETWSCalloutResult=ACTFAWS.GetAuthorizationDetail(AuthId, srk);    
            if (oACETWSCalloutResult.Success)
            {   
                resultwrap= (ACETLGT_AuthorizationDetailResult)oACETWSCalloutResult.Response;
                system.debug('>>>resultwrap findAuths------'+resultwrap);
                resultwrapp = getAuthorizationSel(authType,jsonString);
                
                detWrap.resultWrapper = resultwrap;
                detWrap.searchResultWrapper = resultwrapp;
                return detWrap;
            } 
            else
            {
                detWrap.resultWrapper = new ACETLGT_AuthorizationDetailResult();
                detWrap.searchResultWrapper = new List<ACETLGT_AuthorizationSearchResult>();
                detWrap.ErrorMessage = setLightningErrorMsg('GN500');
                
                return detWrap;
            }           
            
        } catch(Exception e) {
            detWrap.resultWrapper = new ACETLGT_AuthorizationDetailResult();
            detWrap.searchResultWrapper = new List<ACETLGT_AuthorizationSearchResult>();
            detWrap.ErrorMessage = setLightningErrorMsg('MGD997');
            return detWrap;
        }
    }
    
    
    public static List<ACETLGT_AuthorizationSearchResult> getAuthorizationSel(String authType, String jsonString){
        List<ACETLGT_AuthorizationSearchResult> returnAuthorizations = new List<ACETLGT_AuthorizationSearchResult>();
        ACETLGT_AuthorizationSearchResult objAcetAuthrizationResult = new ACETLGT_AuthorizationSearchResult();
        system.debug('authType' +authType);
        jsonString.replace('null','');  
        jsonString = EncodingUtil.urlDecode(jsonString, 'UTF-8');
        
        if(authType == 'Inpatient' && String.isNotBlank(jsonString)){
            system.debug('Selected --> Inpatient');
            list<string> lstAuthDetail = jsonString.split('_');
            system.debug('?'+lstAuthDetail);
            objAcetAuthrizationResult.Authorization_Number = !string.isEmpty(lstAuthDetail[0])?lstAuthDetail[0]:'';
            objAcetAuthrizationResult.Case_Status  = !string.isEmpty(lstAuthDetail[1])?lstAuthDetail[1]:'';
            objAcetAuthrizationResult.Pre_Determination = !string.isEmpty(lstAuthDetail[2])?lstAuthDetail[2]:'';
            objAcetAuthrizationResult.Create_Date = !string.isEmpty(lstAuthDetail[3])?formatDate(lstAuthDetail[3]):'';
            objAcetAuthrizationResult.Expected_Admit_Date = !string.isEmpty(lstAuthDetail[4])?formatDate(lstAuthDetail[4]):'';
            objAcetAuthrizationResult.Actual_Admit_Date = !string.isEmpty(lstAuthDetail[5])?formatDate(lstAuthDetail[5]):'';
            objAcetAuthrizationResult.Expected_Dscharg_Date = !string.isEmpty(lstAuthDetail[6])?formatDate(lstAuthDetail[6]):'';
            objAcetAuthrizationResult.Actual_Dscharg_Date = !string.isEmpty(lstAuthDetail[7])?formatDate(lstAuthDetail[7]):'';
            
            objAcetAuthrizationResult.Facility_Status = !string.isEmpty(lstAuthDetail[8])?lstAuthDetail[8]:'';
            objAcetAuthrizationResult.Primary_Diagnosis = !string.isEmpty(lstAuthDetail[9])?lstAuthDetail[9]:'';
            objAcetAuthrizationResult.POS =  !string.isEmpty(lstAuthDetail[10])?lstAuthDetail[10]:'';
            objAcetAuthrizationResult.ServiceDescDetail = !string.isEmpty(lstAuthDetail[11])?lstAuthDetail[11]:'';
            objAcetAuthrizationResult.LOS = !string.isEmpty(lstAuthDetail[12])?lstAuthDetail[12]:'';
            system.debug('objAcetAuthrizationResult inpatient'+objAcetAuthrizationResult);
            
        }else  if(authType == 'Outpatient'  && String.isNotBlank(jsonString)){
            system.debug('Selected --> Outpatient');
            list<string> lstAuthDetail = jsonString.split('_');
            system.debug('??'+lstAuthDetail);
            objAcetAuthrizationResult.Authorization_Number = !string.isEmpty(lstAuthDetail[0])?lstAuthDetail[0]:'';
            objAcetAuthrizationResult.Case_Status  = !string.isEmpty(lstAuthDetail[1])?lstAuthDetail[1]:'';
            objAcetAuthrizationResult.Pre_Determination = !string.isEmpty(lstAuthDetail[2])?lstAuthDetail[2]:'';
            objAcetAuthrizationResult.Create_Date = !string.isEmpty(lstAuthDetail[3])?formatDate(lstAuthDetail[3]):'';
            objAcetAuthrizationResult.Start_Date = !string.isEmpty(lstAuthDetail[4])?formatDate(lstAuthDetail[4]):'';
            objAcetAuthrizationResult.End_Date = !string.isEmpty(lstAuthDetail[5])?formatDate(lstAuthDetail[5]):'';
            objAcetAuthrizationResult.ServiceProviderStatus = !string.isEmpty(lstAuthDetail[6])?lstAuthDetail[6]:'';
            objAcetAuthrizationResult.Primary_Diagnosis = !string.isEmpty(lstAuthDetail[7])?lstAuthDetail[7]:'';
            objAcetAuthrizationResult.Procedure_Code = !string.isEmpty(lstAuthDetail[8])?lstAuthDetail[8]:'';
            objAcetAuthrizationResult.Count = !string.isEmpty(lstAuthDetail[9])?lstAuthDetail[9]:'';
            objAcetAuthrizationResult.POS = !string.isEmpty(lstAuthDetail[10])?lstAuthDetail[10]:'';
            objAcetAuthrizationResult.ServiceDescDetail = !string.isEmpty(lstAuthDetail[11])?lstAuthDetail[11]:'';
            system.debug('objAcetAuthrizationResult outpatient'+objAcetAuthrizationResult);
            
            
        }else  if(authType == 'Outpatient Facility'  && String.isNotBlank(jsonString)){
            system.debug('Selected --> Outpatient Facility');
            list<string> lstAuthDetail = jsonString.split('_');
            system.debug('???'+lstAuthDetail);
            objAcetAuthrizationResult.Authorization_Number = !string.isEmpty(lstAuthDetail[0])?lstAuthDetail[0]:'';
            objAcetAuthrizationResult.Case_Status  = !string.isEmpty(lstAuthDetail[1])?lstAuthDetail[1]:'';
            objAcetAuthrizationResult.Pre_Determination = !string.isEmpty(lstAuthDetail[2])?lstAuthDetail[2]:'';
            
            objAcetAuthrizationResult.ServiceProvider = !string.isEmpty(lstAuthDetail[3])?lstAuthDetail[3]:'';
            objAcetAuthrizationResult.Primary_Diagnosis = !string.isEmpty(lstAuthDetail[4])?lstAuthDetail[4]:'';
            objAcetAuthrizationResult.Procedure_Code = !string.isEmpty(lstAuthDetail[5])?lstAuthDetail[5]:'';
            objAcetAuthrizationResult.POS = !string.isEmpty(lstAuthDetail[6])?lstAuthDetail[6]:'';
            objAcetAuthrizationResult.ServiceDescDetail = !string.isEmpty(lstAuthDetail[7])?lstAuthDetail[7]:'';
            system.debug('objAcetAuthrizationResult facility'+objAcetAuthrizationResult);
            
        }
        returnAuthorizations.add(objAcetAuthrizationResult);
        return returnAuthorizations;
    }
    
    public static String formatDate(string dateString){
        if(dateString == 'null'){
            dateString='';
        }else if(dateString.contains('/')){
            dateString =  dateString.split('/')[0].removeStart('0')+'/'+dateString.split('/')[1].removeStart('0')+'/'+dateString.split('/')[2];
        }
        
        return dateString;
    }
    
     @AuraEnabled
    public static String GenerateICUEURL(String AuthorizationNumber) {
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
        String tempBaseURL = 'userId={0}&functionId=Initiate_Hsc_Intake&landingPage=initiateHSCIntake&applicationId=ACET&primaryServiceReferenceNum={1}';
        List<String> fillers = new String[]{usr.FederationIdentifier, AuthorizationNumber };
        tempbaseURL = String.format(tempBaseURL, fillers);
        
        System.debug('tempbaseURL-->'+tempBaseURL);
        baseURL += ACETURLEncryptionUtility.GetEncryptedValue(ACETWrapEncryptionKey__c.getValues(orginstance+'_ICUEEncryptionKey').Key__c,'AES256',tempbaseURL);   
        return baseURL;
    }
    
}