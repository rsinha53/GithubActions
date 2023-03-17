/*
 * @Desc: US2974834 - Process the Benefit Check Request/Response
 * @Date: 18-12-2020
 * @Dev: Kavinda
 */
public class ACET_BenefitCheckWS extends ACETWebService {

    public static final Integer RESPONSE_SUCCESS_CODE = 200;
    static final String BENEFIT_CHECK_COMMON_ERROR_MSG = 'Web Service or External System is temporarily unavailable.';
    static final Integer BENEFIT_CHECK_ERROR_CODE = 999;
    static final String BENEFIT_CHECK_RESOURCE = 'BenefitCheckEndPoint';

    Map<String, String> mapMeasure = new Map<String, String> {
        'Days' => 'DY',
        'Hours' => 'HS',
        'Units' => 'FL',
        'Visits' => 'VS'
    };

    Map<String, Integer> mapPlaceOfService = new Map<String, Integer> {
        '34 - Hospice' => 34,
        '2 - Telehealth' => 2,
        '11 - Office' => 11,
        '12 - Home' => 12,
        '13 - Assisted Living Facility' => 13,
        '17 - Walk-in Retail Health Clinic' => 17,
        '20 - Urgent Care Facility' => 20,
        '21 - Inpatient Hospital' => 21,
        '22 - On Campus - Outpatient Hospital' => 22,
        '23 - Emergency Room Hospital' => 23,
        '24 - Ambulatory Surgery Center' => 24,
        '25 - Birthing Center' => 25,
        '31 - Skilled Nursing Facility' => 31,
        '33 - Custodial Care Facility' => 33,
        '41 - Ambulance Land' => 41,
        '42 - Ambulance Air Or Water' => 42,
        '49 - Independent Clinic' => 49,
        '52 - Psychiatric Facility' => 52,
        '55 - Residual Substance Abuse Treatment' => 55,
        '61 - Comprehensive Inpatient Rehabilitaty Facility' => 61,
        '62 - Comprehensive Outpatient Rehabilitation Facility' => 62,
        '81 - Independent Laboratory' => 81,
        '99 - Other Unlisted Facility' => 99
    };
    
    // 17 - Walk-in Retail Health Clinic 
    // 22 - On Campus - Outpatient Hospital 
    // 23 - Emergency Room Hospital
    // 24 - Ambulatory Surgery Center
    // 41 - Ambulance Land
    // 42 - Ambulance Air Or Water
    // 52 -  Psychiatric Facility / 52 - Psychiatric Facility-Partial Hospitalization
    // 55 - Residual Substance Abuse Treatment / 55 - Residential Substance Abuse Treatment Facility
    // 61 - Comprehensive Inpatient Rehabilitaty Facility / 61 - Comprehensive Inpatient Rehabilitation Facility
    // 99 - Other Unlisted Facility / 99 - Other Place of Service

    public ACET_BenefitCheckWS(){
        super(SAEConstants.STARGATE_STG_SERVICENAME);  
        // US3137520
        if(Organization_Properties__c.getInstance(UserInfo.getProfileId()).callProductionEndpoints__c){
            this(SAEConstants.STARGATE_PRD_SERVICENAME);
        }
    }  

    public ACET_BenefitCheckWS(String systemName){
        super(systemName);
    } 

    // set endpoints
    public override void getEndpoint(){
        GetEndpointDetail(BENEFIT_CHECK_RESOURCE);
    }

    // create request body
    public void getRequestBody(String reqParams) {
        RequestBody = reqParams; 
    }

