@isTest
private class ACETLGT_getIndividualGeneralInfoTest {

    @testSetup static void setupTestData() {
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
        ISLWebserviceCSList.add(TestDataFactory.CreateISLWebserviceCS('dev_GetIndividualEndpoint', '/api/alpha/eisl/individuals/v2.0/read'));
        ISLWebserviceCSList.add(TestDataFactory.CreateISLWebserviceCS('dev_ISLOAuthTokenEndpoint', '/auth/oauth/v2/token'));
        ISLWebserviceCSList.add(TestDataFactory.CreateISLWebserviceCS('OILTimeout', '3000'));
        ISLWebserviceCSList.add(TestDataFactory.CreateISLWebserviceCS('SRKCounter', '1'));
        insert ISLWebserviceCSList;
    }
    
    @isTest static void testGeneralInforCatch() {
        String resp='{"getIndividualResponse":{"individual":{"individualIdentifier":"493142896","name":{"firstName":"Maynard","lastName":"Moss","middleName":"","nameSuffix":""},"disabilityInfo":[{"diagnosisCode":"abcd", "disabilityType":"T","diagnosisDesc":"test desc","effectiveDate":"12-12-2020","endDate":"12-12-2021"}],"birthDate":"1960-09-14","genderCode":"F","genderDescription":"Female","socialSecurityNumber":"767626350","maritalStatusCode":"","deceasedDate":"","privacyIndicator":"","tobaccoUsageIndicator":"","ethnicityCode":"","ethnicityDescription":"","address":[{"typeCode":"HOM","addressLine1":"123 Annie Road","addressLine2":"","city":"HOLTSVILLE","postalCode":"00501","stateCode":"NY","countryCode":"US"}],"phone":[{"phoneType":"W","phoneNumber":"732-656-6591","phoneExt":"1234","internationalIndicator":"N","primaryIndicator":"Y"},{"phoneType":"H","phoneNumber":"732-656-6591","phoneExt":"","internationalIndicator":"N","primaryIndicator":"N"}],"email":[{"communicationTypeCode":"EML","electronicAddress":"maynard@optum.com","primaryIndicator":"Y"}],"employment":[{"employmentStatus":"A","employeeIdentifier":"","employmentStartDate":"2019-01-01","retirementDate":"9999-12-31"}],"language":[{"languageCode":"ENG","languageUsedTypeCode":"5","languageUsedTypeDescription":"Language_Reading"}],"otherContact":[{}],"dependentDisabilityList":[{}],"identifiers":[{"id":"660492642","type":"SRK"}]}}}';
            
        MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse =  new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', resp); 
        OILResponse.TokenExpired = false;        
        MockHttpCalloutResponseGenerator MockHttpRes = new MockHttpCalloutResponseGenerator(null, OILResponse);
        Test.setMock(HttpCalloutMock.class, MockHttpRes); 
        
        Test.startTest();
        ACETLGT_getIndividualGeneralInfo.SearchResultWrapper wrapper = ACETLGT_getIndividualGeneralInfo.getSearchResults('111', '12344556', '123', '123');
        System.assert(String.isNotEmpty(wrapper.ErrorMessage));
        Test.stopTest();
    }
    
    @isTest static void testSRKNull() {
        ACETLGT_getIndividualGeneralInfo.SearchResultWrapper wrapper = ACETLGT_getIndividualGeneralInfo.getSearchResults('', '12344556', '123', '123');
        System.assert(String.isNotEmpty(wrapper.ErrorMessage));
    }
    
