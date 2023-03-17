@isTest
public class ACETUpdateACRRelationshipBatchTest {
    @testSetup
       static void ACETUpdateACRRelationshipBatchTestSetup(){
       Account accountRec = new Account();
       Id famRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Family').getRecordTypeId();
        accountRec.RecordTypeId  = famRecordTypeId;
        accountRec.name = 'Test family';
        insert accountRec;
        Account personAcc = new Account();
		Id indRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Individual').getRecordTypeId();
        personAcc.RecordTypeId = indRecordTypeId;
        personAcc.lastname = 'Test Family person1';
        insert personAcc;
        id pConId = [select id,PersonContactid from Account where id=:personAcc.id ].PersonContactid;
        AccountContactRelation accConRel = new AccountContactRelation();
        accConRel.contactid = pConId ;
        accConRel.Accountid = accountRec.id ;
        insert accConRel; 
        
    }
    static testMethod void ACETUpdateACRRelationshipBatchTestMethod1(){
      test.startTest();
      ACETUpdateACRRelationshipBatch acrBatch = new ACETUpdateACRRelationshipBatch();
      Database.executeBatch(acrBatch);
      test.stopTest();
        
    }

}