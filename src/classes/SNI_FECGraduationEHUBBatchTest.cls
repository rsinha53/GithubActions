@isTest
public class SNI_FECGraduationEHUBBatchTest {
    @TestSetup
    static void setup(){
        User oUser = [select id,contactid, Name,Profile_Name__c,ProfileId,Role_Name__c FROM User Where id =: userInfo.getUserId()];
        List<Account> familyList = TestDataFactory.createBulkAccounts();
        List<Account> personList = new List<Account>();
        List<Family_Overview__c> familyOverviewList = new List<Family_Overview__c>();
        String familyRecordType = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Family').getRecordTypeId();
        String personRecordType = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        Integer idKey = 1;
        for(Account a :familyList){
            a.RecordTypeId = familyRecordType;
            a.Member_Id__c = '1231234567'+String.valueOf(idKey);
            a.OwnerId = oUser.Id;
            Family_Overview__c fam=new Family_Overview__c();
            fam.Account__c=a.Id;
            if(idKey == 1){
                fam.Designation__c = 'Assigned';
                fam.Family_Status__c = 'Inactive';
                fam.Last_Active_Date__c = (Date.today() - 385);
            } else if(idKey == 2){
                fam.Designation__c = 'Assigned';
                fam.Family_Status__c = 'Inactive';
                fam.Last_Active_Date__c = (Date.today() - 200);
            } else if(idKey == 3){
                fam.Designation__c = 'Deferred';
                fam.Designation_Changed_Date__c = (Date.today() - 200);
                fam.Last_Active_Date__c = (Date.today() - 200);
                
            } else if(idKey == 4){
                fam.Designation__c = 'Deferred';
                fam.Designation_Changed_Date__c = (Date.today() - 100);
                fam.Last_Active_Date__c = (Date.today() - 100);
            } else {
                fam.Family_Status__c='Active';
            }
            fam.Exception__c = 'No';
            fam.Family_Needs__c='Low';
            fam.UHG_Restriction__c='No';
            fam.Onshore_Restriction__c='No';
            familyOverviewList.add(fam);
            idKey++;
        }
        update familyList;
        insert familyOverviewList;
        for(integer i = 0; i<10; i++){
            Account accountTest = new Account();
            accountTest.FirstName = 'Luke';
            accountTest.LastName = 'Testwalker'+String.valueOf(i);
            accountTest.EID__c = 'lukeTestwalker'+String.valueOf(i)+'@testEmail.com';
            accountTest.RecordTypeId = personRecordType;
            personList.add(accountTest);
        }
        insert personList;
    }
    public testmethod static void testBatchOpenCases(){
        List<Id> famOverIdListToUpdate = new List<Id>(new Map<Id,Family_Overview__c>([Select Id from Family_Overview__c]).keySet());
        Test.startTest();
        SNI_FECGraduationEHUBBatch myBatchObject = new SNI_FECGraduationEHUBBatch(famOverIdListToUpdate);
        Database.executeBatch(myBatchObject);        
        Test.stopTest();   
    }
}