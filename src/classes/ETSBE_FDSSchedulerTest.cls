@isTest(seealldata = false)
public class ETSBE_FDSSchedulerTest {

    @isTest static void testschedule() {
        Test.StartTest();
        ETSBE_FDSScheduler schedulerObj = new ETSBE_FDSScheduler();
        String sch = '0 0 23 * * ?';
        system.schedule('Test schedulable Class', sch, schedulerObj); 
        Test.stopTest();
    }
    
}