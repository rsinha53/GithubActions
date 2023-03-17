/*
 * @Desc: US2154799 - Process the Find Auth response
 * @Date: 23-12-2019
 * @Dev: Malinda
 */
public class ACET_FindAuthorizationWebservice {

    static final Integer RESPONSE_SUCCESS_CODE = 200;
    static final String OIL_AUTHENTICATION = 'Stargate';//'Stargate_prod';
    static final String FIND_AUTH_RESOURCE = 'FindAuth';
    //static final String FIND_AUTH_BASE_URL = 'https://gateway.optum.com';
    static final String FIND_AUTH_SUCCESS_MSG = 'Success';
    static final String FIND_AUTH_COMMON_ERROR_MSG = 'Web Service or External System is temporarily unavailable.';
    static final Integer FIND_AUTH_ERROR_CODE = 999;
    static final String FIND_AUTH_EMPTY_REQUEST_ERROR_MSG = 'Find Auth request body is empty!';
    static final String FIND_AUTH_REQ_SEARCH_TYPE = 'M';
    static final String FIND_AUTH_REQ_SOURCE_MEMBER_TYPE = 'CDB';
    static String FIND_AUTH_REQ_STOP_DATE = '9999-12-31';

    //create request body
    public String getRequestBody(FindAuthRequest requestObj) {
        //RequestBody = '{"authSummaryRequest":{"searchType":"M","member":{"sourceMemberId":{"id":625871210,"type":"CDB"},"firstName":"PATRICK","lastName":"ALFORD","birthDate":"1960-10-27"},"requestDateRange":{"startDate":"1960-10-27","stopDate":"9999-12-31"},"pagination":{"pageNumber":"","pageSize":"","startRecord":""}}}';
        String requestBody = '{"authSummaryRequest":{"searchType":"'+requestObj.SearchType.trim()+'","member":{"sourceMemberId":{"id":"'+requestObj.SourceMemberId.trim()+'","type":"'+requestObj.SourceMemberType.trim()+'"},"firstName":"'+requestObj.SourceMemberFirstName.trim()+'","lastName":"'+requestObj.SourceMemberLasttName.trim()+'","birthDate":"'+requestObj.SourceMemberDOB.trim()+'"},"requestDateRange":{"startDate":"'+requestObj.StartDate.trim()+'","stopDate":"'+requestObj.StopDate.trim()+'"},"pagination":{"pageNumber":"","pageSize":"","startRecord":""}}}';
        System.debug(Logginglevel.INFO, '### FIND-AUTH-REQUEST-BODY:' + requestBody);
        return requestBody;
    }

