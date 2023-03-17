@isTest
private class ACETMemberOtherInquiryControllerTest{
    private static testMethod void unitTestMethodForMember(){
            PageReference ACETMemberOthers = Page.ACETMemberOtherInquiry;
            Interaction__c inte = TestDataFactory.createInteraction();
            RecordType newRecord = [SELECT Id FROM RecordType WHERE Name = 'Person Account' and SObjectType = 'Account'];
        
          Account accountTest = new Account();
          accountTest.FirstName = 'Test';
          accountTest.LastName = 'Contact';
          accountTest.EID__c = 'PIN';
          accountTest.EID__pc = 'PIN';
          accountTest.RecordTypeId = newRecord.Id;
          insert accountTest;
  
      Account acc = [SELECT Id,personcontactid from Account where Id=:accountTest.Id];
          Contact con = [SELECT Id,LastName,FirstName,EID__c,AccountId from Contact where Id=:acc.personcontactid];
            ACETMemberOthers.getParameters().put('InteractionId',inte.Id);
            ACETMemberOthers.getParameters().put('contactId',con.id);
            ACETMemberOthers.getParameters().put('sourceOriginator',con.id);
            ACETMemberOthers.getParameters().put('SRK', 'test');
            ACETMemberOthers.getParameters().put('additionalInfo',TestDataFactory.createACETHighlightsPanelAdditionalInfo());
            Test.setCurrentPage(ACETMemberOthers); 
            
            Test.startTest(); 
            ACETMemberOtherInquiryController acetMI = new ACETMemberOtherInquiryController();
            acetMI.wrapper.AdditionalInfo.GroupN='1234567-Test';
            acetMI.Topic='Member Other Inquiry';
            acetMI.isCancelCaseCreation=false;
            acetMI.surrogateKey='test';
            acetMI.routeCase();
            acetMI.wrapper.IsSystemUnavailable=true;
            acetMI.wrapper.Comments='Test';
            acetMI.wrapper.cancelReason='Created In Error';
            acetMI.wrapper.saveCase();
            Test.stopTest();
    }

}