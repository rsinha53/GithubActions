/* 
 * @name         :   ACETGetAccumulatorRedesignWebservice
 * @description  :   This component  is created to call webservice for the accumulator and pass the accums to benefit language webservice. 
 * @author       :   Divya Sindhu B
 * @createddate  :   03-11-2017
 * @lastmodifiedby:
 *
 */
public class ACETGetAccumulatorRedesignWebservice extends ACETWebservice {
    public ACETGroupPlanBenefitWrapper ACETPlanBenefitSearchResults;
    public ACETGroupPlanBenefitWrapper ACETSubscriptionServiceResults;
    public override void GetEndpoint()
    {
         GetEndpointDetail('GetBenefitAccEndpoint');
    }
    public ACETGetAccumulatorRedesignWebservice() {
        super('Stargate');
    }
    private void GetRequestBody() {
        RequestBody = GetRequestBody('ACETGetBenefitAccRequestJSON', RequestParameters);        
    }
    
    public Continuation StartRequest(String BenefitBundleOptId, 
                                     String EnrolleeIdentifierType, 
                                     String EnrolleeIdentifierId,
                                     String SubscriberIdentifierId,
                                     String EffectiveStartDate, 
                                     String EffectiveEndDate, 
                                     String CoverageType, 
                                     String BenefitVerIndicator, 
                                     String BenefitCode,
                                     String GroupNumber,
                                     String CallbackMethodName, 
                                     Continuation oContinuation,
                                     string CoverageLev)
    {
        GetEndpoint();
        
        RequestParameters = new List<String>{BenefitBundleOptId, EnrolleeIdentifierType, EnrolleeIdentifierId,SubscriberIdentifierId,EffectiveStartDate, 
            EffectiveEndDate, CoverageType, BenefitVerIndicator, BenefitCode, GroupNumber, CoverageLev};
        GetRequestBody();
        oContinuation = AddHttpRequest(OAuthConfig, CallbackMethodName, oContinuation);
        return oContinuation;         
    }
  
     
     /* public ACETWSCalloutResult ProcessResponse(String BenefitPlanId, 
                                                 String CoverageType, 
                                                 String HttpRequestLabel,
                                                 Map<String,String> mapBenefitPlans,String Coveragelev) {
           
            ACETWSCalloutResult oACETWSCalloutResult = new ACETWSCalloutResult();
            List<ACETPlanBenefitDetailController.Accumulator> Accumulators = new List<ACETPlanBenefitDetailController.Accumulator>();
            List<ACETGroupPlanBenefitWrapper.Accumulator> accumLst = new List<ACETGroupPlanBenefitWrapper.Accumulator>();
            Map<String,List<ACETGetBenefitAccJSON2Apex.PlanTier>> planTierBasePlanMap = new Map<String,List<ACETGetBenefitAccJSON2Apex.PlanTier>>();
            Map<String,ACETGetBenefitAccJSON2Apex.PlanTier> planTierRiderPlanMap = new Map<String,ACETGetBenefitAccJSON2Apex.PlanTier>();
            Set<String> planTierSet = new Set<String>();
            
            String planTierStr;
            String costShareTypeDED;
            String costShareTypeOOP;
            String coverageLevelIndividual;
            String coverageLevelFamily;
            
            ACETGroupPlanBenefitWrapper.AccumulatorP Accumulator;
            ACETGroupPlanBenefitWrapper.Accumulator objAccumulator;
            ACETGroupPlanBenefitWrapper.DateRangeVersion ObjdateRangeVersion;
            ACETGroupPlanBenefitWrapper wrapper;
            try
            {
                HttpResponse Response = GetHttpResponse(HttpRequestLabel);
                //StaticResource ResponseJSONSR = [SELECT Body FROM StaticResource WHERE Name = 'getBenefitAccumlator_MockedJSON'];
                //String ResponseBody = ResponseJSONSR.Body.toString();
                //System.debug('Response Body:::'+ResponseBody);
                String ResponseBody = Response.getBody();
                if (Response.getStatusCode() != null && Response.getStatusCode() == 200){
                    wrapper = new ACETGroupPlanBenefitWrapper();
                    ACETGetBenefitAccJSON2Apex ACETJSON2Apex1 = (ACETGetBenefitAccJSON2Apex)JSON.deserialize(ResponseBody, ACETGetBenefitAccJSON2Apex.class);
                    System.debug('ACETJSON2Apex:::'+ACETJSON2Apex1);
                    System.debug('mapBenefitPlans:::'+mapBenefitPlans);
                    if (ACETJSON2Apex1.benefitAccumulatorRSResult.getBenefitsAccumulatorResponse.benefitsAccumulator != null) {
                        ACETGetBenefitAccJSON2Apex.BenefitsAccumulator benefitsAccumulator = ACETJSON2Apex1.benefitAccumulatorRSResult.getBenefitsAccumulatorResponse.benefitsAccumulator;
                        if (benefitsAccumulator != null && benefitsAccumulator.membership != null && mapBenefitPlans != null) {
                            for (ACETGetBenefitAccJSON2Apex.Membership Membership :benefitsAccumulator.membership) {
                                if (Membership.benefitPlan != null) {
                                    for (ACETGetBenefitAccJSON2Apex.BenefitPlan BenefitPlan :Membership.benefitPlan) {
                                        if (mapBenefitPlans != null && BenefitPlan.benefitPlanId != null && BenefitPlan.coverageType == CoverageType && mapBenefitPlans.get(BenefitPlan.benefitPlanId) == 'BasePlan') {
                                            if(BenefitPlan.planTier != null) {
                                                for(ACETGetBenefitAccJSON2Apex.PlanTier planTier :BenefitPlan.planTier) {
                                                    if(planTierBasePlanMap.containsKey(BenefitPlan.benefitPlanId) == false){
                                                        planTierBasePlanMap.put(BenefitPlan.benefitPlanId, new List<ACETGetBenefitAccJSON2Apex.PlanTier>());
                                                    }
                                                    planTierBasePlanMap.get(BenefitPlan.benefitPlanId).add(planTier);
                                                }
                                            }
                                        }
                                        if (mapBenefitPlans != null && BenefitPlan.benefitPlanId != null && BenefitPlan.coverageType == CoverageType && mapBenefitPlans.get(BenefitPlan.benefitPlanId) == 'RiderPlan') {
                                            if(BenefitPlan.planTier != null) {
                                                for (ACETGetBenefitAccJSON2Apex.benefitCode benefitCodePlan :BenefitPlan.benefitCode) {
                                                    for(ACETGetBenefitAccJSON2Apex.BenefitCostShare BenefitCostShare :benefitCodePlan.BenefitCostShare) {
                                                        if(BenefitCostShare.shareBasedPlanAccumulatorIndicator == '1' && (BenefitCostShare.costShareType == 'Deductible' || BenefitCostShare.costShareType == 'Out of Pocket'))  {
                                                            planTierStr = BenefitPlan.planTier[0].tierTypeDescription;
                                                            
                                                            if(BenefitCostShare.costShareType.contains('Deductible') ) {
                                                                costShareTypeDED = BenefitCostShare.costShareType;
                                                            }
                                                            else {
                                                                costShareTypeOOP = BenefitCostShare.costShareType;
                                                            }
                                                            
                                                            if(BenefitCostShare.coverageLevel == 'Individual') {
                                                                coverageLevelIndividual = BenefitCostShare.coverageLevel;
                                                            }
                                                            else {
                                                                coverageLevelFamily = BenefitCostShare.coverageLevel;
                                                            }
                                                            planTierRiderPlanMap.put(BenefitPlan.planTier[0].tierTypeDescription,BenefitPlan.planTier[0]);
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    
                                        if(BenefitPlan.BenefitCode != null && mapBenefitPlans.get(BenefitPlan.benefitPlanId) == 'BasePlan') {
                                            Integer sectionStartIndex = 1;
                                            
                                            ObjdateRangeVersion = new ACETGroupPlanBenefitWrapper.DateRangeVersion();
                                            wrapper.mapDateVersion = new Map<String,ACETGroupPlanBenefitWrapper.DateRangeVersion>();//Added by Divya -06/17
                                            wrapper.benefitAccumulatorMap = new Map<String,List<ACETGroupPlanBenefitWrapper.Accumulator>>();
                                            for (ACETGetBenefitAccJSON2Apex.BenefitCode coPayBenefitCode :benefitPlan.BenefitCode) {
                                                ObjdateRangeVersion.benefitVersion = (coPayBenefitCode.benefitVersion != null)?coPayBenefitCode.benefitVersion:'';
                                                String strEffectiveDate = (ChangeDateFormat(coPayBenefitCode.benefitCodeEffectiveDate) != null)?ChangeDateFormat(coPayBenefitCode.benefitCodeEffectiveDate):''; 
                                                String strExpireDate = (ChangeDateFormat(coPayBenefitCode.benefitCodeExpirationDate) != null)?ChangeDateFormat(coPayBenefitCode.benefitCodeExpirationDate):''; 
                                                String strMatch = strEffectiveDate + ' - ' + strExpireDate;
                                                ObjdateRangeVersion.dateRange = strMatch;
                                                String sectionKey =  coPayBenefitCode.benefitCode+' - '+coPayBenefitCode.benefitName;
                                                wrapper.mapDateVersion.put(sectionKey,ObjdateRangeVersion);
                                                if(coPayBenefitCode.BenefitCostShare != null && wrapper.benefitAccumulatorMap.containsKey(sectionKey) == false){                                          
                                                    for (ACETGetBenefitAccJSON2Apex.BenefitCostShare BenefitCostShare :coPayBenefitCode.BenefitCostShare) {
                                                        if(BenefitCostShare.costShareType == 'Benefit Maximum') {
                                                            objAccumulator = new ACETGroupPlanBenefitWrapper.Accumulator();
                                                            objAccumulator.coverageLevel = (BenefitCostShare.coverageLevel != null)?BenefitCostShare.coverageLevel:'';
                                                            objAccumulator.costShareType = (BenefitCostShare.costShareType != null)?BenefitCostShare.costShareType:'';
                                                            objAccumulator.benefitMaximumValue = (BenefitCostShare.benefitMaximumValue != null)?BenefitCostShare.benefitMaximumValue:'';
                                                            if(BenefitCostShare.benefitMaximumUnit == 'Limits'){
                                                                objAccumulator.benefitMaximumUnit = 'Visits';
                                                            }
                                                            else{
                                                                objAccumulator.benefitMaximumUnit = (BenefitCostShare.benefitMaximumUnit != null)?BenefitCostShare.benefitMaximumUnit:'';
                                                            }    
                                                            objAccumulator.benefitYTDValue = (BenefitCostShare.benefitYTDValue != null)? BenefitCostShare.benefitYTDValue:'';
                                                            objAccumulator.benefitRemainingValue = (BenefitCostShare.benefitRemainingValue != null)?BenefitCostShare.benefitRemainingValue:'';
                                                            
                                                            if(wrapper.benefitAccumulatorMap.containsKey(sectionKey) == false){
                                                                wrapper.benefitAccumulatorMap.put(sectionKey, new List<ACETGroupPlanBenefitWrapper.Accumulator>());
                                                            }
                                                            
                                                            wrapper.benefitAccumulatorMap.get(sectionKey).add(objAccumulator);
                                                            wrapper.benefitAccumulatorMap.get(sectionKey).sort();
                                                            accumLst.add(objAccumulator);   
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        
                        if(planTierBasePlanMap != null) {
                            wrapper.accumulatorList = new List<ACETGroupPlanBenefitWrapper.AccumulatorP>();
                            integer coInsuranceTotal = 100;
                            for(String benefitPla: planTierBasePlanMap.keySet()) {
                                List<ACETGetBenefitAccJSON2Apex.PlanTier> planTierList = planTierBasePlanMap.get(benefitPla);
                                for(ACETGetBenefitAccJSON2Apex.PlanTier planTier:planTierList) {
                                    ACETGetBenefitAccJSON2Apex.PlanTier accPlanTier = planTierRiderPlanMap.get(planTier.tierTypeDescription);   
                                    Accumulator = new ACETGroupPlanBenefitWrapper.AccumulatorP();
                                    Accumulator.Section = 'Individual';
                                    Accumulator.TypeCode = planTier.tierTypeCode == 'INN' ? 'INN' : 'OON';
                                    Accumulator.MaxDeductible = String.isNotBlank(planTier.primaryIndividualDeductibleMaximum) ? (planTier.primaryIndividualDeductibleMaximum) : 'N/A';
                                
                                    if(accPlanTier != null && planTierStr == planTier.tierTypeDescription && coverageLevelIndividual.contains('Individual')) {
                                        if(costShareTypeDED == 'Deductible' && costShareTypeOOP == 'Out of Pocket') {
                                            Accumulator.YTDDeductible = (String.isNotBlank(PlanTier.primaryIndividualDeductibleYTD) ? (PlanTier.primaryIndividualDeductibleYTD) : 'N/A'+(String.isNotBlank(accPlanTier.primaryIndividualDeductibleYTD) ? (accPlanTier.primaryIndividualDeductibleYTD) : 'N/A'));
                                            Accumulator.YTDOOP = (String.isNotBlank(PlanTier.primaryIndividualOOPYTD)?(PlanTier.primaryIndividualOOPYTD) : 'N/A' )+(String.isNotBlank(accPlanTier.primaryIndividualOOPYTD) ? (accPlanTier.primaryIndividualOOPYTD) : 'N/A');
                                        }
                                        else if(costShareTypeDED == 'Deductible' && costShareTypeOOP != 'Out of Pocket') {
                                            Accumulator.YTDDeductible = (String.isNotBlank(PlanTier.primaryIndividualDeductibleYTD)? (PlanTier.primaryIndividualDeductibleYTD) : 'N/A')+(String.isNotBlank(accPlanTier.primaryIndividualDeductibleYTD) ? (accPlanTier.primaryIndividualDeductibleYTD) : 'N/A');
                                            Accumulator.YTDOOP = (String.isNotBlank(PlanTier.primaryIndividualOOPYTD)? (PlanTier.primaryIndividualOOPYTD) : 'N/A');
                                        }
                                        else if(costShareTypeDED != 'Deductible' && costShareTypeOOP == 'Out of Pocket') {
                                            Accumulator.YTDDeductible = (String.isNotBlank(PlanTier.primaryIndividualDeductibleYTD)?(PlanTier.primaryIndividualDeductibleYTD) : 'N/A');
                                            Accumulator.YTDOOP = (String.isNotBlank(PlanTier.primaryIndividualOOPYTD)? (PlanTier.primaryIndividualOOPYTD) : 'N/A')+(String.isNotBlank(accPlanTier.primaryIndividualOOPYTD) ? (accPlanTier.primaryIndividualOOPYTD) : 'N/A');
                                        }
                                    }
                                    
                                    if(Accumulator.YTDDeductible == null) {
                                        Accumulator.YTDDeductible = (PlanTier.primaryIndividualDeductibleYTD != null) ? (PlanTier.primaryIndividualDeductibleYTD) : 'N/A';
                                    }
                                    
                                    if(Accumulator.YTDOOP == null) {
                                        Accumulator.YTDOOP = (PlanTier.primaryIndividualOOPYTD != null) ? (PlanTier.primaryIndividualOOPYTD) : 'N/A';
                                    }
                                    Accumulator.coinsurance = (PlanTier.primaryCoInsurance != null) ? (coInsuranceTotal - integer.valueOf(PlanTier.primaryCoInsurance)) : integer.valueOf(0);
                                    Accumulator.MaxDed = (String.valueOf(Accumulator.MaxDeductible) == 'N/A')?'0.00':Accumulator.MaxDeductible;
                                    Accumulator.YTDDed = (String.valueOf(Accumulator.YTDDeductible) == 'N/A')?'0.00':Accumulator.YTDDeductible;
                                    //Accumulator.RemDeductible = string.ValueOf(Decimal.ValueOf(Accumulator.MaxDed) - Decimal.ValueOf(Accumulator.YTDDed));
                                    if(Accumulator.MaxDeductible == 'N/A' && Accumulator.YTDDeductible == 'N/A'){
                                        Accumulator.RemDeductible = 'N/A';
                                        
                                    }else{
                                        Accumulator.RemDeductible = string.ValueOf(Decimal.ValueOf(Accumulator.MaxDed) - Decimal.ValueOf(Accumulator.YTDDed));
                                    }
                                    Accumulator.MaxOOP = String.isNotBlank(planTier.primaryIndividualOOPMaximum) ? (planTier.primaryIndividualOOPMaximum) : 'N/A';
                                    Accumulator.MaxOutofPoc = (String.valueOf(Accumulator.MaxOOP) == 'N/A')?'0.00':Accumulator.MaxOOP;
                                    Accumulator.YTDOutofPoc = (String.valueOf(Accumulator.YTDOOP) == 'N/A')?'0.00':Accumulator.YTDOOP;
                                    //Accumulator.RemOOP = string.valueOf(Decimal.ValueOf(Accumulator.MaxOutofPoc) - Decimal.ValueOf(Accumulator.YTDOutofPoc));
                                    if(Accumulator.MaxOOP == 'N/A' && Accumulator.YTDOOP == 'N/A'){
                                        Accumulator.RemOOP = 'N/A';
                                        
                                    }else{
                                        Accumulator.RemOOP = string.valueOf(Decimal.ValueOf(Accumulator.MaxOutofPoc) - Decimal.ValueOf(Accumulator.YTDOutofPoc));
                                    }
                                    Accumulator.primaryAccumDeduct = string.isNotBlank(planTier.primaryFamilyAccumulationTypeDescriptionDeductible) ? (planTier.primaryFamilyAccumulationTypeDescriptionDeductible) : 'N/A';
                                    Accumulator.primaryAccumDescOOP = string.isNotBlank(planTier.primaryFamilyAccumulationTypeDescriptionOOP) ? (planTier.primaryFamilyAccumulationTypeDescriptionOOP) : 'N/A';
                                    wrapper.accumulatorList.add(Accumulator);
                                    
                                    Accumulator = new ACETGroupPlanBenefitWrapper.AccumulatorP();
                                    Accumulator.Section = 'Family';
                                    Accumulator.TypeCode = planTier.tierTypeCode == 'INN' ? 'INN' : 'OON';
                                   
                                    Accumulator.MaxDeductible = String.isNotBlank(planTier.primaryFamilyDeductibleMaximum) ? (planTier.primaryFamilyDeductibleMaximum) : 'N/A';
                                    if(accPlanTier != null && planTierStr == planTier.tierTypeDescription && coverageLevelIndividual.contains('Family')) {
                                        if(costShareTypeDED == 'Deductible' && costShareTypeOOP == 'Out of Pocket') {
                                            Accumulator.YTDDeductible = (String.isNotBlank(PlanTier.primaryFamilyDeductibleYTD)? (PlanTier.primaryFamilyDeductibleYTD) : 'N/A')+(String.isNotBlank(accPlanTier.primaryFamilyDeductibleYTD) ? (accPlanTier.primaryFamilyDeductibleYTD) : 'N/A');
                                            Accumulator.YTDOOP = (String.isNotBlank(PlanTier.primaryFamilyOOPYTD)? (PlanTier.primaryFamilyOOPYTD) : 'N/A')+(String.isNotBlank(accPlanTier.primaryFamilyOOPYTD) ? (accPlanTier.primaryFamilyOOPYTD) : 'N/A');
                                        }
                                        else if(costShareTypeDED == 'Deductible' && costShareTypeOOP != 'Out of Pocket') {
                                            Accumulator.YTDDeductible = (String.isNotBlank(PlanTier.primaryFamilyDeductibleYTD)? (PlanTier.primaryFamilyDeductibleYTD) : 'N/A')+(String.isNotBlank(accPlanTier.primaryFamilyDeductibleYTD) ? (accPlanTier.primaryFamilyDeductibleYTD) : 'N/A');
                                            Accumulator.YTDOOP = (String.isNotBlank(PlanTier.primaryFamilyOOPYTD)? (PlanTier.primaryFamilyOOPYTD) : 'N/A');
                                        }
                                        else if(costShareTypeDED != 'Deductible' && costShareTypeOOP == 'Out of Pocket') {
                                            Accumulator.YTDDeductible = (String.isNotBlank(PlanTier.primaryFamilyDeductibleYTD)? (PlanTier.primaryFamilyDeductibleYTD) : 'N/A');
                                            Accumulator.YTDOOP = (String.isNotBlank(PlanTier.primaryFamilyOOPYTD)? (PlanTier.primaryFamilyOOPYTD) : 'N/A')+(String.isNotBlank(accPlanTier.primaryFamilyOOPYTD) ? (accPlanTier.primaryFamilyOOPYTD) : 'N/A');
                                        }
                                    }
                                    if(Accumulator.YTDDeductible == null) {
                                        Accumulator.YTDDeductible = (PlanTier.primaryFamilyDeductibleYTD != null) ? (PlanTier.primaryFamilyDeductibleYTD) : 'N/A';
                                    }
                                    
                                    if(Accumulator.YTDOOP == null) {
                                        Accumulator.YTDOOP = (PlanTier.primaryFamilyOOPYTD != null) ? (PlanTier.primaryFamilyOOPYTD) : 'N/A';
                                    }
                                    Accumulator.coinsurance = (PlanTier.primaryCoInsurance != null)? (coInsuranceTotal - Integer.valueOf(PlanTier.primaryCoInsurance)) : 0;
                                    Accumulator.MaxDed = (String.valueOf(Accumulator.MaxDeductible) == 'N/A')?'0.00':Accumulator.MaxDeductible;
                                    Accumulator.YTDDed = (String.valueOf(Accumulator.YTDDeductible) == 'N/A')?'0.00':Accumulator.YTDDeductible;
                                    //Accumulator.RemDeductible = string.ValueOf(Decimal.ValueOf(Accumulator.MaxDed) - Decimal.ValueOf(Accumulator.YTDDed));
                                    if(Accumulator.MaxDeductible == 'N/A' && Accumulator.YTDDeductible == 'N/A'){
                                        Accumulator.RemDeductible = 'N/A';
                                        
                                    }else{
                                        Accumulator.RemDeductible = string.ValueOf(Decimal.ValueOf(Accumulator.MaxDed) - Decimal.ValueOf(Accumulator.YTDDed));
                                    }
                                    
                                    Accumulator.MaxOOP = String.isNotBlank(planTier.primaryFamilyOOPMaximum) ? (planTier.primaryFamilyOOPMaximum) : 'N/A';
                                    Accumulator.MaxOutofPoc = (String.valueOf(Accumulator.MaxOOP) == 'N/A')?'0.00':Accumulator.MaxOOP;
                                    Accumulator.YTDOutofPoc = (String.valueOf(Accumulator.YTDOOP) == 'N/A')?'0.00':Accumulator.YTDOOP;
                                    //Accumulator.RemOOP = string.valueOf(Decimal.ValueOf(Accumulator.MaxOutofPoc) - Decimal.ValueOf(Accumulator.YTDOutofPoc));
                                    if(Accumulator.MaxOOP == 'N/A' && Accumulator.YTDOOP == 'N/A'){
                                        Accumulator.RemOOP = 'N/A';
                                        
                                    }else{
                                        Accumulator.RemOOP = string.valueOf(Decimal.ValueOf(Accumulator.MaxOutofPoc) - Decimal.ValueOf(Accumulator.YTDOutofPoc));
                                   }
                                    
                                    Accumulator.primaryAccumDeduct = string.isNotBlank(planTier.primaryFamilyAccumulationTypeDescriptionDeductible) ? (planTier.primaryFamilyAccumulationTypeDescriptionDeductible) : 'N/A';
                                    Accumulator.primaryAccumDescOOP = string.isNotBlank(planTier.primaryFamilyAccumulationTypeDescriptionOOP) ? (planTier.primaryFamilyAccumulationTypeDescriptionOOP) : 'N/A';
                                    wrapper.accumulatorList.add(Accumulator);
                                    
                                }
                            }
                        }
                        oACETWSCalloutResult.Success = true;
                        oACETWSCalloutResult.Message = '';
                        oACETWSCalloutResult.Response =  wrapper;
                    } else {
                        oACETWSCalloutResult.Success = false;
                        oACETWSCalloutResult.Message = GetOILErrorMessage(ACETJSON2Apex.benefitAccumulatorRSResult.getBenefitsAccumulatorResponse.errors);
                        oACETWSCalloutResult.Response = null;
                        oACETWSCalloutResult.MessageSeverity = ApexPages.Severity.INFO;
                    }
                }
                else
                {
                    oACETWSCalloutResult = ParseFailureResponse(Response);
                    oACETWSCalloutResult.Success = false;
                    oACETWSCalloutResult.MessageSeverity = ApexPages.Severity.ERROR;        
                }
            }
            catch(Exception ex)
            {
                System.debug('getStackTraceString ' + ex.getStackTraceString());
                oACETWSCalloutResult.Success = false;
                oACETWSCalloutResult.Message = ex.getMessage();
                oACETWSCalloutResult.MessageSeverity = ApexPages.Severity.ERROR;
            }
            return oACETWSCalloutResult;
      } */
      
