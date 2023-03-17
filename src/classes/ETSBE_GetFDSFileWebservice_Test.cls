@istest
public class ETSBE_GetFDSFileWebservice_Test {
    static testMethod void testCase1() {
        
        ISL_Webservice_Config__c configObj = SAETestDataFactory.insertISLWebserviceConfig(
            'dev_GetFDSBaseURL',
            'GetFDSTokenEndpoint',
            true,
            true,
            'GetSolarisEndpoint',
            0,
            false,
            '',
            'https://test.salesforce.com'
        );  
        ISL_Webservice_Config__c tokenconfigObj = SAETestDataFactory.insertISLWebserviceConfig(
            'ISLConAccessToken',
            'ISLConAccessToken',
            true,
            true,
            'ISLConAccessToken',
            0,
            false,
            '',
            '0a66b01d-be12-4cdf-983d-b1dd0b406fa2'
        );  
        ISL_Webservice_Config__c grantconfigObj = SAETestDataFactory.insertISLWebserviceConfig(
            'dev_FDSApiGrantType',
            'FDSApiGrantType',
            true,
            true,
            '',
            0,
            false,
            '',
            'password'
        ); 
        ISL_Webservice_Config__c clientconfigObj = SAETestDataFactory.insertISLWebserviceConfig(
            'dev_FDSApiOAuthClientId',
            'FDSApiOAuthClientId',
            true,
            true,
            '',
            0,
            false,
            '',
            '3MVG9RezSyZYLh2v3P93rV1_Le0UZGAK1_MXdDLKCoMJzrKleQhXHAJKP2rz.BFmRElUTPym5ovJhzKb5zAG_'
        ); 
        ISL_Webservice_Config__c secretconfigObj = SAETestDataFactory.insertISLWebserviceConfig(
            'dev_FDSApiOAuthClientSecret',
            'FDSApiOAuthClientSecret',
            true,
            true,
            '',
            0,
            false,
            '',
            'F872775E1E674A897EB0589F7A215C26E27CF76B8114369B7056832CBC780F49'
        ); 
        
        ISL_Webservice_Config__c provideronfigObj = SAETestDataFactory.insertISLWebserviceConfig(
            'SAE_ProviderSearch',
            'SAE_ProviderSearch',
            true,
            true,
            '',
            0,
            false,
            '',
            'test@'
        );
        ISL_Webservice_Config__c provideronfigObj2 = SAETestDataFactory.insertISLWebserviceConfig(
            'dev_GetFDSSignedURLEndpoint',
            'dev_GetFDSSignedURLEndpoint',
            true,
            true,
            '',
            0,
            false,
            '',
            'test@'
        );
        case casedata = new case();
        casedata.subject = 'test';
        insert casedata;
        
        Blob beforeblob=Blob.valueOf('Unit Test Attachment Body');
        
        ContentVersion cv = new ContentVersion();
        cv.title = 'test content trigger';      
        cv.PathOnClient ='test';           
        cv.VersionData =beforeblob;          
        insert cv;        
        
        ContentVersion testContent = [SELECT id, ContentDocumentId FROM ContentVersion where Id = :cv.Id];
        
        ContentDocumentLink newFileShare = new ContentDocumentLink();
        newFileShare.contentdocumentid = testcontent.contentdocumentid;
        newFileShare.ShareType= 'V';
        newFileShare.LinkedEntityId = casedata.Id;
        insert newFileShare;
        
        
        Test.startTest();
        ETSBE_SolarisMockupResponse fakeResponse = new ETSBE_SolarisMockupResponse(200,
                                                                                   'Success',
                                                                                   '{"access_token":"b3773f31-58bf-454e-9","refresh_token":"bf1dd266-cf75-41f0","token_type":"bearer","expires_in":1800}',
                                                                                   null);
        Test.setMock(HttpCalloutMock.class, fakeResponse);
        ETSBE_SolarisMockupResponse urlResponse = new ETSBE_SolarisMockupResponse(200,
                                                                                   'Success',
                                                                                   '{"presignedUrl":"https://dooss.uhc.com/FS2-Test/71b2fc77-cb14-49e4-b0ce-c04d9b7e6ad0","expiresAt":"2019-02-13T15:40:40Z"}',
                                                                                   null);
        Test.setMock(HttpCalloutMock.class, urlResponse);
        ETSBE_GetFDSFileWebservice FileArchiveObj = new ETSBE_GetFDSFileWebservice();
        
        ETSBE_GetFDSFileWebservice.fetchFDSFile('1234');
        Test.stopTest();                
        
    
}
}