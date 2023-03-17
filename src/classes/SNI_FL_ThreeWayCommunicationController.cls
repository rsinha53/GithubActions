/********************************************************************************* 
Class Name     : SNI_FL_ThreeWayCommunicationController
Description    : Logic related to 3way communication functionality
Created By     : Sameera De Silva US3376756 
Created Date   : 3/23/2021
***********************************************************************************/

public with sharing class SNI_FL_ThreeWayCommunicationController {

    private static final string ERRORMSG = 'Error Occured: SNI_FL_ThreeWayCommunicationController ';
    /**
     * @description insert new message request record when a new message initating from 
     *              mymessage tab/family level/backup advisor
     * @param inputValues 
     */    
    public static void createNewMessageRequest(Map<String,Object> parameters,String sniMessageID){
        

        if(parameters != NULL && parameters.get('selectedQueue') != NULL){
            try{

                AccountContactRelation familyAccountDetails = getFamilyAccountDetails((String)parameters.get('FamilyAccountID'));
                system.debug('values**' + familyAccountDetails);
                Message_Request_Queue__c messageRequest = new Message_Request_Queue__c();
                if(familyAccountDetails != NULL){
                    messageRequest.Assigned_Advisor__c = familyAccountDetails.Account.Owner.Name;
                    messageRequest.City_State__c = familyAccountDetails.Contact.MailingCity+','+familyAccountDetails.Contact.MailingState;
                    messageRequest.Family_Name__c = familyAccountDetails.Account.Name;
                    messageRequest.Onshore_Restriction__c = familyAccountDetails.Account.Onshore_Restriction__c;
                    messageRequest.UHG_Restriction__c = familyAccountDetails.Account.UHG_Restriction__c;
                    messageRequest.Member_ID__c = familyAccountDetails.Account.Member_ID__c;
                }
                messageRequest.Message_Content__c = ((String)parameters.get('MessageContent')).stripHtmlTags();
                messageRequest.Message_Subject__c = (String)parameters.get('MessageSubject');
                
                if(!Test.isRunningTest())
                    messageRequest.SNI_FL_Message__c = sniMessageID;

                Map<Object,Object> m = (Map<Object,Object>)parameters.get('selectedQueue');
                
                messageRequest.OwnerId = (String)m.get('value');
				system.debug('owner is --- ' + (String)m.get('value'));
                messageRequest.Message_Recipients__c = '';
                for(String userName:getUserRelatedData((List<ID>)parameters.get('ToUsers'))){
                    
                    messageRequest.Message_Recipients__c += userName+',';
                }
                messageRequest.Message_Recipients__c = messageRequest.Message_Recipients__c.removeEnd(',');

                // US3393183 - Nantha -ACDC
                Set<String> toList = new Set<String>();
                toList.add(messageRequest.OwnerId);
                system.debug('tolst is---' + toList);

                String subject = 'Message Request has been received for ' + messageRequest.Family_Name__c + '... Please accept!';
                String body = 'Please review the Message Request Queue page to see request.';
                
                insert messageRequest;

                CustomNotificationType notificationType = [SELECT ID FROM CustomNotificationType WHERE DeveloperName ='SNI_FL_Message_Notification'];
                Messaging.CustomNotification notification = new Messaging.CustomNotification();
                notification.setNotificationTypeId(notificationType.ID);
                notification.setTargetId(messageRequest.Id);
                notification.setTitle(subject);
                notification.setBody(body);
                notification.send(toList); 
                // US3393183 - Nantha -ACDC 

            }catch(Exception ex){
                System.debug(ERRORMSG+ex.getMessage());
            }
        } 
    }

    /**
     * @description getFamilyaccount related data
     * @param accountID 
     * @return  `AccountContactRelation`
     */    
    private static AccountContactRelation getFamilyAccountDetails(String accountID){

        try{
            return [SELECT Id, Account.Member_ID__c,Account.Onshore_Restriction__c,Account.UHG_Restriction__c,Account.Name,Account.Owner.Name,Relationship__c, 
            ContactId,Contact.MailingCity,Contact.MailingState FROM AccountContactRelation where 
            AccountID=:accountID LIMIT 1]; //AND Relationship__c='Subscriber/Recipient' LIMIT 1
        }catch(Exception ex){
            
            System.debug(ERRORMSG+ex.getMessage());
            return null;
        }
    }

    /**
     * @description gettting user related datas
     * @param toUsers 
     * @return  `List<User>`
     */    
    private static List<String> getUserRelatedData(List<ID> toUsers){

        try{
            List<String> userNames = new List<String>();

            for(User usr:[SELECT Name FROM User where AccountId IN:toUsers OR Id IN:toUsers]){
                
                userNames.add(usr.Name);
            }
            return userNames;

        }catch(Exception ex){
            System.debug(ERRORMSG+ex.getMessage());
            return null;
        }

    }

    /**
     * @description US3379195
     * @param messageReqId,  userId
     * @user  Pavithra ACDC
     */   
    // 
    @AuraEnabled    
    public static void getMessageRequestQueueDetails(String messageReqId, String userId){
    SNI_FL_MessageRequestQueueController.getMessageRequestQueueDetails(messageReqId,userId);
    }

}