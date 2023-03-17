public without sharing class ACETFamilyGuideCreationController {
    
    @AuraEnabled
    public static void createFSG(string selectVal,Id accountId,Id fsgRecordId){
        //system.debug('ACETFamilyGuideCreationController----createFSG');
        //system.debug('ACETFamilyGuideCreationController----accountId');
        Family_Story_Guide__c famGuide = new Family_Story_Guide__c();
        famGuide.Id = fsgRecordId;
        if(selectVal == 'No'){
            famGuide.Status__c	= 'Declined (Not Interested)';
        }
        else if(selectVal == 'Later'){
            famGuide.Status__c	= 'Declined (Busy, Try Again)';
        }
        famGuide.Status_Modified_Date__c	= system.today();
        famGuide.Expiration_Date__c	= system.today().addMonths(6);
        famGuide.Account__c = accountId;
        Update famGuide;
        
        //famGuide.Expiration_Date__c	= '';   	
    }
    
    @AuraEnabled
    public static Family_Story_Guide__c getFsgRecord(Id accountId){
        Family_Story_Guide__c fsgRecord = new Family_Story_Guide__c(); 
        if(accountId  != null){
            List<Family_Story_Guide__c> fsgRec = [SELECT ID,Status__c,Status_Modified_Date__c,Expiration_Date__c FROM Family_Story_Guide__c Where account__c =: accountId ];
            if(fsgRec.size()>0){
                fsgRecord = fsgRec[0] ;
            }
            
        }
        return fsgRecord ;
        
    }
    @AuraEnabled
    public static boolean getUhgOnshoreRestriction(String accountId){
        Boolean userAccess = true;
       // Boolean uhgPolicy ;
        if(accountId != null){
            List<Account> accRec = [SELECT id,Name,Policy_ID__c,Onshore_Restriction__c FROM Account where Id=:accountId];
            if(accRec != null && ! accRec.isempty()){
            User usr = [SELECT ID,UHG_Access__c,Agent_Type__c FROM USER Where ID=: UserInfo.getUserId()];
            //uhgPolicy = ACETUtility.checkUHGPolicy(accRec[0].Policy_ID__c);
            List<Family_Overview__c> fmOverview = new List<Family_Overview__c>();
            fmOverview = [SELECT UHG_Restriction__c,Onshore_Restriction__c FROM Family_Overview__c WHERE Account__c =:accountId ];
            if(fmOverview == null || fmOverview.isempty()){
                 Family_Overview__c famover = new Family_Overview__c(); 
                 famover.Name = accRec[0].Name+' Family Overview';
                 famover.Account__c = accRec[0].id;
                 famover.Exception__c = 'No';
                 famover.Designation_Changed_Date__c = Date.today();
                 famover.Last_Active_Date__c  = Date.today();
                 boolean insertFO = true;
                 if( ACETUtility.checkUHGPolicy(accRec[0].Policy_ID__c) ){
                     famover.UHG_Restriction__c	 = 'Yes';
                     if(usr.UHG_Access__c != 'Yes'){
                         userAccess = false;
                         list<user> lstUnasignUser = [select id,name,email from user where name = 'Unassigned'];
                         if(lstUnasignUser != null && ! lstUnasignUser.isEmpty())
                             famover.OwnerId = lstUnasignUser[0].id ;
                         else
                              insertFO = false;
                         
                     }
                 }
                 else{
                     famover.UHG_Restriction__c	 = 'No';
                 }
                 if(insertFO){
                    famover.Onshore_Restriction__c = accRec[0].Onshore_Restriction__c;
                    if(accRec[0].Onshore_Restriction__c == 'Yes'){
                        if(usr.Agent_Type__c != 'Onshore'){
                            userAccess = false;
                            list<user> lstUnasignUser = [select id,name,email from user where name = 'Unassigned'];
                            if(lstUnasignUser != null && ! lstUnasignUser.isEmpty())
                                famover.OwnerId = lstUnasignUser[0].id ;
                            else
                                insertFO = false;
                        }
                    }
                }
                fmOverview.add(famover);
                if(insertFO)
                   insert fmOverview;
            }
            else {
                if((fmOverview[0].UHG_Restriction__c == 'Yes' && usr.UHG_Access__c != 'Yes' ) || (fmOverview[0].Onshore_Restriction__c == 'Yes' && usr.Agent_Type__c != 'Onshore')){
                    userAccess = false;
                }
            }
        }
        }
        system.debug('******* user access'+userAccess);
        return userAccess;
    }
    @AuraEnabled
    public static String getUserProfile(){
        Id profileId=userinfo.getProfileId();
        String profileName=[Select Id,Name from Profile where Id=:profileId].Name;
        System.debug('profileName=='+profileName);
        return profileName;
    }
    
}