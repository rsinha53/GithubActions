@isTest
public class SAEMemberProviderDetailTest {
    
    @testSetup static void setup() {
        
        ISL_Webservice_Config__c configObj = SAETestDataFactory.insertISLWebserviceConfig(
            SAEConstants.SAE_POLICYSEARCH_NAME,
            SAEConstants.SAE_POLICYSEARCH_COMMON_NAME,
            SAEConstants.SAE_POLICYSEARCH_ERRORLOG_ENABLED,
            SAEConstants.SAE_POLICYSEARCH_ISAVAILABLE,
            SAEConstants.SAE_POLICYSEARCH_ISLWEBSERVICE_EID,
            SAEConstants.SAE_POLICYSEARCH_PAGESIZE,
            SAEConstants.SAE_POLICYSEARCH_SCOPEHEADER_FLAG,
            SAEConstants.SAE_POLICYSEARCH_SERVICENAME,
            SAEConstants.SAE_POLICYSEARCH_VALUE
        );
        System.assertNotEquals(configObj, null);
        configObj = SAETestDataFactory.insertISLWebserviceConfig(
            SAEConstants.SAE_MEMBERPROVIDER_NAME,
            SAEConstants.SAE_POLICYSEARCH_COMMON_NAME,
            SAEConstants.SAE_POLICYSEARCH_ERRORLOG_ENABLED,
            SAEConstants.SAE_POLICYSEARCH_ISAVAILABLE,
            SAEConstants.SAE_POLICYSEARCH_ISLWEBSERVICE_EID,
            SAEConstants.SAE_POLICYSEARCH_PAGESIZE,
            !SAEConstants.SAE_POLICYSEARCH_SCOPEHEADER_FLAG,
            SAEConstants.SAE_MEMBERPROVIDER_SERVICENAME,
            SAEConstants.SAE_MEMBERPROVIDER_VALUE
        );
        System.assertNotEquals(configObj, null);
        
        Organization_Properties__c orgProp = new Organization_Properties__c();
        orgProp.OrganizationName__c = 'aerosmith';
        orgProp.SetupOwnerId=UserInfo.getOrganizationId();
        insert orgProp;                 
        
        WebserviceConfigurations__c  webConifTokenApi = new WebserviceConfigurations__c ();
        webConifTokenApi.EndpointPath__c = '/oauth/token';
        webConifTokenApi.GrantType__c  = 'client_credentials';
        webConifTokenApi.Headers__c  = '[{"key":"Content-Type","value":"application/x-www-form-urlencoded"}]';
        webConifTokenApi.JSONBodyWithMergeFields__c  = '';
        webConifTokenApi.Method__c  = 'POST';
        webConifTokenApi.Name  = 'LinkServiceTokenAPI';
        //Id RecordTypeId = Schema.SObjectType.WebserviceConfigurations__c.getRecordTypeInfosByName().get('Token_API').getRecordTypeId();
        RecordType recTypeTokenAPI = [SELECT Id FROM RecordType WHERE DeveloperName = 'Token_API' and SObjectType = 'WebserviceConfigurations__c'];
        webConifTokenApi.RecordTypeId  = recTypeTokenAPI.Id;
        insert webConifTokenApi;
        
        OrgSpecificConfigurations__c orgSpecTokenAPI = new OrgSpecificConfigurations__c();
        //Id RecordTypeId = Schema.SObjectType.OrgSpecificConfigurations__c.getRecordTypeInfosByName().get('TokenAPI').getRecordTypeId(); 
        RecordType recTypeOrgTokenAPI = [SELECT Id FROM RecordType WHERE DeveloperName = 'TokenAPI' and SObjectType = 'OrgSpecificConfigurations__c'];
        orgSpecTokenAPI.RecordTypeId  = recTypeOrgTokenAPI.Id;
        orgSpecTokenAPI.EndpointDomain__c = 'https://api-gateway-stage.linkhealth.com';
        orgSpecTokenAPI.ClientId__c = 'test';
        orgSpecTokenAPI.ClientSecret__c = 'a723ef27-493b-4afa-2d43-43542cc87rf3';
        orgSpecTokenAPI.WebserviceConfigurations__c = webConifTokenApi.Id;
        insert orgSpecTokenAPI;             
        
        WebserviceConfigurations__c tokenRecord = new WebserviceConfigurations__c();
        tokenRecord.Name = 'LinkServiceTokenAPIToken';
        RecordType recTypeAuthTokenAPI = [SELECT Id FROM RecordType WHERE DeveloperName = 'Authorization_Token' and SObjectType = 'WebserviceConfigurations__c'];
        tokenRecord.RecordTypeId = recTypeAuthTokenAPI.Id;
        tokenRecord.AuthorizationToken__c = 'sdakhjsadkjsagdiuqwy912879182371okasbdfo123y984e1279479812hkdjasahdo12987349182ehkj';
        insert tokenRecord;
        
        WebserviceConfigurations__c  webConifServiceAPI = new WebserviceConfigurations__c ();
        webConifServiceAPI.EndpointPath__c = '/elink-services/api/eligibility/v2.0';
        webConifServiceAPI.GrantType__c  = 'client_credentials';
        webConifServiceAPI.Headers__c  = '[{"key":"Authorization","value":"Bearer <:AUTH_TOKEN:>"},{"key":"Content-Type","value":"application/json"},{"key":"actor","value":"ACET"}]';
        webConifServiceAPI.AuthorizationToken__c  = 'SELECT AuthorizationToken__c FROM WebserviceConfigurations__c WHERE Name = LinkServiceTokenAPIToken';
        webConifServiceAPI.Method__c  = 'GET';
        webConifServiceAPI.TokenAPI__c  = webConifTokenApi.id;
        webConifServiceAPI.Name  = 'LinkEligibilityMemberSearch';
        webConifServiceAPI.Timeout__c = 10000;
        RecordType recTypeWebServiceAPI = [SELECT Id FROM RecordType WHERE DeveloperName = 'Service_API' and SObjectType = 'WebserviceConfigurations__c'];
        webConifServiceAPI.RecordTypeId  = recTypeWebServiceAPI.id;
        insert webConifServiceAPI;
        
        OrgSpecificConfigurations__c orgSpecServiceAPI = new OrgSpecificConfigurations__c();
        RecordType recTypeOrgServiceAPI = [SELECT Id FROM RecordType WHERE DeveloperName = 'ServiceAPI' and SObjectType = 'OrgSpecificConfigurations__c'];
        orgSpecServiceAPI.RecordTypeId  = recTypeOrgServiceAPI.Id;
        orgSpecServiceAPI.Name = 'aerosmith';
        orgSpecServiceAPI.EndpointDomain__c = 'https://api-gateway-stage.linkhealth.com';
        orgSpecServiceAPI.EnableMock__c  = false;
        orgSpecServiceAPI.WebserviceConfigurations__c = webConifServiceAPI.Id;
        insert orgSpecServiceAPI;
        
        WebserviceConfigurations__c  webConifExtendedServiceAPI = new WebserviceConfigurations__c ();
        webConifExtendedServiceAPI.EndpointPath__c = '/elink-extended/api/coverageAttributes/v2.0';
        webConifExtendedServiceAPI.GrantType__c  = 'client_credentials';
        webConifExtendedServiceAPI.Headers__c  = '[{"key":"Authorization","value":"Bearer <:AUTH_TOKEN:>"},{"key":"Content-Type","value":"application/json"},{"key":"actor","value":"ACET"}]';
        webConifExtendedServiceAPI.AuthorizationToken__c  = 'SELECT AuthorizationToken__c FROM WebserviceConfigurations__c WHERE Name = LinkServiceTokenAPIToken';
        webConifExtendedServiceAPI.Method__c  = 'GET';
        webConifExtendedServiceAPI.TokenAPI__c  = webConifTokenApi.id;
        webConifExtendedServiceAPI.Name  = 'LinkExtendedCoverage';
        webConifExtendedServiceAPI.Timeout__c = 10000;
        RecordType recTypeWebExtendedServiceAPI = [SELECT Id FROM RecordType WHERE DeveloperName = 'Service_API' and SObjectType = 'WebserviceConfigurations__c'];
        webConifExtendedServiceAPI.RecordTypeId  = recTypeWebExtendedServiceAPI.id;
        insert webConifExtendedServiceAPI;
        
        OrgSpecificConfigurations__c orgSpecExtendedServiceAPI = new OrgSpecificConfigurations__c();
        RecordType recTypeOrgExtebdedServiceAPI = [SELECT Id FROM RecordType WHERE DeveloperName = 'ServiceAPI' and SObjectType = 'OrgSpecificConfigurations__c'];
        orgSpecExtendedServiceAPI.RecordTypeId  = recTypeOrgExtebdedServiceAPI.Id;
        orgSpecExtendedServiceAPI.Name = 'aerosmith';
        orgSpecExtendedServiceAPI.EndpointDomain__c = 'https://api-gateway-stage.linkhealth.com';
        orgSpecExtendedServiceAPI.EnableMock__c  = false;
        orgSpecExtendedServiceAPI.WebserviceConfigurations__c = webConifExtendedServiceAPI.Id;
        insert orgSpecExtendedServiceAPI;
        
       /* List<RecordType> recordType2 = new List<RecordType>([SELECT Id,Name FROM RecordType WHERE SobjectType='Case' and DeveloperName='SAE_Provider' LIMIT 1]);

        Case caseRec = new Case();
        caseRec.Subject='Test Controller Acct Case';
        caseRec.Status = 'New';
        caseRec.Origin = 'Phone';
        caseRec.recordTypeId = recordType2[0].Id;        
        INSERT caseRec; */
    }
	
