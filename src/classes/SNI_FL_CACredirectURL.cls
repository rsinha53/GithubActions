public class SNI_FL_CACredirectURL {
    
   /* @AuraEnabled
    public static Boolean showHSIDurl(String featureName){
    	return FeatureFlagService.isFeatureEnabledAura(featureName);
    } */
   @AuraEnabled
    public static Boolean getCustMetaData(){
        FeatureFlagConfig__mdt fetConf = [select Id,MasterLabel,isEnabled__c from FeatureFlagConfig__mdt where MasterLabel = 'OpenHSIDurls' LIMIT 1];
        system.debug(fetConf);
        return fetConf.isEnabled__c;
    }
}