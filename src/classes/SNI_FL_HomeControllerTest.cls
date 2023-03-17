@isTest
private class SNI_FL_HomeControllerTest {
    static final String FEEDITEMBODY = 'Test Feed 1 Post';
    static final String FEEDCOMMENTBODY = 'Test Feed 1 Comment';
    static final String USERROLENAME = 'Care Advisor';
    static final String EMAIL = 'standarduser@testorg.com';
    static final String TIMEZONE = 'America/Los_Angeles';
    static final String USERNAME = 'testpermissionsetuserfordev@testorg.com';
    
    @isTest 
    static void insertMessageNotificationTest(){
        List<FeedComment> feedList = [Select Id, CommentBody,ParentId,CreatedDate, CreatedById From FeedComment Limit 1];        
        Test.startTest();
        SNI_FLDirectMessageObjectQuery.insertMessageNotification(feedList);
        Test.stopTest();
    }
    
    @isTest
    static void testTrigger(){
        Test.startTest();
        CollaborationGroup cg = new CollaborationGroup(Name='Testing Group', CollaborationType='Public');
        insert cg;
        
        // Create Chatter Post
        FeedItem testFeed1 = new FeedItem(Body=FEEDITEMBODY, ParentId = cg.Id, Type='TextPost');
        insert testFeed1;
        
        // Create Chatter Comment
        FeedComment testFeed1Comment = new FeedComment(CommentBody=FEEDCOMMENTBODY, FeedItemId=testFeed1.Id, CommentType='TextComment' );
        insert testFeed1Comment;
        
        // Create Chatter Post
        FeedItem testFeed2 = new FeedItem(Body='Test Feed 2 Post', ParentId = cg.Id, Type='TextPost');
        insert testFeed2;
        
        // Create Chatter Comment
        FeedComment testFeed2Comment = new FeedComment(CommentBody='#answer Test Feed 2 Comment', FeedItemId=testFeed2.Id, CommentType='TextComment');
        insert testFeed2Comment;
        
        List<CollaborationGroupFeed> feeds = [Select Body from CollaborationGroupFeed];
        system.debug('-------------- ' + feeds);
        Test.stopTest();
        
    }
    
    @isTest
    static void checkPermissionSet()
    {
        Test.startTest();
        
        Profile p = [SELECT Id FROM Profile WHERE Name='Center for Health Navigation'];
        UserRole userRole=new UserRole(Name= USERROLENAME); 
        insert userRole; 
        User u = new User(Alias = 'standt', Email=EMAIL,
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
                          LocaleSidKey='en_US', ProfileId = p.Id,
                          TimeZoneSidKey=TIMEZONE,  UserRoleId = userRole.Id,UserName=USERNAME);
        insert u;
        
        // Query your permission set name from Organization that your want to test.
        PermissionSet ps = [SELECT Id,label FROM PermissionSet WHERE label = 'FamilyLink_Manage External Users'];
        
        // Assign the above inserted user for the above Permission Set.
        PermissionSetAssignment psa = new PermissionSetAssignment();
        psa.AssigneeId = u.Id;
        psa.PermissionSetId = ps.Id;
        insert psa;
        
        
        Test.stopTest();
        
    }
    
    @isTest
    static void getUserDataTest(){
        Test.startTest();
        SNI_FL_HomeController.getUserData();
        Test.stopTest();
    }
    
    @isTest
    static void getAdvisoryTest(){
        Test.startTest();
        SNI_FL_HomeController.getAdvisory();
        Test.stopTest();
    }
    
