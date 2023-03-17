/*
    Created By: Ravi kishore
    Created Date: 12th aug July 2019
    Description: This class is used to schedule the batch Job to get access token for SNI Api.
*/

public class ACETGetSNIAPIAccessTokenScheduler  implements Schedulable {
	public void execute(SchedulableContext sc) {
		Database.executeBatch(new ACETGetSNIApiAccessTokenBatch(), 1);					
	}
}

/*
 string CronExpr = '0 30 * * * ?';
 System.schedule('SNI API Access Token', CronExpr, new ACETGetSNIAPIAccessTokenScheduler());

*/