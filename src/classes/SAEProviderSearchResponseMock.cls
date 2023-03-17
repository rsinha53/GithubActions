@isTest
global class SAEProviderSearchResponseMock implements HttpCalloutMock{
    public Integer statusCode{get;set;}

    public SAEProviderSearchResponseMock(Integer statusCode)
    {
        this.statusCode = statusCode;
    }
    global HTTPresponse respond(HttpRequest req)
    {        
        //System.assertEquals('GET', req.getMethod());       
        StaticResource responseJSONSR = null;        
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');

        //Set body for not found        
        if(statusCode == 400){
            Map<String,String> notFoundResponse = new Map<String,String>{
                'faultCode' => 'AAA:76',
                'message' => 'errorMessage'
            };
            res.setBody(JSON.serialize(notFoundResponse));
        }else if(statusCode == 500){
            Map<String,String> notFoundResponse = new Map<String,String>{
                'faultCode' => 'AEFNEE',
                'message' => 'Unexpected error occurred. Please try again. If problem persists contact help desk.'
            };
            res.setBody(JSON.serialize(notFoundResponse));
        }
        else{
            responseJSONSR = [SELECT Body FROM StaticResource WHERE Name = 'SAEEligibilityResponseMock_Vinay'];
            res.setBody(responseJSONSR.Body.toString());
        }

        res.setStatusCode(statusCode);
        return res;
    }
}