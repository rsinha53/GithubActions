@isTest(seealldata=false)
private class ACET_LoginFlowCtrlTest {
    
    @istest
    static void createOrUpdateORSCredentialsTest() {
        Tops_Encryption_Mappings__c topsEncryption = new Tops_Encryption_Mappings__c(EBCDIC__c='B', Char_1__c='45', Char_2__c='38', 
                                                                                     Char_3__c='64', Char_4__c='51', Char_5__c='64', 
                                                                                     Char_6__c='51', Char_7__c='45', Char_8__c='38');
        Insert topsEncryption;
        
        ISL_Webservice_Config__c apiEndpointSetting = new ISL_Webservice_Config__c(Name='SNIAPIAccessToken',
                                                                                   Value__c='zwdsk9VPXJASohgqS2zqXD0UxD9MEa5g');
        Insert apiEndpointSetting;
        
        ISL_Webservice_Config__c serviceSetting = new ISL_Webservice_Config__c(Name='dev_ORSEAIPToken',
                                                                               Value__c='zwdsk9VPXJASohgqS2zqXD0UxD9MEa5g');
        Insert serviceSetting;
        
        Per_User_Credentials__c userCredentialRec = new Per_User_Credentials__c(userName__c = 'test',
                                                                                Password__c='bbbbbbbb',
                                                                                user__c=userinfo.getUserId());
        Insert userCredentialRec;
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new SAEHttpCalloutMock.ACETLoginFlowMock());
        ACET_LoginFlowCtrl loginflow = new ACET_LoginFlowCtrl();
        loginflow.userPassword = 'bbbbbbbb';
        loginflow.validateTopsCredentials();
        loginflow.createOrUpdateORSCredentials();
        Test.stopTest();
    }
    
    @istest
    static void createOrUpdateORSCredentialsTest999() {
        Tops_Encryption_Mappings__c topsEncryption = new Tops_Encryption_Mappings__c(EBCDIC__c='B', Char_1__c='45', Char_2__c='38', 
                                                                                     Char_3__c='64', Char_4__c='51', Char_5__c='64', 
                                                                                     Char_6__c='51', Char_7__c='45', Char_8__c='38');
        Insert topsEncryption;
        
        ISL_Webservice_Config__c apiEndpointSetting = new ISL_Webservice_Config__c(Name='SNIAPIAccessToken',
                                                                                   Value__c='zwdsk9VPXJASohgqS2zqXD0UxD9MEa5g');
        Insert apiEndpointSetting;
        
        ISL_Webservice_Config__c serviceSetting = new ISL_Webservice_Config__c(Name='dev_ORSEAIPToken',
                                                                               Value__c='zwdsk9VPXJASohgqS2zqXD0UxD9MEa5g');
        Insert serviceSetting;
        
        Per_User_Credentials__c userCredentialRec = new Per_User_Credentials__c(userName__c = 'test',
                                                                                Password__c='bbbbbbbb',
                                                                                user__c=userinfo.getUserId());
        Insert userCredentialRec;
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new SAEHttpCalloutMock.ACETLoginFlowMock999());
        ACET_LoginFlowCtrl loginflow = new ACET_LoginFlowCtrl();
        loginflow.userPassword = 'bbbbbbbb';
        loginflow.validateTopsCredentials();
        loginflow.createOrUpdateORSCredentials();
        Test.stopTest();
    }
    
    @istest
    static void updPasswordTest() {
		User providerUser;
        system.runAs(new user(Id = userinfo.getUserId())){
        	providerUser = TestDataFactory.getUser('Provider Service');
            insert providerUser;
		}
        Tops_Encryption_Mappings__c topsEncryption = new Tops_Encryption_Mappings__c(EBCDIC__c='B', Char_1__c='45', Char_2__c='38', 
                                                                                     Char_3__c='64', Char_4__c='51', Char_5__c='64', 
                                                                                     Char_6__c='51', Char_7__c='45', Char_8__c='38');
        Insert topsEncryption;
        
        ISL_Webservice_Config__c apiEndpointSetting = new ISL_Webservice_Config__c(Name='SNIAPIAccessToken',
                                                                                   Value__c='zwdsk9VPXJASohgqS2zqXD0UxD9MEa5g');
        Insert apiEndpointSetting;
        
        ISL_Webservice_Config__c serviceSetting = new ISL_Webservice_Config__c(Name='dev_ORSEAIPToken',
                                                                               Value__c='zwdsk9VPXJASohgqS2zqXD0UxD9MEa5g');
        Insert serviceSetting;
        
        Per_User_Credentials__c userCredentialRec = new Per_User_Credentials__c(userName__c = 'test',
                                                                                Password__c='bbbbbbbb',
                                                                                user__c=providerUser.Id);
        Insert userCredentialRec;
        
        System.runAs(providerUser) {
            Test.startTest();
            Test.setMock(HttpCalloutMock.class, new SAEHttpCalloutMock.ACETLoginFlowUpdPasswordMock());
            ACET_LoginFlowCtrl loginflow = new ACET_LoginFlowCtrl();
            loginflow.userPassword = 'bbbbbbbb';
            loginflow.validateTopsCredentials();
            loginflow.createOrUpdateORSCredentials();
            Test.stopTest();
        }
    }
    
    @istest
    static void validateTopsCredentialsTest() {
		User providerUser;
        system.runAs(new user(Id = userinfo.getUserId())){
        	providerUser = TestDataFactory.getUser('Provider Service');
            insert providerUser;
		}
        ISL_Webservice_Config__c apiEndpointSetting = new ISL_Webservice_Config__c(Name='SNIAPIAccessToken',
                                                                                   Value__c='zwdsk9VPXJASohgqS2zqXD0UxD9MEa5g');
        Insert apiEndpointSetting;
        
        ISL_Webservice_Config__c serviceSetting = new ISL_Webservice_Config__c(Name='dev_ORSEAIPToken',
                                                                               Value__c='zwdsk9VPXJASohgqS2zqXD0UxD9MEa5g');
        Insert serviceSetting;
        
        Tops_Encryption_Mappings__c topsEncryption = new Tops_Encryption_Mappings__c(EBCDIC__c='B', Char_1__c='0C', Char_2__c='37', 
                                                                                     Char_3__c='18', Char_4__c='17', Char_5__c='1C', 
                                                                                     Char_6__c='51', Char_7__c='45', Char_8__c='38');
        Insert topsEncryption;
        System.runAs(providerUser) {
            Test.startTest();
            Test.setMock(HttpCalloutMock.class, new SAEHttpCalloutMock.ACETLoginFlowMock());
            ACET_LoginFlowCtrl loginflow = new ACET_LoginFlowCtrl();
            loginflow.userPassword = 'bbbbbbbb';
            loginflow.validateTopsCredentials();
            loginflow.createOrUpdateORSCredentials();
        }
    }
    
    @istest
    static void validateTopsCredentialsTest400() {
        Per_User_Credentials__c userCredentialRec = new Per_User_Credentials__c(userName__c = 'test',
                                                                                Password__c='bbbbbbbb',
                                                                                user__c=userinfo.getUserId());
        Insert userCredentialRec;
        ISL_Webservice_Config__c apiEndpointSetting = new ISL_Webservice_Config__c(Name='SNIAPIAccessToken',
                                                                                   Value__c='zwdsk9VPXJASohgqS2zqXD0UxD9MEa5g');
        Insert apiEndpointSetting;
        
        ISL_Webservice_Config__c serviceSetting = new ISL_Webservice_Config__c(Name='dev_ORSEAIPToken',
                                                                               Value__c='zwdsk9VPXJASohgqS2zqXD0UxD9MEa5g');
        Insert serviceSetting;
        
        Tops_Encryption_Mappings__c topsEncryption = new Tops_Encryption_Mappings__c(EBCDIC__c='B', Char_1__c='0C', Char_2__c='37', 
                                                                                     Char_3__c='18', Char_4__c='17', Char_5__c='1C', 
                                                                                     Char_6__c='51', Char_7__c='45', Char_8__c='38');
        Insert topsEncryption;
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new SAEHttpCalloutMock.ACETLoginFlowMock400());
        ACET_LoginFlowCtrl loginflow = new ACET_LoginFlowCtrl();
        loginflow.userPassword = 'bbbbbbbb';
        loginflow.validateTopsCredentials();
        loginflow.createOrUpdateORSCredentials();
        Test.stopTest();
    }
    
    @istest
    static void validateTopsCredentialsTest404() {
        Per_User_Credentials__c userCredentialRec = new Per_User_Credentials__c(userName__c = 'test',
                                                                                Password__c='bbbbbbbb',
                                                                                user__c=userinfo.getUserId());
        Insert userCredentialRec;
        ISL_Webservice_Config__c apiEndpointSetting = new ISL_Webservice_Config__c(Name='SNIAPIAccessToken',
                                                                                   Value__c='zwdsk9VPXJASohgqS2zqXD0UxD9MEa5g');
        Insert apiEndpointSetting;
        
        ISL_Webservice_Config__c serviceSetting = new ISL_Webservice_Config__c(Name='dev_ORSEAIPToken',
                                                                               Value__c='zwdsk9VPXJASohgqS2zqXD0UxD9MEa5g');
        Insert serviceSetting;
        
        Tops_Encryption_Mappings__c topsEncryption = new Tops_Encryption_Mappings__c(EBCDIC__c='B', Char_1__c='0C', Char_2__c='37', 
                                                                                     Char_3__c='18', Char_4__c='17', Char_5__c='1C', 
                                                                                     Char_6__c='51', Char_7__c='45', Char_8__c='38');
        Insert topsEncryption;
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new SAEHttpCalloutMock.ACETLoginFlowMock404());
        ACET_LoginFlowCtrl loginflow = new ACET_LoginFlowCtrl();
        loginflow.userPassword = 'bbbbbbbb';
        loginflow.validateTopsCredentials();
        loginflow.createOrUpdateORSCredentials();
        Test.stopTest();
    }
    
    @istest
    static void validateTopsCredentialsTest500() {
        Per_User_Credentials__c userCredentialRec = new Per_User_Credentials__c(userName__c = 'test',
                                                                                Password__c='bbbbbbbb',
                                                                                user__c=userinfo.getUserId());
        Insert userCredentialRec;
        ISL_Webservice_Config__c apiEndpointSetting = new ISL_Webservice_Config__c(Name='SNIAPIAccessToken',
                                                                                   Value__c='zwdsk9VPXJASohgqS2zqXD0UxD9MEa5g');
        Insert apiEndpointSetting;
        
        ISL_Webservice_Config__c serviceSetting = new ISL_Webservice_Config__c(Name='dev_ORSEAIPToken',
                                                                               Value__c='zwdsk9VPXJASohgqS2zqXD0UxD9MEa5g');
        Insert serviceSetting;
        
        Tops_Encryption_Mappings__c topsEncryption = new Tops_Encryption_Mappings__c(EBCDIC__c='B', Char_1__c='0C', Char_2__c='37', 
                                                                                     Char_3__c='18', Char_4__c='17', Char_5__c='1C', 
                                                                                     Char_6__c='51', Char_7__c='45', Char_8__c='38');
        Insert topsEncryption;
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new SAEHttpCalloutMock.ACETLoginFlowMock500());
        ACET_LoginFlowCtrl loginflow = new ACET_LoginFlowCtrl();
        loginflow.userPassword = 'bbbbbbbb';
        loginflow.validateTopsCredentials();
        loginflow.createOrUpdateORSCredentials();
        Test.stopTest();
    }
    
    // Added by Durga Prasad
    @istest
    static void updatePasswordTest() {
		User providerUser;
        system.runAs(new user(Id = userinfo.getUserId())){
        	providerUser = TestDataFactory.getUser('Provider Service');
            insert providerUser;
		}        
        Tops_Encryption_Mappings__c topsEncryption = new Tops_Encryption_Mappings__c(EBCDIC__c='B', Char_1__c='45', Char_2__c='38',
                                                                                     Char_3__c='64', Char_4__c='51', Char_5__c='64',
                                                                                     Char_6__c='51', Char_7__c='45', Char_8__c='38');
        Insert topsEncryption;
        
        ISL_Webservice_Config__c apiEndpointSetting = new ISL_Webservice_Config__c(Name='SNIAPIAccessToken',
                                                                                   Value__c='zwdsk9VPXJASohgqS2zqXD0UxD9MEa5g');
        Insert apiEndpointSetting;
        
        ISL_Webservice_Config__c daysRemaining = new ISL_Webservice_Config__c(Name='MVPTokenDaysPasswordExp',
                                                                              Value__c='10');
        Insert daysRemaining;
        
        ISL_Webservice_Config__c serviceSetting = new ISL_Webservice_Config__c(Name='dev_ORSEAIPToken',
                                                                               Value__c='zwdsk9VPXJASohgqS2zqXD0UxD9MEa5g');
        Insert serviceSetting;
        
        Per_User_Credentials__c userCredentialRec = new Per_User_Credentials__c(userName__c = 'test',
                                                                                Password__c='bbbbbbbb',
                                                                                old_password__c='bbbbbbbb',
                                                                                user__c=providerUser.Id);
        Insert userCredentialRec;
        
        System.runAs(providerUser) {
            Test.startTest();
            Test.setMock(HttpCalloutMock.class, new SAEHttpCalloutMock.ACETLoginFlowUpdatePasswordMock());
            ACET_LoginFlowCtrl loginflow = new ACET_LoginFlowCtrl();
            loginflow.userPassword = 'bbbbbbbb';
            loginflow.renderUpdatePasswordPanel();
            loginflow.strNewPassword = 'bbbbbbbb';
            loginflow.UpdateORSCredentials();
            ACET_LoginFlowCtrl.getAuthToken();
            loginflow.skipTOPSLogin();
            loginflow.validateTopsCredentials();
            Test.stopTest();
        }
    }
    
    @istest
    static void updatePasswordExceptionTest() {
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
        ACET_LoginFlowCtrl loginflow = new ACET_LoginFlowCtrl();
        loginflow.userPassword = 'bbbbbbbb';
        loginflow.renderUpdatePasswordPanel();
        loginflow.strNewPassword = 'aaaaaaaa';
        loginflow.UpdateORSCredentials();
        loginflow.validateTopsCredentials();
        Test.stopTest(); 
    }
    
    @istest
    static void updatePasswordTest400() {
        Tops_Encryption_Mappings__c topsEncryption = new Tops_Encryption_Mappings__c(EBCDIC__c='B', Char_1__c='45', Char_2__c='38',
                                                                                     Char_3__c='64', Char_4__c='51', Char_5__c='64',
                                                                                     Char_6__c='51', Char_7__c='45', Char_8__c='38');
        Insert topsEncryption;
        
        ISL_Webservice_Config__c apiEndpointSetting = new ISL_Webservice_Config__c(Name='SNIAPIAccessToken',
                                                                                   Value__c='zwdsk9VPXJASohgqS2zqXD0UxD9MEa5g');
        Insert apiEndpointSetting;
        
        ISL_Webservice_Config__c daysRemaining = new ISL_Webservice_Config__c(Name='MVPTokenDaysPasswordExp',
                                                                              Value__c='10');
        Insert daysRemaining;
        
        ISL_Webservice_Config__c serviceSetting = new ISL_Webservice_Config__c(Name='dev_ORSEAIPToken',
                                                                               Value__c='zwdsk9VPXJASohgqS2zqXD0UxD9MEa5g');
        Insert serviceSetting;
        
        Per_User_Credentials__c userCredentialRec = new Per_User_Credentials__c(userName__c = 'test',
                                                                                Password__c='bbbbbbbb',
                                                                                user__c=userinfo.getUserId());
        Insert userCredentialRec;
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new SAEHttpCalloutMock.ACETLoginFlowUpdatePasswordMock400());
        ACET_LoginFlowCtrl loginflow = new ACET_LoginFlowCtrl();
        loginflow.userPassword = 'bbbbbbbb';
        loginflow.renderUpdatePasswordPanel();
        loginflow.strNewPassword = 'bbbbbbbb';
        loginflow.UpdateORSCredentials();
        ACET_LoginFlowCtrl.getAuthToken();
        loginflow.skipTOPSLogin();
        loginflow.validateTopsCredentials();
        Test.stopTest();   
    }
    
    @istest
    static void updatePasswordTest500() {
        Tops_Encryption_Mappings__c topsEncryption = new Tops_Encryption_Mappings__c(EBCDIC__c='B', Char_1__c='45', Char_2__c='38',
                                                                                     Char_3__c='64', Char_4__c='51', Char_5__c='64',
                                                                                     Char_6__c='51', Char_7__c='45', Char_8__c='38');
        Insert topsEncryption;
        
        ISL_Webservice_Config__c apiEndpointSetting = new ISL_Webservice_Config__c(Name='SNIAPIAccessToken',
                                                                                   Value__c='zwdsk9VPXJASohgqS2zqXD0UxD9MEa5g');
        Insert apiEndpointSetting;
        
        ISL_Webservice_Config__c daysRemaining = new ISL_Webservice_Config__c(Name='MVPTokenDaysPasswordExp',
                                                                              Value__c='10');
        Insert daysRemaining;
        
        ISL_Webservice_Config__c serviceSetting = new ISL_Webservice_Config__c(Name='dev_ORSEAIPToken',
                                                                               Value__c='zwdsk9VPXJASohgqS2zqXD0UxD9MEa5g');
        Insert serviceSetting;
        
        Per_User_Credentials__c userCredentialRec = new Per_User_Credentials__c(userName__c = 'test',
                                                                                Password__c='bbbbbbbb',
                                                                                user__c=userinfo.getUserId());
        Insert userCredentialRec;
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new SAEHttpCalloutMock.ACETLoginFlowUpdatePasswordMock500());
        ACET_LoginFlowCtrl loginflow = new ACET_LoginFlowCtrl();
        loginflow.userPassword = 'bbbbbbbb';
        loginflow.renderUpdatePasswordPanel();
        loginflow.strNewPassword = 'bbbbbbbb';
        loginflow.UpdateORSCredentials();
        ACET_LoginFlowCtrl.getAuthToken();
        loginflow.skipTOPSLogin();
        loginflow.validateTopsCredentials();
        Test.stopTest();
    }
    
    @istest
    static void updatePasswordTest404() {
        Tops_Encryption_Mappings__c topsEncryption = new Tops_Encryption_Mappings__c(EBCDIC__c='B', Char_1__c='45', Char_2__c='38',
                                                                                     Char_3__c='64', Char_4__c='51', Char_5__c='64',
                                                                                     Char_6__c='51', Char_7__c='45', Char_8__c='38');
        Insert topsEncryption;
        
        Login_Flow_Configs__c loginFlowConfigs = new Login_Flow_Configs__c();
        loginFlowConfigs.SkipLoginFlow__c  = true;
        loginFlowConfigs.AgentId__c = '123';
        loginFlowConfigs.OfficeId__c = 'njk';
        loginFlowConfigs.BusinessGroups__c = 'Standard';
        loginFlowConfigs.CosmosId__c = '12345';
        loginFlowConfigs.UserToken__c = 'A12345';//US3308339
        Insert loginFlowConfigs;
        
        ISL_Webservice_Config__c apiEndpointSetting = new ISL_Webservice_Config__c(Name='SNIAPIAccessToken',
                                                                                   Value__c='zwdsk9VPXJASohgqS2zqXD0UxD9MEa5g');
        Insert apiEndpointSetting;
        
        ISL_Webservice_Config__c daysRemaining = new ISL_Webservice_Config__c(Name='MVPTokenDaysPasswordExp',
                                                                              Value__c='10');
        Insert daysRemaining;
        
        ISL_Webservice_Config__c serviceSetting = new ISL_Webservice_Config__c(Name='dev_ORSEAIPToken',
                                                                               Value__c='zwdsk9VPXJASohgqS2zqXD0UxD9MEa5g');
        Insert serviceSetting;
        
        Per_User_Credentials__c userCredentialRec = new Per_User_Credentials__c(userName__c = 'test',
                                                                                Password__c='bbbbbbbb',
                                                                                user__c=userinfo.getUserId());
        Insert userCredentialRec;
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new SAEHttpCalloutMock.ACETLoginFlowUpdatePasswordMock404());
        ACET_LoginFlowCtrl loginflow = new ACET_LoginFlowCtrl();
        loginflow.userPassword = 'bbbbbbbb';
        loginflow.renderUpdatePasswordPanel();
        loginflow.strNewPassword = 'bbbbbbbb';
        loginflow.UpdateORSCredentials();
        ACET_LoginFlowCtrl.getAuthToken();
        loginflow.skipTOPSLogin();
        loginflow.validateTopsCredentials();
        Test.stopTest();
    }
    
    @istest
    static void updatePasswordTest99() {
        Tops_Encryption_Mappings__c topsEncryption = new Tops_Encryption_Mappings__c(EBCDIC__c='B', Char_1__c='45', Char_2__c='38',
                                                                                     Char_3__c='64', Char_4__c='51', Char_5__c='64',
                                                                                     Char_6__c='51', Char_7__c='45', Char_8__c='38');
        Insert topsEncryption;
        
        Login_Flow_Configs__c loginFlowConfigs = new Login_Flow_Configs__c();
        loginFlowConfigs.SkipLoginFlow__c  = true;
        loginFlowConfigs.AgentId__c = '123';
        loginFlowConfigs.OfficeId__c = 'njk';
        loginFlowConfigs.BusinessGroups__c = 'Standard';
        loginFlowConfigs.CosmosId__c = '12345';//US3273505
        loginFlowConfigs.UserToken__c = 'A12345';
        Insert loginFlowConfigs;
        
        ISL_Webservice_Config__c apiEndpointSetting = new ISL_Webservice_Config__c(Name='SNIAPIAccessToken',
                                                                                   Value__c='zwdsk9VPXJASohgqS2zqXD0UxD9MEa5g');
        Insert apiEndpointSetting;
        
        ISL_Webservice_Config__c daysRemaining = new ISL_Webservice_Config__c(Name='MVPTokenDaysPasswordExp',
                                                                              Value__c='10');
        Insert daysRemaining;
        
        ISL_Webservice_Config__c serviceSetting = new ISL_Webservice_Config__c(Name='dev_ORSEAIPToken',
                                                                               Value__c='zwdsk9VPXJASohgqS2zqXD0UxD9MEa5g');
        Insert serviceSetting;
        
        Per_User_Credentials__c userCredentialRec = new Per_User_Credentials__c(userName__c = 'test',
                                                                                Password__c='bbbbbbbb',
                                                                                user__c=userinfo.getUserId());
        Insert userCredentialRec;
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new SAEHttpCalloutMock.ACETLoginFlowUpdatePasswordMock999());
        ACET_LoginFlowCtrl loginflow = new ACET_LoginFlowCtrl();
        loginflow.userPassword = 'bbbbbbbb';
        loginflow.renderUpdatePasswordPanel();
        loginflow.strNewPassword = 'bbbbbbbb';
        loginflow.UpdateORSCredentials();
        loginflow.validateTopsCredentials();
        Test.stopTest();
    }
}