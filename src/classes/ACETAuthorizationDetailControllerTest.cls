@isTest(SeeAllData=false)
private class ACETAuthorizationDetailControllerTest
{
    
    static testMethod void  ACETAuthorizationDetailControllerTest1() 
    {
        //Setup records in custom setting
        list<Call_Topic_Access__c> callTopicAccess = new list<Call_Topic_Access__c>();
        callTopicAccess.add(new Call_Topic_Access__c( name='test',Call_Topic__c='Create Authorization',VF_Page_Name__c = 'ACETCreateAuthorization',Limit_To_Roles__c='Resolution Specialist - Agent; Resolution Specialist - Supervisor'));
        insert callTopicAccess;
        
        
        ACETOrgInstanceURLToOrgNameMap__c orgnamemap1 = new ACETOrgInstanceURLToOrgNameMap__c();
        orgnamemap1.Name = 'qaacet--acetqa.cs26';
        orgnamemap1.Org_Name__c = 'qa';
        insert orgnamemap1;
        
        ACETOrgInstanceURLToOrgNameMap__c orgnamemap = new ACETOrgInstanceURLToOrgNameMap__c();
        orgnamemap.Name = 'devacet--acetdev.cs26';
        orgnamemap.Org_Name__c = 'dev';
        insert orgnamemap;
        
        ACETOrgInstanceURLToOrgNameMap__c orgnamemap2 = new ACETOrgInstanceURLToOrgNameMap__c();
        orgnamemap2.Name = 'optum';
        orgnamemap2.Org_Name__c = 'prd';
        insert orgnamemap2;
        
        ACETOrgInstanceURLToOrgNameMap__c urlinstance3 = new ACETOrgInstanceURLToOrgNameMap__c();
        urlinstance3.Name = 'cs14';
        urlinstance3.Org_Name__c = 'd1';
        insert urlinstance3;
        
        ACETOrgInstanceURLToOrgNameMap__c urlinstance4 = new ACETOrgInstanceURLToOrgNameMap__c();
        urlinstance4.Name = 'cs17';
        urlinstance4.Org_Name__c = 'qa';
        insert urlinstance4;
        
        ACETOrgInstanceURLToOrgNameMap__c urlinstance7 = new ACETOrgInstanceURLToOrgNameMap__c();
        urlinstance7.Name = 'fullcopy';
        urlinstance7.Org_Name__c = 'qa';
        insert urlinstance7;
        
        ACETOrgInstanceURLToOrgNameMap__c urlinstance5 = new ACETOrgInstanceURLToOrgNameMap__c();
        urlinstance5.Name = 'acet-uhg';
        urlinstance5.Org_Name__c = 'prd';
        insert urlinstance5;
        
        ACETOrgInstanceURLToOrgNameMap__c orgnamemap6 = new ACETOrgInstanceURLToOrgNameMap__c();
        orgnamemap6.Name = 'emidscm';
        orgnamemap6.Org_Name__c = 'qa';
        insert orgnamemap6;
        
        ACETOrgNameToSwivelEndpointMap__c SwivelEndpoint = new ACETOrgNameToSwivelEndpointMap__c();
        SwivelEndpoint.name ='dev_ICUECreateAuthorization';
        SwivelEndpoint.Swivel_Endpoint__c = 'test';
        insert SwivelEndpoint;
        
        ACETOrgNameToSwivelEndpointMap__c SwivelEndpoint1 = new ACETOrgNameToSwivelEndpointMap__c();
        SwivelEndpoint1.name ='qa_ICUECreateAuthorization';
        SwivelEndpoint1.Swivel_Endpoint__c = 'test';
        insert SwivelEndpoint1;
        
        ACETOrgNameToSwivelEndpointMap__c SwivelEndpoint2 = new ACETOrgNameToSwivelEndpointMap__c();
        SwivelEndpoint2.name ='d1_ICUECreateAuthorization';
        SwivelEndpoint2.Swivel_Endpoint__c = 'test';
        insert SwivelEndpoint2;
        
        ACETOrgNameToSwivelEndpointMap__c swivel3 = new ACETOrgNameToSwivelEndpointMap__c();
        swivel3.Name = 'prd_ICUECreateAuthorization';
        swivel3.Swivel_Endpoint__c = 'ICUECreateAuthorization';
        insert swivel3;
        
        
        ACETWrapEncryptionKey__c encryptKey = new ACETWrapEncryptionKey__c();
        encryptKey.name ='dev_ICUEEncryptionKey';
        encryptKey.Algorithm_Name__c = 'AES256';
        encryptKey.Key__c= 'tbC2KA36qE1psxs9mozyfOmy7GdrI3I9';
        insert encryptKey ;
        
        
        ACETWrapEncryptionKey__c encryptKey1 = new ACETWrapEncryptionKey__c();
        encryptKey1.name ='qa_ICUEEncryptionKey';
        encryptKey1.Algorithm_Name__c = 'AES256';
        encryptKey1.Key__c= 'tbC2KA36qE1psxs9mozyfOmy7GdrI3I9';
        insert encryptKey1;
               
        
        ACETWrapEncryptionKey__c dev1key = new ACETWrapEncryptionKey__c();
        dev1key.Name = 'd1_ICUEEncryptionKey';
        dev1key.Algorithm_Name__c = 'AES256';
        dev1key.Key__c = 'tbC2KA36qE1psxs9mozyfOmy7GdrI3I9';
        insert dev1key;
        
        ACETWrapEncryptionKey__c prdkey = new ACETWrapEncryptionKey__c();
        prdkey.Name = 'prd_ICUEEncryptionKey';
        prdkey.Algorithm_Name__c = 'AES256';
        prdkey.Key__c = 'tbC2KA36qE1psxs9mozyfOmy7GdrI3I9';
        insert prdkey;
        
        Account acc2 = ACETTestDataUtility.CreateAccount('Testacc', 'TaxId', 'EID');
        insert acc2;
        
        Contact con2 = ACETTestDataUtility.createContact(acc2.id, 'John', 'Miller');
        con2.Contact_Type__c = 'Provider';
        insert con2;
        
        RecordType newRecord = [SELECT Id FROM RecordType WHERE Name = 'Person Account' and SObjectType = 'Account'];
        
        Account accountTest = new Account();
        accountTest.FirstName = 'TestFirst';
        accountTest.LastName = 'TestLast';
        accountTest.EID__c = '12345';
        accountTest.EID__pc = '12345';
        accountTest.Contact_Type__pc = 'Provider';
        accountTest.RecordTypeId = newRecord.Id;
        insert accountTest;
        
        Account acc1 = [SELECT Id,personcontactid from Account where Id=:accountTest.Id];
        Contact con1 = [SELECT Id,LastName,FirstName,EID__c,AccountId from Contact where Id=:acc1.personcontactid];
        
        
        
        //  AccountContactHandler.handleAfterDelete(accconrellist,accconrelmap);
        
        Map<String, String> mapISLWSConfigs = new Map<String, String>(); 
        mapISLWSConfigs.put('ISLConAccessToken', 'e9b3f2b1-8863-49ec-9ff8-40da25961ef5');
        mapISLWSConfigs.put('ISLFindProviderContentType', 'application/json;charset=UTF-8');
        mapISLWSConfigs.put('ISLHttpHeaderActor', 'ACET');
        mapISLWSConfigs.put('ISLHttpHeaderScope', 'read');
        mapISLWSConfigs.put('ISLOAuthContentType', 'application/x-www-form-urlencoded');
        mapISLWSConfigs.put('ISLOAuthGrantType', 'client_credentials');
        mapISLWSConfigs.put('ISLStageConClientId', 'ISLStageConClientId');
        mapISLWSConfigs.put('ISLStageConClientSecret', 'ISLStageConClientSecret');
        mapISLWSConfigs.put('ISLStageConEndpoint', 'https://api-stg.optum.com:8443');
        mapISLWSConfigs.put('ISLStageFindProviderEndpoint', '/api/test/eisl/providers/v1.0/medicalprovider/search');
        mapISLWSConfigs.put('ISLStageGetProviderEndpoint', '/api/test/eisl/providers/v1.0/medicalprovider/read');
        mapISLWSConfigs.put('ISLStageFindAuthorizationEndpoint', '/api/bravo/eisl/clinical/medicalhealthservicecaseauthorizations/v1.0/search');
        mapISLWSConfigs.put('ISLStageOAuthEndpoint', '/auth/oauth/v2/token');//different
        mapISLWSConfigs.put('ISLStageTimeout', '3000'); 
        List<ISL_Webservice_Config__c> lstISLWSConfigs = ACETTestDataUtility.CreateISLWebserviceConfigurations(mapISLWSConfigs);
        insert lstISLWSConfigs;
        
        //interaction and highlight panel       
        Interaction__c InteractionId = ACETProviderSearchController.RedirectToProviderDetail('Phone Call', 'Contact Name', '1', '999999999', '9999999999', 'Group Name', 'Facility/Group','1452423968971','123456','60005');
        
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
        
        //Setup records in custom setting
        PageReference ACETPDPage = Page.ACETAuthorizationDetail;
        ACETPDPage.getParameters().put('Id', InteractionId.Id);
        ACETPDPage.getParameters().put('caseStatusReason', 'test');
        ACETPDPage.getParameters().put('PreDetermination', 'No');
        ACETPDPage.getParameters().put('ActualDschargDate', '10/25/2016');
        ACETPDPage.getParameters().put('ExpectedDischargeDate', '10/25/2016');
        ACETPDPage.getParameters().put('ActualAdmitDate', '10/25/2016');
        ACETPDPage.getParameters().put('ExpectedAdmitDate', '10/25/2016');
        ACETPDPage.getParameters().put('Type', 'InpatientCases');
        ACETPDPage.getParameters().put('authDeailInfo', 'test_test_testtest_test_testtest_test_testtest_test_testtest_test_test_test_test');        
        
        Account acc = ACETTestDataUtility.createAccount('testName');
        insert acc;
        
        Contact con = new contact();
        con.FirstName ='testname';
        con.LastName = 'testlast';
        upsert con;
        
        Test.startTest();
        
        MockHttpCalloutResponseGenerator.MockHttpResponse OILResponseInpatient = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', ACETTestDataUtility.GetInpatientDetailResponseJSONTest() );
        OILResponseInpatient.TokenExpired = false;        
        
        MockHttpCalloutResponseGenerator MockHttpRes = new MockHttpCalloutResponseGenerator(null, OILResponseInpatient);
        
        Test.setMock(HttpCalloutMock.class, MockHttpRes);

        ACETPDPage.getParameters().put('contactId', con.Id);
        test.setCurrentPage(ACETPDPage);
        ACETCallTopicCreateCaseItem controller =new ACETCallTopicCreateCaseItem();
        ACETAuthorizationDetailController ACETPDExt = new ACETAuthorizationDetailController(controller);
        controller.addCaseItem();
        //ACETAuthorizationDetailController ACETPDExt = new ACETAuthorizationDetailController();
        
        ACETPDExt.CallGetAuthorizationWS();
        case cobj=new case(Priority_Routing__c='Yes',Status='open');
        list<Case_Item__c> cilist=new List<Case_Item__c>();
        Map<String,ACETCaseitemwrapper> csite= new  Map<String,ACETCaseitemwrapper>();
        ACETPDExt.Createcaseanditem(cobj,csite);
        
        
        
        Test.stopTest();
        
    } 
    static testMethod void  ACETAuthorizationDetailControllerTest2() 
    {
        list<Call_Topic_Access__c> callTopicAccess = new list<Call_Topic_Access__c>();
        callTopicAccess.add(new Call_Topic_Access__c( name='test',Call_Topic__c='Create Authorization',VF_Page_Name__c = 'ACETCreateAuthorization',Limit_To_Roles__c='Resolution Specialist - Agent; Resolution Specialist - Supervisor'));
        insert callTopicAccess;
        
        ACETOrgInstanceURLToOrgNameMap__c orgnamemap1 = new ACETOrgInstanceURLToOrgNameMap__c();
        orgnamemap1.Name = 'qaacet--acetqa.cs26';
        orgnamemap1.Org_Name__c = 'qa';
        insert orgnamemap1;
        
        ACETOrgInstanceURLToOrgNameMap__c orgnamemap = new ACETOrgInstanceURLToOrgNameMap__c();
        orgnamemap.Name = 'devacet--acetdev.cs26';
        orgnamemap.Org_Name__c = 'dev';
        insert orgnamemap;
        
        ACETOrgInstanceURLToOrgNameMap__c orgnamemap2 = new ACETOrgInstanceURLToOrgNameMap__c();
        orgnamemap2.Name = 'optum';
        orgnamemap2.Org_Name__c = 'prd';
        insert orgnamemap2;
        
        ACETOrgInstanceURLToOrgNameMap__c urlinstance3 = new ACETOrgInstanceURLToOrgNameMap__c();
        urlinstance3.Name = 'cs14';
        urlinstance3.Org_Name__c = 'd1';
        insert urlinstance3;
        
        ACETOrgInstanceURLToOrgNameMap__c urlinstance4 = new ACETOrgInstanceURLToOrgNameMap__c();
        urlinstance4.Name = 'cs17';
        urlinstance4.Org_Name__c = 'qa';
        insert urlinstance4;
        
        ACETOrgInstanceURLToOrgNameMap__c urlinstance5 = new ACETOrgInstanceURLToOrgNameMap__c();
        urlinstance5.Name = 'acet-uhg';
        urlinstance5.Org_Name__c = 'prd';
        insert urlinstance5;
        
        ACETOrgInstanceURLToOrgNameMap__c orgnamemap6 = new ACETOrgInstanceURLToOrgNameMap__c();
        orgnamemap6.Name = 'emidscm';
        orgnamemap6.Org_Name__c = 'qa';
        insert orgnamemap6;
        
        ACETOrgInstanceURLToOrgNameMap__c orgnamemap7 = new ACETOrgInstanceURLToOrgNameMap__c();
        orgnamemap7.Name = 'fullcopy';
        orgnamemap7.Org_Name__c = 'qa';
        insert orgnamemap7;
        
        ACETOrgNameToSwivelEndpointMap__c SwivelEndpoint = new ACETOrgNameToSwivelEndpointMap__c();
        SwivelEndpoint.name ='dev_ICUECreateAuthorization';
        SwivelEndpoint.Swivel_Endpoint__c = 'test';
        insert SwivelEndpoint;
        
        ACETOrgNameToSwivelEndpointMap__c SwivelEndpoint1 = new ACETOrgNameToSwivelEndpointMap__c();
        SwivelEndpoint1.name ='qa_ICUECreateAuthorization';
        SwivelEndpoint1.Swivel_Endpoint__c = 'test';
        insert SwivelEndpoint1;
        
        ACETOrgNameToSwivelEndpointMap__c SwivelEndpoint2 = new ACETOrgNameToSwivelEndpointMap__c();
        SwivelEndpoint2.name ='d1_ICUECreateAuthorization';
        SwivelEndpoint2.Swivel_Endpoint__c = 'test';
        insert SwivelEndpoint2;
        
        ACETOrgNameToSwivelEndpointMap__c swivel3 = new ACETOrgNameToSwivelEndpointMap__c();
        swivel3.Name = 'prd_ICUECreateAuthorization';
        swivel3.Swivel_Endpoint__c = 'ICUECreateAuthorization';
        insert swivel3;
        
        
        ACETWrapEncryptionKey__c encryptKey = new ACETWrapEncryptionKey__c();
        encryptKey.name ='dev_ICUEEncryptionKey';
        encryptKey.Algorithm_Name__c = 'AES256';
        encryptKey.Key__c= 'tbC2KA36qE1psxs9mozyfOmy7GdrI3I9';
        insert encryptKey ;
        
        
        ACETWrapEncryptionKey__c encryptKey1 = new ACETWrapEncryptionKey__c();
        encryptKey1.name ='qa_ICUEEncryptionKey';
        encryptKey1.Algorithm_Name__c = 'AES256';
        encryptKey1.Key__c= 'tbC2KA36qE1psxs9mozyfOmy7GdrI3I9';
        insert encryptKey1;
              
        ACETWrapEncryptionKey__c dev1key = new ACETWrapEncryptionKey__c();
        dev1key.Name = 'd1_ICUEEncryptionKey';
        dev1key.Algorithm_Name__c = 'AES256';
        dev1key.Key__c = 'tbC2KA36qE1psxs9mozyfOmy7GdrI3I9';
        insert dev1key;
        
        ACETWrapEncryptionKey__c prdkey = new ACETWrapEncryptionKey__c();
        prdkey.Name = 'prd_ICUEEncryptionKey';
        prdkey.Algorithm_Name__c = 'AES256';
        prdkey.Key__c = 'tbC2KA36qE1psxs9mozyfOmy7GdrI3I9';
        insert prdkey;
        
        Map<String, String> mapISLWSConfigs = new Map<String, String>(); 
        mapISLWSConfigs.put('ISLConAccessToken', 'e9b3f2b1-8863-49ec-9ff8-40da25961ef5');
        mapISLWSConfigs.put('ISLFindProviderContentType', 'application/json;charset=UTF-8');
        mapISLWSConfigs.put('ISLHttpHeaderActor', 'ACET');
        mapISLWSConfigs.put('ISLHttpHeaderScope', 'read');
        mapISLWSConfigs.put('ISLOAuthContentType', 'application/x-www-form-urlencoded');
        mapISLWSConfigs.put('ISLOAuthGrantType', 'client_credentials');
        mapISLWSConfigs.put('ISLStageConClientId', 'ISLStageConClientId');
        mapISLWSConfigs.put('ISLStageConClientSecret', 'ISLStageConClientSecret');
        mapISLWSConfigs.put('ISLStageConEndpoint', 'https://api-stg.optum.com:8443');
        mapISLWSConfigs.put('ISLStageFindProviderEndpoint', '/api/test/eisl/providers/v1.0/medicalprovider/search');
        mapISLWSConfigs.put('ISLStageGetProviderEndpoint', '/api/test/eisl/providers/v1.0/medicalprovider/read');
        mapISLWSConfigs.put('ISLStageFindAuthorizationEndpoint', '/api/bravo/eisl/clinical/medicalhealthservicecaseauthorizations/v1.0/search');
        mapISLWSConfigs.put('ISLStageOAuthEndpoint', '/auth/oauth/v2/token');//different
        mapISLWSConfigs.put('ISLStageTimeout', '3000'); 
        List<ISL_Webservice_Config__c> lstISLWSConfigs = ACETTestDataUtility.CreateISLWebserviceConfigurations(mapISLWSConfigs);
        insert lstISLWSConfigs;
        
        //interaction and highlight panel       
        Interaction__c InteractionId = ACETProviderSearchController.RedirectToProviderDetail('Phone Call', 'Contact Name', '1', '9991999999', '9999999999', 'Group Name', 'Facility/Group','1452423968971','123456','60005');
        
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
        
        //Setup records in custom setting
        PageReference ACETPDPage = Page.ACETAuthorizationDetail;
        ACETPDPage.getParameters().put('Id', InteractionId.Id);
        ACETPDPage.getParameters().put('caseStatusReason', 'test');
        ACETPDPage.getParameters().put('PreDetermination', 'No');
        ACETPDPage.getParameters().put('ActualDschargDate', '10/25/2016');
        ACETPDPage.getParameters().put('ExpectedDischargeDate', '10/25/2016');
        ACETPDPage.getParameters().put('ActualAdmitDate', '10/25/2016');
        ACETPDPage.getParameters().put('ExpectedAdmitDate', '10/25/2016');
        ACETPDPage.getParameters().put('Type', 'OutpatientCases');
        ACETPDPage.getParameters().put('authDeailInfo', 'test_test_testtest_test_testtest_test_testtest_test_testtest_test_test_test_test');                
        test.setCurrentPage(ACETPDPage);        
        
        Test.startTest();
        
        MockHttpCalloutResponseGenerator.MockHttpResponse OILResponseOutpatientFacility = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', ACETTestDataUtility.GetOutpatientFacilityDetailResponseJSON() );
        OILResponseOutpatientFacility.TokenExpired = false;        
        
        MockHttpCalloutResponseGenerator MockHttpRes = new MockHttpCalloutResponseGenerator(null, OILResponseOutpatientFacility);
        Test.setMock(HttpCalloutMock.class, MockHttpRes);     
        
        ACETProviderUtility.GetInteractionByID(InteractionId.Id);        
        Apexpages.StandardController ACETPDStdCtrl = new Apexpages.standardController(InteractionId);
        ACETCallTopicCreateCaseItem controller2 =new ACETCallTopicCreateCaseItem();
        // ACETAuthorizationDetailController ACETPDExt1 = new ACETAuthorizationDetailController();
        ACETAuthorizationDetailController ACETPDExt1 = new ACETAuthorizationDetailController(controller2);
        ACETPDExt1.CallGetAuthorizationWS();
        
        
        ACETGetAuthorizationJSON2APEX.StatusReasonCode authDetailsReason= new ACETGetAuthorizationJSON2APEX.StatusReasonCode ();
        authDetailsReason.code= '123';
        authDetailsReason.description = 'test';
        
        ACETGetAuthorizationJSON2APEX.StatusReasonCodeNew authDetailsReasonNew= new ACETGetAuthorizationJSON2APEX.StatusReasonCodeNew ();
        authDetailsReasonNew.code= '123';
        authDetailsReasonNew.description = 'test';
        
        ACETGetAuthorizationJSON2APEX.EffectiveDateRange authDetailsDate= new ACETGetAuthorizationJSON2APEX.EffectiveDateRange();
        authDetailsDate.stopDate = '2018-12-31';
        
        list<ACETGetAuthorizationJSON2APEX.Address> authDetailsAddresslist= new list<ACETGetAuthorizationJSON2APEX.Address>();
        ACETGetAuthorizationJSON2APEX.Address authDetailsAddress= new ACETGetAuthorizationJSON2APEX.Address();
        authDetailsAddress.addressLine1 = 'test';
        authDetailsAddress.city = 'test';
        authDetailsAddress.postalCode1 = 'test';
        authDetailsAddress.countyFIPS = 'test';
        authDetailsAddress.countyName = 'test';
        authDetailsAddress.state = authDetailsReason;
        authDetailsAddress.addressType = authDetailsReason;
        authDetailsAddress.countryCode = authDetailsReason;
        authDetailsAddress.effectiveDateRange = authDetailsDate;
        authDetailsAddresslist.add(authDetailsAddress);
        
        list<ACETGetAuthorizationJSON2APEX.EnrolleIdentifiers> authDetailsEnrollelist= new list<ACETGetAuthorizationJSON2APEX.EnrolleIdentifiers>();
        ACETGetAuthorizationJSON2APEX.EnrolleIdentifiers authDetailsEnrolle= new ACETGetAuthorizationJSON2APEX.EnrolleIdentifiers();
        authDetailsEnrolle.id ='13123';
        authDetailsEnrolle.typeCode ='abc';
        authDetailsEnrollelist.add(authDetailsEnrolle);
        
        ACETGetAuthorizationJSON2APEX.SourceMemberId authDetailssource= new ACETGetAuthorizationJSON2APEX.SourceMemberId();
        authDetailssource.id = '12312';
        authDetailssource.etype= 'abc';
        
        ACETGetAuthorizationJSON2APEX.member authDetailsMember = new ACETGetAuthorizationJSON2APEX.member();
        authDetailsMember.sourceMemberId   = authDetailssource;
        authDetailsMember.firstName   = 'xyz';
        authDetailsMember.lastName   = 'abc';
        authDetailsMember.birthDate   = '2010-12-31';
        authDetailsMember.gender   = authDetailsReason;
        authDetailsMember.relationshipCode   = '123';
        authDetailsMember.address   = authDetailsAddresslist;
        authDetailsMember.enrolleIdentifiers   = authDetailsEnrollelist;
        
        list<ACETGetAuthorizationJSON2APEX.RuleDecision> authDetailsrulelist = new list<ACETGetAuthorizationJSON2APEX.RuleDecision>();
        ACETGetAuthorizationJSON2APEX.RuleDecision authDetailsrule = new ACETGetAuthorizationJSON2APEX.RuleDecision();
        
        ACETGetAuthorizationJSON2APEX.AuthDetailsResponse authDetails = new ACETGetAuthorizationJSON2APEX.AuthDetailsResponse();
        authDetails.authId = '12345';
        authDetails.coverageSequenceNumber = '1';
        authDetails.createDateTime = '2017-12-31';
        authDetails.globalId = '123451234512345';
        authDetails.member = authDetailsMember ;
        authDetails.ruleDecision = authDetailsrulelist ;
        authDetails.letterTypes= authDetailsrulelist ;
        
        ACETGetAuthorizationJSON2APEX.Providers authDetailsprov= new ACETGetAuthorizationJSON2APEX.Providers();
        authDetailsprov.productType = '12312';
        authDetailsprov.primaryPhone= '1234567890';
        authDetailsprov.primaryTelephoneInternationalIndicator= 'Y';
        authDetailsprov.faxInternationalIndicator = 'Y';
        authDetailsprov.faxNumber = '1231231231';
        
        ACETGetAuthorizationJSON2APEX.ProviderContractOrgs authDetailsprovConOrgs= new ACETGetAuthorizationJSON2APEX.ProviderContractOrgs();
        authDetailsprovConOrgs.contractContext= 'Test';
        authDetailsprovConOrgs.contractOrg= 'Test';
        authDetailsprovConOrgs.contractOrgPriority= 'Test';
        
        
        ACETGetAuthorizationJSON2APEX.ServiceDecisionSource authDetailsserv= new ACETGetAuthorizationJSON2APEX.ServiceDecisionSource();
        authDetailsserv.sourceSeqNumber = '1';
        authDetailsserv.decisionSourceType= authDetailsReason;
        
        ACETGetAuthorizationJSON2APEX.AvaliabilityeffectiveDateRange authDetailsrange= new ACETGetAuthorizationJSON2APEX.AvaliabilityeffectiveDateRange();
        authDetailsrange.code= '1';
        authDetailsrange.sourceSystem= 'Test';
        
        ACETGetAuthorizationJSON2APEX.ServiceNonFacility authDetailsnonfac= new ACETGetAuthorizationJSON2APEX.ServiceNonFacility();
        authDetailsnonfac.advanceNotificationTimestamp = '2018-01-24T07:24:27.879-06:00';
        authDetailsnonfac.placeOfServiceCode= authDetailsReason;
        authDetailsnonfac.procedureFrequencyCode= authDetailsReason;
        authDetailsnonfac.procedureUnitOfMeasureCode= authDetailsReason;
        authDetailsnonfac.serviceDescUrgencyCode= authDetailsReason;
        authDetailsnonfac.serviceDetailCategoryCode= authDetailsReason;
        authDetailsnonfac.procedureUnitCount= '3';
        authDetailsnonfac.unitPerFrequencyCount= '2';
        authDetailsnonfac.dmeTotalCost= '20';
        authDetailsnonfac.dmeEnternalFeedingSSONutrInd= 'test';
        
        ACETGetAuthorizationJSON2APEX.Diagnosis authDetailsdiag= new ACETGetAuthorizationJSON2APEX.Diagnosis();
        authDetailsdiag.sequenceNumber = '1';
        authDetailsdiag.preferenceInd= 'a';
        authDetailsdiag.admitInd= 'a';
        
        ACETGetAuthorizationJSON2APEX.ServiceDecisionSource authDetailssds= new ACETGetAuthorizationJSON2APEX.ServiceDecisionSource ();
        authDetailssds.sourceSeqNumber = '1';
        authDetailssds.decisionSourceType= authDetailsReason;
        
        Test.stopTest(); //GetOutpatientFacilityDetailResponseJSON
    }    
    
