public class ACETGetAccessTokenScheduler implements Schedulable {
	public void execute(SchedulableContext sc) {
		Database.executeBatch(new ACETGetAccessTokenBatch(), 1);					
	}
	
	//Run following block of statements in Developer Console to schedule batch job it run after every 30 minutes
	/*
		ACETGetAccessTokenScheduler ACETGATScheduler = new ACETGetAccessTokenScheduler();
		String HourCronExpr = '0 0 * * * ?';
		String HalfHourCronExpr = '0 30 * * * ?';
		System.schedule('ACET Stargate Get Access Token Job', HourCronExpr, ACETGATScheduler);
		System.schedule('ACET Stargate ORX Get Access Token Job', HourCronExpr, ACETGATScheduler);
		System.schedule('ACET Stargate Auth PROD Get Access Token Job', HourCronExpr, ACETGATScheduler);
		System.schedule('ACET Get Access Token Hourly Job', HourCronExpr, ACETGATScheduler);
		System.schedule('ACET Get Access Token Half Hourly Job', HalfHourCronExpr, ACETGATScheduler);
		System.schedule('ACET Stargate JWT Get Access Token Hourly Job', HourCronExpr, ACETGATScheduler);
		System.schedule('ACET Stargate JWT Get Access Token Half Hourly Job', HalfHourCronExpr, ACETGATScheduler);
		System.schedule('ACET Stargate Dashboard JWT Get Access Token Hourly Job', HourCronExpr, ACETGATScheduler);
		System.schedule('ACET Stargate Dashboard JWT Get Access Token Half Hourly Job', HalfHourCronExpr, ACETGATScheduler);
	*/	
}