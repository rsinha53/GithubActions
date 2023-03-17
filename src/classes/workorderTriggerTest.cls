@isTest(SeeAllData = false)
private class workorderTriggerTest {
	static testMethod void testWorkOrder()
    {
       test.startTest();
       WorkOrder w = new WorkOrder();
	   w.Status_Detail__c  ='Prior Authorization Received';
	   insert w;
	   w.Status_Detail__c  = 'MD Review';
     //w.Host_System_Date_and_Time__c = system.now();
	   update w;
       w.Status_Detail__c  ='Decision has been made';
       update w;
       test.stopTest();

    }
}