public class ACET_GetAuthTokenBatchScehduler implements Schedulable{
    public void execute(SchedulableContext sc) {
        Set<String> serviceNames = new Set<String>();
        serviceNames.add('LinkServiceTokenAPI');
        Database.executeBatch(new ACET_GetAuthTokenBatch(serviceNames), 1);					
    }
    
    //Run following block of statements in Developer Console to schedule batch job it run after every 30 minutes
    /*
    ACET_GetAuthTokenBatchScehduler SAEGATScheduler = new ACET_GetAuthTokenBatchScehduler();
    String HourCronExpr = '0 0 * * * ?';
    String HalfHourCronExpr = '0 30 * * * ?';
    System.schedule('ACET Get Access Token Hourly Job', HourCronExpr, SAEGATScheduler);
    System.schedule('ACET Get Access Token Half Hourly Job', HalfHourCronExpr, SAEGATScheduler);
    */	
}