    @isTest
    static void markNewMessageIconTest(){
        
        Profile p = [SELECT Id FROM Profile WHERE Name='Center for Health Navigation'];
        UserRole userRole=new UserRole(Name= USERROLENAME); 
        insert userRole; 
        User u = new User(Alias = 'standt', Email=EMAIL,
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
                          LocaleSidKey='en_US', ProfileId = p.Id,
                          TimeZoneSidKey=TIMEZONE,  UserRoleId = userRole.Id,UserName=USERNAME);
        insert u;
        System.runAs(u){
            Id loggedUserId = UserInfo.getUserId();           
            CollaborationGroup cg = new CollaborationGroup(Name='Test Group 1', CollaborationType='Public');
            insert cg;
            
            // Create Chatter Post
            FeedItem testFeed1 = new FeedItem(Body=FEEDITEMBODY, ParentId = cg.Id, Type='TextPost');
            insert testFeed1;
            
            // Create Chatter Comment
            FeedComment testFeed1Comment = new FeedComment(CommentBody=FEEDCOMMENTBODY, FeedItemId=testFeed1.Id, CommentType='TextComment' );
            insert testFeed1Comment;
            
            SNI_FL_Message_Notification__c msgNotification = new SNI_FL_Message_Notification__c(Name='Test Class Msg', FeedCommentId__c = testFeed1Comment.id,FeedId__c = testFeed1.id, RecipientId__c=loggedUserId , SenderId__c = '', IsViewed__c = false);
            insert msgNotification;
            
            Test.startTest();
            SNI_FL_HomeController.markNewMessageIcon(loggedUserId);
            SNI_FL_HomeController.markNewMessageIcon('001m000001CirBBAAZ');
            SNI_FL_HomeController.markNewMessageIcon('');
            Test.stopTest();
        }
        
    }
    
    @isTest
    static void deleteReadMessagesTest(){
        
        Profile p = [SELECT Id FROM Profile WHERE Name='Center for Health Navigation'];
        UserRole userRole=new UserRole(Name= USERROLENAME); 
        insert userRole; 
        User u = new User(Alias = 'standt', Email=EMAIL,
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
                          LocaleSidKey='en_US', ProfileId = p.Id,
                          TimeZoneSidKey=TIMEZONE,  UserRoleId = userRole.Id,UserName=USERNAME);
        insert u;
        System.runAs(u){
            Id loggedUserId = UserInfo.getUserId();
            CollaborationGroup cg = new CollaborationGroup(Name='Test Group 1', CollaborationType='Public');
            insert cg;
            
            // Create Chatter Post
            FeedItem testFeed1 = new FeedItem(Body=FEEDITEMBODY, ParentId = cg.Id, Type='TextPost');
            insert testFeed1;
            
            // Create Chatter Comment
            FeedComment testFeed1Comment = new FeedComment(CommentBody=FEEDCOMMENTBODY, FeedItemId=testFeed1.Id, CommentType='TextComment' );
            insert testFeed1Comment;
            
            SNI_FL_Message_Notification__c msgNotification = new SNI_FL_Message_Notification__c(Name='Test Class Msg', FeedCommentId__c = testFeed1Comment.id,FeedId__c = testFeed1.id, RecipientId__c=loggedUserId , SenderId__c = '', IsViewed__c = false);
            insert msgNotification;
            
            Test.startTest();
            SNI_FL_HomeController.deleteReadMessages(loggedUserId);
            SNI_FL_HomeController.deleteReadMessages('001m000001CirBBAAZ');
            Test.stopTest();
            
        }
        
    }
    
