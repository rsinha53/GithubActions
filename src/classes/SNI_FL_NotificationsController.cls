public without sharing class SNI_FL_NotificationsController {
    // Added for US3050209 and US3050486
    public static String memberUserTermsOfUse = 'First time Login popup design';
    public static String memberUserPrivacyPolicy = 'Family Link Privacy Policy';
    public static String providerUserTermsOfUse = 'First time Login popup design for Provider User';
    public static String providerUserPrivacyPolicy = 'Family Link Privacy Policy for Provider User';
    // End
    
    @AuraEnabled
    public static String getFirstTimePopupData(String contentType){
        String design = '';
        // Added for US3050209 and US3050486
        Id profileId = UserInfo.getProfileId();
        String profileName = [SELECT Id,Name FROM Profile Where Id =:profileId].Name;
        if(profileName == label.Family_Link_Provider_User){
            if(contentType == memberUserTermsOfUse){
               contentType=providerUserTermsOfUse; 
            }else if(contentType == memberUserPrivacyPolicy){
               contentType=providerUserPrivacyPolicy; 
            }
            
        }
        // End
        List<SNI_FL_Utility__c> popupDataLst = [ select id,SNI_FL_Design__c from SNI_FL_Utility__c where name =: contentType];
        if(popupDataLst != null && ! popupDataLst.isEmpty() && popupDataLst[0].SNI_FL_Design__c != null){
            design = popupDataLst[0].SNI_FL_Design__c;
        }
        return design;
    }
}