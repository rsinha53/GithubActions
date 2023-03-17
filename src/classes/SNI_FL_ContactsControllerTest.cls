//US2801031: This apex class will test SNI_FL_ContactsControllerTest.apxc to determined wehther it is returning correct value
//Author Name : Charnkiat Sukpanichnant
@isTest
public class SNI_FL_ContactsControllerTest {
        @testsetup
    static void setupFamilyContacts(){
        Account acc = new Account();
        Id famRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Family').getRecordTypeId();
        acc.RecordTypeId  = famRecordTypeId;
        acc.Name = 'Familyoverview family 003';
        insert acc;
        Family_Overview__c fo = new Family_Overview__c();
        //fo.Family_Status__c = 'Inactive';
        fo.Designation__c = 'Assigned';
        fo.Account__c = acc.id;
        insert fo;
        fo.Designation__c = 'Removed';
        update fo;
        
        Family_Contact__c fc= new Family_Contact__c();
        fc.Name='abc';
        fc.Email__c= 'abc@txt.com';
        fc.Phone__c='1234567890';
        fc.Status__c='Active';
        fc.Family__c= fo.id;
        insert fc;
        
        
    }
    
  	@isTest
    static void getcontactsvalid(){
        Test.startTest();
        Family_Overview__c[] fo = [Select Account__c from Family_Overview__c];
        string familyID = fo.get(0).Account__c;
        System.assert(SNI_FL_ContactsController.getContacts(familyID).lstcontactWrap.size() > 0);
        System.assert(SNI_FL_ContactsController.getContacts(familyID).ErrorOccured == false);
        System.assert(SNI_FL_ContactsController.getContacts(familyID).ErrorMessage == null);
        Test.stopTest();
     }
    
    @isTest
    static void getcontactsinvalid(){
        Test.startTest();
        SNI_FL_ContactsController.contactWrapperReturn contact = SNI_FL_ContactsController.getContacts('fake');
        System.assert(contact.lstcontactWrap.size() == 0);
        Test.stopTest();
     }
    
    @isTest
    static void getcontactByIDvalid(){
        Test.startTest();
        Family_Contact__c[] fc= [Select Id from Family_Contact__c];
        string fcID = fc.get(0).Id;
        System.assert(SNI_FL_ContactsController.getContactsBySelectedID(fcID).selectedFamilyContacts != null);
        System.assert(SNI_FL_ContactsController.getContactsBySelectedID(fcID).selectedFamilyContacts.contactFormattedPhone == null);
        System.assert(SNI_FL_ContactsController.getContactsBySelectedID(fcID).selectedFamilyContacts.contactphoto == null);
        System.assert(SNI_FL_ContactsController.getContactsBySelectedID(fcID).ErrorOccured == false);
        System.assert(SNI_FL_ContactsController.getContactsBySelectedID(fcID).ErrorMessage == null);
        Test.stopTest();
    }
    
    @isTest
    static void getcontactByIDInvalid(){
        Test.startTest();
        System.assert(SNI_FL_ContactsController.getContactsBySelectedID(null).selectedFamilyContacts == null);
        Test.stopTest();
    }

    @isTest
    static void updatecontactsValid(){
        Test.startTest();
        Family_Contact__c[] fc= [Select Id from Family_Contact__c];
        string fcID = fc.get(0).Id;
        System.assert(SNI_FL_ContactsController.updateContactsByID(fcID, 'Testing Forvever',null,'grandpa',null,null));
        Test.stopTest();
    }
    
    @isTest
    static void updatecontactsInvalid(){
        Test.startTest();
        System.assert(SNI_FL_ContactsController.updateContactsByID(null, null,null,null,null,null) == false);
        Test.stopTest();
    }

        @isTest
    static void deletecontactsValid(){
        Test.startTest();
        Family_Contact__c[] fc= [Select Id from Family_Contact__c];
        string fcID = fc.get(0).Id;
        System.assert(SNI_FL_ContactsController.deleteContactsByID(fcID));
        Test.stopTest();
    }
    
    @isTest
    static void deletecontactsInvalid(){
        Test.startTest();
        System.assert(SNI_FL_ContactsController.deleteContactsByID(null) == false);
        Test.stopTest();
    }
}