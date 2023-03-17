@istest
public class CHNQualifiedDataBatchScheduler_test {
    public static testMethod void testschedule() {
        Test.StartTest();
        CHNQualifiedDataBatchScheduler testsche = new CHNQualifiedDataBatchScheduler();
        String sch = '0 0 23 * * ?';
        system.schedule('Test status Check', sch, testsche );
        Test.stopTest();
    }
}