public with sharing class ETSBE_FDSApiOAuthWebservice extends AcetWebservice {
    public String GrantType;
    public String AccessToken;
    public String ClientId;
    public String ClientSecret;
    public String user;
    public String pass;
    public String RequestBodyStr;
     public String baseurl ;
    //public String endpoint ;
    //public String OrgName;
    
    
    public String GetAccessToken(){
        String AccessToken = '';
        GetEndpointDetail('GetFDSTokenEndpoint');
        if(WSConfigurations.containsKey(OrgName + '_FDSApiGrantType')){
            GrantType = WSConfigurations.get(OrgName + '_FDSApiGrantType').Value__c;//client_credentials
        }
        if(WSConfigurations.containsKey(OrgName + '_FDSApiOAuthClientId')){
            ClientId = WSConfigurations.get(OrgName + '_FDSApiOAuthClientId').Value__c; //sae-link-nprod
        }
        if(WSConfigurations.containsKey(OrgName + '_FDSApiOAuthClientSecret')){
            ClientSecret = WSConfigurations.get(OrgName + '_FDSApiOAuthClientSecret').Value__c; //50f766e3-c685-4e7d-a7d6-423c76b24cd5
        }
      if(WSConfigurations.containsKey(OrgName + '_GetFDSUploadEndpoint')){
            baseurl = WSConfigurations.get(OrgName + '_GetFDSUploadEndpoint').Value__c; //50f766e3-c685-4e7d-a7d6-423c76b24cd5
        }
        
        //String RequestBodyStr = 'grant_type=' + GrantType + '&client_id=' + ClientId + '&client_secret=' + ClientSecret+'&username=acet_api@uhc.com.test&password=Solaris01!';
        String RequestBodyStr = 'grant_type=' + GrantType + '&client_id=' + ClientId + '&client_secret=' + ClientSecret;
                String payload = 'client_id='+EncodingUtil.urlEncode(clientId,'UTF-8')+'&client_secret='+EncodingUtil.urlEncode(clientSecret,'UTF-8')+'&grant_type='+EncodingUtil.urlEncode('authorization_code','UTF-8');

        HttpRequest Req = new HttpRequest();
        Req.setMethod('POST');
        Req.setEndpoint(RelativeURL);
        Req.setBody(payload);
        Req.setHeader('Content-Type', 'application/x-www-form-urlencoded');     
        Http H = new Http();        
        HttpResponse Response = H.send(Req);
        if (Response.getStatusCode() == 200) {
            Map<String, Object> mapOAuthResponse = (Map<String, Object>)JSON.deserializeUntyped(Response.getBody());
            if (mapOAuthResponse.containsKey('access_token')) {    
                AccessToken = (String)mapOAuthResponse.get('access_token'); 
            }    
        }
        system.debug(LoggingLevel.INFO, 'AccessToken: ' + AccessToken);        
        system.debug('Res is '+Response);
        return AccessToken;
    }

    public override void GetEndpoint()
    {
        GetEndpointDetail('GetFDSTokenEndpoint');
        baseURL = ''; //baseURL = 'https://api-gateway-stage.linkhealth.com';

    }
    /*public ACETLinkApiOAuthWebservice(){
        super('Linkapi');
    }*/
    
    
}