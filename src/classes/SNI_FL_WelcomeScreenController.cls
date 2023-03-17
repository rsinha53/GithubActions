public without sharing class SNI_FL_WelcomeScreenController {
   /*                           
    US3219334 - Team Eagles - Bobby Culbertson
    
   */

    @AuraEnabled
    public static User getAdvisor(){
        try{    
            User u = [select id, ContactId, contact.accountid FROM User where id = : UserInfo.getUserId()];
            //Logic in the Digital Onboarding components will not allow registration to happen if you have multiple family account associations
            //That is where, in this ACR query, we can depend on only 1 record return to be accurate.
            //Contact con = [Select Id, AccountId From Contact WHERE Id = :u.ContactId LIMIT 1];
            //Account family = [Select Id, OwnerId FROM Account WHERE ID = :con.AccountId LIMIT 1]; 
            AccountContactRelation acr = [SELECT account.ownerId FROM AccountContactRelation WHERE ContactId =: u.contactId];
            User advisor = new User();
            advisor = [select id, Name, FirstName, LastName, FullPhotoUrl, MediumPhotoUrl FROM User where id = :acr.account.OwnerId ];
            return advisor;
        } catch (Exception e){
            system.debug('exception occured in getAdvisor:::' + e.getMessage());
            return null;
        }   
    }

    @AuraEnabled
    public static Account getPerson(){
        try{
            User u = [select id, contact.accountid FROM User where id = : UserInfo.getUserId()];
            Account person = [Select Id, FirstName, LastName FROM Account WHERE ID = :u.contact.accountId LIMIT 1];
            return person;
        } catch (Exception e){
            system.debug('exception occured in getPerson:::' + e.getMessage());
            return null;
        }
    }
}