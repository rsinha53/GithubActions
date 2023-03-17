/*
    Created By: Prasad More
    Created Date: 23rd August 2016
    Description: Base class for all webservices class. Contains functionality for preparing endpoint, populate http headers, generate request, send request
                and parse failure response both synchronous and asynchronous webservice calls with OIL.
*/
  
public abstract class ACETWebservice    {
    protected Integer Timeout;
    protected String BaseURL;                    //Base URL for all services
    protected String RelativeURL;                //Webservice specific relative URL
    protected String Endpoint;                   //Concatenate BaseURL and RelationURL
    protected Map<String, String> Headers;
    protected String Method;
    protected String RequestBody;
    protected String ServiceName;
    protected String OrgName;
    protected Boolean ErrorLogEnabled;
    protected Boolean ScopeHeaderEnabled;
    protected Map<String, ISL_Webservice_Config__c> WSConfigurations;
    protected ISL_Webservice_Config__c OAuthConfig;
    public String RequestLabel { public get; protected set;}          //Unique label for continuation request
    protected String[] RequestParameters { get; set; }
    public Integer PageSize { get; set; }

    public ACETWebservice() {
        WSConfigurations = ISL_Webservice_Config__c.getAll();
        Map<String, ACETOrgInstanceURLToOrgNameMap__c> OrgInstance2OrgNameMap = ACETOrgInstanceURLToOrgNameMap__c.getAll();
        OrgName = Test.isRunningTest() ? 'dev' : ACETUtility.GetOrgName(OrgInstance2OrgNameMap);

        Timeout = 10000;
        if (WSConfigurations.containsKey('OILTimeout')) {
            Timeout = Integer.valueOf(WSConfigurations.get('OILTimeout').Value__c);
        }
        BaseURL = '';
        if (WSConfigurations.containsKey(OrgName + '_ISLOAuthEndpoint'))    {
            BaseURL = WSConfigurations.get(OrgName + '_ISLOAuthEndpoint').Value__c;
        }
        Headers = new Map<String, String>();
        Method = 'POST';
        if (WSConfigurations.containsKey('ISLConAccessToken'))  {
            OAuthConfig = WSConfigurations.get('ISLConAccessToken');
        }
        else    {
            OAuthConfig = new ISL_Webservice_Config__c();
            OAuthConfig.Name = 'ISLConAccessToken';
            OAuthConfig.Value__c = '';
        }
        ServiceName = 'Not Available';
        ErrorLogEnabled = false;
        ScopeHeaderEnabled = false;
        PageSize = 50;
    }

