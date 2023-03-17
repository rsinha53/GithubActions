public class ETSBE_ArchiveSupplRoutingScheduler implements Schedulable{
    
    public void execute(SchedulableContext sc) {
        Database.executeBatch(new ETSBE_ArchiveSupplRoutingBatch(), 200);                   
    }
    
    //Run following block of statements in Developer Console to schedule batch job it run every day at midnight
    /*
        ETSBE_ArchiveSupplRoutingScheduler archiveSRScheduler = new ETSBE_ArchiveSupplRoutingScheduler();
        String cronExpr = '0 0 0 * * ?';
        System.schedule('ETSBE Daily Supplemental Routing Archive', cronExpr, archiveSRScheduler);
    
    */
}