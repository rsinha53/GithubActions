global with sharing class SAEProviderServiceResponseMock implements HttpCalloutMock {

    public String ProviderType{get;set;}
    public Integer StatusCode{get;set;}

    public SAEProviderServiceResponseMock(String pType) {
        ProviderType = pType;
        StatusCode = 200;
    }

    public SAEProviderServiceResponseMock(integer stCode) {
        StatusCode = stCode;
    }

    global HTTPResponse respond(HTTPRequest req) {        
        // Create a fake response
        StaticResource responseJSONSR = null;
        responseJSONSR = [SELECT Body FROM StaticResource WHERE Name = 'ACETLink_ProviderMockResponse'];
        String resBody = responseJSONSR.Body.toString().replace('svcResponse', 'PhysicianFacilitySummary0002Response');

        if(ProviderType == 'P'){
            resBody.replace('"providerType": "O"', '"providerType": "P"');
            SAE_ProviderResponse responseDes = SAE_ProviderResponse.parse(resBody);
            responseDes.PhysicianFacilitySummary0002Response.get(0).physicianFacilityInformation.providerType = 'P';
            resBody = JSON.serialize(responseDes);
            System.debug('In test ->' + resBody);
        }

        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody(resBody);
        res.setStatusCode(StatusCode);
        return res;
    }
}