/*
 * Created by Derek DuChene (Eagles)
 * 	US3277905, US3277990, US3278034
 */

public class SNI_FECGraduationBatchScheduler implements Schedulable{
	public void execute(SchedulableContext sc) {
		Database.executeBatch(new SNI_FECGraduationBatch(), Integer.valueOf(System.Label.FEC_Graduation_Batch_Size));
	}
    /* runs every Friday starting at 6pm
 	string CronExpr = '0 0 20 ? * 6';
 	System.schedule('SNI FEC Graduation', CronExpr, new SNI_FECGraduationBatchScheduler());
	*/
}