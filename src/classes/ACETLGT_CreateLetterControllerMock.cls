@isTest
public class ACETLGT_CreateLetterControllerMock implements HttpCalloutMock {
    private Integer statusCode;
    private String scenario;

    public ACETLGT_CreateLetterControllerMock(Integer statusCode, String scenario) {
        this.statusCode = statusCode;
        this.scenario = scenario;
    }

    public HttpResponse respond(HttpRequest req){
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-type', 'application/json');

        //This is a copy of what the system.Label.ACETUnexpectedErrorMessage equals 
        String errorLabel = 'Unexpected error occurred. Please try again. If problem persists, please contact the help desk.';

        String endPoint = req.getEndpoint();
        if(endpoint.contains('process-letters')){
            String message = 'Process_Letters';
            if(scenario == 'error'){
                message = errorLabel;
            }
            res.setBody('{"MultipartBody":{"rootAttachment":{"object":{"workItems":{"LetterWorkItem":[{"status":"'+message+'", "description":"'+message+'"}]}}}}}');
            res.setStatusCode(statusCode);
        } else {
            res.setBody('{"MultipartBody":{"rootAttachment":{"object":{"workItems":{"LetterWorkItem":[{"status":"ACTIVE_COMPLETE"}]}}}}}');
            res.setStatusCode(200);
        }
    
		return res;
    }
}