    static testMethod void createPersonAccountTest() {
        Interaction__c interactionRecord = TestDataFactory.createInteraction();
        Test.startTest();
		SAEMemberProviderDetail.upsertPersonAccount('Test First', 'Test Last', '12/12/1989', '956876492', '098099', '1234567890', interactionRecord.Id, '', false, false);
        Test.stopTest();
    }
    
    static testMethod void createPersonAccountMNFTest() {
        Interaction__c interactionRecord = TestDataFactory.createInteraction();
        Test.startTest();
        SAEMemberProviderDetail.upsertPersonAccount('Test First', 'Test Last', '12/12/1989', '956876492', '098099', '1234567890', interactionRecord.Id, 'mnf', false, false);
        Test.stopTest();
    }

    static testMethod void createPersonAccountMNFisProviderSearchDisabledTest() {
        Interaction__c interactionRecord = TestDataFactory.createInteraction();
        Test.startTest();
        SAEMemberProviderDetail.upsertPersonAccount('Test First', 'Test Last', '12/12/1989', '956876492', '098099', '1234567890', interactionRecord.Id, 'mnf', true, false);
        SAEMemberProviderDetail.findMembers('956876492', '', '', '', '', '', '', 'test Provider', 'test Provider Last', '45345345', '');
        SAEMemberProviderDetail.subjectCardPopulation('956876492', '', '', '', '', '', '8226', 'test Provider', 'test Provider Last', '45345345', '', '45345345', '45345345');
        Test.stopTest();
    }
    
