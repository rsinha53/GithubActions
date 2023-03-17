@isTest
public class ACET_DeleteVCCDResponsSchedulerTest{


    @isTest
    static void testSchedule(){
        String sch = '0 41 5 * * ?';
        Test.startTest();
        System.schedule('Remove VCCD Records', sch, new ACET_DeleteVCCDResponsScheduler());
        Test.stopTest();
    
    }



}