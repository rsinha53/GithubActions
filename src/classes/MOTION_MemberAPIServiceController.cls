public class MOTION_MemberAPIServiceController {
    public Static String OrgName;
    
    public static HttpResponse basicSearchMemberService(String intType, String firstName, String lastName, String dob, String reqPageNumber){
        Map<String, String> queryParam = new Map<String, String>();
            
        String email = UserInfo.getUserEmail();
        queryParam.put('customerServiceUserName', email);

        if(!String.isEmpty(lastName)){queryParam.put('lastName', lastName);}
        if(!String.isEmpty(firstName)){queryParam.put('firstName', firstName);}
        if(!String.isEmpty(dob)){queryParam.put('birthDate', dob);}
        if(!String.isEmpty(reqPageNumber)){queryParam.put('offsetPage', reqPageNumber);}
            
        ACET_WebserviceCalloutFramework wsCallout = new ACET_WebserviceCalloutFramework('Motion_DERM_BasicSearchAPI', null, queryParam);
        
        HttpResponse response = wsCallout.getResponse();

        if(response.getStatusCode() != 200){
            System.debug('Basic Search - Returned Status code: ' + String.valueOf(response.getStatusCode()) + 'with Message: ' + response.getStatus());
        }
        System.debug('Response for basic search::'+ response.getBody());
        return response;
    }
    
    public static HttpResponse advanceSearchMemberService(String intType, String firstName, String lastName, String dob, String email, String memberId, String groupName, String status, String transactionId, String reqPageNumber){
        Map<String, String> queryParam = new Map<String, String>();
        
        String emailStr = UserInfo.getUserEmail();
        queryParam.put('customerServiceUserName', emailStr);
        
        if(!String.isEmpty(lastName)){queryParam.put('lastName', lastName);}
        if(!String.isEmpty(firstName)){queryParam.put('firstName', firstName);}
        if(!String.isEmpty(dob)){queryParam.put('birthDate', dob);}
        if(!String.isEmpty(email)){queryParam.put('emailAddress', email);}
        if(!String.isEmpty(memberId)){queryParam.put('registeredMemberId', memberId);}
        if(!String.isEmpty(groupName)){queryParam.put('groupName', groupName);}
        if(!String.isEmpty(status)){queryParam.put('status', status);}
        if(!String.isEmpty(transactionId)){queryParam.put('transactionId', transactionId);}
        if(!String.isEmpty(reqPageNumber)){queryParam.put('offsetPage', reqPageNumber);}
        
        ACET_WebserviceCalloutFramework wsCallout = new ACET_WebserviceCalloutFramework('Motion_DERM_AdvancedSearchAPI', null, queryParam);
        HttpResponse response = wsCallout.getResponse();

        if(response.getStatusCode() != 200){
            System.debug('Advanced Search - Returned Status code: ' + String.valueOf(response.getStatusCode()) + 'with Message: ' + response.getStatus());
        }
        System.debug('Response for Adv search::'+ response.getBody());
        return response;
    }	
    
    //memberDetail Method 
    public static HttpResponse memberDetailService(String dermId, String eligibleId){        
        Map<String, String> queryParam = new Map<String, String>();
        
        String email = UserInfo.getUserEmail();
        queryParam.put('customerServiceUserName', email);
        
        if(!String.isEmpty(dermId)){queryParam.put('registeredMemberID', dermId);}
		if(!String.isEmpty(eligibleId)){queryParam.put('eligibleMemberID', eligibleId);}

        ACET_WebserviceCalloutFramework wsCallout = new ACET_WebserviceCalloutFramework('Motion_DERM_MemberDetailAPI', null, queryParam);
        HttpResponse response = wsCallout.getResponse();

        if(response.getStatusCode() != 200){
            System.debug('Member Detail - Returned Status code: ' + String.valueOf(response.getStatusCode()) + 'with Message: ' + response.getStatus());
        }
        System.debug('************Response for Member Detail::'+ response.getBody());
        return response;
    } 
    
    // Medical Waiver Method  
    public static HttpResponse memberDetailMedicalwaiverService(String dermId,String reqPageNumber){        
        Map<String, String> queryParam = new Map<String, String>();
        
        String email = UserInfo.getUserEmail();
        queryParam.put('customerServiceUserName', email);
        
        if(!String.isEmpty(dermId)){queryParam.put('registeredMemberID', dermId);}
        if(!String.isEmpty(reqPageNumber)){queryParam.put('offsetPage', reqPageNumber);}

        ACET_WebserviceCalloutFramework wsCallout = new ACET_WebserviceCalloutFramework('Motion_DERM_PlanWaiverAPI', null, queryParam);
        HttpResponse response = wsCallout.getResponse();

        if(response.getStatusCode() != 200){
            System.debug('Member Detail - Returned Status code: ' + String.valueOf(response.getStatusCode()) + 'with Message: ' + response.getStatus());
        }
        System.debug('*************Response for Member Detail::'+ response.getBody());
        return response;

    } 
    
    //steamline console api for Device Info
    public static HttpResponse streamLineConsoleForDeviceInfo(String dermId){
        ACET_WebserviceCalloutFramework wsCallout = new ACET_WebserviceCalloutFramework();
        wsCallout.serviceName = 'Motion_CONSOLE_API';
        wsCallout.requestBody = '';
        if(!String.isEmpty(dermId)){ wsCallout.endpointExtraPath = dermId; } 
        
        HttpResponse response = wsCallout.getResponse();

        if(response.getStatusCode() != 200){
            System.debug('Console - Returned Status code: ' + String.valueOf(response.getStatusCode()) + 'with Message: ' + response.getStatus());
        }
        System.debug('************Response for Console::'+ response.getBody());
        return response;
    }   
  /*  public static HttpResponse basicSearchMemberService(String intType, String firstName, String lastName, String dob, String reqPageNumber){
        
        Map<String, ISL_Webservice_Config__c> motionbasicsearchurl = ISL_Webservice_Config__c.getAll();       
        String CUser = getCSRUserName();
        String motion_mbrCommonEndpoint = ''; 
        if (motionbasicsearchurl.containsKey(OrgName + '_BasicSearchEndpoint'))    {
            motion_mbrCommonEndpoint = motionbasicsearchurl.get(OrgName + '_BasicSearchEndpoint').Value__c;
        }              
        String motionBasicMbrSrchEndpoint;
        
        if(!String.isEmpty(CUser)){
            motionBasicMbrSrchEndpoint = motion_mbrCommonEndpoint +  '?customerServiceUserName='+ CUser ;
        }
        if(!String.isEmpty(lastName)){
            lastName = EncodingUtil.urlEncode(lastName,'UTF-8');
            motionBasicMbrSrchEndpoint=(motionBasicMbrSrchEndpoint.indexOf('?')>0)? motionBasicMbrSrchEndpoint+ '&lastName='+lastName :motionBasicMbrSrchEndpoint+ '?lastName='+lastName;
        }
        if(!String.isEmpty(firstName)){
            firstName = EncodingUtil.urlEncode(firstName,'UTF-8');
            motionBasicMbrSrchEndpoint=(motionBasicMbrSrchEndpoint.indexOf('?')>0)? motionBasicMbrSrchEndpoint+ '&firstName='+firstName :motionBasicMbrSrchEndpoint+ '?firstName='+firstName;
        }        
        if(!String.isEmpty(dob)){
            motionBasicMbrSrchEndpoint=(motionBasicMbrSrchEndpoint.indexOf('?')>0)? motionBasicMbrSrchEndpoint+ '&birthDate='+dob :motionBasicMbrSrchEndpoint+ '?birthDate='+dob;
        }
        if(!String.isEmpty(reqPageNumber)){
            motionBasicMbrSrchEndpoint=(motionBasicMbrSrchEndpoint.indexOf('?')>0)? motionBasicMbrSrchEndpoint+ '&offsetPage='+reqPageNumber :motionBasicMbrSrchEndpoint+ '?offsetPage='+reqPageNumber;
        }      
        System.debug('motionBasicMbrSrchEndpoint'+motionBasicMbrSrchEndpoint);
        HttpResponse response = new HttpResponse();
        try{
            HttpRequest request = new HttpRequest();
            request.setMethod('GET');        
            request.setEndpoint(motionBasicMbrSrchEndpoint);
            request.setHeader('Content-Type', 'application/json');
            request.setHeader('Authorization', 'Bearer '+ getAccessToken());
            Http http = new Http();
            response = http.send(request);
        }catch(Exception ex){
            System.debug('ExceptionMessage at --->'+ex.getMessage()+'Exception line at --->'+ex.getLineNumber());     
        }
        return response;
    }
    
    public static HttpResponse advanceSearchMemberService(String intType, String firstName, String lastName, String dob, String email, String memberId, String groupName, String status, String transactionId, String reqPageNumber){
        Map<String, ISL_Webservice_Config__c> motionadvancedsearchurl = ISL_Webservice_Config__c.getAll();       
        String CUser = getCSRUserName();
        String motion_mbrCommonEndpoint = ''; 
        if (motionadvancedsearchurl.containsKey(OrgName + '_AdvancedSearchEndpoint'))    {
            motion_mbrCommonEndpoint = motionadvancedsearchurl.get(OrgName + '_AdvancedSearchEndpoint').Value__c;
        }
        String advMemberSearchEndpoint = '';      
        if(!String.isEmpty(CUser)){
            advMemberSearchEndpoint = motion_mbrCommonEndpoint + '?customerServiceUserName='+CUser ;
        }
        if(!String.isEmpty(lastName)){
            lastName = EncodingUtil.urlEncode(lastName,'UTF-8');
            advMemberSearchEndpoint=(advMemberSearchEndpoint.indexOf('?')>0)? advMemberSearchEndpoint+ '&LastName='+lastName :advMemberSearchEndpoint+ '?LastName='+lastName;
        }
        if(!String.isEmpty(firstName)){
            firstName = EncodingUtil.urlEncode(firstName,'UTF-8');
            advMemberSearchEndpoint=(advMemberSearchEndpoint.indexOf('?')>0)? advMemberSearchEndpoint+ '&FirstName='+firstName :advMemberSearchEndpoint+ '?FirstName='+firstName;
        }		
        if(!String.isEmpty(dob)){
            advMemberSearchEndpoint=(advMemberSearchEndpoint.indexOf('?')>0)? advMemberSearchEndpoint+ '&BirthDate='+dob :advMemberSearchEndpoint+ 'BirthDate='+dob;
        }
        if(!String.isEmpty(email)){
            advMemberSearchEndpoint=(advMemberSearchEndpoint.indexOf('?')>0)? advMemberSearchEndpoint+ '&EmailAddress='+email :advMemberSearchEndpoint+ '?EmailAddress='+email;
        }
        if(!String.isEmpty(memberId)){
            advMemberSearchEndpoint=(advMemberSearchEndpoint.indexOf('?')>0)? advMemberSearchEndpoint+ '&RegisteredMemberID='+memberId :advMemberSearchEndpoint+ '?RegisteredMemberID='+Integer.valueof(memberId);
        }
        if(!String.isEmpty(groupName)){            
            groupName = EncodingUtil.urlEncode(groupName,'UTF-8');
            advMemberSearchEndpoint=(advMemberSearchEndpoint.indexOf('?')>0)? advMemberSearchEndpoint+ '&GroupName='+groupName :advMemberSearchEndpoint+ '?GroupName='+groupName;
        }
        if(!String.isEmpty(status)){
            advMemberSearchEndpoint=(advMemberSearchEndpoint.indexOf('?')>0)? advMemberSearchEndpoint+ '&Status='+status :advMemberSearchEndpoint+ '?Status='+status;
        }
        if(!String.isEmpty(transactionId)){
            advMemberSearchEndpoint=(advMemberSearchEndpoint.indexOf('?')>0)? advMemberSearchEndpoint+ '&TransactionID='+transactionId :advMemberSearchEndpoint+ '?TransactionID='+transactionId;
        }
        if(!String.isEmpty(reqPageNumber)){
            advMemberSearchEndpoint=(advMemberSearchEndpoint.indexOf('?')>0)? advMemberSearchEndpoint+ '&OffsetPage='+reqPageNumber :advMemberSearchEndpoint+ '?OffsetPage='+reqPageNumber;
        }
        HttpResponse response = new HttpResponse();
        try{
            HttpRequest request = new HttpRequest();
            request.setMethod('GET');        
            request.setEndpoint(advMemberSearchEndpoint);
            request.setHeader('Content-Type', 'application/json');
            request.setHeader('Authorization', 'Bearer '+ getAccessToken());
            Http http = new Http();
            response = http.send(request);
        }catch(Exception ex){
            System.debug('ExceptionMessage at --->'+ex.getMessage()+'Exception line at --->'+ex.getLineNumber());   
        }
        return response;
    }	
    
    //memberDetail Method 
    public static HttpResponse memberDetailService(String dermId, String eligibleId){        
        Map<String, ISL_Webservice_Config__c> dermmemberdetails = ISL_Webservice_Config__c.getAll();        
        String CUser = getCSRUserName();
        String motion_mbrCommonEndpoint = '';        
        if (dermmemberdetails.containsKey(OrgName + '_MemberDetailEndPoint'))    {
            motion_mbrCommonEndpoint = dermmemberdetails.get(OrgName + '_MemberDetailEndPoint').Value__c;
        }             
        String memberDetailEndPoint = '';
        System.debug('customerServiceUserName'+CUser);
        if(!String.isEmpty(CUser)){
            memberDetailEndPoint = motion_mbrCommonEndpoint + '?customerServiceUserName='+CUser;
        }
        if(!String.isEmpty(dermId)){
            memberDetailEndPoint=(memberDetailEndPoint.indexOf('?')>0)? memberDetailEndPoint+ '&RegisteredMemberID='+dermId :memberDetailEndPoint+ '?RegisteredMemberID='+dermId;
        }
        if(!String.isEmpty(eligibleId)){
            memberDetailEndPoint=(memberDetailEndPoint.indexOf('?')>0)? memberDetailEndPoint+ '&EligibleMemberID='+eligibleId :memberDetailEndPoint+ '?EligibleMemberID='+eligibleId;
        }
        
        System.debug('memberDetailEndPoint'+memberDetailEndPoint);
        HttpResponse response = new HttpResponse();
        try{
            HttpRequest request = new HttpRequest();
            request.setMethod('GET');        
            request.setEndpoint(memberDetailEndPoint);
            request.setHeader('Content-Type', 'application/json');
            System.debug('GoodMethodToken: '+getAccessToken());
            request.setHeader('Authorization', 'Bearer '+ getAccessToken());
            Http http = new Http();
            response = http.send(request);
        }catch(Exception ex){
            System.debug('ExceptionMessage at --->'+ex.getMessage()+'Exception line at --->'+ex.getLineNumber());    
        }
        return response;
    } 
    // Medical Waiver Method  
    public static HttpResponse memberDetailMedicalwaiverService(String dermId,String reqPageNumber){        
        Motion_MemberSearchUtil.TableDetails objTableDetail;
        Map<String, ISL_Webservice_Config__c> medicalwaiver = ISL_Webservice_Config__c.getAll();        
        String CUser = getCSRUserName();
        String motion_mbrCommonEndpoint = '';        
        if (medicalwaiver.containsKey(OrgName + '_MedicalWaiverEndpoint'))    {
            motion_mbrCommonEndpoint = medicalwaiver.get(OrgName + '_MedicalWaiverEndpoint').Value__c;
        }               
        String medicalWaiverEndPoint = '';
        if(!String.isEmpty(CUser)){
            medicalWaiverEndPoint = motion_mbrCommonEndpoint + '?customerServiceUserName='+CUser;
        }
        if(!String.isEmpty(dermId)){
            medicalWaiverEndPoint=(medicalWaiverEndPoint.indexOf('?')>0)? medicalWaiverEndPoint+ '&RegisteredMemberID='+dermId :medicalWaiverEndPoint+ '?RegisteredMemberID='+dermId;
        }
        if(!String.isEmpty(reqPageNumber)){
            medicalWaiverEndPoint=(medicalWaiverEndPoint.indexOf('?')>0)? medicalWaiverEndPoint+ '&OffsetPage='+reqPageNumber :medicalWaiverEndPoint+ '?OffsetPage='+reqPageNumber;
        }
        //API service call
        System.debug('MedicalWaiver EndPoint'+medicalWaiverEndPoint);
        HttpResponse response = new HttpResponse();
        try{
            HttpRequest request = new HttpRequest();        
            request.setEndpoint(medicalWaiverEndPoint);
            request.setHeader('Content-Type', 'application/json');
            request.setHeader('Authorization', 'Bearer '+ getAccessToken());
            request.setMethod('GET');
            Http httpobj = new Http();         
            response = httpobj.send(request);
            if(response != null){
                System.debug('Mediwaiver Api call response...'+response.getStatusCode());
            }
        }catch(Exception ex){
            System.debug('ExceptionMessage at --->'+ex.getMessage()+'Exception line at --->'+ex.getLineNumber());   
        }             
        system.debug('**************response inside api plan waiver'+ response.getBody()); 
        return response;
        
    } 
    
    //steamline console api for Device Info
    public static HttpResponse streamLineConsoleForDeviceInfo(String dermId){
        //dermId = '330203';
        system.debug('inside console  service method');
        String CUser = getCSRUserName();
        String console_endpoint = '';
        Map<String, ISL_Webservice_Config__c> consoleEndpointURL = ISL_Webservice_Config__c.getAll();
                        
        if (consoleEndpointURL.containsKey(OrgName + '_ConsoleEndpoint'))    {
            console_endpoint = consoleEndpointURL.get(OrgName + '_ConsoleEndpoint').Value__c;
        }
        system.debug('consoleEndPoint'+ console_endpoint);
        if(!String.isEmpty(dermId)){
            console_endpoint=console_endpoint + dermId;
        }       
        System.debug('console_endpoint'+console_endpoint);
        HttpResponse response = new HttpResponse();
        try{            
            HttpRequest request = new HttpRequest();        
            request.setEndpoint(console_endpoint);
            request.setHeader('Content-Type', 'application/json');
            request.setHeader('Authorization', 'Bearer '+ getAccessToken());
            request.setHeader('Token-Type', 'DERM.Motion.Connect');
            request.setMethod('GET');
            Http httpobj = new Http();        
            response = httpobj.send(request);
            if(response != null){
                System.debug('response'+response.getStatusCode());
            }
        }catch(Exception ex){
        	System.debug('ExceptionMessage at --->'+ex.getMessage()+'Exception line at --->'+ex.getLineNumber());    
        }
        
        system.debug('response ='+ response.getBody()); 
        return response;
       
    }   */
  
	//access token for Derm API
/*    public static string getAccessToken(){
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
            
            System.debug('response.getStatusCode() => '+response.getStatusCode());
            
            if (response.getStatusCode() == 200) {
                Map<String, Object> mapOAuthResponse = (Map<String, Object>)JSON.deserializeUntyped(response.getBody());
                if (mapOAuthResponse.containsKey('access_token')) {    
                    accessToken = (String)mapOAuthResponse.get('access_token'); 
                }           
            }
            
        } catch (Exception ex){           
            System.debug(LoggingLevel.ERROR, 'AccessToken Error:: '+ex.getMessage());
            system.debug(LoggingLevel.ERROR, 'AccessToken:: ' + accessToken);            
        }
        System.debug('Access Token returning:'+accessToken);
        return accessToken;
    }
    
    public static String setDermAccessTokenApiClientParams(){
        String requestBodyStr;
        Map<String, ISL_Webservice_Config__c> grantTypeurl = ISL_Webservice_Config__c.getAll();
        Map<String, ACETOrgInstanceURLToOrgNameMap__c> OrgInstance2OrgNameMap = ACETOrgInstanceURLToOrgNameMap__c.getAll();
        OrgName = Test.isRunningTest() ? 'qa' : MotionCommonUtil.GetOrgName(OrgInstance2OrgNameMap);
        
        try {
            String grantType = '';
            if (grantTypeurl.containsKey(OrgName + '_MotionApiGrantType'))    {
                grantType = grantTypeurl.get(OrgName + '_MotionApiGrantType').Value__c;
            }
            String clientId = '';
            if (grantTypeurl.containsKey(OrgName + '_MotionApiOauthClientId'))    {
                clientId = grantTypeurl.get(OrgName + '_MotionApiOauthClientId').Value__c;
            }
            String clientSecret = '';
            if (grantTypeurl.containsKey(OrgName + '_MotionOauthClientSecret'))    {
                clientSecret = grantTypeurl.get(OrgName + '_MotionOauthClientSecret').Value__c;
            }   
            if(String.isNotEmpty(grantType) && String.isNotEmpty(clientId) && String.isNotEmpty(clientSecret)){
                requestBodyStr = 'grant_type=' + grantType + '&client_id=' + clientId + '&client_secret=' + clientSecret;               
            }
            System.debug('requestBody ::::' +requestBodyStr);
        } catch (Exception ex) {            
            System.debug(LoggingLevel.ERROR, 'Error:: '+ex.getMessage());
            System.debug('ExceptionMessage at --->'+ex.getMessage()+'Exception line at --->'+ex.getLineNumber());
        }
        
        return requestBodyStr;
    }

    public static String getEndpointUrl(){
        Map<String, ISL_Webservice_Config__c> tokenurl = ISL_Webservice_Config__c.getAll();
        Map<String, ACETOrgInstanceURLToOrgNameMap__c> OrgInstance2OrgNameMap = ACETOrgInstanceURLToOrgNameMap__c.getAll();
        OrgName = Test.isRunningTest() ? 'qa' : MotionCommonUtil.GetOrgName(OrgInstance2OrgNameMap);
        String endPointUrl ='';
        if (tokenurl.containsKey(OrgName + '_MotionApiEndPoint'))    {
            endPointUrl = tokenurl.get(OrgName + '_MotionApiEndPoint').Value__c;
        }
        return endPointUrl;
    }
    
    public static String getCSRUserName(){
		Map<String, ACETOrgInstanceURLToOrgNameMap__c> OrgInstance2OrgNameMap = ACETOrgInstanceURLToOrgNameMap__c.getAll();
        if(OrgInstance2OrgNameMap!=null){
        	OrgName = MotionCommonUtil.GetOrgName(OrgInstance2OrgNameMap);
        }
        return UserInfo.getUserEmail();
    }

  */
}