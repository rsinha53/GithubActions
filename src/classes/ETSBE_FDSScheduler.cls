public class ETSBE_FDSScheduler implements Schedulable{
    public void execute(SchedulableContext sc) {
		Database.executeBatch(new ETSBE_InteractionFileArchiveBatch(), 1);					
	}
}