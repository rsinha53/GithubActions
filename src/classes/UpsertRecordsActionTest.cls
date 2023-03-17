@IsTest
public class UpsertRecordsActionTest {
   @isTest
    static void testDefaultBehavior(){
        list<CHN_Qualified_Data__c> dataList=new list<CHN_Qualified_Data__c>();
        CHN_Qualified_Data__c data=new CHN_Qualified_Data__c();
        data.First_Name__c='test1';
        data.Last_Name__c='test2';
        data.CHN_Referral_Identifier__c='3728392';
        insert data;
        dataList.add(data);
        test.startTest();
        UpsertRecordsAction.upsertRecords(dataList);
        test.stopTest();
    }
}