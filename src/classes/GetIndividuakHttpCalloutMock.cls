@isTest

global class GetIndividuakHttpCalloutMock implements HttpCalloutMock {

    // Implement this interface method

    global HTTPResponse respond(HTTPRequest request) {

        // Create a fake response

        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        response.setBody('{"getIndividualResponse":{"individual":{"individualIdentifier":"455546547","name":{"firstName":"SubFN7","lastName":"SubLN7","middleName":"A","nameSuffix":""},"birthDate":"1980-05-05","genderCode":"M","genderDescription":"Male","socialSecurityNumber":"","maritalStatusCode":"","maritalStatusDescription":"","deceasedDate":"","privacyIndicator":"","tobaccoUsageIndicator":"","ethnicityCode":"","ethnicityDescription":"","address":[{"typeCode":"HOM","addressLine1":"653 Street line 1","addressLine2":"","city":"HARTFORD","postalCode":"06103","stateCode":"CT","countryCode":"US"}],"phone":[{"phoneType":"H","phoneNumber":"321-686-5384","phoneExt":"","internationalIndicator":"N","primaryIndicator":"Y"}],"email":[{"communicationTypeCode":"EML","electronicAddress":"abc@gmail.com","primaryIndicator":"Y"}],"employment":[{"employmentStatus":"A","employeeIdentifier":"","employmentStartDate":"2017-01-01","retirementDate":"9999-12-31"}],"language":[{}],"otherContact":[{}],"dependentDisabilityList":[{}],"identifiers":[{"id":"620692686","type":"SRK"}]}}}');
        response.setStatusCode(200);
        return response; 

    }

}