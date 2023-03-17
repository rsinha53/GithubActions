public with sharing class ACETPlanBenefitDetailRedesignControllerr {
    public List<PolicyOverviewWrapper> policies {get;set;}
    public ACETCallTopicsDataWrapper wrapper {get;set;}
    public String planId;
    public String MemberId {get; set;}
    public String PlanName;
    public String ProductId;
    public String PlanType {get; set;}
    public String Accumulator; 
    public String Gated;
    public String PCP;
    public string Network {get;set;}
    public String groupNo {get; set;}
    public list<string> networklist {get;set;}
    public String policyNumber {get;set;}
    public String accumsDateSearch {get; set;}
    Public String benefitEnddate{get;set;}
    Public String benefitEffectivedate{get;set;}
    public String fundingArrang{get;set;}
    
    //Added by vinaybabu
    public string covrgLevel {get;set;}
    public Interaction__c objCase  {get; set;}
    Public String customerPurchaseid {get;set;}
    public String bundleOptionId {get; set;}                
    public String CoverageType {get; set;}
    public String EffectiveDate {get; set;}
    public String EndDate {get; set;}    
    public String SRKID {get; set;}
    public String SubscriberSRKID {get; set;}
    public String GroupID {get; set;}
    public String serializeWrapper {get; set;}
    public string accumAsOf {get;set;}
    public Boolean showCirrusBenefit {get;set;}
    public ACETHighlightsPanelAdditionalInfo AdditionalInfo {get;set;}
    
    //Parameter to store error messages
    public Set<String> benefitErrorMsgs {get;set;}
    
    public ACETNimbusGetSSBAPI ACETGetSubscriptionWS;
    public ACETNimbusGetSSBAPI ACETGetSubscriptionWS1;
    
    public ACETGroupPlanBenefitWrapper ACETPlanBenefitSearchResults {get; set;}
    public String ACETSubscriptionServices {get; set;}
   // public Map<String,String> benefitPlanMapping {get; set;}
    public ACETAccumAsOfWrapper asOfDateFields {get;set;}
    
    //Rider Section
    public List<ACETGroupPlanBenefitWrapper.PlanBenefitRiderWrapper> memberPlanBenefitRiderList {get; set;}
    public List<ACETGroupPlanBenefitWrapper.BenefitWrapper> memberPlanBenefitList {get; set;}
    public List<ACETGroupPlanBenefitWrapper.PlanInformationWrapper> policiesovrView {get;set;}
    public String SitusState{get;set;}
 
    public ACETPlanBenefitDetailRedesignControllerr (){     
        objCase = new Interaction__c ();
        showTableLevelErrr = 'onload';
        planId = ApexPages.currentPage().getParameters().get('PI');
        PlanName = ApexPages.currentPage().getParameters().get('PName');  
        ProductId = ApexPages.currentPage().getParameters().get('PId');  
        policyNumber = ApexPages.currentPage().getParameters().get('PN');
        PlanType = ApexPages.currentPage().getParameters().get('PT');
        Accumulator = ApexPages.currentPage().getParameters().get('Accum');
        Gated = ApexPages.currentPage().getParameters().get('Gat');
        PCP = ApexPages.currentPage().getParameters().get('PCP');
        Network = ApexPages.currentPage().getParameters().get('Net');
        groupNo = ApexPages.currentPage().getParameters().get('groupNumber');
        bundleOptionId = apexpages.currentpage().getparameters().get('bundleOptionId');       
        CoverageType = apexpages.currentpage().getparameters().get('CoverageType');
        EffectiveDate = apexpages.currentpage().getparameters().get('EffectiveDate');
        EndDate = apexpages.currentpage().getparameters().get('EndDate');
        SRKID = apexpages.currentpage().getparameters().get('SRK');
        fundingArrang = apexpages.currentpage().getparameters().get('fundingArrang');
        benefitEnddate = apexpages.currentpage().getparameters().get('benefitEnddate'); //US2962032
        benefitEffectivedate = apexpages.currentpage().getparameters().get('benefitEffectivedate');
       SubscriberSRKID = apexpages.currentpage().getparameters().get('coverageSRK');
        MemberId = apexpages.currentpage().getparameters().get('MemberId');
        covrgLevel = ApexPages.currentPage().getParameters().get('cvrlevel');
        accumAsOf = ApexPages.currentPage().getParameters().get('accumAsOf');
        String bookOfBusinessTypeCode = ApexPages.currentPage().getParameters().get('bookOfBusinessTypeCode');
        if(bookOfBusinessTypeCode != 'OX' && bookOfBusinessTypeCode != 'LF' && bookOfBusinessTypeCode != 'OL')
         {
           showCirrusBenefit = false;
         }else{
           showCirrusBenefit =  true;
         }
        String additionalInfoStr = apexpages.currentpage().getparameters().get('additionalInfo');
        AdditionalInfo = new ACETHighlightsPanelAdditionalInfo();
        if(!String.isEmpty(additionalInfoStr )){  
            AdditionalInfo = (ACETHighlightsPanelAdditionalInfo)json.deserialize(additionalInfoStr,ACETHighlightsPanelAdditionalInfo.class);         
        }
        SitusState = (AdditionalInfo.SitusState != null)?AdditionalInfo.SitusState:'';
        asOfDateFields = new ACETAccumAsOfWrapper();
        asOfDateFields.bundleOptionId = bundleOptionId;
        asOfDateFields.effectStartDate = EffectiveDate;
        asOfDateFields.SRKID = SRKID;
        asOfDateFields.effectEndDate = EndDate;
        asOfDateFields.cvrType = CoverageType;
        asOfDateFields.grpNumber = groupNo;
        //US2962032 : replaced date.parse() to DateTime.newInstance() to handle open ended dtaes 
          if(!String.isEmpty(benefitEndDate) && !String.isEmpty(benefitEffectiveDate)) {
            if(DateTime.newInstance(integer.valueof(benefitEndDate.split('/')[2]),integer.valueof(benefitEndDate.split('/')[0]),integer.valueof(benefitEndDate.split('/')[1]), 0, 0, 0) >= Date.Today() && DateTime.newInstance(integer.valueof(benefitEffectiveDate.split('/')[2]),integer.valueof(benefitEffectiveDate.split('/')[0]),integer.valueof(benefitEffectiveDate.split('/')[1]), 0, 0, 0) <  Date.Today()) {
                Date todayAccumsDate  = Date.Today();
                accumsDateSearch = ACETUtility.format(todayAccumsDate);
            }
            else if(DateTime.newInstance(integer.valueof(benefitEndDate.split('/')[2]),integer.valueof(benefitEndDate.split('/')[0]),integer.valueof(benefitEndDate.split('/')[1]), 0, 0, 0) < Date.Today()) {
                accumsDateSearch  = benefitEndDate;
            }
            else if(DateTime.newInstance(integer.valueof(benefitEffectiveDate.split('/')[2]),integer.valueof(benefitEffectiveDate.split('/')[0]),integer.valueof(benefitEffectiveDate.split('/')[1])) >  Date.Today() && DateTime.newInstance(integer.valueof(benefitEndDate.split('/')[2]),integer.valueof(benefitEndDate.split('/')[0]),integer.valueof(benefitEndDate.split('/')[1]), 0, 0, 0) >= Date.Today()) {
                accumsDateSearch  = benefitEffectiveDate;
            }
        } 
        
      
       // System.debug('****'+EndDate);
        if(!String.IsEmpty(covrgLevel)){
            if(covrgLevel == 'EMP' || covrgLevel == 'IND'){
                covrgLevel = 'IND';
            }else{
                covrgLevel= 'FAM';
            }
        }
        
        
        if(Network!=null){
            Network = Network.remove('[');
            Network = Network.remove(']');
            networklist = new list<string>(); 
            networklist.add(Network);                 
        }
        
       /* policies = new List<PolicyOverviewWrapper>();                  
        PolicyOverviewWrapper polovr = new PolicyOverviewWrapper();
        polovr.PolicyNumber = policyNumber;
        polovr.PlanId = planId;
        polovr.PlanName = PlanName;
        polovr.ProductId = ProductId;
        polovr.PlanType = PlanType;
        polovr.FundingArrangement = Null 
        polovr.PCP = PCP;
        polovr.GoverningStatePolicy = '';
        polovr.Resolved = true;
        policies.add(polovr);  */
        
        wrapper = new ACETCallTopicsDataWrapper();
       // System.debug('policies::::'+policies);
        ACETPlanBenefitSearchResults = new ACETGroupPlanBenefitWrapper();
        //benefitPlanMapping = new Map<String,String>();
        
    }
    
    
    
     
   
    
    public void makePlanBenefitLanguageCallout() {
        
    }
    
    public PageReference makePlanBenefitAccCallout() {
        return null;
    }
    
    public object CallWSOnPageLoad_New(){
        showTableLevelErrr = '';
        return CallWSOnPageLoad();
    }
    
    //Continuation callouts for subscription request par status type as 1 and 2
    public Object CallWSOnPageLoad()
    {
        customerPurchaseid = ApexPages.currentPage().getParameters().get('cpid');
        ACETPlanBenefitSearchResults = new ACETGroupPlanBenefitWrapper();
        string accumAsOf = ApexPages.currentPage().getParameters().get('accumAsOf');
        accumAsOf= accumAsOf==null ? accumsDateSearch : accumAsOf; 
      	ACETGetSubscriptionWS = new ACETNimbusGetSSBAPI();
       
        Continuation PageLoadContinuation = ACETGetSubscriptionWS.providerStartRequest( bundleOptionId, '','SRK', SRKID ,SubscriberSRKID, ChangeDateFormatForOIL(benefitEffectivedate) , ChangeDateFormatForOIL(benefitEnddate), ' ', '', '', '', groupNo, ChangeDateFormatForOIL(accumAsOf),customerPurchaseid, 'CallWSOnPageLoadCallback', null,'member');
        
        return PageLoadContinuation;
        
    }
    
    
    public pageReference CallWSOnPageLoadCallback() {
        //Get Subscription Response for Request par status type as 1
        ACETWSCalloutResult CopaySubscriptionCalloutResult = ACETGetSubscriptionWS.ProcessResponse(ACETGetSubscriptionWS.RequestLabel,SitusState);
        benefitErrorMsgs = new set<String>();
       // System.debug('CopaySubscriptionCalloutResult :'+Json.serialize(CopaySubscriptionCalloutResult));
        if(CopaySubscriptionCalloutResult != null && CopaySubscriptionCalloutResult.Success == true) {
            ACETPlanBenefitSearchResults = (ACETGroupPlanBenefitWrapper)CopaySubscriptionCalloutResult.response;
            ACETSubscriptionServices = CopaySubscriptionCalloutResult.responseBody;
            
           // System.debug('ACETPlanBenefitSearchResults :'+ACETPlanBenefitSearchResults );
            //System.debug('ACETPlanBenefitSearchResults :'+);
            if(ACETPlanBenefitSearchResults != null && ACETPlanBenefitSearchResults.benefitWrapperList != null) {
                memberPlanBenefitList  = new List<ACETGroupPlanBenefitWrapper.BenefitWrapper>(); 
                memberPlanBenefitList.addAll(ACETPlanBenefitSearchResults.benefitWrapperList);
            }
            if(ACETPlanBenefitSearchResults != null && ACETPlanBenefitSearchResults.planInfoWrapperList != null) {
                policiesovrView  = new List<ACETGroupPlanBenefitWrapper.PlanInformationWrapper>(); 
                
                policiesovrView.addAll(ACETPlanBenefitSearchResults.planInfoWrapperList);
                for(ACETGroupPlanBenefitWrapper.PlanInformationWrapper  wrp :ACETPlanBenefitSearchResults.planInfoWrapperList){
                    PlanType = wrp.planTypeCode;
                }
                system.debug('policiesovrView'+PlanType);
            }
            
        }
        //system.debug('showTableLevelErrr ::'+showTableLevelErrr);
        if(CopaySubscriptionCalloutResult != null && CopaySubscriptionCalloutResult.Success == false) {
            benefitErrorMsgs.add(CopaySubscriptionCalloutResult.Message);
            if(showTableLevelErrr != 'onload' && ACETGetSubscriptionRedesignWebservice.showCustomErrorMessage){
                showTableLevelErrr = 'true';
            }
        }
        if(benefitErrorMsgs != null && !benefitErrorMsgs.isEmpty()) { 
            for(String msg : benefitErrorMsgs) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, msg));
            }
        }
        return null;
    }
    
    public void dateSearchresults(){
        string accumAsOf = ApexPages.currentPage().getParameters().get('accumAsOf');
        accumAsOf= accumAsOf==null ? '': accumAsOf; 
        
        ACETGetSubscriptionWS1 = new ACETNimbusGetSSBAPI();
        ACETWSCalloutResult callresult = new ACETWSCalloutResult();
        callresult = ACETGetSubscriptionWS1.getSubscriptionBenefitSearch(bundleOptionId, MemberId,
                                                                         SRKID ,SubscriberSRKID , benefitEffectivedate ,
                                                                         benefitEnddate, CoverageType,
                                                                         groupNo, '', ChangeDateFormatForOIL(accumAsOf),customerPurchaseid);
        benefitErrorMsgs = new set<String>();
        
        if(callresult != null) {
            ACETPlanBenefitSearchResults = (ACETGroupPlanBenefitWrapper)callresult.response;
        }else {
            benefitErrorMsgs.add(callresult.Message);
        }
        
        if(benefitErrorMsgs != null && !benefitErrorMsgs.isEmpty()) { 
            for(String msg : benefitErrorMsgs) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error, msg));
            }
        }
    }
    public string showTableLevelErrr {get;set;}
    
    public class PolicyOverviewWrapper{
        public transient boolean isSelected{get;private set;}
        public transient String PolicyNumber{get;private set;}
        public transient String PlanId { get; private set; }
        public transient String PlanName { get; private set; } 
        public transient String productName{get;private set;}
        public transient String ProductId { get; private set; }
        public transient String PlanType { get; private set; }
        public transient String FundingArrangement { get; private set; }
        public transient String Accumulator  { get; private set; }
        public transient String Gated  { get; private set; }
        public transient String PCP  { get; private set; }
        public transient String GoverningStatePolicy  { get; private set; }
        public transient String Network  { get; private set; }
        public transient Boolean Resolved  { get; private set; }
    }
    
    public class Accumulator implements Comparable {
        public String Section { get ; set; }            //Individual or Familty
        public String TypeCode { get ; set; }           //INN or OON
        public string MaxDeductible { get ; set; }
        public string YTDDeductible { get ; set; }
        public string RemDeductible { get ; set; }
        public integer coinsurance {get;set;}
        public string MaxOOP { get ; set; }
        public string YTDOOP { get ; set; }
        public string RemOOP { get ; set; }
        public string covrgLevel {get;set;}
        public string primaryAccumDeduct {get;set;}
        public string primaryAccumDescOOP {get;set;}
        
        public Integer compareTo(Object ObjToCompare) {
            return TypeCode.CompareTo(((Accumulator)ObjToCompare).TypeCode);
        }
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
    
  

}