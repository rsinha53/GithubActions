public with sharing class ACET_ReadCarrierComments 
{
    public static final String APP_NAME = 'ISET';
    public static final String APP_INS_NAME = 'HAD';

    public static ACET_SAECalloutResult invokeService(String planType, String logonId, String password, String sysName, String  empPrefx, String empId, String policyId)
    {
        ACET_SAECalloutResult calloutRes = new ACET_SAECalloutResult();
        HttpRequest request = new HttpRequest();
        HttpResponse response = new HttpResponse();
        try{
            // Using string for easier maintenance and debugging
            String xmlBody = '';
            xmlBody = '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:v3="http://upm3.uhc.com/member/readcarriercomments/v3">'+
                    +'<soapenv:Header/>'+
                    +'<soapenv:Body>'+ 
                    +'<v3:invokeService xmlns:v3="http://upm3.uhc.com/member/readcarriercomments/v3">'+
                    +'<arg0><requestHeader>' + 
                    +'<applicationName>'+APP_NAME+'</applicationName>'+
                    +'<applicationInstanceName>'+APP_INS_NAME+'</applicationInstanceName>'+ 
                    +'<logLevel>DEFAULT</logLevel>'+
                    +'<serviceOption>'+
                    +'<key>SOAP_FAULTS_AS_STATUS_MESSAGE_BEANS</key>'+
                    +'<value>true</value>'+
                    +'</serviceOption>'+
                    +'</requestHeader>'+
                    +'<carrierType>'+planType+'</carrierType>'+
                    +'<logonId>'+logonId+'</logonId>'+
                    +'<password>'+password+'</password>'+
                    +'<system>'+sysName+'</system>'+
                    +'<employeePrefix>'+empPrefx+'</employeePrefix>'+
                    +'<employeeId>'+empId+'</employeeId>'+
                    +'<policy>'+policyId+'</policy>'+
                    +'</arg0>'+
                    +'</v3:invokeService>'+
                    +'</soapenv:Body>'+
                    +'</soapenv:Envelope>';

            Http ht = new Http();
            request   = new HttpRequest();        
            request.setMethod('POST');
            request.setBody(xmlBody);
            // Named Credential Endpoint
            request.setEndpoint('callout:COB_ReadCarrierComments');
            Map<String, String> headers = new map<String, String>{'Content-type' => 'text/xml','Content-Length' => '','SoapAction' => ''};
            for(String HeaderKey :headers.keySet()){
                request.setHeader(HeaderKey, Headers.get(HeaderKey));
            }
            response = new HttpResponse();
            response = ht.send(request);
            System.debug('Request => ' + request.getBody());
            System.debug('Response => ' + response.getBody());            
            if(response.getStatusCode() == 200){
                calloutRes.isSuccess = true;
                calloutRes.statusCode = 200;
                calloutRes.response = processXMLData(response.getBody(),planType);
            }else{
                calloutRes.isSuccess = false;
                calloutRes.message = response.getStatus();
                calloutRes.statusCode = response.getStatusCode();
            }
        }catch(Exception e){
            calloutRes.isSuccess = false;
            calloutRes.message = e.getMessage();
            calloutRes.statusCode = 999;
            System.debug(e.getMessage() +'=>'+ e.getLineNumber());
        }

        return calloutRes;
    }

    public static COBWrapper processXMLData(String xmlStr, String planType){
        Dom.Document doc = new Dom.Document();
        doc.load(xmlStr);
        Dom.XMLNode envelope = doc.getRootElement();        
        Dom.XmlNode comments;
        comments = envelope.getChildElements()[0]
                                .getChildElements()[0]
                                .getChildElements()[0].getChildElements()[1];
        List<CommentWrapper> commentList = new List<CommentWrapper>();
        if(comments != null){
            if(planType == 'MEDICARE'){
                Dom.XmlNode mediComments = comments.getParent();
                for(Dom.XmlNode child : mediComments.getChildElements()){
                    if(child.getName() == 'medicareCarrierComments'){
                        CommentWrapper cwrap = new CommentWrapper();
                        cwrap.planType = planType;
                        cwrap.comment =  child.getChildElement('comment', null) != null ? child.getChildElement('comment', null).getText() : '--';
                        cwrap.commentDate = child.getChildElement('commentDate', null) != null ? SAEUtils.formatDate(child.getChildElement('commentDate', null).getText()) : '--';
                        commentList.add(cwrap);
                    }
                }
            }else{
                for(Dom.XmlNode child : comments.getChildElements()){
                    if(child.getName() == 'comments'){
                        CommentWrapper cwrap = new CommentWrapper();
                        cwrap.planType = planType;
                        cwrap.comment = child.getChildElement('comment', null) != null ? child.getChildElement('comment', null).getText() : '--';
                        cwrap.commentDate = child.getChildElement('commentDate', null) != null ? SAEUtils.formatDate(child.getChildElement('commentDate', null).getText()) : '--';
                        commentList.add(cwrap);
                    }
                } 
            }            
        }     
        COBWrapper returnWrap = new COBWrapper();
        returnWrap.comments = commentList;
        System.debug(JSON.serialize(returnWrap));
        return returnWrap;
    }
    

    public class COBWrapper{
        // Add other fields as required from the response
        @AuraEnabled public List<CommentWrapper> comments{get;set;}
    }

    public class CommentWrapper{
        @AuraEnabled public String planType{get;set;}
        @AuraEnabled public String comment{get;set;}
        @AuraEnabled public String commentDate{get;set;}
    }
}