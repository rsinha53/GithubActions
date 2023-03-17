public with sharing class ACETLGT_NimbusGetSSBAPI {
    
    public ACETGroupPlanBenefitLEXWrapper groupPlanWrapper;
    public set <String> benefitCodeSet {get;set;}
    public Map <String, String> primaryIndicatorVsDescMap;
    public static final String TIME_PLAN_QUALIFIER = 'Plan Year';
    public static final String TIME_CALENDAR_QUALIFIER = 'Calendar Year';
    public Map<String, String> planTypeCodeMap {get; set;}
    public Map<String,String> gatedPCPMap {get; set;}
    public Map<String,String> coverageTypeMap {get; set;} 
    
    public String getRequestBody(String surrogateKey, String bundleId, String enrollerSRK, String startDate, String endDate, String coverageTypes, String groupNumber, String accumsDate, String accumAsOf,String customerPurchaseId) {
        System.debug('>>>getRequestBody Method Start...');
        startDate = ACETWebServicehelper.formatToYYYYMMDD(startDate);
        endDate = ACETWebServicehelper.formatToYYYYMMDD(endDate);
        String requestBody = new ACETLGT_NimbusGetSSBRequest().addSearchInput( bundleId,  enrollerSRK, surrogateKey,  startDate,  endDate, coverageTypes,  groupNumber,  accumsDate,  accumAsOf, customerPurchaseid);
       
        System.debug('>>>Request Body : ' + requestBody);
        System.debug('>>>getRequestBody Method End...');
        return requestBody;
    }
    private String getRequestBodyParam(String bundleId, String enrollerSRK, String subscriberSRK, String startDate, String endDate, String coverageTypes, String groupNumber,string accumAsOf,String customerPurchaseId)
    {
        System.debug('>>>getRequestBodyParam Method Start...');
        startDate = ACETWebServicehelper.formatToYYYYMMDD(startDate);
        endDate = ACETWebServicehelper.formatToYYYYMMDD(endDate);
        String requestBody = new ACETLGT_NimbusGetSSBRequest().addSearchInput( bundleId,  enrollerSRK,  subscriberSRK,  startDate,  endDate,  coverageTypes,  groupNumber, '',  accumAsOf, customerPurchaseid);
		System.debug('>>>Request Body : ' + requestBody);
        System.debug('>>>getRequestBodyParam Method End...');
        return requestBody;
    }   
    public void getErrorMessage(ACETWSCalloutResult calloutResult){
        System.debug('>>>getErrorMessage Method Start...');
        if(calloutResult.statusCode != null && calloutResult.statusCode == 400)
            calloutResult.Message = ACETUtility.getErrorMessage('GN400B'); 
        else if(calloutResult.statusCode != null && calloutResult.statusCode == 404){
            calloutResult.Message = ACETUtility.getErrorMessage('GN404');
            calloutResult.MessageSeverity = ApexPages.Severity.Info; 
        }
        else if(calloutResult.statusCode != null && calloutResult.statusCode == 500)
            calloutResult.Message = ACETUtility.getErrorMessage('GN500'); 
        else if(calloutResult.statusCode != null && calloutResult.statusCode == 504)
            calloutResult.Message = ACETUtility.getErrorMessage('GN504'); 
        else
            calloutResult.Message = ACETUtility.getErrorMessage('GN999');
        System.debug('>>>getErrorMessage Method End...');
    }
    public ACETWSCalloutResult init(String surrogateKey, String bundleId, String enrollerSRK, String startDate,
        String endDate, String coverageTypes, String groupNumber, String accumsDate, String accumAsOf, Boolean isActive, Boolean isTermed,String customerPurchaseId) {
		System.debug('>>>init Method Start...');
        ACETWSCalloutResult calloutResult = new ACETWSCalloutResult();

        try {

            ACET_WebserviceCalloutFramework wsCallOutFW = new ACET_WebserviceCalloutFramework();
            wsCallOutFW.serviceName = 'NimbusGetSSBService';
            String requestBody = getRequestBody(surrogateKey, bundleId, enrollerSRK, startDate, endDate, coverageTypes, groupNumber,accumsDate, accumAsOf,customerPurchaseId);
            wsCallOutFW.requestBody = requestBody; 
            HttpResponse httpResponse  = wsCallOutFW.getResponse();

            if(httpResponse!=null && httpResponse.getStatusCode() == 200){ 
                String responseBody = httpResponse.getBody();
                system.debug('>>>Status Code : '+ httpResponse.getStatusCode());
                system.debug('>>>Response Body : '+ responseBody);
                responseBody = JSON.serialize(JSON.deserialize(responseBody, ACETLGT_NimbusGetSSBResponse.class));
                calloutResult.Success = true;
                calloutResult.statusCode = 200;
                calloutResult.Message = '';
                calloutResult.Response = parseSuccessAdapterResponse(responseBody,isActive, isTermed);
                System.debug('>>Parsed Response : ' + JSON.serialize(calloutResult.Response));
                calloutResult.responseBody = responseBody;
            }
            else{
                calloutResult.MessageSeverity = ApexPages.Severity.ERROR;
                calloutResult.Success = false;
                calloutResult.statusCode = (httpResponse == null) ? 999 : httpResponse.getStatusCode();
                getErrorMessage(calloutResult);
            }           
        } catch (Exception e) {
            System.debug('ACETLGT_NimbusGetSSBAPI: init() - ' + e.getLineNumber() + ' ' + e.getMessage());
            calloutResult.Success = false;
            calloutResult.Message = ACETUtility.getErrorMessage('GN999');
            calloutResult.statusCode = 999;

        }
        System.debug('>>>init Method End...');
        return calloutResult;
    }
    public ACETWSCalloutResult getSubscriptionBenefitSearch(String surrogateKey, String bundleId, String enrollerSRK, String startDate,
        String endDate, String coverageTypes, String groupNumber, String accumAsOf,String situsState,String customerPurchaseId) {
            return getSubBenefitSearch(surrogateKey, bundleId, enrollerSRK,  startDate,
         endDate,  coverageTypes,  groupNumber,  accumAsOf, situsState,null,customerPurchaseId);
        }
    public ACETWSCalloutResult getSubBenefitSearch(String surrogateKey, String bundleId, String enrollerSRK, String startDate,
        String endDate, String coverageTypes, String groupNumber, String accumAsOf,String situsState,String planId,String customerPurchaseId) {
		System.debug('>>>getSubBenefitSearch Method Start...');
        ACETWSCalloutResult calloutResult = new ACETWSCalloutResult();

        try {
			ACET_WebserviceCalloutFramework wsCallOutFW = new ACET_WebserviceCalloutFramework();
            wsCallOutFW.serviceName = 'NimbusGetSSBService';
            String requestBody = getRequestBodyParam(surrogateKey, bundleId, enrollerSRK, startDate, endDate, coverageTypes, groupNumber,accumAsOf,customerPurchaseId);
            wsCallOutFW.requestBody = requestBody; 
            HttpResponse httpResponse  = wsCallOutFW.getResponse();
			if(httpResponse!=null && httpResponse.getStatusCode() == 200){ 
                String responseBody = httpResponse.getBody();
                system.debug('>>>Status Code : '+ httpResponse.getStatusCode());
                system.debug('>>>Response Body : '+ responseBody);
                calloutResult.Success = true;
                calloutResult.statusCode = 200;
                calloutResult.Message = '';
                calloutResult.Response = processResponse(responseBody,situsState,planId);
                System.debug('>>Parsed Response : ' + JSON.serialize(calloutResult.Response));
                calloutResult.responseBody = responseBody;
            }
            else{
                calloutResult.MessageSeverity = ApexPages.Severity.ERROR;
                calloutResult.Success = false;
                calloutResult.statusCode = (httpResponse == null) ? 999 : httpResponse.getStatusCode();
                getErrorMessage(calloutResult);
            }           
        } catch (Exception e) {
            System.debug('ACETLGT_NimbusGetSSBAPI: getSubscriptionBenefitSearch() - ' + e.getLineNumber() + ' ' + e.getMessage());
            calloutResult.Success = false;
            calloutResult.Message = ACETUtility.getErrorMessage('GN999');
            calloutResult.statusCode = 999;

        }
		System.debug('>>>getSubBenefitSearch Method End...');
        return calloutResult;
    }

    public void getNetworkLevelAccumulator(ACETLGT_NimbusGetSSBResponse.planTier benefitTier, ACETGroupPlanBenefitLEXWrapper groupPlanWrapper){
        System.debug('>>>getNetworkLevelAccumulator Method Start...');
        if(benefitTier.tierTypeCode == 'INN' && benefitTier.accumulatorAmounts != null && !benefitTier.accumulatorAmounts.isEmpty()){
            ACETLGT_NimbusGetSSBResponse.AccumulatorAmount accumAmount = benefitTier.accumulatorAmounts[0];
            // IN NETWORK
            
            groupPlanWrapper.IIN_PLAN_MIN = groupPlanWrapper.validateValue(accumAmount.individualDeductibleYTD);
            groupPlanWrapper.IIN_PLAN_MAX = groupPlanWrapper.validateValue(accumAmount.individualDeductibleMaximum).split('\\.')[0];
            groupPlanWrapper.IIN_OOP_MIN = groupPlanWrapper.validateValue(accumAmount.individualOOPYTD);
            groupPlanWrapper.IIN_OOP_MAX = groupPlanWrapper.validateValue(accumAmount.individualOOPMaximum).split('\\.')[0];
            groupPlanWrapper.FIN_PLAN_MIN = groupPlanWrapper.validateValue(accumAmount.familyDeductibleYTD);
            groupPlanWrapper.FIN_PLAN_MAX = groupPlanWrapper.validateValue(accumAmount.familyDeductibleMaximum).split('\\.')[0];
            groupPlanWrapper.FIN_OOP_MIN = groupPlanWrapper.validateValue(accumAmount.familyOOPYTD);
            groupPlanWrapper.FIN_OOP_MAX = groupPlanWrapper.validateValue(accumAmount.familyOOPMaximum).split('\\.')[0];
            groupPlanWrapper.IIN_Primary_Accum_Deduct = getValueAfterStringValidation(accumAmount.familyAccumulationTypeDescriptionDeductible, 'N/A');
            groupPlanWrapper.IIN_Primary_Accum_OOP = getValueAfterStringValidation(accumAmount.familyAccumulationTypeDescriptionOOP, 'N/A');
            groupPlanWrapper.FIN_Primary_Accum_Deduct = getValueAfterStringValidation(accumAmount.familyAccumulationTypeDescriptionDeductible, 'N/A');
            groupPlanWrapper.FIN_Primary_Accum_OOP = getValueAfterStringValidation(accumAmount.familyAccumulationTypeDescriptionOOP, 'N/A');
            
        } 
        else if(benefitTier.tierTypeCode == 'OON'&& benefitTier.accumulatorAmounts != null && !benefitTier.accumulatorAmounts.isEmpty()){
            ACETLGT_NimbusGetSSBResponse.AccumulatorAmount accumAmount = benefitTier.accumulatorAmounts[0];
            // OUT NETWORK
            groupPlanWrapper.ION_PLAN_MIN = groupPlanWrapper.validateValue(accumAmount.individualDeductibleYTD);
            groupPlanWrapper.ION_PLAN_MAX = groupPlanWrapper.validateValue(accumAmount.individualDeductibleMaximum).split('\\.')[0];
            groupPlanWrapper.ION_OOP_MIN = groupPlanWrapper.validateValue(accumAmount.individualOOPYTD);
            groupPlanWrapper.ION_OOP_MAX = groupPlanWrapper.validateValue(accumAmount.individualOOPMaximum).split('\\.')[0];
            groupPlanWrapper.FON_PLAN_MIN = groupPlanWrapper.validateValue(accumAmount.familyDeductibleYTD);
            groupPlanWrapper.FON_PLAN_MAX = groupPlanWrapper.validateValue(accumAmount.familyDeductibleMaximum).split('\\.')[0];
            groupPlanWrapper.FON_OOP_MIN = groupPlanWrapper.validateValue(accumAmount.familyOOPYTD);
            groupPlanWrapper.FON_OOP_MAX = groupPlanWrapper.validateValue(accumAmount.familyOOPMaximum).split('\\.')[0];
            groupPlanWrapper.ION_Primary_Accum_Deduct = getValueAfterStringValidation(accumAmount.familyAccumulationTypeDescriptionDeductible, 'N/A');
            groupPlanWrapper.ION_Primary_Accum_OOP = getValueAfterStringValidation(accumAmount.familyAccumulationTypeDescriptionOOP, 'N/A');
            groupPlanWrapper.FON_Primary_Accum_Deduct = getValueAfterStringValidation(accumAmount.familyAccumulationTypeDescriptionDeductible, 'N/A');
            groupPlanWrapper.FON_Primary_Accum_OOP = getValueAfterStringValidation(accumAmount.familyAccumulationTypeDescriptionOOP, 'N/A');
            
    	}
		System.debug('>>>getNetworkLevelAccumulator Method End...');
    }
    private void getTimePeriodQualifierInfo(ACETLGT_NimbusGetSSBResponse.membership memObj, Boolean isActive, Boolean isTermed)
    {
        System.debug('>>>getTimePeriodQualifierInfo Method Start...');
        if (memObj.timePeriodQualifier != NULL && memObj.timePeriodQualifier == TIME_PLAN_QUALIFIER) {
            groupPlanWrapper.PLAN_CALENDAR_YEAR = ACETWebServicehelper.formatDateFromDashToSlash(memObj.contractOptionStartDate) + ' - ' + ACETWebServicehelper.formatDateFromDashToSlash(memObj.contractOptionEndDate);
            groupPlanWrapper.TIME_PERIOD_QUALIFIER = TIME_PLAN_QUALIFIER;
        } else if (memObj.timePeriodQualifier != NULL && memObj.timePeriodQualifier == TIME_CALENDAR_QUALIFIER) {
            //For Calendar Year
            //Check the Status of the Coverage
            //If Active -> Gets TODAY and Shows 1/1/2019 - 12/31/2019
            //If Termed -> Pending
            //If Future -> Pending
            
            groupPlanWrapper.TIME_PERIOD_QUALIFIER = TIME_CALENDAR_QUALIFIER;
            String firstDateStr = '01/01';
            String lastDateStr = '12/31';
            if (isActive) {                                
                String firstDate = firstDateStr + System.today().year();
                String lastDate =  lastDateStr +System.today().year();
                groupPlanWrapper.PLAN_CALENDAR_YEAR = firstDate + '-' + lastDate;
            } else if (isTermed) {
                groupPlanWrapper.PLAN_CALENDAR_YEAR = firstDateStr + memObj.coverageEndDate.split('-')[0] + ' - ' + lastDateStr + memObj.coverageEndDate.split('-')[0];                             
                
            } else {
                groupPlanWrapper.PLAN_CALENDAR_YEAR = firstDateStr + memObj.coverageStartDate.split('-')[0] + ' - ' + lastDateStr + memObj.coverageStartDate.split('-')[0];
            }
            system.debug('groupPlanWrapper.PLAN_CALENDAR_YEAR 2:::'+groupPlanWrapper.PLAN_CALENDAR_YEAR);
        }
		System.debug('>>>getTimePeriodQualifierInfo Method End...');
    }
    private void getAsOfDate(ACETLGT_NimbusGetSSBResponse.membership memObj, Boolean isActive, Boolean isTermed){
        System.debug('>>>getAsOfDate Method Start...');
        if (isActive){
            groupPlanWrapper.AS_OF_DATE = ACETUtility.format(System.today());
        }else if (isTermed){
            groupPlanWrapper.AS_OF_DATE = String.valueof(ACETUtility.format(Date.valueof(memObj.coverageEndDate)));
        }else{
            groupPlanWrapper.AS_OF_DATE = String.valueof(ACETUtility.format(Date.valueof(memObj.coverageStartDate)));
        }
        System.debug('>>>getAsOfDate Method End...');
    }
    private void getBenefitSectionInfo(ACETLGT_NimbusGetSSBResponse.benefitPlan benefitSectionInfo, Boolean isActive, Boolean isTermed){
		System.debug('>>>getBenefitSectionInfo Method Start...');
        if (benefitSectionInfo.riderOnlyFlag == 'false') {
            if(benefitSectionInfo.planTier != null) {
                // Initialize IN NETWORK Accum Details
                groupPlanWrapper.IIN_PLAN_MIN = 'N/A';
                groupPlanWrapper.IIN_PLAN_MAX = 'N/A';
                groupPlanWrapper.IIN_OOP_MIN = 'N/A';
                groupPlanWrapper.IIN_OOP_MAX = 'N/A';
                groupPlanWrapper.FIN_PLAN_MIN = 'N/A';
                groupPlanWrapper.FIN_PLAN_MAX = 'N/A';
                groupPlanWrapper.FIN_OOP_MIN = 'N/A';
                groupPlanWrapper.FIN_OOP_MAX = 'N/A';
                groupPlanWrapper.IIN_Primary_Accum_Deduct = 'N/A';
                groupPlanWrapper.IIN_Primary_Accum_OOP = 'N/A';
                groupPlanWrapper.FIN_Primary_Accum_Deduct = 'N/A';
                groupPlanWrapper.FIN_Primary_Accum_OOP = 'N/A';
                
                // Initialize OON NETWORK Accum Details
                groupPlanWrapper.ION_PLAN_MIN = 'N/A';
                groupPlanWrapper.ION_PLAN_MAX = 'N/A';
                groupPlanWrapper.ION_OOP_MIN = 'N/A';
                groupPlanWrapper.ION_OOP_MAX = 'N/A';
                groupPlanWrapper.FON_PLAN_MIN = 'N/A';
                groupPlanWrapper.FON_PLAN_MAX = 'N/A';
                groupPlanWrapper.FON_OOP_MIN = 'N/A';
                groupPlanWrapper.FON_OOP_MAX = 'N/A';
                groupPlanWrapper.ION_Primary_Accum_Deduct = 'N/A';
                groupPlanWrapper.ION_Primary_Accum_OOP = 'N/A';
                groupPlanWrapper.FON_Primary_Accum_Deduct = 'N/A';
                groupPlanWrapper.FON_Primary_Accum_OOP = 'N/A';
                for (ACETLGT_NimbusGetSSBResponse.planTier benefitTier: benefitSectionInfo.planTier) {
                    getNetworkLevelAccumulator(benefitTier,groupPlanWrapper);
                }
            }
            if(benefitSectionInfo.membership != NULL && !benefitSectionInfo.membership.isEmpty() && benefitSectionInfo.membership[0] != null) {
                ACETLGT_NimbusGetSSBResponse.membership memObj = benefitSectionInfo.membership[0];
                System.debug('member flow');
                getTimePeriodQualifierInfo(memObj, isActive, isTermed);
                //Update As of Dates
                getAsOfDate(memObj, isActive, isTermed);
                system.debug('groupPlanWrapper.AS_OF_DATE:::'+groupPlanWrapper.AS_OF_DATE);
            }
        }
		System.debug('>>>getBenefitSectionInfo Method End...');
    }
    public ACETGroupPlanBenefitLEXWrapper parseSuccessAdapterResponse(String responseBody, Boolean isActive, Boolean isTermed) {
        System.debug('>>>parseSuccessAdapterResponse Method Start...');
        system.debug('isActive:::'+isActive + ' - ' +isTermed);
        
        groupPlanWrapper = new ACETGroupPlanBenefitLEXWrapper();
        groupPlanWrapper.benefitRedesignWrapperList = new Map <String, Map <String, List <ACETGroupPlanBenefitLEXWrapper.BenefitSubSection>>> ();
        
        ACETLGT_NimbusGetSSBResponse.memberGroupContractPlanOption benefitSubDetails;
        ACETLGT_NimbusGetSSBResponse.memberGroup benefitGroupDetails;
        
        
        ACETLGT_NimbusGetSSBResponse getSSBResponse = (ACETLGT_NimbusGetSSBResponse) JSON.deserialize(responseBody, ACETLGT_NimbusGetSSBResponse.class);
        
        System.debug('getSSBResponse:::' + getSSBResponse);
        if(getSSBResponse != null && getSSBResponse.getSubscriptionServiceBenefitResponse != null && getSSBResponse.getSubscriptionServiceBenefitResponse.serviceBenefit != null){
            benefitSubDetails = getSSBResponse.getSubscriptionServiceBenefitResponse.serviceBenefit.memberGroupContractPlanOption;
            benefitGroupDetails = getSSBResponse.getSubscriptionServiceBenefitResponse.serviceBenefit.memberGroup;
            groupPlanWrapper.mapBenefitPlanTierValues = new Map <String, List <String>> ();
            if (benefitSubDetails.benefitPlan != null && !benefitSubDetails.benefitPlan.isEmpty()) {
                for (ACETLGT_NimbusGetSSBResponse.benefitPlan benefitSectionInfo: benefitSubDetails.benefitPlan) {
                    getBenefitSectionInfo(benefitSectionInfo, isActive, isTermed);
                }
                groupPlanWrapper.initProgressBar();
            }
        }
		System.debug('>>>parseSuccessAdapterResponse Method End...');
        return groupPlanWrapper;
    }
	//Done
	private void getBenefitTierIdentifier(ACETLGT_NimbusGetSSBResponse.PlanTier benefitTier, String benefitPlanId){
        System.debug('>>>getBenefitTierIdentifier Method Start...');
        if(String.isNotBlank(benefitPlanId)) {
            List<String> temp = groupPlanWrapper.mapBenefitPlanTierValues.get(benefitPlanId);
            if(temp == null && String.isNotBlank(benefitTier.tierIdentifier)) {
                groupPlanWrapper.mapBenefitPlanTierValues.put(benefitPlanId, new List<String>{benefitTier.tierIdentifier});
            } 
            else{
                temp.add(benefitTier.tierIdentifier);
            }
            
        }
        System.debug('>>>getBenefitTierIdentifier Method End...');
    }
    private void getBenefitTierServiceAreaType(ACETLGT_NimbusGetSSBResponse.PlanTier benefitTier, String benefitServiceArea){
        System.debug('>>>getBenefitTierServiceAreaType Method Start...');
        if(String.IsNotBlank(benefitServiceArea)){
            groupPlanWrapper.sAreaType.put(benefitTier.tierIdentifier,benefitTier.serviceAreaType);
        }  
        else {
            groupPlanWrapper.sAreaType.put(benefitTier.tierIdentifier,'Service Area could not be determined');
        }
        System.debug('>>>getBenefitTierServiceAreaType Method End...');
    }
	private void getBenefitTierTypeCodeInfo(ACETLGT_NimbusGetSSBResponse.PlanTier benefitTier, String benefitPlanId)
    {
        if(String.isNotBlank(benefitPlanId) && String.isNotBlank(benefitTier.tierIdentifier)) {
            groupPlanWrapper.tierTypeCode.add(benefitPlanId+'-'+benefitTier.tierIdentifier);
        }
        if(groupPlanWrapper.tierTypeCode != null) {
            groupPlanWrapper.tierTypeCodeList = String.valueOf(groupPlanWrapper.tierTypeCode);
        }
        System.debug('groupPlanWrapper.tierTypeCodeList' +groupPlanWrapper.tierTypeCodeList);
        if(String.isNotBlank(benefitTier.tierIdentifier) && String.isNotBlank(benefitTier.tierTypeCode)) {
            groupPlanWrapper.tierTypeIdentifier.add(benefitTier.tierIdentifier+'-'+benefitTier.tierTypeCode);
        }
        if(groupPlanWrapper.tierTypeIdentifier != null) {
            groupPlanWrapper.tierTypeIdentifierList = String.valueOf(groupPlanWrapper.tierTypeIdentifier);
        }
        System.debug('groupPlanWrapper.tierTypeIdentifierList' +groupPlanWrapper.tierTypeIdentifierList);
    }
    private void getBenefitTierInfo(ACETLGT_NimbusGetSSBResponse.PlanTier benefitTier, String benefitPlanId, String benefitServiceArea){
        System.debug('>>>getBenefitTierInfo Method Start...');
        if(String.isNotBlank(benefitTier.tierTypeCode) && benefitTier.tierTypeCode == 'INN') {
            getBenefitTierIdentifier(benefitTier, benefitPlanId);
            
            system.debug('tierDescription--->'+benefitTier.tierDescription);
            groupPlanWrapper.tierDescMap.put(benefitTier.tierIdentifier,benefitTier.tierDescription);
            
            getBenefitTierServiceAreaType(benefitTier, benefitServiceArea);
        }
		getBenefitTierTypeCodeInfo(benefitTier, benefitPlanId);
        System.debug('>>>getBenefitTierInfo Method End...');
    }
    private void getBenefitTierNetworkMap(ACETLGT_NimbusGetSSBResponse.Network ntwrk, String tierIdentifier)
    {	
        System.debug('>>>getBenefitTierNetworkMap Method Start...');
        if(String.isNotBlank(tierIdentifier)) {
            if(groupPlanWrapper.networkMap != null && groupPlanWrapper.networkMap.containsKey(tierIdentifier)){
                groupPlanWrapper.networkMap.get(tierIdentifier).add(ntwrk.id+'_'+ntwrk.description);    
            }
            else{
                groupPlanWrapper.networkMap.put(tierIdentifier,new List<String>{ntwrk.id+'_'+ntwrk.description});    
            }          
        }
        System.debug('>>>getBenefitTierNetworkMap Method End...');
    }
    private void getBenefitTierNetworkInfo(ACETLGT_NimbusGetSSBResponse.BenefitPlan benefitSectionInfo){
        System.debug('>>>getBenefitTierNetworkInfo Method Start...');
        if(benefitSectionInfo.planTier != null) {
            for(ACETLGT_NimbusGetSSBResponse.PlanTier planTier:benefitSectionInfo.planTier) {
                if(planTier.network != null) {
                    for(ACETLGT_NimbusGetSSBResponse.Network ntwrk: planTier.network) {
                        getBenefitTierNetworkMap(ntwrk, planTier.tierIdentifier);
                    }
                }
            }
        } 
        System.debug('>>>getBenefitTierNetworkInfo Method End...');
    }
    private void getBenefitSectionInfo(ACETLGT_NimbusGetSSBResponse.benefitPlan benefitSectionInfo, String planId){
		System.debug('>>>getBenefitSectionInfo Method Start...');
        if(benefitSectionInfo.benefitPlanId == planId ){
            groupPlanWrapper.qualityProviderTierRuleID = benefitSectionInfo.qualityProviderTierRuleID;
        }
        if (benefitSectionInfo.riderOnlyFlag == 'false') {
            groupPlanWrapper.eHBIndicator = getValueAfterStringValidation(benefitSectionInfo.eHBIndicator,'');
            if (benefitSectionInfo.planTier != null){
                for (ACETLGT_NimbusGetSSBResponse.planTier benefitTier: benefitSectionInfo.planTier) {                        
                    getBenefitTierInfo(benefitTier, benefitSectionInfo.benefitPlanId, benefitSectionInfo.benefitServiceArea);
                }
                if(String.isNotBlank(benefitSectionInfo.carrierBusinessId)){
                    groupPlanWrapper.carId.add(benefitSectionInfo.carrierBusinessId);
                    system.debug('carrierIDWS:::'+benefitSectionInfo.carrierBusinessId);
                }
                if(String.isNotBlank(benefitSectionInfo.benefitServiceArea)) {
                    groupPlanWrapper.benefitServiceSet.add(benefitSectionInfo.benefitServiceArea);
                }
				getBenefitTierNetworkInfo(benefitSectionInfo);
            }
        }
		System.debug('>>>getBenefitSectionInfo Method End...');
    }
     public ACETGroupPlanBenefitLEXWrapper processResponse(String responseBody,String situsState,String planId) {
        System.debug('>>>processResponse Method Start...');
        system.debug('SitusState:::'+SitusState);
        
        groupPlanWrapper = new ACETGroupPlanBenefitLEXWrapper();
        groupPlanWrapper.benefitRedesignWrapperList = new Map <String, Map <String, List <ACETGroupPlanBenefitLEXWrapper.BenefitSubSection>>> ();
        groupPlanWrapper.PlanBenefitRiderList = new List <ACETGroupPlanBenefitLEXWrapper.PlanBenefitRiderWrapper> ();
        groupPlanWrapper.benefitWrapperList = new List <ACETGroupPlanBenefitLEXWrapper.BenefitWrapper> ();
        groupPlanWrapper.planInfoWrapperList = new List <ACETGroupPlanBenefitLEXWrapper.PlanInformationWrapper> ();
        groupPlanWrapper.benefitCodeKeyMap = new Map <String, String> ();
        groupPlanWrapper.benefitCodeRiderPlanmap = new Map <String, String> ();

        groupPlanWrapper.benefitCodeKeyMapList = new Map <String, List <String>> ();
        groupPlanWrapper.coPayingMap = new Map <String, String> ();
        benefitCodeSet = new set <String> ();
        groupPlanWrapper.varriableCoverageMap = new map <string, string> ();
        groupPlanWrapper.benefitDisplayMap = new map <string, string> ();
        groupPlanWrapper.existsOnRiderPlanMap = new map<string, string>();
        groupPlanWrapper.accumulatorList = new List <ACETGroupPlanBenefitLEXWrapper.AccumulatorP> ();
        groupPlanWrapper.OONReimbursementMap = new Map <String, String> ();
        groupPlanWrapper.IndividualAccumulatorRedesignList = new List <ACETGroupPlanBenefitLEXWrapper.AccumulatorRedesignWrapper> ();
        groupPlanWrapper.FamilyAccumulatorRedesignList = new List <ACETGroupPlanBenefitLEXWrapper.AccumulatorRedesignWrapper> ();
        groupPlanWrapper.hippaServiceMap = new Map <String, String> ();
        ACETLGT_NimbusGetSSBResponse.memberGroupContractPlanOption benefitSubDetails;
        ACETLGT_NimbusGetSSBResponse.memberGroup benefitGroupDetails;
        groupPlanWrapper.tierDescMap = new map <String, string> ();
        groupPlanWrapper.claimTypeList = new set <String> ();
        groupPlanWrapper.sAreaType = new Map <string, string> ();
        groupPlanWrapper.networkMap = new Map <string, List <String>> ();
        groupPlanWrapper.benefitServiceSet = new set <string> ();
        groupPlanWrapper.carId = new list <string> ();
        groupPlanWrapper.eHBIndicator = '';
        groupPlanWrapper.tierTypeCode = new List <String> ();
        groupPlanWrapper.tierTypeIdentifier = new List <String> ();
        groupPlanWrapper.tierTypeCodeList = '';
        groupPlanWrapper.tierTypeIdentifierList= '';
        ACETLGT_NimbusGetSSBResponse getSSBResponse = (ACETLGT_NimbusGetSSBResponse) JSON.deserialize(responseBody, ACETLGT_NimbusGetSSBResponse.class);
        System.debug('getSSBResponse:::' + getSSBResponse);
         if(getSSBResponse != null && getSSBResponse.getSubscriptionServiceBenefitResponse != null && getSSBResponse.getSubscriptionServiceBenefitResponse.serviceBenefit != null){
             benefitSubDetails = getSSBResponse.getSubscriptionServiceBenefitResponse.serviceBenefit.memberGroupContractPlanOption;
             benefitGroupDetails = getSSBResponse.getSubscriptionServiceBenefitResponse.serviceBenefit.memberGroup;
             groupPlanWrapper.mapBenefitPlanTierValues = new Map <String, List <String>> ();
             if (benefitSubDetails != null && benefitSubDetails.benefitPlan != null && !benefitSubDetails.benefitPlan.isEmpty()) {
                 for (ACETLGT_NimbusGetSSBResponse.benefitPlan benefitSectionInfo: benefitSubDetails.benefitPlan) {
                     getBenefitSectionInfo(benefitSectionInfo, planId);
                 }
             }
         }
        getPlanBenefitSearchMapping(benefitSubDetails, benefitGroupDetails);
        getPlanBenefitDetailsMapping(benefitSubDetails,situsState);
        getCoPayMapping(benefitSubDetails);
        getIndivFamilyAccumulatorMapping(benefitSubDetails);

        System.debug('>>>processResponse Method End...');
        return groupPlanWrapper;
    }
    private String getRiderCoverageType(ACETLGT_NimbusGetSSBResponse.benefitPlan benefitSectionInfo)
    {
       return (benefitSectionInfo.coverageType != null)?((coverageTypeMap.get(benefitSectionInfo.coverageType) != null)?coverageTypeMap.get(benefitSectionInfo.coverageType):benefitSectionInfo.coverageType):''; 
    }
    private String getRiderGated(ACETLGT_NimbusGetSSBResponse.benefitPlan benefitSectionInfo)
    {
        return (benefitSectionInfo.gatedProductIndicator != null)?gatedPCPMap.get(benefitSectionInfo.gatedProductIndicator):'';
    }
    private void getRiderPlanBenefitMapping(ACETLGT_NimbusGetSSBResponse.benefitPlan benefitSectionInfo)
    {
        System.debug('>>>getRiderPlanBenefitMapping Method Start...');
        if(String.isNotBlank(benefitSectionInfo.riderOnlyFlag) && benefitSectionInfo.riderOnlyFlag == 'true')  {
            
            // Below changes to display rider section in both group plan and plan benefit call topics
            ACETGroupPlanBenefitLEXWrapper.BenefitWrapper groupPlanBenefitRiderInfo = new  ACETGroupPlanBenefitLEXWrapper.BenefitWrapper ();
            groupPlanBenefitRiderInfo.riderCoverageType = getRiderCoverageType(benefitSectionInfo);
            groupPlanBenefitRiderInfo.riderBenefitPlanId = getValueAfterStringValidation(benefitSectionInfo.benefitPlanId, '');
            groupPlanBenefitRiderInfo.riderGated = getRiderGated(benefitSectionInfo); 
            groupPlanBenefitRiderInfo.riderCarrierName = getValueAfterStringValidation(benefitSectionInfo.legalEntityName, '');
            groupPlanBenefitRiderInfo.riderProductName = getValueAfterStringValidation(benefitSectionInfo.productName, '');
            groupPlanBenefitRiderInfo.riderProductId = getValueAfterStringValidation(benefitSectionInfo.productId, '');
            groupPlanBenefitRiderInfo.riderPlanTypeCode = getValueAfterStringValidation(benefitSectionInfo.planTypeCode, '');
            groupPlanBenefitRiderInfo.riderPlanName = getValueAfterStringValidation(benefitSectionInfo.customerFacingPlanName, '');
            System.debug('groupPlanBenefitRiderInfoTestD:::::'+groupPlanBenefitRiderInfo);
            groupPlanWrapper.benefitWrapperList.add(groupPlanBenefitRiderInfo);
            
        } 
        System.debug('>>>getRiderPlanBenefitMapping Method End...');
    }
    private void getMembershipDetails(ACETLGT_NimbusGetSSBResponse.benefitPlan benefitSectionInfo, ACETGroupPlanBenefitLEXWrapper.PlanInformationWrapper getPlanInfo)
    {
        System.debug('>>>getMembershipDetails Method Start...');
        List<ACETLGT_NimbusGetSSBResponse.membership> membershipLst = new List<ACETLGT_NimbusGetSSBResponse.membership>();  
        
        if(benefitSectionInfo.membership != null) {
            membershipLst = benefitSectionInfo.membership;  
            for(Integer i =0; i < membershipLst.size(); i++){
                getPlanInfo.effectiveDate = getValueAfterStringValidation(ACETUtility.formatDateFromDashToSlash(membershipLst[i].coverageStartDate),'');
                getPlanInfo.expirationDate = getValueAfterStringValidation(ACETUtility.formatDateFromDashToSlash(membershipLst[i].coverageEndDate),'');
                getPlanInfo.enrolleeIdentifier = getValueAfterStringValidation(membershipLst[i].enrolleeIdentifier.id, '');
                getPlanInfo.enrolleeType = getValueAfterStringValidation(membershipLst[i].enrolleeIdentifier.type, '');
                getPlanInfo.timePeriodQualifier = getValueAfterStringValidation(membershipLst[i].timePeriodQualifier, ''); 
            }
        }    
        System.debug('>>>getMembershipDetails Method End...');
    }
    private void getNetworkScheduleDetails(ACETLGT_NimbusGetSSBResponse.benefitPlan benefitSectionInfo, ACETGroupPlanBenefitLEXWrapper.PlanInformationWrapper getPlanInfo){
        System.debug('>>>getNetworkScheduleDetails Method Start...');
        //Start of NetworkSchdule
        List<ACETGroupPlanBenefitLEXWrapper.networkScheduleIds> networkSchduleToAdd = new List<ACETGroupPlanBenefitLEXWrapper.networkScheduleIds>();  
        List<ACETLGT_NimbusGetSSBResponse.networkScheduleIds> networkSchduleLst = new List<ACETLGT_NimbusGetSSBResponse.networkScheduleIds>();  
        
        if(benefitSectionInfo.networkScheduleIds != null) {
            networkSchduleLst = benefitSectionInfo.networkScheduleIds;
            ACETGroupPlanBenefitLEXWrapper.networkScheduleIds networkSchObj = new  ACETGroupPlanBenefitLEXWrapper.networkScheduleIds();
            for(ACETLGT_NimbusGetSSBResponse.networkScheduleIds networkObj: networkSchduleLst){
                networkSchObj.networkSchId = networkObj.networkScheduleId;
                networkSchduleToAdd.add(networkSchObj);
                getPlanInfo.networkSchedules.add(networkSchObj);
            }    
        } 
        System.debug('>>>getNetworkScheduleDetails Method End...');
    }
   	private String getGatedProductIndicator(ACETLGT_NimbusGetSSBResponse.benefitPlan benefitSectionInfo)
    {
        return (benefitSectionInfo.gatedProductIndicator != null && gatedPCPMap.get(benefitSectionInfo.gatedProductIndicator) != null)?gatedPCPMap.get(benefitSectionInfo.gatedProductIndicator):'';
    }
    private String getPCPRequiredIndicator(ACETLGT_NimbusGetSSBResponse.benefitPlan benefitSectionInfo)
    {
        return (benefitSectionInfo.pcpRequiredIndicator != null && gatedPCPMap.get(benefitSectionInfo.pcpRequiredIndicator) != null)?gatedPCPMap.get(benefitSectionInfo.pcpRequiredIndicator):'';             
    }
    private String getQualityProviderTierRuleID(ACETLGT_NimbusGetSSBResponse.benefitPlan benefitSectionInfo)
    {
        return (benefitSectionInfo.qualityProviderTierRuleID != null&& benefitSectionInfo.qualityProviderTierRuleID != '')?'Yes':'No';
    }
    private String getGroupName(ACETLGT_NimbusGetSSBResponse.MemberGroup benefitGroupDetails)
    {
        return (benefitGroupDetails != null && benefitGroupDetails.groupName != null)?benefitGroupDetails.groupName:'';
    }
    private String getGroupId(ACETLGT_NimbusGetSSBResponse.MemberGroup benefitGroupDetails)
    {
        return (benefitGroupDetails != null && benefitGroupDetails.groupNumber != null)?benefitGroupDetails.groupNumber:'';
    }
    private void getPlanInfoDetails(ACETLGT_NimbusGetSSBResponse.benefitPlan benefitSectionInfo, ACETLGT_NimbusGetSSBResponse.MemberGroupContractPlanOption benefitSubscriptionDetails, ACETLGT_NimbusGetSSBResponse.MemberGroup benefitGroupDetails, ACETGroupPlanBenefitLEXWrapper.PlanInformationWrapper getPlanInfo)
    {
        System.debug('>>>getPlanInfo Method Start...');
        getPlanInfo.coverageType = getValueAfterStringValidation(benefitSectionInfo.coverageType, '');
        getPlanInfo.riderOnlyFlag = getValueAfterStringValidation(benefitSectionInfo.riderOnlyFlag, '');
        getPlanInfo.planId = getValueAfterStringValidation(benefitSectionInfo.benefitPlanId, '');
        getPlanInfo.administeredByName = getValueAfterStringValidation(benefitSectionInfo.customerFacingPlanName,'');
        getPlanInfo.productId = getValueAfterStringValidation(benefitSectionInfo.productId, '');
        getPlanInfo.planTypeCode = getValueAfterStringValidation(benefitSectionInfo.planTypeCode,'');
        getPlanInfo.gatedProductIndicator = getGatedProductIndicator(benefitSectionInfo);
        getPlanInfo.pcpRequiredIndicator = getPCPRequiredIndicator(benefitSectionInfo);
        getPlanInfo.qualityProviderTierRuleID = getQualityProviderTierRuleID(benefitSectionInfo);
        getPlanInfo.groupName = getGroupName(benefitGroupDetails);
        getPlanInfo.groupId = getGroupId(benefitGroupDetails);
        getPlanInfo.legalSubsidiary = getValueAfterStringValidation(benefitSectionInfo.legalEntityName, '');
        getPlanInfo.planMetallicLevel = getValueAfterStringValidation(benefitSubscriptionDetails.planMetallicLevel, '');
        getMembershipDetails(benefitSectionInfo, getPlanInfo);
        getNetworkScheduleDetails(benefitSectionInfo, getPlanInfo);
     
        groupPlanWrapper.planInfoWrapperList.add(getPlanInfo); 
        System.debug('>>>getPlanInfo Method End...');
    }
    private void getMedicalPlanBenefitMapping(ACETLGT_NimbusGetSSBResponse.benefitPlan benefitSectionInfo, ACETLGT_NimbusGetSSBResponse.MemberGroupContractPlanOption benefitSubscriptionDetails, ACETLGT_NimbusGetSSBResponse.MemberGroup benefitGroupDetails, ACETGroupPlanBenefitLEXWrapper.PlanInformationWrapper getPlanInfo){
        System.debug('>>>getMedicalPlanBenefitMapping Method Start...');
        if(String.isNotBlank(benefitSectionInfo.riderOnlyFlag) && benefitSectionInfo.riderOnlyFlag == 'false' 
           && String.isNotBlank(benefitSectionInfo.coverageType) && benefitSectionInfo.coverageType == 'MEDICAL')  
            {  
                getPlanInfoDetails(benefitSectionInfo, benefitSubscriptionDetails, benefitGroupDetails, getPlanInfo);                                    
            }
        System.debug('>>>getMedicalPlanBenefitMapping Method End...');
        
    }
    private void getPlanBenefitSearchMapping(ACETLGT_NimbusGetSSBResponse.MemberGroupContractPlanOption benefitSubscriptionDetails,
                                      ACETLGT_NimbusGetSSBResponse.MemberGroup benefitGroupDetails) {
        System.debug('>>>getPlanBenefitSearchMapping Method Start...');                                  
        getPlanTypeCode();
        getGatedPCPCode();
        getCoverageTypeDescripMap();
        ACETGroupPlanBenefitLEXWrapper.PlanInformationWrapper getPlanInfo = new  ACETGroupPlanBenefitLEXWrapper.PlanInformationWrapper();
        if(benefitSubscriptionDetails != null && benefitSubscriptionDetails.benefitPlan!=null){
         for(ACETLGT_NimbusGetSSBResponse.benefitPlan benefitSectionInfo: benefitSubscriptionDetails.benefitPlan) {
            getRiderPlanBenefitMapping(benefitSectionInfo);
			getMedicalPlanBenefitMapping(benefitSectionInfo, benefitSubscriptionDetails, benefitGroupDetails, getPlanInfo);                                                                     
        }
      }
      System.debug('>>>getPlanBenefitSearchMapping Method End...');      
    }
    public Map<String,String> getPlanTypeCode() {
		System.debug('>>>getPlanTypeCode Method Start...');
        planTypeCodeMap = new Map<String,String>();
        planTypeCodeMap.put('01','EPO');
        planTypeCodeMap.put('02','HMO');
        planTypeCodeMap.put('03','Indemnity');
        planTypeCodeMap.put('05','POS');
        planTypeCodeMap.put('06','PPO');
		System.debug('>>>getPlanTypeCode Method End...');
        return planTypeCodeMap;
    }
    public Map<String,String> getGatedPCPCode() {
		System.debug('>>>getGatedPCPCode Method Start...');
        gatedPCPMap = new Map<String,String>();
        gatedPCPMap.put('false','N');
        gatedPCPMap.put('true','Y');
		System.debug('>>>getGatedPCPCode Method End...');
        return gatedPCPMap;
    }
    public Map<String,String> getCoverageTypeDescripMap() {
		System.debug('>>>getCoverageTypeDescripMap Method Start...');
        coverageTypeMap = new Map<String,String>();        
        coverageTypeMap.put('B','Behavioral Health');
        coverageTypeMap.put('CC','Child Care');
        coverageTypeMap.put('DR','Dep Care');
        coverageTypeMap.put('D','Dental');
        coverageTypeMap.put('DS','Embedded Dental');
        coverageTypeMap.put('HR','Hearing');
        coverageTypeMap.put('L','Life');
        coverageTypeMap.put('M','Medical');
        coverageTypeMap.put('OE','Other Expense');
        coverageTypeMap.put('OT','Other');
        coverageTypeMap.put('PR','Premium');
        coverageTypeMap.put('RX','Prescription');
        coverageTypeMap.put('V','Vision');
        coverageTypeMap.put('VS','Embedded Vision');
		System.debug('>>>getCoverageTypeDescripMap Method End...');
        return coverageTypeMap;
    } 
    private void getVariableCoverageDetails(ACETLGT_NimbusGetSSBResponse.benefitCode benefitCode, String benefitKey){
		System.debug('>>>getVariableCoverageDetails Method Start...');
        if(benefitCode.variableCoverage != null && benefitCode.variableCoverage == 'true'){
            groupPlanWrapper.varriableCoverageMap.put(benefitKey,benefitCode.variableCoverage);
        }else{
            groupPlanWrapper.varriableCoverageMap.put(benefitKey,'');
        } 
        System.debug('groupPlanWrapper.varriableCoverageMap '+ groupPlanWrapper.varriableCoverageMap);
		System.debug('>>>getVariableCoverageDetails Method End...');
    }
    private void getBenefitDisplayDetails(ACETLGT_NimbusGetSSBResponse.benefitCode benefitCode, String benefitKey){
        System.debug('>>>getBenefitDisplayDetails Method Start...');
        if(!String.isBlank(benefitCode.benefitCode) && !String.isBlank(benefitCode.benefitDisplay)){
            groupPlanWrapper.benefitDisplayMap.put(benefitCode.benefitCode,benefitCode.benefitDisplay);
        }
        //This map is used to display the benefit name on the benefit category dropdown
        if(String.isNotBlank(benefitKey) && String.isNotBlank(benefitCode.BenefitCode) && String.isNotBlank(benefitCode.benefitName) && String.isNotBlank(benefitCode.benefitDisplay)) {
            groupPlanWrapper.benefitCodeKeyMap.put(benefitCode.benefitDisplay, benefitKey);
        }
		System.debug('>>>getBenefitDisplayDetails Method End...');
    }
    private void getExistsOnRiderPlanDetails(ACETLGT_NimbusGetSSBResponse.benefitCode benefitCode, String benefitKey)
    {
        System.debug('>>>getExistsOnRiderPlanDetails Method Start...');
        if(benefitCode.existsOnRiderPlan != null) {
            groupPlanWrapper.benefitCodeRiderPlanmap.put(benefitCode.BenefitCode, benefitCode.existsOnRiderPlan);
        } 
        if(String.isNotBlank(benefitKey) && benefitCode.existsOnRiderPlan != null && benefitCode.existsOnRiderPlan != '' && benefitCode.existsOnRiderPlan == 'true' ) {
            groupPlanWrapper.existsOnRiderPlanMap.put(benefitKey,benefitCode.existsOnRiderPlan); 
        }
        System.debug('groupPlanWrapper.existsOnRiderPlanMap'+groupPlanWrapper.existsOnRiderPlanMap);
        System.debug('>>>getExistsOnRiderPlanDetails Method End...');
    }
    private void getBenefitCodes(ACETLGT_NimbusGetSSBResponse.benefitPlan benefitDetails)
    {
        System.debug('>>>getBenefitCodes Method Start...');
        for(ACETLGT_NimbusGetSSBResponse.benefitCode benefitCode: benefitDetails.benefitCode) {
            
            String benefitKey = getValidString(benefitCode.BenefitCode)+' - '+getValidString(benefitCode.benefitName);
            getVariableCoverageDetails(benefitCode, benefitKey);
            getBenefitDisplayDetails(benefitCode, benefitKey);
            groupPlanWrapper.benefitRedesignWrapperList.put(benefitKey, new Map<String, List<ACETGroupPlanBenefitLEXWrapper.BenefitSubSection>>());
            benefitCodeSet.add(benefitCode.benefitCode);
            getExistsOnRiderPlanDetails(benefitCode,benefitKey);
        } 
        System.debug('>>>getBenefitCodes Method End...');
    }
    private void getBenefitSubscriptionDetails(ACETLGT_NimbusGetSSBResponse.MemberGroupContractPlanOption benefitSubscriptionDetails)
    {
        System.debug('>>>getBenefitSubscriptionDetails Method Start...');
        system.debug('benefitSubscriptionDetails===>'+benefitSubscriptionDetails);
        if(benefitSubscriptionDetails != null && benefitSubscriptionDetails.benefitPlan != null) {
            for(ACETLGT_NimbusGetSSBResponse.benefitPlan benefitDetails: benefitSubscriptionDetails.benefitPlan) {
                if(benefitDetails != null && benefitDetails.benefitCode != null) {
                    getBenefitCodes(benefitDetails);
                } 
            }
            groupPlanWrapper.hippakeyStr = JSON.Serialize(groupPlanWrapper.hippaServiceMap);
        }
        System.debug('>>>getBenefitSubscriptionDetails Method End...');
    }
    private void getBenefitCrosswalkDetails(String situsState)
    {
        System.debug('>>>getBenefitCrosswalkDetails Method Start...');
        List<Crosswalk__c> benefitCrossWalkList = new List<Crosswalk__c>();
        List<Crosswalk__c> benefitCrossWalkListUpdated = new List<Crosswalk__c>();
        benefitCrossWalkList = [Select id,Benefit_Code__c,Category_Code__c,Situs_State__c from Crosswalk__c where Situs_State__c != null]; 
        for(Crosswalk__c cw : benefitCrossWalkList){
            if(SitusState != null && cw.Situs_State__c.Contains(situsState)) {
                benefitCrossWalkListUpdated.add(cw);
            }
        }
        System.debug('benefitCrossWalkListUpdated'+benefitCrossWalkListUpdated);
        for(Crosswalk__c c:benefitCrossWalkListUpdated){
            groupPlanWrapper.benefitCodeKeyMap.put(c.Category_Code__c,c.Benefit_Code__c+'@'+c.Category_Code__c);  
        } 
        System.debug('>>>getBenefitCrosswalkDetails Method End...');
    }
    private void getSpecialityCrosswalkDetails(String situsState){
        System.debug('>>>getSpecialityCrosswalkDetails Method Start...');
        List<Specialty_Crosswalk__c> specialityCrossWalkList = new List<Specialty_Crosswalk__c>();
        List<Specialty_Crosswalk__c> specialityCrossWalkUpdated = new List<Specialty_Crosswalk__c>();
        specialityCrossWalkList = [Select id,Benefit_Code__c,Category_Code__c,Situs_State__c from Specialty_Crosswalk__c where Situs_State__c != null];
        for(Specialty_Crosswalk__c sw : specialityCrossWalkList){
            if(SitusState != null &&  sw.Situs_State__c.Contains(situsState)) {
                specialityCrossWalkUpdated.add(sw);
            }
        }
        System.debug('specialityCrossWalkUpdated' +specialityCrossWalkUpdated);
        
        for(Specialty_Crosswalk__c s:specialityCrossWalkUpdated){
            string specialtyCrossWalk = s.Category_Code__c+'%';
            groupPlanWrapper.benefitCodeKeyMap.put(specialtyCrossWalk,s.Benefit_Code__c+'@'+s.Category_Code__c);
        }
        System.debug('>>>getSpecialityCrosswalkDetails Method End...');
    }
    private void getPlanBenefitDetailsMapping(ACETLGT_NimbusGetSSBResponse.MemberGroupContractPlanOption benefitSubscriptionDetails,String situsState) {
        System.debug('>>>getPlanBenefitDetailsMapping Method Start...');
        getbenefitSubscriptionDetails(benefitSubscriptionDetails);
        getBenefitCrosswalkDetails(situsState);
        getSpecialityCrosswalkDetails(situsState);
        
        System.debug('groupPlanWrapper.benefitCodeKeyMapList...'+groupPlanWrapper.benefitCodeKeyMapList);
        System.debug('>>>getPlanBenefitDetailsMapping Method End...');
    }
    private void getPricingType(ACETLGT_NimbusGetSSBResponse.memberGroupContractPlanOption benefitcoPayDetails)
    {
        System.debug('>>>getPricingType Method Start...');
        if(String.isNotBlank(benefitcoPayDetails.oonPricingType)) {
         if(benefitcoPayDetails.oonPricingType == 'UCR') {
             groupPlanWrapper.oonReimbursementMap.put('UCR',benefitcoPayDetails.ucrPercentile);
         }
         else if(benefitcoPayDetails.oonPricingType == 'CMS Based') {
             groupPlanWrapper.oonReimbursementMap.put('CMS Based',benefitcoPayDetails.mnrpPercentile);
         }
        }
        System.debug('>>>getPricingType Method End...');
    }
    
    private String getPCPCopay(ACETLGT_NimbusGetSSBResponse.planTier planTierInfo, String coverageOverviewCopayStr){
        System.debug('>>>getPCPCopay Method Start...');
        if(planTierInfo.pcpCopay != null) {
            for(String copayStr: planTierInfo.pcpCopay) {
                coverageOverviewCopayStr = coverageOverviewCopayStr+copayStr+'/';
                groupPlanWrapper.coPayingMap.put('PCP', '$'+getRemoveLastChar(coverageOverviewCopayStr));
            }
        }
         System.debug('>>>getPCPCopay Method End...');
        return coverageOverviewCopayStr;
    }
    private String getSpecialistCopay(ACETLGT_NimbusGetSSBResponse.planTier planTierInfo, String coverageOverviewSpecialistStr){
        System.debug('>>>getSpecialistCopay Method Start...');
        if(planTierInfo.specialistCopay != null) {
            for(String specialistStr: planTierInfo.specialistCopay) {
                coverageOverviewSpecialistStr = coverageOverviewSpecialistStr+specialistStr+'/';
                groupPlanWrapper.coPayingMap.put('Specialist', '$'+getRemoveLastChar(coverageOverviewSpecialistStr));
            }
        }
        System.debug('>>>getSpecialistCopay Method End...');
        return coverageOverviewSpecialistStr;
    }
    private String getERCopay(ACETLGT_NimbusGetSSBResponse.planTier planTierInfo, String coverageOverviewerCopayStr){
        System.debug('>>>getERCopay Method Start...');
        if(planTierInfo.erCopay != null) {
            for(String erCopayStr: planTierInfo.erCopay) {
                coverageOverviewerCopayStr = coverageOverviewerCopayStr+erCopayStr+'/';
                groupPlanWrapper.coPayingMap.put('ER', '$'+getRemoveLastChar(coverageOverviewerCopayStr));
            }
        }
        System.debug('>>>getERCopay Method End...');
        return coverageOverviewerCopayStr;
    }
    private String getUCCopay(ACETLGT_NimbusGetSSBResponse.planTier planTierInfo, String coverageOverviewerurgentCareStr){
        System.debug('>>>getUCCopay Method Start...');
        if(planTierInfo.urgentCareCopay != null) {
            for(String urgentCareCopayStr: planTierInfo.urgentCareCopay) {
                coverageOverviewerurgentCareStr = coverageOverviewerurgentCareStr+urgentCareCopayStr+'/';
                groupPlanWrapper.coPayingMap.put('UC', '$'+getRemoveLastChar(coverageOverviewerurgentCareStr));
            }
        }
        System.debug('>>>getUCCopay Method End...');
        return coverageOverviewerurgentCareStr;
    }
    private String getVirtualVisitCopay(ACETLGT_NimbusGetSSBResponse.planTier planTierInfo, String coverageOverviewervirtualVisitsStr){
        System.debug('>>>getVirtualVisitCopay Method Start...');
        if(planTierInfo.virtualVisitsCopay != null) {
            for(String virtualVisitCopayStr: planTierInfo.virtualVisitsCopay) {
                coverageOverviewervirtualVisitsStr = coverageOverviewervirtualVisitsStr+virtualVisitCopayStr+'/';
                groupPlanWrapper.coPayingMap.put('Virtual Visit', '$'+getRemoveLastChar(coverageOverviewervirtualVisitsStr));
            }
        }
        System.debug('>>>getVirtualVisitCopay Method End...');
        return coverageOverviewervirtualVisitsStr;
    }
    
    private void getCopayDetails(ACETLGT_NimbusGetSSBResponse.BenefitPlan benefitSectionInfo){
        System.debug('>>>getCopayDetails Method Start...');
        if(String.isNotBlank(benefitSectionInfo.riderOnlyFlag) && benefitSectionInfo.riderOnlyFlag == 'false') {
            String coverageOverviewCopayStr = '';
            String coverageOverviewSpecialistStr = '';
            String coverageOverviewerCopayStr = '';
            String coverageOverviewerurgentCareStr = '';
            String coverageOverviewervirtualVisitsStr = '';
            if(benefitSectionInfo.planTier != null) {
                for(ACETLGT_NimbusGetSSBResponse.planTier planTierInfo: benefitSectionInfo.planTier) {
                    coverageOverviewCopayStr = getPCPCopay(planTierInfo, coverageOverviewCopayStr);
                    coverageOverviewSpecialistStr = getSpecialistCopay(planTierInfo, coverageOverviewSpecialistStr);
                    coverageOverviewerCopayStr = getERCopay(planTierInfo, coverageOverviewerCopayStr);
                    coverageOverviewerurgentCareStr = getUCCopay(planTierInfo, coverageOverviewerurgentCareStr);
                    coverageOverviewervirtualVisitsStr = getVirtualVisitCopay(planTierInfo, coverageOverviewervirtualVisitsStr);
                }       
            }
        }
        System.debug('>>>getCopayDetails Method End...');
    }
    private void getCopayMapping(ACETLGT_NimbusGetSSBResponse.memberGroupContractPlanOption benefitcoPayDetails) {
        System.debug('>>>getRequestBody Start...');
        if(benefitcoPayDetails != null) {
            getPricingType(benefitcoPayDetails);
            if(benefitcoPayDetails.benefitPlan!=null){
                for(ACETLGT_NimbusGetSSBResponse.BenefitPlan benefitSectionInfo: benefitcoPayDetails.benefitPlan) {
                    getCopayDetails(benefitSectionInfo);  
                }
            }
        }
   }  
    
private String getGroupMaxAmount(String accumTypeDescription, String maxAmount, String amount){
        System.debug('>>>getGroupMaxAmount Method Start...');
        String groupMaxAmount = '';
        if(String.isNotBlank(accumTypeDescription) && String.isNotBlank(amount)) {
            String embedded;
            if(maxAmount.equalsIgnoreCase('N/A')){
                embedded = '';
            }else{
                embedded = maxAmount+ '(' +  accumTypeDescription.replace(' Accum','') + ')';
                embedded = embedded.trim();
            }
            groupMaxAmount = embedded;
        }   
        else {
            groupMaxAmount = string.isNotBlank(maxAmount) ? (maxAmount) : 'N/A';
        } 
        System.debug('>>>getGroupMaxAmount Method End...');
        return groupMaxAmount;
    }
    private void getIndAccumAmount(ACETGroupPlanBenefitLEXWrapper.AccumulatorP accumulator, ACETLGT_NimbusGetSSBResponse.PlanTier  planTier){
        System.debug('>>>getIndAccumAmount Method Start...');
        if(planTier.accumulatorAmounts != null && !planTier.accumulatorAmounts.isEmpty() && planTier.accumulatorAmounts[0] != null){
            ACETLGT_NimbusGetSSBResponse.AccumulatorAmount accumAmount = planTier.accumulatorAmounts[0];
            
            accumulator.maxDeductible = getValueAfterStringValidation(accumAmount.individualDeductibleMaximum, 'N/A');
            accumulator.ytdDeductible = getValueAfterStringValidation(accumAmount.individualDeductibleYTD, 'N/A');
            
            accumulator.maxOOP = getValueAfterStringValidation(accumAmount.individualOOPMaximum, 'N/A');
            accumulator.ytdOOP = getValueAfterStringValidation(accumAmount.individualOOPYTD, 'N/A');
            
            accumulator.primaryAccumDeduct = getValueAfterStringValidation(accumAmount.familyAccumulationTypeDescriptionDeductible, 'N/A');
            accumulator.primaryAccumDescOOP = getValueAfterStringValidation(accumAmount.familyAccumulationTypeDescriptionOOP, 'N/A');
            
            accumulator.groupMaxOOP = getGroupMaxAmount(accumAmount.familyAccumulationTypeDescriptionOOP, accumulator.maxOOP, accumAmount.individualOOPMaximum);
            accumulator.groupMaxDed = getGroupMaxAmount(accumAmount.familyAccumulationTypeDescriptionDeductible, accumulator.maxDeductible, accumAmount.individualOOPYTD);
        }
        System.debug('>>>getIndAccumAmount Method End...');
    }
    private void getFamAccumAmount(ACETGroupPlanBenefitLEXWrapper.AccumulatorP accumulator, ACETLGT_NimbusGetSSBResponse.PlanTier  planTier){
        System.debug('>>>getFamAccumAmount Method Start...');
        if(planTier.accumulatorAmounts != null && !planTier.accumulatorAmounts.isEmpty() && planTier.accumulatorAmounts[0] != null){
            ACETLGT_NimbusGetSSBResponse.AccumulatorAmount accumAmount = planTier.accumulatorAmounts[0];
            
            accumulator.maxDeductible = getValueAfterStringValidation(accumAmount.familyDeductibleMaximum, 'N/A');
            accumulator.ytdDeductible = getValueAfterStringValidation(accumAmount.familyDeductibleYTD, 'N/A');
            
            accumulator.maxOOP = getValueAfterStringValidation(accumAmount.familyOOPMaximum, 'N/A');
            accumulator.ytdOOP = getValueAfterStringValidation(accumAmount.familyOOPYTD, 'N/A');
            
            accumulator.primaryAccumDeduct = getValueAfterStringValidation(accumAmount.familyAccumulationTypeDescriptionDeductible, 'N/A');
            accumulator.primaryAccumDescOOP = getValueAfterStringValidation(accumAmount.familyAccumulationTypeDescriptionOOP, 'N/A');
            
            accumulator.groupMaxOOP = getGroupMaxAmount(accumAmount.familyAccumulationTypeDescriptionOOP, accumulator.maxOOP, accumAmount.individualOOPMaximum);
            accumulator.groupMaxDed = getGroupMaxAmount(accumAmount.familyAccumulationTypeDescriptionDeductible, accumulator.maxDeductible, accumAmount.individualOOPYTD);
        }
        System.debug('>>>getFamAccumAmount Method End...');
    }
    private String getRemainigAmount(String maxAmount, String ytdAmount){
        System.debug('>>>getRemainigAmount Method Start...');
        String remainigAmount = 'N/A';
        if(maxAmount == 'N/A' && ytdAmount == 'N/A'){
            remainigAmount = 'N/A';
        }else{
            maxAmount = maxAmount.equalsIgnoreCase('N/A') ? '0.00' : maxAmount;
            ytdAmount = ytdAmount.equalsIgnoreCase('N/A') ? '0.00' : ytdAmount;
            remainigAmount = string.ValueOf(Decimal.ValueOf(maxAmount) - Decimal.ValueOf(ytdAmount));
        }
        System.debug('>>>getRemainigAmount Method End...');
        return remainigAmount;
    }
    private ACETGroupPlanBenefitLEXWrapper.AccumulatorP getIndividualAccumulator(ACETLGT_NimbusGetSSBResponse.PlanTier  planTier){
        System.debug('>>>getFamilyAccumulator Method Start...');
        Integer coInsuranceTotal = 100;
        ACETGroupPlanBenefitLEXWrapper.AccumulatorP indAccumulator;
        indAccumulator = new ACETGroupPlanBenefitLEXWrapper.AccumulatorP();
        indAccumulator.section = 'Individual';
        if(String.isNotBlank(planTier.tierTypeCode)) {
            indAccumulator.typeCode = planTier.tierTypeCode == 'INN' ? 'INN' : 'OON';
        }
        indAccumulator.maxDeductible = 'N/A';
        indAccumulator.ytdDeductible = 'N/A';
        indAccumulator.maxOOP = 'N/A';
        indAccumulator.ytdOOP = 'N/A';
        indAccumulator.maxDeductible = 'N/A';
        indAccumulator.ytdDeductible = 'N/A';
        indAccumulator.maxOOP = 'N/A';
        indAccumulator.ytdOOP = 'N/A';
        indAccumulator.primaryAccumDeduct = 'N/A';
        indAccumulator.primaryAccumDescOOP = 'N/A';
        indAccumulator.groupMaxOOP = 'N/A';
        indAccumulator.groupMaxDed = 'N/A';
        
        indAccumulator.coinsurance = String.isNotBlank(planTier.primaryCoInsurance) ? (coInsuranceTotal - integer.valueOf(planTier.primaryCoInsurance)) : integer.valueOf(100);
        
        getIndAccumAmount(indAccumulator, planTier);
        
        indAccumulator.maxDed = (String.valueOf(indAccumulator.maxDeductible) == 'N/A')?'0.00':indAccumulator.maxDeductible;
        indAccumulator.ytdDed = (String.valueOf(indAccumulator.ytdDeductible) == 'N/A')?'0.00':indAccumulator.ytdDeductible;
        indAccumulator.maxOutofPoc = (String.valueOf(indAccumulator.maxOOP) == 'N/A')?'0.00':indAccumulator.maxOOP;
        indAccumulator.ytdOutofPoc = (String.valueOf(indAccumulator.ytdOOP) == 'N/A')?'0.00':indAccumulator.ytdOOP;
        
        indAccumulator.remDeductible = getRemainigAmount(indAccumulator.maxDeductible, indAccumulator.ytdDeductible);
        indAccumulator.remOOP = getRemainigAmount(indAccumulator.maxOOP, indAccumulator.ytdOOP);
        System.debug('>>>getFamilyAccumulator Method End...');
        return indAccumulator; 
    }
    private ACETGroupPlanBenefitLEXWrapper.AccumulatorP getFamilyAccumulator(ACETLGT_NimbusGetSSBResponse.PlanTier  planTier){
        System.debug('>>>getFamilyAccumulator Method Start...');
        Integer coInsuranceTotal = 100;
        ACETGroupPlanBenefitLEXWrapper.AccumulatorP famAccumulator;
        famAccumulator = new ACETGroupPlanBenefitLEXWrapper.AccumulatorP();
        famAccumulator.section = 'Family';
        if(String.isNotBlank(planTier.tierTypeCode)) {
            famAccumulator.typeCode = planTier.tierTypeCode == 'INN' ? 'INN' : 'OON';
        }
        
        famAccumulator.maxDeductible = 'N/A';
        famAccumulator.ytdDeductible = 'N/A';
        famAccumulator.maxOOP = 'N/A';
        famAccumulator.ytdOOP = 'N/A';
        famAccumulator.maxDeductible = 'N/A';
        famAccumulator.ytdDeductible = 'N/A';
        famAccumulator.maxOOP = 'N/A';
        famAccumulator.ytdOOP = 'N/A';
        famAccumulator.primaryAccumDeduct = 'N/A';
        famAccumulator.primaryAccumDescOOP = 'N/A';
        famAccumulator.groupMaxOOP = 'N/A';
        famAccumulator.groupMaxDed = 'N/A';
        famAccumulator.coinsurance = String.isNotBlank(planTier.primaryCoInsurance) ? (coInsuranceTotal - integer.valueOf(planTier.primaryCoInsurance)) : integer.valueOf(100);
        
        getFamAccumAmount(famAccumulator, planTier);
        
        famAccumulator.maxDed = (String.valueOf(famAccumulator.maxDeductible) == 'N/A')?'0.00':famAccumulator.maxDeductible;
        famAccumulator.ytdDed = (String.valueOf(famAccumulator.ytdDeductible) == 'N/A')?'0.00':famAccumulator.ytdDeductible;
        famAccumulator.maxOutofPoc = (String.valueOf(famAccumulator.maxOOP) == 'N/A')?'0.00':famAccumulator.maxOOP;
        famAccumulator.ytdOutofPoc = (String.valueOf(famAccumulator.ytdOOP) == 'N/A')?'0.00':famAccumulator.ytdOOP;
        
        famAccumulator.remDeductible = getRemainigAmount(famAccumulator.maxDeductible, famAccumulator.ytdDeductible);
        famAccumulator.remOOP = getRemainigAmount(famAccumulator.maxOOP, famAccumulator.ytdOOP);
        System.debug('>>>getFamilyAccumulator Method End...');
        return famAccumulator;
    }
    private void getIndivfamilyAccumulator(ACETLGT_NimbusGetSSBResponse.BenefitPlan accumsInfo, List<String> tierDescList)
    {
        System.debug('>>>getIndivfamilyAccumulator Method Start...');
        for(ACETLGT_NimbusGetSSBResponse.PlanTier  planTier: accumsInfo.planTier) {
            if(String.isNotBlank(planTier.tierDescription)) {
                tierDescList.add(planTier.tierDescription);
            }
            ACETGroupPlanBenefitLEXWrapper.AccumulatorP indAccumulator = getIndividualAccumulator(planTier);
            groupPlanWrapper.accumulatorList.add(indAccumulator);
            ACETGroupPlanBenefitLEXWrapper.AccumulatorP famAccumulator = getFamilyAccumulator(planTier);
            groupPlanWrapper.accumulatorList.add(famAccumulator);
        }
        System.debug('>>>getIndivfamilyAccumulator Method End...');
    }
    private void getIndivFamilyAccumulatorMapping(ACETLGT_NimbusGetSSBResponse.MemberGroupContractPlanOption benefitSubscriptionDetails) {
        System.debug('>>>getIndivFamilyAccumulatorMapping Method Start...');
        List<String> tierDescList = new List<String>();
        if(benefitSubscriptionDetails != null && benefitSubscriptionDetails.benefitPlan != null) {
            for(ACETLGT_NimbusGetSSBResponse.BenefitPlan accumsInfo: benefitSubscriptionDetails.benefitPlan) {
                if(String.isNotBlank(accumsInfo.riderOnlyFlag) && accumsInfo.riderOnlyFlag == 'false' 
                   && accumsInfo.planTier!= null) {
                       getIndivfamilyAccumulator(accumsInfo, tierDescList);
                   }
            }
        }
        System.debug('>>>getIndivFamilyAccumulatorMapping Method End...');
    }
    private String getValueAfterStringValidation(String inputStr, String outputStr)
    {
        if(String.isBlank(inputStr)) return outputStr;
        return inputStr;
    }
    public string getValidString(string inputStr){
        if(string.isNotBlank(inputStr)){
            inputStr = inputStr.replaceAll('\"','');
            return inputStr;
            
        }else{
            return '';
        }
    }
    private static String getRemoveLastChar(String str) {
        return str.substring(0,str.length()-1);
    }

}