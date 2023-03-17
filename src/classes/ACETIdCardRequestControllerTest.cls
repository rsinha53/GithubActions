@isTest
private class ACETIdCardRequestControllerTest {
    @testsetup
    static void prepareData(){
        Organization_Properties__c orgProps = Organization_Properties__c.getOrgDefaults();
        orgProps.OrganizationName__c = 'QA';
        Upsert orgProps;
        // Token API data
        WebserviceConfigurations__c jwtTokenWSConfig = ACET_WebserviceCalloutFramework_Test.createTokenWSConfigs('StargateJWTTokenAPI');
        OrgSpecificConfigurations__c tokenAPIOrgSpecificConfigs = ACET_WebserviceCalloutFramework_Test.createTokenOrgWSConfigs(jwtTokenWSConfig.Id);
        System.debug(tokenAPIOrgSpecificConfigs);

        // Service API data
        WebserviceConfigurations__c wsConfig = ACET_WebserviceCalloutFramework_Test.createWSConfig('SubmitFulfillmentRequestService', jwtTokenWSConfig.Id);
        OrgSpecificConfigurations__c orgSpecificConfigs = ACET_WebserviceCalloutFramework_Test.createOrgWSConfigs(wsConfig.Id);
        System.debug(orgSpecificConfigs);
      
    }
    static testMethod void IdCardReqstContrMethod(){
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
        mapISLWSConfigs.put('dev_ISLOAuthTokenEndpoint', '/auth/oauth/v2/token');
        mapISLWSConfigs.put('OILTimeout', '3000');
        mapISLWSConfigs.put('d1_SubmitfulfillmentrequestEndPoint','/api/cirrus/alpha/fulfillmentgateway/cirrus/v1.0/fulfillmentrequests');
        
        List<ISL_Webservice_Config__c> lstISLWSConfigs = ACETTestDataUtility.CreateISLWebserviceConfigurations(mapISLWSConfigs);
        insert lstISLWSConfigs;
        
        MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse = new MockHttpCalloutResponseGenerator.MockHttpResponse(201, 'OK', '{"externalCorrelationID":"6d7a53c4-a7cc-43d2-9c48-0d3ea0e69af3","metaInformation":null}');
        OILResponse.TokenExpired = false;
        
        MockHttpCalloutResponseGenerator MockHttpRes = new MockHttpCalloutResponseGenerator(null, OILResponse);
        Test.setMock(HttpCalloutMock.class, MockHttpRes);
        
        PageReference ACETIdCardRequest= Page.ACETIdCardRequest;
        String JSONStr = '{"UHCBS":"","GroupN":"Test Group Name","GroupStatus":"Active","ServiceTeam":"NY Large","EffectiveStartDate":"3/1/2016","RiskManagement":"Rating Method","RatingMethod":"","RenewalDate":"3/1/2016","RelationshipType":"Mother","groupSName":"Test GroupName"}';
        String FamilyMemStr='[{"termDate":null,"suffix":"","subscriberIndividualId":"58980221300","selected":false,"Relationship":"Self","reinstDate":null,"MiddleInitial":"","LastName":"Henry","groupNumber":"1118476","Gender":"M","FirstName":"Jacqueline","FamilyId":"58980221300","EID":"154907834","effectiveDate":null,"DOB":"6/17/1969","CoverageStatus":null,"benefitBundleOptionId":"0","Age":"48","Addresses":[{"Zip":"06013","State":"CT","countryCode":"US","City":"BURLINGTON","AddressType":"HOM","AddressLine2":"","AddressLine1":"20882 Havey Circle"}]},{"termDate":null,"suffix":"","subscriberIndividualId":"58980221301","selected":false,"Relationship":"Spouse","reinstDate":null,"MiddleInitial":"","LastName":"Henry","groupNumber":"1118476","Gender":"F","FirstName":"Pete","FamilyId":"58980221301","EID":"154907835","effectiveDate":null,"DOB":"2/12/1972","CoverageStatus":null,"benefitBundleOptionId":"0","Age":"45","Addresses":[{"Zip":"06013","State":"CT","countryCode":"US","City":"BURLINGTON","AddressType":"Mailing","AddressLine2":"","AddressLine1":"20882 Havey Circle"}]}]';
        RecordType newRecord = [SELECT Id FROM RecordType WHERE Name = 'Person Account' and SObjectType = 'Account'];
        
        Account accountTest = new Account();
        accountTest.FirstName = 'Test';
        accountTest.LastName = 'Contact';
        accountTest.EID__c = 'PIN';
        accountTest.EID__pc = 'PIN';
        accountTest.RecordTypeId = newRecord.Id;
        insert accountTest;

    Account acc = [SELECT Id,personcontactid from Account where Id=:accountTest.Id];
        Contact cont = [SELECT Id,LastName,FirstName,EID__c,AccountId from Contact where Id=:acc.personcontactid];
        Interaction__c Interaction = new Interaction__c();
        Interaction.Contact_Name__c = 'Test contname';
        Interaction.Originator__c = cont.id;
        Interaction.Originator_Type__c = 'Group/Employer';
        Interaction.Highlight_Panel_GroupInfo__c = JSONStr;
        insert Interaction ;
        ACETIdCardRequest.getParameters().put('InteractionId', Interaction.Id);
        ACETIdCardRequest.getParameters().put('additionalInfo', TestDataFactory.createACETHighlightsPanelAdditionalInfo());        
        ACETIdCardRequest.getParameters().put('contactId', cont.Id);
        ACETIdCardRequest.getParameters().put('groupId', '123456789');
        ACETIdCardRequest.getParameters().put('memberId', '123456789');    
        ACETIdCardRequest.getParameters().put('familyMembers', FamilyMemStr);
        ACETIdCardRequest.getParameters().put('coverageGroupNumber', '123456789'); 
        ACETIdCardRequest.getParameters().put('coverageEffectiveDate', '07/05/2017'); 
        ACETIdCardRequest.getParameters().put('coverageSRK', '123456789'); 
        Test.setCurrentPage(ACETIdCardRequest);
       
        Test.startTest();
        ACETIdCardRequestController cardrequst = new ACETIdCardRequestController();
        cardrequst.resolved='true';
        cardrequst.familyMember='test';
        cardrequst.Subject = cont;
        cardrequst.getFamilyMembers();
        cardrequst.GetMembershipCallback();
        cardrequst.getPersonInfo();
        cardrequst.documentType = 'IDCARDS';
        cardrequst.DynamicParams='["te,st1","te,st2","te,st3"]';
        cardrequst.findDocument();
        cardrequst.documentId = 'test';
        cardrequst.submitOrderCall();
        ACETSubmitfulfillmentrequest submitRequestWS = new ACETSubmitfulfillmentrequest();
       ACETSubmitfulfillmentrequest.CorrelationIDWrapper cWrapper = new  ACETSubmitfulfillmentrequest.CorrelationIDWrapper();
       cwrapper.externalCorrelationID ='aa00c998-97f7-461d-bcc1-7c1b02741d65';
        HttpResponse response = new HttpResponse();
        //response.setBody(ACETTestDataUtility.getEmployerGroupDetailJson());
        response.setStatusCode(201);
        submitRequestWS.submitFulfillmentRequest('92819483800','1108502','1018483');
        
        
        ACETIdCardRequestController.personWrapper personWrapp=new ACETIdCardRequestController.personWrapper();
        personWrapp.personOrganization='testOrg';
        personWrapp.personFirstName='Kimberly';
        personWrapp.personMiddleName='Joan';
        personWrapp.personLastName='Christina';
        personWrapp.personFullName='Kimberly Joan';
        personWrapp.personSuffix='test';
        personWrapp.personAddOne='testOne';
        personWrapp.personAddTwo='testtwo';
        personWrapp.personCity='Fao Rai';
        personWrapp.personState='NJ';
        personWrapp.personZipCode='98530';
        personWrapp.groupNumber='123456789';
        personWrapp.benefitBundleOptionID='1234567';
        personWrapp.memberId='123456789';
        
        Test.stopTest();
   } 
   static testMethod void IdCardReqstContrMethod2(){
        //Setup records in custom setting
        Map<String, String> mapISLWSConfigs = new Map<String, String>(); 
        mapISLWSConfigs.put('ISLConAccessToken', 'e9b3f2b1-8863-49ec-9ff8-40da25961ef5');
        mapISLWSConfigs.put('OILHttpHeaderAccept', 'application/json;charset=UTF-8');
        mapISLWSConfigs.put('OILHttpHeaderActor', 'ACET');
        mapISLWSConfigs.put('OILHttpHeaderScope', 'read');
        mapISLWSConfigs.put('ISLOAuthContentType', 'application/x-www-form-urlencoded');
        mapISLWSConfigs.put('ISLOAuthGrantType', 'client_credentials');
        mapISLWSConfigs.put('dev_ISLOAuthClientId', 'ISLStageConClientId');
        mapISLWSConfigs.put('dev_ISLOAuthClientSecret', 'ISLStageConClientSecret');
        mapISLWSConfigs.put('dev_ISLOAuthEndpoint', 'https://api-stg.optum.com:8443');
        mapISLWSConfigs.put('dev_ISLOAuthTokenEndpoint', '/auth/oauth/v2/token');
        mapISLWSConfigs.put('OILTimeout', '3000');
        mapISLWSConfigs.put('d1_SubmitfulfillmentrequestEndPoint','/api/cirrus/alpha/fulfillmentgateway/cirrus/v1.0/fulfillmentrequests');
                
        List<ISL_Webservice_Config__c> lstISLWSConfigs = ACETTestDataUtility.CreateISLWebserviceConfigurations(mapISLWSConfigs);
        insert lstISLWSConfigs;
        
        MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse = new MockHttpCalloutResponseGenerator.MockHttpResponse(201, 'OK',ACETTestDataUtility.GetFamilyMembersJSON());
        OILResponse.TokenExpired = false;
         ACETFindDocWebservice service = new ACETFindDocWebservice();
         List<ACETFindDocWebservice.documentKey> findDocKeys = new List<ACETFindDocWebservice.documentKey>();
         ACETFindDocWebservice.documentKey key = new ACETFindDocWebservice.documentKey();
         key.value = '1148123';
         key.name = 'groupNumber';
         findDocKeys.add(key);
         key.value = '123123023';
         key.name = 'memberId';
         findDocKeys.add(key);
         key.value = '00';
         key.name = 'MemberSequenceNumberOrDivision';
         findDocKeys.add(key);
         key.value = '3134';
         key.name = 'clientNumber';
         findDocKeys.add(key);
         
         service.init('IDCARDS', findDocKeys);
         
        MockHttpCalloutResponseGenerator MockHttpRes = new MockHttpCalloutResponseGenerator(null, OILResponse);
        Test.setMock(HttpCalloutMock.class, MockHttpRes);
        service.queryPaginatedData(1,1,1);
        PageReference ACETIdCardRequest= Page.ACETIdCardRequest;
        String JSONStr = '{"UHCBS":"","GroupN":"Test Group Name","GroupStatus":"Active","ServiceTeam":"NY Large","EffectiveStartDate":"3/1/2016","RiskManagement":"Rating Method","RatingMethod":"","RenewalDate":"3/1/2016","RelationshipType":"Mother","groupSName":"Test GroupName"}';
        String FamilyMemStr='[{"termDate":null,"suffix":"","subscriberIndividualId":"58980221300","selected":false,"Relationship":"Self","reinstDate":null,"MiddleInitial":"","LastName":"Henry","groupNumber":"1118476","Gender":"M","FirstName":"Jacqueline","FamilyId":"58980221300","EID":"154907834","effectiveDate":null,"DOB":"6/17/1969","CoverageStatus":null,"benefitBundleOptionId":"0","Age":"48","Addresses":[{"Zip":"06013","State":"CT","countryCode":"US","City":"BURLINGTON","AddressType":"HOM","AddressLine2":"","AddressLine1":"20882 Havey Circle"}]},{"termDate":null,"suffix":"","subscriberIndividualId":"58980221301","selected":false,"Relationship":"Spouse","reinstDate":null,"MiddleInitial":"","LastName":"Henry","groupNumber":"1118476","Gender":"F","FirstName":"Pete","FamilyId":"58980221301","EID":"154907835","effectiveDate":null,"DOB":"2/12/1972","CoverageStatus":null,"benefitBundleOptionId":"0","Age":"45","Addresses":[{"Zip":"06013","State":"CT","countryCode":"US","City":"BURLINGTON","AddressType":"Mailing","AddressLine2":"","AddressLine1":"20882 Havey Circle"}]}]';
        RecordType newRecord = [SELECT Id FROM RecordType WHERE Name = 'Person Account' and SObjectType = 'Account'];
        
        Account accountTest = new Account();
        accountTest.FirstName = 'Test';
        accountTest.LastName = 'Contact';
        accountTest.EID__c = 'PIN';
        accountTest.EID__pc = 'PIN';
        accountTest.RecordTypeId = newRecord.Id;
        insert accountTest;

    Account acc = [SELECT Id,personcontactid from Account where Id=:accountTest.Id];
        Contact cont = [SELECT Id,LastName,FirstName,EID__c,AccountId from Contact where Id=:acc.personcontactid];
        Interaction__c Interaction = new Interaction__c();
        Interaction.Contact_Name__c = 'Test contname';
        Interaction.Originator__c = cont.id;
        Interaction.Originator_Type__c = 'Group/Employer';
        Interaction.Highlight_Panel_GroupInfo__c = JSONStr;
        insert Interaction ;
        ACETIdCardRequest.getParameters().put('InteractionId', Interaction.Id);
        ACETIdCardRequest.getParameters().put('additionalInfo', TestDataFactory.createACETHighlightsPanelAdditionalInfo());        
        ACETIdCardRequest.getParameters().put('contactId', cont.Id);
        ACETIdCardRequest.getParameters().put('groupId', '123456789');
        ACETIdCardRequest.getParameters().put('memberId', '123456789');    
        ACETIdCardRequest.getParameters().put('familyMembers', FamilyMemStr);
        ACETIdCardRequest.getParameters().put('coverageGroupNumber', '123456789'); 
        ACETIdCardRequest.getParameters().put('coverageEffectiveDate', '07/05/2017'); 
        ACETIdCardRequest.getParameters().put('coverageSRK', '123456789'); 
        Test.setCurrentPage(ACETIdCardRequest);
       
        Test.startTest();
        
        ACETIdCardRequestController cardrequst = new ACETIdCardRequestController();
        cardrequst.resolved='true';
        cardrequst.familyMember='test';
        cardrequst.Subject = cont;
        cardrequst.getFamilyMembers();
        cardrequst.GetMembershipCallback();
        cardrequst.getPersonInfo();
        cardrequst.documentType = 'IDCARDS';
        cardrequst.DynamicParams='["te,st1","te,st2","te,st3"]';
        cardrequst.findDocument();
        cardrequst.documentId = 'test';
        cardrequst.submitOrderCall();
        
        ACETIdCardRequestController.personWrapper personWrapp=new ACETIdCardRequestController.personWrapper();
        personWrapp.personOrganization='testOrg';
        personWrapp.personFirstName='Kimberly';
        personWrapp.personMiddleName='Joan';
        personWrapp.personLastName='Christina';
        personWrapp.personFullName='Kimberly Joan';
        personWrapp.personSuffix='test';
        personWrapp.personAddOne='testOne';
        personWrapp.personAddTwo='testtwo';
        personWrapp.personCity='Fao Rai';
        personWrapp.personState='NJ';
        personWrapp.personZipCode='98530';
        personWrapp.groupNumber='123456789';
        personWrapp.benefitBundleOptionID='1234567';
        personWrapp.memberId='123456789';
        
        Test.stopTest();
   } 
   // To cover ACETSubmitFulfillmentRequest class error scenario
   static testMethod void IdCardReqstContrMethodNeg(){
        //Setup records in custom setting
        Map<String, String> mapISLWSConfigs = new Map<String, String>(); 
        mapISLWSConfigs.put('ISLConAccessToken', 'e9b3f2b1-8863-49ec-9ff8-40da25961ef5');
        mapISLWSConfigs.put('OILHttpHeaderAccept', 'application/json;charset=UTF-8');
        mapISLWSConfigs.put('OILHttpHeaderActor', 'ACET');
        mapISLWSConfigs.put('OILHttpHeaderScope', 'read');
        mapISLWSConfigs.put('ISLOAuthContentType', 'application/x-www-form-urlencoded');
        mapISLWSConfigs.put('ISLOAuthGrantType', 'client_credentials');
        mapISLWSConfigs.put('dev_ISLOAuthClientId', 'ISLStageConClientId');
        mapISLWSConfigs.put('dev_ISLOAuthClientSecret', 'ISLStageConClientSecret');
        mapISLWSConfigs.put('dev_ISLOAuthEndpoint', 'https://api-stg.optum.com:8443');
        mapISLWSConfigs.put('dev_ISLOAuthTokenEndpoint', '/auth/oauth/v2/token');
        mapISLWSConfigs.put('d1_SubmitfulfillmentrequestEndPoint','/api/cirrus/alpha/fulfillmentgateway/cirrus/v1.0/fulfillmentrequests');
        mapISLWSConfigs.put('OILTimeout', '3000');
        
        List<ISL_Webservice_Config__c> lstISLWSConfigs = ACETTestDataUtility.CreateISLWebserviceConfigurations(mapISLWSConfigs);
        insert lstISLWSConfigs;
        
        MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse = new MockHttpCalloutResponseGenerator.MockHttpResponse(400, 'OK', '{"externalCorrelationID": null,"metaInformation": {"responseMessageList":[{"code": 400,"message": "memberGroupID: Value is required","type": "error"}]}');
        OILResponse.TokenExpired = false;
        
        MockHttpCalloutResponseGenerator MockHttpRes = new MockHttpCalloutResponseGenerator(null, OILResponse);
        Test.setMock(HttpCalloutMock.class, MockHttpRes);
        
        PageReference ACETIdCardRequest= Page.ACETIdCardRequest;
        String JSONStr = '{"UHCBS":"","GroupN":"Test Group Name","GroupStatus":"Active","ServiceTeam":"NY Large","EffectiveStartDate":"3/1/2016","RiskManagement":"Rating Method","RatingMethod":"","RenewalDate":"3/1/2016","RelationshipType":"Mother","groupSName":"Test GroupName"}';
        String FamilyMemStr='[{"termDate":null,"suffix":"","subscriberIndividualId":"58980221300","selected":false,"Relationship":"Self","reinstDate":null,"MiddleInitial":"","LastName":"Henry","groupNumber":"1118476","Gender":"M","FirstName":"Jacqueline","FamilyId":"58980221300","EID":"154907834","effectiveDate":null,"DOB":"6/17/1969","CoverageStatus":null,"benefitBundleOptionId":"0","Age":"48","Addresses":[{"Zip":"06013","State":"CT","countryCode":"US","City":"BURLINGTON","AddressType":"HOM","AddressLine2":"","AddressLine1":"20882 Havey Circle"}]},{"termDate":null,"suffix":"","subscriberIndividualId":"58980221301","selected":false,"Relationship":"Spouse","reinstDate":null,"MiddleInitial":"","LastName":"Henry","groupNumber":"1118476","Gender":"F","FirstName":"Pete","FamilyId":"58980221301","EID":"154907835","effectiveDate":null,"DOB":"2/12/1972","CoverageStatus":null,"benefitBundleOptionId":"0","Age":"45","Addresses":[{"Zip":"06013","State":"CT","countryCode":"US","City":"BURLINGTON","AddressType":"Mailing","AddressLine2":"","AddressLine1":"20882 Havey Circle"}]}]';
        RecordType newRecord = [SELECT Id FROM RecordType WHERE Name = 'Person Account' and SObjectType = 'Account'];
        
        Account accountTest = new Account();
        accountTest.FirstName = 'Test';
        accountTest.LastName = 'Contact';
        accountTest.EID__c = 'PIN';
        accountTest.EID__pc = 'PIN';
        accountTest.RecordTypeId = newRecord.Id;
        insert accountTest;

    Account acc = [SELECT Id,personcontactid from Account where Id=:accountTest.Id];
        Contact cont = [SELECT Id,LastName,FirstName,EID__c,AccountId from Contact where Id=:acc.personcontactid];
        Interaction__c Interaction = new Interaction__c();
        Interaction.Contact_Name__c = 'Test contname';
        Interaction.Originator__c = cont.id;
        Interaction.Originator_Type__c = 'Group/Employer';
        Interaction.Highlight_Panel_GroupInfo__c = JSONStr;
        insert Interaction ;
        ACETIdCardRequest.getParameters().put('InteractionId', Interaction.Id);
        ACETIdCardRequest.getParameters().put('additionalInfo', TestDataFactory.createACETHighlightsPanelAdditionalInfo());        
        ACETIdCardRequest.getParameters().put('contactId', cont.Id);
        ACETIdCardRequest.getParameters().put('groupId', '123456789');
        ACETIdCardRequest.getParameters().put('memberId', '123456789');    
        ACETIdCardRequest.getParameters().put('familyMembers', FamilyMemStr);
        ACETIdCardRequest.getParameters().put('coverageGroupNumber', '123456789'); 
        ACETIdCardRequest.getParameters().put('coverageEffectiveDate', '07/05/2017'); 
        ACETIdCardRequest.getParameters().put('coverageSRK', '123456789'); 
        Test.setCurrentPage(ACETIdCardRequest);
       
        Test.startTest();
        
        ACETIdCardRequestController cardrequst = new ACETIdCardRequestController();
        cardrequst.resolved='true';
        cardrequst.familyMember='test';
        cardrequst.Subject = cont;
        cardrequst.getFamilyMembers();
        cardrequst.GetMembershipCallback();
        cardrequst.getPersonInfo();
        cardrequst.submitOrderCall();
       ACETFormsHistoryWebService webs = new ACETFormsHistoryWebService();
       webs.init();
       webs.FormatRecpt('test@salesforce.com');
       webs.formatStartDate('2017-10-20');
       webs.formatEndDate ('10/2017');       
        Test.stopTest();
   }
   // To cover ACETSubmitFulfillmentRequest class error scenario
   static testMethod void IdCardReqstContrMethodNeg1(){
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
        mapISLWSConfigs.put('dev_CISLOAuthEndpoint', 'https://api-stg2.optum.com:8443');
        mapISLWSConfigs.put('dev_ISLOAuthTokenEndpoint', '/auth/oauth/v2/token');
        mapISLWSConfigs.put('d1_SubmitfulfillmentrequestEndPoint','/api/cirrus/alpha/fulfillmentgateway/cirrus/v1.0/fulfillmentrequests');
        mapISLWSConfigs.put('CISLTimeout', '3000');
        
        List<ISL_Webservice_Config__c> lstISLWSConfigs = ACETTestDataUtility.CreateISLWebserviceConfigurations(mapISLWSConfigs);
        insert lstISLWSConfigs;
        
        MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse = new MockHttpCalloutResponseGenerator.MockHttpResponse(201, 'OK', ACETTestDataUtility.getEmployerGroupDetailJson());
        OILResponse.TokenExpired = false;
        
        MockHttpCalloutResponseGenerator MockHttpRes = new MockHttpCalloutResponseGenerator(null, OILResponse);
        Test.setMock(HttpCalloutMock.class, MockHttpRes);
        
        PageReference ACETIdCardRequest= Page.ACETIdCardRequest;
        String JSONStr = '{"UHCBS":"","GroupN":"Test Group Name","GroupStatus":"Active","ServiceTeam":"NY Large","EffectiveStartDate":"3/1/2016","RiskManagement":"Rating Method","RatingMethod":"","RenewalDate":"3/1/2016","RelationshipType":"Mother","groupSName":"Test GroupName"}';
        String FamilyMemStr='[{"termDate":null,"suffix":"","subscriberIndividualId":"58980221300","selected":false,"Relationship":"Self","reinstDate":null,"MiddleInitial":"","LastName":"Henry","groupNumber":"1118476","Gender":"M","FirstName":"Jacqueline","FamilyId":"58980221300","EID":"154907834","effectiveDate":null,"DOB":"6/17/1969","CoverageStatus":null,"benefitBundleOptionId":"0","Age":"48","Addresses":[{"Zip":"06013","State":"CT","countryCode":"US","City":"BURLINGTON","AddressType":"HOM","AddressLine2":"","AddressLine1":"20882 Havey Circle"}]},{"termDate":null,"suffix":"","subscriberIndividualId":"58980221301","selected":false,"Relationship":"Spouse","reinstDate":null,"MiddleInitial":"","LastName":"Henry","groupNumber":"1118476","Gender":"F","FirstName":"Pete","FamilyId":"58980221301","EID":"154907835","effectiveDate":null,"DOB":"2/12/1972","CoverageStatus":null,"benefitBundleOptionId":"0","Age":"45","Addresses":[{"Zip":"06013","State":"CT","countryCode":"US","City":"BURLINGTON","AddressType":"Mailing","AddressLine2":"","AddressLine1":"20882 Havey Circle"}]}]';
        RecordType newRecord = [SELECT Id FROM RecordType WHERE Name = 'Person Account' and SObjectType = 'Account'];
        
        Account accountTest = new Account();
        accountTest.FirstName = 'Test';
        accountTest.LastName = 'Contact';
        accountTest.EID__c = 'PIN';
        accountTest.EID__pc = 'PIN';
        accountTest.RecordTypeId = newRecord.Id;
        insert accountTest;

    Account acc = [SELECT Id,personcontactid from Account where Id=:accountTest.Id];
        Contact cont = [SELECT Id,LastName,FirstName,EID__c,AccountId from Contact where Id=:acc.personcontactid];
        Interaction__c Interaction = new Interaction__c();
        Interaction.Contact_Name__c = 'Test contname';
        Interaction.Originator__c = cont.id;
        Interaction.Originator_Type__c = 'Group/Employer';
        Interaction.Highlight_Panel_GroupInfo__c = JSONStr;
        insert Interaction ;
        ACETIdCardRequest.getParameters().put('InteractionId', Interaction.Id);
        ACETIdCardRequest.getParameters().put('additionalInfo', TestDataFactory.createACETHighlightsPanelAdditionalInfo());        
        ACETIdCardRequest.getParameters().put('contactId', cont.Id);
        ACETIdCardRequest.getParameters().put('groupId', '123456789');
        ACETIdCardRequest.getParameters().put('memberId', '123456789');    
        ACETIdCardRequest.getParameters().put('familyMembers', FamilyMemStr);
        ACETIdCardRequest.getParameters().put('coverageGroupNumber', '123456789'); 
        ACETIdCardRequest.getParameters().put('coverageEffectiveDate', '07/05/2017'); 
        ACETIdCardRequest.getParameters().put('coverageSRK', '123456789'); 
        Test.setCurrentPage(ACETIdCardRequest);
       
        Test.startTest();
        
        ACETIdCardRequestController cardrequst = new ACETIdCardRequestController();
        cardrequst.resolved='true';
        cardrequst.familyMember='test';
        cardrequst.Subject = cont;
        cardrequst.getFamilyMembers();
        cardrequst.GetMembershipCallback();
        cardrequst.getPersonInfo();
        cardrequst.submitOrderCall();
        
        Test.stopTest();
   }
   static testMethod void testFindDocService(){
         ACETFindDocWebservice service = new ACETFindDocWebservice();
         List<ACETFindDocWebservice.documentKey> findDocKeys = new List<ACETFindDocWebservice.documentKey>();
         ACETFindDocWebservice.documentKey key = new ACETFindDocWebservice.documentKey();
         key.value = '1148123';
         key.name = 'groupNumber';
         findDocKeys.add(key);
         key.value = '123123023';
         key.name = 'memberId';
         findDocKeys.add(key);
         key.value = '00';
         key.name = 'MemberSequenceNumberOrDivision';
         findDocKeys.add(key);
         key.value = '3134';
         key.name = 'clientNumber';
         findDocKeys.add(key);
         
         service.init('IDCARDS', findDocKeys);
         
         MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse1 = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', ACETTestDataUtility.getFindDocWebserviceResponseIdCard());
         OILResponse1.TokenExpired = false;        
         MockHttpCalloutResponseGenerator MockHttpRes1 = new MockHttpCalloutResponseGenerator(null, OILResponse1);
         Test.setMock(HttpCalloutMock.class, MockHttpRes1);           
         service.queryPaginatedData(1,1,1);
         
         MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse2 = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'Resource Not Found', ACETTestDataUtility.getFindDocWebserviceEmptyResponse());
         OILResponse2.TokenExpired = false;        
         MockHttpCalloutResponseGenerator MockHttpRes2 = new MockHttpCalloutResponseGenerator(null, OILResponse2);
         Test.setMock(HttpCalloutMock.class, MockHttpRes2); 
         service.queryPaginatedData(1,1,1); 
         
         MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse3 = new MockHttpCalloutResponseGenerator.MockHttpResponse(404, 'Resource Not Found', ACETTestDataUtility.getFindDocWebserviceEmptyResponse());
         OILResponse3.TokenExpired = false;        
         MockHttpCalloutResponseGenerator MockHttpRes3 = new MockHttpCalloutResponseGenerator(null, OILResponse3);
         Test.setMock(HttpCalloutMock.class, MockHttpRes3); 
         service.queryPaginatedData(1,1,1);
    }
   
    static testMethod void IdCardOrderHistorytestMethod() {
        Map<String, String> mapISLWSConfigs = new Map<String, String>(); 
        mapISLWSConfigs.put('ISLConAccessToken', 'e9b3f2b1-8863-49ec-9ff8-40da25961ef5');
        mapISLWSConfigs.put('OILHttpHeaderAccept', 'application/json;charset=UTF-8');
        mapISLWSConfigs.put('OILHttpHeaderActor', 'ACET');
        mapISLWSConfigs.put('OILHttpHeaderScope', 'read');
        mapISLWSConfigs.put('ISLOAuthContentType', 'application/x-www-form-urlencoded');
        mapISLWSConfigs.put('ISLOAuthGrantType', 'client_credentials');
        mapISLWSConfigs.put('dev_ISLOAuthClientId', 'ISLStageConClientId');
        mapISLWSConfigs.put('dev_ISLOAuthClientSecret', 'ISLStageConClientSecret');
        mapISLWSConfigs.put('dev_ISLOAuthEndpoint', 'https://api-stg.optum.com:8443');
        mapISLWSConfigs.put('dev_FindFulfillmentHistory', '/api/alpha/eisl/fulfillment/fulfillmentrequests/v2.0/search');
        mapISLWSConfigs.put('dev_ISLOAuthTokenEndpoint', '/auth/oauth/v2/token');
        mapISLWSConfigs.put('d1_SubmitfulfillmentrequestEndPoint','/api/cirrus/alpha/fulfillmentgateway/cirrus/v1.0/fulfillmentrequests');
        mapISLWSConfigs.put('OILTimeout', '3000');
        
        List<ISL_Webservice_Config__c> lstISLWSConfigs = ACETTestDataUtility.CreateISLWebserviceConfigurations(mapISLWSConfigs);
        insert lstISLWSConfigs; 
        
        List<ACETIDCardOrderStatusVerbiage__c> lstStatusVerbgs = new List<ACETIDCardOrderStatusVerbiage__c>();
        ACETIDCardOrderStatusVerbiage__c lstStatusVerbg = new ACETIDCardOrderStatusVerbiage__c();
        lstStatusVerbg.Name='ReleasedToPrint';
        lstStatusVerbg.Hover_Help_Description__c='test';
        lstStatusVerbg.Status_Label__c='Released Material to Print';
        lstStatusVerbgs.add(lstStatusVerbg);
        ACETIDCardOrderStatusVerbiage__c lstStatusVerbg1 = new ACETIDCardOrderStatusVerbiage__c();
        lstStatusVerbg1.Name='Generated';
        lstStatusVerbg1.Hover_Help_Description__c='test';
        lstStatusVerbg1.Status_Label__c='Document Generated';
        lstStatusVerbgs.add(lstStatusVerbg1);
        insert lstStatusVerbgs;

        
        StaticResource ResponseJSONSR = [SELECT Body FROM StaticResource WHERE Name = 'ACETFindFulfillmentHistoryResultJSON_IDCard'];
        String ResponseJSON = ResponseJSONSR.Body.toString(); 
        Test.startTest();

            MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', ResponseJSON);
            OILResponse.TokenExpired = false;
    
            MockHttpCalloutResponseGenerator MockHttpRes = new MockHttpCalloutResponseGenerator(null, OILResponse);
            Test.setMock(HttpCalloutMock.class, MockHttpRes);
            
            Map<String, List<ACETFormsHistoryResult>> testResultMap =new Map<String, List<ACETFormsHistoryResult>>();
            testResultMap.put('98927471400',new List<ACETFormsHistoryResult>());         
            ACETIdCardRequestController IdCardRequestController = new ACETIdCardRequestController();
            IdCardRequestController.selectedFamilyId = '98927471400';
            IdCardRequestController.formHistoryResultMap = testResultMap;
            IdCardRequestController.getPersonInfo();
           
        Test.stopTest();
        }
        static testMethod void IdCardOrderHistorytestMethod2() {
        Map<String, String> mapISLWSConfigs = new Map<String, String>(); 
        mapISLWSConfigs.put('ISLConAccessToken', 'e9b3f2b1-8863-49ec-9ff8-40da25961ef5');
        mapISLWSConfigs.put('OILHttpHeaderAccept', 'application/json;charset=UTF-8');
        mapISLWSConfigs.put('OILHttpHeaderActor', 'ACET');
        mapISLWSConfigs.put('OILHttpHeaderScope', 'read');
        mapISLWSConfigs.put('ISLOAuthContentType', 'application/x-www-form-urlencoded');
        mapISLWSConfigs.put('ISLOAuthGrantType', 'client_credentials');
        mapISLWSConfigs.put('dev_ISLOAuthClientId', 'ISLStageConClientId');
        mapISLWSConfigs.put('dev_ISLOAuthClientSecret', 'ISLStageConClientSecret');
        mapISLWSConfigs.put('dev_ISLOAuthEndpoint', 'https://api-stg.optum.com:8443');
        mapISLWSConfigs.put('dev_FindFulfillmentHistory', '/api/alpha/eisl/fulfillment/fulfillmentrequests/v2.0/search');
        mapISLWSConfigs.put('dev_ISLOAuthTokenEndpoint', '/auth/oauth/v2/token');
        mapISLWSConfigs.put('d1_SubmitfulfillmentrequestEndPoint','/api/cirrus/alpha/fulfillmentgateway/cirrus/v1.0/fulfillmentrequests');
        mapISLWSConfigs.put('OILTimeout', '3000');
        
        List<ISL_Webservice_Config__c> lstISLWSConfigs = ACETTestDataUtility.CreateISLWebserviceConfigurations(mapISLWSConfigs);
        insert lstISLWSConfigs; 
        
        List<ACETIDCardOrderStatusVerbiage__c> lstStatusVerbgs = new List<ACETIDCardOrderStatusVerbiage__c>();
        ACETIDCardOrderStatusVerbiage__c lstStatusVerbg = new ACETIDCardOrderStatusVerbiage__c();
        lstStatusVerbg.Name='ReleasedToPrint';
        lstStatusVerbg.Hover_Help_Description__c='test';
        lstStatusVerbg.Status_Label__c='Released Material to Print';
        lstStatusVerbgs.add(lstStatusVerbg);
        ACETIDCardOrderStatusVerbiage__c lstStatusVerbg1 = new ACETIDCardOrderStatusVerbiage__c();
        lstStatusVerbg1.Name='Generated';
        lstStatusVerbg1.Hover_Help_Description__c='test';
        lstStatusVerbg1.Status_Label__c='Document Generated';
        lstStatusVerbgs.add(lstStatusVerbg1);
        insert lstStatusVerbgs;

        
        StaticResource ResponseJSONSR = [SELECT Body FROM StaticResource WHERE Name = 'ACETFindFulfillmentHistoryResultJSON_IDCard'];
        String ResponseJSON = ResponseJSONSR.Body.toString(); 
        ResponseJSON = ResponseJSON.replaceAll('TransactionalInlineDataOnly', 'TransactionalInlinePrintReadySingleItem');       
        Test.startTest();

            MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', ResponseJSON);
            OILResponse.TokenExpired = false;
    
            MockHttpCalloutResponseGenerator MockHttpRes = new MockHttpCalloutResponseGenerator(null, OILResponse);
            Test.setMock(HttpCalloutMock.class, MockHttpRes);
            
            Map<String, List<ACETFormsHistoryResult>> testResultMap =new Map<String, List<ACETFormsHistoryResult>>();
            testResultMap.put('98927471400',new List<ACETFormsHistoryResult>());         
            ACETIdCardRequestController IdCardRequestController = new ACETIdCardRequestController();
            IdCardRequestController.selectedFamilyId = '98927471400';
            IdCardRequestController.formHistoryResultMap = testResultMap;
            IdCardRequestController.getPersonInfo();
           
        Test.stopTest();
        }
        static testMethod void IdCardOrderHistorytestMethod3() {
        Map<String, String> mapISLWSConfigs = new Map<String, String>(); 
        mapISLWSConfigs.put('ISLConAccessToken', 'e9b3f2b1-8863-49ec-9ff8-40da25961ef5');
        mapISLWSConfigs.put('OILHttpHeaderAccept', 'application/json;charset=UTF-8');
        mapISLWSConfigs.put('OILHttpHeaderActor', 'ACET');
        mapISLWSConfigs.put('OILHttpHeaderScope', 'read');
        mapISLWSConfigs.put('ISLOAuthContentType', 'application/x-www-form-urlencoded');
        mapISLWSConfigs.put('ISLOAuthGrantType', 'client_credentials');
        mapISLWSConfigs.put('dev_ISLOAuthClientId', 'ISLStageConClientId');
        mapISLWSConfigs.put('dev_ISLOAuthClientSecret', 'ISLStageConClientSecret');
        mapISLWSConfigs.put('dev_ISLOAuthEndpoint', 'https://api-stg.optum.com:8443');
        mapISLWSConfigs.put('dev_FindFulfillmentHistory', '/api/alpha/eisl/fulfillment/fulfillmentrequests/v2.0/search');
        mapISLWSConfigs.put('dev_ISLOAuthTokenEndpoint', '/auth/oauth/v2/token');
        mapISLWSConfigs.put('d1_SubmitfulfillmentrequestEndPoint','/api/cirrus/alpha/fulfillmentgateway/cirrus/v1.0/fulfillmentrequests');
        mapISLWSConfigs.put('OILTimeout', '3000');
        
        List<ISL_Webservice_Config__c> lstISLWSConfigs = ACETTestDataUtility.CreateISLWebserviceConfigurations(mapISLWSConfigs);
        insert lstISLWSConfigs; 
        
        List<ACETIDCardOrderStatusVerbiage__c> lstStatusVerbgs = new List<ACETIDCardOrderStatusVerbiage__c>();
        ACETIDCardOrderStatusVerbiage__c lstStatusVerbg = new ACETIDCardOrderStatusVerbiage__c();
        lstStatusVerbg.Name='ReleasedToPrint';
        lstStatusVerbg.Hover_Help_Description__c='test';
        lstStatusVerbg.Status_Label__c='Released Material to Print';
        lstStatusVerbgs.add(lstStatusVerbg);
        ACETIDCardOrderStatusVerbiage__c lstStatusVerbg1 = new ACETIDCardOrderStatusVerbiage__c();
        lstStatusVerbg1.Name='Generated';
        lstStatusVerbg1.Hover_Help_Description__c='test';
        lstStatusVerbg1.Status_Label__c='Document Generated';
        lstStatusVerbgs.add(lstStatusVerbg1);
        insert lstStatusVerbgs;

        
        StaticResource ResponseJSONSR = [SELECT Body FROM StaticResource WHERE Name = 'ACETFindFulfillmentHistoryResultJSON_IDCard'];
        String ResponseJSON = ResponseJSONSR.Body.toString(); 
        //ResponseJSON = ResponseJSON.replaceAll('TransactionalInlineDataOnly', 'TransactionalInlinePrintReadySingleItem');       
        Test.startTest();

            MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse = new MockHttpCalloutResponseGenerator.MockHttpResponse(404, 'OK', ResponseJSON);
            OILResponse.TokenExpired = false;
    
            MockHttpCalloutResponseGenerator MockHttpRes = new MockHttpCalloutResponseGenerator(null, OILResponse);
            Test.setMock(HttpCalloutMock.class, MockHttpRes);
            
            Map<String, List<ACETFormsHistoryResult>> testResultMap =new Map<String, List<ACETFormsHistoryResult>>();
            testResultMap.put('98927471400',new List<ACETFormsHistoryResult>());         
            ACETIdCardRequestController IdCardRequestController = new ACETIdCardRequestController();
            IdCardRequestController.selectedFamilyId = '98927471400';
            IdCardRequestController.formHistoryResultMap = testResultMap;
            IdCardRequestController.getPersonInfo();
           
        Test.stopTest();
        }
   Static testMethod void FamilyMemberscallable(){     
         Map<String, String> mapISLWSConfigs = new Map<String, String>(); 
            mapISLWSConfigs.put('ISLConAccessToken', 'e9b3f2b1-8863-49ec-9ff8-40da25961ef5');
            mapISLWSConfigs.put('OILHttpHeaderAccept', 'application/json;charset=UTF-8');
            mapISLWSConfigs.put('OILHttpHeaderActor', 'ACET');
            mapISLWSConfigs.put('OILHttpHeaderScope', 'read');
            mapISLWSConfigs.put('ISLOAuthContentType', 'application/x-www-form-urlencoded');
            mapISLWSConfigs.put('ISLOAuthGrantType', 'client_credentials');
            mapISLWSConfigs.put('dev_ISLOAuthClientId', 'ISLStageConClientId');
            mapISLWSConfigs.put('dev_ISLOAuthClientSecret', 'ISLStageConClientSecret');
            mapISLWSConfigs.put('dev_ISLOAuthEndpoint', 'https://api-stg.optum.com:8443');
            mapISLWSConfigs.put('OILTimeout', '3000'); 
           
        List<ISL_Webservice_Config__c> lstISLWSConfigs = ACETTestDataUtility.CreateISLWebserviceConfigurations(mapISLWSConfigs);
       
        //string FamilymemJson='{"getFamilyMembershipResponse":{"individual":[{"individualIdentifier":"456565338","name":{"firstName":"Jim","lastName":"Brown","middleName":"J","nameSuffix":"Sr"},"birthDate":"1980-10-10","genderCode":"M","genderDescription":"Male","socialSecurityNumber":"546733275","privacyIndicator":"N","address":[{"typeCode":"HOM","addressLine1":"113 Hill Street","addressLine2":"","city":"HARTFORD","postalCode":"06103","stateCode":"CT","countryCode":"US"}],"membership":[{"sourceSysCode":"CR","coverages":[{"groupNumber":"1108502","groupName":"MGAlpha6","eligibilitySystemTypeCode":"CR","claimSystemTypeCode":"CR","memberStatus":"ACTIVE","bundleOptions":[{"benefits":[{"benefitBundleOptionId":"1018483","benefitBundleOptionDescription":"Default Description","benefitEffectiveDate":"2017-11-01","benefitExpirationDate":"9999-12-31","benefitPlanId":"M000000012","benefitPlanName":"CTSM MEHIP 06 HMO G $15/$30","benefitType":"MD","coverageLevelCode":"FAM","product":{"productIdentifier":"PM00000001"},"relationshipCode":"18","relationshipDescription":"Self","memberIdCardSerialNumber":"92819483800","subscriberIdCardSerialNumber":"92819483800","eligibilityStatusCode":"A","cancelReasonTypeCode":"","planType":"02","networkScheduleID":"FREEDOM","indicators":{"qmscoIndicator":"N"}}]}]}],"cob":[{}],"providers":[{}],"identifiers":[{"id":"456565338","type":"enrolleeEID"},{"id":"100000000470010","type":"subscriberSystemId"},{"id":"100000000470010","type":"enrolleeSystemID"},{"id":"621642623","type":"subscriberSurrogateKey"},{"id":"621642623","type":"enrolleeSurrogateKey"}]}]}]}}';
        MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', ACETTestDataUtility.getFindDocWebserviceResponseIdCard());
        OILResponse.TokenExpired = false;        
        MockHttpCalloutResponseGenerator MockHttpRes = new MockHttpCalloutResponseGenerator(null, OILResponse);
        Test.setMock(HttpCalloutMock.class, MockHttpRes);  
        
        PageReference ACETIdCardRequest= Page.ACETIdCardRequest;
        String JSONStr = '{"UHCBS":"","GroupN":"Test Group Name","GroupStatus":"Active","ServiceTeam":"NY Large","EffectiveStartDate":"3/1/2016","RiskManagement":"Rating Method","RatingMethod":"","RenewalDate":"3/1/2016","RelationshipType":"Mother","groupSName":"Test GroupName"}';
        String FamilyMemStr='[{"termDate":null,"suffix":"","subscriberIndividualId":"92819483800","selected":false,"Relationship":"Self","reinstDate":null,"MiddleInitial":"","LastName":"Henry","groupNumber":"1118476","Gender":"M","FirstName":"Jacqueline","FamilyId":"92819483800","EID":"154907834","effectiveDate":null,"DOB":"6/17/1969","CoverageStatus":null,"benefitBundleOptionId":"0","Age":"48","Addresses":[{"Zip":"06013","State":"CT","countryCode":"US","City":"BURLINGTON","AddressType":"HOM","AddressLine2":"","AddressLine1":"20882 Havey Circle"}]},{"termDate":null,"suffix":"","subscriberIndividualId":"58980221301","selected":false,"Relationship":"Spouse","reinstDate":null,"MiddleInitial":"","LastName":"Henry","groupNumber":"1118476","Gender":"F","FirstName":"Pete","FamilyId":"58980221301","EID":"154907835","effectiveDate":null,"DOB":"2/12/1972","CoverageStatus":null,"benefitBundleOptionId":"0","Age":"45","Addresses":[{"Zip":"06013","State":"CT","countryCode":"US","City":"BURLINGTON","AddressType":"Mailing","AddressLine2":"","AddressLine1":"20882 Havey Circle"}]}]';
        RecordType newRecord = [SELECT Id FROM RecordType WHERE Name = 'Person Account' and SObjectType = 'Account'];
        
        Account accountTest = new Account();
        accountTest.FirstName = 'Test';
        accountTest.LastName = 'Contact';
        accountTest.EID__c = 'PIN';
        accountTest.EID__pc = 'PIN';
        accountTest.RecordTypeId = newRecord.Id;
        insert accountTest;

    Account acc = [SELECT Id,personcontactid from Account where Id=:accountTest.Id];
        Contact cont = [SELECT Id,LastName,FirstName,EID__c,AccountId from Contact where Id=:acc.personcontactid];
        Interaction__c Interaction = new Interaction__c();
        Interaction.Contact_Name__c = 'Test contname';
        Interaction.Originator__c = cont.id;
        Interaction.Originator_Type__c = 'Group/Employer';
        Interaction.Highlight_Panel_GroupInfo__c = JSONStr;
        insert Interaction ;
        ACETIdCardRequest.getParameters().put('InteractionId', Interaction.Id);
        ACETIdCardRequest.getParameters().put('additionalInfo', TestDataFactory.createACETHighlightsPanelAdditionalInfo());        
        ACETIdCardRequest.getParameters().put('contactId', cont.Id);
        ACETIdCardRequest.getParameters().put('groupId', '1108502');
        ACETIdCardRequest.getParameters().put('memberId', '92819483800');    
        ACETIdCardRequest.getParameters().put('familyMembers', FamilyMemStr);
        ACETIdCardRequest.getParameters().put('coverageGroupNumber', '1108502'); 
        ACETIdCardRequest.getParameters().put('coverageEffectiveDate', '11/1/2017'); 
        ACETIdCardRequest.getParameters().put('coverageSRK', '621642623'); 
        ACETIdCardRequest.getParameters().put('SRK', '621642623'); 
        Test.setCurrentPage(ACETIdCardRequest);
        
        ACETMemberDetail memberDetails = new ACETMemberDetail();
        List<ACETMemberDetail.FamilyMember> lst_FamilyMembers =new List<ACETMemberDetail.FamilyMember>();
        ACETMemberDetail.FamilyMember familyMember = new ACETMemberDetail.FamilyMember();
        familyMember.FamilyId='92819483800';
        lst_FamilyMembers.add(familyMember);
        memberDetails.FamilyMembers= lst_FamilyMembers; 
        memberDetails.Surrogatekey='123'; 
        memberDetails.PreferredCoverage = new ACETMemberDetail.CoverageLine();
        memberDetails.PreferredCoverage.groupNumber = '1108502';
        memberDetails.PreferredCoverage.effectiveDate = '11/1/2017';
        memberDetails.PreferredCoverage.SurrogateKey = '621642623';         
            
        Test.startTest(); 
           ACETIdCardRequestController IdCardRequestContrl = new ACETIdCardRequestController();
            IdCardRequestContrl.resolved='true';
            IdCardRequestContrl.familyMember='test';
            IdCardRequestContrl.Subject = cont;
            IdCardRequestContrl.documentType = 'IDCARDS';
            IdCardRequestContrl.DynamicParams='["te,st1","te,st2","te,st3"]';
            IdCardRequestContrl.findDocument();
            IdCardRequestContrl.documentId = 'test';
            IdCardRequestContrl.currentTrackingId= 'test';
            IdCardRequestContrl.reponseMessage= 'test';
            IdCardRequestContrl.correlationID= 'test';
            IdCardRequestContrl.familySize= 1;
            IdCardRequestContrl.getFamilyMembers();
            IdCardRequestContrl.memberDetail=memberDetails;
            IdCardRequestContrl.GetMembershipCallback();
        Test.stopTest();
        
     }  
    }