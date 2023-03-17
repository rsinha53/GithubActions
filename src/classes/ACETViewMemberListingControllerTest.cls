@isTest
public class ACETViewMemberListingControllerTest {
     public static testMethod void ACETSendMemberlistEmailtestmethod() {
             
         Test.startTest();
          List < String > listbundles = new list<string>();
         listbundles.add('ids');
          List < String > listpops = new list<string>();
         listpops.add('pop');
          List < ACETViewMemberListingResultsWrapper > finalListadded = new  List < ACETViewMemberListingResultsWrapper > ();
         ACETGetMemberListingResults mr = new ACETGetMemberListingResults('12/01/2013','request','statusPDF','groupId','bundleID',listbundles,'All', listpops,'Y',2,'hasPop','groupName','contractId',2,finalListadded,'contenttype');
         ID jobIDone = System.enqueueJob(mr);
         ACETSendMemberlistEmail seone = new ACETSendMemberlistEmail('hasPop','groupName','groupId','contractId','request','statusPDF','bundleID','inquiryDate',1234,'continuationType','selectedPopulation','attachid','contenttype');
        ID jobID = System.enqueueJob(seone);
        Test.stopTest();  
         
     }
    public static testMethod void memberListingSaveMethod() {
        PageReference ACETMemberListing = Page.ACETViewMemberListing;
        String JSONStr = '{"UHCBS":"","GroupN":"Test Group Name","GroupStatus":"Active","ServiceTeam":"NY Large","EffectiveStartDate":"3/1/2016","RiskManagement":"Rating Method","RatingMethod":"","RenewalDate":"3/1/2016","RelationshipType":"Mother","groupSName":"Test GroupName"}';
        
        Contact cont = TestDataFactory.createContact();
        Interaction__c InteractionId = new Interaction__c();
        InteractionId.Originator__c = cont.id;
        InteractionId.Originator_Type__c = 'Member';
        InteractionId.Highlight_Panel_GroupInfo__c = JSONStr;
        insert InteractionId;
        ACETMemberListing.getParameters().put('InteractionId', InteractionId.Id);
        Test.setCurrentPage(ACETMemberListing);
        
        PageReference ACETMemberListingPDF = Page.ACETViewMemberListingPDF;
        ACETMemberListingPDF.getParameters().put('view', 'Subscriber');
        ACETMemberListingPDF.getParameters().put('status', 'All');
        ACETMemberListingPDF.getParameters().put('groupIdName', '123456-Test');
        ACETMemberListingPDF.getParameters().put('inqDate', '2017/04/03');
        ACETMemberListingPDF.getParameters().put('bundleId', '12345');
        ACETMemberListingPDF.getParameters().put('pageNo', '0');
        ACETMemberListingPDF.getParameters().put('pgSize', '20');
        ACETMemberListingPDF.getParameters().put('onshoreCode', '00');
        ACETMemberListingPDF.getParameters().put('InteractionId', InteractionId.Id);
        ACETMemberListingPDF.getParameters().put('GoToLink', 'false'); // added by kalyan
        ACETMemberListingPDF.getParameters().put('groupId', '123');// added by kalyan
        Test.setCurrentPage(ACETMemberListingPDF);
        
        Test.startTest();
        
        ACETViewMemberListingController MemberListContr = new ACETViewMemberListingController();
  
        MemberListContr.MemberId = '122121212'; 
        MemberListContr.FirstName = 'test';
        MemberListContr.GoToLink = false;
        MemberListContr.GroupId = '122121212';
        MemberListContr.view = 'All Members';
        MemberListContr.status = 'Active';
        MemberListContr.Subject = cont;
        MemberListContr.selectedStatus='Active';
        MemberListContr.inquiryDate='31/03/2017';
        MemberListContr.setMemberListingData();
        MemberListContr.resultsList= new List<List<String>>();
        MemberListContr.search();
        ACETCallTopicsDataWrapper acetCallTopicDW = new ACETCallTopicsDataWrapper();
        acetCallTopicDW.SurrogateKey = '12345';
        acetCallTopicDW.saveCase(); 
        Test.stopTest();
        system.AssertNotEquals(acetCallTopicDW.caseObj.id, null);
    }
    