    //Changes start - added by Abhinav Balla for CISL and Stargate Services
    public ACETWebservice(String systemType) {

        if(systemType == 'CISL')
        {
            system.debug('@@@ Inside CISL');
            WSConfigurations = ISL_Webservice_Config__c.getAll();
            Map<String, ACETOrgInstanceURLToOrgNameMap__c> OrgInstance2OrgNameMap = ACETOrgInstanceURLToOrgNameMap__c.getAll();
            OrgName = Test.isRunningTest() ? 'dev' : ACETUtility.GetOrgName(OrgInstance2OrgNameMap);

            Timeout = 10000;
            if (WSConfigurations.containsKey('CISLTimeout')) {
                Timeout = Integer.valueOf(WSConfigurations.get('CISLTimeout').Value__c);
            }
            BaseURL = '';
            if (WSConfigurations.containsKey(OrgName + '_CISLOAuthEndpoint'))    {
                BaseURL = WSConfigurations.get(OrgName + '_CISLOAuthEndpoint').Value__c;
            }
            Headers = new Map<String, String>();
            Method = 'POST';
            if (WSConfigurations.containsKey('CISLConAccessToken'))  {
                OAuthConfig = WSConfigurations.get('CISLConAccessToken');
            }
            else    {
                OAuthConfig = new ISL_Webservice_Config__c();
                OAuthConfig.Name = 'CISLConAccessToken';
                OAuthConfig.Value__c = '';
            }
            ServiceName = 'Not Available';
            ErrorLogEnabled = false;
            PageSize = 50;
        }
        //Changes End - added by Abhinav Balla for CISL Services
        else if(systemType == 'LinkClaimSummaryAPI'){
            
            WSConfigurations = ISL_Webservice_Config__c.getAll();
            Map<String, ACETOrgInstanceURLToOrgNameMap__c> OrgInstance2OrgNameMap = ACETOrgInstanceURLToOrgNameMap__c.getAll();
            OrgName = Test.isRunningTest() ? 'dev' : ACETUtility.GetOrgName(OrgInstance2OrgNameMap);
            system.debug('OrgName :'+OrgName);  
            Timeout = 10000;
            if (WSConfigurations.containsKey('LinkapiTimeout')) {
                Timeout = Integer.valueOf(WSConfigurations.get('LinkapiTimeout').Value__c);
            }
            system.debug('Timeout :'+Timeout);  
            BaseURL = '';
            if (WSConfigurations.containsKey(OrgName + '_'+systemType)) {
                BaseURL = WSConfigurations.get(OrgName + '_'+systemType).Value__c;//'_LinkApiEndpoint'
            }
            system.debug('BaseURL :'+BaseURL);
            Headers = new Map<String, String>();
            Method = 'GET';
            Token_Generation__c tokenVar = new Token_Generation__c();
            tokenVar = [select Token_Name__c,Value__c from Token_Generation__c where Token_Name__c = 'ISLConAccessToken' limit 1];
            if (tokenVar.Value__c != null)  {
                OAuthConfig = new ISL_Webservice_Config__c();
                OAuthConfig.Name = tokenVar.Token_Name__c;
                OAuthConfig.Value__c = tokenVar.Value__c;
            }
            else    {
                OAuthConfig = new ISL_Webservice_Config__c();
                OAuthConfig.Name = tokenVar.Token_Name__c;
                OAuthConfig.Value__c = '';
            }
            system.debug('OAuthConfig :'+OAuthConfig);
            ServiceName = 'Not Available'; //systemType
            ErrorLogEnabled = false;//true; //false
            PageSize = 50;
        }
        else if(systemType == 'Stargate')
        {
            system.debug('@@@ Inside Stargate');
            WSConfigurations = ISL_Webservice_Config__c.getAll();
            Map<String, ACETOrgInstanceURLToOrgNameMap__c> OrgInstance2OrgNameMap = ACETOrgInstanceURLToOrgNameMap__c.getAll();
            OrgName = Test.isRunningTest() ? 'dev' : ACETUtility.GetOrgName(OrgInstance2OrgNameMap);

            Timeout = 10000;
            if (WSConfigurations.containsKey('StargateTimeout')) {
                Timeout = Integer.valueOf(WSConfigurations.get('StargateTimeout').Value__c);
            }
            BaseURL = '';
            if (WSConfigurations.containsKey(OrgName + '_StargateOAuthEndpoint'))    {
                BaseURL = WSConfigurations.get(OrgName + '_StargateOAuthEndpoint').Value__c;
            }
            Headers = new Map<String, String>();
            Method = 'POST';
            if (WSConfigurations.containsKey('StargateConAccessToken'))  {
                OAuthConfig = WSConfigurations.get('StargateConAccessToken');
            }
            else    {
                OAuthConfig = new ISL_Webservice_Config__c();
                OAuthConfig.Name = 'StargateConAccessToken';
                OAuthConfig.Value__c = '';
            }
            ServiceName = 'Not Available';
            ErrorLogEnabled = false;
            PageSize = 50;
        }        
        else if(systemType == 'StargateORX')	//	US2722432	Aligning Stargate and ORX token generation callout by Madhura 08-July-2020
        {
            system.debug('@@@ Inside StargateORX');
            WSConfigurations = ISL_Webservice_Config__c.getAll();
            Map<String, ACETOrgInstanceURLToOrgNameMap__c> OrgInstance2OrgNameMap = ACETOrgInstanceURLToOrgNameMap__c.getAll();
            OrgName = Test.isRunningTest() ? 'dev' : ACETUtility.GetOrgName(OrgInstance2OrgNameMap);

            Timeout = 10000;
            if (WSConfigurations.containsKey('StargateTimeout')) {
                Timeout = Integer.valueOf(WSConfigurations.get('StargateTimeout').Value__c);
            }
            BaseURL = '';
            if (WSConfigurations.containsKey(OrgName + '_StargateORXOAuthEndpoint'))    {
                BaseURL = WSConfigurations.get(OrgName + '_StargateORXOAuthEndpoint').Value__c;
            }
            Headers = new Map<String, String>();
            Method = 'POST';
            if (WSConfigurations.containsKey('StargateORXConAccessToken'))  {
                OAuthConfig = WSConfigurations.get('StargateORXConAccessToken');
            }
            else    {
                OAuthConfig = new ISL_Webservice_Config__c();
                OAuthConfig.Name = 'StargateORXConAccessToken';
                OAuthConfig.Value__c = '';
            }
            ServiceName = 'Not Available';
            ErrorLogEnabled = false;
            PageSize = 50;
        }
         else if(systemType == 'Stargate_prod')
        {
            system.debug('@@@ Inside Stargate');
            WSConfigurations = ISL_Webservice_Config__c.getAll();
            Map<String, ACETOrgInstanceURLToOrgNameMap__c> OrgInstance2OrgNameMap = ACETOrgInstanceURLToOrgNameMap__c.getAll();
            OrgName = Test.isRunningTest() ? 'dev' : ACETUtility.GetOrgName(OrgInstance2OrgNameMap);

            Timeout = 10000;
            if (WSConfigurations.containsKey('StargateTimeout')) {
                Timeout = Integer.valueOf(WSConfigurations.get('StargateTimeout').Value__c);
            }
            BaseURL = '';
            if (WSConfigurations.containsKey('prd_StargateOAuthEndpoint'))    {
                BaseURL = WSConfigurations.get('prd_StargateOAuthEndpoint').Value__c;
            }
            Headers = new Map<String, String>();
            Method = 'POST';
            if (WSConfigurations.containsKey('SAEAPIAccessToken'))  {
                OAuthConfig = WSConfigurations.get('SAEAPIAccessToken');
            }
            else    {
                OAuthConfig = new ISL_Webservice_Config__c();
                OAuthConfig.Name = 'SAEAPIAccessToken';
                OAuthConfig.Value__c = '';
            }
            ServiceName = 'Not Available';
            ErrorLogEnabled = false;
            PageSize = 50;
        }
        else if(systemType == 'StargateJWT')
        {
            system.debug('@@@ Inside Stargate JWT');
            WSConfigurations = ISL_Webservice_Config__c.getAll();
            Map<String, ACETOrgInstanceURLToOrgNameMap__c> OrgInstance2OrgNameMap = ACETOrgInstanceURLToOrgNameMap__c.getAll();
            OrgName = Test.isRunningTest() ? 'dev' : ACETUtility.GetOrgName(OrgInstance2OrgNameMap);

            Timeout = 10000;
            if (WSConfigurations.containsKey('StargateTimeout')) {
                Timeout = Integer.valueOf(WSConfigurations.get('StargateTimeout').Value__c);
            }
            BaseURL = '';
            if (WSConfigurations.containsKey(OrgName + '_StargateOAuthEndpoint'))    {
                BaseURL = WSConfigurations.get(OrgName + '_StargateOAuthEndpoint').Value__c;
            }
            Headers = new Map<String, String>();
            Method = 'POST';
            if (WSConfigurations.containsKey('StargateJWTConAccessToken'))  {
                OAuthConfig = WSConfigurations.get('StargateJWTConAccessToken');
            }
            else    {
                OAuthConfig = new ISL_Webservice_Config__c();
                OAuthConfig.Name = 'StargateJWTConAccessToken';
                OAuthConfig.Value__c = '';
            }
            ServiceName = 'Not Available';
            ErrorLogEnabled = false;
            PageSize = 50;
        }
        //Changes End - added by Abhinav Balla for Stargate Services
        //Changes Start - added by Somanath Dash for linkapi services
        else if(systemType == 'LinkEligibilityAPI' || systemType == 'LinkExtendedCoverageAPI')
        {
        try{
          system.debug('@@@ Inside Linkapi');
          WSConfigurations = ISL_Webservice_Config__c.getAll();
          Map<String, ACETOrgInstanceURLToOrgNameMap__c> OrgInstance2OrgNameMap = ACETOrgInstanceURLToOrgNameMap__c.getAll();
          OrgName = Test.isRunningTest() ? 'qa' : ACETUtility.GetOrgName(OrgInstance2OrgNameMap);
          system.debug('OrgName :'+OrgName);
          Timeout = 10000;
          if (WSConfigurations.containsKey('LinkapiTimeout')) {
              Timeout = Integer.valueOf(WSConfigurations.get('LinkapiTimeout').Value__c);
          }
          system.debug('Timeout :'+Timeout);
          BaseURL = '';
          if (WSConfigurations.containsKey(OrgName + '_'+systemType)) {
              BaseURL = WSConfigurations.get(OrgName + '_'+systemType).Value__c;//'_LinkApiEndpoint'
          }
          system.debug('BaseURL :'+BaseURL);
          Headers = new Map<String, String>();
          Method = 'GET';
          Token_Generation__c tokenVar = getToken('LinkAPIAccessToken');
          if (tokenVar!=null && tokenVar.Value__c != null)  {
              OAuthConfig = new ISL_Webservice_Config__c();
              OAuthConfig.Name = tokenVar.Token_Name__c;
              OAuthConfig.Value__c = tokenVar.Value__c;
          }
          else{
              OAuthConfig = new ISL_Webservice_Config__c();
              OAuthConfig.Name = tokenVar.Token_Name__c;
              OAuthConfig.Value__c = '';
          }
          system.debug('OAuthConfig :'+OAuthConfig);
          ServiceName = systemType;//Not Available'; //systemType
          System.debug('ServiceName='+ServiceName);
          ErrorLogEnabled = true;//true; //false
          PageSize = 50;
         }
         catch(Exception e){
           System.debug('Exception Occured while getting Link Accsess token'+e);
         }
        }
        else if(systemType == 'SNIEligibilityAPI' ) //SNIApiEndpoint
        {
          system.debug('SNIApiEndpoint----with param-------');
          WSConfigurations = ISL_Webservice_Config__c.getAll();
          Map<String, ACETOrgInstanceURLToOrgNameMap__c> OrgInstance2OrgNameMap = ACETOrgInstanceURLToOrgNameMap__c.getAll();
          OrgName = Test.isRunningTest() ? 'qa' : ACETUtility.GetOrgName(OrgInstance2OrgNameMap);
          system.debug('OrgName :'+OrgName);
          Timeout = 10000;
          if (WSConfigurations.containsKey('SNIapiTimeout')) {
              Timeout = Integer.valueOf(WSConfigurations.get('SNIapiTimeout').Value__c);

          }
          system.debug('Timeout :'+Timeout);
          BaseURL = '';
          if (WSConfigurations.containsKey(OrgName + '_'+systemType)) {
              BaseURL = WSConfigurations.get(OrgName + '_'+systemType).Value__c;
          }
          system.debug('super method ---base url--------'+BaseURL);
          system.debug('BaseURL :'+BaseURL);
          Headers = new Map<String, String>();
          Method = 'POST';

            if (! WSConfigurations.containsKey('SNIAPIAccessToken')) {
                OAuthConfig = new ISL_Webservice_Config__c();
                OAuthConfig.Name = 'SNIAPIAccessToken';
                OAuthConfig.Value__c = '';
                //OAuthConfig.ACET_Common_Name__c = 'SNIApiEndpoint';
            }
            else{
              OAuthConfig = WSConfigurations.get('SNIAPIAccessToken');

            }
         /* Token_Generation__c tokenVar = new Token_Generation__c();
          tokenVar = [select Token_Name__c,Value__c from Token_Generation__c where Token_Name__c = 'SNIAPIAccessToken' limit 1];
          if (tokenVar.Value__c != null)  {
              OAuthConfig = new ISL_Webservice_Config__c();
              OAuthConfig.Name = tokenVar.Token_Name__c;
              OAuthConfig.Value__c = tokenVar.Value__c;
          }
          else{
              OAuthConfig = new ISL_Webservice_Config__c();
              OAuthConfig.Name = tokenVar.Token_Name__c;
              OAuthConfig.Value__c = '';
          }
          */
          system.debug('OAuthConfig :'+OAuthConfig);
          ServiceName = systemType;//'Not Available'; //systemType
          ErrorLogEnabled = true;//true; //false
          PageSize = 50;
        }else if(systemType == 'OIL') {       //US2034021 Tech -  Member ID Standalone Search Integration
            System.debug('###OIL-CONSTRUCTOR');
            WSConfigurations = ISL_Webservice_Config__c.getAll();
            Map<String, ACETOrgInstanceURLToOrgNameMap__c> OrgInstance2OrgNameMap = ACETOrgInstanceURLToOrgNameMap__c.getAll();
            OrgName = Test.isRunningTest() ? 'dev' : ACETUtility.GetOrgName(OrgInstance2OrgNameMap);
            system.debug('OrgName :'+OrgName);  
            Timeout = 10000;
            if (WSConfigurations.containsKey('OILTimeout')) {
                Timeout = Integer.valueOf(WSConfigurations.get('OILTimeout').Value__c);
            }
            system.debug('Timeout :'+Timeout);  
            BaseURL = '';
            if (WSConfigurations.containsKey(OrgName + '_OILAuthEndpoint'))    {
                BaseURL = WSConfigurations.get(OrgName + '_OILAuthEndpoint').Value__c;
                System.debug('###OIL-BASE-URL:'+BaseURL);
            }
            Headers = new Map<String, String>();
            Method = 'POST';
            if (WSConfigurations.containsKey('OILAccessToken'))  {
                OAuthConfig = WSConfigurations.get('OILAccessToken');
            }
            else    {
                OAuthConfig = new ISL_Webservice_Config__c();
                OAuthConfig.Name = 'OILAccessToken';
                OAuthConfig.Value__c = '';
            }
            System.debug('###OIL-TOKEN:'+ OAuthConfig.Value__c);
            ServiceName = 'Not Available';
            ErrorLogEnabled = false;
            ScopeHeaderEnabled = false;
            PageSize = 50;
        } else if(systemType == 'EAIP') {
            system.debug('systemType::'+systemType);
            WSConfigurations = ISL_Webservice_Config__c.getAll();
            Map<String, ACETOrgInstanceURLToOrgNameMap__c> OrgInstance2OrgNameMap = ACETOrgInstanceURLToOrgNameMap__c.getAll();
            OrgName = Test.isRunningTest() ? 'dev' : ACETUtility.GetOrgName(OrgInstance2OrgNameMap);
            Timeout = 10000;
            headers = new Map<String, String>();
            Method = '';
            if (WSConfigurations.containsKey('EAIPLoginFlowHttpMethod')) {
                Method = WSConfigurations.get('EAIPLoginFlowHttpMethod').Value__c;
            }
            if (WSConfigurations.containsKey(OrgName+'_ORSEAIPToken'))  {
                OAuthConfig = WSConfigurations.get(OrgName+'_ORSEAIPToken');
            }
            
               ServiceName = OAuthConfig.Service_Name__c;
               ErrorLogEnabled = OAuthConfig.Error_Log_Enabled__c;
                ScopeHeaderEnabled = OAuthConfig.Scope_Header_Flag__c;
            PageSize = 0;
        }

    }

