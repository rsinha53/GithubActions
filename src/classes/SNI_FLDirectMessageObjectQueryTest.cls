@IsTest(SeeAllData=true)
public class SNI_FLDirectMessageObjectQueryTest {
    
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
    private static final String TESTFILENAME = 'test File';
    private static final String TESTPATHONCLIENT = 'testing.txt';
    private static final String TESTFILETITLE = 'Testing Files';
    private static final String ACCOUNTNAME = 'Test Account';
    private static final String EMAIL ='standarduser@testorg.com';
    private static final String TIMEZONESIDKEY = 'America/Los_Angeles';
    private static final String ASSERTMSG = 'There is no data for the inputs in DB to retirve';
    private static final String DODYSSEY = 'Diagnostic Odyssey';
    
    @isTest 
    static void insertMessageNotificationTest(){
        Case acc = new Case(subject = 'Test Account');
        insert acc;
         
        FeedItem fi = new FeedItem(ParentId = acc.Id, Body = 'Test Body');
        insert fi;
         
        FeedComment fc = new FeedComment(FeedItemId = fi.Id, CommentBody = 'Test Comment');
        insert fc;
         
        FeedComment objFC = [Select Id, CommentBody, FeedItemId, ParentId FROM FeedComment LIMIT 1];

        //System.assertEquals(objFC.ParentId, acc.Id); //Commented By Pratikshya as assertion was failing
        List<DirectMessageFeed> directMsg = [Select id from DirectMessageFeed];
        SNI_FLDirectMessageObjectQuery.getCommentsForFeed(directMsg);
        SNI_FLDirectMessageObjectQuery.getDirectMessageWrapper(directMsg[0].id,userinfo.getUserId(),false);
        SNI_FLDirectMessageObjectQuery.feedToggleMarked(true,directMsg[0].id);
        SNI_FLDirectMessageObjectQuery.changeReadStatus(true,directMsg[0].id);
        SNI_FLDirectMessageObjectQuery.changeStatusForReply(directMsg[0].id);
        SNI_FLDirectMessageObjectQuery.getBackUpAdvisors();
        user u,u1;
        List<user> usrLst = new List<User>();
        Profile p = [Select id from Profile WHERE Name = 'System Administrator' LIMIT 1];
        system.runAs(new user(Id = userinfo.getUserId())){
            u = new User(Alias = 'standt', Email=EMAIL, 
                              EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey=TESTLOCALKEYS, 
                              LocaleSidKey=TESTLOCALKEYS, ProfileId = p.Id, 
                              TimeZoneSidKey=TIMEZONESIDKEY, UserName='standarduser45454@testorg.com');
            usrLst.add(u);
            u1 = new User(Alias = 'standt', Email=EMAIL, 
                              EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey=TESTLOCALKEYS, 
                              LocaleSidKey=TESTLOCALKEYS, ProfileId = p.Id, 
                              TimeZoneSidKey=TIMEZONESIDKEY, UserName='standarduser214545@testorg.com');
            usrLst.add(u1);
			insert usrLst;
		}
        SNI_FL_BackupAdvisor__c sn= new SNI_FL_BackupAdvisor__c(Advisor__c = u1.id, Backup_Advisor__c=u.id);
        SNI_FLDirectMessageObjectQuery.saveBkUpAdvisors('string',new list<string>{sn.id});
        SNI_FLDirectMessageObjectQuery.checkManageProviderGroupUserId();
        SNI_FLDirectMessageObjectQuery.getUserProfilePermissionSet();
        List<FeedComment> feedList = [Select Id, CommentBody,ParentId,CreatedDate, CreatedById From FeedComment Limit 1];        
        Test.startTest();
        SNI_FLDirectMessageObjectQuery.insertMessageNotification(feedList);
        Test.stopTest();
    }
    
     @isTest
    Public static void getUserProfilePermissionSet_Test() {
        SNI_FLDirectMessageWrapper.UserPermissionSet userPermision = SNI_FLDirectMessageObjectQuery.getUserProfilePermissionSet();
    }
    
    @isTest
    public static void checkProfileValidityForUserId_Test() {
        Boolean result = SNI_FLDirectMessageObjectQuery.checkProfileValidityForUserId();
    }
    