    public static testMethod void memberListingSaveandCloseMethod() {
        PageReference ACETMemberListing = Page.ACETViewMemberListing;
       
        String JSONStr = '{"UHCBS":"","GroupN":"Test Group Name","GroupStatus":"Active","ServiceTeam":"NY Large","EffectiveStartDate":"3/1/2016","RiskManagement":"Rating Method","RatingMethod":"","RenewalDate":"3/1/2016","RelationshipType":"Mother","groupSName":"Test GroupName"}';
        Contact cont = TestDataFactory.createContact();
        Interaction__c InteractionId = new Interaction__c();
        InteractionId.Originator__c = cont.id;
        InteractionId.Originator_Type__c = 'Member';
        InteractionId.Highlight_Panel_GroupInfo__c = JSONStr;
        insert InteractionId;
        ACETMemberListing.getParameters().put('InteractionId', InteractionId.Id);
        Test.setCurrentPage(ACETMemberListing);
        
        PageReference ACETMemberListingPDF = Page.ACETViewMemberListingPDF;
        ACETMemberListingPDF.getParameters().put('view', 'Subscriber');
        ACETMemberListingPDF.getParameters().put('status', 'All');
        ACETMemberListingPDF.getParameters().put('groupIdName', '123456-Test');
        ACETMemberListingPDF.getParameters().put('inqDate', '2017/04/03');
        ACETMemberListingPDF.getParameters().put('bundleId', '12345');
        ACETMemberListingPDF.getParameters().put('pageNo', '0');
        ACETMemberListingPDF.getParameters().put('pgSize', '20');
        ACETMemberListingPDF.getParameters().put('InteractionId', InteractionId.Id);
        ACETMemberListingPDF.getParameters().put('onshoreCode', '05');
        ACETMemberListingPDF.getParameters().put('additionalInfo', TestDataFactory.createACETHighlightsPanelAdditionalInfo());
        ACETMemberListingPDF.getparameters().put('population','population1&population2');
        ACETMemberListingPDF.getparameters().put('allPop','population1&population2');
        Test.setCurrentPage(ACETMemberListingPDF);
        
        Test.startTest();
        
        ACETViewMemberListingController MemberListContr = new ACETViewMemberListingController();
        ACETViewMemberListingPDFController MemberListPDFContr = new ACETViewMemberListingPDFController();
        
        MemberListContr.view = 'Subscriber';
        MemberListContr.status = 'Termed';
        MemberListContr.Subject = cont;
        MemberListContr.inquiryDate='31/03/2017';
        MemberListContr.search();
        MemberListContr.clear();
        MemberListContr.getviewList();
        MemberListContr.getstatusList();
        MemberListContr.getMemberListingOnLoad();
        MemberListContr.passParamsStartRecord();
       // MemberListPDFContr.getSearchMemberListingResultsResp();
        ACETCallTopicsDataWrapper acetCallTopicDW = new ACETCallTopicsDataWrapper();
        acetCallTopicDW.SurrogateKey = '12345';
        acetCallTopicDW.getCallTopicDataWrapperStr();
        acetCallTopicDW.getAdditionalInfoStr();
        acetCallTopicDW.getTTSFilterStr();
        //acetCallTopicDW.createCase();
        acetCallTopicDW.saveCaseAndReturn();
        acetCallTopicDW.saveAndClose();
        Test.stopTest(); 
        
        system.AssertNotEquals(acetCallTopicDW.caseObj.id,null);
        system.AssertEquals(acetCallTopicDW.caseObj.status,'Closed');
    }
    public static testMethod void memberListingSaveandCloseMethod2() {
        PageReference ACETMemberListing = Page.ACETViewMemberListing;
       
        String JSONStr = '{"UHCBS":"","GroupN":"Test Group Name","GroupStatus":"Active","ServiceTeam":"NY Large","EffectiveStartDate":"3/1/2016","RiskManagement":"Rating Method","RatingMethod":"","RenewalDate":"3/1/2016","RelationshipType":"Mother","groupSName":"Test GroupName"}';
        Contact cont = TestDataFactory.createContact();
        Interaction__c InteractionId = new Interaction__c();
        InteractionId.Originator__c = cont.id;
        InteractionId.Originator_Type__c = 'Member';
        InteractionId.Highlight_Panel_GroupInfo__c = JSONStr;
        insert InteractionId;
        ACETMemberListing.getParameters().put('InteractionId', InteractionId.Id);
        Test.setCurrentPage(ACETMemberListing);
        
        PageReference ACETMemberListingPDF = Page.ACETViewMemberListingPDF;
        ACETMemberListingPDF.getParameters().put('view', 'Subscriber');
        ACETMemberListingPDF.getParameters().put('status', 'All');
        ACETMemberListingPDF.getParameters().put('groupIdName', '123456-Test');
        ACETMemberListingPDF.getParameters().put('inqDate', '2017/04/03');
        ACETMemberListingPDF.getParameters().put('bundleId', '12345');
        ACETMemberListingPDF.getParameters().put('pageNo', '0');
        ACETMemberListingPDF.getParameters().put('pgSize', '20');
        ACETMemberListingPDF.getParameters().put('InteractionId', InteractionId.Id);
        ACETMemberListingPDF.getParameters().put('additionalInfo', TestDataFactory.createACETHighlightsPanelAdditionalInfo());
        ACETMemberListingPDF.getparameters().put('population','population1&population2');
        ACETMemberListingPDF.getparameters().put('allPop','population1&population2');
        Test.setCurrentPage(ACETMemberListingPDF);
        
        Test.startTest();
        
        ACETViewMemberListingController MemberListContr = new ACETViewMemberListingController();
        ACETViewMemberListingPDFController MemberListPDFContr = new ACETViewMemberListingPDFController();
        
        MemberListContr.view = 'Subscriber';
        MemberListContr.status = 'Termed';
        MemberListContr.Subject = cont;
        MemberListContr.inquiryDate='31/03/2017';
        MemberListContr.search();
        MemberListContr.clear();
        MemberListContr.getviewList();
        MemberListContr.getstatusList();
        MemberListContr.getMemberListingOnLoad();
        MemberListContr.passParamsStartRecord();
      //  MemberListPDFContr.getSearchMemberListingResultsResp();
        ACETCallTopicsDataWrapper acetCallTopicDW = new ACETCallTopicsDataWrapper();
        acetCallTopicDW.SurrogateKey = '12345';
        acetCallTopicDW.getCallTopicDataWrapperStr();
        acetCallTopicDW.getAdditionalInfoStr();
        acetCallTopicDW.getTTSFilterStr();
        //acetCallTopicDW.createCase();
        acetCallTopicDW.AutodocComment = 'test';
        acetCallTopicDW.misdirect();
        acetCallTopicDW.getMisdirectedReasons();
        acetCallTopicDW.saveCase();
        acetCallTopicDW.cancelCase();
        acetCallTopicDW.getCancelReasons();
        acetCallTopicDW.saveCase();
        Test.stopTest();        
    }
    
    
    public static testMethod void memberListingWebserviceMethod() {
        //Setup records in custom setting
        Map<String, String> mapISLWSConfigs = new Map<String, String>(); 
        mapISLWSConfigs.put('CISLConAccessToken', 'e9b3f2b1-8863-49ec-9ff8-40da25961ef5');
        mapISLWSConfigs.put('OILHttpHeaderAccept', 'application/json;charset=UTF-8');
        mapISLWSConfigs.put('OILHttpHeaderActor', 'ACET');
        mapISLWSConfigs.put('OILHttpHeaderScope', 'read');
        mapISLWSConfigs.put('ISLOAuthContentType', 'application/x-www-form-urlencoded');
        mapISLWSConfigs.put('ISLOAuthGrantType', 'client_credentials');
        mapISLWSConfigs.put('dev_ISLOAuthClientId', 'CISLStageConClientId');
        mapISLWSConfigs.put('dev_ISLOAuthClientSecret', 'CISLStageConClientSecret');
        mapISLWSConfigs.put('dev_ISLOAuthEndpoint', 'https://api-stg.optum.com:8443');
        mapISLWSConfigs.put('dev_GetMedicalProviderEndpoint', '/api/alp/cirrus/v1.0/members/search');
        mapISLWSConfigs.put('dev_ISLOAuthTokenEndpoint', '/auth/oauth/v2/token');
        mapISLWSConfigs.put('OILTimeout', '3000');
        
        List<ISL_Webservice_Config__c> lstISLWSConfigs = ACETTestDataUtility.CreateISLWebserviceConfigurations(mapISLWSConfigs);
        insert lstISLWSConfigs;
        
        Contact cont = TestDataFactory.createContact();
        Interaction__c InteractionId = new Interaction__c();
        InteractionId.Originator__c = cont.id;
        InteractionId.Originator_Type__c = 'Member';
        insert InteractionId;
        
        PageReference ACETMemberListing = Page.ACETViewMemberListing;
        ACETMemberListing.getParameters().put('InteractionId', InteractionId.Id);
        ACETMemberListing.getParameters().put('status', 'Active');
        ACETMemberListing.getParameters().put('subscriber', 'Subscriber');
        ACETMemberListing.getparameters().put('population','population1&population2');
        ACETMemberListing.getparameters().put('allPop','population1&population2');
        Test.setCurrentPage(ACETMemberListing);
        
        PageReference ACETMemberListingPDF = Page.ACETViewMemberListingPDF;
        ACETMemberListingPDF.getParameters().put('InteractionId', InteractionId.Id);
        ACETMemberListingPDF.getParameters().put('status', 'Hold');
        Test.setCurrentPage(ACETMemberListingPDF);

        Test.startTest();
        
        MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', ACETTestDataUtility.getViewMemberListingJSONResponse());
        OILResponse.TokenExpired = false;
        
        MockHttpCalloutResponseGenerator MockHttpRes = new MockHttpCalloutResponseGenerator(null, OILResponse);
        Test.setMock(HttpCalloutMock.class, MockHttpRes);
        
        String jsonResponse = ACETTestDataUtility.getViewMemberListingJSONResponse();
        ACETViewMemberListingJSON2Apex Json2ApexTest = ACETViewMemberListingJSON2Apex.parse(jsonResponse);
        ACETViewMemberListingWebservice webserviceCall = new ACETViewMemberListingWebservice();
        webserviceCall.init('123456-Test','3/1/2016',true,'Active','All');
        webserviceCall.queryPaginatedData(1,10,1);
        
        List<ACETViewMemberListingJSON2Apex.ResponseMessageList> respList = new List<ACETViewMemberListingJSON2Apex.ResponseMessageList>();
        ACETViewMemberListingJSON2Apex.ResponseMessageList resp = new ACETViewMemberListingJSON2Apex.ResponseMessageList();
        resp.code = '200';
        resp.message = 'Success';
        resp.type_z = 'Test';
        respList.add(resp);
        
        ACETViewMemberListingJSON2Apex.MetaInformation metaInfo = new  ACETViewMemberListingJSON2Apex.MetaInformation();
        metaInfo.responseMessageList = respList;
        
        ACETViewMemberListingController MemberListContr = new ACETViewMemberListingController();
        MemberListContr.status = 'All';
        MemberListContr.inquiryDate='31/03/2017';
        MemberListContr.search(); 
        
        ACETViewMemberListingResultsWrapper memberWrapp = new ACETViewMemberListingResultsWrapper();
        memberWrapp.firstName ='testfirstname';
        memberWrapp.lastName ='testlastName';
        memberWrapp.memberID ='123456789';
        memberWrapp.relationShip ='Member';
        memberWrapp.effectiveDate ='01/01/2017';
        memberWrapp.terminationDate ='01/31/2017';
        memberWrapp.contractType ='testType';
        memberWrapp.bundleId ='123456789';
        memberWrapp.billingGroup ='test';
        memberWrapp.status ='Active';
        memberWrapp.memberDOB ='01/01/1950';
        
        Test.stopTest(); 
    }
    public static testMethod void memberListingWebserviceErrorMethod() {
        //Setup records in custom setting
        Map<String, String> mapISLWSConfigs = new Map<String, String>(); 
        mapISLWSConfigs.put('CISLConAccessToken', 'e9b3f2b1-8863-49ec-9ff8-40da25961ef5');
        mapISLWSConfigs.put('OILHttpHeaderAccept', 'application/json;charset=UTF-8');
        mapISLWSConfigs.put('OILHttpHeaderActor', 'ACET');
        mapISLWSConfigs.put('OILHttpHeaderScope', 'read');
        mapISLWSConfigs.put('ISLOAuthContentType', 'application/x-www-form-urlencoded');
        mapISLWSConfigs.put('ISLOAuthGrantType', 'client_credentials');
        mapISLWSConfigs.put('dev_CISLOAuthClientId', 'ISLStageConClientId');
        mapISLWSConfigs.put('dev_CISLOAuthClientSecret', 'ISLStageConClientSecret');
        mapISLWSConfigs.put('dev_CISLOAuthEndpoint', 'https://api-stg.optum.com:8443');
        mapISLWSConfigs.put('dev_GetMedicalProviderEndpoint', '/api/alp/cirrus/v1.0/members/search');
        mapISLWSConfigs.put('dev_ISLOAuthTokenEndpoint', '/auth/oauth/v2/token');
        mapISLWSConfigs.put('OILTimeout', '3000');
        
        List<ISL_Webservice_Config__c> lstISLWSConfigs = ACETTestDataUtility.CreateISLWebserviceConfigurations(mapISLWSConfigs);
        insert lstISLWSConfigs;
        
        Contact cont = TestDataFactory.createContact();
        Interaction__c InteractionId = new Interaction__c();
        InteractionId.Originator__c = cont.id;
        InteractionId.Originator_Type__c = 'Member';
        insert InteractionId;
        
        PageReference ACETMemberListing = Page.ACETViewMemberListing;
        ACETMemberListing.getParameters().put('InteractionId', InteractionId.Id);
        ACETMemberListing.getParameters().put('status', 'Active');
        ACETMemberListing.getParameters().put('subscriber', 'Subscriber');
        Test.setCurrentPage(ACETMemberListing);
        
        PageReference ACETMemberListingPDF = Page.ACETViewMemberListingPDF;
        ACETMemberListingPDF.getParameters().put('InteractionId', InteractionId.Id);
        ACETMemberListingPDF.getParameters().put('status', 'Hold');
        Test.setCurrentPage(ACETMemberListingPDF);

        Test.startTest();
        
        MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse = new MockHttpCalloutResponseGenerator.MockHttpResponse(400, 'Error',ACETTestDataUtility.getViewMemberListingJSONResponse()); 
        OILResponse.TokenExpired = false;
        
        MockHttpCalloutResponseGenerator MockHttpRes = new MockHttpCalloutResponseGenerator(null, OILResponse);
        Test.setMock(HttpCalloutMock.class, MockHttpRes);
        
        String jsonResponse = ACETTestDataUtility.getViewMemberListingJSONResponse();
        ACETViewMemberListingJSON2Apex Json2ApexTest = ACETViewMemberListingJSON2Apex.parse(jsonResponse);
        ACETViewMemberListingWebservice webserviceCall = new ACETViewMemberListingWebservice();
        webserviceCall.queryPaginatedData(1,10,1);
        
        List<ACETViewMemberListingJSON2Apex.ResponseMessageList> respList = new List<ACETViewMemberListingJSON2Apex.ResponseMessageList>();
        ACETViewMemberListingJSON2Apex.ResponseMessageList resp = new ACETViewMemberListingJSON2Apex.ResponseMessageList();
        resp.code = '400';
        resp.message = 'Error';
        resp.type_z = 'Test';
        respList.add(resp);
        
        Test.stopTest(); 
    }
    public static testMethod void memberListingWebserviceErrorMethod1() {
        //Setup records in custom setting
        Map<String, String> mapISLWSConfigs = new Map<String, String>(); 
        mapISLWSConfigs.put('CISLConAccessToken', 'e9b3f2b1-8863-49ec-9ff8-40da25961ef5');
        mapISLWSConfigs.put('OILHttpHeaderAccept', 'application/json;charset=UTF-8');
        mapISLWSConfigs.put('OILHttpHeaderActor', 'ACET');
        mapISLWSConfigs.put('OILHttpHeaderScope', 'read');
        mapISLWSConfigs.put('ISLOAuthContentType', 'application/x-www-form-urlencoded');
        mapISLWSConfigs.put('ISLOAuthGrantType', 'client_credentials');
        mapISLWSConfigs.put('dev_CISLOAuthClientId', 'ISLStageConClientId');
        mapISLWSConfigs.put('dev_CISLOAuthClientSecret', 'ISLStageConClientSecret');
        mapISLWSConfigs.put('dev_CISLOAuthEndpoint', 'https://api-stg.optum.com:8443');
        mapISLWSConfigs.put('dev_CirrusMemberListing', '/api/alp/cirrus/v1.0/members/search');
        mapISLWSConfigs.put('dev_ISLOAuthTokenEndpoint', '/auth/oauth/v2/token');
        mapISLWSConfigs.put('CISLTimeout', '3000');
        
        List<ISL_Webservice_Config__c> lstISLWSConfigs = ACETTestDataUtility.CreateISLWebserviceConfigurations(mapISLWSConfigs);
        insert lstISLWSConfigs;
        
        Contact cont = TestDataFactory.createContact();
        Interaction__c InteractionId = new Interaction__c();
        InteractionId.Originator__c = cont.id;
        InteractionId.Originator_Type__c = 'Member';
        insert InteractionId;
        
        PageReference ACETMemberListing = Page.ACETViewMemberListing;
        ACETMemberListing.getParameters().put('InteractionId', InteractionId.Id);
        ACETMemberListing.getParameters().put('status', 'Active');
        ACETMemberListing.getParameters().put('subscriber', 'Subscriber');
        Test.setCurrentPage(ACETMemberListing);
        
        PageReference ACETMemberListingPDF = Page.ACETViewMemberListingPDF;
        ACETMemberListingPDF.getParameters().put('InteractionId', InteractionId.Id);
        ACETMemberListingPDF.getParameters().put('status', 'Hold');
        Test.setCurrentPage(ACETMemberListingPDF);

        Test.startTest();
        
        MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', ACETTestDataUtility.getViewMemberListingJSONResponseError1());
        OILResponse.TokenExpired = false;
        
        MockHttpCalloutResponseGenerator MockHttpRes = new MockHttpCalloutResponseGenerator(null, OILResponse);
        Test.setMock(HttpCalloutMock.class, MockHttpRes);
        
        String jsonResponse = ACETTestDataUtility.getViewMemberListingJSONResponseError1();
        ACETViewMemberListingJSON2Apex Json2ApexTest = ACETViewMemberListingJSON2Apex.parse(jsonResponse);
        ACETViewMemberListingWebservice webserviceCall = new ACETViewMemberListingWebservice();
        webserviceCall.init('123456-Test','3/1/2016',true,'All','12345');
        webserviceCall.queryPaginatedData(1,10,1);
        
        MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse2 = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', ACETTestDataUtility.getViewMemberListingJSONResponseError2());
        OILResponse2.TokenExpired = false;
        
        MockHttpCalloutResponseGenerator MockHttpRes2 = new MockHttpCalloutResponseGenerator(null, OILResponse2);
        Test.setMock(HttpCalloutMock.class, MockHttpRes2);
        
        String jsonResponse2 = ACETTestDataUtility.getViewMemberListingJSONResponseError2();
        ACETViewMemberListingJSON2Apex Json2ApexTest2 = ACETViewMemberListingJSON2Apex.parse(jsonResponse2);
        ACETViewMemberListingWebservice webserviceCall2 = new ACETViewMemberListingWebservice();
        webserviceCall.init('123456-Test','3/1/2016',true,'Active','All');
        webserviceCall.queryPaginatedData(1,10,1);
       
        Test.stopTest(); 
    }
    
