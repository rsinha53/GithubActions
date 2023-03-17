@isTest
public class SNI_FL_AccountSettingControllerTest {
    @testSetup static void testSetupData(){
        Id recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Family').getRecordTypeId();
        List<Account> accList=new List<Account>();
        Account ac = new Account();
        ac.Member_ID__c = '453543123';
        ac.Policy_ID__c = '0070123';
        ac.Name =   'FLTestAcc123';
        ac.RecordTypeId = recordTypeId;
        accList.add(ac);
        
        Id personAccRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Individual').getRecordTypeId();
        Account pa =new account();
        pa.PersonBirthdate = date.valueOf(ACETUtility.formatDateFutureDate('6/17/1979'));
        pa.firstName = 'Community'; 
        pa.lastName = 'FLTestUser'; 
        pa.RecordTypeId = personAccRecordTypeId;
        accList.add(pa);       
        
        Account pa2 =new account();
        pa2.PersonBirthdate = date.valueOf(ACETUtility.formatDateFutureDate('6/7/1979'));
        pa2.firstName = 'CommunityUser'; 
        pa2.lastName = 'FLTestUser2'; 
        pa2.RecordTypeId = personAccRecordTypeId;
        accList.add(pa2);       
        insert accList;
        
        List<Contact> conId = [SELECT id from contact where accountId =: pa.Id];
        List<Profile> pList = [SELECT Id,Name FROM Profile WHERE Name =: 'Care Advisor Connect Community User'];  //'Care Advisor Connect Community User'
        User u;
        system.runAs(new user(Id = userinfo.getUserId())){
            u = new User(Alias = 'standt', Email='fltest@testorg.com', 
                         EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                         LocaleSidKey='en_US', ProfileId = pList.get(0).id, contactId =conId[0].Id,
                         TimeZoneSidKey='America/Los_Angeles',MobilePhone='8876543456', UserName='fltest@testorg.com',IsActive=true);
            insert u;
        }
    }
    @isTest static void accountsettingsTest(){
        WebserviceConfigurations__c newrec=new WebserviceConfigurations__c();
        newrec.active__c=true;
        newrec.name='SMS GeneratePhoneId';
        newrec.Method__c='POST';
        newrec.Headers__c='[{"key":"Authorization","value":"Bearer <:AUTH_TOKEN:>"},{"key":"Content-Type","value":"application/json"},{"key":"actor","value":"ACET"}]';
        newrec.JSONBodyWithMergeFields__c='{\n\"id\": \"00411796502\",\n\"idType\": \"searchid\",\n\"dateOfBirth\": \"1995-11-21\"\n}';
        newrec.EndpointPath__c='https://api-stg.uhg.com/api/identity/user/individuals/v1/search';
        insert newrec;
        WebserviceConfigurations__c newrec1=new WebserviceConfigurations__c();
        newrec1.active__c=true;
        newrec1.name='SMS Authorization';
        newrec1.Method__c='POST';
        newrec1.Headers__c='[{"key":"Authorization","value":"Bearer <:AUTH_TOKEN:>"},{"key":"Content-Type","value":"application/json"},{"key":"actor","value":"ACET"}]';
        newrec1.JSONBodyWithMergeFields__c='{\n\"id\": \"00411796502\",\n\"idType\": \"searchid\",\n\"dateOfBirth\": \"1995-11-21\"\n}';
        newrec1.EndpointPath__c='https://api-stg.uhg.com/api/identity/user/individuals/v1/search';
        insert newrec1;
        WebserviceConfigurations__c newrec2=new WebserviceConfigurations__c();
        newrec2.active__c=true;
        newrec2.name='SMS subscribePhoneID';
        newrec2.Method__c='POST';
        newrec2.Headers__c='[{"key":"Authorization","value":"Bearer <:AUTH_TOKEN:>"},{"key":"Content-Type","value":"application/json"},{"key":"actor","value":"ACET"}]';
        newrec2.JSONBodyWithMergeFields__c='{\n\"id\": \"00411796502\",\n\"idType\": \"searchid\",\n\"dateOfBirth\": \"1995-11-21\"\n}';
        newrec2.EndpointPath__c='https://api-stg.uhg.com/api/identity/user/individuals/v1/search';
        insert newrec2;
        WebserviceConfigurations__c newrec3=new WebserviceConfigurations__c();
        newrec3.active__c=true;
        newrec3.name='SMS getPhoneIdValue';
        newrec3.Method__c='POST';
        newrec3.Headers__c='[{"key":"Authorization","value":"Bearer <:AUTH_TOKEN:>"},{"key":"Content-Type","value":"application/json"},{"key":"actor","value":"ACET"}]';
        newrec3.JSONBodyWithMergeFields__c='{\n\"id\": \"00411796502\",\n\"idType\": \"searchid\",\n\"dateOfBirth\": \"1995-11-21\"\n}';
        newrec3.EndpointPath__c='https://api-stg.uhg.com/api/identity/user/individuals/v1/search';
        insert newrec3;
        WebserviceConfigurations__c newrec4=new WebserviceConfigurations__c();
        newrec4.active__c=true;
        newrec4.name='SMS Notification';
        newrec4.Method__c='POST';
        newrec4.Headers__c='[{"key":"Authorization","value":"Bearer <:AUTH_TOKEN:>"},{"key":"Content-Type","value":"application/json"},{"key":"actor","value":"ACET"}]';
        newrec4.JSONBodyWithMergeFields__c='{\n\"id\": \"00411796502\",\n\"idType\": \"searchid\",\n\"dateOfBirth\": \"1995-11-21\"\n}';
        newrec4.EndpointPath__c='https://api-stg.uhg.com/api/identity/user/individuals/v1/search';
        insert newrec4;
        
        WebserviceConfigurations__c newrec5=new WebserviceConfigurations__c();
        newrec5.active__c=true;
        newrec5.name='SMS getSubscriptionStatus';
        newrec5.Method__c='POST';
        newrec5.Headers__c='[{"key":"Authorization","value":"Bearer <:AUTH_TOKEN:>"},{"key":"Content-Type","value":"application/json"},{"key":"actor","value":"ACET"}]';
        newrec5.JSONBodyWithMergeFields__c='{\n\"id\": \"00411796502\",\n\"idType\": \"searchid\",\n\"dateOfBirth\": \"1995-11-21\"\n}';
        newrec5.EndpointPath__c='https://api-stg.uhg.com/api/identity/user/individuals/v1/search';
        insert newrec5;
        
        WebserviceConfigurations__c newrec6=new WebserviceConfigurations__c();
        newrec6.active__c=true;
        newrec6.name='SMS UnsubscribePhoneID';
        newrec6.Method__c='POST';
        newrec6.Headers__c='[{"key":"Authorization","value":"Bearer <:AUTH_TOKEN:>"},{"key":"Content-Type","value":"application/json"},{"key":"actor","value":"ACET"}]';
        newrec6.JSONBodyWithMergeFields__c='{\n\"id\": \"00411796502\",\n\"idType\": \"searchid\",\n\"dateOfBirth\": \"1995-11-21\"\n}';
        newrec6.EndpointPath__c='https://api-stg.uhg.com/api/identity/user/individuals/v1/search';
        insert newrec6;
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new ACET_ViewPCPReferralMockResponse(400,true));
        User u = [SELECT Id ,Email,contact.accountid from User where UserName='fltest@testorg.com' LIMIT 1];
        Account acc = [SELECT Id,Text_Message_SMS_Notification__c,Email_Notification__c from Account where id =: u.contact.accountid];
        //system.runAs(u){
        u.Email = 'fltest2@testorg.com';
        Test.setMock(HttpCalloutMock.class,new ExampleCalloutMock());
        SNI_FL_AccountSettingController.getUserDetail();
        SNI_FL_AccountSettingController.getchangePassword('test@1234','test@1234','test@123');
        SNI_FL_AccountSettingController.getchangePassword('test','test@1234','test@123');
        SNI_FL_AccountSettingController.getchangePassword('','','test@123');
        SNI_FL_AccountSettingController.getchangePassword('test@12','test@12','test@123');
        //SNI_FL_AccountSettingController.saveUserDetails(u,'tst@4321');
        SNI_FL_AccountSettingController.saveUserDetails(u);
        //SNI_FL_AccountSettingController.UpdateAccdetails(acc,false,true,'tst@4321','8876543456');
        SNI_FL_AccountSettingController.UpdateAccdetails(acc,false,true,'8876543456');
        SNI_FL_AccountSettingController.UpdateAccdetails(acc,false,false,'8876543456');
        SNI_FL_AccountSettingController.getCustMetaData();
        
        //}
        Test.stopTest();
        //Boolean flg = SNI_FL_AccountSettingController.HSIDmemURls();
    }
    
    
    
}