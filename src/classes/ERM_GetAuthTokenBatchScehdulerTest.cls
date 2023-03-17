@isTest
public class ERM_GetAuthTokenBatchScehdulerTest {
    public static testMethod void schedulerTest(){
		Test.StartTest();
		ERM_GetAuthTokenBatchScehduler testsche = new ERM_GetAuthTokenBatchScehduler();
		String sch = '0 0 23 * * ?';
		system.schedule('Test status Check', sch, testsche );
		Test.stopTest();
    }
}