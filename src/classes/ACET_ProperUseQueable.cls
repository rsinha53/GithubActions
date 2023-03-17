public class ACET_ProperUseQueable implements System.Queueable, Database.AllowsCallouts {

  public void execute(QueueableContext qc) {  
    ACET_ProperUseWebService.callProperUseService();     
  }

}