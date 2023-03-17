/**
 * @description       : 
 * @author            : Nikhil Kanth
 * @group             : 
 * @last modified on  : 05-11-2021
 * @last modified by  : Nikhil Kanth
 * Modifications Log 
 * Ver   Date         Author         Modification
 * 1.0   05-11-2021   Nikhil Kanth   Initial Version
**/
@isTest
private class ACET_ClaimServiceRequestDetailCtrlTest {
    
    /**
    * @description test data
    * @author Nikhil Kanth | 05-11-2021 
    **/
    @testSetup
    static void testSetupMethod() {
        //Org Data
        Organization_Properties__c orgProps = Organization_Properties__c.getOrgDefaults();
        orgProps.OrganizationName__c = 'QA';
        Upsert orgProps;
        
        // Token API data
        WebserviceConfigurations__c tokenAPIWSConfig = ACET_WebserviceCalloutFramework_Test.createTokenWSConfigs('LinkTokenAPI');
        OrgSpecificConfigurations__c tokenAPIOrgSpecificConfigs = ACET_WebserviceCalloutFramework_Test.createTokenOrgWSConfigs(tokenAPIWSConfig.Id);
        
         // Service API data
        WebserviceConfigurations__c reconWsConfig = ACET_WebserviceCalloutFramework_Test.createWSConfig('LinkClaimRecon', tokenAPIWSConfig.Id);
        OrgSpecificConfigurations__c reconOrgSpecificConfigs = ACET_WebserviceCalloutFramework_Test.createOrgWSConfigs(reconWsConfig.Id);
        WebserviceConfigurations__c claAttachWsConfig = ACET_WebserviceCalloutFramework_Test.createWSConfig('LinkClaimAttachmentList', tokenAPIWSConfig.Id);
        OrgSpecificConfigurations__c claAttachOrgSpecificConfigs = ACET_WebserviceCalloutFramework_Test.createOrgWSConfigs(claAttachwsConfig.Id);
        WebserviceConfigurations__c doc360WsConfig = ACET_WebserviceCalloutFramework_Test.createWSConfig('DOC360GLobalURL', tokenAPIWSConfig.Id);
        //OrgSpecificConfigurations__c doc360OrgSpecificConfigs = ACET_WebserviceCalloutFramework_Test.createOrgWSConfigs(doc360WsConfig.Id);
        OrgSpecificConfigurations__c doc360OrgSpecificConfigs = new OrgSpecificConfigurations__c(
            WebserviceConfigurations__c = doc360WsConfig.Id,
            Name = 'QA',
            RecordTypeId = Schema.SObjectType.OrgSpecificConfigurations__c.getRecordTypeInfosByName().get('Service API').getRecordTypeId(),
            EndpointDomain__c = 'https://www.test.com',
            EnableLogs__c = 'All Logs',
            Static_Data__c = '{"user":"abc","appId":"abcd"}'
        );
        Insert doc360OrgSpecificConfigs;
    }
    
    /**
    * @description Testing claim recon service
    * @author Nikhil Kanth | 05-11-2021 
    **/
    @isTest
    static void getReconTicketDetailsTest() {
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new SAEHttpCalloutMock.SAEClaimReconWebServiceMock());
        ACET_ClaimServiceRequestDetailCtrl.getReconTicketDetails('123', '123');
        Test.stopTest();
    }
    
    /**
    * @description Testing claim attachment list and doc360 service
    * @author Nikhil Kanth | 05-11-2021 
    **/
    @isTest
    static void getClaimAttachmentRelatedTest() {
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new SAEHttpCalloutMock.SAEClaimAttachmentListWebServiceMock());
        ACET_ClaimServiceRequestDetailCtrl.getClaimAttachmentList('123', '123');
        ACET_ClaimServiceRequestDetailCtrl.getDoc360Url('123', '123', '123');
        Test.stopTest();
    }

}