    @isTest
    static void caseNotificationTest() {
        Id recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Family').getRecordTypeId();
        List<Account> accList=new List<Account>();
        List<SNI_FL_Care_Team_Member__c> teamlist=new List<SNI_FL_Care_Team_Member__c>();
        Account ac = new Account();
        ac.Member_ID__c = '453543145';
        ac.Policy_ID__c = '0070145';
        ac.Name =   'FLTestAcc';
        ac.RecordTypeId = recordTypeId;
        accList.add(ac);
        
        
        Id personAccRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Individual').getRecordTypeId();
        Account pa =new account();
        pa.PersonBirthdate = date.valueOf(ACETUtility.formatDateFutureDate('6/17/1979'));
        pa.firstName = 'Community'; 
        pa.lastName = 'FLCreteamTestUser'; 
        pa.RecordTypeId = personAccRecordTypeId;
        pa.MultiPolicyCheck__c=true;
        pa.Policy_ID__c='0070145';
        pa.Member_ID__c='453543145';
        pa.Email_Notification__c = false;
        accList.add(pa);       
        
        Account pa2 =new account();
        pa2.PersonBirthdate = date.valueOf(ACETUtility.formatDateFutureDate('6/7/1979'));
        pa2.firstName = 'Community'; 
        pa2.lastName = 'FLCreteamTestUser1'; 
        pa2.RecordTypeId = personAccRecordTypeId;
        pa2.MultiPolicyCheck__c=true;
        pa2.Email_Notification__c = true;
        accList.add(pa2);   
        insert accList;
        
        set<id> accSet=new set<id>{(pa.Id),(pa2.Id)};
            Id contactId,contactId1;
        for(Contact con:[SELECT id,accountId from contact where accountId in : accSet]){
            if(con.accountId==pa.Id)
                contactId=con.id;
            else
                contactId1=con.id; 
        }
        
        List<AccountContactRelation> acrList=new List<AccountContactRelation>();
        AccountContactRelation acr=new AccountContactRelation();
        acr.AccountId=ac.id;
        acr.contactID= contactId;
        acrList.add(acr);
        
        AccountContactRelation acr1=new AccountContactRelation();
        acr1.AccountId=ac.id;
        acr1.contactID= contactId1;
        acrList.add(acr1);
        
        insert acrList;
        
        SNI_FL_Care_Team_Member__c teamMemb = new SNI_FL_Care_Team_Member__c();
        teamMemb.SNI_FL_Primary_Caregiver__c = false;
        teamMemb.SNI_FL_Status__c='Registered';
        teamMemb.SNI_FL_Family__c = ac.Id;
        teamMemb.SNI_FL_Member__c = pa.Id;
        teamMemb.SNI_FL_Not_Visible_in_Familylink__c = false;
        teamlist.add(teamMemb);
        
        SNI_FL_Care_Team_Member__c teamMemb1 = new SNI_FL_Care_Team_Member__c();
        teamMemb1.SNI_FL_Primary_Caregiver__c = false;
        teamMemb1.SNI_FL_Family__c = ac.Id;
        teamMemb1.SNI_FL_Member__c = pa2.Id;
        teamMemb1.SNI_FL_Status__c='Registered';
        teamMemb1.SNI_FL_Not_Visible_in_Familylink__c = false;
        teamlist.add(teamMemb1);
        insert teamlist;
        
        List<SNI_FL_Members_ROI__c> roiList = new List<SNI_FL_Members_ROI__c>();
        SNI_FL_Members_ROI__c roi1 = new SNI_FL_Members_ROI__c();
        roi1.SNI_FL_Status__c = 'Active';
        roi1.SNI_FL_ROI_Signed_With__c = teamMemb.id;
        roi1.SNI_FL_Member__c =teamMemb.id;
        roiList.add(roi1);
        SNI_FL_Members_ROI__c roi2 = new SNI_FL_Members_ROI__c();
        roi2.SNI_FL_Status__c = 'Active';
        roi2.SNI_FL_ROI_Signed_With__c = teamMemb1.id;
        roiList.add(roi2);
        insert roiList;
        
        
        List<Contact> conId = [SELECT id from contact where accountId =: pa.Id];
        List<Profile> pList = [SELECT Id,Name FROM Profile WHERE Name =: 'Care Advisor Connect Community User']; 
        User thisUser = [Select Id From User Where Id =:UserInfo.getUserId()];
        
        
        List<case> caselist = new List<case>();
        Case cas = new case();
        Id ecmRecordTypeID = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('ECM').getRecordTypeId();
        Case ecmCas = TestDataFactory.createCases(1)[0];
        ecmCas.RecordTypeId =ecmRecordTypeID;
        ecmCas.Topic__c = 'Appeals - Post Service';
        ecmCas.AccountId = pa.Id;
        ecmCas.ContactId = contactId;
        ecmCas.UHG_Restriction__c = 'No';
        ecmCas.DOB__c = '1999/08/09';
        ecmCas.Onshore_Restriction__c = 'No';
        ecmCas.Subject_Name__c = 'ECM Test case' ;
        ecmCas.Subject_Group_ID__c = '0070145';
        ecmCas.ParentId =cas.Id;
        ecmCas.status='Open';        
        ecmCas.Case_Type__c = 'Opportunity';
        ecmCas.ID__c = '453543145';
        ecmCas.Policy_ID__c = '0070145';
        ecmCas.Community__c = true;
        caselist.add(ecmCas);
        insert caselist;
        
        List<case> newCaselist = new List<case>();
        Case cas1 = new case();
        Case ecmCas2 = TestDataFactory.createCases(1)[0];
        ecmCas2.RecordTypeId =ecmRecordTypeID;
        ecmCas2.Topic__c = 'Appeals - Post Service';
        ecmCas2.AccountId = pa2.Id;
        ecmCas2.ContactId = contactId1;
        ecmCas2.UHG_Restriction__c = 'No';
        ecmCas2.DOB__c = '1989/08/09';
        ecmCas2.Onshore_Restriction__c = 'No';
        ecmCas2.Subject_Name__c = 'ECM Test case 2' ;
        ecmCas2.Subject_Group_ID__c = '0070145';
        ecmCas2.ParentId =cas1.Id;
        ecmCas2.status='Open';        
        ecmCas2.Case_Type__c = 'Opportunity';
        ecmCas2.ID__c = '453543145';
        ecmCas2.Policy_ID__c = '0070145';
        ecmCas2.Community__c = true;
        newCaselist.add(ecmCas2);
        insert newCaselist;
        
        List<SNI_FL_Case_Notification__c> newNotificationlist = new List<SNI_FL_Case_Notification__c>();
        SNI_FL_Case_Notification__c notification = new SNI_FL_Case_Notification__c();
        notification.Name = ecmCas.Subject_Name__c;
        notification.Contact_Name__c = contactId;
        notification.Is_Viewed__c = false;        
        notification.Is_Viewed_Authorized_Member__c  = false;
        newNotificationlist.add(notification);
        insert newNotificationlist;
        
        List<SNI_FL_Case_Notification__c> newNotificationlist2 = new List<SNI_FL_Case_Notification__c>();
        SNI_FL_Case_Notification__c notification2 = new SNI_FL_Case_Notification__c();
        notification2.Name = ecmCas.Subject_Name__c;
        notification2.Contact_Name__c = contactId;
        notification2.Is_Viewed__c = true;        
        notification2.Is_Viewed_Authorized_Member__c  = true;
        newNotificationlist2.add(notification2);
        insert newNotificationlist2;
        
        Id loggedUserId = UserInfo.getUserId();
        String familyId = ac.Id;
        System.runAs(thisUser){
            User u = new User(Alias = 'standt', Email='flCareTeamtest@testorg.com', 
                              EmailEncodingKey='UTF-8', FirstName='Test007',LastName='Testing', LanguageLocaleKey='en_US', 
                              LocaleSidKey='en_US', ProfileId = pList.get(0).id, contactId =conId[0].Id,
                              TimeZoneSidKey=TIMEZONE,MobilePhone='9000000001', UserName='flCareTeamtest@testorg.com',IsActive=true);
            insert u;
            
            List<Contact> conId1 = [SELECT id from contact where accountId =: pa2.Id];
            List<Profile> pList1 = [SELECT Id,Name FROM Profile WHERE Name =: 'Care Advisor Connect Community User']; 
            User u1 = new User(Alias = 'standt1', Email='flCareTeamtest1@testorg.com', 
                               EmailEncodingKey='UTF-8', FirstName='Test008',LastName='Testing1', LanguageLocaleKey='en_US', 
                               LocaleSidKey='en_US', ProfileId = pList1.get(0).id, contactId =conId1[0].Id,
                               TimeZoneSidKey=TIMEZONE,MobilePhone='9000000001', UserName='flCareTeamtest1@testorg.com',IsActive=true);
            insert u1;
            
            System.runAs(u){ // Making changes as the account owner cannot be a community user
                Test.startTest();
                SNI_FL_HomeController.markNewCaseNotification(loggedUserId,familyId);
                SNI_FL_HomeController.markNewCaseNotification('001m000001CirBBAZ',familyId);
                SNI_FL_HomeController.deleteReadCases(loggedUserId,familyId);
                SNI_FL_HomeController.deleteReadCases(u.Id,familyId);
                SNI_FL_HomeController.deleteReadCases(u1.Id,familyId);
                SNI_FL_HomeController.deleteReadCases('001m000001CirBBAAZ',familyId);
                Test.stopTest();
            }
        }
    } 
    
}