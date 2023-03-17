@isTest
private class ACETCallTopicSaveCloseControllerTest{

private static testMethod void testMethodACETCallTopicSaveCloseController1(){
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
        mapTestCaseDetails.put('Topic__c', 'View Consumer Dashboard');
        mapTestCaseDetails.put('New_Closed_Reason__c','Balance Billing');
        mapTestCaseDetails.put('createCloseReason','blockedCallTopic');
        Case TestCase = ACETTestDataUtility.CreateTestCase(mapTestCaseDetails); 
        insert TestCase;
        Test.startTest();
        PageReference pageRef = new Pagereference('apex/ECM_AutoRouteCase');
        pageRef.getParameters().put('caseId',TestCase.id);
        Test.setCurrentPage(pageRef);
        ACETCallTopicSaveCloseController ATSCC = new ACETCallTopicSaveCloseController();
        ATSCC.save();
        ATSCC.RemoveNone();
         Test.stopTest();
  }
  private static testMethod void testMethodACETCallTopicSaveCloseController2(){
  
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
        mapTestCaseDetails.put('Topic__c', 'Create Authorization');
        mapTestCaseDetails.put('New_Closed_Reason__c','System Unavailable');
        Case TestCase = ACETTestDataUtility.CreateTestCase(mapTestCaseDetails); 
        insert TestCase;
        Test.startTest();
        PageReference pageRef = new Pagereference('apex/ECM_AutoRouteCase');
        pageRef.getParameters().put('caseId',TestCase.id);
        Test.setCurrentPage(pageRef);
        ACETCallTopicSaveCloseController ATSCC = new ACETCallTopicSaveCloseController();
        ATSCC.save();
        ATSCC.RemoveNone();
        ACETCallTopicsDataWrapper ACTDW = new ACETCallTopicsDataWrapper();
        ATSCC.caseData = ACTDW ;
         Test.stopTest();
  }
   private static testMethod void testMethodACETCallTopicsPicklistUtility1(){
       ACETCallTopicsPicklistUtility ACTPU = new ACETCallTopicsPicklistUtility();
      // String test='Communications,Consumer Accounts,Coordination of Benefits,Member Other Inquiry,ID Card Request,Pharmacy Inquiry,Plan Benefits,Provider Lookup';
     // string test='Call_Topic__c';
       string test='Provider Lookup';
       String pagename='ACETProviderLookUpDetails';
       ACETCallTopicsPicklistUtility.getTTSFilter(test);
       ACETCallTopicsPicklistUtility.getCallTopics(pagename);
       ACETCallTopicsPicklistUtility.getCallTopics(pagename,'Test');
       ACETCallTopicsPicklistUtility.getCallTopicOptions(pagename);
       ACETCallTopicsPicklistUtility.getCallTopicOptions(pagename,'Provider');
       
       
   }
   Private static testMethod void ACETStateControllerTestMethod1(){
        ACETStateController ACETSC = new ACETStateController();
        Test.startTest();
        ACETSC.state='ST'; 
        ACETSC.getStateOptions();   
        Test.stopTest();
    }
    private static testMethod void ACETWebserviceHelperTestMethod1(){
        string date1 ='22/11/1983';
        string date2='1984/02/10';
        integer error1=500;
        Test.startTest();
        ACETWebserviceHelper.formatDatetimeFromDashToSlash(date1);
        ACETWebserviceHelper.getErrorMessageFromCode(error1);
        ACETWebserviceHelper.formatToYYYYMMDD(date2);
        Test.stopTest();
    }
    private static testMethod void ACETWebserviceHelperTestMethod2(){
        string date1 ='2017-11-11:12T12T44T56';
        string date2=' / / ';
        integer error1=200;
        Test.startTest();
        ACETWebserviceHelper.formatDatetimeFromDashToSlash(date1);
        ACETWebserviceHelper.getErrorMessageFromCode(error1);
        ACETWebserviceHelper.formatToYYYYMMDD(date2);
        Test.stopTest();
    }

}