@isTest
public class SNI_FL_DeleteNPSDataRecordsSchedulerTest {
    @isTest
    static void testSchedule(){
        String sch = '0 0 0 ? * SUN';
        Test.startTest();
        System.schedule('Remove NPS Records', sch, new SNI_FL_DeleteNPSDataRecordsScheduler());
        Test.stopTest();
        
    }
    
}