    @isTest static void houseHoldDataTest()
    {
        Test.startTest();        
        Test.setMock(HttpCalloutMock.class, new SAEHttpCalloutMock.SAEExtendedCoverageWSMock());
        SAEMemberProviderDetail.getHouseHoldData(SAEConstants.SAE_POLICYSEARCH_TRANSACTION_ID);
        Test.stopTest();
    }
    
    @isTest static void getCobDataTest()
    {
        Test.startTest();        
        Test.setMock(HttpCalloutMock.class, new SAEHttpCalloutMock.SAEExtendedCoverageWSMock());
        SAEMemberProviderDetail.getCobData(SAEConstants.SAE_POLICYSEARCH_TRANSACTION_ID);
        Test.stopTest();
    }
            
    static testMethod void createPersonAccountMNFisProviderSearchDisabledNotOtherTest() {
        Interaction__c interactionRecord = TestDataFactory.createInteraction();
        Test.startTest();
        Contact conRec = TestDataFactory.createContactwithEID();
        
        SAEMemberProviderDetail.upsertPersonAccount('Test First', 'Test Last', '12/12/1989', '956876492', '098099', '1234567890', interactionRecord.Id, '', true, false);
        String caseString = '{"providerNotFound":false,"noProviderToSearch":true,"isOtherSearch":false,"noMemberToSearch":false,"mnf":"","memberContactId":"","providerContactId":"","Status":"","Interaction":"'+interactionRecord.Id+'","ContactId":"'+conRec.Id+'","providerId":"","OriginatorName":"undefined undefined","OriginatorRelationship":"Provider","OriginatorType":"Provider","OriginatorPhone":"0112223334","OriginatorEmail":"example@abc.com","OriginatorContactName":"rythjthjtyj","SubjectName":"AMANDA ADAM","SubjectType":"Member","SubjectDOB":"06/08/1977","SubjectId":"956876492","SubjectGroupId":"706577","MisdirectReason":"","AddInfoTopic":"View Member Eligibility","AddInfoOrginType":"Issue Resolved","AddInfoOrginSubType":"Verify Eligibility","CommentPublic":"","CommentDesc":"","PolicyCount":"1","CaseCreationFrom":"","TaxId":"111111111","ttsType":"","ttsSubType":"","AutoDoc":"<div></div>","AutoDocCaseItems":"caseitem1::caseitem1|caseitem2::caseitem2"}';
        SAEMemberProviderDetail.postCaseWrapper(caseString);
        String caseString1 = '{"providerNotFound":true,"noProviderToSearch":false,"isOtherSearch":false,"noMemberToSearch":false,"mnf":"mnf","memberContactId":"","providerContactId":"","Status":"","Interaction":"'+interactionRecord.Id+'","ContactId":"'+conRec.Id+'","providerId":"","OriginatorName":"undefined undefined","OriginatorRelationship":"Provider","OriginatorType":"Provider","OriginatorPhone":"0112223334","OriginatorEmail":"example@abc.com","OriginatorContactName":"rythjthjtyj","SubjectName":"AMANDA ADAM","SubjectType":"Member","SubjectDOB":"06/08/1977","SubjectId":"956876492","SubjectGroupId":"706577","MisdirectReason":"","AddInfoTopic":"View Member Eligibility","AddInfoOrginType":"Issue Resolved","AddInfoOrginSubType":"Verify Eligibility","CommentPublic":"","CommentDesc":"","PolicyCount":"1","CaseCreationFrom":"","TaxId":"111111111","ttsType":"","ttsSubType":"","AutoDoc":"<div></div>","AutoDocCaseItems":"caseitem1::caseitem1|caseitem2::caseitem2"}';
        SAEMemberProviderDetail.postCaseWrapper(caseString1);
        String caseString2 = '{"providerNotFound":false,"noProviderToSearch":false,"isOtherSearch":true,"noMemberToSearch":false,"mnf":"mnf","memberContactId":"","providerContactId":"","Status":"","Interaction":"'+interactionRecord.Id+'","ContactId":"'+conRec.Id+'","providerId":"","OriginatorName":"undefined undefined","OriginatorRelationship":"Provider","OriginatorType":"Provider","OriginatorPhone":"0112223334","OriginatorEmail":"example@abc.com","OriginatorContactName":"rythjthjtyj","SubjectName":"AMANDA ADAM","SubjectType":"Member","SubjectDOB":"06/08/1977","SubjectId":"956876492","SubjectGroupId":"706577","MisdirectReason":"","AddInfoTopic":"View Member Eligibility","AddInfoOrginType":"Issue Resolved","AddInfoOrginSubType":"Verify Eligibility","CommentPublic":"","CommentDesc":"","PolicyCount":"1","CaseCreationFrom":"","TaxId":"111111111","ttsType":"","ttsSubType":"","AutoDoc":"<div></div>","AutoDocCaseItems":"caseitem1::caseitem1|caseitem2::caseitem2"}';
        SAEMemberProviderDetail.postCaseWrapper(caseString2);
        String caseString3 = '{"providerNotFound":false,"noProviderToSearch":false,"isOtherSearch":false,"noMemberToSearch":true,"mnf":"mnf","memberContactId":"","providerContactId":"","Status":"","Interaction":"'+interactionRecord.Id+'","ContactId":"'+conRec.Id+'","providerId":"","OriginatorName":"undefined undefined","OriginatorRelationship":"Provider","OriginatorType":"Provider","OriginatorPhone":"0112223334","OriginatorEmail":"example@abc.com","OriginatorContactName":"rythjthjtyj","SubjectName":"AMANDA ADAM","SubjectType":"Member","SubjectDOB":"06/08/1977","SubjectId":"956876492","SubjectGroupId":"706577","MisdirectReason":"","AddInfoTopic":"View Member Eligibility","AddInfoOrginType":"Issue Resolved","AddInfoOrginSubType":"Verify Eligibility","CommentPublic":"","CommentDesc":"","PolicyCount":"1","CaseCreationFrom":"","TaxId":"111111111","ttsType":"","ttsSubType":"","AutoDoc":"<div></div>","AutoDocCaseItems":"caseitem1::caseitem1|caseitem2::caseitem2"}';
        SAEMemberProviderDetail.postCaseWrapper(caseString3);
        SAEMemberProviderDetail.findMembers('956876492', '12/12/1989', 'Test First', 'Test Last', '098099', '', '', 'test Provider', 'test Provider Last', '45345345', '');
        SAEMemberProviderDetail.getOptumExlusions();
        SAEMemberProviderDetail.getMockStatus();

        Test.stopTest();
    }    
    
