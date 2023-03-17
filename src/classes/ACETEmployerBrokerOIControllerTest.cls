@isTest(seeAllData=false)
public class ACETEmployerBrokerOIControllerTest
{
  static testMethod void ACETEmployerBrokerOIControllerTestsave()
  {  
    PageReference ACETEEBOIpage = Page.ACETEmployerBrokerOtherInquiry;
    ACETEEBOIpage.getParameters().put('additionalInfo', TestDataFactory.createACETHighlightsPanelAdditionalInfo());        
    Test.setCurrentPage(ACETEEBOIpage);
    Test.startTest();
        RecordType newRecord = [SELECT Id FROM RecordType WHERE Name = 'Person Account' and SObjectType = 'Account'];
        
        Account accountTest = new Account();
        accountTest.FirstName = 'Test';
        accountTest.LastName = 'Contact';
        accountTest.EID__c = 'PIN';
        accountTest.EID__pc = 'PIN';
        accountTest.RecordTypeId = newRecord.Id;
        insert accountTest;

    Account acc = [SELECT Id,personcontactid from Account where Id=:accountTest.Id];
        Contact contactRec = [SELECT Id,LastName,FirstName,Name,EID__c,AccountId from Contact where Id=:acc.personcontactid];
        
        Interaction__c inter = ACETProviderUtility.CreateInteraction(contactRec.Id,'Phone','',ContactRec.name);
            inter.Highlight_Panel_GroupInfo__c='{"UHCBS":"YES","ServiceTeam":"National Accounts","RiskManagement":"Audit","RenewalDate":"4/6/2018","RelationshipType":null,"RatingMethod":"","GroupStatus":"Active","groupSName":"37E9769CORG1","GroupName":"37E9769C - 37E9769CORG1","EffectiveStartDate":"4/6/2017"}';
            insert inter;
            
         apexpages.currentpage().getparameters().put('interactionId',inter.id);
        
        ACETEmployerBrokerOtherInquiryController ACETEEBOIcontroller = new ACETEmployerBrokerOtherInquiryController();
        ACETEEBOIcontroller.selectedTopic = 'Producer Other Inquiry';
        ACETEEBOIcontroller.subject=contactRec;
        ACETEEBOIcontroller.swivelATNE_URL='test';
        ACETEEBOIcontroller.swivelORBIT_URL='test';
        ACETCallTopicsDataWrapper acetCallTopicDW = new ACETCallTopicsDataWrapper();
        acetCallTopicDW.MigrationIssue=true;
        acetCallTopicDW.saveCase();
    Test.stopTest();
    system.AssertNotEquals(acetCallTopicDW.caseObj.id,null);
   }
   
   static testMethod void ACETEmployerBrokerTestsaveClose()
  {  
    PageReference ACETEEBOIpage = Page.ACETEmployerBrokerOtherInquiry;
    Test.setCurrentPage(ACETEEBOIpage);
    Test.startTest();
        RecordType newRecord = [SELECT Id FROM RecordType WHERE Name = 'Person Account' and SObjectType = 'Account'];
        
        Account accountTest = new Account();
        accountTest.FirstName = 'Test';
        accountTest.LastName = 'Contact';
        accountTest.EID__c = 'PIN';
        accountTest.EID__pc = 'PIN';
        accountTest.RecordTypeId = newRecord.Id;
        insert accountTest;

    Account acc = [SELECT Id,personcontactid from Account where Id=:accountTest.Id];
        Contact contactRec = [SELECT Id,LastName,FirstName,EID__c,AccountId from Contact where Id=:acc.personcontactid];
        ACETEmployerBrokerOtherInquiryController ACETEEBOIcontroller = new ACETEmployerBrokerOtherInquiryController();
        ACETEEBOIcontroller.selectedTopic = 'Producer Other Inquiry';
        ACETCallTopicsDataWrapper acetCallTopicDW = new ACETCallTopicsDataWrapper();
        acetCallTopicDW.saveAndClose();
    Test.stopTest();
    system.AssertNotEquals(acetCallTopicDW.caseObj.id,null);
    system.AssertEquals(acetCallTopicDW.caseObj.status,'Closed');
   }
    
  static testMethod void ACETEmployerBrokerOIControllerTestCancel()
  {  
    PageReference ACETEEBOIpage = Page.ACETEmployerBrokerOtherInquiry;
    Test.setCurrentPage(ACETEEBOIpage);
    Test.startTest();
        ACETEmployerBrokerOtherInquiryController ACETEEBOIcontroller = new ACETEmployerBrokerOtherInquiryController();
        ACETCaseActionsController employerBrokercancel= new ACETCaseActionsController(); 
        employerBrokercancel.RedirectToPage='ACETOriginatingPageServiceRenewal';  
        pageReference pageRef = employerBrokercancel.cancel();
        PageReference expectedPage  = new PageReference('/apex/ACETOriginatingPageServiceRenewal');
    Test.stopTest();
    System.assertEquals(expectedPage.getUrl(), pageRef.getUrl());
  }
}