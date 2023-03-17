@isTest
public class SNI_FL_DeleteNPSDataRecordsBatchTest {
     @isTest
    static void testBatch()
    {
        List<NPS_Data__c> npsDataList= new List<NPS_Data__c>();
        for(Integer i=0 ;i <200;i++)
        {
            NPS_Data__c acc = new NPS_Data__c();
            
            npsDataList.add(acc);
        }
       
        insert npsDataList;
       
        Test.startTest();

            SNI_FL_DeleteNPSDataRecordsBatch obj = new SNI_FL_DeleteNPSDataRecordsBatch();
            DataBase.executeBatch(obj);
           
        Test.stopTest();
    }
}