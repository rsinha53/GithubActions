@isTest
public class SNI_FECGraduationBatchSchedulerTest {
    @isTest
    static void testSchedule(){
        string CronExpr = '0 0 20 ? * 6';
	String dateStr = Date.today().format();
        Test.startTest();
        System.schedule('SNI FEC Graduation'+dateStr, CronExpr, new SNI_FECGraduationBatchScheduler());
        Test.stopTest();
    }
}