    static testMethod void createPersonAccountMNFisOtherTest() {
        Interaction__c interactionRecord = TestDataFactory.createInteraction();
        Test.startTest();
        SAEMemberProviderDetail.upsertPersonAccount('Test First', 'Test Last', '12/12/1989', '956876492', '098099', '1234567890', interactionRecord.Id, 'mnf', false, true);
        Test.stopTest();
    }
    
    static testMethod void getAllCasesmethodToggle(){        
        Test.startTest();
        SAEMemberProviderDetail.getMemberRelatedCases('956876492',true);
        Test.stopTest();
    }
    
    static testMethod void getAllCasesmethodToggleOFF(){        
        Test.startTest();
        SAEMemberProviderDetail.getMemberRelatedCases('956876492',false);
        Test.stopTest();
    }
    
    static testMethod void callEligibilityServicesTestMethod(){
        
        ACET_ProvidersearchCtrl.ProviderDetails providerDetails = new ACET_ProvidersearchCtrl.ProviderDetails();
        providerDetails.lastName = 'pln'; 
        providerDetails.taxId = '123456789';
        providerDetails.firstName = 'sdas';
        providerDetails.npi = '1234567890';
        providerDetails.isProviderNotFound = false;
        providerDetails.isNoProviderToSearch = false;
        providerDetails.isOther = false;
        providerDetails.isValidProvider = true;
        
        SAEMemberProviderDetail.MemberDetails memberDetails = new SAEMemberProviderDetail.MemberDetails();
        memberDetails.firstName = 'Mark';
        memberDetails.lastName = 'Johnson';
        memberDetails.memberDOB = '1956-11-03';
        memberDetails.payerId = '8226';
        memberDetails.isFourthCallout = false;
        
        Test.startTest();
        SAEMemberProviderDetail.callEligibilityServices(memberDetails,providerDetails);
        Test.stopTest();
    }
    
