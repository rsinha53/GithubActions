/********************************************************************************* 
Class Name     : SNI_FL_Notification_Center.cls
Description    : 
Created By     : Bastine Sebastyan
Created Date   : 

Modification Log
---------------------------------------------------------------------------------- 
Developer                   Date                   Description

1.Bastine Sebastyan         9/29/2020               Test clas for Notification center
----------------------------------------------------------------------------------            

*********************************************************************************/
@IsTest
public class SNI_FL_Notification_Center_Test {
    @testSetup static void setupData() {
        Account acc = new Account();
        acc.FirstName = 'First Name';
        acc.LastName = 'Last Name';
        acc.RecordTypeId = PC_TestUtility.getRecordTypeId('Account','Individual');
        insert acc;
        
        Contact cnt =[select id from Contact where  AccountID =: acc.id];
        
        User rescuUser;
        system.runAs(new user(Id = userinfo.getUserId())){
            rescuUser = PC_TestUtility.getUser('Care Advisor Connect Provider User', 'test@testorg.com');
            rescuUser.ContactId = cnt.id;
            rescuUser.FirstName = 'First Name';
            rescuUser.LastName = 'Last Name';
            rescuUser.MobilePhone = '1234567890';
            rescuUser.Email = 'meghanagolla@rallyhealth.com';
            insert rescuUser;
        }
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
        webConfig5.Name = 'dev_SNI_FL_Notification_EmailEndPoint';
        webConfig5.ACET_Common_Name__c = 'SNI FL Notification EmailEndPoint';
        webConfig5.Value__c = 'https://gateway-stage.optum.com/api/test/ccs/comm/communications/electronic-mails/v2';
        webConfigList.add(webConfig5);    
        
        ISL_Webservice_Config__c webConfig6 = new ISL_Webservice_Config__c();
        webConfig6.Name = 'dev_SNI_FL_Notification_SMSEndPoint';
        webConfig6.ACET_Common_Name__c = 'SNI FL Notification SMSEndPoint';
        webConfig6.Value__c = 'https://gateway-stage.optum.com/api/test/ccs/comm/communications/text-messages/v2';
        webConfigList.add(webConfig6); 
        
        ISL_Webservice_Config__c webConfig7 = new ISL_Webservice_Config__c();
        webConfig7.Name = 'dev_SNI_FL_DO_Notification_ProgramID';
        webConfig7.ACET_Common_Name__c = 'SNI FL Notification Program ID';
        webConfig7.Value__c = '501345';
        webConfigList.add(webConfig7); 
        
        insert webConfigList; 
        WebserviceConfigurations__c newrec2=new WebserviceConfigurations__c();
        newrec2.active__c=true;
        newrec2.name='SMS subscribePhoneID';
        newrec2.Method__c='POST';
        newrec2.Headers__c='[{"key":"Authorization","value":"Bearer <:AUTH_TOKEN:>"},{"key":"Content-Type","value":"application/json"},{"key":"actor","value":"ACET"}]';
        newrec2.JSONBodyWithMergeFields__c='{\n\"id\": \"00411796502\",\n\"idType\": \"searchid\",\n\"dateOfBirth\": \"1995-11-21\"\n}';
        newrec2.EndpointPath__c='https://api-stg.uhg.com/api/identity/user/individuals/v1/search';
        insert newrec2;
        
        WebserviceConfigurations__c newrec=new WebserviceConfigurations__c();
        newrec.active__c=true;
        newrec.name='SMS GeneratePhoneId';
        newrec.Method__c='POST';
        newrec.Headers__c='[{"key":"Authorization","value":"Bearer <:AUTH_TOKEN:>"},{"key":"Content-Type","value":"application/json"},{"key":"actor","value":"ACET"}]';
        newrec.JSONBodyWithMergeFields__c='{\n\"id\": \"00411796502\",\n\"idType\": \"searchid\",\n\"dateOfBirth\": \"1995-11-21\"\n}';
        newrec.EndpointPath__c='https://api-stg.uhg.com/api/identity/user/individuals/v1/search';
        insert newrec;
        
        Organization_Properties__c orgProps = Organization_Properties__c.getOrgDefaults();
        orgProps.OrganizationName__c = 'QA';
        Upsert orgProps;
        
        
        // Token API data
        WebserviceConfigurations__c tokenAPIWSConfig = createTokenWSConfigs('StarGateTokenAPI');
        OrgSpecificConfigurations__c tokenAPIOrgSpecificConfigs = createTokenOrgWSConfigs(tokenAPIWSConfig.Id);
        WebserviceConfigurations__c authTokenWSConfig = createAuthTokenWSConfig('StarGateTokenAPI');
        
        // Service API data
        WebserviceConfigurations__c wsConfig = createWSConfig('NOTIFICATION_TYPE_EMAIL', tokenAPIWSConfig.Id,'/api/test/ccs/comm/communications/electronic-mails/v2');
        OrgSpecificConfigurations__c orgSpecificConfigs = createOrgWSConfigs(wsConfig.Id);
        WebserviceConfigurations__c wsConfig1 = createWSConfig('NOTIFICATION_TYPE_SMS', tokenAPIWSConfig.Id,'/api/test/ccs/comm/communications/text-messages/v2');
        OrgSpecificConfigurations__c orgSpecificConfigs1 = createOrgWSConfigs(wsConfig1.Id);
    }
    
