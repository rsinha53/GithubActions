public with sharing class MotionDermAuthTokenAccess {
    public MotionDermAuthTokenAccess() {

    }
   
    public String getAccessToken(){
        @TestVisible
        String accessToken;
        try{
         String requestBody = setDermAccessTokenApiClientParams();
              		      
         HttpRequest request = new HttpRequest();
         request.setMethod('POST');        
		 request.setEndpoint(getEndpointUrl());
         request.setBody(requestBody);
         request.setHeader('Content-Type', 'application/x-www-form-urlencoded'); 
         system.debug('Access token API request:'+request);
         Http http = new Http();        
         HttpResponse response = http.send(request);
         if (response.getStatusCode() == 200) {
             Map<String, Object> mapOAuthResponse = (Map<String, Object>)JSON.deserializeUntyped(response.getBody());
             if (mapOAuthResponse.containsKey('access_token')) {    
                 accessToken = (String)mapOAuthResponse.get('access_token'); 
             }    
         }
            system.debug(LoggingLevel.DEBUG,'Response is:: ' + response);
        } catch (Exception ex){           
            System.debug(LoggingLevel.ERROR, 'AccessToken Error:: '+ex.getMessage());
            system.debug(LoggingLevel.ERROR, 'AccessToken:: ' + accessToken);  
        }
         System.debug('Access Token:'+accessToken);
         return accessToken;
    }

    public String setDermAccessTokenApiClientParams(){
        String requestBodyStr;
        try {
            String grantType = (ISL_Webservice_Config__c.getValues('MotionDermOauthGrantType')).Value__c;
            String clientId = (ISL_Webservice_Config__c.getValues('MotionDermOauthClientId')).Value__c;
            String clientSecret = (ISL_Webservice_Config__c.getValues('MotionDermOauthClientSecret')).Value__c;        
            if(String.isNotEmpty(grantType) && String.isNotEmpty(clientId) && String.isNotEmpty(clientSecret)){
                requestBodyStr = 'grant_type=' + grantType + '&client_id=' + clientId + '&client_secret=' + clientSecret;               
            }
        } catch (Exception ex) {            
            System.debug(LoggingLevel.ERROR, 'Error:: '+ex.getMessage());
        }
        
        return requestBodyStr;
    }

    public String getEndpointUrl(){
        String endPointUrl =  (ISL_Webservice_Config__c.getValues('MotionDermAccessTokenApiEndpoint')).Value__c;
        return endPointUrl;
    }
}