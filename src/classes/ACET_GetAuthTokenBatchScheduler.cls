public class ACET_GetAuthTokenBatchScheduler implements Schedulable {
    public void execute(SchedulableContext sc) {
        Set<String> serviceNames = new Set<String>();
        serviceNames.add('MotionAccessTokenAPI');
        Database.executeBatch(new ACET_GetAuthTokenBatch(serviceNames), 1);					
    }
    
    //Run following block of statements in Developer Console -Anonymous Window to schedule batch job
    /*
    ACET_GetAuthTokenBatchScheduler scheduler = new ACET_GetAuthTokenBatchScheduler();
    String cronExpr = '0 0 0,3,6,9,12,15,18,21 * * ?';
    System.schedule('ACET Job Get Access Token Every 3 hours', cronExpr, scheduler);
    */	
}