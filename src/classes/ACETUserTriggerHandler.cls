public without sharing class ACETUserTriggerHandler {
         public static boolean isTriggerFire =False;
         public static List<Policies_Credential__mdt> validClientsCred;
         public static List<Id> contactIds = new List<Id>();
         public static Map<String,String> mapOfValidClients = new Map<String,String>();
         public static List<AccountContactRelation> acrList;
         public static Set<Id> validContactIds = new Set<Id>();
         public static List<User> userListForSendSMS = new List<User>();
    
    public ACETUserTriggerHandler(){
        validClientsCred = [Select Id, Policy_ID__c,Name__c from Policies_Credential__mdt where Name__c = 'BestBuy'];
        for(Policies_Credential__mdt validClient : validClientsCred){
            mapOfValidClients.put(validClient.Policy_ID__c, validClient.Name__c);
        }
    } 
    
    public static void getUserDetails(List<User> TriggerNew){
        for(User us :Triggernew){
            if(us.Profile_Name__c == 'Care Advisor Connect Community User'){
                contactIds.add(us.ContactId);
            }
        }
    }
    
    public static void updateUserDetails(List<User> Triggernew){
        List<Id> cnIds = new List<Id>();
        Map<String,String> mapOfUserContacts = new Map<String,String>();
        
        for(User us :Triggernew){
            if(us.Profile_Name__c == 'Care Advisor Connect Community User'){
                cnIds.add(us.ContactId);
                mapOfUserContacts.put(us.ContactId,us.Id);
            }
        }
        //List<User> updateUsers = new List<User>();
        //List<AccountContactRelation> acrLst = [SELECT ID,AccountId,contact.accountId,contactId from AccountContactRelation where contactId in :mapOfUserContacts.keySet()];
        for(AccountContactRelation acr: [SELECT ID,AccountId,contact.accountId,contactId from AccountContactRelation where contactId in :mapOfUserContacts.keySet()]){
            for(User u:TriggerNew){ 
                if(mapOfUserContacts.get(acr.contactId) == u.id){
                    u.IsMember__c = true; 
                }
            }
        }    
    }

    @future
    public static void addUserToGroup(String NewString, String OldMapString){   
    
        list<user> triggerNew = (list<user>)JSON.deserialize(NewString, list<user>.class);
        Map<id, User> oldMap = new Map<id, User>();
        if(OldMapString != null && OldMapString != '')
        oldMap = (Map<id, User>)JSON.deserialize(OldMapString, Map<id, User>.class);
        list<GroupMember> groupMemberstoInsert = new list<GroupMember>();     
        set<id> roleIds = new set<id>();
        set<id> userIdsToConsider = new set<id>();
        
        Group grpOff = [select id from group where DeveloperName = 'Team_Offshore'];
        Group grpOn = [select id from group where DeveloperName = 'Team_Onshore'];
        
        if(oldMap == null){
            for(user u : triggerNew){ 
          /*  if(oldMap.get(u.Id).Agent_Type__c!=null){
                if(u.Agent_Type__c!= oldMap.get(u.Id).Agent_Type__c){
                isTriggerFire = True;
                }  
            } */
            if(u.Agent_Type__c=='Offshore'){
                groupMemberstoInsert.add(New GroupMember(groupId=grpOff.id,UserorGroupId=u.id)); 
                userIdsToConsider.add(u.id);
            }            
             else if(u.Agent_Type__c=='Onshore'){
                userIdsToConsider.add(u.id);
                groupMemberstoInsert.add(New GroupMember(groupId=grpOn.id,UserorGroupId=u.id)); 
                  
      /*          if(u.UserRoleId != null){
                  roleIds.add(u.UserRoleId);
                }      */          
            }
            else
            {     
                userIdsToConsider.add(u.id);
            } 
           }
       }
       else {
           for(user u : triggerNew) {
                if(oldMap.containskey(u.Id) && oldMap.get(u.Id).Agent_Type__c !=null && u.Agent_Type__c != oldMap.get(u.Id).Agent_Type__c) {
                    isTriggerFire = True;
                
                User oldUsr = oldMap.get(u.id);
                if(u.Agent_Type__c=='Offshore' && oldMap.get(u.Id).Agent_Type__c != 'Offshore'){
                     groupMemberstoInsert.add(New GroupMember(groupId=grpOff.id,UserorGroupId=u.id)); 
                     userIdsToConsider.add(u.id);
                }
                else if(u.Agent_Type__c=='Onshore' && oldMap.get(u.Id).Agent_Type__c != 'Onshore'){
                     userIdsToConsider.add(u.id);
                     groupMemberstoInsert.add(New GroupMember(groupId=grpOn.id,UserorGroupId=u.id)); 
                } 
                else {
                      userIdsToConsider.add(u.id);
                }
              }       
           }
        }
           system.debug('----50--groupMemberstoInsert::'+groupMemberstoInsert);
        if(userIdsToConsider.size() > 0){
              list<GroupMember> groupMemberstoDelete = new list<GroupMember>([select UserOrGroupId from GroupMember where UserOrGroupId in:userIdsToConsider and (group.DeveloperName='Team_Offshore' or group.DeveloperName='Team_Onshore')]);
              // list<GroupMember> groupMemberstoDelete = new list<GroupMember>([select UserOrGroupId from GroupMember where UserOrGroupId in:userIdsToConsider]);  
                if(!groupMemberstoDelete.isEmpty()){
                   if(GroupMember.sObjectType.getDescribe().isDeletable()){ // code added as per checkmarx improvement -- Srinivasa
                   delete groupMemberstoDelete;
              }
             }
            }

   
         if(groupMemberstoInsert.size() > 0){
             system.debug('***inside insert');
            if(GroupMember.sObjectType.getDescribe().isCreateable()){   // code added as per checkmarx improvement -- Srinivasa
                system.debug('***inside group insert');
                insert groupMemberstoInsert;
            }
            /*if(GroupMember.sObjectType.getDescribe().isUpdateable()){   // code added as per checkmarx improvement -- Srinivasa
                if(isTriggerFire ==true){
                 insert groupMemberstoInsert;
                }
            }*/
         }

    }
    /*
    * Author: Aarti Garg
    * US: US2692279
    * Description: Following function update same email address on user page which set in Email field on Person Account Page
    * Date: 07/30/2020
    */
     public static void getEmail(List<User> Triggernew, Map<id, user> TriggerOldMap)
     {
         boolean recCheck = RecursiveTriggerHandler.emailcheck;
         RecursiveTriggerHandler.emailcheck= false;
         Map<id, String> AccountIdEmailMap = new Map<id,String>();
         
         
    for(User us : Triggernew)
    {
        if(TriggerOldMap!=null)
        {
            
        
        if(us.Email !=NULL && us.Email !=TriggerOldMap.get(us.id).Email && us.Profile_Name__c=='Care Advisor Connect Community User' && !recCheck)
            {
              AccountIdEmailMap.put(us.AccountId, us.Email);
             }
           
        }
        else
        {
            if(us.Email !=NULL && us.Profile_Name__c=='Care Advisor Connect Community User' && !recCheck)
            {
                AccountIdEmailMap.put(us.AccountId, us.Email);
             }
        }
    }
        if(AccountIdEmailMap.size()>0){
       setEmail(AccountIdEmailMap);
    }
     
    }
    @future
    public static void setEmail( Map<id, String> AccountIdEmailMap)
    {
        list<Account> lstAccount= new List<Account>();
         String emailstr='';
        List<Account>  acclist= [select Id, PersonEmail from Account where Id IN : AccountIdEmailMap.keySet()];
        system.debug('acc++  '+acclist);
        for(Account acc: acclist)
        {
                emailstr=AccountIdEmailMap.get(acc.Id) ;
                if(emailstr !=  acc.PersonEmail)
                    {
                        acc.PersonEmail= emailstr;
                        lstAccount.add(acc);
                    }
        }
                if(lstAccount.size()>0)
                {
                    RecursiveTriggerHandler.userEmailCheck = true;
               update lstAccount; 
             
                  
                }       
    }
    
    /*  US2732016: Care Team - Display Care Team on Family Page -Populated*/
    /**This code works only for single policyneed to be modified once multiple policy story comes in **/
    public static void createCareTeam(List<User> Triggernew){
        List<Id> cnIds = new List<Id>();
        List<Id> digitalOnboard = new List<Id>();
        Map<string,User> mapOfUserRecords = new Map<string,user>();
        for(User us :Triggernew){
            if(us.IsPortalEnabled && us.Profile_Name__c =='Care Advisor Connect Community User'){
                cnIds.add(us.ContactId);
                mapOfUserRecords.put(us.AccountId,us);
            }
            if(us.Digital_Onboarding__c || us.Suppress_Email_Reset_Time__c != null){
                digitalOnboard.add(us.ContactId);
            }
        }
        string mapString = JSON.serialize(mapOfUserRecords);
        careTeamInsertOperation(mapString,cnIds,digitalOnboard);
    }
    /*  US2732016: Care Team - Display Care Team on Family Page -Populated*/
    @future
    public static void careTeamInsertOperation(String mapString, List<Id> PersonAccList,List<Id>digitalOnboard){
        Map<string,user> mapOfUserRecords= new Map<String,user>();
            if(mapString != '' && mapString != null){
                mapOfUserRecords = (Map<String, User>)JSON.deserialize(mapString, Map<String, User>.class);
            }
        List<Account> personAccountUpdList= new List<Account>(); //US2736623: Care Team - Multi Policy Pop Up 
        List<AccountContactRelation> acrLst = [SELECT ID,AccountId,contact.accountId,contactId from AccountContactRelation where contactId in :PersonAccList];
        Map<Id, List<Id>> PersonAccFamAccMap = new Map<Id,List<Id>>();
        Map<Id,List<SNI_FL_Care_Team_Member__c>> existingCareTeamLst = new Map<Id,List<SNI_FL_Care_Team_Member__c>>();
        map<Id,Id> accContactMap=new map<Id,Id>();
        List<Id> digitalOnboardAccount = new List<Id>();
        //Adding all the ACR with personAccount and FamilyAccount
        for(AccountContactRelation acr :acrLst){
            accContactMap.put(acr.contact.accountId,acr.contactId);
            if(PersonAccFamAccMap.containsKey(acr.contact.accountId)){
                PersonAccFamAccMap.get(acr.contact.accountId).add(acr.AccountId);
            }
            else{
                PersonAccFamAccMap.put(acr.contact.accountId,new list<Id>{acr.AccountId});
            }
            if(digitalOnboard.contains(acr.ContactId)){
                digitalOnboardAccount.add(acr.contact.accountId);
            }
        }
        //Fetching the existing care team records for the members
        for(SNI_FL_Care_Team_Member__c careTm : [SELECT ID,SNI_FL_Family__c,SNI_FL_Member__c,SNI_FL_Status__c,SNI_FL_Registered_Date__c,SNI_FL_Primary_Caregiver__c FROM SNI_FL_Care_Team_Member__c WHERE SNI_FL_Member__c in :PersonAccFamAccMap.keyset()]){
            if(!existingCareTeamLst.keyset().contains(careTm.SNI_FL_Member__c))
                existingCareTeamLst.put(careTm.SNI_FL_Member__c,new List<SNI_FL_Care_Team_Member__c>{(careTm)});
            else{
               List<SNI_FL_Care_Team_Member__c> ctmList= existingCareTeamLst.get(careTm.SNI_FL_Member__c);
                ctmList.add(careTm);
                existingCareTeamLst.put(careTm.SNI_FL_Member__c,ctmList);
            }
        }
        System.debug('existingCareTeamLst');
        List<SNI_FL_Care_Team_Member__c> careTeamLst = new List<SNI_FL_Care_Team_Member__c>();
        //Once the ACR fetched iterate over person account check whether record exists in care team or not. IF not create else update the status of existing record
        for(Id personAcc : PersonAccFamAccMap.keySet()){
           //US2736623: Care Team - Multi Policy Pop Up -Start
           List<Id> famAcntList=PersonAccFamAccMap.get(personAcc);
            //We need to only update for that user who got created
            //Added extra logic in pop up controller to check whether those family contains any primary care giver
           if(famAcntList!=null && famAcntList.size()>1 && PersonAccList.contains(accContactMap.get(personAcc))){
            Account acct = new Account(Id=personAcc,MultiPolicyCheck__c=true);
            personAccountUpdList.add(acct);
           }
           //End
           set<id> famCareTeamCheck=new set<id>();
           if(existingCareTeamLst!=null && existingCareTeamLst.get(personAcc)!=null){
               for(SNI_FL_Care_Team_Member__c careTeam: existingCareTeamLst.get(personAcc) ){
                            System.debug('Its coming here111='+careTeam.SNI_FL_Family__c);
                            famCareTeamCheck.add(careTeam.SNI_FL_Family__c);
                            //If a member is added in both the family -->Then he need to be invited to both the family
                            //if(careTeam.SNI_FL_Family__c == famAcnt){
                            if(careTeam.SNI_FL_Status__c=='Added'){ //As if he registered or removed --we dont want to update that
                                careTeam.SNI_FL_Status__c = 'Invited';
                                careTeam.SNI_FL_Invited_Date__c = Date.parse(DateTime.now().format('MM/dd/yyyy HH:mm:ss', 
                 'CST').substring(0,10));
                                careTeamLst.add(careTeam); 
                            }
               }
           }
               
           System.debug('famCareTeamCheck='+famCareTeamCheck);
           for(Id famAcnt : famAcntList){
                System.debug('check'+famAcnt);
               if(!famCareTeamCheck.contains(famAcnt)) {
                    System.debug('Creating New Care Team Record');
                    SNI_FL_Care_Team_Member__c careTeam=  new  SNI_FL_Care_Team_Member__c();
                    careTeam.SNI_FL_Family__c =famAcnt;
                    careTeam.SNI_FL_Member__c = personAcc;
                    if(mapOfUserRecords.containsKey(personAcc) && mapOfUserRecords.get(personAcc).Suppress_Email_Reset_Time__c!= null){ 
                            careTeam.SNI_FL_Status__c = 'Registered';
                            careTeam.SNI_FL_Registered_Date__c = Date.parse(DateTime.now().format('MM/dd/yyyy HH:mm:ss', 
                                                                                                  'CST').substring(0,10));
                            //Commenting the below line as a fix for DE665624. 
                            //The field will be set from ACETAccountTriggerHandler.createCareTeamList(Trigger.newMap , trigger.oldMap);
                            /*careTeam.SNI_FL_Primary_Caregiver__c = true;*/
                        }
                        else{
                            careTeam.SNI_FL_Status__c = 'Invited';
                        }
                    careTeam.SNI_FL_Added_Date__c = Date.parse(DateTime.now().format('MM/dd/yyyy HH:mm:ss', 
                 'CST').substring(0,10));
                    careTeam.SNI_FL_Invited_Date__c = Date.parse(DateTime.now().format('MM/dd/yyyy HH:mm:ss', 
                 'CST').substring(0,10));
                    careTeamLst.add(careTeam);
                }
            }
        }
        if(careTeamLst.size()>0){
            Database.upsert(careTeamLst);
        }
        if(digitalOnboard.size()>0){
            List<Account> acctToUpdate = new List<Account>();
            List<Account> acctList = [Select Id, PersonContactId, FamilyLink_Registration_Date__c from Account where PersonContactId in :digitalOnboard];
            for(Account acct:acctList){
                acct.FamilyLink_Registration_Date__c = Date.parse(DateTime.now().format('MM/dd/yyyy HH:mm:ss', 
                 'CST').substring(0,10));
                acctToUpdate.add(acct);
            }
            if(acctToUpdate.size()>0) update acctToUpdate;
        }
        //US2736623: Care Team - Multi Policy Pop Up -Start
        if(personAccountUpdList!=null && personAccountUpdList.size()>0)
           update personAccountUpdList;
        //End
    }
    public static void memAffShareInsertOperation(list<user> triggerNew){
        set<id> contactIds = new set<id>();
        set<id> userIdset = new set<id>();
        map<Id,Id> contactusrIDs = new map<Id,Id>();
        for(user u:triggerNew){
            if(u.Profile_Name__c == 'Care Advisor Connect Provider User'){
                contactIds.add(u.ContactId);
                userIdset.add(u.Id);
                contactusrIDs.put(u.ContactId,u.Id);
            }
        }
        if(contactIds.size()>0){
            System.enqueueJob(new ACETUserMemShareQueue(contactusrIDs, contactIds, userIdset));
        }
    }
    
    //Restrict SMS invitation for non best buy clients on user creation
    public static void restrictSmsInvitation(List<User> TriggerNew){
        ACETUserTriggerHandler.getUserDetails(TriggerNew);
        getACRDetails();
        for(User usr : TriggerNew){
            if(usr.Include_SMS_invitation__c == true && contactIds.contains(usr.ContactId)){
                if(usr.contactId != null && !validContactIds.contains(usr.ContactId)){
                    usr.addError(Label.Non_Approved_SMS_Clients_Error);
                }else if(usr.MobilePhone == '' || usr.MobilePhone == null){
                    usr.addError(Label.Blank_Phone_Number_Error);
                }else if(usr.contactId != null && validContactIds.contains(usr.ContactId)){
                    userListForSendSMS.add(usr);
                }
            }
        }
    }
    
    public static void getACRDetails(){
        if(contactIds.size() > 0){
            if(acrList == null){
                acrList = [SELECT ID,AccountId,Policy_Id__c,contact.accountId,contactId from AccountContactRelation where contactId in :contactIds];
                if(acrList.size() > 0){
                    for(AccountContactRelation acr : acrList){
                        if(mapOfValidClients.containsKey(acr.Policy_ID__c)){
                            validContactIds.add(acr.ContactId);
                        }   
                    }
                }
            }
        }
    }
    
    public static void restrictSmsInvitationOnUpdate(List<User> TriggerNew, Map<id, user> TriggerOldMap){
        for(User usr : TriggerNew){
            if(usr.Include_SMS_invitation__c != TriggerOldMap.get(usr.Id).Include_SMS_invitation__c){
                usr.addError(Label.SMS_Error_on_Update);
            }
            
        }
    }
    
    //Send SMS invitation for best buy clients on user creation
    public static void sendSmsInvitation(List<User> userList){
        if(Limits.getQueueableJobs() < Limits.getLimitQueueableJobs()){
            if(userListForSendSMS.size() > 0){
                SendSMSInvitation obj = new SendSMSInvitation(userListForSendSMS);
                System.enqueueJob(obj); 
            }
        }
    }
    
}