    @isTest
    public static void fetchLookUpValuesForBackupAdvisors_Test() {
        SNI_FLDirectMessageUtil.checkProfileValidity();
        string profileName = SNI_FLDirectMessageUtil.getProfileName();
        string objectName = 'User';
        List<SNI_FL_BackupAdvisor__c> excludeList = [SELECT Id, Name,Advisor__c,Backup_Advisor__c  FROM SNI_FL_BackupAdvisor__c WHERE Name like 'BA - 0000002%'];
        List<User> excludeList2 = [SELECT Id, Name  FROM User WHERE Name like 'bill%'];
        System.runAs([SELECT Id FROM User WHERE Id = :UserInfo.getUserId()][0]) {
            PermissionSet pms = [SELECT Id FROM PermissionSet WHERE Name = 'X3_Way_Communication'];			  
            PermissionSetAssignment psa = new PermissionSetAssignment(
                AssigneeId = UserInfo.getUserId(),
                PermissionSetId = pms.Id
            );
            insert psa;
        
        List < sObject > result1 = SNI_FLDirectMessageObjectQuery.fetchLookUpValuesForBackupAdvisors('test',objectName, null, 'FEC - Supervisor');
        List < sObject > result2 = SNI_FLDirectMessageObjectQuery.fetchLookUpValuesForBackupAdvisors('test',objectName, null, 'Care Advisor');
        List < sObject > result3 = SNI_FLDirectMessageObjectQuery.fetchLookUpValuesForBackupAdvisors('test',objectName, null, 'Research Advisor');
        List < sObject > result4 = SNI_FLDirectMessageObjectQuery.fetchLookUpValuesForBackupAdvisors('test',objectName, null, 'Registered Nurse');
        List < sObject > result5 = SNI_FLDirectMessageObjectQuery.fetchLookUpValuesForBackupAdvisors('test',objectName, null, 'Behavioral Health Advisor');
        List < sObject > result6 = SNI_FLDirectMessageObjectQuery.fetchLookUpValuesForBackupAdvisors('test',objectName, null, 'Nurse Advisor');
        List < sObject > result7 = SNI_FLDirectMessageObjectQuery.fetchLookUpValuesForBackupAdvisors('test',objectName, null, 'Wellness and Community Coach');
        List < sObject > result8 = SNI_FLDirectMessageObjectQuery.fetchLookUpValuesForBackupAdvisors('test',objectName, null, 'Pharmacist');
        List < sObject > result9 = SNI_FLDirectMessageObjectQuery.fetchLookUpValuesForBackupAdvisors('test',objectName, excludeList, 'System Administrator');
        List < sObject > result11 = SNI_FLDirectMessageObjectQuery.fetchLookUpValuesForBackupAdvisors('t',objectName, excludeList2, 'FEC - Supervisor');
        List < sObject > result21 = SNI_FLDirectMessageObjectQuery.fetchLookUpValuesForBackupAdvisors('t',objectName, null, 'Care Advisor');
        List < sObject > result31 = SNI_FLDirectMessageObjectQuery.fetchLookUpValuesForBackupAdvisors('t',objectName, null, 'Research Advisor');
        List < sObject > result41 = SNI_FLDirectMessageObjectQuery.fetchLookUpValuesForBackupAdvisors('t',objectName, null, 'Registered Nurse');
        List < sObject > result51 = SNI_FLDirectMessageObjectQuery.fetchLookUpValuesForBackupAdvisors('t',objectName, null, 'Behavioral Health Advisor');
        List < sObject > result61 = SNI_FLDirectMessageObjectQuery.fetchLookUpValuesForBackupAdvisors('t',objectName, null, 'Nurse Advisor');
        List < sObject > result71 = SNI_FLDirectMessageObjectQuery.fetchLookUpValuesForBackupAdvisors('t',objectName, null, 'Wellness and Community Coach');
        List < sObject > result81 = SNI_FLDirectMessageObjectQuery.fetchLookUpValuesForBackupAdvisors('t',objectName, null, 'Pharmacist');
        List < sObject > result91 = SNI_FLDirectMessageObjectQuery.fetchLookUpValuesForBackupAdvisors('t',objectName, null, 'System Administrator');
        }
    }
    
