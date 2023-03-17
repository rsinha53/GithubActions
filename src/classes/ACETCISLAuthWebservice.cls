public class ACETCISLAuthWebservice extends ACETWebservice
{
    public override void GetEndpoint()
    {
        GetEndpointDetail('ISLOAuthTokenEndpoint');
    }
    
    public void GetRequestBody(String GrantType, String ClientId, String ClientSecret)
    {
        RequestBody = 'grant_type=' + GrantType + '&client_id=' + ClientId + '&client_secret=' + ClientSecret;
    }
   public ACETCISLAuthWebservice(String systemType){
       super(systemType);
   }
    public String GetAccessToken(){
    
        String AccessToken = '';
        String GrantType;
        String ClientId;
        String ClientSecret;
        
        if (WSConfigurations.containsKey('ISLOAuthGrantType'))
        {
            GrantType = WSConfigurations.get('ISLOAuthGrantType').Value__c;
        } 
        if (WSConfigurations.containsKey(OrgName + '_CISLOAuthClientId'))
        {
            ClientId = WSConfigurations.get(OrgName + '_CISLOAuthClientId').Value__c;
        }
        if (WSConfigurations.containsKey(OrgName + '_CISLOAuthClientSecret'))
        {
            ClientSecret = WSConfigurations.get(OrgName + '_CISLOAuthClientSecret').Value__c;
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
        system.debug(LoggingLevel.INFO, 'CISL AccessToken: ' + AccessToken);
        return AccessToken;       
    }
}