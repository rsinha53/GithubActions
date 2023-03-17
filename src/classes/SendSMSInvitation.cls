public class SendSMSInvitation implements Queueable, Database.AllowsCallouts {
    
    public List<USer> userList;
    public Map<Id,AccountContactRelation> acrMap;
    Map<String,String> mapOfBestBuy;
        
    public SendSMSInvitation(List<User> userList){
        this.userList = userList;
    }
    
    public void execute(QueueableContext context) {
        String returnValue;
        for(User usr : userList){
            if(usr.Include_SMS_invitation__c == true && (usr.MobilePhone != null || usr.MobilePhone != '')){
                string label = 'Welcome_Portal_SMS';
                SNI_FL_Notification_Center_API_Settings__mdt settings = [select Email_Notification_Email__c
                                                                         from SNI_FL_Notification_Center_API_Settings__mdt WHERE MasterLabel =: label LIMIT 1];
                String SMSText = settings.Email_Notification_Email__c;
                if(usr.FirstName != null || usr.LastName != null){
                    SMSText = SMSText.replace('{Name}',usr.FirstName+' '+usr.LastName);
                }
                if(UserInfo.getName() != null){
                    SMSText = SMSText.replace('{CA}',UserInfo.getName()); 
                }
                String mobilePhone = (usr.MobilePhone).replace(' ','').replace('-','').replace('(','').replace(')','');
                if(!Test.isRunningTest()){
                    returnValue = SNI_FL_NotificationCenter2.sendSMS(mobilePhone, SMSText);
                }
            }
        }
    }
}