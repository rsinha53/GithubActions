public with sharing class ACETProviderDetailController {
    public Interaction__c Interaction { get; set; }
    public  Transient  ACETProviderDetail providerDetail { get; set; }
    public Contact subject { get; set; }   
    public list<ACETProviderContractResult> Agreements { get; set; }
    public String FindAgreementsMessage { get; set; }
    public String providerNotFound {get;set;}
    public String ProviderTypeCode { get; set; } //added by Avish 03/14/2017 - US537411
    public String providerTINStatusCode { get; set; } //added by Avish 03/14/2017 - US537411
    public String ProvideraddressTypeCode { get; set; } //added by Avish 03/14/2017 - US537411
    public String providerTINOwner { get; set; } //added by Avish 03/14/2017 - US537411
    public String hcoTypeCode { get; set; } //added by vinay 04/12/2017
    public String providerStatusCode { get; set; } //Added by vinay 04/11/2017
    public String providerTINTypeCode { get; set; } //Added by vinay 04/11/2017
    public String addressId { get; set; }  //Added by vinay 04/11/2017
    public String addressTypeCode { get; set; } //Added by vinay 04/11/2017
    public list<Alert__c> lstProviderAlert { get; set; }//added by Vishkaha 11/17/2016
    public String providerType {get; set;}
    public Transient  List<ACETContactHistoryCase> historyCases { get; set; }
    public Integer caseListSize { get; set; }
    public string strType { get; set; }
    public Double offset { get; set; }     
    
    //Added for Async callouts
   Transient   ACETGetHCOWebservice ACETGetHCOWS;
   Transient    ACETGetHCPWebservice ACETGetHCPWS;
   Transient ACETFindAgreementsWebservice ACETFindAgreementsWS;
    
   Transient public ACETDatatableWrapper AddrDTWrapper { get; set; }     //Used by pagination component
   Transient public ACETDatatableWrapper AffDTWrapper { get; set; }     //Used by pagination component
   Transient public ACETDatatableWrapper AgrmntsDTWrapper { get; set; }     //Used by pagination component
  
    public string PNFContactName {get;set;}
    public string PNFLastName {get;set;}
    public string PNFFirstName {get;set;}
    public string PNFPhoneNumber {get;set;}
    public string PNFTaxId {get;set;}
    public string PNFNPI {get;set;}
    public string FilterByStatus{get;set;}
    public string PNFProviderTypeCode {get;set;}
    public ACETHighlightsPanelAdditionalInfo AdditionalInfo {get;set;}
    public string AttributeSet {get; set;}
    public String hpAdditionInfoStr {get{
        //return JSON.serialize(AdditionalInfo);
        return EncodingUtil.urlEncode(JSON.serialize(AdditionalInfo), 'UTF-8');
    }set;}
     public List<SelectOption> filterStatus {
    get {
        if (filterStatus == null) {
            filterStatus = new List<SelectOption>();
            filterStatus.add(new SelectOption('Active', 'Active'));
            filterStatus.add(new SelectOption('All', 'All'));
        }
        return filterStatus;
    }
   set;
}
    public ACETProviderDetailController()
    {    
        System.debug('!@ ProviderDetail Page complete URL'+ApexPages.currentPage().getUrl());
        String InteractionId = apexpages.currentpage().getparameters().get('Id');
        System.debug('!@ InteractionId'+InteractionId);
        strType  = apexpages.currentpage().getparameters().get('Type');
        ProviderTypeCode = apexpages.currentpage().getparameters().get('ProviderTypeCode');
        
        providerTINStatusCode = apexpages.currentpage().getparameters().get('providerTINStatusCode');
        ProvideraddressTypeCode = apexpages.currentpage().getparameters().get('ProvideraddressTypeCode');
        providerTINOwner = apexpages.currentpage().getparameters().get('providerTINOwner');
        hcoTypeCode = apexpages.currentpage().getparameters().get('hcoTypeCode');
        providerStatusCode = apexpages.currentpage().getparameters().get('providerStatusCode');
        providerTINTypeCode = apexpages.currentpage().getparameters().get('providerTINTypeCode');
        providerType = apexpages.currentpage().getparameters().get('providerType');
        addressId = apexpages.currentpage().getparameters().get('addressId');
        addressTypeCode = apexpages.currentpage().getparameters().get('addressTypeCode');
        string contactName = apexpages.currentpage().getparameters().get('ContactName');
        System.debug('!@ contactName'+contactName);
  
        providerNotFound = apexpages.currentpage().getparameters().get('pnf');
        PNFContactName = apexpages.currentpage().getparameters().get('PNFContactName');
        System.debug('!@ PNFContactName'+PNFContactName);
        PNFLastName = apexpages.currentpage().getparameters().get('PNFLastName');
        System.debug('!@ PNFLastName'+PNFLastName);
        PNFFirstName = apexpages.currentpage().getparameters().get('PNFFirstName');
        System.debug('!@ PNFFirstName'+PNFFirstName);
        PNFPhoneNumber = apexpages.currentpage().getparameters().get('PNFPhoneNumber');
        PNFTaxId = apexpages.currentpage().getparameters().get('PNFTaxId');
        PNFNPI = apexpages.currentpage().getparameters().get('PNFNPI');
        PNFProviderTypeCode = apexpages.currentpage().getparameters().get('PNFProviderTypeCode');
        system.debug('!@ PNFProviderTypeCode----> '+PNFProviderTypeCode );
        AdditionalInfo = new ACETHighlightsPanelAdditionalInfo();
        AdditionalInfo.providerPhoneNumber = apexpages.currentpage().getparameters().get('providerPhoneNumber');
          AdditionalInfo.platinumProvider = ApexPages.currentPage().getParameters().get('platinumProvider');
        Interaction = ACETProviderUtility.GetInteractionByID(InteractionId);
        if(contactName != null)
        {
            system.debug('!@ contactName----> '+contactName );
            AdditionalInfo.contactName = contactName;
            //Added below line by Avish on 09052017 as a part of DE108966 PI16.3
            AdditionalInfo.providerType = ProviderTypeCode;
        }
        if(PNFProviderTypeCode != null && PNFProviderTypeCode != '') {
            AdditionalInfo.providerType = PNFProviderTypeCode;
        }
        if(PNFPhoneNumber != null && PNFPhoneNumber !='') {
             AdditionalInfo.providerPhoneNumber = PNFPhoneNumber;
        }
        if(PNFContactName != null && PNFContactName != '') {
            AdditionalInfo.contactName = PNFContactName;
        }
        hpAdditionInfoStr = JSON.serialize(AdditionalInfo);
        
        system.debug(LoggingLevel.INFO, 'Interaction Id: ' + InteractionId + ', Type: ' + strType + ', ProviderTypeCode: ' + ProviderTypeCode);
        system.debug(LoggingLevel.INFO, 'providerTINStatusCode: ' + providerTINStatusCode + ', ProvideraddressTypeCode: ' + ProvideraddressTypeCode + ', providerTINOwner: ' + providerTINOwner);
        system.debug(LoggingLevel.INFO, 'hcoTypeCode: ' + hcoTypeCode + ', providerStatusCode: ' + providerStatusCode + ', providerTINTypeCode: ' + providerTINTypeCode);
        system.debug(LoggingLevel.INFO, 'addressId: ' + addressId + ', addressTypeCode: ' + addressTypeCode);
        
        Interaction = ACETProviderUtility.GetInteractionByID(InteractionId);
        system.debug(LoggingLevel.INFO, 'Interaction: ' + Interaction );
        
        timeZone tz = UserInfo.getTimeZone();
        offset = tz.getOffset(DateTime.now()) / (1000 * 3600 * 24.0);
        providerDetail  =  new ACETProviderDetail();     
            
        HistoryCases = new List<ACETContactHistoryCase>();
        FindAgreementsMessage = Label.ACETNoRecordErrorMessage;
        CallTopicOptions = new list<selectOption>(); 
        system.debug('test');
if(providerNotFound == null){
            providerNotFound = apexpages.currentpage().getparameters().get('pnf');
        }
        if(providerNotFound!='1'){
        CallTopicOptions = ACETCallTopicsPicklistUtility.getCallTopicOptions('Provider Detail', Interaction.Originator_Type__c);  
}
        else{
            CallTopicOptions = ACETCallTopicsPicklistUtility.getCallTopicOptions('Provider Not Found', 'Provider');
        }
    }
    
    public void Init()
    {
        system.debug(LoggingLevel.INFO, 'Interaction.Originator__r.EID__c: ' + Interaction.Originator__r.EID__c);
        system.debug(LoggingLevel.INFO, 'Interaction.Originator__r.Tax_ID__c: ' + Interaction.Originator__r.Tax_ID__c);
        try
        {
            if(Interaction !=null ){
                If(Interaction.Originator__c !=null && Interaction.Originator__r.Contact_Type__c !=null && Interaction.Originator__r.Contact_Type__c !=''){
                    System.debug('!@ PDInteraction.Originator__r.Contact_Type__c'+Interaction.Originator__r.Contact_Type__c);
                }else if(Interaction.Contact_Type__c !=null && Interaction.Contact_Type__c !=''){
                    System.debug('!@ PDInteraction.Contact_Type__c'+Interaction.Contact_Type__c);
                }
            }
            if (Interaction.Originator__r != NULL && String.isNotBlank(Interaction.Originator__r.EID__c))
            {
                HistoryCases = ACETProviderUtility.GetACETContactCaseHistory(Interaction.Originator__r.Tax_ID__c);
                caseListSize = HistoryCases.size();
            }
            else
            {
                providerDetail.generalInfo.lastName = Interaction.Third_Party__r.LastName__c;
                providerDetail.generalInfo.firstName = Interaction.Third_Party__r.First_Name__c;
                providerDetail.generalInfo.taxId = Interaction.Third_Party__r.Tax_ID__c;
                providerDetail.generalInfo.nPI = Interaction.Third_Party__r.NPI__c;
                providerDetail.generalInfo.phone = Interaction.Third_Party__r.Phone_Number__c;   
            }
            getNumberOfProviderAlert();
            updateInterfromVccdParms();
        }
        catch(Exception ex) 
        {
            system.debug(LoggingLevel.INFO, 'Exception in Init: ' + ex);
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, system.Label.ACETUnexpectedErrorMessage));
        }
    }
    
    public   Object CallWSOnPageLoad()
    {
        system.debug(LoggingLevel.INFO, 'Inside CallWSOnPageLoad. ProviderTypeCode: ' + ProviderTypeCode + ', Interaction.Originator_Type__c @@@ ' + Interaction.Originator_Type__c);
         Continuation PageLoadContinuation;
        if (ProviderTypeCode == 'HCO') {
            ACETGetHCOWS = new ACETGetHCOWebservice();
            PageLoadContinuation = ACETGetHCOWS.StartRequest(Interaction.Originator__r.EID__c, Interaction.Originator__r.Tax_ID__c, providerStatusCode, providerTINStatusCode, providerTINTypeCode, addressId, ProvideraddressTypeCode, 'providerSearch', 'CallWSOnPageLoadCallback', null);
        } else {
            ACETGetHCPWS = new ACETGetHCPWebservice();
            PageLoadContinuation = ACETGetHCPWS.StartRequest(Interaction.Originator__r.EID__c, Interaction.Originator__r.Tax_ID__c, providerTINTypeCode, addressId, ProvideraddressTypeCode, 'providerSearch', 'CallWSOnPageLoadCallback', null);
        }       
        return PageLoadContinuation; 
    }
    
    public  PageReference CallWSOnPageLoadCallback() {
        system.debug(LoggingLevel.INFO, 'Inside CallWSOnPageLoadCallback. ProviderTypeCode: ' + ProviderTypeCode);
       ACETWSCalloutResult GetProviderCalloutResult, FindAgreementsCalloutResult;
        if(Interaction.Originator_Type__c != 'Other'){
            if (ProviderTypeCode == 'HCO') {
                GetProviderCalloutResult = ACETGetHCOWS.ProcessResponse(providerTINOwner, ACETGetHCOWS.RequestLabel);
            } else if(ProviderTypeCode == 'HCP') {
                 GetProviderCalloutResult = ACETGetHCPWS.ProcessResponse('providerSearch', ACETGetHCPWS.RequestLabel);
            }
            providerDetail = (ACETProviderDetail)GetProviderCalloutResult.Response;          
            system.debug(LoggingLevel.INFO, 'GetProviderCalloutResult:: ' + GetProviderCalloutResult);

            if(String.isNotBlank(GetProviderCalloutResult.Message)) {                
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, GetProviderCalloutResult.Message));
            } 
            
            if(providerDetail!=null){
                if(providerDetail.generalInfo!=null){
                    if(providerDetail.generalInfo.providerId!=null){
                        AdditionalInfo.providerId = providerDetail.generalInfo.providerId;
                    }
                }
            }
            
           if(providerDetail.specialities!=null && !providerDetail.specialities.isEmpty()){
            for(ACETProviderSpeciality specialty :providerDetail.specialities){
                 if(specialty.primarySpeciality == 'Y'){
                 AdditionalInfo.primarySpecialty = specialty.speciality;
                 }
                } 
               }
                hpAdditionInfoStr = JSON.serialize(AdditionalInfo);   
                            
        }
        return null;
    }    
     //Added for the user story US1035659 
     public void CallFindAgreements() {
     
            ACETFindAgreementsWebservice AgrementsWS = new ACETFindAgreementsWebservice();
            AgrementsWS.Init(Interaction.Originator__r.EID__c, Interaction.Originator__r.Tax_ID__c, providerTINTypeCode, addressId, ProvideraddressTypeCode,null,'','');
            AgrementsWS.GetEndpoint();  
            AgrmntsDTWrapper  = new ACETDatatableWrapper('ACETFindAgreementsWebservice', AgrementsWS);   
            AgrmntsDTWrapper.PageSize = AgrementsWS.PageSize;
            AgrmntsDTWrapper.IsSortEnabled = true;
           // AgrmntsDTWrapper.Columns.add(new ACETDataTableWrapper.DataColumn('Plan Type', 'Product'));
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
            AgrmntsDTWrapper.defaultSortBy = 2;
    }

    public void CallFindMedicalProvider() {
        system.debug(LoggingLevel.INFO, 'Interaction.Originator__r.EID__c: ' + Interaction.Originator__r.EID__c + ' ProviderTypeCode :: ' + ProviderTypeCode);
        system.debug(LoggingLevel.INFO, 'Interaction.Originator__r.Tax_ID__c: ' + Interaction.Originator__r.Tax_ID__c);        
        if (ProviderTypeCode == 'HCO') {
            ACETFindHCOWebservice ACETAddrWS = new ACETFindHCOWebservice();
            ACETAddrWS.Init(Interaction.Originator__r.EID__c, null, Interaction.Originator__r.Tax_ID__c, null, null, null, null, null, null, null,null,null,null,null,null,null,null,AttributeSet,'false',false);
            ACETAddrWS.GetEndpoint();  
            AddrDTWrapper = new ACETDatatableWrapper('ACETFindHCOWebservice', ACETAddrWS);
            AddrDTWrapper.PageSize = ACETAddrWS.PageSize;   
        } else {
            ACETFindHCPWebservice ACETAddrWS = new ACETFindHCPWebservice();
            ACETAddrWS.Init(Interaction.Originator__r.EID__c, null, Interaction.Originator__r.Tax_ID__c, null, null, null, null, null, null,null,null, null, null, null,null,null,null,null, null,null,null,null,null,null,AttributeSet,'false');
            ACETAddrWS.GetEndpoint();
            AddrDTWrapper = new ACETDatatableWrapper('ACETFindHCPWebservice', ACETAddrWS);
            AddrDTWrapper.PageSize = ACETAddrWS.PageSize;
        }  
        AddrDTWrapper.PageStartNumber = 0;
        AddrDTWrapper.PageNumber = 0;
        AddrDTWrapper.StartRecord = 0;
        AddrDTWrapper.initOnDocumentReady = false;
        AddrDTWrapper.IsSortEnabled = true;
        AddrDTWrapper.Columns.add(new ACETDataTableWrapper.DataColumn('Active', 'addressStatusCode'));
        AddrDTWrapper.Columns.add(new ACETDataTableWrapper.DataColumn('Address Type', 'addressTypeCode'));
        AddrDTWrapper.Columns.add(new ACETDataTableWrapper.DataColumn('Address', 'address'));
        AddrDTWrapper.Columns.add(new ACETDataTableWrapper.DataColumn('County', 'County'));
        AddrDTWrapper.Columns.add(new ACETDataTableWrapper.DataColumn('Phone', 'phoneNumber'));
        AddrDTWrapper.Columns.add(new ACETDataTableWrapper.DataColumn('Fax', 'Fax'));
        AddrDTWrapper.Columns.add(new ACETDataTableWrapper.DataColumn('Email', 'Email'));  
    }
    
    public void CallFindAffiliations() {
        system.debug(LoggingLevel.INFO, 'Interaction.Originator__r.EID__c: ' + Interaction.Originator__r.EID__c + ' ProviderTypeCode :: ' + ProviderTypeCode);
        system.debug(LoggingLevel.INFO, 'Interaction.Originator__r.Tax_ID__c: ' + Interaction.Originator__r.Tax_ID__c);
        if (ProviderTypeCode == 'HCO'){
            ACETFindHCOAffiliationsWebservice ACETAffWS = new ACETFindHCOAffiliationsWebservice();
            ACETAffWS.Init(Interaction.Originator__r.EID__c, null, null, null);
            ACETAffWS.GetEndpoint();  
            AffDTWrapper = new ACETDatatableWrapper('ACETFindHCOAffiliationsWebservice', ACETAffWS);   
            AffDTWrapper.PageSize = ACETAffWS.PageSize;
            AffDTWrapper.IsSortEnabled = true;
            AffDTWrapper.Columns.add(new ACETDataTableWrapper.DataColumn('Name', 'affiliation'));
            AffDTWrapper.Columns.add(new ACETDataTableWrapper.DataColumn('Provider ID', 'providerId'));
            AffDTWrapper.Columns.add(new ACETDataTableWrapper.DataColumn('Primary Specialty', 'PrimarySpeciality'));
            AffDTWrapper.Columns.add(new ACETDataTableWrapper.DataColumn('Affiliation Effective Date', 'effective'));
        } else {
            ACETFindHCPAffiliationsWebservice ACETAffWS = new ACETFindHCPAffiliationsWebservice();
            ACETAffWS.Init(Interaction.Originator__r.EID__c, providerStatusCode);
            ACETAffWS.GetEndpoint();  
            AffDTWrapper = new ACETDatatableWrapper('ACETFindHCPAffiliationsWebservice', ACETAffWS);   
            AffDTWrapper.PageSize = ACETAffWS.PageSize;
            AffDTWrapper.IsSortEnabled = true;
            AffDTWrapper.Columns.add(new ACETDataTableWrapper.DataColumn('Affiliation', 'affiliation'));
            AffDTWrapper.Columns.add(new ACETDataTableWrapper.DataColumn('Provider ID', 'providerId'));
            AffDTWrapper.Columns.add(new ACETDataTableWrapper.DataColumn('Affiliation Effective Date', 'effective'));
        }  
        AffDTWrapper.PageStartNumber = 0;
        AffDTWrapper.PageNumber = 0;
        AffDTWrapper.StartRecord = 0;
        AffDTWrapper.initOnDocumentReady = false;
    }
    
    //added by Vishakha 11/17/2016
    public void getNumberOfProviderAlert() {
        ACETInteractionHighlightsPanelController alertNumber = new ACETInteractionHighlightsPanelController();
        if(Interaction != null){
            lstProviderAlert = alertNumber.getNoAlert('Provider',Interaction.Originator__r.EID__c,Interaction.Originator__r.Tax_ID__c);
            if(!lstProviderAlert.IsEmpty()){
                list<Interaction_Alert__c> lstIntAlert = new list<Interaction_Alert__c>();
                for(Alert__c varalert : lstProviderAlert){
                    Interaction_Alert__c intAlert = new Interaction_Alert__c();
                    intAlert.Alert__c = varAlert.id;
                    intAlert.Interaction__c = Interaction.id;
                    intAlert.ID_Number__c = Interaction.Originator__r.EID__c;// added by vishakha 11/30 for US442332
                    intAlert.Intercation_Alert_Unique_Id_del__c = String.valueof(varAlert.id)+String.valueof(Interaction.id)+ Interaction.Originator__r.EID__c;
                    lstIntAlert.add(intAlert); 
                }
                try{
                    Upsert lstIntAlert Intercation_Alert_Unique_Id_del__c ;//added by vishakha 12/09
                }
                Catch(DMLException ex){
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Exception during Insertion Interaction Alert.'));
                }
            }
        }
    }
    
    
    public void updateInterfromVccdParms() { 
        Interaction = ACETVCCDUtility.populateVCCDInfo(Interaction);
        update Interaction;
    }
    
    private void updateFastTrackProviderDetails(){
    
    //  Interaction
    
    }
    
    public class ACETProviderDetail 
    {
        public ACETProviderGeneralInfo generalInfo { get; set; }
        public List<ACETProviderSpeciality> specialities { get; set; }
        public List<ACETProviderUnitedPremium> unitedPremiums { get; set; }
        public List<ACETProviderAffiliation> affiliations { get; set; }
        public List<Degree> degrees { get; set; }
        public List<HoursOfOperation> hoursOfOperations { get; set; }
        public List<Language> languages { get; set; }
        public List<NPI> npis { get; set; }
        public list<providerLocationAffiliation> providerLocationAffiliations {get;set;}
        public ACETProviderDetail()
        {
            generalInfo  =  new ACETProviderGeneralInfo();
            specialities  =  new List<ACETProviderSpeciality>();
            unitedPremiums  =  new List<ACETProviderUnitedPremium>();
            affiliations  =  new List<ACETProviderAffiliation>();    
            degrees = new List<Degree>();
            hoursOfOperations = new List<HoursOfOperation>();
            languages = new List<Language>();
            npis = new List<NPI>();
            providerLocationAffiliations = new list<providerLocationAffiliation>();
        }
    }
    
    public class providerLocationAffiliation{
        public string id {get;set;}
    }
    
    public class ACETProviderGeneralInfo
    {
        public String lastName { get; set; }
        public String firstName { get; set; }
        public String PFS { get; set; }
        public String taxId { get; set; }
        public String npi { get; set; }
        public String phone { get; set; }
        public String providerID { get; set; }
        public String primaryPhysician { get; set; }
        public String newPatients { get; set; }
        public String paytoIndividual { get; set; }
        public String platinumProvider { get; set; }
        public String medicareId { get; set; }
        public String medicaidId { get; set; }
        public String providerType { get; set; }
        public String providerTINOwner { get; set; }
        public String hcoTypeCode { get; set; }
        public String providerTINTypeCode { get; set; }
        public String providerGenderCode { get; set; }
        public String providerBirthDate { get; set; }
        public String patientAgeRange { get; set; }
        public string pcpObgnId {get;set;}
        
    }
    
    public class NPI
    {
        public String npiName { get; set; }       
    }
     
    public class ACETProviderSpeciality
    {
        public String primarySpeciality { get; set; }
        public String speciality { get; set; }
        public String boardCert { get; set; }
        public String cancelDate { get; set; }
        public String statusCode{get;set;}
    }
    public class Degree 
    {
        public String code { get; set; }
        public String schoolName { get; set; }
    }
    
    public class HoursOfOperation
    {
        public String weekCode { get; set; }
        public String startTime1 { get; set; }
        public String endTime1 { get; set; }
        public String startTime2 { get; set; }
        public String endTime2 { get; set; }
    }
    
    public class Language 
    {
        public String languageStatusCode { get; set; }
        public String languageCode { get; set; }
        public String language { get; set; }
        public String languageSpokenByCode { get; set; }
        public String languageSpokenByDesc { get; set; }
        public String languageWrittenByCode { get; set; }
        public String languageWrittenByDesc { get; set; }
    }
    public class ACETProviderUnitedPremium
    {
        public String premiumDesignation { get; set; }
        public String premiumSpeciality { get; set; }
        public String effectiveDate { get; set; }
        public String premiumCancelDate { get; set; }
        public String efficiencyTypeDescription { get; set; }
        public String qualityTypeDescription { get; set; }
    }
    public class ACETProviderAffiliation
    {
        public string affiliation { get; set; }
        public string providerId { get; set; }
        public string effective { get; set; }
        public String PrimarySpeciality { get; set; }                
    }
    
    public List<SelectOption> CallTopicOptions{get; set;}
         
}