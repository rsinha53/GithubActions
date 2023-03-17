public class MemberAffiliationTriggerHandler {
	
    Public void Memberrecordsharing(List<Member_Affiliation__c> MemberListNew,Map<Id, Member_Affiliation__c> oldMemberMap){	
     List<Member_Affiliation__c> MemberList = new List<Member_Affiliation__c>();
     map<String,String> ProviderMap = new map<String,String>();
     map<String,String> ProviderUserMap = new map<String,String>();
     set<id> ProviderAffiliation = new set<id>();
     set<id> ProviderUser = new set<id>();
     List<id> userid = new List<id>();
     List<Member_Affiliation__Share> memaffshr = new List<Member_Affiliation__Share>();
        for (Member_Affiliation__c memAff : MemberListNew)
        {   if(oldMemberMap != null){
            if(memAff.Provider_Affiliation__c != null && oldMemberMap.get(memAff.id).Status__c ==false && memAff.Status__c ==true){
              ProviderAffiliation.add(memaff.Provider_Affiliation__c);
              ProviderMap.put(memaff.Provider_Affiliation__c,memaff.id);	
            }
            }else{
             if(memAff.Provider_Affiliation__c != null && memAff.Status__c ==true){
              ProviderAffiliation.add(memaff.Provider_Affiliation__c);
              ProviderMap.put(memaff.Provider_Affiliation__c,memaff.id);	
             }        
            }
		}
        for (AccountContactRelation Provideraff : [Select id,AccountId,ContactId,Relationship__c  from AccountContactRelation where AccountId in :ProviderAffiliation]){
            If(Provideraff.Relationship__c =='Provider User'){
              ProviderUser.add(Provideraff.ContactId);
              ProviderUserMap.put(Provideraff.ContactId,Provideraff.AccountId);
            } 
        }
        //Map<Id, contact> contactMap = new Map<Id, contact>([Select id,AccountId,Account.RecordTypeId from contact where id in :ProviderUserMap.values() and Account.RecordTypeId =:proUsrRecordTypeId]);
        List<user> UsrList =[select id,Contact.Account.Id,ContactId,Contact.Account.Email_Notification__c from User where ContactId in :ProviderUser];
        
        for(User usr: UsrList){
            if(ProviderUserMap.containsKey(usr.ContactId)){
               if(ProviderMap.containsKey(ProviderUserMap.get(usr.ContactId))){
                  Member_Affiliation__Share memshr  = new Member_Affiliation__Share();
                  memshr.ParentId = ProviderMap.get(ProviderUserMap.get(usr.ContactId));
     	    	  memshr.UserOrGroupId = usr.id;
     	          memshr.AccessLevel = 'Read';
                  memshr.RowCause = Schema.Member_Affiliation__Share.RowCause.Manual;
                  memaffshr.add(memshr);
                  if(usr.Contact.Account.Email_Notification__c ==true){
                  userid.add(usr.id);
                   }
               }
             }
        }
        
        if(!memaffshr.isEmpty()){
            system.debug('userid:'+userid);
              try {
                if (!userid.isEmpty()) { 
                   
                   SNI_FL_Notification_Center.SendNotificationList(userid);
                   
                }
              } catch (Exception e) {
                  //Handling exception gracefully because this shouldn't throw an exception on front-end/UI and shouldn't block other events
                  System.debug(LoggingLevel.WARN, 'Acet Exception - Something went wrong while sending Email or SMS Notification: ' + e.getMessage());
              }
            system.debug('memaffshr'+memaffshr);
            insert memaffshr;
        }
     
   }
   
}