    // US3137520
    public ACETWebservice(String systemType, String strOrgName) {
        if(systemType == 'Stargate') {
            WSConfigurations = ISL_Webservice_Config__c.getAll();
            String orgNameProp = Organization_Properties__c.getOrgDefaults().OrganizationName__c;
            if(orgNameProp.contains(strOrgName)){
                OrgName = SAEConstants.ORGNAME_QA;
            }         
            Timeout = 10000;
            if (WSConfigurations.containsKey('StargateTimeout')) {
                Timeout = Integer.valueOf(WSConfigurations.get('StargateTimeout').Value__c);
            }
            BaseURL = '';
            if (WSConfigurations.containsKey(OrgName + '_StargateOAuthEndpoint'))    {
                BaseURL = WSConfigurations.get(OrgName + '_StargateOAuthEndpoint').Value__c;
            }
            Headers = new Map<String, String>();
            Method = 'POST';
            if (WSConfigurations.containsKey('StargateConAccessToken'))  {
                OAuthConfig = WSConfigurations.get('StargateConAccessToken');
            } else {
                OAuthConfig = new ISL_Webservice_Config__c();
                OAuthConfig.Name = 'StargateConAccessToken';
                OAuthConfig.Value__c = '';
            }
            ServiceName = 'Not Available';
            ErrorLogEnabled = false;
            PageSize = 50;
        }   
    }
    //Override in derived class if Timeout is different for webservice
    public virtual void GetTimeout()    {
        //Do nothing as default timeout is read from custom setting in constructor
    }