    public static testMethod void groupMemberListingWebserviceMethod() {
        //Setup records in custom setting
        Map<String, String> mapISLWSConfigs = new Map<String, String>(); 
        mapISLWSConfigs.put('CISLConAccessToken', 'e9b3f2b1-8863-49ec-9ff8-40da25961ef5');
        mapISLWSConfigs.put('OILHttpHeaderAccept', 'application/json;charset=UTF-8');
        mapISLWSConfigs.put('OILHttpHeaderActor', 'ACET');
        mapISLWSConfigs.put('OILHttpHeaderScope', 'read');
        mapISLWSConfigs.put('ISLOAuthContentType', 'application/x-www-form-urlencoded');
        mapISLWSConfigs.put('ISLOAuthGrantType', 'client_credentials');
        mapISLWSConfigs.put('dev_CISLOAuthClientId', 'ISLStageConClientId');
        mapISLWSConfigs.put('dev_CISLOAuthClientSecret', 'ISLStageConClientSecret');
        mapISLWSConfigs.put('dev_CISLOAuthEndpoint', 'https://api-stg.optum.com:8443');
        mapISLWSConfigs.put('dev_CirrusMemberListing', '/api/alp/cirrus/v1.0/members/search');
        mapISLWSConfigs.put('dev_ISLOAuthTokenEndpoint', '/auth/oauth/v2/token');
        mapISLWSConfigs.put('OILTimeout', '3000');
        
        List<ISL_Webservice_Config__c> lstISLWSConfigs = ACETTestDataUtility.CreateISLWebserviceConfigurations(mapISLWSConfigs);
        insert lstISLWSConfigs;
        
        Contact cont = TestDataFactory.createContact();
        Interaction__c InteractionId = new Interaction__c();
        InteractionId.Originator__c = cont.id;
        InteractionId.Originator_Type__c = 'Member';
        insert InteractionId;
        
        PageReference ACETMemberListing = Page.ACETViewMemberListing;
        ACETMemberListing.getParameters().put('InteractionId', InteractionId.Id);
        ACETMemberListing.getParameters().put('status', 'Active');
        ACETMemberListing.getParameters().put('subscriber', 'Subscriber');
        Test.setCurrentPage(ACETMemberListing);
        
        PageReference ACETMemberListingPDF = Page.ACETViewMemberListingPDF;
        ACETMemberListingPDF.getParameters().put('InteractionId', InteractionId.Id);
        ACETMemberListingPDF.getParameters().put('status', 'Hold');
        Test.setCurrentPage(ACETMemberListingPDF);

        Test.startTest();
        
        MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', ACETTestDataUtility.getViewMemberListingErrorJSONResponse());
        OILResponse.TokenExpired = false;
        
        MockHttpCalloutResponseGenerator MockHttpRes = new MockHttpCalloutResponseGenerator(null, OILResponse);
        Test.setMock(HttpCalloutMock.class, MockHttpRes);
        
        String jsonResponse = ACETTestDataUtility.getViewMemberListingErrorJSONResponse();
        ACETViewMemberListingJSON2Apex Json2ApexTest = ACETViewMemberListingJSON2Apex.parse(jsonResponse);
        ACETViewMemberListingWebservice webserviceCall = new ACETViewMemberListingWebservice();
        webserviceCall.init('123456-Test','3/1/2016',true,'All','All');
        webserviceCall.queryPaginatedData(1,10,1);
        String str='{"metaInformation": {},"responseData":{"memberList":[{"demographics":{"memberID":"","cobraInd":"","nameFirst":"","nameLast":"","birthDate":"","gender":""},"memberCoverageList":[{"coverageOptionID":"1930005","benPlanEffDate":"2017-05-01","benPlanExpDate":"9999-12-31","coverageType":"02","coverageOptionPlans":[{"planID": "PEDV000011","planName":"PEDIATRIC VISION CTSM SMART HSA 02","planType":"02","benefitType":"VS"}],"memberStatus":"ACTIVE"}],"memberAffiliation": {}}],"hasNextPage": false,"sort":[{"direction":"ASC","property":"memberID","ignoreCase":false,"nullHandling":"NATIVE","ascending": true,"descending": false}],"pageNumber": 0,"size": 19}}';
        Test.stopTest(); 
    }
    public static testMethod void groupMemberListingWebserviceMethod1() {
        //Setup records in custom setting
        Map<String, String> mapISLWSConfigs = new Map<String, String>(); 
        mapISLWSConfigs.put('CISLConAccessToken', 'e9b3f2b1-8863-49ec-9ff8-40da25961ef5');
        mapISLWSConfigs.put('OILHttpHeaderAccept', 'application/json;charset=UTF-8');
        mapISLWSConfigs.put('OILHttpHeaderActor', 'ACET');
        mapISLWSConfigs.put('OILHttpHeaderScope', 'read');
        mapISLWSConfigs.put('ISLOAuthContentType', 'application/x-www-form-urlencoded');
        mapISLWSConfigs.put('ISLOAuthGrantType', 'client_credentials');
        mapISLWSConfigs.put('dev_CISLOAuthClientId', 'ISLStageConClientId');
        mapISLWSConfigs.put('dev_CISLOAuthClientSecret', 'ISLStageConClientSecret');
        mapISLWSConfigs.put('dev_CISLOAuthEndpoint', 'https://api-stg.optum.com:8443');
        mapISLWSConfigs.put('dev_CirrusMemberListing', '/api/alp/cirrus/v1.0/members/search');
        mapISLWSConfigs.put('dev_ISLOAuthTokenEndpoint', '/auth/oauth/v2/token');
        mapISLWSConfigs.put('OILTimeout', '3000');
        
        List<ISL_Webservice_Config__c> lstISLWSConfigs = ACETTestDataUtility.CreateISLWebserviceConfigurations(mapISLWSConfigs);
        insert lstISLWSConfigs;
        
        Contact cont = TestDataFactory.createContact();
        Interaction__c InteractionId = new Interaction__c();
        InteractionId.Originator__c = cont.id;
        InteractionId.Originator_Type__c = 'Member';
        insert InteractionId;
        
        PageReference ACETMemberListing = Page.ACETViewMemberListing;
        ACETMemberListing.getParameters().put('InteractionId', InteractionId.Id);
        ACETMemberListing.getParameters().put('status', 'Active');
        ACETMemberListing.getParameters().put('subscriber', 'Subscriber');
        Test.setCurrentPage(ACETMemberListing);
        
        PageReference ACETMemberListingPDF = Page.ACETViewMemberListingPDF;
        ACETMemberListingPDF.getParameters().put('InteractionId', InteractionId.Id);
        ACETMemberListingPDF.getParameters().put('status', 'Hold');
        Test.setCurrentPage(ACETMemberListingPDF);

        Test.startTest();
        String strResponse='{"metaInformation": {},"responseData":{"memberList":[{"demographics":{"memberID":null,"cobraInd":"","nameFirst":"","nameLast":"","birthDate":"","gender":""},"memberCoverageList":[{"coverageOptionID":"1930005","benPlanEffDate":"2017-05-01","benPlanExpDate":"9999-12-31","coverageType":"02","covLevelList":[],"coverageOptionPlans":[{"planID": "PEDV000011","planName":"PEDIATRIC VISION CTSM SMART HSA 02","planType":"02","benefitType":"VS"}],"memberStatus":"ACTIVE"}],"memberAffiliation":{}}],"hasNextPage":true,"sort":[{"direction":"ASC","property":"memberID","ignoreCase":false,"nullHandling":"NATIVE","ascending": true,"descending": false}],"pageNumber": 0,"size": 19}}';
        MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK',strResponse);
        OILResponse.TokenExpired = false;
        
        MockHttpCalloutResponseGenerator MockHttpRes = new MockHttpCalloutResponseGenerator(null, OILResponse);
        Test.setMock(HttpCalloutMock.class, MockHttpRes);
        System.debug('hereherehere1 ' + strResponse);
        ACETViewMemberListingJSON2Apex Json2ApexTest = ACETViewMemberListingJSON2Apex.parse(strResponse);
        ACETViewMemberListingWebservice webserviceCall = new ACETViewMemberListingWebservice();
        webserviceCall.init('123456-Test','3/1/2016',true,'Active','All');
        webserviceCall.queryPaginatedData(1,10,1);        
        Test.stopTest(); 
    }
    public static testMethod void groupMemberListingWebserviceMethod2() {
        //Setup records in custom setting
        Map<String, String> mapISLWSConfigs = new Map<String, String>(); 
        mapISLWSConfigs.put('CISLConAccessToken', 'e9b3f2b1-8863-49ec-9ff8-40da25961ef5');
        mapISLWSConfigs.put('OILHttpHeaderAccept', 'application/json;charset=UTF-8');
        mapISLWSConfigs.put('OILHttpHeaderActor', 'ACET');
        mapISLWSConfigs.put('OILHttpHeaderScope', 'read');
        mapISLWSConfigs.put('ISLOAuthContentType', 'application/x-www-form-urlencoded');
        mapISLWSConfigs.put('ISLOAuthGrantType', 'client_credentials');
        mapISLWSConfigs.put('dev_CISLOAuthClientId', 'ISLStageConClientId');
        mapISLWSConfigs.put('dev_CISLOAuthClientSecret', 'ISLStageConClientSecret');
        mapISLWSConfigs.put('dev_CISLOAuthEndpoint', 'https://api-stg.optum.com:8443');
        mapISLWSConfigs.put('dev_CirrusMemberListing', '/api/alp/cirrus/v1.0/members/search');
        mapISLWSConfigs.put('dev_ISLOAuthTokenEndpoint', '/auth/oauth/v2/token');
        mapISLWSConfigs.put('OILTimeout', '3000');
        
        List<ISL_Webservice_Config__c> lstISLWSConfigs = ACETTestDataUtility.CreateISLWebserviceConfigurations(mapISLWSConfigs);
        insert lstISLWSConfigs;
        
        Contact cont = TestDataFactory.createContact();
        Interaction__c InteractionId = new Interaction__c();
        InteractionId.Originator__c = cont.id;
        InteractionId.Originator_Type__c = 'Member';
        insert InteractionId;
        
        PageReference ACETMemberListing = Page.ACETViewMemberListing;
        ACETMemberListing.getParameters().put('InteractionId', InteractionId.Id);
        ACETMemberListing.getParameters().put('status', 'Active');
        ACETMemberListing.getParameters().put('subscriber', 'Subscriber');
        Test.setCurrentPage(ACETMemberListing);
        
        PageReference ACETMemberListingPDF = Page.ACETViewMemberListingPDF;
        ACETMemberListingPDF.getParameters().put('InteractionId', InteractionId.Id);
        ACETMemberListingPDF.getParameters().put('status', 'Hold');
        Test.setCurrentPage(ACETMemberListingPDF);

        Test.startTest();
        String strResponse='{"metaInformation": {},"responseData":{"memberList":[{"demographics":{"memberID":null,"cobraInd":"","nameFirst":"","nameLast":"","birthDate":"","gender":""},"memberCoverageList":[{"coverageOptionID":"1930005","benPlanEffDate":"2017-05-01","benPlanExpDate":"9999-12-31","coverageType":"02","covLevelList":[],"coverageOptionPlans":[{"planID": "PEDV000011","planName":"PEDIATRIC VISION CTSM SMART HSA 02","planType":"02","benefitType":"VS"}],"memberStatus":"ACTIVE"}],"memberAffiliation":{}}],"hasNextPage":true,"sort":[{"direction":"ASC","property":"memberID","ignoreCase":false,"nullHandling":"NATIVE","ascending": true,"descending": false}],"pageNumber": 0,"size": 19}}';
        MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK',strResponse);
        OILResponse.TokenExpired = false;
        
        MockHttpCalloutResponseGenerator MockHttpRes = new MockHttpCalloutResponseGenerator(null, OILResponse);
        Test.setMock(HttpCalloutMock.class, MockHttpRes);
        
        ACETViewMemberListingJSON2Apex Json2ApexTest = ACETViewMemberListingJSON2Apex.parse(strResponse);
        ACETViewMemberListingWebservice webserviceCall = new ACETViewMemberListingWebservice();
        webserviceCall.init('123456-Test','3/1/2016',true,'Active','12345');
        webserviceCall.queryPaginatedData(1,10,1);        
        Test.stopTest(); 
    }
        
