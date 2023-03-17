global with sharing class ACETProviderFeeScheduleController {
  
    public ACETProviderDetailController.ACETProviderDetail providerDetail  { get; set; }
    public Interaction__c Interaction { get; set; }
    public String ProviderTypeCode { get; set; }
    public ACETCallTopicsDataWrapper wrapper {get;set;}
    
    public string rowEntry {get;set;}
   
    public boolean showvalue {get;set;}
    public ACETHighlightsPanelAdditionalInfo additionalInfo {
        get;
        set;
    }
      
    public ACETDatatableWrapper AgrmntsDTWrapper { get; set; }  
    public String ProviderId{get;set;}
    Public String TaxId{get;set;}
    public String providerTINTypeCode{get;set;}
    public String addressId{get;set;}
    public String ProvideraddressTypeCode{get;set;}
    ACETGetHCOWebservice ACETGetHCOWS;
    ACETGetHCPWebservice ACETGetHCPWS;
    public String providerStatusCode {get;set;}
    public String providerTINStatusCode{get;set;}
   
    Public ACETProviderFeeScheduleController (){
       
        
        System.debug(LoggingLevel.INFO,'ProviderTypeCode::::::' + ProviderTypeCode);
        String interactionId = ApexPages.currentPage().getParameters().get('interactionId');
        ProviderId= apexpages.currentpage().getparameters().get('ProviderId');
        TaxId= apexpages.currentpage().getparameters().get('TaxId');
        providerTINTypeCode= apexpages.currentpage().getparameters().get('providerTINTypeCode');
        addressId= apexpages.currentpage().getparameters().get('addressId');
        ProvideraddressTypeCode= apexpages.currentpage().getparameters().get('ProvideraddressTypeCode');
        ProviderTypeCode = apexpages.currentpage().getparameters().get('ProviderTypeCode');
        providerStatusCode = apexpages.currentpage().getparameters().get('providerStatusCode');
        providerTINStatusCode= apexpages.currentpage().getparameters().get('providerTINStatusCode');
        String surrogateKey = apexpages.currentpage().getparameters().get('SRK');
        if (!String.isEmpty(interactionId)) {
            Interaction = ACETProviderUtility.GetInteractionByID(interactionId);
        }
        wrapper = new ACETCallTopicsDataWrapper();        
            wrapper.CallTopic = 'Provider Fee Schedule';         
            wrapper.CaseObj.topic__c = 'Provider Fee Schedule';
            
            if(string.isNotBlank(surrogateKey)){
                wrapper.surrogateKey = surrogateKey;
              // wrapper.surrogateKey = surrogateKey;
            }  
        
        }
    
                
    public Object CallWSOnPageLoad()
    {
        
        Continuation PageLoadContinuation;
      /*  if (ProviderTypeCode == 'HCO') {
            ACETGetHCOWS = new ACETGetHCOWebservice();
            PageLoadContinuation = ACETGetHCOWS.StartRequest(ProviderId, TaxId, providerStatusCode, providerTINStatusCode, providerTINTypeCode, addressId, ProvideraddressTypeCode, 'providerSearch', 'CallWSOnPageLoadCallback', null);
        else {
            ACETGetHCPWS = new ACETGetHCPWebservice();
            PageLoadContinuation = ACETGetHCPWS.StartRequest(ProviderId, TaxId, providerTINTypeCode, addressId, ProvideraddressTypeCode, 'providerSearch', 'CallWSOnPageLoadCallback', null);
        }    */   
        return PageLoadContinuation; 
    }
    public PageReference CallWSOnPageLoadCallback() {
        system.debug(LoggingLevel.INFO, 'Inside CallWSOnPageLoadCallback. ProviderTypeCode: ' + ProviderTypeCode);
        system.debug(LoggingLevel.INFO, 'Inside CallWSOnPageLoadCallback. providerTINTypeCode: ' + providerTINTypeCode);
        system.debug(LoggingLevel.INFO, 'Inside CallWSOnPageLoadCallback. providerStatusCode: ' + providerStatusCode);
        system.debug(LoggingLevel.INFO, 'Inside CallWSOnPageLoadCallback. providerTINStatusCode: ' + providerTINStatusCode);
        system.debug(LoggingLevel.INFO, 'Inside CallWSOnPageLoadCallback. addressId: ' + addressId);
        system.debug(LoggingLevel.INFO, 'Inside CallWSOnPageLoadCallback. ProvideraddressTypeCode: ' + ProvideraddressTypeCode);
        system.debug(LoggingLevel.INFO, 'Inside CallWSOnPageLoadCallback. Originatorinteraction: ' + Interaction.Originator_Type__c);
        ACETWSCalloutResult FindAgreementsCalloutResult;
      /*  if(Interaction.Originator_Type__c != 'Other'){
            if (ProviderTypeCode == 'HCO') {
                GetProviderCalloutResult = ACETGetHCOWS.ProcessResponse('', ACETGetHCOWS.RequestLabel);
            } else if(ProviderTypeCode == 'HCP') {
                GetProviderCalloutResult = ACETGetHCPWS.ProcessResponse('providerSearch', ACETGetHCPWS.RequestLabel);
            }
            if(GetProviderCalloutResult != null && GetProviderCalloutResult.Response != null)
                providerDetail = (ACETProviderDetailController.ACETProviderDetail)GetProviderCalloutResult.Response;          
            system.debug(LoggingLevel.INFO, 'GetProviderCalloutResult:: ' + GetProviderCalloutResult);
            
            if(GetProviderCalloutResult != null && String.isNotBlank(GetProviderCalloutResult.Message)) {                
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, GetProviderCalloutResult.Message));
            } 
            
        } */
        return null;
    }    
    
        public void CallFindAgreements() {
        System.debug('method');
        ACETFindAgreementsWebservice AgrementsWS = new ACETFindAgreementsWebservice();
        AgrementsWS.Init(ProviderId, TaxId, providerTINTypeCode,addressId,ProvideraddressTypeCode,'','','');
        AgrementsWS.GetEndpoint();  
        AgrmntsDTWrapper  = new ACETDatatableWrapper('ACETFindAgreementsWebservice', AgrementsWS);   
        AgrmntsDTWrapper.PageSize = AgrementsWS.PageSize;
        //AgrmntsDTWrapper.IsSortEnabled = true;
        //AgrmntsDTWrapper.defaultSortBy = 0;  
        //AgrmntsDTWrapper.defaultSortDir = 'asc';      
        // AgrmntsDTWrapper.Columns.add(new ACETDataTableWrapper.DataColumn('Plan Type', 'Product'));
       // AgrmntsDTWrapper.Columns.add(new ACETDataTableWrapper.DataColumn('', 'Network_Name')); 
        AgrmntsDTWrapper.Columns.add(new ACETDataTableWrapper.DataColumn('', 'NetworkNamePricngSet'));
        AgrmntsDTWrapper.Columns.add(new ACETDataTableWrapper.DataColumn('Active', 'Contract_Status'));
        AgrmntsDTWrapper.Columns.add(new ACETDataTableWrapper.DataColumn('Network ID', 'Network_ID'));
        AgrmntsDTWrapper.Columns.add(new ACETDataTableWrapper.DataColumn('Network Name', 'Network_Name'));
        AgrmntsDTWrapper.Columns.add(new ACETDataTableWrapper.DataColumn('Process Order', 'process_Order_Number'));
        //  AgrmntsDTWrapper.Columns.add(new ACETDataTableWrapper.DataColumn('Network Schedule ID', 'NetworkSchedule'));
        // AgrmntsDTWrapper.Columns.add(new ACETDataTableWrapper.DataColumn('Benefit Plan ID', 'BenefitPlanId'));
        AgrmntsDTWrapper.Columns.add(new ACETDataTableWrapper.DataColumn('Organization Name', 'organizationName'));
        AgrmntsDTWrapper.Columns.add(new ACETDataTableWrapper.DataColumn('Pricing Set ID', 'Pricing_Set_ID')); 
        //AgrmntsDTWrapper.Columns.add(new ACETDataTableWrapper.DataColumn('Status', 'Contract_Status'));
        AgrmntsDTWrapper.Columns.add(new ACETDataTableWrapper.DataColumn('Contract ID', 'ContractDetailId'));
        AgrmntsDTWrapper.Columns.add(new ACETDataTableWrapper.DataColumn('Effective', 'Effective'));
        AgrmntsDTWrapper.Columns.add(new ACETDataTableWrapper.DataColumn('Cancel', 'Cancel'));
        if (ProviderTypeCode == 'HCP') {
            AgrmntsDTWrapper.Columns.add(new ACETDataTableWrapper.DataColumn('Accepting New Patients', 'Accepting_New_Patients'));
            AgrmntsDTWrapper.Columns.add(new ACETDataTableWrapper.DataColumn('Assignment Type', 'ProviderAssignmentType'));
        }
        AgrmntsDTWrapper.Columns.add(new ACETDataTableWrapper.DataColumn('Provider Assignment', 'providerAssignmentIndicator'));
        AgrmntsDTWrapper.PageStartNumber = 0;
        AgrmntsDTWrapper.PageNumber = 0;
        AgrmntsDTWrapper.StartRecord = 0;
        AgrmntsDTWrapper.initOnDocumentReady = false;
    }
   
}