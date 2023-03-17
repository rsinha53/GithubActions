@isTest
global class ACET_BenefitDetailsControllerTest {
	@testSetup static void setup() {
        List<Benefit_Configuration__c> testData = new List<Benefit_Configuration__c>();
        testData.add(new Benefit_Configuration__c(Benefit_Code_Type__c = 'HIPAA',Benefit_Grouping_Type__c = 'Benefit Code',Benefit_Code_Description_UI__c = 'Benefit Configuration'));
        insert testData;        
        Organization_Properties__c orgProps = Organization_Properties__c.getOrgDefaults();
        orgProps.OrganizationName__c = 'QA';
        Upsert orgProps;
        // Token API data
        WebserviceConfigurations__c tokenAPIWSConfig = ACET_WebserviceCalloutFramework_Test.createTokenWSConfigs('StarGateTokenAPI');
        OrgSpecificConfigurations__c tokenAPIOrgSpecificConfigs = ACET_WebserviceCalloutFramework_Test.createTokenOrgWSConfigs(tokenAPIWSConfig.Id);
        // Service API data
        WebserviceConfigurations__c wsConfig = ACET_WebserviceCalloutFramework_Test.createWSConfig('ADBLoyaltyEndpoint', tokenAPIWSConfig.Id);
        OrgSpecificConfigurations__c orgSpecificConfigs = ACET_WebserviceCalloutFramework_Test.createOrgWSConfigs(wsConfig.Id);
    }
    
    static testMethod void test_fetchLookUpValues() {
        Test.startTest();
        List<Benefit_Configuration__c> testTopics = new List<Benefit_Configuration__c>();
        testTopics.add(new Benefit_Configuration__c(Benefit_Code_Type__c = 'HIPAA',Benefit_Grouping_Type__c = 'Benefit Code',Benefit_Code_Description_UI__c = 'Benefit Configuration Test'));
        insert testTopics;
        
        List < Benefit_Configuration__c > returnList = ACET_BenefitDetailsController.fetchBenefitCodes('','Benefit_Configuration__c',testTopics);
        System.assertEquals(returnList[0].Benefit_Code_Description_UI__c,'Benefit Configuration');
        Test.stopTest();
    }    
    static testMethod void test_getNonTherapy(){
        ACET_BenefitDetailsController.NonTherapyRequest request = new  ACET_BenefitDetailsController.NonTherapyRequest();
        request.policyNumber = '1234';
        request.subscriberId = '12345';
        request.dependentNumber = '00';
        request.planYearStartDate = '1/1/2021';
       //Inserting custom setting
        ACET_TestDataFactory.createWebServiceSetting('SNIAPIAccessToken', 'zwdsk9VPXJASohgqS2zqXD0UxD9MEa5g');
        ACET_TestDataFactory.createWebServiceSetting('dev_ORSEAIPToken', 'zwdsk9VPXJASohgqS2zqXD0UxD9MEa5g');
        //TOPS Encryption
        Tops_Encryption_Mappings__c topsEncryption = new Tops_Encryption_Mappings__c(EBCDIC__c='B', Char_1__c='0C', Char_2__c='37', 
                                                                                     Char_3__c='18', Char_4__c='17', Char_5__c='1C', 
                                                                                     Char_6__c='51', Char_7__c='45', Char_8__c='38');
        Insert topsEncryption;
        Test.setMock(HttpCalloutMock.class, new SAEHttpCalloutMock.ACET_NonTherapyResponse_200());
        // Testing  positive case
        Test.startTest();
        ACET_BenefitDetailsController.getNonTherapy(request, 'CS');
        ACET_BenefitDetailsController.getNonTherapy(request, 'AP');
        // Empty Response block
        Test.setMock(HttpCalloutMock.class, new SAEHttpCalloutMock.ACET_NonTherapyEmptyResponse_200());
        ACET_BenefitDetailsController.getNonTherapy(request, 'CS');
        // Exception Block
        request=null;
        ACET_BenefitDetailsController.getNonTherapy(request, 'CS');
        Test.stopTest();
    }
}