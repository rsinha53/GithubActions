public class SNI_FL_ROIDeactivationScheduler implements Schedulable {
    
    public void execute(SchedulableContext sc) {
		Database.executeBatch(new SNI_FL_ROIDeactivationBatch(), 200);					
	}
    /*
    SNI_FL_ROIDeactivationScheduler ROIDeactivationScheduler = new SNI_FL_ROIDeactivationScheduler();
	String dayCronExpr = '0 0 0 * * ? *'; 
	System.schedule('SNI FL Deactivate Expired ROI Daily Job', dayCronExpr, ROIDeactivationScheduler);
    */

}