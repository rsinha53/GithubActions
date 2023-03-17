/********************************************************************************* 
Class Name     : SNI_FL_CheckMessageStatus.cls
Description    : This class is used to 
Created By     : Sameera De Silva (ACDC) DE397810
Created Date   : 1/15/2020
***********************************************************************************/
@isTest
public with sharing class SNI_FL_CheckMEssageStatusTest {


    @TestSetup
    static void makeData(){

        ID accountRecordType = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Family').getRecordTypeId();
        profile p=[select Id from profile where Name=:'System Administrator'];
        User u1 = new User( email='familyLink@optum.acet.com',
                           profileid = p.id, 
                           UserName='ACDC_test_@optum.acet.com', 
                           Alias = 'GDS',
                           TimeZoneSidKey='America/New_York',
                           EmailEncodingKey='ISO-8859-1',
                           LocaleSidKey='en_US', 
                           LanguageLocaleKey='en_US',
                           FirstName = 'FirstNameAcet',
                           LastName = 'LastNameAcet');
        insert u1;
        System.runAs(u1){
            Account acc = new Account();
            acc.Name = 'TestAccount_123456';
            acc.Phone = '123456789';
            acc.Type = 'Prospect';
            acc.EID__c = '!123abcACDC';
            acc.RecordTypeId = accountRecordType;

            insert acc;
        }
    }
    //Check status records when owner changed to a new owner
    @isTest
    static void checkAccountOwnerChangedTest1(){

        Account act = [SELECT ID FROM Account WHERE EID__c = '!123abcACDC'];

        SNI_FL_Message__c msg = new SNI_FL_Message__c();
        msg.Family_ID__c = act.ID;
        msg.Name = 'Direct ';
        insert msg;

        profile p=[select Id from profile where Name=:'System Administrator'];

        Test.startTest();
        User u2;
        system.runAs(new user(Id = userinfo.getUserId())){
            u2 = new User( email='family_Link@optum.acet.com',
                               profileid = p.id, 
                               UserName='test_ACDC_userACDC@optum.acet.com', 
                               Alias = 'GDSS',
                               TimeZoneSidKey='America/New_York',
                               EmailEncodingKey='ISO-8859-1',
                               LocaleSidKey='en_US', 
                               isActive=true,
                               LanguageLocaleKey='en_US',
                               FirstName = 'FirstNameAcetACDC',
                               LastName = 'LastNameAcetACDC');
            insert u2;
		}
        act.OwnerId = u2.Id;
        update act;
        Test.stopTest();

        
        //System.assertEquals(1,[SELECT count() FROM SNI_FL_Message_Status__c],'New SNI_FL_MessageStatus record didn\'t created when account owner changed');
    }

    //Check status records when owner changed to same owner 
    @isTest
    static void checkAccountOwnerChangeTest2(){

  
        Account act = [SELECT ID,OwnerId FROM Account WHERE EID__c = '!123abcACDC'];

        SNI_FL_Message__c msg = new SNI_FL_Message__c();
        msg.Family_ID__c = act.ID;
        msg.Name = 'Direct ';
        insert msg;

        Test.startTest();
        
        act.OwnerId = [SELECT ID FROM User WHERE UserName='ACDC_test_@optum.acet.com'][0].Id;
        update act;

        Test.stopTest();

        System.assertEquals(0,[SELECT count() FROM SNI_FL_Message_Status__c],'Same account owner change created new records');
    }

    @isTest
    static void bulkTestAccountOwnerChange(){


        ID accountRecordType = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Family').getRecordTypeId();
        List<Account> lstAccounts = new List<Account>();

        for(Integer x=1;x<=200;x++){
            
            Account acc = new Account();
            acc.Name = 'Acc '+x;
            acc.Phone = '12345678'+x;
            acc.Type = 'Prospect';
            acc.EID__c = '!123abcACDC'+x;
            acc.RecordTypeId = accountRecordType;

            lstAccounts.add(acc);

        }
        insert lstAccounts;

        Map<Id,Account> oldMap = new  Map<Id,Account>([SELECT ID,OwnerId,RecordTypeId FROM Account]);

        List<SNI_FL_Message__c> lstmessages = new List<SNI_FL_Message__c>();
        
        for(Account act:[SELECT id FROM Account]){
            SNI_FL_Message__c messgeRecord = new SNI_FL_Message__c();
            messgeRecord.Family_ID__c = act.id;

            lstmessages.add(messgeRecord);
        }
        insert lstmessages;

       
        Test.startTest();
            User newUser = [SELECT ID FROM User WHERE UserName='ACDC_test_@optum.acet.com'];

            List<Account> lstToupdate = new List<Account>();
            for(Account a:lstAccounts){
                a.OwnerId = newUser.id;
                lstToupdate.add(a);
            }

            update lstToupdate;
        Test.stopTest();
        
        
        //System.assertEquals(200,[SELECT count() FROM SNI_FL_Message_Status__c],'200 recods didn\'t created');

    }

}