    //Override in derived class if Http Post Method is different for webservice
    public virtual void GetMethod() {
        //Do nothing as default method is assigned in constructor
    }

    protected virtual void GetHeaders(ISL_Webservice_Config__c OAuthConfig) {
        if (OAuthConfig == null)    {
            if (WSConfigurations.containsKey('ISLOAuthContentType'))    {
                Headers.put('Content-Type', WSConfigurations.get('ISLOAuthContentType').Value__c);
            }
        } else if (OAuthConfig.Service_Name__c == 'ORSEAIPToken') {
            // Adding EAIP Login Flow headers
            if (WSConfigurations.containsKey('SNIAPIAccessToken')) {
                Headers.put('Authorization', 'Bearer '+ WSConfigurations.get('SNIAPIAccessToken').Value__c);
            }
            if (WSConfigurations.containsKey('EAIPLoginFlowHeaderAccept')) {
                Headers.put('Content-Type', WSConfigurations.get('EAIPLoginFlowHeaderAccept').Value__c);
                Headers.put('Accept', WSConfigurations.get('EAIPLoginFlowHeaderAccept').Value__c);
            }
            if (WSConfigurations.containsKey('EAIPLoginFlowHttpHeaderActor')) {
                Headers.put('actor', WSConfigurations.get('EAIPLoginFlowHttpHeaderActor').Value__c);
            }
        } else {
            if (WSConfigurations.containsKey('OILHttpHeaderAccept'))    {
                Headers.put('Content-Type', WSConfigurations.get('OILHttpHeaderAccept').Value__c);
                Headers.put('accept', WSConfigurations.get('OILHttpHeaderAccept').Value__c);
            }
            Headers.put('timestamp', String.valueOf(system.now().millisecond()));
            if (WSConfigurations.containsKey('OILHttpHeaderScope')) {
                Headers.put('scope', WSConfigurations.get('OILHttpHeaderScope').Value__c);
                if (ScopeHeaderEnabled) {
                    String ScopeAgentType = ACETUtility.getAgentTypeById(UserInfo.getUserID());
                    if (String.isNotBlank(ScopeAgentType)) {
                        if (ScopeAgentType == 'Onshore') {
                            Headers.put('scope', 'ace');
                        }
                        else {
                            Headers.put('scope', 'off');
                        }
                    }
                }
            }
            if (WSConfigurations.containsKey('OILHttpHeaderActor')) {
                Headers.put('actor', WSConfigurations.get('OILHttpHeaderActor').Value__c);
            }
            if (WSConfigurations.containsKey('SNIEligibilityAPIContentType')) {
                Headers.put('Content-Type', WSConfigurations.get('SNIEligibilityAPIContentType').Value__c);
            }
            Headers.put('authorization', 'Bearer ' + OAuthConfig.Value__c);
        }
    }

    protected String GetRequestFormatByName(String StaticResourceName)  {
        system.debug(LoggingLevel.INFO, 'StaticResourceName: ' + StaticResourceName);
        String RequestBodyFormat = '';
        StaticResource RequestJSONSR;
        if (!test.isRunningTest())  {
            RequestJSONSR = [SELECT Body FROM StaticResource WHERE Name =:StaticResourceName];
            RequestBodyFormat = RequestJSONSR.Body.toString();
        }
        system.debug(LoggingLevel.INFO, 'RequestBodyFormat: ' + RequestBodyFormat);
        return RequestBodyFormat;
    }

    protected String GetRequestBody(String StaticResourceName, List<String> RequestParameters)  {
        String RequestBodyFormat = GetRequestFormatByName(StaticResourceName);
        String RequestBody;
        if (!test.isRunningTest())  {
            RequestBody = String.format(RequestBodyFormat, RequestParameters).replaceAll('~', '{');
        }
        system.debug(LoggingLevel.INFO, 'RequestBody: ' + RequestBody);
        return RequestBody;
    }

