@isTest
public class RetrySensPublishToMicroserviceBatchTest{
    public static testMethod void microServcsTestMethod() {
        test.startTest();   
            List<SENS_Publish__c> sensPubLst = new List<SENS_Publish__c>();
            SENS_Publish__c sensPub = new SENS_Publish__c();
            sensPub.Is_Data_Published_in_Topic__c = false;
            sensPub.Last_Name__c = 'testtesttesttesttest';
            sensPubLst.add(sensPub);
            
            SENS_Publish__c sensPub1 = new SENS_Publish__c();
            sensPub1.Is_Data_Published_in_Topic__c = false;
            sensPub1.Last_Name__c = 'testtesttesttesttest';
            sensPubLst.add(sensPub1);
            
            insert sensPubLst;
            sensPubLst[1].Last_Name__c = 'test test test test test test test test test test test';
            update sensPubLst[1];
            
            RetrySensPublishToMicroserviceBatch obj = new RetrySensPublishToMicroserviceBatch();
            DataBase.executeBatch(obj);
        
        	 String sch = '0 0 23 * * ?';
            system.schedule('Test check', sch, obj);
        
        test.stopTest();
    }
}