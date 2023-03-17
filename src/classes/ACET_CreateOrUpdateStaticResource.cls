public with sharing class ACET_CreateOrUpdateStaticResource {
    

    public static void createOrUpdateStaticResource (String fileName, String contentType, String cacheControl, String fileData) {
        Http h = new Http();
        HttpRequest httpReq = new HttpRequest();
        HttpResponse httpRes = new HttpResponse();
        String base64EncodedBody = EncodingUtil.base64Encode(Blob.valueof(fileData));
        StaticResourceBody srb = new StaticResourceBody();
        srb.Name = fileName;
        srb.ContentType = ContentType; //application/json
        srb.CacheControl = cacheControl; //Public
        srb.Body = base64EncodedBody;
        String body = JSON.serialize(srb);
        System.debug('@@ ACET_CreateStaticResource: createStaticResource: body: ' + body);
        StaticResource staticRecord = new StaticResource();
        String endpointPath = '';
        try {
         	staticRecord = [Select Id, Name FROM StaticResource where Name = :fileName LIMIT 1];
            endpointPath = '/services/data/v41.0/tooling/sobjects/StaticResource/' + staticRecord.Id + '?_HttpMethod=PATCH';
        } catch(QueryException qe) {
            endpointPath = '/services/data/v41.0/tooling/sobjects/StaticResource/';
        }
        httpReq.setEndpoint(URL.getSalesforceBaseUrl().toExternalForm() + endpointPath);
        httpReq.setMethod('POST');
        httpReq.setHeader('Content-Type', 'application/json'); 
        httpReq.setHeader('Authorization', 'Bearer ' + UserInfo.getSessionId());
        httpReq.setBody(body);
        httpRes = h.send(httpReq);
        System.debug('@@ ACET_CreateStaticResource: createStaticResource: response body: ' + httpRes.getBody());
    }

    public class StaticResourceBody {
        public String Name;
        public String ContentType;
        public String CacheControl;
        public String Body;
    }
    
}