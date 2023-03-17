public without sharing class ACET_WebserviceCalloutFramework{
    public String serviceName;
    public Map < String, String > requestParamsMap;
    public Map < String, String > requestBodyParamsMap;
    public String requestBody;
    public Boolean encodeURLParameters;
    private WebserviceConfigurations__c wsConfig;
    private WebserviceConfigurations__c wsAuthTokenConfig;
    private OrgSpecificConfigurations__c orgSpecificConfigs;
	private OrgSpecificConfigurations__c orgSpecificAuthTokenConfigs;
    private Map < String, Object > wsConfigMap;
    private String endPoint;
    private String requestParams;
    public static List < WebseviceLogDetails > webseviceLogDetailsList = new List < WebseviceLogDetails > ();
    public String endpointExtraPath;
	public String certificateName;
	public String faroID;
	public String userID;
    public String userProfileName;
	public String orgName;
	public Map < String, String > mapServiceNameToAuthToken = new Map < String, String > ();
	public Set < String > setAuthTokenName = new Set < String > ();
    public Map < String, Object > mapRecordAuthToken = new Map < String, Object > ();
    public map <String, Set<String>> mapTokenServiceOrglist = new  map <String, Set<String>>();
    public static Map < String, HttpResponse > mapWSOrgHttpResponse = new Map < String, HttpResponse > ();
    public Boolean overrideDefaultCheck = false;
	public Boolean createLogFromWSF = true;
    public ACET_WebserviceCalloutFramework()
    {
        // code for pointing to different endpoints based on profile - start
		userProfileName = [SELECT Name FROM Profile WHERE Id =: UserInfo.getProfileId() LIMIT 1].Name;
		orgName = Organization_Properties__c.getOrgDefaults().OrganizationName__c;
        if(test.isRunningTest()){
            orgName = 'QA';
        }
		orgName = orgName.toLowerCase();
        system.debug('orgname is ****' + orgName);
		// code for pointing to different endpoints based on profile - end
    }
    public ACET_WebserviceCalloutFramework(String serviceName, String body, Map <String, String> requestParamsMap)
    {
       // code for pointing to different endpoints based on profile - start
		userProfileName = [SELECT Name FROM Profile WHERE Id =: UserInfo.getProfileId() LIMIT 1].Name;
		orgName = Organization_Properties__c.getOrgDefaults().OrganizationName__c;
		orgName = orgName.toLowerCase();
		// code for pointing to different endpoints based on profile - end
		this.serviceName = serviceName;
		if(String.isNotBlank(body)){
			this.requestBody = body;
		}
		if(requestParamsMap !=null){
			this.requestParamsMap = requestParamsMap;
			this.encodeURLParameters = true;
		}
    }

    public HttpResponse getResponse() {
        Http http = new Http();
        HttpRequest httpReq = getHttpRequest();
        HttpResponse httpRes;
        // checking whether mock enabled or not and getting mock response
        try {
            System.debug('@@ ACET_WebserviceCalloutFramework: getResponse: orgSpecificConfigs.EnableMock__c: ' + orgSpecificConfigs.EnableMock__c);
            if (orgSpecificConfigs.EnableMock__c && !(Organization_Properties__c.getInstance(UserInfo.getProfileId()).OverrideEnableMock__c || Organization_Properties__c.getInstance(UserInfo.getUserId()).OverrideEnableMock__c)) {
                System.debug('@@ ACET_WebserviceCalloutFramework: getResponse inside if');
                if (String.isNotBlank(orgSpecificConfigs.EnableMockForProfiles__c)) {
                    String userProfileName = [SELECT Name FROM Profile WHERE Id =: UserInfo.getProfileId() LIMIT 1].Name;
                    if (orgSpecificConfigs.EnableMockForProfiles__c.split(',').contains(userProfileName)) {
                        return ACET_WebserviceMockFramework.getMockResponse(serviceName, requestParamsMap, requestBody, wsConfigMap);
                    }
                } else {
                    return ACET_WebserviceMockFramework.getMockResponse(serviceName, requestParamsMap, requestBody, wsConfigMap);
                }
            }
        } catch (Exception e) {
            throw new WebserviceConfigException('Error in mock configuration');
        }
        System.debug('@@ ACET_WebserviceCalloutFramework: getResponse: httpReq: ' + httpReq);
        httpRes = http.send(httpReq);
        System.debug('@@ ACET_WebserviceCalloutFramework: getResponse: httpRes: ' + httpRes);
        System.debug('@@ ACET_WebserviceCalloutFramework: getResponse: response body: ' + httpRes.getBody());
        // if call out is not successful then creating error log record and sending email for email id's configured
        Integer serviceStatusCode = httpRes.getStatusCode();
        if (serviceStatusCode == 401 ) {
            if(wsConfig.TokenAPI__r.IsCachedToken__c && wsConfig.Handle_Unauthorized__c && handleUnAuthorizedCall()){
                httpReq = getHttpRequest();
               httpRes = http.send(httpReq);
            }
         }

        Set<String> statusCodesSet = new Set<String>();
        if(!String.isBlank(wsConfig.RetryStatusCodes__c)){
            system.debug('RetryStatusCodes__c: '+wsConfig.RetryStatusCodes__c+' ServiceName: '+wsConfig.Name);
            List<String> statusCodeList = String.valueOf(wsConfig.RetryStatusCodes__c).split(',');
            for(String s: statusCodeList){
                statusCodesSet.add(s);
            }
       } 
 
         if (!statusCodesSet.isEmpty() && statusCodesSet.contains(String.valueOf(serviceStatusCode))){
 
             if(serviceStatusCode == 401 && wsConfig.TokenAPI__r.IsCachedToken__c && handleUnAuthorizedCall()){
                 system.debug('Retry inside if: '+wsConfig.TokenAPI__r.IsCachedToken__c+' ServiceName: '+wsConfig.Name);
                 httpReq = getHttpRequest();
                    httpRes = http.send(httpReq);
             }else if(serviceStatusCode != 401){
                 httpReq = getHttpRequest();
                 httpRes = http.send(httpReq);
             }
 
         }

        //if (httpRes.getStatusCode() != 200) {
        String wsConfigStatus = wsConfigMap.containsKey('E' + httpRes.getStatusCode()) ? (String) wsConfigMap.get('E' + httpRes.getStatusCode() + '__c') : null;
        //String status = String.isNotBlank(wsConfigStatus) ? wsConfigStatus : httpRes.getStatus();
        String status = String.isNotBlank(wsConfigStatus) ? wsConfigStatus : String.isNotBlank(httpRes.getStatus()) ? httpRes.getStatus() : string.valueOf(httpRes.getStatusCode());
            if(status != null){
        httpRes.setStatus(status);
            }

        System.debug('@@ ACET_WebserviceCalloutFramework: getResponse: orgSpecificConfigs.EnableLogs__c: ' + orgSpecificConfigs.EnableLogs__c);
        Boolean isValidResponse = validateResponse(httpRes,serviceName);
        if (!isValidResponse || (String.isNotBlank(orgSpecificConfigs.EnableLogs__c) && (orgSpecificConfigs.EnableLogs__c.equalsIgnoreCase('All Logs') ||
                (orgSpecificConfigs.EnableLogs__c.equalsIgnoreCase('Only Error Logs') && httpRes.getStatusCode() != 200  && httpRes.getStatusCode() != 201 && httpRes.getStatusCode() != 204)))) { //204 added as part of US3433074
            System.debug('@@ ACET_WebserviceCalloutFramework: getResponse: inside logging if: ');
            WebseviceLogDetails webseviceLogDetails = new WebseviceLogDetails();
            webseviceLogDetails.parentRecordId = wsConfig.Id;
            webseviceLogDetails.serviceName = serviceName;
            webseviceLogDetails.endPoint = endPoint;
            webseviceLogDetails.requestParams = requestParams;
            webseviceLogDetails.requestBody = requestBody;
            webseviceLogDetails.status = status;
            webseviceLogDetails.statusCode = httpRes.getStatusCode();
            webseviceLogDetails.responseBody = httpRes.getBody();
            webseviceLogDetailsList.add(webseviceLogDetails);
            System.debug('@@ ACET_WebserviceCalloutFramework: getResponse: webseviceLogDetailsList: ' + webseviceLogDetailsList);
            System.debug('@@ ACET_WebserviceCalloutFramework: getResponse: webseviceLogDetailsList size: ' + webseviceLogDetailsList.size());
            if (!Test.isRunningTest()&& createLogFromWSF) {
            System.enqueueJob(new CreateWSLogQueue(webseviceLogDetailsList));
            }
            if (orgSpecificConfigs.SendEmailOnError__c && String.isNotBlank(orgSpecificConfigs.ErrorReportingEmailIds__c)) {
                sendEmail(serviceName, orgSpecificConfigs.ErrorReportingEmailIds__c, false);
                }
        }

        //}
        return httpRes;
    }

    // call for continuation
    public HttpRequest getHttpRequest() {
        System.debug('@@ ACET_WebserviceCalloutFramework: getHttpRequest: serviceName: ' + serviceName);
        System.debug('@@ ACET_WebserviceCalloutFramework: getHttpRequest: requestParamsMap: ' + requestParamsMap);
        System.debug('@@ ACET_WebserviceCalloutFramework: getHttpRequest: requestBody: ' + requestBody);
        HttpRequest httpReq = new HttpRequest();
        requestParams = '';
		String authToken='';
        List < WebserviceConfigurations__c > listWSConfig = new List < WebserviceConfigurations__c > ();
		Map < String, Map < String, OrgSpecificConfigurations__c >> mapWebserviceToOrg = new Map < String, Map < String, OrgSpecificConfigurations__c >> ();		
        try {          		
			System.debug('Default OrgName: ' + orgName);																									
            wsConfig = [SELECT Id, Name, AuthorizationToken__c, EndpointPath__c, Headers__c, JSONBodyWithMergeFields__c, Method__c, Timeout__c, E400__c, E401__c, E500__c, E502__c, TokenAPI__r.Name, TokenAPI__r.IsCachedToken__c,
                        Handle_Unauthorized__c, Has_Mutual_Authentication__c, ProfileOrgMappings__c, RetryStatusCodes__c,
                        (SELECT Name, EnableLogs__c, EnableMock__c, EnableMockForProfiles__c, EndpointDomain__c, ErrorReportingEmailIds__c, SendEmailOnError__c FROM OrgSpecificConfigurations__r)
                        FROM WebserviceConfigurations__c WHERE Name =: serviceName LIMIT 1
                    ];
            if (wsConfig != null) listWSConfig.add(wsConfig);

            System.debug('@@ ACET_WebserviceCalloutFramework: getHttpRequest: wsConfig: ' + wsConfig);
			// code for pointing to different endpoints based on profile - Start
			if (Organization_Properties__c.getOrgDefaults().EnableProfileBasedEndpoint__c) {

				orgName = determineOrgNameBasedOnProfile(wsConfig);
			}
			// code for pointing to different endpoints based on profile - End		
			mapWebserviceToOrg = constructServiceToOrgSpecficConfigMapping(listWSConfig);
            if(!mapWebserviceToOrg.isEmpty()){
				orgSpecificConfigs = mapWebserviceToOrg.get(wsConfig.Name.toLowerCase()).get(orgName.toLowerCase());
            }
			System.debug('@@ ACET_WebserviceCalloutFramework: getHttpRequest: orgSpecificConfigs: ' + orgSpecificConfigs);
            // getting authorization token - start
            if(wsConfig.Has_Mutual_Authentication__c){
                 if(string.isNotBlank(certificateName) && !Test.isRunningTest())
                  httpReq.setClientCertificateName(certificateName);
            }else{
                authToken = getAccessToken();
            }
            wsConfigMap = wsConfig.getPopulatedFieldsAsMap();
            httpReq.setMethod(wsConfig.Method__c);
            httpReq.setTimeout((Integer) wsConfig.Timeout__c);

            if(string.isNotBlank(endpointExtraPath)){
                if(string.isNotBlank(wsConfig.EndpointPath__c))
                    endPoint = orgSpecificConfigs.EndpointDomain__c + wsConfig.EndpointPath__c+endpointExtraPath;
                else
                    endPoint = orgSpecificConfigs.EndpointDomain__c + endpointExtraPath;
            }else{
                if(string.isNotBlank(wsConfig.EndpointPath__c))
                    endPoint = orgSpecificConfigs.EndpointDomain__c + wsConfig.EndpointPath__c;
		else
                    endPoint = orgSpecificConfigs.EndpointDomain__c;
            }

            // constucting request parameters
            if (requestParamsMap != null) {
                requestParams = '?';
                for (String paramKey: requestParamsMap.keySet()) {
                    if (encodeURLParameters != null && encodeURLParameters) {
                        System.debug('paramKey@@ ' + requestParamsMap.get(paramKey));
                        if (String.isNotBlank(requestParamsMap.get(paramKey))) { //US3076045 - End 
                            requestParams = requestParams + (requestParams != '?' ? '&' : '') + EncodingUtil.urlEncode(paramKey, 'UTF-8') + '=' + EncodingUtil.urlEncode(requestParamsMap.get(paramKey), 'UTF-8');
                        } else {
                            requestParams = requestParams + (requestParams != '?' ? '&' : '') + paramKey + '=' + requestParamsMap.get(paramKey);
                        }
                    } else {
                        requestParams = requestParams + (requestParams != '?' ? '&' : '') + paramKey + '=' + requestParamsMap.get(paramKey);
                    }
                }
            }
            String endPointWithParams = String.isNotBlank(requestParams) ? endPoint + requestParams : endPoint;
            System.debug('@@ ACET_WebserviceCalloutFramework: getHttpRequest: endPointWithParams: ' + endPointWithParams);
            httpReq.setEndpoint(endPointWithParams);
            if (String.isNotBlank(requestBody)) {
                httpReq.setBody(requestBody);
            } else if (String.isNotBlank(wsConfig.JSONBodyWithMergeFields__c)) {
                // create dynamic JSON body with merge fields
                String requestBody = wsConfig.JSONBodyWithMergeFields__c;
                if (!requestBodyParamsMap.isEmpty()) {
                    for (String rbpm: requestBodyParamsMap.keySet()) {
                        if (requestBody.contains(rbpm)) {
                            requestBody.replaceAll('<::' + rbpm + '::>', requestBodyParamsMap.get(rbpm));
                        }
                    }
                }
            }
            // setting headers for request
            List < Object > wsHeaders = String.isNotBlank(wsConfig.Headers__c) ? (List < Object > ) JSON.deserializeUntyped(wsConfig.Headers__c) : null;
            if (wsHeaders != null) {
                for (Object wsHeader: wsHeaders) {
                    Map < String, Object > wsHeaderMap = (Map < String, Object > ) wsHeader;
                    String key = (String) wsHeaderMap.get('key');
                    String value = (String) wsHeaderMap.get('value');
                    // checking and setting if authorization is required in request header
                    if (key.equalsIgnoreCase('Authorization')) {
                        /* if (String.isNotBlank(wsConfig.TokenAPI__r.IsCachedToken__c)) {
                            authToken = (String) Cache.Org.get('local.WebserviceFramework.' + wsConfig.TokenAPI__r.Name + 'Token');
                        } else if (String.isNotBlank(wsConfig.AuthorizationToken__c)) {
                            authToken = wsConfig.AuthorizationToken__c;
                            if (authToken.contains('SELECT')) {
                                List < sObject > authTokens = Database.query(authToken);
                                if (authTokens.size() > 0) {
                                    authToken = (String) authTokens[0].get(authToken.substringBetween('SELECT', 'FROM').trim());
                                } else {
                                    throw new WebserviceConfigException('Authorization Token Configuration Error');
                                }
                                //authToken = (String) Database.query(authToken)[0].get(authToken.substringBetween('SELECT', 'FROM').trim());
                            }
                        } else if (wsAuthTokenConfig != null) {
                            authToken = wsAuthTokenConfig.AuthorizationToken__c;
                        } else {
                            throw new WebserviceConfigException('Authorization Token Configuration Error');
                        }
                        System.debug('@@ ACET_WebserviceCalloutFramework: getHttpRequest: authToken: ' + authToken);
						value = value.replace('<:AUTH_TOKEN:>', authToken); */
			 if (String.isNotBlank(authToken)) {
			 value = value.replace('<:AUTH_TOKEN:>', authToken);
			 }
                     }
		     if (key.equalsIgnoreCase('FAROID')) {
                         if (String.isNotBlank(faroID)) {
                            value = value.replace('<:FARO_ID:>', faroID);
                         }
                    }
		     if (key.equalsIgnoreCase('userId')) {
                         if (String.isNotBlank(userID)) {
                            value = value.replace('<:user_Id:>', userID);
                        }
                    }
                    httpReq.setHeader(key, value);
                    System.debug('@@ ACET_WebserviceCalloutFramework: getHttpRequest: header: ' + key + ' : ' + value);
                }
            }
            System.debug('@@ ACET_WebserviceCalloutFramework: getHttpRequest: httpReq: ' + httpReq);
        } catch (Exception e) {
            System.debug('@@ ACET_WebserviceCalloutFramework: getHttpRequest: exception caught: e: ' + e);
            System.debug('@@ ACET_WebserviceCalloutFramework: getHttpRequest: exception caught: stack trace: ' + e.getStackTraceString());
            throw new WebserviceConfigException('Error in webservice configuration');
        }
        return httpReq;
	}
	
	public String getAccessToken() {
		String tokenName = String.isNotBlank(wsConfig.TokenAPI__r.Name) ? wsConfig.TokenAPI__r.Name + 'Token' : null;
		System.debug('@@ ACET_WebserviceCalloutFramework: getAccessToken: tokenName: ' + tokenName);
		String authToken = '';
		if (String.isNotBlank(tokenName)) {
			String cachedAuthToken = '';
            string cachedAuthTokenOrg ='';
			if (wsConfig.TokenAPI__r.IsCachedToken__c) {
				String cacheKey = 'local.WebserviceFramework.' + wsConfig.TokenAPI__r.Name + 'Token';
				if (Cache.Org.contains(cacheKey)) {
					cachedAuthToken = (String) Cache.Org.get(cacheKey);
                    cachedAuthTokenOrg = extractAuthTokenBasedOnOrg(orgName, cachedAuthToken);
                    System.debug('cachedAuthTokenOrg: '+cachedAuthTokenOrg);

				}
                String cacheTokenExpiry = 'local.WebserviceFramework.' + wsConfig.TokenAPI__r.Name + 'TokenExpiry'+orgName;	
                Boolean isActiveToken = false;
                
                if (Cache.Org.contains(cacheTokenExpiry)) {
                    System.debug('If Check: cacheTokenExpiry');
                    string cachedAuthTokenExpiry = (String)Cache.Org.get(cacheTokenExpiry);
                    if(String.isNotBlank(cachedAuthTokenExpiry) && cachedAuthTokenExpiry != null){
                        System.debug('If Check: isActiveToken');
                        DateTime dateToCompare = datetime.valueOf(cachedAuthTokenExpiry);
                        isActiveToken = dateToCompare > Datetime.now() ? true : false;
                    }
                }
                if (String.isNotBlank(cachedAuthToken) && String.isNotBlank(cachedAuthTokenOrg) && isActiveToken) {                    
					authToken = cachedAuthToken;
                    System.debug('If Check: found authToken');
				} else {
					System.debug('In else: expire authToken so getting fresh token');
					Set < String > tokenAPINames = new Set < String >();
					tokenAPINames.add(wsConfig.TokenAPI__r.Name);
                    if(mapTokenServiceOrglist.containsKey(wsConfig.TokenAPI__r.name))
                    {
                        mapTokenServiceOrglist.get(wsConfig.TokenAPI__r.name).add(orgName);                        
                    }
                    else
                    {
                        mapTokenServiceOrglist.put(wsConfig.TokenAPI__r.Name, new Set<String>());
                        mapTokenServiceOrglist.get(wsConfig.TokenAPI__r.name).add(orgName);                        
                        
                    }
                    overrideDefaultCheck = true;
                    getAuthToken(tokenAPINames);                    
					if (Cache.Org.contains(cacheKey)) {
						authToken = (String) Cache.Org.get(cacheKey);
					}
				}
			} else {
                try {
                    wsAuthTokenConfig = [SELECT AuthorizationToken__c FROM WebserviceConfigurations__c WHERE Name =: tokenName AND RecordType.Name = 'Authorization Token' LIMIT 1];
                } catch (QueryException qe) {}
				System.debug('@@ ACET_WebserviceCalloutFramework: getAccessToken: wsAuthTokenConfig: ' + wsAuthTokenConfig);
				if (wsAuthTokenConfig != null) {
					authToken = wsAuthTokenConfig.AuthorizationToken__c;
				}
			}
		} else if (String.isNotBlank(wsConfig.AuthorizationToken__c)) {
			String dynamicQuery = wsConfig.AuthorizationToken__c;
			if (dynamicQuery.contains('SELECT')) {
				List < sObject > authTokens = Database.query(dynamicQuery);
				if (authTokens.size() > 0) {
					authToken = (String) Database.query(dynamicQuery)[0].get(dynamicQuery.substringBetween('SELECT', 'FROM').trim());
				}/*  else {
					throw new WebserviceConfigException('Authorization Token Configuration Error');
				} */
			}
		}
		return extractAuthTokenBasedOnOrg(orgName, authToken);					
    }
    //Call this method from Batch schedule class responsible for generating auth tokens 
    public Map<String, HttpResponse> getScheduledAuthToken(Map<String, set<String>> mWSOrgList,Boolean overrideDefaultCheck)
    {	
        this.mapTokenServiceOrglist = mWSOrgList;
        this.overrideDefaultCheck = overrideDefaultCheck;
        System.debug('scheduledGetAuthToken: mapTokenServiceOrglist: '+mapTokenServiceOrglist);       
        System.debug('scheduledGetAuthToken: overrideDefaultCheck: '+overrideDefaultCheck);       
	    getAuthToken(mapTokenServiceOrglist.keySet());              
        
        return mapWSOrgHttpResponse;
    }
    public List < HttpResponse > getAuthToken(Set < String > tokenAPINames) {		
		
        system.debug('OrgName: ' + orgName);        
		System.debug('@@ ACET_WebserviceCalloutFramework: getAuthToken: tokenAPINames: ' + tokenAPINames);
		List < HttpResponse > httpResponses = new List < HttpResponse > ();
		List < WebserviceConfigurations__c > wsAuthTokenRecords = new List < WebserviceConfigurations__c > ();
		List < OrgSpecificConfigurations__c > listOrgSpecificAuthToken = new List < OrgSpecificConfigurations__c > ();
		Map < String, Map < String, OrgSpecificConfigurations__c >> mapWebserviceToOrg = new Map < String, Map < String, OrgSpecificConfigurations__c >> ();		
        String recordTokenKey;
		String recordAccessTokenJSON;
        Id authTokenRecordTypeId = Schema.SObjectType.WebserviceConfigurations__c.getRecordTypeInfosByName().get('Authorization Token').getRecordTypeId();
		List < WebserviceConfigurations__c > wsConfigs = [SELECT Id, AuthorizationToken__c, EndpointPath__c, GrantType__c, Method__c, Timeout__c, E400__c, E401__c, E500__c, E502__c, Name, TokenAPI__r.Name, IsCachedToken__c, ProfileOrgMappings__c,
			(SELECT Name, ClientId__c, ClientSecret__c, EnableLogs__c, EnableMock__c, EnableMockForProfiles__c, EndpointDomain__c, ErrorReportingEmailIds__c, SendEmailOnError__c FROM OrgSpecificConfigurations__r)            
			FROM WebserviceConfigurations__c WHERE Name =: tokenAPINames
		];
		System.debug('@@ ACET_WebserviceCalloutFramework: getAuthToken: wsConfigs: ' + wsConfigs);

		for (WebserviceConfigurations__c ws: wsConfigs) {
			setAuthTokenName.add(ws.Name + 'Token');
		}
		list < WebserviceConfigurations__c > listAuthToken = [
			SELECT NAme, AuthorizationToken__c
			FROM WebserviceConfigurations__c
			WHERE RecordTypeId =: authTokenRecordTypeId AND Name =: setAuthTokenName
		];
		if (listAuthToken.size() > 0 && !listAuthToken.isEmpty()) {
			for (WebserviceConfigurations__c ws: listAuthToken) {
				mapServiceNameToAuthToken.put(ws.Name, ws.AuthorizationToken__c);
			}
		}
		System.debug('listAuthToken: ' + listAuthToken);
		System.debug('setAuthTokenName: ' + setAuthTokenName);
		System.debug('mapServiceNameToAuthToken: ' + mapServiceNameToAuthToken);

		mapWebserviceToOrg = constructServiceToOrgSpecficConfigMapping(wsConfigs);
		if (tokenAPINames.size() != wsConfigs.size()) {
			throw new WebserviceConfigException('Configurations missing for Token API(s) requested');
		}
		for (WebserviceConfigurations__c wsConfig: wsConfigs) {
			Set <String> orgList = new Set < String>();
			Http http = new Http();
			HttpRequest httpReq = new HttpRequest();
			HttpResponse httpRes = new HttpResponse();
            System.debug('overrideDefaultCheck:' +overrideDefaultCheck);
            try
            {
                if(overrideDefaultCheck)
                {	
                    orgList= mapTokenServiceOrglist.get(wsConfig.Name);                     
                }          
                else
                {
                    if (Organization_Properties__c.getOrgDefaults().EnableProfileBasedEndpoint__c) 
                    {
                        listOrgSpecificAuthToken = wsConfig.OrgSpecificConfigurations__r;
                        for (OrgSpecificConfigurations__c org: listOrgSpecificAuthToken) 
                        {
                            orgList.add(org.Name.toLowerCase());
                        }
                    } 
                    else 
                    {
                        orgList.add(orgName);
                    }       
                } 
               System.debug('getAuthToken: orgList ' + orgList);
        	}
            catch (NullPointerException npe)   
            {
                System.debug('@@ ACET_WebserviceCalloutFramework:Nullpointer Exception Occurred ' + npe);
                orgName = determineOrgNameBasedOnProfile(wsConfig);
                orgList.add(orgName);
                System.debug('getAuthToken:NullPointerException: orgList ' + orgList);
            }            
            for (String orgName: orgList)
            {
                orgSpecificAuthTokenConfigs = mapWebserviceToOrg.get(wsConfig.Name.toLowerCase()).get(orgName.toLowerCase());
                system.debug('getAuthToken: orgSpecificAuthTokenConfigs: ' + orgSpecificAuthTokenConfigs);
                Map < String, Object > wsConfigMap = wsConfig.getPopulatedFieldsAsMap();
                httpReq.setHeader('Content-Type', 'application/x-www-form-urlencoded');    //DE378956 - Avish
                httpReq.setMethod(wsConfig.Method__c);
                httpReq.setTimeout((Integer) wsConfig.Timeout__c);
                String endPoint = orgSpecificAuthTokenConfigs.EndpointDomain__c + wsConfig.EndpointPath__c;
                String requestParams = 'grant_type=' + wsConfig.GrantType__c + '&client_id=' + orgSpecificAuthTokenConfigs.ClientId__c + '&client_secret=' + orgSpecificAuthTokenConfigs.ClientSecret__c; //DE378956 - Avish
                String endPointWithParams = endPoint + requestParams;
                System.debug('@@ ACET_WebserviceCalloutFramework: getHttpRequest: endPointWithParams: ' + endPointWithParams);
                httpReq.setEndpoint(endPoint); //DE378956 - Avish
                httpReq.setBody(requestParams); //DE378956 - Avish
                System.debug('@@ ACET_WebserviceCalloutFramework: getAuthToken: httpReq: ' + httpReq);
                try 
                {
                    httpRes = http.send(httpReq);
                } 
                catch (Exception e)
                {
                    System.debug('@@ ACET_WebserviceCalloutFramework: Exception Occurred ' + e);
                }                
                System.debug('@@ ACET_WebserviceCalloutFramework: getAuthToken: httpRes: ' + httpRes);
                System.debug('@@ ACET_WebserviceCalloutFramework: getAuthToken: response body: ' + httpRes.getBody());
                String status = httpRes.getStatus();
                System.debug('@@ ACET_WebserviceCalloutFramework: getAuthToken: response status: ' + status);
                httpResponses.add(httpRes);
                String scheduledJobName = wsConfig.Name +' Access Token Job-'+orgName;
                System.debug('scheduledJobName: '+scheduledJobName);                
                mapWSOrgHttpResponse.put(scheduledJobName, httpRes);
                if (httpRes.getStatusCode() == 200) {
                    Map < String, Object > oAuthResponseMap = (Map < String, Object > ) JSON.deserializeUntyped(httpRes.getBody());
                    String accessToken = oAuthResponseMap.containsKey('access_token') ? (String) oAuthResponseMap.get('access_token') : null;
                    if (wsConfig.isCachedToken__c) {
                        integer expiresIn = (Integer) oAuthResponseMap.get('expires_in');
                        datetime dtimeExp = datetime.now();
                        datetime dtimeExpiry = dtimeExp.addSeconds(expiresIn);
                        string dtimeExpiryStr = string.valueof(dtimeExpiry);
                        String cacheTokenKey = 'local.WebserviceFramework.' + wsConfig.Name + 'Token';
                        String cacheTokenExpiryKey = 'local.WebserviceFramework.' + wsConfig.Name +'TokenExpiry'+orgName;
                        String accessTokenJSON = createJSONAccessTokenMap(orgName, cacheTokenKey, accessToken, 'cache');                        
                        if(expiresIn < 300){
                            System.debug('Inside If-cache store');
                            expiresIn = expiresIn + 300;
                            
                            Cache.Org.put(cacheTokenKey, accessTokenJSON, Cache.org.MAX_TTL_SECS, Cache.Visibility.ALL, true);
                            cache.Org.put(cacheTokenExpiryKey, dtimeExpiryStr, expiresIn, Cache.Visibility.ALL, true);
                        } 
                        else 
                        {
                            System.debug('Inside else cache store');
                            Cache.Org.put(cacheTokenKey, accessTokenJSON, (Integer) oAuthResponseMap.get('expires_in'), Cache.Visibility.ALL, true);
                            cache.org.put(cacheTokenExpiryKey, dtimeExpiryStr, (Integer) oAuthResponseMap.get('expires_in'), Cache.Visibility.ALL, true);
                        }
                    } 
                    else 
                    {
                        recordTokenKey = wsConfig.Name + 'Token';
                        recordAccessTokenJSON = createJSONAccessTokenMap(orgName, recordTokenKey, accessToken, 'record');
                        System.debug('recordAccessTokenJSON: ' + recordAccessTokenJSON);
                    }
                } 
                else 
                {
                    String wsConfigStatus = wsConfigMap.containsKey('E' + httpRes.getStatusCode()) ? (String) wsConfigMap.get('E' + httpRes.getStatusCode() + '__c') : null;
                    System.debug('@@ ACET_WebserviceCalloutFramework: getAuthToken: wsConfigStatus: ' + wsConfigStatus);
                    status = String.isNotBlank(wsConfigStatus) ? wsConfigStatus : httpRes.getStatus();
                    System.debug('@@ ACET_WebserviceCalloutFramework: getAuthToken: status: ' + status);
                    httpRes.setStatus(status);
                }                
                if (String.isNotBlank(orgSpecificAuthTokenConfigs.EnableLogs__c) && (orgSpecificAuthTokenConfigs.EnableLogs__c.equalsIgnoreCase('All Logs') ||
                    (orgSpecificAuthTokenConfigs.EnableLogs__c.equalsIgnoreCase('Only Error Logs') && httpRes.getStatusCode() != 200))) {                
                    WebseviceLogDetails webseviceLogDetails = new WebseviceLogDetails();
                    webseviceLogDetails.parentRecordId = wsConfig.Id;
                    webseviceLogDetails.serviceName = serviceName;
                    webseviceLogDetails.endPoint = endPoint;
                    webseviceLogDetails.requestParams = requestParams;
                    webseviceLogDetails.requestBody = requestBody;
                    webseviceLogDetails.status = status;
                    webseviceLogDetails.statusCode = httpRes.getStatusCode();
                    webseviceLogDetails.responseBody = httpRes.getBody();
                    webseviceLogDetailsList.add(webseviceLogDetails);
                    if (!Test.isRunningTest()) {
                        System.enqueueJob(new CreateWSLogQueue(webseviceLogDetailsList));
                    }
                }
            } //End Orglist Iteration          
			mapRecordAuthToken.clear();
			if (!wsConfig.isCachedToken__c) {
				wsAuthTokenRecords.add(new WebserviceConfigurations__c(Name = recordTokenKey,
					RecordTypeId = authTokenRecordTypeId,
					AuthorizationToken__c = recordAccessTokenJSON));
			}
			if (orgSpecificAuthTokenConfigs.SendEmailOnError__c && String.isNotBlank(orgSpecificAuthTokenConfigs.ErrorReportingEmailIds__c)) {
				sendEmail(wsConfig.Name, orgSpecificAuthTokenConfigs.ErrorReportingEmailIds__c, true);
			}
		} //end of wsConfigs Iteration       
		if (!Test.isRunningTest() && wsAuthTokenRecords.size() > 0) {
			system.debug('DML upsert');
			object wsAuthTokenObj = wsAuthTokenRecords;
			String wsAuthTokenObjStr = JSON.serialize(wsAuthTokenObj);
			//storeAuthToken(wsAuthTokenObjStr);
			Database.upsert(wsAuthTokenRecords, WebserviceConfigurations__c.Fields.Name);
		}
		return httpResponses;
	}
    
    //method to determine Org config record to switch based on Profile.
    public String determineOrgNameBasedOnProfile(WebserviceConfigurations__c wsConfig) {
		System.debug('@@ ACET_WebserviceCalloutFramework: determineOrgNameBasedOnProfile: orgName before mapping: ' + orgName);
		// code for pointing to different endpoints based on profile - Start        
		if (String.isNotBlank(wsConfig.ProfileOrgMappings__c)) {
			Map < String, Object > profileOrgMappings = (Map < String, Object > ) JSON.deserializeUntyped(wsConfig.ProfileOrgMappings__c);
			if (profileOrgMappings.containsKey(userProfileName)) {
				orgName = (String) profileOrgMappings.get(userProfileName);
			}
		}
		//orgName = 'stg';
		System.debug('@@ ACET_WebserviceCalloutFramework: determineOrgNameBasedOnProfile: orgName after mapping: ' + orgName);
		return orgName.toLowerCase();
	}
	
    //Method to extract Authorization Code from JSON String for a particular org
	Public String extractAuthTokenBasedOnOrg(String orgName, String authToken) {
		System.debug('@@ ACET_WebserviceCalloutFramework: extractAuthTokenBasedOnOrg: authToken: ' + authToken + ' OrgName: ' + orgName);
		System.debug('@@ ACET_WebserviceCalloutFramework: extractAuthTokenBasedOnOrg:OrgName: ' + orgName);

		// code for pointing to different endpoints based on profile - Start
		try {
			Map < String, Object > orgTokenMappings = (Map < String, Object > ) JSON.deserializeUntyped(authToken);
			if (orgTokenMappings.containsKey(orgName)) {
				authToken = (String) orgTokenMappings.get(orgName);
			}
		} catch (JSONException je) {
			System.debug('@@ ACET_WebserviceCalloutFramework: extractAuthTokenBasedOnOrg: json exception caught');
		}
		// code for pointing to different endpoints based on profile - End
		return authToken;
	}
    
    //Method to construct a map of Webservice and its related Org specific config list
	public Map < String, Map < String, OrgSpecificConfigurations__c >> constructServiceToOrgSpecficConfigMapping(List < WebserviceConfigurations__c > listWSConfigs) 
    {
		System.debug('constructServiceToOrgSpecficConfigMapping : listWSConfigs: ' + listWSConfigs);
		Map < String, Map < String, OrgSpecificConfigurations__c >> mapServiceToOrg = new Map < String, Map < String, OrgSpecificConfigurations__c >> ();
		List < OrgSpecificConfigurations__c > listOrgSpecificAuthToken = new List < OrgSpecificConfigurations__c > ();

		if (listWSConfigs.size() > 0 && !listWSConfigs.isEmpty())
        {
			for (WebserviceConfigurations__c service: listWSConfigs)
            {
				listOrgSpecificAuthToken = service.OrgSpecificConfigurations__r;
				System.debug('listOrgSpecificAuthToken: ' + listOrgSpecificAuthToken);
				if (listOrgSpecificAuthToken != null && !listOrgSpecificAuthToken.isEmpty()) 
                {
					for (OrgSpecificConfigurations__c org: listOrgSpecificAuthToken)
                    {
						String orgLowerCase = org.Name.toLowerCase();
						if (mapServiceToOrg.containsKey(service.Name.toLowerCase())) {							
							mapServiceToOrg.get(service.Name.toLowerCase()).put(orgLowerCase, org);
						} 
                        else 
                        {							
							mapServiceToOrg.put(service.name.toLowerCase(), new Map < String, OrgSpecificConfigurations__c > ());
							mapServiceToOrg.get(service.Name.toLowerCase()).put(orgLowerCase, org);
						}
					}
				}
			}
		}
		System.debug('constructServiceToOrgSpecficConfigMapping: mapServiceToOrg: ' + mapServiceToOrg);
		return mapServiceToOrg;
	}
	//To create Org Name and Token Mapping in JSON format
	public String createJSONAccessTokenMap(String orgName, String keyName, String accessToken, String storeType)
    {
		String jsonAuthToken;
		Map < String, Object > orgTokenMappings = new Map < String, Object > ();
		System.debug('@@ ACET_WebserviceCalloutFramework: createJsonAccessTokenMap: orgName: ' + orgName);
		System.debug('@@ ACET_WebserviceCalloutFramework: createJsonAccessTokenMap: keyName: ' + keyName);
		System.debug('@@ ACET_WebserviceCalloutFramework: createJsonAccessTokenMap: accessToken: ' + accessToken);
		
		if (storeType.equalsIgnoreCase('cache')) 
        {
			System.debug('Inside Cache: ' + (String) Cache.Org.get(keyName));
			if (Cache.Org.contains(keyName)) {
				System.debug('Inside If-Cache: ');
				String JSONCachedAuthToken = (String) Cache.Org.get(keyName);
				if (String.isNotBlank(JSONCachedAuthToken)) {
					try 
                    {
						orgTokenMappings = (Map < String, Object > ) JSON.deserializeUntyped(JSONCachedAuthToken);
						orgTokenMappings.put(orgName.toLowerCase(), accessToken);
						jsonAuthToken = JSON.Serialize(orgTokenMappings);
					} 
                    catch (Exception je) {
						System.debug('@@ ACET_WebserviceCalloutFramework: createJSONAccessTokenMap: json exception caught');
						orgTokenMappings.put(orgName.toLowerCase(), accessToken);
						jsonAuthToken = JSON.Serialize(orgTokenMappings);
					}
				} 
                else 
                {
					orgTokenMappings.put(orgName.toLowerCase(), accessToken);
					jsonAuthToken = JSON.Serialize(orgTokenMappings);											
				}
			} 
            else
            {
				orgTokenMappings.put(orgName.toLowerCase(), accessToken);
				jsonAuthToken = JSON.Serialize(orgTokenMappings);
			}
			System.debug('@@ ACET_WebserviceCalloutFramework: createJsonAccessTokenMap: CacheToken: jsonAuthToken: ' + jsonAuthToken);	 
		} 
        else if (storeType.equalsIgnoreCase('record')) 
        {
			Id authTokenRecordTypeId = Schema.SObjectType.WebserviceConfigurations__c.getRecordTypeInfosByName().get('Authorization Token').getRecordTypeId();
			String jsonRecordAuthToken = mapServiceNameToAuthToken.get(keyName);
			System.debug('jsonRecordAuthToken: ' + jsonRecordAuthToken);

			if (String.isNotBlank(jsonRecordAuthToken)) 
            {
				try 
                {
					System.debug('inside if');
					orgTokenMappings = (Map < String, Object > ) JSON.deserializeUntyped(jsonRecordAuthToken);
					mapRecordAuthToken.put(orgName, accessToken);
					orgTokenMappings.putAll(mapRecordAuthToken);
					jsonAuthToken = JSON.Serialize(orgTokenMappings);
				} 
                catch (Exception je)
                {
					System.debug('@@ ACET_WebserviceCalloutFramework: createJSONAccessTokenMap:RecordToken: json exception caught');
					mapRecordAuthToken.put(orgName, accessToken);
					orgTokenMappings.putAll(mapRecordAuthToken);
					jsonAuthToken = JSON.Serialize(orgTokenMappings);
				}
			} 
            else
            {
				System.debug('inside else');
				mapRecordAuthToken.put(orgName, accessToken);
				jsonAuthToken = JSON.Serialize(mapRecordAuthToken);
			}
			System.debug('@@ ACET_WebserviceCalloutFramework: createJsonAccessTokenMap: jsonRecordAuthToken: ' + jsonAuthToken);
		}
		System.debug('@@ ACET_WebserviceCalloutFramework: createJsonAccessTokenMap: Final jsonAuthToken: ' + jsonAuthToken);
		return jsonAuthToken;
	}
    public Boolean handleUnAuthorizedCall(){
		Boolean getAccessToken = false;       
		if(wsConfig.TokenAPI__r.IsCachedToken__c ){
			HttpResponse httpRes = getStargateAccessToken(wsConfig.TokenAPI__r.Name);
			Integer statusCode = httpRes.getStatusCode();
			if (statusCode == 200) {
				getAccessToken = true;
			}else{
				getAccessToken = false;
			}
		}
		return getAccessToken;
	}

    public static HttpResponse getStargateAccessToken(string serviceName){
		Boolean getAccessToken = false;
		ACET_WebserviceCalloutFramework wsCallOut = new ACET_WebserviceCalloutFramework();
		Set < String > tokenAPINames = new Set < String > ();
		tokenAPINames.add(serviceName);        
		List < HttpResponse > httpResponses = wsCallOut.getAuthToken(tokenAPINames);
		HttpResponse httpRes = httpResponses[0];
		return httpRes;
	}

    public static void storeStargateToken(String accessToken, Integer expiresIn){

        List<ISL_Webservice_Config__c> islWebServiceLst = new List<ISL_Webservice_Config__c>();
		Map<String, ISL_Webservice_Config__c> WSConfigurations = ISL_Webservice_Config__c.getAll();
        if(string.isNotBlank(accessToken) && accessToken !=null ){
            ISL_Webservice_Config__c islWebService = WSConfigurations.get('SNIAPIAccessToken');
            islWebService.Value__c = accessToken;
            islWebService.TokenExpiry__c = expiresIn;
            datetime dtim = datetime.now();
            datetime dtim1 = dtim.addSeconds(expiresIn);
            islWebService.TokenExpiredBy__c	 = dtim1;
            islWebServiceLst.add(islWebService);
        }

        if(islWebServiceLst.size()>0){
           Database.UpsertResult[] results= Database.upsert(islWebServiceLst);
            if (results != null){
                for (Database.UpsertResult AccessTokenUR: results) {
                    if (!AccessTokenUR.isSuccess()) {
                        for(Database.Error DbError :AccessTokenUR.getErrors()) {
                            system.debug(LoggingLevel.INFO, 'Save Access Token Error. StatusCode: ' + DbError.getStatusCode() + ', Message: ' + DbError.getMessage());
                        }
                    }
                    else {
                        system.debug(LoggingLevel.INFO, 'Access token saved successfully in custom setting');
                    }
              }
           }
         }
    }
    //Start of Changes New Tokens - Abhinav
    //Generate JWT Tokens - Used for Advocacy/Polaris Opportunity Offers and Polaris Member Listing
    public list<String> getjwToken (set<String> tokenAPINames){
		String jwToken;
		List<String> jwtTokens = new list<string>();
		OrgSpecificConfigurations__c orgSpecificAuthTokenConfigs;
		List <OrgSpecificConfigurations__c> listOrgSpecificAuthToken = new List<OrgSpecificConfigurations__c>();
		List < WebserviceConfigurations__c > wsAuthTokenRecords = new List < WebserviceConfigurations__c > ();
		Id authTokenRecordTypeId = Schema.SObjectType.WebserviceConfigurations__c.getRecordTypeInfosByName().get('Authorization Token').getRecordTypeId();
		String jwtRecordTokenKey;
		String accessTokenJSON;
		//String orgDefaultName = Organization_Properties__c.getOrgDefaults().OrganizationName__c;        
		Map<String, Map<String, OrgSpecificConfigurations__c>> mapWebserviceToOrg = new Map<String, Map<String, OrgSpecificConfigurations__c>>();
		mapServiceNameToAuthToken.clear();

		List < WebserviceConfigurations__c > wsConfigs = [SELECT Id, ProfileOrgMappings__c, AuthorizationToken__c, EndpointPath__c, GrantType__c, Method__c, Timeout__c, E400__c, E401__c, E500__c, E502__c, Name, TokenAPI__r.Name, IsCachedToken__c, Is_JWT_Token__c,
			(SELECT Name, ClientId__c, ClientSecret__c, EnableLogs__c, EnableMock__c, EnableMockForProfiles__c, EndpointDomain__c, ErrorReportingEmailIds__c, SendEmailOnError__c FROM OrgSpecificConfigurations__r)
			FROM WebserviceConfigurations__c WHERE Name =: tokenAPINames and Is_JWT_Token__c = true
		];
		for (WebserviceConfigurations__c ws: wsConfigs) {
			setAuthTokenName.add(ws.Name + 'Token');
		}
        list <WebserviceConfigurations__c> listAuthToken = [
			SELECT NAme, AuthorizationToken__c
			FROM WebserviceConfigurations__c
			WHERE RecordTypeId =: authTokenRecordTypeId AND Name =: setAuthTokenName
		];
        if (listAuthToken.size() > 0 && !listAuthToken.isEmpty()) {
			for (WebserviceConfigurations__c ws: listAuthToken) {
				mapServiceNameToAuthToken.put(ws.Name, ws.AuthorizationToken__c);
			}
		}
		System.debug('mapServiceNameToAuthToken: ' + mapServiceNameToAuthToken);
		mapWebserviceToOrg = constructServiceToOrgSpecficConfigMapping(wsConfigs);
		for (WebserviceConfigurations__c wsConfig: wsConfigs) {
			Set < String > orgList = new Set < String > ();
			if (Organization_Properties__c.getOrgDefaults().EnableProfileBasedEndpoint__c) {
				listOrgSpecificAuthToken = wsConfig.OrgSpecificConfigurations__r;
				for (OrgSpecificConfigurations__c org: listOrgSpecificAuthToken) {
					orgList.add(org.Name.toLowerCase());
				}
			} else {
				orgList.add(orgName);
			}
			System.debug('getjwToken: orgList' + orgList);
			for (String orgName: orgList) {
				orgSpecificAuthTokenConfigs = mapWebserviceToOrg.get(wsConfig.Name.toLowerCase()).get(orgName.toLowerCase());
				ADBJWTGenerator jwt = new ADBJWTGenerator('HS256');
				String privateKey = orgSpecificAuthTokenConfigs.ClientSecret__c;
				String iss = orgSpecificAuthTokenConfigs.ClientId__c;
				jwt.privateKey = EncodingUtil.base64Encode(Blob.valueOf(privateKey));
				jwt.iss = iss;
				jwtoken = jwt.issue();
				System.debug('jwtoken : ' +wsConfig.Name+ jwtoken);
				jwtRecordTokenKey = wsConfig.Name + 'Token';
				accessTokenJSON = createJSONAccessTokenMap(orgName, jwtRecordTokenKey, jwtoken, 'record');
				System.debug('accessTokenJSON: ' + accessTokenJSON);
			}
			wsAuthTokenRecords.add(new WebserviceConfigurations__c(Name = jwtRecordTokenKey, RecordTypeId = authTokenRecordTypeId, AuthorizationToken__c = accessTokenJSON));
			jwtTokens.add(jwtoken);
		}
		if (!Test.isRunningTest() && wsAuthTokenRecords.size()>0) {
			system.debug('DML upsert JWT');
			Database.upsert(wsAuthTokenRecords, WebserviceConfigurations__c.Fields.Name);
		}
		return jwtTokens;
	}

    @future
    public static void storeAuthToken(String wsAuthTokenObjStr){
        List < WebserviceConfigurations__c > wsAuthTokenRecords = (List < WebserviceConfigurations__c >)JSON.deserializeUntyped(wsAuthTokenObjStr);
    	Database.upsert(wsAuthTokenRecords, WebserviceConfigurations__c.Fields.Name);
    }

    public void createWSLog(List < WebseviceLogDetails > wsLogDetailsList) {
        System.debug('@@ ACET_WebserviceCalloutFramework: createWSLog: wsLogDetailsList: ' + wsLogDetailsList);
        List < WebserviceLog__c > wsLogs = new List < WebserviceLog__c > ();
        List < Attachment > wsLogAtts = new List < Attachment > ();
        for (WebseviceLogDetails wsLogDetails: wsLogDetailsList) {
            WebserviceLog__c wsLog = new WebserviceLog__c(
                WebserviceConfigurations__c = wsLogDetails.parentRecordId,
                EndPoint__c = wsLogDetails.endPoint,
                RequestParameters__c = String.isNotBlank(wsLogDetails.requestParams) ? wsLogDetails.requestParams : '',
                Status__c = wsLogDetails.status,
                StatusCode__c = wsLogDetails.statusCode);
            wsLogs.add(wsLog);
        }
        Database.insert(wsLogs, true);
        System.debug('@@ ACET_WebserviceCalloutFramework: createWSLog: wsLogs size: ' + wsLogs.size());
        for (Integer i = 0; i < wsLogs.size(); i++) {
            System.debug('@@ ACET_WebserviceCalloutFramework: createWSLog: wsLogDetails.requestBody: ' + wsLogDetailsList[i].requestBody);
            if (String.isNotBlank(wsLogDetailsList[i].requestBody)) {
                System.debug('@@ ACET_WebserviceCalloutFramework: createWSLog: wsLogDetails.requestBody: ' + wsLogDetailsList[i].requestBody);
                wsLogAtts.add(new Attachment(ParentId = wsLogs[i].Id, Name = wsLogDetailsList[i].serviceName + 'Request', Body = Blob.valueof(wsLogDetailsList[i].requestBody)));
            }
            System.debug('@@ ACET_WebserviceCalloutFramework: createWSLog: wsLogDetails.responseBody: before if: ' + wsLogDetailsList[i].responseBody);
            if (String.isNotBlank(wsLogDetailsList[i].responseBody)) {
                System.debug('@@ ACET_WebserviceCalloutFramework: createWSLog: wsLogDetails.responseBody: inside if' + wsLogDetailsList[i].responseBody);
                wsLogAtts.add(new Attachment(ParentId = wsLogs[i].Id, Name = wsLogDetailsList[i].serviceName + 'Response', Body = Blob.valueof(wsLogDetailsList[i].responseBody)));
            }
        }
        if (wsLogAtts.size() > 0) {
            Database.insert(wsLogAtts);
        }
    }

    public class CreateWSLogQueue implements Queueable {
        List < WebseviceLogDetails > webseviceLogDetailsList;
        public CreateWSLogQueue(List < WebseviceLogDetails > eldList) {
            webseviceLogDetailsList = eldList;
        }
        public void execute(QueueableContext context) {
            System.debug('@@ ACET_WebserviceCalloutFramework: CreateWSLogQueue: execute: ');
            ACET_WebserviceCalloutFramework wsCallOutFW = new ACET_WebserviceCalloutFramework();
            wsCallOutFW.createWSLog(webseviceLogDetailsList);
        }
    }

    public static void sendEmail(String serviceName, String toAddresses, Boolean isAccessTokenCall) {
        System.debug('@@ ACET_WebserviceCalloutFramework: sendEmail: ');
        Messaging.SingleEmailMessage singleEmailMsg = new Messaging.SingleEmailMessage();
        singleEmailMsg.setToAddresses(toAddresses.split(','));
        if (isAccessTokenCall) {
            singleEmailMsg.setSubject('ACET Salesforce Access Token' + (System.isBatch() ? ' Batch' : '') + 'Job Failed at ' + Datetime.now().format() + 'CST');
            singleEmailMsg.setPlainTextBody('Token ' + serviceName + ' is Null due to Webservice Failure at ' + Datetime.now().format() + ' CST');
        } else {
            singleEmailMsg.setSubject('Error with ' + serviceName);
            singleEmailMsg.setPlainTextBody('Hi, ' + serviceName + ' is having some issue, could you please look into that. Thanks.');
        }
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] {
            singleEmailMsg
        });
    }

    public static boolean validateResponse(HttpResponse responseObj, String serviceName) {
        Boolean isValidResponse = true;
        try{
            if(responseObj.getStatusCode() == 200 && serviceName =='ORSCreateIssueMicroService'){
                Map<String, Object> resMap =  (Map<String, Object>)JSON.deserializeUntyped(responseObj.getBody());
            }

        }catch(exception e){
            isValidResponse = false;
        }

        return isValidResponse;

    }

    public class WebseviceLogDetails {
        public String parentRecordId;
        public String serviceName;
        public String endPoint;
        public String requestParams;
        public String requestBody;
        public String status;
        public Integer statusCode;
        public String responseBody;
		public String caseId;
    }

    public class WebserviceConfigException extends Exception {}

}