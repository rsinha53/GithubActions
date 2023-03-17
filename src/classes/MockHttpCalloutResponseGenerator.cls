//This is to Create fake response
@isTest(SeeAllData=false)
public class MockHttpCalloutResponseGenerator implements HttpCalloutMock
{
    public MockHttpResponse OAuthWSResponse;
    public MockHttpResponse OILWSResponse;
        
    protected Integer httpResponseStatusCode;
    protected String httpResponseStatus;
    protected String httpResponseBody;
       
    public MockHttpCalloutResponseGenerator()
    {
    }
    
    public MockHttpCalloutResponseGenerator(MockHttpResponse OAuthWSResp, MockHttpResponse OILWSResp)
    {
        OAuthWSResponse = OAuthWSResp;
        OILWSResponse = OILWSResp;      
    }
    
    public HTTPResponse Respond(HTTPRequest Request) 
    {
        system.debug(LoggingLevel.INFO, 'Inside MockHttpCalloutResponseGenerator.Respond. Request: ' + Request);
        
        HttpResponse Response = new HttpResponse();
        MockHttpResponse oMockHttpResponse = Request.getEndpoint().contains('/auth/oauth/v2/token') ? OAuthWSResponse : OILWSResponse;
        system.debug('oMockHttpResponse '+oMockHttpResponse );
        if (oMockHttpResponse.TokenExpired != null && oMockHttpResponse.TokenExpired)
        {
            Response.setStatusCode(500);
            Response.setStatus('Internal Server Error');
            Response.setBody('{"ErrorID":"3e363171-6e86-41ae-b4b9-2cf9f4f70e80","ErrorCode":"4.2","ErrorMessage":"Error","Advice":"If problem persists, please contact API team"}');
            oMockHttpResponse.TokenExpired = false;
        }
        else if(oMockHttpResponse.TokenExpired != null)
        {
            Response.setStatusCode(oMockHttpResponse.StatusCode);
            Response.setStatus(oMockHttpResponse.Status);
            Response.setBody(oMockHttpResponse.Body);
        } 
        system.debug(LoggingLevel.INFO, 'Inside MockHttpCalloutResponseGenerator.Respond. Response: ' + Response);
        return Response;
    }   
    
    public class MockHttpResponse
    {
        public Integer StatusCode { get; set; }
        public String Status { get; set; }
        public String Body { get; set; }
        public Boolean TokenExpired { get; set; }
        
        public MockHttpResponse(Integer StatusCodeParam, String StatusParam, String BodyParam)
        {
            StatusCode = StatusCodeParam;
            Status = StatusParam;
            Body = BodyParam;
        } 
    }   
}