    public ACETWSCalloutResult benefitCheck(String benefitData){
        
        System.debug(Logginglevel.INFO, 'ACET_BenefitCheckWS -> benefitData: ' + benefitData); 

        ACETWSCalloutResult calloutResult = new ACETWSCalloutResult();
        ACET_BenefitCheckResponseWrap result = new ACET_BenefitCheckResponseWrap();
        
        try{

            HttpResponse response;
            Boolean isStaticResponseChecked = false;
            isStaticResponseChecked = SAEUtils.getMockStatus();
            
            if(isStaticResponseChecked && !Test.isRunningTest()) {
                //US3137795
                Integer statusCode= 200;
                if(benefitData.contains('40000')) {
                    statusCode=400;
                }
                else if(benefitData.contains('50000')) {
                    statusCode=500;
                }
                else if(benefitData.contains('40004')) {
                    statusCode=404;
                }
                else if(benefitData.contains('90009')) {
                    statusCode=999;
                }
                return getBenefitCheckMockResponse(statusCode);
            } else { 
                String reqParams = requestFormatProcessing(benefitData);
                System.debug(Logginglevel.INFO, 'ACET_BenefitCheckWS -> reqParams: ' + reqParams); 
                getRequestBody(reqParams);  
                getEndpoint(); 
                response = Send(OAuthConfig);
                Integer ttapStatusCode = response.getStatusCode();  
                result = (ACET_BenefitCheckResponseWrap)JSON.deserialize(response.getBody(), ACET_BenefitCheckResponseWrap.Class);
                System.debug(Logginglevel.INFO, 'ACET_BenefitCheckWS -> Response:' + result); 
                if(ttapStatusCode == RESPONSE_SUCCESS_CODE) {
                    calloutResult.Success = true;
                    calloutResult.MessageSeverity = ApexPages.Severity.INFO; 
                    calloutResult.Message = '';  
                } else {
                    calloutResult.Success = false;
                    calloutResult.MessageSeverity = ApexPages.Severity.ERROR;  
                    calloutResult.Message = response.getBody(); 
                }   
                calloutResult.statusCode = ttapStatusCode; 
                calloutResult.Response = result;
            } 
        } catch (Exception e) {
            System.debug(LoggingLevel.ERROR, 'ACET_BenefitCheckWS -> benefitCheck() : ' + e.getLineNumber() + ' - ' + e.getStackTraceString());
            calloutResult.MessageSeverity = ApexPages.Severity.ERROR; 
            calloutResult.Success = false;
            calloutResult.Message = BENEFIT_CHECK_COMMON_ERROR_MSG;
            calloutResult.statusCode = BENEFIT_CHECK_ERROR_CODE;
        } 
        return calloutResult;
    }

    private ACETWSCalloutResult getBenefitCheckMockResponse(Integer statusCode){
        ACETWSCalloutResult calloutResult = new ACETWSCalloutResult();
        String fileName= (statusCode==400 || statusCode==500 || statusCode==404)? 'ACET_BenefitCheck_ErrorResponse' : (statusCode==999) ? 'ACET_BenefitCheck_Error999Response' :'ACET_BenefitCheck_Response'; //US3137795
        StaticResource response = [SELECT Id, Body FROM StaticResource WHERE Name =: fileName LIMIT 1];
        String RespStr = response.Body.toString();
        ACET_BenefitCheckResponseWrap result = (ACET_BenefitCheckResponseWrap)System.JSON.deserialize(RespStr, ACET_BenefitCheckResponseWrap.class);
        calloutResult.Success = true;
        calloutResult.Message = '';
        calloutResult.Response = result;
        calloutResult.statusCode = (statusCode==999) ? 200 : statusCode; //US3137795
        return calloutResult;
    }

