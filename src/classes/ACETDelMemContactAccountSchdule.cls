global class ACETDelMemContactAccountSchdule implements Schedulable{
	global void execute(SchedulableContext SC) {
        ACETDelMemContactAccountBatch batchClass = new ACETDelMemContactAccountBatch();
        Database.ExecuteBatch(batchClass);
	}
    
}