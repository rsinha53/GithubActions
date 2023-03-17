/* Author : Vishal Badoni
* Created Date : 13 August 2021
* Batch class created to Freeze users whose last login date is greater than 90 Days and if blank than created date is greater than 90 Days.
*/

global without sharing class ACET_FreezingUserBatch implements Database.Batchable<sObject> {
    //dateTime dt = date.today()-90;
    public String query = 'SELECT Id,name,Profile_Name__c,IsActive,LastLoginDate,CreatedDate FROM User WHERE IsActive = TRUE AND (LastLoginDate < LAST_90_DAYS OR LastLoginDate =NULL)'+(Test.isRunningTest()?' LIMIT 200':'');

    global Database.QueryLocator start(Database.BatchableContext BC) {
    return Database.getQueryLocator(query);
}   
    
    global void execute(Database.BatchableContext BC, List<User> scope) {
        List<UserLogin> selectedUserslogin = new List<UserLogin>();
        //Map<id,User> selectedUsers = new Map<id,User>();
        List<user> selectedUsersupd = new List<user>();
        
        Set<id> usrid = new Set<id>();
         for(User record: scope) {
          if(record.Profile_Name__c !='Family Link Provider User' && record.Profile_Name__c !='FamilyLink Community User' && record.Profile_Name__c !='Customer Community Plus Login User'){
            if((record.LastLoginDate ==null && record.CreatedDate < (system.now()-90)) ||(record.LastLoginDate !=null) && record.LastLoginDate < (system.now()-90))
              usrid.add(record.id);
            //record.IsActive = false;
            //selectedUsers.put(record.id,record);
          } 
        }
        List<UserLogin> upuser= [Select UserId,IsFrozen From UserLogin where IsFrozen=false and UserId IN:usrid];
         for(UserLogin record: upuser) {
            record.IsFrozen = True;
            selectedUserslogin.add(record);
             //if(selectedUsers.containsKey(record.UserId)){
                 //selectedUsersupd.add(selectedUsers.get(record.UserId));
             //}
        }
        //system.debug('selectedUsers--'+selectedUsers);
        system.debug('selectedUserslogin--'+selectedUserslogin);
        system.debug('selectedUsersupd--'+selectedUsersupd);
        //if(!selectedUsersupd.isEmpty())
        //Database.update(selectedUsersupd, false); 
        
        if(!selectedUserslogin.isEmpty())
        Database.update(selectedUserslogin, false);
    }   
    
    global void finish(Database.BatchableContext BC) {
    }
    
}