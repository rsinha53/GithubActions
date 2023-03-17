@isTest
public class ACET_FACETSServiceRequest_Test{
    
    @testSetup static void createTestData() {
        
        TestDataFactory.createInteraction();
        List<ISL_Webservice_Config__c> lstofWebServiceConfigs = new List<ISL_Webservice_Config__c>();
        lstofWebServiceConfigs.add(new ISL_Webservice_Config__c(Name='dev_FacetsCreateRecord',Value__c = 'https://api-gateway-stage.linkhealth.com/rlink-extended/api'));
        lstofWebServiceConfigs.add(new ISL_Webservice_Config__c(Name='dev_FacetsGetCases',Value__c = 'https://api-gateway-stage.linkhealth.com/rlink-extended/api'));
        lstofWebServiceConfigs.add(new ISL_Webservice_Config__c(Name='SNIAPIAccessToken',Value__c = 'https://api-gateway-stage.linkhealth.com/rlink-extended/api'));
        insert lstofWebServiceConfigs;
        Organization_Properties__c orgProps = Organization_Properties__c.getOrgDefaults();
        orgProps.OrganizationName__c = 'QA';
        Upsert orgProps;
        // Token API data
        WebserviceConfigurations__c tokenAPIWSConfig = ACET_WebserviceCalloutFramework_Test.createTokenWSConfigs('StarGateTokenAPI');
        OrgSpecificConfigurations__c tokenAPIOrgSpecificConfigs = ACET_WebserviceCalloutFramework_Test.createTokenOrgWSConfigs(tokenAPIWSConfig.Id);
        //WebserviceConfigurations__c authTokenWSConfig = ACET_WebserviceCalloutFramework_Test.createAuthTokenWSConfig('StarGateTokenAPI');
        
        // Service API data
        WebserviceConfigurations__c wsConfig = ACET_WebserviceCalloutFramework_Test.createWSConfig('FacetsGetCases', tokenAPIWSConfig.Id);
        OrgSpecificConfigurations__c orgSpecificConfigs = ACET_WebserviceCalloutFramework_Test.createOrgWSConfigs(wsConfig.Id);
        
        WebserviceConfigurations__c wsConfig2 = ACET_WebserviceCalloutFramework_Test.createWSConfig('FacetsCreateRecord', tokenAPIWSConfig.Id);
        OrgSpecificConfigurations__c orgSpecificConfigs2 = ACET_WebserviceCalloutFramework_Test.createOrgWSConfigs(wsConfig2.Id);
        //US3182780
        WebserviceConfigurations__c wsConfig3 = ACET_WebserviceCalloutFramework_Test.createWSConfig('MACESSCaseCreation', tokenAPIWSConfig.Id);
        OrgSpecificConfigurations__c orgSpecificConfigs3 = ACET_WebserviceCalloutFramework_Test.createOrgWSConfigs(wsConfig3.Id);
         //US3433074
        WebserviceConfigurations__c wsConfig4 = ACET_WebserviceCalloutFramework_Test.createWSConfig('FacetsUpdateRecord', tokenAPIWSConfig.Id);
        OrgSpecificConfigurations__c orgSpecificConfigs4 = ACET_WebserviceCalloutFramework_Test.createOrgWSConfigs(wsConfig4.Id);
    }
    