    static testMethod void getMemberDetailsTestMethod(){
        try
        {
        ACET_ProvidersearchCtrl.ProviderDetails providerDetails = new ACET_ProvidersearchCtrl.ProviderDetails();
        providerDetails.lastName = 'pln'; 
        providerDetails.taxId = '123456789';
        providerDetails.firstName = 'sdas';
        providerDetails.npi = '1234567890';
        providerDetails.isProviderNotFound = false;
        providerDetails.isNoProviderToSearch = false;
        providerDetails.isOther = false;
        providerDetails.isValidProvider = true;
         
        Test.startTest();
        SAEMemberProviderDetail.getMemberDetails('', '','1949-3-26', 'Mark', 'Johnson', '', 'NameDateOfBirth', '8226', providerDetails);
        SAEMemberProviderDetail memProvider = new SAEMemberProviderDetail();
        Continuation contin = (Continuation)SAEMemberProviderDetail.getMemberDetails('', '','1949-3-26', 'Mark', 'Johnson', '', 'NameDateOfBirth', '8226', providerDetails);
        Continuation contin1 = (Continuation)SAEMemberProviderDetail.getMemberDetails('', '','1949-3-26', 'Mark', 'Johnson', '', 'NameDateOfBirth', '8226', providerDetails);
        Continuation contin2 = (Continuation)SAEMemberProviderDetail.getMemberDetails('', '','1949-3-26', 'Mark', 'Johnson', '', 'NameDateOfBirth', '8226', providerDetails);
        HttpResponse response = new HttpResponse();
        response.setStatusCode(200);
        response.setBody(SAETestDataFactory.getStaticResourceResponse('SAEEligibilityResponseMockData'));
        Test.setContinuationResponse('continuation-1',response);
        Test.setContinuationResponse('continuation-2',response);
        Test.setContinuationResponse('continuation-3',response);
        Object result = Test.invokeContinuationMethod(memProvider, contin);
        Object result1 = Test.invokeContinuationMethod(memProvider, contin1);
        Object result2 = Test.invokeContinuationMethod(memProvider, contin2);
        Test.stopTest();
    }
        catch(exception e)
        {

        }

    }

