@isTest
public class ACETfamilyOverviewTriggerTest {
	@isTest static void SNIFamStatusControllerMethod() {
        Account acc = new Account();
        Id famRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Family').getRecordTypeId();
        acc.RecordTypeId  = famRecordTypeId;
        acc.Name = 'Familyoverview family 003';
        insert acc;
        test.startTest();
        Family_Overview__c fo = new Family_Overview__c();
        //fo.Family_Status__c = 'Inactive';
        fo.Designation__c = 'Assigned';
        fo.Account__c = acc.id;
        insert fo;
        fo.Designation__c = 'Removed';
        update fo;
        fo.Designation__c = 'Assigned';
        update fo;
        fo.Designation__c = 'Attempted';
        update fo;
        test.stoptest();
	}
    //Reference for: US3236600
    @isTest static void familyOverToAccountSync() {
        Account acc = new Account();
        Id famRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Family').getRecordTypeId();
        acc.RecordTypeId  = famRecordTypeId;
        acc.Name = 'Familyoverview family 004';
        insert acc;
        Family_Overview__c fo = new Family_Overview__c();
        fo.Family_Status__c = 'Inactive';
        fo.Family_Needs__c = 'Low';
        fo.Account__c = acc.id;
        insert fo;
        fo.Family_Status__c = 'Active';
        fo.Family_Needs__c = 'High';
        update fo;
        Account updatedAct = [Select Id, Family_Needs__c, Family_Status__c FROM Account WHERE Id = :acc.Id Limit 1];
        //System.assertEquals('Active', updatedAct.Family_Status__c);
        //System.assertEquals('High', updatedAct.Family_Needs__c);
        
    }
}