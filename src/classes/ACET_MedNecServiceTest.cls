@isTest
public class ACET_MedNecServiceTest {
    @testSetup static void setupCS(){
        Organization_Properties__c orgProps = Organization_Properties__c.getOrgDefaults();
        orgProps.OrganizationName__c = 'QA';
        Upsert orgProps;
        // Token API data
        WebserviceConfigurations__c tokenAPIWSConfig = ACET_WebserviceCalloutFramework_Test.createTokenWSConfigs('StarGateTokenAPI');
        OrgSpecificConfigurations__c tokenAPIOrgSpecificConfigs = ACET_WebserviceCalloutFramework_Test.createTokenOrgWSConfigs(tokenAPIWSConfig.Id);
        //WebserviceConfigurations__c authTokenWSConfig = ACET_WebserviceCalloutFramework_Test.createAuthTokenWSConfig('StarGateTokenAPI');
        
        // Service API data
        WebserviceConfigurations__c wsConfig = ACET_WebserviceCalloutFramework_Test.createWSConfig('MedNecService', tokenAPIWSConfig.Id);
        OrgSpecificConfigurations__c orgSpecificConfigs = ACET_WebserviceCalloutFramework_Test.createOrgWSConfigs(wsConfig.Id);
    }
    
    @isTest static void testMedNecService() {
        Cache.Session.put('local.TOPSProfileInfo.userToken','12312312', 28800, Cache.Visibility.ALL, true);
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new SAEHttpCalloutMock.ACET_MedNecService200());
        ACET_MedNecService.medNecInputParams re = new ACET_MedNecService.medNecInputParams();
        re.policy = '752713';
        re.memberId = 'S212313196';
        re.firstName = 'Jillian';
        re.relationship = 'EE';
        re.firstServiceDate = '2021-01-01';
        re.lastServiceDate = '2021-12-31';
        re.authorizationNumber = 'A123123';
        ACET_SAECalloutResult resp =  ACET_MedNecService.callMedNec(re);
        ACET_MedNecServiceResponse responseData = (ACET_MedNecServiceResponse) resp.response;
        Map<string,string> resMap = ACET_MedNecService.processMedResponse(responseData);
        List<String> lstOfValues =  ACET_MedNecService.processHoverValues(resMap);
        ACET_MedNecService.getMockToken();
        // MecdNec service Request
        string responseStr = ACET_MedNecService.getRequestBody(re);
        ACET_MedNecServiceRequest req = ACET_MedNecServiceRequest.parse(responseStr);
        SAEClaimSearchController.getUNETResult(re);
        Test.stopTest();
    }
    
    @istest
    static void testTOPSValidate() {
        Tops_Encryption_Mappings__c topsEncryption = new Tops_Encryption_Mappings__c(EBCDIC__c='B', Char_1__c='45', Char_2__c='38',
                                                                                     Char_3__c='64', Char_4__c='51', Char_5__c='64',
                                                                                     Char_6__c='51', Char_7__c='45', Char_8__c='38');
        Insert topsEncryption;
        
        ISL_Webservice_Config__c apiEndpointSetting = new ISL_Webservice_Config__c(Name='SNIAPIAccessToken',
                                                                                   Value__c='zwdsk9VPXJASohgqS2zqXD0UxD9MEa5g');
        Insert apiEndpointSetting;
        
        ISL_Webservice_Config__c daysRemaining = new ISL_Webservice_Config__c(Name='MVPTokenDaysPasswordExp',
                                                                              Value__c='1');
        Insert daysRemaining;
        
        ISL_Webservice_Config__c serviceSetting = new ISL_Webservice_Config__c(Name='dev_ORSEAIPToken',
                                                                               Value__c='zwdsk9VPXJASohgqS2zqXD0UxD9MEa5g');
        Insert serviceSetting;
        
        Per_User_Credentials__c userCredentialRec = new Per_User_Credentials__c(userName__c = 'test',
                                                                                Password__c='bbbbbbbb',
                                                                                user__c=userinfo.getUserId());
        Insert userCredentialRec;
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new SAEHttpCalloutMock.ACETLoginFlowUpdatePasswordMock());
        ACET_MedNecService.medNecInputParams re = new ACET_MedNecService.medNecInputParams();
        re.policy = '752713';
        re.memberId = 'S212313196';
        re.firstName = 'Jillian';
        re.relationship = 'EE';
        re.firstServiceDate = '2021-01-01';
        re.lastServiceDate = '2021-12-31';
        ACET_SAECalloutResult resp =  ACET_BenefitCheckController.getMedicalValues(re);
        Test.stopTest(); 
    }
}