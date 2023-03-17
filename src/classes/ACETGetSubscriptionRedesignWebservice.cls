/* 
* @name         :   ACETGetSubscriptionRedesignWebservice
* @description  :   This component  is created to call webservice for the subscription service to cover
copay section, Family and Individual section, Rider Section for group and Member flows
* @author       :   Divya Sindhu B
* @createddate  :   03-11-2017
* @lastmodifiedby: Ramadevi Pesala
* @lastmodifieddate  : 06-21-2018
*/
public with sharing class ACETGetSubscriptionRedesignWebservice extends ACETWebservice {
    public ACETGroupPlanBenefitWrapper groupPlanWrapper ;
    public Map<String,String> teirCodeMap {get; set;}
    public Map<String, String> PlanTypeCodeMap {get; set;}
    public Map<String,String> gatedPCPMap {get; set;}
    public Map<String,String> CoverageTypeMap {get; set;} 
    public Map<String,String> durationMap {get; set;} 
    public set<String> benefitCodeSet {get; set;}
    public String planId;
    
    public override void GetEndpoint()
    {
        GetEndpointDetail('getSubscriptionBenefitSearch');
    }
     public ACETGetSubscriptionRedesignWebservice() {
        super('Stargate');
    }
    private void GetRequestBody(String bundleID,String groupId, String accumAsOf) {
        //System.debug('::::::accumAsOf:::::::'+accumAsOf);
        RequestBody = '{"getSubscriptionServiceBenefitRequest":{"benefitBundleOptionId":"'+bundleID+'","groupNumber":"'+groupId+'","accumulatorAsOfDate":"'+accumAsOf+'"}}';          
    }
    
    private void GetRequestBodyParam(String bundleID, String planOptionId , String startDate, String EndDate, String groupId, String accumAsOf) {
        //System.debug('::::::accumAsOf:::::::'+accumAsOf);
        RequestBody = '{"getSubscriptionServiceBenefitRequest":{"benefitBundleOptionId":"'+bundleID+'","planOptionId":"'+planOptionId +'","effectiveStartDate":"'+startDate +'","effectiveEndDate":"'+EndDate +'","groupNumber":"'+groupId+'","accumulatorAsOfDate":"'+accumAsOf+'","suppressByHipaaServiceType":"true"}}';          
    }
     
    
     public ACETWSCalloutResult init(String bundleId, String enrollerSRK, String subscriberSRK, String startDate, String EndDate, String CoverageTypes, String groupNumber, String accumsDate, string accumAsOf,String customerPurchaseId){
        ACETWSCalloutResult oACETWSCalloutResult = new ACETWSCalloutResult();
        GetEndpoint();
        GetRequestBody(bundleId,enrollerSRK, subscriberSRK, startDate, EndDate, CoverageTypes, groupNumber, accumsDate, accumAsOf,customerPurchaseId);
        HttpResponse Response;
        Response = Send(OAuthConfig);
        system.debug('Response vinay'+Response.getStatusCode());
        if (Response.getStatusCode() == 200)
            {
                oACETWSCalloutResult.Success = true;
                oACETWSCalloutResult.Message = '';
                oACETWSCalloutResult.Response = parseSuccessAdapterResponse(ReplaceKeywords(Response.getBody()),'');
                oACETWSCalloutResult.responseBody = ReplaceKeywords(Response.getBody());
            }
        else{
                ACETGetSubscriptionRedesignJSON2APEX ACETEGDJSON2Apex = (ACETGetSubscriptionRedesignJSON2APEX)JSON.deserialize(Response.getBody(), ACETGetSubscriptionRedesignJSON2APEX.class);
                oACETWSCalloutResult.Success = false;
                List<ACETOILError> authErrors = new List<ACETOILError>();
                if(ACETEGDJSON2Apex != null && ACETEGDJSON2Apex.getSubscriptionServiceBenefitResponse != null)
                    authErrors = ACETEGDJSON2Apex.getSubscriptionServiceBenefitResponse.errors;  
                oACETWSCalloutResult.Message = GetOILErrorMessage(authErrors);
                oACETWSCalloutResult.MessageSeverity = ApexPages.Severity.ERROR;  
                if(Response.getStatusCode() == 404){
                    showCustomErrorMessage = true;
                    oACETWSCalloutResult.Message = GetOILErrorMessage(authErrors);//'No Results Found';
                    oACETWSCalloutResult.MessageSeverity = ApexPages.Severity.Info; 
                }else if(Response.getStatusCode() == 500){
                    oACETWSCalloutResult.Message = 'Unexpected error occurred. Please try again. If problem persists, please contact the help desk.';
                }   
            }

        return oACETWSCalloutResult;
    }
    private void GetRequestBody2(String bundleId, String enrollerSRK, String subscriberSRK, String startDate, String EndDate, String CoverageTypes, String groupNumber, String accumsDate, string accumAsOf,string customerPurchaseid)
    {
    if(customerPurchaseid != null && customerPurchaseid != ''){
        List<String> SearchParameters = new String[] {(bundleId != null)?bundleId:'',enrollerSRK, subscriberSRK,startDate,EndDate,CoverageTypes,groupNumber,accumAsOf,customerPurchaseid};
        RequestBody = GetRequestBody('ACETGetSubscriptionRedesignRequest1',SearchParameters);
        }else{
        List<String> SearchParameters = new String[] {(bundleId != null)?bundleId:'',enrollerSRK, subscriberSRK,startDate,EndDate,CoverageTypes,groupNumber,accumAsOf};
        RequestBody = GetRequestBody('ACETGetSubscriptionRedesignRequest',SearchParameters);
            }
    }
    private void GetRequestBody(String bundleId, String enrollerSRK, String subscriberSRK, String startDate, String EndDate, String CoverageTypes, String groupNumber, String accumsDate, string accumAsOf,string customerPurchaseId)
    {
    if(customerPurchaseid != null && customerPurchaseid != ''){
        List<String> SearchParameters = new String[] {(bundleId != null)?bundleId:'',enrollerSRK, subscriberSRK,startDate,EndDate,CoverageTypes,groupNumber,accumAsOf,customerPurchaseid};
        RequestBody = GetRequestBody('ACETGetSubscriptionRedesignRequest1',SearchParameters);
        }else{
        List<String> SearchParameters = new String[] {(bundleId != null)?bundleId:'',enrollerSRK, subscriberSRK,startDate,EndDate,CoverageTypes,groupNumber,accumAsOf};
        RequestBody = GetRequestBody('ACETGetSubscriptionRedesignRequest',SearchParameters);
            }
    }   
     
    public ACETGroupPlanBenefitWrapper parseSuccessAdapterResponse(String ResponseBody,String SitusState)
    {
        //System.debug('Adapter Testing::::'+ResponseBody);
        groupPlanWrapper = new ACETGroupPlanBenefitWrapper();
        groupPlanWrapper.benefitRedesignWrapperList = new Map<String, Map<String, List<ACETGroupPlanBenefitWrapper.BenefitSubSection>>>();
        groupPlanWrapper.PlanBenefitRiderList = new List<ACETGroupPlanBenefitWrapper.PlanBenefitRiderWrapper>();
        groupPlanWrapper.benefitWrapperList = new List<ACETGroupPlanBenefitWrapper.BenefitWrapper>();
        groupPlanWrapper.planInfoWrapperList = new List<ACETGroupPlanBenefitWrapper.PlanInformationWrapper>();
        groupPlanWrapper.benefitCodeKeyMap = new Map<String, String>();
        groupPlanWrapper.benefitCodeKeyMapList = new Map<String, List<String>>();
        groupPlanWrapper.coPayingMap = new Map<String, String>();
        benefitCodeSet = new set<String>();
        groupPlanWrapper.varriableCoverageMap = new map<string, string>();
        groupPlanWrapper.existsOnRiderPlanMap = new map<string, string>();
        groupPlanWrapper.accumulatorList = new List<ACETGroupPlanBenefitWrapper.AccumulatorP>();
        groupPlanWrapper.OONReimbursementMap = new Map<String, String>();
        groupPlanWrapper.IndividualAccumulatorRedesignList = new List<ACETGroupPlanBenefitWrapper.AccumulatorRedesignWrapper>();
        groupPlanWrapper.FamilyAccumulatorRedesignList = new List<ACETGroupPlanBenefitWrapper.AccumulatorRedesignWrapper>();
        groupPlanWrapper.hippaServiceMap = new Map<String, String>(); 
        ACETGetSubscriptionRedesignJSON2APEX.memberGroupContractPlanOption benefitSubDetails;
        ACETGetSubscriptionRedesignJSON2APEX.memberGroup benefitGroupDetails;
        ACETGetSubscriptionRedesignJSON2APEX.planTier pTier;
        groupPlanWrapper.tierDescMap = new map<String,string>();
        groupPlanWrapper.claimTypeList = new set<String>();
        groupPlanWrapper.sAreaType = new Map<string,string>();
        groupPlanWrapper.networkMap = new Map<string,List<String>>();
       groupPlanWrapper.benefitServiceSet =new set<string>();
        groupPlanWrapper.carId = new  list<string>();
        
        ACETGetSubscriptionRedesignJSON2APEX ACETEGDJSON2Apex = (ACETGetSubscriptionRedesignJSON2APEX)JSON.deserialize(ResponseBody, ACETGetSubscriptionRedesignJSON2APEX.class);
        //System.debug('ACETEGDJSON2Apex:::'+ACETEGDJSON2Apex);
        if(ACETEGDJSON2Apex.getSubscriptionServiceBenefitResponse != null) {
        if(ACETEGDJSON2Apex.getSubscriptionServiceBenefitResponse.serviceBenefit != null) {
        if(ACETEGDJSON2Apex.getSubscriptionServiceBenefitResponse.serviceBenefit.memberGroupContractPlanOption != null) {
        benefitSubDetails = ACETEGDJSON2Apex.getSubscriptionServiceBenefitResponse.serviceBenefit.memberGroupContractPlanOption; 
       if(ACETEGDJSON2Apex.getSubscriptionServiceBenefitResponse.serviceBenefit.memberGroup != null) {
        benefitGroupDetails = ACETEGDJSON2Apex.getSubscriptionServiceBenefitResponse.serviceBenefit.memberGroup;
        groupPlanWrapper.mapBenefitPlanTierValues = new Map<String,List<String>>();
            system.debug('benefitSubDetails.benefitPlan--->'+benefitSubDetails.benefitPlan);
         if(benefitSubDetails !=null) {
        if(benefitSubDetails.benefitPlan!=null && !benefitSubDetails.benefitPlan.isEmpty()){
         for(ACETGetSubscriptionRedesignJSON2APEX.benefitPlan benefitSectionInfo: benefitSubDetails.benefitPlan) {
             if(benefitSectionInfo.benefitPlanId == planId ){
                 groupPlanWrapper.qualityProviderTierRuleID = benefitSectionInfo.qualityProviderTierRuleID;
             }
          if(benefitSectionInfo != null) {
           if(String.isNotBlank(benefitSectionInfo.riderOnlyFlag)) {
               system.debug('benefitPlanId--->'+benefitSectionInfo.benefitPlanId);
            if( benefitSectionInfo.riderOnlyFlag == 'false')  {
                if(benefitSectionInfo.planTier !=null && !benefitSectionInfo.planTier.isEmpty()){
                 for(ACETGetSubscriptionRedesignJSON2APEX.planTier benefitTier: benefitSectionInfo.planTier){
                  if(benefitTier != null) {
                  if(String.isNotBlank(benefitTier.tierTypeCode)) {
                    if(benefitTier.tierTypeCode == 'INN'){
                        system.debug('tierDescription--->'+benefitTier.tierDescription);
                        if(String.isNotBlank(benefitSectionInfo.benefitPlanId)) {
                        List<String> temp = groupPlanWrapper.mapBenefitPlanTierValues.get(benefitSectionInfo.benefitPlanId);
                        if(temp == null) {
                             if(String.isNotBlank(benefitTier.tierIdentifier)){
                            groupPlanWrapper.mapBenefitPlanTierValues.put(benefitSectionInfo.benefitPlanId, new List<String>{benefitTier.tierIdentifier});
                           }
                        } else {
                            temp.add(benefitTier.tierIdentifier);
                        }
                      }
                        system.debug('benefitTier.tierDescription--->'+benefitTier.tierDescription);
                        groupPlanWrapper.tierDescMap.put(benefitTier.tierIdentifier,benefitTier.tierDescription);
                     //  benefitSectionInfo.benefitServiceArea = '';
                     if(String.IsNotBlank(benefitSectionInfo.benefitServiceArea)){
                        groupPlanWrapper.sAreaType.put(benefitTier.tierIdentifier,benefitTier.serviceAreaType);
                        }  
                        else {
                        groupPlanWrapper.sAreaType.put(benefitTier.tierIdentifier,'Service Area could not be determined');

                        }                  
                      }
                    }
                  }
                }
                if(String.isNotBlank(benefitSectionInfo.carrierBusinessId)){
                   groupPlanWrapper.carId.add(benefitSectionInfo.carrierBusinessId);
                   system.debug('carrierIDWS:::'+benefitSectionInfo.carrierBusinessId);
               }
                 if(String.isNotBlank(benefitSectionInfo.benefitServiceArea)) {
               groupPlanWrapper.benefitServiceSet.add(benefitSectionInfo.benefitServiceArea);
                 }
                //system.debug('Benefitservice-->'+benefitSectionInfo.benefitServiceArea);
               
               if(benefitSubDetails != null) {
                if(benefitSectionInfo.planTier != null && !benefitSectionInfo.planTier.isEmpty()) {
                   for(ACETGetSubscriptionRedesignJSON2APEX.planTier planTier:benefitSectionInfo.planTier) {
                          if(planTier.network != null && !planTier.network.isEmpty()) {
                           for(ACETGetSubscriptionRedesignJSON2APEX.network ntwrk: planTier.network) {
                               if(String.isNotBlank(planTier.tierIdentifier)) {
                               if(groupPlanWrapper.networkMap != null && !groupPlanWrapper.networkMap.isEmpty() && groupPlanWrapper.networkMap.containsKey(planTier.tierIdentifier)){
                                groupPlanWrapper.networkMap.get(planTier.tierIdentifier).add(ntwrk.id+'_'+ntwrk.description);    
                               }
                               else{
                                   groupPlanWrapper.networkMap.put(planTier.tierIdentifier,new List<String>{ntwrk.id+'_'+ntwrk.description});    
                               }          
                           }
                          }
                        }
                      }
                   }
               }
            }
          }
        }
       }
      }
     }
    }
  }
   }
  }
 }
        planBenefitSearchMapping(benefitSubDetails, benefitGroupDetails);
        planBenefitDetailsMapping(benefitSubDetails,SitusState);
        coPayMapping(benefitSubDetails);
        IndivFamilyAccumulatorMapping(benefitSubDetails);
        
        if(benefitCodeSet != null) {
            groupPlanWrapper.hippaBenefitCodeJSON = JSON.Serialize(benefitCodeSet); 
        }
        
        //System.debug('GroupPlanWrapper::::'+groupPlanWrapper);
        return groupPlanWrapper;
    }
    
     private void IndivFamilyAccumulatorMapping(ACETGetSubscriptionRedesignJSON2APEX.memberGroupContractPlanOption benefitSubscriptionDetails) {
        
        Integer coInsuranceTotal = 100;
        ACETGroupPlanBenefitWrapper.AccumulatorP Accumulator;
        List<String> tierDescList = new List<String>();
        if(benefitSubscriptionDetails != null) {
        if(benefitSubscriptionDetails.benefitPlan !=null && !benefitSubscriptionDetails.benefitPlan.isEmpty()){
        for(ACETGetSubscriptionRedesignJSON2APEX.benefitPlan AccumsInfo: benefitSubscriptionDetails.benefitPlan) {
        if(String.isNotBlank(AccumsInfo.riderOnlyFlag)) {
        if(AccumsInfo.riderOnlyFlag == 'false') {
         if(AccumsInfo.planTier!= null && !AccumsInfo.planTier.isEmpty()){
            for(ACETGetSubscriptionRedesignJSON2APEX.planTier  planTier: AccumsInfo.planTier) {
            
                Accumulator = new ACETGroupPlanBenefitWrapper.AccumulatorP();
                Accumulator.Section = 'Individual';
                if(String.isNotBlank(planTier.tierTypeCode)) {
                Accumulator.TypeCode = planTier.tierTypeCode == 'INN' ? 'INN' : 'OON';
                }
                Accumulator.MaxDeductible = String.isNotBlank(planTier.primaryIndividualDeductibleMaximum) ? (planTier.primaryIndividualDeductibleMaximum) : 'N/A';
                Accumulator.YTDDeductible = String.isNotBlank(PlanTier.primaryIndividualDeductibleYTD) ? (PlanTier.primaryIndividualDeductibleYTD) : 'N/A';
                Accumulator.YTDOOP = String.isNotBlank(PlanTier.primaryIndividualOOPYTD) ? (PlanTier.primaryIndividualOOPYTD) : 'N/A';
                Accumulator.coinsurance = String.isNotBlank(PlanTier.primaryCoInsurance) ? (coInsuranceTotal - integer.valueOf(PlanTier.primaryCoInsurance)) : integer.valueOf(0);
                Accumulator.MaxDed = (String.valueOf(Accumulator.MaxDeductible) == 'N/A')?'0.00':Accumulator.MaxDeductible;
                Accumulator.YTDDed = (String.valueOf(Accumulator.YTDDeductible) == 'N/A')?'0.00':Accumulator.YTDDeductible;
                
                
                if(Accumulator.MaxDeductible == 'N/A' && Accumulator.YTDDeductible == 'N/A'){
                    Accumulator.RemDeductible = 'N/A';
                }else{
                    Accumulator.RemDeductible = string.ValueOf(Decimal.ValueOf(Accumulator.MaxDed) - Decimal.ValueOf(Accumulator.YTDDed));
                }
                
                Accumulator.MaxOOP = String.isNotBlank(planTier.primaryIndividualOOPMaximum) ? (planTier.primaryIndividualOOPMaximum) : 'N/A';
                Accumulator.MaxOutofPoc = (String.valueOf(Accumulator.MaxOOP) == 'N/A')?'0.00':Accumulator.MaxOOP;
                Accumulator.YTDOutofPoc = (String.valueOf(Accumulator.YTDOOP) == 'N/A')?'0.00':Accumulator.YTDOOP;
                
                if(Accumulator.MaxOOP == 'N/A' && Accumulator.YTDOOP == 'N/A'){
                    Accumulator.RemOOP = 'N/A';
                }else{
                    Accumulator.RemOOP = string.valueOf(Decimal.ValueOf(Accumulator.MaxOutofPoc) - Decimal.ValueOf(Accumulator.YTDOutofPoc));
                }
                
                Accumulator.primaryAccumDeduct = string.isNotBlank(planTier.primaryFamilyAccumulationTypeDescriptionDeductible) ? (planTier.primaryFamilyAccumulationTypeDescriptionDeductible) : 'N/A';    
                Accumulator.primaryAccumDescOOP = string.isNotBlank(planTier.primaryFamilyAccumulationTypeDescriptionOOP) ? (planTier.primaryFamilyAccumulationTypeDescriptionOOP) : 'N/A';
                //system.debug('Agg/Embedded::'+planTier.primaryFamilyAccumulationTypeDescriptionOOP);               
                // Individual OOP Limit Condition
                if(planTier.primaryFamilyAccumulationTypeDescriptionOOP !=null && planTier.primaryIndividualOOPMaximum !=null && planTier.primaryFamilyAccumulationTypeDescriptionOOP !='') {
                    string embedded = Accumulator.MaxOOP;
                    if(Accumulator.MaxOOP == 'N/A'){
                        embedded = '';
                    }else{
                        embedded = Accumulator.MaxOOP + '(' +  planTier.primaryFamilyAccumulationTypeDescriptionOOP.replace(' Accum','') + ')';
                        embedded = embedded.trim();
                    }
                    Accumulator.GroupMaxOOP = embedded;
                }   
                else {
                    Accumulator.GroupMaxOOP = string.isNotBlank(Accumulator.MaxOOP) ? (Accumulator.MaxOOP) : 'N/A';
                } 
                
                // Individual Ded Limit Condition
                if(planTier.primaryFamilyAccumulationTypeDescriptionDeductible !=null && planTier.primaryIndividualOOPYTD !=null && planTier.primaryFamilyAccumulationTypeDescriptionDeductible !='') {
                    string embedded = '';
                    if(Accumulator.MaxDeductible == 'N/A'){
                        embedded = Accumulator.MaxDeductible;
                    }else{
                        embedded = Accumulator.MaxDeductible + '(' + '' + planTier.primaryFamilyAccumulationTypeDescriptionDeductible.replace(' Accum','') + ')';
                        embedded = embedded.trim();
                    }
                    Accumulator.GroupMaxDed = embedded;
                }   
                else {
                    Accumulator.GroupMaxDed = string.isNotBlank(Accumulator.MaxDeductible) ? (Accumulator.MaxDeductible) : 'N/A';
                } 
                if(String.isNotBlank(planTier.tierDescription)) {
                tierDescList.add(planTier.tierDescription);
                }
                //tierDescProdlkp
                
                groupPlanWrapper.accumulatorList.add(Accumulator);
                //system.debug ('BackendIndividualList' +  groupPlanWrapper.accumulatorList);
                Accumulator = new ACETGroupPlanBenefitWrapper.AccumulatorP();
                Accumulator.Section = 'Family';
                if(String.isNotBlank(planTier.tierTypeCode)) {
                Accumulator.TypeCode = planTier.tierTypeCode == 'INN' ? 'INN' : 'OON';
                }
                Accumulator.MaxDeductible = String.isNotBlank(planTier.primaryFamilyDeductibleMaximum) ? (planTier.primaryFamilyDeductibleMaximum) : 'N/A';
               
                if(String.isBlank(Accumulator.YTDDeductible)) {
                    Accumulator.YTDDeductible = String.isNotBlank(PlanTier.primaryFamilyDeductibleYTD) ? (PlanTier.primaryFamilyDeductibleYTD) : 'N/A';
                }
                
                if(String.isBlank(Accumulator.YTDOOP)) {
                    Accumulator.YTDOOP = String.isNotBlank(PlanTier.primaryFamilyOOPYTD) ? (PlanTier.primaryFamilyOOPYTD) : 'N/A';
                }
                Accumulator.coinsurance = String.isNotBlank(PlanTier.primaryCoInsurance)? (coInsuranceTotal - Integer.valueOf(PlanTier.primaryCoInsurance)) : 0;
                Accumulator.MaxDed = (String.valueOf(Accumulator.MaxDeductible) == 'N/A')?'0.00':Accumulator.MaxDeductible;
                Accumulator.YTDDed = (String.valueOf(Accumulator.YTDDeductible) == 'N/A')?'0.00':Accumulator.YTDDeductible;
                
                if(Accumulator.MaxDeductible == 'N/A' && Accumulator.YTDDeductible == 'N/A'){
                    Accumulator.RemDeductible = 'N/A';
                }else{
                    Accumulator.RemDeductible = string.ValueOf(Decimal.ValueOf(Accumulator.MaxDed) - Decimal.ValueOf(Accumulator.YTDDed));
                }
                Accumulator.MaxOOP = String.isNotBlank(planTier.primaryFamilyOOPMaximum) ? (planTier.primaryFamilyOOPMaximum) : 'N/A';
                Accumulator.MaxOutofPoc = (String.valueOf(Accumulator.MaxOOP) == 'N/A')?'0.00':Accumulator.MaxOOP;
                Accumulator.YTDOutofPoc = (String.valueOf(Accumulator.YTDOOP) == 'N/A')?'0.00':Accumulator.YTDOOP;
                
                if(Accumulator.MaxOOP == 'N/A' && Accumulator.YTDOOP == 'N/A'){
                    Accumulator.RemOOP = 'N/A';
                }else{
                    Accumulator.RemOOP = string.valueOf(Decimal.ValueOf(Accumulator.MaxOutofPoc) - Decimal.ValueOf(Accumulator.YTDOutofPoc));
                }
                Accumulator.primaryAccumDeduct = string.isNotBlank(planTier.primaryFamilyAccumulationTypeDescriptionDeductible) ? (planTier.primaryFamilyAccumulationTypeDescriptionDeductible) : 'N/A';
                Accumulator.primaryAccumDescOOP = string.isNotBlank(planTier.primaryFamilyAccumulationTypeDescriptionOOP) ? (planTier.primaryFamilyAccumulationTypeDescriptionOOP) : 'N/A';
                
                //system.debug('Agg/Embedded::'+planTier.primaryFamilyAccumulationTypeDescriptionOOP);
                //Family OOP Limit - Condition
                if(planTier.primaryFamilyAccumulationTypeDescriptionOOP !=null && planTier.primaryIndividualOOPMaximum !=null && planTier.primaryFamilyAccumulationTypeDescriptionOOP !='') {
                    string embedded = Accumulator.MaxOOP;
                    if(Accumulator.MaxOOP == 'N/A'){
                        embedded = '';
                    }else{
                        embedded = Accumulator.MaxOOP + '(' + '' + planTier.primaryFamilyAccumulationTypeDescriptionOOP.replace(' Accum','') + ')';
                        embedded = embedded.trim();
                    }
                    Accumulator.GroupMaxOOP = embedded;
                }   
                else {
                    Accumulator.GroupMaxOOP = string.isNotBlank(Accumulator.MaxOOP) ? (Accumulator.MaxOOP) : 'N/A';
                } 
                
                //Family Ded Limit Condition 
                if(planTier.primaryFamilyAccumulationTypeDescriptionDeductible !=null && planTier.primaryIndividualOOPYTD !=null && planTier.primaryFamilyAccumulationTypeDescriptionDeductible !='') {
                    string embedded = '';
                    if(Accumulator.MaxDeductible == 'N/A'){
                        embedded = Accumulator.MaxDeductible;
                    }else{
                        embedded = Accumulator.MaxDeductible + '(' + ''  + planTier.primaryFamilyAccumulationTypeDescriptionDeductible.replace(' Accum','') + ')';
                        embedded = embedded.trim();
                    }
                    Accumulator.GroupMaxDed = embedded;
                }   
                else {
                    Accumulator.GroupMaxDed = string.isNotBlank(Accumulator.MaxDeductible) ? (Accumulator.MaxDeductible) : 'N/A';
                } 
                
                groupPlanWrapper.accumulatorList.add(Accumulator);
            }
          }
        }
      }
     }
     }
    }
   }
    private void coPayMapping(ACETGetSubscriptionRedesignJSON2APEX.memberGroupContractPlanOption benefitcoPayDetails) {
       if(benefitcoPayDetails != null) {
        if(String.isNotBlank(benefitcoPayDetails.oonPricingType)) {
         if(benefitcoPayDetails.oonPricingType == 'UCR') {
             groupPlanWrapper.OONReimbursementMap.put('UCR',benefitcoPayDetails.ucrPercentile);
         }
         else if(benefitcoPayDetails.oonPricingType == 'CMS Based') {
             groupPlanWrapper.OONReimbursementMap.put('CMS Based',benefitcoPayDetails.mnrpPercentile);
         }
        }
         if(benefitcoPayDetails.benefitPlan!=null && !benefitcoPayDetails.benefitPlan.isEmpty()){
         for(ACETGetSubscriptionRedesignJSON2APEX.benefitPlan benefitSectionInfo: benefitcoPayDetails.benefitPlan) {
           if(String.isNotBlank(benefitSectionInfo.riderOnlyFlag)) {
            if(benefitSectionInfo.riderOnlyFlag == 'false') {
                String coverageOverviewCopayStr = '';
                String coverageOverviewSpecialistStr = '';
                String coverageOverviewerCopayStr = '';
                String coverageOverviewerurgentCareStr = '';
                String coverageOverviewervirtualVisitsStr = '';
                //System.debug('groupPlanWrapper.coPayingMap:::');
                if(benefitSectionInfo.planTier != null && !benefitSectionInfo.planTier.isEmpty()) {
                //System.debug('groupPlanWrapper.coPayingMap1:::');
                    for(ACETGetSubscriptionRedesignJSON2APEX.planTier planTierInfo: benefitSectionInfo.planTier) {
                        //System.debug('groupPlanWrapper.coPayingMap2:::'+planTierInfo);
                        if(planTierInfo.pcpCopay != null && !planTierInfo.pcpCopay.isEmpty()) {
                            for(String copayStr: planTierInfo.pcpCopay) {
                                coverageOverviewCopayStr = coverageOverviewCopayStr+copayStr+'/';
                                groupPlanWrapper.coPayingMap.put('PCP', '$'+getRemoveLastChar(coverageOverviewCopayStr));
                            }
                        }
                        if(planTierInfo.specialistCopay != null && !planTierInfo.specialistCopay.isEmpty()) {
                             for(String specialistStr: planTierInfo.specialistCopay) {
                                coverageOverviewSpecialistStr = coverageOverviewSpecialistStr+specialistStr+'/';
                                groupPlanWrapper.coPayingMap.put('Specialist', '$'+getRemoveLastChar(coverageOverviewSpecialistStr));
                            }
                        }
                        if(planTierInfo.erCopay != null && !planTierInfo.erCopay.isEmpty()) {
                            for(String erCopayStr: planTierInfo.erCopay) {
                                coverageOverviewerCopayStr = coverageOverviewerCopayStr+erCopayStr+'/';
                                groupPlanWrapper.coPayingMap.put('ER', '$'+getRemoveLastChar(coverageOverviewerCopayStr));
                            }
                        }
                        if(planTierInfo.urgentCareCopay != null && !planTierInfo.urgentCareCopay.isEmpty()) {
                            for(String urgentCareCopayStr: planTierInfo.urgentCareCopay) {
                                coverageOverviewerurgentCareStr = coverageOverviewerurgentCareStr+urgentCareCopayStr+'/';
                                groupPlanWrapper.coPayingMap.put('UC', '$'+getRemoveLastChar(coverageOverviewerurgentCareStr));
                            }
                        }
                        if(planTierInfo.virtualVisitsCopay != null && !planTierInfo.virtualVisitsCopay.isEmpty()) {
                            for(String virtualVisitCopayStr: planTierInfo.virtualVisitsCopay) {
                                coverageOverviewervirtualVisitsStr = coverageOverviewervirtualVisitsStr+virtualVisitCopayStr+'/';
                                groupPlanWrapper.coPayingMap.put('Virtual Visit', '$'+getRemoveLastChar(coverageOverviewervirtualVisitsStr));
                            }
                        }
                    }       
                }
            } 
         }
        }
    }
        //System.debug('groupPlanWrapper.coPayingMap:::'+groupPlanWrapper.coPayingMap);
    }
   }  
    private void planBenefitSearchMapping(ACETGetSubscriptionRedesignJSON2APEX.memberGroupContractPlanOption benefitSubscriptionDetails,
                                      ACETGetSubscriptionRedesignJSON2APEX.memberGroup benefitGroupDetails) {
        getPlanTypeCode();
        getGatedPCPCode();
        getCoverageTypeDescripMap();
        ACETGroupPlanBenefitWrapper.PlanInformationWrapper getPlanInfo = new  ACETGroupPlanBenefitWrapper.PlanInformationWrapper();
        getPlanInfo.eHBIndicator = '';                                  
        if(benefitSubscriptionDetails != null && benefitSubscriptionDetails.benefitPlan!=null && !benefitSubscriptionDetails.benefitPlan.isEmpty()){
         for(ACETGetSubscriptionRedesignJSON2APEX.benefitPlan benefitSectionInfo: benefitSubscriptionDetails.benefitPlan) {
            if(String.isNotBlank(benefitSectionInfo.riderOnlyFlag) && benefitSectionInfo.riderOnlyFlag == 'true')  {
                                                     
                 // Below changes to display rider section in both group plan and plan benefit call topics
                 ACETGroupPlanBenefitWrapper.BenefitWrapper groupPlanBenefitRiderInfo = new  ACETGroupPlanBenefitWrapper.BenefitWrapper ();
                 groupPlanBenefitRiderInfo.riderCoverageType = (benefitSectionInfo.coverageType != null)?((CoverageTypeMap.get(benefitSectionInfo.coverageType) != null)?CoverageTypeMap.get(benefitSectionInfo.coverageType):benefitSectionInfo.coverageType):'';
            
                 groupPlanBenefitRiderInfo.riderBenefitPlanId = (benefitSectionInfo.benefitPlanId != null)?benefitSectionInfo.benefitPlanId:'';
                 groupPlanBenefitRiderInfo.riderGated =  (benefitSectionInfo.gatedProductIndicator != null)?gatedPCPMap.get(benefitSectionInfo.gatedProductIndicator):'';
                 groupPlanBenefitRiderInfo.riderCarrierName = (benefitSectionInfo.legalEntityName != null)?benefitSectionInfo.legalEntityName:'';
                 groupPlanBenefitRiderInfo.riderProductName = (benefitSectionInfo.productName != null)?benefitSectionInfo.productName:'';
                 groupPlanBenefitRiderInfo.riderProductId = (benefitSectionInfo.productId != null)?benefitSectionInfo.productId:'';
                 groupPlanBenefitRiderInfo.riderPlanTypeCode =  (benefitSectionInfo.planTypeCode != null)?benefitSectionInfo.planTypeCode:'';
                 groupPlanBenefitRiderInfo.riderPlanName = (benefitSectionInfo.customerFacingPlanName != null)?benefitSectionInfo.customerFacingPlanName:'';
                 System.debug('groupPlanBenefitRiderInfoTestD:::::'+groupPlanBenefitRiderInfo);
                 groupPlanWrapper.benefitWrapperList.add(groupPlanBenefitRiderInfo);
                 
            } 
            else if(String.isNotBlank(benefitSectionInfo.riderOnlyFlag) && benefitSectionInfo.riderOnlyFlag == 'false' && String.isNotBlank(benefitSectionInfo.coverageType) && benefitSectionInfo.coverageType == 'MEDICAL')  
            {  
                getPlanInfo.coverageType = (benefitSectionInfo.coverageType != null)?benefitSectionInfo.coverageType:'';
                getPlanInfo.riderOnlyFlag = (benefitSectionInfo.riderOnlyFlag != null)?benefitSectionInfo.riderOnlyFlag:'';
                getPlanInfo.PlanId = (benefitSectionInfo.benefitPlanId != null)?benefitSectionInfo.benefitPlanId:'';
                getPlanInfo.administeredByName = (benefitSectionInfo.customerFacingPlanName != null)?benefitSectionInfo.customerFacingPlanName:'';
                getPlanInfo.productId = (benefitSectionInfo.productId != null)?benefitSectionInfo.productId:'';
                getPlanInfo.planTypeCode = (benefitSectionInfo.planTypeCode != null)?benefitSectionInfo.planTypeCode:'';
                getPlanInfo.gatedProductIndicator = (benefitSectionInfo.gatedProductIndicator != null && gatedPCPMap.get(benefitSectionInfo.gatedProductIndicator) != null)?gatedPCPMap.get(benefitSectionInfo.gatedProductIndicator):'';
                getPlanInfo.pcpRequiredIndicator = (benefitSectionInfo.pcpRequiredIndicator != null && gatedPCPMap.get(benefitSectionInfo.pcpRequiredIndicator) != null)?gatedPCPMap.get(benefitSectionInfo.pcpRequiredIndicator):'';             
                getPlanInfo.qualityProviderTierRuleID = (benefitSectionInfo != null && benefitSectionInfo.qualityProviderTierRuleID != null&& benefitSectionInfo.qualityProviderTierRuleID != '')?'Yes':'No';
                getPlanInfo.groupName = (benefitGroupDetails != null && benefitGroupDetails.groupName != null)?benefitGroupDetails.groupName:'';
                getPlanInfo.groupId = (benefitGroupDetails != null && benefitGroupDetails.groupNumber != null)?benefitGroupDetails.groupNumber:'';
                getPlanInfo.legalSubsidiary = (benefitSectionInfo.legalEntityName != null)?benefitSectionInfo.legalEntityName:'';
                getPlanInfo.planMetallicLevel = (benefitSubscriptionDetails.planMetallicLevel != null)?benefitSubscriptionDetails.planMetallicLevel:'';
                String eHBIndicatorval = (benefitSectionInfo.eHBIndicator != null)? benefitSectionInfo.eHBIndicator : '';
                if(eHBIndicatorval == 'true') {
                    getPlanInfo.eHBIndicator = 'Y'; 
                }else if(eHBIndicatorval == 'false') {
                     getPlanInfo.eHBIndicator = 'N';
                }
               /** if(benefitSectionInfo.legalEntityName != null && benefitSectionInfo.legalEntityName != '') {
                    if(benefitSectionInfo.legalEntityName.contains('Oxford Health Plans')) {
                        getPlanInfo.legalSubsidiary = 'OHP';
                    }
                    else if(benefitSectionInfo.legalEntityName.contains('Oxford Health Insurance')) {
                         getPlanInfo.legalSubsidiary = 'OHI';
                    }
                }*/
                
                //Start of membership snippet
                List<ACETGetSubscriptionRedesignJSON2APEX.membership> membershipLst = new List<ACETGetSubscriptionRedesignJSON2APEX.membership>();  
            
                if(benefitSectionInfo.membership != null && !benefitSectionInfo.membership.isEmpty()) {
                    membershipLst = benefitSectionInfo.membership;  
                    for(Integer i =0; i < membershipLst.size(); i++){
                      getPlanInfo.EffectiveDate = (membershipLst[i].coverageStartDate != null)?ChangeDateFormat(membershipLst[i].coverageStartDate):'';
                      getPlanInfo.ExpirationDate = (membershipLst[i].coverageEndDate != null)?ChangeDateFormat(membershipLst[i].coverageEndDate):'';
                      getPlanInfo.enrolleeIdentifier = (membershipLst[i].enrolleeIdentifier.id != null)?membershipLst[i].enrolleeIdentifier.id:'';
                      getPlanInfo.enrolleeType =  (membershipLst[i].enrolleeIdentifier.type != null)?membershipLst[i].enrolleeIdentifier.type:'';
                      getPlanInfo.timePeriodQualifier = (membershipLst[i].timePeriodQualifier != null)?membershipLst[i].timePeriodQualifier:'';
                      // groupPlanWrapper.planInfoWrapperList.add(getPlanInfo);   
                    }
                }    
                //End of membership
                //Start of NetworkSchdule
                List<ACETGroupPlanBenefitWrapper.networkScheduleIds> networkSchduleToAdd = new List<ACETGroupPlanBenefitWrapper.networkScheduleIds>();  
                List<ACETGetSubscriptionRedesignJSON2APEX.networkScheduleIds> networkSchduleLst = new List<ACETGetSubscriptionRedesignJSON2APEX.networkScheduleIds>();  
                
                if(benefitSectionInfo.networkScheduleIds != null && !benefitSectionInfo.networkScheduleIds.isEmpty()) {
                    networkSchduleLst = benefitSectionInfo.networkScheduleIds;
                    ACETGroupPlanBenefitWrapper.networkScheduleIds networkSchObj = new  ACETGroupPlanBenefitWrapper.networkScheduleIds();
                    for(ACETGetSubscriptionRedesignJSON2APEX.networkScheduleIds networkObj: networkSchduleLst){
                        networkSchObj.networkSchId = networkObj.networkScheduleId;
                        networkSchduleToAdd.add(networkSchObj);
                        getPlanInfo.networkSchedules.add(networkSchObj);
                    }    
                } 
                //System.debug('getPlanInfo:::::'+getPlanInfo);
                groupPlanWrapper.planInfoWrapperList.add(getPlanInfo);                                      
            }                                                         
        }
      }
    }
  
      private void planBenefitDetailsMapping(ACETGetSubscriptionRedesignJSON2APEX.memberGroupContractPlanOption benefitSubscriptionDetails,String SitusState) {
        system.debug('benefitSubscriptionDetails===>'+benefitSubscriptionDetails);
        if(benefitSubscriptionDetails != null) {
          if(benefitSubscriptionDetails.benefitPlan != null && !benefitSubscriptionDetails.benefitPlan.isEmpty()){
            for(ACETGetSubscriptionRedesignJSON2APEX.benefitPlan benefitDetails: benefitSubscriptionDetails.benefitPlan) {
                if(benefitDetails != null) {
                    if(benefitDetails.benefitCode != null && !benefitDetails.benefitCode.isEmpty()) {
                        for(ACETGetSubscriptionRedesignJSON2APEX.benefitCode benefitCode: benefitDetails.benefitCode) {
                        
                        //System.debug('Entering:::::'+benefitCode.benefitName);
                        String benefitKey = getValidString(benefitCode.BenefitCode)+' - '+getValidString(benefitCode.benefitName);
                        if(benefitCode.variableCoverage != null && benefitCode.variableCoverage == 'true'){
                            groupPlanWrapper.varriableCoverageMap.put(benefitKey,benefitCode.variableCoverage);
                        }else{
                            groupPlanWrapper.varriableCoverageMap.put(benefitKey,'');
                        } 
                        System.debug('groupPlanWrapper.varriableCoverageMap'+ groupPlanWrapper.varriableCoverageMap);
                        groupPlanWrapper.benefitRedesignWrapperList.put(benefitKey, new Map<String, List<ACETGroupPlanBenefitWrapper.BenefitSubSection>>());
                        benefitCodeSet.add(benefitCode.benefitCode);
                        
                        if(String.isNotBlank(benefitKey)) {
                            //This map is used to display the benefit name on the benefit category dropdown
                            if(String.isNotBlank(benefitCode.BenefitCode) && String.isNotBlank(benefitCode.benefitName) && String.isNotBlank(benefitCode.benefitDisplay)) {
                                groupPlanWrapper.benefitCodeKeyMap.put(benefitCode.benefitDisplay, benefitKey);
                            }
                        }
                        
                      /*  if(benefitCode.hipaaServiceTypes != null) {
                            groupPlanWrapper.hippaServiceMap.put(benefitCode.BenefitCode+'_', benefitCode.hipaaServiceTypes[0].serviceTypeCode);
                            
                        } */
                          if(String.isNotBlank(benefitKey) && benefitCode.existsOnRiderPlan != null && benefitCode.existsOnRiderPlan != '' && benefitCode.existsOnRiderPlan == 'true' ) {
                               groupPlanWrapper.existsOnRiderPlanMap.put(benefitKey,benefitCode.existsOnRiderPlan); 
                            }        
                          System.debug('groupPlanWrapper.existsOnRiderPlanMap'+groupPlanWrapper.existsOnRiderPlanMap);
                     }
                    }
                }   
            }
            groupPlanWrapper.hippakeyStr = JSON.Serialize(groupPlanWrapper.hippaServiceMap);
            //system.debug('groupPlanWrapper::'+groupPlanWrapper.benefitRedesignWrapperList);
        }
      }
      
      List<Crosswalk__c> benefitCrossWalkList = new List<Crosswalk__c>();
      System.debug('SitusState' +SitusState);
      List<Crosswalk__c> benefitCrossWalkListUpdated = new List<Crosswalk__c>();
      benefitCrossWalkList = [Select id,Benefit_Code__c,Category_Code__c,Situs_State__c from Crosswalk__c where Situs_State__c != null]; 
          for(Crosswalk__c cw : benefitCrossWalkList){
             if(SitusState != null) {
              if(cw.Situs_State__c.Contains(SitusState)){
                  benefitCrossWalkListUpdated.add(cw);
              }
          }
        }
      System.debug('benefitCrossWalkListUpdated'+benefitCrossWalkListUpdated);
      if(benefitCrossWalkListUpdated.size()>0){
          for(Crosswalk__c c:benefitCrossWalkListUpdated){
              groupPlanWrapper.benefitCodeKeyMap.put(c.Category_Code__c,c.Benefit_Code__c+'@'+c.Category_Code__c);  
              //groupPlanWrapper.benefitCodeKeyMap.put(c.Category_Code__c,c.Benefit_Code__c);  
              //System.debug('groupPlanWrapper category'+groupPlanWrapper.benefitCodeKeyMap);
          }
      }
      List<Specialty_Crosswalk__c> specialityCrossWalkList = new List<Specialty_Crosswalk__c>();
      List<Specialty_Crosswalk__c> specialityCrossWalkUpdated = new List<Specialty_Crosswalk__c>();
      specialityCrossWalkList = [Select id,Benefit_Code__c,Category_Code__c,Situs_State__c from Specialty_Crosswalk__c where Situs_State__c != null];
      for(Specialty_Crosswalk__c sw : specialityCrossWalkList){
             if(SitusState != null) {
              if(sw.Situs_State__c.Contains(SitusState)){
                  specialityCrossWalkUpdated.add(sw);
              }
          }
        }
      System.debug('specialityCrossWalkUpdated' +specialityCrossWalkUpdated);
      if(specialityCrossWalkUpdated.size()>0){
          for(Specialty_Crosswalk__c s:specialityCrossWalkUpdated){
              string specialtyCrossWalk = s.Category_Code__c+'%';
              groupPlanWrapper.benefitCodeKeyMap.put(specialtyCrossWalk,s.Benefit_Code__c+'@'+s.Category_Code__c);
              //groupPlanWrapper.benefitCodeKeyMap.put(specialtyCrossWalk,s.Benefit_Code__c);    
          }
      }
      System.debug('groupPlanWrapper.benefitCodeKeyMapList...'+groupPlanWrapper.benefitCodeKeyMapList);
    }
    
    public ACETWSCalloutResult getSubscriptionBenefitSearch(string bundleID,String MemberId,String SRKID, String SubSRKID, String EffectiveDate,String EndDate,String CoverageType, String groupNumber, String parStatusType,String accumAsOf,String customerPurchaseId){
        
        ACETWSCalloutResult oACETWSCalloutResult = new ACETWSCalloutResult();
        ACETGroupPlanBenefitWrapper groupPlanWrapper;
        try
        {
            //System.debug('accumsOff::::'+accumAsOf);
            HttpResponse Response;
            getEndpoint();
            String strEffectiveDate = ChangeDateFormatForOIL(EffectiveDate);
            String strEndDate = ChangeDateFormatForOIL(EndDate);
            GetRequestBody(bundleID,SRKID,SubSRKID,strEffectiveDate,strEndDate,CoverageType,groupNumber,parStatusType,accumAsOf,customerPurchaseId); //groupNumber
            Response = Send(OAuthConfig); 
            //StaticResource ResponseJSONSR = [SELECT Body FROM StaticResource WHERE Name = 'ACETGetSubscriptionRedesign'];
          
            //String ResponseBody = ResponseJSONSR.Body.toString();           
            //oACETWSCalloutResult.Response = parseSuccessAdapterResponse(ReplaceKeywords(ResponseBody));
            //System.debug('oACETWSCalloutResult:::::'+oACETWSCalloutResult);
            if (Response.getStatusCode() == 200)
            {
                oACETWSCalloutResult.Success = true;
                oACETWSCalloutResult.Message = '';
                oACETWSCalloutResult.Response = parseSuccessAdapterResponse(ReplaceKeywords(Response.getBody()),'');
            }
            else if (Response.getStatusCode() == 404){
                ACETGetSubscriptionRedesignJSON2APEX JSON2ApexError = (ACETGetSubscriptionRedesignJSON2APEX)JSON.deserialize(Response.getBody(), ACETGetSubscriptionRedesignJSON2APEX.class);
                List<ACETOILError> authErrors = new List<ACETOILError>();       
                authErrors = JSON2ApexError.getSubscriptionServiceBenefitResponse.errors;   
                
                if(authErrors[0].code == '404' && authErrors[0].Name.contains('NOT_FOUND') && (authErrors[0].description.contains('No Group Found') || authErrors[0].description.contains('No Enrollee Individual Found'))){
                    oACETWSCalloutResult.Success = false;
                    oACETWSCalloutResult.Message = 'No Records found' ;
                    oACETWSCalloutResult = ParseFailureResponse(Response);
                    oACETWSCalloutResult.MessageSeverity = ApexPages.Severity.ERROR;                      
                }else
                    oACETWSCalloutResult = ParseFailureResponse(Response);    
            }
            else
            {
                oACETWSCalloutResult = ParseFailureResponse(Response);     
            }
        }
        catch(Exception ex)
        {   
        system.debug(LoggingLevel.INFO, 'Exception in ProcessResponse. Details: ' + ex.getstackTraceString()); 
            oACETWSCalloutResult.Success = false;
            oACETWSCalloutResult.Message = ex.getMessage();
            oACETWSCalloutResult.MessageSeverity = ApexPages.Severity.ERROR;
        }      
        return oACETWSCalloutResult;
    }
    
    public Continuation StartRequest(string bundleId, String isFlag,String CallbackMethodName, Continuation oContinuation)
    {
        GetEndpoint();
        //GetRequestBody(bundleID,isFlag);
        oContinuation = AddHttpRequest(OAuthConfig, CallbackMethodName, oContinuation);
        Long dt1Long = DateTime.now().getTime();
        
        return oContinuation;         
    }
    public Continuation providerStartRequest(String BenefitBundleOptId, String planOptionId,String EnrolleeIdentifierType, String EnrolleeIdentifierId, String subscriberIdentifierId, String EffectiveStartDate, 
                                             String EffectiveEndDate, String CoverageType, String groupID, 
                                             String BenefitVerIndicator, String BenefitCode, String groupNumber,String accumAsOf,String customerPurchaseid, 
                                             String CallbackMethodName, Continuation oContinuation, String isGroup)
    {
        GetEndpoint(); 
        if(isGroup == 'group') {
            GetRequestBodyParam(BenefitBundleOptId,planOptionId,EffectiveStartDate,EffectiveEndDate,groupNumber,accumAsOf);
          system.debug ('Groupishere>>>>>' + groupNumber);
        }
        else {
            GetRequestBody2(BenefitBundleOptId,EnrolleeIdentifierId, subscriberIdentifierId,EffectiveStartDate,EffectiveEndDate,CoverageType,groupNumber,'',accumAsOf,customerPurchaseid);
            system.debug ('Groupishere>>>>>' + groupNumber);
        }
        oContinuation = AddHttpRequest(OAuthConfig, CallbackMethodName, oContinuation);
        Long dt1Long = DateTime.now().getTime();
        
        return oContinuation;         
    }
    
    
    public static boolean showCustomErrorMessage = false;
    public ACETWSCalloutResult ProcessResponse(String HttpRequestLabel,String SitusState) {
        system.debug(LoggingLevel.INFO, 'ProcessResponse: '); 
        // Enable Hardcoded response by uncommneting below two lines when service is down or for test data requirements 
        //StaticResource ResponseJSONSR = [SELECT Body FROM StaticResource WHERE Name = 'getSubscriptionBenefit_MockedJSON'];
        //StaticResource ResponseJSONSR = [SELECT Body FROM StaticResource WHERE Name = 'ACETGetSubscriptionRedesign'];
        //String ResponseBody = ResponseJSONSR.Body.toString();
        ACETWSCalloutResult oACETWSCalloutResult = new ACETWSCalloutResult();
        //HttpResponse Response = GetHttpResponse(HttpRequestLabel);
        //oACETWSCalloutResult.Response = parseSuccessAdapterResponse(ReplaceKeywords(ResponseBody));
        try {
            HttpResponse Response = GetHttpResponse(HttpRequestLabel);
            showCustomErrorMessage = false;
            //system.debug('Response ::'+Response);
            //system.debug('Response.getBody() ::'+Response.getBody());
            if (Response.getStatusCode() == 200) {
                oACETWSCalloutResult.Success = true;
                oACETWSCalloutResult.Message = '';
                oACETWSCalloutResult.Response = parseSuccessAdapterResponse(ReplaceKeywords(Response.getBody()),SitusState); 
                oACETWSCalloutResult.responseBody = Response.getBody();
                    
                // Enable Hardcoded response by uncommneting below line when service is down or for test data requirements
                //oACETWSCalloutResult.Response = parseSuccessAdapterResponse(ReplaceKeywords(ResponseBody));
            }else{
                
                ACETGetSubscriptionRedesignJSON2APEX ACETEGDJSON2Apex = (ACETGetSubscriptionRedesignJSON2APEX)JSON.deserialize(Response.getBody(), ACETGetSubscriptionRedesignJSON2APEX.class);
                
                oACETWSCalloutResult.Success = false;
                List<ACETOILError> authErrors = new List<ACETOILError>();
                if(ACETEGDJSON2Apex != null && ACETEGDJSON2Apex.getSubscriptionServiceBenefitResponse != null)
                    authErrors = ACETEGDJSON2Apex.getSubscriptionServiceBenefitResponse.errors;  
                oACETWSCalloutResult.Message = GetOILErrorMessage(authErrors);
                oACETWSCalloutResult.MessageSeverity = ApexPages.Severity.ERROR;  
                if(Response.getStatusCode() == 404){
                    showCustomErrorMessage = true;
                    oACETWSCalloutResult.Message = GetOILErrorMessage(authErrors);//'No Results Found';
                    oACETWSCalloutResult.MessageSeverity = ApexPages.Severity.Info; 
                }else if(Response.getStatusCode() == 500){
                    oACETWSCalloutResult.Message = 'Unexpected error occurred. Please try again. If problem persists, please contact the help desk.';
                }
            }
        }catch(Exception ex){
            system.debug(LoggingLevel.INFO, 'Exception in ProcessResponse. Details: ' + ex.getstackTraceString()); 
            oACETWSCalloutResult.Success = false;
            oACETWSCalloutResult.Message = ex.getMessage();
            oACETWSCalloutResult.MessageSeverity = ApexPages.Severity.ERROR;
        } 
        return oACETWSCalloutResult;
    }   
    
    public Map<String,String> getTierCode() {
        teirCodeMap = new Map<String,String>();
        teirCodeMap.put('1','INN');
        teirCodeMap.put('2','OON');
        return teirCodeMap;
    }
    
    public Map<String,String> getPlanTypeCode() {
        PlanTypeCodeMap = new Map<String,String>();
        PlanTypeCodeMap.put('01','EPO');
        PlanTypeCodeMap.put('02','HMO');
        PlanTypeCodeMap.put('03','Indemnity');
        PlanTypeCodeMap.put('05','POS');
        PlanTypeCodeMap.put('06','PPO');
        return PlanTypeCodeMap;
    }
    
    public Map<String,String> getGatedPCPCode() {
        gatedPCPMap = new Map<String,String>();
        gatedPCPMap.put('false','N');
        gatedPCPMap.put('true','Y');
        return gatedPCPMap;
    }
    
    //Change date format from MM/DD/YYYY to yyyy-mm-dd added by Avish on 06282017
    public String ChangeDateFormatForOIL(String OILDate) {
        String FormattedDate = '';
        
        if (String.isNotBlank(OILDate)) {
            List<String> OILDateSplit = OILDate.split('/');
            if(OILDateSplit.size() == 3) {
                Integer strMonth = integer.ValueOf(OILDateSplit[0]);
                Integer strDay = integer.ValueOf(OILDateSplit[1]);
                String appendMonth,appendDay;
                if(strMonth < 10)
                    appendMonth = 0 + String.valueOf(strMonth);
                else
                    appendMonth = String.valueOf(strMonth);
                
                if(strDay < 10)    
                    appendDay = 0 + String.valueOf(strDay);
                else 
                    appendDay = String.valueOf(strDay);
                
                //FormattedDate = OILDateSplit[2] + '-' + OILDateSplit[0] + '-' + OILDateSplit[1];
                FormattedDate = OILDateSplit[2] + '-' + appendMonth + '-' + appendDay;
            }
        }
        
        return FormattedDate;
    } 
    
    public Map<String,String> getDurationCodeMap() {
        durationMap = new Map<String,String>();        
        durationMap.put('C','Calendar Year(s)');
        durationMap.put('D','Day(s)');
        durationMap.put('L','Lifetime');
       durationMap.put('M','Month(s)');
        durationMap.put('P','Plan Year(s)');
        durationMap.put('W','Week(s)');
        return durationMap;
    }
    
    public Map<String,String> getCoverageTypeDescripMap() {
        CoverageTypeMap = new Map<String,String>();        
        CoverageTypeMap.put('B','Behavioral Health');
        CoverageTypeMap.put('CC','Child Care');
        CoverageTypeMap.put('DR','Dep Care');
        CoverageTypeMap.put('D','Dental');
        CoverageTypeMap.put('DS','Embedded Dental');
        CoverageTypeMap.put('HR','Hearing');
        CoverageTypeMap.put('L','Life');
        CoverageTypeMap.put('M','Medical');
        CoverageTypeMap.put('OE','Other Expense');
        CoverageTypeMap.put('OT','Other');
        CoverageTypeMap.put('PR','Premium');
        CoverageTypeMap.put('RX','Prescription');
        CoverageTypeMap.put('V','Vision');
        CoverageTypeMap.put('VS','Embedded Vision');
        return CoverageTypeMap;
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