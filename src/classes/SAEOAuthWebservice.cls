/*
    Created By: Avish Pagote
    Created Date: 3rd April 2019
    Description: This class is used to generate the access token.
*/
public class SAEOAuthWebservice {

    public String GetAccessToken(String ClientId, String ClientSecret, String endpoint){
        String AccessToken = '';
        String GrantType = 'client_credentials';
        String RequestBodyStr = 'grant_type=' + GrantType + '&client_id=' + ClientId + '&client_secret=' + ClientSecret;
        /*String ClientId = 'sae-link-nprod';
        String ClientSecret = '50f766e3-c685-4e7d-a7d6-423c76b24cd5';
        String endpoint = 'https://api-gateway-stage.linkhealth.com/oauth/token';*/
        
        HttpRequest Req = new HttpRequest();
        Req.setMethod('POST');
        Req.setEndpoint(endpoint);
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

}