@isTest(SeeAllData=false)
private class ACETEnrollMemberControllerTest{
    private static testMethod void unitTestMethodForEnrollment(){
        
        User thisUser = [Select Id From User Where Id =:UserInfo.getUserId()];
        User acetmember;
         System.runAs(thisUser){
             setTestData('EnrollMember');
         acetmember = TestDataFactory.getUser('ACET EB Agent'); 
         }
        System.runAs(acetmember){
            
            PageReference ACETEnrollSub = Page.ACETEnrollMember;
            Interaction__c interactionId = TestDataFactory.createInteraction();
            Contact cont = TestDataFactory.createContact();
            ACETEnrollSub.getParameters().put('InteractionId', InteractionId.Id);
            ACETEnrollSub.getParameters().put('SRK', 'test');
            ACETEnrollSub.getParameters().put('callTopic','Enroll Member');
            ACETEnrollSub.getParameters().put('rowToRemove','1');
            ACETEnrollSub.getParameters().put('groupId','1158478');
            Test.setCurrentPage(ACETEnrollSub);
            test.startTest(); 
                ACETEnrollMemberController enrolSubscriber = new ACETEnrollMemberController();
                ACETEnrollMemberController.WrapperEnrollList enrollList= new ACETEnrollMemberController.WrapperEnrollList();
                list<ACETEnrollMemberController.WrapperEnrollList> enrollListWrap= new list<ACETEnrollMemberController.WrapperEnrollList>();
                
                enrolSubscriber.comments = 'Test Comments';
                enrolSubscriber.subject = cont;
                enrolSubscriber.memberID = '0012345';
                
                enrollList.index = 0;
                enrollList.effectiveDate = '01/01/2018';
                enrollList.memberID = '123123' ;
                enrollList.isResolved = false;
                enrollListWrap.add(enrollList);
                enrolSubscriber.enrollList = enrollListWrap;
                
                enrolSubscriber.addNewRowToEnrollList();
                enrolSubscriber.removeRowFromEnrollList();

                
                ACETHighlightsPanelAdditionalInfo AdditionalInfo = new ACETHighlightsPanelAdditionalInfo();
                AdditionalInfo.DOB = '12/27/2009';
                AdditionalInfo.SitusState = '12/27/2009';
                AdditionalInfo.EffectiveDate = '12/27/2009';
                AdditionalInfo.EndDate = '12/27/2009';
                AdditionalInfo.groupName  = 'Test';
                AdditionalInfo.Network    = 'Test';
                AdditionalInfo.OriginatorRelationship  = 'Test';
                AdditionalInfo.PolicyNumber  = 'UHC1234';
                AdditionalInfo.Product  = 'Product Test';
                AdditionalInfo.productType  = 'Care Service';
                AdditionalInfo.Relationship  = 'Primary';
                string jsonString = '{"ACETHighlightsPanelAdditionalInfo":[{"DOB":"12/27/2009","SitusState":"2011-10-04T16:58:54.858Z"}]}';
                enrolSubscriber.AdditionalInfo = AdditionalInfo;
                enrolSubscriber.hpAdditionInfoStr = 'test';
                
                list<Alert__c> alerts = new list<Alert__c>();
                enrolSubscriber.lstMemAlert = alerts;
                
                ACETCallTopicsDataWrapper acetCallTopicDW = new ACETCallTopicsDataWrapper();
                acetCallTopicDW.saveCase();    
            test.stopTest();
            system.AssertNotEquals(acetCallTopicDW.caseObj.id,null);
        }
    }
    
    private static testMethod void unitTestMethodForEnrollSubscriber(){
         User thisUser = [Select Id From User Where Id =:UserInfo.getUserId()];
         User acetsubscriber;
         System.runAs(thisUser){
         setTestData('EnrollSubscriber');
         acetsubscriber = TestDataFactory.getUser('ACET EB Agent'); 
         }
        System.runAs(acetsubscriber){
            
            PageReference ACETEnrollSub = Page.ACETEnrollMember;
            Interaction__c interactionId = TestDataFactory.createInteraction();
            Contact cont = TestDataFactory.createContact();
            ACETEnrollSub.getParameters().put('InteractionId', InteractionId.Id);
            ACETEnrollSub.getParameters().put('SRK', 'test');
            ACETEnrollSub.getParameters().put('memberEnrollment','False');
            ACETEnrollSub.getParameters().put('callTopic','Enroll Subscriber');
            ACETEnrollSub.getParameters().put('rowToRemove','1');
            ACETEnrollSub.getParameters().put('groupId','0123456');
            ACETEnrollSub.getParameters().put('Id','0012345');
            Test.setCurrentPage(ACETEnrollSub);
            test.startTest(); 
                ACETEnrollMemberController enrolSubscriber = new ACETEnrollMemberController();
                ACETEnrollMemberController.WrapperEnrollList enrollList= new ACETEnrollMemberController.WrapperEnrollList();
                list<ACETEnrollMemberController.WrapperEnrollList> enrollListWrap= new list<ACETEnrollMemberController.WrapperEnrollList>();
                
                enrolSubscriber.comments = 'Test Comments';
                enrolSubscriber.subject = cont;
                enrolSubscriber.memberID = '0012345';
                enrolSubscriber.rowNum = 1;
                enrolSubscriber.isClikedAddRow = true;
                enrolSubscriber.ErrorMessage = 'test error';
                enrolSubscriber.isSubscriberEnrolled = true;
                
                enrollList.index = 0;
                enrollList.effectiveDate = '01/01/2018';
                enrollList.memberID = '123123' ;
                enrollList.isResolved = false;
                enrollListWrap.add(enrollList);
                enrolSubscriber.enrollList = enrollListWrap;
                
                enrolSubscriber.addNewRowToEnrollList();
                enrolSubscriber.removeRowFromEnrollList();
                
                ACETHighlightsPanelAdditionalInfo AdditionalInfo = new ACETHighlightsPanelAdditionalInfo();
                AdditionalInfo.DOB = '12/27/2009';
                AdditionalInfo.SitusState = '12/27/2009';
                AdditionalInfo.EffectiveDate = '12/27/2009';
                AdditionalInfo.EndDate = '12/27/2009';
                AdditionalInfo.groupName  = 'Test';
                AdditionalInfo.Network    = 'Test';
                AdditionalInfo.OriginatorRelationship  = 'Test';
                AdditionalInfo.PolicyNumber  = 'UHC1234';
                AdditionalInfo.Product  = 'Product Test';
                AdditionalInfo.productType  = 'Care Service';
                AdditionalInfo.Relationship  = 'Primary';
                string jsonString = '{"ACETHighlightsPanelAdditionalInfo":[{"DOB":"12/27/2009","SitusState":"2011-10-04T16:58:54.858Z"}]}';
                enrolSubscriber.AdditionalInfo = AdditionalInfo;
                enrolSubscriber.hpAdditionInfoStr = 'test';
                
                list<Alert__c> alerts = new list<Alert__c>();
                enrolSubscriber.lstMemAlert = alerts;
                
                ACETCallTopicsDataWrapper acetCallTopicDW = new ACETCallTopicsDataWrapper();
                acetCallTopicDW.saveCase();    
            test.stopTest();
            system.AssertNotEquals(acetCallTopicDW.caseObj.id,null);
        }
    }        
   
    private static void setTestData(String flow){

        Contact con = TestDataFactory.createContact();
        if(flow == 'EnrollMember'){
            Interaction__c inte = TestDataFactory.createInteraction();
            ApexPages.currentPage().getParameters().put('InteractionId',inte.id);
        }
    } 
}