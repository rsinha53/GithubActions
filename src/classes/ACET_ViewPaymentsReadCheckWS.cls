public class ACET_ViewPaymentsReadCheckWS {
    Public Static ACET_SAECalloutResult getReadChecData(String cNumber,String sdNo)
    {
        ACET_SAECalloutResult retResponse = new ACET_SAECalloutResult();
        try
        {
            RequestBody request= new RequestBody();
            Meta meta= new Meta();
            meta.sourceSystem='TREASURY';
            meta.securityToken='';
            
            Data data= new Data();
            data.seriesDesignator=sdNo;
            data.checkPayReferenceID='';
            data.checkNumber=cNumber;
            request.meta= meta;
            request.data= data;
            System.debug('1@RequestBody'+request);
            ACET_WebserviceCalloutFramework wsCallOutFW = new ACET_WebserviceCalloutFramework();
            wsCallOutFW.serviceName = 'PaymentReadCheck';
            wsCallOutFW.requestBody = JSON.serialize(request);
            System.debug('2@HttpRequest'+wsCallOutFW);
            HttpResponse httpResponse = wsCallOutFW.getResponse();
            //String responseString = [SELECT Body FROM StaticResource WHERE Name ='PaymentReadCheck' LIMIT 1].Body.toString();
           // httpResponse.setBody(responseString);
           // httpResponse.setStatusCode(200);
            System.debug('3@HttpResponse'+httpResponse);
            if(httpResponse.getStatusCode() == 200){
                retResponse.statusCode = 200;
                retResponse.isSuccess = true;
                ACET_ReadCheckRespWrap resp = (ACET_ReadCheckRespWrap) JSON.deserialize(httpResponse.getBody(),ACET_ReadCheckRespWrap.class);
                retResponse.response = resp;
                System.debug('4@resp'+resp+'\n return success response '+retResponse);
            }else{
                retResponse.statusCode = httpResponse.getStatusCode();
                retResponse.isSuccess = false;
                retResponse.message = String.valueOf(httpResponse.getBody());
                System.debug('5@HttpResponseBody'+httpResponse.getBody());
            }
        }catch(Exception e){
            retResponse.statusCode = 400;
            retResponse.isSuccess = false;
            retResponse.message=String.valueOf(e);
            System.debug('6@ExceptionInReadCheckcls' + e.getMessage() + '--->' + e.getLineNumber());
        }
        return retResponse;
    }
    public class RequestBody {
        public Meta meta{get;set;}
        public Data data{get;set;}
    }
    public class Meta{
        public String sourceSystem{get;set;}
        public String securityToken{get;set;}
    }
    public class Data{
        public String seriesDesignator{get;set;}	
        public String checkPayReferenceID{get;set;}
        public String checkNumber{get;set;}
    }
}