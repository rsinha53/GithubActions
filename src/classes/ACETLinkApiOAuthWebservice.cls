/*
    Created By: Chandan Patro
    Created Date: 29th July 2019
    Description: This class is used to generate the access token for Link Api.
*/
public class ACETLinkApiOAuthWebservice extends AcetWebservice {
    
    public String GrantType;
    public String AccessToken;
    public String ClientId ;
    public String ClientSecret ;
    public String RequestBodyStr;
    //public String endpoint ;
    //public String OrgName;
    
    public override void GetEndpoint()
    {
        GetEndpointDetail('LinkApiEndpoint');
        baseURL = ''; //baseURL = 'https://api-gateway-stage.linkhealth.com';

    }
    /*public ACETLinkApiOAuthWebservice(){
        super('Linkapi');
    }*/
    
    public void GetRequestBody(String GrantType, String ClientId, String ClientSecret)
    {
        RequestBody = 'grant_type=' + GrantType + '&client_id=' + ClientId + '&client_secret=' + ClientSecret;
    }
    

    public String getAccessToken(){
        
        AccessToken = '';
        endpoint='';
        ClientId='';
        ClientSecret='';
        System.debug('OrgName='+OrgName);
        if (WSConfigurations.containsKey(OrgName + '_LinkApiGrantType'))
        {
            GrantType = WSConfigurations.get(OrgName + '_LinkApiGrantType').Value__c;//client_credentials
        } 
        
        /*if (WSConfigurations.containsKey(OrgName + '_LinkApiEndpoint'))    {
                endpoint = WSConfigurations.get(OrgName + '_LinkApiEndpoint').Value__c; //'https://api-gateway-stage.linkhealth.com/oauth/token';
        }*/
        if (WSConfigurations.containsKey(OrgName + '_LinkApiOAuthClientId'))    {
                ClientId = WSConfigurations.get(OrgName + '_LinkApiOAuthClientId').Value__c; //sae-link-nprod
        }
        if (WSConfigurations.containsKey(OrgName + '_LinkApiOAuthClientSecret'))    {
                ClientSecret = WSConfigurations.get(OrgName + '_LinkApiOAuthClientSecret').Value__c; //50f766e3-c685-4e7d-a7d6-423c76b24cd5
        }
        GetEndpoint();
        System.debug('endpoint='+endpoint);
        GetRequestBody(GrantType, ClientId, ClientSecret);
        
        /*HttpRequest Req = new HttpRequest();
        Req.setMethod('POST');
        Req.setEndpoint(endpoint);
        Req.setBody(RequestBody);
        Req.setHeader('Content-Type', 'application/x-www-form-urlencoded');     
        Http H = new Http();        
        HttpResponse Response = H.send(Req);*/
        HttpResponse Response = Send();
        if (Response.getStatusCode() == 200)
        {
            Map<String, Object> mapOAuthResponse = (Map<String, Object>)JSON.deserializeUntyped(Response.getBody());
            if (mapOAuthResponse.containsKey('access_token'))
            {    
                AccessToken = (String)mapOAuthResponse.get('access_token'); 
            }    
        }
        system.debug(LoggingLevel.INFO, 'AccessToken: ' + AccessToken);        
        system.debug('Res is '+Response);
        return AccessToken;
    }
}