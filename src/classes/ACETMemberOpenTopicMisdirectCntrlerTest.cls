@isTest()
private class ACETMemberOpenTopicMisdirectCntrlerTest {
   static testMethod void openTopicMisdirectTest() {
   
        Interaction__c inte = TestDataFactory.createInteraction();
        account accountObj = new account();
        accountObj.Name = 'Test account';
        insert accountObj;
        
        ACETHighlightsPanelAdditionalInfo AdditionalInfo = new ACETHighlightsPanelAdditionalInfo();
        AdditionalInfo.DOB = '12/27/2009';
        AdditionalInfo.SitusState = '12/27/2009';
        AdditionalInfo.EffectiveDate = '12/27/2009';
        AdditionalInfo.EndDate = '12/27/2009';
        AdditionalInfo.groupName  = 'Member Offshore';
        AdditionalInfo.Network    = 'Test';
        AdditionalInfo.OriginatorRelationship  = 'Test';
        AdditionalInfo.PolicyNumber  = 'UHC1234';
        AdditionalInfo.Product  = 'Product Test';
        AdditionalInfo.productType  = 'Care Service';
        AdditionalInfo.Relationship  = 'Primary';      
        
        ACETHighlightsPanelAdditionalInfo AdditionalInfo2 = null;    
        
        Map<String, String> mapTestCaseDetails = new Map<String, String>();
        //mapTestCaseDetails.put('AccountId', accountObj.Id);
        mapTestCaseDetails.put('ContactId', inte.Originator__c);
        mapTestCaseDetails.put('Interaction__c', inte.Id);
        mapTestCaseDetails.put('Status', 'Cancelled');
        mapTestCaseDetails.put('Origin', 'Phone');
        mapTestCaseDetails.put('Topic__c', 'Other Inquiry');
        Case TestCase = ACETTestDataUtility.CreateTestCase(mapTestCaseDetails); 
        insert TestCase;
        System.assertEquals(TestCase.Interaction__c, inte.Id);
         String case1 = JSON.serialize(TestCase); 
        
        Map<String, String> mapTestCaseDetails2 = new Map<String, String>();
        //mapTestCaseDetails.put('AccountId', accountObj.Id);
        mapTestCaseDetails2.put('ContactId', inte.Originator__c);
        mapTestCaseDetails2.put('Interaction__c', inte.Id);
        mapTestCaseDetails2.put('Status', 'Cancelled');
        mapTestCaseDetails2.put('Origin', 'Phone');
        mapTestCaseDetails2.put('Topic__c', 'Other Inquiry');
        Case TestCase2 = ACETTestDataUtility.CreateTestCase(mapTestCaseDetails2); 
        insert TestCase2;  
        String case2 = JSON.serialize(TestCase2);      
        Test.startTest();
         PageReference pageRef = new Pagereference('apex/ACETMemberOpenTopicMisdirectComponent');
      //  pageRef.getParameters().put('caseId',TestCase.id);
        Test.setCurrentPage(pageRef);

        ACETMemberOpenTopicMisdirectController misdirect = new ACETMemberOpenTopicMisdirectController();
        misdirect.additionalInfoWrapper = AdditionalInfo;
        misdirect.createCase();
        ACETMemberOpenTopicMisdirectController.createCaseRA(case1,case2);    
        
        ACETMemberOpenTopicMisdirectController misdirect2 = new ACETMemberOpenTopicMisdirectController();
        misdirect2.additionalInfoWrapper = AdditionalInfo2;
        misdirect2.createCase();
        //ACETMemberOpenTopicMisdirectController.createCaseRA(case1,case2);           
        Test.stopTest();
   }
   
   static testMethod void openTopicMisdirectExceptionTest() {
        Test.startTest();
        PageReference pageRef = new Pagereference('apex/ACETMemberOpenTopicMisdirectComponent');
        Test.setCurrentPage(pageRef); 
        
        ACETMemberOpenTopicMisdirectController misdirect2 = new ACETMemberOpenTopicMisdirectController();
        
        misdirect2.createCase();
        //ACETMemberOpenTopicMisdirectController.createCaseRA(case1,case2);           
        Test.stopTest();       
   }   
}