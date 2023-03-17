public class ACET_GetAuthJWTTokenBatchScheduler implements Schedulable{
    
    public void execute(SchedulableContext sc) {
        Set<String> serviceNamesJWT = new Set<String>();
        serviceNamesJWT.add('StargateDashboardJWTTokenAPI');
        serviceNamesJWT.add('StargateJWTTokenAPI');
        Database.executeBatch(new ACET_GetJWTAuthTokenBatch(serviceNamesJWT), 1);					
    }
    
    //Run following block of statements in Developer Console to schedule batch job it run after every 30 minutes
    /*
    ACET_GetAuthJWTTokenBatchScheduler JWTGATScheduler = new ACET_GetAuthJWTTokenBatchScheduler();
    String JWTHourCronExpr = '0 0 * * * ?';
    String JWTHalfHourCronExpr = '0 30 * * * ?';
    System.schedule('JWT Get Access Token Hourly Job', HourCronExpr, JWTGATScheduler);
    System.schedule('JWT Get Access Token Half Hourly Job', HalfHourCronExpr, JWTGATScheduler);
	*/

}