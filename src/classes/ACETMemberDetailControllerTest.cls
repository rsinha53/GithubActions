@isTest(seealldata = false)
private class ACETMemberDetailControllerTest {
 /**  private static testMethod void testMemberFlowPositive() {
     //   setTestData('Member');
        List<ISL_Webservice_Config__c> ISLWebserviceCSList = new List<ISL_Webservice_Config__c>();
        ISLWebserviceCSList.add(TestDataFactory.CreateISLWebserviceCS('ISLConAccessToken', 'dfb379c2-06b7-46c4-8c6f-bbc390d1b854'));
        ISLWebserviceCSList.add(TestDataFactory.CreateISLWebserviceCS('OILHttpHeaderAccept', 'application/json;charset=UTF-8'));
        ISLWebserviceCSList.add(TestDataFactory.CreateISLWebserviceCS('OILHttpHeaderActor', 'ACET'));
        ISLWebserviceCSList.add(TestDataFactory.CreateISLWebserviceCS('OILHttpHeaderScope', 'read'));
        ISLWebserviceCSList.add(TestDataFactory.CreateISLWebserviceCS('ISLOAuthContentType', 'application/x-www-form-urlencoded'));
        ISLWebserviceCSList.add(TestDataFactory.CreateISLWebserviceCS('ISLOAuthGrantType', 'client_credentials'));
        ISLWebserviceCSList.add(TestDataFactory.CreateISLWebserviceCS('dev_ISLOAuthClientId', 'ISLStageConClientId'));
        ISLWebserviceCSList.add(TestDataFactory.CreateISLWebserviceCS('dev_ISLOAuthClientSecret', 'ISLStageConClientSecret'));
        ISLWebserviceCSList.add(TestDataFactory.CreateISLWebserviceCS('dev_ISLOAuthEndpoint', 'https://api-stg.optum.com:8443'));
        ISLWebserviceCSList.add(TestDataFactory.CreateISLWebserviceCS('dev_GetMemberEndpoint', '/GetIndividualService'));
        ISLWebserviceCSList.add(TestDataFactory.CreateISLWebserviceCS('dev_GetMembershipEndpoint', '/GetMemberShipService'));
        ISLWebserviceCSList.add(TestDataFactory.CreateISLWebserviceCS('dev_SearchMembershipEndpoint', '/FindMemberShipService'));
        ISLWebserviceCSList.add(TestDataFactory.CreateISLWebserviceCS('dev_GetFamilyMembersEndpoint', '/GetFamilyMemberService'));
        ISLWebserviceCSList.add(TestDataFactory.CreateISLWebserviceCS('dev_ISLOAuthTokenEndpoint', '/auth/oauth/v2/token'));
        ISLWebserviceCSList.add(TestDataFactory.CreateISLWebserviceCS('OILTimeout', '3000'));
        ISLWebserviceCSList.add(TestDataFactory.CreateISLWebserviceCS('SRKCounter', '1'));
        insert ISLWebserviceCSList;

    RecordType newRecord = [SELECT Id FROM RecordType WHERE Name = 'Person Account' and SObjectType = 'Account'];
        
        Account accountTest = new Account();
        accountTest.FirstName = 'Test Contact FN';
        accountTest.LastName = 'Test Contact LN';
        accountTest.EID__c = 'TestEID1';
        accountTest.EID__pc = 'TestEID1';
        accountTest.Tax_Id__c = 'TstTaxID1';
        accountTest.RecordTypeId = newRecord.Id;
        insert accountTest;
    Account acc = [SELECT Id,personcontactid from Account where Id=:accountTest.Id];
        Contact oContact = [SELECT Id,LastName,FirstName,EID__c,AccountId from Contact where Id=:acc.personcontactid];

        Interaction__c oInteraction = ACETTestDataUtility.CreateInteraction(oContact.Id, 'Phone', 'Member', oContact.LastName);
        insert oInteraction;

        ACETHighlightsPanelAdditionalInfo AdditionalInfo = new ACETHighlightsPanelAdditionalInfo();
        AdditionalInfo.PolicyNumber = 'TestPolicyNumber';

        setMockResponse();

  //      User memberAgent = TestDataFactory.getUser('ACET Member');
  //      System.runAs(memberAgent){
            // Call method to test.
            PageReference ACETPDPage = Page.ACETMemberDetail;
            ACETPDPage.getParameters().put('SRK', '12345');
          //  ACETPDPage.getParameters().put('Id', ProviderTestInteraction.Id);
            Test.setCurrentPageReference(ACETPDPage);
             ACETMemberDetailController memberDetailController = new ACETMemberDetailController();
         //    memberDetailController.CallWSonPageLoad();
             //// memberDetailController.init();
   //     }

        Continuation oContinuation = (Continuation)memberDetailController.CallWSOnPageLoad();
        Map<String, HttpRequest> HttpRequests = oContinuation.getRequests();
        system.assertEquals(2, HttpRequests.size());


        Object result = Test.invokeContinuationMethod(memberDetailController, oContinuation);


    }**/
    
