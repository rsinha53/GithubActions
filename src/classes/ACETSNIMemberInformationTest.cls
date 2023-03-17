@isTest
public class ACETSNIMemberInformationTest {
    @isTest static void createMemberInformationUpdateMethod(){
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
            List<Account> accList = new List<Account>();
            accList.add(pa);
            Account personAcc = [Select PersonContactId From Account Where Id = :pa.Id];
            
            AccountContactRelation acr = new AccountContactRelation();
            acr.ContactId = personAcc.PersonContactId;            
            acr.Accountid = ac.id;
            acr.Relationship__c = 'Child/Other';
            insert acr;
            List<String> policyList = new List<String>();
            Map<Id,List<String>> existingPolicyDetails = new Map<Id,List<String>>();
            policyList.add('Yes');
            existingPolicyDetails.put(pa.Id, policyList);
            
            Family_Overview__c famOverview = new Family_Overview__c();
            famOverview.Account__c = ac.Id;
            insert famOverview;
            
            Member_Information__c memInfo = new Member_Information__c();
            memInfo.Account__c = pa.Id;
            insert memInfo;
            ACETSNIMemberInformation.createMemberInformation(accList,'123456','update',existingPolicyDetails,True);
        }
    }
    @isTest static void createMemberInformationInsertMethod(){
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
            List<Account> accList = new List<Account>();
            accList.add(pa);
            Account personAcc = [Select PersonContactId From Account Where Id = :pa.Id];
            
            AccountContactRelation acr = new AccountContactRelation();
            acr.ContactId = personAcc.PersonContactId;            
            acr.Accountid = ac.id;
            acr.Relationship__c = 'Child/Other';
            insert acr;
            List<String> policyList = new List<String>();
            Map<Id,List<String>> existingPolicyDetails = new Map<Id,List<String>>();
            policyList.add('Yes');
            existingPolicyDetails.put(pa.Id, policyList);
            
            Family_Overview__c famOverview = new Family_Overview__c();
            famOverview.Account__c = ac.Id;
            insert famOverview;
            
            Member_Information__c memInfo = new Member_Information__c();
            memInfo.Account__c = pa.Id;
            insert memInfo;
            
            ACETSNIMemberInformation.createMemberInformation(accList,'123456','insert',existingPolicyDetails,True);
        }
    }
}