public class ACETStargateProdAuthWebservice extends ACETWebservice
{
    public override void GetEndpoint()
    {
        GetEndpointDetail('StargateOAuthTokenEndpoint');
    }
    
    public void GetRequestBody(String GrantType, String ClientId, String ClientSecret)
    {
        RequestBody = 'grant_type=' + GrantType + '&client_id=' + ClientId + '&client_secret=' + ClientSecret;
    }
   public ACETStargateProdAuthWebservice(String systemType){
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
        if (WSConfigurations.containsKey('prd_StargateOAuthClientId'))
        {
            ClientId = WSConfigurations.get('prd_StargateOAuthClientId').Value__c;
        }
        if (WSConfigurations.containsKey('prd_StargateOAuthClientSecret'))
        {
            ClientSecret = WSConfigurations.get('prd_StargateOAuthClientSecret').Value__c;
        }
        
        GetEndpoint();
        GetRequestBody(GrantType, ClientId, ClientSecret);
        HttpResponse Response = Send();
        system.debug('Response in stargatewebservice'+response+'@@'+Response.getStatusCode());
        if (Response.getStatusCode() == 200)
        {
            Map<String, Object> mapOAuthResponse = (Map<String, Object>)JSON.deserializeUntyped(Response.getBody());
            if (mapOAuthResponse.containsKey('access_token'))
            {    
                AccessToken = (String)mapOAuthResponse.get('access_token');
                if(mapOAuthResponse.containsKey('expires_in')){
                    system.debug('expires_in--------------------'+mapOAuthResponse.containsKey('expires_in'));
                    AccessToken = AccessToken+'_expiry_'+mapOAuthResponse.get('expires_in');
                }
            }    
        }
        system.debug(LoggingLevel.INFO, 'Stargate AccessToken: ' + AccessToken);
        return AccessToken;       
    }
}