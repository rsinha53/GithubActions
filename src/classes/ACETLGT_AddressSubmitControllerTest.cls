@isTest
private class ACETLGT_AddressSubmitControllerTest {
    
    @testSetup static void setupTestData() {
        Test.startTest();
        List<Material_Forms__c> formList = new List<Material_Forms__c> {
            new Material_Forms__c(
                FulfillmentType__c = '10700',
                FulfillmentType_Description__c = 'Blank Form',
                Business_Unit__c = '',
                Quantity__c = '2'
            ),
                new Material_Forms__c(
                    FulfillmentType__c = '10701',
                    FulfillmentType_Description__c = 'Blank Form 2',
                    Business_Unit__c = '',
                    Quantity__c = '5'
                )
                };
                    insert formList;
        Test.stopTest();
    }
    
    @isTest static void testFindMemberInfor() {
        // generating material form string
        String mForms = '{';        
        for(Material_Forms__c form : [SELECT Id, Quantity__c FROM Material_Forms__c]) {
            mForms += '"' + form.Id + '" : ' + '"' + form.Quantity__c + '",';
        }
        mForms = mForms.removeEnd(',');
        mForms += '}';
        
        Test.startTest();
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('getIndividualResponse_1');
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'application/json;charset=UTF-8');
        // Associate the callout with a mock response
        Test.setMock(HttpCalloutMock.class, mock); 
        ACETLGT_AddressSubmitController.AddOnFilePersonWrapper person = ACETLGT_AddressSubmitController.findMemberInfo('006', '930775200');            
        
        // performing different scenarios for btn submit by changing the address
        ACETLGT_AddressSubmitController.resultwrap result = ACETLGT_AddressSubmitController.btnSubmit(person, 'BusinessUnit', 'AddressOnFile', mForms);
        result = ACETLGT_AddressSubmitController.btnSubmit(person, 'BusinessUnit', 'AlternateAddress', mForms);
        Test.stopTest();
    } 
    
    @isTest static void testFindMemberInfor_1() {
        // generating material form string
        String mForms = '{';        
        for(Material_Forms__c form : [SELECT Id, Quantity__c FROM Material_Forms__c]) {
            mForms += '"' + form.Id + '" : ' + '"' + form.Quantity__c + '",';
        }
        mForms = mForms.removeEnd(',');
        mForms += '}';
        
        Test.startTest();
        String ResponseJSON = '{"getIndividualResponse":{"individual":{"individualIdentifier":"1234567890","name":{"firstName":"Steph","lastName":"Smith"},"birthDate":"2015-01-01","genderCode":"M","genderDescription":"MALE","socialSecurityNumber":"987654321","maritalStatusCode":"UM","maritalStatusDescription":"unmarried","deceasedDate":"2017-01-01","relationshipCode":"18","relationshipDescription":"Self","privacyIndicator":"Y","tobaccoUsageIndicator":"S","ethnicityCode":"G","ethnicityDescription":"Native American","address":[{"typeCode":"P","addressLine1":"12 abc ave","addressLine2":"apt 2","city":"Bangalore","postalCode":"560076","stateCode":"NJ","countryCode":"IND","countryDescription":"India","AddressType":"Mailing"},{"typeCode":"P1","addressLine1":"123 abc ave","addressLine2":"apt 4","city":"Berhampur","postalCode":"760001","stateCode":"NJ","countryCode":"IND","countryDescription":"India","AddressType":"Home"}],"phone":[{"phoneType":"HOM","phoneNumber":"7777321229","phoneExt":"1234","internationalIndicator":"US","primaryIndicator":"Y"},{"phoneType":"OFF","phoneNumber":"7777322000","phoneExt":"1234","internationalIndicator":"US","primaryIndicator":"N"}],"email":[{"communicationTypeCode":"EML","electronicAddress":"x.yz12@gmail.com","primaryIndicator":"Y"},{"communicationTypeCode":"EML","electronicAddress":"pqrs.yz12@yahoo.com","primaryIndicator":"Y"}],"employment":[{"employmentStatus":"FT","employeeIdentifier":"5432","employmentStartDate":"2012-10-01","retirementDate":"2015-08-02"},{"employmentStatus":"CT","employeeIdentifier":"3011","employmentStartDate":"2014-10-01","retirementDate":"2016-08-02"}],"language":[{"languageCode":"Eng","languageDescription":"English","languageUsedTypeCode":"5","languageUsedTypeDescription":"Reading"},{"languageCode":"Spa","languageDescription":"Spanish","languageUsedTypeCode":"6","languageUsedTypeDescription":"Writing"}],"otherContact":[{"name":{"firstName":"Jingtian","lastName":"Zhang","middleName":"K","nameSuffix":"Zhang"},"relationshipType":"Attorney","address":{"typeCode":"HOM","addressLine1":"12 abc ave","addressLine2":"apt 2","city":"Hoboken","postalCode":"07307","stateCode":"NJ","countryCode":"US","countryDescription":"United State"},"electronicContact":{"communicationTypeCode":"EML","electronicAddress":"abc.lmn@yahoo.com","primaryIndicator":"Y"}},{"name":{"firstName":"David","lastName":"Burch","middleName":"J","nameSuffix":"XZ"},"relationshipType":"Case Manager","address":{"typeCode":"HOM","addressLine1":"123 abc ave","addressLine2":"apt 4","city":"Hoboken","postalCode":"07311","stateCode":"NJ","countryCode":"US","countryDescription":"United State"},"electronicContact":{"communicationTypeCode":"EML","electronicAddress":"dvd.xyz@yahoo.com","primaryIndicator":"N"}}],"identifiers":[{"id":"101","type":"SRK"},{"id":"102","type":"SRK"},{"id":"103","type":"SRK"},{"id":"456","type":"HICN"}]}}}';
        MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse = new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', ResponseJSON );
        OILResponse.TokenExpired = false;
        MockHttpCalloutResponseGenerator MockHttpRes = new MockHttpCalloutResponseGenerator(null, OILResponse);
        Test.setMock(HttpCalloutMock.class, MockHttpRes);
        ACETLGT_AddressSubmitController.AddOnFilePersonWrapper person = ACETLGT_AddressSubmitController.findMemberInfo('006', '930775200');            
        
        // performing different scenarios for btn submit by changing the address
        ACETLGT_AddressSubmitController.resultwrap result = ACETLGT_AddressSubmitController.btnSubmit(person, 'BusinessUnit', 'AddressOnFile', mForms);
        result = ACETLGT_AddressSubmitController.btnSubmit(person, 'BusinessUnit', 'AlternateAddress', mForms);
        Test.stopTest();
    }
    
    @isTest static void testFindMemberInfor_2(){
        Test.startTest();
        ACETLGT_AddressSubmitController.resultwrap resWrap = new ACETLGT_AddressSubmitController.resultwrap();
        resWrap.errorMessage = 'errorMessage';
        resWrap.isSuccess = 'successMessage';
        ACETLGT_AddressSubmitController.AddOnFilePersonWrapper person = ACETLGT_AddressSubmitController.findMemberInfo('', '930775200');
        Test.stopTest();
    }
}