    public ACETWSCalloutResult findAuth(FindAuthRequest requestObj) {

        ACETWSCalloutResult calloutResult = new ACETWSCalloutResult();
        ACET_FindAuthorizationJSON2Apex responseObj;
        ACET_AuthorizationResult resultWrapper;
        ACET_AuthorizationResult.InPatientSummary inPatientSummary;
        List<ACET_AuthorizationResult.InPatientSummary> lstInPatients;
        ACET_AuthorizationResult.OutPatientSummary outPatientSummary;
        List<ACET_AuthorizationResult.OutPatientSummary> lstOutPatients;
        ACET_AuthorizationResult.OutPatientFacilitySummary outPatientFacilitySummary;
        List<ACET_AuthorizationResult.OutPatientFacilitySummary> lstOutFacilityPatients;

        try {

            if(requestObj != null) {
                //Setting up default request values
                FIND_AUTH_REQ_STOP_DATE = SAEUtils.formatDateFutureDate(Date.today().addDays(+1).format()); 
                requestObj.SearchType = FIND_AUTH_REQ_SEARCH_TYPE;
                requestObj.SourceMemberType = FIND_AUTH_REQ_SOURCE_MEMBER_TYPE;
                requestObj.StopDate = FIND_AUTH_REQ_STOP_DATE;

                HttpResponse response;
                // US3636832: Migration of authSummary and authDetail APIs to new framework- Swapnil
                ACET_WebserviceCalloutFramework wsCallOutFW = new ACET_WebserviceCalloutFramework();
                wsCallOutFW.serviceName = 'FindAuthorization';
                wsCallOutFW.requestBody = getRequestBody(requestObj);
                response = wsCallOutFW.getResponse();
				// US3636832 - Swapnil
                /* //if current org is production
                if('prd'==SAEUtils.getOrgName())
                {
                    response = Send(OAuthConfig);
                }
                else
                {
                    //Lahiru : Add Mock response in Lower sandboxes
                    //mock response code updated by _vishnu 05/20/2020
                    Boolean isStaticResponseChecked = false;
					isStaticResponseChecked = SAEUtils.getMockStatus();

                    if(isStaticResponseChecked && !Test.isRunningTest()){
                        // US2619791 - updated search param for new format
                        String searchparameter = 'findAuth_'+requestObj.PolicyIndex.trim()+'_'+requestObj.SourceMemberFirstName.trim().toLowerCase()+'_'+requestObj.SourceMemberLasttName.trim().toLowerCase()+'_'+requestObj.GetAllAuth.trim();

                        // US2819909
                        if(String.isNotBlank(requestObj.SRNNumber) && String.isNotEmpty(requestObj.SRNNumber)){
                            searchparameter +=  '_' + requestObj.SRNNumber.trim();
                        }


                        //vishnu- 30/04/2020
                        response=SAEUtils.getResponse(searchparameter);
                        
                    }else{
                        //Runs the Production APIs on upper sandboxes
                        response = Send(OAuthConfig);
                    }
                } */
                System.debug(Logginglevel.INFO, '### FIND-AUTH-RESPONSE-STATUS:' + response.getStatusCode());
                System.debug(Logginglevel.INFO, '### FIND-AUTH-RESPONSE-BODY:' + response.getBody());

                if(response.getStatusCode() == RESPONSE_SUCCESS_CODE) {

                    responseObj = (ACET_FindAuthorizationJSON2Apex)JSON.deserialize(response.getBody(), ACET_FindAuthorizationJSON2Apex.class);
                    //AcetLinkEligibilityJSON2Apex json2Apex = AcetLinkEligibilityJSON2Apex.parse(responseStr);
                    if(responseObj != null && responseObj.authSummaryResponse != null) {

                       resultWrapper = new ACET_AuthorizationResult();

                       //InPatient
                       if(responseObj.authSummaryResponse.inPatientsSummary != null && !responseObj.authSummaryResponse.inPatientsSummary.isEmpty()) {
                           lstInPatients = new List<ACET_AuthorizationResult.InPatientSummary>();
                           for (ACET_FindAuthorizationJSON2Apex.InPatientsSummary summary : responseObj.authSummaryResponse.inPatientsSummary) {
                               inPatientSummary = new ACET_AuthorizationResult.InPatientSummary();

                               //Mappings
                               inPatientSummary.ServiceReferenceNumber = String.isNotBlank(summary.primaryServiceReferenceNumber) ? summary.primaryServiceReferenceNumber : '';
                               inPatientSummary.ActualAdmitDateTime = String.isNotBlank(summary.actualAdmissionDateTime) ? summary.actualAdmissionDateTime : '';
                               inPatientSummary.ActualDischargeDateTime =  String.isNotBlank(summary.actualDischargeDateTime) ? summary.actualDischargeDateTime : '';
                               if(summary.primaryDiagnosisCode != null) {
                               inPatientSummary.PrimaryDiagnosisCode = String.isNotBlank(summary.primaryDiagnosisCode.code) ? summary.primaryDiagnosisCode.code : '';
                               inPatientSummary.PrimaryDiagnosisCodeDescription = String.isNotBlank(summary.primaryDiagnosisCode.description) ? summary.primaryDiagnosisCode.description : '';
                                }
                               inPatientSummary.ProviderFirstName = String.isNotBlank(summary.servicingProviderFirstName) ? summary.servicingProviderFirstName : '';
                               inPatientSummary.ProviderLastName = String.isNotBlank(summary.servicingProviderLastName) ? summary.servicingProviderLastName : '';
                               inPatientSummary.ProviderOrganizationName = String.isNotBlank(summary.facilityProviderOrganizationName) ? summary.facilityProviderOrganizationName : '';
                                if(summary.FacilityProviderNetworkStatusType != null) {
                               inPatientSummary.ProviderNetworkStatusTypeCode = String.isNotBlank(summary.FacilityProviderNetworkStatusType.code) ? summary.FacilityProviderNetworkStatusType.code : '';
                               inPatientSummary.ProviderNetworkStatusTypeDescription = String.isNotBlank(summary.FacilityProviderNetworkStatusType.description) ? summary.FacilityProviderNetworkStatusType.description : '';
                                }
                                if(summary.serviceSettingType != null) {
                               inPatientSummary.ServiceSettingTypeCode =  String.isNotBlank(summary.serviceSettingType.code) ? summary.serviceSettingType.code : '';
                               inPatientSummary.ServiceSettingTypeDescription = String.isNotBlank(summary.serviceSettingType.description) ? summary.serviceSettingType.description: '';
                                }

                               inPatientSummary.AuthId = String.isNotBlank(summary.authId) ? summary.authId: '';
                               inPatientSummary.LengthOfStay = String.isNotBlank(summary.lengthOfStay) ? summary.lengthOfStay: '';
                                //US2291037	 Pilot Minot Changes - Add Status on Authorization Results - Sarma - 29-01-2010
                                if(summary.statusType != null ) {
                                inPatientSummary.StatusTypeCode = String.isNotBlank(summary.statusType.code) ? summary.statusType.code : '';
                                inPatientSummary.StatusTypeDescription = String.isNotBlank(summary.statusType.description) ? summary.statusType.description : '';
                                }


                               lstInPatients.add(inPatientSummary);
                           }
                       }

                       //OutPatient
                       if(responseObj.authSummaryResponse.outPatientsSummary != null && !responseObj.authSummaryResponse.outPatientsSummary.isEmpty()) {
                           lstOutPatients = new List<ACET_AuthorizationResult.OutPatientSummary>();
                           for (ACET_FindAuthorizationJSON2Apex.OutPatientsSummary summary : responseObj.authSummaryResponse.outPatientsSummary) {
                               outPatientSummary = new ACET_AuthorizationResult.OutPatientSummary();

                               //Mappings
                               outPatientSummary.ServiceReferenceNumber =  String.isNotBlank(summary.primaryServiceReferenceNumber) ? summary.primaryServiceReferenceNumber : '';
                               if(summary.serviceDateRange != null ) {
                               outPatientSummary.ServiceStartDate = String.isNotBlank(summary.serviceDateRange.startDate) ? summary.serviceDateRange.startDate : '';
                               outPatientSummary.ServiceEndDate =  String.isNotBlank(summary.serviceDateRange.stopDate) ? summary.serviceDateRange.stopDate : '';
                               }
                               if(summary.procedureCode != null ) {
                               outPatientSummary.ProcedureCode = String.isNotBlank(summary.procedureCode.code) ? summary.procedureCode.code : '';
                               outPatientSummary.ProcedureCodeDescription = String.isNotBlank(summary.procedureCode.codeDesc) ? summary.procedureCode.codeDesc : '';
                               }

                               if(summary.primaryDiagnosisCode != null ) {
                               outPatientSummary.PrimaryDiagnosisCode = String.isNotBlank(summary.primaryDiagnosisCode.code) ? summary.primaryDiagnosisCode.code : '';
                               outPatientSummary.PrimaryDiagnosisCodeDescription = String.isNotBlank(summary.primaryDiagnosisCode.description) ? summary.primaryDiagnosisCode.description : '';
                               }

                               outPatientSummary.ProviderFirstName = String.isNotBlank(summary.servicingProviderFirstName) ? summary.servicingProviderFirstName : '';
                               outPatientSummary.ProviderLastName = String.isNotBlank(summary.servicingProviderLastName) ? summary.servicingProviderLastName : '';

                                if(summary.serviceSettingType != null ) {
                               outPatientSummary.ServiceSettingTypeCode = String.isNotBlank(summary.serviceSettingType.code) ? summary.serviceSettingType.code : '';
                               outPatientSummary.ServiceSettingTypeDescription = String.isNotBlank(summary.serviceSettingType.description) ? summary.serviceSettingType.description : '';
                                }
                               if(summary.servicingProviderNetworkStatusType != null ) {
                               outPatientSummary.ProviderStatus = String.isNotBlank(summary.servicingProviderNetworkStatusType.description) ? summary.servicingProviderNetworkStatusType.description : '';

                               }
                               outPatientSummary.AuthId = String.isNotBlank(summary.authId) ? summary.authId: '';
                                 //US2291037	 Pilot Minot Changes - Add Status on Authorization Results - Sarma - 29-01-2010
                                if(summary.servicingProviderNetworkStatusType != null ) {
                                outPatientSummary.StatusTypeCode = String.isNotBlank(summary.statusType.code) ? summary.statusType.code : '';
                                outPatientSummary.StatusTypeDescription = String.isNotBlank(summary.statusType.description) ? summary.statusType.description : '';
                                }

                               lstOutPatients.add(outPatientSummary);
                           }
                       }

                       //OutPatientFacility
                       if(responseObj.authSummaryResponse.outPatientsFacilitySummary != null && !responseObj.authSummaryResponse.outPatientsFacilitySummary.isEmpty()) {
                           lstOutFacilityPatients = new List<ACET_AuthorizationResult.OutPatientFacilitySummary>();
                           for (ACET_FindAuthorizationJSON2Apex.outPatientsFacilitySummary summary : responseObj.authSummaryResponse.outPatientsFacilitySummary) {
                               outPatientFacilitySummary = new ACET_AuthorizationResult.OutPatientFacilitySummary();

                               //Mappings
                               outPatientFacilitySummary.ServiceReferenceNumber = String.isNotBlank(summary.primaryServiceReferenceNumber) ? summary.primaryServiceReferenceNumber : '';
                               outPatientFacilitySummary.ActualAdmitDate = String.isNotBlank(summary.expectedAdmitDate) ? summary.expectedAdmitDate : '';//summary.actualAdmitDateTime : ''; (US2308090 - 23 JAN 2020)
                               outPatientFacilitySummary.ActualDischargeDateTime = String.isNotBlank(summary.expectedDischargeDate) ?  summary.expectedDischargeDate : '';//summary.actualDischargeDateTime : ''; (US2308090 - 23 JAN 2020)
                               if(summary.procedureCode != null ) {
                               outPatientFacilitySummary.ProcedureCode = String.isNotBlank(summary.procedureCode.code) ? summary.procedureCode.code : '';
                               outPatientFacilitySummary.ProcedureCodeDescription = String.isNotBlank(summary.procedureCode.codeDesc) ? summary.procedureCode.codeDesc : '';
                               }
                               if(summary.primaryDiagnosisCode != null) {
                               outPatientFacilitySummary.PrimaryDiagnosisCode = String.isNotBlank(summary.primaryDiagnosisCode.code) ? summary.primaryDiagnosisCode.code : '';
                               outPatientFacilitySummary.PrimaryDiagnosisCodeDescription = String.isNotBlank(summary.primaryDiagnosisCode.description) ? summary.primaryDiagnosisCode.description : '';
                               }

                               outPatientFacilitySummary.ProviderFirstName = String.isNotBlank(summary.servicingProviderFirstName) ? summary.servicingProviderFirstName : '';
                               outPatientFacilitySummary.ProviderLastName = String.isNotBlank(summary.servicingProviderLastName) ? summary.servicingProviderLastName : '';
                               outPatientFacilitySummary.ProviderOrganizationName = String.isNotBlank(summary.facilityProviderOrganizationName) ? summary.facilityProviderOrganizationName : '';
                               if(summary.FacilityProviderNetworkStatusType != null ) {
                               outPatientFacilitySummary.ProviderNetworkStatusTypeCode = String.isNotBlank(summary.FacilityProviderNetworkStatusType.code) ? summary.FacilityProviderNetworkStatusType.code : '';
                               outPatientFacilitySummary.ProviderNetworkStatusTypeDescription = String.isNotBlank(summary.FacilityProviderNetworkStatusType.description) ? summary.FacilityProviderNetworkStatusType.description : '';
                               }
                               if(summary.serviceSettingType != null ) {
                               outPatientFacilitySummary.ServiceSettingTypeCode = String.isNotBlank(summary.serviceSettingType.code) ? summary.serviceSettingType.code : '';
                               outPatientFacilitySummary.ServiceSettingTypeDescription = String.isNotBlank(summary.serviceSettingType.description) ? summary.serviceSettingType.description : '';
                               }

                               outPatientFacilitySummary.AuthId = String.isNotBlank(summary.authId) ? summary.authId: '';
                                //US2291037	 Pilot Minot Changes - Add Status on Authorization Results - Sarma - 29-01-2010
                                if(summary.statusType != null ) {
                                outPatientFacilitySummary.StatusTypeCode = String.isNotBlank(summary.statusType.code) ? summary.statusType.code : '';
                                outPatientFacilitySummary.StatusTypeDescription = String.isNotBlank(summary.statusType.description) ? summary.statusType.description : '';
                                }

                               lstOutFacilityPatients.add(outPatientFacilitySummary);
                           }
                       }

                       resultWrapper.InPatientSummaries = lstInPatients;
                       resultWrapper.OutPatientSummaries = lstOutPatients;
                       resultWrapper.OutPatientFacilitySummaries = lstOutFacilityPatients;
                    }

                    System.debug(Logginglevel.INFO, '### FIND-AUTH-RESPONSE-RESULT-WRAPPER:' + resultWrapper);
                    calloutResult.Success = true;
                    calloutResult.Message = FIND_AUTH_SUCCESS_MSG;
                    calloutResult.statusCode = RESPONSE_SUCCESS_CODE;
                    calloutResult.Response = resultWrapper;

                } //US2616399 Assigning custom error message based on response status code _by vishnu  05/20/2020
				else if (SAEConstants.viewAuthStatusCodeErrorMSG.containsKey(response.getStatusCode()))
				{
					calloutResult.Message = SAEConstants.viewAuthStatusCodeErrorMSG.get(response.getStatusCode());
					calloutResult.statusCode = response.getStatusCode();
				}
                else {

                calloutResult.Success = false;
                calloutResult.Message = FIND_AUTH_COMMON_ERROR_MSG;
                calloutResult.statusCode = response.getStatusCode();
                }

            } else {

                calloutResult.Success = false;
                calloutResult.Message = FIND_AUTH_EMPTY_REQUEST_ERROR_MSG;
                calloutResult.statusCode = FIND_AUTH_ERROR_CODE;
            }
        } catch (Exception e) {

            System.debug(Logginglevel.ERROR, '### FIND-AUTH-EXCEPTION:' + e.getStackTraceString());
            calloutResult.MessageSeverity = ApexPages.Severity.ERROR;
            calloutResult.Success = false;
            calloutResult.Message = FIND_AUTH_COMMON_ERROR_MSG;
            calloutResult.statusCode = FIND_AUTH_ERROR_CODE;
        }
		

            System.debug(Logginglevel.ERROR, '### FIND-AUTH-calloutResult:' + calloutResult);
            return calloutResult;
    }
    


    public class FindAuthRequest {
        @AuraEnabled public String SearchType {get;set;}
        @AuraEnabled public String SourceMemberId {get;set;}
        @AuraEnabled public String SourceMemberType {get;set;}
        @AuraEnabled public String SourceMemberFirstName {get;set;}
        @AuraEnabled public String SourceMemberLasttName {get;set;}
        @AuraEnabled public String SourceMemberDOB {get;set;}
        @AuraEnabled public String StartDate {get;set;}
        @AuraEnabled public String StopDate {get;set;}
        @AuraEnabled public String PolicyIndex {get;set;}
        @AuraEnabled public String GetAllAuth {get;set;} // US2619791 - new param for new format
        @AuraEnabled public String SRNNumber {get;set;} // US2819909 - Based on this value, we are changing the mock data resource
    }
}