// US2041480 - Thanish - 6th Apr 2020
@isTest
public class ACET_ServiceRequestDetailCtrlTest {

    @testSetup static void testSetupMethod() {
        Organization_Properties__c orgProps = Organization_Properties__c.getOrgDefaults();
        orgProps.OrganizationName__c = 'QA';
        Upsert orgProps;

        // Token API data
        WebserviceConfigurations__c tokenAPIWSConfig = ACET_WebserviceCalloutFramework_Test.createTokenWSConfigs('LinkTokenAPI');
        OrgSpecificConfigurations__c tokenAPIOrgSpecificConfigs = ACET_WebserviceCalloutFramework_Test.createTokenOrgWSConfigs(tokenAPIWSConfig.Id);
        WebserviceConfigurations__c starTokenAPIWSConfig = ACET_WebserviceCalloutFramework_Test.createTokenWSConfigs('StarGateTokenAPI');
        OrgSpecificConfigurations__c starTokenAPIOrgSpecificConfigs = ACET_WebserviceCalloutFramework_Test.createTokenOrgWSConfigs(starTokenAPIWSConfig.Id);

        // Service API data
        WebserviceConfigurations__c orswsConfig = ACET_WebserviceCalloutFramework_Test.createWSConfig('ORSSelectIssue', starTokenAPIWSConfig.Id);
        OrgSpecificConfigurations__c orsorgSpecificConfigs = ACET_WebserviceCalloutFramework_Test.createOrgWSConfigs(orswsConfig.Id);
        WebserviceConfigurations__c claDetailwsConfig = ACET_WebserviceCalloutFramework_Test.createWSConfig('LinkClaimDetail', tokenAPIWSConfig.Id);
        OrgSpecificConfigurations__c claDetailorgSpecificConfigs = ACET_WebserviceCalloutFramework_Test.createOrgWSConfigs(claDetailwsConfig.Id);
        WebserviceConfigurations__c claimActwsConfig = ACET_WebserviceCalloutFramework_Test.createWSConfig('LinkClaimAction', tokenAPIWSConfig.Id);
        OrgSpecificConfigurations__c claimActorgSpecificConfigs = ACET_WebserviceCalloutFramework_Test.createOrgWSConfigs(claimActwsConfig.Id);
        WebserviceConfigurations__c orsUpdatewsConfig = ACET_WebserviceCalloutFramework_Test.createWSConfig('OrsUpdateIssueMicroService', starTokenAPIWSConfig.Id);
        OrgSpecificConfigurations__c orsUpdateorgSpecificConfigs = ACET_WebserviceCalloutFramework_Test.createOrgWSConfigs(orsUpdatewsConfig.Id);
        WebserviceConfigurations__c orsReadwsConfig = ACET_WebserviceCalloutFramework_Test.createWSConfig('ORSReadIssueMicroService', starTokenAPIWSConfig.Id);
        OrgSpecificConfigurations__c orsReadorgSpecificConfigs = ACET_WebserviceCalloutFramework_Test.createOrgWSConfigs(orsReadwsConfig.Id);
        WebserviceConfigurations__c facetwsConfig = ACET_WebserviceCalloutFramework_Test.createWSConfig('FacetsGetCases', starTokenAPIWSConfig.Id);
        OrgSpecificConfigurations__c facetorgSpecificConfigs = ACET_WebserviceCalloutFramework_Test.createOrgWSConfigs(facetwsConfig.Id);
    }

    /**
     * @description 
     * @author Nikhil Kanth | 04-26-2021 
     **/
    @isTest static void testGetClaimIssuesContinuation() {
        ACET_ServiceRequestDetailCtrl serReq = new ACET_ServiceRequestDetailCtrl();
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new SAEHttpCalloutMock.SAEClaimDetailWebServiceMock());
        ACET_WebserviceCalloutFramework claimWsCallOutFW = new ACET_WebserviceCalloutFramework();
        claimWsCallOutFW.serviceName = 'LinkClaimDetail';
        Map < String, String > requestParamsMap = new Map < String, String > ();
        requestParamsMap.put('q', 'test');
        claimWsCallOutFW.requestParamsMap = requestParamsMap;
        HttpResponse claimDetResponse = claimWsCallOutFW.getResponse();

