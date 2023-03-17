public class ACETURLEncryptionUtility {

     /** added by Pavan on 1/25/2017 for US495218 *****/
    public Static String getEncryptedConsumerDashURL(String userID , string memberId , String firstName , string lastName, String DOB, String groupNumber, String srk){
        //String tempBaseURL;
        String orginstance;
        String baseURL = String.valueof(URL.getSalesforceBaseUrl().toExternalForm().toLowerCase());
        system.debug('baseURL::'+baseURL);
        for(ACETOrgInstanceURLToOrgNameMap__c orgname:ACETOrgInstanceURLToOrgNameMap__c.getAll().values()) {
            
            if(baseURL.contains(orgname.Name)) {
                system.debug('tname '+orgname.name);
                orginstance = ACETOrgInstanceURLToOrgNameMap__c.getValues(orgname.name).Org_Name__c;
            }
        }
        if(orginstance != null)
        {
            system.debug('orginstance is '+orginstance);
            baseURL += getICUEURL(orginstance+'_ICUEConsumerDashboard');
            
        }
        
        /*tempBaseURL = 'cdbXrefId=780991&cdbXrefIdPartitionNumber=91&policy='+policynum;
        tempBaseURL = tempBaseURL + '&subscriberId='+memberId;
        tempBaseURL = tempBaseURL + '&firstName='+firstName;
        tempBaseURL = tempBaseURL + '&lastName='+lastName;
        tempBaseURL = tempBaseURL + '&functionId=Consumer_Dashboard&landingPage=consumerDashboard&applicationId=ACET';*/
        
        String tempBaseURL = 'subscriberId={0}&firstName={1}&lastName={2}&userId={3}&dateOfBirth={4}&groupNumber={5}&surrogateKey={6}&functionId=Consumer_Dashboard&landingPage=consumerDashboard&SAML_Subject=ACET&applicationId=ACET';
        system.debug('tempBaseURL '+tempBaseURL);
        List<String> fillers = new String[]{memberId,firstName,lastName,userID,DOB,groupNumber,srk};
        tempbaseURL = String.format(tempBaseURL, fillers);
        
        system.debug('tempBaseURL '+tempBaseURL);
        String Key = ACETWrapEncryptionKey__c.getValues(orginstance+'_ICUEEncryptionKey').Key__c;
        baseURL += GetEncryptedValue(Key,'AES256',tempBaseURL);
        system.debug('tempbaseULR '+baseURL);
        return baseURL;
    }
    
    /** added by Pavan on 2/1/2017 for US495218, US468672 and US495232 *****/
    public Static String getICUEURL(String getICUEURL){
        system.debug('getICUEURL is '+getICUEURL);
        ACETOrgNameToSwivelEndpointMap__c wrapURL = ACETOrgNameToSwivelEndpointMap__c.getValues(getICUEURL);
        system.debug('wrapURL is '+wrapURL);
        String icueURL = wrapURL.Swivel_Endpoint__c;
        return icueURL ;
        
    }
    
    /** added by Pavan on 2/1/2017 for US495218, US468672 and US495232 *****/
    public Static String GetEncryptedValue(String Key, String algorithmname, String baseurl){
        system.debug('Key: '+Key+'algorithmname: '+algorithmname+'baseurl: '+baseurl);
        String tempBaseURL;
        Blob data = Blob.valueOf(baseurl);
        Blob EncryptKey = Blob.valueOf(Key);
        Blob encryptedtempBaseURLData = Crypto.encryptWithManagedIV(algorithmname, EncryptKey , data);
        tempBaseURL = EncodingUtil.base64Encode(encryptedtempBaseURLData);
        system.debug('tempbaseULR'+tempBaseURL);
        return tempBaseURL;
    }
	
	    /* Added by Sai Kolluru on 07/03/2020 US2720275 */
      public Static String getEncryptedConsumerDashAPIURL(String tempBaseURL,String baseURL){
        String orginstance;
        system.debug('baseURL before encryption::'+baseURL);
        system.debug('tempBaseURL before encryption'+tempBaseURL);
        Map<String, ACETOrgInstanceURLToOrgNameMap__c> OrgInstance2OrgNameMap = ACETOrgInstanceURLToOrgNameMap__c.getAll();
        orginstance = Test.isRunningTest() ? 'dev' : ACETUtility.GetOrgName(OrgInstance2OrgNameMap);

        String Key = ACETWrapEncryptionKey__c.getValues(orginstance+'_ICUEEncryptionKey').Key__c;
        baseURL = baseURL+'?'+GetEncryptedValue(Key,'AES256',tempBaseURL);
        system.debug('tempbaseULR '+baseURL);
        return baseURL;
    }
    /* Added by Sindhu for US3745035 on 7/22/2021 */
    public Static String getEncryptedEZCommRecipientValue(String key, String algorithmname, String recipientJSON){
        system.debug('key: '+key+'algorithmname: '+algorithmname+'recipientJSON: '+recipientJSON);
        String encryptedRecipientValue;
        Blob data = Blob.valueOf(recipientJSON);
        Blob encryptKey = Blob.valueOf(Key);
        Blob encryptedRecipientData = Crypto.encryptWithManagedIV(algorithmname, encryptKey , data);
        encryptedRecipientValue = EncodingUtil.base64Encode(encryptedRecipientData);
        system.debug('encryptedRecipientValue'+encryptedRecipientValue);
        return EncodingUtil.urlEncode(encryptedRecipientValue, 'UTF-8');
    }
}