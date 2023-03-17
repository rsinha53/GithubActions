@isTest
private class ACETProviderOtherInquiryControllerTest{
    private static testMethod void unitTestMethodForProvider(){
            PageReference ACETProviderOthers = Page.ACETProviderOtherInquiry;
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
            ACETProviderOthers.getParameters().put('InteractionId',inte.Id);
            ACETProviderOthers.getParameters().put('contactId',con.id);
            ACETProviderOthers.getParameters().put('sourceOriginator',con.id);
            ACETProviderOthers.getParameters().put('additionalInfo',TestDataFactory.createACETHighlightsPanelAdditionalInfo());
            Test.setCurrentPage(ACETProviderOthers);  

            Test.startTest();     
            ACETProviderOtherInquiryController acetPI = new ACETProviderOtherInquiryController();
            acetPI.Subject=con;
            acetPI.Interaction=inte;
            acetPI.init();
            acetPI.getTopics();
            acetPI.renderCancelCaseSection();
            acetPI.renderMisdirectCaseSection();
            system.debug('acetPI>>'+acetPI.wrapper);
            acetPI.wrapper.CaseRecordTypeLabel ='ECM';
            acetPI.wrapper.AdditionalInfo.GroupN='1234567-Test';
            acetPI.routeCase();
            acetPI.wrapper.IsSystemUnavailable=true;
            acetPI.wrapper.Comments='Test';
            acetPI.wrapper.cancelReason='Created In Error';
            acetPI.wrapper.createBlankCase();
            acetPI.wrapper.saveCase();
            Test.stopTest();
    }
}