public with sharing class ETSBE_SolarisApiOAuthWebservice extends AcetWebservice {
    public String GrantType;
    public String AccessToken;
    public String ClientId;
    public String ClientSecret;
    public String user;
    public String pass;
    public String RequestBodyStr;
    //public String endpoint ;
    //public String OrgName;
    
    
    public String GetAccessToken(){
    	String AccessToken = '';
    	GetEndpointDetail('GetSolarisTokenEndpoint');
        if(WSConfigurations.containsKey(OrgName + '_SolarisApiGrantType')){
            GrantType = WSConfigurations.get(OrgName + '_SolarisApiGrantType').Value__c;//client_credentials
        }
        if(WSConfigurations.containsKey(OrgName + '_SolarisApiOAuthClientId')){
            ClientId = WSConfigurations.get(OrgName + '_SolarisApiOAuthClientId').Value__c; //sae-link-nprod
        }
        if(WSConfigurations.containsKey(OrgName + '_SolarisApiOAuthClientSecret')){
            ClientSecret = WSConfigurations.get(OrgName + '_SolarisApiOAuthClientSecret').Value__c; //50f766e3-c685-4e7d-a7d6-423c76b24cd5
        }
        if(WSConfigurations.containsKey(OrgName + '_SolarisApiOAuthUsername')){
            user = WSConfigurations.get(OrgName + '_SolarisApiOAuthUsername').Value__c; //acet_api@uhc.com.test
        }
        if(WSConfigurations.containsKey(OrgName + '_SolarisApiOAuthPassword')){
            pass = WSConfigurations.get(OrgName + '_SolarisApiOAuthPassword').Value__c; //Solaris01!
        }
        
        //String RequestBodyStr = 'grant_type=' + GrantType + '&client_id=' + ClientId + '&client_secret=' + ClientSecret+'&username=acet_api@uhc.com.test&password=Solaris01!';
        String RequestBodyStr = 'grant_type=' + GrantType + '&client_id=' + ClientId + '&client_secret=' + ClientSecret+'&username=' + user +'&password=' + pass;
        HttpRequest Req = new HttpRequest();
        Req.setMethod('POST');
        Req.setEndpoint(RelativeURL);
        Req.setBody(RequestBodyStr);
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
        GetEndpointDetail('GetSolarisTokenEndpoint');
        baseURL = ''; //baseURL = 'https://api-gateway-stage.linkhealth.com';

    }
    /*public ACETLinkApiOAuthWebservice(){
        super('Linkapi');
    }*/
    
    
}