@isTest(seeAllData=false)
public  class AcetDocumentControllerTest{

public static String oauthtoken = '/auth/oauth/v2/token';
public static String claimTrnsc = 'Claim Transactions';
public static String serviceOnshore = 'All Services Onshore';
public static String serviceOffshore = 'All Services Offshore';
static testmethod void MemberTest()
{
    ISL_Webservice_Config__c islWebServConfig=new ISL_Webservice_Config__c();
    islWebServConfig.Name='OILHttpHeaderScope';
    islWebServConfig.Value__c='read1';
    try{
    insert islWebServConfig;
    }catch(exception ex){}
    ACETGetDocWebservice web=new ACETGetDocWebservice();
    ACETWSCalloutResult ress=new ACETWSCalloutResult();
    web.GetRequestBody();
    
    Map<String, String> mapISLWSConfigs = new Map<String, String>(); 
    mapISLWSConfigs.put('ISLConAccessToken', 'dfb379c2-06b7-46c4-8c6f-bbc390d1b854');
    mapISLWSConfigs.put('OILHttpHeaderAccept', 'application/json;charset=UTF-8');
    mapISLWSConfigs.put('OILHttpHeaderActor', 'ACET');
    mapISLWSConfigs.put('OILHttpHeaderScope', 'read');
    mapISLWSConfigs.put('ISLOAuthContentType', 'application/x-www-form-urlencoded');
    mapISLWSConfigs.put('ISLOAuthGrantType', 'client_credentials');
    mapISLWSConfigs.put('dev_ISLOAuthClientId', 'ISLStageConClientId');
    mapISLWSConfigs.put('dev_ISLOAuthClientSecret', 'ISLStageConClientSecret');
    mapISLWSConfigs.put('dev_ISLOAuthEndpoint', 'https://api-stg.optum.com:8443');
    mapISLWSConfigs.put('dev_CreateLetter', '/api/alpha/eisl/fulfillment/createletter/v1.0');
    mapISLWSConfigs.put('dev_ISLOAuthTokenEndpoint', oauthtoken);
    mapISLWSConfigs.put('OILTimeout', '3000'); 
    List<ISL_Webservice_Config__c> lstISLWSConfigs = ACETTestDataUtility.CreateISLWebserviceConfigurations(mapISLWSConfigs);
    //insert lstISLWSConfigs;
    Test.startTest();
    Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
    web.fetchDocument('test','test');
    Test.stopTest();
}

static testmethod void MemberTest2()
{
    ISL_Webservice_Config__c islWebServConfig=new ISL_Webservice_Config__c();
    islWebServConfig.Name='OILHttpHeaderActor1';
    islWebServConfig.Value__c='';
    insert islWebServConfig;
    
    ACETGetDocWebservice web=new ACETGetDocWebservice();
    ACETWSCalloutResult ress=new ACETWSCalloutResult();
    web.GetRequestBody();
    
    Map<String, String> mapISLWSConfigs = new Map<String, String>(); 
    mapISLWSConfigs.put('ISLConAccessToken', 'dfb379c2-06b7-46c4-8c6f-bbc390d1b854');
    mapISLWSConfigs.put('OILHttpHeaderAccept', 'application/json;charset=UTF-8');
    mapISLWSConfigs.put('OILHttpHeaderActor', 'ACET');
    mapISLWSConfigs.put('OILHttpHeaderScope', 'read');
    mapISLWSConfigs.put('ISLOAuthContentType', 'application/x-www-form-urlencoded');
    mapISLWSConfigs.put('ISLOAuthGrantType', 'client_credentials');
    mapISLWSConfigs.put('dev_ISLOAuthClientId', 'ISLStageConClientId');
    mapISLWSConfigs.put('dev_ISLOAuthClientSecret', 'ISLStageConClientSecret');
    mapISLWSConfigs.put('dev_ISLOAuthEndpoint', 'https://api-stg.optum.com:8443');
    mapISLWSConfigs.put('dev_CreateLetter', '/api/alpha/eisl/fulfillment/createletter/v1.0');
    mapISLWSConfigs.put('dev_ISLOAuthTokenEndpoint', oauthtoken);
    mapISLWSConfigs.put('OILTimeout', '3000'); 
    List<ISL_Webservice_Config__c> lstISLWSConfigs = ACETTestDataUtility.CreateISLWebserviceConfigurations(mapISLWSConfigs);
    try{
    insert lstISLWSConfigs;
    }catch(Exception ex){}
    Test.startTest();
    Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
    web.fetchDocument('PSEUDO1','');
    Test.stopTest();
}

static testmethod void MemberTest3(){
    ACETGetDocWebservice web=new ACETGetDocWebservice();
    Test.setMock(HttpCalloutMock.class, new UnauthorizedEndpointResponse());
    web.fetchDocument('PSEUDO1','test');
}

static testmethod void DocTest()
{
    Account ac = new Account();
    ac.name = 'test';
    insert ac;
    
    Case cs = new Case();
    cs.AccountId = ac.id;
    cs.Subject_Name__c = 'test';
    insert cs;
    Contact cont = new Contact();
    cont.LastName = 'testcon';
    insert cont;
    Interaction__c interaction = new Interaction__c();
    interaction.Originator__c = cont.Id; 
    interaction.Interaction_Type__c = 'Phone Call';
    interaction.Originator_Type__c = 'Member';        
    insert interaction;
    
    Attachment att = new Attachment();
    blob body = blob.valueof('test');
    att.Body = body;
    att.Name = 'test';
    att.ParentId = cs.id;
    insert att;
    List<ISL_Webservice_Config__c> webConfigList=new List<ISL_Webservice_Config__c>();
    ISL_Webservice_Config__c topsConfig1 = new ISL_Webservice_Config__c();
    topsConfig1.Name = 'StargateConAccessToken';
    topsConfig1.ACET_Common_Name__c = 'StargateConAccessToken';
    topsConfig1.Value__c = 'e9b3f2b1-8863-49ec-9ff8-40da25961ef5';
    webConfigList.add(topsConfig1);
    
    ISL_Webservice_Config__c topsConfig2 = new ISL_Webservice_Config__c();
    topsConfig2.Name = 'qa_StargateOAuthEndpoint';
    topsConfig2.ACET_Common_Name__c = 'StargateOAuthEndpoint';
    topsConfig2.Value__c = oauthtoken;
    webConfigList.add(topsConfig2);
    
    ISL_Webservice_Config__c topsConfig3 = new ISL_Webservice_Config__c();
    topsConfig3.Name = 'dev_ISLOAuthEndpoint';
    topsConfig3.ACET_Common_Name__c = 'dev_StargateOAuthEndpoint';//dev_StargateOAuthEndpoint
    topsConfig3.Value__c = oauthtoken;
    webConfigList.add(topsConfig3);
    
    ISL_Webservice_Config__c topsConfig4 = new ISL_Webservice_Config__c();
    topsConfig4.Name = 'StargateTimeout';
    topsConfig4.Value__c = '3000';
    webConfigList.add(topsConfig4);
    insert webConfigList;
    Organization_Properties__c orgProps = Organization_Properties__c.getOrgDefaults();
    orgProps.OrganizationName__c = 'QA';
    Upsert orgProps;
    // Token API data
    WebserviceConfigurations__c starTokenAPIWSConfig = ACET_WebserviceCalloutFramework_Test.createTokenWSConfigs('StarGateTokenAPI');
    OrgSpecificConfigurations__c starTokenAPIOrgSpecificConfigs = ACET_WebserviceCalloutFramework_Test.createTokenOrgWSConfigs(starTokenAPIWSConfig.Id);
    starTokenAPIOrgSpecificConfigs.EnableErrorLog__c=true;
    update starTokenAPIOrgSpecificConfigs;

    // Service API data
    WebserviceConfigurations__c orswsConfig = ACET_WebserviceCalloutFramework_Test.createWSConfig('Doc360DocumentReprint', starTokenAPIWSConfig.Id);
    OrgSpecificConfigurations__c orsorgSpecificConfigs = ACET_WebserviceCalloutFramework_Test.createOrgWSConfigs(orswsConfig.Id);
    orsorgSpecificConfigs.EnableErrorLog__c=true;
    update orsorgSpecificConfigs;
    WebserviceConfigurations__c orswsConfig2 = ACET_WebserviceCalloutFramework_Test.createWSConfig('DOC360GLobalURL', starTokenAPIWSConfig.Id);
    OrgSpecificConfigurations__c orsorgSpecificConfigs2 = ACET_WebserviceCalloutFramework_Test.createOrgWSConfigs(orswsConfig2.Id);
    orsorgSpecificConfigs2.Static_Data__c='{"appId":"5949e3ae-1198-4b02-bc83-d63c7e4baa2c"}';
    update orsorgSpecificConfigs2;
        String samplebody= '{"reprintId":null,"clientReprintId":"Paul-ACET-1624455939386","documentClassName":null,"documentId":null,"sourceId":null,"receivedDate":"2021-04-15T18:08:11.000Z","status":"Success"}';
        Test.setMock(HttpCalloutMock.class, new ACET_ORSMockResponse(samplebody, 201));
    PageReference pageRef = Page.ACETFormsHistory;
    test.setCurrentPage(pageRef); 
        ApexPages.currentPage().getParameters().put('DocId','7f183de6');
    ApexPages.currentPage().getParameters().put('docType','ACET Letter');
        ApexPages.currentPage().getParameters().put('bookOfBusinessTypeCode','OX');
    ApexPages.currentPage().getParameters().put('interactionId', interaction.id);
                List<Document_Type_Flow__mdt> dtfs = [select Document_Type__r.WS_Field_Name__c, Document_Type__r.Document_Type__c, WS_Backup_Address_Type__c, WS_Primary_Address_Type__c,isAlternateAddress__c, Subscriber_Only__c from Document_Type_Flow__mdt where Subscriber_Only__c=true limit 1];//where Flow__c = :flow and Is_Member_Focus__c = :isMemberFocus and Document_Type__r.Document_Type__c = :documentType];
    ACETDocumentController doc = new ACETDocumentController();
    doc.DocumentId = 'test';
    doc.DocumentType = 'test';
    doc.IsDocSizeMoreThanOneMB = 'false';
    doc.AttachmentId = att.Id;
    doc.getDoc360URL();
    test.startTest();
    doc.resendSelectedDocs();
    ApexPages.currentPage().getParameters().put('DocId','7f183de6');
    ApexPages.currentPage().getParameters().put('docContentType','application/pdf');
    // ApexPages.currentPage().getParameters().put('IsDocSizeMoreThanOneMB','false');
    
    ACETHighlightsPanelAdditionalInfo jsonReq = new ACETHighlightsPanelAdditionalInfo();
    jsonReq.Relationship='Test';   
    jsonReq.SitusState='Test';
    jsonReq.DOB='09/28/2016';
    jsonReq.EndDate='09/28/2016';
    jsonReq.EffectiveDate='09/28/2016';
    jsonReq.PolicyNumber='12345';
    jsonReq.GroupName='Test';
    jsonReq.Product='Test';
    jsonReq.ProductType='Test';
    jsonReq.Network='Test';
    jsonReq.ConsumerAccountIndicator='Test';
    
    String additionalInfoStr  = JSON.serialize(jsonReq);
    
    ApexPages.currentPage().getParameters().put('additionalInfo',TestDataFactory.createACETHighlightsPanelAdditionalInfo());
        MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK',ACETTestDataUtility.GetProducerJSON());
        system.debug('test response==========>'+OILResponse);
        OILResponse.TokenExpired = false;
        
        
    MockHttpCalloutResponseGenerator MockHttpRes = new MockHttpCalloutResponseGenerator(null, OILResponse);
        Test.setMock(HttpCalloutMock.class, MockHttpRes);
        
        PageReference ACETPDPage = Page.ACETProducerDetail;
        test.setCurrentPage(ACETPDPage);
            apexpages.currentpage().getparameters().put('Id', '16712');
                apexpages.currentpage().getparameters().put('ProvTypeCode','HCO');
                try {
    doc.findProviderInfo(dtfs[0]);
    }
    catch(exception ex){
        system.debug('test exception '+ex);
    }
        ApexPages.currentPage().getParameters().put('bookOfBusinessTypeCode','OX');

    ACETDocumentController.getDocContent(att.Id);
            ApexPages.currentPage().getParameters().put('DocId','7f183de6');
    ApexPages.currentPage().getParameters().put('docContentType','application/pdf');

        ApexPages.currentPage().getParameters().put('isDocSizeMoreThanOneMB','false');
    ApexPages.currentPage().getParameters().put('docContentType','PDF');
    try{
    doc.fetchDoc();
    }catch(exception ex){}
    Test.stopTest();
}


static testMethod void testDocController(){
    ApexPages.currentPage().getParameters().put('IsDocSizeMoreThanOneMB','false');
    
    ACETHighlightsPanelAdditionalInfo jsonReq = new ACETHighlightsPanelAdditionalInfo();
    jsonReq.Relationship='Test';   
    jsonReq.SitusState='Test';
    jsonReq.DOB='09/28/2016';
    jsonReq.EndDate='09/28/2016';
    jsonReq.EffectiveDate='09/28/2016';
    jsonReq.PolicyNumber='12345';
    jsonReq.GroupName='Test';
    jsonReq.Product='Test';
    jsonReq.ProductType='Test';
    jsonReq.Network='Test';
    jsonReq.ConsumerAccountIndicator='Test';
    
    String additionalInfoStr  = JSON.serialize(jsonReq);
    
    ApexPages.currentPage().getParameters().put('additionalInfo',TestDataFactory.createACETHighlightsPanelAdditionalInfo());
    
    MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse1 = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', ACETTestDataUtility.getGetDocWebserviceResponse());
    OILResponse1.TokenExpired = false;        
    MockHttpCalloutResponseGenerator MockHttpRes1 = new MockHttpCalloutResponseGenerator(null, OILResponse1);
    Test.setMock(HttpCalloutMock.class, MockHttpRes1);    
        PageReference pageRef = Page.ACETFormsHistory;
    test.setCurrentPage(pageRef); 
        ApexPages.currentPage().getParameters().put('DocId','7f183de6');
    ApexPages.currentPage().getParameters().put('docType','ACET Letter');
    ApexPages.currentPage().getParameters().put('isDocSizeMoreThanOneMB','false');
    ApexPages.currentPage().getParameters().put('docContentType','application/PDF');
                ApexPages.currentPage().getParameters().put('bookOfBusinessTypeCode','OX');

    ACETDocumentController stub = new ACETDocumentController();
    stub.fetchDoc();                        
}

static testMethod void testDocControllerforIdCard(){
    
    MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse1 = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', ACETTestDataUtility.getGetDocWebserviceResponse());
    OILResponse1.TokenExpired = false;        
    MockHttpCalloutResponseGenerator MockHttpRes1 = new MockHttpCalloutResponseGenerator(null, OILResponse1);
    Test.setMock(HttpCalloutMock.class, MockHttpRes1);    
        PageReference pageRef = Page.ACETFormsHistory;
    test.setCurrentPage(pageRef); 
        ApexPages.currentPage().getParameters().put('DocId','7f183de6');
    ApexPages.currentPage().getParameters().put('docType','ACET Letter');
    //  ApexPages.currentPage().getParameters().put('DocId','7f183de6');
    ApexPages.currentPage().getParameters().put('docContentType','application/pdf');
    ApexPages.currentPage().getParameters().put('IsDocSizeMoreThanOneMB','false');      
    ApexPages.currentPage().getParameters().put('idCard','true'); 
    ApexPages.currentPage().getParameters().put('additionalInfo',TestDataFactory.createACETHighlightsPanelAdditionalInfo());
        
            ApexPages.currentPage().getParameters().put('bookOfBusinessTypeCode','OX');

    
    ACETDocumentController stub = new ACETDocumentController();
    stub.fetchDoc();                        
}

static testMethod void testGetDocContent(){
    Temp_Document__c td = new Temp_Document__c();
    insert td;
    Attachment a = new Attachment();
    a.Name = '7f183de6';
    a.parentId = td.Id;
    a.body = blob.valueof('test');
    a.ContentType = 'application/pdf';
    insert a;
    
    
    ISL_Webservice_Config__c islWebServConfig=new ISL_Webservice_Config__c();
    islWebServConfig.Name='dev_GetIndividualEndpoint';
    islWebServConfig.Value__c='/api/alpha/cel/eisl/cirrus/individuals/v2.0/read';
    try{
    insert islWebServConfig;
    }catch(exception ex){
        system.debug('test'+ex);
    }
    Organization_Properties__c orgProps = Organization_Properties__c.getOrgDefaults();
    orgProps.OrganizationName__c = 'QA';
    Upsert orgProps;
    // Token API data
    WebserviceConfigurations__c starTokenAPIWSConfig = ACET_WebserviceCalloutFramework_Test.createTokenWSConfigs('StarGateTokenAPI');
    OrgSpecificConfigurations__c starTokenAPIOrgSpecificConfigs = ACET_WebserviceCalloutFramework_Test.createTokenOrgWSConfigs(starTokenAPIWSConfig.Id);
    starTokenAPIOrgSpecificConfigs.EnableErrorLog__c=true;
    update starTokenAPIOrgSpecificConfigs;

    // Service API data
    WebserviceConfigurations__c orswsConfig = ACET_WebserviceCalloutFramework_Test.createWSConfig('ACETGetProducerAPI', starTokenAPIWSConfig.Id);
    OrgSpecificConfigurations__c orsorgSpecificConfigs = ACET_WebserviceCalloutFramework_Test.createOrgWSConfigs(orswsConfig.Id);
    orsorgSpecificConfigs.EnableErrorLog__c=true;
    update orsorgSpecificConfigs;
    
    Test.startTest();
    ACETHighlightsPanelAdditionalInfo jsonReq = new ACETHighlightsPanelAdditionalInfo();
    jsonReq.Relationship='Test';   
    jsonReq.SitusState='Test';
    jsonReq.DOB='09/28/2016';
    jsonReq.EndDate='09/28/2016';
    jsonReq.EffectiveDate='09/28/2016';
    jsonReq.PolicyNumber='12345';
    jsonReq.GroupName='Test';
    jsonReq.Product='Test';
    jsonReq.ProductType='Test';
    jsonReq.Network='Test';
    jsonReq.ConsumerAccountIndicator='Testa';
    
    String additionalInfoStr  = JSON.serialize(jsonReq);
    
    
    ApexPages.currentPage().getParameters().put('additionalInfo',TestDataFactory.createACETHighlightsPanelAdditionalInfo());
    ApexPages.currentPage().getParameters().put('groupID','1198485');
    ApexPages.currentPage().getParameters().put('SRK','1198485');
    MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse1 = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', ACETTestDataUtility.GetProducerJSON());//getGetDocWebserviceResponse());
    OILResponse1.TokenExpired = false;        
    MockHttpCalloutResponseGenerator MockHttpRes1 = new MockHttpCalloutResponseGenerator(null, OILResponse1);
    Test.setMock(HttpCalloutMock.class, MockHttpRes1);    

            ApexPages.currentPage().getParameters().put('bookOfBusinessTypeCode','OX');

    ACETDocumentController.getDocContent(a.Id);
    Test.stopTest();
        PageReference pageRef = Page.ACETFormsHistory;
    test.setCurrentPage(pageRef); 
        ApexPages.currentPage().getParameters().put('DocId','7f183de6');
    ApexPages.currentPage().getParameters().put('docType','ACET Letter');
    /* ACETHighlightsPanelAdditionalInfo jsonReq = new ACETHighlightsPanelAdditionalInfo();
    jsonReq.Relationship='Test';   
    jsonReq.SitusState='Test';
    jsonReq.DOB='09/28/2016';
    jsonReq.EndDate='09/28/2016';
    jsonReq.EffectiveDate='09/28/2016';
    jsonReq.PolicyNumber='12345';
    jsonReq.GroupName='Test';
    jsonReq.Product='Test';
    jsonReq.ProductType='Test';
    jsonReq.Network='Test';
    jsonReq.ConsumerAccountIndicator='Test';
    
    String additionalInfoStr  = JSON.serialize(jsonReq);
    
    ApexPages.currentPage().getParameters().put('additionalInfo',TestDataFactory.createACETHighlightsPanelAdditionalInfo());
    */
    ApexPages.currentPage().getParameters().put('additionalInfo',TestDataFactory.createACETHighlightsPanelAdditionalInfo());
                ApexPages.currentPage().getParameters().put('bookOfBusinessTypeCode','OX');

    ACETDocumentController ac = new ACETDocumentController();
        List<Document_Type_Flow__mdt> dtfs = [select Document_Type__r.WS_Field_Name__c, Document_Type__r.Document_Type__c, WS_Backup_Address_Type__c, WS_Primary_Address_Type__c,isAlternateAddress__c, Subscriber_Only__c from Document_Type_Flow__mdt where Subscriber_Only__c=true limit 1];//where Flow__c = :flow and Is_Member_Focus__c = :isMemberFocus and Document_Type__r.Document_Type__c = :documentType];
    // try{
    ac.findProducerInfo(dtfs[0]);
    //  }catch(exception ex){}
    ac.getProfileName();
    
    try{
    ac.findMemberInfo(dtfs[0]);
    }catch(exception ex){
        system.debug('test exception2 '+ex);
    }
}

static testMethod void testGetDocContent3(){
    Temp_Document__c td = new Temp_Document__c();
    insert td;
    Attachment a = new Attachment();
    a.Name = '7f183de6';
    a.parentId = td.Id;
    a.body = blob.valueof('test');
    a.ContentType = 'application/pdf';
    insert a;
    
    
    ISL_Webservice_Config__c islWebServConfig=new ISL_Webservice_Config__c();
    islWebServConfig.Name='dev_GetIndividualEndpoint';
    islWebServConfig.Service_Name__c='GetIndividualEndpoint';
    islWebServConfig.Value__c='/api/alpha/cel/eisl/cirrus/individuals/v2.0/read';
    try{
    insert islWebServConfig;
    }catch(exception ex){
        system.debug('test exception3 '+ex);
    }
    
    ISL_Webservice_Config__c islWebServConfigsecond=new ISL_Webservice_Config__c();
    islWebServConfigsecond.Name='dev_GetFamilyMembersEndpoint';
    islWebServConfigsecond.Service_Name__c='GetFamilyMembersEndpoint';
    islWebServConfigsecond.Value__c='/api/alpha/eisl/individuals/familymembership/v2.0/read';
    try{
    insert islWebServConfigsecond;
    }catch(exception ex){
        system.debug('test exception4 '+ex);
    }
    
    ISL_Webservice_Config__c islWebServConfigthird=new ISL_Webservice_Config__c();
    islWebServConfigthird.Name='dev_FindMembershipEndpoint';
    islWebServConfigthird.Service_Name__c='FindMembershipEndpoint';
    islWebServConfigthird.Value__c='/api/alpha/eisl/individuals/membership/v2.0/search';
    try{
    insert islWebServConfigthird;
    }catch(exception ex){
        system.debug('test exception5 '+ex);
    }
    
    Test.startTest();
    ACETHighlightsPanelAdditionalInfo jsonReq = new ACETHighlightsPanelAdditionalInfo();
    jsonReq.Relationship='Test';   
    jsonReq.SitusState='Test';
    jsonReq.DOB='09/28/2016';
    jsonReq.EndDate='09/28/2016';
    jsonReq.EffectiveDate='09/28/2016';
    jsonReq.PolicyNumber='12345';
    jsonReq.GroupName='Test';
    jsonReq.Product='Test';
    jsonReq.ProductType='Test';
    jsonReq.Network='Test';
    jsonReq.ConsumerAccountIndicator='Testa';

    ApexPages.currentPage().getParameters().put('additionalInfo',TestDataFactory.createACETHighlightsPanelAdditionalInfo());
    ApexPages.currentPage().getParameters().put('groupID','1198485');
    ApexPages.currentPage().getParameters().put('SRK','1198485');
    MockHttpCalloutResponseGenerator.MockHttpResponse oilresponse = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', '{"getIndividualResponse":{"individual":{"individualIdentifier":"455546547","name":{"firstName":"SubFN7","lastName":"SubLN7","middleName":"A","nameSuffix":""},"birthDate":"2015-05-05","Age":"10","genderCode":"M","genderDescription":"Male","socialSecurityNumber":"","maritalStatusCode":"","maritalStatusDescription":"","deceasedDate":"","privacyIndicator":"","tobaccoUsageIndicator":"","ethnicityCode":"","ethnicityDescription":"","address":[{"typeCode":"MAIL","addressLine1":"653 Street line 1","addressLine2":"","city":"HARTFORD","postalCode":"06103","stateCode":"CT","countryCode":"US"}],"phone":[{"phoneType":"H","phoneNumber":"321-686-5384","phoneExt":"","internationalIndicator":"N","primaryIndicator":"Y"}],"email":[{"communicationTypeCode":"EML","electronicAddress":"abc@gmail.com","primaryIndicator":"Y"}],"employment":[{"employmentStatus":"A","employeeIdentifier":"","employmentStartDate":"2017-01-01","retirementDate":"9999-12-31"}],"language":[{}],"otherContact":[{}],"dependentDisabilityList":[{}],"identifiers":[{"id":"620692686","type":"SRK"}]}}}');        
    oilresponse.TokenExpired = false;        
    MockHttpCalloutResponseGenerator mockHttpRes = new MockHttpCalloutResponseGenerator(null, oilresponse);
    Test.setMock(HttpCalloutMock.class, mockHttpRes);    

    ApexPages.currentPage().getParameters().put('bookOfBusinessTypeCode','OX');

    ACETDocumentController.getDocContent(a.Id);
    Test.stopTest();
    PageReference pageRef = Page.ACETFormsHistory;
    test.setCurrentPage(pageRef); 
    ApexPages.currentPage().getParameters().put('DocId','7f183de6');
    ApexPages.currentPage().getParameters().put('docType','ACET Letter');
    ApexPages.currentPage().getParameters().put('additionalInfo',TestDataFactory.createACETHighlightsPanelAdditionalInfo());
    ApexPages.currentPage().getParameters().put('bookOfBusinessTypeCode','OX');

    ACETDocumentController ac = new ACETDocumentController();
    List<Document_Type_Flow__mdt> dtfs = [select Document_Type__r.WS_Field_Name__c, Document_Type__r.Document_Type__c, WS_Backup_Address_Type__c, WS_Primary_Address_Type__c,isAlternateAddress__c, Subscriber_Only__c from Document_Type_Flow__mdt where Subscriber_Only__c=true limit 1];//where Flow__c = :flow and Is_Member_Focus__c = :isMemberFocus and Document_Type__r.Document_Type__c = :documentType];
    
    try{
        ac.findMemberInfo(dtfs[0]);
    }catch(exception ex){
        system.debug('test exception6 '+ex);
    }
}

static testMethod void testGetDocContent2(){
    Temp_Document__c td = new Temp_Document__c();
    insert td;
    Attachment a = new Attachment();
    a.Name = '7f183de6';
    a.parentId = td.Id;
    a.body = blob.valueof('test');
    a.ContentType = 'application/pdf';
    insert a;
    ACETOnshoreIndicatorVerbiage__c verbiage = new ACETOnshoreIndicatorVerbiage__c();
    verbiage.Code__c = 123;
    verbiage.Code_Description__c = claimTrnsc;
    verbiage.Hover_Help_Description__c = claimTrnsc;
    verbiage.Name = claimTrnsc;
    insert verbiage;
    verbiage = new ACETOnshoreIndicatorVerbiage__c();
    verbiage.Code__c = 124;
    verbiage.Code_Description__c = serviceOnshore;
    verbiage.Hover_Help_Description__c = serviceOnshore;
    verbiage.Name = serviceOnshore;
    insert verbiage;
    verbiage = new ACETOnshoreIndicatorVerbiage__c();
    verbiage.Code__c = 125;
    verbiage.Code_Description__c = serviceOffshore;
    verbiage.Hover_Help_Description__c = serviceOffshore;
    verbiage.Name = serviceOffshore;
    insert verbiage;
    ISL_Webservice_Config__c islWebServConfig=new ISL_Webservice_Config__c();
    islWebServConfig.Name='dev_GetEmployerGroupEndpoint';
    islWebServConfig.Value__c='/api/alpha/cdm/cust/eisl/employer-groups/v4.0/read';
    try{
    insert islWebServConfig;
    }catch(exception ex){
        system.debug('test exception7 '+ex);
    }
    Test.startTest();
    ACETHighlightsPanelAdditionalInfo jsonReq = new ACETHighlightsPanelAdditionalInfo();
    jsonReq.Relationship='Test';   
    jsonReq.SitusState='Test';
    jsonReq.DOB='09/28/2016';
    jsonReq.EndDate='09/28/2016';
    jsonReq.EffectiveDate='09/28/2016';
    jsonReq.PolicyNumber='12345';
    jsonReq.GroupName='Test';
    jsonReq.Product='Test';
    jsonReq.ProductType='Test';
    jsonReq.Network='Test';
    jsonReq.ConsumerAccountIndicator='Testa';
    
    ApexPages.currentPage().getParameters().put('additionalInfo',TestDataFactory.createACETHighlightsPanelAdditionalInfo());
    ApexPages.currentPage().getParameters().put('groupID','1198485');
    ApexPages.currentPage().getParameters().put('SRK','1198485');
    ApexPages.currentPage().getParameters().put('bookOfBusinessTypeCode','OX');

    ACETDocumentController.getDocContent(a.Id);
    Test.stopTest();
    PageReference pageRef = Page.ACETFormsHistory;
    test.setCurrentPage(pageRef); 
    ApexPages.currentPage().getParameters().put('DocId','7f183de6');
    ApexPages.currentPage().getParameters().put('docType','ACET Letter');
    ApexPages.currentPage().getParameters().put('additionalInfo',TestDataFactory.createACETHighlightsPanelAdditionalInfo());
    ApexPages.currentPage().getParameters().put('bookOfBusinessTypeCode','OX');

    ACETDocumentController ac = new ACETDocumentController();
    
    MockHttpCalloutResponseGenerator.MockHttpResponse oilresponsenew = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', ACETTestDataUtility.getEmployerGroupJSON());
    oilresponsenew.TokenExpired = false;        
    MockHttpCalloutResponseGenerator mockHttpResnew = new MockHttpCalloutResponseGenerator(null, oilresponsenew);
    Test.setMock(HttpCalloutMock.class, mockHttpResnew); 
    ac.findGroupInfo();
    
    
}
static testMethod void testmemflow1(){
    system.debug('ENTERED TESTMEMFLOW');
    MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', '{"getIndividualResponse":{"individual":{"individualIdentifier":"455546547","name":{"firstName":"SubFN7","lastName":"SubLN7","middleName":"A","nameSuffix":""},"birthDate":"1980-05-05","Age":"10","genderCode":"M","genderDescription":"Male","socialSecurityNumber":"","maritalStatusCode":"","maritalStatusDescription":"","deceasedDate":"","privacyIndicator":"","tobaccoUsageIndicator":"","ethnicityCode":"","ethnicityDescription":"","address":[{"typeCode":"MAIL","addressLine1":"653 Street line 1","addressLine2":"","city":"HARTFORD","postalCode":"06103","stateCode":"CT","countryCode":"US"}],"phone":[{"phoneType":"H","phoneNumber":"321-686-5384","phoneExt":"","internationalIndicator":"N","primaryIndicator":"Y"}],"email":[{"communicationTypeCode":"EML","electronicAddress":"abc@gmail.com","primaryIndicator":"Y"}],"employment":[{"employmentStatus":"A","employeeIdentifier":"","employmentStartDate":"2017-01-01","retirementDate":"9999-12-31"}],"language":[{}],"otherContact":[{}],"identifiers":[{"id":"620692686","type":"SRK"}]}}}');
    OILResponse.TokenExpired = false;        
    MockHttpCalloutResponseGenerator MockHttpRes = new MockHttpCalloutResponseGenerator(null, OILResponse);
    Test.setMock(HttpCalloutMock.class, MockHttpRes);
    
    ACETHighlightsPanelAdditionalInfo addinfo = new ACETHighlightsPanelAdditionalInfo();
    addinfo.MemberId = '123456';
    String addinfojson = JSON.serialize(addinfo);
    
    ApexPages.currentPage().getParameters().put('additionalInfo',addinfojson);

    ApexPages.currentPage().getParameters().put('DocId','7f183de6');
    ApexPages.currentPage().getParameters().put('docType','ACET Letter');
    ApexPages.currentPage().getParameters().put('docContentType','application/pdf');
    ApexPages.currentPage().getParameters().put('IsDocSizeMoreThanOneMB','false');
    ApexPages.currentPage().getParameters().put('idCard','7f183de6');
    ApexPages.currentPage().getParameters().put('SRK','');
                ApexPages.currentPage().getParameters().put('bookOfBusinessTypeCode','OX');

        
    ACETDocumentController stub = new ACETDocumentController();
    stub.Flow = 'Member';
    stub.initDocDelivery();
    
}
static testMethod void testmemflow2(){
    MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', '{"getIndividualResponse":{"individual":{"individualIdentifier":"455546547","name":{"firstName":"SubFN7","lastName":"SubLN7","middleName":"A","nameSuffix":""},"birthDate":"2015-05-05","Age":"10","genderCode":"M","genderDescription":"Male","socialSecurityNumber":"","maritalStatusCode":"","maritalStatusDescription":"","deceasedDate":"","privacyIndicator":"","tobaccoUsageIndicator":"","ethnicityCode":"","ethnicityDescription":"","address":[{"typeCode":"HOM","addressLine1":"653 Street line 1","addressLine2":"","city":"HARTFORD","postalCode":"06103","stateCode":"CT","countryCode":"US"}],"phone":[{"phoneType":"H","phoneNumber":"321-686-5384","phoneExt":"","internationalIndicator":"N","primaryIndicator":"Y"}],"email":[{"communicationTypeCode":"EML","electronicAddress":"abc@gmail.com","primaryIndicator":"Y"}],"employment":[{"employmentStatus":"A","employeeIdentifier":"","employmentStartDate":"2017-01-01","retirementDate":"9999-12-31"}],"language":[{}],"otherContact":[{}],"identifiers":[{"id":"620692686","type":"SRK"}]}}}');
    OILResponse.TokenExpired = false;        
    MockHttpCalloutResponseGenerator MockHttpRes = new MockHttpCalloutResponseGenerator(null, OILResponse);
    Test.setMock(HttpCalloutMock.class, MockHttpRes);
    
    ACETHighlightsPanelAdditionalInfo addinfo = new ACETHighlightsPanelAdditionalInfo();
    addinfo.MemberId = '123456';
    String addinfojson = JSON.serialize(addinfo);
    
    ApexPages.currentPage().getParameters().put('additionalInfo',addinfojson);

    ApexPages.currentPage().getParameters().put('DocId','7f183de6');
    ApexPages.currentPage().getParameters().put('docType','ACET Letter');
    ApexPages.currentPage().getParameters().put('docContentType','application/pdf');
    ApexPages.currentPage().getParameters().put('IsDocSizeMoreThanOneMB','false');
    ApexPages.currentPage().getParameters().put('idCard','7f183de6');
    ApexPages.currentPage().getParameters().put('SRK','');
                ApexPages.currentPage().getParameters().put('bookOfBusinessTypeCode','OX');

        
    ACETDocumentController stub = new ACETDocumentController();
    stub.Flow = 'Member';
    stub.initDocDelivery();
    
}
static testMethod void testproducerflow(){
    MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', '{"response": { "serviceAttributes":{"applicationIdentifier": "IVR","requestIdentifier": "2d537d12-b1fd-4d7a-b990-40dfb1c23426","responseCode": "200","responseDescription": "Success:Trace of all the success calls","totalNumberOfRecords": "9","pageNumber": "","recordsPerPage": ""},"getProducerResponse":{"producerID": "167106","memberGroupDetails":[{"groupNumber": "2100105","groupName": "10404 - Scenario 5 "},{"groupNumber": "9786013","groupName": "SB UHG Scenario 4"},{"groupNumber": "1110176","groupName": "UHG SHOP Test contract 26"},{"groupNumber": "5110301","groupName": "Test UHG contract 31"},{"groupNumber": "1110111","groupName": "UHG SHOP Test contract 15"},{"groupNumber": "9966214","groupName": "Test contract 2"},{"groupNumber": "9966231","groupName": "Test contract 2"},{"groupNumber": "7676005","groupName": "SB UHG Scenario 1"},{"groupNumber": "8110400","groupName": "Test UHG PR contract 1"}],"producerCompanyName": "","producerName":{"firstName": "SAMUEL","middleInitial": "J","lastName": "GRUBBS"},"producerTIN": "","producerSSN": "987167106","producerType": "I ","type": "BR","producerContact": " ","producerEffectiveStartDate": "08/23/2007","producerEffectiveEndDate": "12/31/2016","producerAddress":{"addressTypeCode": "M","addressLine1": "647 LUVERNE AVE","addressLine2": "","city": "PANAMA CITY","state": "FL","zipCode": "32401","country": "","phoneNumber": "8507695215"},"producerStatus": "InActive","legacyBrokerCode": ""}}}');        OILResponse.TokenExpired = false;        
    MockHttpCalloutResponseGenerator MockHttpRes = new MockHttpCalloutResponseGenerator(null, OILResponse);
    Test.setMock(HttpCalloutMock.class, MockHttpRes);
    
    ACETHighlightsPanelAdditionalInfo addinfo = new ACETHighlightsPanelAdditionalInfo();
    addinfo.producerId = '123456';
    String addinfojson = JSON.serialize(addinfo);
    
    ApexPages.currentPage().getParameters().put('additionalInfo',addinfojson);

    ApexPages.currentPage().getParameters().put('DocId','7f183de6');
    ApexPages.currentPage().getParameters().put('docType','Enrollment Letter');
    ApexPages.currentPage().getParameters().put('docContentType','application/pdf');
    ApexPages.currentPage().getParameters().put('IsDocSizeMoreThanOneMB','false');
    ApexPages.currentPage().getParameters().put('idCard','7f183de6');
    ApexPages.currentPage().getParameters().put('SRK','');
                ApexPages.currentPage().getParameters().put('bookOfBusinessTypeCode','OX');

        
    ACETDocumentController stub = new ACETDocumentController();
    stub.Flow = 'Producer';
    stub.initDocDelivery();
    
}
static testMethod void testProviderFlow2(){
    /*Contact cont = new Contact();
    cont.FirstName='Test';
    cont.LastName='Test';
    cont.Tax_ID__c = '123456789';
    cont.EID__c = '123456789';
    insert cont;*/
            RecordType newRecord = [SELECT Id FROM RecordType WHERE Name = 'Person Account' and SObjectType = 'Account'];
    
    Account accountTest = new Account();
    accountTest.FirstName = 'TestFirst';
    accountTest.LastName = 'TestLast';
    accountTest.EID__c = '12345';
    accountTest.EID__pc = '12345';
    accountTest.RecordTypeId = newRecord.Id;
    insert accountTest;
    
    Account acc = [SELECT Id,personcontactid from Account where Id=:accountTest.Id];
    Contact cont = [SELECT Id,LastName,FirstName,EID__c,AccountId from Contact where Id=:acc.personcontactid];
        
    
    Interaction__c interaction = new Interaction__c();
    interaction.Originator__c = cont.Id; 
    interaction.Interaction_Type__c = 'Phone Call';
    //interaction.Originator_Type__c = 'Group/Employer';        
    insert interaction;
    
    Material_Forms__c mform = new Material_Forms__c();
    mform.FulfillmentType__c = '10700';
    mform.FulfillmentType_Description__c = 'Blank Form';
    mform.Business_Unit__c = '';
    
    insert mform;
    
    List<Material_Forms__c> listMform = new List<Material_Forms__c>();
    listMform.add(mform);
    
    PageReference pageRef = Page.ACETFormsHistory;
    test.setCurrentPage(pageRef); 
    pageRef.getParameters().put('interactionId', interaction.id);
    ApexPages.currentPage().getParameters().put('DocId','7f183de6');
    ApexPages.currentPage().getParameters().put('docType','ACET Letter');
    ApexPages.currentPage().getParameters().put('docContentType','application/pdf');
    ApexPages.currentPage().getParameters().put('IsDocSizeMoreThanOneMB','false');
    ApexPages.currentPage().getParameters().put('idCard','7f183de6');
    ApexPages.currentPage().getParameters().put('SRK','');
    ACETHighlightsPanelAdditionalInfo addinfo = new ACETHighlightsPanelAdditionalInfo();
    //addinfo.MemberId = '123456';
    addinfo.providerType = 'HCO';
    String addinfojson = JSON.serialize(addinfo);
    
    ApexPages.currentPage().getParameters().put('additionalInfo',addinfojson);
    
    //ApexPages.currentPage().getParameters().put('ProvTypeCode','HCO');
    Test.setMock(HttpCalloutMock.class, new FindProviderInfoCalloutMock1());
                ApexPages.currentPage().getParameters().put('bookOfBusinessTypeCode','OX');

    ACETDocumentController stub = new ACETDocumentController();
    stub.Flow = 'Provider';
    stub.initDocDelivery();
    
    
}
static testMethod void testgroupflow(){
    /*MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', '{"getEmployerGroup": {"getEmployerGroupResponse": {"employerGroup": { "groupNumber": "1188478", "groupName": "HARVEYS HILLBILLY PUB", "sourceSysCode": "CIRRUS", "taxIdentificationNumber": ["440537894"], "customerAccount": [ { "planBillingGroupNumber": "6602", "statusCode": "V", "statusDescription": "Validation", "startDate": "2017-12-01", "renewalDate": "2018-12-01", "terminationDate": "9999-12-31", "customerAccountInsuringRules": [ { "dependentCutOff": "26", "dependentCutOffType": "Date of Event", "dependentCutOffStartDate": "2017-01-01", "dependentCutOffEndDate": "9999-12-31", "waiveRehiredIndefiniteIndicator": "0", "terminationLagType": "001", "terminationLagDescription": "Date of Event", "terminationLagStartDate": "2017-12-01", "terminationLagEndDate": "9999-12-31", "newHireWaitingPeriodType": "First of the Following Month (FOFM)", "newHireWaitingStartDate": "2017-12-01", "newHireWaitingEndDate": "9999-12-31" }, { "dependentCutOff": "26", "dependentCutOffType": "Date of Event", "dependentCutOffStartDate": "2017-01-01", "dependentCutOffEndDate": "9999-12-31", "waiveRehiredIndefiniteIndicator": "0", "terminationLagType": "001", "terminationLagDescription": "Date of Event", "terminationLagStartDate": "2017-12-01", "terminationLagEndDate": "9999-12-31", "newHireWaitingPeriodType": "Date of Event", "newHireWaitingStartDate": "2017-12-01", "newHireWaitingEndDate": "9999-12-31" }, { "dependentCutOff": "26", "dependentCutOffType": "Date of Event", "dependentCutOffStartDate": "2017-01-01", "dependentCutOffEndDate": "9999-12-31", "waiveRehiredIndefiniteIndicator": "0", "terminationLagType": "001", "terminationLagDescription": "Date of Event", "terminationLagStartDate": "2017-12-01", "terminationLagEndDate": "9999-12-31", "newHireWaitingPeriodType": "Specified Duration", "newHireWaitingStartDate": "2017-12-01", "newHireWaitingEndDate": "9999-12-31" }, { "dependentCutOff": "26", "dependentCutOffType": "Date of Event", "dependentCutOffStartDate": "2017-01-01", "dependentCutOffEndDate": "9999-12-31", "waiveRehiredIndefiniteIndicator": "0", "terminationLagType": "001", "terminationLagDescription": "Date of Event", "terminationLagStartDate": "2017-12-01", "terminationLagEndDate": "9999-12-31", "newHireWaitingPeriodType": "FOFM after Specified Duration", "newHireWaitingStartDate": "2017-12-01", "newHireWaitingEndDate": "9999-12-31" } ], "customerPurchase": [ { "memberGroupContractPlanOptionID": "140507", "stateOfIssueCode": "CT", "stateOfIssueDescription": "CONNECTICUT", "fundingArrangementCode": "01", "fundingArrangementDescription": "Fully Insured", "coverageStartDate": "2017-12-01", "coverageExpirationDate": "9999-12-31", "benefitBundleOptionID": "1018482", "openEnrollmentStartDate": "2017-11-01", "openEnrollmentEndDate": "2017-11-30", "timePeriodQualifier": "Contract Year", "benefitBasePlan": "M000000011", "benefitPlanDescription": "CTSM MEHIP 05 HMO NG $15/$30", "gatedProductIndicator": "0", "planMetallicLevel": "Platinum", "lineOfBusiness": [ { "name": "Small Business", "description": "Small Business (UHC definition = 2 to 50, and Sole Prop)" }, { "name": "Small Business", "description": "Small Business (UHC definition = 2 to 50, and Sole Prop)" }, { "name": "Small Business", "description": "Small Business (UHC definition = 2 to 50, and Sole Prop)" }, { "name": "Small Business", "description": "Small Business (UHC definition = 2 to 50, and Sole Prop)" } ], "networkScheduleId": [ "FREEDOM", "FREEDOM", "FREEDOM", "FREEDOM" ], "billingSchedule": [ { "ratingMethodology": "02", "contractTypeCode": "5", "amount": "600.00" }, { "ratingMethodology": "02", "contractTypeCode": "1", "amount": "100.00" }, { "ratingMethodology": "02", "contractTypeCode": "2", "amount": "300.00" }, { "ratingMethodology": "02", "contractTypeCode": "3", "amount": "200.00" }, { "ratingMethodology": "02", "contractTypeCode": "4", "amount": "500.00" } ] }] }] }}}}'); 
    OILResponse.TokenExpired = false;        
    MockHttpCalloutResponseGenerator MockHttpRes = new MockHttpCalloutResponseGenerator(null, OILResponse);
    */
    Test.setMock(HttpCalloutMock.class, new FindGroupInfoHttpCalloutMock());
    
    ACETHighlightsPanelAdditionalInfo addinfo = new ACETHighlightsPanelAdditionalInfo();
    //addinfo.MemberId = '123456';
    String addinfojson = JSON.serialize(addinfo);
    
    ApexPages.currentPage().getParameters().put('additionalInfo',addinfojson);
    ApexPages.currentPage().getParameters().put('groupID','testgroupid');
    ApexPages.currentPage().getParameters().put('DocId','7f183de6');
    ApexPages.currentPage().getParameters().put('docType','Oxford SBC');
    ApexPages.currentPage().getParameters().put('docContentType','application/pdf');
    ApexPages.currentPage().getParameters().put('IsDocSizeMoreThanOneMB','false');
    ApexPages.currentPage().getParameters().put('idCard','7f183de6');
    ApexPages.currentPage().getParameters().put('SRK','');
                ApexPages.currentPage().getParameters().put('bookOfBusinessTypeCode','OX');

        
    ACETDocumentController stub = new ACETDocumentController();
    stub.Flow = 'Group';
    stub.initDocDelivery();
    
}
static testMethod void testgroupflow2(){
    /*MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', '{"getEmployerGroup": {"getEmployerGroupResponse": {"employerGroup": { "groupNumber": "1188478", "groupName": "HARVEYS HILLBILLY PUB", "sourceSysCode": "CIRRUS", "taxIdentificationNumber": ["440537894"], "customerAccount": [ { "planBillingGroupNumber": "6602", "statusCode": "V", "statusDescription": "Validation", "startDate": "2017-12-01", "renewalDate": "2018-12-01", "terminationDate": "9999-12-31", "customerAccountInsuringRules": [ { "dependentCutOff": "26", "dependentCutOffType": "Date of Event", "dependentCutOffStartDate": "2017-01-01", "dependentCutOffEndDate": "9999-12-31", "waiveRehiredIndefiniteIndicator": "0", "terminationLagType": "001", "terminationLagDescription": "Date of Event", "terminationLagStartDate": "2017-12-01", "terminationLagEndDate": "9999-12-31", "newHireWaitingPeriodType": "First of the Following Month (FOFM)", "newHireWaitingStartDate": "2017-12-01", "newHireWaitingEndDate": "9999-12-31" }, { "dependentCutOff": "26", "dependentCutOffType": "Date of Event", "dependentCutOffStartDate": "2017-01-01", "dependentCutOffEndDate": "9999-12-31", "waiveRehiredIndefiniteIndicator": "0", "terminationLagType": "001", "terminationLagDescription": "Date of Event", "terminationLagStartDate": "2017-12-01", "terminationLagEndDate": "9999-12-31", "newHireWaitingPeriodType": "Date of Event", "newHireWaitingStartDate": "2017-12-01", "newHireWaitingEndDate": "9999-12-31" }, { "dependentCutOff": "26", "dependentCutOffType": "Date of Event", "dependentCutOffStartDate": "2017-01-01", "dependentCutOffEndDate": "9999-12-31", "waiveRehiredIndefiniteIndicator": "0", "terminationLagType": "001", "terminationLagDescription": "Date of Event", "terminationLagStartDate": "2017-12-01", "terminationLagEndDate": "9999-12-31", "newHireWaitingPeriodType": "Specified Duration", "newHireWaitingStartDate": "2017-12-01", "newHireWaitingEndDate": "9999-12-31" }, { "dependentCutOff": "26", "dependentCutOffType": "Date of Event", "dependentCutOffStartDate": "2017-01-01", "dependentCutOffEndDate": "9999-12-31", "waiveRehiredIndefiniteIndicator": "0", "terminationLagType": "001", "terminationLagDescription": "Date of Event", "terminationLagStartDate": "2017-12-01", "terminationLagEndDate": "9999-12-31", "newHireWaitingPeriodType": "FOFM after Specified Duration", "newHireWaitingStartDate": "2017-12-01", "newHireWaitingEndDate": "9999-12-31" } ], "customerPurchase": [ { "memberGroupContractPlanOptionID": "140507", "stateOfIssueCode": "CT", "stateOfIssueDescription": "CONNECTICUT", "fundingArrangementCode": "01", "fundingArrangementDescription": "Fully Insured", "coverageStartDate": "2017-12-01", "coverageExpirationDate": "9999-12-31", "benefitBundleOptionID": "1018482", "openEnrollmentStartDate": "2017-11-01", "openEnrollmentEndDate": "2017-11-30", "timePeriodQualifier": "Contract Year", "benefitBasePlan": "M000000011", "benefitPlanDescription": "CTSM MEHIP 05 HMO NG $15/$30", "gatedProductIndicator": "0", "planMetallicLevel": "Platinum", "lineOfBusiness": [ { "name": "Small Business", "description": "Small Business (UHC definition = 2 to 50, and Sole Prop)" }, { "name": "Small Business", "description": "Small Business (UHC definition = 2 to 50, and Sole Prop)" }, { "name": "Small Business", "description": "Small Business (UHC definition = 2 to 50, and Sole Prop)" }, { "name": "Small Business", "description": "Small Business (UHC definition = 2 to 50, and Sole Prop)" } ], "networkScheduleId": [ "FREEDOM", "FREEDOM", "FREEDOM", "FREEDOM" ], "billingSchedule": [ { "ratingMethodology": "02", "contractTypeCode": "5", "amount": "600.00" }, { "ratingMethodology": "02", "contractTypeCode": "1", "amount": "100.00" }, { "ratingMethodology": "02", "contractTypeCode": "2", "amount": "300.00" }, { "ratingMethodology": "02", "contractTypeCode": "3", "amount": "200.00" }, { "ratingMethodology": "02", "contractTypeCode": "4", "amount": "500.00" } ] }] }] }}}}'); 
    OILResponse.TokenExpired = false;        
    MockHttpCalloutResponseGenerator MockHttpRes = new MockHttpCalloutResponseGenerator(null, OILResponse);
    */
    Test.setMock(HttpCalloutMock.class, new FindGroupInfoMockCorpAdd());
    
    ACETHighlightsPanelAdditionalInfo addinfo = new ACETHighlightsPanelAdditionalInfo();
    //addinfo.MemberId = '123456';
    String addinfojson = JSON.serialize(addinfo);
    
    ApexPages.currentPage().getParameters().put('additionalInfo',addinfojson);
    ApexPages.currentPage().getParameters().put('groupID','testgroupid');
    ApexPages.currentPage().getParameters().put('DocId','7f183de6');
    ApexPages.currentPage().getParameters().put('docType','Oxford SBC');
    ApexPages.currentPage().getParameters().put('docContentType','application/pdf');
    ApexPages.currentPage().getParameters().put('IsDocSizeMoreThanOneMB','false');
    ApexPages.currentPage().getParameters().put('idCard','7f183de6');
    ApexPages.currentPage().getParameters().put('SRK','');
            ApexPages.currentPage().getParameters().put('bookOfBusinessTypeCode','OX');

        
    ACETDocumentController stub = new ACETDocumentController();
    stub.Flow = 'Group';
    stub.initDocDelivery();
    
}
static testMethod void testInit(){       
    /* Contact cont = new Contact();
    cont.FirstName='Test';
    cont.LastName='Test';
    cont.Tax_ID__c = '123456789';
    insert cont;*/
            RecordType newRecord = [SELECT Id FROM RecordType WHERE Name = 'Person Account' and SObjectType = 'Account'];
    
    Account accountTest = new Account();
    accountTest.FirstName = 'TestFirst';
    accountTest.LastName = 'TestLast';
    accountTest.EID__c = '12345';
    accountTest.EID__pc = '12345';
    accountTest.RecordTypeId = newRecord.Id;
    insert accountTest;
    
    Account acc = [SELECT Id,personcontactid from Account where Id=:accountTest.Id];
    Contact cont = [SELECT Id,LastName,FirstName,EID__c,AccountId from Contact where Id=:acc.personcontactid];
        
    
    Interaction__c interaction = new Interaction__c();
    interaction.Originator__c = cont.Id; 
    interaction.Interaction_Type__c = 'Phone Call';
    interaction.Originator_Type__c = 'Member';        
    insert interaction;
    
    ACETHighlightsPanelAdditionalInfo addinfo = new ACETHighlightsPanelAdditionalInfo();
    addinfo.MemberId = '123456';
    String addinfojson = JSON.serialize(addinfo);
    
    ApexPages.currentPage().getParameters().put('interactionId', interaction.Id);
    ApexPages.currentPage().getParameters().put('additionalInfo',addinfojson);

    ApexPages.currentPage().getParameters().put('DocId','7f183de6');
    ApexPages.currentPage().getParameters().put('docType','ACET Letter');
    ApexPages.currentPage().getParameters().put('docContentType','application/pdf');
    ApexPages.currentPage().getParameters().put('IsDocSizeMoreThanOneMB','false');
    ApexPages.currentPage().getParameters().put('idCard','7f183de6');
    ApexPages.currentPage().getParameters().put('SRK','');
                ApexPages.currentPage().getParameters().put('bookOfBusinessTypeCode','OX');

    ACETDocumentController stub = new ACETDocumentController();

}
static testMethod void testgetFlow1(){
    /* Contact cont = new Contact();
    cont.FirstName='Test';
    cont.LastName='Test';
    cont.Tax_ID__c = '123456789';
    cont.EID__c = '123456789';
    insert cont;*/
            RecordType newRecord = [SELECT Id FROM RecordType WHERE Name = 'Person Account' and SObjectType = 'Account'];
    
    Account accountTest = new Account();
    accountTest.FirstName = 'TestFirst';
    accountTest.LastName = 'TestLast';
    accountTest.EID__c = '12345';
    accountTest.EID__pc = '12345';
    accountTest.RecordTypeId = newRecord.Id;
    insert accountTest;
    
    Account acc = [SELECT Id,personcontactid from Account where Id=:accountTest.Id];
    Contact cont = [SELECT Id,LastName,FirstName,EID__c,AccountId from Contact where Id=:acc.personcontactid];
        
    
    Interaction__c interaction = new Interaction__c();
    interaction.Originator__c = cont.Id; 
    interaction.Interaction_Type__c = 'Phone Call';
    interaction.Originator_Type__c = 'Member';        
    insert interaction;
    ApexPages.currentPage().getParameters().put('interactionId', interaction.id);
    ApexPages.currentPage().getParameters().put('DocId','7f183de6');
    ApexPages.currentPage().getParameters().put('docType','ACET Letter');
    ApexPages.currentPage().getParameters().put('docContentType','application/pdf');
    ApexPages.currentPage().getParameters().put('IsDocSizeMoreThanOneMB','false');
    ApexPages.currentPage().getParameters().put('idCard','7f183de6');
    ApexPages.currentPage().getParameters().put('SRK','');
    ACETHighlightsPanelAdditionalInfo addinfo = new ACETHighlightsPanelAdditionalInfo();
    addinfo.MemberId = '123456';
    addinfo.providerType = 'HCO';
    String addinfojson = JSON.serialize(addinfo);
    
    ApexPages.currentPage().getParameters().put('additionalInfo',addinfojson);
                ApexPages.currentPage().getParameters().put('bookOfBusinessTypeCode','OX');

    //ApexPages.currentPage().getParameters().put('ProvTypeCode','HCO');
    ACETDocumentController stub = new ACETDocumentController();
}
static testMethod void testgetFlow2(){
    /* Contact cont = new Contact();
    cont.FirstName='Test';
    cont.LastName='Test';
    cont.Tax_ID__c = '123456789';
    cont.EID__c = '123456789';
    insert cont;*/
            RecordType newRecord = [SELECT Id FROM RecordType WHERE Name = 'Person Account' and SObjectType = 'Account'];
    
    Account accountTest = new Account();
    accountTest.FirstName = 'TestFirst';
    accountTest.LastName = 'TestLast';
    accountTest.EID__c = '12345';
    accountTest.EID__pc = '12345';
    accountTest.RecordTypeId = newRecord.Id;
    insert accountTest;
    
    Account acc = [SELECT Id,personcontactid from Account where Id=:accountTest.Id];
    Contact cont = [SELECT Id,LastName,FirstName,EID__c,AccountId from Contact where Id=:acc.personcontactid];
        
    
    Interaction__c interaction = new Interaction__c();
    interaction.Originator__c = cont.Id; 
    interaction.Interaction_Type__c = 'Phone Call';
    interaction.Originator_Type__c = 'Group/Employer';        
    insert interaction;
    ApexPages.currentPage().getParameters().put('interactionId', interaction.id);
    ApexPages.currentPage().getParameters().put('DocId','7f183de6');
    ApexPages.currentPage().getParameters().put('docType','ACET Letter');
    ApexPages.currentPage().getParameters().put('docContentType','application/pdf');
    ApexPages.currentPage().getParameters().put('IsDocSizeMoreThanOneMB','false');
    ApexPages.currentPage().getParameters().put('idCard','7f183de6');
    ApexPages.currentPage().getParameters().put('SRK','');
    ACETHighlightsPanelAdditionalInfo addinfo = new ACETHighlightsPanelAdditionalInfo();
    addinfo.MemberId = '123456';
    addinfo.providerType = 'HCO';
    String addinfojson = JSON.serialize(addinfo);
    
    ApexPages.currentPage().getParameters().put('additionalInfo',addinfojson);
                ApexPages.currentPage().getParameters().put('bookOfBusinessTypeCode','OX');

    //ApexPages.currentPage().getParameters().put('ProvTypeCode','HCO');
    ACETDocumentController stub = new ACETDocumentController();
}
static testMethod void testgetFlow3(){
    Contact cont = new Contact();
    cont.FirstName='Test';
    cont.LastName='Test';
    cont.Tax_ID__c = '123456789';
    cont.EID__c = '123456789';
    insert cont;
    
    Interaction__c interaction = new Interaction__c();
    interaction.Originator__c = cont.Id; 
    interaction.Interaction_Type__c = 'Phone Call';
    interaction.Originator_Type__c = 'Producer';        
    insert interaction;
    ApexPages.currentPage().getParameters().put('interactionId', interaction.id);
    ApexPages.currentPage().getParameters().put('DocId','7f183de6');
    ApexPages.currentPage().getParameters().put('docType','ACET Letter');
    ApexPages.currentPage().getParameters().put('docContentType','application/pdf');
    ApexPages.currentPage().getParameters().put('IsDocSizeMoreThanOneMB','false');
    ApexPages.currentPage().getParameters().put('idCard','7f183de6');
    ApexPages.currentPage().getParameters().put('SRK','');
    ACETHighlightsPanelAdditionalInfo addinfo = new ACETHighlightsPanelAdditionalInfo();
    addinfo.MemberId = '123456';
    String addinfojson = JSON.serialize(addinfo);
    
    ApexPages.currentPage().getParameters().put('additionalInfo',addinfojson);
                ApexPages.currentPage().getParameters().put('bookOfBusinessTypeCode','OX');

    /////ApexPages.currentPage().getParameters().put('ProvTypeCode','HCO');
    ACETDocumentController stub = new ACETDocumentController();
}
static testMethod void testgetFlow4(){
    /* Contact cont = new Contact();
    cont.FirstName='Test';
    cont.LastName='Test';
    cont.Tax_ID__c = '123456789';
    cont.EID__c = '123456789';
    insert cont;*/
    
            RecordType newRecord = [SELECT Id FROM RecordType WHERE Name = 'Person Account' and SObjectType = 'Account'];
    
    Account accountTest = new Account();
    accountTest.FirstName = 'TestFirst';
    accountTest.LastName = 'TestLast';
    accountTest.EID__c = '12345';
    accountTest.EID__pc = '12345';
    accountTest.RecordTypeId = newRecord.Id;
    insert accountTest;
    
    Account acc = [SELECT Id,personcontactid from Account where Id=:accountTest.Id];
    Contact cont = [SELECT Id,LastName,FirstName,EID__c,AccountId from Contact where Id=:acc.personcontactid];
        
    
    Interaction__c interaction = new Interaction__c();
    interaction.Originator__c = cont.Id; 
    interaction.Interaction_Type__c = 'Phone Call';
    interaction.Originator_Type__c = 'Provider';        
    insert interaction;
    ApexPages.currentPage().getParameters().put('interactionId', interaction.id);
    ApexPages.currentPage().getParameters().put('DocId','7f183de6');
    ApexPages.currentPage().getParameters().put('docType','ACET Letter');
    ApexPages.currentPage().getParameters().put('docContentType','application/pdf');
    ApexPages.currentPage().getParameters().put('IsDocSizeMoreThanOneMB','false');
    ApexPages.currentPage().getParameters().put('idCard','7f183de6');
    ApexPages.currentPage().getParameters().put('SRK','');
    ACETHighlightsPanelAdditionalInfo addinfo = new ACETHighlightsPanelAdditionalInfo();
    //addinfo.MemberId = '123456';
    addinfo.providerType = 'HCO';
    String addinfojson = JSON.serialize(addinfo);
                ApexPages.currentPage().getParameters().put('bookOfBusinessTypeCode','OX');

    ApexPages.currentPage().getParameters().put('additionalInfo',addinfojson);
    ACETDocumentController stub = new ACETDocumentController();
}      
}