      public List<ACETPlanBenefitLanguageWrapper.BenefitWrapper> getAccumulatorBenefitsRedesign(String BenefitBundleOptId, 
                                                                         String EnrolleeIdentifierType, 
                                                                         String EnrolleeIdentifierId,
                                                                         String SubscriberIdentifierId, 
                                                                         String EffectiveStartDate, 
                                                                         String EffectiveEndDate, 
                                                                         String CoverageType, 
                                                                         String BenefitVerIndicator, 
                                                                         String BenefitCode, string accumAsOf, String GroupNumber, String SubscriptionServiceResponse,String MembershipDuration,String SubscriptionResponse,List<String> existsOnRiderPlanArray) {
          Map<String,List<String>> tierTypeCodeMap = new Map<String,List<String>>();
          Map<String,String> tierTypeIdentifierMap = new Map<String,String>();
          List<String> SubscriptionServiceResponseList = new List<String>();
          List<String> SubscriptionResponseList = new List<String>(); 
          String existsOnRiderPlanBenefitIndicator = '';  
          //BenefitCode = 'RX_TIER_1';     
          Map<String,List<ACETGetAccumulatorRedesignJSON2APEX.benefitCode>> benefitPlanMap = new Map<String,List<ACETGetAccumulatorRedesignJSON2APEX.benefitCode>>();         
          system.debug('SubscriptionServiceResponse::'+SubscriptionServiceResponse);
          system.debug('MembershipDuration'+MembershipDuration); 
          system.debug('SubscriptionResponse::'+SubscriptionResponse);  
          System.debug('BenefitCode'+BenefitCode);                                                                 
          if(String.isNotBlank(SubscriptionServiceResponse)){         
            SubscriptionServiceResponseList = SubscriptionServiceResponse.split(',');
          } 
          if(SubscriptionServiceResponseList != null && !SubscriptionServiceResponseList.isEmpty()){                          
            for(String s : SubscriptionServiceResponseList){
              //system.debug('s :'+s);
              List<string> tempString = new List<String>();
              tempString = s.split('-');
              String first = tempString[tempString.size() - 2];
              //system.debug('first'+first);
              String last = tempString[tempString.size()-1];
              //system.debug('first'+last);
              List<String> temp = tierTypeCodeMap.get(first);
                if(temp == null) {
                      tierTypeCodeMap.put(first, new List<String>{last});
                } else {
                      temp.add(last);
                }  
              }    
              System.debug('tierTypeCodeMap ::'+tierTypeCodeMap);    
          }  
          Set<String> tierCodeSet = new Set<String>();
          if(tierTypeCodeMap != null && !tierTypeCodeMap.isEmpty()) { 
           for( String key: tierTypeCodeMap.keySet() ){
           List<String> lstString = tierTypeCodeMap.get(key);
          if ( lstString.size()>0 )
          {
          tierCodeSet.addAll(lstString);
          }
         }
        }
        if(String.isNotBlank(SubscriptionResponse)){
           SubscriptionResponseList = SubscriptionResponse.split(','); 
        }   
         if(SubscriptionResponseList != null && !SubscriptionResponseList.isEmpty()){ 
          for(String s : SubscriptionResponseList) { 
              List<string> tempTierIdentifier = new List<String>();
              tempTierIdentifier = s.split('-');
              if(tempTierIdentifier !=null && tempTierIdentifier.size() > 0){
                String tierIdentifier = tempTierIdentifier[tempTierIdentifier.size() - 2];
                system.debug('tierIdentifier'+tierIdentifier);
                String tierType = tempTierIdentifier[tempTierIdentifier.size()-1];
                system.debug('tierType'+tierType);  
                tierTypeIdentifierMap.put(tierIdentifier,tierType); 
              }
          }
        }     
           System.debug('existsOnRiderPlanArray'+existsOnRiderPlanArray);                                                                
           if(existsOnRiderPlanArray != null && !existsOnRiderPlanArray.isEmpty()) {
               For(Integer i =0; i<existsOnRiderPlanArray.size();i++) {
                   if(existsOnRiderPlanArray[i].contains('-')) {
                   String existsOnRiderPlanBenefitKey = existsOnRiderPlanArray[i].split('-')[0];
                   System.debug('BenefitCode--->123'+BenefitCode);
                   System.debug('existsOnRiderPlanArray7777'+existsOnRiderPlanBenefitKey);
                                          System.debug('existsOnRiderPlanBenefitKey.trim()'+existsOnRiderPlanBenefitKey.trim());

                   if(BenefitCode.trim() == existsOnRiderPlanBenefitKey.trim()) {
                     //  if(BenefitCode.equals(existsOnRiderPlanBenefitKey)){
                
                       System.debug('benefit code matches existsriderplan');
                       System.debug('existsOnRiderPlanArray1234'+existsOnRiderPlanArray[i]); 
                       if(existsOnRiderPlanArray[i].contains('=')) {
                         existsOnRiderPlanBenefitIndicator = existsOnRiderPlanArray[i].split('=')[1];
                         System.debug('existsOnRiderPlanBenefitIndicator456'+existsOnRiderPlanBenefitIndicator);
                       }
                   }
               }
           } 
           }
          System.debug('tierTypeIdentifierMap :'+tierTypeIdentifierMap);    
          ACETPlanBenefitLanguageWrapper.BenefitWrapper bw = new ACETPlanBenefitLanguageWrapper.BenefitWrapper(); 
          List<ACETPlanBenefitLanguageWrapper.BenefitWrapper> accumList = new List<ACETPlanBenefitLanguageWrapper.BenefitWrapper>(); 
          Map<String,ACETPlanBenefitLanguageWrapper.AccumulatorCode> accumMap = new Map<String,ACETPlanBenefitLanguageWrapper.AccumulatorCode>(); 
          Map<String,ACETPlanBenefitLanguageWrapper.AccumulatorCode> accumOONMap = new Map<String,ACETPlanBenefitLanguageWrapper.AccumulatorCode>();                                                                      
          List<ACETPlanBenefitLanguageWrapper.AccumulatorCode> aList = new List<ACETPlanBenefitLanguageWrapper.AccumulatorCode>();
          List<ACETPlanBenefitLanguageWrapper.AccumulatorCode> aOONList = new List<ACETPlanBenefitLanguageWrapper.AccumulatorCode>();
          bw.dateRange = new list<string>();                                                              
          try {
            HttpResponse response = null;
            GetEndpoint();
            List<String> accumsBeefitsCode = BenefitCode.split(',');
            //system.debug('accumsBeefitsCode :'+accumsBeefitsCode);  
            String accumsBenefitJoin='';
           
            for(String s: accumsBeefitsCode ){
               accumsBenefitJoin = accumsBenefitJoin+'{"benefitCode":'+'"'+s.removeEnd('_').trim()+'"},';    
            }
            accumsBenefitJoin = accumsBenefitJoin.removeEnd(',');
            RequestParameters = new List<String>{BenefitBundleOptId, EnrolleeIdentifierType, EnrolleeIdentifierId,SubscriberIdentifierId, ChangeDateFormatForOIL(EffectiveStartDate), 
            ChangeDateFormatForOIL(EffectiveEndDate), CoverageType, BenefitVerIndicator, accumsBenefitJoin, ChangeDateFormatForOIL(accumAsOf),GroupNumber};
            GetRequestBody(); 
            System.debug('tierCodeSet ::'+tierCodeSet);
            Response = Send(OAuthConfig); 
            if (Response.getStatusCode() == 200) {
                  bw.accumulatorCodeList =  new list<ACETPlanBenefitLanguageWrapper.AccumulatorCode>();
                  ACETGetAccumulatorRedesignJSON2APEX ACETJSON2Apex = (ACETGetAccumulatorRedesignJSON2APEX)JSON.deserialize(Response.getBody(), ACETGetAccumulatorRedesignJSON2APEX.class); 
                  if(ACETJSON2Apex.getBenefitAccumulatorResponse.benefitAccumulator != null) {
                      ACETGetAccumulatorRedesignJSON2APEX.benefitAccumulator benefitsAccumulator = ACETJSON2Apex.getBenefitAccumulatorResponse.benefitAccumulator;
                      //System.debug('benefitsAccumulator::::'+benefitsAccumulator);
                      if(benefitsAccumulator != null) {
                          
                          for(ACETGetAccumulatorRedesignJSON2APEX.benefitPlan benefitPlanObj: benefitsAccumulator.benefitPlan) {
                                  benefitPlanMap.put(benefitPlanObj.benefitPlanId,benefitPlanObj.benefitCode);
                                  String benefitPlanKey = benefitPlanObj.benefitPlanId;
                                  System.debug('benefitPlanKey'+benefitPlanKey);
                                 List<ACETGetAccumulatorRedesignJSON2APEX.benefitCode> benefitPlanCodeObj = benefitPlanMapping(benefitPlanMap,existsOnRiderPlanBenefitIndicator,benefitPlanKey);
                                 System.debug('benefitPlanCodeObj'+benefitPlanCodeObj); 
                                if(benefitPlanCodeObj != null) {
                                 for(ACETGetAccumulatorRedesignJSON2APEX.benefitCode benefitCodeObj: benefitPlanCodeObj) {
                                  bw.BenefitKey = getValidString(benefitCodeObj.benefitCode)+' - '+getValidString(benefitCodeObj.benefitName);
                                  //system.debug('bw.BenefitKey :'+bw.BenefitKey);
                                  if(string.isNotBlank(benefitCodeObj.benefitCodeEffectiveDate) && string.isNotBlank(benefitCodeObj.benefitCodeExpirationDate)){    
                                    string listVal = ChangeDateFormat(benefitCodeObj.benefitCodeEffectiveDate)+' - '+ChangeDateFormat(benefitCodeObj.benefitCodeExpirationDate);
                                    System.debug('listVal :'+listVal);
                                    if(!bw.dateRange.contains(listVal)){
                                        bw.dateRange.add(listVal);  
                                    }
                                    if(string.isNotBlank(benefitCodeObj.benefitVersion)){
                                        bw.dateVersion = benefitCodeObj.benefitVersion;
                                    }
                                        System.debug('benefitCodeObj.benefitTier :'+benefitCodeObj.benefitTier);
                                        System.debug('tierCodeSet :'+tierCodeSet);
                                        System.debug('tierTypeIdentifierMap'+tierTypeIdentifierMap);
                                        if((String.isNotBlank(existsOnRiderPlanBenefitIndicator) && existsOnRiderPlanBenefitIndicator == 'true') ||(String.isBlank(existsOnRiderPlanBenefitIndicator) && String.ValueOf(tierTypeCodeMap.keySet()).removeEnd('}').removeStart('{')==benefitPlanObj.benefitPlanId && tierCodeSet.contains(benefitCodeObj.benefitTier) && tierTypeIdentifierMap != null && tierTypeIdentifierMap.containsKey(benefitCodeObj.benefitTier))){
                                            
                                            for(ACETGetAccumulatorRedesignJSON2APEX.benefitCostShare benefitCostShareObj: benefitCodeObj.benefitCostShare) {
                                                //System.debug('benefitCostShareObj.costShareType:::'+benefitCostShareObj.costShareType);
                                                if(benefitCostShareObj.costShareType == 'Benefit Maximum' || (benefitCostShareObj.primaryCostShareIndicator == 'false' && benefitCostShareObj.benefitMaximumValue!=null))  { //Benefit Maximum
                                                    ACETPlanBenefitLanguageWrapper.AccumulatorCode Ac = new ACETPlanBenefitLanguageWrapper.AccumulatorCode();
                                                    Ac.BenefitKey = bw.BenefitKey;
                                                    Ac.coverageLevel = (String.isNotBlank(benefitCostShareObj.coverageLevel)? (benefitCostShareObj.coverageLevel) : '');
                                                    Ac.coverageType = (String.isNotBlank(tierTypeIdentifierMap.get(benefitCodeObj.benefitTier))? (tierTypeIdentifierMap.get(benefitCodeObj.benefitTier)) : '');
                                                    Ac.costShareType = (String.isNotBlank(benefitCostShareObj.costShareType) ? (benefitCostShareObj.costShareType) : '');
                                                    Ac.benefitMaximumValue = (String.isNotBlank(benefitCostShareObj.benefitMaximumValue) ? (benefitCostShareObj.benefitMaximumValue) : '');
                                                    if(Ac.benefitMaximumUnit == 'Limits'){
                                                        Ac.benefitMaximumUnit = 'Visits';
                                                    }
                                                    else{
                                                        Ac.benefitMaximumUnit = (String.isNotBlank(benefitCostShareObj.benefitMaximumUnit) ? (benefitCostShareObj.benefitMaximumUnit) : '');
                                                    }    
                                                    Ac.benefitYTDValue = (String.isNotBlank(benefitCostShareObj.benefitYTDValue) ? (benefitCostShareObj.benefitYTDValue) : '');
                                                    if(String.isNotBlank(benefitCostShareObj.limitAccumulatorBenefitPeriodDurationCount) && String.isNotBlank(benefitCostShareObj.limitAccumulatorBenefitPeriodDurationCode)) {
                                                       Ac.duration  = (String.isNotBlank(benefitCostShareObj.limitAccumulatorBenefitPeriodDurationCount) ? (benefitCostShareObj.limitAccumulatorBenefitPeriodDurationCount) : '') + '  '+ (String.isNotBlank(benefitCostShareObj.limitAccumulatorBenefitPeriodDurationCode ) ? (benefitCostShareObj.limitAccumulatorBenefitPeriodDurationCode ) : '') ;
                                                    } 
                                                    else if(benefitCostShareObj.costShareType == 'Out of Pocket' && String.isBlank(benefitCostShareObj.limitAccumulatorBenefitPeriodDurationCount) && String.isBlank(benefitCostShareObj.limitAccumulatorBenefitPeriodDurationCode)) {
                                                        Ac.duration = (String.isNotBlank(MembershipDuration)) ? ('1'+ '  '+MembershipDuration):'';
                                                    }
                                                    else {
                                                        Ac.duration = '';
                                                    }
                                                    Ac.benefitRemainingValue = (String.isNotBlank(benefitCostShareObj.benefitRemainingValue) ? (benefitCostShareObj.benefitRemainingValue) : '');
                                                    Ac.dateRangeValue = listVal;
                                                    System.debug('benefitCostShareObj.costShareId'+benefitCostShareObj.costShareId);
                                                    Ac.dateRange = new List<string>();
                                                    if(bw.dateRange != Null){
                                                        Ac.dateRange.addAll(bw.dateRange);    
                                                    }
                                                    if(string.isNotBlank(benefitCodeObj.benefitVersion)){
                                                        Ac.dateVersion = benefitCodeObj.benefitVersion;
                                                    }
                                                    Ac.costShareId = benefitCostShareObj.costShareId;
                                                    if(Ac.coverageType == 'INN') {
                                                       accumMap.put(benefitCostShareObj.costShareId+Ac.coverageLevel+Ac.benefitMaximumUnit+Ac.BenefitKey,Ac);
                                                       System.debug('INN'+accumMap);
                                                    }
                                                    if(Ac.coverageType == 'OON') {
                                                      accumOONMap.put(benefitCostShareObj.costShareId+Ac.coverageLevel+Ac.benefitMaximumUnit+Ac.BenefitKey,Ac);
                                                      System.debug('OON'+accumOONMap);                                                        
                                                    }
                                                    system.debug('benefitCodeObj.benefitTier+benefitCostShareObj.coverageLevel+Ac.BenefitKey :'+benefitCodeObj.benefitTier+benefitCostShareObj.coverageLevel+Ac.BenefitKey);
                                                    if(bw.accumulatorCodeList == null){
                                                        bw.accumulatorCodeList = new list<ACETPlanBenefitLanguageWrapper.AccumulatorCode>{Ac};
                                                    }   
                                                }
                                                System.debug('bw.accumulatorCodeList ::'+bw.accumulatorCodeList);
                                            }
                                        }  
                                              
                                      
                                      
                                  }
                              }
                              
                          }
                          }
                          System.debug('accumMap :::::'+accumMap);
                          System.debug('accumOONMap ::::'+accumOONMap);
                          if(accumMap.size() > 0){
                              aList.addAll(accumMap.Values());
                              aList.sort();
                              System.debug('aList ::'+aList);
                              bw.accumulatorCodeList.addAll(aList);
                          }
                          if(accumOONMap.size() > 0) {
                              aOONList.addAll(accumOONMap.Values());
                              aOONList.sort();
                              System.debug('aOONList ::'+aOONList);
                              bw.accumulatorCodeList.addAll(aOONList);
                          }
                      }
                  } 
                     bw.isSuccess = true;
                     bw.Message = '';  
                     accumList.add(bw);
              }
             else if (Response.getStatusCode() == 404){     
                    bw = new ACETPlanBenefitLanguageWrapper.BenefitWrapper(); 
                    bw.isSuccess = false;
                    bw.messageSeverityStr = 'INFO';
                    ACETGetAccumulatorRedesignJSON2APEX JSON2ApexError = (ACETGetAccumulatorRedesignJSON2APEX)JSON.deserialize(Response.getBody(), ACETGetAccumulatorRedesignJSON2APEX.class);
                    bw.Message = GetOILErrorMessage(JSON2ApexError.getBenefitAccumulatorResponse.errors);
                    System.debug('*****'+bw);  
                    accumList.add(bw);
                }else {
                    bw = new ACETPlanBenefitLanguageWrapper.BenefitWrapper();
                    bw.isSuccess = false;
                    bw = ParseFailureResponseFromOil(Response); 
                    System.debug('*****500'+bw); 
                    accumList.add(bw);
                }                     
      }
      catch(Exception w) {
          System.debug('Excepttion:::'+w);
      }
      System.debug(' accumList ::' + accumList);
      return  accumList;
   }
      