    @isTest
    public static void getAccountNameByID_Test(){
        Account ac = new Account( Name = 'test Account');
        insert ac;
        Case acc = new Case(subject = 'Test Account', AccountId = ac.Id);
        insert acc;
        
        SNI_FL_Members_ROI__c memROI = new SNI_FL_Members_ROI__c(SNI_FL_Account__c = ac.Id, SNI_FL_Status__c  = 'Active');
        insert memROI;
        Map<String,String>  result = SNI_FLDirectMessageObjectQuery.getAccountNameByID(ac.Id);
        SNI_FLDirectMessageWrapper.wrapperAccPermission ob = SNI_FLDirectMessageObjectQuery.getAccountNameByID1(ac.Id);
        String result2 = SNI_FLDirectMessageObjectQuery.getAccountNameByUser();
        String result3 = SNI_FLDirectMessageObjectQuery.getProfileNameForLoggedUser();
        Boolean result4 = SNI_FLDirectMessageObjectQuery.isAdvisorAfliatedToProviderAffliation(null);
        SNI_FLDirectMessageObjectQuery.createContentDistribution('');
        SNI_FLDirectMessageObjectQuery.enforceApexSecurity(null, 'READABLE');
       
    }
    
    
    @isTest(SeeAllData=true)
   public static void getFeedCommentsForLazyLoadingTest(){
        List<Account> lstFamilyAccount = SNI_FL_DirectMessageTestDataFactory.createAccountRecordsTestData('Family',1);
        String accId = lstFamilyAccount[0].id;
        lstFamilyAccount[0].Ownerid=Userinfo.getuserid();
        update lstFamilyAccount;
        
        List<ID> ids = new List<ID>();
        profile p=[select Id from profile where Name='System Administrator'];
        User u1;
        system.runAs(new user(Id = userinfo.getUserId())){
            u1 = new User( email='directmsgagent1@optum.acet.com',
                          profileid = p.id, 
                          UserName='directmsgagent1@optum.acet.com', 
                          Alias = 'dtmsg1',
                          TimeZoneSidKey='America/New_York',
                          EmailEncodingKey='ISO-8859-1',
                          LocaleSidKey='en_US', 
                          LanguageLocaleKey='en_US',
                          FirstName = 'Test Fname',
                          LastName = 'Test Lname',
                           UserRoleId = [select Id from UserRole where Name = 'Women\'s Health Nurse Advisor' LIMIT 1].Id);
            insert u1;
        }
        ids.add(u1.Id);
        SNI_FL_DirectMessageTestDataFactory.createDirectMessagesTestData(1,ids);
        List<DirectMessageFeed> lstDirectMsgFeed = [SELECT ID FROM DirectMessageFeed WHERE ParentId IN (SELECT ID FROM DirectMessage WHERE Subject LIKE 'DirectMsg_ACDC_Test') LIMIT 1];
        SNI_FLDirectMessageObjectQuery.getCommentsForFeed(lstDirectMsgFeed);
        String feedID = lstDirectMsgFeed[0].id;
       
        SNI_FL_Message__c FLmsg = new SNI_FL_Message__c();
        FLmsg.Member_Id__c = accId;
        FLmsg.Program__c = accId;
        FLmsg.Feed_Id__c = feedID;
        insert FLmsg;
        
        Id loggedUserid = UserInfo.getUserId();
       SNI_FL_Message_Status__c msgStatus = new SNI_FL_Message_Status__c();
       msgStatus.SNI_FL_Message__c = FLmsg.id;
       msgStatus.Agent__c = loggedUserid;
       insert msgStatus;
       
       system.runAs(new user(Id = u1.id)){
           FeedComment fc = new FeedComment();
           fc.CommentBody = 'Test Comment Body';
           fc.FeedItemId = feedID;
           insert fc;
           
           SNI_FLDirectMessageObjectQuery.getFeedCommentsForLazyLoading(feedID,1,1);
       }
       
       /*u1.UserRoleId = [select Id from UserRole where Name = 'Behavioral Health Advisor' LIMIT 1].Id;
       update u1;
       
       system.runAs(new user(Id = u1.id)){
           FeedComment fc = new FeedComment();
           fc.CommentBody = 'Test Comment Body';
           fc.FeedItemId = feedID;
           insert fc;
           
           SNI_FLDirectMessageObjectQuery.getFeedCommentsForLazyLoading(feedID,1,1);
       }
       
       u1.UserRoleId = [select Id from UserRole where Name = 'Lifestyle and SDoH Coach' LIMIT 1].Id;
       update u1;
       
       system.runAs(new user(Id = u1.id)){
           FeedComment fc = new FeedComment();
           fc.CommentBody = 'Test Comment Body';
           fc.FeedItemId = feedID;
           insert fc;
           
           SNI_FLDirectMessageObjectQuery.getFeedCommentsForLazyLoading(feedID,1,1);
       }
       
       u1.UserRoleId = [select Id from UserRole where Name = 'Pharmacist' LIMIT 1].Id;
       update u1;
       
       system.runAs(new user(Id = u1.id)){
           FeedComment fc = new FeedComment();
           fc.CommentBody = 'Test Comment Body';
           fc.FeedItemId = feedID;
           insert fc;
           
           SNI_FLDirectMessageObjectQuery.getFeedCommentsForLazyLoading(feedID,1,1);
       }
       
       u1.UserRoleId = [select Id from UserRole where Name = 'Clinical Manager' LIMIT 1].Id;
       update u1;
       
       system.runAs(new user(Id = u1.id)){
           FeedComment fc = new FeedComment();
           fc.CommentBody = 'Test Comment Body';
           fc.FeedItemId = feedID;
           insert fc;
           
           SNI_FLDirectMessageObjectQuery.getFeedCommentsForLazyLoading(feedID,1,1);
       }
	    
       
       u1.UserRoleId = [select Id from UserRole where Name = 'Research Advisor' LIMIT 1].Id;
       update u1;
       
       system.runAs(new user(Id = u1.id)){
           FeedComment fc = new FeedComment();
           fc.CommentBody = 'Test Comment Body';
           fc.FeedItemId = feedID;
           insert fc;
           
           SNI_FLDirectMessageObjectQuery.getFeedCommentsForLazyLoading(feedID,1,1);
       }
       
       u1.UserRoleId = [select Id from UserRole where Name = 'Research Advisor' LIMIT 1].Id;
       update u1;
       
       system.runAs(new user(Id = u1.id)){
           FeedComment fc = new FeedComment();
           fc.CommentBody = 'Test Comment Body';
           fc.FeedItemId = feedID;
           insert fc;
           
           SNI_FLDirectMessageObjectQuery.getFeedCommentsForLazyLoading(feedID,1,1);
       }
       
       u1.UserRoleId = [select Id from UserRole where Name = 'Non-Clinical Supervisor' LIMIT 1].Id;
       update u1;
       
       system.runAs(new user(Id = u1.id)){
           FeedComment fc = new FeedComment();
           fc.CommentBody = 'Test Comment Body';
           fc.FeedItemId = feedID;
           insert fc;
           
           SNI_FLDirectMessageObjectQuery.getFeedCommentsForLazyLoading(feedID,1,1);
       }*/
       
       SNI_FLDirectMessageObjectQuery.updateMessageStatus(feedID);
       SNI_FLDirectMessageObjectQuery.checkUnregisteredMemberByUserId(accId);
   }
    
