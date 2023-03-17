/*------------------------------------------------------------
Author:        Prajnith Karra
Description:   

Test Class: CHNSENSAPITest

History
24-07-2022  Prajnith Karra       Initial Code
Modified By : Pratikshya Satapathy
03-10-2022  Manmeet Kaur         Modified
25-11-2022  Tushar Kaore         Modified
16-12-2022  Harshini Thotakura   Modified
------------------------------------------------------------*/
@RestResource(urlMapping='/CHNSENSAPI/*')
global with sharing class CHNSENSAPI {
    public Static String svcName;
    public Static Integer statusCode;
    public Static Boolean exceptionCheck = false; 
    
    //tag name which will be added in request if source is present in header
    public static final String REQUEST_SOURCETAG = 'requestHeaderSource';
    private static final String SOURCEKEY = 'source';
    private static Map<String, String> serviceVsleagueReqParser;
    private static Map<String, String> serviceVsResponseProcessorClass;
    private static Map<String, String> sourceMap;
    
    @TestVisible private static Boolean testClassException = false;
    
    // load all the static callout configuration values 
    static {
        logger.start();
        serviceVsleagueReqParser = new Map<String, String>();
        sourceMap = new Map<String, String>();
        serviceVsResponseProcessorClass = new Map<String, String>();
        Map<String, CHN_SENS_API_CALLOUTS__mdt > reqGenerators = CHN_SENS_API_CALLOUTS__mdt.getAll();
        for(String key : reqGenerators.keySet()){
            serviceVsleagueReqParser.put(reqGenerators.get(key).Service_Name__c ,reqGenerators.get(key).Request_Parser_Class__c);
            sourceMap.put(reqGenerators.get(key).Service_Name__c,reqGenerators.get(key).Source__c);
            
        }
    }
    
    @HttpPost
    global static void doPost(){
        IRestResponseWrapper responseWrapper; 
        String response = '';
        String svcName = '';
        String source = '' ;
        String jsonStr = '';
        String request = RestContext.request.requestBody.toString();
        
        try{
            
            if(null != RestContext.request.requestBody) {
                jsonStr = RestContext.request.requestBody.toString();
            }
            
            if(RestContext.request.headers.containsKey('svcName')){
                svcName = (String) RestContext.request.headers.get('svcName');  
            }
            if(RestContext.request.headers.containsKey('source')){
                source = (String) RestContext.request.headers.get('source');  
            }
            
            // Check if serviceName is empty or incorrect 
            if(!(serviceVsleagueReqParser.containsKey(svcName))){
                response = getErrorResponse(400,SENSAPI_Constant.SOURCE_SERVICE_ERROR);
                populateRestResponse(400, response);
                return;     
            }
            
            //Check if source is  empty or incorrect
            if(sourceMap.get(svcName) != source  && serviceVsleagueReqParser.containsKey(svcName) ){
                response = getErrorResponse(400,SENSAPI_Constant.SOURCE_ERROR);
                populateRestResponse(400, response);
                return;     
            }
            
            //call the processor class if service name and source is correct
            if(serviceVsleagueReqParser.get(svcName) != null && sourceMap.get(svcName) != null){
                Type requestGeneratorType = Type.forname(serviceVsleagueReqParser.get(svcName));
                IRestRequestProcessor  requestProcessor = (IRestRequestProcessor) requestGeneratorType.newInstance();
                responseWrapper = requestProcessor.process(jsonStr);
                String responseStr = getSuccessResponse(responseWrapper);
                populateRestResponse(null,responseStr);     
            }
            
            if(Test.isRunningTest() && testClassException){
                throw new SENSAPI_Exception('Test exception');
            }
        }catch(Exception ex){
            //set response body         
            response = getErrorResponse(500,ex.getMessage() + ' - ' + ex.getStackTraceString());
            populateRestResponse(500, response);
            statusCode = RestContext.response.statusCode;
            svcName = (String) RestContext.request.headers.get('svcName');
            Logger.apiException(ex,request,response,statusCode,svcName);
			exceptionCheck = true;
            return;    
        }finally {
			if (!exceptionCheck) {
                statusCode = RestContext.response.statusCode;
                response = RestContext.response.responseBody.toString();
				Logger.apiLog(request,response,statusCode,svcName);
			}
		}
    }
    
    private static void populateRestResponse(Integer statusCode, String jsonResponse){
        RestContext.response.addHeader('Content-Type', 'application/json');
        RestContext.response.responseBody = Blob.valueOf(jsonResponse);   
        if(statusCode != null){
            RestContext.response.statusCode = statusCode;
        }
    }
    
    private static String getSuccessResponse(IRestResponseWrapper responseWrapper){
        SENSAPI_ResponseParser apiResponse = new SENSAPI_ResponseParser();
        apiResponse.response.data = responseWrapper;
        return JSON.serialize(apiResponse);
    }
    
    /**
     * @Description : This method is responsible to get response 
     */ 
    private static String getErrorResponse(Integer errorCode ,String errorDescription){
        SENSAPI_ResponseParser apiResponse = new SENSAPI_ResponseParser();
        apiResponse.response.data = new SENSAPI_ResponseParser.StatusResponse(new SENSAPI_StatusResponse(false,errorCode,errorDescription));
        return JSON.serialize(apiResponse);
    }
    
    
    //log integration message with request and response, initiated by league and stage should be responded
    private static void logIntegrationMessage(String jsonStr,String svcName,String requestStructure){
    }
}