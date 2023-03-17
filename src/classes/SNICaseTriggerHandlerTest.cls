@isTest
public class SNICaseTriggerHandlerTest {
    //Added below test method by Mounika Ravipudi 
    static testMethod void updateECMcase1(){
        Id coRecordTypeID = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Support Request').getRecordTypeId(); 
        Id familyRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Family').getRecordTypeId();
        User u = [Select id from User where Profile.Name = 'System Administrator' and isActive = true and Id !=:userinfo.getUserId() limit 1];
        
        system.runAs(u){
            Account ac = new Account();
            ac.Member_ID__c = '453543145';
            ac.Policy_ID__c = '0070145';
            ac.Name =   'Member1 Bourne Family';
            ac.RecordTypeId = familyRecordTypeId;
            insert ac;
            
            Case coCase = TestDataFactory.createCases(1)[0];
            coCase.RecordTypeId =coRecordTypeID;                          
            Insert coCase;
            case cs=[select id,OwnerId,RecordTypeId,Account_Owner_Change_Indicator__c from case where RecordTypeId=: coRecordTypeID Limit 1];
            Test.startTest();
            CaseComment c = new CaseComment();
            c.CommentBody ='text' ;
            c.ParentId = cs.id;
            insert c ;
            Map<Id,Case> oldCaseMap=new Map<Id,Case>();
            oldCaseMap.put(coCase.id,coCase);
            cs.OwnerId=userinfo.getUserId();            
            update cs;              
            SNICaseTriggerHandler.supportCaseOwnerChangeValidation(new list<case>{cs},oldCaseMap);
            Test.stopTest();
        }
        
    }
    
    
    static testMethod void updateECMcase(){
        Id coRecordTypeID = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Case Overview').getRecordTypeId();
        Id ecmRecordTypeID = Schema.SObjectType.Case.getRecordTypeInfosByName().get('ECM').getRecordTypeId();
        Id familyRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Family').getRecordTypeId();
        Id personAccRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Individual').getRecordTypeId();
        Id srRecordTypeID = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Support Request').getRecordTypeId();
        
        User u = [Select id from User where Profile.Name = 'System Administrator' and isActive = true and Id !=:userinfo.getUserId() limit 1];
        User u1 = [Select id from User where Profile.Name = 'System Administrator' and isActive = true and Id !=:userinfo.getUserId() AND Id !=:u.Id limit 1];
        List<Case> addCase = new List<Case>();
        Map<Id,Case> CaseMap = new Map<Id,Case>();
        Map<Id,Case> newCaseMap = new Map<Id,Case>();
        system.runAs(u){
            Account ac = new Account();
            ac.Member_ID__c = '453543145';
            ac.Policy_ID__c = '0070145';
            ac.Name =   'Member1 Bourne Family';
            ac.RecordTypeId = familyRecordTypeId;
            insert ac;
            
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
            
            Case coCase = TestDataFactory.createCases(1)[0];
            coCase.RecordTypeId =coRecordTypeID;
            coCase.AccountId = pa.Id;
            Insert coCase;
            // coCase.OwnerId=userinfo.getUserId();
            //  update coCase;
            addCase.add(coCase);
            
            /* Case coCase1 = TestDataFactory.createCases(1)[0];
coCase1.RecordTypeId =srRecordTypeID;
Insert coCase1;
addCase.add(coCase1);

Case coCase2 = new case();
coCase2.Id = coCase1.Id;
coCase2.AccountId = pa.Id;
update coCase2;*/
            
            Case ecmCas = TestDataFactory.createCases(1)[0];
            ecmCas.RecordTypeId =ecmRecordTypeID;
            ecmCas.Topic__c = 'Appeals - Post Service';
            ecmCas.Type__c = 'Family Advisor';
            ecmCas.ParentId = coCase.Id;
            ecmCas.Subject_Group_ID__c = '123456';
            ecmCas.Case_Type__c = 'Opportunity';
            ecmCas.Status = 'Open';
            Insert ecmCas;
            addCase.add(ecmCas);
            CaseMap.put(ecmCas.Id, ecmCas);
            
            Case ecmCas1 = TestDataFactory.createCases(1)[0];
            ecmCas1.RecordTypeId =ecmRecordTypeID;
            ecmCas1.Topic__c = 'Appeals - Post Service';
            ecmCas1.Type__c = 'Family Advisor';
            ecmCas1.ParentId = coCase.Id;
            ecmCas1.Subject_Group_ID__c = '123456';
            ecmCas1.Case_Type__c = 'Opportunity';
            ecmCas1.Status = 'Open';
            ecmCas1.Support_Request__c = ecmCas.Id;
            Insert ecmCas1;
            
            Id taskRecordTypeID = Schema.SObjectType.Task.getRecordTypeInfosByName().get('SENS Task').getRecordTypeId();
            Task ts = new Task();
            ts.Subject = 'Care Advisor Connect Response';
            ts.status = 'Open';
            ts.whatId = ecmCas.Id;
            ts.IsRecurrence = false;
            ts.RecordTypeId = taskRecordTypeID;
            insert ts;
            Test.startTest();
            Map<Id,Case> oldCase = new Map<Id,Case>();
            Case srCas = TestDataFactory.createCases(1)[0];
            srCas.RecordTypeId = srRecordTypeID;
            srCas.OwnerId = UserInfo.getUserId();
            insert srCas;
            oldCase.put(srCas.Id,srCas);
            List<Case> newCase = new List<Case>();
            srCas.OwnerId = u1.id;
            srCas.RecordTypeId = srRecordTypeID;
            srCas.subject = 'Test';
            update srCas;
            newCase.add(srCas);
            CaseTeamRole caseRole = new CaseTeamRole();
            caseRole.Name = 'XYZ';
            caseRole.AccessLevel = 'Read';
            insert caseRole;
            
            CaseTeamMember caseTeam = new CaseTeamMember();
            caseTeam.ParentId = coCase.Id;
            caseTeam.MemberId = personAcc.PersonContactId;
            caseTeam.TeamRoleId = caseRole.Id;
            insert caseTeam;
            
            Family_Overview__c famOverview = new Family_Overview__c();
            famOverview.Account__c = ac.Id;
            insert famOverview;
            
            Member_Information__c memInfo = new Member_Information__c();
            memInfo.Account__c = pa.Id;
            insert memInfo;
            SNICaseTriggerHandler.handleCaseInsert(addCase);
            List<case> closedCase = new List<case>();
            case ecmCaseNew = new case();
            ecmCaseNew.Id = ecmCas.Id;
            ecmCaseNew.Status = 'Assigned';
            update ecmCaseNew;
            newCaseMap.put(ecmCaseNew.Id, ecmCaseNew);
            addCase.add(ecmCas);
            
            SNICaseTriggerHandler.handleCaseUpdate(CaseMap,newCaseMap);
            SNICaseTriggerHandler.handleCaseDelete(CaseMap);
            
            SNICaseTriggerHandler.closeCaseValidation(addCase);
            case ecmCaseNew1 = new case();
            ecmCaseNew1.Id = ecmCas1.Id;
            ecmCaseNew1.Status = 'Closed';
            update ecmCaseNew1;
            closedcase.add(ecmCaseNew1);
            SNICaseTriggerHandler.closeCaseValidation(closedcase);
            SNICaseTriggerHandler.supportCaseOwnerChangeValidation(newCase,oldCase);
            Test.stopTest();
        }
        
    }
    static testMethod void deleteECMcase(){
        test.startTest();
        RecursiveTriggerHandler.allowSNICase=true;
        Id individualRecordId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Individual').getRecordTypeId();
        Id familyRecordId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Family').getRecordTypeId();
        List<Account> acts = new List<Account>();
        Account busAcc= new Account(Name='Test Family', phone='1001290986');
        busAcc.RecordTypeId = familyRecordId;
        busAcc.UHG_Restriction__c='No';
        busAcc.Policy_ID__c='0915181';
        busAcc.Member_ID__c='0123456';
        acts.add(busAcc);
        Account accountTest1 = new Account();
        accountTest1.FirstName = 'TestFirst';
        accountTest1.LastName = 'TestLast';
        accountTest1.EID__c = '12345';
        accountTest1.EID__pc = '12345';
        accountTest1.PersonMailingState = 'CA';
        accountTest1.RecordTypeId = individualRecordId;
        acts.add(accountTest1);
        insert acts;
        
        contact cont = [select Id from contact where accountId =: accountTest1.Id];
        
        AccountContactRelation acr=new AccountContactRelation();
        acr.AccountId=busAcc.ID;
        acr.ContactId=cont.ID;
        acr.Relationship__c='Subscriber/Recipient';
        acr.Policy_ID__c='0915181';
        acr.Member_ID__c='0123456';
        Insert acr;
        
        test.stopTest();
        
    }
}