@isTest(seealldata = false)
public class ETSBE_CaseFileArchiveScheduleTest {

    @isTest static void testschedule() {
        Test.StartTest();
        ETSBE_CaseFileArchiveSchedule schedulerObj = new ETSBE_CaseFileArchiveSchedule();
        String sch = '0 0 23 * * ?';
        system.schedule('Test schedulable Class', sch, schedulerObj); 
        Test.stopTest();
    }
    
}