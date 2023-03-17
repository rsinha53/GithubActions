/********************************************************************************* 
Class Name     : SNI_FL_CheckMessageStatus.cls
Description    : This class is used to find whether changed owner is having a messsage status
                 record in SNI_FL_MessageStatus object, if there are not record a new record will be created
                 
Created By     : Sameera De Silva (ACDC) DE397810
Created Date   : 11/02/2020| Updated 1/12/2020
***********************************************************************************/
public  with sharing  class SNI_FL_MessageStatusChecker implements Database.Batchable<sObject>,Database.Stateful {

    public static Boolean isExecuted = false;// Sameera DE397810
    Map<ID,ID> lstAccountIDs;
    Integer successRecordCount = 0;
    Integer failureRecordCount = 0;

    public SNI_FL_MessageStatusChecker(Map<Id,Id> accountList){
        
        lstAccountIDs = accountList;
       
    }

    public Database.QueryLocator start(Database.BatchableContext bc){
       
        return Database.getQueryLocator([SELECT ID,Family_ID__c,OwnerId,Feed_Id__c,(SELECT Agent__c FROM SNI_FL_Message_Statuses__r WHERE Agent__c IN:lstAccountIDs.values())FROM SNI_FL_Message__c WHERE Family_ID__c IN:lstAccountIDs.keySet()]);
    }

    public void execute(Database.BatchableContext bc, list<sObject> objs){
        
        
        List<SNI_FL_Message_Status__c> lstMessageStatusRecordsToUpdate = new List<SNI_FL_Message_Status__c>();

        try{
           
            for(SNI_FL_Message__c messageRecord:(List<SNI_FL_Message__c>)objs){

                String newUserID = lstAccountIDs.get(messageRecord.Family_ID__c);
                List<SNI_FL_Message_Status__c> lstMessageStatus = messageRecord.SNI_FL_Message_Statuses__r;
                    
                if(lstMessageStatus == null || lstMessageStatus.isEmpty()){
                    SNI_FL_Message_Status__c statusRecord = new SNI_FL_Message_Status__c();
                    statusRecord.Agent__c = newUserID;
                    statusRecord.IsRead__c = false;
                    statusRecord.SNI_FL_Message__c = messageRecord.id;
                        
                    lstMessageStatusRecordsToUpdate.add(statusRecord);
                }
                
            }

            if(lstMessageStatusRecordsToUpdate.size()>0){
                
                Database.SaveResult[] srList = Database.insert(lstMessageStatusRecordsToUpdate,false);

                for (Database.SaveResult sr : srList) {
                    if (sr.isSuccess()) {
                        successRecordCount++;
                    }
                    else {
                        failureRecordCount++;
                    }
                }
            }

        }catch(Exception ex){
            System.debug(ex.getMessage());
            System.debug(ex.getLineNumber());
        }
        
    }

    public void finish(Database.BatchableContext bc){
      
        System.debug('successRecordCount*********************'+successRecordCount);
        System.debug('failureRecordCount*********************'+failureRecordCount);
        
        
    }

}