    static testMethod void  ACETAuthorizationDetailControllerTest3() 
    {
        list<Call_Topic_Access__c> callTopicAccess = new list<Call_Topic_Access__c>();
        callTopicAccess.add(new Call_Topic_Access__c( name='test',Call_Topic__c='Create Authorization',VF_Page_Name__c = 'ACETCreateAuthorization',Limit_To_Roles__c='Resolution Specialist - Agent; Resolution Specialist - Supervisor'));
        insert callTopicAccess;
        
        ACETOrgInstanceURLToOrgNameMap__c orgnamemap1 = new ACETOrgInstanceURLToOrgNameMap__c();
        orgnamemap1.Name = 'qaacet--acetqa.cs26';
        orgnamemap1.Org_Name__c = 'qa';
        insert orgnamemap1;
        
        ACETOrgInstanceURLToOrgNameMap__c orgnamemap = new ACETOrgInstanceURLToOrgNameMap__c();
        orgnamemap.Name = 'devacet--acetdev.cs26';
        orgnamemap.Org_Name__c = 'dev';
        insert orgnamemap;
        
        ACETOrgInstanceURLToOrgNameMap__c orgnamemap2 = new ACETOrgInstanceURLToOrgNameMap__c();
        orgnamemap2.Name = 'optum';
        orgnamemap2.Org_Name__c = 'prd';
        insert orgnamemap2;
        
        ACETOrgInstanceURLToOrgNameMap__c urlinstance3 = new ACETOrgInstanceURLToOrgNameMap__c();
        urlinstance3.Name = 'cs14';
        urlinstance3.Org_Name__c = 'd1';
        insert urlinstance3;
        
        ACETOrgInstanceURLToOrgNameMap__c urlinstance4 = new ACETOrgInstanceURLToOrgNameMap__c();
        urlinstance4.Name = 'cs17';
        urlinstance4.Org_Name__c = 'qa';
        insert urlinstance4;
        
        ACETOrgInstanceURLToOrgNameMap__c urlinstance5 = new ACETOrgInstanceURLToOrgNameMap__c();
        urlinstance5.Name = 'acet-uhg';
        urlinstance5.Org_Name__c = 'prd';
        insert urlinstance5;
        
        ACETOrgInstanceURLToOrgNameMap__c orgnamemap6 = new ACETOrgInstanceURLToOrgNameMap__c();
        orgnamemap6.Name = 'emidscm';
        orgnamemap6.Org_Name__c = 'qa';
        insert orgnamemap6;
        
        ACETOrgInstanceURLToOrgNameMap__c orgnamemap7 = new ACETOrgInstanceURLToOrgNameMap__c();
        orgnamemap7.Name = 'fullcopy';
        orgnamemap7.Org_Name__c = 'qa';
        insert orgnamemap7;
        
        ACETOrgNameToSwivelEndpointMap__c SwivelEndpoint = new ACETOrgNameToSwivelEndpointMap__c();
        SwivelEndpoint.name ='dev_ICUECreateAuthorization';
        SwivelEndpoint.Swivel_Endpoint__c = 'test';
        insert SwivelEndpoint;
        
        ACETOrgNameToSwivelEndpointMap__c SwivelEndpoint1 = new ACETOrgNameToSwivelEndpointMap__c();
        SwivelEndpoint1.name ='qa_ICUECreateAuthorization';
        SwivelEndpoint1.Swivel_Endpoint__c = 'test';
        insert SwivelEndpoint1;
        
        ACETOrgNameToSwivelEndpointMap__c SwivelEndpoint2 = new ACETOrgNameToSwivelEndpointMap__c();
        SwivelEndpoint2.name ='d1_ICUECreateAuthorization';
        SwivelEndpoint2.Swivel_Endpoint__c = 'test';
        insert SwivelEndpoint2;
        
        ACETOrgNameToSwivelEndpointMap__c swivel3 = new ACETOrgNameToSwivelEndpointMap__c();
        swivel3.Name = 'prd_ICUECreateAuthorization';
        swivel3.Swivel_Endpoint__c = 'ICUECreateAuthorization';
        insert swivel3;
        
        
        ACETWrapEncryptionKey__c encryptKey = new ACETWrapEncryptionKey__c();
        encryptKey.name ='dev_ICUEEncryptionKey';
        encryptKey.Algorithm_Name__c = 'AES256';
        encryptKey.Key__c= 'tbC2KA36qE1psxs9mozyfOmy7GdrI3I9';
        insert encryptKey ;
        
        
        ACETWrapEncryptionKey__c encryptKey1 = new ACETWrapEncryptionKey__c();
        encryptKey1.name ='qa_ICUEEncryptionKey';
        encryptKey1.Algorithm_Name__c = 'AES256';
        encryptKey1.Key__c= 'tbC2KA36qE1psxs9mozyfOmy7GdrI3I9';
        insert encryptKey1;
             
        
        ACETWrapEncryptionKey__c dev1key = new ACETWrapEncryptionKey__c();
        dev1key.Name = 'd1_ICUEEncryptionKey';
        dev1key.Algorithm_Name__c = 'AES256';
        dev1key.Key__c = 'tbC2KA36qE1psxs9mozyfOmy7GdrI3I9';
        insert dev1key;
        
        ACETWrapEncryptionKey__c prdkey = new ACETWrapEncryptionKey__c();
        prdkey.Name = 'prd_ICUEEncryptionKey';
        prdkey.Algorithm_Name__c = 'AES256';
        prdkey.Key__c = 'tbC2KA36qE1psxs9mozyfOmy7GdrI3I9';
        insert prdkey;
        
        Map<String, String> mapISLWSConfigs = new Map<String, String>(); 
        mapISLWSConfigs.put('ISLConAccessToken', 'e9b3f2b1-8863-49ec-9ff8-40da25961ef5');
        mapISLWSConfigs.put('ISLFindProviderContentType', 'application/json;charset=UTF-8');
        mapISLWSConfigs.put('ISLHttpHeaderActor', 'ACET');
        mapISLWSConfigs.put('ISLHttpHeaderScope', 'read');
        mapISLWSConfigs.put('ISLOAuthContentType', 'application/x-www-form-urlencoded');
        mapISLWSConfigs.put('ISLOAuthGrantType', 'client_credentials');
        mapISLWSConfigs.put('ISLStageConClientId', 'ISLStageConClientId');
        mapISLWSConfigs.put('ISLStageConClientSecret', 'ISLStageConClientSecret');
        mapISLWSConfigs.put('ISLStageConEndpoint', 'https://api-stg.optum.com:8443');
        mapISLWSConfigs.put('ISLStageFindProviderEndpoint', '/api/test/eisl/providers/v1.0/medicalprovider/search');
        mapISLWSConfigs.put('ISLStageGetProviderEndpoint', '/api/test/eisl/providers/v1.0/medicalprovider/read');
        mapISLWSConfigs.put('ISLStageFindAuthorizationEndpoint', '/api/bravo/eisl/clinical/medicalhealthservicecaseauthorizations/v1.0/search');
        mapISLWSConfigs.put('ISLStageOAuthEndpoint', '/auth/oauth/v2/token');//different
        mapISLWSConfigs.put('ISLStageTimeout', '3000'); 
        List<ISL_Webservice_Config__c> lstISLWSConfigs = ACETTestDataUtility.CreateISLWebserviceConfigurations(mapISLWSConfigs);
        insert lstISLWSConfigs;
        
        //interaction and highlight panel       
        Interaction__c InteractionId = ACETProviderSearchController.RedirectToProviderDetail('Phone Call', 'Contact Name', '1', '9991999999', '9999999999', 'Group Name', 'Facility/Group','1452423968971','123456','60005');
        
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
        
        //Setup records in custom setting
        PageReference ACETPDPage = Page.ACETAuthorizationDetail;
        ACETPDPage.getParameters().put('Id', InteractionId.Id);
        ACETPDPage.getParameters().put('caseStatusReason', 'test');
        ACETPDPage.getParameters().put('PreDetermination', 'No');
        ACETPDPage.getParameters().put('ActualDschargDate', '10/25/2016');
        ACETPDPage.getParameters().put('ExpectedDischargeDate', '10/25/2016');
        ACETPDPage.getParameters().put('ActualAdmitDate', '10/25/2016');
        ACETPDPage.getParameters().put('ExpectedAdmitDate', '10/25/2016');
        ACETPDPage.getParameters().put('Type', 'OutpatientFacilityCases');
        ACETPDPage.getParameters().put('authDeailInfo', 'test_test_testtest_test_testtest_test_testtest_test_testtest_test_test_test_test');                
        test.setCurrentPage(ACETPDPage);
        
        Test.startTest();
        
        MockHttpCalloutResponseGenerator.MockHttpResponse OILResponseOutpatientFacility = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', ACETTestDataUtility.GetOutpatientFacilityDetailResponseJSON() );
        OILResponseOutpatientFacility.TokenExpired = false;        
        
        MockHttpCalloutResponseGenerator MockHttpRes = new MockHttpCalloutResponseGenerator(null, OILResponseOutpatientFacility);
        Test.setMock(HttpCalloutMock.class, MockHttpRes);             
        
        ACETProviderUtility.GetInteractionByID(InteractionId.Id);        
        Apexpages.StandardController ACETPDStdCtrl = new Apexpages.standardController(InteractionId);
        ACETCallTopicCreateCaseItem controller2 =new ACETCallTopicCreateCaseItem();
        ACETAuthorizationDetailController ACETPDExt1 = new ACETAuthorizationDetailController(controller2);
        // ACETAuthorizationDetailController ACETPDExt1 = new ACETAuthorizationDetailController();
        ACETPDExt1.CallGetAuthorizationWS();       
        ACETPDExt1.OutpatientFacilityDisplay  = true; 
        ACETAuthorizationDetailController.displayDateTimeFormat('2016-10-25T14:22:49.000Z');
        ACETAuthorizationDetailController.strDateFormat('1-1-2017');   
        
        ACETGetAuthorizationWebservice.convertToDateFormat('2016-10-25T14:22:49.000Z');
        ACETAuthorizationDetailResult ACETDR=new ACETAuthorizationDetailResult();
        ACETAuthorizationDetailResult.authServiceDetail ACETASD=new ACETAuthorizationDetailResult.authServiceDetail();
        ACETAuthorizationDetailResult.authProviderDetail ACETAPD=new ACETAuthorizationDetailResult.authProviderDetail(); 
        ACETDR.Authorization_Number='1234tes';
        ACETDR.Actual_Admission_Date='06-06-1959';   
        ACETAPD.Speciality='physician';
        ACETDR.Pre_Determination='test';
        ACETDR.Authorization_Number_3='123test';
        ACETDR.Seq_No='11111';
        ACETASD.Proc_Text='test';
        ACETASD.Service_StartDate='06-05-2010'; 
        ACETDR.Letter_Gen_ID='12test';        
        ACETDR.Create_Dt='test';
        ACETDR.Service_Start_Date='01-01-1999';
        ACETDR.Service_End_Date='02-02-1999';
        ACETDR.Expiration_Date='02-02-1999';
        ACETDR.Actual_Discharge_Date='06-10-2017';
        ACETAuthorizationDetailController.InnerNotes ACETDCIN=new ACETAuthorizationDetailController.InnerNotes();
        ACETDCIN.temp='test';
        ACETPDExt1.SourceOriginator='test';
        ACETPDExt1.Expected_Dscharg_Date='06-10-2017';
        
        Test.stopTest();
    }  
    static testMethod void  ACETAuthorizationSearch(){
        ACETAuthorizationSearchResult auth = new ACETAuthorizationSearchResult();
        auth.jsonString = 'str';
        auth.Case_Type_Code = 'str';
        auth.AuthID = 'str';
        auth.Case_Type_Desc = 'str';
        auth.Expected_Start_Date = 'str';
        auth.Actual_End_Date = 'str';
        auth.Actual_Start_Date = 'str';
        auth.Expected_End_Date = 'str';
        auth.CountCode = 'str';
        auth.CountDesc = 'str';
        auth.Case_Reason_Code = 'str';
        auth.Case_Reason_Desc = 'str';
        auth.Admit_Date = 'str';
        auth.Dscharg_Date = 'str';
        auth.selected = true;
    }
}