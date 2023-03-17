//US2812235: Testing SNI_FL_RecordsController
//Author Name : Derek DuChene
@isTest
public with sharing class SNI_FL_RecordsControllerTest {
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
        
         Family_Link_Rx_Medication__c fr= new Family_Link_Rx_Medication__c();
        fr.Family__c = fo.Id;
        fr.Status__c = 'Active';
        fr.Name='abc';
        fr.Pill_Size__c= '10';
        fr.Directions__c='12790 primrose ln';
        fr.Rx_Number__c='Active';
      	fr.Refill_Date__c=system.today();
        fr.Pharmacy__c='Eden prairie';
        fr.Pharmacy_Phone_Number__c ='1234567890';
        
        insert fr;
        
        
    }
    
  	@isTest
    static void getcontactsvalid(){
        Test.startTest();
        Family_Overview__c[] fo = [Select Account__c from Family_Overview__c];
        string familyID = fo.get(0).Account__c;
        System.assert(SNI_FL_RecordsController.getContacts(familyID).lstcontactWrap.size() > 0);
        System.assert(SNI_FL_RecordsController.getContacts(familyID).ErrorOccured == false);
        System.assert(SNI_FL_RecordsController.getContacts(familyID).ErrorMessage == null);
        Test.stopTest();
     }
    
    @isTest
    static void getcontactsinvalid(){
        Test.startTest();
        SNI_FL_RecordsController.contactWrapperReturn contact = SNI_FL_RecordsController.getContacts('fake');
        System.assert(contact.lstcontactWrap.size() == 0);
        Test.stopTest();
     }
     
     @isTest
    static void addcontacts(){
        Test.startTest();
        Family_Overview__c[] fo = [Select Account__c from Family_Overview__c];
        string familyID = fo.get(0).Account__c;
        SNI_FL_RecordsController.contactWrapperReturn contact = SNI_FL_RecordsController.addContacts('test1', 'test1@test1.com', '1234567890', 'test1 avenue', 'Neighbor', familyID);
        Family_Contact__c[] fc = [Select id,Name from Family_Contact__c where Name = 'test1'];
        System.assert(fc.size() > 0);
        Test.stopTest();
     }
    
     @isTest
    static void addRxMeds(){
        Test.startTest();
        Family_Overview__c[] fo = [Select Account__c from Family_Overview__c];
        string familyID = fo.get(0).Account__c;
        Date d= system.today();
       SNI_FL_RecordsController.RxMedWrapperReturn rx = SNI_FL_RecordsController.addRxMeds('test6', '10', '12356 primrose ln', 'RxNum10', d, 'Neighbor', '1234567890', familyID);
        Family_Link_Rx_Medication__c[] frx = [Select id,Name from Family_Link_Rx_Medication__c where Name = 'test6'];
       System.assert(frx.size() > 0);
        Test.stopTest();
     }
    
    @isTest
    static void getRxMedsvalid(){
        Test.startTest();
        Family_Overview__c[] fo = [Select Account__c from Family_Overview__c];
        string familyID = fo.get(0).Account__c;
         
        Family_Link_Rx_Medication__c[] frx = [Select id,Name, Family__c from Family_Link_Rx_Medication__c];
     	System.assert(SNI_FL_RecordsController.FetchRXMed(familyID).lstRxMedWrap.size() > 0);
	System.assert(SNI_FL_RecordsController.FetchRXMed(familyID).ErrorOccured == false);
        System.assert(SNI_FL_RecordsController.FetchRXMed(familyID).ErrorMessage == null);
        Test.stopTest();
     }
    @isTest
    static void getRXMedsinvalid(){
        Test.startTest();
        SNI_FL_RecordsController.RxMedWrapperReturn rx =SNI_FL_RecordsController.FetchRXMed('fake');
        System.assert(rx.lstRxMedWrap.size() == 0);
        Test.stopTest();
     }
}