    public static testMethod void testFACETSServiceRequest(){    
        
        ACET_FACETSServiceRequest.Tasks tRef = new ACET_FACETSServiceRequest.Tasks();
        tRef.seqNo = '';
        tRef.customerId = '';
        
        ACET_FACETSServiceRequest.CodeDesc cDesc = new ACET_FACETSServiceRequest.CodeDesc();
        cDesc.code = '';
        cDesc.description = '';
        
        tRef.customerType = cDesc;
        tRef.compliantIndicator = '';
        tRef.inputInd = cDesc;
        tRef.categoryCode = cDesc;
        tRef.proofOfClosureCode = cDesc;
        tRef.priorityCode = cDesc;
        tRef.statusReasonCode = cDesc;
        tRef.subjectCode = cDesc;
        tRef.nextReviewInterval = '';
        tRef.statusCode = cDesc;
        tRef.summaryText = '';
        tRef.noteType = cDesc;
        tRef.noteText = '';
        tRef.pageType = '';
        tRef.providerId = '';
        tRef.subscriberId = '';
        tRef.familyLinkId = '';
        tRef.primaryUserId = '';
        
        
        ACET_FACETSServiceRequest.ContactInfo contRef = new ACET_FACETSServiceRequest.ContactInfo();
        contRef.contactType = '';
        contRef.address1 = '';
        contRef.address2 = '';
        contRef.address3 = '';
        contRef.city = '';
        contRef.state = '';
        contRef.zip = '';
        contRef.county = '';
        contRef.countryCode = '';
        contRef.phone = '';
        contRef.phoneExt = '';
        contRef.fax = '';
        contRef.faxExt = '';
        contRef.emailAddress = '';
        
        ACET_FACETSServiceRequest.CallerType callTypeRef = new ACET_FACETSServiceRequest.CallerType();
        callTypeRef.code = '';
        
        ACET_FACETSServiceRequest.CallerName callerRef = new ACET_FACETSServiceRequest.CallerName();
        callerRef.firstName = ''; 
        callerRef.lastName  = '';
        callerRef.title  = '';
        callerRef.middleInit  = '';        
        
        ACET_FACETSServiceRequest.CustomerServiceRecord custRef = new ACET_FACETSServiceRequest.CustomerServiceRecord();
        custRef.callerType = callTypeRef;
        custRef.inquiryMethod = callTypeRef;
        custRef.satisfactionLevel = callTypeRef;
        custRef.disclaimerInd = '';
        custRef.callerResponse = '';
        custRef.callerName = callerRef;
        custRef.languageCode = '';
        custRef.relationship = '';
        custRef.idNumber = '';
        custRef.contactInfo = contRef;
        custRef.tasks = new List<ACET_FACETSServiceRequest.Tasks>();
    }
    
