@isTest
public class ACETSNIOrphanRecordAddMemberTest {
    public static Id personAccRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Individual').getRecordTypeId();
    public static Id familyAccRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Family').getRecordTypeId();
    public static Id priorAuthRecordType = Schema.SObjectType.WorkOrder.getRecordTypeInfosByName().get('Prior Authorization').getRecordTypeId();  
    public static List<Case> addCase = new List<Case>();
    static testMethod void ACETSNIOrphanRecordAddMemberMethod() {
        
        User u = [Select id from User where Profile.Name = 'System Administrator' and isActive = true limit 1];
        system.runAs(u){
            Account ac = new Account();
            ac.Member_ID__c = '453543145';
            ac.Policy_ID__c = '0070145';
            ac.Name =   'Member1 Bourne Family';
            ac.RecordTypeId = familyAccRecordTypeId;
            insert ac;
            
            Account pa =new account();
            pa.PersonBirthdate = date.valueOf(ACETUtility.formatDateFutureDate('6/17/1979'));
            pa.firstName = 'Member1'; 
            pa.lastName = 'Bourne'; 
            pa.RecordTypeId = personAccRecordTypeId;
            insert pa;
            
            Account personAcc = [Select PersonContactId From Account Where Id = :pa.Id];
            
            AccountContactRelation acr = new AccountContactRelation();
            acr.ContactId = personAcc.PersonContactId;            
            acr.Accountid = ac.id;
            acr.Relationship__c = 'Child/Other';
            insert acr;
            
            workOrder workOrderObj = new workOrder();
            workOrderObj.HSC_Unique_ID__c='156627064';
            workOrderObj.Xref_ID__c='625871210';
            workOrderObj.AccountId = ac.Id;
            workOrderObj.Policy_ID__c = '0070145';
            workOrderObj.Member_ID__c = '453543145';
            workOrderObj.Status_Detail__c = 'Prior Authorization Received';
            workOrderObj.Host_System_Date_and_Time__c = datetime.now();
            workOrderObj.RecordTypeId = priorAuthRecordType;
            INSERT workOrderObj;
            
            ACETSNIOrphanRecordAddMember.addMemberOnWorkOrder(workOrderObj.Id);
        }
    }
    static testMethod void ACETSNIOrphanRecordNoAccountMethod() {
        User u = [Select id from User where Profile.Name = 'System Administrator' and isActive = true limit 1];
        system.runAs(u){
        Account ac = new Account();
        ac.Member_ID__c = '453543145';
        ac.Policy_ID__c = '0070145';
        ac.Name =   'Member1 Bourne Family';
        ac.RecordTypeId = familyAccRecordTypeId;
        insert ac;
        
        Account pa =new account();
        pa.PersonBirthdate = date.valueOf(ACETUtility.formatDateFutureDate('6/17/1979'));
        pa.firstName = 'Member1'; 
        pa.lastName = 'Bourne'; 
        pa.RecordTypeId = personAccRecordTypeId;
        insert pa;
        
        Account personAcc = [Select PersonContactId From Account Where Id = :pa.Id];
            
        AccountContactRelation acr = new AccountContactRelation();
        acr.ContactId = personAcc.PersonContactId;  
        acr.Accountid = ac.id;
        acr.Relationship__c = 'Child/Other';
        insert acr;
        
        workOrder workOrderObj = new workOrder();
        workOrderObj.HSC_Unique_ID__c='156627064';
        workOrderObj.Xref_ID__c='625871210';
        workOrderObj.Policy_ID__c = '0070145';
        workOrderObj.Member_ID__c = '453543145';
        workOrderObj.Status_Detail__c = 'Prior Authorization Received';
        workOrderObj.Host_System_Date_and_Time__c = datetime.now();
        workOrderObj.RecordTypeId = priorAuthRecordType;
        workOrderObj.First_Name__c = 'Member1';
        workOrderObj.Last_Name__c = 'Bourne';
        workOrderObj.Date_of_Birth__c = date.valueOf(ACETUtility.formatDateFutureDate('6/17/1979'));
        INSERT workOrderObj;
        
        ACETSNIOrphanRecordAddMember.addMemberOnWorkOrder(workOrderObj.Id);
        }
    }
}