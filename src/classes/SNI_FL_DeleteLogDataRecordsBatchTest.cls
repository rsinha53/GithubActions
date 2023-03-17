@isTest
public class SNI_FL_DeleteLogDataRecordsBatchTest {
     @isTest
    static void testBatch()
    {
        List<Application_Error_Log__c> logDataList= new List<Application_Error_Log__c>();
        for(Integer i=0 ;i <200;i++)
        {
            Application_Error_Log__c data = new Application_Error_Log__c();
            data.Application__c = 'sens';
            logDataList.add(data);
        }
       
        insert logDataList;
       
        Test.startTest();

            SNI_FL_DeleteLogDataRecordsBatch objt = new SNI_FL_DeleteLogDataRecordsBatch();
            objt.execute(null,logDataList);
           
        Test.stopTest();
    }
    @isTest
    static void testSchedule(){
        String sch = '0 0 0 ? * * *';
        Test.startTest();
        System.schedule('Remove Log Records', sch, new SNI_FL_DeleteLogDataRecordsBatch());
        Test.stopTest();
        
    }
}