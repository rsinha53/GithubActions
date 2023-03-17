@isTest()
private class ACETCancelCaseControllerTest {
   static testMethod void ACETCancelCaseControllerTest1() {
    
        Interaction__c inte = TestDataFactory.createInteraction();
        account accountObj = new account();
        accountObj.Name = 'Test account';
        insert accountObj;
        
        Map<String, String> mapTestCaseDetails = new Map<String, String>();
        //mapTestCaseDetails.put('AccountId', accountObj.Id);
        mapTestCaseDetails.put('ContactId', inte.Originator__c);
        mapTestCaseDetails.put('Interaction__c', inte.Id);
        mapTestCaseDetails.put('Status', 'Cancelled');
        mapTestCaseDetails.put('Origin', 'Phone');
        mapTestCaseDetails.put('Topic__c', 'Other Inquiry');
        Case TestCase = ACETTestDataUtility.CreateTestCase(mapTestCaseDetails); 
        insert TestCase;
        Test.startTest();
         PageReference pageRef = new Pagereference('apex/ECM_AutoRouteCase');
        pageRef.getParameters().put('caseId',TestCase.id);
        Test.setCurrentPage(pageRef);
        
        ACETCancelCaseController acetCan = new ACETCancelCaseController();
           System.assertEquals(TestCase.id,acetCan.CaseObj.id);
           acetCan.save();
           System.assertEquals('Canceled',acetCan.CaseObj.Status);
            
        Test.stopTest();
        }
   }