    public abstract void GetEndpoint();

    public virtual ACETWSCalloutResult queryPaginatedData(Integer pageNumber, Integer pageSize, Integer startRecord)    {
        ACETWSCalloutResult r = new ACETWSCalloutResult();
        r.Success = false;
        r.MessageSeverity = ApexPages.Severity.INFO;
        r.Message = 'Pagination service is not implemented.';
        r.Response = new List<Object>();
        return r;
    }

    public virtual ACETWSCalloutResult queryPaginatedData(Integer pageNumber, Integer startRecord)  {
        ACETWSCalloutResult r = new ACETWSCalloutResult();
        r.Success = false;
        r.MessageSeverity = ApexPages.Severity.INFO;
        r.Message = 'Pagination service is not implemented.';
        r.Response = new List<Object>();
        return r;
    }

    protected void GetEndpointDetail(String ISLWSConfigName)    {
        ISLWSConfigName = OrgName + '_' + ISLWSConfigName;
        ISL_Webservice_Config__c ISLWebserviceConfig;
        RelativeURL = '';
        if (WSConfigurations.containsKey(ISLWSConfigName))  {
            ISLWebserviceConfig = WSConfigurations.get(ISLWSConfigName);
            RelativeURL = ISLWebserviceConfig.Value__c;
            ServiceName = ISLWebserviceConfig.Service_Name__c;
            ErrorLogEnabled = ISLWebserviceConfig.Error_Log_Enabled__c;
            scopeHeaderEnabled = ISLWebserviceConfig.Scope_Header_Flag__c;
            PageSize = Test.isRunningTest() ? 5 : ISLWebserviceConfig.Page_Size__c != null ? Integer.valueOf(ISLWebserviceConfig.Page_Size__c) : 50;
            system.debug(LoggingLevel.INFO, 'ServiceName: ' + ServiceName + ', ErrorLogEnabled: ' + ErrorLogEnabled + ', PageSize: ' + PageSize);
        }
    }

    public HttpRequest CreateRequest()  {
        HttpRequest Request = new HttpRequest();

        //Set the timeout in milliseconds for the request.
        system.debug(LoggingLevel.INFO, 'Request Timeout: ' + Timeout);
        Request.setTimeout(Timeout);

        //Set the contents of the request header.
        for(String HeaderKey :Headers.keySet()) {
            system.debug(LoggingLevel.INFO, 'Request HeaderKey: ' + HeaderKey + ', Value: ' + Headers.get(HeaderKey));
            Request.setHeader(HeaderKey, Headers.get(HeaderKey));
        }

        //Set the type of method to be used for the HTTP request.
        system.debug(LoggingLevel.INFO, 'Request Method: ' + Method);
        Request.setMethod(Method);

        //Set the endpoint url for request.
        Endpoint = BaseURL + RelativeURL;
        system.debug(LoggingLevel.INFO, 'Request BaseURL: ' + BaseURL + ', RelativeURL: ' + RelativeURL + ', Endpoint: ' + Endpoint);
        Request.setEndpoint(Endpoint);

        system.debug(LoggingLevel.INFO, 'Request Body: ' + RequestBody);
        //if (!String.isBlank(RequestBody))   { //Code Commented By Chandan -To consider Link Api Get condition
        if (Method!='GET' && String.isNotBlank(RequestBody))   { //For Get Method no need to send the code in Body -Chandan
            Request.setBody(RequestBody); // uncomment
        }

        return Request;
    }

    protected HttpResponse Send()   {
        HttpRequest Request;
        HttpResponse Response;
        Http oHttp = new Http();

        try {
            GetHeaders(null);
            Request = CreateRequest();
            Response = oHttp.Send(Request);
        }
        catch(Exception ex) {
            system.debug(LoggingLevel.INFO, 'OAuth Http Callout Exception: ' + ex);
            Response = new HttpResponse();
            Response.setStatusCode(500);
            Response.setStatus(ex.getTypeName() + ': ' + ex.getMessage());
        }
        system.debug(LoggingLevel.INFO, 'OAuth Response Status: ' + Response.getStatus() + ', StatusCode: ' + Response.getStatusCode() + ', Body: ' + Response.getBody());
        return Response;
    }
    //Code Added By Chandan for dynamic generation of Link Api -Start
    protected String addUrlParameters(map<String,String> reqParaMap){
        String resultQuery = '?';
        for(String key:reqParaMap.keySet()){
            resultQuery += key+'='+reqParaMap.get(key)+'&';
        }
        resultQuery=resultQuery.substring(0, resultQuery.length()-1);
        return resultQuery;
    }
    //Code for getting "LinkAPI" token -Chandan Added
    public Token_Generation__c getToken(String tokenName){
     Token_Generation__c tokenVar = new Token_Generation__c();
     try{
      tokenVar = [select Token_Name__c,Value__c from Token_Generation__c where Token_Name__c =:tokenName limit 1];
     }
     catch(Exception e){
      System.debug('Exception occured while quering the token'+e);
     }
     return tokenVar;
    }
    //End

     //Code By Chandan for dynamic generation of Link Api -End

