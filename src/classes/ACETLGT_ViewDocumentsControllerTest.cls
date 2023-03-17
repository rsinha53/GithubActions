@isTest
private class ACETLGT_ViewDocumentsControllerTest{
    static testMethod void ACETLGT_ViewDocumentsControllertest1(){
        
        List<Document_Type_Search_By_Field__mdt> listSearchByFields = [SELECT Document_Type__r.WS_Field_Name__c, WS_MultiValue_Field__c, Document_Type_Field__r.WS_Field_Name__c FROM Document_Type_Search_By_Field__mdt];
        ACETLGT_ViewDocumentsController.initDocDatatable('sbc Doc','12345','123');
        Organization_Properties__c orgProps = Organization_Properties__c.getOrgDefaults();
        orgProps.OrganizationName__c = 'QA';
        Upsert orgProps;
        // Token API data
        WebserviceConfigurations__c starTokenAPIWSConfig = ACET_WebserviceCalloutFramework_Test.createTokenWSConfigs('StarGateTokenAPI');
        OrgSpecificConfigurations__c starTokenAPIOrgSpecificConfigs = ACET_WebserviceCalloutFramework_Test.createTokenOrgWSConfigs(starTokenAPIWSConfig.Id);
        starTokenAPIOrgSpecificConfigs.EnableErrorLog__c=true;
        update starTokenAPIOrgSpecificConfigs;
        
        // Service API data
        WebserviceConfigurations__c orswsConfig = ACET_WebserviceCalloutFramework_Test.createWSConfig('Doc360DocumentReprint', starTokenAPIWSConfig.Id);
        OrgSpecificConfigurations__c orsorgSpecificConfigs = ACET_WebserviceCalloutFramework_Test.createOrgWSConfigs(orswsConfig.Id);
        orsorgSpecificConfigs.EnableErrorLog__c=true;
        update orsorgSpecificConfigs;
        WebserviceConfigurations__c orswsConfig2 = ACET_WebserviceCalloutFramework_Test.createWSConfig('DOC360GLobalURL', starTokenAPIWSConfig.Id);
        OrgSpecificConfigurations__c orsorgSpecificConfigs2 = ACET_WebserviceCalloutFramework_Test.createOrgWSConfigs(orswsConfig2.Id);
        orsorgSpecificConfigs2.Static_Data__c='{"appId":"5949e3ae-1198-4b02-bc83-d63c7e4baa2c"}';
        update orsorgSpecificConfigs2;
        ACETLGT_ViewDocumentsController.getDoc360URL('test','u_enrl_ltr');
    }
}