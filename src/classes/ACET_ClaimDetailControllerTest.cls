@isTest
public class ACET_ClaimDetailControllerTest {
    @testSetup static void setupCS(){
        Organization_Properties__c orgProps = Organization_Properties__c.getOrgDefaults();
        orgProps.OrganizationName__c = 'slayerdev';
        Upsert orgProps;
        List<WebserviceConfigurations__c> webConRelatedDocumentsList = new List<WebserviceConfigurations__c>();
        WebserviceConfigurations__c  webConRelatedDocuments = new WebserviceConfigurations__c ();
        webConRelatedDocuments.GrantType__c  = 'client_credentials';
        webConRelatedDocuments.Headers__c  = '[{"key":"Authorization","value":"Bearer <:AUTH_TOKEN:>"},{"key":"Content-Type","value":"application/json"},{"key":"actor","value":"ACET"}]';
        webConRelatedDocuments.Method__c  = 'GET';
        webConRelatedDocuments.Name  = 'LinkClaimDetail';
        webConRelatedDocuments.Timeout__c = 10000;
        RecordType recTypeWebExtendedServiceAPI = [SELECT Id FROM RecordType WHERE DeveloperName = 'Service_API' and SObjectType = 'WebserviceConfigurations__c'];
        webConRelatedDocuments.RecordTypeId  = recTypeWebExtendedServiceAPI.id;
        webConRelatedDocumentsList.add(webConRelatedDocuments);
        
        insert webConRelatedDocumentsList;
        
        OrgSpecificConfigurations__c orgConfig = new OrgSpecificConfigurations__c();
        orgConfig.Name = 'slayerdev';
        orgConfig.WebserviceConfigurations__c = webConRelatedDocuments.id;
        orgConfig.EnableMock__c = true;
        orgConfig.EndpointDomain__c='https://api-gateway-stage.linkhealth.com/clink-api/api/claim/summary/v1.0';
        orgConfig.RecordTypeText__c  = 'ServiceAPI'; 
        insert orgConfig;
        
        List<Mock_Response_Details__c> mockResponseRecList = new List<Mock_Response_Details__c>();
        Mock_Response_Details__c mockResponseRec=new Mock_Response_Details__c();
        mockResponseRec.Status_Code__c='200';
        mockResponseRec.FileName__c='claimDetail_7863109999';
        mockResponseRec.SearchParameter__c='claimDetail_7863109999';
        mockResponseRec.WebserviceConfigurations__c = webConRelatedDocuments.id;
        mockResponseRecList.add(mockResponseRec);
        
        Mock_Response_Details__c mockResponseRec2=new Mock_Response_Details__c();
        mockResponseRec2.Status_Code__c='200';
        mockResponseRec2.FileName__c='claimDetail_7777777111';
        mockResponseRec2.SearchParameter__c='claimDetail_7777777111';
        mockResponseRec2.WebserviceConfigurations__c = webConRelatedDocuments.id;
        mockResponseRecList.add(mockResponseRec2);
        
        Mock_Response_Details__c mockResponseRec1=new Mock_Response_Details__c();
        mockResponseRec1.Status_Code__c='200';
        mockResponseRec1.FileName__c='claimDetail_18A9022531124';
        mockResponseRec1.SearchParameter__c='claimDetail_18A9022531124';
        mockResponseRec1.WebserviceConfigurations__c = webConRelatedDocuments.id;
        mockResponseRecList.add(mockResponseRec1);

        Mock_Response_Details__c mockResponseRec3=new Mock_Response_Details__c();
        mockResponseRec3.Status_Code__c='200';
        mockResponseRec3.FileName__c='claimDetail_7777777112';
        mockResponseRec3.SearchParameter__c='claimDetail_7777777112';
        mockResponseRec3.WebserviceConfigurations__c = webConRelatedDocuments.id;
        mockResponseRecList.add(mockResponseRec3);

        insert mockResponseRecList;
        
        Cache.Org.put('local.WebserviceFramework.LinkServiceTokenAPIToken', 'Test123');
        datetime dtimeExp = datetime.now();
        datetime dtimeExpiry = dtimeExp.addSeconds(200);
        string dtimeExpiryStr = string.valueof(dtimeExpiry);
        Cache.Org.put('local.WebserviceFramework.LinkServiceTokenAPITokenExpiry', dtimeExpiryStr);

        // US3368942 - Thanish - 21st May 2021
        // Token API data
        WebserviceConfigurations__c tokenAPIWSConfig = ACET_WebserviceCalloutFramework_Test.createTokenWSConfigs('StarGateTokenAPI');
        OrgSpecificConfigurations__c tokenAPIOrgSpecificConfigs = ACET_WebserviceCalloutFramework_Test.createTokenOrgWSConfigs(tokenAPIWSConfig.Id);
        // Service API data
        WebserviceConfigurations__c wsConfig = ACET_WebserviceCalloutFramework_Test.createWSConfig('ADBLoyaltyEndpoint', tokenAPIWSConfig.Id);
        OrgSpecificConfigurations__c orgSpecificConfigs = ACET_WebserviceCalloutFramework_Test.createOrgWSConfigs(wsConfig.Id);
    }
    
