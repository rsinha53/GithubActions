public with sharing class ACETGetProducerAPI{
    
    public ACETProducerResult producerDetailresult;
    public ACETGetProducerResponseDetail getProducerResponseDetail;
    public String flag {get; set;}
    public String currentDate = cleanDate(ACETUtility.format(Date.today()));
    public String RequestBody;
    
    public static final string COMMON_ERROR_MESSAGE='Unexpected error occurred. Please try again. If problem persists contact help desk.';
    public static List<String> requestLabelList=new List<String>();
    public static List<String> finalHttpResponse=new List<String>();
    public static Map<String,ACET_CountinousCallout.ServiceCallout> serviceRequestMap=new Map<String,ACET_CountinousCallout.ServiceCallout>();
    public static Map<String,ACET_WebServiceUtils.ServiceMockResponse> serviceMockMap=new Map<String,ACET_WebServiceUtils.ServiceMockResponse>();
    public static Map<String,String> requestLServiceMap=new Map<String,String>();
    
    
    public String GetRequestBody(String ProducerId)
    {    
        ACETGetProducerRequestDetail getProducerReq = new ACETGetProducerRequestDetail();
        ACETGetProducerRequestDetail.ServiceAttributes service = new ACETGetProducerRequestDetail.ServiceAttributes();
        ACETGetProducerRequestDetail.GetProducerRequest getProducer=new ACETGetProducerRequestDetail.GetProducerRequest();
        
        service.applicationIdentifier='ACET';
        service.requestIdentifier='74a0a206-7fbb-4568-ad39-5de31abb6db3';
        service.producerGroupAssociation = flag;
        service.pageNumber= 1;
        service.recordsPerPage= 100;        
        
        getProducer.producerID= ProducerId;
        getProducer.customerNumber= '';
        getProducer.adminSystem= '';
        getProducer.producerEffectiveAsofdate = currentDate;
        
        RequestBody = stripJsonNulls(getProducerReq.addSearchInput(service,getProducer));
        return RequestBody;
    }
    
		    
    public ACETWSCalloutResult GetProducer(String ProducerId){
        
        ACETWSCalloutResult oACETWSCalloutResult = new ACETWSCalloutResult();
        try
        {            
            GetRequestBody(ProducerId);
            ACET_WebserviceCalloutFramework wsCallOutFW = new ACET_WebserviceCalloutFramework('ACETGetProducerAPI',RequestBody,null);
            HttpResponse Response;
            if(!Test.isRunningTest()){
                Response = wsCallOutFW.getResponse();
            }
            else{
                Response = new HttpResponse();
                Response.setBody(ACETProducerDetailControllerTest.getProducerAPIResponseBody);
                Response.setStatusCode(200);
            }
            producerDetailresult = new ACETProducerResult();
            oACETWSCalloutResult.statusCode=response!=null?response.getStatusCode():null;//Added for US1517846
            if (Response.getStatusCode() == 200){
                oACETWSCalloutResult.Success = true;
                oACETWSCalloutResult.Message = '';
                //Response.setBody('-');
                oACETWSCalloutResult.Response = parseSuccessAdapterResponse(ACET_WebServiceUtils.ReplaceKeywords(Response.getBody()));
                if(Response.getBody()!=Null){
                    ACETGetProducerResponseDetail.ServiceAttributes PDresponse; 
                    ACETGetProducerResponseDetail ACTGPJSON2Apex = (ACETGetProducerResponseDetail)JSON.deserialize(Response.getBody(), ACETGetProducerResponseDetail.class);
                    PDresponse= ACTGPJSON2Apex.response.serviceAttributes;
                    getProducerResponseDetail = (ACETGetProducerResponseDetail)JSON.deserialize(Response.getBody(), ACETGetProducerResponseDetail.class);
                    if(Integer.ValueOf(PDresponse.responseCode)!=200){
                        oACETWSCalloutResult.Success = false;
                        oACETWSCalloutResult.statusCode=Integer.ValueOf(PDresponse.responseCode);
                    }
                }
            }
            else {
                oACETWSCalloutResult.statusCode=response!=null?response.getStatusCode():null;//Added for US1517846
            }  
        }
        catch(Exception ex){
            system.debug(LoggingLevel.INFO, 'Exception in ProcessResponse. Details: ' + ex); 
            oACETWSCalloutResult.Success = false;
            oACETWSCalloutResult.Message = ex.getMessage();
            oACETWSCalloutResult.MessageSeverity = ApexPages.Severity.ERROR;
            oACETWSCalloutResult.statusCode=999; //Added for US1517846
        }
        return oACETWSCalloutResult;
    } 
    
    public ACETProducerResult parseSuccessAdapterResponse(String ResponseBody)
    {
        producerDetailresult = new ACETProducerResult(); 
        producerDetailresult.addressInfo= new ACETProducerResult.ACETProducerDemography();
        producerDetailresult.addresslist = new  list<ACETProducerResult.ACETProducerDemography>();
        producerDetailresult.producerGrouplist = new  list<ACETProducerResult.ACETGroupInfoWrapper>();
        getProducerResponseDetail = (ACETGetProducerResponseDetail)JSON.deserialize(ResponseBody, ACETGetProducerResponseDetail.class);
        ACETGetProducerResponseDetail ACTGPJSON2Apex = (ACETGetProducerResponseDetail)JSON.deserialize(ResponseBody, ACETGetProducerResponseDetail.class);
        ACETGetProducerResponseDetail.GetProducerResponse PDDetails = ACTGPJSON2Apex.response.getProducerResponse;
        generalProducerMapping(PDDetails);
        producerGroupMapping(PDDetails);
        return producerDetailresult;
    }  
    
    public String cleanDate(String theDate){
        String [] s = theDate.split('/');
        String newDate= '';
        String newMonth= '';
        if(s[0].length() == 1){
            newDate = '0'+s[0];
        }else{
            newDate = s[0];
        }
        if(s[1].length() == 1){
            newMonth = '0'+s[1];
        }else{
            newMonth = s[1];
        }
        newDate = newDate+'/'+newMonth+'/'+s[2];
        return newDate;
    }
    
    
    
    private void producerGroupMapping(ACETGetProducerResponseDetail.GetProducerResponse PDDetails)
    {
        try{
            if(PDDetails.customerDetails != null)
            {
                producerDetailresult.producerGrouplist = new  list<ACETProducerResult.ACETGroupInfoWrapper>();  
                for(ACETGetProducerResponseDetail.CustomerDetails producerGroupAddress : PDDetails.customerDetails)
                {   
                    ACETProducerResult.ACETGroupInfoWrapper pGroupaddress = new ACETProducerResult.ACETGroupInfoWrapper();             
                    pGroupaddress.groupNumber = (producerGroupAddress.customerNumber != null)?producerGroupAddress.customerNumber:'';
                    pGroupaddress.groupName = (producerGroupAddress.customerName != null)?producerGroupAddress.customerName:'';
                    pGroupaddress.status = (flag != null && flag=='present')?'Active':(flag != null && flag=='future')?'Future':(flag != null && flag=='past')?'InActive':'';
                    producerDetailresult.producerGrouplist.add(pGroupaddress);
                }
            } 
        }catch(Exception ex){
            system.debug(LoggingLevel.INFO, 'Issues in general producer detail' + ex);                 
        }
    }
    
    private void generalProducerMapping(ACETGetProducerResponseDetail.GetProducerResponse PDDetails)
    {
        try{
            if(PDDetails != null)
            {
                producerDetailresult = new ACETProducerResult();                                             
                producerDetailresult.ProducerID = (PDDetails.producerID != null)?PDDetails.producerID:'';
                producerDetailresult.CompanyName =(PDDetails.producerCompanyName != null)?PDDetails.producerCompanyName:'';
                producerDetailresult.LastName =(PDDetails.producerIndividualName.lastName != null)?PDDetails.producerIndividualName.lastName:'';
                producerDetailresult.FirstName =(PDDetails.producerIndividualName.firstName != null)?PDDetails.producerIndividualName.firstName:'';
                producerDetailresult.MiddleInitial =(PDDetails.producerIndividualName.middleInitial != null)?PDDetails.producerIndividualName.middleInitial:'';
                for(ACETGetProducerResponseDetail.LegacyProducers lp : PDDetails.legacyProducers){
                    if(lp.legacyProducerSystem == 'PUL'){
                        producerDetailresult.legacyBrokerCode =( lp.legacyProducerID != null)?lp.legacyProducerID:''; 
                    }
                }
                producerDetailresult.primaryContactName =(PDDetails.producerContact != null)?PDDetails.producerContact:'';                       
                producerDetailresult.tax_SSN = (PDDetails.producerSSN != null)?PDDetails.producerSSN:'';                          
                producerDetailresult.tax_id = (PDDetails.producerTIN != null)?PDDetails.producerTIN:'';
                producerDetailresult.ProducerType =(PDDetails.producerType != null)?PDDetails.producerType:'';
                producerDetailresult.producerEffectiveStartDate =(PDDetails.producerEffectiveStartDate != null)?PDDetails.producerEffectiveStartDate :'';
                producerDetailresult.producerEffectiveEndDate =(PDDetails.producerEffectiveEndDate != null)?PDDetails.producerEffectiveEndDate :'';
                
                if(PDDetails.producerType != null)
                {
                    if(PDDetails.producerType == 'I ')
                    {
                        producerDetailresult.taxSSNType = 'SSN';                          
                    }
                    else if(PDDetails.producerType == 'B ')
                    {
                        producerDetailresult.taxSSNType = 'TIN';
                    }
                }
                else
                {
                    producerDetailresult.taxSSNType = '';
                }
                
            }
            
            if(PDDetails.producerAddress != null)
            {                
                ACETGetProducerResponseDetail.producerAddress demographics  = new ACETGetProducerResponseDetail.producerAddress();
                demographics = PDDetails.producerAddress;
                producerDetailresult.addresslist = new  list<ACETProducerResult.ACETProducerDemography>();
                ACETProducerResult.ACETProducerDemography address = new ACETProducerResult.ACETProducerDemography();
                address.addressType = (demographics.addressTypeCode != null)?demographics.addressTypeCode:'';
                address.streetAddress = ((demographics.producerStreetLine1 != null)?demographics.producerStreetLine1:'')+''+((demographics.producerStreetLine1 != null)?demographics.producerStreetLine1:'');            
                address.city =(demographics.producerCity != null)?demographics.producerCity:'';               
                address.State  =(demographics.producerState != null)?demographics.producerState:'';  
                address.zip= (demographics.producerZipCode != null)?demographics.producerZipCode:'';
                address.phone =(demographics.producerPhoneNumber != null)?demographics.producerPhoneNumber:'';
                if(address.addressType=='MAIL')
                    address.addressType = 'Mailing';
                else if(address.addressType=='BUSI')
                    address.addressType = 'Business';
                producerDetailresult.addresslist.add(address);
            }
            
        } catch(Exception ex){
            system.debug(LoggingLevel.INFO, 'Issues in general producer detail' + ex);                 
        }
        
    }  
    
    public ContinuationWrapper addHTTPRequest(String producerId, String callbackMethod, Continuation continuationObject){
        if(continuationObject == null){
            continuationObject = new Continuation(40);
        }
        String requestBody = GetRequestBody(producerId);
        ACET_WebserviceCalloutFramework wf = new ACET_WebserviceCalloutFramework('ACETGetProducerAPI',requestBody,null);
        continuationObject.ContinuationMethod = callbackMethod;
        return new ContinuationWrapper(continuationObject,continuationObject.addHttpRequest(wf.getHttpRequest()));
    }
    
    public class ContinuationWrapper{
        public Continuation oContinuation;
        public String requestLabel;
        public ContinuationWrapper(Continuation oContinuation,String requestLabel){
            this.oContinuation = oContinuation;
            this.requestLabel = requestLabel;
        }
    }
    
    public static string stripJsonNulls(string JsonString)
    {

    	if(JsonString != null)   	
    	{
			JsonString = JsonString.replaceAll('\"[^\"]*\":null',''); //basic removeal of null values
			JsonString = JsonString.replaceAll(',{2,}', ','); //remove duplicate/multiple commas
			JsonString = JsonString.replace('{,', '{'); //prevent opening brace from having a comma after it
			JsonString = JsonString.replace(',}', '}'); //prevent closing brace from having a comma before it
			JsonString = JsonString.replace('[,', '['); //prevent opening bracket from having a comma after it
			JsonString = JsonString.replace(',]', ']'); //prevent closing bracket from having a comma before it
    	}
  	
	return JsonString;
    }
}