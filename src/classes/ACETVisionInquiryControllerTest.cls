@isTest(SeeAllData = false)
public with sharing class ACETVisionInquiryControllerTest 
{
        static testMethod void DentalInquiryControllerTestsave()
        {  
          PageReference ACETVisionInquiry = Page.ACETVisionInquiry;
          Test.setCurrentPage(ACETVisionInquiry );
          Interaction__c Interaction = TestDataFactory.createInteraction();
          Contact con=TestDataFactory.createContact();
          System.currentPageReference().getParameters().put('InteractionId',Interaction.Id);
          System.currentPageReference().getParameters().put('contactId',con.Id);
          
          Test.startTest();
              Account accountRec = ACETTestDataUtility.createAccount('test Account');
              insert accountRec;
              
              Contact contactRec = ACETTestDataUtility.createContact(accountRec.Id,'Test','Contact');
              insert contactRec;
              
              ACETVisionInquiryController  VisionInquiryController = new ACETVisionInquiryController();
              //VisionInquiryController.getVisionInquiryCallTypes();
              ACETCallTopicsDataWrapper acetCallTopicDW = new ACETCallTopicsDataWrapper();
              acetCallTopicDW.saveCase();
          Test.stopTest();
          system.AssertNotEquals(acetCallTopicDW.caseObj.id,null);
         }
   
        static testMethod void DentalInquiryControllerTestsaveClose()
        { 
          PageReference ACETVisionInquiry = Page.ACETVisionInquiry;
          Test.setCurrentPage(ACETVisionInquiry );
          Test.startTest();
              Account accountRec = ACETTestDataUtility.createAccount('test Account');
              insert accountRec;
              
              Contact contactRec = ACETTestDataUtility.createContact(accountRec.Id,'Test','Contact');
              insert contactRec;
              
              ACETVisionInquiryController  VisionInquiryController = new ACETVisionInquiryController();
              //VisionInquiryController.getVisionInquiryCallTypes();
              ACETCallTopicsDataWrapper acetCallTopicDW = new ACETCallTopicsDataWrapper();
              acetCallTopicDW.saveAndClose();
          Test.stopTest();
          system.AssertNotEquals(acetCallTopicDW.caseObj.id,null);
          system.AssertEquals(acetCallTopicDW.caseObj.status,'Closed');
         }
    
        static testMethod void DentalInquiryControllerTestCancel()
        {  
          PageReference ACETVisionInquiry = Page.ACETVisionInquiry;
          Test.setCurrentPage(ACETVisionInquiry );
          Test.startTest();       
              ACETCaseActionsController employerBrokercancel= new ACETCaseActionsController();               
              pageReference pageRef = employerBrokercancel.cancel();             
          Test.stopTest();          
        }
        
           static testMethod void testSwivelToISET()
           {
              ACETOrgInstanceURLToOrgNameMap__c orgInstance = new ACETOrgInstanceURLToOrgNameMap__c();
              orgInstance = ACETTestDataUtility.createOrgInstanceToOrgNameData('testURL','dev');
              insert orgInstance ;
              
              ACETOrgNameToSwivelEndpointMap__c swivelEndPoint = new ACETOrgNameToSwivelEndpointMap__c();
              swivelEndPoint = ACETTestDataUtility.createORGNameToSwivelData('dev_ISET','https://iset.uhc.com/');
              insert swivelEndPoint ;
              
              ACETUtility.GetOrgName();
              ACETUtility.GetSwivelEndpointByOrgName('dev','ISET');
           }
    
}