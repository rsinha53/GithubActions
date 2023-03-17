//US2841187: This test class covering the functionality of SNI_FL_RxMedicationsControllerTest class.
//Author Name : Aarti garg, Vishal Yelisetti
@isTest
public class SNI_FL_RxMedicationsControllerTest {
    @testsetup
    static void setupRxMeds(){
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
        
        Family_Link_Rx_Medication__c rxm= new Family_Link_Rx_Medication__c();
        rxm.Name='abc';
        rxm.Pill_Size__c = '50';
        rxm.Directions__c = 'Take 1 pill daily.';
        rxm.Rx_Number__c = '123456';
        rxm.Refill_Date__c = Date.parse('01/01/2021');
        rxm.Pharmacy__c = 'Test Pharmacy';
        rxm.Pharmacy_Phone_Number__c = '1234567890';
        rxm.Status__c='Active';
        rxm.Family__c= fo.id;
        insert rxm;
        
        
    }
    @isTest static void callRxMeds(){
        Test.startTest();
        Family_Link_Rx_Medication__c recordID=   [Select  Family__c from Family_Link_Rx_Medication__c where Name='abc'];
        List<Family_Link_Rx_Medication__c> lstFC=SNI_FL_RxMedicationsController.fetchRxMedications(recordID.Family__c);
        Test.stopTest();
        
    } 
    
    @isTest static void getUserInfo(){
        Test.startTest();
        String userPro = SNI_FL_RxMedicationsController.getUserProfile();
        System.assert(String.isNotBlank(userPro));
        Test.stopTest();
        
    }  
    
    @isTest static void updateRxMedInfo() {
        Test.startTest();
        Family_Link_Rx_Medication__c rxm = new Family_Link_Rx_Medication__c();
		rxm.Name = 'Super Soldier Serum';
		rxm.Directions__c = 'Take 1 pill daily.';
		rxm.Refill_Date__c = Date.parse('11/01/2020');
        Family_Link_Rx_Medication__c rxMed = SNI_FL_RxMedicationsController.editRxMed(rxm);
       	System.assertEquals('Super Soldier Serum', rxMed.Name);
        Test.stopTest();
	}
    
    @isTest static void removeRxMedInfo() {
        Test.startTest();
        Family_Link_Rx_Medication__c rxm = new Family_Link_Rx_Medication__c();
		rxm.Name = 'Super Soldier Serum';
		rxm.Directions__c = 'Take 1 pill daily.';
		rxm.Refill_Date__c = Date.parse('11/01/2020');
        Family_Link_Rx_Medication__c rxMed = SNI_FL_RxMedicationsController.removeRxMed(rxm);
       	System.assertEquals('Super Soldier Serum', rxMed.Name);
        System.assertEquals('Removed', rxMed.Status__c);
        Test.stopTest();
	}
}