        Continuation contin = (Continuation) ACET_ServiceRequestDetailCtrl.getClaimIssues('11111', '860708506', '1234');
        HttpResponse orsResponse = new HttpResponse();
        orsResponse.setStatusCode(200);
        orsResponse.setBody('{"searchResult": {"searchOutput": {"issuesList": [{"issueId": "D00860744188246","reasonCode": "","statusCode": "H","status": "HOLD","contactMethodCode": "W","contactMethodDescription": "WALK-IN","originatorTypeCode": "EM","originatorTypeDescription": "MEMBER","originatedDate": "2020-03-26","originatedTime": "07:44:00","comment": "BE LOST).","updateDate": "2020-03-26","associateName": {"firstName": "JAMAL","lastName": "ROYSTER"},"businessSegmentName": "","subReasonText": "","complaintCategoryText": "","reasonCategory": "","followupStatusCode": "","followupStatusDescription": "NONE","followupPurposeCode": "","claimNumber": "","claimAuthorization": "","claimServiceDate": "","claimCount": "00","hippa": "","extrClaimNumber": "","extrSubscriberId": "","origOfficeNumber": "673","ownerOfficeId": "673","ownerDepartmentCode": "SYS","memberInfo": {"dependentName": {"firstName": "JACK","lastName": ""},"groupNumber": "000000000","groupName": "UHC","product": "","memberNumber": "123456789","policy": "12345","alternateId": "123456789","eligibilitySourceSystem": "","primaryPolicyNumber": "","sharedArrangementId": "","obligorId": "","logoIndicator": "","fontIndicator": "","planCode": "","benefitPackageCode": "014","regionCode": "","ipaCode": "","panelCode": "","source": "AK"},"providerInfo": {"productCode": "","panelNumber": "","ipa": "","sourceSystem": "","firstInitial": "S","lastName": "MITRA","mpin": ""},"originatorInfo": {"originatorMPIN": "000000000000","originatorTIN": "000000000","originatorSuffix": "00000","originatorId": "JR2"},"otherInfo": {"agencyName": "","agencyTaxId": "","agencyUniqueId": "00000000000"},"serviceRequest": {"srProductType": "","srType": "","srSubType": ""}},{"issueId": "D00860742040426","reasonCode": "","statusCode": "H","status": "HOLD","contactMethodCode": "W","contactMethodDescription": "WALK-IN","originatorTypeCode": "EM","originatorTypeDescription": "MEMBER","originatedDate": "2020-03-26","originatedTime": "07:42:00","comment": "BE LOST).","updateDate": "2020-03-26","associateName": {"firstName": "JAMAL","lastName": "ROYSTER"},"businessSegmentName": "","subReasonText": "","complaintCategoryText": "","reasonCategory": "","followupStatusCode": "","followupStatusDescription": "NONE","followupPurposeCode": "","claimNumber": "","claimAuthorization": "","claimServiceDate": "","claimCount": "00","hippa": "","extrClaimNumber": "","extrSubscriberId": "","origOfficeNumber": "673","ownerOfficeId": "673","ownerDepartmentCode": "SYS","memberInfo": {"dependentName": {"firstName": "JACK","lastName": ""},"groupNumber": "000000000","groupName": "UHC","product": "","memberNumber": "123456789","policy": "12345","alternateId": "123456789","eligibilitySourceSystem": "","primaryPolicyNumber": "","sharedArrangementId": "","obligorId": "","logoIndicator": "","fontIndicator": "","planCode": "","benefitPackageCode": "014","regionCode": "","ipaCode": "","panelCode": "","source": "AK"},"providerInfo": {"productCode": "","panelNumber": "","ipa": "","sourceSystem": "","firstInitial": "S","lastName": "MITRA","mpin": ""},"originatorInfo": {"originatorMPIN": "000000000000","originatorTIN": "000000000","originatorSuffix": "00000","originatorId": "JR2"},"otherInfo": {"agencyName": "","agencyTaxId": "","agencyUniqueId": "00000000000"},"serviceRequest": {"srProductType": "","srType": "","srSubType": ""}}],"alertsList": [],"pagingState": {"moreData": false}}}}');

