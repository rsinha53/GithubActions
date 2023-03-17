public without sharing class ACET_CountinousCallout {
    
    static string COMMON_ERROR_MESSAGE='Unexpected error occurred. Please try again. If problem persists contact help desk.';
    static List<String> requestLabelList=new List<String>();
    static List<String> finalHttpResponse=new List<String>();
    static Map<String,ServiceCallout> serviceRequestMap=new Map<String,ServiceCallout>();
    static Map<String,ACET_WebServiceUtils.ServiceMockResponse> serviceMockMap=new Map<String,ACET_WebServiceUtils.ServiceMockResponse>();
    Static Map<String,String> requestLServiceMap=new Map<String,String>();
    Static Integer statuscode;
    public class ServiceCallout{
        
        public String serviceName{get;set;}
        public String docClass{get;set;}
        public String requestBody{get;set;}
        public Map<String,String> requestParamsMap{get;set;}
        public String inputParam{get;set;}
        public Boolean createJSONBody{get;set;}
        public String outputFormat{get;set;}
        public String docName{get;set;}
        
    }
    
    @AuraEnabled(continuation=true)
    public static Object startRequest(String serviceCalloutInput) {
        try{
            List<ServiceCallout> serviceCalloutList=(List<ServiceCallout>)Json.deserialize(serviceCalloutInput, List<ServiceCallout>.class);	          
            if(serviceCalloutList[0].docName != null && serviceCalloutList[0].docName != '') {
                COMMON_ERROR_MESSAGE = 'Unexpected Error Occurred in the '+serviceCalloutList[0].docName+' card. Please try again. If problem persists please contact the help desk.';
            }           
            String orgName = Organization_Properties__c.getOrgDefaults().OrganizationName__c;        
            if(serviceCalloutList.size()>3 || serviceCalloutList.isEmpty()){ 
                return 'Continuation Framework Can handle only three callout';
            }else{
                for(ServiceCallout each:serviceCalloutList){
                    if(each.createJSONBody)
                        each.requestBody=ACET_WebServiceUtils.createJsonRequestBoby(each.docClass,each.inputParam);
                    	serviceRequestMap.put(each.docClass, each);
                }
                //Searching for Mock Response if applicable for the running org
                serviceMockMap=ACET_WebServiceUtils.getMockResponse(serviceCalloutList);
                if(serviceMockMap.keySet().size()==serviceCalloutList.size()){
                    List<Object> output=new List<Object>();
                    ACET_ClaimRelatedDocumentController.SearchResultWrapper resultWrapper = new ACET_ClaimRelatedDocumentController.SearchResultWrapper();
                    List<ACET_ClaimRelatedDocumentController.AttachmentsResponseData> attachmentList=new List<ACET_ClaimRelatedDocumentController.AttachmentsResponseData>();
                    for(String each:serviceMockMap.keySet()){
                        HttpResponse httpTemp=serviceMockMap.get(each).mockResponse; 
                        if(httpTemp.getStatusCode()==200){
                          attachmentList.addAll(ACET_WebServiceUtils.transformResponse(each,httpTemp.getBody())); 
                          statuscode = httpTemp.getStatusCode(); 
                        }else{
                            statuscode = httpTemp.getStatusCode(); 
                        }
                        
                    }
                    if(attachmentList.size()>0){
                        resultWrapper.totalRecords=attachmentList.size();
                        resultWrapper.AttachmentsData=attachmentList;
                        resultWrapper.isSuccess=true;
                    }else if (attachmentList.size()== 0 && statuscode == 200){
                        resultWrapper.totalRecords=0;
                        resultWrapper.AttachmentsData=attachmentList;
                        resultWrapper.isSuccess = true;

                    }else{
                        resultWrapper.totalRecords=0;
                        resultWrapper.errorMessage = COMMON_ERROR_MESSAGE;
                        resultWrapper.isSuccess = false;
                    }
                    
                    return resultWrapper;
                }else{
                    Continuation con = new Continuation(120); 
                    con.continuationMethod='processResponse';
                    for(ServiceCallout each:serviceCalloutList){
                        if(!serviceMockMap.containsKey(each.docClass)){
                            ACET_WebserviceCalloutFramework wsCallOut = new ACET_WebserviceCalloutFramework(); 
                            wsCallOut.serviceName = each.serviceName;
                            wsCallOut.requestBody = each.requestBody;
                             requestLServiceMap.put(con.addHttpRequest(wsCallOut.getHttpRequest()), each.docClass);
                            wsCallOut=null;
                        }
                    }   
                    con.state = requestLServiceMap;
                    return con;
                }
            }
            
        }catch(Exception e){
            system.debug('Exception '+e);
            
        }
        return null;
    }
    @AuraEnabled(continuation=true)
    public static Object processResponse(List<String> labels, Object state) {
        Map<String,boolean> requestSuccessStatus=new Map<String,Boolean>();
		Map<String,String> serviceResponseBody=new Map<String,String>();
       Map<String,String> requestLServiceMap=(Map<String, String>)state;
        system.debug('requestLServiceMap'+requestLServiceMap);
        List<Object> output=new List<Object>();
        ACET_ClaimRelatedDocumentController.SearchResultWrapper resultWrapper = new ACET_ClaimRelatedDocumentController.SearchResultWrapper();
        List<ACET_ClaimRelatedDocumentController.AttachmentsResponseData> attachmentList=new List<ACET_ClaimRelatedDocumentController.AttachmentsResponseData>();
        
        for(String each:requestLServiceMap.keySet()){
            HttpResponse response = Continuation.getResponse(each);
			system.debug('response '+response);
            system.debug('response body'+response.getBody());
            if(response.getStatusCode() == 200){
                finalHttpResponse.add(response.getBody());
                statuscode=response.getStatusCode();
				 serviceResponseBody.put(requestLServiceMap.get(each), response.getBody());
            }
            else{
                requestSuccessStatus.put(each, false);
                //Need to implement Exception Logging
                statuscode=response.getStatusCode();
            }
        }
         system.debug('serviceResponseBody::'+serviceResponseBody);
        for(String each:serviceResponseBody.keySet()){
            attachmentList.addAll(ACET_WebServiceUtils.transformResponse(each,serviceResponseBody.get(each)));
        }
        if(attachmentList.size()>0){
            resultWrapper.AttachmentsData=attachmentList;
            resultWrapper.totalRecords=attachmentList.size();
            resultWrapper.isSuccess=true;
        }else if (attachmentList.size()== 0 && statuscode == 200){
            resultWrapper.totalRecords=0;
            resultWrapper.AttachmentsData=attachmentList;
            resultWrapper.isSuccess = true;
            
        }else{
            if(serviceResponseBody.keyset().size() > 1){
                COMMON_ERROR_MESSAGE = 'Unexpected Error Occurred in the '+serviceResponseBody.values()[0]+' card. Please try again. If problem persists please contact the help desk.';
            }
            resultWrapper.totalRecords=0;
            resultWrapper.errorMessage = COMMON_ERROR_MESSAGE;
            resultWrapper.isSuccess = false;
        }
        
        return resultWrapper;
    }
    @AuraEnabled
    public static String generateDoc360URL(String doc360Input) {
        return ACET_WebServiceUtils.generateDoc360URL(doc360Input);
    }

    @AuraEnabled
    public static Object getClaimNotOnFileDoc(String serviceCalloutInput,Boolean isClaimNotOnFile) {
        ACET_ClaimRelatedDocumentController.isClaimNotOnFile = isClaimNotOnFile;
        return startRequest(serviceCalloutInput);
    }
}