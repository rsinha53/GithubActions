@isTest
public class ETSBE_InteractionFileArchiveBatch_Test {

    static testMethod void testInteractionFileArchive() {

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
            'dev_GetFDSUploadEndpoint',
            'dev_GetFDSUploadEndpoint',
            true,
            true,
            '',
            0,
            false,
            '',
            'test@'
        );
        Interaction__c interactObj = new Interaction__c();            
        interactObj.Interaction_Type__c = 'Phone Call';
        interactObj.Evt_Recvd_Dt_Time__c = DateTime.newInstance(2020, 03, 26, 06, 00, 00);
        insert interactObj;
        
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
        newFileShare.LinkedEntityId = interactObj.Id;
        insert newFileShare;
        
        Test.startTest();
        ETSBE_SolarisMockupResponse fakeResponse = new ETSBE_SolarisMockupResponse(200,
                                                                                   'Success',
                                                                                   '{"access_token": "sForceTest1", "attachment":[{    "content_type":"image/jpeg",    "file_name":"noData.jpg",     "file_size":"10047",    "id":"d261f355-2490-4843-aafc-be8197dfa695",     "status":"AVAILABLE"}]}',
                                                                                   null);
        Test.setMock(HttpCalloutMock.class, fakeResponse);
        
        ETSBE_InteractionFileArchiveBatch interactionFileArchiveObj = new ETSBE_InteractionFileArchiveBatch();
        Database.executeBatch(interactionFileArchiveObj);
        
        Test.stopTest();  
        
    }
    
}