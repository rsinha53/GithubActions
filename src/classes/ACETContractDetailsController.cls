public with sharing class ACETContractDetailsController{
public string selectedProcType{get;set;}
   public ACETHighlightsPanelAdditionalInfo additionalInfo { get; set;}
   public ACETCallTopicsDataWrapper wrapper {get;set;}
   public List<FilingLimitDetailsWrapper> filingLimitDetailsList{get;set;}
   public List<TierDetailsWrapper> tierDetailsList{get;set;}
   public List<PricingSchedulesWrapper> pricingSchedulesList{get;set;}
   public List<LineofBusinessWrapper> lineOfBusinessList{get;set;}
   ACETGetMedProvAgreementWebservice ACETGMPAWS;
   public ACETGetMedProvAgreementJSON2Apex.MedicalProviderAgreement AgreementDetail { get; set;}
    public string providerType {get;set;}
   
   /*   */
   
   public list<ACETGetMedProvAgreementJSON2Apex.MedicalProviderAgreement> lstAgreementDetail { get; set;}
   public boolean  isProviderLookupDetailsResult {get;set;}
    public string rowEntry {get;set;}
   
   /*  */
   
   public String ProviderId, TaxId, providerTINTypeCode, addressId, addressTypeCode;
   public String ContractDetailId, ContractHeaderId, NetworkId, BenefitPlanId, NetworkScheduleId;
   public String NetwordTypeCode { get; set; }
   public String NTypeList {get;set;}
   public List<SelectOption> NetwordTypeCodes { get; set; }
    public Interaction__c interaction {
    get;
    set;
    }
    
   public String hpAdditionInfoStr {
    get;
    set;
   }
   
    public string sourceOriginator {
  get;
  set;
 }
 public Contact conObj {
  get;
  set;
 }
 public string memberId {
  get;
  set;
 }
 public string policyNumber {
  get;
  set;
 }
   public boolean showvalue{get;set;}
   public boolean showDetails{get;set;}
   //public List<PricingSearchTableWrapper> pricingTablesData{get;set;}
   //public List<ACETPricingScheduleResult> resultList{get;set;}      
   public String ProviderTypeCode { get; set; }
     
   
    public ACETCallTopicsDataWrapper acetCallTopicData {
        get;
        set;
    }
   
    public string allignment {get;set;}
        
   public ACETContractDetailsController(){
       
       allignment = 'margin-left:-32px';
   
   try{
      
      
     
   lstAgreementDetail = new list<ACETGetMedProvAgreementJSON2Apex.MedicalProviderAgreement>(); 
   isProviderLookupDetailsResult = false;
   if(ApexPages.currentPage().getParameters().get('isProviderLookupDetailsResult')=='True'){
            isProviderLookupDetailsResult = true;
        }
        
      NetwordTypeCodes = new List<SelectOption>();
      additionalInfo = new ACETHighlightsPanelAdditionalInfo();
      //wrapper = new ACETCallTopicsDataWrapper();
      String interactionId = ApexPages.currentPage().getParameters().get('interactionId');
       if (!String.isEmpty(interactionId)) {
   system.debug('InteractionId: ' + InteractionId);

   //Query Provider Interaction details
       interaction = ACETProviderUtility.GetInteractionByID(interactionId);
       sourceOriginator = Interaction.Interaction_Type__c;
       system.debug(LoggingLevel.info, 'Interaction: ' + interaction + ', sourceOriginator: ' + sourceOriginator);
     }
     
      String contactId = ApexPages.currentPage().getParameters().get('contactId');
      system.debug(LoggingLevel.Info, 'contactId: ' + contactId);
      if (!String.isEmpty(contactId)) {
        conObj = ACETProviderUtility.GetContactByID(contactId);
      }
      system.debug(LoggingLevel.Info, 'conObj: ' + conObj);
      
      String additionalInfostr = ApexPages.currentPage().getParameters().get('additionalInfo');
      system.debug(LoggingLevel.Info, 'additionalInfostr: ' + additionalInfostr);
      if (!String.isEmpty(additionalInfostr) && additionalInfostr != 'undefined' ) {
       additionalInfo = (ACETHighlightsPanelAdditionalInfo) JSON.deserialize(additionalInfostr, ACETHighlightsPanelAdditionalInfo.class);
       policyNumber = additionalInfo.PolicyNumber;
       hpAdditionInfoStr = JSON.serialize(additionalInfo);
      }
      system.debug(LoggingLevel.Info, 'additionalInfo: ' + additionalInfo);
      ProviderId = ApexPages.currentPage().getParameters().get('PID');
      TaxId = ApexPages.currentPage().getParameters().get('TID');
      providerTINTypeCode = ApexPages.currentPage().getParameters().get('PTINTC');
      addressId = ApexPages.currentPage().getParameters().get('AID');
      addressTypeCode = ApexPages.currentPage().getParameters().get('ATC');
      ContractDetailId = ApexPages.currentPage().getParameters().get('CNTRDID');
      ContractHeaderId = ApexPages.currentPage().getParameters().get('CNTRHID');
      NetworkId = ApexPages.currentPage().getParameters().get('NID');
      BenefitPlanId = ApexPages.currentPage().getParameters().get('BPID');
      NetworkScheduleId = ApexPages.currentPage().getParameters().get('NSID');
      providerType = ApexPages.currentPage().getParameters().get('type');
      filingLimitDetailsList = new list<FilingLimitDetailsWrapper>();
      tierDetailsList = new list<TierDetailsWrapper>();
      pricingSchedulesList = new list<PricingSchedulesWrapper>();
      lineOfBusinessList = new list<LineOfbusinessWrapper>();
      }
   catch(Exception ex){
   system.debug('-----Exception----'+ex.getMessage()+'-----at LIne#----'+ex.getLineNumber());
   }
   }
   
    public Object CallWSOnPageLoad()
    {
        system.debug(LoggingLevel.INFO, 'Inside CallWSOnPageLoad.');
        Continuation PageLoadContinuation;
        ACETGMPAWS = new ACETGetMedProvAgreementWebservice();
        PageLoadContinuation = ACETGMPAWS.StartRequest(ProviderId, TaxId, providerTINTypeCode, addressId, 
            addressTypeCode, ContractHeaderId, ContractDetailId, NetworkId, NetworkScheduleId, BenefitPlanId, 'CallWSOnPageLoadCallback', null);
        return PageLoadContinuation; 
    }
    public string pricingSetId{get; set;}
    public PageReference CallWSOnPageLoadCallback() {
        system.debug(LoggingLevel.INFO, 'Inside CallWSOnPageLoadCallback.');
        ACETWSCalloutResult GetMPACalloutResult = ACETGMPAWS.ProcessResponse(ACETGMPAWS.RequestLabel);
        AgreementDetail = (ACETGetMedProvAgreementJSON2Apex.MedicalProviderAgreement)GetMPACalloutResult.Response;
        lstAgreementDetail.add(AgreementDetail);
        for(ACETGetMedProvAgreementJSON2Apex.MedicalProviderAgreement l : lstAgreementDetail){
            if(l.PricingSet.id != null)
            pricingSetId = l.PricingSet.id;
        }
        NTypeList = '';
        if(AgreementDetail != null && AgreementDetail.network != null && AgreementDetail.network.typeCode != null){
            for (String NTypeCode :AgreementDetail.network.typeCode) {               
                system.debug('NTypeCode***'+NTypeCode);
                NTypeList +=  NTypeCode + ',';
            }
            NTypeList = !String.isBlank(NTypeList) ? NTypeList.substring(0,NTypeList.length()-1) : '';
         }   
         if(String.isNotBlank(GetMPACalloutResult.Message)){
             ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, GetMPACalloutResult.Message));
         }
        return null;
    }
       
    public class FilingLimitDetailsWrapper {
        public String filingLimitPeriod{get;set;}
        public String filingLimitEffectiveDate{get;set;}
        public String filingLimitPenaltyAmount{get;set;}
        public String filingLimitPeriodType{get;set;}
        public String filingLimitType{get;set;}
        public String filingLimitCancelDate{get;set;}
        public String filingLimitPenaltyPercentage{get;set;}
    } 
     public class TierDetailsWrapper {
        public String parStatus{get;set;}
        public String tier{get;set;}
        public String tierDescription{get;set;}
        public String benefitType{get;set;}
        public String serviceAreaType{get;set;}
    }   
    public class PricingSchedulesWrapper {
        public String pricingScheduleStatus{get;set;}
        public String pricingScheduleID{get;set;}
        public String pricingScheduleDescription{get;set;}
        public String pricingScheduleEffectiveDate{get;set;}
        public String pricingScheduleCancelDate{get;set;}
        public String facilityPaperTypeID{get;set;}
        public String facilityPaperTypeDescription{get;set;}
        }
    public class LineOfBusinessWrapper {
        public String LOBName{get;set;}
        public String MedicalNecessity{get;set;}
        
    }
  
}