    static testMethod void fourthCalloutMethod(){
        ACET_ProvidersearchCtrl.ProviderDetails providerDetails = new ACET_ProvidersearchCtrl.ProviderDetails();
        providerDetails.lastName = 'pln'; 
        providerDetails.taxId = '123456789';
        providerDetails.firstName = 'sdas';
        providerDetails.npi = '1234567890';
        providerDetails.isProviderNotFound = false;
        providerDetails.isNoProviderToSearch = false;
        providerDetails.isOther = false;
        providerDetails.isValidProvider = true;
        
        SAEMemberProviderDetail dateFormatInstance = new SAEMemberProviderDetail();
        dateFormatInstance.formatDate('1956-01-01');
        
        SAEMemberProviderDetail.MemberDetails memberDetails = new SAEMemberProviderDetail.MemberDetails();
        memberDetails.firstName = 'Mark';
        memberDetails.lastName = 'Johnson';
        memberDetails.memberDOB = '1956-11-03';
        memberDetails.payerId = '8226';
        memberDetails.isFourthCallout = true;
        memberDetails.memberId = '929394959';
        memberDetails.sourceCode = 'CS';

        system.debug('memberDetails@@@ ' + memberDetails);
		Test.startTest();
        //SAEMemberProviderDetail.getOneSourceLink();
        Test.setMock(HttpCalloutMock.class, new SAEHttpCalloutMock.SAEEligibilityV2Mock());
        SAEMemberProviderDetail.fourthCallout(memberDetails, providerDetails);

        Test.setMock(HttpCalloutMock.class, new SAEHttpCalloutMock.SAEEligibilityV2MockZero());
        SAEMemberProviderDetail.fourthCallout(memberDetails, providerDetails);
        Test.stopTest();
        SAEMemberProviderDetail.getOneSourceLink();
        SAEMemberProviderDetail.subjectCardPopulation('12345678', '1956-11-03', 'firstName', 'lastname', '12345', 'NameDateOfBirth', '8226', 'providerFN', 'providerLN', '123456789', '', '751281210', '751281210');

    }
    
    static testMethod void fetchDataTestMethod(){
        Continuation contin = (Continuation)SAEMemberProviderDetail.fetchData('', '','1949-3-26', 'Mark', 'Johnson', '', 'NameDateOfBirth', '8226');
        
        HttpResponse response = new HttpResponse();
        response.setStatusCode(200);
        response.setBody(SAETestDataFactory.getStaticResourceResponse('SAEEligibilityResponseMockData'));
        Test.setContinuationResponse('continuation-1',response);
        Test.setContinuationResponse('continuation-2',response);
    }
    