    @testSetup
    static void dataSetup () {
        List<User> memberAgent = new List<User>();
        memberAgent.add(TestDataFactory.getUser('ACET Provider')); 
        memberAgent.add(TestDataFactory.getUser('ACET Member')); 
    }
    
    private static testMethod void testProviderFlowPositive() {
        setTestData('Provider');

        setMockResponse();
        List<user> memberAgent = [select id from user];

        System.runAs(memberAgent[0]){
             ACETMemberDetailController memberDetailController = new ACETMemberDetailController();
 /*            memberDetailController.originatorDOB = '01/01/1979';
             memberDetailController.isServiceError = True;
             memberDetailController.ThirdPartyActionFlag = True;
             memberDetailController.isMisdirectCaseCreation = False;
             memberDetailController.ProviderId = '6745755689';
             memberDetailController.GroupNumber = '8987876697';
             memberDetailController.EmployerName = 'GroupName';
             memberDetailController.Zip = '2300932';
             memberDetailController.State = 'CT';
             memberDetailController.phonenum = '6576575756';
             memberDetailController.alertNumber = 788876;
            memberDetailController.isAlertModal = False;
            memberDetailController.consumerDashURL = '';
            memberDetailController.UHGRestricted = False;
            memberDetailController.GlobalRestricted = False;
            memberDetailController.ErrorMessage= 'Test';
            memberDetailController.DefaultValue='Test';
            memberDetailController.renderMisdirectCaseSection();
         //   memberDetailController.changeOriginator();
            memberDetailController.btnHideWindowAlertWinodw();    */



             //// memberDetailController.init();
        }

    }
    private static testMethod void testChangeOriginator(){
        setTestData('Member');

        setMockResponse();
        List<user> memberAgent = [select id from user];
        system.debug('UserName >>>> '+memberAgent);
        RecordType newRecord = [SELECT Id FROM RecordType WHERE Name = 'Person Account' and SObjectType = 'Account'];
        
        Account accountTest = new Account();
        accountTest.FirstName = 'Test';
        accountTest.LastName = 'Contact';
        accountTest.EID__c = 'TestEID2';
        accountTest.EID__pc = 'TestEID2';
        accountTest.RecordTypeId = newRecord.Id;
        insert accountTest;
        Account acc = [SELECT Id,personcontactid from Account where Id=:accountTest.Id];
        Contact con = [SELECT Id,LastName,FirstName,EID__c,AccountId from Contact where Id=:acc.personcontactid];
        System.runAs(memberAgent[1]){
             ACETMemberDetailController memberDetailController = new ACETMemberDetailController();
             memberDetailController.Originator = con.Id;
        //    memberDetailController.changeOriginator();
        }
    }
    private static testMethod void testToggleShowCoverages(){
        setTestData('Member');

        setMockResponse();
        List<user> memberAgent = [select id from user];
        System.runAs(memberAgent[1]){
             ACETMemberDetailController memberDetailController = new ACETMemberDetailController();
             // // memberDetailController.init();
             //memberDetailController.toggleShowCoverages();

        }
    }
    private static testMethod void testSelectPreferredCoverage(){
        setTestData('Member');

        setMockResponse();
        List<user> memberAgent = [select id from user];
        System.runAs(memberAgent[1]){
            Test.startTest();
             ACETMemberDetailController memberDetailController = new ACETMemberDetailController();
            // // memberDetailController.init();
             //memberDetailController.toggleShowCoverages();
             if (memberDetailController.Coverages != null && memberDetailController.Coverages.size()>0 )
             memberDetailController.ProferredCoverageGUID = memberDetailController.Coverages[0].GUID;
      //       memberDetailController.selectPreferredCoverage();
            Test.stopTest();
        }

    }
    /* US659454 Removing test methods
    private static testMethod void testCheckrestrictedPolicy1(){
        setTestData('Member');

        setMockResponse();
        User memberAgent = TestDataFactory.getUser('ACET Member');
        String pnumber = insertRestrictedPolicy();
        System.runAs(memberAgent){
            Test.startTest();
             ACETMemberDetailController memberDetailController = new ACETMemberDetailController();
            // // memberDetailController.init();
             memberDetailController.toggleShowCoverages();
             if (memberDetailController.Coverages != null && memberDetailController.Coverages.size()>0 )
             memberDetailController.ProferredCoverageGUID = memberDetailController.Coverages[0].GUID;
             memberDetailController.UserGroupName = 'Member Offshore';
             memberDetailController.selectPreferredCoverage();
            Test.stopTest();
        }

    }

    private static testMethod void testCheckrestrictedPolicy2(){
        setTestData('Member');

        setMockResponse();
        User memberAgent = TestDataFactory.getUser('ACET Member');
        String pnumber = insertRestrictedPolicy();
        System.runAs(memberAgent){
            Test.startTest();
             ACETMemberDetailController memberDetailController = new ACETMemberDetailController();
           //  // memberDetailController.init();
             memberDetailController.toggleShowCoverages();
             if (memberDetailController.Coverages != null && memberDetailController.Coverages.size()>0 )
             memberDetailController.ProferredCoverageGUID = memberDetailController.Coverages[0].GUID;
             memberDetailController.UserGroupName = 'Provider Onshore';
             memberDetailController.selectPreferredCoverage();
            Test.stopTest();
        }

    }
    private static testMethod void testCheckrestrictedPolicy3(){
        setTestData('Member');

        setMockResponse();
        User memberAgent = TestDataFactory.getUser('ACET Member');
        String pnumber = insertRestrictedPolicy();
        System.runAs(memberAgent){
            Test.startTest();
             ACETMemberDetailController memberDetailController = new ACETMemberDetailController();
          //   // memberDetailController.init();
             memberDetailController.toggleShowCoverages();
             if (memberDetailController.Coverages != null && memberDetailController.Coverages.size()>0 )
             memberDetailController.ProferredCoverageGUID = memberDetailController.Coverages[0].GUID;
             memberDetailController.UserGroupName = 'UHG Provider Services';
             memberDetailController.selectPreferredCoverage();
            Test.stopTest();
        }

    }
    */ // US659454
     private static testMethod void testCallTopicOptionForMember() {

        setTestData('Member');

        setMockResponse();
        List<user> memberAgent = [select id from user];
        System.runAs(memberAgent[1]){
             ACETMemberDetailController memberDetailController = new ACETMemberDetailController();
           //  // memberDetailController.init();
           //  memberDetailController.getCallTopicOptions();
         }
        }
     private static testMethod void testCallTopicOptionForProvider() {
        setTestData('Provider');
        setMockResponse();

        List<user> memberAgent = [select id from user];
        System.runAs(memberAgent[0]){
             ACETMemberDetailController memberDetailController = new ACETMemberDetailController();
           //  // memberDetailController.init();
          //   memberDetailController.getCallTopicOptions();
         }
        }
     private static testMethod void testGetCaseHistory() {
        setTestData('Member');
        setMockResponse();

        List<user> memberAgent = [select id from user];
        System.runAs(memberAgent[1]){
             ACETMemberDetailController memberDetailController = new ACETMemberDetailController();
           //  // memberDetailController.init();
          //   memberDetailController.getCaseHistory();
         }
        }

