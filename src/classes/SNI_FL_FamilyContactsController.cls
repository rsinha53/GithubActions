//US2798609_US2798673: This apex class return the fields of Family Contact Custom object associated with current Family to the SNI_FL_FamilyContactsHelper.js 
//Author Name : Aarti garg, Vishal Yelisetti
public class SNI_FL_FamilyContactsController {
	@AuraEnabled
    public static List<Family_Contact__c> fetchFamilyContacts(String recordID)
    {
        List <Family_Contact__c> fo = new  List <Family_Contact__c>();
        try {
            if(recordID !=NULL)
            {
                fo= [select Id, Name, Email__c, Phone__c, Relationship__c, Address__c  from Family_Contact__c where Status__c ='Active' and Family__c=: recordID order by CreatedDate desc];
                
            }
            return fo;
        }
        catch(Exception e){ return null;}
    }
    
    @AuraEnabled
    public static String getUserProfile(){
        Id profileId=userinfo.getProfileId();
        String profileName=[Select Id,Name from Profile where Id=:profileId].Name;
        return profileName;
    }
    
    @AuraEnabled
    public static Family_Contact__c editContacts(Family_Contact__c selContact) {
        if(selContact!=NULL) {
            upsert selContact;
        }
        return selContact;
    }
    
    @AuraEnabled
    public static Family_Contact__c removeContact(Family_Contact__c selContact) {
        if(selContact!=NULL) {
        	selContact.Status__c = 'Removed';
            upsert selContact;
        }
        return selContact;
    }
    @AuraEnabled
    public static List<Family_Contact__c> fetchFamilyNPCGContacts(string recordId){
        List <Family_Contact__c> fc = new  List <Family_Contact__c>();
        try {
            if(recordId !=NULL){
                fc = [select Id, Name, Email__c, Phone__c, Address__c, Relationship__c, Preferred_Method__c, Primary_caregiver__c, Preferred_Name__c, Communications__c  from Family_Contact__c where Status__c ='Active' and Family_Account__c=: recordId order by CreatedDate desc];
            }  
            return fc;
        }
        catch(Exception e){ return null;}
    }
    @AuraEnabled
    public static Family_Contact__c addNewcareContact(Family_Contact__c caregiver){
        if(caregiver != null){
            string careGiverRTId = Schema.SObjectType.Family_Contact__c.getRecordTypeInfosByName().get('Family Caregiver').getRecordTypeId();
            caregiver.RecordTypeId = careGiverRTId;
            insert caregiver;
            return caregiver;
        }
        return null;
    }
    @AuraEnabled
    public static List<String> getPreferredMethods(){
        Family_Contact__c fContact = new Family_Contact__c();
        List<String> options = getPickListOptions(fContact, 'Preferred_Method__c');
        options.sort();
        return options; 
    }
    @AuraEnabled
    public static List<String> getPickListOptions(SObject sobj, String fieldName){
        List<String> optionList = new List<String>();
        Schema.SObjectType objType = sobj.getSObjectType();
        Schema.DescribeSObjectResult objDescribe = objType.getDescribe();
        Map<String, Schema.SObjectField> fieldMap = objDescribe.fields.getMap();
        List<Schema.PickListEntry> values = fieldMap.get(fieldName).getDescribe().getPickListValues();
        for(Schema.PickListEntry a :values){
            optionList.add(a.getValue());
        }
        return optionList;
    }
}