@isTest
public class ACETGetSNIEligibleStatusTest {
    @isTest static void ACETGetSNIEligibleStatusMethod(){
        
        Account fAcc = new Account();
       // fAcc.RecordType.name  = 'Family';
        Id famRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Family').getRecordTypeId();
        fAcc.RecordTypeId  = famRecordTypeId;
        fAcc.name = 'Test family';
        insert fAcc;
        Account pAcc = new Account();
       // pAcc.recordtype.name = 'Individual';
        Id indRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Individual').getRecordTypeId();
        pAcc.RecordTypeId = indRecordTypeId;
        pAcc.lastname = 'Test Family person1';
        insert pAcc;
        id pConId = [select id,PersonContactid from Account where id=:pAcc.id ].PersonContactid;
        AccountContactRelation accConRel = new AccountContactRelation();
        accConRel.contactid = pConId ;
        accConRel.Accountid = fAcc.id ;
        insert accConRel;
        string res = ACETGetSNIEligibleStatus.FetchSniEligibleStatus(pAcc.id);
        
        
    
    }
}