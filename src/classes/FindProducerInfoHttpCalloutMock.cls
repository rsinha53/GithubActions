@isTest
global class FindProducerInfoHttpCalloutMock implements HttpCalloutMock {
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest request) {
        // Create a fake response
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        response.setBody('{"response": { "serviceAttributes":{"applicationIdentifier": "IVR","requestIdentifier": "2d537d12-b1fd-4d7a-b990-40dfb1c23426","responseCode": "200",'+
      '"responseDescription": "Success:Trace of all the success calls","totalNumberOfRecords": "9","pageNumber": "","recordsPerPage": ""},"getProducerResponse":{'+
      '"producerID": "167106","memberGroupDetails":[{"groupNumber": "2100105","groupName": "10404 - Scenario 5 "},{"groupNumber": "9786013","groupName": "SB UHG Scenario 4"'+
      '},{"groupNumber": "1110176","groupName": "UHG SHOP Test contract 26"},{"groupNumber": "5110301","groupName": "Test UHG contract 31"},{"groupNumber": "1110111",'+
      '"groupName": "UHG SHOP Test contract 15"},{"groupNumber": "9966214","groupName": "Test contract 2"},{"groupNumber": "9966231","groupName": "Test contract 2"'+
      '},{"groupNumber": "7676005","groupName": "SB UHG Scenario 1"},{"groupNumber": "8110400","groupName": "Test UHG PR contract 1"}],"producerCompanyName": "",'+
      '"producerName":{"firstName": "SAMUEL","middleInitial": "J","lastName": "GRUBBS"},"producerTIN": "","producerSSN": "987167106","producerType": "I ","type": "BR",'+
      '"producerContact": " ","producerEffectiveStartDate": "08/23/2007","producerEffectiveEndDate": "12/31/2016","producerAddress":{"addressTypeCode": "M","addressLine1": "647 LUVERNE AVE",'+
      '"addressLine2": "","city": "PANAMA CITY","state": "FL","zipCode": "32401","country": "","phoneNumber": "8507695215"},"producerStatus": "InActive","legacyBrokerCode": ""}'+
            '}}');
        response.setStatusCode(200);
        return response; 
    }
}