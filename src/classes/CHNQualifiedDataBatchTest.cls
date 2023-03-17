@isTest
public class CHNQualifiedDataBatchTest{
    public static testMethod void qualfDataTestMethod() {
        try{
            test.startTest();   
                         
                CHN_Qualified_Data__c  qulDt = new CHN_Qualified_Data__c ();
                qulDt.EID__c = '1057070455';
                qulDt.Last_Name__c = 'test last name';
                qulDt.Policy_Number__c = '123456';
                qulDt.Subscriber_Member_ID__c = '55555';
                
                insert qulDt;
                
                
                CHNQualifiedDataBatch obj = new CHNQualifiedDataBatch();
                DataBase.executeBatch(obj);
                
            test.stopTest();
        }catch(exception e){}
    }
}