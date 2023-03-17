@istest(seealldata=false)
private class SAEGetAccessTokenSchedulerTest {
    
    @isTest static void GetAccessTokenSchedulerTest1() {
        
        ISL_Webservice_Config__c webConfig = new ISL_Webservice_Config__c();
        webConfig.Name = 'dev_LINKOAuthClientId';
        webConfig.Value__c = 'https://api-gateway-stage.linkhealth.com/elink-services/api/eligibility';
        insert webConfig;
        
        ISL_Webservice_Config__c webConfig_token = new ISL_Webservice_Config__c();
        webConfig_token.Name = 'dev_LINKOAuthClientSecret';
        webConfig_token.Value__c = 'bearer';
        insert webConfig_token;
        
        ISL_Webservice_Config__c webConfig_token1 = new ISL_Webservice_Config__c();
        webConfig_token1.Name = 'dev_LINKApiEndpoint';
        webConfig_token1.Value__c = 'bearer';
        insert webConfig_token1;
        
        ISL_Webservice_Config__c webConfig_token2 = new ISL_Webservice_Config__c();
        webConfig_token2.Name = 'dev_StargateOAuthClientId';
        webConfig_token2.Value__c = 'bearer';
        insert webConfig_token2;
        
        ISL_Webservice_Config__c webConfig_token3 = new ISL_Webservice_Config__c();
        webConfig_token3.Name = 'dev_StargateOAuthClientSecret';
        webConfig_token3.Value__c = 'bearer';
        insert webConfig_token3;
        
        ISL_Webservice_Config__c webConfig_token4 = new ISL_Webservice_Config__c();
        webConfig_token4.Name = 'dev_SNIApiEndpoint';
        webConfig_token4.Value__c = 'bearer';
        insert webConfig_token4;
        
        
        Token_Generation__c tokenRec = new Token_Generation__c(Token_Name__c = 'ISLConAccessToken',value__c = 'f8BbDcdeErZYzZ7nCMHzom4HO6Z8Fatx');
        Insert tokenRec;
        Token_Generation__c tokenRec1 = new Token_Generation__c(Token_Name__c = 'StageGate',value__c = 'f8BbDcdeErZYzZ7nCMHzom4HO6Z8Fatx');
        Insert tokenRec1;
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new SAEHttpCalloutMock.SAEGETAccessTokenSchedulerWebServiceMock());
        System.schedule('testjob', '0 45 * * * ?', new SAEGetAccessTokenScheduler());
        Test.stopTest();
        
    }
    
    @isTest static void GetAccessTokenSchedulerTest2() {
        
        ISL_Webservice_Config__c webConfig = new ISL_Webservice_Config__c();
        webConfig.Name = 'dev_LINKOAuthClientId';
        webConfig.Value__c = 'https://api-gateway-stage.linkhealth.com/elink-services/api/eligibility';
        insert webConfig;
        
        ISL_Webservice_Config__c webConfig_token = new ISL_Webservice_Config__c();
        webConfig_token.Name = 'dev_LINKOAuthClientSecret';
        webConfig_token.Value__c = 'bearer';
        insert webConfig_token;
        
        ISL_Webservice_Config__c webConfig_token1 = new ISL_Webservice_Config__c();
        webConfig_token1.Name = 'dev_LINKApiEndpoint';
        webConfig_token1.Value__c = 'bearer';
        insert webConfig_token1;
        
        ISL_Webservice_Config__c webConfig_token2 = new ISL_Webservice_Config__c();
        webConfig_token2.Name = 'dev_StargateOAuthClientId';
        webConfig_token2.Value__c = 'bearer';
        insert webConfig_token2;
        
        ISL_Webservice_Config__c webConfig_token3 = new ISL_Webservice_Config__c();
        webConfig_token3.Name = 'dev_StargateOAuthClientSecret';
        webConfig_token3.Value__c = 'bearer';
        insert webConfig_token3;
        
        ISL_Webservice_Config__c webConfig_token4 = new ISL_Webservice_Config__c();
        webConfig_token4.Name = 'dev_SNIApiEndpoint';
        webConfig_token4.Value__c = 'bearer';
        insert webConfig_token4;
        
        //Token Generation Records
        Token_Generation__c tokenRec = new Token_Generation__c(Token_Name__c = 'ISLConAccessToken',value__c = 'f8BbDcdeErZYzZ7nCMHzom4HO6Z8Fatx');
        Insert tokenRec;
        Token_Generation__c tokenRec1 = new Token_Generation__c(Token_Name__c = 'StageGate',value__c = 'f8BbDcdeErZYzZ7nCMHzom4HO6Z8Fatx');
        Insert tokenRec1;
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new SAEHttpCalloutMock.SAEPCPHistoryWebServiceMock());
        System.schedule('testjob', '0 45 * * * ?', new SAEGetAccessTokenScheduler());
        Test.stopTest();
        
    }
}