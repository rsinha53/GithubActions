@isTest(seeAllData = false)
public class ACETPharmacyInquiryControllerTest
{
  static testMethod void pharmacyInquiryTestsave()
  {  
    PageReference ACETPharamacyInquiry = Page.ACETPharmacyInquiry;
    Test.setCurrentPage(ACETPharamacyInquiry);
    Interaction__c Interaction = TestDataFactory.createInteraction();
    RecordType newRecord = [SELECT Id FROM RecordType WHERE Name = 'Person Account' and SObjectType = 'Account'];
        
    Account accountTest = new Account();
    accountTest.FirstName = 'Test';
    accountTest.LastName = 'Contact';
    accountTest.EID__c = 'TestEID1';
    accountTest.EID__pc = 'TestEID1';
    accountTest.RecordTypeId = newRecord.Id;
    insert accountTest;

  Account acc = [SELECT Id,personcontactid from Account where Id=:accountTest.Id];
    Contact con = [SELECT Id,LastName,FirstName,EID__c,AccountId from Contact where Id=:acc.personcontactid];
    System.currentPageReference().getParameters().put('InteractionId',Interaction.Id);
    System.currentPageReference().getParameters().put('contactId',con.Id);
    System.currentPageReference().getParameters().put('additionalInfo',TestDataFactory.createACETHighlightsPanelAdditionalInfo());
    Test.startTest();

        
        ACETPharmacyInquiryController  PharamacyInquirycontroller = new ACETPharmacyInquiryController();
        PharamacyInquirycontroller.getPharmacyInquiryCallTypes();
        ACETCallTopicsDataWrapper acetCallTopicDW = new ACETCallTopicsDataWrapper();
        acetCallTopicDW.saveCase();
    Test.stopTest();
    system.AssertNotEquals(acetCallTopicDW.caseObj.id,null);
   }
   
   static testMethod void pharmacyInquiryTestsaveClose()
  {  
    PageReference ACETPharamacyInquiry = Page.ACETPharmacyInquiry;
    Test.setCurrentPage(ACETPharamacyInquiry);
    Test.startTest();
    RecordType newRecord = [SELECT Id FROM RecordType WHERE Name = 'Person Account' and SObjectType = 'Account'];
        
    Account accountTest = new Account();
    accountTest.FirstName = 'Test';
    accountTest.LastName = 'Contact';
    accountTest.EID__c = 'TestEID1';
    accountTest.EID__pc = 'TestEID1';
    accountTest.RecordTypeId = newRecord.Id;
    insert accountTest;
        
        ACETPharmacyInquiryController  PharamacyInquirycontroller = new ACETPharmacyInquiryController();
        PharamacyInquirycontroller.getPharmacyInquiryCallTypes();
        ACETCallTopicsDataWrapper acetCallTopicDW = new ACETCallTopicsDataWrapper();
        acetCallTopicDW.saveAndClose();
    Test.stopTest();
    system.AssertNotEquals(acetCallTopicDW.caseObj.id,null);
    system.AssertEquals(acetCallTopicDW.caseObj.status,'Closed');
   }
    
  static testMethod void pharmacyInquiryTestCancel()
  {  
    PageReference ACETPharamacyInquirypage = Page.ACETPharmacyInquiry;
    Test.setCurrentPage(ACETPharamacyInquirypage);
    Test.startTest();
        ACETPharmacyInquiryController PharamacyInquirycontroller = new ACETPharmacyInquiryController();
        ACETCaseActionsController employerBrokercancel= new ACETCaseActionsController();        
        pageReference pageRef = employerBrokercancel.cancel();       
    Test.stopTest();
   
  }
}