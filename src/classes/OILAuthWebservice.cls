//US2034021 : Tech -  Member ID Standalone Search Integration
public class OILAuthWebservice extends ACETWebservice {
    
    public OILAuthWebservice(String systemType) {
        super(systemType);
    }
    
    public override void GetEndpoint()
    {
        //GetEndpointDetail('prd_ISLOAuthTokenEndpoint');
        RelativeURL = '/auth/oauth/v2/token';
        BaseURL='https://api.optum.com:8444';
    }
    
    public void GetRequestBody(String GrantType, String ClientId, String ClientSecret)

    {
        RequestBody = 'grant_type=' + GrantType + '&client_id=' + ClientId + '&client_secret=' + ClientSecret;
    }
    
    public String GetAccessToken()
    {
        String AccessToken = '';
        String GrantType;
        String ClientId;
        String ClientSecret;
        
        if (WSConfigurations.containsKey('ISLOAuthGrantType'))
        {
            GrantType = WSConfigurations.get('ISLOAuthGrantType').Value__c;
        } 
        if (WSConfigurations.containsKey('prd_ISLOAuthClientId'))
        {
            ClientId = WSConfigurations.get('prd_ISLOAuthClientId').Value__c;
        }
        if (WSConfigurations.containsKey('prd_ISLOAuthClientSecret'))
        {
            ClientSecret = WSConfigurations.get('prd_ISLOAuthClientSecret').Value__c;
        }
        
        GetEndpoint();
        GetRequestBody(GrantType, ClientId, ClientSecret);
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
        return AccessToken;
    }

}