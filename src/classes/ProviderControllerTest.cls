@isTest 
public class ProviderControllerTest {
    static final String feedItemBody = 'Test Feed 1 Post';
    static final String feedCommentBody = 'Test Feed 1 Comment';
    static final String userRoleName = 'Care Advisor';
    static final String email = 'standarduser@testorg.com';
    static final String timeZone = 'America/Los_Angeles';
    static final String userName = 'testpermissionsetuserfordev@testorg.com';

    static testMethod void testGetUserData() {
        
        Id recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Provider_Affiliation').getRecordTypeId();
        List<Account> accList = new List<Account>();
        Account ac = new Account();
        ac.Member_ID__c = '453543543';
        ac.Policy_ID__c = '0070145';
        ac.Name =   'SampleTEstFLAcc1';
        ac.RecordTypeId = recordTypeId;
        accList.add(ac);
        
        Account ac1 = new Account();
        ac1.Member_ID__c = '453543542';
        ac1.Policy_ID__c = '0070142';
        ac1.Name =   'SampleTEstFLAcc2';
        ac1.RecordTypeId = recordTypeId;
        accList.add(ac1);
        
        Account ac3 = new Account();
        ac3.Member_ID__c = '453543543';
        ac3.Policy_ID__c = '0070145';
        ac3.Name =   'SampleTEstFLAcc3';
        ac3.RecordTypeId = recordTypeId;
        accList.add(ac3);
        insert accList;
      //  account accper = [select id, PersonBirthdate from account where id='0017600000B7cExAAJ'];
       //  date dobt =accper.PersonBirthdate;
        Id personAccRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Individual').getRecordTypeId();
        
        Account pa =new account();
      //  pa.PersonBirthdate =dobt;
        pa.firstName = 'paLastSample1'; 
        pa.lastName = 'paFirstSample1'; 
        pa.RecordTypeId = personAccRecordTypeId;
        insert pa;
        
        Account pa1 =new account(); 
     //   pa1.PersonBirthdate = dobt;
        pa1.firstName = 'paLastSample2'; 
        pa1.lastName = 'paFirstSample2'; 
        pa1.RecordTypeId = personAccRecordTypeId;
        insert pa1;
        
        account pa2 = [select id,personcontactid from account where id =: pa.id];
        Profile p = [SELECT Id FROM Profile WHERE Name='Care Advisor Connect Community User']; 
        User u;
        system.runAs(new user(Id = userinfo.getUserId())){
            u = new User(Alias = 'standt', Email='standarduser@testorg.com.acet', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='standarduser45454@testorg.com');
            u.ContactId = pa2.personcontactid;
            insert u;      
        }

        AccountContactRelation acr = new AccountContactRelation();
        acr.ContactId = pa2.personcontactid;            
        acr.Accountid = accList[0].id;
        acr.Relationship__c = 'Child/Other';
        insert acr;
        List<program__c> programList=new List<program__c>();
        Program__c pgm = new Program__c();
        pgm.Program__c = 'Complex Care';
        programList.add(pgm);
        insert programList;
        system.debug('Userdetails--'+acr);
        System.runAs(u){
            providerController.ProviderWrapper pw= new providerController.ProviderWrapper();
            pw= ProviderController.ProviderWrapper.getUserData();
        }
    }

    @isTest
    static void markNewMessageIconTest(){
        
        Profile p = [SELECT Id FROM Profile WHERE Name='Center for Health Navigation'];
        UserRole userRole=new UserRole(Name= userRoleName); 
        insert userRole; 
        User u = new User(Alias = 'standt', Email=email,
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
                          LocaleSidKey='en_US', ProfileId = p.Id,
                          TimeZoneSidKey=timeZone,  UserRoleId = userRole.Id,UserName=userName);
        insert u;
        System.runAs(u){
            Id loggedUserId = UserInfo.getUserId();  
            String userId = '001m000001CirBBAAZ';
            CollaborationGroup cg = new CollaborationGroup(Name='Test Group 1', CollaborationType='Public');
            insert cg;
            
            // Create Chatter Post
            FeedItem testFeed1 = new FeedItem(Body=feedItemBody, ParentId = cg.Id, Type='TextPost');
            insert testFeed1;
            
            // Create Chatter Comment
            FeedComment testFeed1Comment = new FeedComment(CommentBody=feedCommentBody, FeedItemId=testFeed1.Id, CommentType='TextComment' );
            insert testFeed1Comment;
            
            SNI_FL_Message_Notification__c msgNotification = new SNI_FL_Message_Notification__c(Name='Test Class Msg', FeedCommentId__c = testFeed1Comment.id,FeedId__c = testFeed1.id, RecipientId__c=loggedUserId , SenderId__c = '', IsViewed__c = false);
            insert msgNotification;
            
            Test.startTest();
            ProviderController.markNewMessageIcon(loggedUserId);
            ProviderController.markNewMessageIcon(userId);
            Test.stopTest();
        }
        
    }
    
    @isTest
    static void deleteReadMessagesTest(){
        String userId = '001m000001CirBBAAZ';
        Profile p = [SELECT Id FROM Profile WHERE Name='Center for Health Navigation'];
        UserRole userRole=new UserRole(Name= userRoleName); 
        insert userRole; 
        User u = new User(Alias = 'standt', Email=email,
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
                          LocaleSidKey='en_US', ProfileId = p.Id,
                          TimeZoneSidKey=timeZone,  UserRoleId = userRole.Id,UserName=userName);
        insert u;
        System.runAs(u){
            Id loggedUserId = UserInfo.getUserId();
            CollaborationGroup cg = new CollaborationGroup(Name='Test Group 1', CollaborationType='Public');
            insert cg;
            
            // Create Chatter Post
            FeedItem testFeed1 = new FeedItem(Body=feedItemBody, ParentId = cg.Id, Type='TextPost');
            insert testFeed1;
            
            // Create Chatter Comment
            FeedComment testFeed1Comment = new FeedComment(CommentBody=feedCommentBody, FeedItemId=testFeed1.Id, CommentType='TextComment' );
            insert testFeed1Comment;
            
            SNI_FL_Message_Notification__c msgNotification = new SNI_FL_Message_Notification__c(Name='Test Class Msg', FeedCommentId__c = testFeed1Comment.id,FeedId__c = testFeed1.id, RecipientId__c=loggedUserId , SenderId__c = '', IsViewed__c = false);
            insert msgNotification;
            
            Test.startTest();
            ProviderController.deleteReadMessages(loggedUserId);
            ProviderController.deleteReadMessages(userId);

            Test.stopTest();
            
        }
        
    }
    
}