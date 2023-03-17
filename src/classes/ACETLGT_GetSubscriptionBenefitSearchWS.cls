public class ACETLGT_GetSubscriptionBenefitSearchWS extends ACETWebService {

    public ACETGroupPlanBenefitLEXWrapper groupPlanWrapper;
    public set <String> benefitCodeSet {get;set;}
    private Map <String, String> EligibilityCodeVsStatusMap;
    public Map <String, String> primaryIndicatorVsDescMap;
    public static final String TIME_PLAN_QUALIFIER = 'Plan Year';
    public static final String TIME_CALENDAR_QUALIFIER = 'Calendar Year';
    public Map<String, String> PlanTypeCodeMap {get; set;}
    public Map<String,String> gatedPCPMap {get; set;}
    public Map<String,String> CoverageTypeMap {get; set;} 
    public override void getEndpoint() {
        GetEndpointDetail('getSubscriptionBenefitSearch');
    }
    public ACETLGT_GetSubscriptionBenefitSearchWS() {
        super('Stargate');
    }
    public void getRequestBody(String surrogateKey, String bundleId, String enrollerSRK, String startDate, String endDate, String coverageTypes, String groupNumber, String accumsDate, String accumAsOf,String customerPurchaseId) {
       String reqParams ;
        if(customerPurchaseId != null){
       reqParams = '~"getSubscriptionServiceBenefitRequest":~"benefitBundleOptionId":"{0}","subscriberIdentifier":~"id":"{1}","type":"SRK"},"enrolleeIdentifier":~"id":"{2}","type":"SRK"},"effectiveStartDate":"{3}","effectiveEndDate":"{4}","groupNumber":"{5}", "accumulatorAsOfDate":"", "coverageTypes":[~"coverageType":""}], "suppressByHipaaServiceType" :"true","customerPurchaseID":"{6}"}}';
        }else{
       reqParams = '~"getSubscriptionServiceBenefitRequest":~"benefitBundleOptionId":"{0}","subscriberIdentifier":~"id":"{1}","type":"SRK"},"enrolleeIdentifier":~"id":"{2}","type":"SRK"},"effectiveStartDate":"{3}","effectiveEndDate":"{4}","groupNumber":"{5}", "accumulatorAsOfDate":"", "coverageTypes":[~"coverageType":""}], "suppressByHipaaServiceType" :"true"}}';
        }
        RequestBody = String.format(reqParams, new List<String>{bundleId,  surrogateKey, enrollerSRK, 
        ACETWebServicehelper.formatToYYYYMMDD(startDate), ACETWebServicehelper.formatToYYYYMMDD(endDate), 
        groupNumber,customerPurchaseId}).replaceAll('~', '{');
        System.debug('getRequestBody(): ' + RequestBody);
    }
    private void GetRequestBodyParam(String bundleId, String enrollerSRK, String subscriberSRK, String startDate, String endDate, String CoverageTypes, String groupNumber,string accumAsOf,String customerPurchaseId)
    {
        if(customerPurchaseId != null && customerPurchaseId != ''){
        List<String> SearchParameters = new String[] {(bundleId != null)?bundleId:'',enrollerSRK, subscriberSRK,ACETWebServicehelper.formatToYYYYMMDD(startDate),ACETWebServicehelper.formatToYYYYMMDD(endDate),CoverageTypes,groupNumber,accumAsOf,customerPurchaseId};
        RequestBody = GetRequestBody('ACETLGT_GetSubscriptionRedesignRequest1',SearchParameters);            
        }else{
           List<String> SearchParameters = new String[] {(bundleId != null)?bundleId:'',enrollerSRK, subscriberSRK,ACETWebServicehelper.formatToYYYYMMDD(startDate),ACETWebServicehelper.formatToYYYYMMDD(endDate),CoverageTypes,groupNumber,accumAsOf};
        RequestBody = GetRequestBody('ACETLGT_GetSubscriptionRedesignRequest',SearchParameters);     
        }
        
       
    }   
    

    
    //public ACETWSCalloutResult getFamilyMembers(String memberId, ACETMemberSearchCoveragesResult memberDetail){
    public ACETWSCalloutResult init(String surrogateKey, String bundleId, String enrollerSRK, String startDate,
        String endDate, String coverageTypes, String groupNumber, String accumsDate, String accumAsOf, Boolean isActive, Boolean isTermed,String customerPurchaseId) {

        ACETWSCalloutResult calloutResult = new ACETWSCalloutResult();

        try {

            getEndpoint();
            GetRequestBody(surrogateKey, bundleId, enrollerSRK, startDate, endDate, coverageTypes, groupNumber,accumsDate, accumAsOf,customerPurchaseId);

            HttpResponse response = Send(OAuthConfig);

            if(response!=null){ // response!=null
                //response.SetStatusCode(500);
                calloutResult.statusCode=response.getStatusCode();
                System.debug('getStatusCode(): ' + response.getStatusCode());    
                 System.debug('getBody(): ' + response.getBody());    
                if(response.getStatusCode() == 200 && response.getBody() != null){ 
                     
                        //Lahiru : Redesign with the wrapper
                        calloutResult.Success = true;
                        calloutResult.Message = '';
                        calloutResult.Response = parseSuccessAdapterResponse(ReplaceKeywords(response.getBody()), isActive, isTermed); //pg.getContent().toString()
                        calloutResult.responseBody = ReplaceKeywords(response.getBody()); // response.getBody()
        }else{         
                    calloutResult.Success = false;                
                    calloutResult.Response = new ACETGroupPlanBenefitLEXWrapper();
                }
            } else{
                calloutResult.Success = false;
                calloutResult.Message = 'Web Service or External System is temporarily unavailable.';
                calloutResult.statusCode = 999;
            }           
        } catch (Exception e) {
            System.debug('ACETGetSubscriptionBenefitSearchWS: init() - ' + e.getLineNumber() + ' ' + e.getMessage());
            calloutResult.Success = false;
            calloutResult.Message = 'Web Service or External System is temporarily unavailable.';
            calloutResult.statusCode = 999;

        }
        return calloutResult;
    }
    public ACETWSCalloutResult getSubscriptionBenefitSearch(String surrogateKey, String bundleId, String enrollerSRK, String startDate,
        String endDate, String coverageTypes, String groupNumber, String accumAsOf,String situSState,String customerPurchaseId) {
            return getSubBenefitSearch(surrogateKey, bundleId, enrollerSRK,  startDate,
         endDate,  coverageTypes,  groupNumber,  accumAsOf, situSState,null,customerPurchaseId);
        }
    public ACETWSCalloutResult getSubBenefitSearch(String surrogateKey, String bundleId, String enrollerSRK, String startDate,
        String endDate, String coverageTypes, String groupNumber, String accumAsOf,String situSState,String planId,String customerPurchaseId) {

        ACETWSCalloutResult calloutResult = new ACETWSCalloutResult();

        try {

            getEndpoint();
            GetRequestBodyParam(surrogateKey, bundleId, enrollerSRK, startDate, endDate, coverageTypes, groupNumber,accumAsOf,customerPurchaseId);
            HttpResponse response = Send(OAuthConfig);

            if(response!=null){ // response!=null
                calloutResult.statusCode=response.getStatusCode();
                System.debug('getStatusCode(): ' + response.getStatusCode());    
                 System.debug('getBody(): ' + response.getBody());    
                if(response.getStatusCode() == 200){ // response.getStatusCode() == 200
                    if(response.getBody() != null){ // response.getBody() != null

            // String strstaticfilename = 'getSubscriptionServiceBenefitResponse';
            // StaticResource sr = [SELECT Id, NamespacePrefix, SystemModstamp FROM StaticResource
            //     WHERE Name = : strstaticfilename LIMIT 1
            // ];
            // String prefix = sr.NamespacePrefix;

            // if (String.isEmpty(prefix)) {
            //     prefix = '';
            // } else {
            //     prefix += '__';
            // }

            // String srPath = '/resource/' + sr.SystemModstamp.getTime() + '/' + prefix + strstaticfilename;
            // PageReference pg = new PageReference(srPath);

            //Lahiru : Redesign with the wrapper
            calloutResult.Success = true;
            calloutResult.Message = '';
            calloutResult.Response = processResponse(ReplaceKeywords(response.getBody()),situSState,planId); //pg.getContent().toString()
            calloutResult.responseBody = ReplaceKeywords(response.getBody()); // response.getBody()

            }

                }else if(response.getStatusCode() == 500){         
                    calloutResult.Success = true;                
                    calloutResult.Response = new ACETGroupPlanBenefitLEXWrapper();
                }
            } else{
                calloutResult.Success = false;
                calloutResult.Message = 'Web Service or External System is temporarily unavailable.';
                calloutResult.statusCode = 999;
            }           
        } catch (Exception e) {
            System.debug('ACETGetSubscriptionBenefitSearchWS: init() - ' + e.getLineNumber() + ' ' + e.getMessage());
            calloutResult.Success = false;
            calloutResult.Message = 'Web Service or External System is temporarily unavailable.';
            calloutResult.statusCode = 999;

        }
        return calloutResult;
    }

    public ACETGroupPlanBenefitLEXWrapper parseSuccessAdapterResponse(String ResponseBody, Boolean isActive, Boolean isTermed) {
        
        system.debug('isActive:::'+isActive + ' - ' +isTermed);
        
        groupPlanWrapper = new ACETGroupPlanBenefitLEXWrapper();
        groupPlanWrapper.benefitRedesignWrapperList = new Map <String, Map <String, List <ACETGroupPlanBenefitLEXWrapper.BenefitSubSection>>> ();
        
        ACETLGT_GetSubscriptionRedesignJSON2APEX.memberGroupContractPlanOption benefitSubDetails;
        ACETLGT_GetSubscriptionRedesignJSON2APEX.memberGroup benefitGroupDetails;
        ACETLGT_GetSubscriptionRedesignJSON2APEX.planTier pTier;
        

        ACETLGT_GetSubscriptionRedesignJSON2APEX ACETEGDJSON2Apex = (ACETLGT_GetSubscriptionRedesignJSON2APEX) JSON.deserialize(ResponseBody, ACETLGT_GetSubscriptionRedesignJSON2APEX.class);

        System.debug('ACETEGDJSON2Apex:::' + ACETEGDJSON2Apex);

        benefitSubDetails = ACETEGDJSON2Apex.getSubscriptionServiceBenefitResponse.serviceBenefit.memberGroupContractPlanOption;
        benefitGroupDetails = ACETEGDJSON2Apex.getSubscriptionServiceBenefitResponse.serviceBenefit.memberGroup;
        groupPlanWrapper.mapBenefitPlanTierValues = new Map <String, List <String>> ();


        if (benefitSubDetails.benefitPlan != null && !benefitSubDetails.benefitPlan.isEmpty()) {
            for (ACETLGT_GetSubscriptionRedesignJSON2APEX.benefitPlan benefitSectionInfo: benefitSubDetails.benefitPlan) {
                if (benefitSectionInfo.riderOnlyFlag == 'false') {

                    if (benefitSectionInfo.planTier != null && !benefitSectionInfo.planTier.isEmpty()) {
                        for (ACETLGT_GetSubscriptionRedesignJSON2APEX.planTier benefitTier: benefitSectionInfo.planTier) {
                            
                            if (benefitTier.tierTypeCode == 'INN') {
                                // IN NETWORK
                                groupPlanWrapper.IIN_PLAN_MIN = groupPlanWrapper.validateValue(benefitTier.primaryIndividualDeductibleYTD);
                                groupPlanWrapper.IIN_PLAN_MAX = groupPlanWrapper.validateValue(benefitTier.primaryIndividualDeductibleMaximum).split('\\.')[0];
                                groupPlanWrapper.IIN_OOP_MIN = groupPlanWrapper.validateValue(benefitTier.primaryIndividualOOPYTD);
                                groupPlanWrapper.IIN_OOP_MAX = groupPlanWrapper.validateValue(benefitTier.primaryIndividualOOPMaximum).split('\\.')[0];
                                groupPlanWrapper.FIN_PLAN_MIN = groupPlanWrapper.validateValue(benefitTier.primaryFamilyDeductibleYTD);
                                groupPlanWrapper.FIN_PLAN_MAX = groupPlanWrapper.validateValue(benefitTier.primaryFamilyDeductibleMaximum).split('\\.')[0];
                                groupPlanWrapper.FIN_OOP_MIN = groupPlanWrapper.validateValue(benefitTier.primaryFamilyOOPYTD);
                                groupPlanWrapper.FIN_OOP_MAX = groupPlanWrapper.validateValue(benefitTier.primaryFamilyOOPMaximum).split('\\.')[0];
                                groupPlanWrapper.IIN_Primary_Accum_Deduct = string.isNotBlank(benefitTier.primaryFamilyAccumulationTypeDescriptionDeductible) ? (benefitTier.primaryFamilyAccumulationTypeDescriptionDeductible) : 'N/A';
                                groupPlanWrapper.IIN_Primary_Accum_OOP = string.isNotBlank(benefitTier.primaryFamilyAccumulationTypeDescriptionOOP) ? (benefitTier.primaryFamilyAccumulationTypeDescriptionOOP) : 'N/A';
                                groupPlanWrapper.FIN_Primary_Accum_Deduct = string.isNotBlank(benefitTier.primaryFamilyAccumulationTypeDescriptionDeductible) ? (benefitTier.primaryFamilyAccumulationTypeDescriptionDeductible) : 'N/A';
                                groupPlanWrapper.FIN_Primary_Accum_OOP = string.isNotBlank(benefitTier.primaryFamilyAccumulationTypeDescriptionOOP) ? (benefitTier.primaryFamilyAccumulationTypeDescriptionOOP) : 'N/A';
                            } else if (benefitTier.tierTypeCode == 'OON') {
                                // OUT NETWORK
                                groupPlanWrapper.ION_PLAN_MIN = groupPlanWrapper.validateValue(benefitTier.primaryIndividualDeductibleYTD);
                                groupPlanWrapper.ION_PLAN_MAX = groupPlanWrapper.validateValue(benefitTier.primaryIndividualDeductibleMaximum).split('\\.')[0];
                                groupPlanWrapper.ION_OOP_MIN = groupPlanWrapper.validateValue(benefitTier.primaryIndividualOOPYTD);
                                groupPlanWrapper.ION_OOP_MAX = groupPlanWrapper.validateValue(benefitTier.primaryIndividualOOPMaximum).split('\\.')[0];
                                groupPlanWrapper.FON_PLAN_MIN = groupPlanWrapper.validateValue(benefitTier.primaryFamilyDeductibleYTD);
                                groupPlanWrapper.FON_PLAN_MAX = groupPlanWrapper.validateValue(benefitTier.primaryFamilyDeductibleMaximum).split('\\.')[0];
                                groupPlanWrapper.FON_OOP_MIN = groupPlanWrapper.validateValue(benefitTier.primaryFamilyOOPYTD);
                                groupPlanWrapper.FON_OOP_MAX = groupPlanWrapper.validateValue(benefitTier.primaryFamilyOOPMaximum).split('\\.')[0];
                                groupPlanWrapper.ION_Primary_Accum_Deduct = string.isNotBlank(benefitTier.primaryFamilyAccumulationTypeDescriptionDeductible) ? (benefitTier.primaryFamilyAccumulationTypeDescriptionDeductible) : 'N/A';
                                groupPlanWrapper.ION_Primary_Accum_OOP = string.isNotBlank(benefitTier.primaryFamilyAccumulationTypeDescriptionOOP) ? (benefitTier.primaryFamilyAccumulationTypeDescriptionOOP) : 'N/A';
                                groupPlanWrapper.FON_Primary_Accum_Deduct = string.isNotBlank(benefitTier.primaryFamilyAccumulationTypeDescriptionDeductible) ? (benefitTier.primaryFamilyAccumulationTypeDescriptionDeductible) : 'N/A';
                                groupPlanWrapper.FON_Primary_Accum_OOP = string.isNotBlank(benefitTier.primaryFamilyAccumulationTypeDescriptionOOP) ? (benefitTier.primaryFamilyAccumulationTypeDescriptionOOP) : 'N/A';
                    
                            }
                        }
                    }
                    if (benefitSectionInfo.membership != NULL) {
                        ACETLGT_GetSubscriptionRedesignJSON2APEX.membership memObj = benefitSectionInfo.membership[0];
                        System.debug('member flow');
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
                            
                            if (isActive) {                                
                                String firstDate = '01/01/'+ System.today().year();
                                String lastDate =  '12/31/'+System.today().year();
                                groupPlanWrapper.PLAN_CALENDAR_YEAR = firstDate + '-' + lastDate;
                                //groupPlanWrapper.AS_OF_DATE = System.today().format();
                            } else if (isTermed) {
                                groupPlanWrapper.PLAN_CALENDAR_YEAR = '01/01/'+ memObj.coverageEndDate.split('-')[0] + ' - ' + '12/31/'+ memObj.coverageEndDate.split('-')[0];                             
                               
                            } else {
                                //groupPlanWrapper.AS_OF_DATE = '';
                                 groupPlanWrapper.PLAN_CALENDAR_YEAR = '01/01/'+ memObj.coverageStartDate.split('-')[0] + ' - ' + '12/31/'+ memObj.coverageStartDate.split('-')[0];
                            }
                            
                            system.debug('groupPlanWrapper.PLAN_CALENDAR_YEAR 2:::'+groupPlanWrapper.PLAN_CALENDAR_YEAR);
                        }
                        
                        //Update As of Dates
                        if (isActive){
                            groupPlanWrapper.AS_OF_DATE = ACETUtility.format(System.today());
                        }else if (isTermed){
                            groupPlanWrapper.AS_OF_DATE = String.valueof(ACETUtility.format(Date.valueof(memObj.coverageEndDate)));
                        }else{
                            groupPlanWrapper.AS_OF_DATE = String.valueof(ACETUtility.format(Date.valueof(memObj.coverageStartDate)));
                        }
                        
                        system.debug('groupPlanWrapper.AS_OF_DATE:::'+groupPlanWrapper.AS_OF_DATE);
                    }

                }
            }
            groupPlanWrapper.initProgressBar();
        }
        return groupPlanWrapper;
    }
     public ACETGroupPlanBenefitLEXWrapper processResponse(String ResponseBody,String SitusState,String planId) {
        
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
        ACETLGT_GetSubscriptionRedesignJSON2APEX.memberGroupContractPlanOption benefitSubDetails;
        ACETLGT_GetSubscriptionRedesignJSON2APEX.memberGroup benefitGroupDetails;
        ACETLGT_GetSubscriptionRedesignJSON2APEX.planTier pTier;
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
        ACETLGT_GetSubscriptionRedesignJSON2APEX ACETEGDJSON2Apex = (ACETLGT_GetSubscriptionRedesignJSON2APEX) JSON.deserialize(ResponseBody, ACETLGT_GetSubscriptionRedesignJSON2APEX.class);
        System.debug('ACETEGDJSON2Apex:::' + ACETEGDJSON2Apex);
        benefitSubDetails = ACETEGDJSON2Apex.getSubscriptionServiceBenefitResponse.serviceBenefit.memberGroupContractPlanOption;
        benefitGroupDetails = ACETEGDJSON2Apex.getSubscriptionServiceBenefitResponse.serviceBenefit.memberGroup;
        groupPlanWrapper.mapBenefitPlanTierValues = new Map <String, List <String>> ();
        if (benefitSubDetails.benefitPlan != null && !benefitSubDetails.benefitPlan.isEmpty()) {
            for (ACETLGT_GetSubscriptionRedesignJSON2APEX.benefitPlan benefitSectionInfo: benefitSubDetails.benefitPlan) {
                if(benefitSectionInfo.benefitPlanId == planId ){
                    groupPlanWrapper.qualityProviderTierRuleID = benefitSectionInfo.qualityProviderTierRuleID;
                }
               

                if (benefitSectionInfo.riderOnlyFlag == 'false') {
                      groupPlanWrapper.eHBIndicator = String.isNotBlank(benefitSectionInfo.eHBIndicator)? benefitSectionInfo.eHBIndicator : '';
                    if (benefitSectionInfo.planTier != null && !benefitSectionInfo.planTier.isEmpty()) {
                        for (ACETLGT_GetSubscriptionRedesignJSON2APEX.planTier benefitTier: benefitSectionInfo.planTier) {                        
                            if (benefitTier.tierTypeCode == 'INN') {                            
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
                                groupPlanWrapper.tierDescMap.put(benefitTier.tierIdentifier,benefitTier.tierDescription);
                                System.debug('groupPlanWrapper.tierDescMap' +groupPlanWrapper.tierDescMap);
                                if(String.IsNotBlank(benefitSectionInfo.benefitServiceArea)){
                                   groupPlanWrapper.sAreaType.put(benefitTier.tierIdentifier,benefitTier.serviceAreaType);
                                }  else {
                                   groupPlanWrapper.sAreaType.put(benefitTier.tierIdentifier,'Service Area could not be determined');
                                } 
                                System.debug('groupPlanWrapper.sAreaType'+groupPlanWrapper.sAreaType);
                            }
                            if(String.isNotBlank(benefitSectionInfo.benefitPlanId) && String.isNotBlank(benefitTier.tierIdentifier)) {
                               groupPlanWrapper.tierTypeCode.add(benefitSectionInfo.benefitPlanId+'-'+benefitTier.tierIdentifier);
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
                         if(String.isNotBlank(benefitSectionInfo.carrierBusinessId)){
                           groupPlanWrapper.carId.add(benefitSectionInfo.carrierBusinessId);
                           system.debug('carrierIDWS:::'+benefitSectionInfo.carrierBusinessId);
                        }
                         if(String.isNotBlank(benefitSectionInfo.benefitServiceArea)) {
                           groupPlanWrapper.benefitServiceSet.add(benefitSectionInfo.benefitServiceArea);
                         }
                         System.debug('groupPlanWrapper.benefitServiceSet' +groupPlanWrapper.benefitServiceSet);
                         for(ACETLGT_GetSubscriptionRedesignJSON2APEX.planTier planTier:benefitSectionInfo.planTier) {
                          if(planTier.network != null && !planTier.network.isEmpty()) {
                           for(ACETLGT_GetSubscriptionRedesignJSON2APEX.network ntwrk: planTier.network) {
                               if(String.isNotBlank(planTier.tierIdentifier)) {
                                   if(groupPlanWrapper.networkMap != null && !groupPlanWrapper.networkMap.isEmpty() && groupPlanWrapper.networkMap.containsKey(planTier.tierIdentifier)){
                                    groupPlanWrapper.networkMap.get(planTier.tierIdentifier).add(ntwrk.id+'_'+ntwrk.description);    
                                   } else{
                                   groupPlanWrapper.networkMap.put(planTier.tierIdentifier,new List<String>{ntwrk.id+'_'+ntwrk.description});    
                                 }          
                             }
                          }
                        }
                      }
                    }
                    System.debug('groupPlanWrapper.networkMap' +groupPlanWrapper.networkMap);
                    
             }
          }
        }
        planBenefitSearchMapping(benefitSubDetails, benefitGroupDetails);
        planBenefitDetailsMapping(benefitSubDetails,SitusState);
        coPayMapping(benefitSubDetails);
        IndivFamilyAccumulatorMapping(benefitSubDetails);

        //System.debug('GroupPlanWrapper::::'+groupPlanWrapper);
        return groupPlanWrapper;
    }
    private void planBenefitSearchMapping(ACETLGT_GetSubscriptionRedesignJSON2APEX.memberGroupContractPlanOption benefitSubscriptionDetails,
                                      ACETLGT_GetSubscriptionRedesignJSON2APEX.memberGroup benefitGroupDetails) {
        getPlanTypeCode();
        getGatedPCPCode();
        getCoverageTypeDescripMap();
        ACETGroupPlanBenefitLEXWrapper.PlanInformationWrapper getPlanInfo = new  ACETGroupPlanBenefitLEXWrapper.PlanInformationWrapper();
        if(benefitSubscriptionDetails != null && benefitSubscriptionDetails.benefitPlan!=null && !benefitSubscriptionDetails.benefitPlan.isEmpty()){
         for(ACETLGT_GetSubscriptionRedesignJSON2APEX.benefitPlan benefitSectionInfo: benefitSubscriptionDetails.benefitPlan) {
            if(String.isNotBlank(benefitSectionInfo.riderOnlyFlag) && benefitSectionInfo.riderOnlyFlag == 'true')  {
                                                     
                 // Below changes to display rider section in both group plan and plan benefit call topics
                 ACETGroupPlanBenefitLEXWrapper.BenefitWrapper groupPlanBenefitRiderInfo = new  ACETGroupPlanBenefitLEXWrapper.BenefitWrapper ();
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

               //getPlanInfo.benefitBundleOptionId = (strBenefitBundleOptionId !=null)?strBenefitBundleOptionId:'';
                getPlanInfo.groupName = (benefitGroupDetails != null && benefitGroupDetails.groupName != null)?benefitGroupDetails.groupName:'';
                getPlanInfo.groupId = (benefitGroupDetails != null && benefitGroupDetails.groupNumber != null)?benefitGroupDetails.groupNumber:'';
                getPlanInfo.legalSubsidiary = (benefitSectionInfo.legalEntityName != null)?benefitSectionInfo.legalEntityName:'';
                getPlanInfo.planMetallicLevel = (benefitSubscriptionDetails.planMetallicLevel != null)?benefitSubscriptionDetails.planMetallicLevel:'';
               /** if(benefitSectionInfo.legalEntityName != null && benefitSectionInfo.legalEntityName != '') {
                    if(benefitSectionInfo.legalEntityName.contains('Oxford Health Plans')) {
                        getPlanInfo.legalSubsidiary = 'OHP';
                    }
                    else if(benefitSectionInfo.legalEntityName.contains('Oxford Health Insurance')) {
                         getPlanInfo.legalSubsidiary = 'OHI';
                    }
                }*/
                
                //Start of membership snippet
                List<ACETLGT_GetSubscriptionRedesignJSON2APEX.membership> membershipLst = new List<ACETLGT_GetSubscriptionRedesignJSON2APEX.membership>();  
            
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
                List<ACETGroupPlanBenefitLEXWrapper.networkScheduleIds> networkSchduleToAdd = new List<ACETGroupPlanBenefitLEXWrapper.networkScheduleIds>();  
                List<ACETLGT_GetSubscriptionRedesignJSON2APEX.networkScheduleIds> networkSchduleLst = new List<ACETLGT_GetSubscriptionRedesignJSON2APEX.networkScheduleIds>();  
                
                if(benefitSectionInfo.networkScheduleIds != null && !benefitSectionInfo.networkScheduleIds.isEmpty()) {
                    networkSchduleLst = benefitSectionInfo.networkScheduleIds;
                    ACETGroupPlanBenefitLEXWrapper.networkScheduleIds networkSchObj = new  ACETGroupPlanBenefitLEXWrapper.networkScheduleIds();
                    for(ACETLGT_GetSubscriptionRedesignJSON2APEX.networkScheduleIds networkObj: networkSchduleLst){
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
    private void planBenefitDetailsMapping(ACETLGT_GetSubscriptionRedesignJSON2APEX.memberGroupContractPlanOption benefitSubscriptionDetails,String SitusState) {
        
        if(benefitSubscriptionDetails != null) {
          if(benefitSubscriptionDetails.benefitPlan != null && !benefitSubscriptionDetails.benefitPlan.isEmpty()){
            for(ACETLGT_GetSubscriptionRedesignJSON2APEX.benefitPlan benefitDetails: benefitSubscriptionDetails.benefitPlan) {
                if(benefitDetails != null) {
                    if(benefitDetails.benefitCode != null && !benefitDetails.benefitCode.isEmpty()) {
                        for(ACETLGT_GetSubscriptionRedesignJSON2APEX.benefitCode benefitCode: benefitDetails.benefitCode) {
                        
                        //System.debug('Entering:::::'+benefitCode.benefitName);
                        String benefitKey = getValidString(benefitCode.BenefitCode)+' - '+getValidString(benefitCode.benefitName);
                        if(benefitCode.variableCoverage != null && benefitCode.variableCoverage == 'true'){
                            groupPlanWrapper.varriableCoverageMap.put(benefitKey,benefitCode.variableCoverage);
                        }else{
                            groupPlanWrapper.varriableCoverageMap.put(benefitKey,'');
                        } 
                        if(benefitCode.benefitCode != null && benefitCode.benefitDisplay != null && benefitCode.benefitCode != '' && benefitCode.benefitDisplay != ''){
                            groupPlanWrapper.benefitDisplayMap.put(benefitCode.benefitCode,benefitCode.benefitDisplay);
                        }
                        groupPlanWrapper.benefitRedesignWrapperList.put(benefitKey, new Map<String, List<ACETGroupPlanBenefitLEXWrapper.BenefitSubSection>>());
                        benefitCodeSet.add(benefitCode.benefitCode);
                        
                        if(String.isNotBlank(benefitKey)) {
                            //This map is used to display the benefit name on the benefit category dropdown
                            if(String.isNotBlank(benefitCode.BenefitCode) && String.isNotBlank(benefitCode.benefitName) && String.isNotBlank(benefitCode.benefitDisplay)) {
                                groupPlanWrapper.benefitCodeKeyMap.put(benefitCode.benefitDisplay, benefitKey);
                            }
                        }
                        
                       if(benefitCode.existsOnRiderPlan != null) {
                            groupPlanWrapper.benefitCodeRiderPlanmap.put(benefitCode.BenefitCode, benefitCode.existsOnRiderPlan);
                            
                        } 
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
    private void coPayMapping(ACETLGT_GetSubscriptionRedesignJSON2APEX.memberGroupContractPlanOption benefitcoPayDetails) {
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
         for(ACETLGT_GetSubscriptionRedesignJSON2APEX.benefitPlan benefitSectionInfo: benefitcoPayDetails.benefitPlan) {
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
                    for(ACETLGT_GetSubscriptionRedesignJSON2APEX.planTier planTierInfo: benefitSectionInfo.planTier) {
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
   private void IndivFamilyAccumulatorMapping(ACETLGT_GetSubscriptionRedesignJSON2APEX.memberGroupContractPlanOption benefitSubscriptionDetails) {
        
        Integer coInsuranceTotal = 100;
        ACETGroupPlanBenefitLEXWrapper.AccumulatorP Accumulator;
        List<String> tierDescList = new List<String>();
        if(benefitSubscriptionDetails != null) {
        if(benefitSubscriptionDetails.benefitPlan !=null && !benefitSubscriptionDetails.benefitPlan.isEmpty()){
        for(ACETLGT_GetSubscriptionRedesignJSON2APEX.benefitPlan AccumsInfo: benefitSubscriptionDetails.benefitPlan) {
        if(String.isNotBlank(AccumsInfo.riderOnlyFlag)) {
        if(AccumsInfo.riderOnlyFlag == 'false') {
         if(AccumsInfo.planTier!= null && !AccumsInfo.planTier.isEmpty()){
            for(ACETLGT_GetSubscriptionRedesignJSON2APEX.planTier  planTier: AccumsInfo.planTier) {
            
                Accumulator = new ACETGroupPlanBenefitLEXWrapper.AccumulatorP();
                Accumulator.Section = 'Individual';
                if(String.isNotBlank(planTier.tierTypeCode)) {
                Accumulator.TypeCode = planTier.tierTypeCode == 'INN' ? 'INN' : 'OON';
                }
                Accumulator.MaxDeductible = String.isNotBlank(planTier.primaryIndividualDeductibleMaximum) ? (planTier.primaryIndividualDeductibleMaximum.split('\\.')[0]) : 'N/A';
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
                
                Accumulator.MaxOOP = String.isNotBlank(planTier.primaryIndividualOOPMaximum) ? (planTier.primaryIndividualOOPMaximum.split('\\.')[0]) : 'N/A';
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
                Accumulator = new ACETGroupPlanBenefitLEXWrapper.AccumulatorP();
                Accumulator.Section = 'Family';
                if(String.isNotBlank(planTier.tierTypeCode)) {
                Accumulator.TypeCode = planTier.tierTypeCode == 'INN' ? 'INN' : 'OON';
                }
                Accumulator.MaxDeductible = String.isNotBlank(planTier.primaryFamilyDeductibleMaximum) ? (planTier.primaryFamilyDeductibleMaximum.split('\\.')[0]) : 'N/A';
               
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
                Accumulator.MaxOOP = String.isNotBlank(planTier.primaryFamilyOOPMaximum) ? (planTier.primaryFamilyOOPMaximum.split('\\.')[0]) : 'N/A';
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