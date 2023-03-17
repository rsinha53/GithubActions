//US2798609_US2798673: This test class covering vthe functionality of SNI_FL_FamilyContacts class.
//Author Name : Aarti garg, Vishal Yelisetti
@isTest
public class SNI_FL_FamilyContactsControllerTest {
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
        Family_Contact__c fac = new Family_Contact__c();
        fac.Name='careGiver test user';
        fac.Email__c='abdc876@optum.acet.com';
        fac.Status__c='Active';
        fac.Family_Account__c=acc.Id;
        insert fac;
        
    }
    @isTest static void callFamilyContacts(){
        Test.startTest();
        Family_Contact__c recordID=   [Select  Family__c from Family_Contact__c where name='abc'];
        List<Family_Contact__c> lstFC=SNI_FL_FamilyContactsController.fetchFamilyContacts(recordID.Family__c);
        Test.stopTest();
        
    } 
    
    @isTest static void getUserInfo(){
        Test.startTest();
        String userPro = SNI_FL_FamilyContactsController.getUserProfile();
        System.assert(String.isNotBlank(userPro));
        Test.stopTest();
        
    }  
    
    @isTest static void updateContactInfo() {
        Test.startTest();
        Family_Contact__c con = new Family_Contact__c();
        con.Address__c = 'Call Pizza Hut';
        con.Name = 'Pizza Hut';
        Family_Contact__c famCont = SNI_FL_FamilyContactsController.editContacts(con);
       	System.assertEquals('Pizza Hut', famCont.Name);
        Test.stopTest();
	}
    
    @isTest static void removeContactInfo() {
        Test.startTest();
        Family_Contact__c con = new Family_Contact__c();
        con.Address__c = 'Call Pizza Hut';
        con.Name = 'Pizza Hut';
        Family_Contact__c famCont = SNI_FL_FamilyContactsController.removeContact(con);
       	System.assertEquals('Pizza Hut', famCont.Name);
        Test.stopTest();
	}
    @isTest static void fetchFamilyNPCGContactsTest(){
        Test.startTest();
        Family_Contact__c recordID=   [Select  Family_Account__c from Family_Contact__c where name='careGiver test user'];
        List<Family_Contact__c> lstFC=SNI_FL_FamilyContactsController.fetchFamilyNPCGContacts(recordID.Family_Account__c);
        System.assertEquals('careGiver test user', lstFC[0].Name);
        Test.stopTest();
    }
    @isTest static void createFamilyNPCGContactsTest(){
        Test.startTest();
        account acc = [select Id from account limit 1];
        Family_Contact__c fcc = new Family_Contact__c();
        fcc.Name ='testing';
        fcc.phone__c = '12345678';
        fcc.Family_Account__c = acc.Id;
        string careGiverRTId = Schema.SObjectType.Family_Contact__c.getRecordTypeInfosByName().get('Family Caregiver').getRecordTypeId();
        Family_Contact__c record=  SNI_FL_FamilyContactsController.addNewcareContact(fcc);
        System.assertEquals(careGiverRTId, record.RecordTypeId);
        Test.stopTest();
    }
    @isTest static void getPreferredMethodsTest(){
     	Test.startTest();
        List<String> preferredMethods = SNI_FL_FamilyContactsController.getPreferredMethods();
        System.assert(preferredMethods.size()>0);
    	Test.stopTest();
    }
    
}