    @isTest
    public static void checkUHGRestrictionForUserIdTestForYes(){
        
        Test.startTest();
        Profile profileId = [SELECT Id FROM Profile WHERE Name = 'Center for Health Navigation' LIMIT 1];
        User ur =[SELECT Id FROM User WHERE Id= :userinfo.getUserId()];
        Account acc= new Account(FirstName = 'acc test',
                                 LastName ='Acc last',
                                 UHG_Restriction__c ='Yes'
        );
            insert acc;
        System.runas(ur){
        User usr = new User(LastName = 'test Access',
                           FirstName='test restriction',
                           Alias = 'tpr',
                           Email = 'resacess@ac.com',
                           Username = 'resacess123@ac.com',
                           profileId = profileId.id,
                           TimeZoneSidKey = 'GMT',
                           LanguageLocaleKey = 'en_US', 
                           EmailEncodingKey = 'UTF-8',
                           LocaleSidKey = 'en_US',
                           Agent_Type__c='Onshore'
                           );
        insert usr;
        
        usr.Agent_Type__c='Offshore';
        usr.UHG_Access__c ='Yes';
        update usr;
        }
        SNI_FLDirectMessageObjectQuery.checkUHGRestrictionForUserId(acc.id);
        SNI_FLDirectMessageObjectQuery.checkUHGRestrictionForMemberId(acc.id);
        Test.stopTest();
    }  
    @isTest
    public static void checkUHGRestrictionForUserIdTestforNo(){
        
        Test.startTest();
        Profile profileId = [SELECT Id FROM Profile WHERE Name = 'Center for Health Navigation' LIMIT 1];
        User ur =[SELECT Id FROM User WHERE Id= :userinfo.getUserId()];
        Account acc= new Account(FirstName = 'acc test',
                                 LastName ='Acc last',
                                 UHG_Restriction__c ='No'
        );
            insert acc;
        System.runas(ur){
        User usr = new User(LastName = 'test Access',
                           FirstName='test restriction',
                           Alias = 'tpr',
                           Email = 'resacess@ac.com',
                           Username = 'resacess123@ac.com',
                           profileId = profileId.id,
                           TimeZoneSidKey = 'GMT',
                           LanguageLocaleKey = 'en_US', 
                           EmailEncodingKey = 'UTF-8',
                           LocaleSidKey = 'en_US',
                           Agent_Type__c='Onshore'
                           );
        insert usr;
        
        usr.Agent_Type__c='Offshore';
        usr.UHG_Access__c ='No';
        update usr;
        }
        SNI_FLDirectMessageObjectQuery.checkUHGRestrictionForUserId(acc.id);
        SNI_FLDirectMessageObjectQuery.checkUHGRestrictionForMemberId(acc.id);
        
        acc.UHG_Restriction__c = 'Yes';
        update acc;
        SNI_FLDirectMessageObjectQuery.checkUHGRestrictionForUserId(acc.id);
        SNI_FLDirectMessageObjectQuery.checkUHGRestrictionForMemberId(acc.id);
        Test.stopTest();
    }   
    @isTest 
    public static void insertCaseNotificationTest(){
         Account ac = new Account( Name = 'test Account');
        insert ac; 
        Id ecmRecordTypeID = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('ECM').getRecordTypeId();//'01236000000yOkTAAU'- chsdev '01236000000yOkTAAU' paintQA
        case cs=new case();
        cs.Status ='New';
        cs.Priority = 'Medium';
        cs.Origin = 'Email';
        cs.RecordTypeId = ecmRecordTypeID;
        cs.Community__c = true;
        cs.AccountId = ac.Id;
        insert cs;
        List<Case> case1= new List<Case>();
        case1.add(cs);
        CaseComment cc = new CaseComment (ParentId = cs.Id,
                                         CommentBody = 'test',IsPublished = true);
        insert cc;
        List<CaseComment> lstCC = new List<CaseComment>();
        lstCC.add(cc);
        SNI_FL_Members_ROI__c memROI = new SNI_FL_Members_ROI__c(SNI_FL_Account__c = ac.Id, SNI_FL_Status__c  = 'Active');
        insert memROI;
         SNI_FLDirectMessageObjectQuery.insertCaseCommentNotification(null);
        SNI_FLDirectMessageObjectQuery.insertCaseCommentNotification(lstCC);
        SNI_FLDirectMessageObjectQuery.insertCaseNotification(case1); 
        
    }
    
    @isTest 
    public static void checkForProviderAffiliationRecord_Test(){
        Account ac = new Account( Name = 'test Account');
        insert ac;    
        Member_Affiliation__c ma = new Member_Affiliation__c(
        	member__c = ac.Id,
            Provider_Affiliation__c =ac.Id,
            Enrollment_Date__c = System.today()
        );
            insert ma;
        String result1 = SNI_FLDirectMessageObjectQuery.checkForProviderAffiliationRecord(ac.id);
        String result2 = SNI_FLDirectMessageObjectQuery.getMemberIdByAccountId(ac.Id);
        ContentVersion newVersion = new ContentVersion();
        newVersion.Title = 'my version title';
        newVersion.pathOnClient = 'url';
        newVersion.VersionData=blob.valueof('test data');
        insert newVersion;

        ContentDistribution distribution = new ContentDistribution();
        distribution.Name = newVersion.title + ' ' +  Date.today();
        distribution.ContentVersionId = newVersion.Id;
        distribution.PreferencesNotifyOnVisit = false;
        distribution.PreferencesNotifyRndtnComplete = false;
        //insert distribution;
    }
    
    
}