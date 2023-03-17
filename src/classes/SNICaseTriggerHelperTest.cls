@isTest
public class SNICaseTriggerHelperTest {
    
    @isTest static void prePopulateFieldValuesMethod(){
        Id coRecordTypeID = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Case Overview').getRecordTypeId();
        Id ecmRecordTypeID = Schema.SObjectType.Case.getRecordTypeInfosByName().get('ECM').getRecordTypeId();
        Id familyRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Family').getRecordTypeId();
        Id personAccRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Individual').getRecordTypeId();
        User u = [Select id from User where Profile.Name = 'System Administrator' and isActive = true limit 1];
        List<Case> addCase = new List<Case>();
        Map<Id,Case> CaseMap = new Map<Id,Case>();
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
            addCase.add(coCase);
            
            Case ecmCas = TestDataFactory.createCases(1)[0];
            ecmCas.RecordTypeId =ecmRecordTypeID;
            ecmCas.Topic__c = 'Appeals - Post Service';
            ecmCas.Type__c = 'Family Advisor';
            ecmCas.ParentId = coCase.Id;
            ecmCas.Subject_Group_ID__c = '123456';
            ecmCas.Case_Type__c = 'Opportunity';
            Insert ecmCas;
            
            addCase.add(ecmCas);
            CaseMap.put(ecmCas.Id, ecmCas);
            
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
            
            SNICaseTriggerHelper.prePopulateFieldValues(addCase);  
            SNICaseTriggerHelper.copyCaseTeamtoOpportunity(addCase);
            SNICaseTriggerHelper.sniCaseRecordTypeSet();
            Boolean tempValue = true;
            SNICaseTriggerHelper.calculateActiveCount(CaseMap, tempValue, tempValue);
            set<Id> conIdTempSet = new set<Id>();
            conIdTempSet.add(personAcc.PersonContactId);
            set<Id> delCaseRecords = new set<Id>();
            delCaseRecords.add(ecmCas.Id);
            SNICaseTriggerHelper.updateDetail(conIdTempSet,delCaseRecords);
        }
        
    }
}