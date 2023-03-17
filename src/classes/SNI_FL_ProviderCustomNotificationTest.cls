@isTest(SeeAllData=true)/*seeAllData is true as this class has testmethods related to ConnectAPI which requries it to be true*/
public class SNI_FL_ProviderCustomNotificationTest {
    private static final String PROFILENAME = 'System Administrator';
    private static final String TESTUSERNAME = 'test_userr@optum.com';
    private static final String TIMEZONE = 'America/New_York';
    private static final String EMAILENCODINGKEY = 'ISO-8859-1';
    private static final String TESTEMAIL = 'familyLink@optum.com';
    private static final String TSTEMAIL = 'agent1@optum.acet.com';
    private static final String TESTMAIL = 'agent2_acdc_@optum.acet.com';
    private static final String TESTALIAS= 'GDS';
    private static final String TESTLOCALKEYS = 'en_US';
    private static final String TESTFIRSTNAME = 'FirstName';
    private static final String TESTLASTNAME = 'LastName';
    private static final String ACCOUNTNAME = 'Test Account';
    /*cannot create testsetup as seeAllData is true*/
   
    @isTest
    static void sendNewMessageCustonNotification(){
        ID personAccountType =  Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('PersonAccount').getRecordTypeId();
        profile p=[select Id from profile where Name=:'Care Advisor Connect Community User'];
        Account acc3 = new Account();
        acc3.FirstName ='Secondperson_ACDC';
        acc3.LastName = 'SecondName_ACDC';
        acc3.RecordTypeId = personAccountType;
        insert acc3;
		Contact cont2 = [SELECT ID FROM Contact WHERE AccountId=:acc3.id];
        User thisUser = [Select Id From User Where Id =:UserInfo.getUserId()];
         System.runAs(thisUser){
        User u2 = new User( email='familyLink_ACDC@optum.acet.com',
                            profileid = p.id, 
                            UserName='test_uer_ACDC@optum.acet.com', 
                            Alias = 'GDS',
                            TimeZoneSidKey='America/New_York',
                            EmailEncodingKey='ISO-8859-1',
                            LocaleSidKey='en_US', 
                            ContactId = cont2.id,
                            LanguageLocaleKey='en_US',
                            FirstName = 'First_NameAcet',
                            LastName = 'Last_NameAcet');
            insert u2;
        System.runAs(u2){
        Test.startTest();
        set<string> users =new Set<String>{'testUser', 'testUser2'};
        SNI_FL_ProviderCustomNotification.sendNewMessageCustonNotification('messageBody','subject is test to test data subject data subject data', users);
        Test.stopTest();
        }
         }
    }
    @isTest
    static void sendNewMessageCustonNotification2(){
        ID personAccountType =  Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('PersonAccount').getRecordTypeId();
        profile p=[select Id from profile where Name=:'Care Advisor Connect Community User'];
        Account acc3 = new Account();
        acc3.FirstName ='Secondperson_ACDC';
        acc3.LastName = 'SecondName_ACDC';
        acc3.RecordTypeId = personAccountType;
        insert acc3;
		Contact cont2 = [SELECT ID FROM Contact WHERE AccountId=:acc3.id];
        User thisUser = [Select Id From User Where Id =:UserInfo.getUserId()];
         System.runAs(thisUser){
        User u2 = new User( email='familyLink_ACDC@optum.acet.com',
                            profileid = p.id, 
                            UserName='test_uer_ACDC@optum.acet.com', 
                            Alias = 'GDS',
                            TimeZoneSidKey='America/New_York',
                            EmailEncodingKey='ISO-8859-1',
                            LocaleSidKey='en_US', 
                            ContactId = cont2.id,
                            LanguageLocaleKey='en_US',
                            FirstName = 'First_NameAcet',
                            LastName = 'Last_NameAcet');
            insert u2;
        System.runAs(u2){
        Test.startTest();
        set<string> users =new Set<String>{'testUser', 'testUser2'};
        SNI_FL_ProviderCustomNotification.sendNewMessageCustonNotification('messageBody','', users);
        Test.stopTest();
        }
         }
    }
    @isTest
    static void sendNewMessageCustonNotification3(){
        ID personAccountType =  Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('PersonAccount').getRecordTypeId();
        profile p=[select Id from profile where Name=:'Care Advisor Connect Community User'];
        Account acc3 = new Account();
        acc3.FirstName ='Secondperson_ACDC';
        acc3.LastName = 'SecondName_ACDC';
        acc3.RecordTypeId = personAccountType;
        insert acc3;
		Contact cont2 = [SELECT ID FROM Contact WHERE AccountId=:acc3.id];
        User thisUser = [Select Id From User Where Id =:UserInfo.getUserId()];
         System.runAs(thisUser){
        User u2 = new User( email='familyLink_ACDC@optum.acet.com',
                            profileid = p.id, 
                            UserName='test_uer_ACDC@optum.acet.com', 
                            Alias = 'GDS',
                            TimeZoneSidKey='America/New_York',
                            EmailEncodingKey='ISO-8859-1',
                            LocaleSidKey='en_US', 
                            ContactId = cont2.id,
                            LanguageLocaleKey='en_US',
                            FirstName = 'First_NameAcet',
                            LastName = 'Last_NameAcet');
            insert u2;
        System.runAs(u2){
        Test.startTest();
        set<string> users =new Set<String>{'testUser', 'testUser2'};
        SNI_FL_ProviderCustomNotification.sendNewMessageCustonNotification('Posted a file','', users);
        Test.stopTest();
        }
         }
    }
     @isTest
    static void sendNewMessageCustonNotification4(){
        ID personAccountType =  Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('PersonAccount').getRecordTypeId();
        profile p=[select Id from profile where Name=:'Care Advisor Connect Community User'];
        Account acc3 = new Account();
        acc3.FirstName ='Secondperson_ACDC';
        acc3.LastName = 'SecondName_ACDC';
        acc3.RecordTypeId = personAccountType;
        insert acc3;
		Contact cont2 = [SELECT ID FROM Contact WHERE AccountId=:acc3.id];
        User thisUser = [Select Id From User Where Id =:UserInfo.getUserId()];
         System.runAs(thisUser){
        User u2 = new User( email='familyLink_ACDC@optum.acet.com',
                            profileid = p.id, 
                            UserName='test_uer_ACDC@optum.acet.com', 
                            Alias = 'GDS',
                            TimeZoneSidKey='America/New_York',
                            EmailEncodingKey='ISO-8859-1',
                            LocaleSidKey='en_US', 
                            ContactId = cont2.id,
                            LanguageLocaleKey='en_US',
                            FirstName = 'First_NameAcet',
                            LastName = 'Last_NameAcet');
            insert u2;
        System.runAs(u2){
        Test.startTest();
        set<string> users =new Set<String>{'testUser', 'testUser2'};
        SNI_FL_ProviderCustomNotification.sendNewMessageCustonNotification('messageBody','subject', users);
        Test.stopTest();
        }
         }
    }
    @isTest
    static void sendReplyCustomNotification(){ 
        ID personAccountType =  Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('PersonAccount').getRecordTypeId();
        profile p=[select Id from profile where Name=:'Care Advisor Connect Community User'];
       //List<Account> accLst = [select id from account where recordTypeId =:personAccountType Limit 10];
       	List<User> lstUser = [select id,ContactId from user where ContactId != ''];
        Set<Id> ConId = new set<Id>();
        for(User u : lstUser){
            ConId.add(u.ContactId);
        }
        id userId = userinfo.getUserId();
        Account acc = new Account(recordtypeid = personAccountType, lastname = 'test');
        insert acc; 

        Contact cont2 = [SELECT ID FROM Contact WHERE account.recordTypeId =:personAccountType AND Id Not in:ConId Limit 1];
        User u2;
        system.runAs(new user(id = userinfo.getUserId())){

            u2 = new User( email='familyLink_ACDC@optum.acet.com',
                                profileid = p.id, 
                                UserName='test_uer_ACDC@optum.acet.com', 
                                Alias = 'GDS',
                                TimeZoneSidKey='America/New_York',
                                EmailEncodingKey='ISO-8859-1',
                                LocaleSidKey='en_US', 
                                ContactId = cont2.id,
                                LanguageLocaleKey='en_US',
                                FirstName = 'First_NameAcet',
                                LastName = 'Last_NameAcet');
             insert u2; 
        }
         List<ID> ids = new List<ID>();
         List<UserRole> usrRole = [select Id,name from userrole where name like '%FEC%'];
         profile profle=[select Id from profile where Name like :PROFILENAME];
        User thisUser = [Select Id From User Where Id =:UserInfo.getUserId()];
        User u1;
         System.runAs(thisUser){
		  u1 = new User( email=TESTEMAIL,
                           profileid = profle.id, 
                           UserName=TESTUSERNAME, 
                           Alias = TESTALIAS,
                           TimeZoneSidKey=TIMEZONE,
                           EmailEncodingKey=EMAILENCODINGKEY,
                           LocaleSidKey=TESTLOCALKEYS, 
                           LanguageLocaleKey=TESTLOCALKEYS,
                           FirstName = TESTFIRSTNAME,
                           LastName = TESTLASTNAME,
                           userRoleId = usrRole[0].Id
                           );
        insert u1;
         }
		Test.startTest();
        ids.add(u1.id);
        List<DirectMessageFeed> lstDirectMsgFeed = [SELECT ID FROM DirectMessageFeed LIMIT 1];
        /*Cannot create the setup and non user object both as user with FEC role need to be created this data is retrieved directy*/
        String feedId = lstDirectMsgFeed.size()>0 ? String.valueOf(lstDirectMsgFeed[0].Id) : '';
        system.debug('feedId+ '+feedId);
        System.runAs(u2){
        SNI_FL_ProviderCustomNotification.sendReplyCustomNotification('messageBody',feedId,null);
        }
        Test.stopTest();
    }
    
}