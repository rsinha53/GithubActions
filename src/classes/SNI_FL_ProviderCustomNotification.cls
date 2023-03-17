/****************************************************************************** 
Class Name     : SNI_FL_ProviderCustomNotification
Description    : Custom notification logic
Created By     : Sameera -Sameera ACDC US3131863
Created Date   : 1/17/2020
******************************************************************************/
public with sharing class SNI_FL_ProviderCustomNotification {

    private static final String TEAMNAME=' ACDC ';
    private static final String DUMMYID=System.Label.ACDC_DummyID;

    /**
     * @description: sends custom notifications for a new message
     * @authro: Sameera ACDC US3131863
     * @param messageBody 
     * @param feedElementId 
     * @param fileId 
     */
    public static void sendNewMessageCustonNotification(String messageBody, String subject, Set<String> users){

        try{
            CustomNotificationType notificationType = [SELECT ID FROM CustomNotificationType WHERE DeveloperName ='SNI_FL_Message_Notification'];    

           
            Switch on UserInfo.getUserType(){

                When 'PowerCustomerSuccess'{
    
                    Messaging.CustomNotification notification = new Messaging.CustomNotification();
                    notification.setNotificationTypeId(notificationType.ID);
                    notification.setTargetId(DUMMYID);
                    notification.setTitle(Userinfo.getName() + ' sent you a message');
                    notification.setBody(getMessage(subject,messageBody));
                    notification.send(users);
    
                }
                When else{
                    System.debug('Not a family link user');
                }
            }
            
        }catch(Exception ex){
            System.debug(TEAMNAME +'- sendNewMessageCustonNotification '+ex.getMessage()+'line '+ex.getLineNumber());
        }

    }

    /**
     * @description get the customnotification subject
     * @authro: Sameera ACDC US3131863
     * @param subject 
     * @param messageBody 
     * @return  `String`
     */    
    private static String getMessage(String subject,String messageBody){
        
        try{
            if (!String.isBlank(subject)) {
                if((subject.length() > 50)){
                    subject = subject.subString(0,50) + '...';
                } 
                else{
                    subject = subject;
                }
            } else {
                if (messageBody != 'Posted a file') {
                    subject = 'No Subject';
                } else {
                    subject = 'Attachment Sent';
                }
            }
            return subject;
        }catch(Exception ex){
            System.debug(TEAMNAME +'- getMessage '+ex.getMessage()+'line '+ex.getLineNumber());
            return null;
        }

    }

    /**
     * @description  send custom notification for reply
     * @authro: Sameera ACDC US3131863
     * @param messageBody 
     * @param feedElementId 
     * @param fileId 
     */    
    public static void sendReplyCustomNotification(String messageBody,String feedElementId, String fileId){

        try{
            Set<String> advisors = getUsers(feedElementId);
            if(advisors!=null){

                CustomNotificationType notificationType = [SELECT ID FROM CustomNotificationType WHERE DeveloperName ='SNI_FL_Message_Notification'];    

            
                Switch on UserInfo.getUserType(){

                    When 'PowerCustomerSuccess'{
        
                        Messaging.CustomNotification notification = new Messaging.CustomNotification();
                        notification.setNotificationTypeId(notificationType.ID);
                        notification.setTargetId(DUMMYID);
                        notification.setTitle(Userinfo.getName() + ' sent you a message');
                        notification.setBody(getMessageForReply(messageBody));
                        notification.send(advisors);
        
                    }
                    When else{
                        System.debug('Not a family link user');
                    }

                }
            }
        }catch(Exception ex){
            System.debug(TEAMNAME +'- sendReplyCustomNotification '+ex.getMessage()+'line '+ex.getLineNumber());
        }

    }

    /**
     * @description message for reply notification
     * @authro: Sameera ACDC US3131863
     * @param messageBody 
     * @param fielId 
     * @return  `String`
     */    
    private static String getMessageForReply(String messageBody){

        try{
            if (!String.isBlank(messageBody)) {
                if((messageBody.length() > 50)){
                    messageBody = messageBody.subString(0,50) + '...';
                } 
                else{
                    messageBody = messageBody;
                }
            } else {
                    messageBody = 'Attachment Sent'; 
            }
            return messageBody.stripHtmlTags();
        }catch(Exception ex){
            System.debug(TEAMNAME +'- getMessageForReply '+ex.getMessage()+'line '+ex.getLineNumber());
            return null;
        }
    }

    /**
     * @description getUsers in the feed to send notification
     * @authro: Sameera ACDC US3131863
     * @param feedID 
     * @return  `static`
     */    
        private static Set<String> getUsers(String feedID){

            try {
                if (String.isNotEmpty(feedID)) {
                    Set<String> memberIds = new Set<String>();
                    Id userID = UserInfo.getUserId();
                    List<DirectMessageFeed> lstDirectMessageFeed = [SELECT Id, Parent.Id, ParentId FROM DirectMessageFeed WHERE Id =:feedID];
                    if (!lstDirectMessageFeed.isEmpty()) {
                        List<DirectMessageMember> lstDirectMessageMember = [SELECT Id,DirectMessageId,MemberId FROM DirectMessageMember WHERE DirectMessageId=:lstDirectMessageFeed[0].ParentId];
                        for(DirectMessageMember member:lstDirectMessageMember){
                            if(member.MemberId != userID){
                                memberIds.add(member.MemberId);
                            }
                        }
                        if (!memberIds.isEmpty()) {
                            return getAdvisorUser(memberIds);
                        }
                    }
                }
                return null;
            } catch (Exception ex) {
                System.debug(TEAMNAME +'- getUsers '+ex.getMessage()+'line '+ex.getLineNumber());
                return null;
            }
        }

        /**
         * @description get Advisor users
         * @authro: Sameera ACDC US3131863
         * @param memberIds 
         * @return  `Set<ID>`
         */        
        private static Set<String> getAdvisorUser(Set<String> memberIds){

            try{
                Set<String> advisors = new Set<String>();
                for(User usr:[SELECT Id, UserRole.Name FROM User where Id IN:memberIds]){
                     advisors.add(usr.id);
                }
            return advisors;
            }catch (Exception ex) {
                System.debug(TEAMNAME +'- SNI_FL_CustomNotification '+ex.getMessage()+'line '+ex.getLineNumber());
                return null;
            }
            
        }
    

}