public class ACETOAuthWebservice extends ACETWebservice
{
    public override void GetEndpoint()
    {
        GetEndpointDetail('ISLOAuthTokenEndpoint');
        baseURL = 'https://api-stg.optum.com:8443';


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
        if (WSConfigurations.containsKey(OrgName + '_ISLOAuthClientId'))
        {
            ClientId = WSConfigurations.get(OrgName + '_ISLOAuthClientId').Value__c;
        }
        if (WSConfigurations.containsKey(OrgName + '_ISLOAuthClientSecret'))
        {
            ClientSecret = WSConfigurations.get(OrgName + '_ISLOAuthClientSecret').Value__c;
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