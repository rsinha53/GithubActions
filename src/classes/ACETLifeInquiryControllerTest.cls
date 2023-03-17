@isTest(seeAllData = false)
public  class ACETLifeInquiryControllerTest 
{   
  static testMethod void lifeInquiryTestsave()
  {  
    PageReference ACETLifeInquiry = Page.ACETLifeInquiry;
    Interaction__c interaction = TestDataFactory.createInteraction();
    Contact cont = TestDataFactory.createContact();
    ACETLifeInquiry.getParameters().put('interactionId', interaction.Id);
    ACETLifeInquiry.getParameters().put('contactId', cont.Id);
    ACETLifeInquiry.getParameters().put('additionalInfo', TestDataFactory.createACETHighlightsPanelAdditionalInfo());
    Test.setCurrentPage(ACETLifeInquiry);
    Test.startTest();
        Account accountRec = ACETTestDataUtility.createAccount('test Account');
        insert accountRec;
        
        Contact contactRec = ACETTestDataUtility.createContact(accountRec.Id,'Test','Contact');
        insert contactRec;
        
        ACETLifeInquiryController  lifeInquirycontroller = new ACETLifeInquiryController();
        lifeInquirycontroller.comments='test';
        ACETCallTopicsDataWrapper acetCallTopicDW = new ACETCallTopicsDataWrapper();
        acetCallTopicDW.saveCase();
    Test.stopTest();
    system.AssertNotEquals(acetCallTopicDW.caseObj.id,null);
   }
   
  static testMethod void lifeInquiryTestsaveClose()
  {  
    PageReference ACETLifeInquiry = Page.ACETLifeInquiry;
    Test.setCurrentPage(ACETLifeInquiry);
    Test.startTest();
        Account accountRec = ACETTestDataUtility.createAccount('test Account');
        insert accountRec;
        
        Contact contactRec = ACETTestDataUtility.createContact(accountRec.Id,'Test','Contact');
        insert contactRec;
        
        ACETLifeInquiryController  lifeInquirycontroller = new ACETLifeInquiryController();
        ACETCallTopicsDataWrapper acetCallTopicDW = new ACETCallTopicsDataWrapper();
        acetCallTopicDW.saveAndClose();
    Test.stopTest();
    system.AssertNotEquals(acetCallTopicDW.caseObj.id,null);
    system.AssertEquals(acetCallTopicDW.caseObj.status,'Closed');
   }
    
  static testMethod void lifeInquiryTestCancel()
  {  
    PageReference ACETLifeInquiry = Page.ACETLifeInquiry;
    Test.setCurrentPage(ACETLifeInquiry);
    Test.startTest();       
        ACETCaseActionsController employerBrokercancel= new ACETCaseActionsController(); 
        pageReference pageRef = employerBrokercancel.cancel();       
    Test.stopTest();
   
  }
    
  static testMethod void testSwivelToFACETS(){
      ACETOrgInstanceURLToOrgNameMap__c orgInstance = new ACETOrgInstanceURLToOrgNameMap__c();
      orgInstance = ACETTestDataUtility.createOrgInstanceToOrgNameData('testURL','dev');
      insert orgInstance ;
      
      ACETOrgNameToSwivelEndpointMap__c swivelEndPoint = new ACETOrgNameToSwivelEndpointMap__c();
      swivelEndPoint = ACETTestDataUtility.createORGNameToSwivelData('dev_FACETS','https://custhspprod.tzghosting.net/vpn/index.html');
      insert swivelEndPoint ;
      
      ACETUtility.GetOrgName();
      ACETUtility.GetSwivelEndpointByOrgName('dev','FACETS');
  }
}