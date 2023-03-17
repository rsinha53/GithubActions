public without sharing class ACET_MemberSearchCtrl {
    
    static final string COMMON_ERROR_MESSAGE = 'Unexpected Error Occurred on the Member Results . Please try again. If problem persists please contact the help desk.';
    static final string PLAN_TYPE_NOT_SUPPORT_ERROR_MSG = 'This Plan Type is not currently supported. This is a misdirected contact.';
    static final string PLAN_TYPE_NOT_SUPPORT_ERROR_CODE = 'ED270IP';

    @AuraEnabled
    public static ACET_SAECalloutResult getMemberDetails(ACET_ExplorePageCtrl.FlowDetails flowDetails, ACET_ProviderSearchCtrl.ProviderDetails providerDetails, MemberDetails memberDetails) {
        System.debug('@@ ACET_MemberSearchCtrl: getTestMemberDetails: flowDetails: ' + flowDetails);
        System.debug('@@ ACET_MemberSearchCtrl: getTestMemberDetails: providerDetails: ' + providerDetails);
        System.debug('@@ ACET_MemberSearchCtrl: getTestMemberDetails: memberDetails: ' + memberDetails);
        //US2873788
        if(flowDetails != null && flowDetails.isGenesys && String.isNotBlank(memberDetails.dob) && !memberDetails.dob.contains('-') && memberDetails.dob.length() == 8){
            memberDetails.dob = memberDetails.dob.substring(0,4)+'-'+ memberDetails.dob.substring(4,6)+'-'+memberDetails.dob.substring(6,8);
        }
        Boolean isSupportedPlanType = true;
        Map < String, String > requestParamsMap = new Map < String, String > ();
        ACET_SAECalloutResult calloutResult = new ACET_SAECalloutResult();
        // US3204295 - Thanish - 3rd Feb 2021
        if(!memberDetails.isAdvancedSearch){
            ACETWSCalloutResult findIndividualCalloutResult = findIndividual(String.isNotBlank(memberDetails.dob) ? memberDetails.memberId+'_'+memberDetails.dob : memberDetails.memberId);
            System.debug('@@ ACET_MemberSearchCtrl: getTestMemberDetails: findIndividualCalloutResult: ' + findIndividualCalloutResult);
            calloutResult.isSuccess = findIndividualCalloutResult.Success;
            //US3020344 - Sravan - Start
            if(findIndividualCalloutResult.recordCount == '0'){
                // US3204299: Member Search Shows No Results- Update - Krishnanshu
                calloutResult.message = 'No results found. Modify search criteria and try again.';
            } else {
                calloutResult.message = String.isNotBlank(findIndividualCalloutResult.Message) ? findIndividualCalloutResult.Message : COMMON_ERROR_MESSAGE + ' (999 #)';
            }
            //US3020344 - Sravan - End
            calloutResult.response = findIndividualCalloutResult.Response;
            calloutResult.statusCode = findIndividualCalloutResult.statusCode;
        } else {
            if (String.isNotBlank(memberDetails.sourceCode)) {
                isSupportedPlanType = getSupportedPlanType(memberDetails.sourceCode);
            }
            memberDetails.isValidMember = true;
            memberDetails.dob = String.isNotBlank(memberDetails.dob) ? memberDetails.dob.contains('/') ? SAEUtils.formatDateFutureDate(memberDetails.dob) : SAEUtils.formatDateRequest(memberDetails.dob) : '';
            System.debug('@@ ACET_MemberSearchCtrl: getMemberDetails: memberDetails.dob: ' + memberDetails.dob);
            String searchOption = getSearchOption(memberDetails);
            try {
                String responseBody = null;
                String requestParameters = '';
                String taxId = '';
                String providerNameId = '';
                //old Code
                Boolean isStaticResponseChecked = false;
                String responseStr = '';
                HttpResponse response;
                isStaticResponseChecked = SAEUtils.getMockStatus();
                System.debug('@@ SAEMemberProviderWS: getMemberWS: isStaticResponseChecked: ' + isStaticResponseChecked);

                //US3008502 - Avish
                if (providerDetails.isProviderNotFound || providerDetails.isNoProviderToSearch || providerDetails.isOther) {
                    providerDetails.lastName = 'ACET';
                    taxId = '9999999';
                    providerNameId = '9999999';

                    requestParamsMap.put('providerLastName', providerDetails.lastName);
                    requestParamsMap.put('providerFirstName', '');
                    requestParamsMap.put('providerNameID', providerNameId);
                    requestParamsMap.put('taxIdNumber', taxId);
                } else {
                   requestParamsMap.put('providerLastName', String.isNotBlank(providerDetails.lastName) ? providerDetails.lastName : '');
                   requestParamsMap.put('providerFirstName', '');
                   requestParamsMap.put('providerNameID', String.isNotBlank(providerDetails.providerId) ? providerDetails.providerId : '');
                   requestParamsMap.put('taxIdNumber', String.isNotBlank(providerDetails.taxId) ? providerDetails.taxId : '');
                   //commenting npi parameter as it is optional for making Eligibility Call as its causing issue in Prod when npi is blank - 12112020                  
                   //requestParamsMap.put('npi', String.isNotBlank(providerDetails.npi) ? providerDetails.npi : '');
               }
                   requestParamsMap.put('searchOption', searchOption);
                   requestParamsMap.put('memberId', String.isNotBlank(memberDetails.memberId) ? memberDetails.memberId : '');
                   requestParamsMap.put('firstName', String.isNotBlank(memberDetails.firstName) ? memberDetails.firstName : '');
                   requestParamsMap.put('lastName', String.isNotBlank(memberDetails.lastName) ? memberDetails.lastName : '' );
                   requestParamsMap.put('dateOfBirth', String.isNotBlank(memberDetails.dob) ? memberDetails.dob : '');
                   requestParamsMap.put('groupNumber', String.isNotBlank(memberDetails.groupNumber) ? memberDetails.groupNumber : '');
                   requestParamsMap.put('payerID', String.isNotBlank(memberDetails.payerId) ? memberDetails.payerId : '');
                   requestParamsMap.put('serviceStart', '');
                   requestParamsMap.put('serviceEnd', '');

                // calling webservice using webservice framework
                ACET_WebserviceCalloutFramework wsCallOutFW = new ACET_WebserviceCalloutFramework();
                wsCallOutFW.serviceName = 'LinkEligibilityMemberSearch';
                wsCallOutFW.requestParamsMap = requestParamsMap;
                wsCallOutFW.encodeURLParameters = true;
                response = wsCallOutFW.getResponse();
                //US3008502 - Ends

                responseBody = response.getBody();
                Integer statusCode = response.getStatusCode();
                System.debug('@@ ACET_MemberSearchCtrl: getMemberDetails: statusCode: ' + statusCode);
                if (statusCode == 200) {
                    if (String.isNotBlank(responseBody)) {
                        ACET_MemberSearchResultsWrapper memberData = ACET_MemberSearchResultsWrapper.parse(responseBody);
                        ExplorePageMemberDetailsResponse epmdResponse;
                        //DE343974 - Payer ID fetching as per the Member drop down value, not from the real time service - Durga - START
                        Map < String, String > polciygroupToPayerIdMap = new Map < String, String > ();
                        String searchQueryPayerIdValue = '';
                        if (memberData != null && memberData.memberPolicies != null) {
                            for (ACET_MemberSearchResultsWrapper.MemberPolicies policies: memberData.memberPolicies) {
                                String isThisPoilcyActive = 'F';
                                if (policies.PolicyInfo != null) {
                                    if (policies.PolicyInfo.policyStatus.contains('Active') || policies.PolicyInfo.policyStatus.contains('active')) {
                                        isThisPoilcyActive = 'T';
                                    }
                                }
                                if (String.isNotBlank(policies.insuranceInfo.payerId) && String.isNotBlank(policies.transactionId)) {
                                    polciygroupToPayerIdMap.put(policies.transactionId, policies.insuranceInfo.payerId + ';;' + isThisPoilcyActive);
                                }
                            }
                        }
                        if (memberData != null && memberData.searchQuery != null) {
                            searchQueryPayerIdValue = String.isNotBlank(memberData.searchQuery.payerID) ? memberData.searchQuery.payerID : '';
                        }
                        //DE343974 - Payer ID fetching as per the Member drop down value, not from the real time service - Durga - END
                        ACET_MemberSearchResultsWrapper.MemberPolicies selectedPolicy;
                        for (ACET_MemberSearchResultsWrapper.MemberPolicies memberPolicy: memberData.memberPolicies) {
                            if (memberPolicy.PolicyInfo.policyStatus.containsignoreCase('Active')) {
                                selectedPolicy = memberPolicy;
                                break;
                            }
                        }
                        if (selectedPolicy == null) {
                            selectedPolicy = memberData.memberPolicies[0];
                            System.debug('@@ ACET_MemberSearchCtrl: getMemberDetails: selectedPolicy: 2nd if: ' + selectedPolicy);
                        }
                        for (ACET_MemberSearchResultsWrapper.PatientInfo patientInfo: selectedPolicy.patientInfo) {
                            if (patientInfo.searched == 'true') {
                                epmdResponse = new ExplorePageMemberDetailsResponse();
                                epmdResponse.memberId = selectedPolicy.policyInfo.memberId;
                                epmdResponse.firstName = patientInfo.firstName;
                                epmdResponse.middleName = patientInfo.middleName;
                                epmdResponse.lastName = patientInfo.lastName;
                                epmdResponse.dob = patientInfo.dateOfBirth;
                                epmdResponse.age = Integer.valueOf(SAEUtils.getAgeFromBirthday(patientInfo.dateOfBirth));
                                epmdResponse.gender = patientInfo.gender;
                                epmdResponse.relationship = patientInfo.relationship;
                                epmdResponse.groupNumber = selectedPolicy.insuranceInfo.groupNumber;
                                epmdResponse.insuranceTypeCode = selectedPolicy.insuranceInfo.insuranceTypeCode;
                                epmdResponse.searchOption = searchOption;
                                epmdResponse.payerId = memberDetails.payerId;
                                //DE343974 - Payer ID fetching as per the Member drop down value, not from the real time service - Durga
                                if (!polciygroupToPayerIdMap.isEmpty()) {
                                    epmdResponse.policyandPayerMap = polciygroupToPayerIdMap;
                                }
                                epmdResponse.searchQueryPayerId = searchQueryPayerIdValue;
                                epmdResponse.SSN = '';
                                epmdResponse.EEID = String.isNotBlank(patientInfo.EEID) ? patientInfo.EEID : '';
                                ACETWSCalloutResult findIndividualCalloutResult = findIndividual(memberDetails.memberId);
                                if (findIndividualCalloutResult.Success != null && findIndividualCalloutResult.Success) {
                                    System.debug('@@ ACET_MemberSearchCtrl: getMemberDetails: inside findindividual');
                                    SAEProviderMemberSearchInteractionResult findIndividualResultwrap = (SAEProviderMemberSearchInteractionResult) findIndividualCalloutResult.Response;
                                    System.debug('@@ ACET_MemberSearchCtrl: getMemberDetails: findIndividualResultwrap' + findIndividualResultwrap.lstSAEMemberStandaloneSearch);
                                    for (SAEProviderMemberSearchInteractionResult.SAEMemberStandaloneSearch memberList: findIndividualResultwrap.lstSAEMemberStandaloneSearch) {
                                        System.debug('@@ ACET_MemberSearchCtrl: getMemberDetails: patientInfo:' + patientInfo);
                                        if (patientInfo.firstName == memberList.firstName && patientInfo.lastName == memberList.lastName && SAEUtils.formatDate(patientInfo.dateOfBirth) == memberList.birthDate) {
                                            epmdResponse.SSN = memberList.SSN;
                                            break;
                                        }
                                    }
                                }
                                System.debug('@@ ACET_MemberSearchCtrl: getMemberDetails: epmdResponse:' + epmdResponse);
                                calloutResult.response = epmdResponse;
                                break;
                            }
                        }
                        //calloutResult.response = epmdResponse;
                        if (isSupportedPlanType) {
                            calloutResult.isSuccess = true;
                            calloutResult.message = 'Success';
                            calloutResult.statusCode = statusCode;
                        } else {
                            calloutResult.messageSeverity = ApexPages.Severity.ERROR;
                            calloutResult.isSuccess = false;
                            calloutResult.message = PLAN_TYPE_NOT_SUPPORT_ERROR_MSG;
                            calloutResult.statusCode = statusCode;
                        }
                        System.debug('@@ ACET_MemberSearchCtrl: getMemberDetails: calloutResult: ' + calloutResult);
                    }
                } else {
                    if (isSupportedPlanType) {
                        // US3625646
                        calloutResult.messageSeverity = ApexPages.Severity.ERROR;
                        calloutResult.isSuccess = false;
                        calloutResult.statusCode = statusCode;
                        Map<String, Object> httpResponseJSON = (Map<String, Object>) JSON.deserializeUntyped(responseBody);
                        String faultCode = String.isNotBlank((String)httpResponseJSON.get('faultCode')) ? (String)httpResponseJSON.get('faultCode') : '';
                        if (faultCode.containsIgnoreCase(PLAN_TYPE_NOT_SUPPORT_ERROR_CODE)) {
                            calloutResult.message = PLAN_TYPE_NOT_SUPPORT_ERROR_MSG;
                        }  else {
                            calloutResult.message = COMMON_ERROR_MESSAGE;
                        }
                        //calloutResult = getErrorResponse(statusCode, responseBody);
                    } else {
                        calloutResult.messageSeverity = ApexPages.Severity.ERROR;
                        calloutResult.isSuccess = false;
                        calloutResult.message = PLAN_TYPE_NOT_SUPPORT_ERROR_MSG;
                        calloutResult.statusCode = statusCode;
                    }
                }
            } catch (Exception e) {
                System.debug('@@ ACET_MemberSearchCtrl: getMemberDetails: caught exception: ' + e.getMessage() + '_' + e.getStackTraceString());
                calloutResult.messageSeverity = ApexPages.Severity.ERROR;
                calloutResult.isSuccess = false;
                calloutResult.message = COMMON_ERROR_MESSAGE;
                calloutResult.statusCode = 999;
            }
        }
        return calloutResult;
    }

    public static ACETWSCalloutResult findIndividual(String memberId) {
        SAEMemberStandaloneSearchWebService findIndividualWS = new SAEMemberStandaloneSearchWebService();
        ACETWSCalloutResult calloutResult = null;
        calloutResult = findIndividualWS.findIndividual(memberId);
        return calloutResult;
    }

    public static String getSearchOption(MemberDetails memberDetails) {
        String searchOption = '';
        String memberId = memberDetails.memberId;
        String firstName = memberDetails.firstName;
        String lastName = memberDetails.lastName;
        String groupNumber = memberDetails.groupNumber;
        String dob = memberDetails.dob;
        if (String.isNotBlank(memberId)) {
            searchOption = 'MemberID';
        }
        if (String.isNotBlank(firstName) && String.isNotBlank(lastName)) {
            searchOption = searchOption + 'Name';
        } else if (String.isNotBlank(firstName)) {
            searchOption = searchOption + 'FirstName';
        } else if (String.isNotBlank(lastName)) {
            searchOption = searchOption + 'LastName';
        }
        if (String.isNotBlank(dob)) {
            searchOption = searchOption + 'DateOfBirth';
        }
        return searchOption;
    }

    public class MemberDetails {
        @AuraEnabled public Boolean isValidMember {get;set;}
        @AuraEnabled public Boolean isFindIndividualSearch {get;set;}
        @AuraEnabled public Boolean isNoMemberToSearch {get;set;}
        @AuraEnabled public Boolean isMemberNotFound {get;set;}
        @AuraEnabled public Boolean isAdvancedSearch {get;set;}
        @AuraEnabled public String memberId {get;set;}
        @AuraEnabled public String dob {get;set;}
        @AuraEnabled public String firstName {get;set;}
        @AuraEnabled public String lastName {get;set;}
        @AuraEnabled public String state {get;set;}
        @AuraEnabled public String zip {get;set;}
        @AuraEnabled public String phoneNumber {get;set;}
        @AuraEnabled public String groupNumber {get;set;}
        @AuraEnabled public String searchOption {get;set;}
        @AuraEnabled public String payerId {get;set;}
        @AuraEnabled public String memberUniqueId {get;set;}
        @AuraEnabled public String sourceCode {
            get;
            set;
        }
    }
    
    public class ExplorePageMemberDetailsResponse {
        @AuraEnabled public Boolean isValidMember {get;set;}
        @AuraEnabled public Boolean isFindIndividualSearch {get;set;}
        @AuraEnabled public Boolean isNoMemberToSearch {get;set;}
        @AuraEnabled public Boolean isMemberNotFound {get;set;}
        @AuraEnabled public Boolean isAdvancedSearch {get;set;}
        @AuraEnabled public String memberId {get;set;}
        @AuraEnabled public String firstName {get;set;}
        @AuraEnabled public String formattedSSN {get;set;}
        @AuraEnabled public String maskedSSN {get;set;}
        @AuraEnabled public String memberUniqueId {get;set;}
        @AuraEnabled public String middleName {get;set;}
        @AuraEnabled public String lastName {get;set;}
        @AuraEnabled public String dob {get;set;}
        @AuraEnabled public Integer age {get;set;}
        @AuraEnabled public String gender {get;set;}
        @AuraEnabled public String relationship {get;set;}
        @AuraEnabled public String groupNumber {get;set;}
        @AuraEnabled public String insuranceTypeCode {get;set;}
        @AuraEnabled public String searchOption {get;set;}
        @AuraEnabled public String payerId {get;set;}
        @AuraEnabled public String ssn {get;set;}
        @AuraEnabled public String eeId {get;set;}
        @AuraEnabled public String phoneNumber {get;set;}
        @AuraEnabled public String state {get;set;}
        @AuraEnabled public String zip {get;set;}
        @AuraEnabled public Map<String,String> policyandPayerMap {get;set;}
        @AuraEnabled public String searchQueryPayerId {get;set;}
    }

    /*public static ACET_SAECalloutResult getErrorResponse(Integer statusCode, String responseBody) {
        ACET_SAECalloutResult calloutResult = new ACET_SAECalloutResult();
        calloutResult.isSuccess = false;
        calloutResult.message = '';
        calloutResult.statusCode = statusCode;

        Map < String, Object > httpResponseJSON = (Map < String, Object > ) JSON.deserializeUntyped(responseBody);
        String faultCode = (String) httpResponseJSON.get('faultCode');
        if (statusCode == 400) {
            if (faultCode != null && (faultCode.containsIgnoreCase('AAA:58') || faultCode.containsIgnoreCase('AAA:71') || faultCode.containsIgnoreCase('AAA:72') ||
                    faultCode.containsIgnoreCase('AAA:73') || faultCode.containsIgnoreCase('AAA:76') ||
                    faultCode.containsIgnoreCase('AAA:79') || faultCode.containsIgnoreCase('AAA:62'))) {
                calloutResult.message = (String) httpResponseJSON.get('message') + '(' + faultCode + ')';
            } else if (faultCode != null && (faultCode.containsIgnoreCase('ED270UG'))) {
                calloutResult.message = getErrorMessage(faultCode) + '(' + faultCode + ')';
            } else if (faultCode != null && (faultCode.containsIgnoreCase('AAA:Fault Code'))) {
                String[] faultCodeMsg = faultCode.split(':');
                String[] faultCodeMsg2 = faultCodeMsg[1].split(' ');
                String faultCodeOrignal = faultCodeMsg[0] + faultCodeMsg2[0] + faultCodeMsg2[1];
                calloutResult.message = getErrorMessage(faultCodeOrignal) + '(' + faultCode + ')';
            } else if (faultCode != null && (faultCode.containsIgnoreCase('ED270IP'))) {
                calloutResult.message = (String) httpResponseJSON.get('message') + '(' + faultCode + ')';
            } else if (faultCode != null && (faultCode.containsIgnoreCase('ED270BP'))) {
                calloutResult.message = (String) httpResponseJSON.get('message') + '(' + faultCode + ')';
            } else if (faultCode != null && (faultCode.containsIgnoreCase('ED270BR'))) {
                calloutResult.message = (String) httpResponseJSON.get('message') + '(' + faultCode + ')';
            }else {
                calloutResult.message = getErrorMessage(SAEConstants.GN400) + '(' + faultCode + ')';
            }
        } else if (statusCode == 404) {
            if (faultCode != null && (faultCode.containsIgnoreCase('AEFNND'))) {
                calloutResult.message = getErrorMessage(faultCode) + '(' + faultCode + ')';
            } else {
                calloutResult.message = getErrorMessage(SAEConstants.GN404) + '(' + faultCode + ')';
            }
        } else if (statusCode == 406) {
            if (faultCode != null && (faultCode.containsIgnoreCase('ED270IA'))) {
                calloutResult.message = getErrorMessage(faultCode) + '(' + faultCode + ')';
            }
        } else if (statusCode == 424) {
            if (faultCode != null && (faultCode.containsIgnoreCase('ED270UR'))) {
                calloutResult.message = getErrorMessage(faultCode) + '(' + faultCode + ')';
            } else if (faultCode != null && (faultCode.containsIgnoreCase('AAA:42'))) {
                String[] faultCodeMsg = faultCode.split(':');
                String temp = faultCodeMsg[0] + faultCodeMsg[1];
                calloutResult.message = getErrorMessage(temp) + '(' + faultCode + ')';
            }else{
                calloutResult.message = 'Unexpected error occurred. Please try again. If problem persists contact help desk.';//getErrorMessage(SAEConstants.GN400);
            }
        } else if (statusCode == 500) {
            if (faultCode != null && (faultCode.containsIgnoreCase('ED270SE') ||
                    faultCode.containsIgnoreCase('ED270UE') || faultCode.containsIgnoreCase('AEFNEE'))) {
                calloutResult.message = getErrorMessage(faultCode) + '(' + faultCode + ')';
            } else {
                calloutResult.message = getErrorMessage(SAEConstants.GN500A) + '(' + faultCode + ')';
                calloutResult.statusCode = 999;
            }
        }
        else if (statusCode == 503) {
            if (faultCode != null) {
                calloutResult.message = 'Unexpected error occurred. Please try again. If problem persists contact help desk.';//getErrorMessage(SAEConstants.GN400);
            }else{
                calloutResult.message = 'Unexpected error occurred. Please try again. If problem persists contact help desk.';
            }
        }
        else {
            calloutResult.message = getErrorMessage(SAEConstants.GN500A) + '(' + faultCode + ')';
            calloutResult.statusCode = 999;
        }
        return calloutResult;
    }

    // Get Error messages from metadata records
    public static String getErrorMessage(String errorCode) {
        String errorMessage = '';
        AcetErrorMessage__mdt[] errorCodes = [SELECT DeveloperName, Label, Error_Message__c, Message_Type__c FROM AcetErrorMessage__mdt WHERE DeveloperName =: errorCode];
        if (errorCodes.size() > 0) {
            errorMessage = errorCodes[0].Error_Message__c;
        }
        return errorMessage;
    }*/

    @AuraEnabled
    public static List < State__mdt > getStateValues() {
        List < State__mdt > stateList = [SELECT Id, DeveloperName, MasterLabel FROM State__mdt ORDER BY DeveloperName ASC];
        return stateList;
    }
	
    @AuraEnabled
    public static Boolean getSupportedPlanType(String sourceCode) {
        try{
            ACET_SourceCodeValues__mdt sourceCodeRecord = new ACET_SourceCodeValues__mdt();
            if(String.isNotBlank(sourceCode)) {
                sourceCodeRecord = [SELECT Id, DeveloperName, Is_Spire_Supported__c, MasterLabel FROM ACET_SourceCodeValues__mdt WHERE DeveloperName =: sourceCode LIMIT 1];   
            } else {
                return true;
            }
            if (sourceCodeRecord != null) {
                return sourceCodeRecord.Is_Spire_Supported__c;
            }
        }catch(exception ex) {
            System.debug('exception::'+ex.getStackTraceString());
        }
        return false;
    }
}