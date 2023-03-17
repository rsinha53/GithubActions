@IsTest
public class SNI_FL_DigitalOnboardingControllerTest {
    //Taken frmo ACETSNILinkMemberSearchTest
    @testSetup static void testSetupSNILinkMemberSearch(){
        UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
        Profile profile1 = [Select Id from Profile where name = 'System Administrator'];
        User portalAccountOwner1 = new User(
            UserRoleId = portalRole.Id,
            ProfileId = profile1.Id,
            Username = System.now().millisecond() + 'zzznpDOadv99@optum.com.acet',
            Alias = 'batman',
            Email='zzznpzDOadv99@optum.com.acet',
            EmailEncodingKey='UTF-8',
            Firstname='yarroaz',
            Lastname='yavanoaz',
            LanguageLocaleKey='en_US',
            LocaleSidKey='en_US',
            TimeZoneSidKey='America/Chicago');
        Database.insert(portalAccountOwner1);
        System.runAs ( portalAccountOwner1 ){
            Round_Robin_Queue__c rrq = new Round_Robin_Queue__c();
            rrq.Last_Assigned_Advisor__c = '';
            insert rrq;
            id UserRoleID = [Select Id From UserRole Where Name = 'Care Advisor' Limit 1].id; 
            id ProfileID = [Select Id From Profile Where Name='Center for Health Navigation'].id;
            User user = new User();
            user.UserRoleID = UserRoleID;
            user.ProfileID = ProfileID;
            user.EmailEncodingKey = 'ISO-8859-1';
            user.LanguageLocaleKey = 'en_US';
            user.TimeZoneSidKey = 'America/New_York';
            user.LocaleSidKey = 'en_US';
            user.FirstName = 'advone';
            user.LastName = 'advone';
            user.Username = 'ABCD1234DOadva991@optum.com.acet';
            user.CommunityNickname = 'testUser123radv991';
            user.Alias = 'z11';
            user.Email = 'noyarroDOadva991@optum.com.acet';
            user.IsActive = true;
            insert user;
            User user1 = new User();
            user1.UserRoleID = UserRoleID;
            user1.ProfileID = ProfileID;
            user1.EmailEncodingKey = 'ISO-8859-1';
            user1.LanguageLocaleKey = 'en_US';
            user1.TimeZoneSidKey = 'America/New_York';
            user1.LocaleSidKey = 'en_US';
            user1.FirstName = 'advtwo';
            user1.LastName = 'advtwo';
            user1.Username = 'ABCD1234DOadva992@optum.com.acet';
            user1.CommunityNickname = 'testUser123radv992';
            user1.Alias = 'z12';
            user1.Email = 'noyarroDOadva992@optum.com.acet';
            user1.IsActive = true;
            insert user1;
            DigitalOnboardingAdvisorAssignment__c doa = new DigitalOnboardingAdvisorAssignment__c();
            doa.Name__c = user.Id;
            insert doa;
            DigitalOnboardingAdvisorAssignment__c doa1 = new DigitalOnboardingAdvisorAssignment__c();
            doa1.Name__c = user1.Id;
            insert doa1;
            User user2 = new User();
            user2.UserRoleID = UserRoleID;
            user2.ProfileID = ProfileID;
            user2.EmailEncodingKey = 'ISO-8859-1';
            user2.LanguageLocaleKey = 'en_US';
            user2.TimeZoneSidKey = 'America/New_York';
            user2.LocaleSidKey = 'en_US';
            user2.FirstName = 'advthree';
            user2.LastName = 'advthree';
            user2.Username = 'ABCD1234DOadva993@optum.com.acet';
            user2.CommunityNickname = 'testUser123radv993';
            user2.Alias = 'z13';
            user2.Email = 'noyarroDOadva993@optum.com.acet';
            user2.IsActive = true;
            insert user2;
            DigitalOnboardingAdvisorAssignment__c doa2 = new DigitalOnboardingAdvisorAssignment__c();
            doa2.Name__c = user2.Id;
            insert doa2;
            
            Organization_Properties__c orgProp = new Organization_Properties__c();
            orgProp.OrganizationName__c = 'QA';
            orgProp.SetupOwnerId=UserInfo.getOrganizationId();
            insert orgProp;                 
            
            WebserviceConfigurations__c  webConifTokenApi = new WebserviceConfigurations__c ();
            webConifTokenApi.EndpointPath__c = '/oauth/token';
            webConifTokenApi.GrantType__c  = 'client_credentials';
            webConifTokenApi.Headers__c  = '[{"key":"Content-Type","value":"application/x-www-form-urlencoded"}]';
            webConifTokenApi.JSONBodyWithMergeFields__c  = '';
            webConifTokenApi.Method__c  = 'POST';
            webConifTokenApi.Name  = 'LinkServiceTokenAPI';
            //Id RecordTypeId = Schema.SObjectType.WebserviceConfigurations__c.getRecordTypeInfosByName().get('Token_API').getRecordTypeId();
            RecordType recTypeTokenAPI = [SELECT Id FROM RecordType WHERE DeveloperName = 'Token_API' and SObjectType = 'WebserviceConfigurations__c'];
            webConifTokenApi.RecordTypeId  = recTypeTokenAPI.Id;
            insert webConifTokenApi;
            
            OrgSpecificConfigurations__c orgSpecTokenAPI = new OrgSpecificConfigurations__c();
            //Id RecordTypeId = Schema.SObjectType.OrgSpecificConfigurations__c.getRecordTypeInfosByName().get('TokenAPI').getRecordTypeId(); 
            RecordType recTypeOrgTokenAPI = [SELECT Id FROM RecordType WHERE DeveloperName = 'TokenAPI' and SObjectType = 'OrgSpecificConfigurations__c'];
            orgSpecTokenAPI.RecordTypeId  = recTypeOrgTokenAPI.Id;
            orgSpecTokenAPI.EndpointDomain__c = 'https://api-gateway-stage.linkhealth.com';
            orgSpecTokenAPI.ClientId__c = 'test';
            orgSpecTokenAPI.ClientSecret__c = 'a723ef27-493b-4afa-2d43-43542cc87rf3';
            orgSpecTokenAPI.WebserviceConfigurations__c = webConifTokenApi.Id;
            insert orgSpecTokenAPI;             
            
            WebserviceConfigurations__c tokenRecord = new WebserviceConfigurations__c();
            tokenRecord.Name = 'LinkServiceTokenAPIToken';
            RecordType recTypeAuthTokenAPI = [SELECT Id FROM RecordType WHERE DeveloperName = 'Authorization_Token' and SObjectType = 'WebserviceConfigurations__c'];
            tokenRecord.RecordTypeId = recTypeAuthTokenAPI.Id;
            tokenRecord.AuthorizationToken__c = 'sdakhjsadkjsagdiuqwy912879182371okasbdfo123y984e1279479812hkdjasahdo12987349182ehkj';
            insert tokenRecord;
            
            WebserviceConfigurations__c  webConifServiceAPI = new WebserviceConfigurations__c ();
            webConifServiceAPI.EndpointPath__c = '/elink-services/api/eligibility/v2.0';
            webConifServiceAPI.GrantType__c  = 'client_credentials';
            webConifServiceAPI.Headers__c  = '[{"key":"Authorization","value":"Bearer <:AUTH_TOKEN:>"},{"key":"Content-Type","value":"application/json"},{"key":"actor","value":"ACET"}]';
            webConifServiceAPI.AuthorizationToken__c  = 'SELECT AuthorizationToken__c FROM WebserviceConfigurations__c WHERE Name = LinkServiceTokenAPIToken';
            webConifServiceAPI.Method__c  = 'GET';
            webConifServiceAPI.TokenAPI__c  = webConifTokenApi.id;
            webConifServiceAPI.Name  = 'LinkEligibilityMemberSearch';
            webConifServiceAPI.Timeout__c = 10000;
            RecordType recTypeWebServiceAPI = [SELECT Id FROM RecordType WHERE DeveloperName = 'Service_API' and SObjectType = 'WebserviceConfigurations__c'];
            webConifServiceAPI.RecordTypeId  = recTypeWebServiceAPI.id;
            insert webConifServiceAPI;
            OrgSpecificConfigurations__c orgSpecServiceAPI = new OrgSpecificConfigurations__c();
            RecordType recTypeOrgServiceAPI = [SELECT Id FROM RecordType WHERE DeveloperName = 'ServiceAPI' and SObjectType = 'OrgSpecificConfigurations__c'];
            orgSpecServiceAPI.RecordTypeId  = recTypeOrgServiceAPI.Id;
            orgSpecServiceAPI.Name = 'QA';
            orgSpecServiceAPI.EndpointDomain__c = 'https://api-gateway-stage.linkhealth.com';
            orgSpecServiceAPI.EnableMock__c  = false;
            orgSpecServiceAPI.WebserviceConfigurations__c = webConifServiceAPI.Id;
            insert orgSpecServiceAPI;
            
            WebserviceConfigurations__c  webConifServiceAPI2 = new WebserviceConfigurations__c ();
            webConifServiceAPI2.EndpointPath__c = '';
            webConifServiceAPI2.GrantType__c  = 'client_credentials';
            webConifServiceAPI2.Headers__c  = '[{"key":"Authorization","value":"Bearer <:AUTH_TOKEN:>"},{"key":"Content-Type","value":"application/json"},{"key":"actor","value":"ACET"}]';
            webConifServiceAPI2.AuthorizationToken__c  = 'SELECT AuthorizationToken__c FROM WebserviceConfigurations__c WHERE Name = LinkServiceTokenAPIToken';
            webConifServiceAPI2.Method__c  = 'GET';
            webConifServiceAPI2.TokenAPI__c  = webConifTokenApi.id;
            webConifServiceAPI2.Name  = 'SNI Eligibility API';
            webConifServiceAPI2.Timeout__c = 10000;
            //RecordType recTypeWebServiceAPI = [SELECT Id FROM RecordType WHERE DeveloperName = 'Service_API' and SObjectType = 'WebserviceConfigurations__c'];
            webConifServiceAPI2.RecordTypeId  = recTypeWebServiceAPI.id;
            insert webConifServiceAPI2;
            OrgSpecificConfigurations__c orgSpecServiceAPI2 = new OrgSpecificConfigurations__c();
            //RecordType recTypeOrgServiceAPI = [SELECT Id FROM RecordType WHERE DeveloperName = 'ServiceAPI' and SObjectType = 'OrgSpecificConfigurations__c'];
            orgSpecServiceAPI2.RecordTypeId  = recTypeOrgServiceAPI.Id;
            orgSpecServiceAPI2.Name = 'QA';
            orgSpecServiceAPI2.EndpointDomain__c = 'https://gateway-stage.optum.com/api/nonprod/cel/sni-riptide/eligibilities/v5/search';
            orgSpecServiceAPI2.EnableMock__c  = false;
            orgSpecServiceAPI2.WebserviceConfigurations__c = webConifServiceAPI2.Id;
            insert orgSpecServiceAPI2;
            
            WebserviceConfigurations__c  webConifExtendedServiceAPI = new WebserviceConfigurations__c ();
            webConifExtendedServiceAPI.EndpointPath__c = '/elink-extended/api/coverageAttributes/v2.0';
            webConifExtendedServiceAPI.GrantType__c  = 'client_credentials';
            webConifExtendedServiceAPI.Headers__c  = '[{"key":"Authorization","value":"Bearer <:AUTH_TOKEN:>"},{"key":"Content-Type","value":"application/json"},{"key":"actor","value":"ACET"}]';
            webConifExtendedServiceAPI.AuthorizationToken__c  = 'SELECT AuthorizationToken__c FROM WebserviceConfigurations__c WHERE Name = LinkServiceTokenAPIToken';
            webConifExtendedServiceAPI.Method__c  = 'GET';
            webConifExtendedServiceAPI.TokenAPI__c  = webConifTokenApi.id;
            webConifExtendedServiceAPI.Name  = 'LinkExtendedCoverage';
            webConifExtendedServiceAPI.Timeout__c = 10000;
            RecordType recTypeWebExtendedServiceAPI = [SELECT Id FROM RecordType WHERE DeveloperName = 'Service_API' and SObjectType = 'WebserviceConfigurations__c'];
            webConifExtendedServiceAPI.RecordTypeId  = recTypeWebExtendedServiceAPI.id;
            insert webConifExtendedServiceAPI;
            OrgSpecificConfigurations__c orgSpecExtendedServiceAPI = new OrgSpecificConfigurations__c();
            RecordType recTypeOrgExtebdedServiceAPI = [SELECT Id FROM RecordType WHERE DeveloperName = 'ServiceAPI' and SObjectType = 'OrgSpecificConfigurations__c'];
            orgSpecExtendedServiceAPI.RecordTypeId  = recTypeOrgExtebdedServiceAPI.Id;
            orgSpecExtendedServiceAPI.Name = 'QA';
            orgSpecExtendedServiceAPI.EndpointDomain__c = 'https://api-gateway-stage.linkhealth.com';
            orgSpecExtendedServiceAPI.EnableMock__c  = false;
            orgSpecExtendedServiceAPI.WebserviceConfigurations__c = webConifExtendedServiceAPI.Id;
            insert orgSpecExtendedServiceAPI;
            
            ACETServiceRelationshipMap__c rel = new ACETServiceRelationshipMap__c();
            rel.name = 'Subscriber/Recipient';
            rel.Service_Relationship__c = 'Subscriber';
            insert rel;
            
            Id personRTId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Individual').getRecordTypeId();
            User unassignedUser = [select id from User where Name ='Unassigned' limit 1];
            unassignedUser.UserRoleID = [Select Id From UserRole Where Name = 'Care Advisor' Limit 1].id;
            Update  unassignedUser;   
            Account personUser = new Account(
                Salutation = 'Mr.',
                FirstName = 'do',
                LastName = 'onboardz',
                PersonEmail = 'yarrodigitaladv1777@optum.com.acet',
                PersonDepartment = 'forDO-callout',
                PersonBirthdate = Date.valueOf('1960-01-01'),
                RecordTypeId = personRTId
            );
            insert personUser;
            Account acc = new Account();
            Id famRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Family').getRecordTypeId();
            acc.RecordTypeId  = famRecordTypeId;
            acc.OwnerId = unassignedUser.Id;
            acc.Member_ID__c='100020000';
            acc.Policy_ID__c='12345';
            acc.Name = 'Family Digital Onboarding';
            RecursiveTriggerHandler.restrictOwnerChange=false;
            insert acc;
            
            Family_Overview__c fo = new Family_Overview__c();
            fo.Account__c = acc.id;
            insert fo;
            
        }
    }
    @isTest static void linkElligibilityTest() 
    {
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new SNI_FL_DigitalOnboardingControllerMock(200,'LinkEligibilityAPI', 'eligible'));
        SNI_FL_DigitalOnboardingController.verifyUser('sss','AZDDD3','1970-10-29','656555621','');
        Test.stopTest();
    }
    @isTest static void linkElligibilityFullPolicyIdTest() 
    {
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new SNI_FL_DigitalOnboardingControllerMock(200,'LinkEligibilityAPI', 'eligible'));
        SNI_FL_DigitalOnboardingController.verifyUser('sss','AZDDD3','1970-10-29','656555621','123456789');
        Test.stopTest();
    }
    @isTest static void linkNotEligibleTest() 
    {
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new SNI_FL_DigitalOnboardingControllerMock(200,'LinkEligibilityAPI', 'not eligible'));
        SNI_FL_DigitalOnboardingController.verifyUser('Test','User','1970-10-29','123456789','999888777');
        Test.stopTest();
    }
    
    @isTest static void setNotificationPreferencesTest() 
    {
        Account personAccount = new Account();
        personAccount.firstName = 'EligibilityTest';
        personAccount.lastName = 'EligibilityTest';
        personAccount.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Individual').getRecordTypeId();
        insert personAccount;
        Test.startTest();
        //Test.setMock(HttpCalloutMock.class, new SNI_FL_DigitalOnboardningControllerMock(200,'LinkEligibilityAPI', 'eligible'));
        SNI_FL_DigitalOnboardingController.setNotificationPreferences(true, true, personAccount.Id);
        Test.stopTest();
        Account aCheck = [Select Id, Email_Notification__c FROM Account WHERE ID = :personAccount.Id LIMIT 1];
        System.assertEquals(true, aCheck.Email_Notification__c);
    }
    @istest static void registerUsertest(){
        
        Id recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Family').getRecordTypeId();
        List<ISL_Webservice_Config__c> webConfigList=new List<ISL_Webservice_Config__c>();
        ISL_Webservice_Config__c webConfig1 = new ISL_Webservice_Config__c();
        webConfig1.Name = 'dev_SNI_FL_Notification_AuthEndPoint';
        webConfig1.ACET_Common_Name__c = 'SNI FL Notification AuthEndPoint';
        webConfig1.Value__c = 'https://gateway-stage.optum.com/auth/oauth2/cached/token';
        webConfigList.add(webConfig1);
        
        
        ISL_Webservice_Config__c webConfig2 = new ISL_Webservice_Config__c();
        webConfig2.Name = 'dev_SNI_FL_Notification_ClientSecret';
        webConfig2.ACET_Common_Name__c = 'SNI FL Notification ClientSecret';
        webConfig2.Value__c = '0X8HKY8BIF1KqnuEuDDk435afQTU6dND';
        webConfigList.add(webConfig2);
        
        ISL_Webservice_Config__c webConfig3 = new ISL_Webservice_Config__c();
        webConfig3.Name = 'dev_SNI_FL_Notification_ClientID';
        webConfig3.ACET_Common_Name__c = 'SNI FL Notification ClientSecret';
        webConfig3.Value__c = 'R5zUdTcSaEMWHPQ8lylXr7ktDCOUKFcQ';
        webConfigList.add(webConfig3);
        
        
        ISL_Webservice_Config__c webConfig4 = new ISL_Webservice_Config__c();
        webConfig4.Name = 'dev_SNI_FL_Notification_ProgramID';
        webConfig4.ACET_Common_Name__c = 'SNI FL Notification Program ID';
        webConfig4.Value__c = '501345';
        webConfigList.add(webConfig4);        
        //
        ISL_Webservice_Config__c webConfig5 = new ISL_Webservice_Config__c();
        webConfig5.Name = 'dev_SNI_FL_Notification_EmailEndPoint1';
        webConfig5.ACET_Common_Name__c = 'SNI FL Notification EmailEndPoint';
        webConfig5.Value__c = 'https://gateway-stage.optum.com/api/test/ccs/comm/communications/electronic-mails/v2';
        webConfigList.add(webConfig5);    
        
        ISL_Webservice_Config__c webConfig6 = new ISL_Webservice_Config__c();
        webConfig6.Name = 'dev_SNI_FL_Notification_SMSEndPoint';
        webConfig6.ACET_Common_Name__c = 'SNI FL Notification SMSEndPoint';
        webConfig6.Value__c = 'https://gateway-stage.optum.com/api/test/ccs/comm/communications/text-messages/v2';
        webConfigList.add(webConfig6); 
        
        insert webConfigList;
        
        User unassignedUser = [select id from User where Name ='Unassigned' limit 1];
        List<Account> accList=new List<Account>();
        Account ac = new Account();
        ac.OwnerId = unassignedUser.Id;
        ac.Member_ID__c = '453543145';
        ac.Policy_ID__c = '0070145';
        ac.Name =   'FLTestAcc';
        ac.RecordTypeId = recordTypeId;
        accList.add(ac);
        insert accList;
        Datetime dtd = system.now();
        String dtdstr = String.valueOf(dtd);
        SNI_FL_DigitalOnboardingController.registerUser(dtdstr,'234567','userName@test.com','1111111111', false, dtdstr, 'userName@test.com.acet','Password@123', 'firstName','lastName', ac.Id);
        SNI_FL_DigitalOnboardingController.verificationCodeGeneration('(202) 795-1234','userName@test.com','true','');
        SNI_FL_DigitalOnboardingController.verifyUser('firstName','lastName',dtdstr,'453543145','453543145');
        
    }
    @isTest
    public static void accountValidationUserTest(){
        UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
        Profile profile1 = [Select Id from Profile where name = 'System Administrator'];
        User portalAccountOwner1 = new User(
            UserRoleId = portalRole.Id,
            ProfileId = profile1.Id,
            Username = System.now().millisecond() + 'zzznpDOnboard@optum.com.acet',
            Alias = 'batman',
            Email='zzznpDOnboard@optum.com.acet',
            EmailEncodingKey='UTF-8',
            Firstname='yarroDO',
            Lastname='yavanoDO',
            LanguageLocaleKey='en_US',
            LocaleSidKey='en_US',
            TimeZoneSidKey='America/Chicago');
        Database.insert(portalAccountOwner1);
        System.runAs ( portalAccountOwner1 ) {
            Id personRTId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Individual').getRecordTypeId();
            Account personUser = new Account(
                Salutation = 'Mr.',
                FirstName = 'digital',
                LastName = 'onboard4',
                PersonEmail = 'yarrodigitalonb@optum.com.acet',
                RecordTypeId = personRTId
            );
            insert personUser;
            Contact c = [SELECT Id FROM Contact WHERE AccountId =: personuser.Id];
            User user = new User();
            user.ProfileID = [Select Id From Profile Where Name='Care Advisor Connect Community User'].id;
            user.EmailEncodingKey = 'ISO-8859-1';
            user.LanguageLocaleKey = 'en_US';
            user.TimeZoneSidKey = 'America/New_York';
            user.LocaleSidKey = 'en_US';
            user.FirstName = 'yarroDOb';
            user.LastName = 'yevvanohe';
            user.Username = 'ABCD1234DOb@optum.com.acet';
            user.CommunityNickname = 'testUser123Dob';
            user.Alias = 't12';
            user.Email = 'noyarroDOb@optum.com.acet';
            user.IsActive = true;
            user.ContactId = c.Id;
            insert user;
            system.assertEquals('Error-UserPresent', SNI_FL_DigitalOnboardingController.accountValidation(null,personUser.Id,null,null,null,null,null));
        }
    }
    @isTest
    public static void accountValidationFOTest(){
        //  Date dob = Date.parse('10/29/1970');
        Date dob=system.today();
        Id personRTId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Individual').getRecordTypeId();
        Account personUser = new Account(
            Salutation = 'Mr.',
            FirstName = 'digitali',
            LastName = 'onboard4',
            PersonEmail = 'yarrodigitalonb1@optum.com.acet',
            RecordTypeId = personRTId
        );
        insert personUser;
        User unassignedUser = [select id from User where Name ='Unassigned' limit 1];
        Account acc = new Account();
        Id famRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Family').getRecordTypeId();
        acc.OwnerId = unassignedUser.Id;
        acc.RecordTypeId  = famRecordTypeId;
        acc.Name = 'Family Digital Onboardng';
        insert acc;
        Family_Overview__c fo = new Family_Overview__c();
        fo.Designation__c = 'Assigned';
        fo.Account__c = acc.id;
        insert fo;
        SNI_FL_DigitalOnboardingController.accountValidation(acc.Id,personUser.Id,null,null,null,null,null);
        system.assertEquals('Digital Onboard', [select First_Family_Contact_Into_Center__c from Family_Overview__c where Id=:fo.Id].First_Family_Contact_Into_Center__c);
        Test.startTest();
        Account accf = new Account();
        accf.OwnerId = unassignedUser.Id;
        accf.RecordTypeId  = famRecordTypeId;
        accf.Name = 'Family for multipolicy';
        insert accf;
        account pa1 = [select id,personcontactid from account where id =: personUser.id];
        AccountContactRelation acr = new AccountContactRelation();
        acr.ContactId = pa1.personcontactid;            
        acr.Accountid = acc.id;
        acr.Relationship__c = 'Child/Other';
        insert acr;
        system.assertnotEquals('Error', SNI_FL_DigitalOnboardingController.accountValidation(accf.Id,null,null,null,personUser.FirstName,personUser.LastName,dob));
        AccountContactRelation acr1 = new AccountContactRelation();
        acr1.ContactId = pa1.personcontactid;            
        acr1.Accountid = accf.id;
        acr1.Relationship__c = 'Child/Other';
        insert acr1;
        system.assertEquals('Error', SNI_FL_DigitalOnboardingController.accountValidation(accf.Id,personUser.Id,null,null,null,null,null));
        Test.stopTest();
    }    
    @isTest 
    public static void testUserEmailCheck() {
        Profile prof = [select id from profile where name LIKE '%Standard User%' limit 1];
        User u = new User(Alias = 'standt', Email='standarduser@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', profileId = prof.Id,
                          TimeZoneSidKey='America/Los_Angeles', UserName= 'digitalonboardtest3@testorg.com');
        insert u;
        String emailAddress = u.Email;
        String unusedEmailAddress = '32j43kjsd9f' + u.Email;
        Test.startTest();
        //System.assertEquals(SNI_FL_DigitalOnboardingController.emailInUse(emailAddress), true);
        System.assertEquals(SNI_FL_DigitalOnboardingController.emailInUse(unusedEmailAddress), false);
        Test.stopTest();
    }
    
    @isTest
    public static void testGetOrgName(){
        Digital_Onboarding_SMS_Verification__c vs = new Digital_Onboarding_SMS_Verification__c(Code__c = '123456');
        insert vs;
        Test.startTest();
        String code = SNI_FL_DigitalOnboardingController.getOrgName();
        Test.stopTest();
        System.assertEquals('123456', code);
    }
    @isTest
    public static void testCallout(){
        Id personId = [select Id from account where PersonDepartment = 'forDO-callout' limit 1].Id;
        account pa1 = [select id,personcontactid from account where id =: personId];
        Account fam = [select Id from account where policy_id__c = '12345' limit 1];
        User unassignedUser = [select id from User where Name ='Unassigned' limit 1];
        test.startTest();
        system.runAs (unassignedUser) {
            AccountContactRelation acr = new AccountContactRelation();
            acr.ContactId = pa1.personcontactid;            
            acr.Accountid = fam.id;
            acr.Relationship__c = 'Child/Other';
            insert acr;
            SNI_FL_DigitalOnboardingController.callEHUBUpdateAPI(personId);
        }
        test.stopTest();      
    }
    @isTest
    public static void testCallout1(){
        Id personId = [select Id from account where PersonDepartment = 'forDO-callout' limit 1].Id;
        account pa1 = [select id,personcontactid from account where id =: personId];
        Account fam = [select Id from account where policy_id__c = '12345' limit 1];
        User unassignedUser = [select id from User where Name ='Unassigned' limit 1];
        test.startTest();
        System.runAs(unassignedUser) {
            AccountContactRelation acr = new AccountContactRelation();
            acr.ContactId = pa1.personcontactid;            
            acr.Accountid = fam.id;
            acr.Relationship__c = 'Child/Other';
            insert acr;
            Round_Robin_Queue__c roundRobin = Round_Robin_Queue__c.getOrgDefaults();
            roundRobin.Last_Assigned_Advisor__c=[select name from DigitalOnboardingAdvisorAssignment__c where name__r.name ='advtwo advtwo' limit 1].name;
            update roundRobin;
            SNI_FL_DigitalOnboardingController.callEHUBUpdateAPI(personId);
        }
        test.stopTest();      
    }
    @isTest
    public static void testCallout2(){
        Id personId = [select Id from account where PersonDepartment = 'forDO-callout' limit 1].Id;
        account pa1 = [select id,personcontactid from account where id =: personId];
        Account fam = [select Id from account where policy_id__c = '12345' limit 1];
        User unassignedUser = [select id from User where Name ='Unassigned' limit 1];
        test.startTest();
        system.runAs (unassignedUser) {
            AccountContactRelation acr = new AccountContactRelation();
            acr.ContactId = pa1.personcontactid;            
            acr.Accountid = fam.id;
            acr.Relationship__c = 'Child/Other';
            insert acr;
            Round_Robin_Queue__c roundRobin = Round_Robin_Queue__c.getOrgDefaults();
            roundRobin.Last_Assigned_Advisor__c=[select name from DigitalOnboardingAdvisorAssignment__c where name__r.name ='advthree advthree' limit 1].name;
            update roundRobin;
            SNI_FL_DigitalOnboardingController.callEHUBUpdateAPI(personId);
        }
        test.stopTest();      
    }
    @isTest
    public static void testCallout3(){
        Id personId = [select Id from account where PersonDepartment = 'forDO-callout' limit 1].Id;
        account pa1 = [select id,personcontactid from account where id =: personId];
        Account fam = [select Id from account where policy_id__c = '12345' limit 1];
        User unassignedUser = [select id from User where Name ='Unassigned' limit 1];
        test.startTest();
        
            AccountContactRelation acr = new AccountContactRelation();
            acr.ContactId = pa1.personcontactid;            
            acr.Accountid = fam.id;
            acr.Relationship__c = 'Child/Other';
            insert acr;
            list<DigitalOnboardingAdvisorAssignment__c> abc = [select Id from DigitalOnboardingAdvisorAssignment__c limit 2];
            delete abc;
        system.runAs (unassignedUser) {
            SNI_FL_DigitalOnboardingController.callEHUBUpdateAPI(personId);
        }
        test.stopTest();      
    }
}