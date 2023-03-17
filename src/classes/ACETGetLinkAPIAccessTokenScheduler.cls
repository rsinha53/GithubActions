/*
    Created By: Chandan Patro
    Created Date: 29th July 2019
    Description: This class is used to schedule the batch Job to get access token for Link Api.
*/

public class ACETGetLinkAPIAccessTokenScheduler implements Schedulable {
	public void execute(SchedulableContext sc) {
		Database.executeBatch(new ACETGetLinkApiAccessTokenBatch(), 1);					
	}
	
	//Run following block of statements in Developer Console to schedule batch job it run after every 30 minutes
	/*
		ACETGetLinkAPIAccessTokenScheduler ITEGATScheduler = new ACETGetLinkAPIAccessTokenScheduler();
		String HourCronExpr = '0 0 * * * ?';
		String HalfHourCronExpr = '0 30 * * * ?';
		System.schedule('Get ACET LINK API Access Token Hourly Job', HourCronExpr, ITEGATScheduler);
		System.schedule('Get ACET LINK API Access Token Half Hourly Job', HalfHourCronExpr, ITEGATScheduler);
	*/	
}