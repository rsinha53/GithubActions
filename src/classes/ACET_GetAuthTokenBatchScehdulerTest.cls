@istest
public class ACET_GetAuthTokenBatchScehdulerTest {
    static testMethod void test(){
    ACET_GetAuthTokenBatchScehduler SAEGATScheduler = new ACET_GetAuthTokenBatchScehduler();
    SchedulableContext sc = null;
	SAEGATScheduler.execute(sc);
    }
}