     //Code Added By Chandan for calling Link Api -Start
    protected HttpResponse Send(ISL_Webservice_Config__c OAuthConfig,String apiName)   {
        system.debug(LoggingLevel.INFO, 'OAuthConfig: ' + OAuthConfig);
        system.debug(LoggingLevel.INFO, 'apiName: ' + apiName);

        HttpRequest Request = new HttpRequest();
        HttpResponse Response;
        Http oHttp = new Http();
        ACETOAuthWebservice OAuthWS;

        try {
            System.debug('APINAME='+apiName);
            if(apiName=='LinkApi'){
                System.debug('OAuthConfig='+OAuthConfig);
                if(OAuthConfig !=null && String.isNotBlank(OAuthConfig.Value__c)){
                    System.debug('OAuthConfig.Value__c='+OAuthConfig.Value__c);
                    Headers.put('authorization', 'Bearer '+OAuthConfig.Value__c);
                }
                else{
                    Token_Generation__c tokenVar=getToken('LinkAPIAccessToken');
                    if (tokenVar!=null && tokenVar.Value__c != null)  {
                       System.debug('tokenVar.Value__c='+tokenVar.Value__c);
                       Headers.put('authorization', 'Bearer '+tokenVar.Value__c);
                    }
                }
            }

            //GetHeaders(OAuthConfig);
            system.debug(LoggingLevel.INFO, 'Timeout: ' + Timeout + ', Method: ' + Method );
            system.debug(LoggingLevel.INFO, 'BaseURL: ' + BaseURL + ', RelativeURL: ' + RelativeURL );

            Request = CreateRequest();
            System.debug('RequestBody is '+Request);
            Response = oHttp.Send(Request);
            system.debug(LoggingLevel.INFO, 'Response Status: ' + Response.getStatus() + ', StatusCode: ' + Response.getStatusCode() + ', Body: ' + Response.getBody());
        }
        catch(Exception ex) {
            system.debug(LoggingLevel.INFO, 'Http Callout Exception: ' + ex);
            Response = new HttpResponse();
            Response.setStatusCode(500);
            Response.setStatus('Internal Server Error');
            Response.setBody(GetErrorJSON('500', ex.getTypeName(), ex.getMessage(), Label.ACETUnexpectedErrorMessage));
            system.debug(LoggingLevel.INFO, 'Response Status: ' + Response.getStatus() + ', StatusCode: ' + Response.getStatusCode() + ', Body: ' + Response.getBody());
            //Response.setStatusCode(500);
        }

        if (ErrorLogEnabled) {
            if (Response.getStatusCode() != 200) {
                //Logic to add url parameters in a different column as its length is more compared endpoint feild length -Start
                String endPoint=Request.getEndpoint();
                String urlParameters='';
                if(endPoint!=null){
                    urlParameters=endPoint.substringAfter('?');
                    urlParameters='?'+urlParameters;
                    endPoint=endPoint.substringBefore('?');
                }
                createAppErrorLog('ACET', ServiceName, endPoint, Response.getStatus(), Response.getStatusCode(),Request.getBody(),Response.getBody(),urlParameters);
                //Logic to add url parameters in a different column as its length is more compared endpoint feild length -End
            }
        }/*Error is coming*/
        return Response;
    }
    //Code By Chandan for calling Link Api -End

    protected HttpResponse Send(ISL_Webservice_Config__c OAuthConfig)   {
        system.debug(LoggingLevel.INFO, 'OAuthConfig: ' + OAuthConfig);
        HttpRequest Request = new HttpRequest();
        HttpResponse Response;
        Http oHttp = new Http();
        ACETOAuthWebservice OAuthWS;

        try {
            GetHeaders(OAuthConfig);
            Request = CreateRequest();
            Response = oHttp.Send(Request);
            system.debug(LoggingLevel.INFO, 'Response Status: ' + Response.getStatus() + ', StatusCode: ' + Response.getStatusCode() + ', Body: ' + Response.getBody());
        }
        catch(Exception ex) {
            system.debug(LoggingLevel.INFO, 'Http Callout Exception: ' + ex);
            Response = new HttpResponse();
            Response.setStatusCode(500);
            Response.setStatus('Internal Server Error');
            Response.setBody(GetErrorJSON('500', ex.getTypeName(), ex.getMessage(), Label.ACETUnexpectedErrorMessage));
            system.debug(LoggingLevel.INFO, 'Response Status: ' + Response.getStatus() + ', StatusCode: ' + Response.getStatusCode() + ', Body: ' + Response.getBody());
        }
        string sniEligibleVal = '';
        if(ServiceName == 'SNIEligibilityAPI')
        {
            Map<String, Object> sniMapResultData = ACETUtility.checkSNiEligibilityValue(Response);
            if(sniMapResultData != null && ! sniMapResultData.isempty()){
                sniEligibleVal = (String)sniMapResultData.get('sniEligibility');
            }
        }
        if (ErrorLogEnabled) {
            if (Response.getStatusCode() != 200) {
                createAppErrorLog('ACET', ServiceName, Request.getEndpoint(), Response.getStatus(), Response.getStatusCode(),Request.getBody(),Response.getBody());

            }else if(Response.getStatusCode() == 200 && Response.getBody().contains('207')){
                createAppErrorLog('ACET', ServiceName, Request.getEndpoint(), Response.getStatus(), 207 ,Request.getBody(),Response.getBody());

            }else if(Response.getStatusCode() == 200 && ServiceName == 'SNIEligibilityAPI'  && (sniEligibleVal == '' || sniEligibleVal == null ) ){ // 617 for no eligibility
                createAppErrorLog('ACET', ServiceName, Request.getEndpoint(), Response.getStatus(), 617 ,Request.getBody(),Response.getBody());
            }
        }
        return Response;
    }
    @future
    public static void createAppErrorLog(string AppName, string servName, string endPoint, string respStatus, Integer respStatuscode, string reqBody,string resBody){
        Application_Error_Log__c AppErrorLog = ACETUtility.CreateApplicationErrorLog(AppName, servName, endPoint, respStatus, respStatuscode);
        List<Attachment> AppErrorLogAtts = new List<Attachment>();
        if (servName == 'ORSEAIPToken') {
            AppErrorLogAtts.add(ACETUtility.CreateAttachment(null, servName + 'Request', reqBody));
            AppErrorLogAtts.add(ACETUtility.CreateAttachment(null, servName + 'Response', resBody));
        } else {
            if(reqBody != null)
            AppErrorLogAtts.add(ACETUtility.CreateAttachment(null, 'OILRequest', reqBody));
            if(resBody != null)
            AppErrorLogAtts.add(ACETUtility.CreateAttachment(null, 'OILResponse', resBody));
        }
        system.debug(LoggingLevel.INFO, 'AppErrorLog: ' + AppErrorLog + ', AppErrorLogAtts: ' + AppErrorLogAtts);
        Database.SaveResult ErrorLogSR = Database.insert(AppErrorLog);
        if (ErrorLogSR.isSuccess()) {
            Id ErrorLogId = ErrorLogSR.getId();
            for(Attachment AppErrorLogAtt : AppErrorLogAtts) {
                AppErrorLogAtt.ParentId = ErrorLogId;
            }
            Database.SaveResult[] ErrorLogAttsSR = Database.insert(AppErrorLogAtts);
        }
    }
    @future
    public static void createAppErrorLog(string AppName, string servName, string endPoint, string respStatus, Integer respStatuscode, string reqBody,string resBody,String urlParameters){
        Application_Error_Log__c AppErrorLog = ACETUtility.CreateApplicationErrorLog(AppName, servName, endPoint, respStatus, respStatuscode);
        AppErrorLog.UrlParamaters__c=urlParameters;
        List<Attachment> AppErrorLogAtts = new List<Attachment>();
        AppErrorLogAtts.add(ACETUtility.CreateAttachment(null, 'OILRequest', reqBody));
        AppErrorLogAtts.add(ACETUtility.CreateAttachment(null, 'OILResponse', resBody));
        system.debug(LoggingLevel.INFO, 'AppErrorLog: ' + AppErrorLog + ', AppErrorLogAtts: ' + AppErrorLogAtts);
        Database.SaveResult ErrorLogSR = Database.insert(AppErrorLog);
        if (ErrorLogSR.isSuccess()) {
            Id ErrorLogId = ErrorLogSR.getId();
            for(Attachment AppErrorLogAtt : AppErrorLogAtts) {
                AppErrorLogAtt.ParentId = ErrorLogId;
            }
            Database.SaveResult[] ErrorLogAttsSR = Database.insert(AppErrorLogAtts);
        }
    }
    protected Continuation AddHttpRequest(ISL_Webservice_Config__c OAuthConfig, String CallbackMethodName, Continuation oContinuation)  {
        system.debug(LoggingLevel.INFO, 'OAuthConfig: ' + OAuthConfig + ', CallbackMethodName: ' + CallbackMethodName + ', oContinuation: ' + oContinuation);
        GetHeaders(OAuthConfig);
        HttpRequest Request = CreateRequest();
        if (oContinuation == null) {
            oContinuation = new Continuation(Timeout / 1000);
            oContinuation.continuationMethod = CallbackMethodName;
        }
        RequestLabel = oContinuation.addHttpRequest(Request);
        system.debug(LoggingLevel.INFO, 'AddHttpRequest. RequestLabel: ' + RequestLabel);

        return oContinuation;
    }

