/********************************************************************************* 
Class Name     : SNI_FL_MessageRequestQueueController
Description    : Logic related to 3way communication Assign To Me Functionality
Created By     : Pavithra Fernando US3379195 
Created Date   : 01/04/2021
***********************************************************************************/


public with sharing class SNI_FL_MessageRequestQueueController {
    private static String messageID;
    private static final String TEAMNAME = 'ACDC Exception ';
    private static final String LINE = ' Line: ';
    
    //US3379195 Pavithra ACDC
    @AuraEnabled    
    public static boolean getMessageRequestQueueDetails(String messageReqId, String userId){
        List <Message_Request_Queue__c> lstMsgReq = new List<Message_Request_Queue__c>();  
        list<Family_Partner__c> lstFamPart = new list<Family_Partner__c>();
        set<string> setFamIds = new set<string>();
        for(Message_Request_Queue__c rq: [Select SNI_FL_Message__c,SNI_FL_Message__r.Family_ID__c,Account__c,OwnerId From Message_Request_Queue__c Where Id =: messageReqId ]){            
            messageID = rq.SNI_FL_Message__c;
            rq.OwnerId = userId;
            lstMsgReq.add(rq);
            if(rq.SNI_FL_Message__c != null && rq.SNI_FL_Message__r.Family_ID__c != null){
                 setFamIds.add(rq.SNI_FL_Message__r.Family_ID__c);
            }
        }
        
        update lstMsgReq;
        if(! setFamIds.isEmpty()){
        list<string> listExiFams = new list<string>();
        for(Family_Partner__c lstFp : [select id,Family__c from Family_Partner__c where Family__c IN: setFamIds and Partner__c =: userId]){
            listExiFams.add(lstFp.Family__c);
        }
        for(string str : setFamIds){
                if( listExiFams.isEmpty() || ! listExiFams.contains(str)){
                    Family_Partner__c fp = new Family_Partner__c();
                    fp.Family__c = str;
                    fp.Partner__c = userId;
                    lstFamPart.add(fp);
                }          
       }
       if(! lstFamPart.isEmpty()){
           insert lstFamPart;
        }
        }
        if(messageID != null){
            String feedId = [SELECT Feed_Id__c FROM SNI_FL_Message__c Where Id =: messageID].Feed_Id__c;
                if(feedId != null){
                    return updateDirectMessageMembers(feedId,userId);
                }
            
        }

        return false;
    }


    // get Community ID
    public static String getCommunityId() {
        List < Network > customCommunity = [select Id, name from network where name = 'Care Advisor Connect' ];
        if (customCommunity != null && customCommunity.size() > 0) {
            return customCommunity[0].Id;
        }
        return null;
    }

    //US3379195 Pavithra ACDC
    private static boolean updateDirectMessageMembers(String feedId,String userId){
        try{
            String communityId = getCommunityId();
            List<Id> listOfUserIds = new List<Id>();
            listOfUserIds.add(userId);
            //Direct Message Capability
            ConnectApi.DirectMessageCapabilityInput dmInput = new ConnectApi.DirectMessageCapabilityInput();        
            dmInput.membersToAdd = listOfUserIds;
            ConnectApi.DirectMessageCapability dm = ConnectApi.ChatterFeeds.updateDirectMessage(communityId, feedId, dmInput);
            system.debug('updateDirectMessage list - ' + dm);
            if(dm != null){

                getPartnerData(feedId,userId);
                return createMessageStatus(userId);
    
            }
            return false;
        }catch(Exception ex){

            System.debug(TEAMNAME+ex.getMessage()+LINE+ex.getLineNumber());
            return false;
        }
    }

    //US3379195 Pavithra ACDC
    private static boolean createMessageStatus(String userID){
        try{
            
            SNI_FL_Message_Status__c flMessageStatus = new SNI_FL_Message_Status__c();
            flMessageStatus.SNI_FL_Message__c  = messageID;
            flMessageStatus.Agent__c  = userID;
            flMessageStatus.IsRead__c = false;
            

            Database.SaveResult saveResult = Database.insert(flMessageStatus);            
            if(!saveResult.isSuccess()){                    
                return false;
            }
            System.debug('userID++'+userID);
            

            return true;
        }catch(Exception ex){
            return false;
        }
        
    }
    
    private static void getPartnerData(String feedId,String userId){

        try{
            
            User partner = [SELECT FirstName,LastName,UserRole.Name FROM User WHERE ID=:userId];

            if(partner.UserRole.Name.contains('Nurse Advisor')){
               String comment  = 'ACDC:%(Nurse Advisor) has joined the message. ';
                SNI_FLDirectMessageConnectAPI.postComment(feedId,comment);
            } else if(partner.UserRole.Name.contains('Women\'s Health Nurse Advisor')){
               String comment  = 'ACDC:%(Women\'s Health Nurse Advisor) has joined the message. ';
                SNI_FLDirectMessageConnectAPI.postComment(feedId,comment);
            } else{
                String comment = 'ACDC:%(Wellness and Community Coach) has joined the message. ';
                SNI_FLDirectMessageConnectAPI.postComment(feedId,comment);
            }
            
        }catch(Exception ex){
            System.debug(TEAMNAME+ex.getMessage()+LINE+ex.getLineNumber());
        }
        

    }
}