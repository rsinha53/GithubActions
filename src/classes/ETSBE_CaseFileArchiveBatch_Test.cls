@istest
public class ETSBE_CaseFileArchiveBatch_Test {
 
    
    static testMethod void testCaseFileArchive() {
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
        Case casedata = new case();
        casedata.subject = 'test';
        casedata.RecordTypeId =  Schema.SObjectType.Case.getRecordTypeInfosByName().get('BEO').getRecordTypeId();
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
      /*  ETSBE_SolarisMockupResponse fakeResponse = new ETSBE_SolarisMockupResponse(200,
                                                                                   'Success',
                                                                                   '{"access_token":"b3773f31-58bf-454e-9","refresh_token":"bf1dd266-cf75-41f0","token_type":"bearer","expires_in":1800}',
                                                                                   null);
        Test.setMock(HttpCalloutMock.class, fakeResponse); */
        ETSBE_SolarisMockupResponse uploadResponse = new ETSBE_SolarisMockupResponse(200,
                                                                                     'Success',
                                                                                     '{"attachment":[{"status":"AVAILABLE","id":"442827ad-398e-40a8-806e-624bd257300b","space_id":2805,"external_id":"123456789","file_name":"test.doc","file_size":30208,"content_type":""}]}',
                                                                                     null); 
        Test.setMock(HttpCalloutMock.class, uploadResponse);
        //ETSBE_caseFileArchiveBatch interactionFileArchiveObj = new ETSBE_caseFileArchiveBatch();
        
        Database.executeBatch(new ETSBE_caseFileArchiveBatch());
        
        Test.stopTest(); 
    }
}