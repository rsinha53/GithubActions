public with sharing class ACET_FacetsWebservice extends ACETWebservice {
    
    public static String strCaseId;
    private String endpointType;
    
    public static Object ProcessFacetsRecord(String strRecord, String caseId) {
        
        String strCodeType = '', strType = '', strSubType = '', strReturnType = '';
        
        try {
            
            List<User> lstUsers = new List<User>();
            lstUsers = [Select id,FederationIdentifier from User Where Id=:Userinfo.getUserId()];
            
            strCaseId = caseId;
            
            ACET_FACETSServiceRequest.customerServiceRecord objCustomerServiceRecord = new ACET_FACETSServiceRequest.CustomerServiceRecord();
            ACET_FACETSServiceRequest.CallerType objCallerType = new ACET_FACETSServiceRequest.CallerType();
            ACET_FACETSServiceRequest.CallerName objCallerName = new ACET_FACETSServiceRequest.CallerName();
            ACET_FACETSServiceRequest.ContactInfo objContactInfo = new ACET_FACETSServiceRequest.ContactInfo();
            ACET_FACETSServiceRequest.Tasks objTasks = new ACET_FACETSServiceRequest.Tasks();
            ACET_FACETSServiceRequest.CodeDesc objCodeDesc = new ACET_FACETSServiceRequest.CodeDesc();
            Map < String, String > mapProviderMember = new Map < String, String > {'P' => 'Provider','M' => 'Member', 'N' => 'Non-Member'};
                
            List < Case > lstCases = new List < Case > ();
            lstCases = [Select id, Originator_Relationship__c, CaseNumber, Status, ID__c from Case where id =: caseId];
            system.debug('### objCaseWrapper ==>:'+strRecord);
            SAETTSCaseWrapper objCaseWrapper = (SAETTSCaseWrapper) JSON.deserialize(strRecord, SAETTSCaseWrapper.class);
            system.debug('### objCaseWrapper ==>:'+objCaseWrapper);
            List < Interaction__c > lstInteractions = new List < Interaction__c > ();
            lstInteractions = [Select id, Interaction_Type__c from Interaction__c Where id =: objCaseWrapper.Interaction];
            
            List < SAE_FACETS_MACESS__mdt > lstFacetsMdt = new List < SAE_FACETS_MACESS__mdt > ();
            
            //if Case Wrapper is null return
            if (objCaseWrapper == null || String.isBlank(caseId)) {
                return '';
            }
            
           
            // Is Other Search 
            if (objCaseWrapper.isOtherSearch == true && String.isNotBlank(objCaseWrapper.OtherOrginatorType)) {
                strCodeType = objCaseWrapper.OtherOrginatorType;
                objTasks.providerId = 'UNKNOWN'; //US2951245 - Sravan
            }
            // Is Member
            else if (objCaseWrapper.noProviderToSearch == true || objCaseWrapper.providerNotFound == true){//US2951245 - Sravan
                strCodeType = 'Member';
                objTasks.providerId = 'UNKNOWN'; //US2951245 - Sravan

            }
            //Is Provider
            else if (objCaseWrapper.noProviderToSearch == false && (objCaseWrapper.isOtherSearch == null || objCaseWrapper.isOtherSearch == false) && objCaseWrapper.providerNotFound == false) { //US2951245 - Sravan
                strCodeType = 'Provider';
                // get c and s contract data from api
               // system.debug('### strAddressID==>:'+objCaseWrapper.strAddressID+'### plProviderID==>:'+'### plTaxId==>:'+objCaseWrapper.plTaxId);
                //if(String.isNotBlank(objCaseWrapper.strAddressID) && String.isNotBlank(objCaseWrapper.plProviderID) && String.isNotBlank(objCaseWrapper.plTaxId)){
                    ACET_ProviderContractService providerContractService = new ACET_ProviderContractService();
                    ACETWSCalloutResult calloutResult = providerContractService.getCAndSContracts(objCaseWrapper.plProviderID, objCaseWrapper.plTaxId, objCaseWrapper.strAddressID, false); 
                    if(calloutResult.Success) {
                         // cast callout result to c and s contract response
                         ACET_CAndSContractsResponse contractResponse = (ACET_CAndSContractsResponse) calloutResult.Response;
                         system.debug('### contractResponse==>:'+contractResponse);
                          if(contractResponse != null){
                              if(contractResponse.communityandstate != null && !contractResponse.communityandstate.isEmpty()){
                          for(ACET_CAndSContractsResponse.Communityandstate communityAndState : contractResponse.communityandstate) {
                              if(string.isNotBlank(communityAndState.csp_pltfm_prov_id) ){
                                  objTasks.providerId=communityAndState.csp_pltfm_prov_id;
                                  break;
                              }
                              else{
                                objTasks.providerId = 'UNKNOWN'; //US2951245 - Sravan
                              }

                          }
                        }
                        else{
                            objTasks.providerId = 'UNKNOWN'; //US2951245 - Sravan
                        }

                        }
                        else{
                            objTasks.providerId = 'UNKNOWN'; //US2951245 - Sravan
                          }
                    }
               // }
                
            }
            else if(objCaseWrapper.noProviderToSearch == true || objCaseWrapper.isOtherSearch == true || objCaseWrapper.mnf == 'mnf'){//US2951245 - Sravan
                system.debug('Entered Member Not Found Condition');
                objTasks.providerId = 'UNKNOWN';
            }

            List < ACET_FACETS_Codes__mdt > lstFacetsCodeType = new List < ACET_FACETS_Codes__mdt > ();
            lstFacetsCodeType = [select id, ACET_Input__c, FACETS_Code__c, category__c from ACET_FACETS_Codes__mdt WHERE ACET_Input__c =: strCodeType AND category__c = 'callerType'];
            if (lstFacetsCodeType.isEmpty() == false) {
                objCallerType.code = lstFacetsCodeType[0].FACETS_Code__c;
            }
            objCustomerServiceRecord.callerType = objCallerType;
            
            //Refresh Caller Type Instance variable for future use.
            if(lstInteractions.isEmpty() == false) {
                objCallerType = new ACET_FACETSServiceRequest.CallerType();
                lstFacetsCodeType = [select id, ACET_Input__c, FACETS_Code__c, category__c from ACET_FACETS_Codes__mdt WHERE ACET_Input__c =: lstInteractions[0].Interaction_Type__c AND category__c = 'inquiryMethod'];
                if (lstFacetsCodeType.isEmpty() == false) {
                    objCallerType.code = lstFacetsCodeType[0].FACETS_Code__c;
                }
                objCustomerServiceRecord.inquiryMethod = objCallerType;
            }
            
            string OriginatorFirstName = '';
            string OriginatorLastName = '';
            if (String.isNotBlank(objCaseWrapper.OriginatorContactName)) {
                List < String > fullName = new List < String > ();
                fullName = objCaseWrapper.OriginatorContactName.split(' ');
                if (fullName.Size() > 1) {
                    OriginatorFirstName = fullName[0];
                    OriginatorLastName = fullName[1];
                }
                else if(fullName.Size() ==  1 ){
                   OriginatorFirstName = fullName[0];
                   OriginatorLastName = fullName[0]; 
                }
            }
            
            //CallerName Key Instance 
            objCallerName = new ACET_FACETSServiceRequest.CallerName();
            if (String.isNotBlank(objCaseWrapper.OriginatorFirstName) == true) {
                objCallerName.firstName = objCaseWrapper.OriginatorFirstName;
            }
            else if(string.isNotBlank(OriginatorFirstName)){
                objCallerName.firstName = OriginatorFirstName;
            }
            
            if (String.isNotBlank(objCaseWrapper.OriginatorLastName) == true) {
                objCallerName.lastName = objCaseWrapper.OriginatorLastName;
            }
            else if(string.isNotBlank(OriginatorLastName)){
                objCallerName.lastName = OriginatorLastName;
            }
            //Assign Back Caller Details
            objCustomerServiceRecord.callerName = objCallerName;
            
            if (String.isNotBlank(objCaseWrapper.contactNumber) == true) {
                objContactInfo.phone = objCaseWrapper.contactNumber;
            }
            
            if (String.isNotBlank(objCaseWrapper.contactExt) == true) {
                objContactInfo.phoneExt = objCaseWrapper.contactExt;
            }
            //Assign Contact Info to Parent Contact Info Instance
            objCustomerServiceRecord.contactInfo = objContactInfo;
            
            if (String.isNotBlank(objCaseWrapper.strMemberId) == true) {
                objTasks.customerId = objCaseWrapper.strMemberId;
            }
            
            if (String.isNotBlank(objCaseWrapper.ttsType) == true && String.isNotBlank(objCaseWrapper.ttsSubType) == true && String.isNotBlank(objCaseWrapper.AddInfoTopic) == true) {
                lstFacetsMdt = [select id, Type__c, Topic__c, Subtype__c, FACETS_Subject_Code__c, FACETS_Subject__c, FACETS_Category_Code__c, FACETS_Category__c from SAE_FACETS_MACESS__mdt Where Topic__c =: objCaseWrapper.AddInfoTopic AND
                                Type__c =: objCaseWrapper.ttsType AND Subtype__c =: objCaseWrapper.ttsSubType];
            }
            
            if (lstFacetsMdt.isEmpty() == false) {
                objCodeDesc.code = lstFacetsMdt[0].FACETS_Subject_Code__c;
                objCodeDesc.description = lstFacetsMdt[0].FACETS_Subject__c;
            }
            
            objTasks.subjectCode = objCodeDesc;
            
            objCodeDesc = new ACET_FACETSServiceRequest.CodeDesc();
            if (lstFacetsMdt.isEmpty() == false) {
                objCodeDesc.code = lstFacetsMdt[0].FACETS_Category_Code__c;
                objCodeDesc.description = lstFacetsMdt[0].FACETS_Category__c;
            }
            objTasks.categoryCode = objCodeDesc;
            
            String strCustomerType = '', strCustomerCode = '';
            
            if (objCaseWrapper.noProviderToSearch == false && objCaseWrapper.isOtherSearch == false && objCaseWrapper.isOtherSearch == false && String.isBlank(objCaseWrapper.OriginatorType) && objCaseWrapper.OriginatorType == 'Provider') {
                strCustomerCode = 'P';
            } else if(objCaseWrapper.mnf != 'mnf'){
                strCustomerCode = 'M';
            }
			else{
				strCustomerCode = 'N';
			}

            objCodeDesc = new ACET_FACETSServiceRequest.CodeDesc();
            objCodeDesc.code = strCustomerCode;
            objCodeDesc.description = mapProviderMember.get(strCustomerCode);
            
            objTasks.customerType = objCodeDesc;
            
            strCustomerCode = (strCustomerCode == 'M' ? 'P' : (strCustomerCode == 'P' ? 'M' : ''));
            
            objCodeDesc = new ACET_FACETSServiceRequest.CodeDesc();
            objCodeDesc.code = strCustomerCode;
            objCodeDesc.description = mapProviderMember.get(strCustomerCode);
            
            objTasks.subjectType = objCodeDesc;
            
            objCodeDesc = new ACET_FACETSServiceRequest.CodeDesc();
            objCodeDesc.code = '1';
            objCodeDesc.description = 'Low';
            objTasks.priorityCode = objCodeDesc;
            
            //Status Reason Code These are static values for FACETS
            objCodeDesc = new ACET_FACETSServiceRequest.CodeDesc();
            objCodeDesc.code = 'CL01';
            objCodeDesc.description = 'Completed Call';
            if(objCaseWrapper.ttsType  == 'Issue Routed'){
                objCodeDesc.code = 'CL02';
                objCodeDesc.description = 'Completed Route';
            }
            objTasks.statusReasonCode = objCodeDesc;
            
            lstFacetsCodeType = new List < ACET_FACETS_Codes__mdt > ();
            if (String.isNotBlank(lstCases[0].status) == true) {
                lstFacetsCodeType = [select id, ACET_Input__c, FACETS_Code__c, category__c from ACET_FACETS_Codes__mdt WHERE ACET_Input__c = 'Closed' AND category__c = 'CaseStatus'];
            }
            
            System.debug('@@@@@@@ Facet Codes ' + lstFacetsCodeType);
            objCodeDesc = new ACET_FACETSServiceRequest.CodeDesc();
            if (lstFacetsCodeType.isEmpty() == false) {
                objCodeDesc.code = lstFacetsCodeType[0].FACETS_Code__c;
                objCodeDesc.description = lstFacetsCodeType[0].ACET_Input__c;
                objTasks.statusCode = objCodeDesc;
            }
            
            if(lstUsers.isEmpty() == false) {
                objTasks.primaryUserId = lstUsers[0].FederationIdentifier;
            }
            
            if (String.isNotBlank(objCaseWrapper.strFacetsRoutingComments) == true) {
                objTasks.summaryText = 'FACETS ID created for ACET Case Number ' + lstCases[0].CaseNumber + ' ' +  objCaseWrapper.strFacetsRoutingComments + ' created'+'\n'+objCaseWrapper.relatedCaseItems;//US3146746 - Sravan
            } else {
                objTasks.summaryText = 'FACETS ID created for ACET Case Number ' + lstCases[0].CaseNumber+'\n'+ objCaseWrapper.relatedCaseItems;//US3146746 - Sravan
            }
            
            if (lstCases.isEmpty() == false && String.isNotBlank(lstCases[0].ID__c) == true &&  objCaseWrapper.mnf != 'mnf') {//US2951245 - Sravan
                objTasks.subscriberId = lstCases[0].ID__c;//101512675
            }
            
            objCustomerServiceRecord.tasks = new List < ACET_FACETSServiceRequest.Tasks > {objTasks};
                
                if (lstCases.isEmpty() == false) {
                    if (String.isNotBlank(lstCases[0].Originator_Relationship__c) == true) {
                        objCustomerServiceRecord.relationship = lstCases[0].Originator_Relationship__c;
                    }
                    objCustomerServiceRecord.idNumber = lstCases[0].CaseNumber;
                }
            
            ACET_FACETSServiceRequest objRequest = new ACET_FACETSServiceRequest(objCustomerServiceRecord);
            
            String strRequest = JSON.serialize(objRequest);
            
            //Replace description key word with desc
            strRequest = strRequest.replaceAll('description','desc');
            
            //Replace contactType key word with Type
            strRequest = strRequest.replaceAll('contactType','type');
            
            system.debug(' @@@ strRequest '+strRequest);
            

            //US3182780
            //object objResponse = ACET_FacetsWebservice.createFacetsRecord(strRequest);
            object objResponse;
            if(string.isNotBlank(objCaseWrapper.SubjectGroupId) && (!objCaseWrapper.SubjectGroupId.contains('ONEX') && !objCaseWrapper.SubjectGroupId.contains('OFEX') ) && objCaseWrapper.ttsType  == 'Issue Routed'){

                objResponse = ACET_FacetsWebservice.createFacetsRecord(strRequest,true,strRecord);
            }
            else{
                 objResponse = ACET_FacetsWebservice.createFacetsRecord(strRequest,false,strRecord);
            }
            
            strReturnType = JSON.serialize(objResponse); 
            
            System.debug(' @@@ strReturnType ' + strReturnType);
            
            return strReturnType;
            
        } catch(exception objException) {
            return objException;
        }
    }
    
    /*public static Object createFacetsRecord(String requestBody) {
        try {    
            FacetsResponse objFacetsResponse = null;*/
           /* Http h = new Http();
            HttpRequest httpRequest = new HttpRequest();
            HttpResponse httpResponse = new HttpResponse();
            String responseBody;
            Integer statusCode;
            Map < String, ACETOrgInstanceURLToOrgNameMap__c > OrgInstance2OrgNameMap = ACETOrgInstanceURLToOrgNameMap__c.getAll();
            String orgName = Test.isRunningTest() ? 'dev' : ACETUtility.GetOrgName(OrgInstance2OrgNameMap);
            Map < String, ISL_Webservice_Config__c > islWebserviceData = ISL_Webservice_Config__c.getAll();
            String endPoint = islWebserviceData.get(orgName + '_FacetsCreateRecord').Value__c;
            httpRequest.setMethod('POST');
            httpRequest.setEndpoint(endPoint);
            httpRequest.setBody(requestBody);
            httpRequest.setHeader('Content-Type', 'application/json');
            httpRequest.setHeader('client-code', 'ACET');
            httpRequest.setTimeout(12000);
            httpRequest.setHeader('Authorization', 'Bearer ' + ISL_Webservice_Config__c.getInstance('SNIAPIAccessToken').Value__c);
            httpResponse = h.send(httpRequest);*/
            /*HttpResponse httpResponse = new HttpResponse();
            ACET_WebserviceCalloutFramework wsCallOutFW = new ACET_WebserviceCalloutFramework();
            wsCallOutFW.serviceName = 'FacetsCreateRecord';	
            wsCallOutFW.requestBody = requestBody;	
            httpResponse = wsCallOutFW.getResponse();*/
            
             //ACET_ORSWebservice.createAppErrorLog_ORS('ACET', 'FACETSCaseCreationsuccess==>', endPoint, httpResponse.getStatus(), httpResponse.getStatusCode(), requestBody, httpResponse.getBody(), 'urlParameters');
            //system.debug('facets response ==> '+JSON.deserializeUntyped(httpResponse.getBody()));
            /*if(httpResponse.getStatusCode() == 201) {
                Map<String,Object> mapResponse = (Map<String,Object>)(JSON.deserializeUntyped(httpResponse.getBody()));
                Object objResponse = (object)mapResponse.get('data');
                String strResponse = JSON.serialize(objResponse);
                Map<String,Object> mapResponseData = (Map<String,Object>)(JSON.deserializeUntyped(strResponse));
                
                if(String.isNotBlank(strCaseId) == true) {
                    List<Case> caseRecord = [Select Id,Facets_Issue_ID__c from Case where Id =: strCaseId];
                    if(caseRecord != null && !caseRecord.isEmpty()){
                       Case updateCase = new Case(Id = caseRecord[0].Id);
                       if(String.isBlank(caseRecord[0].Facets_Issue_ID__c)){
                           updateCase.Facets_Issue_ID__c =  (String)mapResponseData.get('id');   
                       }
                       else{
                           updateCase.Facets_Issue_ID__c = caseRecord[0].Facets_Issue_ID__c+','+(String)mapResponseData.get('id');
                       }
                       upsert updateCase;
                    
                    }

                }
                objFacetsResponse = new FacetsResponse(true, 'Success FACETS Case Created',null);
            } else if(httpResponse.getStatusCode() == 500) { 
                objFacetsResponse = new FacetsResponse(false, 'FACETS Case Creation Failed ',null);
            } else {
                if(httpResponse.getHeader('Content-Type').contains('html')){
                    objFacetsResponse = new FacetsResponse(false, 'Service unavailable ',null);
                }else{
                    Map<String,Object> mapResponse = (Map<String,Object>)(JSON.deserializeUntyped(httpResponse.getBody()));
                    List<object> objResponse = (List<object>)mapResponse.get('errors');
                    String strResponse = JSON.serialize(objResponse[0]);
                    Map<String,Object> mapActualResponse = (Map<String,Object>)(JSON.deserializeUntyped(strResponse));
                    objFacetsResponse = new FacetsResponse(false, (String)mapActualResponse.get('detail'),null);
                }
                
            }*/
            /*if(httpResponse.getStatusCode() != 201){
                String urlParameters='';
                if(endPoint!=null){
                    urlParameters = '?' + endPoint.substringAfter('?');
                    endPoint = endPoint.substringBefore('?');
                }
                //ACET_ORSWebservice.createAppErrorLog_ORS('ACET', 'FACETSCaseCreation', endPoint, httpResponse.getStatus(), httpResponse.getStatusCode(), requestBody, httpResponse.getBody(), urlParameters);
            }*/
           /* return objFacetsResponse;
        } catch (exception objException) {
            return objException;
        }
    }*/
    //US3182780
    public static Object createFacetsRecord(String requestBody, boolean callMacess,string strRecord) {
        try {
            system.debug('==in createFacetsRecord');
            FacetsResponse objFacetsResponse = null;

            HttpResponse httpResponse = new HttpResponse();
            ACET_WebserviceCalloutFramework wsCallOutFW = new ACET_WebserviceCalloutFramework();
            wsCallOutFW.serviceName = 'FacetsCreateRecord';
            wsCallOutFW.requestBody = requestBody;
            httpResponse = wsCallOutFW.getResponse();

            if(httpResponse.getStatusCode() == 201) {
                Map<String,Object> mapResponse = (Map<String,Object>)(JSON.deserializeUntyped(httpResponse.getBody()));
                Object objResponse = (object)mapResponse.get('data');
                String strResponse = JSON.serialize(objResponse);
                Map<String,Object> mapResponseData = (Map<String,Object>)(JSON.deserializeUntyped(strResponse));
                string facetsNumber =  mapResponseData.get('id') != NULL ? (String)mapResponseData.get('id') : '';

                if(callMacess && string.isNotBlank(facetsNumber)){

                    objFacetsResponse = callMacess(strRecord,facetsNumber,strCaseId);

                }
                else{
                    if(String.isNotBlank(strCaseId) == true) {
                         ACET_MACESSWebService.updateSFCase(strCaseId,facetsNumber,'');

                    }
                    objFacetsResponse = new FacetsResponse(true, 'Success FACETS Case Created',null);
                }
            } else if(httpResponse.getStatusCode() == 500) {
                objFacetsResponse = new FacetsResponse(false, 'FACETS Case Creation Failed ',null);
            } else {
                if(httpResponse.getHeader('Content-Type').contains('html')){
                    objFacetsResponse = new FacetsResponse(false, 'Service unavailable ',null);
                }else{
                    Map<String,Object> mapResponse = (Map<String,Object>)(JSON.deserializeUntyped(httpResponse.getBody()));
                    List<object> objResponse = (List<object>)mapResponse.get('errors');
                    String strResponse = JSON.serialize(objResponse[0]);
                    Map<String,Object> mapActualResponse = (Map<String,Object>)(JSON.deserializeUntyped(strResponse));
                    objFacetsResponse = new FacetsResponse(false, (String)mapActualResponse.get('detail'),null);
                }

            }
            return objFacetsResponse;
        } catch (exception objException) {
            return objException;
        }
    }
    //US3182780
    public static FacetsResponse callMacess(string strRecord,string facetsNumber,string strCaseId){
        system.debug('==in callMacess');
        FacetsResponse objFacetsResponse = null;
        string macessReq = ACET_MACESSWebService.frameRequest(strRecord,facetsNumber,strCaseId);
        system.debug('==macessReq is '+macessReq);
        ACET_SAECalloutResult macessResp = ACET_MACESSWebService.createMACESSCase(macessReq,strCaseId,facetsNumber);
        system.debug('=macessResp='+macessResp);
        if(macessResp.isSuccess){
            objFacetsResponse = new FacetsResponse(true, 'Success FACETS and MACESS Case Created',null);
        }
        else{
            system.debug('==at 387');
            if(String.isNotBlank(strCaseId) == true) {
                ACET_MACESSWebService.updateSFCase(strCaseId,facetsNumber,'');

            }

            objFacetsResponse = new FacetsResponse(true, 'Success FACETS Case Created but MACESS Case Not Created due to Error Code: '+ macessResp.statuscode + ' AND Error Description: '+ macessResp.message ,null);

        }
        return objFacetsResponse;
    }

    public static getFacetsResponse fetchFacetsCases(String subscriberId,String providerId,String inquiryId, Integer offset) {
        system.debug('fetchFacetsCases');
        FacetsResponse getResponse = null;
        String requestBody;
        Integer statusCode;
        String responseBody;
        getFacetsResponse responseResult = new getFacetsResponse();
        facetsGetCasesRequest inputReq = new facetsGetCasesRequest();
        map<String,Object> responseMap = new map<String,Object>();
        
        inputReq.subscriberId = string.isNotBlank(subscriberId) ? subscriberId : '';
        inputReq.providerId= string.isNotBlank(providerId) ? providerId : '';
        inputReq.inquiryId=string.isNotBlank(inquiryId) ? inquiryId : '';
        inputReq.sortBy='D';
        inputReq.offset=offset;
        //inputReq.limit_Z=2;
         
        requestBody = JSON.serialize(inputReq);
        requestBody = requestBody.replace('limit_Z', 'limit');
        system.debug('==Outer request '+requestBody);
        httpResponse responseStr = (httpResponse)fetchFacetsRecord(requestBody);
        statusCode = responseStr.getStatusCode();
        responseBody = responseStr.getBody();
        List<ACET_FacetsGetCasesResponse.Data> lstofAlldata = new List<ACET_FacetsGetCasesResponse.Data>();
        if(statusCode == 200){
            if(string.isNotBlank(responseBody)){
                ACET_FacetsGetCasesResponse casesFacetsResponse = ACET_FacetsGetCasesResponse.parse(responseStr.getBody());
                system.debug('=casesFacetsResponse='+casesFacetsResponse);
                //getResponse = new FacetsResponse(false, 'Sucess',casesFacetsResponse);
                responseResult.casesFacetsResponse = casesFacetsResponse;
                responseResult.responseStatus = statusCode;
                responseResult.responseStatusMessage = 'Success';
            }
        }else{
            responseMap.put('Success',false);
            responseMap.put('statusCode',statusCode);
            //Error handling
            //getFacetsResponse errorWrapper = new getFacetsResponse();
            /*if(statusCode==400){
                responseResult.responseStatus = statusCode;
                responseResult.responseStatusMessage = 'Unexpected error occurred while retrieving Facets details. Please try again. If problem persists contact help desk.';
            } else if(statusCode==404){
                responseResult.responseStatus = statusCode;
                responseResult.responseStatusMessage = 'No Facets Results Found';
            } else if(statusCode==500){
                responseResult.responseStatus = statusCode;
                responseResult.responseStatusMessage = 'Unexpected error occurred while retrieving Facets details. Please try again. If problem persists contact help desk.';
            } else {
                responseResult.responseStatus = statusCode;
                responseResult.responseStatusMessage = 'Unexpected error while retrieving Facets details! Error Code: ' + String.valueOf(statusCode);
            }*/
            responseResult.responseStatus = statusCode;
            responseResult.responseStatusMessage = 'Unexpected Error Occurred in the Case History�card. Please try again. If problem persists please contact the help desk.';
            //respToReturn.add(errorWrapper);
            
        }
        
        return responseResult;
    }
    
    /*public static string getFacetsCases(String subscriberId,String providerId,String inquiryId) {
        
        string facetsResponse ='';
        String requestBody;
        facetsGetCasesRequest searchInputProv = new facetsGetCasesRequest();
        
        searchInputProv.subscriberId =subscriberId;
        searchInputProv.inquiryId=inquiryId;
        searchInputProv.sortBy='D';
        searchInputProv.offset=1;
        searchInputProv.limit_Z=50;
         
        requestBody = JSON.serialize(searchInputProv);
        requestBody = requestBody.replace('limit_Z', 'limit');
        system.debug('==Outer request '+requestBody);
        httpResponse responseStr = (httpResponse)fetchFacetsRecord(requestBody);
         List<ACET_FacetsGetCasesResponse.Data> lstofAlldata = new List<ACET_FacetsGetCasesResponse.Data>();
        if(responseStr != null){
            if(responseStr.getStatusCode() == 200){
                Boolean calloutNeeded = false;
                //ACET_FacetsGetCasesResponse casesFacetsResponse = (ACET_FacetsGetCasesResponse)JSON.deserialize(responseStr.getBody(), ACET_FacetsGetCasesResponse.class);
                ACET_FacetsGetCasesResponse casesFacetsResponse = ACET_FacetsGetCasesResponse.parse(responseStr.getBody());
                system.debug('=casesFacetsResponse='+casesFacetsResponse);
                if(casesFacetsResponse != null && casesFacetsResponse.meta != null && casesFacetsResponse.meta.nextPageInd != null &&  casesFacetsResponse.meta.nextPageInd){
                    calloutNeeded = casesFacetsResponse.meta.nextPageInd;
                    while(calloutNeeded){
                        facetsGetCasesRequest innerSearchInput = new facetsGetCasesRequest();
                        
                        innerSearchInput.subscriberId =subscriberId;
                        //searchInputProv.providerId='';
                        innerSearchInput.inquiryId=inquiryId;
                        innerSearchInput.sortBy='D';
                        innerSearchInput.offset=Integer.valueOf(casesFacetsResponse.meta.limit_Z)+1;
                        innerSearchInput.limit_Z=Integer.valueOf(casesFacetsResponse.meta.limit_Z);
                        
                        requestBody = JSON.serialize(innerSearchInput);
                         system.debug('==Inner request '+requestBody);
                        requestBody = requestBody.replace('limit_Z', 'limit');
                        httpResponse innerresponseStr = (httpResponse)fetchFacetsRecord(requestBody);
                        if(innerresponseStr != null){
                            if(innerresponseStr.getStatusCode() == 200){
                                calloutNeeded = false;
                                //ACET_FacetsGetCasesResponse casesFacetsResponse = (ACET_FacetsGetCasesResponse)JSON.deserialize(responseStr.getBody(), ACET_FacetsGetCasesResponse.class);
                                ACET_FacetsGetCasesResponse innercasesFacetsResponse = ACET_FacetsGetCasesResponse.parse(responseStr.getBody());
                                system.debug('=innercasesFacetsResponse='+innercasesFacetsResponse);
                                 if(innercasesFacetsResponse != null && innercasesFacetsResponse.meta != null && innercasesFacetsResponse.meta.nextPageInd != null &&  innercasesFacetsResponse.meta.nextPageInd){
                                    calloutNeeded = innercasesFacetsResponse.meta.nextPageInd;
                                 }
                                
                            }
                        }
                        
                    }
                }
                
            }
        }
        
        return null;
    }*/
    
    public static Object fetchFacetsRecord(String requestBody) {
        system.debug('fetchFacetsRecord');
        //Http h = new Http();
        //HttpRequest httpRequest = new HttpRequest();
        HttpResponse httpResponse = new HttpResponse();
        String responseBody;
        Integer statusCode;
        try{
            /*Map < String, ACETOrgInstanceURLToOrgNameMap__c > OrgInstance2OrgNameMap = ACETOrgInstanceURLToOrgNameMap__c.getAll();
            String orgName = Test.isRunningTest() ? 'dev' : ACETUtility.GetOrgName(OrgInstance2OrgNameMap);
            Map < String, ISL_Webservice_Config__c > islWebserviceData = ISL_Webservice_Config__c.getAll();
            String endPoint = islWebserviceData.get(orgName + '_FacetsGetCases').Value__c;
            httpRequest.setMethod('POST');
            httpRequest.setEndpoint(endPoint);
            httpRequest.setBody(requestBody);
            httpRequest.setHeader('Content-Type', 'application/json');
            httpRequest.setHeader('client-code', 'ACET');
            httpRequest.setTimeout(12000);
            httpRequest.setHeader('Authorization', 'Bearer ' + ISL_Webservice_Config__c.getInstance('SNIAPIAccessToken').Value__c);
            //httpResponse = h.send(httpRequest);*/
            
            ACET_WebserviceCalloutFramework wsCallOutFW = new ACET_WebserviceCalloutFramework();	
            wsCallOutFW.serviceName = 'FacetsGetCases';	
            wsCallOutFW.requestBody = requestBody;	
            httpResponse = wsCallOutFW.getResponse();
            
            system.debug('=httpResponse.getStatusCode() ='+httpResponse.getStatusCode() );
            /*if(httpResponse.getStatusCode() != 200){
                String urlParameters='';
                if(endPoint!=null){
                    urlParameters = '?' + endPoint.substringAfter('?');
                    endPoint = endPoint.substringBefore('?');
                }
                ACET_ORSWebservice.createAppErrorLog_ORS('ACET', 'FacetsGetCases', endPoint, httpResponse.getStatus(), httpResponse.getStatusCode(), requestBody, httpResponse.getBody(), urlParameters);
            }*/
        }
        catch(Exception e){
            system.debug(e.getStackTraceString());
        }
        
        return httpResponse;
    }
    
    public override void getEndpoint() {
        if(this.endpointType == 'read_issue') {
            GetEndpointDetail('FacetsGetCases');
        }
    }
    //US3433074
    @AuraEnabled
    public static ACET_SAECalloutResult updateFaceCase(string facetsId, string comment,string msId){
        ACET_SAECalloutResult calloutResult = new ACET_SAECalloutResult();
        try{
            HttpResponse response = new HttpResponse();
            string requestBody = getFacetsUpdateRequest(facetsId,comment,msId);
            response = (HttpResponse) updateFacetsRecord(requestBody);
            Integer respCode = response.getStatusCode();
            String respBody = response.getBody();
            if(respCode == 204){
                calloutResult.isSuccess = true;
                calloutResult.Message = 'Success';
                calloutResult.statusCode = respCode;
                calloutResult.Response = null;
            }
            else{
                system.debug('@Error@' + respBody);
                calloutResult.MessageSeverity = ApexPages.Severity.INFO;
                calloutResult.isSuccess = false;
                calloutResult.statusCode = respCode;
                calloutResult.Message = respBody;

            }

        }
        Catch(Exception e){
            system.debug('@e@'+e.getStackTraceString());
            system.debug('@em'+e.getMessage());
            calloutResult.MessageSeverity = ApexPages.Severity.ERROR;
            calloutResult.isSuccess = false;
            calloutResult.Message = 'Web Service or External System is temporarily unavailable.';
            calloutResult.statusCode=999;
        }
        system.debug('@calloutResult@'+calloutResult);
        return calloutResult;
    }


     public static Object updateFacetsRecord(String requestBody) {
        system.debug('updateFacetsRecord');
        HttpResponse httpResponse = new HttpResponse();
        try{
            ACET_WebserviceCalloutFramework wsCallOutFW = new ACET_WebserviceCalloutFramework();
            wsCallOutFW.serviceName = 'FacetsUpdateRecord';
            wsCallOutFW.requestBody = requestBody;
            httpResponse = wsCallOutFW.getResponse();
            system.debug('@StatusCode'+httpResponse.getStatusCode());
        }
        catch(Exception e){
            system.debug('@e@'+e.getStackTraceString());
        }
        return httpResponse;
    }

    //US3155915
    public static string getFacetsUpdateRequest(string facetsId, string comment,string msId){
        comment = comment.replace('\n',' ');
        ACET_FACETSUpdateRequest.customerServiceRecord req = new ACET_FACETSUpdateRequest.customerServiceRecord();
        req.inquiryId = facetsId;
        ACET_FACETSUpdateRequest.Tasks t= new ACET_FACETSUpdateRequest.Tasks();
        t.noteText = comment;
        t.lastUpdateUserId = msId;
        req.tasks = new List < ACET_FACETSUpdateRequest.Tasks > {t};
        ACET_FACETSUpdateRequest objRequest = new ACET_FACETSUpdateRequest(req);
        system.debug('@requestBody@'+objRequest);
        system.debug('@requestBodyJ@'+JSON.serialize(objRequest));
        return JSON.serialize(objRequest);
    }


    /*Facets Response Class*/
    public class FacetsResponse {
        @AuraEnabled public boolean isSuccess {get; set;} {isSuccess = false;}
        @AuraEnabled public string strResponse {get;set;} {strResponse = '';}
        @AuraEnabled public Object Response{get;set;}{Response = '';}
        @AuraEnabled public Integer responseStatus;
        @AuraEnabled public string responseStatusMessage;
        public FacetsResponse(Boolean isSuccess, String strResponse,Object Response) {
            this.isSuccess = isSuccess;
            this.strResponse = strResponse;
            this.Response = Response;
        }
    }
    
    public class facetsGetCasesRequest {
        
        public String subscriberId {get;set;} 
        public String providerId {get;set;} 
        public String inquiryId {get;set;} 
        public String dateOfServiceFrom {get;set;} 
        public String dateOfServiceTo {get;set;} 
        public String sortBy {get;set;} 
        public Integer offset {get;set;} 
        public Integer limit_Z {get;set;} // in json: limit
    }
    
    public class getFacetsResponse {
        @AuraEnabled public Integer responseStatus;
        @AuraEnabled public string responseStatusMessage;
        @AuraEnabled public ACET_FacetsGetCasesResponse casesFacetsResponse;
    }
    
}