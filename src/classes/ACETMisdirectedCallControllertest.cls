@isTest
private class ACETMisdirectedCallControllertest{
    
    static testMethod void   ACETMisdirectedCalltestmethod() {

            Interaction__c inte = TestDataFactory.createInteraction();
        RecordType newRecord = [SELECT Id FROM RecordType WHERE Name = 'Person Account' and SObjectType = 'Account'];
        
          Account accountTest = new Account();
          accountTest.FirstName = 'Test';
          accountTest.LastName = 'Contact';
          accountTest.EID__c = 'PIN';
          accountTest.EID__pc = 'PIN';
          accountTest.RecordTypeId = newRecord.Id;
          insert accountTest;

            Map<String, String> mapTestCaseDetails = new Map<String, String>();
            //mapTestCaseDetails.put('AccountId', accountObj.Id);
            mapTestCaseDetails.put('ContactId', inte.Originator__c);
            mapTestCaseDetails.put('Interaction__c', inte.Id);
            mapTestCaseDetails.put('Status', 'Canceled');
            mapTestCaseDetails.put('Origin', 'Phone');
            mapTestCaseDetails.put('Topic__c', 'View Consumer Dashboard');
            Case TestCase = ACETTestDataUtility.CreateTestCase(mapTestCaseDetails); 
           
            Test.startTest();
            insert TestCase;
            Pagereference ACETMisdirectedCallpage = page.ACETMisdirectedCall;
            ACETMisdirectedCallpage.getparameters().put('currentCaseId',TestCase.Id);
            ACETMisdirectedCallpage.getparameters().put('errMsg','ACETMemberOffshoreError');
            ACETMisdirectedCallpage.getparameters().put('SRK','testkey');
            ACETMisdirectedCallpage.getparameters().put('defaultVal','Other');
            ACETMisdirectedCallpage.getparameters().put('misdirectReason','true');
            Test.setCurrentPage(ACETMisdirectedCallpage);
            
            ACETMisdirectedCallController misdirectCont= new ACETMisdirectedCallController(); 
            misdirectCont.checkMisdirectCase();
            misdirectCont.fetchProfile();
            misdirectCont.save();
            Test.stopTest();
   }
 }