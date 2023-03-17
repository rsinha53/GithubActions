public class ACET_ViewPCPReferralMockResponse implements HttpCalloutMock{
    public static final string failedresbody = '{"faultCode": "400", "message": "Failed Due to Mandatory fields are blank"}';
    public static final string successresbody= '{"referralStatusResponse":[{"referralId":"123456789","referringProvider":"JIPSOM, GEORGE W.","referredToProvider":"CARE, LINDER E.","startDate":"2019-09-18","endDate":"2020-03-17","numberOfVisits":"6","remainingVisits":"6","firstDiagnosisCode":"H53.9","secondDiagnosisCode":"H53.9","comments":"","referredToProviderPhoneNumber":null,"referredToProviderNpi":null,"referredToProviderAddress":null,"referringProviderAddress":null,"referringProviderTin":null,"referredToProviderTin":null,"referredToProviderSpeciality":null,"referringProviderNpi":null,"referringProviderPhoneNumber":null,"referringProviderMpin":"000774778123","referredToProviderMpin":"002214629234"}]}';
    public  Integer statuscode;
    public boolean isException;
    
    public ACET_ViewPCPReferralMockResponse(Integer code,boolean ExceptionNeeded){
        this.statuscode = code;
        this.isException = ExceptionNeeded;
    }
    
    public  HTTPResponse respond(HTTPRequest request) {
        // Create a fake response
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        response.setBody(successresbody);
        if(isException){
            response.setBody(failedresbody);
        }
        
        response.setStatusCode(statuscode);
        return response; 
    }
}