        Test.setContinuationResponse('continuation-1', orsResponse);
        Test.setContinuationResponse('continuation-2', claimDetResponse);

        ACET_ServiceRequestDetailCtrl.ServiceRequestsWrapper state = new ACET_ServiceRequestDetailCtrl.ServiceRequestsWrapper();
        state.issueId = 'D00860744188246';
        state.claimWsCallOutFW = claimWsCallOutFW;

        List < String > labels = new List < String > {
            'continuation-1',
            'continuation-2'
        };
        Object result = ACET_ServiceRequestDetailCtrl.processInitialResponse(labels, state);

        Test.setMock(HttpCalloutMock.class, new SAEHttpCalloutMock.SAEClaimActWebServiceMock());
        ACET_WebserviceCalloutFramework claimActCallOutFW = new ACET_WebserviceCalloutFramework();
        claimActCallOutFW.serviceName = 'LinkClaimAction';
        Map < String, String > claimRequestParamsMap = new Map < String, String > ();
        claimRequestParamsMap.put('q', 'test');
        claimActCallOutFW.requestParamsMap = claimRequestParamsMap;
        HttpResponse claimActResponse = claimActCallOutFW.getResponse();
        Test.stopTest();

        Test.setContinuationResponse('continuation-3', claimActResponse);
        labels = new List < String > ();
        labels.add('continuation-3');
        state.claimActCallOutFW = claimActCallOutFW;
        Object result1 = ACET_ServiceRequestDetailCtrl.processChainedResponse(labels, state);
    }

    @isTest static void testGetORSIssueDetails() {

        List < ISL_Webservice_Config__c > wsConfigs = new List < ISL_Webservice_Config__c > ();
        wsConfigs.add(new ISL_Webservice_Config__c(Name = 'SNIAPIAccessToken', Value__c = 'zwdsk9VPXJASohgqS2zqXD0UxD9MEa5g'));
        wsConfigs.add(new ISL_Webservice_Config__c(Name = 'dev_ORSReadIssue', Value__c = 'https://gateway-stage.optum.com/api/STAGE/cdm/constmgmt/eaipxdomain-rid/issues/v1/Read'));
        wsConfigs.add(new ISL_Webservice_Config__c(Name = 'dev_ORSReadIssueMicroService', Value__c = 'https://gateway-stage.optum.com/api/STAGE/cdm/constmgmt/eaipxdomain-rid/issues/v1/Read'));
        wsConfigs.add(new ISL_Webservice_Config__c(Name = 'dev_ORSEAIPToken', Value__c = 'zwdsk9VPXJASohgqS2zqXD0UxD9MEa5g'));
        wsConfigs.add(new ISL_Webservice_Config__c(Name = 'EAIPLoginFlowHeaderAccept', Value__c = 'application/json'));
        wsConfigs.add(new ISL_Webservice_Config__c(Name = 'EAIPLoginFlowHttpHeaderActor', Value__c = 'ACET'));
        wsConfigs.add(new ISL_Webservice_Config__c(Name = 'EAIPLoginFlowHttpHeaderContentType', Value__c = 'application/json'));
        wsConfigs.add(new ISL_Webservice_Config__c(Name = 'EAIPLoginFlowHttpMethod', Value__c = 'EAIPLoginFlowHttpMethod'));
        Insert wsConfigs;

        Test.startTest();
        StaticResource responseJSON = [SELECT Body FROM StaticResource WHERE Name = 'ACET_ORSReadIssueMockResponse'];
        Test.setMock(HttpCalloutMock.class, new ACET_ORSMockResponse(responseJSON.Body.toString(), 200));
        ACET_ServiceRequestDetailCtrl.getORSIssueDetails('123456789456', 'FACETS', ' ');
        ACET_ServiceRequestDetailCtrl.getORSIssueDetails('123456789456', '', ' ');
        string str = ACET_ServiceRequestDetailCtrl.getRequestBody('logon', 'logoffice', '123456789456');
        ACET_ORSReadIssueRequestWrapper.parse(str);
        ACET_ORSWebservice.assignOrRouteIssue('123');
        ACET_ORSWebservice.insertClaimAdjustments('123');
        ACET_ORSWebservice.reopenIssue('123');
        Test.stopTest();
    }

    // Test ORS Comments
    @isTest static void Test_UpdateCaseComments() {
		List < ISL_Webservice_Config__c > wsConfigs = new List < ISL_Webservice_Config__c > ();
		wsConfigs.add(new ISL_Webservice_Config__c(Name = 'SNIAPIAccessToken', Value__c = 'zwdsk9VPXJASohgqS2zqXD0UxD9MEa5g'));
		wsConfigs.add(new ISL_Webservice_Config__c(Name = 'dev_ORSReadIssue', Value__c = 'https://gateway-stage.optum.com/api/STAGE/cdm/constmgmt/eaipxdomain-rid/issues/v1/Read'));
		wsConfigs.add(new ISL_Webservice_Config__c(Name = 'dev_ORSReadIssueMicroService', Value__c = 'https://gateway-stage.optum.com/api/STAGE/cdm/constmgmt/eaipxdomain-rid/issues/v1/Read'));
		wsConfigs.add(new ISL_Webservice_Config__c(Name = 'dev_ORSSelectIssue', Value__c = 'https://gateway-stage.optum.com/api/STAGE/cdm/constmgmt/eaipxdomain-rid/issues/v1/Read'));
		wsConfigs.add(new ISL_Webservice_Config__c(Name = 'dev_ORSCreateORSIssue', Value__c = 'https://gateway-stage.optum.com/api/STAGE/cdm/constmgmt/eaipxdomain-rid/issues/v1/Read'));
		wsConfigs.add(new ISL_Webservice_Config__c(Name = 'dev_ORSEAIPToken', Value__c = 'zwdsk9VPXJASohgqS2zqXD0UxD9MEa5g'));
		wsConfigs.add(new ISL_Webservice_Config__c(Name = 'EAIPLoginFlowHeaderAccept', Value__c = 'application/json'));
		wsConfigs.add(new ISL_Webservice_Config__c(Name = 'EAIPLoginFlowHttpHeaderActor', Value__c = 'ACET'));
		wsConfigs.add(new ISL_Webservice_Config__c(Name = 'EAIPLoginFlowHttpHeaderContentType', Value__c = 'application/json'));
		wsConfigs.add(new ISL_Webservice_Config__c(Name = 'EAIPLoginFlowHttpMethod', Value__c = 'EAIPLoginFlowHttpMethod'));
        wsConfigs.add(new ISL_Webservice_Config__c(Name = 'dev_ORSUpdateIssueMicroService', Value__c = 'EAIPLoginFlowHttpMethod'));
		Insert wsConfigs;

		Case caseInsert = new Case();
		caseInsert.Caller__c = 'Test Caller';
		insert caseInsert;

		CaseComment cc = new CaseComment();
		cc.ParentId = caseInsert.id;
		insert cc;

		Test.startTest();
		StaticResource responseJSON = [SELECT Body FROM StaticResource WHERE Name = 'ACET_SelectIssueMockResponse'];
		Test.setMock(HttpCalloutMock.class, new ACET_ORSMockResponse(responseJSON.Body.toString(), 200));

		String comment = 'this is a test comment this is a test comment this is a test comment this is a test comment this is a test comment';

		// US2101461 - Thanish - 23rd Jun 2020 - Error Code Handling ...
		List < ACET_CaseCommentsController.UpdateCaseCommentsWrapper > returnIdList = ACET_CaseCommentsController.updateORSCaseComments(caseInsert.Id, comment);

		List < ACET_CaseCommentsController.CaseCommentWrapper > cw = ACET_CaseCommentsController.getCaseComments(caseInsert.Id);

		ACET_CaseCommentsController.feedback fb = ACET_CaseCommentsController.insertCaseComments(caseInsert.Id, 'just a comment', true);

		Test.stopTest();

	}

    @isTest static void Test_ORSonlyComments() {
        ACET_TestDataFactory.createWebServiceSetting('dev_ORSSelectIssue', 'dev_ORSSelectIssue');
        ACET_TestDataFactory.createWebServiceSetting('SNIAPIAccessToken', 'SNIAPIAccessToken');
        ACET_TestDataFactory.createWebServiceSetting('dev_ORSUpdateIssueMicroService', 'dev_ORSUpdateIssueMicroService');
        Case caseInsert = new Case();
        caseInsert.Caller__c = 'Test Caller';
        insert caseInsert;
        Cache.Session.put('local.TOPSProfileInfo.userId', '12312321' + '/' + '123123', 28800, Cache.Visibility.ALL, true);
        Test.startTest();
        StaticResource responseJSON = [SELECT Body FROM StaticResource WHERE Name = 'ACET_SelectIssueMockResponse'];
        Test.setMock(HttpCalloutMock.class, new ACET_ORSMockResponse(responseJSON.Body.toString(), 200));
        String comment = 'this is a test comment this is a test comment this is a test comment this is a test comment this is a test commentt this test comment test';

        ACET_CaseCommentsController.feedback fb = ACET_ServiceRequestDetailCtrl.insertCaseComments(caseInsert.Id, 'just a comment', true);
        List < ACET_CaseCommentsController.UpdateCaseCommentsWrapper > retList = ACET_ServiceRequestDetailCtrl.updateORSCaseComments(caseInsert.Id, comment);
        List < ACET_CaseCommentsController.UpdateCaseCommentsWrapper > retList2 = ACET_ServiceRequestDetailCtrl.updateOnlyORSCaseComments('D12312312', comment, 'P', 'test', 'test');
        HttpResponse response400 = new HttpResponse();
        response400.setStatusCode(400);
        List < ACET_CaseCommentsController.UpdateCaseCommentsWrapper > retList3 = ACET_ServiceRequestDetailCtrl.proceeUpdateResponseCallout(response400);
        HttpResponse response200 = new HttpResponse();
        response200.setStatusCode(200);
        List < ACET_CaseCommentsController.UpdateCaseCommentsWrapper > retList4 = ACET_ServiceRequestDetailCtrl.proceeUpdateResponseCallout(response200);
        HttpResponse response404 = new HttpResponse();
        response404.setStatusCode(404);
        List < ACET_CaseCommentsController.UpdateCaseCommentsWrapper > retList5 = ACET_ServiceRequestDetailCtrl.proceeUpdateResponseCallout(response404);
        HttpResponse response500 = new HttpResponse();
        response500.setStatusCode(500);
        List < ACET_CaseCommentsController.UpdateCaseCommentsWrapper > retList6 = ACET_ServiceRequestDetailCtrl.proceeUpdateResponseCallout(response500);
        HttpResponse response501 = new HttpResponse();
        response501.setStatusCode(501);
        List < ACET_CaseCommentsController.UpdateCaseCommentsWrapper > retList7 = ACET_ServiceRequestDetailCtrl.proceeUpdateResponseCallout(response501);

        Test.stopTest();
    }
}