    @isTest static void testEIDNull() {
        String resp='{"getIndividualResponse":{"individual":{"individualIdentifier":"493142896","name":{"firstName":"Maynard","lastName":"Moss","middleName":"","nameSuffix":""},"disabilityInfo":[{"diagnosisCode":"abcd", "disabilityType":"T","diagnosisDesc":"test desc","effectiveDate":"12-12-2020","endDate":"12-12-2021"}],"birthDate":"1960-09-14","genderCode":"F","genderDescription":"Female","socialSecurityNumber":"767626350","maritalStatusCode":"","deceasedDate":"","privacyIndicator":"","tobaccoUsageIndicator":"","ethnicityCode":"","ethnicityDescription":"","address":[{"typeCode":"HOM","addressLine1":"123 Annie Road","addressLine2":"","city":"HOLTSVILLE","postalCode":"00501","stateCode":"NY","countryCode":"US"}],"phone":[{"phoneType":"W","phoneNumber":"732-656-6591","phoneExt":"1234","internationalIndicator":"N","primaryIndicator":"Y"},{"phoneType":"H","phoneNumber":"732-656-6591","phoneExt":"","internationalIndicator":"N","primaryIndicator":"N"}],"email":[{"communicationTypeCode":"EML","electronicAddress":"maynard@optum.com","primaryIndicator":"Y"}],"employment":[{"employmentStatus":"A","employeeIdentifier":"","employmentStartDate":"2019-01-01","retirementDate":"9999-12-31"}],"language":[{"languageCode":"ENG","languageUsedTypeCode":"5","languageUsedTypeDescription":"Language_Reading"}],"otherContact":[{}],"dependentDisabilityList":[{}],"identifiers":[{"id":"660492642","type":"SRK"}]}}}';
            
        MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse =  new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', resp); 
        OILResponse.TokenExpired = false;        
        MockHttpCalloutResponseGenerator MockHttpRes = new MockHttpCalloutResponseGenerator(null, OILResponse);
        Test.setMock(HttpCalloutMock.class, MockHttpRes);
        
        Test.startTest();
        ACETLGT_getIndividualGeneralInfo.SearchResultWrapper wrapper = ACETLGT_getIndividualGeneralInfo.getSearchResults('123', null, '123', '123');
        System.assert(String.isNotEmpty(wrapper.ErrorMessage));
        Test.stopTest();
    }
    
    @isTest static void testGeneralInfor() {
        String resp='{"getIndividualResponse":{"individual":{"dependentDisabilityList":[{"disabilityType":"P","diagnosisCode":"PPE","diagCodeType":"9","effectiveDate":null,"expirationDate":null}],"individualIdentifier":"493142896","name":{"firstName":"Maynard","lastName":"Moss","middleName":"", "nameSuffix":""},"birthDate":"1960-09-14","genderCode":"F","genderDescription":"Female","socialSecurityNumber":"767626350","maritalStatusCode":"","deceasedDate":"","privacyIndicator":"","tobaccoUsageIndicator":"","ethnicityCode":"","ethnicityDescription":"","address":[{"typeCode":"HOM","addressLine1":"123 Annie Road","addressLine2":"","city":"HOLTSVILLE","postalCode":"00501","stateCode":"NY","countryCode":"US"}],"phone":[{"phoneType":"W","phoneNumber":"732-656-6591","phoneExt":"1234","internationalIndicator":"N","primaryIndicator":"Y"},{"phoneType":"H","phoneNumber":"732-656-6591","phoneExt":"","internationalIndicator":"N","primaryIndicator":"N"}],"email":[{"communicationTypeCode":"EML","electronicAddress":"maynard@optum.com","primaryIndicator":"Y"}],"employment":[{"employmentStatus":"A","employeeIdentifier":"","employmentStartDate":"2019-01-01","retirementDate":"9999-12-31"}],"language":[{"languageCode":"ENG","languageUsedTypeCode":"5","languageUsedTypeDescription":"Language_Reading"}],"otherContact":[{}],"identifiers":[{"id":"660492642","type":"SRK"}]}}}';
        MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse =  new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', resp); 
        OILResponse.TokenExpired = false;        
        MockHttpCalloutResponseGenerator MockHttpRes = new MockHttpCalloutResponseGenerator(null, OILResponse);
        Test.setMock(HttpCalloutMock.class, MockHttpRes); 
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
        Case cs = new case(subject = 'test', contactId = oContact.id,Surrogate_Key__c = '1234');
        insert cs;
        
        Interaction__c oInteraction = ACETTestDataUtility.CreateInteraction(oContact.Id, 'Phone', 'Member', oContact.LastName);
        insert oInteraction;
        
        Test.startTest();
        	ACETLGT_getIndividualGeneralInfo.SearchResultWrapper wrapper = ACETLGT_getIndividualGeneralInfo.getSearchResults('111', '12344556', '123', oInteraction.Id);
        Test.stopTest();
    }
    
    @isTest static void testCalloutFail() {
        ACETLGT_getIndividualGeneralInfo.SearchResultWrapper wrapper = ACETLGT_getIndividualGeneralInfo.getSearchResults('111', '12344556', '123', '123');
        System.assert(String.isNotEmpty(wrapper.ErrorMessage));
    }
}