    static testMethod void test_SAEEligibilityClaimDetailsJSON2Apex(){
        SAEEligibilityClaimDetailsJSON2Apex jsonToApex = new SAEEligibilityClaimDetailsJSON2Apex();
        SAEEligibilityClaimDetailsJSON2Apex.ClaimCodes claimCodes = new SAEEligibilityClaimDetailsJSON2Apex.ClaimCodes();
        claimCodes.type = 'type';
        claimCodes.description = 'description';
        claimCodes.code = 'code';
        SAEEligibilityClaimDetailsJSON2Apex.parse('{}')  ;
        
    }
    
    static testMethod void getClaimDetailsTest(){
        Test.setMock(HttpCalloutMock.class, new SAEHttpCalloutMock.SAEDetailsSearchWebServiceMock());
        // US3368942 - Thanish - 21st May 2021
        ACET_TestDataFactory.createWebServiceSetting('SNIAPIAccessToken', 'zwdsk9VPXJASohgqS2zqXD0UxD9MEa5g');
        ACET_TestDataFactory.createWebServiceSetting('dev_ORSEAIPToken', 'zwdsk9VPXJASohgqS2zqXD0UxD9MEa5g');
        //test class
        /*Profile p = [select Id from Profile where name like '%System Administrator%'];
User u = [select Id from User where profileId = :p.Id and isActive = True limit 1];
String currentUserProfName = [SELECT Name FROM Profile WHERE Id = :UserInfo.getProfileId()].Name;
Organization_Properties__c orgProps = new Organization_Properties__c();
orgProps.Name = 'test';
orgProps.OrganizationName__c = 'testOrg';
insert orgProps;
WebserviceConfigurations__c testWebServiceConfig = [SELECT Name,AuthorizationToken__c FROM WebserviceConfigurations__c
WHERE AuthorizationToken__c LIKE 'Bearer%' LIMIT 1];
testWebServiceConfig.Name = 'LinkClaimDetail';
update testWebServiceConfig;
OrgSpecificConfigurations__c orgSpecificConfig = new OrgSpecificConfigurations__c();
orgSpecificConfig.Name = orgProps.OrganizationName__c;
orgSpecificConfig.WebserviceConfigurations__c = testWebServiceConfig.Id;
orgSpecificConfig.EnableMock__c = true;
orgSpecificConfig.EnableMockForProfiles__c = currentUserProfName;
orgSpecificConfig.EndpointDomain__c = 'https://api-gateway-stage.linkhealth.com/clink-api/api/claim/detail/v1.0';
insert orgSpecificConfig;
List<Mock_Response_Details__c> mockRespDetails = [SELECT SearchParameter__c FROM Mock_Response_Details__c WHERE SearchParameter__c LIKE 'claimDetail%'
LIMIT 1];*/
        
        ACET_ClaimDetailController.ClaimInputs claimInputs = new ACET_ClaimDetailController.ClaimInputs();
        claimInputs.claimNumber ='18A9022531124';
        claimInputs.taxId='741777515';
        claimInputs.payerId='87726';
        claimInputs.processDate='03/19/2018';
        
        ACET_ClaimDetailController.ClaimDetailCard claimDetailCard= ACET_ClaimDetailController.getClaimDetails(claimInputs);
        ACET_ClaimDetailController.ClaimInputs claimInput = new ACET_ClaimDetailController.ClaimInputs();
        claimInput.claimNumber ='7863109999';
        claimInput.taxId='741777515';
        claimInput.payerId='87726';
        claimInput.processDate='03/19/2018';
        
        ACET_ClaimDetailController.ClaimDetailCard claimDetCard= ACET_ClaimDetailController.getClaimDetails(claimInput);
        
         ACET_ClaimDetailController.ClaimInputs claimInput2 = new ACET_ClaimDetailController.ClaimInputs();
        claimInput2.claimNumber ='7777777112';
        claimInput2.taxId='741777515';
        claimInput2.payerId='87726';
        claimInput2.processDate='03/19/2018';
        ACET_ClaimDetailController.getClaimDetails(claimInput2);

        ACET_ClaimDetailController.ClaimInputs ci = new ACET_ClaimDetailController.ClaimInputs();
        ci.claimNumber ='7777777112';
        ci.taxId='741777515';
        ci.payerId='87726';
        ci.processDate='03/16/2021';
        ACET_ClaimDetailController.getClaimDetails(ci);

    }
    
