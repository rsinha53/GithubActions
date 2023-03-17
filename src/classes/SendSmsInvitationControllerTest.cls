/*------------------------------------------------------------
Author:        Harshini Thotakura
Description:   Test class for Send Sms Invitation Controller
History
Date           Author               Comments
-------------------------------------------------------------
02-01-2023     Harshini Thotakura   Created 
------------------------------------------------------------*/
@isTest
public class SendSmsInvitationControllerTest {
    
    private static final String memberId = '4535435434';
    
    @testSetup static void dataSetup() {
        Id personAccRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Individual').getRecordTypeId();
        Id recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Family').getRecordTypeId();
        
        Account ac = new Account();
        ac.Member_ID__c = memberId;
        ac.Policy_ID__c = '0070145';
        ac.Name =   'SampleTest1';
        ac.RecordTypeId = recordTypeId;
        insert ac;
        
        Account pa =new account();
        pa.firstName = 'paFirstSample1'; 
        pa.lastName = 'paLastSample1';
        pa.Policy_ID__c = '0070145';
        pa.Member_ID__c = memberId;
        pa.RecordTypeId = personAccRecordTypeId;
        pa.PersonMobilePhone = NULL;
        insert pa;
        
        Contact con = [SELECT Id FROM Contact where Contact.AccountId=: pa.id];
        Profile p = [SELECT Id FROM Profile WHERE Name='Care Advisor Connect Community User']; 
        User u = new User(Alias = 'standt', Email='standardusersysAdmin@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, contactid = con.id,
                          TimeZoneSidKey='America/Los_Angeles', UserName='standardUserAdminSys#@testorg.com');
        insert u;
        
        pa = [SELECT Id,PersonContactId FROM Account WHERE Id =:pa.Id];
        
        AccountContactRelation acr = new AccountContactRelation();
        acr.ContactId = pa.PersonContactId;            
        acr.Accountid = ac.id;
        acr.Policy_ID__c = '0070145';
        acr.Relationship__c = 'Child/Other';
        insert acr;
        
        SNI_FL_Care_Team_Member__c ctmMember = new SNI_FL_Care_Team_Member__c();
        ctmMember.SNI_FL_Member__c = ac.id;
        ctmMember.SNI_FL_Status__c = 'Registered';
        insert ctmMember;
        
    }
    
    @isTest
    static void getAccountDetailsTest()
    {
        Id personAccRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Individual').getRecordTypeId();
        
        Account pa =new account();
        pa.firstName = 'paFirstSample1'; 
        pa.lastName = 'paLastSample1';
        pa.Policy_ID__c = '0703352';
        pa.Member_ID__c = memberId;
        pa.RecordTypeId = personAccRecordTypeId;
        pa.PersonMobilePhone = NULL;
        insert pa;
        
        Contact con = [SELECT Id FROM Contact where Contact.AccountId=: pa.id];
        Profile p = [SELECT Id FROM Profile WHERE Name='Care Advisor Connect Community User']; 
        User u = new User(Alias = 'standt', Email='standardusersysAdmin@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, contactid = con.id,
                          TimeZoneSidKey='America/Los_Angeles', UserName='standardUserAdminSys542#@testorg.com');
        insert u;
        Id accId = [SELECT Id FROM Account LIMIT 1].Id;
        User usr = [select id,MobilePhone from User where Contact.AccountId =: pa.Id];
        Test.startTest();
        try{
            SendSmsInvitationController.getAccountDetails(String.valueof(pa.Id));
        } catch(AuraHandledException e) {
        }
        SendSmsInvitationController.sendSMSNotification(pa.Id);
        Test.stopTest();
    }
    
    @isTest
    static void getAccountDetailsTest1()
    {
        Id personAccRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Individual').getRecordTypeId();
        Id recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Family').getRecordTypeId();
        
        Account ac = new Account();
        ac.Member_ID__c = memberId;
        ac.Policy_ID__c = '0070145';
        ac.Name =   'SampleTest1';
        ac.RecordTypeId = recordTypeId;
        insert ac;
        
        Account pa =new account();
        pa.firstName = 'paFirstSample1'; 
        pa.lastName = 'paLastSample1';
        pa.Policy_ID__c = '0070145';
        pa.Member_ID__c = memberId;
        pa.RecordTypeId = personAccRecordTypeId;
        pa.PersonMobilePhone = NULL;
        insert pa;
        
        Contact con = [SELECT Id FROM Contact where Contact.AccountId=: pa.id];
        Profile p = [SELECT Id FROM Profile WHERE Name='Care Advisor Connect Community User']; 
        User u = new User(Alias = 'standt', Email='standardusersysAdmin@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, contactid = con.id, MobilePhone = '6842732',
                          TimeZoneSidKey='America/Los_Angeles', UserName='standardUserTest@testorg.com');
        insert u;
        
        pa = [SELECT Id,PersonContactId FROM Account WHERE Id =:pa.Id];
        
        AccountContactRelation acr = new AccountContactRelation();
        acr.ContactId = pa.PersonContactId;            
        acr.Accountid = ac.id;
        acr.Policy_ID__c = '0070145';
        acr.Relationship__c = 'Child/Other';
        insert acr;
        
        Test.startTest();
        try{
            SendSmsInvitationController.getAccountDetails(String.valueof(pa.Id));
        } catch(AuraHandledException e) {}
        Test.stopTest();
    }
    
