@isTest
public class ACETOffcycleChangesControllerTest{
    public static testmethod void ACETOffCyclePage() {  
            PageReference ACETOffCycle = Page.ACETOffcycleChanges;
            Interaction__c interactionId = TestDataFactory.createInteraction();
      RecordType newRecord = [SELECT Id FROM RecordType WHERE Name = 'Person Account' and SObjectType = 'Account'];
          
          Account accountTest = new Account();
          accountTest.FirstName = 'Test';
          accountTest.LastName = 'Contact';
          accountTest.EID__c = 'PIN';
          accountTest.EID__pc = 'PIN';
          accountTest.RecordTypeId = newRecord.Id;
          insert accountTest;
  
      Account acc = [SELECT Id,personcontactid from Account where Id=:accountTest.Id];
          Contact cont = [SELECT Id,LastName,FirstName,EID__c,AccountId from Contact where Id=:acc.personcontactid];            ACETOffCycle.getParameters().put('InteractionId', InteractionId.Id);
	    ACETOffCycle.getParameters().put('InteractionId', InteractionId.Id);
            ACETOffCycle.getParameters().put('contactId',cont.Id);
            ACETOffCycle.getParameters().put('callTopic','OffCycle');            
            Test.setCurrentPage(ACETOffCycle);  
            Apexpages.StandardController ACETOffCtrl = new Apexpages.standardController(InteractionId);           
            ACETOffcycleChangesController ACETOffCycleContr = new ACETOffcycleChangesController();
            ACETOffCycleContr.interactionId = interactionId.Id;
            ACETOffCycleContr.contactid = cont.Id;
            ACETOffCycleContr.Subject = cont; 
     }   
}