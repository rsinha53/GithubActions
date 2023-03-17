/**
* Author: Hasara Disanayaka
* Description : Controller class for external links
* AuraEnabled : True
* Date Created: 07/15/2020
*/

public without sharing class ADBSpendingAccountsController {
    @AuraEnabled
    public static String getCAMSUrlStatic (){
        ACETOrgNameToSwivelEndpointMap__c  url = [Select name,Swivel_Endpoint__c
                                                  from ACETOrgNameToSwivelEndpointMap__c
                                                  where name='ADBCAMSUrl'];
        String camsUrl = String.valueOf(url.Swivel_Endpoint__c);
        System.debug(camsUrl);
        return camsUrl;
    }
    @AuraEnabled
    public static String getCAMSUrl (String memberId){
        // Uncomment memberId on line 12 for testing in QA201 if needed
        // memberId = '28017408';
        String orgName = ACETUtility.GetOrgName();
        ACETOrgNameToSwivelEndpointMap__c camsWrapMap = new ACETOrgNameToSwivelEndpointMap__c();
        camsWrapMap =  ACETOrgNameToSwivelEndpointMap__c.getValues(orgName + '_CAMSWrapURL');
        String camsWrapURL = camsWrapMap.Swivel_Endpoint__c;
        ACETWrapEncryptionKey__c ACETWrapEncryptionKey = ACETWrapEncryptionKey__c.getValues(orgName + '_CAMSEncryptionKey');
        String encryptionKey = ACETWrapEncryptionKey.Key__c;
        String algorithmName = ACETWrapEncryptionKey.Algorithm_Name__c;
        system.debug(LoggingLevel.INFO, 'camsWrapURL: ' + camsWrapURL + ', EncryptionKey: ' + encryptionKey);
        String memberIdEncrypted = ACETURLEncryptionUtility.GetEncryptedValue(encryptionKey, algorithmName, memberId);
        String memberIdEncoded =  EncodingUtil.urlEncode (memberIdEncrypted, 'UTF-8');
        String finalURL = camsWrapURL +memberIdEncoded;
        system.debug('FINAL URL'+finalURL);
        return finalURL;
    }
    /* This method is to fetch Financials - all Spending account card information */
    @AuraEnabled
    public static Map<String,Object> fetchFinancialOverviews(String memberId, String fName, String lName, String planNumber, String birthdate,boolean hsaaccess,String ssn){
        System.debug('spending memberId : ' + memberId);
        System.debug('spending fName : ' + fName);
        System.debug('spending lName : ' + lName);
        System.debug('spending planNumber : ' + planNumber);
        System.debug('spending birthdate : ' + birthdate);
        //	converting the birthdate into the way it's expected in the financial web service
        String convertedBirthdate = '';
        if(String.isNotBlank(birthdate)) {
            List<String> bDayArr = birthdate.split('/');
            if(bDayArr != null && bDayArr.size() == 3) {
                convertedBirthdate = bDayArr[2] + '-' + bDayArr[0] + '-' + bDayArr[1];
            }
        }
        System.debug('spending convertedBirthdate : ' + convertedBirthdate);
        Map<String,Object> reswrapper = ADBFinancialOverViewWebService.getFinancialOverview(memberId, fName, lName, planNumber, convertedBirthdate,hsaaccess,ssn);
        system.debug('response wrapper '+reswrapper);
        return reswrapper;
    } 
    // Call Security access API: US2923041 - sunil vennam
    @AuraEnabled
    public static Boolean fetchUserDetails(String userId){
        Boolean userAccessCheck = false;
        // Pending - where should be the group name stored 
        String groupName = '';
        List<ADBUserSecurityAccessEndpoint__mdt> securityapiConfigs;
        Map<String, ACETOrgInstanceURLToOrgNameMap__c> OrgInstance2OrgNameMap = ACETOrgInstanceURLToOrgNameMap__c.getAll();
        String OrgName = ACETUtility.GetOrgName(OrgInstance2OrgNameMap);
        String serviceName = 'ADBUserSecurityAccessAPIDetails';
        String masterLabel = orgName + '_' + serviceName; 
        if(!Test.isRunningTest()){
            securityapiConfigs = [SELECT Id, GroupName__c  FROM ADBUserSecurityAccessEndpoint__mdt WHERE MasterLabel =: masterLabel];
            groupName = securityapiConfigs[0].GroupName__c;
        }
        List<String> userAccessresponse = ADBFinancialOverViewWebService.getUserAccessDetails(userId);
        system.debug('userAccessCheck imp imp'+userAccessresponse);
        if(userAccessresponse!=null){
            for(String user : userAccessresponse){
                System.debug('user ' + user);
                if(user == groupName){
                    userAccessCheck = true;
                }
            }
        }       
        return userAccessCheck;
    }
}