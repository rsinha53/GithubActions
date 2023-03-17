/*
    Created By: Ravi Kishore
    Created Date: 6th aug
    Description: This class is used to generate the access token for SNI Api.
*/

public class ACETSNIApiOAuthWebservice extends AcetWebservice {
    
    public String GrantType;
    public String AccessToken;
    public String ClientId ;
    public String ClientSecret ;
    public String RequestBodyStr;
    //public String endpoint ;
    //public String OrgName;
    
    public override void GetEndpoint()
    {
        GetEndpointDetail('SNIApiEndpoint');
       // baseURL = 'https://gateway-stage.optum.com';

    }
    
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
         //US3098067 - Vishnu
        //orgName=Test.isRunningTest() ?'dev':Organization_Properties__c.getInstance(UserInfo.getProfileId()).callProductionEndpoints__c?'qa':orgName;
        if (WSConfigurations.containsKey(OrgName + '_SNIApiGrantType'))
        {
            GrantType = WSConfigurations.get(OrgName + '_SNIApiGrantType').Value__c;//client_credentials
        } 
        if (WSConfigurations.containsKey(OrgName + '_SNIApiOAuthClientId'))    {
                ClientId = WSConfigurations.get(OrgName + '_SNIApiOAuthClientId').Value__c; 
        }
        if (WSConfigurations.containsKey(OrgName + '_SNIApiOAuthClientSecret'))    {
                ClientSecret = WSConfigurations.get(OrgName + '_SNIApiOAuthClientSecret').Value__c; 
        }
        GetEndpoint();
        GetRequestBody(GrantType, ClientId, ClientSecret);
        baseURL = '';
        HttpResponse Response = Send();
        
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
        system.debug(LoggingLevel.INFO, 'AccessToken: ' + AccessToken);        
        system.debug('Res is '+Response);
        return AccessToken;
    }
}