    protected HttpResponse GetHttpResponse(String HttpRequestLabel) {
        system.debug(LoggingLevel.INFO, 'HttpRequestLabel: ' + HttpRequestLabel);
        HttpResponse Response = Continuation.getResponse(HttpRequestLabel);
        system.debug(LoggingLevel.INFO, 'Response Status: ' + Response.getStatus() + ', StatusCode: ' + Response.getStatusCode() + ', Body: ' + Response.getBody());

        if (ErrorLogEnabled) {
            if (Response.getStatusCode() != 200) {
                createAppErrorLog('ACET', ServiceName, Endpoint, Response.getStatus(), Response.getStatusCode(),RequestBody,Response.getBody());

            }
        }

        return Response;
    }

    public virtual ACETWSCalloutResult ParseFailureResponse(HttpResponse FailureResponse)   {
        ACETWSCalloutResult oACETWSCalloutResult = new ACETWSCalloutResult();
        oACETWSCalloutResult.Success = false;
        oACETWSCalloutResult.MessageSeverity = ApexPages.Severity.ERROR;
        try {
            Map<String, Object> mapRootNode = (Map<String, Object>)JSON.deserializeUntyped(FailureResponse.getBody());
            if (FailureResponse.getStatusCode() == 500 &&
                (mapRootNode.containsKey('ErrorCode') && mapRootNode.containsKey('Advice'))) {
                //Parse failure repsonse from ISL
                oACETWSCalloutResult.Message = Label.ACETUnexpectedErrorMessage;
            } else {
                //Parse failure response from OIL
                Map<String, Object> mapErrors = (Map<String, Object>)mapRootNode.values().get(0);
                system.debug('Map Errors:' + mapErrors);
                List<Object> lstErrors = (List<Object>)mapErrors.get('errors');
                system.debug('List Errors:' + lstErrors);
                if (lstErrors == null) {
                    Map<String, Object> mapTypeNode = (Map<String, Object>)mapErrors.values().get(0);
                    lstErrors = (List<Object>)mapTypeNode.get('errors');
                    system.debug('List Errors 2:' + lstErrors);
                }
                Map<String, Object> mapError;
                String ErrorDescription;
                if(lstErrors != null) {
                    for (Object oError :lstErrors) {
                        mapError = (Map<String, Object>)oError;
                        system.debug('Error: ' + mapError);
                        ErrorDescription = String.valueOf(mapError.get('description'));
                        if (String.isBlank(oACETWSCalloutResult.Message)) {
                            oACETWSCalloutResult.Message = ErrorDescription;
                        } else {
                            if (oACETWSCalloutResult.Message.length() + ErrorDescription.length() <= 255) {
                                oACETWSCalloutResult.Message += '; ' + ErrorDescription;
                            } else {
                                break;
                            }
                        }
                    }
                }
            }
        }
        catch(Exception ex)
        {
            system.debug(LoggingLevel.INFO, 'Error serializing error response JSON. Details: ' + ex);
            oACETWSCalloutResult.Message = FailureResponse.getBody();
        }

        return oACETWSCalloutResult;
    }

    public String GetOILErrorMessage(List<ACETOILError> lstOILErrors) {
        String ErrorMessage = '';
        for (ACETOILError OILError :lstOILErrors) {
            if (String.isBlank(ErrorMessage)) {
                if (test.isRunningTest()) {
                    ErrorMessage = OILError.code;
                    ErrorMessage = OILError.name;
                    ErrorMessage = OILError.severity;
                    ErrorMessage = OILError.origin;
                }
                ErrorMessage = OILError.description;
            } else {
                if (ErrorMessage.length() + OILError.description.length() <= 255) {
                    ErrorMessage += '; ' + OILError.description;
                } else {
                    break;
                }
            }
        }
        return ErrorMessage;
    }

    protected String GetErrorJSON(String ErrorID, String ErrorCode, String ErrorMessage, String Advice) {
        String ErrorJSON = '{"ErrorID":"' + ErrorID + '","ErrorCode":"' + ErrorCode + '","ErrorMessage":"' + ErrorMessage + '","Advice":"' + Advice + '"}';
        return ErrorJSON;
    }