    public static testmethod void testFacetsWebserviceProcessFacetsRecord(){
        List<Interaction__c> lstInteractions = [SELECT Id FROM Interaction__c LIMIT 2];
        Case caseRec = new Case(Status = 'Open');
        Insert caseRec;
        String caseString = '{"providerNotFound":false,"noProviderToSearch":true,"isOtherSearch":false,"Interaction":"'+lstInteractions[0].Id+'","OriginatorName":"undefined undefined","OriginatorType":"Provider","OriginatorRelationship":"Provider","OriginatorContactName":"rythjthjtyj","OriginatorPhone":"0112223334","OriginatorEmail":"example@abc.com","SubjectName":"AMANDA ADAM","SubjectDOB":"06/08/1977","SubjectType":"Member","SubjectId":"956876492","SubjectGroupId":"706577","AddInfoTopic":"View Member Eligibility","Status":"Closed","AddInfoOrginSubType":"Verify Eligibility","AddInfoOrginType":"Issue Resolved","AutoDoc":"<div></div>","AutoDocCaseItems":"caseitem1::caseitem1|caseitem2::caseitem2"}';
        String caseString2 = '{"providerNotFound":false,"noProviderToSearch":false,"isOtherSearch":false,"Interaction":"'+lstInteractions[0].Id+'","OriginatorName":"undefined undefined","OriginatorType":"Provider","OriginatorRelationship":"Provider","OriginatorContactName":"rythjthjty dfsj","OriginatorPhone":"0112223334","OriginatorEmail":"example@abc.com","SubjectName":"AMANDA ADAM","SubjectDOB":"06/08/1977","SubjectType":"Member","SubjectId":"956876492","SubjectGroupId":"706577","AddInfoTopic":"View Member Eligibility","Status":"Closed","AddInfoOrginSubType":"Verify Eligibility","AddInfoOrginType":"Issue Resolved","AutoDoc":"<div></div>","AutoDocCaseItems":"caseitem1::caseitem1|caseitem2::caseitem2"}';
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new ACET_ViewPCPReferralMockResponse(400,true));
        ACET_FacetsWebservice.ProcessFacetsRecord(caseString,caseRec.id);
        Test.setMock(HttpCalloutMock.class, new SAEHttpCalloutMock.CAndScontractsSuccessResponse());
        ACET_FacetsWebservice.ProcessFacetsRecord(caseString2,caseRec.id);
        ACET_FacetsWebservice.fetchFacetsCases('12312312','12312312','12312312',0);
        Test.setMock(HttpCalloutMock.class, new SAEHttpCalloutMock.facetsCreateService200());
        ACET_FacetsWebservice.ProcessFacetsRecord(caseString,caseRec.id);
        Test.setMock(HttpCalloutMock.class, new SAEHttpCalloutMock.facetsGetService200());
        ACET_FacetsWebservice.fetchFacetsCases('12312312','12312312','12312312',0);
        Test.stopTest();
    }
    //US3433074
    public static testmethod void testUpdateFacetCases(){
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new ACET_ViewPCPReferralMockResponse(204,false));
         ACET_ServiceRequestDetailCtrl.insertFacetsComments('test','21G000001483');
         Test.setMock(HttpCalloutMock.class, new ACET_ViewPCPReferralMockResponse(500,false));
         ACET_ServiceRequestDetailCtrl.insertFacetsComments('test','21G000001483');
        ACET_ServiceRequestDetailCtrl.getORSIssueDetails('123456789456', 'FACETS', ' ');
        Test.setMock(HttpCalloutMock.class, new ACET_ViewPCPReferralMockResponse(400,false));
         ACET_ServiceRequestDetailCtrl.insertFacetsComments('test','21G000001483');
        ACET_ServiceRequestDetailCtrl.getORSIssueDetails('123456789456', 'FACETS', ' ');
         Test.setMock(HttpCalloutMock.class, new ACET_ViewPCPReferralMockResponse(404,false));
         ACET_ServiceRequestDetailCtrl.insertFacetsComments('test','21G000001483');
        ACET_ServiceRequestDetailCtrl.getORSIssueDetails('123456789456', 'FACETS', ' ');
         Test.setMock(HttpCalloutMock.class, new ACET_ViewPCPReferralMockResponse(999,false));
         ACET_ServiceRequestDetailCtrl.insertFacetsComments('test','21G000001483');
        ACET_ServiceRequestDetailCtrl.getORSIssueDetails('123456789456', 'FACETS', ' ');

        Test.stopTest();
    }

    public static testmethod void testgetFacetsCases(){
        List<Interaction__c> lstInteractions = [SELECT Id FROM Interaction__c LIMIT 2];
        Case caseRec = new Case(Status = 'Open');
        Insert caseRec;
        String caseString = '{"providerNotFound":false,"noProviderToSearch":true,"isOtherSearch":false,"Interaction":"'+lstInteractions[0].Id+'","OriginatorName":"undefined undefined","OriginatorType":"Provider","OriginatorRelationship":"Provider","OriginatorContactName":"rythjthjtyj","OriginatorPhone":"0112223334","OriginatorEmail":"example@abc.com","SubjectName":"AMANDA ADAM","SubjectDOB":"06/08/1977","SubjectType":"Member","SubjectId":"956876492","SubjectGroupId":"706577","AddInfoTopic":"View Member Eligibility","Status":"Closed","AddInfoOrginSubType":"Verify Eligibility","AddInfoOrginType":"Issue Resolved","AutoDoc":"<div></div>","AutoDocCaseItems":"caseitem1::caseitem1|caseitem2::caseitem2"}';
        String caseString2 = '{"providerNotFound":false,"strFacetsRoutingComments":"testcom",OriginatorFirstName":"test","ttsSubType":"test","ttsType":"test","OriginatorLastName":"test","contactNumber":"1231231","strMemberId":"12312312","contactExt":"1231231","noProviderToSearch":false,"isOtherSearch":false,"Interaction":"'+lstInteractions[0].Id+'","OriginatorName":"undefined undefined","OriginatorType":"Provider","OriginatorRelationship":"Provider","OriginatorContactName":"rythjthjty dfsj","OriginatorPhone":"0112223334","OriginatorEmail":"example@abc.com","SubjectName":"AMANDA ADAM","SubjectDOB":"06/08/1977","SubjectType":"Member","SubjectId":"956876492","SubjectGroupId":"706577","AddInfoTopic":"View Member Eligibility","Status":"Closed","AddInfoOrginSubType":"Verify Eligibility","AddInfoOrginType":"Issue Resolved","AutoDoc":"<div></div>","AutoDocCaseItems":"caseitem1::caseitem1|caseitem2::caseitem2"}';
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new SAEHttpCalloutMock.facetsGetService200());
        ACET_FacetsWebservice.fetchFacetsCases('12312312','12312312','12312312',0);
        ACET_ServiceRequestDetailCtrl.getORSIssueDetails('123456789456', 'FACETS', ' ');

        Test.setMock(HttpCalloutMock.class, new SAEHttpCalloutMock.facetsCreateService200());
        ACET_FacetsWebservice.ProcessFacetsRecord(caseString2,caseRec.id);
        
        Test.stopTest();
    }
    //US3182780
    @isTest
    static void createMACESSCreationRecord(){
        Case caseRec = new Case(Status = 'Open');
        Insert caseRec;
        Test.startTest();

        ACET_MACESSCreateReq req = new ACET_MACESSCreateReq();
        req.subscriberId = '117391314';
        req.providerId = '001146131101';
        req.contactFirstName = 'karl';
        req.contactLastName = 'cobTester';
        req.contactMiddleName = 'KK';
        req.phone ='999-999-9123';
        req.email = 'test@test.com';
        req.subject = 'COB Request';
        req.requestSources = '3';
        req.maccessUserAccountInformation = 'kponnus3';
        req.facetsTracking = '21G001870966';
        req.spireTrackingNum = 'ST12345';
        req.contactorType = 'M';
        req.relatedState = 'HIDSNP';
        req.cobRequestCheckbox = 'TRUE';
        req.cobRequestOption = 'L';
        req.comments = 'update enrollment test 2';
        string reqBody = JSON.serialize(req);
        // For other than 201
        Test.setMock(HttpCalloutMock.class, new ACET_ViewPCPReferralMockResponse(400,true));
        ACET_MACESSWebService.createMACESSCase(reqBody,caseRec.id,'21G001870966');
        //SAECaseCreationController.createMACESSCreationRecord(reqBody,caseRec.id);
        // For Success 201
        Test.setMock(HttpCalloutMock.class, new SAEHttpCalloutMock.MACESSUpdateService201());
        ACET_MACESSWebService.createMACESSCase(reqBody,caseRec.id,'21G001870966');
        // For Exception
        Test.setMock(HttpCalloutMock.class, new ACET_ViewPCPReferralMockResponse(500,true));
        ACET_MACESSWebService.createMACESSCase(reqBody,caseRec.id,'21G001870966');

        Test.stopTest();

    }
    //US3182780
     @isTest
    static void callMacessTest(){
        List<Interaction__c> lstInteractions = [SELECT Id FROM Interaction__c LIMIT 2];
        Case caseRec = new Case(Status = 'Open');
        Insert caseRec;
        String caseString2 = '{"providerNotFound":false,"noProviderToSearch":false,"isOtherSearch":false,"Interaction":"'+lstInteractions[0].Id+'","OriginatorName":"undefined undefined","OriginatorType":"Provider","OriginatorRelationship":"Provider","OriginatorContactName":"rythjthjty dfsj","OriginatorPhone":"0112223334","OriginatorEmail":"example@abc.com","SubjectName":"AMANDA ADAM","SubjectDOB":"06/08/1977","SubjectType":"Member","SubjectId":"956876492","SubjectGroupId":"706577","AddInfoTopic":"View Member Eligibility","Status":"Closed","AddInfoOrginSubType":"Verify Eligibility","AddInfoOrginType":"Issue Resolved","AutoDoc":"<div></div>","AutoDocCaseItems":"caseitem1::caseitem1|caseitem2::caseitem2"}';
        Test.startTest();

        Test.setMock(HttpCalloutMock.class, new SAEHttpCalloutMock.MACESSUpdateService201());
        ACET_FacetsWebservice.callMacess(caseString2,'231231231',caseRec.id);
         Test.setMock(HttpCalloutMock.class, new ACET_ViewPCPReferralMockResponse(999,false));
        ACET_FacetsWebservice.callMacess(caseString2,'231231231',caseRec.id);
        Test.stopTest();

    }

    /*@isTest
    static void updateMACESSCase(){
        Case caseRec = new Case(Status = 'Open');
        Insert caseRec;
        Test.startTest();

        ACET_MACESSUpdateReq msreq = new ACET_MACESSUpdateReq();
        msreq.contactFirstName = 'praveen';
        msreq.contactLastName = 'cr';
        msreq.contactMiddleName = 'r';
        msreq.maccessUserAccountInformation = 'rkuma430';
        msreq.comments = 'Test Macess';
        msreq.spireTrackingNum = 'SF12345';
        msreq.adjustmentNum = 'SF20210113754555555';

        string reqBody = JSON.serialize(msreq);
        // For other than 201
        Test.setMock(HttpCalloutMock.class, new ACET_ViewPCPReferralMockResponse(400,true));
        ACET_MACESSWebService.updateMACESSCase(reqBody,caseRec.id);
        // For Success 201
        Test.setMock(HttpCalloutMock.class, new SAEHttpCalloutMock.MACESSCreateService201());
         ACET_MACESSWebService.updateMACESSCase(reqBody,caseRec.id);
        // For Exception
        Test.setMock(HttpCalloutMock.class, new ACET_ViewPCPReferralMockResponse(500,true));
         ACET_MACESSWebService.updateMACESSCase(reqBody,caseRec.id);

        Test.stopTest();

    }*/
}