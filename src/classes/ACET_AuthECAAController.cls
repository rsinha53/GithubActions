public class ACET_AuthECAAController{
    
    public class ECAAResultWrapper{
        @AuraEnabled public ACET_ECAALetterResult resultWrapper {get;set;}
        @AuraEnabled public string message {get;set;}
        @AuraEnabled public integer statusCode {get;set;}
    }
    
    @AuraEnabled
    public static ECAAResultWrapper findECAA(String srnNumber){
        ACET_ECAALetterWS ecaaLetterWS = new ACET_ECAALetterWS();
        ACETWSCalloutResult CalloutResult = null;
        ECAAResultWrapper dataWrap = new ECAAResultWrapper();
        ACET_ECAALetterResult responseResult = new ACET_ECAALetterResult();
        if(String.isNotBlank(srnNumber)){
            CalloutResult = ecaaLetterWS.findECAALetter(srnNumber); 
            responseResult = (ACET_ECAALetterResult)CalloutResult.Response;
        }

        dataWrap.resultWrapper = responseResult;
        dataWrap.message = CalloutResult.Message;
        dataWrap.statusCode = CalloutResult.statusCode;

        return dataWrap;
    }
    
    @AuraEnabled
    public static Object getEDMSLink(){
        String returnURL;
        
        String baseURL = String.valueof(URL.getSalesforceBaseUrl().toExternalForm());
        system.debug('baseURL@@ '+baseURL);
        String orginstance,OrgSDBName;
        for(ACETOrgInstanceURLToOrgNameMap__c orgname:ACETOrgInstanceURLToOrgNameMap__c.getAll().values()) {
            system.debug('tname '+orgname.name);
            if(baseURL.containsIgnoreCase(orgname.Name)) {
                OrgSDBName = orgname.Name;
                system.debug('tname '+orgname.name);
                orginstance = ACETOrgInstanceURLToOrgNameMap__c.getValues(orgname.name).Org_Name__c;
            }
        }
        system.debug('orginstance@@ '+orginstance);
        if(String.isNotBlank(orginstance)){
            Map<String, ISL_Webservice_Config__c> WSConfigurations = ISL_Webservice_Config__c.getAll();
            returnURL = WSConfigurations.get(orginstance + '_EDMSEndpoint').Value__c;
            
            system.debug('returnURL@@ '+returnURL);
            //blob params = blob.valueOf(returnURL);
            //String base64params = EncodingUtil.base64Encode(params);
            ACET_AuthECAAController.EDMSWrapper wrapper = new ACET_AuthECAAController.EDMSWrapper();
            wrapper.endPointURL = returnURL;
            
            //return  JSON.serialize(wrapper);
            return wrapper;
        }
        
		return null;
    }
    
    public class EDMSWrapper{
        @AuraEnabled public String endPointURL {get;set;}
    }
    
}