    @isTest
    static void getAccountDetailsTest2()
    {
        Id personAccRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Individual').getRecordTypeId();
        Id recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Family').getRecordTypeId();
        
        Account ac = new Account();
        ac.Member_ID__c = memberId;
        ac.Policy_ID__c = '0070145';
        ac.Name =   'SampleTest1';
        ac.RecordTypeId = recordTypeId;
        insert ac;
        
        Account pa =new account();
        pa.firstName = 'paFirstSample1'; 
        pa.lastName = 'paLastSample1';
        pa.Policy_ID__c = '0070145';
        pa.Member_ID__c = memberId;
        pa.RecordTypeId = personAccRecordTypeId;
        pa.PersonMobilePhone = NULL;
        insert pa;
        
        Contact con = [SELECT Id FROM Contact where Contact.AccountId=: pa.id];
        Profile p = [SELECT Id FROM Profile WHERE Name='Care Advisor Connect Community User']; 
        User u = new User(Alias = 'standt', Email='standardusersysAdmin@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, contactid = con.id, MobilePhone = '',
                          TimeZoneSidKey='America/Los_Angeles', UserName='standardUserTest67@testorg.com');
        insert u;
        
        pa = [SELECT Id,PersonContactId FROM Account WHERE Id =:pa.Id];
        
        AccountContactRelation acr = new AccountContactRelation();
        acr.ContactId = pa.PersonContactId;            
        acr.Accountid = ac.id;
        acr.Policy_ID__c = '0703352';
        acr.Relationship__c = 'Child/Other';
        insert acr;
        
        Test.startTest();
        try{
            SendSmsInvitationController.getAccountDetails(String.valueof(pa.Id));
        } catch(AuraHandledException e) {}
        Test.stopTest();
    }
    
    @isTest
    static void validateClientTest2()
    {
        Id recordTypeId1 = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Individual').getRecordTypeId();
        Account acc = new Account(
            //Name='test',
            FirstName= 'test',
            LastName='lastTest',
            PersonEmail='' ,
            Recordtypeid=recordTypeId1);
        insert acc;
        Id recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Family').getRecordTypeId();
        Account famAcc = new Account();
        famAcc.Name = 'FLTestAcc123';
        famAcc.RecordTypeId = recordTypeId;
        insert famAcc;
        Contact objContact = [Select id, FirstName, LastName from Contact where AccountId=:acc.Id];
        Accountcontactrelation acr = new Accountcontactrelation();
        acr.contactid = objContact.id;
        acr.accountid = famAcc.id;
        acr.Policy_ID__c = '0703352';
        insert acr;
        SendSmsInvitationController.validateClient(acc);
    }
    
    @isTest
    static void validateRegisteredMemberTest()
    {
        try{
            Id accId = [SELECT Id FROM Account LIMIT 1].Id;
            Account acct = [SELECT Id,RecordType.Name,Family__c,PersonMobilePhone,Policy_Id__c,Member_ID__c FROM Account WHERE Id=:accId];
            SNI_FL_Care_Team_Member__c cteamList = [SELECT ID, Name, SNI_FL_Status__c FROM SNI_FL_Care_Team_Member__c WHERE SNI_FL_Member__c =: accId];
            SendSmsInvitationController.validateRegisteredMember(acct);
        }catch(Exception ex){
            
        }
    }
    
    @isTest
    static void validatePhoneNumberTest()
    {
        Id accId = [SELECT Id FROM Account LIMIT 1].Id;
        Account acct = [SELECT Id,RecordType.Name,Family__c,PersonMobilePhone,Policy_Id__c,Member_ID__c FROM Account WHERE Id=:accId];
        try{
            SendSmsInvitationController.validatePhoneNumber(acct);
        }catch(Exception e){
            
        }
    }
    
    /*@isTest
static void sendSMSNotificationTest()
{
Id accId = [SELECT Id FROM Account LIMIT 1].Id;
Account acct = [SELECT Id,RecordType.Name,Family__c,PersonMobilePhone,Policy_Id__c,Member_ID__c FROM Account WHERE Id=:accId];
//SendSmsInvitationController.sendSMSNotification(accId);
}*/
    
}