    private String requestFormatProcessing(String benefitData){

        ACET_BenefitCheckRequest benefitCheckRequest = new ACET_BenefitCheckRequest(); 

        Map<String, Object> benefitDetailsMap = (Map<String, Object>)JSON.deserializeUntyped(benefitData);

        Map<String, Object> memberCardData = new Map<String, Object>();
        Map<String, Object> providerDetail = new Map<String, Object>();

        Map<String, Object> PACheckData = new Map<String, Object>();
        Map<String, Object> DOSAndPOS = new Map<String, Object>();
        Map<String, Object> ProcedureCode = new Map<String, Object>();
        List<Object> ProcedureCodesList = new List<Object>();

        ACET_ExtendedServiceController.ExtendedServiceWrapper extendeResult = new ACET_ExtendedServiceController.ExtendedServiceWrapper();
        SAEMemberProviderSearchCoveragesResult memberDataResult = new SAEMemberProviderSearchCoveragesResult();

        if (benefitDetailsMap.containsKey('memberCardData')) {  
            memberCardData = (Map<String, Object>)JSON.deserializeUntyped(String.valueOf(benefitDetailsMap.get('memberCardData'))); 
        }

        if (benefitDetailsMap.containsKey('providerDetail')) {  
            providerDetail = (Map<String, Object>)JSON.deserializeUntyped(String.valueOf(benefitDetailsMap.get('providerDetail'))); 
        }

        if (benefitDetailsMap.containsKey('PACheckData')) {  
            PACheckData = (Map<String, Object>)JSON.deserializeUntyped(String.valueOf(benefitDetailsMap.get('PACheckData'))); 
            if (PACheckData.containsKey('DOSAndPOS')) {
                DOSAndPOS = (Map<String, Object>)PACheckData.get('DOSAndPOS');
            } 
            if (PACheckData.containsKey('ProcedureCode')) { 
                ProcedureCode = (Map<String, Object>)PACheckData.get('ProcedureCode');
                if (ProcedureCode.containsKey('ProcedureCodes')) {
                    ProcedureCodesList = (List<Object>)ProcedureCode.get('ProcedureCodes');
                }
            }
        }

        if (benefitDetailsMap.containsKey('extendeResult')) {  
             extendeResult = (ACET_ExtendedServiceController.ExtendedServiceWrapper)JSON.deserialize((String)benefitDetailsMap.get('extendeResult'),ACET_ExtendedServiceController.ExtendedServiceWrapper.Class);
        }

        if (benefitDetailsMap.containsKey('memberDataResult')) {  
            memberDataResult= (SAEMemberProviderSearchCoveragesResult)(JSON.deserialize((String)benefitDetailsMap.get('memberDataResult'),SAEMemberProviderSearchCoveragesResult.Class));
        }

        String currTimestamp = System.now().format('yyyy-MM-dd\' \'HH:mm:ss.SSS');

        benefitCheckRequest.transactionId = '';
        benefitCheckRequest.submissionDateTime = currTimestamp;
        benefitCheckRequest.certificationType = 'I';
        benefitCheckRequest.levelOfService = 'E';
        String PlaceOfService = mapContainsString(mapPlaceOfService, mapContainsString(DOSAndPOS, 'PlaceOfService'));
        benefitCheckRequest.facilityType = PlaceOfService;
        benefitCheckRequest.placeOfService = PlaceOfService;

        ACET_BenefitCheckRequest.Patient patient = new ACET_BenefitCheckRequest.Patient();
        String strDOB = mapContainsString(memberCardData, 'memberDOB');
        if(strDOB != null && String.isNotBlank(strDOB)){
            List<String> dtDOB = strDOB.split('/');
            patient.dob = dtDOB[2] + '-' + dtDOB[0] + '-' + dtDOB[1];
        }
        patient.genderType = mapContainsString(memberCardData, 'gender');
        patient.SSN = mapContainsString(memberCardData, 'SSN');

        if(extendeResult != null && extendeResult.policyResultWrapper != null && extendeResult.policyResultWrapper.resultWrapper != null && extendeResult.policyResultWrapper.resultWrapper.policyRes != null){
            patient.subscriberID = stringIsBlank(extendeResult.policyResultWrapper.resultWrapper.policyRes.subscriberID);
            patient.sourceMemberID = extendeResult.policyResultWrapper.resultWrapper.policyRes.xrefId;
            patient.policyNumber = extendeResult.policyResultWrapper.resultWrapper.policyRes.policyNumber;
            patient.relationshipCode = extendeResult.policyResultWrapper.resultWrapper.policyRes.relationshipCode;

        }

        if(extendeResult != null && extendeResult.houseHoldWrapper != null && extendeResult.houseHoldWrapper.houseHoldList != null){
            if(extendeResult.houseHoldWrapper.houseHoldList.size() > 0){
                for(Integer k = 0; k < extendeResult.houseHoldWrapper.houseHoldList.size(); k++){
                    if(extendeResult.houseHoldWrapper.houseHoldList[k].relationship == 'Subscriber'){
                        patient.subscriberFirstName = extendeResult.houseHoldWrapper.houseHoldList[k].firstName;
                        patient.subscriberLastName = extendeResult.houseHoldWrapper.houseHoldList[k].lastName;  
                    }
                }
            }
        }
        patient.memberId = mapContainsString(memberCardData, 'memberId');
        patient.firstName = mapContainsString(memberCardData, 'firstName');
        patient.lastName = mapContainsString(memberCardData, 'lastName');
        
        List<ACET_BenefitCheckRequest.MemberAddresses> memberAddressesList = new List<ACET_BenefitCheckRequest.MemberAddresses>();
        ACET_BenefitCheckRequest.MemberAddresses memberAddress = new ACET_BenefitCheckRequest.MemberAddresses();
        memberAddress.addressType = '1';
        memberAddress.address1 = memberDataResult.CoverageLines[0].patientInfo.AddressLine1;
        memberAddress.city = memberDataResult.CoverageLines[0].patientInfo.City;
        memberAddress.state = memberDataResult.CoverageLines[0].patientInfo.State; 
        memberAddress.zip = memberDataResult.CoverageLines[0].patientInfo.Zip;
        memberAddress.countryCode = '';
        memberAddress.zipSuffix = ''; 

        memberAddressesList.add(memberAddress);

        patient.memberAddresses = memberAddressesList;

        ACET_BenefitCheckRequest.Address providerAddress = new ACET_BenefitCheckRequest.Address();
        providerAddress.city = mapContainsString(providerDetail, 'AddressCity');
        providerAddress.line1 = mapContainsString(providerDetail, 'addressLine1');
        providerAddress.line2 = mapContainsString(providerDetail, 'addressLine2');
        providerAddress.state = mapContainsString(providerDetail, 'state');
        providerAddress.zip = mapContainsString(providerDetail, 'zip');

        ACET_BenefitCheckRequest.ServicingProviders servicingProvider = new ACET_BenefitCheckRequest.ServicingProviders();
        servicingProvider.address = providerAddress;

        String phoneNumber = mapContainsString(providerDetail, 'phoneNumberSRN');
        if(phoneNumber != null && String.isNotBlank(phoneNumber) && phoneNumber.trim().length() > 0){
            servicingProvider.primaryPhone = phoneNumber.substring(0, 3)+'-'+phoneNumber.substring(3, 6)+'-'+phoneNumber.substring(6, phoneNumber.length());
        }

        servicingProvider.providerCategory = mapContainsString(providerDetail, 'providerCategory');
        servicingProvider.providerRole = 'SJ';
        if(servicingProvider.providerCategory == 'P'){
            servicingProvider.firstName = mapContainsString(providerDetail, 'firstName');
            servicingProvider.middleName = mapContainsString(providerDetail, 'middleName');
            servicingProvider.lastName = mapContainsString(providerDetail, 'lastName');
        } else if(servicingProvider.providerCategory == 'F'){
            servicingProvider.businesName = mapContainsString(providerDetail, 'businessName');
        }
        servicingProvider.npi = mapContainsString(providerDetail, 'npi');
        servicingProvider.tax = mapContainsString(providerDetail, 'taxId');
        
        List<ACET_BenefitCheckRequest.ServicingProviders> servicingProvidersList = new List<ACET_BenefitCheckRequest.ServicingProviders>();
        servicingProvidersList.add(servicingProvider);
        benefitCheckRequest.servicingProviders = servicingProvidersList;

        ACET_BenefitCheckRequest.Dates dates = new  ACET_BenefitCheckRequest.Dates();
        dates.fromDate = mapContainsString(DOSAndPOS, 'DateOfService'); 
        dates.toDate = System.now().format('yyyy-MM-dd'); // Testing Purpose
        dates.type = 'Event';
        benefitCheckRequest.dates = dates; 


        List<ACET_BenefitCheckRequest.Procedures> proceduresList = new List<ACET_BenefitCheckRequest.Procedures>();
        List<ACET_BenefitCheckRequest.Diagnosis> diagnosisList = new List<ACET_BenefitCheckRequest.Diagnosis>();
        
        Integer i = 1;
        for(Object procedureObj : ProcedureCodesList){
            
            Map<String, Object> procedureMap = (Map<String, Object>)procedureObj; 
            
            ACET_BenefitCheckRequest.Procedures procedures = new ACET_BenefitCheckRequest.Procedures();
            procedures.code = mapContainsString(procedureMap, 'procedureCode'); 
            procedures.unit = mapContainsString(procedureMap, 'units'); 
            procedures.quantityQualifier = mapContainsString(mapMeasure, mapContainsString(procedureMap, 'measure'));
            procedures.sampleModulus = mapContainsString(procedureMap, 'frequency');  
            // procedures.Modifier = mapContainsString(procedureMap, 'Modifier'); 
            // procedures.Charge = mapContainsString(procedureMap, 'Charge'); 
            // procedures.Count = mapContainsString(procedureMap, 'Count');

            procedures.dmeClinicalIllnessDescText = null;
            procedures.dmeEnternalFeedingSSONutrInd = null;
            procedures.dmeFormulaNameText = null;
            procedures.dmeInitialTreatmentDate = null;
            procedures.dmeMedicalConditionText = null;
            procedures.dmeProcurementType = null;
            procedures.dmeServiceDescriptionText = null;
            procedures.dmeSupplyDescText = null;
            procedures.description = null;
            procedures.timePeriodQualifier = null;
            procedures.quantity = null;

            // Testing Purpose
            procedures.dmeTotalCost = '';
            procedures.numberOfPeriods = '1';
            procedures.procedureIndex = String.valueOf(i);
            procedures.servicingProviders = servicingProvidersList;

            proceduresList.add(procedures);
            
            ACET_BenefitCheckRequest.Diagnosis diagnosis = new ACET_BenefitCheckRequest.Diagnosis();
            diagnosis.code = mapContainsString((Map<String, Object>)ProcedureCodesList[0], 'diagnosisCode');
            diagnosis.type = 'ICD10';
            diagnosisList.add(diagnosis); 
            
            ++i;
        
        }
        
        benefitCheckRequest.patient = patient; 
        benefitCheckRequest.procedures = proceduresList;
        benefitCheckRequest.diagnosis = diagnosisList;

        return System.JSON.serialize(benefitCheckRequest);  
    }

    public String mapContainsString(Map<String, Object> mp, String vl){
        return ((mp.get(vl) != null && mp.containsKey(vl) && String.isNotBlank(String.valueOf(mp.get(vl))) && (String.valueOf(mp.get(vl)).length() > 0) ) ? String.valueOf(mp.get(vl)) : '');
    }

    public String stringIsBlank(Object vl){
        return (String.isNotBlank(String.valueOf(vl)) ? String.valueOf(vl) : null);
    }

}