    public static testMethod void memberListingSaveandCloseMethod3() {
        
    PageReference ACETMemberListing = Page.ACETViewMemberListing;
       
        String JSONStr = '{"UHCBS":"","GroupN":"Test Group Name","GroupStatus":"Active","ServiceTeam":"NY Large","EffectiveStartDate":"3/1/2016","RiskManagement":"Rating Method","RatingMethod":"","RenewalDate":"3/1/2016","RelationshipType":"Mother","groupSName":"Test GroupName"}';
        Contact cont = TestDataFactory.createContact();
        Interaction__c InteractionId = new Interaction__c();
        InteractionId.Originator__c = cont.id;
        InteractionId.Originator_Type__c = 'Member';
        InteractionId.Highlight_Panel_GroupInfo__c = JSONStr;
        insert InteractionId;
        ACETMemberListing.getParameters().put('InteractionId', InteractionId.Id);
        Test.setCurrentPage(ACETMemberListing);
        
        PageReference ACETMemberListingPDF = Page.ACETViewMemberListingPDF;
        ACETMemberListingPDF.getParameters().put('view', 'Subscriber');
        ACETMemberListingPDF.getParameters().put('status', 'All');
        ACETMemberListingPDF.getParameters().put('groupIdName', '123456-Test');
        ACETMemberListingPDF.getParameters().put('inqDate', '2017/04/03');
        ACETMemberListingPDF.getParameters().put('bundleId', '12345');
        ACETMemberListingPDF.getParameters().put('pageNo', '0');
        ACETMemberListingPDF.getParameters().put('pgSize', '20');
        ACETMemberListingPDF.getParameters().put('InteractionId', InteractionId.Id);
        ACETMemberListingPDF.getParameters().put('onshoreCode', '05');
        ACETMemberListingPDF.getParameters().put('additionalInfo', TestDataFactory.createACETHighlightsPanelAdditionalInfo());
        ACETMemberListingPDF.getparameters().put('population','population1&population2');
        ACETMemberListingPDF.getparameters().put('allPop','population1&population2');
        Test.setCurrentPage(ACETMemberListingPDF);
        
        Test.startTest();
        String strResponse='{"metaInformation": {},"responseData":{"memberList":[{"demographics":{"memberID":"95197881500","cobraInd":false,"familyStatus":"single","nameFirst":"John","nameLast":"Johnson","birthDate":"1983-08-09","gender":"M","socialSecurityNumber":"435670444"},"memberCoverageList":[{"coverageOptionDescription":"Plan_1","coverageOptionID":"1018480","benPlanEffDate":"2017-09-01","benPlanExpDate":"2018-06-30","termMemberBenMethod":"1","termMemberBenReason":"22","productID":"PM00000007","qualifyingEvent":"28","benefitStatusCode":"A","qualifyingEventDate":"2017-01-01","coverageOptionPlans":[{"planID":"M000000745","planName":"CTSM SMART HSA PPO D30/D50 ER D/200","planType":"06","benefitType":"MD"},{"planID":"PEDD000005","planName":"PEDIATRIC DENTAL CTSM SMART HSA 01","benefitType":"DN"},{"planID":"PEDV000005","planName":"PEDIATRIC VISION CTSM SMART HSA 01","benefitType":"VS"},{"planID":"RX00000003","planName":"SG $5/$50/30% to $500 max/50% to $750","planType":"03","benefitType":"RX"}],"memberStatus":"TERM","covLevelList":[{"covLevelCode":"EMP","covLevelDesc":"Employee Only","covLevelEffDate":"2017-09-01","covLevelExpDate":"2018-06-30"}]}],"memberAffiliation":{"relationshipCode":"18","populationID":"ALL_EMP","populationName":"ALL OTHER EMPLOYEES","subscriberID":"95197881500","employStatusCode":"T","memGroupID":"4061353","memGroupName":"Small 20180817060629","billingPrefID":"14516","relationshipCodeDesc":"Self","billingPreferenceDescription":"Default Billing Pref"}},{"demographics":{"memberID":"11593523700","cobraInd":false,"familyStatus":"single","nameFirst":"Dana","nameLast":"Johnsontest","birthDate":"1981-08-09","gender":"F","socialSecurityNumber":"435670555"},"memberCoverageList":[{"coverageOptionDescription":"Plan_1","coverageOptionID":"1018480","benPlanEffDate":"2018-01-01","benPlanExpDate":"9999-12-31","productID":"PM00000007","qualifyingEvent":"28","benefitStatusCode":"A","qualifyingEventDate":"2017-01-01","coverageOptionPlans":[{"planID":"M000000745","planName":"CTSM SMART HSA PPO D30/D50 ER D/200","planType":"06","benefitType":"MD"},{"planID":"PEDD000005","planName":"PEDIATRIC DENTAL CTSM SMART HSA 01","benefitType":"DN"},{"planID":"PEDV000005","planName":"PEDIATRIC VISION CTSM SMART HSA 01","benefitType":"VS"},{"planID":"RX00000003","planName":"SG $5/$50/30% to $500 max/50% to $750","planType":"03","benefitType":"RX"}],"memberStatus":"ACTIVE","covLevelList":[{"covLevelCode":"EMP","covLevelDesc":"Employee Only","covLevelEffDate":"2018-01-01","covLevelExpDate":"9999-12-31"}]}],"memberAffiliation":{"relationshipCode":"18","populationID":"ALL_EMP","populationName":"ALL OTHER EMPLOYEES","subscriberID":"11593523700","employStatusCode":"B","memGroupID":"4061353","memGroupName":"Small 20180817060629","billingPrefID":"14516","relationshipCodeDesc":"Self","billingPreferenceDescription":"Default Billing Pref"}},{"demographics":{"memberID":"95589541400","cobraInd":false,"familyStatus":"single","nameFirst":"Leah","nameLast":"Privi","birthDate":"1981-08-09","gender":"F","socialSecurityNumber":"435670432"},"memberCoverageList":[{"coverageOptionDescription":"Plan_1","coverageOptionID":"1018480","benPlanEffDate":"2017-09-01","benPlanExpDate":"9999-12-31","productID":"PM00000007","qualifyingEvent":"28","benefitStatusCode":"A","qualifyingEventDate":"2017-01-01","coverageOptionPlans":[{"planID":"M000000745","planName":"CTSM SMART HSA PPO D30/D50 ER D/200","planType":"06","benefitType":"MD"},{"planID":"PEDD000005","planName":"PEDIATRIC DENTAL CTSM SMART HSA 01","benefitType":"DN"},{"planID":"PEDV000005","planName":"PEDIATRIC VISION CTSM SMART HSA 01","benefitType":"VS"},{"planID":"RX00000003","planName":"SG $5/$50/30% to $500 max/50% to $750","planType":"03","benefitType":"RX"}],"memberStatus":"ACTIVE","covLevelList":[{"covLevelCode":"EMP","covLevelDesc":"Employee Only","covLevelEffDate":"2017-09-01","covLevelExpDate":"9999-12-31"}]}],"memberAffiliation":{"relationshipCode":"18","populationID":"POP_EXECUTIVES","populationName":"Executives","subscriberID":"95589541400","employStatusCode":"B","memGroupID":"4061353","memGroupName":"Small 20180817060629","billingPrefID":"14516","relationshipCodeDesc":"Self","billingPreferenceDescription":"Default Billing Pref"}},{"demographics":{"memberID":"21590165300","cobraInd":false,"familyStatus":"single","nameFirst":"Jack","nameLast":"Smithtest","birthDate":"1987-08-09","gender":"M","socialSecurityNumber":"435670916"},"memberCoverageList":[{"coverageOptionDescription":"Plan_2","coverageOptionID":"1018485","benPlanEffDate":"2018-01-01","benPlanExpDate":"2018-12-31","termMemberBenMethod":"1","termMemberBenReason":"02","productID":"PM00000022","qualifyingEvent":"29","benefitStatusCode":"A","qualifyingEventDate":"2017-01-01","coverageOptionPlans":[{"planID":"M000000014","planName":"CTSM HMO $25/$40 COPAY","planType":"02","benefitType":"MD"},{"planID":"RX00000001","planName":"SG $5/$30/30% to $500 max/50% to $750","planType":"03","benefitType":"RX"},{"planID":"PEDD000009","planName":"PEDIATRIC DENTAL CTSM HMO 01","benefitType":"DN"},{"planID":"PEDV000009","planName":"PEDIATRIC VISION CTSM HMO 01","benefitType":"VS"}],"memberStatus":"FUTURE","covLevelList":[{"covLevelCode":"EMP","covLevelDesc":"Employee Only","covLevelEffDate":"2018-01-01","covLevelExpDate":"2018-12-31"}]}],"memberAffiliation":{"relationshipCode":"18","populationID":"POP_EXECUTIVES","populationName":"Executives","subscriberID":"21590165300","employStatusCode":"A","memGroupID":"4061353","memGroupName":"Small 20180817060629","billingPrefID":"14516","relationshipCodeDesc":"Self","billingPreferenceDescription":"Default Billing Pref"}}],"hasNextPage":false,"sort":[{"direction":"ASC","property":"nameLast","ignoreCase":false,"nullHandling":"NATIVE","descending":false,"ascending":true},{"direction":"ASC","property":"nameFirst","ignoreCase":false,"nullHandling":"NATIVE","descending":false,"ascending":true},{"direction":"ASC","property":"memberID","ignoreCase":false,"nullHandling":"NATIVE","descending":false,"ascending":true}],"pageNumber":0,"size":4}}';
        MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK',strResponse);
        OILResponse.TokenExpired = false;
        
        MockHttpCalloutResponseGenerator MockHttpRes = new MockHttpCalloutResponseGenerator(null, OILResponse);
        Test.setMock(HttpCalloutMock.class, MockHttpRes);
        System.debug('hereherehere2 ' + strResponse);
        ACETViewMemberListingJSON2Apex Json2ApexTest = ACETViewMemberListingJSON2Apex.parse(strResponse);
        ACETViewMemberListingWebservice webserviceCall = new ACETViewMemberListingWebservice();
        webserviceCall.init('123456-Test','3/1/2016',true,'Active','All');
        webserviceCall.queryPaginatedData(1,10,1);
        
        ACETViewMemberListingController MemberListContr = new ACETViewMemberListingController();
        ACETViewMemberListingPDFController MemberListPDFContr = new ACETViewMemberListingPDFController();
        
        MemberListContr.view = 'Subscriber';
        MemberListContr.status = 'Termed';
        MemberListContr.Subject = cont;
        MemberListContr.inquiryDate='31/03/2017';
        MemberListContr.getMemberListingOnLoad();
        MemberListContr.getMemberListingResults('4061353','2018-11-16',true,'All','1018480', 'Executives');
        ACETCallTopicsDataWrapper acetCallTopicDW = new ACETCallTopicsDataWrapper();
        acetCallTopicDW.SurrogateKey = '12345';
        acetCallTopicDW.getCallTopicDataWrapperStr();
        acetCallTopicDW.getAdditionalInfoStr();
        acetCallTopicDW.getTTSFilterStr();
        //acetCallTopicDW.createCase();
        acetCallTopicDW.saveCaseAndReturn();
        acetCallTopicDW.saveAndClose();
        Test.stopTest(); 
        
        system.AssertNotEquals(acetCallTopicDW.caseObj.id,null);
        system.AssertEquals(acetCallTopicDW.caseObj.status,'Closed');
    }
    
    public static testMethod void startMemberListingTesting() {
        try{
            string cobraCount1 = '5';
            ApexPages.currentPage().getParameters().put('inquiryDate', '31/03/2017');
            ApexPages.currentPage().getParameters().put('bundles', 'Bundle1,Bundle2');
            ApexPages.currentPage().getParameters().put('allPop', 'testOp1,testopo2');
            ApexPages.currentPage().getParameters().put('cobCount',string.valueof(cobraCount1));
            ACETViewMemberListingController MemberListContr = new ACETViewMemberListingController();
            MemberListContr.startMemberListing();
        }catch(exception ex){}
    }
    
}