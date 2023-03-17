public class ETSBE_CaseFileArchiveSchedule implements Schedulable {
   Public void execute(SchedulableContext sc) {
      ETSBE_CaseFileArchivebatch b = new ETSBE_CaseFileArchivebatch(); 
      database.executebatch(b,1);
   }

}