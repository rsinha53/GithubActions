//scheduler class to delte temp document and the attachment under it
global with sharing class ACETDelTempDocumentScheduler implements Schedulable {
	global void execute(SchedulableContext SC) {
        ACETDelTempDocumentBatch job = new ACETDelTempDocumentBatch();
        Database.ExecuteBatch(job, 100);
	}    
}