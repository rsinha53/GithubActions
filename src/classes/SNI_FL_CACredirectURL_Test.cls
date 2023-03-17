@isTest
public class SNI_FL_CACredirectURL_Test {
    @isTest
    public static void getCustMetaData(){
        FeatureFlagConfig__mdt fetConf = [select Id,MasterLabel,isEnabled__c from FeatureFlagConfig__mdt where MasterLabel = 'OpenHSIDurls'];
        SNI_FL_CACredirectURL.getCustMetaData();
    }
   
}