    @istest static void testNotificationNotSetWithNoPreference()
    {
        User usr = [select id,Contactid,Contact.AccountId from User where UserName =: 'test@testorg.com'];
        Account acc = [select id,Email_Notification__c,Last_Notification_Timestamp__c from Account where Id =: usr.Contact.AccountID];
        
        SNI_FL_Notification_Center center = new SNI_FL_Notification_Center();
        SNI_FL_Notification_Result result = center.SendNotificationMethod(usr.id);
        System.assertEquals(result.EmailSent, false);
        System.assertEquals(result.SMSSent, false);
        System.assertEquals(result.SMSStatusText, Label.SNI_FL_Not_Opted_SMS);
        System.assertEquals(result.EmailStatusText, Label.SNI_FL_Not_Opted_Email);
        
        result = center.SendNotificationMethod(usr.Contactid);
        System.assertEquals(result.EmailSent, false);
        System.assertEquals(result.SMSSent, false);
        System.assertEquals(result.SMSStatusText, Label.SNI_FL_Not_Opted_SMS);
        System.assertEquals(result.EmailStatusText, Label.SNI_FL_Not_Opted_Email);
        
        
        result = center.SendNotificationMethod(usr.Contact.AccountId);
        System.assertEquals(result.EmailSent, false);
        System.assertEquals(result.SMSSent, false);
        System.assertEquals(result.SMSStatusText, Label.SNI_FL_Not_Opted_SMS);
        System.assertEquals(result.EmailStatusText, Label.SNI_FL_Not_Opted_Email);
    }
    @istest static void testNotificationNotSetWithEmailPreferenceTimeStamp()
    {
        User usr = [select id,Contactid,Contact.AccountId from User where UserName =: 'test@testorg.com'];
        Account acc = [select id,Email_Notification__c,Last_Notification_Timestamp__c from Account where Id =: usr.Contact.AccountID];
        acc.Email_Notification__c = true;
        acc.Last_Notification_Timestamp__c = datetime.now().addminutes(-20);
        update acc;
        WebserviceConfigurations__c newrec2=new WebserviceConfigurations__c();
        newrec2.active__c=true;
        newrec2.name='SMS subscribePhoneID';
        newrec2.Method__c='POST';
        newrec2.Headers__c='[{"key":"Authorization","value":"Bearer <:AUTH_TOKEN:>"},{"key":"Content-Type","value":"application/json"},{"key":"actor","value":"ACET"}]';
        newrec2.JSONBodyWithMergeFields__c='{\n\"id\": \"00411796502\",\n\"idType\": \"searchid\",\n\"dateOfBirth\": \"1995-11-21\"\n}';
        newrec2.EndpointPath__c='https://api-stg.uhg.com/api/identity/user/individuals/v1/search';
        insert newrec2;
        WebserviceConfigurations__c newrec1=new WebserviceConfigurations__c();
        newrec1.active__c=true;
        newrec1.name='SMS Authorization';
        newrec1.Method__c='POST';
        newrec1.Headers__c='[{"key":"Authorization","value":"Bearer <:AUTH_TOKEN:>"},{"key":"Content-Type","value":"application/json"},{"key":"actor","value":"ACET"}]';
        newrec1.JSONBodyWithMergeFields__c='{\n\"id\": \"00411796502\",\n\"idType\": \"searchid\",\n\"dateOfBirth\": \"1995-11-21\"\n}';
        newrec1.EndpointPath__c='https://api-stg.uhg.com/api/identity/user/individuals/v1/search';
        insert newrec1;
        WebserviceConfigurations__c newrec=new WebserviceConfigurations__c();
        newrec.active__c=true;
        newrec.name='SMS GeneratePhoneId';
        newrec.Method__c='POST';
        newrec.Headers__c='[{"key":"Authorization","value":"Bearer <:AUTH_TOKEN:>"},{"key":"Content-Type","value":"application/json"},{"key":"actor","value":"ACET"}]';
        newrec.JSONBodyWithMergeFields__c='{\n\"id\": \"00411796502\",\n\"idType\": \"searchid\",\n\"dateOfBirth\": \"1995-11-21\"\n}';
        newrec.EndpointPath__c='https://api-stg.uhg.com/api/identity/user/individuals/v1/search';
        insert newrec;
        Test.StartTest();
        Test.setMock(HttpCalloutMock.class, new ExampleCalloutMock1());
        
        SNI_FL_Notification_Center center = new SNI_FL_Notification_Center();
        try{
            SNI_FL_Notification_Result result = center.SendNotificationMethod(usr.id);
            System.assertEquals(result.EmailSent, false);
            System.assertEquals(result.SMSSent, false);
            System.assertEquals(result.SMSStatusText, Label.SNI_FL_Notification_Time_Interval_Message);
            System.assertEquals(result.EmailStatusText, Label.SNI_FL_Notification_Time_Interval_Message);
        }catch(Exception e){}
    }
    @istest static void testNotificationNotSetWithEmailPreference()
    {
        User usr = [select id,Contactid,Contact.AccountId from User where UserName =: 'test@testorg.com'];
        Account acc = [select id,Email_Notification__c,Last_Notification_Timestamp__c from Account where Id =: usr.Contact.AccountID];
        acc.Email_Notification__c = true;
        update acc;
        
        Account acc1 = [select id,Email_Notification__c,Last_Notification_Timestamp__c from Account where Id =: usr.Contact.AccountID];
        system.debug('acc1111:'+acc1);
        WebserviceConfigurations__c newrec2=new WebserviceConfigurations__c();
        newrec2.active__c=true;
        newrec2.name='SMS subscribePhoneID';
        newrec2.Method__c='POST';
        newrec2.Headers__c='[{"key":"Authorization","value":"Bearer <:AUTH_TOKEN:>"},{"key":"Content-Type","value":"application/json"},{"key":"actor","value":"ACET"}]';
        newrec2.JSONBodyWithMergeFields__c='{\n\"id\": \"00411796502\",\n\"idType\": \"searchid\",\n\"dateOfBirth\": \"1995-11-21\"\n}';
        newrec2.EndpointPath__c='https://api-stg.uhg.com/api/identity/user/individuals/v1/search';
        insert newrec2;
        WebserviceConfigurations__c newrec1=new WebserviceConfigurations__c();
        newrec1.active__c=true;
        newrec1.name='SMS Authorization';
        newrec1.Method__c='POST';
        newrec1.Headers__c='[{"key":"Authorization","value":"Bearer <:AUTH_TOKEN:>"},{"key":"Content-Type","value":"application/json"},{"key":"actor","value":"ACET"}]';
        newrec1.JSONBodyWithMergeFields__c='{\n\"id\": \"00411796502\",\n\"idType\": \"searchid\",\n\"dateOfBirth\": \"1995-11-21\"\n}';
        newrec1.EndpointPath__c='https://api-stg.uhg.com/api/identity/user/individuals/v1/search';
        insert newrec1;
        WebserviceConfigurations__c newrec=new WebserviceConfigurations__c();
        newrec.active__c=true;
        newrec.name='SMS GeneratePhoneId';
        newrec.Method__c='POST';
        newrec.Headers__c='[{"key":"Authorization","value":"Bearer <:AUTH_TOKEN:>"},{"key":"Content-Type","value":"application/json"},{"key":"actor","value":"ACET"}]';
        newrec.JSONBodyWithMergeFields__c='{\n\"id\": \"00411796502\",\n\"idType\": \"searchid\",\n\"dateOfBirth\": \"1995-11-21\"\n}';
        newrec.EndpointPath__c='https://api-stg.uhg.com/api/identity/user/individuals/v1/search';
        insert newrec;
        Test.StartTest();
        Test.setMock(HttpCalloutMock.class, new ExampleCalloutMock1());
        
        SNI_FL_Notification_Center center = new SNI_FL_Notification_Center();
        try{
            SNI_FL_Notification_Result result = center.SendNotificationMethod(usr.id);
            system.debug('resultresult:'+result);
            System.assertEquals(result.EmailSent, true);
            System.assertEquals(result.SMSSent, false);
            System.assertEquals(result.SMSStatusText, Label.SNI_FL_Not_Opted_SMS);
            //System.assertEquals(result.EmailStatusText, Label.SNI_FL_Callout_Successful);
            
            
            
            result = center.SendNotificationMethod(usr.id);
            System.assertEquals(result.EmailSent, false);
            System.assertEquals(result.SMSSent, false);
            System.assertEquals(result.SMSStatusText, Label.SNI_FL_Notification_Time_Interval_Message);
            System.assertEquals(result.EmailStatusText, Label.SNI_FL_Notification_Time_Interval_Message);
            //System.assertEquals(result.EmailStatusText, Label.SNI_FL_Callout_Fail);SNI_FL_Notification_Time_Interval_Message
            Test.StopTest();
        }catch(Exception e){}
        
    } 
    
