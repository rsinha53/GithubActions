/**
* Author: Madhura Priyadarshana
* Description : Utility service to invoke any Stargate web service
* AuraEnabled : False
* Created Date : 21 August 2019
*/

public without sharing class ADBWebService {
    
    public static HttpResponse sendRequest(String body, Map<String, String> headers, String endpoint, String method) {
        
        Http ht = new Http();
        HttpResponse response = new HttpResponse();
        HttpRequest request   = new HttpRequest();
        if(body!= null){
            request.setBody(body);
        }
        request.setMethod(method);
        request.setEndpoint(endpoint);
        request.setTimeout(15000);
        
        //Set the contents of the request header.
        if(headers != null){
            for(String HeaderKey :headers.keySet()) {
                system.debug('Request HeaderKey: ' + HeaderKey + ', Value: ' + Headers.get(HeaderKey));
                request.setHeader(HeaderKey, Headers.get(HeaderKey));
            }
        }
        
        response = ht.send(request);
        return response;
    }
        
    public static String getjwToken (String jwtLabel){
        String jwToken;
        Map<String, ACETOrgInstanceURLToOrgNameMap__c> OrgInstance2OrgNameMap = ACETOrgInstanceURLToOrgNameMap__c.getAll();
        String OrgName = Test.isRunningTest() ? 'dev' : ACETUtility.GetOrgName(OrgInstance2OrgNameMap);
        
        String masterLabel = OrgName+'_'+jwtLabel;
        system.debug('org name'+masterLabel);
        List<ADB_JWT_Config__mdt> jwtConfigs = [SELECT Id, JWT_Key__c, 	JWT_Secret__c  
                                                FROM ADB_JWT_Config__mdt WHERE MasterLabel =: masterLabel];
        if(!jwtConfigs.isEmpty()) {
            ADBJWTGenerator jwt = new ADBJWTGenerator('HS256');
            String privateKey = jwtConfigs[0].JWT_Secret__c;
            String iss = jwtConfigs[0].JWT_Key__c;
            jwt.privateKey = EncodingUtil.base64Encode(Blob.valueOf(privateKey));
            jwt.iss = iss;
            jwtoken = jwt.issue();
            System.debug('jwtoken : ' + jwtoken); 
        }
        return jwToken;
    }

    //	to generate signature using corresponding custom metadata values : By Madhura : US2574136
    public static String generateSignature(String serviceName, String metadataType) {
    	String encryptedSignature;
        String rightNow = String.valueOf(dateTime.now().getTime());
	    rightNow = rightNow.substring(0, (rightNow.length()-3));//DE396556 Madhura 12/22/2020
        Map<String, ACETOrgInstanceURLToOrgNameMap__c> OrgInstance2OrgNameMap = ACETOrgInstanceURLToOrgNameMap__c.getAll();
        String OrgName = ACETUtility.GetOrgName(OrgInstance2OrgNameMap);
        String masterLabel = orgName + '_' + serviceName;                
        
        List<ADB_JWT_Config__mdt> signatureConfigs = [SELECT Id, JWT_Key__c, JWT_Secret__c  
                                                      FROM ADB_JWT_Config__mdt WHERE MasterLabel =: masterLabel];
        string apiKey = signatureConfigs[0].JWT_Key__c;
        string secret = signatureConfigs[0].JWT_Secret__c;
        
        Blob targetBlob = Blob.valueOf(apiKey+secret+rightNow);
        Blob hash = Crypto.generateDigest('SHA-256', targetBlob);
        encryptedSignature = EncodingUtil.convertToHex(hash);
        System.debug('hash : ' + serviceName + ' : ' + encryptedSignature);        
        
        return encryptedSignature;
    }
    
    //	to get the endpoint : By Madhura : US2574136
    public static String getEndpoint(String serviceName) {
        String endPoint = '';
        
        Map<String, ACETOrgInstanceURLToOrgNameMap__c> OrgInstance2OrgNameMap = ACETOrgInstanceURLToOrgNameMap__c.getAll();
        String OrgName = Test.isRunningTest() ? 'dev' : ACETUtility.GetOrgName(OrgInstance2OrgNameMap);
        String label = OrgName + '_' + serviceName;
        ISL_Webservice_Config__c iWeb = [SELECT id, name , value__c 
                                         from ISL_Webservice_Config__c 
                                         where name =: label];
        endpoint = iWeb.value__c;
        
        return endPoint;
    }    
    
    /*	generate and return the access/auth for the given service name
    *	using corresponding custom metadata values
    *	Madhura : US2574136
    */	
    public static String generateTokenbyMetadata(String serviceName, String metadataType) {
        String token;
        Map<String, ACETOrgInstanceURLToOrgNameMap__c> OrgInstance2OrgNameMap = ACETOrgInstanceURLToOrgNameMap__c.getAll();
        String OrgName = ACETUtility.GetOrgName(OrgInstance2OrgNameMap);
        String masterLabel = OrgName + '_' + serviceName;
        system.debug('masterLabel'+masterLabel);
        
        List<Eligibility_Token_Service__mdt> tokenDetails = [SELECT Grant_Type__c, Client_Id__c, Client_Secret__c, Token_Endpoint__c  
                                                                     FROM Eligibility_Token_Service__mdt WHERE MasterLabel =: masterLabel];
        
        if(!tokenDetails.isEmpty()){
            //creating the request for the Eligibility TOken Service
            String GrantType = tokenDetails[0].Grant_Type__c; 
            String ClientId = tokenDetails[0].Client_Id__c;
            String ClientSecret = tokenDetails[0].Client_Secret__c;
            String RequestBody = 'grant_type=' + GrantType + '&client_id=' + ClientId + '&client_secret=' + ClientSecret;
            
            String endpoint = tokenDetails[0].Token_Endpoint__c;
            String method = 'POST';
            
            // make the callout
            HttpResponse response = ADBWebService.sendRequest(RequestBody, null, endpoint, method);
            if(response.getStatusCode() == 200) {
                Map<String, String> responseMap = (Map<String, String>)JSON.deserialize(response.getBody(), Map<String, String>.class);
                if(responseMap != null && responseMap.containsKey('access_token')) {
                    token = responseMap.get('access_token');
                    system.debug('new token ' + serviceName + ' : ' + token);
                }
            }
        }
        
        return token;
    }
    
    public static String getjwtToken(String tokenRecordName) {
        String tokenName = '';
 
        ISL_Webservice_Config__c iWeb = [SELECT id, name , value__c 
                                         from ISL_Webservice_Config__c 
                                         where name =: tokenRecordName];
        tokenName = iWeb.value__c;
        
        return tokenName;
    }
    
}