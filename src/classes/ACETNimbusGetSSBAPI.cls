/* 
* @name         :   ACETNimbusGetSSBAPI
* @description  :   This component  is created to call webservice for the subscription service to cover
copay section, Family and Individual section, Rider Section for group and Member flows
* @author       :   Manish Kumar
* @createddate  :   08-16-2021
*/
public with sharing class ACETNimbusGetSSBAPI{
    public ACETGroupPlanBenefitWrapper groupPlanWrapper {get; set;}
    public Map<String,String> teirCodeMap {get; set;}
    public Map<String, String> planTypeCodeMap {get; set;}
    public Map<String,String> gatedPCPMap {get; set;}
    public Map<String,String> coverageTypeMap {get; set;} 
    public Map<String,String> durationMap {get; set;} 
    public set<String> benefitCodeSet {get; set;}
    public String planId{get;set;}
    public String requestLabel{get;set;}
    
    public String getRequestBody(String bundleID,String groupId, String accumAsOf) {
        System.debug('>>>getRequestBody Method_1 Start...');
        ACETNimbusGetSSBRequest getSSBRequest = new ACETNimbusGetSSBRequest();
        String requestBody = getSSBRequest.addSearchInput(bundleID,groupId,accumAsOf);
        System.debug('>>>getRequestBody Method_1 End...');
        return requestBody;
    }
    
    private String getRequestBody(String bundleID, String planOptionId , String startDate, String endDate, String groupId, String accumAsOf) {
        System.debug('>>>getRequestBody Method_2 Start...');
        ACETNimbusGetSSBRequest getSSBRequest = new ACETNimbusGetSSBRequest();
        String requestBody = getSSBRequest.addSearchInput(bundleID,planOptionId,startDate,endDate,groupId,accumAsOf);
        System.debug('>>>getRequestBody Method_2 End...');
    	return requestBody;
    }
    
    private String getRequestBody(String bundleId, String enrollerSRK, String subscriberSRK, String startDate, String endDate, String coverageType, String groupNumber, String accumsDate, string accumAsOf,string customerPurchaseid)
    {
        System.debug('>>>getRequestBody Method_3 Start...');
        ACETNimbusGetSSBRequest getSSBRequest = new ACETNimbusGetSSBRequest();
        String requestBody = getSSBRequest.addSearchInput(bundleID,enrollerSRK,subscriberSRK,startDate,endDate,coverageType, groupNumber,accumsDate,accumAsOf,customerPurchaseid);
    	System.debug('>>>getRequestBody Method_3 End...');
		return requestBody;
    }
    
    public void getErrorMessage(ACETWSCalloutResult calloutResult){
        System.debug('>>>getErrormessage Method Start...');
        if(calloutResult.statusCode != null && calloutResult.statusCode == 400)
            calloutResult.message = ACETUtility.getErrormessage('GN400B'); 
        else if(calloutResult.statusCode != null && calloutResult.statusCode == 404){
            calloutResult.message = ACETUtility.getErrormessage('GN404');
            calloutResult.messageSeverity = ApexPages.Severity.Info; 
        }
        else if(calloutResult.statusCode != null && calloutResult.statusCode == 500)
            calloutResult.message = ACETUtility.getErrormessage('GN500'); 
        else if(calloutResult.statusCode != null && calloutResult.statusCode == 504)
            calloutResult.message = ACETUtility.getErrormessage('GN504'); 
        else
            calloutResult.message = ACETUtility.getErrormessage('GN999');
        System.debug('>>>getErrormessage Method End...');
    }
    
     public ACETWSCalloutResult init(String bundleId, String enrollerSRK, String subscriberSRK, String startDate, String endDate, String coverageTypes, String groupNumber, String accumsDate, string accumAsOf,String customerPurchaseId){
        System.debug('>>>init Method Start...');
        ACETWSCalloutResult calloutResult = new ACETWSCalloutResult();
        try{
            ACET_WebserviceCalloutFramework wsCallOutFW = new ACET_WebserviceCalloutFramework();
            wsCallOutFW.serviceName = 'NimbusGetSSBService';
            String requestBody = getRequestBody(bundleId,enrollerSRK, subscriberSRK, startDate, endDate, coverageTypes, groupNumber, accumsDate, accumAsOf,customerPurchaseId);
            wsCallOutFW.requestBody = requestBody; 
            HttpResponse httpResponse  = wsCallOutFW.getResponse();
            
            if (httpResponse != null && httpResponse.getStatusCode() == 200)
                {
                    String responseBody = httpResponse.getBody();
                    system.debug('>>>Status Code : '+ httpResponse.getStatusCode());
                    system.debug('>>>Response Body : '+ responseBody);
                    calloutResult.success = true;
                    calloutResult.statusCode = 200;
                    calloutResult.message = '';
                    calloutResult.Response = parsesuccessAdapterResponse(responseBody,'');
                    System.debug('>>Parsed Response : ' + JSON.serialize(calloutResult.Response));
                    calloutResult.responseBody = responseBody;
                }
             else{
                    calloutResult.messageSeverity = ApexPages.Severity.ERROR;
                    calloutResult.success = false;
                    calloutResult.statusCode = (httpResponse == null) ? 999 : httpResponse.getStatusCode();
                    getErrormessage(calloutResult);
                }
            }
             catch(Exception e){
                System.debug('ACETNimbusGetSSBAPI: init() - ' + e.getLineNumber() + ' ' + e.getMessage());
                calloutResult.messageSeverity = ApexPages.Severity.ERROR;
                calloutResult.success = false;
                calloutResult.message = ACETUtility.getErrormessage('GN999');
                calloutResult.statusCode = 999;
            }
         System.debug('>>>init Method End...');
        return calloutResult;
    }
    private void getBenefitTierIdentifier(ACETNimbusGetSSBResponse.PlanTier benefitTier, String benefitPlanId){
        System.debug('>>>getBenefitTierIdentifier Method Start...');
        if(String.isNotBlank(benefitPlanId)) {
            List<String> temp = groupPlanWrapper.mapBenefitPlanTierValues.get(benefitPlanId);
            if(temp == null) {
                if(String.isNotBlank(benefitTier.tierIdentifier)){
                    groupPlanWrapper.mapBenefitPlanTierValues.put(benefitPlanId, new List<String>{benefitTier.tierIdentifier});
                }
            } else {
                temp.add(benefitTier.tierIdentifier);
            }
        }
        System.debug('>>>getBenefitTierIdentifier Method End...');
    }
    private void getBenefitTierServiceAreaType(ACETNimbusGetSSBResponse.PlanTier benefitTier, String benefitServiceArea){
        System.debug('>>>getBenefitTierServiceAreaType Method Start...');
        if(String.IsNotBlank(benefitServiceArea)){
            groupPlanWrapper.sAreaType.put(benefitTier.tierIdentifier,benefitTier.serviceAreaType);
        }  
        else {
            groupPlanWrapper.sAreaType.put(benefitTier.tierIdentifier,'Service Area could not be determined');
        }
        System.debug('>>>getBenefitTierServiceAreaType Method End...');
    }
    private void getBenefitTierInfo(ACETNimbusGetSSBResponse.PlanTier benefitTier, String benefitPlanId, String benefitServiceArea){
        System.debug('>>>getBenefitTierInfo Method Start...');
        if(String.isNotBlank(benefitTier.tierTypeCode) && benefitTier.tierTypeCode == 'INN') {
            getBenefitTierIdentifier(benefitTier, benefitPlanId);
            
            system.debug('tierDescription--->'+benefitTier.tierDescription);
            groupPlanWrapper.tierDescMap.put(benefitTier.tierIdentifier,benefitTier.tierDescription);
            
            getBenefitTierServiceAreaType(benefitTier, benefitServiceArea);
        }
        System.debug('>>>getBenefitTierInfo Method End...');
    }
    private void getBenefitTierNetworkMap(ACETNimbusGetSSBResponse.Network ntwrk, String tierIdentifier)
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
    private void getBenefitTierNetworkInfo(ACETNimbusGetSSBResponse.BenefitPlan benefitSectionInfo){
        System.debug('>>>getBenefitTierNetworkInfo Method Start...');
        if(benefitSectionInfo.planTier != null) {
            for(ACETNimbusGetSSBResponse.PlanTier planTier:benefitSectionInfo.planTier) {
                if(planTier.network != null) {
                    for(ACETNimbusGetSSBResponse.Network ntwrk: planTier.network) {
                        getBenefitTierNetworkMap(ntwrk, planTier.tierIdentifier);
                    }
                }
            }
        } 
        System.debug('>>>getBenefitTierNetworkInfo Method End...');
    }
    private void getBenefitSectionInfo(ACETNimbusGetSSBResponse.BenefitPlan benefitSectionInfo)
    {   
        System.debug('>>>getBenefitSectionInfo Method Start...');
        if(benefitSectionInfo != null && String.isNotBlank(benefitSectionInfo.riderOnlyFlag) && benefitSectionInfo.riderOnlyFlag == 'false'
                                                           && benefitSectionInfo.planTier !=null)
        {
            
            for(ACETNimbusGetSSBResponse.PlanTier benefitTier: benefitSectionInfo.planTier){
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
        System.debug('>>>getBenefitSectionInfo Method End...');
    }
    private void getMemberGroupContractPlanOptionDetails(ACETNimbusGetSSBResponse.MemberGroupContractPlanOption benefitSubDetails){
        System.debug('>>>getMemberGroupContractPlanOptionDetails Method Start...');
        groupPlanWrapper.mapBenefitPlanTierValues = new Map<String,List<String>>();
        system.debug('benefitSubDetails.benefitPlan--->'+benefitSubDetails.benefitPlan);
        if(benefitSubDetails.benefitPlan != null) {
            for(ACETNimbusGetSSBResponse.BenefitPlan benefitSectionInfo: benefitSubDetails.benefitPlan) {
                system.debug('benefitPlanId--->'+benefitSectionInfo.benefitPlanId);
                if(benefitSectionInfo.benefitPlanId == planId ){
                    groupPlanWrapper.qualityProviderTierRuleID = benefitSectionInfo.qualityProviderTierRuleID;
                }
                getBenefitSectionInfo(benefitSectionInfo);
            }
        }
        System.debug('>>>getMemberGroupContractPlanOptionDetails Method End...');
    }
     
    public ACETGroupPlanBenefitWrapper parsesuccessAdapterResponse(String responseBody,String situsState)
    {
        System.debug('>>>parsesuccessAdapterResponse Method Start...');
        System.debug('Adapter Testing::::'+responseBody);
        groupPlanWrapper = new ACETGroupPlanBenefitWrapper();
        groupPlanWrapper.benefitRedesignWrapperList = new Map<String, Map<String, List<ACETGroupPlanBenefitWrapper.BenefitSubSection>>>();
        groupPlanWrapper.planBenefitRiderList = new List<ACETGroupPlanBenefitWrapper.PlanBenefitRiderWrapper>();
        groupPlanWrapper.benefitWrapperList = new List<ACETGroupPlanBenefitWrapper.BenefitWrapper>();
        groupPlanWrapper.planInfoWrapperList = new List<ACETGroupPlanBenefitWrapper.PlanInformationWrapper>();
        groupPlanWrapper.benefitCodeKeyMap = new Map<String, String>();
        groupPlanWrapper.benefitCodeKeyMapList = new Map<String, List<String>>();
        groupPlanWrapper.coPayingMap = new Map<String, String>();
        benefitCodeSet = new set<String>();
        groupPlanWrapper.varriableCoverageMap = new map<string, string>();
        groupPlanWrapper.existsOnRiderPlanMap = new map<string, string>();
        groupPlanWrapper.accumulatorList = new List<ACETGroupPlanBenefitWrapper.AccumulatorP>();
        groupPlanWrapper.oonReimbursementMap = new Map<String, String>();
        groupPlanWrapper.individualAccumulatorRedesignList = new List<ACETGroupPlanBenefitWrapper.AccumulatorRedesignWrapper>();
        groupPlanWrapper.familyAccumulatorRedesignList = new List<ACETGroupPlanBenefitWrapper.AccumulatorRedesignWrapper>();
        groupPlanWrapper.hippaServiceMap = new Map<String, String>(); 
        ACETNimbusGetSSBResponse.MemberGroupContractPlanOption benefitSubDetails;
        ACETNimbusGetSSBResponse.MemberGroup benefitGroupDetails;
        groupPlanWrapper.tierDescMap = new map<String,string>();
        groupPlanWrapper.claimTypeList = new set<String>();
        groupPlanWrapper.sAreaType = new Map<string,string>();
        groupPlanWrapper.networkMap = new Map<string,List<String>>();
        groupPlanWrapper.benefitServiceSet =new set<string>();
        groupPlanWrapper.carId = new  list<string>();
        
        ACETNimbusGetSSBResponse getSSBResponse = (ACETNimbusGetSSBResponse)JSON.deserialize(responseBody, ACETNimbusGetSSBResponse.class);
        if(getSSBResponse.getSubscriptionServiceBenefitResponse != null 
           && getSSBResponse.getSubscriptionServiceBenefitResponse.serviceBenefit != null
           && getSSBResponse.getSubscriptionServiceBenefitResponse.serviceBenefit != null
          ) {
              if(getSSBResponse.getSubscriptionServiceBenefitResponse.serviceBenefit.memberGroup != null) {
                  benefitGroupDetails = getSSBResponse.getSubscriptionServiceBenefitResponse.serviceBenefit.memberGroup;
              }
              if(getSSBResponse.getSubscriptionServiceBenefitResponse.serviceBenefit.memberGroupContractPlanOption != null) {
                  benefitSubDetails = getSSBResponse.getSubscriptionServiceBenefitResponse.serviceBenefit.memberGroupContractPlanOption; 
                  getMemberGroupContractPlanOptionDetails(benefitSubDetails);
              }
          }
        getPlanBenefitSearchMapping(benefitSubDetails, benefitGroupDetails);
        getPlanBenefitDetailsMapping(benefitSubDetails,SitusState);
        getCopayMapping(benefitSubDetails);
        getIndivFamilyAccumulatorMapping(benefitSubDetails);
        
        if(benefitCodeSet != null) {
            groupPlanWrapper.hippaBenefitCodeJSON = JSON.Serialize(benefitCodeSet); 
        }
        System.debug('>>>parsesuccessAdapterResponse Method End...');
        return groupPlanWrapper;
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
    private void getIndAccumAmount(ACETGroupPlanBenefitWrapper.AccumulatorP accumulator, ACETNimbusGetSSBResponse.PlanTier  planTier){
        System.debug('>>>getIndAccumAmount Method Start...');
        if(planTier.accumulatorAmounts != null && !planTier.accumulatorAmounts.isEmpty() && planTier.accumulatorAmounts[0] != null){
            ACETNimbusGetSSBResponse.AccumulatorAmount accumAmount = planTier.accumulatorAmounts[0];
            
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
    private void getFamAccumAmount(ACETGroupPlanBenefitWrapper.AccumulatorP accumulator, ACETNimbusGetSSBResponse.PlanTier  planTier){
        System.debug('>>>getFamAccumAmount Method Start...');
        if(planTier.accumulatorAmounts != null && !planTier.accumulatorAmounts.isEmpty() && planTier.accumulatorAmounts[0] != null){
            ACETNimbusGetSSBResponse.AccumulatorAmount accumAmount = planTier.accumulatorAmounts[0];
            
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
    private ACETGroupPlanBenefitWrapper.AccumulatorP getIndividualAccumulator(ACETNimbusGetSSBResponse.PlanTier  planTier){
        System.debug('>>>getFamilyAccumulator Method Start...');
        Integer coInsuranceTotal = 100;
        ACETGroupPlanBenefitWrapper.AccumulatorP indAccumulator;
        indAccumulator = new ACETGroupPlanBenefitWrapper.AccumulatorP();
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
    private ACETGroupPlanBenefitWrapper.AccumulatorP getFamilyAccumulator(ACETNimbusGetSSBResponse.PlanTier  planTier){
        System.debug('>>>getFamilyAccumulator Method Start...');
        Integer coInsuranceTotal = 100;
        ACETGroupPlanBenefitWrapper.AccumulatorP famAccumulator;
        famAccumulator = new ACETGroupPlanBenefitWrapper.AccumulatorP();
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
    private void getIndivfamilyAccumulator(ACETNimbusGetSSBResponse.BenefitPlan accumsInfo, List<String> tierDescList)
    {
        System.debug('>>>getIndivfamilyAccumulator Method Start...');
        for(ACETNimbusGetSSBResponse.PlanTier  planTier: accumsInfo.planTier) {
            if(String.isNotBlank(planTier.tierDescription)) {
                tierDescList.add(planTier.tierDescription);
            }
            ACETGroupPlanBenefitWrapper.AccumulatorP indAccumulator = getIndividualAccumulator(planTier);
            groupPlanWrapper.accumulatorList.add(indAccumulator);
            ACETGroupPlanBenefitWrapper.AccumulatorP famAccumulator = getFamilyAccumulator(planTier);
            groupPlanWrapper.accumulatorList.add(famAccumulator);
        }
        System.debug('>>>getIndivfamilyAccumulator Method End...');
    }
    private void getIndivFamilyAccumulatorMapping(ACETNimbusGetSSBResponse.memberGroupContractPlanOption benefitSubscriptionDetails) {
        System.debug('>>>getIndivFamilyAccumulatorMapping Method Start...');
        List<String> tierDescList = new List<String>();
        if(benefitSubscriptionDetails != null && benefitSubscriptionDetails.benefitPlan != null) {
            for(ACETNimbusGetSSBResponse.BenefitPlan accumsInfo: benefitSubscriptionDetails.benefitPlan) {
                if(String.isNotBlank(accumsInfo.riderOnlyFlag) && accumsInfo.riderOnlyFlag == 'false' 
                   && accumsInfo.planTier!= null) {
                       getIndivfamilyAccumulator(accumsInfo, tierDescList);
                   }
            }
        }
        System.debug('>>>getIndivFamilyAccumulatorMapping Method End...');
    }
    private void getPricingType(ACETNimbusGetSSBResponse.memberGroupContractPlanOption benefitcoPayDetails)
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
    
    private String getPCPCopay(ACETNimbusGetSSBResponse.planTier planTierInfo, String coverageOverviewCopayStr){
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
    private String getSpecialistCopay(ACETNimbusGetSSBResponse.planTier planTierInfo, String coverageOverviewSpecialistStr){
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
    private String getERCopay(ACETNimbusGetSSBResponse.planTier planTierInfo, String coverageOverviewerCopayStr){
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
    private String getUCCopay(ACETNimbusGetSSBResponse.planTier planTierInfo, String coverageOverviewerurgentCareStr){
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
    private String getVirtualVisitCopay(ACETNimbusGetSSBResponse.planTier planTierInfo, String coverageOverviewervirtualVisitsStr){
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
    
    private void getCopayDetails(ACETNimbusGetSSBResponse.BenefitPlan benefitSectionInfo){
        System.debug('>>>getCopayDetails Method Start...');
        if(String.isNotBlank(benefitSectionInfo.riderOnlyFlag) && benefitSectionInfo.riderOnlyFlag == 'false') {
            String coverageOverviewCopayStr = '';
            String coverageOverviewSpecialistStr = '';
            String coverageOverviewerCopayStr = '';
            String coverageOverviewerurgentCareStr = '';
            String coverageOverviewervirtualVisitsStr = '';
            if(benefitSectionInfo.planTier != null) {
                for(ACETNimbusGetSSBResponse.planTier planTierInfo: benefitSectionInfo.planTier) {
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
    private void getCopayMapping(ACETNimbusGetSSBResponse.memberGroupContractPlanOption benefitcoPayDetails) {
        System.debug('>>>getRequestBody Start...');
        if(benefitcoPayDetails != null) {
            getPricingType(benefitcoPayDetails);
            if(benefitcoPayDetails.benefitPlan!=null){
                for(ACETNimbusGetSSBResponse.BenefitPlan benefitSectionInfo: benefitcoPayDetails.benefitPlan) {
                    getCopayDetails(benefitSectionInfo);  
                }
            }
        }
   }  
    private String getRiderCoverageType(ACETNimbusGetSSBResponse.benefitPlan benefitSectionInfo)
    {
       return (benefitSectionInfo.coverageType != null)?((coverageTypeMap.get(benefitSectionInfo.coverageType) != null)?coverageTypeMap.get(benefitSectionInfo.coverageType):benefitSectionInfo.coverageType):''; 
    }
    private String getRiderGated(ACETNimbusGetSSBResponse.benefitPlan benefitSectionInfo)
    {
        return (benefitSectionInfo.gatedProductIndicator != null)?gatedPCPMap.get(benefitSectionInfo.gatedProductIndicator):'';
    }
    private void getRiderPlanBenefitMapping(ACETNimbusGetSSBResponse.benefitPlan benefitSectionInfo)
    {
        System.debug('>>>getRiderPlanBenefitMapping Method Start...');
        if(String.isNotBlank(benefitSectionInfo.riderOnlyFlag) && benefitSectionInfo.riderOnlyFlag == 'true')  {
            
            // Below changes to display rider section in both group plan and plan benefit call topics
            ACETGroupPlanBenefitWrapper.BenefitWrapper groupPlanBenefitRiderInfo = new  ACETGroupPlanBenefitWrapper.BenefitWrapper ();
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
    private String getValueAfterStringValidation(String inputStr, String outputStr)
    {
        if(String.isBlank(inputStr)) return outputStr;
        return inputStr;
    }
    private void getMembershipDetails(ACETNimbusGetSSBResponse.benefitPlan benefitSectionInfo, ACETGroupPlanBenefitWrapper.PlanInformationWrapper getPlanInfo)
    {
        System.debug('>>>getMembershipDetails Method Start...');
        List<ACETNimbusGetSSBResponse.membership> membershipLst = new List<ACETNimbusGetSSBResponse.membership>();  
        
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
    private void getNetworkScheduleDetails(ACETNimbusGetSSBResponse.benefitPlan benefitSectionInfo, ACETGroupPlanBenefitWrapper.PlanInformationWrapper getPlanInfo){
        System.debug('>>>getNetworkScheduleDetails Method Start...');
        //Start of NetworkSchdule
        List<ACETGroupPlanBenefitWrapper.networkScheduleIds> networkSchduleToAdd = new List<ACETGroupPlanBenefitWrapper.networkScheduleIds>();  
        List<ACETNimbusGetSSBResponse.networkScheduleIds> networkSchduleLst = new List<ACETNimbusGetSSBResponse.networkScheduleIds>();  
        
        if(benefitSectionInfo.networkScheduleIds != null) {
            networkSchduleLst = benefitSectionInfo.networkScheduleIds;
            ACETGroupPlanBenefitWrapper.networkScheduleIds networkSchObj = new  ACETGroupPlanBenefitWrapper.networkScheduleIds();
            for(ACETNimbusGetSSBResponse.networkScheduleIds networkObj: networkSchduleLst){
                networkSchObj.networkSchId = networkObj.networkScheduleId;
                networkSchduleToAdd.add(networkSchObj);
                getPlanInfo.networkSchedules.add(networkSchObj);
            }    
        } 
        System.debug('>>>getNetworkScheduleDetails Method End...');
    }
    private String getEHBIndicator(String eHBIndicatorval){
        if(eHBIndicatorval == 'true') return 'Y';
        else if(eHBIndicatorval == 'false') return 'N';
        else return '';
    }
   	private String getGatedProductIndicator(ACETNimbusGetSSBResponse.benefitPlan benefitSectionInfo)
    {
        return (benefitSectionInfo.gatedProductIndicator != null && gatedPCPMap.get(benefitSectionInfo.gatedProductIndicator) != null)?gatedPCPMap.get(benefitSectionInfo.gatedProductIndicator):'';
    }
    private String getPCPRequiredIndicator(ACETNimbusGetSSBResponse.benefitPlan benefitSectionInfo)
    {
        return (benefitSectionInfo.pcpRequiredIndicator != null && gatedPCPMap.get(benefitSectionInfo.pcpRequiredIndicator) != null)?gatedPCPMap.get(benefitSectionInfo.pcpRequiredIndicator):'';             
    }
    private String getQualityProviderTierRuleID(ACETNimbusGetSSBResponse.benefitPlan benefitSectionInfo)
    {
        return (benefitSectionInfo.qualityProviderTierRuleID != null&& benefitSectionInfo.qualityProviderTierRuleID != '')?'Yes':'No';
    }
    private String getGroupName(ACETNimbusGetSSBResponse.MemberGroup benefitGroupDetails)
    {
        return (benefitGroupDetails != null && benefitGroupDetails.groupName != null)?benefitGroupDetails.groupName:'';
    }
    private String getGroupId(ACETNimbusGetSSBResponse.MemberGroup benefitGroupDetails)
    {
        return (benefitGroupDetails != null && benefitGroupDetails.groupNumber != null)?benefitGroupDetails.groupNumber:'';
    }
    private void getPlanInfoDetails(ACETNimbusGetSSBResponse.benefitPlan benefitSectionInfo, ACETNimbusGetSSBResponse.MemberGroupContractPlanOption benefitSubscriptionDetails, ACETNimbusGetSSBResponse.MemberGroup benefitGroupDetails, ACETGroupPlanBenefitWrapper.PlanInformationWrapper getPlanInfo)
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
        String eHBIndicatorval = getValueAfterStringValidation(benefitSectionInfo.eHBIndicator, '');
        getPlanInfo.eHBIndicator = getEHBIndicator(eHBIndicatorval);
        getMembershipDetails(benefitSectionInfo, getPlanInfo);
        getNetworkScheduleDetails(benefitSectionInfo, getPlanInfo);
     
        groupPlanWrapper.planInfoWrapperList.add(getPlanInfo); 
        System.debug('>>>getPlanInfo Method End...');
    }
    private void getMedicalPlanBenefitMapping(ACETNimbusGetSSBResponse.benefitPlan benefitSectionInfo, ACETNimbusGetSSBResponse.MemberGroupContractPlanOption benefitSubscriptionDetails, ACETNimbusGetSSBResponse.MemberGroup benefitGroupDetails, ACETGroupPlanBenefitWrapper.PlanInformationWrapper getPlanInfo){
        System.debug('>>>getMedicalPlanBenefitMapping Method Start...');
        if(String.isNotBlank(benefitSectionInfo.riderOnlyFlag) && benefitSectionInfo.riderOnlyFlag == 'false' 
           && String.isNotBlank(benefitSectionInfo.coverageType) && benefitSectionInfo.coverageType == 'MEDICAL')  
            {  
                getPlanInfoDetails(benefitSectionInfo, benefitSubscriptionDetails, benefitGroupDetails, getPlanInfo);                                    
            }
        System.debug('>>>getMedicalPlanBenefitMapping Method End...');
        
    }
    private void getPlanBenefitSearchMapping(ACETNimbusGetSSBResponse.MemberGroupContractPlanOption benefitSubscriptionDetails,
                                      ACETNimbusGetSSBResponse.MemberGroup benefitGroupDetails) {
        System.debug('>>>getPlanBenefitSearchMapping Method Start...');                                  
        getPlanTypeCode();
        getGatedPCPCode();
        getCoverageTypeDescripMap();
        ACETGroupPlanBenefitWrapper.PlanInformationWrapper getPlanInfo = new  ACETGroupPlanBenefitWrapper.PlanInformationWrapper();
        getPlanInfo.eHBIndicator = '';                                  
        if(benefitSubscriptionDetails != null && benefitSubscriptionDetails.benefitPlan!=null){
         for(ACETNimbusGetSSBResponse.benefitPlan benefitSectionInfo: benefitSubscriptionDetails.benefitPlan) {
            getRiderPlanBenefitMapping(benefitSectionInfo);
			getMedicalPlanBenefitMapping(benefitSectionInfo, benefitSubscriptionDetails, benefitGroupDetails, getPlanInfo);                                                                     
        }
      }
      System.debug('>>>getPlanBenefitSearchMapping Method End...');      
    }
  
    private void getBenefitCodes(ACETNimbusGetSSBResponse.benefitPlan benefitDetails)
    {
        System.debug('>>>getBenefitCodes Method Start...');
        for(ACETNimbusGetSSBResponse.benefitCode benefitCode: benefitDetails.benefitCode) {
            
            String benefitKey = getValidString(benefitCode.BenefitCode)+' - '+getValidString(benefitCode.benefitName);
            if(benefitCode.variableCoverage != null && benefitCode.variableCoverage == 'true'){
                groupPlanWrapper.varriableCoverageMap.put(benefitKey,benefitCode.variableCoverage);
            }else{
                groupPlanWrapper.varriableCoverageMap.put(benefitKey,'');
            } 
            System.debug('groupPlanWrapper.varriableCoverageMap'+ groupPlanWrapper.varriableCoverageMap);
            groupPlanWrapper.benefitRedesignWrapperList.put(benefitKey, new Map<String, List<ACETGroupPlanBenefitWrapper.BenefitSubSection>>());
            benefitCodeSet.add(benefitCode.benefitCode);
            //This map is used to display the benefit name on the benefit category dropdown
            if(String.isNotBlank(benefitKey) && String.isNotBlank(benefitCode.BenefitCode) && String.isNotBlank(benefitCode.benefitName) && String.isNotBlank(benefitCode.benefitDisplay)) {
                groupPlanWrapper.benefitCodeKeyMap.put(benefitCode.benefitDisplay, benefitKey);
            }
            
            if(String.isNotBlank(benefitKey) && benefitCode.existsOnRiderPlan != null && benefitCode.existsOnRiderPlan != '' && benefitCode.existsOnRiderPlan == 'true' ) {
                groupPlanWrapper.existsOnRiderPlanMap.put(benefitKey,benefitCode.existsOnRiderPlan); 
            }        
            System.debug('groupPlanWrapper.existsOnRiderPlanMap'+groupPlanWrapper.existsOnRiderPlanMap);
        } 
        System.debug('>>>getBenefitCodes Method End...');
    }
    private void getBenefitSubscriptionDetails(ACETNimbusGetSSBResponse.MemberGroupContractPlanOption benefitSubscriptionDetails)
    {
        System.debug('>>>getBenefitSubscriptionDetails Method Start...');
        system.debug('benefitSubscriptionDetails===>'+benefitSubscriptionDetails);
        if(benefitSubscriptionDetails != null && benefitSubscriptionDetails.benefitPlan != null) {
            for(ACETNimbusGetSSBResponse.benefitPlan benefitDetails: benefitSubscriptionDetails.benefitPlan) {
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
    private void getPlanBenefitDetailsMapping(ACETNimbusGetSSBResponse.MemberGroupContractPlanOption benefitSubscriptionDetails,String situsState) {
        System.debug('>>>planBenefitDetailsMapping Method Start...');
        getbenefitSubscriptionDetails(benefitSubscriptionDetails);
        getBenefitCrosswalkDetails(situsState);
        getSpecialityCrosswalkDetails(situsState);
        
        System.debug('groupPlanWrapper.benefitCodeKeyMapList...'+groupPlanWrapper.benefitCodeKeyMapList);
        System.debug('>>>planBenefitDetailsMapping Method End...');
    }
    
    public ACETWSCalloutResult getSubscriptionBenefitSearch(string bundleID,String memberId,String srkID, String subSRKID, String effectiveDate,String endDate,String coverageType, String groupNumber, String parStatusType,String accumAsOf,String customerPurchaseId){
        System.debug('>>>getSubscriptionBenefitSearch Method Start...');
        ACETWSCalloutResult calloutResult = new ACETWSCalloutResult();
        try
        {
            System.debug('accumsOff::::'+accumAsOf);
            ACET_WebserviceCalloutFramework wsCallOutFW = new ACET_WebserviceCalloutFramework();
            wsCallOutFW.serviceName = 'NimbusGetSSBService';
            String strEffectiveDate = ChangeDateFormatForOIL(effectiveDate);
            String strEndDate = ChangeDateFormatForOIL(endDate);
            String requestBody = getRequestBody(bundleID,srkID,subSRKID,strEffectiveDate,strEndDate,coverageType,groupNumber,parStatusType,accumAsOf,customerPurchaseId); //groupNumber
            wsCallOutFW.requestBody = requestBody; 
            HttpResponse httpResponse  = wsCallOutFW.getResponse();
        
            if (httpResponse != null && httpResponse.getStatusCode() == 200)
            {
                calloutResult.success = true;
                calloutResult.message = '';
                String responseBody = httpResponse.getBody();
                calloutResult.Response = parsesuccessAdapterResponse(responseBody,'');
            }
            else{
                calloutResult.messageSeverity = ApexPages.Severity.ERROR;
                calloutResult.success = false;
                calloutResult.statusCode = (httpResponse == null) ? 999 : httpResponse.getStatusCode();
                getErrormessage(calloutResult);
            }
        }
        catch(Exception ex)
        {   
        	system.debug(LoggingLevel.INFO, 'Exception in ProcessResponse. Details: ' + ex.getstackTraceString()); 
            calloutResult.success = false;
            calloutResult.message = ex.getmessage();
            calloutResult.messageSeverity = ApexPages.Severity.ERROR;
        }      
        System.debug('>>>getSubscriptionBenefitSearch Method End...');
        return calloutResult;
    }
    
    public Continuation startRequest(string bundleId, String isFlag,String callbackMethodName, Continuation oContinuation)
    {
        System.debug('>>>StartRequest Method Start...');
        ACET_WebserviceCalloutFramework wsCallOutFW = new ACET_WebserviceCalloutFramework();
        wsCallOutFW.serviceName = 'NimbusGetSSBService';
        //String requestBody = getRequestBody(bundleID,isFlag);
        HttpRequest httpRequest = wsCallOutFW.getHttpRequest();
        if(oContinuation == null){
            oContinuation = new Continuation(10);
            oContinuation.continuationMethod = callbackMethodName;
        }
        requestLabel = oContinuation.addHttpRequest(httpRequest);
        system.debug(LoggingLevel.INFO, 'AddHttpRequest. RequestLabel: ' + requestLabel);
        
        Long dt1Long = DateTime.now().getTime();
        System.debug('>>>dt1Long : ' + dt1Long);
        System.debug('>>>StartRequest Method End...');
        return oContinuation;         
    }
    public Continuation providerStartRequest(String benefitBundleOptId, String planOptionId,String enrolleeIdentifierType, String enrolleeIdentifierId, String subscriberIdentifierId, String effectiveStartDate, 
                                             String effectiveEndDate, String coverageType, String groupID, 
                                             String benefitVerIndicator, String benefitCode, String groupNumber,String accumAsOf,String customerPurchaseid, 
                                             String callbackMethodName, Continuation oContinuation, String isGroup)
    {
        System.debug('>>>providerStartRequest Method Start...');
        ACET_WebserviceCalloutFramework wsCallOutFW = new ACET_WebserviceCalloutFramework();
        wsCallOutFW.serviceName = 'NimbusGetSSBService';
        String requestBody;
        if(isGroup == 'group') {
            requestBody = getRequestBody(benefitBundleOptId,planOptionId,effectiveStartDate,effectiveEndDate,groupNumber,accumAsOf);
        }
        else {
            requestBody = getRequestBody(benefitBundleOptId,enrolleeIdentifierId, subscriberIdentifierId,effectiveStartDate,effectiveEndDate,coverageType,groupNumber,'',accumAsOf,customerPurchaseid);
        }
        System.debug('>>>Request Body : ' + requestBody);
        wsCallOutFW.requestBody = requestBody;
        HttpRequest httpRequest = wsCallOutFW.getHttpRequest();
        if(oContinuation == null){
            oContinuation = new Continuation(10);
            oContinuation.continuationMethod = CallbackMethodName;
        }
        requestLabel = oContinuation.addHttpRequest(httpRequest);
        system.debug(LoggingLevel.INFO, 'AddHttpRequest. RequestLabel: ' + RequestLabel);
        
        Long dt1Long = DateTime.now().getTime();
        System.debug('>>>dt1Long : ' + dt1Long);
        System.debug('>>>providerStartRequest Method End...');
        return oContinuation;          
    }
    
    
    public static boolean showCustomErrormessage = false;
    public ACETWSCalloutResult processResponse(String httpRequestLabel,String situsState) {
        System.debug('>>>ProcessResponse Method Start...');
        ACETWSCalloutResult calloutResult = new ACETWSCalloutResult();
        try{
            HttpResponse httpResponse = Continuation.getResponse(httpRequestLabel);
            System.debug('>>>Status Code : ' + httpResponse.getStatusCode());
            System.debug('>>>Response Body :' + httpResponse.getBody());
            if (httpResponse != null && httpResponse.getStatusCode() == 200)
            {
                calloutResult.success = true;
                calloutResult.message = '';
                String responseBody = httpResponse.getBody();
                calloutResult.responseBody = responseBody;
                calloutResult.Response = parsesuccessAdapterResponse(responseBody,situsState);
            }
            else{
                calloutResult.messageSeverity = ApexPages.Severity.ERROR;
                calloutResult.success = false;
                calloutResult.statusCode = (httpResponse == null) ? 999 : httpResponse.getStatusCode();
                getErrormessage(calloutResult);
            }
        }
		catch(Exception ex){
            system.debug(LoggingLevel.INFO, 'Exception in ProcessResponse. Details: ' + ex.getstackTraceString()); 
            calloutResult.success = false;
            calloutResult.message = ex.getmessage();
            calloutResult.messageSeverity = ApexPages.Severity.ERROR;
        } 
        System.debug('>>>ProcessResponse Method End...');
        return calloutResult;
    } 
    
    public Map<String,String> getTierCode() {
        System.debug('>>>getTierCode Method Start...');
        teirCodeMap = new Map<String,String>();
        teirCodeMap.put('1','INN');
        teirCodeMap.put('2','OON');
        System.debug('>>>getTierCode Method End...');
        return teirCodeMap;
    }
    
    public Map<String,String> getPlanTypeCode() {
        System.debug('>>>getPlanTypeCode Method Start...');
        planTypeCodeMap = new Map<String,String>();
        planTypeCodeMap.put('01','EPO');
        planTypeCodeMap.put('02','HMO');
        planTypeCodeMap.put('03','Indemnity');
        planTypeCodeMap.put('05','POS');
        planTypeCodeMap.put('06','PPO');
        System.debug('>>>getRequestBody Method End...');
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
    
    //Change date format from MM/DD/YYYY to yyyy-mm-dd added by Avish on 06282017
    public String changeDateFormatForOIL(String strDate) {
        System.debug('>>>changeDateFormatForOIL Method Start...');
        String formattedDate = '';
        
        if (String.isNotBlank(strDate)) {
            List<String> strDateSplit = strDate.split('/');
            if(strDateSplit.size() == 3) {
                Integer strMonth = integer.ValueOf(strDateSplit[0]);
                Integer strDay = integer.ValueOf(strDateSplit[1]);
                String appendMonth,appendDay;
                if(strMonth < 10)
                    appendMonth = 0 + String.valueOf(strMonth);
                else
                    appendMonth = String.valueOf(strMonth);
                
                if(strDay < 10)    
                    appendDay = 0 + String.valueOf(strDay);
                else 
                    appendDay = String.valueOf(strDay);
                
                formattedDate = strDateSplit[2] + '-' + appendMonth + '-' + appendDay;
            }
        }
        System.debug('>>>changeDateFormatForOIL Method End...');
        return formattedDate;
    } 
    
    public Map<String,String> getDurationCodeMap() {
        System.debug('>>>getDurationCodeMap Method Start...');
        durationMap = new Map<String,String>();        
        durationMap.put('C','Calendar Year(s)');
        durationMap.put('D','Day(s)');
        durationMap.put('L','Lifetime');
        durationMap.put('M','Month(s)');
        durationMap.put('P','Plan Year(s)');
        durationMap.put('W','Week(s)');
        System.debug('>>>getDurationCodeMap Method End...');
        return durationMap;
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