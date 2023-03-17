public class ACETLGT_PlanBenefitController {
    private static String sessionId = UserInfo.getSessionId();
    
    @AuraEnabled 
    public static List <ACETLanguageCTIndicator__c> getBenefitLanguageIndicatormdt(){
       return new List<ACETLanguageCTIndicator__c>([select Name,Benefit_Code__c from ACETLanguageCTIndicator__c order by Benefit_Code__c asc]);
    }
    public class SearchResultBenefitsWrapper {   
        @AuraEnabled public List<ACETGroupPlanBenefitLEXWrapper.PlanInformationWrapper> resultWrapper {get;set;}
        @AuraEnabled public List<String> networkScheduleList {get;set;}
        @AuraEnabled public String eHBIndicator {get;set;}
        @AuraEnabled public List<ACETGroupPlanBenefitLEXWrapper.BenefitWrapper> resultBenefitWrapper {get;set;}
        @AuraEnabled public List<ACETGroupPlanBenefitLEXWrapper.OONReimbursement> resultOONReimbursementWrapper {get;set;}
        @AuraEnabled public Map<String,String> benefitCodeKeyMap {get;set;}
        @AuraEnabled public Map<String,String> varriableCoverageMap {get;set;}
        @AuraEnabled public Map<String,String> benefitDisplayMap {get;set;}
        @AuraEnabled public String tierTypeCodeList {get;set;}
        @AuraEnabled public String tierTypeIdentifierList {get;set;}
        @AuraEnabled public Map<String,String> existsOnRiderPlanMap {get;set;}
        @AuraEnabled public List<SelectOption> benefitCategoryOptionList{get;set;}  //US3582935 : Added By Manish 
        @AuraEnabled public Map<String,List<ACETLGT_GetBenefitCategoryResponse.Child>> benefitCategoryChildrenMap;  //US3582935 : Added By Manish 
    }
    public class SearchResultAccumWrapper {
     @AuraEnabled public List<ACETGroupPlanBenefitLEXWrapper.AccumulatorP> resultIndividualAccumWrapper {get;set;}
     @AuraEnabled public List<ACETGroupPlanBenefitLEXWrapper.AccumulatorP> resultFamilyAccumWrapper {get;set;}
    }
    public class SearchResultBenefitLanguageWrapper {
     @AuraEnabled public List<ACETLGT_PlanBenefitLanguageWrapper.BenefitWrapper> resultBenefitLanguageWrapper {get;set;}
    }
    public class SearchResultBenefitAccumulatorWrapper {
     @AuraEnabled public List<ACETLGT_PlanBenefitLanguageWrapper.BenefitWrapper> resultBenefitAccumulatorWrapper {get;set;}
    }
    
    public class SearchBenefitsByPhraseWrapper {
     @AuraEnabled public List<ACETLGT_SearchBenefitsResponseJSON.Benefit> benefits {get;set;}
    }
    
     public class SearchBenefitsBenefitSectionWrapper {
     @AuraEnabled public List<ACETLGT_GetBenefitSectionResponseJSON.Benefit> benefits {get;set;}
    }
    
    @AuraEnabled
    public static boolean isAvailableServiceCall(String benefitPlanId, String accumulatorAsOf){// function added by suresh
        System.debug('>>>>benefitPlanId::'+benefitPlanId);
        Boolean isAvailable = false;
        ACETWSCalloutResult calloutResult = new ACETWSCalloutResult();
        ACETLGT_AreBenefitsAvailableAPI acetBenefitCat = new ACETLGT_AreBenefitsAvailableAPI();
        calloutResult = acetBenefitCat.getB360AreBenefitsAvailableService(benefitPlanId,accumulatorAsOf); 
        if(calloutResult != null && calloutResult.Success && calloutResult.statusCode == 200){ 
            isAvailable = Boolean.valueOf(calloutResult.response);
        }
        System.debug('isAvailable::'+isAvailable);
        return isAvailable;
    } 
    
     //US3582935 : Added By Manish 
    @AuraEnabled
    public static ACETLGT_GetBenefitCategoryAPI.B360BenefitCategory getB360BenefitCategory(String benefitPlanId, String dateOfService)
    {
        ACETLGT_GetBenefitCategoryAPI.B360BenefitCategory b360BenefitCategory;
        ACETWSCalloutResult calloutResult;
        ACETLGT_GetBenefitCategoryAPI getBenefitCatAPI = new ACETLGT_GetBenefitCategoryAPI();
        calloutResult = getBenefitCatAPI.getB360BenefitCategoryResponse(benefitPlanId,dateOfService);
        if(calloutResult != null && calloutResult.Success && calloutResult.statusCode == 200)
        {
            ACETLGT_GetBenefitCategoryResponse response = (ACETLGT_GetBenefitCategoryResponse)calloutResult.Response;
            b360BenefitCategory = getBenefitCatAPI.processResponse(response);
        }
        return b360BenefitCategory;
    }
     @AuraEnabled
    public static SearchResultBenefitsWrapper getSearchResults(String surrogateKey, String bundleId, String enrollerSRK, String startDate, 
    String endDate, String coverageTypes, String groupNumber, String accumAsOf,String SitusState,String customerPurchaseId){
         system.debug('customerPurchaseId--->'+customerPurchaseId);
         System.debug('surrogateKey:'+ surrogateKey);
         System.debug('bundleId:'+ bundleId);
         System.debug('enrollerSRK:'+ enrollerSRK);
         System.debug('startDate:'+ startDate);
         System.debug('endDate:'+ endDate);
         System.debug('coverageTypes:'+ coverageTypes);
         System.debug('groupNumber:'+ groupNumber);
         System.debug('accumAsOf:'+ accumAsOf); 
         System.debug('SitusState:' +SitusState);
        
        ACETLGT_NimbusGetSSBAPI getPlanBenefitService = new ACETLGT_NimbusGetSSBAPI();
         ACETWSCalloutResult CalloutResult = getPlanBenefitService.getSubscriptionBenefitSearch(bundleId,enrollerSRK,surrogateKey,startDate, 
            endDate, coverageTypes,groupNumber,accumAsOf,SitusState,customerPurchaseId);
        List<ACETGroupPlanBenefitLEXWrapper.PlanInformationWrapper>  planInfoList  = new List<ACETGroupPlanBenefitLEXWrapper.PlanInformationWrapper>();
        List<String> networkSchList = new List<String>();
        List<ACETGroupPlanBenefitLEXWrapper.BenefitWrapper>  memberPlanBenefitList= new List<ACETGroupPlanBenefitLEXWrapper.BenefitWrapper>(); 
        List<ACETGroupPlanBenefitLEXWrapper.OONReimbursement> OONReimbursementList= new List<ACETGroupPlanBenefitLEXWrapper.OONReimbursement>(); 
        String eHBIndicator = '';
        String tierTypeCodeList = '';
        String tierTypeIdentifierList = '';
        Map<String,String> benefitCodeKeyMap  = new Map<String,String>();
        Map<String,String> varriableCoverageMap = new Map<String,String>();
        Map<String,String> benefitDisplayMap = new Map<String,String>();
        Map<String,String> existsOnRiderPlanMap = new Map<String,String>();
        ACETGroupPlanBenefitLEXWrapper planInfoWrapper = (ACETGroupPlanBenefitLEXWrapper)CalloutResult.response;
            if(planInfoWrapper != null) {
                planInfoList = planInfoWrapper.planInfoWrapperList;
                eHBIndicator = planInfoWrapper.eHBIndicator;
                tierTypeCodeList = planInfoWrapper.tierTypeCodeList;
                tierTypeIdentifierList = planInfoWrapper.tierTypeIdentifierList;
                system.debug(LoggingLevel.INFO,'planInfoList:: ' + planInfoList);
                memberPlanBenefitList= planInfoWrapper.benefitWrapperList;
                system.debug(LoggingLevel.INFO,'memberPlanBenefitList:: ' + memberPlanBenefitList);
                if(planInfoList!=null) {             
                    for(ACETGroupPlanBenefitLEXWrapper.PlanInformationWrapper networkSch : planInfoList){
                       // system.debug('qualityProviderTierRuleID--->'+networkSch.tieredPlan);
                        if(networkSch.networkSchedules != null){
                            for(ACETGroupPlanBenefitLEXWrapper.networkScheduleIds netSchObj : networkSch.networkSchedules ){
                                networkSchList.add(netSchObj.networkSchId);
                          }
                        }
                    }
                }
                if(planInfoWrapper.OONReimbursementMap != null) {
                    for(String OONKey: planInfoWrapper.OONReimbursementMap.keySet()) {
                       ACETGroupPlanBenefitLEXWrapper.OONReimbursement OONRiem = new ACETGroupPlanBenefitLEXWrapper.OONReimbursement();
                       OONRiem.Percentile = planInfoWrapper.OONReimbursementMap.get(OONKey);
                       OONRiem.OONPricingType = OONKey;
                       OONReimbursementList.add(OONRiem);
                    }
                     System.debug('ACETGroupPlanBenefitLEXWrapper.OONReimbursement::::'+OONReimbursementList);
                }
                benefitCodeKeyMap = planInfoWrapper.benefitCodeKeyMap;
                varriableCoverageMap = planInfoWrapper.varriableCoverageMap;
                benefitDisplayMap = planInfoWrapper.benefitDisplayMap;
                if(planInfoWrapper.existsOnRiderPlanMap != null) {
                    existsOnRiderPlanMap = planInfoWrapper.existsOnRiderPlanMap;
                }
            }   
            SearchResultBenefitsWrapper detWrap = new SearchResultBenefitsWrapper();
            detWrap.resultWrapper = planInfoList;
            detWrap.networkScheduleList = networkSchList;
            detWrap.resultBenefitWrapper = memberPlanBenefitList;
            detWrap.resultOONReimbursementWrapper = OONReimbursementList;
            detWrap.eHBIndicator = eHBIndicator;
            detWrap.benefitCodeKeyMap = benefitCodeKeyMap;
            detWrap.varriableCoverageMap = varriableCoverageMap;
            detWrap.benefitDisplayMap = benefitDisplayMap;
            detWrap.tierTypeCodeList = tierTypeCodeList;
            detWrap.tierTypeIdentifierList = tierTypeIdentifierList;
            detWrap.existsOnRiderPlanMap = existsOnRiderPlanMap;
            return detWrap;

    } 
    @AuraEnabled
    public static SearchResultAccumWrapper getSearchAccumResults(String surrogateKey, String bundleId, String enrollerSRK, String startDate, 
    String endDate, String coverageTypes, String groupNumber, String accumAsOf,String SitusState){
        
         System.debug('surrogateKey:'+ surrogateKey);
         System.debug('bundleId:'+ bundleId);
         System.debug('enrollerSRK:'+ enrollerSRK);
         System.debug('startDate:'+ startDate);
         System.debug('endDate:'+ endDate);
         System.debug('coverageTypes:'+ coverageTypes);
         System.debug('groupNumber:'+ groupNumber);
         System.debug('accumAsOf:'+ accumAsOf); 
         System.debug('SitusState:' +SitusState);

         ACETLGT_NimbusGetSSBAPI getPlanBenefitService = new ACETLGT_NimbusGetSSBAPI();
         ACETWSCalloutResult CalloutResult = getPlanBenefitService.getSubscriptionBenefitSearch(bundleId,enrollerSRK,surrogateKey,startDate, 
            endDate, coverageTypes, groupNumber,accumAsOf,SitusState,'');
        List<ACETGroupPlanBenefitLEXWrapper.AccumulatorP>  individualAccList  = new List<ACETGroupPlanBenefitLEXWrapper.AccumulatorP>();
        List<ACETGroupPlanBenefitLEXWrapper.AccumulatorP>  familyAccList  = new List<ACETGroupPlanBenefitLEXWrapper.AccumulatorP>();
        Map<String, ACETGroupPlanBenefitLEXWrapper.AccumulatorP> individualSet = new Map<String, ACETGroupPlanBenefitLEXWrapper.AccumulatorP>();
        Map<String, ACETGroupPlanBenefitLEXWrapper.AccumulatorP> familySet = new Map<String, ACETGroupPlanBenefitLEXWrapper.AccumulatorP>();
        ACETGroupPlanBenefitLEXWrapper planInfoWrapper = (ACETGroupPlanBenefitLEXWrapper)CalloutResult.response;
            if(planInfoWrapper != null) {
                if(planInfoWrapper.accumulatorList != null) {             
                    for(ACETGroupPlanBenefitLEXWrapper.AccumulatorP oAccumulator : planInfoWrapper.accumulatorList){
                         if (oAccumulator.Section == 'Individual' && oAccumulator != null) {
                            individualSet.put(oAccumulator.TypeCode,oAccumulator);
                        }
                    }
                if(individualSet.size() > 0) {
                        individualAccList.addAll(individualSet.values());
                        individualAccList.sort();
                    }          
                    for(ACETGroupPlanBenefitLEXWrapper.AccumulatorP oAccumulator : planInfoWrapper.accumulatorList){
                         if (oAccumulator.Section == 'Family' && oAccumulator != null) {
                            familySet.put(oAccumulator.TypeCode,oAccumulator);
                        }
                    }
                if(familySet.size() > 0) {
                        familyAccList.addAll(familySet.values());
                        familyAccList.sort();
                    }
            }
            }
            SearchResultAccumWrapper detWrap = new SearchResultAccumWrapper();
            detWrap.resultIndividualAccumWrapper = individualAccList;
            detWrap.resultFamilyAccumWrapper = familyAccList;
            return detWrap;
            
    } 
     @AuraEnabled
    public static SearchResultBenefitLanguageWrapper getBenefitLanguageResults(String bundleId, String benefitCodes, 
    String asOfDate,String groupNumber,String hippaServiceType,boolean multiple,String benefitDisplayString,String languageString,String EffectiveStartDate){
         SearchResultBenefitLanguageWrapper detWrap = new SearchResultBenefitLanguageWrapper();
        System.debug('entering getBenefitLanguageResults');
        try{
         
         Map<String,String> benefitDisplayMap = new Map<String,String>();
         List<string> benefitDisplayWrapperList = new List<String>();
         List<string> benefitLanguageIndicatorWrapperList = new List<String>();
         System.debug('benefitDisplayString' +benefitDisplayString);
         System.debug('languageString' +languageString);
         if(benefitDisplayString != null && benefitDisplayString != '') {
            benefitDisplayWrapperList = (List<String>) JSON.deserialize(benefitDisplayString, List<String>.class);
        }
         if(languageString != null && languageString != '') {
            benefitLanguageIndicatorWrapperList = (List<String>) JSON.deserialize(languageString, List<String>.class);
        }
         System.debug('bundleId:'+ bundleId);
         System.debug('benefitCodes:'+ benefitCodes);
         System.debug('asOfDate:'+ asOfDate);
         System.debug('hippaServiceType:'+ hippaServiceType);
         System.debug('groupNumber:'+ groupNumber);
         System.debug('multiple:' +multiple);
         System.debug('benefitDisplayList:' +benefitDisplayWrapperList.size());
         if(benefitDisplayWrapperList != null) {
            for(String str: benefitDisplayWrapperList) {
                if(str.contains('!')) {
                   List<String> strSplit = str.split('!');
                   benefitDisplayMap.put(strSplit[0],strSplit[1]);
                }     
            }
        }
        System.debug('benefitDisplayMap' +benefitDisplayMap);
         list<string> benefitCodeLst = new list<string>();
         System.debug('benefitCodes' +benefitCodes);
         String benefitCodeIndiv = benefitCodes.removeEnd('_'); 
         benefitCodeLst.add(benefitCodeIndiv);
         System.debug('benefitCodeLst'+benefitCodeLst);
         ACETLGT_GetBenefitLanguageWebService getPlanBenefitservice = new ACETLGT_GetBenefitLanguageWebService();
         List<ACETLGT_PlanBenefitLanguageWrapper.BenefitWrapper> benefitWrapperlist = new List<ACETLGT_PlanBenefitLanguageWrapper.BenefitWrapper>();    
         benefitWrapperlist= getPlanBenefitservice.getPlanBenefitLanguageNew(bundleId,benefitCodeLst,asOfDate,groupNumber,hippaServiceType,multiple,benefitDisplayMap,benefitLanguageIndicatorWrapperList,EffectiveStartDate); 
        
         if(benefitWrapperlist != null) {
            detWrap =  new SearchResultBenefitLanguageWrapper();
            detWrap.resultBenefitLanguageWrapper = benefitWrapperlist;
        } 
              
        } 
        catch(Exception e) {
            System.debug('exception' +e);
        }
         return detWrap;

    } 
    @AuraEnabled
    public static SearchResultBenefitAccumulatorWrapper getBenefitAccumulatorResults(String surrogateKey, String bundleId, String enrollerSRK, String startDate, 
    String endDate, String groupNumber,String benefitCodes,String accumAsOf,String tierTypeCodeList,String membershipList,String tierTypeIdentifierList,String benefitRiderString){
        
         System.debug('surrogateKey:'+ surrogateKey);
         System.debug('bundleId:'+ bundleId);
         System.debug('enrollerSRK:'+ enrollerSRK);
         System.debug('startDate:'+ startDate);
         System.debug('endDate:'+ endDate);
         System.debug('groupNumber:'+ groupNumber);
         System.debug('accumAsOf:'+ accumAsOf); 
         System.debug('tierTypeCodeList:' +tierTypeCodeList);
         System.debug('membershipList:' +membershipList);
         System.debug('tierTypeIdentifierList:' +tierTypeIdentifierList);
         System.debug('benefitRiderString:'+benefitRiderString);
         System.debug('benefitCodes'+benefitCodes);
         List<string> benefitRiderList = new List<String>();
         if(benefitRiderString != null && benefitRiderString != '') {
            benefitRiderList.add(benefitRiderString);
																													  

        }
         System.debug('benefitRiderList' +benefitRiderList);
     
        ACETLGT_GetBenefitAccumsWebService getPlanBenefitService = new ACETLGT_GetBenefitAccumsWebService();
         List<ACETLGT_PlanBenefitLanguageWrapper.BenefitWrapper> benefitWrapperlist = new List<ACETLGT_PlanBenefitLanguageWrapper.BenefitWrapper>(); 
        ACETLGT_GetBAServiceWrapper getBAServiceWrapper = new ACETLGT_GetBAServiceWrapper();
        getBAServiceWrapper.BenefitBundleOptId =bundleId;
        getBAServiceWrapper.enrollerSRK = enrollerSRK;
        getBAServiceWrapper.surrogateKey =surrogateKey;
        getBAServiceWrapper.EffectiveStartDate =startDate;
        getBAServiceWrapper.EffectiveEndDate =  endDate;
        getBAServiceWrapper.BenefitCode = benefitCodes;
        getBAServiceWrapper.accumAsOf =accumAsOf;
        getBAServiceWrapper.GroupNumber =groupNumber;
        getBAServiceWrapper.SubscriptionServiceResponse =tierTypeCodeList;
        getBAServiceWrapper.MembershipDuration =membershipList;
        getBAServiceWrapper.SubscriptionResponse = tierTypeIdentifierList;
        getBAServiceWrapper.benefitRiderList = benefitRiderList;
         benefitWrapperlist = getPlanBenefitService.getAccumulatorBenefits(getBAServiceWrapper);
        
        system.debug('benefitWrapperlist'+benefitWrapperlist);
       SearchResultBenefitAccumulatorWrapper detWrap = new SearchResultBenefitAccumulatorWrapper();
        if(benefitWrapperlist != null) {
            detWrap =  new SearchResultBenefitAccumulatorWrapper();
            detWrap.resultBenefitAccumulatorWrapper = benefitWrapperlist;
            
        } 
            return detWrap;

    } 
    
    @AuraEnabled
    public static SearchBenefitsByPhraseWrapper searchBenefitsByPhrase(String benefitPlanId,String searchedPhrase,String dateOfService){
        system.debug('ACETLGT_PlanBenefitController searchBenefitsByPhrase method');
        system.debug('benefitPlanId::'+benefitPlanId+'searchedPhrase::'+'dateOfService::'+dateOfService);
        SearchBenefitsByPhraseWrapper resultWrapper = new SearchBenefitsByPhraseWrapper();
        ACETLGT_SearchBenefitsService sbs = new ACETLGT_SearchBenefitsService();
        ACETWSCalloutResult calloutResult = sbs.searchBenefits(benefitPlanId, searchedPhrase, dateOfService, sessionId);
        if (CalloutResult.Success){   
                resultWrapper.benefits = (List<ACETLGT_SearchBenefitsResponseJSON.Benefit>)CalloutResult.Response;
         } 
       system.debug('resultWrapper'+resultWrapper);
        return resultWrapper;
    }
    
    @AuraEnabled
    public static SearchBenefitsBenefitSectionWrapper getBenefitSection(String benefitId){
        SearchBenefitsBenefitSectionWrapper responseWrapper = new SearchBenefitsBenefitSectionWrapper();
        ACETLGT_GetBenefitSectionService benefitService = new ACETLGT_GetBenefitSectionService();
        ACETWSCalloutResult calloutResult = benefitService.searchBenefitsSection(benefitId, sessionId);
         if (CalloutResult.Success){   
                responseWrapper.benefits = (List<ACETLGT_GetBenefitSectionResponseJSON.Benefit>)CalloutResult.Response;
         }
        return responseWrapper;
    }
    
  
    
}