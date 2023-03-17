@isTest(seeAllData = false)
public  class ACETUpdateGroupInformationControllerTest 
{   
  static testMethod void UpdateGroupInformationTestsave()
  {  
    PageReference ACETUpdateGroupInformation = Page.ACETUpdateGroupInformation;
    Test.setCurrentPage(ACETUpdateGroupInformation );
    Interaction__c Interaction = TestDataFactory.createInteraction();
    System.currentPageReference().getParameters().put('InteractionId',Interaction.Id);
    System.currentPageReference().getParameters().put('additionalInfo',TestDataFactory.createACETHighlightsPanelAdditionalInfo());
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
        
        ACETUpdateGroupInformationController Updategroupinformationcontroller = new ACETUpdateGroupInformationController();
        Updategroupinformationcontroller.Subject=contactRec;
        Updategroupinformationcontroller.comments='test';
        Updategroupinformationcontroller.groupId='123456789';
        Updategroupinformationcontroller.groupName='testgroup';
        Updategroupinformationcontroller.authorizedContact='testcontact';
        ACETCallTopicsDataWrapper acetCallTopicDW = new ACETCallTopicsDataWrapper();
        acetCallTopicDW.saveCase();
    Test.stopTest();
    system.AssertNotEquals(acetCallTopicDW.caseObj.id,null);
   }
   
  static testMethod void UpdateGroupInformationTestsaveClose()
  {  
    PageReference ACETUpdateGroupInformation = Page.ACETUpdateGroupInformation;
    Test.setCurrentPage(ACETUpdateGroupInformation );
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
        
        ACETUpdateGroupInformationController Updategroupinformationcontroller = new ACETUpdateGroupInformationController();
        ACETCallTopicsDataWrapper acetCallTopicDW = new ACETCallTopicsDataWrapper();
        acetCallTopicDW.saveAndClose();
    Test.stopTest();
    system.AssertNotEquals(acetCallTopicDW.caseObj.id,null);
    system.AssertEquals(acetCallTopicDW.caseObj.status,'Closed');
   }
    
  static testMethod void updateGroupInformationTestCancel()
  {       
    PageReference ACETUpdateGroupInformation = Page.ACETUpdateGroupInformation;
    Test.setCurrentPage(ACETUpdateGroupInformation );
    Test.startTest();       
        ACETCaseActionsController employerBrokercancel= new ACETCaseActionsController();       
        pageReference pageRef = employerBrokercancel.cancel(); 
    Test.stopTest();
   
  }
    
  static testMethod void testSwivelToCIRRUS(){
      ACETOrgInstanceURLToOrgNameMap__c orgInstance = new ACETOrgInstanceURLToOrgNameMap__c();
      orgInstance = ACETTestDataUtility.createOrgInstanceToOrgNameData('testURL','dev');
      insert orgInstance ;
      
      ACETOrgNameToSwivelEndpointMap__c swivelEndPoint = new ACETOrgNameToSwivelEndpointMap__c();
      swivelEndPoint = ACETTestDataUtility.createORGNameToSwivelData('dev_CIRRUS','https://cirrus-dev.optum.com/index.html');
      insert swivelEndPoint ;
      
      ACETUtility.GetOrgName();
      ACETUtility.GetSwivelEndpointByOrgName('dev','CIRRUS');
      
  }
}