@isTest
public class SAECaseCommentTriggerTest {
    
    @isTest static void SAECaseCommentTriggerTestMethod() {
        List<User> userLst = new List<User>();
        List<String> profiles = new List<String>();
        profiles.add('Provider Service');
        profiles.add('System Administrator');
        for(String p : profiles){
            User user = TestDataFactory.getUser(p);
            user.UserName = Date.Today().month()+Date.Today().day()+Date.Today().year()+user.UserName ;
            UserLst.add(user);
        }       
        insert userLst;        
        
        List<RecordType> recordType = new List<RecordType>([SELECT Id,Name FROM RecordType WHERE SobjectType='Case' and DeveloperName='BEO' LIMIT 1]);
        List<RecordType> recordType2 = new List<RecordType>([SELECT Id,Name FROM RecordType WHERE SobjectType='Case' and DeveloperName='SAE_Provider' LIMIT 1]);
        Profile profleRec=[SELECT Id From Profile WHERE Name='Standard User' limit 1];
        
        User usrRecord =new User( Alias = 'newUser1' ,
                                 Email ='standard_user1@testuser.com',
                                 EmailEncodingKey = 'UTF-8',
                                 LastName = 'Testing22',
                                 LanguageLocaleKey='en_US',
                                 LocaleSidKey='en_US', 
                                 UserName='standard_user1@testuser.com.acet',
                                 ProfileId=profleRec.Id,
                                 TimeZoneSidKey    = 'America/Los_Angeles');
        insert usrRecord;
        
        system.runAs(usrRecord){
            
            Case caseRec=new Case();
            caseRec.Subject='Test Controller Acct Case';
            caseRec.Status = 'New';
            caseRec.Origin = 'Phone';
            caseRec.recordTypeId = recordType2[0].Id;        
            INSERT caseRec;
            
            List<CaseComment> caseComLst=new List<CaseComment>();
            CaseComment tComment = new CaseComment();
            tComment.CommentBody = 'Some Comment';
            tComment.ParentId = caseRec.Id; 
            caseComLst.add(tComment);    
            SAECaseCommentTriggerHandler.handleBeforeInsert(caseComLst);   
        }
        
        List<case> csLst = new List<case>();
        List<CaseComment> cmLst = new List<CaseComment>();
        
        try{          
            for(User u : userLst){              
                Case cas = TestDataFactory.createCases(1)[0];
                cas.recordTypeId = recordType[0].Id;
                cas.OwnerId=u.id;
                cas.Case_Type__c='BEO Case';
                cas.Department__c='OptumRx PSS Team - Mass Adjustment'; 
                csLst.add(cas);
            }           
            insert csLst;
            
            for(case cs: csLst){
                CaseComment caseComm = new CaseComment();
                caseComm.CommentBody = 'Test Case Comments';
                caseComm.ParentId = cs.Id;
                caseComm.IsPublished=true;
                cmLst.add(caseComm);
            }
            insert cmLst;            
            
        }catch(exception e){
            Boolean expectedExceptionThrown =  e.getMessage().contains('Case comments on SAE cases are not allowed to be added by non SAE users.') ? true : false;
            system.debug('expectedExceptionThrown: '+expectedExceptionThrown);
            System.assertEquals(expectedExceptionThrown, false);
        }
        
    }
    
    @isTest static void coverCasecommentTestMethod(){
        Profile profleRec=[SELECT Id From Profile WHERE Name='Standard User' limit 1];
        List<RecordType> recordType = new List<RecordType>([SELECT Id,Name FROM RecordType WHERE SobjectType='Case' and DeveloperName='BEO' LIMIT 1]);
        
        User usrRecord =new User( Alias = 'newUser1' ,
                                 Email ='newuser123@optum.com',
                                 EmailEncodingKey = 'UTF-8',
                                 LastName = 'Testing',
                                 LanguageLocaleKey='en_US',
                                 LocaleSidKey='en_US', 
                                 UserName='newuser123@optum.com.acet',
                                 ProfileId=profleRec.Id,
                                 TimeZoneSidKey    = 'America/Los_Angeles');
        insert usrRecord;
        
        system.runAs(usrRecord){
            Case caseRec=new Case();
            caseRec.Subject='Test Controller Acct Case';
            caseRec.Status = 'New';
            caseRec.Origin = 'Phone';
            caseRec.Case_Type__c='BEO Case';
            caseRec.recordTypeId = recordType[0].Id;
            caseRec.Department__c='OptumRx PSS Team - Mass Adjustment'; 
            INSERT caseRec;
            
            Case caseRecc=new Case();
            caseRecc.Subject='Test Controller Acct Case';
            caseRecc.Status = 'New';
            caseRecc.Origin = 'Phone';
            caseRecc.Case_Type__c='BEO Case';
            caseRecc.recordTypeId = recordType[0].Id;
            INSERT caseRecc;
            System.assertEquals(caseRecc.Origin, 'Phone');
            
            List<CaseComment> caseComLst=new List<CaseComment>();
            CaseComment tComment = new CaseComment();
            tComment.CommentBody = 'Some Comment';
            tComment.ParentId = caseRecc.Id; 
            caseComLst.add(tComment);
            Test.startTest();
            SAECaseCommentTriggerHandler.handleBeforeInsert(caseComLst);   
            
            caseComLst[0].IsPublished=true;
            Test.stopTest();
        }
    }
}