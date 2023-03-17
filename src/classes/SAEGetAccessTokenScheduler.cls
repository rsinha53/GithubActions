public class SAEGetAccessTokenScheduler implements Schedulable {
	public void execute(SchedulableContext sc) {
		Database.executeBatch(new SAEGetAccessTokenBatch(), 3);					
	}
	
	//Run following block of statements in Developer Console to schedule batch job it run after every 30 minutes
	/*
		SAEGetAccessTokenScheduler SAEGATScheduler = new SAEGetAccessTokenScheduler();
		String HourCronExpr = '0 0 * * * ?';
		String HalfHourCronExpr = '0 30 * * * ?';
		System.schedule('ACET Get Access Token Hourly Job', HourCronExpr, SAEGATScheduler);
		System.schedule('ACET Get Access Token Half Hourly Job', HalfHourCronExpr, SAEGATScheduler);
	*/	
}