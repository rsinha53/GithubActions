@IsTest(SeeAllData=true)
public class SNI_FL_DirectMessageObjectQueryTest {
    @isTest
    static void testCaseCommentNotification (){
        Id coRecordTypeID = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Case Overview').getRecordTypeId();
        Id ecmRecordTypeID = Schema.SObjectType.Case.getRecordTypeInfosByName().get('ECM').getRecordTypeId();
        Id familyRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Family').getRecordTypeId();
        Id personAccRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Individual').getRecordTypeId();
        
        User u = [Select id from User where Profile.Name = 'System Administrator' and isActive = true and Id !=:userinfo.getUserId() limit 1];
        String userId = u.id;
        DirectMessageMember dsm=[SELECT DirectMessageId,MemberId FROM DirectMessageMember limit 1];
        
        system.runAs(u){
            
            Account ac = new Account();
            ac.Member_ID__c = '453543145';
            ac.Policy_ID__c = '0070145';
            ac.Name =   'Member1 Bourne Family';
            ac.RecordTypeId = familyRecordTypeId;
            ac.OwnerId=dsm.MemberId;
            insert ac;
            
            String accId = ac.id;
            
            Contact con= new Contact();
            con.firstname = 'test';
            con.lastname = 'test';
            con.AccountId = ac.id;
            insert con;
            
            Profile portal = [SELECT Id FROM Profile WHERE Name = 'Care Advisor Connect Provider User' LIMIT 1];  
            
            
            user u1 = new User( email='directmsgagent1@optum.acet.com',
                               profileid = portal.id, 
                               UserName='directmsgagent1@optum.acet.com', 
                               Alias = 'dtmsg1',
                               TimeZoneSidKey='America/New_York',
                               EmailEncodingKey='ISO-8859-1',
                               LocaleSidKey='en_US', 
                               LanguageLocaleKey='en_US',
                               ContactId=con.Id,
                               FirstName = 'Test Fname',
                               LastName = 'Test Lname');
            // insert u1;
            
            Account pa =new account();
            pa.PersonBirthdate = date.valueOf(ACETUtility.formatDateFutureDate('6/17/1979'));
            pa.firstName = 'Member1'; 
            pa.lastName = 'Bourne'; 
            pa.RecordTypeId = personAccRecordTypeId;
            pa.Policy_ID__c = '123456';
            insert pa;
            
            Account personAcc = [Select PersonContactId From Account Where Id = :pa.Id];
            AccountContactRelation acr = new AccountContactRelation();
            acr.ContactId = personAcc.PersonContactId;            
            acr.Accountid = ac.id;
            acr.Relationship__c = 'Child/Other';
            insert acr;
            
            SNI_FL_Care_Team_Member__c careTeamRecord1 = new SNI_FL_Care_Team_Member__c();
            careTeamRecord1.SNI_FL_Family__c = ac.id;
            careTeamRecord1.SNI_FL_Member__c = pa.id;
            careTeamRecord1.SNI_FL_Status__c    = 'Registered';
            insert careTeamRecord1;
            
            SNI_FL_Members_ROI__c memberROI1 = new SNI_FL_Members_ROI__c();
            memberROI1.SNI_FL_Member__c = careTeamRecord1.id;
            memberROI1.SNI_FL_ROI_Signed_With__c =careTeamRecord1.id;
            memberROI1.SNI_FL_Status__c = 'Active';
            memberROI1.SNI_FL_Account__c = pa.id;
            insert memberROI1;
            
            Case ecmCas = TestDataFactory.createCases(1)[0];
            ecmCas.RecordTypeId =ecmRecordTypeID;
            ecmCas.Topic__c = 'Appeals - Post Service';
            ecmCas.Type__c = 'Family Advisor';
            ecmCas.Subject_Group_ID__c = '123456';
            ecmCas.Case_Type__c = 'Opportunity';
            ecmCas.Status = 'Open';
            ecmCas.AccountId = pa.Id;
            ecmCas.Community__c = true;
            Insert ecmCas;
            
            List<CaseComment> caseComLst=new List<CaseComment>();
            CaseComment tComment = new CaseComment();
            tComment.CommentBody = 'Some Comment';
            tComment.ParentId = ecmCas.Id;
            tComment.IsPublished = true;
            insert tComment;
            caseComLst.add(tComment);
            
            List<SNI_FL_Message__c> FLmsgLst = new List<SNI_FL_Message__c>();
            SNI_FL_Message__c FLmsg = new SNI_FL_Message__c();
            FLmsg.Member_Id__c = ac.id;
            FLmsg.Program__c = String.ValueOf(ac.id);
            FLmsg.Feed_Id__c = '1234';
            FLmsg.Marked__c=true;
            FLmsg.Family_ID__c=ac.id;
            insert FLmsg;
            FLmsgLst.add(FLmsg);
            String flmsgId = FLmsg.id;
            
            SNI_FL_Message_Status__c msgSts = new SNI_FL_Message_Status__c();
            msgSts.SNI_FL_Message__c = FLmsg.id;
            msgSts.Agent__c = u.id;
            insert msgSts;
            
            
            
            
            
            DirectMessageFeed dsf= [select id,CreatedById,ParentId from DirectMessageFeed Limit 1];
            //insert dsf;
            FLmsg.Feed_Id__c=dsf.id;
            update FLmsg;
            
            Test.startTest();
            SNI_FLDirectMessageObjectQuery.insertCaseCommentNotification(caseComLst);
            SNI_FLDirectMessageObjectQuery.getUserProfilePermissionSet();
            SNI_FL_DirectMessageObjectQuery.retrieveDirectMessageList(true,ac.id,'test',1,1,true,true,False,'test',true,true);
            SNI_FL_DirectMessageObjectQuery.getDirectMessageIdFromFeed(FLmsgLst);
            SNI_FL_DirectMessageObjectQuery.getlstOfMessagesForFamilyAccount(ac.id,u.id,true);
            SNI_FL_DirectMessageObjectQuery.getlstOfMessagesForFamilyAccount(ac.id,u.id,false);
            SNI_FL_DirectMessageObjectQuery.getDirectMessagesId(false,accId,userId,true,false,true,'empty',true);
            SNI_FL_DirectMessageObjectQuery.getDirectMessagesId(false,accId,userId,true,true,true,'1234',true);
            SNI_FL_DirectMessageObjectQuery.getDirectMessagesId(false,accId,userId,true,false,true,flmsgId,true);
            SNI_FL_DirectMessageObjectQuery.getSuperAdminMessagesForFamilyMember(accId,userId,true,true,true);
            SNI_FL_DirectMessageObjectQuery.getSuperAdminMessagesForFamilyMember(accId,userId,false,true,true);
            SNI_FL_DirectMessageObjectQuery.getAllRelatedToMembers('test');
            SNI_FL_DirectMessageObjectQuery.markAsUnread('1234');
            SNI_FL_DirectMessageObjectQuery.advisorAffliationList();
            SNI_FL_DirectMessageObjectQuery.getDirectMessageIdForAgents(dsm.MemberId,true);
            SNI_FL_DirectMessageObjectQuery.getMapOfDirectMessageIDswithMembers(new list<id>{userId});
            SNI_FL_DirectMessageObjectQuery.getSortedDirstMsgList(userId,new list<DirectMessageFeed>{dsf},Null,True,True);
            SNI_FL_DirectMessageObjectQuery.getUserdetails(new list<DirectMessageFeed>{dsf});
            SNI_FL_DirectMessageObjectQuery.sortReadMsgListAndReturn(new list<DirectMessageFeed>{dsf},new list<DirectMessageFeed>{dsf});
            //SNI_FL_DirectMessageObjectQuery.getMemberIdOfProvider(pa.Id);
            try{
                SNI_FL_DirectMessageObjectQuery.getProviderFLMessagesRecord(Null,FLmsg,new list<SNI_FL_Message_Status__c>{msgSts});
            }catch (exception e){}
            Test.stopTest();
        }
    }
    @isTest
    static void testCaseCommentNotificationNegative (){
        Id coRecordTypeID = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Case Overview').getRecordTypeId();
        Id ecmRecordTypeID = Schema.SObjectType.Case.getRecordTypeInfosByName().get('ECM').getRecordTypeId();
        Id familyRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Family').getRecordTypeId();
        Id personAccRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Individual').getRecordTypeId();
        
        User u = [Select id from User where Profile.Name = 'System Administrator' and isActive = true and Id !=:userinfo.getUserId() limit 1];
        system.runAs(u){
            Account ac = new Account();
            ac.Member_ID__c = '453543145';
            ac.Policy_ID__c = '0070145';
            ac.Name =   'Member1 Bourne Family';
            ac.RecordTypeId = familyRecordTypeId;
            insert ac;
            
            Contact con= new Contact();
            con.firstname = 'test';
            con.lastname = 'test';
            con.AccountId = ac.id;
            insert con;
            
            Account pa =new account();
            pa.PersonBirthdate = date.valueOf(ACETUtility.formatDateFutureDate('6/17/1979'));
            pa.firstName = 'Member1'; 
            pa.lastName = 'Bourne'; 
            pa.RecordTypeId = personAccRecordTypeId;
            pa.Policy_ID__c = '123456';
            insert pa;
            
            Account personAcc = [Select PersonContactId From Account Where Id = :pa.Id];
            AccountContactRelation acr = new AccountContactRelation();
            acr.ContactId = personAcc.PersonContactId;            
            acr.Accountid = ac.id;
            acr.Relationship__c = 'Child/Other';
            insert acr;
            
            
            Case ecmCas = TestDataFactory.createCases(1)[0];
            ecmCas.RecordTypeId =ecmRecordTypeID;
            ecmCas.Topic__c = 'Appeals - Post Service';
            ecmCas.Type__c = 'Family Advisor';
            ecmCas.Subject_Group_ID__c = '123456';
            ecmCas.Case_Type__c = 'Opportunity';
            ecmCas.Status = 'Open';
            ecmCas.AccountId = pa.Id;
            ecmCas.Community__c = true;
            Insert ecmCas;
            
            List<CaseComment> caseComLst=new List<CaseComment>();
            CaseComment tComment = new CaseComment();
            tComment.CommentBody = 'Some Comment';
            tComment.ParentId = ecmCas.Id;
            tComment.IsPublished = true;
            insert tComment;
            caseComLst.add(tComment);
            Test.startTest();
            SNI_FLDirectMessageObjectQuery.insertCaseCommentNotification(caseComLst);
            Test.stopTest();
        }
    }
    @isTest
    static void getCommentsFeedTest(){
        List<Account> lstFamilyAccount = SNI_FL_DirectMessageTestDataFactory.createAccountRecordsTestData('Family',1);
        lstFamilyAccount[0].Ownerid=Userinfo.getuserid();
        update lstFamilyAccount;
        
        List<SNI_FL_Message__c> FLmsgLst = new List<SNI_FL_Message__c>();
        SNI_FL_Message__c FLmsg = new SNI_FL_Message__c();
        FLmsg.Member_Id__c = lstFamilyAccount[0].id;
        FLmsg.Program__c = String.ValueOf(lstFamilyAccount[0].id);
        FLmsg.Feed_Id__c = '1234';
        insert FLmsg;
        
        SNI_FL_Message_Status__c msgSts = new SNI_FL_Message_Status__c();
        msgSts.SNI_FL_Message__c = FLmsg.id;
        msgSts.Agent__c = userinfo.getUserId();
        insert msgSts;
        
        //FLmsgLst.add(FLmsg);
        map<id,SNI_FL_Message__c> msg2= new map<id,SNI_FL_Message__c>();
        msg2.put(FLmsg.id,FLmsg);
        List<ID> ids = new List<ID>();
        profile p=[select Id from profile where Name='System Administrator'];
        DirectMessageFeed dsf=[select id from DirectMessageFeed limit 1];
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
                          LastName = 'Test Lname');
            insert u1;
        }
        ids.add(u1.Id);
        SNI_FL_DirectMessageTestDataFactory.createDirectMessagesTestData(1,ids);
        List<DirectMessageFeed> lstDirectMsgFeed = [SELECT ID FROM DirectMessageFeed WHERE ParentId IN (SELECT ID FROM DirectMessage WHERE Subject LIKE 'DirectMsg_ACDC_Test') LIMIT 1];
        SNI_FLDirectMessageObjectQuery.getCommentsForFeed(lstDirectMsgFeed);
        SNI_FL_DirectMessageObjectQuery.SNI_FLMessage msgWrapper1 = new SNI_FL_DirectMessageObjectQuery.SNI_FLMessage('1234',true,true,'3458','pname',false,'mem123');
        SNI_FL_DirectMessageObjectQuery.SNI_FLMessage msgWrapper2 = new SNI_FL_DirectMessageObjectQuery.SNI_FLMessage(userinfo.getUserId(),'7829','fname',true,false,true,'mem123');
        SNI_FL_DirectMessageObjectQuery.RecordsData recordWrapper = new SNI_FL_DirectMessageObjectQuery.RecordsData('label','value');
        Date myDate = Date.newInstance( 2020, 10, 30 );
        Time myTime = Time.newInstance( 3, 3, 3, 0 );
        DateTime objDT = DateTime.newInstance( myDate, myTime );
        SNI_FL_DirectMessageObjectQuery.SNI_FLUserDetails usr = new SNI_FL_DirectMessageObjectQuery.SNI_FLUserDetails('fname','lname',userinfo.getUserId(),'System Administrator');
        User usr1 = new User(Id= userinfo.getUserId());
        SNI_FL_DirectMessageObjectQuery.SNI_FLDirectMessageFeed feedWrapper = new SNI_FL_DirectMessageObjectQuery.SNI_FLDirectMessageFeed(objDT,objDT,'body','1234',usr);
        SNI_FL_DirectMessageObjectQuery.SNI_FLDirectMessageWrapper dmWrapper = new SNI_FL_DirectMessageObjectQuery.SNI_FLDirectMessageWrapper(new list<SNI_FL_DirectMessageObjectQuery.SNI_FLUserDetails>{usr},'body',Null,Null,1,1,1,1,1);
        SNI_FL_DirectMessageObjectQuery.getDirectMessageIdForFamilyLink(new list<Id>{userinfo.getUserId()},true,'1231','3212',usr1);
        
        List<Id> lstUsers = new List<Id>();
        lstUsers.add(userinfo.getUserId());
        lstUsers.add(u1.Id);
        system.debug('lstUsers+ '+lstUsers);
        try{
            SNI_FL_DirectMessageObjectQuery.createFLMessageWrapper(msg2,dsf);
        }catch (exception e){}
        
        SNI_FL_DirectMessageTestDataFactory.createDirectMessagesTestData(1,lstUsers);
        
    }
}