    static testMethod void createDiagnosisCardTest(){
        SAEEligibilityClaimDetailsJSON2Apex.ClaimsDetailInfo claimDetailInfo=new SAEEligibilityClaimDetailsJSON2Apex.ClaimsDetailInfo();
        List<SAEEligibilityClaimDetailsJSON2Apex.DiagnosisCodes> diagnosisCodes=new List<SAEEligibilityClaimDetailsJSON2Apex.DiagnosisCodes>();
        SAEEligibilityClaimDetailsJSON2Apex.DiagnosisCodes dc=new  SAEEligibilityClaimDetailsJSON2Apex.DiagnosisCodes();
        dc.diagnosisCode='N201';
        diagnosisCodes.add(dc) ;
        claimDetailInfo.diagnosisCodes =diagnosisCodes;
        // ACET_ClaimDetailController.createDiagnosisCard(claimDetailInfo,'7867773888');
        
    }
    static testMethod void getPaymentNumberTest(){
        ACET_ClaimDetailController.getPaymentNumber('7777777111','87726','741777515');
    }
    static testMethod void getClaimInformationTest(){
        ACET_ClaimDetailController.ClaimInputs claimInputs = new ACET_ClaimDetailController.ClaimInputs();
        claimInputs.claimNumber ='7777777111';
        claimInputs.taxId='741777515';
        claimInputs.payerId='87726';
        claimInputs.processDate='03/19/2018';
        SAEClaimDetailsWS claimDetailsService = new SAEClaimDetailsWS();
        claimDetailsService.getClaimInformation(claimInputs);
    }
    static testMethod void getClaimInformationExceptionHandlingTest(){
        ACET_ClaimDetailController.ClaimInputs claimInputs = new ACET_ClaimDetailController.ClaimInputs();
        claimInputs.claimNumber ='777777';
        claimInputs.taxId='7417';
        claimInputs.payerId='877';
        claimInputs.processDate='03/19/2018';
        SAEClaimDetailsWS claimDetailsService = new SAEClaimDetailsWS();
        claimDetailsService.getClaimInformation(claimInputs);
    }
    static testMethod void getErrorCodeTest(){
        Test.startTest();
        
        SAEClaimDetailsWS.getErrorResponse(400,'{"faultCode": "LCLM_S_302"}');
        SAEClaimDetailsWS.getErrorResponse(401,'{"faultCode": "LCLM_S_302"}');
        SAEClaimDetailsWS.getErrorResponse(404,'{"faultCode": "LCLM_S_302"}');
        SAEClaimDetailsWS.getErrorResponse(500,'{"faultCode": "LCLM_S_302"}');
        SAEClaimDetailsWS.getErrorResponse(503,'{"faultCode": "LCLM_S_302"}');
        SAEClaimDetailsWS.getErrorResponse(999,'{"faultCode": "LCLM_S_302"}');
        Test.stopTest();
    }

    static testMethod void test_getClaimDetailsByClaimId(){
        Test.startTest();
        SAEClaimSearchController.ClaimInputs claimInputs = new SAEClaimSearchController.ClaimInputs();
        claimInputs.claimNumber = '18A902707070';
        claimInputs.taxId = '420982971';
        claimInputs.payerId = '87726';
        claimInputs.startDateCompare = '10/14/2020';
        claimInputs.ClaimType = 'P';
        claimInputs.FromDate = '1/14/2020';
        claimInputs.ToDate = '5/14/2020';
        SAEClaimSearchController.SearchResultWrapper result = ACET_ClaimDetailController.getClaimDetailsByClaimId(claimInputs,true,false,1,true);
        System.assertNotEquals(result, null);
        Test.stopTest();
    }
    static testMethod void getContractExceptionsTest(){
        Test.startTest();
        ACET_ClaimDetailController.getContractExceptions('000006798', '061330992', '583');
        Test.stopTest();
    }


    
}