public with sharing class ACETViewFeeScheduleController {
  public String pcode1 { get; set; }

    /* Commenting until integration time- US661689
    public String checkNumber { get; set; }
    public String seriesDesignator { get; set; } 
    public Boolean showSearch{ get; set; }  
    public String revenue { get; set; }  
    public String charges { get; set; }  
    public String modifiers { get; set; }  
    public String pcode { get; set; }
    public String pcode1 { get; set; } 
    public String pcode2 { get; set; }
    public String pcode3 { get; set; } 
    public String pcode4 { get; set; }
    public String pcode5 { get; set; } 
    public String pcode6 { get; set; }
    public String pcode7 { get; set; } 
    public String pcode8 { get; set; }
    public String pcode9 { get; set; }        
    public String providerId { get; set; } 
    public String memberId { get; set; } 
    public String surrogateKey {get;set;}
    public Case startDate { get; set; }
    public Case endDate { get; set; }       
    public Interaction__c interaction { get; set; }  
    public Contact subject { get; set; }
    public ACETHighlightsPanelAdditionalInfo additionalInfo { get; set; }
    public Boolean showDetails{ get; set; }
    public String hpAdditionInfoStr { get; set; }
    public String proferredCoverageGUID { get; set; }
    public Boolean showSearchResults{ get; set; }
    public list<ACETProviderContractResult> lstACETProvider { get; set; }
    private List<ACETProviderContractResult> agreements { get; set; }
    public List<ACETGetAgreementPricingWebservice.ACETFeeScheduleCodeLookupResult> feeScheduleCodeLookupResults { get;set;}
    public Boolean disableContractType { get; set; }
    
    public String contractType { get; set; }
    public ACETCallTopicsDataWrapper wrapper {get;set;}
    
    public List<SelectOption> contractTypes {
        get {
            List<SelectOption> lstCTs = new List<SelectOption>();
            lstCTs.add(new SelectOption('Active', 'Active'));
            lstCTs.add(new SelectOption('All', 'All'));
            return lstCTs;
        }
    }
    
    public ACETViewFeeScheduleController() { 
        startDate = new Case();
        startDate.tst_unit_type__c = 1;
        endDate = new Case();      
        showDetails = false;
        showSearch = false;
        interaction = new Interaction__c();     
        contractType = '';
        wrapper = new ACETCallTopicsDataWrapper();
        wrapper.init(); 
        wrapper.CaseObj.Topic__c = 'View Fee Schedule';
        
        additionalInfo = new ACETHighlightsPanelAdditionalInfo();
        lstACETProvider = new list<ACETProviderContractResult>();
        feeScheduleCodeLookupResults = new List<ACETGetAgreementPricingWebservice.ACETFeeScheduleCodeLookupResult>();
        disableContractType = false;
        
        providerId = ApexPages.currentPage().getParameters().get('providerId');
        memberId = ApexPages.currentPage().getParameters().get('memberId');
        String interactionId = ApexPages.currentPage().getParameters().get('interactionId');
        surrogateKey  = ApexPages.currentPage().getParameters().get('SRK');
        System.debug(LoggingLevel.INFO, 'SRKSRK' + surrogateKey  );
        if (!String.isEmpty(interactionId)){ 
            interaction = ACETProviderUtility.getInteractionByID(interactionId);
        }
        if (!String.isEmpty(surrogateKey)){ 
            wrapper.surrogateKey = surrogateKey;
        }
        String contactId = ApexPages.currentPage().getParameters().get('contactId');
        if (!String.isEmpty(contactId)){ 
            subject = ACETProviderUtility.getContactByID(contactId);
        }
        String additionalInfostr = ApexPages.currentPage().getParameters().get('additionalInfo');
        if (!String.isEmpty(additionalInfostr)){        
            additionalInfo = (ACETHighlightsPanelAdditionalInfo)JSON.deserialize(additionalInfostr , ACETHighlightsPanelAdditionalInfo.class);
            hpAdditionInfoStr = JSON.serialize(AdditionalInfo);  
        }  
        String checknumberstr = ApexPages.currentPage().getParameters().get('checkNumber');
        if (!String.isEmpty(checknumberstr)){        
            checkNumber = checknumberstr;  
        } 
        String seriesdesignatorstr = ApexPages.currentPage().getParameters().get('seriesDesignator');
        if (!String.isEmpty(seriesdesignatorstr)){        
            seriesDesignator = seriesdesignatorstr;  
        } 
    }
    
    //Action method for invoking findAgreements webservice  
    public void CallGetProviderContractsWS() {
        ACETFindAgreementWebservice ACETFAWS = new ACETFindAgreementWebservice();        
        ACETWSCalloutResult findContractsServiceCalloutResult = new ACETWSCalloutResult();
        if(String.isNotBlank(surrogateKey) && surrogateKey != 'undefined'){
            findContractsServiceCalloutResult = ACETFAWS.findAgreement(surrogateKey, 'member');
            system.debug(LoggingLevel.INFO, '2323findContractsServiceCalloutResult'+findContractsServiceCalloutResult);     
        }
        else{
            if(String.isNotBlank(memberId)){
                findContractsServiceCalloutResult = ACETFAWS.findAgreement(memberId, 'member');         
            }
            else
                findContractsServiceCalloutResult = ACETFAWS.findAgreement(interaction.Originator__r.EID__c, interaction.Originator_Type__c);
            
        }
        if (findContractsServiceCalloutResult.Success != null && findContractsServiceCalloutResult.Success) {   
            agreements = (list<ACETProviderContractResult>)findContractsServiceCalloutResult.Response;
            disableContractType = agreements.size() == 0; 
            refreshAgreements();
        }
        else {
            disableContractType = true;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, system.Label.ACETUnexpectedErrorMessage));
        }
    } 
    
    //Refresh agreements based on selected radio, Active or All
   public PageReference refreshAgreements() {
        List<ACETProviderContractResult> activeAgreements = new List<ACETProviderContractResult>();
        for (ACETProviderContractResult agreement :agreements) {
            if (agreement.isActive) {
                activeAgreements.add(agreement);
            }
        }
        system.debug(LoggingLevel.INFO, 'ContractType: ' + contractType);
        if (contractType == '') {
            contractType = agreements.size() == 0 || activeAgreements.size() == 0 ? 'All' : 'Active';
        }
        if (contractType == 'All') {
            lstACETProvider = agreements;
        } 
        else {
            lstACETProvider = activeAgreements;
        }
        return null;
    } 
    
    public PageReference searchNegative() { 
        showSearch = false;
        return null;
    }
    
    public PageReference search() { 
        showSearch = true;
        String stringNoOfUnits = String.ValueOf(startDate.tst_unit_type__c);        
        String stringStartDate = ACETUtility.formatDate(string.valueOf(startDate.tst_Date_Field__c));
        String stringEndDate = ACETUtility.formatDate(string.valueOf(endDate.tst_Date_Field__c));
        
        ACETGetAgreementPricingWebservice ACETGAPWS = new ACETGetAgreementPricingWebservice();
        ACETWSCalloutResult ACETGARResult = ACETGAPWS.GetAgreementPricing(stringStartDate, stringEndDate, checkNumber, seriesDesignator, stringNoOfUnits, pcode, revenue, charges, modifiers);
        if (ACETGARResult.Success != null && ACETGARResult.Success) { 
            list<ACETGetAgreementPricingWebservice.ACETFeeScheduleCodeLookupResult> WSResult = (list<ACETGetAgreementPricingWebservice.ACETFeeScheduleCodeLookupResult>)ACETGARResult.Response;  
            if(feeScheduleCodeLookupResults.size() == 0) {
                feeScheduleCodeLookupResults = WSResult;
            }
            else {
                //FeeScheduleCodeLookupResults.clear();
                feeScheduleCodeLookupResults.addAll(WSResult);
            }            
        }
        else {         
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, system.Label.ACETUnexpectedErrorMessage));        
        }
        return null;        
    }     
    
    public void showDetailsSection() {
        showDetails = true;
    }
    
    public class ProviderContractDetail {
        public String strEffective { get; set; }
        public String strCancel { get; set; }
        public String strProduct { get; set; }
        public String strNetworkId { get; set; }
        public String strNetworkName { get; set; }
        public String strNetworkStatus { get; set; }
        public String strIPA{ get; set; }
        public String location { get; set; }
        public String code { get; set; }
        public String description { get; set; }
        public String modifier { get; set; }
        public String unitType { get; set; }
        public Integer noOfUnits { get; set; }
        public Decimal amount { get; set; }
        public Boolean isActive { get; set; }
        public String strCapitation { get; set; }
        public String strAcceptingNewPatient { get; set; }
    } */
}