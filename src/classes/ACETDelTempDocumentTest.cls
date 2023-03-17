@isTest
private class ACETDelTempDocumentTest {
	static testMethod void test(){
        Temp_Document__c td = new Temp_Document__c();
        insert td;
        Datetime yesterday = Datetime.now().addHours(-25);
        Test.setCreatedDate(td.Id,Yesterday);
		SchedulableContext SC;
		ACETDelTempDocumentScheduler stub = new ACETDelTempDocumentScheduler();
		stub.execute(SC);
	}    
}