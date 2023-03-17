public class SENSAPI_CustomNotificationQueueable implements Queueable,Database.AllowsCallouts {
    String messageBody;
        String subject;
        List<String> notifyUserIds;
        String uploadedFiledID;
   
     public SENSAPI_CustomNotificationQueueable(String messageBody, String subject, List<String> notifyUserIds, String uploadedFiledID){
        this.messageBody = messageBody;
        this.subject = subject;
         this.notifyUserIds = notifyUserIds;
         this.uploadedFiledID = uploadedFiledID;
    }
   
    public void execute(QueueableContext context) {
       SNI_FLDirectMessageConnectAPI.sendCustomNotification(messageBody,subject,notifyUserIds,uploadedFiledID);
       
    }
}