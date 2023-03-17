@isTest(seeAllData=false)
public class ACETServiceRenewalControllerTest{
    static testMethod void saveCloseServiceRenewalCase(){
        Test.setCurrentPageReference(new PageReference('Page.serviceRenewal')); 
        System.currentPageReference().getParameters().put('callType','serviceRenewal');
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
          Contact cont = [SELECT Id,LastName,FirstName,EID__c,AccountId from Contact where Id=:acc.personcontactid];     

               ACETServiceRenewalController serviceRenewal= new ACETServiceRenewalController();   
               serviceRenewal.getServiceRenewalCallTypes();
               ACETCallTopicsDataWrapper acetCallTopicDW = new ACETCallTopicsDataWrapper();
               acetCallTopicDW.saveAndClose();
           Test.stopTest();
           system.AssertNotEquals(acetCallTopicDW.caseObj.id,null);
           system.AssertEquals(acetCallTopicDW.caseObj.status,'Closed');
    }
    
    static testMethod void saveServiceRenewalCase(){
        Test.setCurrentPageReference(new PageReference('Page.serviceRenewal')); 
        Interaction__c Interaction = TestDataFactory.createInteraction();
        Interaction.Highlight_Panel_GroupInfo__c='test';
        System.currentPageReference().getParameters().put('InteractionId',Interaction.Id);
        System.currentPageReference().getParameters().put('callType','serviceRenewal');
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
          Contact cont = [SELECT Id,LastName,FirstName,EID__c,AccountId from Contact where Id=:acc.personcontactid];
               ACETServiceRenewalController serviceRenewal= new ACETServiceRenewalController();   
               serviceRenewal.getServiceRenewalCallTypes();
               ACETCallTopicsDataWrapper acetCallTopicDW = new ACETCallTopicsDataWrapper();
               acetCallTopicDW.saveCase();
           Test.stopTest();
           system.AssertNotEquals(acetCallTopicDW.caseObj.id,null);
    }
    
    static testMethod void saveCloseCreateProposalCase(){
        Test.setCurrentPageReference(new PageReference('Page.serviceRenewal')); 
        System.currentPageReference().getParameters().put('callType','newBusiness');
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
          Contact cont = [SELECT Id,LastName,FirstName,EID__c,AccountId from Contact where Id=:acc.personcontactid];
               ACETServiceRenewalController serviceRenewal= new ACETServiceRenewalController();   
               serviceRenewal.getCreateProposalCallTypes();
               ACETCallTopicsDataWrapper acetCallTopicDW = new ACETCallTopicsDataWrapper();
               acetCallTopicDW.saveAndClose();
           Test.stopTest();
           system.AssertNotEquals(acetCallTopicDW.caseObj.id,null);
           system.AssertEquals(acetCallTopicDW.caseObj.status,'Closed');
    }
    
    static testMethod void saveCreateProposalCase(){
        Test.setCurrentPageReference(new PageReference('Page.serviceRenewal')); 
        System.currentPageReference().getParameters().put('callType','newBusiness');
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
          Contact cont = [SELECT Id,LastName,FirstName,EID__c,AccountId from Contact where Id=:acc.personcontactid];
               ACETServiceRenewalController serviceRenewal= new ACETServiceRenewalController();   
               serviceRenewal.getCreateProposalCallTypes();
               ACETCallTopicsDataWrapper acetCallTopicDW = new ACETCallTopicsDataWrapper();
               acetCallTopicDW.saveCase();
           Test.stopTest();
           system.AssertNotEquals(acetCallTopicDW.caseObj.id,null);
    }
    
    static testMethod void cancel(){
        Test.setCurrentPageReference(new PageReference('Page.serviceRenewal')); 
        System.currentPageReference().getParameters().put('callType','serviceRenewal');
        Test.startTest();
            ACETCaseActionsController serviceRenewalcancel= new ACETCaseActionsController();             
            pageReference pageRef = serviceRenewalcancel.cancel();          
        Test.stopTest();
    }
}