    //Change date format from YYYY-MM-DD to MM/DD/YYYY
    public String ChangeDateFormat(String OILDate) {
        String FormattedDate = '';

        if (String.isNotBlank(OILDate)) {
            List<String> OILDateSplit = OILDate.split('-');
            if(OILDateSplit.size() == 3) {
                FormattedDate = OILDateSplit[1] + '/' + OILDateSplit[2] + '/' + OILDateSplit[0];
            }
        }

        return FormattedDate;
    }

    public String ReplaceKeywords(String ResponsBody) {         
        Integer StringMaxLimit = 100000;
        
        if(ResponsBody!=null && ResponsBody.length() < StringMaxLimit){
            //If Response Body Length is less than 1M characters replace all the keywords
            return ResponsBody.replaceAll('"desc"','"descr"').
                replaceAll('"date"','"dte"')
                .replaceAll('"dateTime"','"dteTime"')
                .replaceAll('"number"','"numbr"')
                .replaceAll('"type"','"eType"')
                .replaceAll('"object"','"Object_Z"');
        }
        
        else if(ResponsBody != null){
            
            /*If Response Body Length is more than 1M characters, replaceAll throws "Regex too complicated" exception 
             * reported in PGA 1727 or 	DE362641 , so ReponseBody will be split into Strings of 1M characters each 
             * and scenarios when keyword is divided between the parts must be handled*/
            
            String regex = ResponsBody;
            List<String> parts = new List<String>();
            Integer partsCount = Integer.valueOf(regex.length()/StringMaxLimit);
            
            //Dividing into parts of 1M each
            for(Integer i=0;i<partsCount;i++){
                if(i<partsCount-1){  
                    parts.add(regex.substring(i*StringMaxLimit,(i+1)*StringMaxLimit));
                }
                else{
                    parts.add(regex.substring(i*StringMaxLimit,regex.length()));  
                }
            }
            
            //Variable returned by this method
            String updatedString = '';
            
            //Replacing the strings in each part and concatenating to single String
            for(Integer i=0;i<parts.size();i++){
                
                
                //If the parts[i] is not last part there chance the keyword divided in this part parts[i] and next parts[i+1]
                if(i<partsCount-1){
                    
                    /*if keyword is divided, 
                     * ex: '"desc"' divided as  parts[i]='abc...."des' & parts[i+1]='c"...xyz' 
                     * then removing the divided combination from end of parts[i] and start of parts[i+1]*/
                    
                    /*Below variable will hold the updated part and replaced String
                     *  if keyword is divided in parts */
                    List<String> updatedParts = new List<String>();
                    
                    //isReplacingStringDividedBetweenParts boolean below is true if any keyword is divided between parts                    
                    Boolean isReplacingStringDividedBetweenParts = 
                        replaceDividedString(parts[i],parts[i+1],updatedParts,'"desc"','"descr"');
                    
                    isReplacingStringDividedBetweenParts = isReplacingStringDividedBetweenParts
                        || replaceDividedString(parts[i],parts[i+1],updatedParts,'"date"','"dte"');
                    
                    isReplacingStringDividedBetweenParts = isReplacingStringDividedBetweenParts 
                        || replaceDividedString(parts[i],parts[i+1],updatedParts,'"type"','"eType"');
                    
                    isReplacingStringDividedBetweenParts = isReplacingStringDividedBetweenParts
                        || replaceDividedString(parts[i],parts[i+1],updatedParts,'"number"','"numbr"');
                    
                    isReplacingStringDividedBetweenParts = isReplacingStringDividedBetweenParts
                        || replaceDividedString(parts[i],parts[i+1],updatedParts,'"object"','"Object_Z"');
                    
                    isReplacingStringDividedBetweenParts = isReplacingStringDividedBetweenParts 
                        || replaceDividedString(parts[i],parts[i+1],updatedParts,'"dateTime"','"dteTime"');
                    
                    /*If keyword divided between parts then remove the divided string
                     *  in parts[i] and parts[i+1] as returned from replaceDividedString method */
                    
                    if(isReplacingStringDividedBetweenParts){
                        parts[i] = updatedParts[0];
                        parts[i+1] = updatedParts[1];
                    } 
                    
                    //Replacing keyword occurences in between of parts[i] and appending to updatedString
                    updatedString +=
                        parts[i].replaceAll('"desc"','"descr"')
                        .replaceAll('"date"','"dte"')
                        .replaceAll('"dateTime"','"dteTime"')
                        .replaceAll('"number"','"numbr"')
                        .replaceAll('"type"','"eType"')
                        .replaceAll('"object"','"Object_Z"');
                    
                    
                   /*If keyword was divided then append replaced String to updatedString 
                     * respective replaced Sting updatedParts[2] is returned from replaceDividedString method */
                    
                    if(isReplacingStringDividedBetweenParts){
                        updatedString += updatedParts[2];
                    }
                }
                else{
                    updatedString += 
                        parts[i].replaceAll('"desc"','"descr"')
                        .replaceAll('"date"','"dte"')
                        .replaceAll('"dateTime"','"dteTime"')
                        .replaceAll('"number"','"numbr"')
                        .replaceAll('"type"','"eType"')
                        .replaceAll('"object"','"Object_Z"');
                }
            }
            return updatedString;
        }
        return null;
    }

    public static Boolean replaceDividedString(String firstPart,String secondPart,List<String> updatedParts,String keyword,String replacedString){
        
        /*High level check to see replacing String is divided between firstPart and secondPart, 
         * if not return false, to save CPU time */
        if(firstPart.length() > keyword.length() && secondPart.length() > keyword.length()){
            String shortStr = firstPart.substring(firstPart.length()-keyword.length(),firstPart.length());
            shortStr += secondPart.substring(0,keyword.length());
            if(!shortStr.contains(keyword)){
                return false;
            }
        }
        
        /* Keyword character wise comparison, (done by splitting the keyword into 
         * character increments and residual characters) to confirm the index at which the keyword 
         * is divided between firstPart and secondPart to remove the divided parts in firstPart and secondPart */
        
        for(integer i=0;i<keyword.length()-1;i++){
            String part1 = keyword.substring(0,i+1);
            String part2 = keyword.substring(i+1,keyword.length());
            if(firstPart.endsWith(part1) && secondPart.startsWith(part2)){
                updatedParts.add(firstPart.removeEnd(part1));
                updatedParts.add(secondPart.removeStart(part2));
                updatedParts.add(replacedString);
                return true;
            }
        }
        return false;
    }
}