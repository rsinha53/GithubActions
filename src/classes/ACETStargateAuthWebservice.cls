public class ACETStargateAuthWebservice extends ACETWebservice
{
    public override void GetEndpoint()
    {
        GetEndpointDetail('StargateOAuthTokenEndpoint');
    }
    
    public void GetRequestBody(String GrantType, String ClientId, String ClientSecret)
    {
        RequestBody = 'grant_type=' + GrantType + '&client_id=' + ClientId + '&client_secret=' + ClientSecret;
    }
   public ACETStargateAuthWebservice(String systemType){
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
        if (WSConfigurations.containsKey(OrgName + '_StargateOAuthClientId'))
        {
            ClientId = WSConfigurations.get(OrgName + '_StargateOAuthClientId').Value__c;
        }
        if (WSConfigurations.containsKey(OrgName + '_StargateOAuthClientSecret'))
        {
            ClientSecret = WSConfigurations.get(OrgName + '_StargateOAuthClientSecret').Value__c;
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