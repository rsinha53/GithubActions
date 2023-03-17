global class HSIDPlugin extends Auth.AuthProviderPluginClass {
    
    // Use this URL for the endpoint that the 
    // authentication provider calls back to for configuration.
    public String redirectUrl; 
    private String key;
    private String secret;
    private String pfidpadapterid;
    private String portal;
    // Application redirection to the Concur website for 
    // authentication and authorization.
    private String authUrl;  
    
    // URI to get the new access token from concur using the GET verb.
    private String accessTokenUrl; 
    
    // Api name for the custom metadata type created for this auth provider.
    private String customMetadataTypeApiName; 
    
    // Api URL to access the user in Concur
    private String userAPIUrl; 
    
    // Version of the user api URL to access data from Concur
    private String userAPIVersionUrl;
    
    //Creating map of Webservice Configuration Name and its record
    Map<String, WebserviceConfigurations__c> mapNameToWebservice = new Map<String, WebserviceConfigurations__c>();
    
    public static List<Application_Error_Log__c> appLogList = new List<Application_Error_Log__c>();
    
    global String getCustomMetadataType() {
        
        return 'HSIDCredentials__mdt';
    } 
    
    global PageReference initiate(Map<string,string> 
                                  authProviderConfiguration, String stateToPropagate) 
    { 
        system.debug('--initiate--');                   
        system.debug('stateToPropagate--'+stateToPropagate);
        system.debug('authProviderConfiguration--'+authProviderConfiguration);
        
        system.debug('auth--'+authProviderConfiguration.get('Auth_Url__c'));
        authUrl = authProviderConfiguration.get('Auth_Url__c'); 
        key = authProviderConfiguration.get('Key__c'); 
        redirectUrl = authProviderConfiguration.get('redirect_uri__c');
        pfidpadapterid = authProviderConfiguration.get('pfidpadapterid__c');
        portal = authProviderConfiguration.get('portal__c');
        // Here the developer can build up a request of some sort. 
        // Ultimately, they return a URL where we will redirect the user. 
        //String url = authUrl + '?client_id='+ key +'&scope=openid+profile&response_type=code&pfidpadapterid=HsidNewUIOidcStage&portal=careadvisor&redirect_uri='+ redirectUrl + '&state=' + 'gpXyJ4lYlqUAeYU0PwKBmGGYfPl42E'; 
        String url = authUrl + '?client_id='+ key +'&scope=openid+profile&response_type=code&pfidpadapterid=' + pfidpadapterid + '&portal=' + portal + '&redirect_uri='+ redirectUrl + '&state=' + stateToPropagate;
        //String url = authUrl + '?client_id='+ key +'&scope=openid+profile&response_type=code&pfidpadapterid=HsidNewUIOidcStage&portal=careadvisor&redirect_uri='+ redirectUrl;
        
        
        return new PageReference(url); 
    } 
    
    global Auth.AuthProviderTokenResponse handleCallback(Map<string,string> authProviderConfiguration, Auth.AuthProviderCallbackState state){
        if(state != null){
            system.debug('--handleCallback--');
            system.debug('state--'+state);
            system.debug('authProviderConfiguration handleCallback--'+authProviderConfiguration);
            // Here, the developer will get the callback with actual protocol. 
            // Their responsibility is to return a new object called 
            // AuthProviderTokenResponse. 
            // This will contain an optional accessToken and refreshToken 
            key = authProviderConfiguration.get('Key__c'); 
            secret = authProviderConfiguration.get('Secret__c'); 
            redirectUrl = authProviderConfiguration.get('redirect_uri__c'); 
            accessTokenUrl = authProviderConfiguration.get('Access_Token_Url__c'); 
            
            Map<String,String> queryParams = state.queryParameters; 
            String code = queryParams.get('code'); 
            String sfdcState = queryParams.get('state'); 
            system.debug('--code--'+code);
            system.debug('--sfdcState--'+sfdcState);
           String payLoad;
           payLoad = !Test.isRunningTest() ? ('client_secret='+EncodingUtil.urlEncode(secret,'UTF-8') + '&grant_type='+EncodingUtil.urlEncode('authorization_code','UTF-8') + '&redirect_uri='+EncodingUtil.urlEncode(redirectUrl,'UTF-8') + '&client_id=' + EncodingUtil.urlEncode(key,'UTF-8')  + '&code=' + EncodingUtil.urlEncode(code,'UTF-8')) : 'test url';  
                
                
                
                  
            
            try{
                HttpRequest req = new HttpRequest(); 
                req.setEndpoint(accessTokenUrl);                
                req.setHeader('Content-Type','application/x-www-form-urlencoded');
                req.setBody(payLoad);
                req.setMethod('POST');                
                Http http = new Http(); 
                HTTPResponse res = http.send(req); 
                if(res.getStatusCode() == 200){
                    String responseBody = res.getBody(); 
                    system.debug('--responseBody--'+responseBody);
                    JWTTokenWrapper objJWTTokenWrapper = JWTTokenWrapperParse(responseBody);
                    return new Auth.AuthProviderTokenResponse('Concur', objJWTTokenWrapper.id_token, objJWTTokenWrapper.access_token, sfdcState); 
                }else{
                    Map<String, Object> errorMap = (Map<String, Object>)JSON.deserializeUntyped(res.getBody());
                    Application_Error_Log__c appErrorLog = ACETUtility.CreateApplicationErrorLog('Auth Provider', 'Auth Provider', accessTokenUrl, (String)errorMap.get('message'), res.getStatusCode()); 
                    appLogList.add(appErrorLog);
                    if(appLogList.size() > 0){
                        insert appLogList;
                    }
                }         
            }catch(Exception e){
                System.debug('Exception Occured' +e);                            
            }    
        }
        return null;
    } 
    
    global Auth.UserData getUserInfo(Map<string,string> authProviderConfiguration, Auth.AuthProviderTokenResponse response){   
        if(response != null){
            String cdbQuery = '%CDB%';
            String hsidQuery = '%HSID%';
            RecursiveTriggerHandler.HSIDPlguinFlg = true;
            try{
          
            
                List<WebserviceConfigurations__c> WsObj = [SELECT Id, Name, AuthorizationToken__c, EndpointPath__c, Headers__c, Client_ID__c, GrantType__c, Client_Secret__c,
                                                           JSONBodyWithMergeFields__c, Method__c, Timeout__c, E400__c, E401__c, 
                                                           E500__c, TokenAPI__r.Name, TokenAPI__r.IsCachedToken__c, Handle_Unauthorized__c 
                                                           FROM WebserviceConfigurations__c Where (Name Like : cdbQuery or Name Like : hsidQuery) and active__c = true];
                
                for (WebserviceConfigurations__c wsc : WsObj) {
                    if (!mapNameToWebservice.containsKey(wsc.Name)) {
                        mapNameToWebservice.put(wsc.Name, wsc);
                    }
                }
            
            
            //parse JWT token
            map<String,String> jwtEncoded = new map<String,String>();
            list<String> jwtEncodedList = new list<String>();
            if (response.oauthToken != null) {
                for(string ost:response.oauthToken.replace('.','/').split('/')){
                    jwtEncodedList.add(ost);
                }
                if (jwtEncodedList.size()>1){
                    blob decodedTokenBlob = EncodingUtil.base64Decode(jwtEncodedList[1]);
                    Map<String, Object> m = (Map<String, Object>)JSON.deserializeUntyped(decodedTokenBlob.toString());
                    String userUUid = (String)m.get('sub');
                    List<String> portalList = new List<String>();
                    Map<String,String> provMap = new Map<String,String>(); 
                    portalList.add('CAREADVISOR');
                    String id,fname,lname,flname,uname,locale, policyId, dob, eid, personCont, personAcctId, userId,email,famAccId;                    
                    String token = generateStargateToken(); 
                    HSIDKeychainResponseWrapper respWrapper = keyChainCallout(token, userUUid, portalList);
                    ESSOResponseWrapper essoRespWrap = essoCallOut(token,userUUid, true);
                    if(respWrapper != null && respWrapper.status == Constants.HSIDKeyChainStatus){
                        HSIDKeychainResponseWrapper.Keychains respKeychain =  respWrapper.Keychains;
                        if (respKeychain.careadvisor != null) {
                            HSIDKeychainResponseWrapper.careadvisor respCaread =  respKeychain.careadvisor;
                            List<HSIDKeychainResponseWrapper.EligibilityInfo> respElig = respCaread.eligibilityInfo;
                            HSIDKeychainResponseWrapper.Name respName = respElig[0].Name; 
                            HSIDKeychainResponseWrapper.Identifiers respIden = respElig[0].identifiers;
                            fname = respName.first;
                            lname = respName.last;
                            flname = respName.first + ' ' + respName.last;
                            policyId = respIden.policy;
                            eid = respWrapper.eid;
                            dob = respCaread.dob;    
                            List<Account> memPerAcc = [SELECT Id,(SELECT Id FROM Contacts) FROM Account WHERE EID__c =: eid LIMIT 1];
                            system.debug('memPerAcc--'+memPerAcc);
                            if (memPerAcc.size()>0) {
                                personCont = memPerAcc[0].contacts[0].Id;
                                personAcctId = memPerAcc[0].Id;
                                system.debug('personAcctId--'+personAcctId);
                            }
                            else {
                                HTTPResponse HttpRes1 = CDB_ACETWebservice.getAccessToken(true, mapNameToWebservice); //access token API call
                                if(HttpRes1!= null) {
                                    if(HttpRes1.getStatusCode() == 200){
                                        Map<String, Object> result1 = (Map<String, Object>)JSON.deserializeUntyped(HttpRes1.getBody());
                                        token = (String)result1.get('access_token');
                                        system.debug('--getUserInfo token--'+token);
                                        HTTPResponse HttpRes2=CDB_ACETWebservice.getUserInfo(true ,mapNameToWebservice ,token, eid);
                                        if(HttpRes2 != null){
                                            if(HttpRes2.getStatusCode() == 200){
                                                String apiIdentifier;
                                                Map<String, Object> results = (Map<String, Object>)JSON.deserializeUntyped(HttpRes2.getBody());
                                                apiIdentifier = (String)results.get('apiIdentifier');
                                                ACETSNILinkMemberSearch.SearchResultWrapper srW = new ACETSNILinkMemberSearch.SearchResultWrapper();
                                                try{
                                                    srW = CDB_ACETWebservice.setWrapperData(apiIdentifier,true,mapNameToWebservice,token,'', '');
                                                }catch(Exception ex){
                                                    system.debug('Exception occurred while retrieving data from CDB' + ex.getMessage());
                                                }
                                                if (srW.statusCode == 200) {
                                                    if(!String.isBlank(srW.houseHoldResultWrapper.memberDetails.accountId)){
                                                        list<string> objectids = new list<string>();
                                                        objectids = srW.houseHoldResultWrapper.memberDetails.accountId.split('@');
                                                        Set<Id> newObjectId = new Set<Id>();
                                                        Set<Id> newContactId = new Set<Id>();
                                                        Set<Id> newAccountId = new Set<Id>();
                                                        for (String ab : objectids) {
                                                            if (ab.startsWith('00')) {
                                                                if (ab.startsWith('003')){
                                                                    newContactId.add(ab);
                                                                }
                                                                if (ab.startsWith('001')){
                                                                    newAccountId.add (ab);
                                                                }
                                                                newObjectId.add(ab);
                                                            }
                                                        }
                                                        
                                                        for (string Ids : newObjectId) {
                                                            famAccId = Ids;
                                                            break;
                                                        }
                                                        Date dateOfB = date.valueOf(dob);      
                                                        list<AccountcontactRelation> acrList = [select Id, accountId, contact.account.Id,contactId,contact.account.FirstName,contact.account.LastName,contact.account.PersonBirthdate,policy_ID__c, member_ID__c
                                                                                                from accountcontactrelation where accountId = :famAccId and contact.account.EID__c=:eid];
                                                        system.debug('acrList--'+acrList);
                                                        if (acrList.size()>0) {
                                                            personCont = acrList[0].contactId;
                                                            personAcctId = acrList[0].contact.account.Id;
                                                        }
                                                    }
                                                }else{
                                                    CDB_ACETWebservice.createAppErrorLog('CDB', 'CDB Response Member Search', '', srW.message, srW.statusCode);
                                                }                                            
                                            }                                        
                                        }else{
                                            Map<String, Object> errorMap = (Map<String, Object>)JSON.deserializeUntyped(HttpRes2.getBody());
                                            Application_Error_Log__c appErrorLog = ACETUtility.CreateApplicationErrorLog('CDB Webservice', 'CDB Response Member Search', '', (String)errorMap.get('message'), HttpRes2.getStatusCode()); 
                                            appLogList.add(appErrorLog);
                                            if(appLogList.size() > 0){
                                                insert appLogList;
                                            }
                                        }                                     
                                    }else{
                                        Map<String, Object> errorMap = (Map<String, Object>)JSON.deserializeUntyped(HttpRes1.getBody());
                                        Application_Error_Log__c appErrorLog = ACETUtility.CreateApplicationErrorLog('CDB Webservice', 'CDB Access Token', '', (String)errorMap.get('message'), HttpRes1.getStatusCode()); 
                                        appLogList.add(appErrorLog);
                                        if(appLogList.size() > 0){
                                            insert appLogList;
                                        }
                                    }                                
                                }
                            }
                            if  (personAcctId != null) {
                                SNI_FL_DigitalOnboardingController.callEHUBUpdateAPI(personAcctId);
                                if (essoRespWrap != null) {
                                    ESSOResponseWrapper.Resources respRes = essoRespWrap.Resources;
                                    if (respRes != null) {
                                        List<ESSOResponseWrapper.Resource> resResWr = respRes.Resource;
                                        if (resResWr.size()>0) {
                                            ESSOResponseWrapper.UserPayload respUserPl = resResWr[0].UserPayload;
                                            if (respUserPl != null) {
                                                List<ESSOResponseWrapper.Emails> respEmail = respUserPl.emails;
                                                if (respEmail.size()>0) {
                                                    email = respEmail[0].value;
                                                    system.debug('email--'+email);
                                                    uname = respEmail[0].value;
                                                }
                                            }
                                        }
                                    }
                                }
                                
                                id = personCont;
                                provMap.put('personcontact', personCont);  
                                String userlocale = 'en_US';                               
                                return new Auth.UserData(id, fname, lname, flname, email,null, uname, userlocale, null, null, provMap); 
                            }
                            
                        }                        
                    }
                }
            }
         }catch(QueryException qe){
                // Handle inaccessible fields
                Map<String, Set<String>> inaccessible = qe.getInaccessibleFields();
                Set<String> WebserviceConfigurations = inaccessible.get('WebserviceConfigurations__c');
                System.debug('Exception occurred during Exception' +qe.getStackTraceString());
                System.debug('WebserviceConfigurations' +WebserviceConfigurations);
            }
            catch(Exception ex){
                Application_Error_Log__c appErrorLog = ACETUtility.CreateApplicationExcepLog('HSID', 'HSID Plugin class','' ,'','' ,ex.getMessage(),''); 
                appLogList.add(appErrorLog);
                if(appLogList.size() > 0){
                    insert appLogList;
                }
                throw new Auth.AuthProviderPluginException('My custom error');
              //throw new HSIDPluginException('custom error');
            }   
        }                
        return null;
    }
    
    private String generateStargateToken(){
        
        if(mapNameToWebservice.containsKey(Constants.stargateTokenName)){
            try{
                //Get Stargate Token
                HttpRequest req = new HttpRequest();
                req.setEndpoint(mapNameToWebservice.get(Constants.stargateTokenName).EndpointPath__c);               
                req.setMethod(mapNameToWebservice.get(Constants.stargateTokenName).Method__c);               
                req.setHeader('Content-Type','application/x-www-form-urlencoded');
                String payLoad = 'client_id='+EncodingUtil.urlEncode(mapNameToWebservice.get(Constants.stargateTokenName).Client_ID__c,'UTF-8')
                    + '&grant_type='+EncodingUtil.urlEncode(mapNameToWebservice.get(Constants.stargateTokenName).GrantType__c,'UTF-8')
                    + '&client_secret=' + EncodingUtil.urlEncode(mapNameToWebservice.get(Constants.stargateTokenName).Client_Secret__c,'UTF-8');          
                req.setBody(payLoad);      
                Http http = new Http();
                HTTPResponse res = http.send(req);
                if(res.getStatusCode() == 200){
                    String responseBody = res.getBody();
                    StargateTokenWrapper objStargateToken = StargateTokenWrapperParse(responseBody);
                    return objStargateToken.access_token; 
                }else{
                    Map<String, Object> errorMap = (Map<String, Object>)JSON.deserializeUntyped(res.getBody());
                    Application_Error_Log__c appErrorLog = ACETUtility.CreateApplicationErrorLog('HSID', 'Stargate Token Generation', mapNameToWebservice.get(Constants.stargateTokenName).EndpointPath__c, (String)errorMap.get('message'), res.getStatusCode()); 
                    appLogList.add(appErrorLog);
                    if(appLogList.size() > 0){
                        insert appLogList;
                    }
                }       
            }catch(Exception e){
                System.debug('Exception Occured' +e);                
            }            
        }
        return null;
    }
    
    private ESSOResponseWrapper essoCallOut(String stargateToken, String UUID, Boolean isloginTime){
        if(stargateToken != null && UUID != null){                        
            
            if(mapNameToWebservice.containsKey(Constants.hsidESSO)){
                try{
                    HttpRequest req = new HttpRequest();
                    req.setEndpoint(mapNameToWebservice.get(Constants.hsidESSO).EndpointPath__c+'id='+UUID+'&loginTime='+isloginTime+'&transid='+stargateToken); 
                    req.setMethod(mapNameToWebservice.get(Constants.hsidESSO).Method__c);               
                    req.setHeader('Content-Type','application/json'); 
                    req.setHeader('Authorization', 'Bearer ' + stargateToken); 
                    Http http = new Http();
                    HTTPResponse res = http.send(req);
                    if(res.getStatusCode() == 200){
                        String responseBody = res.getBody();
                        ESSOResponseWrapper responseWrapper = new ESSOResponseWrapper();
                        ESSOResponseWrapper essoResponseWrapper = responseWrapper.parse(responseBody); 
                        return essoResponseWrapper;
                    }else{
                        Map<String, Object> errorMap = (Map<String, Object>)JSON.deserializeUntyped(res.getBody());
                        Application_Error_Log__c appErrorLog = ACETUtility.CreateApplicationErrorLog('ESSO', 'ESSO Callout', mapNameToWebservice.get(Constants.hsidESSO).EndpointPath__c, (String)errorMap.get('message'), res.getStatusCode()); 
                        appLogList.add(appErrorLog);
                        if(appLogList.size() > 0){
                            insert appLogList;
                        } 
                    }                  
                }catch(Exception e){
                    System.debug('Exception Occured' +e);
                }                
            }
            return null;
        } 
        return (new ESSOResponseWrapper());
    }
    
    private HSIDKeychainResponseWrapper keyChainCallout(String stargateToken, String UUID, List<String> portals){
        HSIDKeyChainRequestWrapper hsidKeyChainRequestWrapper = new HSIDKeyChainRequestWrapper();
        if(stargateToken != null && UUID != null && portals.size() > 0){
            
            hsidKeyChainRequestWrapper.userUUID = UUID;
            hsidKeyChainRequestWrapper.portals = portals;
            String hsidDataPayLoad = hsidKeyChainRequestWrapper.parse(hsidKeyChainRequestWrapper);
            
            if(mapNameToWebservice.containsKey(Constants.hsidKeyChain)){
                try{
                    HttpRequest req = new HttpRequest();
                    req.setEndpoint(mapNameToWebservice.get(Constants.hsidKeyChain).EndpointPath__c);               
                    req.setMethod(mapNameToWebservice.get(Constants.hsidKeyChain).Method__c);               
                    req.setHeader('Content-Type','application/json'); 
                    req.setHeader('Authorization', 'Bearer ' + stargateToken);  
                    req.setbody(hsidDataPayLoad); 
                    Http http = new Http();
                    HTTPResponse res = http.send(req);
                    if(res.getStatusCode() == 200){
                        String responseBody = res.getBody();
                        HSIDKeychainResponseWrapper responseWrapper = new HSIDKeychainResponseWrapper();
                        HSIDKeychainResponseWrapper hsidKeyChainResponseWrapper = responseWrapper.parse(responseBody);                       
                        return hsidKeyChainResponseWrapper;
                    }else{
                        Map<String, Object> errorMap = (Map<String, Object>)JSON.deserializeUntyped(res.getBody());
                        Application_Error_Log__c appErrorLog = ACETUtility.CreateApplicationErrorLog('HSID', 'HSID KeyChain Callout', mapNameToWebservice.get(Constants.hsidKeyChain).EndpointPath__c, (String)errorMap.get('message'), res.getStatusCode()); 
                        appLogList.add(appErrorLog);
                        if(appLogList.size() > 0){
                            insert appLogList;
                        } 
                    }                  
                }catch(Exception e){
                    System.debug('Exception Occured' +e);
                }                
            }
            return null;
        } 
        return (new HSIDKeychainResponseWrapper());
    }
    
    
    public class JWTTokenWrapper{
        public string access_token;
        public string id_token;
        public string token_type;
        public string expires_in;               
    }
    
    public static JWTTokenWrapper JWTTokenWrapperParse(string json){
        return (JWTTokenWrapper) System.JSON.deserialize(json, JWTTokenWrapper.class); 
    }
    
    
    public class StargateTokenWrapper{
        public string access_token;
        public string expires_in;
        public string token_type;                  
    }
    
    public static StargateTokenWrapper StargateTokenWrapperParse(string json){
        return (StargateTokenWrapper) System.JSON.deserialize(json, StargateTokenWrapper.class); 
    }
    
    public class HSIDPluginException extends Exception {

    }
    
    
}