     private static testMethod void testWrapInteraction() {
        setTestData('Provider');
        setMockResponse();
        Case caseObj = new Case();
        caseObj.Topic__c = 'Consumer Accounts';
        caseObj.New_Closed_Reason__c = 'Inquiry Resolved';
        caseObj.Comments__c = 'test';
        caseObj.isComplete__c = false;
        caseObj.Interaction__c = TestdataFactory.createInteraction().id;
        system.debug('what is this :: '+caseObj.Interaction__c);
        insert caseObj;



           /*  ACETMemberDetailController memberDetailController = new ACETMemberDetailController();

              memberDetailController.init();
             ApexPages.currentPage().getParameters().put('interactionId',memberDetailController.Interaction.id);
             memberdetailController.wrapper = new ACETCallTopicsDataWrapper();
             memberdetailController.wrapper.saveCase();
             ACETCaseActionsController caseCon = new ACETCaseActionsController();
             caseCon.callTopicDataWrapper = memberdetailController.wrapper;
             caseCon.CallTopic = 'Enroll Subscriber';
             caseCon.InteractionId = caseObj.Interaction__c;
             caseCon.wrapInteraction();
             caseCon.getIsComponentVisible();
             caseCon.cancel(); */

        }
     private static testMethod void testWrapperSaveAndClose() {
        setTestData('Provider');
        setMockResponse();

        List<user> memberAgent = [select id from user];
        System.runAs(memberAgent[1]){
             ACETMemberDetailController memberDetailController = new ACETMemberDetailController();
             /* memberDetailController.init();
             ApexPages.currentPage().getParameters().put('interactionId',memberDetailController.Interaction.id);
             memberdetailController.wrapper = new ACETCallTopicsDataWrapper();
             memberdetailController.wrapper.saveAndClose(); */
         }
        }
     private static testMethod void testWrapperSaveCasereturn() {
        setTestData('Provider');
        setMockResponse();

        List<user> memberAgent = [select id from user];
        System.runAs(memberAgent[1]){
             ACETMemberDetailController memberDetailController = new ACETMemberDetailController();
           /*   memberDetailController.init();
             ApexPages.currentPage().getParameters().put('interactionId',memberDetailController.Interaction.id);
             memberdetailController.wrapper = new ACETCallTopicsDataWrapper();
             memberdetailController.wrapper.saveCaseAndReturn(); */
         }
        }
     private static testMethod void testWrapperCreateCase() {
        setTestData('Provider');
        setMockResponse();

        List<user> memberAgent = [select id from user];
        System.runAs(memberAgent[1]){
             ACETMemberDetailController memberDetailController = new ACETMemberDetailController();
            /*  memberDetailController.init();
             ApexPages.currentPage().getParameters().put('interactionId',memberDetailController.Interaction.id);
             memberdetailController.wrapper = new ACETCallTopicsDataWrapper();
             memberdetailController.wrapper.createCase(); */
         }
        }
     private static testMethod void testWrapperCreateBlankCase() {
        setTestData('Provider');
        setMockResponse();
          MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', ACETTestDataUtility.GetFindAuthorizationResponseJSON() );
        OILResponse.TokenExpired = false;

        MockHttpCalloutResponseGenerator MockHttpRes = new MockHttpCalloutResponseGenerator(null, OILResponse);
        Test.setMock(HttpCalloutMock.class, MockHttpRes);

        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, MockHttpRes);
        List<user> memberAgent = [select id from user];
        System.runAs(memberAgent[1]){
             ACETMemberDetailController memberDetailController = new ACETMemberDetailController();
          /*    memberDetailController.init();
             ApexPages.currentPage().getParameters().put('interactionId',memberDetailController.Interaction.id);
             memberdetailController.wrapper = new ACETCallTopicsDataWrapper();
             memberdetailController.wrapper.createBlankCase(); */
         }
        }
     private static testMethod void testWrapperCancelCase() {
        setTestData('Provider');
        setMockResponse();

        List<user> memberAgent = [select id from user];
        System.runAs(memberAgent[1]){
             ACETMemberDetailController memberDetailController = new ACETMemberDetailController();
            /*  memberDetailController.init();
             ApexPages.currentPage().getParameters().put('interactionId',memberDetailController.Interaction.id);
             memberdetailController.wrapper = new ACETCallTopicsDataWrapper();
             memberdetailController.wrapper.cancelCase();
             memberDetailController.memberNotFound(); */
         }
        }
     private static testMethod void testWrapperMisdirectCase() {
        setTestData('Provider');
        setMockResponse();

        List<user> memberAgent = [select id from user];
        System.runAs(memberAgent[1]){
             ACETMemberDetailController memberDetailController = new ACETMemberDetailController();
             memberdetailController.memberEnrollment=true;
             memberdetailController.GroupNumber='1111111';
             memberdetailController.EmployerName='test';
             memberdetailController.Zip='53412';
             memberdetailController.State='CT';
           /*   memberDetailController.init();
             ApexPages.currentPage().getParameters().put('interactionId',memberDetailController.Interaction.id);
             memberdetailController.wrapper = new ACETCallTopicsDataWrapper();
             memberdetailController.wrapper.misdirect(); */
         }
        }

        private static void testWrapperMisdirectedReason(){
            ACETCallTopicsDataWrapper wrapper = new ACETCallTopicsDataWrapper();
            wrapper.getMisdirectedReasons();
        }
        private static void testWrapperCancelReason(){
            ACETCallTopicsDataWrapper wrapper = new ACETCallTopicsDataWrapper();
            wrapper.getCancelReasons();
        }
    private static void setMockResponse(){

        MultiStaticResourceCalloutMock multiMockResponse = new MultiStaticResourceCalloutMock();
        multiMockResponse.setStaticResource('https://api-stg.optum.com:8443/GetIndividualService', 'GetIndividualService');
        multiMockResponse.setStaticResource('https://api-stg.optum.com:8443/GetMemberShipService', 'GetMemberShipService');
        multiMockResponse.setStaticResource('https://api-stg.optum.com:8443/FindMemberShipService', 'FindMemberShipService');
        multiMockResponse.setStaticResource('https://api-stg.optum.com:8443/GetFamilyMemberService', 'GetFamilyMemberService');
        multiMockResponse.setStatusCode(200);
        multiMockResponse.setHeader('Content-Type', 'application/json');

        Test.setMock(HttpCalloutMock.class, multiMockResponse);

    }
    private static void setTestData(String flow){
        RecordType newRecord = [SELECT Id FROM RecordType WHERE Name = 'Person Account' and SObjectType = 'Account'];
        
        Account accountTest = new Account();
        accountTest.FirstName = 'Test';
        accountTest.LastName = 'Contact';
        accountTest.EID__c = 'TestEID1';
        accountTest.EID__pc = 'TestEID1';
        accountTest.RecordTypeId = newRecord.Id;
        insert accountTest;
        Account acc = [SELECT Id,personcontactid from Account where Id=:accountTest.Id];
        Contact con = [SELECT Id,LastName,FirstName,EID__c,AccountId from Contact where Id=:acc.personcontactid];
        
        if(flow == 'Provider'){
            Interaction__c inte = TestDataFactory.createInteraction();
            ApexPages.currentPage().getParameters().put('InteractionId',inte.id);
        }
        String vccdParams = '{"producerId":"123456789","idStr":"0012345","questionTypeCode":"MA","callerANI":"ANI123","TFN":"123456789"}';
        ApexPages.currentPage().getParameters().put('vccdParams',vccdParams);
        ApexPages.currentPage().getParameters().put('id',con.id);
        ApexPages.currentPage().getParameters().put('Id','73452645');
        ApexPages.currentPage().getParameters().put('firstName','Connie');
        ApexPages.currentPage().getParameters().put('lastName','Reed');
        ApexPages.currentPage().getParameters().put('sourceOriginator','FAX');

        List<ISL_Webservice_Config__c> ISLWebserviceCSList = new List<ISL_Webservice_Config__c>();
        ISLWebserviceCSList.add(TestDataFactory.CreateISLWebserviceCS('ISLConAccessToken', 'dfb379c2-06b7-46c4-8c6f-bbc390d1b854'));
        ISLWebserviceCSList.add(TestDataFactory.CreateISLWebserviceCS('OILHttpHeaderAccept', 'application/json;charset=UTF-8'));
        ISLWebserviceCSList.add(TestDataFactory.CreateISLWebserviceCS('OILHttpHeaderActor', 'ACET'));
        ISLWebserviceCSList.add(TestDataFactory.CreateISLWebserviceCS('OILHttpHeaderScope', 'read'));
        ISLWebserviceCSList.add(TestDataFactory.CreateISLWebserviceCS('ISLOAuthContentType', 'application/x-www-form-urlencoded'));
        ISLWebserviceCSList.add(TestDataFactory.CreateISLWebserviceCS('ISLOAuthGrantType', 'client_credentials'));
        ISLWebserviceCSList.add(TestDataFactory.CreateISLWebserviceCS('dev_ISLOAuthClientId', 'ISLStageConClientId'));
        ISLWebserviceCSList.add(TestDataFactory.CreateISLWebserviceCS('dev_ISLOAuthClientSecret', 'ISLStageConClientSecret'));
        ISLWebserviceCSList.add(TestDataFactory.CreateISLWebserviceCS('dev_ISLOAuthEndpoint', 'https://api-stg.optum.com:8443'));
        ISLWebserviceCSList.add(TestDataFactory.CreateISLWebserviceCS('dev_GetMemberEndpoint', '/GetIndividualService'));
        ISLWebserviceCSList.add(TestDataFactory.CreateISLWebserviceCS('dev_GetMembershipEndpoint', '/GetMemberShipService'));
        ISLWebserviceCSList.add(TestDataFactory.CreateISLWebserviceCS('dev_SearchMembershipEndpoint', '/FindMemberShipService'));
        ISLWebserviceCSList.add(TestDataFactory.CreateISLWebserviceCS('dev_GetFamilyMembersEndpoint', '/GetFamilyMemberService'));
        ISLWebserviceCSList.add(TestDataFactory.CreateISLWebserviceCS('dev_ISLOAuthTokenEndpoint', '/auth/oauth/v2/token'));
        ISLWebserviceCSList.add(TestDataFactory.CreateISLWebserviceCS('OILTimeout', '3000'));
        ISLWebserviceCSList.add(TestDataFactory.CreateISLWebserviceCS('SRKCounter', '1'));
        insert ISLWebserviceCSList;


        ACETOrgNameToSwivelEndpointMap__c durl = new ACETOrgNameToSwivelEndpointMap__c();
        durl.Swivel_Endpoint__c = 'test';
        durl.name = 'dev_ICUEConsumerDashboard';
        insert durl;


        ACETOrgNameToSwivelEndpointMap__c setting = new ACETOrgNameToSwivelEndpointMap__c();
        setting.Name = 'dev_ICUE';
        setting.Swivel_Endpoint__c = 'https://www.google.com';
        insert setting;



    }
    /* US659454
    private static String insertRestrictedPolicy(){
        Restricted_Policy_Number__c rpn = new Restricted_Policy_Number__c();
        rpn.Global_Restricted__c = true;
        rpn.UHG_Restricted__c = true;
        rpn.name = '000737';
        insert rpn;
        return rpn.id;
    }
    */ //US659454
    public static void insertCase(String intId, boolean completeCase){
        Case newCase = new Case();
        newcase.isComplete__c = completeCase;
        newcase.status = 'open';
        insert newCase;
    }
   static testMethod void memberDetailwrap(){
      ACETMemberDetail.statusLog stlog = new ACETMemberDetail.statusLog();
       stlog.StatusAction = true;
       stlog.EffectiveDate = system.today();
       stlog.ChangedOn = system.today();
       stlog.Changedby = '';
       stlog.Reason = '';
       stlog.OperationInitiatedby = '';

       ACETMemberDetail.FamilyMember FM = new ACETMemberDetail.FamilyMember();
       FM.effectiveDate = system.today();
       FM.termDate = system.today();
       FM.reinstDate = system.today();
       FM.CoverageStatus = '';

       ACETMemberDetail.COB c = new ACETMemberDetail.COB();
       c.medicareEntitlementType = '';
       c.EntitlementReason = '';
       c.PartAStart =system.today();
       c.PartBStart = system.today();
       c.PartDStart = system.today();
       c.PartAEnd = system.today();
       c.PartBEnd = system.today();
       c.PartDEnd = system.today();

       ACETMemberDetail.CoverageLine cl = new ACETMemberDetail.CoverageLine();
       cl.Network = '';
       cl.FundingArrangement = '';
       cl.PlanSitusState = '';


    }

    public static testMethod void testGetCustomerPurchaseJson(){
        ACETGetcustomerPurchaseJSON2apex Json = new ACETGetcustomerPurchaseJSON2apex();
       
        
    }
   /* public static testMethod void testGetCustomerPurchaseJson1(){
        ACETGetcustomerPurchaseJSON2apex.planCodes cp = new ACETGetcustomerPurchaseJSON2apex.planCodes();
      
        ACETGetcustomerPurchaseJSON2apex.packages pack = new ACETGetcustomerPurchaseJSON2apex.packages();
        pack.packageCode='';
        pack.packageOptionId='';
        pack.planCodes = cp;
        ACETGetcustomerPurchaseJSON2apex.customerPurchaseVersions cpv = new ACETGetcustomerPurchaseJSON2apex.customerPurchaseVersions();
        cpv.bookOfBusinessTypeCode='';
        cpv.bookOfBusinessTypeDescription='';
        cpv.brandingEntityName='';
        cpv.brandingEntityDescription='';
        cpv.carrierId='';
        cpv.carrierName='';
        cpv.contractOptionEffectiveDate='';
        cpv.contractOptionExpiryDate='';
        cpv.contractOptionExpiryDate='';
        cpv.customerPurchaseStatusDescription='';
        cpv.customerPurchaseVersionId='';
        cpv.exchangeTypeCode='';
        cpv.exchangeTypeDescription='';
        cpv.lineOfBusinessSegmentDescription='';
        cpv.lineOfBusinessSegmentId='';
        cpv.lineOfBusinessSegmentName='';
      //  cpv.packages.add(pack);
        cpv.timePeriodQualifier='';
        ACETGetcustomerPurchaseJSON2apex.customerPurchase cpList= new ACETGetcustomerPurchaseJSON2apex.customerPurchase();
        cpList.customerPurchaseIdentifier ='';
        cpList.groupNumber='';
        cpList.planOptionId='';
      //  cpList.customerPurchaseVersions.add(cpv); 
    }*/
}