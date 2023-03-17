@isTest(SeeAllData = false)
public with sharing class ACETViewCommissionControllerTest 
{
        static testMethod void ViewCommissionControllerTestsave()
        {  
          Test.startTest();         
          PageReference ACETViewCommission = Page.ACETViewCommissions;
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
          Interaction__c Interaction = ACETTestDataUtility.CreateInteraction(contactRec.Id,'Phone Call','Member','TestName');
          Interaction.Highlight_Panel_GroupInfo__c='{"UHCBS":"YES","ServiceTeam":"National Accounts","RiskManagement":"Audit","RenewalDate":"4/6/2018","RelationshipType":null,"RatingMethod":"","GroupStatus":"Active","groupSName":"37E9769CORG1","GroupName":"37E9769C - 37E9769CORG1","EffectiveStartDate":"4/6/2017"}';
          insert Interaction;
          ACETViewCommission.getParameters().put('InteractionId',Interaction.Id);
          Test.setCurrentPage(ACETViewCommission); 
              ACETViewCommissionController ViewCommissionController = new ACETViewCommissionController();
              ViewCommissionController.Interaction=Interaction;
              ACETCallTopicsDataWrapper acetCallTopicDW = new ACETCallTopicsDataWrapper();
              acetCallTopicDW.saveCase();
          Test.stopTest();
          system.AssertNotEquals(acetCallTopicDW.caseObj.id, null);
         }
   
        static testMethod void ViewCommissionControllersaveClose()
        { 
          PageReference ACETViewCommission = Page.ACETViewCommissions;
          Test.setCurrentPage(ACETViewCommission);
          Test.startTest();
      RecordType newRecord = [SELECT Id FROM RecordType WHERE Name = 'Person Account' and SObjectType = 'Account'];
          
          Account accountTest = new Account();
          accountTest.FirstName = 'Test';
          accountTest.LastName = 'Contact';
          accountTest.EID__c = 'PIN';
          accountTest.EID__pc = 'PIN';
          accountTest.RecordTypeId = newRecord.Id;
          insert accountTest;
              
              ACETViewCommissionController ViewCommissionController = new ACETViewCommissionController();
              ACETCallTopicsDataWrapper acetCallTopicDW = new ACETCallTopicsDataWrapper();
              acetCallTopicDW.saveAndClose();
          Test.stopTest();
          system.AssertNotEquals(acetCallTopicDW.caseObj.id,null);
          system.AssertEquals(acetCallTopicDW.caseObj.status,'Closed');
         }
    
        static testMethod void DentalInquiryControllerTestCancel()
        {  
          PageReference ACETViewCommission = Page.ACETViewCommissions;
          Test.setCurrentPage(ACETViewCommission);
          Test.startTest();       
              ACETCaseActionsController viewcommissioncancel= new ACETCaseActionsController(); 
              viewcommissioncancel.RedirectToPage='ACETOriginatingPageServiceRenewal';  
              pageReference pageRef = viewcommissioncancel.cancel();
              PageReference expectedPage  = new PageReference('/apex/ACETOriginatingPageServiceRenewal');
              System.assertEquals(expectedPage.getUrl(), pageRef.getUrl());
          Test.stopTest();
          System.assertEquals(expectedPage.getUrl(), pageRef.getUrl());
        }    
        
        static testMethod void testSwivelToBASICS(){
          ACETOrgInstanceURLToOrgNameMap__c orgInstance = new ACETOrgInstanceURLToOrgNameMap__c();
          orgInstance = ACETTestDataUtility.createOrgInstanceToOrgNameData('testURL','dev');
          insert orgInstance ;
          
          ACETOrgNameToSwivelEndpointMap__c swivelEndPoint = new ACETOrgNameToSwivelEndpointMap__c();
          swivelEndPoint = ACETTestDataUtility.createORGNameToSwivelData('dev_BASICS','http://basics.uhc.com/basicscompmgmt/login.jsp');
          insert swivelEndPoint ;
          
          ACETUtility.GetOrgName();
          ACETUtility.GetSwivelEndpointByOrgName('dev','BASICS');
        }    
         
}