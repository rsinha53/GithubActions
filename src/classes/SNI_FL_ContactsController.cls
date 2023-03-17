public without sharing class SNI_FL_ContactsController {
    
   @AuraEnabled
   public static contactWrapperReturn getContacts(String familyId){
        list<contactWrapper> lstcontactwrapper = new list<contactWrapper>();
        boolean ErrorOccured = false;
        string ErrorMessage = null;
        string DebugMessage = null;
        boolean isFLAccOwner =false;
        contactWrapperReturn objcontactWrapperReturn = new contactWrapperReturn();
        try{
            Family_Overview__c[] familyOverView = [select Name,id from Family_Overview__c where Account__c =: familyId];
            List<Family_Contact__c> fcon= [select Id, Name, Email__c, Phone__c,Relationship__c, Address__c from Family_Contact__c where Status__c ='Active' and Family__c IN: familyOverView order by CreatedDate desc] ;
            
                 for(Family_Contact__c c : fcon) 
                 {
                 contactWrapper contact = new contactWrapper();
                    contact.contactID = c.Id;
                    contact.contactName = c.Name;
                    contact.contactEmail = c.Email__c;
                    contact.contactPhone = c.Phone__c;
                    contact.contactRelationship = c.Relationship__c;
                    contact.contactAddress = c.Address__c;
                    lstcontactwrapper.add(contact);
                }
                
            
            objcontactWrapperReturn.lstcontactWrap = lstcontactwrapper;
            objcontactWrapperReturn.ErrorOccured = ErrorOccured;
            objcontactWrapperReturn.ErrorMessage = ErrorMessage;
            objcontactWrapperReturn.DebugMessage = DebugMessage;
        }
        catch(Exception e){
            AcetUtility.CreateAndRedirectToError('FamilyLink','SNI_FL_ContactController',e);
        	ErrorOccured = true;
        	ErrorMessage = e.getMessage();
        }
        return objcontactWrapperReturn;
    }
    
    @AuraEnabled
    public static SinglecontactWrapperReturn getContactsBySelectedID(String familyContactID){
        boolean ErrorOccured = false;
        string ErrorMessage = null;
        string DebugMessage = null;
        boolean isFLAccOwner =false;
        contactWrapper contact = new contactWrapper();
        SinglecontactWrapperReturn objcontactWrapperReturn = new SinglecontactWrapperReturn();
        try{
            Family_Contact__c fc= [select Id, Name, Email__c, Phone__c,Relationship__c, Address__c  from Family_Contact__c where Id =: familyContactID];
             contact.contactID = fc.Id;
             contact.contactName = fc.Name;
             contact.contactEmail = fc.Email__c;
             contact.contactPhone = fc.Phone__c;
            contact.contactRelationship = fc.Relationship__c;
            contact.contactAddress = fc.Address__c;
            objcontactWrapperReturn.selectedFamilyContacts = contact;
            objcontactWrapperReturn.ErrorOccured = ErrorOccured;
            objcontactWrapperReturn.ErrorMessage = ErrorMessage;
            objcontactWrapperReturn.DebugMessage = DebugMessage;
        }
        catch(Exception e){
            AcetUtility.CreateAndRedirectToError('FamilyLink','SNI_FL_ContactController',e);
        	ErrorOccured = true;
        	ErrorMessage = e.getMessage();
        }
        return objcontactWrapperReturn;
    }

    @AuraEnabled
    public static boolean updateContactsByID(String familyContactID, string contactName, string contactEmail,string contactAddress,string contactRelationship,string contactPhone){
        boolean ErrorOccured = false;
        string ErrorMessage = null;
        string DebugMessage = null;
        try{
            Family_Contact__c fc= [select Id, Name, Email__c, Phone__c,Relationship__c, Address__c  from Family_Contact__c where Id =: familyContactID limit 1];
            if(fc != null){
                fc.Name = contactName;
                fc.Email__c = (IsEmptyOrNull(contactEmail)) ? '': contactEmail;
                fc.Address__c = (IsEmptyOrNull(contactAddress)) ? '': contactAddress;
                fc.Relationship__c = (IsEmptyOrNull(contactRelationship)) ? '': contactRelationship;
                fc.Phone__c = (IsEmptyOrNull(contactPhone)) ? '': contactPhone;
                Update fc;
                return true;
            }
            else{
                return false;
            }

        }
        catch(Exception ex){
            AcetUtility.CreateAndRedirectToError('FamilyLink','SNI_FL_ContactController',ex);
        	ErrorOccured = true;
        	ErrorMessage = ex.getMessage();
            return false;
        }
    }

    @AuraEnabled
    public static boolean deleteContactsByID(String familyContactID){
        boolean ErrorOccured = false;
        string ErrorMessage = null;
        string DebugMessage = null;
        try{
            Family_Contact__c fc= [select Id, Name, Email__c, Phone__c,Relationship__c, Address__c  from Family_Contact__c where Id =: familyContactID limit 1];
            if(fc != null){
                fc.Status__c = 'Removed';
                upsert fc;
                return true;
            }
            else{
                return false;
            }
        }
        catch(Exception e){
            AcetUtility.CreateAndRedirectToError('FamilyLink','SNI_FL_ContactController',e);
        	ErrorOccured = true;
        	ErrorMessage = e.getMessage();
            return false;
        }
    }

    @AuraEnabled
    public static boolean IsEmptyOrNull(String value){
         return (value == null || String.isEmpty(value) || String.isBlank(value));
    }


    public class contactWrapperReturn {
        @AuraEnabled
        public list<contactWrapper> lstcontactWrap{get; set;}
        @AuraEnabled
        public boolean ErrorOccured {get;set;}
        @AuraEnabled
        public string ErrorMessage {get;set;}
        @AuraEnabled
        public string DebugMessage {get;set;}
    }

    public class SinglecontactWrapperReturn {
        @AuraEnabled
        public contactWrapper selectedFamilyContacts {get; set;}
        @AuraEnabled
        public boolean ErrorOccured {get;set;}
        @AuraEnabled
        public string ErrorMessage {get;set;}
        @AuraEnabled
        public string DebugMessage {get;set;}
    }
    
    public class contactWrapper {
        @AuraEnabled
        public String contactID {get;set;}
        @AuraEnabled
        public string contactName{get;set;}
        @AuraEnabled
        public string contactEmail{get;set;}
        @AuraEnabled
        public string contactPhone{get;set;}
        @AuraEnabled
        public string contactRelationship{get;set;}
        @AuraEnabled
        public string contactAddress{get;set;}
        @AuraEnabled
        public string contactFormattedPhone {get;set;}
        @AuraEnabled
        public string contactphoto{get;set;}
    }
}