  static testMethod void mockDataTestMethod(){
        ACET_ProvidersearchCtrl.ProviderDetails providerDetails = new ACET_ProvidersearchCtrl.ProviderDetails();
        providerDetails.lastName = 'pln'; 
        providerDetails.taxId = '123456789';
        providerDetails.firstName = 'sdas';
        providerDetails.npi = '1234567890';
        providerDetails.isProviderNotFound = false;
        providerDetails.isNoProviderToSearch = false;
        providerDetails.isOther = false;
        providerDetails.isValidProvider = true;
        
        SAEMemberProviderDetail dateFormatInstance = new SAEMemberProviderDetail();
        dateFormatInstance.formatDate('1956-01-01');
        
        SAEMemberProviderDetail.MemberDetails memberDetails = new SAEMemberProviderDetail.MemberDetails();
        memberDetails.firstName = 'Mark';
        memberDetails.lastName = 'Johnson';
        memberDetails.memberDOB = '1956-11-03';
        memberDetails.payerId = '8226';
        memberDetails.isFourthCallout = true;
        memberDetails.memberId = '929394959';
        
        system.debug('memberDetails@@@ ' + memberDetails);
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new SAEHttpCalloutMock.SAEEligibilityV2Mock());
        SAEMemberProviderDetail.getElibilityMockData(memberDetails, providerDetails);
        Test.stopTest();
    }
    
    static testMethod void mockDataTestMethodOldVersion(){
        ACET_ProvidersearchCtrl.ProviderDetails providerDetails = new ACET_ProvidersearchCtrl.ProviderDetails();
        providerDetails.lastName = 'pln'; 
        providerDetails.taxId = '123456789';
        providerDetails.firstName = 'sdas';
        providerDetails.npi = '1234567890';
        providerDetails.isProviderNotFound = false;
        providerDetails.isNoProviderToSearch = false;
        providerDetails.isOther = false;
        providerDetails.isValidProvider = true;

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new SAEHttpCalloutMock.SAEEligibilityV2Mock());
        SAEMemberProviderDetail.getMockData('', '', '1960-01-02', 'Caleb', 'Galleco', '', 'NameDateOfBirth', '8226', providerDetails);
        
		Test.stopTest();
    }
    
    static testMethod void MemberIDNameGroupNumberDateOfBirthTest(){
        ACET_ProvidersearchCtrl.ProviderDetails providerDetails = new ACET_ProvidersearchCtrl.ProviderDetails();
        providerDetails.lastName = 'pln'; 
        providerDetails.taxId = '123456789';
        providerDetails.firstName = 'sdas';
        providerDetails.npi = '1234567890';
        providerDetails.isProviderNotFound = false;
        providerDetails.isNoProviderToSearch = false;
        providerDetails.isOther = false;
        providerDetails.isValidProvider = true;
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new SAEHttpCalloutMock.SAEEligibilityV2Mock());
        SAEMemberProviderDetail.getMockData('', '929394959', '1960-01-0', 'CALEB', 'GALLECO', '523119', 'MemberIDNameGroupNumberDateOfBirth', '8226', providerDetails);
        Test.stopTest();
    }
    
   static testMethod void MemberIDNameDateOfBirthTest(){
        ACET_ProvidersearchCtrl.ProviderDetails providerDetails = new ACET_ProvidersearchCtrl.ProviderDetails();
        providerDetails.lastName = 'pln'; 
        providerDetails.taxId = '123456789';
        providerDetails.firstName = 'sdas';
        providerDetails.npi = '1234567890';
        providerDetails.isProviderNotFound = false;
        providerDetails.isNoProviderToSearch = false;
        providerDetails.isOther = false;
        providerDetails.isValidProvider = true;
       
        
        
        SAEMemberProviderDetail dateFormatInstance = new SAEMemberProviderDetail();
        dateFormatInstance.formatDate('1956-01-01');
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new SAEHttpCalloutMock.SAEEligibilityV2Mock());
        SAEMemberProviderDetail.getMockData('', '929394959', '1960-01-02', 'CALEB', 'GALLECO', '', 'MemberIDNameDateOfBirth', '8226', providerDetails);
        SAEMemberProviderDetail.getRelatedCasesHistory('929394959', 'CALEBGALLECO01021960929394959523119', false, 'Member');
        Test.stopTest();
    }
    
    static testMethod void MemberIDNameTest(){
        ACET_ProvidersearchCtrl.ProviderDetails providerDetails = new ACET_ProvidersearchCtrl.ProviderDetails();
        providerDetails.lastName = 'pln'; 
        providerDetails.taxId = '123456789';
        providerDetails.firstName = 'sdas';
        providerDetails.npi = '1234567890';
        providerDetails.isProviderNotFound = false;
        providerDetails.isNoProviderToSearch = false;
        providerDetails.isOther = false;
        providerDetails.isValidProvider = true;
 
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new SAEHttpCalloutMock.SAEEligibilityV2Mock());
        SAEMemberProviderDetail.getMockData('', '929394959', '', 'CALEB', 'GALLECO', '', 'MemberIDName', '8226', providerDetails);
        SAEMemberProviderDetail.getRelatedETSBECasesHistory('929394959', '523119', '123456789', 'CALEBGALLECO01021960929394959523119', true, 'Member');
        Test.stopTest();
    }
    
    static testMethod void MemberIDLastNameDateOfBirthTest(){
        ACET_ProvidersearchCtrl.ProviderDetails providerDetails = new ACET_ProvidersearchCtrl.ProviderDetails();
        providerDetails.lastName = 'pln'; 
        providerDetails.taxId = '123456789';
        providerDetails.firstName = 'sdas';
        providerDetails.npi = '1234567890';
        providerDetails.isProviderNotFound = false;
        providerDetails.isNoProviderToSearch = false;
        providerDetails.isOther = false;
        providerDetails.isValidProvider = true;
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new SAEHttpCalloutMock.SAEEligibilityV2Mock());
        SAEMemberProviderDetail.getMockData('', '929394959', '1960-01-02', '', 'GALLECO', '', 'MemberIDLastNameDateOfBirth', '8226', providerDetails);
        Test.stopTest();
    }   
    
    static testMethod void MemberIDFirstNameDateOfBirthTest(){
        ACET_ProvidersearchCtrl.ProviderDetails providerDetails = new ACET_ProvidersearchCtrl.ProviderDetails();
        providerDetails.lastName = 'pln'; 
        providerDetails.taxId = '123456789';
        providerDetails.firstName = 'sdas';
        providerDetails.npi = '1234567890';
        providerDetails.isProviderNotFound = false;
        providerDetails.isNoProviderToSearch = false;
        providerDetails.isOther = false;
        providerDetails.isValidProvider = true;

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new SAEHttpCalloutMock.SAEEligibilityV2Mock());
        SAEMemberProviderDetail.getMockData('', '929394959', '1960-01-02', 'CALEB', '', '', 'MemberIDFirstNameDateOfBirth', '8226', providerDetails);
        Test.stopTest();
    } 

    static testMethod void MemberIDDateOfBirthTest(){
        ACET_ProvidersearchCtrl.ProviderDetails providerDetails = new ACET_ProvidersearchCtrl.ProviderDetails();
        providerDetails.lastName = 'pln'; 
        providerDetails.taxId = '123456789';
        providerDetails.firstName = 'sdas';
        providerDetails.npi = '1234567890';
        providerDetails.isProviderNotFound = false;
        providerDetails.isNoProviderToSearch = false;
        providerDetails.isOther = false;
        providerDetails.isValidProvider = true;
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new SAEHttpCalloutMock.SAEEligibilityV2Mock());

        SAEMemberProviderDetail.getMockData('', '929394959', '1960-01-02', '', '', '', 'MemberIDDateOfBirth', '8226', providerDetails);
        Test.stopTest();
    }     
}