    @istest static void testNotificationNotSetWithSMSPreference()
    {
        User usr = [select id,Contactid,Contact.AccountId from User where UserName =: 'test@testorg.com'];
        Account acc = [select id,Text_Message_SMS_Notification__c from Account where Id =: usr.Contact.AccountID];
        acc.Text_Message_SMS_Notification__c = true;
        update acc;
        WebserviceConfigurations__c newrec2=new WebserviceConfigurations__c();
        newrec2.active__c=true;
        newrec2.name='SMS subscribePhoneID';
        newrec2.Method__c='POST';
        newrec2.Headers__c='[{"key":"Authorization","value":"Bearer <:AUTH_TOKEN:>"},{"key":"Content-Type","value":"application/json"},{"key":"actor","value":"ACET"}]';
        newrec2.JSONBodyWithMergeFields__c='{\n\"id\": \"00411796502\",\n\"idType\": \"searchid\",\n\"dateOfBirth\": \"1995-11-21\"\n}';
        newrec2.EndpointPath__c='https://api-stg.uhg.com/api/identity/user/individuals/v1/search';
        insert newrec2;
        WebserviceConfigurations__c newrec1=new WebserviceConfigurations__c();
        newrec1.active__c=true;
        newrec1.name='SMS Authorization';
        newrec1.Method__c='POST';
        newrec1.Headers__c='[{"key":"Authorization","value":"Bearer <:AUTH_TOKEN:>"},{"key":"Content-Type","value":"application/json"},{"key":"actor","value":"ACET"}]';
        newrec1.JSONBodyWithMergeFields__c='{\n\"id\": \"00411796502\",\n\"idType\": \"searchid\",\n\"dateOfBirth\": \"1995-11-21\"\n}';
        newrec1.EndpointPath__c='https://api-stg.uhg.com/api/identity/user/individuals/v1/search';
        insert newrec1;
        WebserviceConfigurations__c newrec=new WebserviceConfigurations__c();
        newrec.active__c=true;
        newrec.name='SMS GeneratePhoneId';
        newrec.Method__c='POST';
        newrec.Headers__c='[{"key":"Authorization","value":"Bearer <:AUTH_TOKEN:>"},{"key":"Content-Type","value":"application/json"},{"key":"actor","value":"ACET"}]';
        newrec.JSONBodyWithMergeFields__c='{\n\"id\": \"00411796502\",\n\"idType\": \"searchid\",\n\"dateOfBirth\": \"1995-11-21\"\n}';
        newrec.EndpointPath__c='https://api-stg.uhg.com/api/identity/user/individuals/v1/search';
        insert newrec;
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new ExampleCalloutMock1());
        
        
        SNI_FL_Notification_Center center = new SNI_FL_Notification_Center();
        SNI_FL_Notification_Result result = center.SendNotificationMethod(usr.id);
                SNI_FL_Notification_SendResponse result1 = center.SendEmailNotification('test@gmail.com','panduu','Test Subject','HI Pandu');

