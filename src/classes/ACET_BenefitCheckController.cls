/*
 * @Desc: US2974834 - Controller Class for Benefit Check API Callouts  
 * @Date: 18-12-2020
 * @Dev: Kavinda
 */
public without sharing class ACET_BenefitCheckController {

    @AuraEnabled
    public static BenefitResultWrapper benefitCheck(String benefitData){ 
        ACET_BenefitCheckWS wbService = new ACET_BenefitCheckWS(); 
        ACETWSCalloutResult CalloutResult = wbService.benefitCheck(benefitData); 
        BenefitResultWrapper wrapper = new BenefitResultWrapper();
        wrapper.resultWrapper = (ACET_BenefitCheckResponseWrap) CalloutResult.Response;
        wrapper.message = CalloutResult.Message;
        wrapper.statusCode = CalloutResult.statusCode; 
        wrapper.success = CalloutResult.Success; 
        return wrapper;  
    }
        
    public class BenefitResultWrapper {
        @AuraEnabled public ACET_BenefitCheckResponseWrap resultWrapper {get;set;}
        @AuraEnabled public String message {get;set;}
        @AuraEnabled public Integer statusCode {get;set;}
        @AuraEnabled public Boolean success {get;set;}
    }

    public class PriorAuthInquiryWrap {
        @Auraenabled Public Integer statusCode {set;get;}
        @Auraenabled Public String failedProCode {set;get;}
        @Auraenabled Public String failedDiagCode {set;get;}
        @Auraenabled Public String disclaimerText {set;get;}
	    @Auraenabled Public List<PreliminaryDetermination> preliminaryDetermination {set;get;}
    }

    public class SiteOfService {
		@Auraenabled Public String siteOfServiceType {set;get;}
		@Auraenabled Public String siteOfServiceDescription {set;get;}
		@Auraenabled Public String decisionCode {set;get;}
		@Auraenabled Public String decisionDescription {set;get;}
		@Auraenabled Public List<ConditionType> conditionType {set;get;}
	}
	public class PreliminaryDetermination {
		@Auraenabled Public String decisionSummaryText {set;get;}
		@Auraenabled Public String procedureCode {set;get;}
		@Auraenabled Public List<SiteOfService> siteOfService {set;get;}
	}

	Public class ConditionType {
		@Auraenabled Public String conditionName {set;get;}
		@Auraenabled Public String conditionDetail {set;get;}
	}

    @AuraEnabled
    public static SAEPolicyDetailsController.RCEDResponseWrap getRCEDres(String subscriberId, String policyNumber, String sourceCode){
        SAEPolicyDetailsController.RCEDResponseWrap resRCED = new SAEPolicyDetailsController.RCEDResponseWrap(); //= SAEPolicyDetailsController.call_RCED_API(subscriberId,policyNumber,sourceCode);
        system.debug('resRCED: '+resRCED);
        //String vendorBenefitOptionTypeCode = resRCED.Vendor.vendorBenefitOptionTypeCode;
        //String healthServiceProductCode = resRCED.Vendor.healthServiceProductCode;
        //
        Boolean isStaticResponseChecked = false;
        isStaticResponseChecked = SAEUtils.getMockStatus();
        if(isStaticResponseChecked && !Test.isRunningTest()) {
            String searchparameter = 'RCED_'+subscriberId+'_'+policyNumber+'_'+sourceCode;
            HttpResponse response = SAEUtils.getResponse(searchparameter);
            resRCED = SAEPolicyDetailsController.get_RCED_MockData(response);
        } else{
            resRCED = SAEPolicyDetailsController.call_RCED_API(subscriberId,policyNumber,sourceCode);
        }

        return resRCED;
    }

    // US3304569 - Thanish - 18th Mar 2021
    @AuraEnabled
    public static PesResWrapper getPESres(String providerId, String taxId, String addressSeq){
        PesResWrapper retWrapper = new PesResWrapper();
        Boolean isParticipating = false;
        //Map<String, String> resPES = new Map<String, String>();

        ACET_ProviderContractService providerContractService = new ACET_ProviderContractService();
        ACETWSCalloutResult calloutResult = providerContractService.getEAndIContracts(providerId, taxId, addressSeq, null, null, null, true);
        system.debug('calloutResult: '+calloutResult);
        if (calloutResult.Success) {
            //resPES.put('isSuccess','true');
            ACET_EAndIContractsResponse contractResponse = (ACET_EAndIContractsResponse) calloutResult.Response;
            for (ACET_EAndIContractsResponse.Employerandindividual employerAndIndividual: contractResponse.employerandindividual) {
                //pnc_ipa_nbr
                if(employerAndIndividual.pnc_ipa_nbr =='990' || employerAndIndividual.pnc_ipa_nbr =='137' || employerAndIndividual.pnc_ipa_nbr =='138'){
                    isParticipating = true;
                    //resPES.put('isParticipating','true');
        }else{
                    //resPES.put('isParticipating','false');
                }
            }
        }
        // US3304569 - Thanish - 18th Mar 2021
        retWrapper.statusCode=calloutResult.statusCode;
        retWrapper.isParticipating=isParticipating;
        return retWrapper;
        }

    // US3304569 - Thanish - 18th Mar 2021
    public class PesResWrapper {
        @AuraEnabled Public Integer statusCode;
	    @AuraEnabled Public Boolean isParticipating;

        public PesResWrapper(){
            statusCode=200; isParticipating=false;
        }
    }

     @AuraEnabled
        public static ACET_SAECalloutResult getMedicalValues(ACET_MedNecService.medNecInputParams input){
            return ACET_MedNecService.getMedNecHoverValues(input);
        }

    Public class PESResponse {
        @Auraenabled public Integer statusCode {get;set;}
        @Auraenabled public Boolean Success { get; set; }
        @Auraenabled public Boolean isParticipating { get; set; }
    }

    // US3314837 BenifitCheck PriorAuthInquiry Integration - Continuation
    @AuraEnabled(continuation=true cacheable=true)
    public static Object getPriorAuthInquiry(String priorAuthData){

        System.debug(Logginglevel.INFO, 'ACET_BenefitCheckController -> benefitCheck() -> priorAuthData: ' + priorAuthData);

        try {

            Map<String, Object> priorAuthMap = (Map<String, Object>)JSON.deserializeUntyped(priorAuthData);
            ACET_WebserviceCalloutFramework wsCallOutFW = null;

            Boolean isStaticResponseChecked = false;
            isStaticResponseChecked = SAEUtils.getMockStatus();

            Map<String, Object> codesMap = (Map<String, Object>)JSON.deserializeUntyped(String.valueOf(priorAuthMap.get('codesMap')));
            List<String> lstKeys = new List<String>(codesMap.keySet());

            if(isStaticResponseChecked && !Test.isRunningTest()) {
                wsCallOutFW = generatePriorAuthInquiryRequests(priorAuthMap, codesMap, lstKeys, 0);
                HttpResponse response = ACET_WebserviceMockFramework.getMockResponse(wsCallOutFW.serviceName, wsCallOutFW.requestParamsMap, '', null);
                ACET_BenefitCheckController.PriorAuthInquiryWrap inquiryResult = generatePriorAuthInquiryResponse(response, null, 1);
                List<ACET_BenefitCheckController.PriorAuthInquiryWrap> lstResp = new List<ACET_BenefitCheckController.PriorAuthInquiryWrap>();
                lstResp.add(inquiryResult);
                System.debug(LoggingLevel.INFO, 'Mock-inquiryResult -> ' + inquiryResult);
                return lstResp;
            }

            Continuation con = new Continuation(120);
            con.continuationMethod = 'processResponse';
            List<ACET_WebserviceCalloutFramework> lstwsCallOutFW = new List<ACET_WebserviceCalloutFramework>();

            System.debug(Logginglevel.INFO, 'ACET_BenefitCheckController -> benefitCheck() -> lstKeys.size(): ' + lstKeys.size());

            if(0 < lstKeys.size()){
                for(Integer i = 0; i < 3; i++){
                    if(lstKeys.size() > i){
                        wsCallOutFW = generatePriorAuthInquiryRequests(priorAuthMap, codesMap, lstKeys, i);
                        lstwsCallOutFW.add(wsCallOutFW);
                        con.addHttpRequest(wsCallOutFW.getHttpRequest());
                        System.debug(LoggingLevel.INFO, 'ACET_BenefitCheckController -> benefitCheck() -> HttpRequest ' + (i + 1) + ' -> ' + wsCallOutFW.getHttpRequest());
                    }
                }
                if(lstKeys.size() >= 4){
                    wsCallOutFW = generatePriorAuthInquiryRequests(priorAuthMap, codesMap, lstKeys, 3);
                    lstwsCallOutFW.add(wsCallOutFW);
                    System.debug(LoggingLevel.INFO, 'ACET_BenefitCheckController -> benefitCheck() -> HttpRequest 4 -> ' + wsCallOutFW.getHttpRequest());
                }
                if(lstKeys.size() == 5){
                    wsCallOutFW = generatePriorAuthInquiryRequests(priorAuthMap, codesMap, lstKeys, 4);
                    lstwsCallOutFW.add(wsCallOutFW);
                    System.debug(LoggingLevel.INFO, 'ACET_BenefitCheckController -> benefitCheck() -> HttpRequest 5 -> ' + wsCallOutFW.getHttpRequest());
                }
            }
            con.state = lstwsCallOutFW;

            return con;


        } catch(Exception e) {
            System.debug(LoggingLevel.ERROR, 'ACET_BenefitCheckController -> benefitCheck() -> Exception: ' + e.getLineNumber() + ' - ' + e.getStackTraceString());
        }

        return null;

    }

    @AuraEnabled(cacheable=true)
    public static List<ACET_BenefitCheckController.PriorAuthInquiryWrap> processResponse(List<String> labels, Object state) {

        List<ACET_WebserviceCalloutFramework> lstwsCallOutFW;
        if(state != null){
            lstwsCallOutFW = (List<ACET_WebserviceCalloutFramework>)state;
        }

        List<ACET_BenefitCheckController.PriorAuthInquiryWrap> lstResp = new List<ACET_BenefitCheckController.PriorAuthInquiryWrap>();

        if(0 < labels.size()){
            lstResp.add(generatePriorAuthInquiryResponse(Continuation.getResponse(labels[0]), lstwsCallOutFW[0], 1));
        }

        if(1 < labels.size()){
            lstResp.add(generatePriorAuthInquiryResponse(Continuation.getResponse(labels[1]), lstwsCallOutFW[1], 2));
        }

        if(2 < labels.size()){
            lstResp.add(generatePriorAuthInquiryResponse(Continuation.getResponse(labels[2]), lstwsCallOutFW[2], 3));
        }

        if(lstwsCallOutFW != null){
            if(lstwsCallOutFW.size() >= 4 && lstwsCallOutFW[3] != null){
                lstResp.add(generatePriorAuthInquiryResponse(lstwsCallOutFW[3].getResponse(), lstwsCallOutFW[3], 4));
            }
            if(lstwsCallOutFW.size() == 5 && lstwsCallOutFW[4] != null){
                lstResp.add(generatePriorAuthInquiryResponse(lstwsCallOutFW[4].getResponse(), lstwsCallOutFW[4], 5));
            }
        }

        return lstResp;
    }

    public static ACET_WebserviceCalloutFramework generatePriorAuthInquiryRequests(Map<String, Object> priorAuthMap, Map<String, Object> codesMap, List<String> lstKeys, Integer i){
        ACET_WebserviceCalloutFramework wsCallOutFW = new ACET_WebserviceCalloutFramework();
        wsCallOutFW.serviceName = 'LinkPriorAuthInquiry';
        String diagCode = String.valueOf(lstKeys[i]).replace('"','');
        Map<String, String> requestParamsMap = new Map<String, String>();
        requestParamsMap.put('cptCode',  String.valueOf(codesMap.get(diagCode)).removeEnd(','));
        requestParamsMap.put('diagnosisCode', diagCode);
        requestParamsMap.put('payerId', '87726');
        requestParamsMap.put('planTypeCode', String.valueOf(priorAuthMap.get('planTypeCode')).replace('"',''));
        requestParamsMap.put('stateOfIssueCode', String.valueOf(priorAuthMap.get('stateOfIssueCode')).replace('"','')); //  'MD'
        requestParamsMap.put('taxIdNumber', String.valueOf(priorAuthMap.get('taxIdNumber')).replace('"',''));
        wsCallOutFW.requestParamsMap = requestParamsMap;
        wsCallOutFW.encodeURLParameters = true;
        return wsCallOutFW;
    }

    public static ACET_BenefitCheckController.PriorAuthInquiryWrap generatePriorAuthInquiryResponse(HttpResponse httpResp, ACET_WebserviceCalloutFramework wsCallOutFW, Integer num){
        ACET_BenefitCheckController.PriorAuthInquiryWrap inquiryResult = new ACET_BenefitCheckController.PriorAuthInquiryWrap();
        System.debug(LoggingLevel.INFO, 'ACET_BenefitCheckController -> generatePriorAuthInquiryResponse() -> getBody-' + num + ': '+ httpResp.getBody());
        if (httpResp.getStatusCode() == 200) {
            inquiryResult = (ACET_BenefitCheckController.PriorAuthInquiryWrap)System.JSON.deserialize(httpResp.getBody(),ACET_BenefitCheckController.PriorAuthInquiryWrap.class);
            inquiryResult.statusCode = httpResp.getStatusCode();
        }else {
            inquiryResult.statusCode = httpResp.getStatusCode();
            inquiryResult.failedProCode = wsCallOutFW.requestParamsMap.get('cptCode');
            inquiryResult.failedDiagCode = wsCallOutFW.requestParamsMap.get('diagnosisCode');
        }
        System.debug(LoggingLevel.INFO, 'ACET_BenefitCheckController -> generatePriorAuthInquiryResponse() -> inquiryResult-' + num + ': '+ inquiryResult);
        return inquiryResult;
    }

    //US3487597 - Sravan
    @AuraEnabled
    public static String getProviderNotificationTool(){
        String providerNotificationTool = '';
        providerNotificationTool = SAEUtils.getProviderNotification();
        return providerNotificationTool;
    }

    @AuraEnabled
    public static ACET_BenefitSpInService.BenefitCheckRespWrap  getBenefitCheckData(String benefitData){
        system.debug('@benefitData@'+benefitData);
        ACET_BenefitSpInService.BenefitCheckRespWrap finalRes = new ACET_BenefitSpInService.BenefitCheckRespWrap();

        ACET_BenefitCheckRequest req = new ACET_BenefitCheckRequest();
        req = ACET_BenefitSpInService.getProessBenfitRequest(benefitData);
        system.debug('@req@'+req);
        ACET_SAECalloutResult res = ACET_BenefitSpInService.callBenefitCheck(req);
        finalRes = new ACET_BenefitSpInService.BenefitCheckRespWrap();

        if(res.isSuccess && res.statusCode == 200){
            finalRes = ACET_BenefitSpInService.processBenifiResp(res);
        }
        else{
            finalRes.calloutResult = res;
        }
        system.debug('@finalRes@'+finalRes);
        return finalRes;
    }

    @AuraEnabled
    public static Map<String,List<KLData>> getKLData(string klInputs){
        List<KL_Data__c> klDataRecList = new List<KL_Data__c>();
        List<KL_Data__c> ProcedureCodeList = new List<KL_Data__c>();
        List<KL_Data__c> DiagnosisCodeList = new List<KL_Data__c>();
        List<KLData> klDataList = new List<KLData>();
        Map<String,KLData> klDataMap = new Map<String,KLData>();
        Map<String,List<KLData>> klExtractDataMap = new Map<String,List<KLData>>();
        try{


            system.debug('klInputs: '+klInputs);
            Map<String, Object> klInputsMap = (Map<String, Object>)JSON.deserializeUntyped(klInputs);

            system.debug('klInputsMap: '+klInputsMap);

            List<String> procedureCodes = new List<String>();
            List<String> diagnosisCodes = new List<String>();

            if (klInputsMap.containsKey('procedureCodes')) {
                string strPcodes = String.valueOf(klInputsMap.get('procedureCodes')) ;
                system.debug('strPcodes:: '+strPcodes);
                procedureCodes = strPcodes.split(',');
                //(List<String>)JSON.deserializeUntyped(strPcodes);
                //procedureCodes = (List<String>)klInputsMap.get('procedureCodes');
                //system.debug('strPcodes:: '+strPcodes);
                //procedureCodes = klInputsMap.get('procedureCodes');
                system.debug('procedureCodes:: '+procedureCodes);
            }
            if (klInputsMap.containsKey('diagnosisCode')) {
                string strDcodes = String.valueOf(klInputsMap.get('diagnosisCode')) ;
                diagnosisCodes = strDcodes.split(',');//(List<String>)JSON.deserializeUntyped(strDcodes);
                system.debug('diagnosisCodes:: '+diagnosisCodes);
                //diagnosisCodes = (List<String>)JSON.deserializeUntyped(klInputsMap.get('diagnosisCode'));
            }

            ProcedureCodeList=[select id, Name,Code_Type__c,Code_Description__c,Description__c,Code_Indicator_Type__c,Value__c from KL_Data__c where (Name in :procedureCodes) AND (Code_Type__c='CPT' OR Code_Type__c='HCPCS') ORDER BY Name];
            system.debug('ProcedureCodeList: '+ProcedureCodeList);
            DiagnosisCodeList=[select id, Name,Code_Type__c,Code_Description__c,Description__c,Code_Indicator_Type__c,Value__c from KL_Data__c where (Name in :diagnosisCodes) AND (Code_Type__c='ICD10 Diagnosis') ORDER BY Name];
            for(KL_Data__c pc: ProcedureCodeList){
                klDataRecList.add(pc);
            }
            for(KL_Data__c dc: DiagnosisCodeList){
                klDataRecList.add(dc);
            }

            for(KL_Data__c kl: klDataRecList){
                List<KLData> kleDataList = new List<KLData>();
                KLData klRec = new KLData();
                klRec.code = kl.name;
                klRec.Description = kl.Description__c;
                klRec.CodeIndicatorType = kl.Code_Indicator_Type__c;
                klRec.Value = kl.Value__c;
                klRec.CodeDescription = kl.Code_Description__c;
                klDataList.add(klRec);
                klDataMap.put(kl.name, klRec);
                system.debug('klRec: '+klRec);
                if(klExtractDataMap.containsKey(kl.name)){
                    kleDataList = klExtractDataMap.get(kl.name);
                    kleDataList.add(klRec);
                    klExtractDataMap.put(kl.name, kleDataList);
                }else{
                    kleDataList.add(klRec);
                    klExtractDataMap.put(kl.name, kleDataList);
                }
            }
            system.debug('klDataList: '+klDataList);
            system.debug('klDataMap: '+klDataMap);
            return klExtractDataMap;
        }catch(exception e){
            system.debug('exception kldata: '+e.getCause()+' : '+e.getLineNumber()+' : '+e.getMessage()+' : '+e.getStackTraceString());
            return klExtractDataMap;
        }
    }

    public class KLData {
        @AuraEnabled public String code {get;set;}
        @AuraEnabled public String Description {get;set;}
        @AuraEnabled public String CodeIndicatorType {get;set;}
        @AuraEnabled public String Value {get;set;}
        @AuraEnabled public String CodeDescription {get;set;}
    }

}