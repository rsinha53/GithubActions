@isTest
global class MockHttpDermAPITokenResponseGenerator implements HttpCalloutMock {
    public MockHttpDermAPITokenResponseGenerator() {

     }    
        public string valtype;
        public MockHttpDermAPITokenResponseGenerator(string resType){
           valtype = resType;
        }
        global HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
             if(valtype == 'empty'){
                 string nullval = '';
                res.setBody('{"token_type":"bearer","access_token":"'+nullval+'"}');
            }
            else{
                res.setBody('{"token_type":"bearer","access_token":"lopLXwXceqtPvfBYv5apRY0iC02j2jCY"}');
                
            }
            if(valtype == null){
                res = null;
            }
            if(res != null){
                res.setStatusCode(200);
            }
            else{
                CalloutException e = new CalloutException();
                throw e;
            }

            return res;
    
        }
    }