        System.assertEquals(result.EmailSent, false);
        //System.assertEquals(result.SMSSent, true);
       // System.assertEquals(result.SMSStatusText, Label.SNI_FL_Callout_Successful);
        //System.assertEquals(result.EmailStatusText, Label.SNI_FL_Not_Opted_Email);
        Test.StopTest();
        
    }
    
    @istest static void testNotificationNotSetWithSMSPreferenceNoMobile()
    {
        User usr = [select id,Contactid,Contact.AccountId from User where UserName =: 'test@testorg.com'];
        Account acc = [select id,Text_Message_SMS_Notification__c from Account where Id =: usr.Contact.AccountID];
        acc.Text_Message_SMS_Notification__c = true;
        update acc;
        WebserviceConfigurations__c newrec2=new WebserviceConfigurations__c();
        newrec2.active__c=true;
        newrec2.name='SMS subscribePhoneID';
        newrec2.Method__c='POST';
        newrec2.Headers__c='[{"key":"Authorization","value":"Bearer <:AUTH_TOKEN:>"},{"key":"Content-Type","value":"application/json"},{"key":"actor","value":"ACET"}]';
        newrec2.JSONBodyWithMergeFields__c='{\n\"id\": \"00411796502\",\n\"idType\": \"searchid\",\n\"dateOfBirth\": \"1995-11-21\"\n}';
        newrec2.EndpointPath__c='https://api-stg.uhg.com/api/identity/user/individuals/v1/search';
        insert newrec2;
        WebserviceConfigurations__c newrec1=new WebserviceConfigurations__c();
        newrec1.active__c=true;
        newrec1.name='SMS Authorization';
        newrec1.Method__c='POST';
        newrec1.Headers__c='[{"key":"Authorization","value":"Bearer <:AUTH_TOKEN:>"},{"key":"Content-Type","value":"application/json"},{"key":"actor","value":"ACET"}]';
        newrec1.JSONBodyWithMergeFields__c='{\n\"id\": \"00411796502\",\n\"idType\": \"searchid\",\n\"dateOfBirth\": \"1995-11-21\"\n}';
        newrec1.EndpointPath__c='https://api-stg.uhg.com/api/identity/user/individuals/v1/search';
        insert newrec1;
        WebserviceConfigurations__c newrec=new WebserviceConfigurations__c();
        newrec.active__c=true;
        newrec.name='SMS GeneratePhoneId';
        newrec.Method__c='POST';
        newrec.Headers__c='[{"key":"Authorization","value":"Bearer <:AUTH_TOKEN:>"},{"key":"Content-Type","value":"application/json"},{"key":"actor","value":"ACET"}]';
        newrec.JSONBodyWithMergeFields__c='{\n\"id\": \"00411796502\",\n\"idType\": \"searchid\",\n\"dateOfBirth\": \"1995-11-21\"\n}';
        newrec.EndpointPath__c='https://api-stg.uhg.com/api/identity/user/individuals/v1/search';
        insert newrec;
        Test.StartTest();
        
        Test.setMock(HttpCalloutMock.class, new ExampleCalloutMock1());
        
        /*Cache.Org.put('local.AcetCHS.SNIFLNotificationExpiresInCache' , 600);
Cache.Org.put('local.AcetCHS.SNIFLNotificationTokenCache' , 'AccessToken');
Cache.Org.put('local.AcetCHS.SNIFLNotificationTimeStampCache', DateTime.now());*/
        
        SNI_FL_Notification_Center.SendNotification(usr.id);
        SNI_FL_Notification_Center.SendNotificationNonFuture(usr.id);
    }
    @istest static void WelcomeMessage()
    {
        User usr = [select id,Contactid,Contact.AccountId,MobilePhone from User where UserName =: 'test@testorg.com'];
        Account acc = [select id,Text_Message_SMS_Notification__c from Account where Id =: usr.Contact.AccountID];
        WebserviceConfigurations__c newrec2=new WebserviceConfigurations__c();
        newrec2.active__c=true;
        newrec2.name='SMS subscribePhoneID';
        newrec2.Method__c='POST';
        newrec2.Headers__c='[{"key":"Authorization","value":"Bearer <:AUTH_TOKEN:>"},{"key":"Content-Type","value":"application/json"},{"key":"actor","value":"ACET"}]';
        newrec2.JSONBodyWithMergeFields__c='{\n\"id\": \"00411796502\",\n\"idType\": \"searchid\",\n\"dateOfBirth\": \"1995-11-21\"\n}';
        newrec2.EndpointPath__c='https://api-stg.uhg.com/api/identity/user/individuals/v1/search';
        insert newrec2;
        WebserviceConfigurations__c newrec1=new WebserviceConfigurations__c();
        newrec1.active__c=true;
        newrec1.name='SMS Authorization';
        newrec1.Method__c='POST';
        newrec1.Headers__c='[{"key":"Authorization","value":"Bearer <:AUTH_TOKEN:>"},{"key":"Content-Type","value":"application/json"},{"key":"actor","value":"ACET"}]';
        newrec1.JSONBodyWithMergeFields__c='{\n\"id\": \"00411796502\",\n\"idType\": \"searchid\",\n\"dateOfBirth\": \"1995-11-21\"\n}';
        newrec1.EndpointPath__c='https://api-stg.uhg.com/api/identity/user/individuals/v1/search';
        insert newrec1;
        WebserviceConfigurations__c newrec=new WebserviceConfigurations__c();
        newrec.active__c=true;
        newrec.name='SMS GeneratePhoneId';
        newrec.Method__c='POST';
        newrec.Headers__c='[{"key":"Authorization","value":"Bearer <:AUTH_TOKEN:>"},{"key":"Content-Type","value":"application/json"},{"key":"actor","value":"ACET"}]';
        newrec.JSONBodyWithMergeFields__c='{\n\"id\": \"00411796502\",\n\"idType\": \"searchid\",\n\"dateOfBirth\": \"1995-11-21\"\n}';
        newrec.EndpointPath__c='https://api-stg.uhg.com/api/identity/user/individuals/v1/search';
        insert newrec;
        Test.StartTest();
        
        Test.setMock(HttpCalloutMock.class,new ExampleCalloutMock1())  ;
        new SNI_FL_Notification_Center().sendSMSNotification(usr.MobilePhone, 'First Name');
        Test.stopTest();
    }
    
    public static WebserviceConfigurations__c createTokenWSConfigs (String serviceName) {
        WebserviceConfigurations__c tokenAPIWSConfig = new WebserviceConfigurations__c(
            Name = serviceName,
            RecordTypeId = Schema.SObjectType.WebserviceConfigurations__c.getRecordTypeInfosByName().get('Token API').getRecordTypeId(),
            Method__c = 'POST',
            Headers__c = '[{"key":"Content-Type","value":"application/x-www-form-urlencoded"}]',
            EndpointPath__c = '/auth/oauth2/cached/token',
            AuthorizationToken__c = '',
            GrantType__c = 'client_credentials',
            Timeout__c = 1000
        );
        Insert tokenAPIWSConfig;
        return tokenAPIWSConfig;
    }
    
    public static OrgSpecificConfigurations__c createTokenOrgWSConfigs (Id wsConfigId) {
        OrgSpecificConfigurations__c tokenAPIOrgSpecificConfigs = new OrgSpecificConfigurations__c(
            WebserviceConfigurations__c = wsConfigId,
            Name = 'QA',
            RecordTypeId = Schema.SObjectType.OrgSpecificConfigurations__c.getRecordTypeInfosByName().get('Token API').getRecordTypeId(),
            EndpointDomain__c = 'https://gateway-stage.optum.com',
            EnableErrorLog__c = true
        );
        Insert tokenAPIOrgSpecificConfigs;
        return tokenAPIOrgSpecificConfigs;
    }
    
    public static WebserviceConfigurations__c createAuthTokenWSConfig (String serviceName) {
        WebserviceConfigurations__c authTokenWSConfig = new WebserviceConfigurations__c(
            Name = serviceName + 'Token',
            RecordTypeId = Schema.SObjectType.WebserviceConfigurations__c.getRecordTypeInfosByName().get('Authorization Token').getRecordTypeId(),
            AuthorizationToken__c = 'testToken'
        );
        Insert authTokenWSConfig;
        return authTokenWSConfig;
    }
    
    public static WebserviceConfigurations__c createWSConfig (String serviceName, Id authTokenWSConfigId,String url) {
        WebserviceConfigurations__c wsConfig = new WebserviceConfigurations__c(
            Name = serviceName,
            RecordTypeId = Schema.SObjectType.WebserviceConfigurations__c.getRecordTypeInfosByName().get('Service API').getRecordTypeId(),
            Method__c = 'POST',
            Headers__c = '[{"key":"Authorization","value":"Bearer AUTH_TOKEN"},{"key":"Content-Type","value":"application/x-www-form-urlencoded"},{"key":"Accept","value":"application/json"}]',
            EndpointPath__c = url,
            Timeout__c = 1000,
            TokenAPI__c = authTokenWSConfigId
        );
        Insert wsConfig;
        return wsConfig;
    }
    
    public static OrgSpecificConfigurations__c createOrgWSConfigs (Id wsConfigId) {
        OrgSpecificConfigurations__c orgSpecificConfigs = new OrgSpecificConfigurations__c(
            WebserviceConfigurations__c = wsConfigId,
            Name = 'QA',
            RecordTypeId = Schema.SObjectType.OrgSpecificConfigurations__c.getRecordTypeInfosByName().get('Service API').getRecordTypeId(),
            EndpointDomain__c = 'https://gateway-stage.optum.com',
            EnableErrorLog__c = true
        );
        Insert orgSpecificConfigs;
        return orgSpecificConfigs;
    }
    @istest static void testsendEmailorSMSNotification()
    {
        WebserviceConfigurations__c newrec1=new WebserviceConfigurations__c();
        newrec1.active__c=true;
        newrec1.name='SMS Authorization';
        newrec1.Method__c='POST';
        newrec1.Headers__c='[{"key":"Authorization","value":"Bearer <:AUTH_TOKEN:>"},{"key":"Content-Type","value":"application/json"},{"key":"actor","value":"ACET"}]';
        newrec1.JSONBodyWithMergeFields__c='{\n\"id\": \"00411796502\",\n\"idType\": \"searchid\",\n\"dateOfBirth\": \"1995-11-21\"\n}';
        newrec1.EndpointPath__c='https://api-stg.uhg.com/api/identity/user/individuals/v1/search';
        insert newrec1;
        Test.StartTest();
        Test.setMock(HttpCalloutMock.class, new ExampleCalloutMock1());
        SNI_FL_Notification_Center sendNotification = new SNI_FL_Notification_Center();
        sendNotification.sendEmailorSMSNotification('','','','true','(202) 795-3222','123456','notification_center_verification');
        sendNotification.sendEmailorSMSNotification('userName@test.com','test','true','','','123456','notification_center_verification');  
        Test.StopTest();
    }
    
    
}