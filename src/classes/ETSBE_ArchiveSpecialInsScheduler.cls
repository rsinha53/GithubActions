public class ETSBE_ArchiveSpecialInsScheduler implements Schedulable{
    public void execute(SchedulableContext sc) {
		Database.executeBatch(new ETSBE_ArchiveSpecialInsBatch(), 200);					
	}
	
	//Run following block of statements in Developer Console to schedule batch job it run every day at midnight
	/*
		ETSBE_ArchiveSpecialInsScheduler ArchiveSIScheduler = new ETSBE_ArchiveSpecialInsScheduler();
		String MidnightCronExpr = '0 0 0 * * ?';
		System.schedule('ETSBE Daily Special Instructions Archive', MidnightCronExpr, ArchiveSIScheduler);

	*/
}