    public string getValidString(string inputStr){
        if(string.isNotBlank(inputStr)){
            inputStr = inputStr.replaceAll('\"','');
            return inputStr;
            
        }else{
            return '';
        }
    }
    public Map<String,String> durationMap {get; set;}
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
    private static List<ACETGetAccumulatorRedesignJSON2APEX.benefitCode> benefitPlanMapping(Map<String,List<ACETGetAccumulatorRedesignJSON2APEX.benefitCode>> benefitPlanMap,String existsOnRiderPlanBenefitIndicator,String benefitPlanKey) {
       List<ACETGetAccumulatorRedesignJSON2APEX.benefitCode> benefitCodeObj = new List<ACETGetAccumulatorRedesignJSON2APEX.benefitCode>();
        System.debug('benefitPlanMap' +benefitPlanMap);
        if(benefitPlanMap != null && benefitPlanKey != null && benefitPlanKey != '' && benefitPlanMap.containsKey(benefitPlanKey)) {
            System.debug('benefitPlanMap' +benefitPlanMap);
            for(String benefitKey : benefitPlanMap.keyset()) {
                if(String.isNotBlank(existsOnRiderPlanBenefitIndicator) && existsOnRiderPlanBenefitIndicator == 'true' && String.isNotBlank(benefitKey) && benefitKey.startsWith('MR')) {
                   System.debug('rider plan'); 
                   benefitCodeObj = benefitPlanMap.get(benefitKey);
                   
                }else if(String.isBlank(existsOnRiderPlanBenefitIndicator)) {
                    System.debug('medical plan');
                    benefitCodeObj = benefitPlanMap.get(benefitKey);
                }
            }
        }
        System.debug('benefitCodeObj'+benefitCodeObj);
        return benefitCodeObj;
    }
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
    public ACETPlanBenefitLanguageWrapper.BenefitWrapper ParseFailureResponseFromOil(HttpResponse FailureResponse)   {
        ACETPlanBenefitLanguageWrapper.BenefitWrapper bw = new ACETPlanBenefitLanguageWrapper.BenefitWrapper();
        bw.isSuccess = false;   
        bw.MessageSeverity = ApexPages.Severity.ERROR;
        try {
            Map<String, Object> mapRootNode = (Map<String, Object>)JSON.deserializeUntyped(FailureResponse.getBody());
            if (FailureResponse.getStatusCode() == 500 && 
                (mapRootNode.containsKey('ErrorCode') && mapRootNode.containsKey('Advice'))) {
                //Parse failure repsonse from ISL
                bw.Message = Label.ACETUnexpectedErrorMessage; 
                system.debug('List Errors 500:' + bw.Message);
            } else { 
                //Parse failure response from OIL
                Map<String, Object> mapErrors = (Map<String, Object>)mapRootNode.values().get(0);
                system.debug('Map Errors:' + mapErrors);
                List<Object> lstErrors = (List<Object>)mapErrors.get('errors');
                system.debug('List Errors:' + lstErrors);
                if (lstErrors == null) {
                    Map<String, Object> mapTypeNode = (Map<String, Object>)mapErrors.values().get(0);
                    lstErrors = (List<Object>)mapTypeNode.get('errors');
                    system.debug('List Errors 2:' + lstErrors);
                }
                Map<String, Object> mapError;
                String ErrorDescription;
                if(lstErrors != null) {
                    for (Object oError :lstErrors) {
                        mapError = (Map<String, Object>)oError;
                        system.debug('Error: ' + mapError);
                        ErrorDescription = String.valueOf(mapError.get('description'));
                        if (String.isBlank(bw.Message)) { 
                            bw.Message = ErrorDescription;
                        } else {
                            if (bw.Message.length() + ErrorDescription.length() <= 255) {
                                bw.Message += '; ' + ErrorDescription;
                            } else {
                                break;
                            }   
                        }   
                    }
                }
            }       
        }
        catch(Exception ex)
        {
            system.debug(LoggingLevel.INFO, 'Error serializing error response JSON. Details: ' + ex);
            bw.Message = FailureResponse.getBody();
        }
        
        return bw;
      }
}