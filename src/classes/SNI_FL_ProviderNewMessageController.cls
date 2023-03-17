/****************************************************************************** 
Class Name     : SNI_FL_ProviderAdvisorMessage
Description    : Create provider messages in advisor view
Created By     : Sameera -ACDC  US3128709,US3128731
Created Date   : 1/17/2020
******************************************************************************/
public with sharing class SNI_FL_ProviderNewMessageController {

    public static Set<ID> providerTeam = new Set<ID>();
    public static Set<String> advisors = new Set<String>();
    private static final String TEAMNAME=' ACDC ';
    /**
    * @description get user ids of recipients
    * @param recipentList 
    * @return  `List<String>`
    */
   public static List<String> getRecipientList(List<Object> recipentList){

    
    List<String> recipientIds = new List<String>();
        try{
            for(Object a:recipentList){
                Map<Object,Object> val = (Map<Object,Object>)a;
        
                Switch on (String)val.get('userType'){
                    when 'PT'{
                        providerTeam.add((ID)val.get('value'));
                    }
                    when 'PU'{
                        recipientIds.add((String)val.get('value'));
                    }
                    when else{
                        advisors.add((String)val.get('value'));
                        recipientIds.add((String)val.get('value'));
                    }
                }
            }
            recipientIds.addAll(getUserIDs(getContactList(providerTeam)));
            return recipientIds;
        
        }catch(Exception ex){
            System.debug(TEAMNAME+'Method Name:getRecipientList '+ex.getMessage()+':'+ex.getLineNumber());
           
            return null;
        }
     }

  /**
   * @description getContactIds from ProviderTeam accounts
   * @param providerTeam 
   * @return  `Set<Id>`
   */   
  private static Set<Id> getContactList(Set<ID> providerTeam){
       Set<Id> contactIds = new Set<Id>();

       try{
            ID providerUserrecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Provider_User').getRecordTypeId();    
            for(AccountContactRelation acr:[SELECT Id, ContactId FROM AccountContactRelation WHERE AccountId IN :providerTeam AND Contact.IsPersonAccount=true AND Contact.Account.RecordTypeId=:providerUserrecordTypeId]){
                contactIds.add(acr.ContactId);
            } 
    
            return contactIds;
       }catch(Exception ex){
        System.debug(TEAMNAME+'Method Name:getContactList '+ex.getMessage()+':'+ex.getLineNumber());

            return null;
       }
       
  }

  /**
   * @description  getUser ids from contactids
   * @param contactIds 
   * @return  `List<ID>`
   */   
  private static List<ID> getUserIDs(Set<Id> contactIds){
   List<Id> users = new List<Id>();

   try{
        for(User usr:[SELECT id FROM User WHERE ContactId IN :contactIds AND IsActive=true]){
            users.add(usr.id);
        }
        return users;
   }catch(Exception ex){
    System.debug(TEAMNAME+'Method Name:getUserIDs '+ex.getMessage()+':'+ex.getLineNumber());

        return null;  
   }   

  }

  /**
   * @description  create SNI_FL_Message_Provider_Team record
   */  
  public static void createMessageProviderTeam(Id flMessageID,Savepoint sp){

    try{
        List<SNI_FL_Message_Provider_Team__c> lstProviderTeams = new List<SNI_FL_Message_Provider_Team__c>();
        for(Id teamID:providerTeam){

            SNI_FL_Message_Provider_Team__c pTobj = new SNI_FL_Message_Provider_Team__c();
            pTobj.Provider_Team__c = teamID;
            pTobj.SNI_FL_Message__c = flMessageID;

            lstProviderTeams.add(pTobj);
        }
        insert lstProviderTeams;
    }catch(Exception ex){
        Database.rollback(sp);
        System.debug(TEAMNAME+'Method Name:createMessageProviderTeam '+ex.getMessage()+':'+ex.getLineNumber());

    }
  }

}