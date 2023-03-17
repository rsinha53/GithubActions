public class ACETLGT_PharmacyInquiryController {

    @AuraEnabled
    public static String getCSRFURL() {
        String sandboxName = ACETUtility.GetOrgName();
        return ACETUtility.GetSwivelEndpointByOrgName(sandboxName, 'CSRF');
    }
    
    //  US2552389 : Added by Madhura to Generate ISET URL
    //  Added by Madhura to get ISET URL from ISETWrap
    @AuraEnabled
    public static String getISETURL(String memberId, String groupNember, String srk, String memberGender,
                                   String memberFirstName, String memberLastName, String memberDOB,
                                   String SSBCarrierId) {
        String ISETURL = '';                

        system.debug(LoggingLevel.INFO, 'memberId: ' + memberId + ', memberFirstName: ' + memberFirstName + ', memberLastName: ' + memberLastName + ', memberDOB: ' + memberDOB + ', memberGender: ' + memberGender + ', groupNember: ' + groupNember + ', srk: ' + srk);
        String OrgInstanceURL = String.valueof(URL.getSalesforceBaseUrl().toExternalForm()); 
        String OrgName = ACETUtility.GetOrgName();     
        ACETOrgNameToSwivelEndpointMap__c ISETWrapURLMap = new ACETOrgNameToSwivelEndpointMap__c();        
        ISETWrapURLMap =  ACETOrgNameToSwivelEndpointMap__c.getValues(OrgName + '_ISETWrap');
    
        String ISETWrapURL = ISETWrapURLMap.Swivel_Endpoint__c;
        ACETWrapEncryptionKey__c ACETWrapEncryptionKey = ACETWrapEncryptionKey__c.getValues(OrgName + '_ISETEncryptionKey');
        String EncryptionKey = ACETWrapEncryptionKey.Key__c;
        String AlgorithmName = ACETWrapEncryptionKey.Algorithm_Name__c;
        
        Integer AppSourceIndex = ISETWrapURL.indexOf('applicationSource=');
        String ISETQSTemplate = ISETWrapURL.right(ISETWrapURL.length() - AppSourceIndex);
        ISETWrapURL = ISETWrapURL.remove(ISETQSTemplate);
        
        if(SSBCarrierId != null &&  SSBCarrierId.isNumeric()){
            SSBCarrierId = 'UHC00'+(Integer.valueOf(SSBCarrierId)<10?'0'+SSBCarrierId:SSBCarrierId)+'XX';
        } else {
             SSBCarrierId ='';
         }

        String ISETQS = String.format(ISETQSTemplate, new List<String>{memberId, memberFirstName, memberLastName, memberDOB, memberGender, SSBCarrierId});
        String ISETQSEncrypted = ACETURLEncryptionUtility.GetEncryptedValue(EncryptionKey, AlgorithmName, ISETQS);
        system.debug(LoggingLevel.INFO, 'before encrypt: ' + ISETQS + ', after encrypt: ' + ISETQSEncrypted);
        
        ISETURL = OrgInstanceURL + ISETWrapURL + EncodingUtil.urlEncode(ISETQSEncrypted, 'UTF-8');
        system.debug('full url finalized '+ISETURL);

        return ISETURL;
    }
    
    //  US2552389 : To get Carrier Id
    @AuraEnabled
    public static String getCarrierId(String surrogateKey, String bundleId, String enrollerSRK, String startDate, 
                        String endDate, String coverageTypes, String groupNumber, String accumAsOf, String SitusState,String customerPurchaseId) {
        String carrierId='';
                            
         ACETLGT_NimbusGetSSBAPI getPlanBenefitService = new ACETLGT_NimbusGetSSBAPI();
         ACETWSCalloutResult CalloutResult = getPlanBenefitService.getSubscriptionBenefitSearch(bundleId,enrollerSRK,surrogateKey,startDate, 
            endDate, coverageTypes,groupNumber,accumAsOf,SitusState,customerPurchaseId);
         ACETGroupPlanBenefitLEXWrapper planInfoWrapper = (ACETGroupPlanBenefitLEXWrapper)CalloutResult.response;
         if(planInfoWrapper != null && planInfoWrapper.carId !=null) {
             for(String carId : planInfoWrapper.carId)
                 carrierId = carId;
         }
         system.debug('::Carrier ID'+carrierId);               
        return carrierId;
    }

    @AuraEnabled 
    public static user getProfileUser(){
     //query current user information  
      User oUser = [select id,Name,Agent_Type__c,Profile_Name__c,Role_Name__c FROM User Where id =: userInfo.getUserId()];
        system.debug('oUser:: '+oUser);
        return oUser;
    }
}