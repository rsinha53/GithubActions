public without sharing class ACET_BenefitSpInService {
    static Map<String, String> mapMeasure = new Map<String, String> { 'Days' => 'DY','Hours' => 'HS','Units' => 'FL','Visits' => 'VS'};
    public static Map<String, Integer> mapPlaceOfService = new Map<String, Integer> {
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

                    public static ACET_SAECalloutResult callBenfitSpInService(BenefitSIReq req){
                        ACET_SAECalloutResult calloutResult = new ACET_SAECalloutResult();
                        calloutResult.isSuccess = false;
                        calloutResult.statusCode = 999;
                        try{
                            string reqBody = JSON.serialize(req);
                            ACET_WebserviceCalloutFramework wsCallOut = new ACET_WebserviceCalloutFramework();
                            wsCallOut.serviceName = 'BenefitSpecialInstructions';
                            wsCallOut.requestBody = reqBody;
                            HttpResponse response = wscallout.getResponse();
                            string responseStr = response.getBody();
                            Integer code = response.getStatusCode();
                            system.debug('@code@'+code+' @body@'+responseStr);
                            if(code == 200){
                                if(responseStr != null && String.isNotBlank(responseStr)){
                                    ACET_BenefitSIResponse responseData = ACET_BenefitSIResponse.parse(responseStr);
                                    system.debug('@responseData@'+responseData);
                                    calloutResult.isSuccess = true;
                                    calloutResult.Message = 'Success';
                                    calloutResult.statusCode = code;
                                    calloutResult.Response = responseData;
                                }
                            }
                            else{
                                calloutResult.isSuccess = false;
                                calloutResult.Message = responseStr;
                                calloutResult.statusCode = code;
                            }
                        }
                        catch(Exception e){
                            system.debug('@excep@'+e.getMessage());
                            calloutResult.Message = e.getMessage();
                        }
                        return calloutResult;
                    }


    public class BenefitSIReq {
        public String clientId;
        public codeWrapper[] codeList;
        public String dateOfService;
        public memberPWrapper memberProductCodes;
        public String productGroup;
        public String provState;
        public String siteOfService;

    }
    public class codeWrapper {
        public String diagnosisCode;
        public String procedureCode;
    }

    public class memberPWrapper {
        public String marketType;
        public String productCode;
    }


    public static ACET_SAECalloutResult callBenefitCheck(ACET_BenefitCheckRequest req){
        ACET_SAECalloutResult calloutResult = new ACET_SAECalloutResult();
        calloutResult.isSuccess = false;
        calloutResult.statusCode = 999;
        try{
            string reqBody = JSON.serialize(req);
            ACET_WebserviceCalloutFramework wsCallOut = new ACET_WebserviceCalloutFramework();
            wsCallOut.serviceName = 'BenefitCheckClaim';
            wsCallOut.requestBody = reqBody;
            HttpResponse response = wscallout.getResponse();
            string responseStr = response.getBody();
            Integer code = response.getStatusCode();
            system.debug('@code@'+code+' @body@'+responseStr);
            if(code == 200){
                if(responseStr != null && String.isNotBlank(responseStr)){
                    ACET_BenefitCheckResponseWrap responseData = ACET_BenefitCheckResponseWrap.parse(responseStr);
                    system.debug('@responseData@'+responseData);
                    calloutResult.isSuccess = true;
                    calloutResult.Message = 'Success';
                    calloutResult.statusCode = code;
                    calloutResult.Response = responseData;
                }
            }
            else{
                calloutResult.isSuccess = false;
                calloutResult.Message = responseStr;
                calloutResult.statusCode = code;
            }
        }
        catch(Exception e){
            system.debug('@excep@'+e.getMessage());
            calloutResult.Message = e.getMessage();
        }
        return calloutResult;
    }

    public static ACET_BenefitCheckRequest getProessBenfitRequest(String benefitData){
        ACET_BenefitCheckRequest benefitCheckRequest = new ACET_BenefitCheckRequest();
        try{

            Map<String, Object> benefitDetailsMap = (Map<String, Object>)JSON.deserializeUntyped(benefitData);

            Map<String, Object> memberCardData = new Map<String, Object>();
            Map<String, Object> providerDetail = new Map<String, Object>();

            Map<String, Object> PACheckData = new Map<String, Object>();
            Map<String, Object> DOSAndPOS = new Map<String, Object>();
            Map<String, Object> ProcedureCode = new Map<String, Object>();
            List<Object> ProcedureCodesList = new List<Object>();
            Integer policyIndex = 0;

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
            if(benefitDetailsMap.containsKey('policyIndex')){
                policyIndex = Integer.valueof((benefitDetailsMap.get('policyIndex')));
            }

            benefitCheckRequest.certificationType = 'I';

            ACET_BenefitCheckRequest.Dates dates = new  ACET_BenefitCheckRequest.Dates();
            dates.fromDate = mapContainsString(DOSAndPOS, 'DateOfService');
            dates.toDate = mapContainsString(DOSAndPOS, 'DateOfService');
            dates.type = 'Event';
            benefitCheckRequest.dates = dates;
           	system.debug('==dates'+dates);

            ACET_BenefitCheckRequest.ServicingProviders servicingProvider = new ACET_BenefitCheckRequest.ServicingProviders();
            servicingProvider.MPIN = mapContainsString(providerDetail, 'providerId');
            servicingProvider.NPI = mapContainsString(providerDetail, 'npi');
            servicingProvider.TAX = mapContainsString(providerDetail, 'taxId');
            ACET_BenefitCheckRequest.Address providerAddress = new ACET_BenefitCheckRequest.Address();
            providerAddress.city = mapContainsString(providerDetail, 'AddressCity');
            providerAddress.line1 = mapContainsString(providerDetail, 'addressLine1');
            providerAddress.line2 = mapContainsString(providerDetail, 'addressLine2');
            providerAddress.state = mapContainsString(providerDetail, 'state');
            providerAddress.zip = mapContainsString(providerDetail, 'zip');

            servicingProvider.address = providerAddress;
            string provfilter= mapContainsString(providerDetail, 'filterType');
            servicingProvider.providerCategory = 'H';
            switch on provfilter{
                when 'P'{
                    servicingProvider.firstName = mapContainsString(providerDetail, 'firstName');
                    servicingProvider.lastName = mapContainsString(providerDetail, 'lastName');
                    servicingProvider.providerCategory = 'P';
                }
                when 'O' { servicingProvider.lastName = mapContainsString(providerDetail, 'businessName'); }
                when else {}
            }
            servicingProvider.primaryPhone = mapContainsString(providerDetail, 'phoneNumberSRN');

            servicingProvider.providerRole = 'SJ';

            List<ACET_BenefitCheckRequest.ServicingProviders> servicingProvidersList = new List<ACET_BenefitCheckRequest.ServicingProviders>();
            servicingProvidersList.add(servicingProvider);

            ACET_BenefitCheckRequest.ReferringProvider refPro = new ACET_BenefitCheckRequest.ReferringProvider();
            refPro.MPIN =  mapContainsString(providerDetail, 'providerId');
            refPro.NPI = mapContainsString(providerDetail, 'npi');
            refPro.TAX = mapContainsString(providerDetail, 'taxId');
            refPro.address = providerAddress;
            refPro.contact = null;
            refPro.firstName = servicingProvider.firstName;
            refPro.lastName =  servicingProvider.lastName;
            refPro.providerCategory = servicingProvider.providerCategory;
            benefitCheckRequest.referringProvider = refPro;

            benefitCheckRequest = prepareProcedureList(ProcedureCodesList,benefitCheckRequest,servicingProvidersList);

            benefitCheckRequest.levelOfService = 'E';
            String PlaceOfService = mapContainsString(mapPlaceOfService, mapContainsString(DOSAndPOS, 'PlaceOfService'));
            benefitCheckRequest.facilityType = PlaceOfService;

            ACET_BenefitCheckRequest.Patient patient = new ACET_BenefitCheckRequest.Patient();
            patient.SSN = mapContainsString(memberCardData, 'SSN');
            patient.firstName = mapContainsString(memberCardData, 'firstName');
            patient.lastName = mapContainsString(memberCardData, 'lastName');

            List<ACET_BenefitCheckRequest.MemberAddresses> memberAddressesList = new List<ACET_BenefitCheckRequest.MemberAddresses>();
            ACET_BenefitCheckRequest.MemberAddresses memberAddress = new ACET_BenefitCheckRequest.MemberAddresses();

            memberAddress.addressType = '1';
            memberAddress.address1 = memberDataResult.CoverageLines[policyIndex].patientInfo.AddressLine1;
            memberAddress.city = memberDataResult.CoverageLines[policyIndex].patientInfo.City;
            memberAddress.state = memberDataResult.CoverageLines[policyIndex].patientInfo.State;
            memberAddress.zip = memberDataResult.CoverageLines[policyIndex].patientInfo.Zip;
            patient.memberId = stringIsBlank(memberDataResult.CoverageLines[policyIndex].patientInfo.MemberId);
            String strDOB = stringIsBlank(memberDataResult.CoverageLines[policyIndex].patientInfo.dobVal);
            patient.dob = processDOB(strDOB);
            system.debug('=patient.dob ='+patient.dob );
            patient.genderType = stringIsBlank(memberDataResult.CoverageLines[policyIndex].patientInfo.gender);
            memberAddress.countryCode = '';
            memberAddress.zipSuffix = '';

            memberAddressesList.add(memberAddress);

            patient.memberAddresses = memberAddressesList;
            patient = preparePatient(extendeResult,patient);
            patient = preparePatientSub(extendeResult,patient);



            benefitCheckRequest.patient = patient;
            benefitCheckRequest.placeOfService = PlaceOfService;
            benefitCheckRequest.requestCategory = '1';
            benefitCheckRequest.serviceSettingType = '1';
            benefitCheckRequest.serviceType = '17';
            benefitCheckRequest.servicingProviders = servicingProvidersList;
            String currTimestamp = System.now().format('yyyy-MM-dd');
            benefitCheckRequest.transactionId = '';
            benefitCheckRequest.submissionDateTime = currTimestamp;
        }
        catch(Exception e){
            system.debug('@e@'+e.getMessage() + e.getCause()+e.getStackTraceString());
        }
        return benefitCheckRequest;
    }

    public static string processDOB(string strDOB){
        string strDOBirth = '';
        if(string.isNotBlank(strDOB)){
            List<String> dtDOB = strDOB.split('/');
            strDOBirth = dtDOB[2] + '-' + dtDOB[0] + '-' + dtDOB[1];
        }
        return strDOBirth;
    }

    public static ACET_BenefitCheckRequest prepareProcedureList(List<Object> ProcedureCodesList, ACET_BenefitCheckRequest bReq, List<ACET_BenefitCheckRequest.ServicingProviders> servicingProvidersList){
        List<ACET_BenefitCheckRequest.Procedures> proceduresList = new List<ACET_BenefitCheckRequest.Procedures>();
        List<ACET_BenefitCheckRequest.Diagnosis> diagnosisList = new List<ACET_BenefitCheckRequest.Diagnosis>();

        Integer i = 1;
        for(Object procedureObj : ProcedureCodesList){

            Map<String, Object> procedureMap = (Map<String, Object>)procedureObj;

            ACET_BenefitCheckRequest.Procedures procedures = new ACET_BenefitCheckRequest.Procedures();
            string code =  mapContainsString(procedureMap, 'procedureCode');
            if(string.isNotBlank(code)){
                procedures.code =  mapContainsString(procedureMap, 'procedureCode');
                procedures.numberOfPeriods = null;
                procedures.quantity = mapContainsString(procedureMap, 'count');
                procedures.quantityQualifier = mapContainsString(mapMeasure, mapContainsString(procedureMap, 'measure'));
                procedures.sampleModulus = mapContainsString(procedureMap, 'frequency');
                procedures.timePeriodQualifier = mapContainsString(mapMeasure, mapContainsString(procedureMap, 'measure'));
                procedures.unit = mapContainsString(procedureMap, 'units');
                procedures.dmeTotalCost =  mapContainsString(procedureMap, 'charge');
                procedures.servicingProviders = servicingProvidersList;
                proceduresList.add(procedures);
                ACET_BenefitCheckRequest.Diagnosis diagnosis = new ACET_BenefitCheckRequest.Diagnosis();
                diagnosis.code = mapContainsString((Map<String, Object>)ProcedureCodesList[i-1], 'diagnosisCode');
                diagnosis.type = 'ICD10';
                diagnosisList.add(diagnosis);
            }
            ++i;
        }
        bReq.diagnosis = diagnosisList;
        bReq.procedures = proceduresList;
        return bReq;
    }

    public static  ACET_BenefitCheckRequest.Patient preparePatient(ACET_ExtendedServiceController.ExtendedServiceWrapper extendeResult, ACET_BenefitCheckRequest.Patient patient){
        if(extendeResult != null && extendeResult.policyResultWrapper != null && extendeResult.policyResultWrapper.resultWrapper != null && extendeResult.policyResultWrapper.resultWrapper.policyRes != null){
                patient.subscriberID = stringIsBlank(extendeResult.policyResultWrapper.resultWrapper.policyRes.subscriberID);
                patient.sourceMemberID = extendeResult.policyResultWrapper.resultWrapper.policyRes.xrefId;
                patient.policyNumber = extendeResult.policyResultWrapper.resultWrapper.policyRes.policyNumber;
                patient.relationshipCode = extendeResult.policyResultWrapper.resultWrapper.policyRes.relationshipCode;

            }

        return patient;
    }

    public static  ACET_BenefitCheckRequest.Patient preparePatientSub(ACET_ExtendedServiceController.ExtendedServiceWrapper extendeResult, ACET_BenefitCheckRequest.Patient patient){
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

        return patient;
    }

    public Static String mapContainsString(Map<String, Object> mp, String vl){
        return ((mp.get(vl) != null && mp.containsKey(vl) && String.isNotBlank(String.valueOf(mp.get(vl))) && (String.valueOf(mp.get(vl)).length() > 0) ) ? String.valueOf(mp.get(vl)) : '');
    }

    public Static String stringIsBlank(Object vl){
        return (String.isNotBlank(String.valueOf(vl)) ? String.valueOf(vl) : null);
    }

    public static BenefitCheckRespWrap processBenifiResp(ACET_SAECalloutResult result){
        BenefitCheckRespWrap resp = new BenefitCheckRespWrap();
        Map<string,string> coverMap = new Map<string,string>();
        Map<string,string> codeMap = new Map<string,string>();
        Map<string,Spire_Benefit_Check_Remark_Codes__mdt> codeToHoverMap = new map<string,Spire_Benefit_Check_Remark_Codes__mdt>();
         processWrap p = new processWrap();
        p.coverMapp = coverMap;
        p.codeMapp = codeMap;
        ACET_BenefitCheckResponseWrap responseData = ACET_BenefitCheckResponseWrap.parse(JSON.serialize(result.Response));
        if(responseData != null && responseData.serviceLines != null &&  !responseData.serviceLines.isEmpty()) {
            p = processResp(responseData);
        }
        codeMap = p.codeMapp;
        if(codeMap != null && !codeMap.isEmpty()){
            for(Spire_Benefit_Check_Remark_Codes__mdt sr: [SELECT Payout_Categories__c, Id, QualifiedApiName, Benefit_Check_Claim_Remark__c, TOPS_Description__c
                                                           FROM Spire_Benefit_Check_Remark_Codes__mdt where Benefit_Check_Claim_Remark__c IN :codeMap.values()] ){
                                                               codeToHoverMap.put(sr.Benefit_Check_Claim_Remark__c,sr);
                                                           }
        }
        resp.calloutResult = result;
        resp.coverMap = p.coverMapp;
        resp.codeMap = p.codeMapp;
        resp.codeToHoverMap =  codeToHoverMap;
        system.debug('==resp'+resp);
        return resp;
    }

    public static processWrap processResp(ACET_BenefitCheckResponseWrap responseData){
        processWrap p = new processWrap();
         Map<string,string> coverMap = new Map<string,string>();
        Map<string,string> codeMap = new Map<string,string>();
            for(ACET_BenefitCheckResponseWrap.ServiceLines sl : responseData.serviceLines){
                coverMap.put(sl.procedureCode,'Undetermined');
                if(string.isNotBlank(sl.status)){
                    List<string> lstString = sl.status.split(' ');
                    if(lstString.size() == 2){
                        switch on lstString[0]{
                            when 'NCV'{
                                coverMap.put(sl.procedureCode,'Not Covered');
                            }
                            when 'COV'{
                                coverMap.put(sl.procedureCode,'Covered');
                            }
                        when else {}
                        }
                        codeMap.put(sl.procedureCode,lstString[1]);
                    }
                }
            }
        p.coverMapp = coverMap;
        p.codeMapp = codeMap;
        return p;
                                                           }
    public class processWrap{
        public Map<string,string> coverMapp;
        public Map<string,string> codeMapp;
        }
    public class BenefitCheckRespWrap{
        @AuraEnabled public ACET_SAECalloutResult calloutResult{get;set;}
        @AuraEnabled public Map<string,string> coverMap{get;set;}
        @AuraEnabled public Map<string,string> codeMap {get;set;}
        @AuraEnabled public Map<string,Spire_Benefit_Check_Remark_Codes__mdt> codeToHoverMap {get;set;}
    }
    
}