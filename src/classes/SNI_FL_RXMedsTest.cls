//US2801031: This apex class will test SNI_FL_RXMedsFL.apxc to determined wehther it is returning correct value
//Author Name : Aarti Garg
@isTest
public class SNI_FL_RXMedsTest {
@testsetup
    static void setupRXMeds(){
        Account acc = new Account();
        Id famRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Family').getRecordTypeId();
        acc.RecordTypeId  = famRecordTypeId;
        acc.Name = 'Familyoverview family 003';
        insert acc;
        Family_Overview__c fo = new Family_Overview__c();
       	fo.Designation__c = 'Assigned';
        fo.Account__c = acc.id;
        insert fo;
        fo.Designation__c = 'Removed';
        update fo;
        
       Family_Link_Rx_Medication__c fr= new Family_Link_Rx_Medication__c();
        fr.Family__c = fo.Id;
        fr.Status__c = 'Active';
        fr.Name='abc';
        fr.Pill_Size__c= '10';
        fr.Directions__c='12790 primrose ln';
        fr.Rx_Number__c='Active';
      	fr.Refill_Date__c=Date.newInstance(2020, 01, 22);
        fr.Pharmacy__c='Eden prairie';
        fr.Pharmacy_Phone_Number__c ='1234567890';
        
        insert fr;
        
        
    }
    	@isTest
    static void getRxMedsvalid(){
        Test.startTest();
        Family_Overview__c[] fo = [Select Account__c from Family_Overview__c];
        string familyID = fo.get(0).Account__c;
        System.assert(SNI_FL_RXMedsFL.FetchRXMed(familyID).lstRxMedWrap.size() > 0);
        System.assert(SNI_FL_RXMedsFL.FetchRXMed(familyID).ErrorOccured == false);
        System.assert(SNI_FL_RXMedsFL.FetchRXMed(familyID).ErrorMessage == null);
        Test.stopTest();
     }
    @isTest
    static void getRXMedsinvalid(){
        Test.startTest();
        SNI_FL_RXMedsFL.RxMedWrapperReturn rx =SNI_FL_RXMedsFL.FetchRXMed('fake');
        System.assert(rx.lstRxMedWrap.size() == 0);
        Test.stopTest();
     }
    @isTest
    static void getRxMedsByIDvalid(){
        Test.startTest();
        Family_Link_Rx_Medication__c[] frx= [Select Id from Family_Link_Rx_Medication__c];
        string frxID = frx.get(0).Id;
        System.assert(SNI_FL_RXMedsFL.getRxMedsBySelectedID(frxID).selectedRxMed != null);
        System.assert(SNI_FL_RXMedsFL.getRxMedsBySelectedID(frxID).ErrorOccured == false);
        System.assert(SNI_FL_RXMedsFL.getRxMedsBySelectedID(frxID).ErrorMessage == null);
        Test.stopTest();
    }
    
    @isTest
    static void getcontactByIDInvalid(){
        Test.startTest();
        System.assert(SNI_FL_RXMedsFL.getRxMedsBySelectedID(null).selectedRxMed == null);
        Test.stopTest();
    }
    
    @isTest
    static void updateRxMedValid(){
        Test.startTest();
        Family_Link_Rx_Medication__c[] frx= [Select Id from Family_Link_Rx_Medication__c];
        string frxID = frx.get(0).Id;
        Date d= system.today();
        System.assert(SNI_FL_RXMedsFL.updateRxMedsByID(frxID, 'RxNum','10','Eden Prairie','rxnum101',d,'1270 primrose ln', '1234567890'));
        Test.stopTest();
    }
    
    @isTest
    static void updateRxMedInvalid(){
        Test.startTest();
        System.assert(SNI_FL_RXMedsFL.updateRxMedsByID(null, null,null,null,null,null,null,null) == false);
        Test.stopTest();
    }
    
     @isTest
    static void deleteRxMedsValid(){
        Test.startTest();
        Family_Link_Rx_Medication__c[] frx= [Select Id from Family_Link_Rx_Medication__c limit1];
       	string frxID = frx.get(0).Id;
        System.assert(SNI_FL_RXMedsFL.deleteRxMedByID(frxID));
        Test.stopTest();
    }
    
    @isTest
    static void deleteRxMedsInvalid(){
        Test.startTest();
        System.assert(SNI_FL_RXMedsFL.deleteRxMedByID(null) == false);
        Test.stopTest();
    }
   
    
}