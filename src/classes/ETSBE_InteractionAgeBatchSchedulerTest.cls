@isTest
public class ETSBE_InteractionAgeBatchSchedulerTest {
    
    public static testMethod void testschedule() {
        
        Test.StartTest();
		ETSBE_InteractionAgeBatchScheduler interactAgeSche = new ETSBE_InteractionAgeBatchScheduler();
		String sch = '0 0 23 * * ?';
		system.schedule('Test status Check', sch, interactAgeSche);
		Test.stopTest();	
        
    }

}