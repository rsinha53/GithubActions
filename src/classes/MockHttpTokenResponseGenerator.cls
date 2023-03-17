@isTest
global class MockHttpTokenResponseGenerator implements HttpCalloutMock {
    public string valtype;
    public MockHttpTokenResponseGenerator(string resType){
       valtype = resType;
    }
    global HTTPResponse respond(HTTPRequest req) {
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
         if(valtype == 'empty'){
             string nullval = '';
            res.setBody('{"token_type":"bearer","access_token":"'+nullval+'"}');
        }
        else if(valtype == 'expiry'){
            res.setBody('{"token_type":"bearer","access_token":"lopLXwXceqtPvfBYv5apRY0iC02j2jCY_expiry_10"}');
        }
        else{
            res.setBody('{"token_type":"bearer","access_token":"lopLXwXceqtPvfBYv5apRY0iC02j2jCY"}');
            
        }
        
        
        res.setStatusCode(200);
        return res;

    }
}