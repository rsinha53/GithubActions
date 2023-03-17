public with sharing class ACET_ORSWebservice extends ACETWebservice {

    static final String BEARER = 'Bearer';
    static final String CONTENT_TYPE = 'Content-Type';
    static final String CONTENT_TYPE_VALUE = 'application/json';

    // US2041480 - Thanish - 6th Apr 2020 - Integrating ACETWebservice
    private String endpointType;

    // US2101464 - Thanish - 19th Jun 2020 - Error code handling ...
    @AuraEnabled
    public static Object getORSSearchServiceResponse(string requestBody) {
        HttpResponse response = new HttpResponse();
        try{
            Map < String, ACETOrgInstanceURLToOrgNameMap__c > OrgInstance2OrgNameMap = ACETOrgInstanceURLToOrgNameMap__c.getAll();
            String orgName = Test.isRunningTest() ? 'dev' : ACETUtility.GetOrgName(OrgInstance2OrgNameMap);
            Map < String, ISL_Webservice_Config__c > islWebserviceData = ISL_Webservice_Config__c.getAll();
            String endPoint = islWebserviceData.get(orgName + '_ORSSelectIssue').Value__c;
            Http h = new Http();
            HttpRequest httpRequest = new HttpRequest();
            httpRequest.setEndpoint(endPoint);
            httpRequest.setMethod('POST');
            httpRequest.setHeader('Authorization', BEARER + ISL_Webservice_Config__c.getInstance('SNIAPIAccessToken').Value__c);
            httpRequest.setHeader(CONTENT_TYPE, CONTENT_TYPE_VALUE);
            httpRequest.setHeader('actor', 'ACET');
            httpRequest.setBody(requestBody);
            System.debug('@ ACET_ORSWebservice: getORSSearchServiceResponse: requestBody:'+ requestBody);
            //response = h.send(httpRequest);
            //System.debug('@ ACET_ORSWebservice: getORSSearchServiceResponse: responseBody:'+response.getBody());

            ACET_WebserviceCalloutFramework wsCallOutFW = new ACET_WebserviceCalloutFramework();
            wsCallOutFW.serviceName = 'ORSSelectIssue';
            wsCallOutFW.requestBody = requestBody;
            response = wsCallOutFW.getResponse();

            //ORS Log Creation
            if(response.getStatusCode() != 200){
                String urlParameters='';
                if(endPoint!=null){
                    urlParameters = '?' + endPoint.substringAfter('?');
                    endPoint = endPoint.substringBefore('?');
                }
                //ACET_ORSWebservice.createAppErrorLog_ORS('ACET', 'ORSSelectIssue', endPoint, response.getStatus(), response.getStatusCode(), requestBody, response.getBody(), urlParameters);
            }

            return response;
        } catch(Exception ex) {
            System.debug('@ ACET_ORSWebservice: getORSSearchServiceResponse: exception:'+ex.getMessage());
            response.setStatusCode(500);
            return response;
        }
    }

    @AuraEnabled
    public static list<selectIssueWrapper> selectIssues(string lastName,string alternateId,string state,string callerFirstName,
                                                        string callerLastName,Boolean isProvider,String providerTaxId,Boolean isToggleOnOff,String nextIssueKey, String memdob, String memRelation, String memberNumber) {
        string requestBody;
        map<String,Object> responseMap = new map<String,Object>();
        list<selectIssueWrapper> respToReturn = new list<selectIssueWrapper>();
      	String topsUserId = (String)Cache.Session.get('local.TOPSProfileInfo.userId');//673/JR2
        List<String> searchInputParams = new List<String>();
        if(!String.isBlank(topsUserId)) {
            searchInputParams = topsUserId.split('/');
        }else {
            ACET_LoginFlowCtrl loginflow = new ACET_LoginFlowCtrl();
            loginflow.validateTopsCredentials();
            topsUserId = (String)Cache.Session.get('local.TOPSProfileInfo.userId');
            if(!String.isBlank(topsUserId)) {
                searchInputParams = topsUserId.split('/');
            }
        }
        Http h = new Http();
        HttpRequest httpRequest = new HttpRequest();
        HttpResponse httpResponse = new HttpResponse();
        String responseBody;
        Integer statusCode;

         if(isProvider){
            SearchInputProvider searchInputProv = new SearchInputProvider();
             if(!searchInputParams.isempty()) {
                 searchInputProv.officeId = searchInputParams[0];
                 searchInputProv.agentId = searchInputParams[1];
             }
            searchInputProv.providerTaxId = providerTaxId;
            searchInputProv.searchType = 'PROVIDER_TAX_ID';
             if(String.isNotBlank(nextIssueKey) || String.isNotEmpty(nextIssueKey)){
                 pagingState ps = new pagingState();
                 ps.moreData = 'true';
                 ps.nextIssueKey = nextIssueKey;
                 searchInputProv.pagingState = ps;
             }
            requestBody = JSON.serialize(searchInputProv);
            requestBody = '{"searchInput":' + requestBody + '}';
        }else{
            SearchInputMember searchInputMem = new SearchInputMember();
             if(!searchInputParams.isempty()) {
                 searchInputMem.officeId = searchInputParams[0];
                 searchInputMem.agentId = searchInputParams[1];
             }
            //searchInputMem.searchType = 'SUBSCRIBER_ID';
            //searchInputMem.subscriberId =  alternateId;

            //searchInputMem.searchType = 'MEMBER_BY_DOB_RELCODE';
            //searchInputMem.memberNumber = alternateId;
            //searchInputMem.dateOfBirth = memdob;
            //searchInputMem.relationshipcode = memRelation; alternateId
            searchInputMem.searchType = 'ALTERNATE_ID';
            searchInputMem.alternateId = alternateId;


            if(String.isNotBlank(nextIssueKey) || String.isNotEmpty(nextIssueKey)){
                 pagingState ps = new pagingState();
                 ps.moreData = 'true';
                 ps.nextIssueKey = nextIssueKey;
                 searchInputMem.pagingState = ps;
             }

            requestBody = JSON.serialize(searchInputMem);
            requestBody = '{"searchInput":' + requestBody + '}';
        }

        System.debug('@@ ACET_ORSWebservice: selectIssues: requestBody: ' + requestBody);
        Map < String, ACETOrgInstanceURLToOrgNameMap__c > OrgInstance2OrgNameMap = ACETOrgInstanceURLToOrgNameMap__c.getAll();
        String orgName = Test.isRunningTest() ? 'dev' : ACETUtility.GetOrgName(OrgInstance2OrgNameMap);
      	//US3098067 - Vishnu
        Map < String, ISL_Webservice_Config__c > islWebserviceData = ISL_Webservice_Config__c.getAll();
        String endPoint = islWebserviceData.get(orgName + '_ORSSelectIssue').Value__c;
        httpRequest.setMethod('POST');
        httpRequest.setEndpoint(endPoint);
        httpRequest.setBody(requestBody);
        httpRequest.setHeader(CONTENT_TYPE, CONTENT_TYPE_VALUE);
        httpRequest.setHeader('actor', 'ACET');
        httpRequest.setTimeout(12000);
        httpRequest.setHeader('Authorization', BEARER + ISL_Webservice_Config__c.getInstance('SNIAPIAccessToken').Value__c);

        System.debug('@@ ACET_ORSWebservice: selectIssues: requestBody: ' + requestBody);
        //httpResponse = h.send(httpRequest);

		ACET_WebserviceCalloutFramework wsCallOutFW = new ACET_WebserviceCalloutFramework();
        wsCallOutFW.serviceName = 'ORSSelectIssue';
        wsCallOutFW.requestBody = requestBody;
        httpResponse = wsCallOutFW.getResponse();

        statusCode = httpResponse.getStatusCode();
        responseBody = httpResponse.getBody();
        if(statusCode == 200){
            if(string.isNotBlank(responseBody)){
                Map<String, Object> orsMainMap = (Map<String, Object>)JSON.deserializeUntyped(responseBody);
                Map<String, Object> orsRespMap = (Map<String, Object>)orsMainMap.get('searchResult');

                Map<String,Object> orsSearchOutput = (Map<String, Object>)orsRespMap.get('searchOutput');
                List<Object> orsIssuesList = (List<Object>)orsSearchOutput.get('issuesList');

                Map<String,Object> pagingState = (Map<String,Object>)orsSearchOutput.get('pagingState');
                Boolean moreRecords = (Boolean)pagingState.get('moreData');
                String nextIssueKey_next;
                if(moreRecords){
                    nextIssueKey_next =(String)pagingState.get('nextIssueKey');
                }

                List<Relationship_Codes__mdt> relCodes = [select code__c, Description__c from Relationship_Codes__mdt];

                Map<String, String> relCodeMap = new Map<String, String>();

                for(Relationship_Codes__mdt rel: relCodes){
                    relCodeMap.put(rel.code__c,rel.Description__c);
                }

                ACET_ORSSelectIssues.IssuesList orsSelectIssue = new ACET_ORSSelectIssues.IssuesList();
                for(Object obj : orsIssuesList){
                    Map<String, Object> mapobj = (Map<String, Object>)obj;
                    selectIssueWrapper ss = new selectIssueWrapper();
                    ss.ID = (String)mapobj.get('issueId');
                    //ss.OriginatorType = (String)mapobj.get('originatorTypeDescription');
                    String originType = (String)mapobj.get('originatorTypeDescription');
                    originType = originType.toLowerCase();
                    ss.OriginatorType = originType.capitalize();
                    string orgDate = (String)mapobj.get('originatedDate');
                    String orgTime = (String)mapobj.get('originatedTime');
                    //US2646982 Added by Vinay
                    List<String> orgTimeList = orgTime.split(':');
                    Date orgDt = date.valueOf(orgDate);
                    DateTime myDateTime = DateTime.newInstance(orgDt.year(),
                                                               orgDt.month(),
                                                               orgDt.day(),
                                                               integer.valueOf(orgTimeList[0]),
                                                               integer.valueOf(orgTimeList[1]),
                                                               integer.valueOf(orgTimeList[2]));
                    String convertedOrgDateTime = myDateTime.format('MM/dd/yyyy hh:mm a');

                    ss.CreatedDate = convertedOrgDateTime;

                    //6 Months Filtering
                    Date beforeSixMonths = System.today().addMonths(-6);
                    Date dt = date.valueOf(orgDate);
                    ss.isSixMonths = beforeSixMonths < dt ? true : false;

                    if(String.isNotBlank(ss.ID)){
                        if(0 == ss.ID.indexOf('D')){
                            ss.IDType = 'ORS';
                        }else{
                            ss.IDType = '';
                        }
                    }
                    ss.CaseNumber = '--';
                    ss.isProvider = ss.OriginatorType == 'Provider' ? true : false;
                    ss.TopicReason = (String)mapobj.get('contactReasonDescription');
					ss.Status = '--';
					  // US2667560 -  Sanka - ORS Family Filtering
                    Map<String, Object> memberInfo = ( Map<String, Object>)mapobj.get('memberInfo');
                    Map<String, Object> dependetName = ( Map<String, Object>)memberInfo.get('dependentName');

                    Map<String, Object> providerInfo = ( Map<String, Object>)mapobj.get('providerInfo');

                    String mem_fistName = (String) dependetName.get('firstName');
                    String mem_lastName = (String) dependetName.get('lastName');
                    String mem_memberId = (String) memberInfo.get('memberNumber');
                    String mem_policyNo = (String) memberInfo.get('policy');

                    String provider_lastName = (String) providerInfo.get('lastName');
                    //String provider_firstName = (String) providerInfo.get('firstName');
                    //String formattedPolicyNo = mem_policyNo != '' ? mem_policyNo.SubString(1,mem_policyNo.length()) : mem_policyNo;

                    String relCode = (string)memberInfo.get('relationshipCode');

                    String relationDesc = String.isNotBlank(relCodeMap.get(relCode)) ? relCodeMap.get(relCode) : '--';


                    ss.xRefIdORS = mem_fistName + mem_lastName + mem_memberId + mem_policyNo;

                    if(String.isNotBlank(mem_fistName) || (String.isNotBlank(mem_lastName))){
					String SubjectName = String.isNotBlank(mem_fistName) ? mem_fistName +' '+ (String.isNotBlank(mem_lastName) ? mem_lastName : '') : '--';
                    //String SubjectName = String.isNotBlank(mem_fistName) ? mem_fistName : '--';

                        ss.relationship = SubjectName +' '+'/'+' '+relationDesc;
                    }else{
                        String ProviderName = String.isNotBlank(provider_lastName) ? provider_lastName : '--';
                        ss.relationship = ProviderName +' '+'/'+' '+'Provider';
                    }
                    ss.moreData = moreRecords;
                    if(ss.moreData){
                        ss.nextIssueKey = nextIssueKey_next;
                    }

                    respToReturn.add(ss);
                }

                responseMap.put('success',true);
                //responseMap.put('Response',result);
                responseMap.put('statusCode',statusCode);
            }
        }else{
            responseMap.put('Success',false);
            responseMap.put('statusCode',statusCode);
            // US2101464 - Thanish - 22nd Jun 2020 - Error handling ...
            selectIssueWrapper errorWrapper = new selectIssueWrapper();
            /*if (statusCode == 400) {
                errorWrapper.responseStatus = statusCode;
                errorWrapper.responseStatusMessage = 'Unexpected error occurred while retrieving ORS details. Please try again. If problem persists contact help desk.';
            } else if(statusCode==404){
                errorWrapper.responseStatus = statusCode;
                errorWrapper.responseStatusMessage = 'No ORS Results Found';
            } else if(statusCode==500){
                errorWrapper.responseStatus = statusCode;
                errorWrapper.responseStatusMessage = 'Unexpected error occurred while retrieving ORS details. Please try again. If problem persists contact help desk.';
            } else {
                errorWrapper.responseStatus = statusCode;
                errorWrapper.responseStatusMessage = 'Unexpected error while retrieving ORS details! Error Code: ' + String.valueOf(statusCode);
            }*/
            errorWrapper.responseStatus = statusCode;
            errorWrapper.responseStatusMessage = 'Unexpected Error Occurred in the Case History�card. Please try again. If problem persists please contact the help desk.';
            respToReturn.add(errorWrapper);

            //ORS Log Creation
            String urlParameters='';
            if(endPoint!=null){
                urlParameters = '?' + endPoint.substringAfter('?');
                endPoint = endPoint.substringBefore('?');
            }
            //ACET_ORSWebservice.createAppErrorLog_ORS('ACET', 'ORSSelectIssue', endPoint, httpResponse.getStatus(), httpResponse.getStatusCode(), requestBody, httpResponse.getBody(), urlParameters);
        }
        System.debug('@@ ACET_ORSWebservice: selectIssues: statusCode: ' + statusCode);
        System.debug('@@ ACET_ORSWebservice: selectIssues: responseBody: ' + responseBody);
        return respToReturn;
    }

    public class SearchInputProvider{
        public String searchType;
        public String officeId;
        public String agentId;
        public String providerTaxId;
        public pagingState pagingState;
    }

    public class SearchInputMember{
        public String subscriberId;
        public String searchType;
        public String agentId;
        public String officeId;
        public pagingState pagingState;
        public String memberNumber;
        public String dateOfBirth;
        public String relationshipcode;
        public String alternateId;
    }

    // US2041480 - Thanish - 6th Apr 2020 - Integrating ACETWebservice
    public override void getEndpoint() {
        if(this.endpointType == 'read_issue') {
            //GetEndpointDetail('ORSReadIssue');
            GetEndpointDetail('ORSReadIssueMicroService');
        }
    }

    public Object readIssueDetails(String requestBody) {
        // US2041480 - Thanish - 6th Apr 2020 - Integrating ACETWebservice
        this.endpointType = 'read_issue';
        getEndpoint();

        Http h = new Http();
        HttpRequest httpRequest = new HttpRequest();
        HttpResponse httpResponse = new HttpResponse();
        String responseBody;
        Integer statusCode;
        // sample requestBody = '{"searchInput":{"controlModifiers":{"orsSystemParameters":{"logonId":"JR2","logonOffice":"673"}},"issueId":"D00780701475712"}}';
        httpRequest.setMethod('POST');
        httpRequest.setEndpoint(RelativeURL);
        httpRequest.setBody(requestBody);
        httpRequest.setHeader(CONTENT_TYPE, CONTENT_TYPE_VALUE);
        httpRequest.setHeader('actor', 'ACET');
        httpRequest.setTimeout(12000);
        httpRequest.setHeader('Authorization', BEARER + ISL_Webservice_Config__c.getInstance('SNIAPIAccessToken').Value__c);

        System.debug('@@ ACET_ORSWebservice: readIssueDetails: requestBody: ' + requestBody);
        //httpResponse = h.send(httpRequest);

        ACET_WebserviceCalloutFramework wsCallOutFW = new ACET_WebserviceCalloutFramework();
		wsCallOutFW.serviceName = 'ORSReadIssueMicroService';
		wsCallOutFW.requestBody = requestBody;
		httpResponse = wsCallOutFW.getResponse();

        statusCode = httpResponse.getStatusCode();
        responseBody = httpResponse.getBody();
        System.debug('@@ ACET_ORSWebservice: readIssueDetails: statusCode: ' + statusCode);
        System.debug('@@ ACET_ORSWebservice: readIssueDetails: responseBody: ' + responseBody);

        //ORS Log Creation
        String endPoint = RelativeURL;
        if(statusCode != 200){
            String urlParameters='';
            if(endPoint!=null){
                urlParameters = '?' + endPoint.substringAfter('?');
                endPoint = endPoint.substringBefore('?');
            }
            //ACET_ORSWebservice.createAppErrorLog_ORS('ACET', 'ORSReadIssueMicroService', endPoint, httpResponse.getStatus(), httpResponse.getStatusCode(), requestBody, httpResponse.getBody(), urlParameters);
        }

        // US2667560 - ORS ReadIssue Error Handling - Sanka
        return httpResponse;
    }

    public static Object insertClaimAdjustments(String requestBody) {
        Http h = new Http();
        HttpRequest httpRequest = new HttpRequest();
        HttpResponse httpResponse = new HttpResponse();
        String responseBody;
        Integer statusCode;
        requestBody = '{"postInput":{"postInputMeta":{"claimSource":"UNET","macessSystemParameter":{"applicationId":"","password":"","stationId":"","userId":"","userName":""},"orsSystemParameter":{"logonId":"PRP","logonOffice":"011","securityToken":""}},"claimAdjustments":{"adjustmentSource":"","allowedIndicator":"Z","atgIndicator":"N","claimIssueDescription":"","claimIssueType":"","claimNumber":"0000000000","claimSystem":"UNET","claimType":"PHYSICIAN","cobIndicator":"N","comment":"X05609520190930141907043;NPI1194062448","cosmosProduct":"","dateOfService":"2019-09-30","documentImageId":"","draftNumber":"","employeeFirstName":"ROCK","employeeId":"999410701","employeeLastName":"JOHNSON","facetsProviderId":"","market":"","mpin":"0","mpinSequenceNumber":"","originatorCode":"","patientDateOfBirth":"","patientFirstName":"ROCK","patientLastName":"JOHNSON","payLocationNumber":"","policyNumber":"712974","productId":"","providerFirstName":"B2B","providerLastName":"QUEST DIAGNOSTICS MA","providerTin":"461491586","providerTinPrefix":"","providerTinSuffix":"","reasonCategory":"PRO","reasonCode":"PRED","requestSource":"","routingKey":"00057","serviceEndDate":"","substitutionIndicator":"","systemDivision":"","totalClaimAmount":"412.16","totalPaid":"","tpmsDescription":"","tpsmIndicator":"","uhcEmployeeIndicator":"N","unetAdjustmentRcptSource":"","unetClaimEngine":"","userId":"Amit"}}}';
        String endPoint = 'https://gateway-stage.optum.com/api/alpha/clm/eaipclaims/claim-adjustments/v1';
        httpRequest.setMethod('POST');
        httpRequest.setEndpoint(endPoint);
        httpRequest.setBody(requestBody);
        httpRequest.setHeader(CONTENT_TYPE, CONTENT_TYPE_VALUE);
        httpRequest.setHeader('actor', 'ACET');
        httpRequest.setHeader('logLevel', 'DEBUG');
        httpRequest.setHeader('Accept', CONTENT_TYPE_VALUE);
        httpRequest.setHeader('applicationName', 'B2B');
        httpRequest.setHeader('applicationInstanceName', 'ag-clm-eaipclaims-claimadjustments-v1-tc1');
        httpRequest.setHeader('serviceOption', 'LISA_ENV:VS-ClaimsUnit');
        httpRequest.setHeader('externalId', '99999901');
        httpRequest.setTimeout(12000);
        httpRequest.setHeader('Authorization', BEARER + ISL_Webservice_Config__c.getInstance('SNIAPIAccessToken').Value__c);

        System.debug('@@ ACET_ORSWebservice: insertClaimAdjustments: requestBody: ' + requestBody);
        httpResponse = h.send(httpRequest);
        statusCode = httpResponse.getStatusCode();
        responseBody = httpResponse.getBody();
        System.debug('@@ ACET_ORSWebservice: insertClaimAdjustments: statusCode: ' + statusCode);
        return responseBody;
    }

    public static Object assignOrRouteIssue(String requestBody) {
        Http h = new Http();
        HttpRequest httpRequest = new HttpRequest();
        HttpResponse httpResponse = new HttpResponse();
        String responseBody;
        Integer statusCode;
        requestBody = '{"putInput":{"controlModifiers":{"orsSystemParameters":{"logonId":"JR2","logonOffice":"673"}},"assignIndicator":"I","officeId":"673","departmentCode":"SYS","teamCode":"TST","associateId":"","issueId":["C93151447589980"]}}';
        String endPoint = 'https://gateway-stage.optum.com/api/STAGE/cdm/constmgmt/eaipxdomain-aoril/issues/v1';
        httpRequest.setMethod('PUT');
        httpRequest.setEndpoint(endPoint);
        httpRequest.setBody(requestBody);
        httpRequest.setHeader(CONTENT_TYPE, CONTENT_TYPE_VALUE);
        httpRequest.setHeader('actor', 'ACET');
        httpRequest.setTimeout(12000);
        httpRequest.setHeader('Authorization', BEARER + ISL_Webservice_Config__c.getInstance('SNIAPIAccessToken').Value__c);

        System.debug('@@ ACET_ORSWebservice: assignOrRouteIssue: requestBody: ' + requestBody);
        httpResponse = h.send(httpRequest);
        statusCode = httpResponse.getStatusCode();
        responseBody = httpResponse.getBody();
        System.debug('@@ ACET_ORSWebservice: assignOrRouteIssue: statusCode: ' + statusCode);
        System.debug('@@ ACET_ORSWebservice: assignOrRouteIssue: responseBody: ' + responseBody);
        return responseBody;
    }

    public static Object reopenIssue(String requestBody) {
        Http h = new Http();
        HttpRequest httpRequest = new HttpRequest();
        HttpResponse httpResponse = new HttpResponse();
        String responseBody;
        Integer statusCode;
        requestBody = '{"putInput":{"controlModifiers":{"orsSystemParameter":{"logonId":"JR2","logonOffice":"673"}},"issue":{"autoId":"5823843785","businessSegmentName":"ABCDEFGH","dialedId":"2857365844","icrCallLocationDay":"9439639399","icrCallLocationId":"8548276832","issueId":"C93151447589980","modifiedByApplicationIndicator":"A","updateDate":"19315","updateTime":"14:47:58"}}}';
        String endPoint = 'https://gateway-stage-dmz.optum.com/api/STAGE/cdm/constmgmt/eaipxdomain-roi/issues/v1';
        httpRequest.setMethod('POST');
        httpRequest.setEndpoint(endPoint);
        httpRequest.setBody(requestBody);
        httpRequest.setHeader(CONTENT_TYPE, CONTENT_TYPE_VALUE);
        httpRequest.setHeader('actor', 'ACET');
        httpRequest.setTimeout(12000);
        httpRequest.setHeader('Authorization', BEARER + ISL_Webservice_Config__c.getInstance('SNIAPIAccessToken').Value__c);

        System.debug('@@ ACET_ORSWebservice: reopenIssue: requestBody: ' + requestBody);
        httpResponse = h.send(httpRequest);
        statusCode = httpResponse.getStatusCode();
        responseBody = httpResponse.getBody();
        System.debug('@@ ACET_ORSWebservice: reopenIssue: statusCode: ' + statusCode);
        System.debug('@@ ACET_ORSWebservice: reopenIssue: responseBody: ' + responseBody);
        return responseBody;
    }

    public static Object createORSIssue(String requestBody) {
        Http h = new Http();
        HttpRequest httpRequest = new HttpRequest();
        HttpResponse httpResponse = new HttpResponse();
        String responseBody;
        Integer statusCode;
        Map < String, ACETOrgInstanceURLToOrgNameMap__c > OrgInstance2OrgNameMap = ACETOrgInstanceURLToOrgNameMap__c.getAll();
        String orgName = Test.isRunningTest() ? 'dev' : ACETUtility.GetOrgName(OrgInstance2OrgNameMap);
        //US3098067 - Vishnu
        //orgName=Test.isRunningTest() ?'dev':Organization_Properties__c.getInstance(UserInfo.getProfileId()).callProductionEndpoints__c?'qa':orgName;
        Map < String, ISL_Webservice_Config__c > islWebserviceData = ISL_Webservice_Config__c.getAll();
        String endPoint = islWebserviceData.get(orgName + '_ORSCreateIssueMicroService').Value__c;
        //String endPoint = 'https://gateway-stage.optum.com/api/STAGE/cdm/constmgmt/eaipxdomain-coui/issues/v1';
        httpRequest.setMethod('POST');
        httpRequest.setEndpoint(endPoint);
        httpRequest.setBody(requestBody);
        httpRequest.setHeader(CONTENT_TYPE, CONTENT_TYPE_VALUE);
        httpRequest.setHeader('actor', 'ACET');
        httpRequest.setTimeout(12000);
        httpRequest.setHeader('Authorization', BEARER + ISL_Webservice_Config__c.getInstance('SNIAPIAccessToken').Value__c);

        System.debug('@@ ACET_ORSWebservice: createORSIssue: requestBody: ' + requestBody);
        //httpResponse = h.send(httpRequest);

        ACET_WebserviceCalloutFramework wsCallOutFW = new ACET_WebserviceCalloutFramework();
		wsCallOutFW.serviceName = 'ORSCreateIssueMicroService';
		wsCallOutFW.requestBody = requestBody;
		wsCallOutFW.createLogFromWSF = false;
		httpResponse = wsCallOutFW.getResponse();

        // US2101461 - Thanish - 23rd Jun 2020 - Error Code Handling ...
        System.debug('@@ ACET_ORSWebservice: createORSIssue: statusCode: ' + httpResponse.getStatusCode());
        System.debug('@@ ACET_ORSWebservice: createORSIssue: responseBody: ' + httpResponse.getBody());

        //ORS Log Creation
        if(httpResponse.getStatusCode() != 200){
            String urlParameters='';
            if(endPoint!=null){
                urlParameters = '?' + endPoint.substringAfter('?');
                endPoint = endPoint.substringBefore('?');
            }
			for(ACET_WebserviceCalloutFramework.WebseviceLogDetails wsLogObj: ACET_WebserviceCalloutFramework.webseviceLogDetailsList){
            	wsLogObj.caseId = SAECaseCreationController.acetCaseId;
            }
            System.enqueueJob(new ACET_WebserviceCalloutFramework.CreateWSLogQueue(ACET_WebserviceCalloutFramework.webseviceLogDetailsList));
            //ACET_ORSWebservice.createAppErrorLog_ORS('ACET', 'ORSCreateIssueMicroService', endPoint, httpResponse.getStatus(), httpResponse.getStatusCode(), requestBody, httpResponse.getBody(), urlParameters);
        }

        return httpResponse;
    }

     //For Continuation framework
     public static Object createORSIssueRequest(String requestBody) {

                Http h = new Http();
                HttpRequest httpRequest = new HttpRequest();
                HttpResponse httpResponse = new HttpResponse();
                String responseBody;
                Integer statusCode;
                Map < String, ACETOrgInstanceURLToOrgNameMap__c > OrgInstance2OrgNameMap = ACETOrgInstanceURLToOrgNameMap__c.getAll();
                String orgName = Test.isRunningTest() ? 'dev' : ACETUtility.GetOrgName(OrgInstance2OrgNameMap);
                //US3098067 - Vishnu
                //orgName=Test.isRunningTest() ?'dev':Organization_Properties__c.getInstance(UserInfo.getProfileId()).callProductionEndpoints__c?'qa':orgName;
                Map < String, ISL_Webservice_Config__c > islWebserviceData = ISL_Webservice_Config__c.getAll();
                String endPoint = islWebserviceData.get(orgName + '_ORSCreateIssueMicroService').Value__c;
                //String endPoint = 'https://gateway-stage.optum.com/api/STAGE/cdm/constmgmt/eaipxdomain-coui/issues/v1';
                httpRequest.setMethod('POST');
                httpRequest.setEndpoint(endPoint);
                httpRequest.setBody(requestBody);
                httpRequest.setHeader(CONTENT_TYPE, CONTENT_TYPE_VALUE);
                httpRequest.setHeader('actor', 'ACET');
                httpRequest.setTimeout(12000);
                httpRequest.setHeader('Authorization', BEARER + ISL_Webservice_Config__c.getInstance('SNIAPIAccessToken').Value__c);

                System.debug('@@ ACET_ORSWebservice: createORSIssue: requestBody: ' + requestBody);
                //httpResponse = h.send(httpRequest);

                ACET_WebserviceCalloutFramework wsCallOutFW = new ACET_WebserviceCalloutFramework();



                wsCallOutFW.serviceName = 'ORSCreateIssueMicroService';
                wsCallOutFW.requestBody = requestBody;
                wsCallOutFW.createLogFromWSF = false;


                return wsCallOutFW.getHttpRequest();


    }

     public static Object createORSIssueResponse(HttpResponse httpResponse ) {


          // US2101461 - Thanish - 23rd Jun 2020 - Error Code Handling ...
        System.debug('@@ ACET_ORSWebservice: createORSIssue: statusCode: ' + httpResponse.getStatusCode());
        System.debug('@@ ACET_ORSWebservice: createORSIssue: responseBody: ' + httpResponse.getBody());

        //ORS Log Creation. Need to move this logic out to process asynchronously
        if(httpResponse.getStatusCode() != 200){

            String endpoint = '';
            String urlParameters='';
            if(endPoint!=null){
                urlParameters = '?' + endPoint.substringAfter('?');
                endPoint = endPoint.substringBefore('?');
            }
			for(ACET_WebserviceCalloutFramework.WebseviceLogDetails wsLogObj: ACET_WebserviceCalloutFramework.webseviceLogDetailsList){
            	wsLogObj.caseId = SAECaseCreationController.acetCaseId;
            }
            System.enqueueJob(new ACET_WebserviceCalloutFramework.CreateWSLogQueue(ACET_WebserviceCalloutFramework.webseviceLogDetailsList));
            //ACET_ORSWebservice.createAppErrorLog_ORS('ACET', 'ORSCreateIssueMicroService', endPoint, httpResponse.getStatus(), httpResponse.getStatusCode(), requestBody, httpResponse.getBody(), urlParameters);
        }

        return httpResponse;

     }

    //US2887985 - Tech: Create ORS Change to Microservice - Sravan
    public static Object updateORSIssue(String requestBody,String issueId) {
        Http h = new Http();
        HttpRequest httpRequest = new HttpRequest();
        HttpResponse httpResponse = new HttpResponse();
        String responseBody;
        Integer statusCode;
        Map < String, ACETOrgInstanceURLToOrgNameMap__c > OrgInstance2OrgNameMap = ACETOrgInstanceURLToOrgNameMap__c.getAll();
        String orgName = Test.isRunningTest() ? 'dev' : ACETUtility.GetOrgName(OrgInstance2OrgNameMap);
        //US3098067 - Vishnu
        //orgName=Test.isRunningTest() ?'dev':Organization_Properties__c.getInstance(UserInfo.getProfileId()).callProductionEndpoints__c?'qa':orgName;
        Map < String, ISL_Webservice_Config__c > islWebserviceData = ISL_Webservice_Config__c.getAll();
        String endPoint = islWebserviceData.get(orgName + '_ORSUpdateIssueMicroService').Value__c+'/'+issueId;
        httpRequest.setMethod('PUT');
        httpRequest.setEndpoint(endPoint);
        httpRequest.setBody(requestBody);
        httpRequest.setHeader(CONTENT_TYPE, CONTENT_TYPE_VALUE);
        httpRequest.setHeader('actor', 'ACET');
        httpRequest.setTimeout(12000);
        httpRequest.setHeader('Authorization', BEARER + ISL_Webservice_Config__c.getInstance('SNIAPIAccessToken').Value__c);

        System.debug('@@ ACET_ORSWebservice: updateORSIssue: requestBody: ' + requestBody);
        //httpResponse = h.send(httpRequest);
        ACET_WebserviceCalloutFramework wsCallOutFW = new ACET_WebserviceCalloutFramework();
        wsCallOutFW.serviceName = 'OrsUpdateIssueMicroService';
        wsCallOutFW.requestBody = requestBody;
        wsCallOutFW.endpointExtraPath = '/'+issueId;
        httpResponse = wsCallOutFW.getResponse();

        System.debug('@@ ACET_ORSWebservice: updateORSIssue: statusCode: ' + httpResponse.getStatusCode());
        System.debug('@@ ACET_ORSWebservice: updateORSIssue: responseBody: ' + httpResponse.getBody());

        //ORS Log Creation
        if(httpResponse.getStatusCode() != 200 && httpResponse.getStatusCode() != 201){ //DE391654 - Sravan
            String urlParameters='';
            if(endPoint!=null){
                urlParameters = '?' + endPoint.substringAfter('?');
                endPoint = endPoint.substringBefore('?');
            }
            //ACET_ORSWebservice.createAppErrorLog_ORS('ACET', 'ORSUpdateIssueMicroService', endPoint, httpResponse.getStatus(), httpResponse.getStatusCode(), requestBody, httpResponse.getBody(), urlParameters);
        }

        return httpResponse;
    }

    // Common Select Issues Method
    public static Object selectIssuesCommon(String requestBody)
    {
        Http h = new Http();
        HttpRequest httpRequest = new HttpRequest();
        HttpResponse httpResponse = new HttpResponse();
        String responseBody;
        Integer statusCode;

        Map < String, ACETOrgInstanceURLToOrgNameMap__c > OrgInstance2OrgNameMap = ACETOrgInstanceURLToOrgNameMap__c.getAll();
        String orgName = Test.isRunningTest() ? 'dev' : ACETUtility.GetOrgName(OrgInstance2OrgNameMap);
        //US3098067 - Vishnu
        //orgName=Test.isRunningTest() ?'dev':Organization_Properties__c.getInstance(UserInfo.getProfileId()).callProductionEndpoints__c?'qa':orgName;
        Map < String, ISL_Webservice_Config__c > islWebserviceData = ISL_Webservice_Config__c.getAll();
        String endPoint = islWebserviceData.get(orgName + '_ORSSelectIssue').Value__c;
        //String endPoint = 'https://gateway-stage.optum.com/api/STAGE/cdm/constmgmt/eaipxdomain-si/issues/v1/search';
        httpRequest.setMethod('POST');
        httpRequest.setEndpoint(endPoint);
        httpRequest.setBody(requestBody);
        httpRequest.setHeader(CONTENT_TYPE, CONTENT_TYPE_VALUE);
        httpRequest.setHeader('actor', 'ACET');
        httpRequest.setTimeout(12000);
        httpRequest.setHeader('Authorization', BEARER + ISL_Webservice_Config__c.getInstance('SNIAPIAccessToken').Value__c);

        // US2101461 - Thanish - 23rd Jun 2020 - Error Code Handling ...
        System.debug('@@ ACET_ORSWebservice: selectIssues: requestBody: ' + requestBody);
        //httpResponse = h.send(httpRequest);

        ACET_WebserviceCalloutFramework wsCallOutFW = new ACET_WebserviceCalloutFramework();
        wsCallOutFW.serviceName = 'ORSSelectIssue';
        wsCallOutFW.requestBody = requestBody;
        httpResponse = wsCallOutFW.getResponse();

        System.debug('@@ ACET_ORSWebservice: selectIssues: responseBody: ' + httpRequest.getBody());

        //ORS Log Creation
        if(httpResponse.getStatusCode() != 200){
            String urlParameters='';
            if(endPoint!=null){
                urlParameters = '?' + endPoint.substringAfter('?');
                endPoint = endPoint.substringBefore('?');
            }
            //ACET_ORSWebservice.createAppErrorLog_ORS('ACET', 'ORSSelectIssue', endPoint, httpResponse.getStatus(), httpResponse.getStatusCode(), requestBody, httpResponse.getBody(), urlParameters);
        }

        return httpResponse;
    }

    //ORS Log Creation
    @future
    public static void createAppErrorLog_ORS(string AppName, string servName, string endPoint, string respStatus, Integer respStatuscode, string reqBody,string resBody,String urlParameters){
        Application_Error_Log__c AppErrorLog = ACETUtility.CreateApplicationErrorLog(AppName, servName, endPoint, respStatus, respStatuscode);
        AppErrorLog.UrlParamaters__c=urlParameters;
        List<Attachment> AppErrorLogAtts = new List<Attachment>();
        AppErrorLogAtts.add(ACETUtility.CreateAttachment(null, 'ORS_Request', reqBody));
        AppErrorLogAtts.add(ACETUtility.CreateAttachment(null, 'ORS_Rsponse', resBody));
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

    public class selectIssueWrapper{
        @AuraEnabled public string OriginatorType {get;set;}
        @AuraEnabled public string CreatedDate{get;set;}
        @AuraEnabled public string ID{get;set;}
        @AuraEnabled public string IDType{get;set;}
        @AuraEnabled public string CaseNumber{get;set;}
        @AuraEnabled public string TopicReason{get;set;}
        @AuraEnabled public string Status{get;set;}
        @AuraEnabled public string recordID{get;set;}
        @AuraEnabled public string relationship{get;set;}
        //US2619021
        @AuraEnabled public Boolean isProvider{get;set;}
        @AuraEnabled public Boolean isSixMonths{get;set;}
        // US2667560 -  Sanka - ORS Family Filtering
        @AuraEnabled public string xRefIdORS{get;set;}
        // US2101464 - Thanish - 22nd Jun 2020 - Error handling ...
        @AuraEnabled public Integer responseStatus;
        @AuraEnabled public string responseStatusMessage;
        @AuraEnabled public Boolean moreData {get;set;}
        @AuraEnabled public string nextIssueKey {get;set;}
        @AuraEnabled public Integer recordCount {get;set;}
        // US3177995 - Thanish - 22nd Jun 2021
        @AuraEnabled public string purgedORSID{get;set;}
        @AuraEnabled public Boolean isEmptyPurgedORS {get;set;}

        public selectIssueWrapper(){
            this.isSixMonths = true; this.responseStatus = 200; this.responseStatusMessage = 'Success'; // US2101464 - Thanish - 22nd Jun 2020 - Error handling ...
        }
    }
    public class pagingState{
                public string moreData {get;set;}
                public string nextIssueKey {get;set;}
            }

    @AuraEnabled
    public static List<ACETGetCases.CaseWrapper> getRelatedCasesHistory(String taxMemberID, String xRefIdIndividual, Boolean toggleOnOff, String flowType){

        List<ACETGetCases.CaseWrapper> caseWrapperlst = new List<ACETGetCases.CaseWrapper>();
        caseWrapperlst = ACETGetCases.getRelatedCases(taxMemberID, xRefIdIndividual, toggleOnOff, flowType);
        return caseWrapperlst;
    }

    /**************************************
* @Method: fetchFACETCases
* @Return Type: wrapper ACET_FacetsWebservice.getFacetsResponse
* @Description:
* @parameters: subscriberId, providerId, inquiryId, offset
************************************** */
    @AuraEnabled
    public static list<selectIssueWrapper> fetchFACETCases(String subscriberId,String providerId,String inquiryId, Integer offset){
        list<selectIssueWrapper> lstResponseResult = new list<selectIssueWrapper>();
        ACET_FacetsWebservice.getFacetsResponse facetResponse = new ACET_FacetsWebservice.getFacetsResponse ();
        selectIssueWrapper objResponse = new selectIssueWrapper();
        facetResponse = ACET_FacetsWebservice.fetchFacetsCases(subscriberId,providerId,inquiryId,offset);
        // system.debug('### FACET Response==>:'+facetResponse);
        /*facetResponse = ACET_FacetsWebservice.fetchFacetsCases(subscriberId,providerId,inquiryId,offset);
StaticResource sr= [select id, body from StaticResource Where Name = 'ACET_FACETGetResponse'];
String allcontents = sr.body.toString();
//allcontents=JSON.serialize(allcontents);
system.debug('SR@@@ # '+ allcontents);
ACET_FacetsGetCasesResponse casesFacetsResponse = ACET_FacetsGetCasesResponse.parse(allcontents);*/
        system.debug('### FACET Response==>:'+facetResponse);
        if(facetResponse.responseStatus==200){
            //if(casesFacetsResponse!=null){
            Boolean nextPageInd = facetResponse.casesFacetsResponse.meta.nextPageInd;
            Integer recordCount = facetResponse.casesFacetsResponse.meta.limit_Z;
            //Integer recordCount = facetResponse.casesFacetsResponse.meta.limit_Z;
            for(ACET_FacetsGetCasesResponse.Data objRes: facetResponse.casesFacetsResponse.data){
                system.debug('### FACET Data==>:'+objRes);
                objResponse = new selectIssueWrapper();
                objResponse.ID=objRes.id;
                objResponse.IDType='FACETS';

                if(string.isNotBlank(objRes.attributes.tasks[0].inputDate)){
                    List<String> inputTimeList = objRes.attributes.tasks[0].inputDate.substring(11).split(':');
                    Date inputDate = date.valueOf(objRes.attributes.tasks[0].inputDate.substring(0,10));
                    DateTime myDateTime = DateTime.newInstance(inputDate.year(),
                                                               inputDate.month(),
                                                               inputDate.day(),
                                                               integer.valueOf(inputTimeList[0]),
                                                               integer.valueOf(inputTimeList[1]),
                                                               integer.valueOf(inputTimeList[2]));
                    String convertedOrgDateTime = myDateTime.format('MM/dd/yyyy hh:mm a');
                    objResponse.CreatedDate=convertedOrgDateTime;
                    //6 Months Filtering
                    Date beforeSixMonths = System.today().addMonths(-6);
                    Date dt = date.valueOf(inputDate);
                    objResponse.isSixMonths = beforeSixMonths < dt ? true : false;
                }

                objResponse.CaseNumber=string.isNotBlank(objRes.attributes.idNumber)?objRes.attributes.idNumber:'--';
                string categoryCode ='';
                string subjectCode ='';
                if(objRes.attributes.tasks[0].categoryCode!=null){
                    categoryCode = string.isNotBlank(objRes.attributes.tasks[0].categoryCode.desc_Z)?objRes.attributes.tasks[0].categoryCode.desc_Z:'--';
                }
                if(objRes.attributes.tasks[0].subjectCode!=null){
                    subjectCode = string.isNotBlank(objRes.attributes.tasks[0].subjectCode.desc_Z)?objRes.attributes.tasks[0].subjectCode.desc_Z:'--';
                }
                objResponse.TopicReason=categoryCode +'/'+subjectCode;
                // objResponse.TopicReason=objRes.attributes.tasks[0].categoryCode.desc_Z;
                string caseStatus = '';
                if(string.isNotBlank(objRes.attributes.tasks[0].statusCode.code)){
                    if(objRes.attributes.tasks[0].statusCode.code=='CL'){
                        caseStatus='Closed';
                    }else if(objRes.attributes.tasks[0].statusCode.code=='MD'){
                        caseStatus='Mis-Directed';
                    }else if(objRes.attributes.tasks[0].statusCode.code=='OP'){
                        caseStatus='Open';
                    }else if(objRes.attributes.tasks[0].statusCode.code=='PE'){
                        caseStatus='Pending';
                    }else if(objRes.attributes.tasks[0].statusCode.code=='RT'){
                        caseStatus='Routed';
                    }
                }else{
                    caseStatus='--';
                }
                objResponse.Status=caseStatus;
                String SubjectName = String.isNotBlank(objRes.attributes.callerName.firstName) ? objRes.attributes.callerName.firstName +' '+ (String.isNotBlank(objRes.attributes.callerName.lastName) ? objRes.attributes.callerName.lastName : '') : '--';

                String relsnsp = '';
                if(String.isNotBlank(objRes.attributes.relationship)){
                    if(objRes.attributes.relationship == 'D'){
                        relsnsp = 'Daughter';
                    }else if(objRes.attributes.relationship == 'H'){
                        relsnsp = 'Husband';
                    }else if(objRes.attributes.relationship == 'M'){
                        relsnsp = 'Subscriber';
                    }else if(objRes.attributes.relationship == 'O'){
                        relsnsp = 'Other';
                    }else if(objRes.attributes.relationship == 'S'){
                        relsnsp = 'Son';
                    }else if(objRes.attributes.relationship == 'W'){
                        relsnsp = 'Wife';
                    }else{
                        relsnsp ='--';
                    }

                }else{
                    relsnsp ='--';
                }
                objResponse.relationship= SubjectName +' '+'/'+' '+relsnsp;
                objResponse.moreData=nextPageInd;
                objResponse.recordCount=recordCount;
                objResponse.OriginatorType=objRes.attributes.callerType.desc_Z;
                objResponse.isProvider = objResponse.OriginatorType == 'Provider' ? true : false;
                lstResponseResult.add(objResponse);
            }
        }else{
            selectIssueWrapper objErrorResponse = new selectIssueWrapper();
            objErrorResponse.responseStatusMessage =facetResponse.responseStatusMessage;
            objErrorResponse.responseStatus = facetResponse.responseStatus;
            lstResponseResult.add(objErrorResponse);
        }

        return lstResponseResult;
    }

    //create Tops request body
    public static string getTopsRequestBody(String userId, String password) {
        String RequestBody = '';
        ACET_LoginFlowCtrl.TopsSourceSystemParameters topsParams = new ACET_LoginFlowCtrl.TopsSourceSystemParameters();
        topsParams.userId = userId;
        topsParams.userPassword = password;

        ACET_LoginFlowCtrl.ControlModifiers cm = new ACET_LoginFlowCtrl.ControlModifiers();
        cm.topsSourceSystemParameters = topsParams;

        List < ACET_LoginFlowCtrl.ControlModifiers > ctrlModifiersList = new List < ACET_LoginFlowCtrl.ControlModifiers > ();
        ctrlModifiersList.add(cm);

        ACET_LoginFlowCtrl.PostInput postInput = new ACET_LoginFlowCtrl.PostInput();
        postInput.controlModifiers = ctrlModifiersList;
        postInput.getOrsProfile = 'true';
        postInput.getTOPSToken = 'true';
        postInput.validateTOPSCredentials = 'true';
        postInput.encryptionIndicatorTOPS = 'true';
        RequestBody = JSON.serialize(postInput);
        RequestBody = '{"postInput":' + RequestBody + '}';
        return RequestBody;
        //System.debug('###REQUEST-BODY:' + RequestBody);
    }

    //Refresh Tops Cache
    public static void refreshTopsCache() {

        System.debug(' Validate Tops ');
        Login_Flow_Configs__c loginFlowConfigs = Login_Flow_Configs__c.getInstance(UserInfo.getUserId());
        List<String> businessGroupsList = new List<String>();
        PageReference pageRef = ApexPages.currentPage();
        System.debug(' Validate Tops ' + loginFlowConfigs.SkipLoginFlow__c);
        if (loginFlowConfigs != null && loginFlowConfigs.SkipLoginFlow__c) {
            Cache.Session.put('local.TOPSProfileInfo.userId', loginFlowConfigs.AgentId__c + '/' + loginFlowConfigs.OfficeId__c, 28800, Cache.Visibility.ALL, true);
            if (loginFlowConfigs.BusinessGroups__c != null) {
                businessGroupsList.addAll(loginFlowConfigs.BusinessGroups__c.split(','));
            }
            Cache.Session.put('local.TOPSProfileInfo.businessGroups', businessGroupsList, 28800, Cache.Visibility.ALL, true);
        }else{

            List<Per_User_Credentials__c> lstPerUserCredentials = [SELECT Id, UserName__c, Password__c FROM Per_User_Credentials__c WHERE User__c =: UserInfo.getUserId()];
            String strRequestBody = getTopsRequestBody(lstPerUserCredentials[0].UserName__c, lstPerUserCredentials[0].Password__c);
            //String Intialisers
            String responseBody = '';
            Integer statusCode ;
            //Response Intialiser
            HttpResponse response = null;
            if(!lstPerUserCredentials.isEmpty() && String.isNotBlank(strRequestBody)) {
                ACET_WebserviceCalloutFramework wsCallOutFW = new ACET_WebserviceCalloutFramework();
                wsCallOutFW.serviceName = 'ORSEAIPToken';
                wsCallOutFW.requestBody = strRequestBody;
                response = wsCallOutFW.getResponse();
                responseBody = response.getBody();
                statusCode = response.getStatusCode();
                if (statusCode == 200) {
                    if (String.isNotBlank(responseBody) && responseBody.containsIgnoreCase('userProfile')) {
                        ACET_PerUserCredentialResultWrapper loginData = ACET_PerUserCredentialResultWrapper.parse(responseBody);
                        System.debug('@@@ user Id ' + loginData.PostResult.userProfile.userId);
                        System.debug('@@@ Business Group ' + loginData.PostResult.userProfile.businessGroups);
                        Cache.Session.put('local.TOPSProfileInfo.userId', loginData.PostResult.userProfile.userId, 28800, Cache.Visibility.ALL, true);
                        Cache.Session.put('local.TOPSProfileInfo.businessGroups', loginData.PostResult.userProfile.businessGroups, 28800, Cache.Visibility.ALL, true);
                    }
                }
            }
        }
    }

    // US3177995 - Thanish - 22nd Jun 2021
    @AuraEnabled
    public static ACET_SAECalloutResult getPurgedORSRecords(String searchId){
        List<selectIssueWrapper> retList = new List<selectIssueWrapper>();
        ACET_SAECalloutResult result = ACET_DocThreeSixtyService.searchDocuments(searchId, true);
        List<ACET_DocThreeSixtyService.PurgedORS> purgedRecords = (List<ACET_DocThreeSixtyService.PurgedORS>) result.response;

        if(result.isSuccess && (purgedRecords.size() > 0)){
            for(ACET_DocThreeSixtyService.PurgedORS purgedRecord : purgedRecords){
                selectIssueWrapper record = new selectIssueWrapper();
                record.OriginatorType = '--';
                record.CreatedDate = purgedRecord.dateTimeVal;
                record.relationship = 'Member in Session';
                record.ID = purgedRecord.externalId;
                record.purgedORSID = purgedRecord.objectId;
                record.IDType = purgedRecord.idType;
                record.CaseNumber = '--';
                record.TopicReason = '--';
                record.Status = '--';
                record.isEmptyPurgedORS = false;
                retList.add(record);
            }
            result.response = retList;
        } else{
            selectIssueWrapper emptyRec = new selectIssueWrapper();
            emptyRec.isEmptyPurgedORS = true; emptyRec.relationship = 'No Additional Matching Case History Results Found'; emptyRec.IDType = 'Purged ORS';
            retList.add(emptyRec);
            result.response = retList;
        }
        return result;
    }
}