public class CHNQualifiedDataBatchScheduler implements Schedulable {
    public void execute(SchedulableContext sc) {
        Database.executeBatch(new CHNQualifiedDataBatch(), 1);                  
    }
}