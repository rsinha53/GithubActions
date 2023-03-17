@isTest
public class ETSBE_ArchiveSupplRoutingScheduler_Test {
    static testmethod void routemethod(){
		Test.StartTest();
         ETSBE_ArchiveSupplRoutingScheduler schObj = new ETSBE_ArchiveSupplRoutingScheduler();
		String sch = '0 0 23 * * ?';
        system.schedule('Test Territory Check1', sch, schObj); 
		Test.StopTest();
    }
}