public with sharing class ACETProviderLookUpDetailController extends ACETErrorHandler{
    public Case StartDate { get; set; }
    public Case StartDateNew { get; set; }
    public String genInfoLanguage { get; set; }    
    public ACETProviderDetailController.ACETProviderDetail providerDetail  { get; set; }
    public List<SelectOption> languageOptions {get;set;}
    public List<ACETGetHCOJSON2Apex.specialty> lstspc { get; set; } //Added by Vinay for getHCO
    public List<ACETProviderDetailController.ACETProviderSpeciality> specialityLst  { get; set; }    
    public string NPIList {get;set;}
    public string LanguageList {get;set;}  
    public String Dummy  { get; set; }
    public ACETMemberDetail MemberDetail  { get; set; }    
    public ACETHighlightsPanelAdditionalInfo additionalInfo  { get; set; }
    public String benefitPlanId { get; set; }   
    public String Shownonpar  { get; set; }
    public boolean  isProviderLookupDetailsResult { get; set; }
    public Boolean FreeStandingFacl {get;set;}
    public list<ACETProviderLookupController.ProviderLookupResult> lstProviderLookup { get; set; } 
    public Boolean isErrorMessageAdded {get; set;}
    public list<ACETProviderContractResult> agreements  { get; set; }
    public String FindAgreementsMessage { get; set; }
    public string providerId { get; set; }
    public string providerType { get; set; }
    public string taxId { get; set; }
    public string npis { get; set; }
    public string sourceOriginator { get; set; }
    public Contact conObj { get; set; }
    public string memberId { get; set; }
    public string policyNumber { get; set; }
    public Interaction__c interaction { get; set; }
    public String hpAdditionInfoStr { get; set; }
    public list < PraticeInformation > lstPraticeInformation { get; set; }
    public set < SelectOption > networkOptions { get; set; }
    public String netWork { get; set; }
    public Boolean istProviderContratResult { get; set; }
    public boolean isContractControl { get; set; }
    public boolean disableContractType { get; set; }
    public string strType { get; set; }
    public string proferredCoverageGUID { get; set; }
    public list < ContrcatInfo > lstContrcat { get; set; }
    public ACETCallTopicsDataWrapper wrapper { get; set; }
    public ACETCaseItemWrapper caseItem  { get; set; }
    public string networkval {get;set;}
    public string claimType {get;set;}
    public boolean memId {get;set;}
    public Boolean updatePCPBool {get;set;}
    public Boolean addressBool {get;set;}
    //Added the variable as a part of US1234488 by Avish on 09/12/2018
    public String pcpLocatorID {get;set;}
	
	public String labTypeCode {get;set;}
 //
   // public Boolean renderName {   //Commented Due to Argument 2 cannot be null Error
    //    get {
    //        return optSelected == 'Active';
    //    }
   // }
    public String optSelected { get; set; }
    public list <CurrentPhysician> lstCurrentPhysician { get; set; }
    public list <NewPhysician> lstNewPhysician { get; set; }
    public String benefitPlanIdStr;
    
    Transient ACETGetHCOWebservice ACETGetHCOWS;
    Transient ACETGetHCPWebservice ACETGetHCPWS;  
    ACETFindAgreementsWebservice ACETFindAgreementsWS;
    public Transient ACETDatatableWrapper AddrDTWrapper { get; set; }     //Used by pagination component
    public Transient ACETDatatableWrapper AffDTWrapper { get; set; }     //Used by pagination component
    public Transient ACETDatatableWrapper AgrmntsDTWrapper { get; set; }     //Used by pagination component
       
    public String providerTINTypeCodeParam { get; set; }
    public String addressIdParam { get; set; }
    public String addressTypeCodeParam { get; set; }
    public String providerTINParam { get; set; }
    public String returningFromServiceParam;
    public String providerStatusCodeParam,providerTINStatusCodeParam;
    public String pcpOBGYNLst{get;set;}
    public string AttributeSet {get; set;}
    public string membNetwork{get;set;}
    public String affiliationAddress {get;set;}
    public String PCPRole1{get;set;}
    public String pcpLocationAffiliationID{get;set;}
    public List < SelectOption > radioValues {
        get {
            List < SelectOption > resList = new List < SelectOption > ();
            resList.add(new SelectOption('Active', 'Active'));
            resList.add(new SelectOption('All', 'All'));
            return resList;
        }
    }
    
    //code to make asynchronous callout
    public Object CallWSOnPageLoad1(){
        Continuation PageLoadContinuation;
        if (providerType == 'Facility') {
            ACETGetHCOWS = new ACETGetHCOWebservice();
           PageLoadContinuation = ACETGetHCOWS.StartRequest(providerId, taxId, providerStatusCodeParam, providerTINStatusCodeParam, providerTINTypeCodeParam, addressIdParam, addressTypeCodeParam, returningFromServiceParam, 'CallWSOnPageLoadCallback1', null);
        } else {
            ACETGetHCPWS = new ACETGetHCPWebservice();
            PageLoadContinuation = ACETGetHCPWS.StartRequest(providerId, taxId, providerTINTypeCodeParam, addressIdParam, addressTypeCodeParam,'providerLookup', 'CallWSOnPageLoadCallback1', null);
        }       
         
        //Added by Vinay for US668672 show par and non-par on 06162017
        if(Shownonpar == 'true'){
            benefitPlanIdStr = '';
        }else{
            benefitPlanIdStr = benefitPlanId;
        }
        
        return PageLoadContinuation; 
    }   
    
    public PageReference CallWSOnPageLoadCallback1() {
        system.debug(LoggingLevel.INFO, 'Inside CallWSOnPageLoadCallback. ProviderTypeCode: ' + providerType);
        ACETWSCalloutResult GetProviderCalloutResult, FindAgreementsCalloutResult;
     //   if(Interaction.Originator_Type__c != 'Other'){
            if (providerType == 'Facility') {
                GetProviderCalloutResult = ACETGetHCOWS.ProcessResponse(null, ACETGetHCOWS.RequestLabel);
            } else if(providerType == 'Physician') {
                
                GetProviderCalloutResult = ACETGetHCPWS.ProcessResponse(returningFromServiceParam, ACETGetHCPWS.RequestLabel);
                system.debug(LoggingLevel.INFO,'GetProviderCalloutResult.Response*** ' + GetProviderCalloutResult.Response);
            }
            providerDetail = (ACETProviderDetailController.ACETProviderDetail)GetProviderCalloutResult.Response; 
            integer count=1;
            NPIList = '';
            if (providerType == 'Facility') {
                if(providerDetail != null && providerDetail.npis!=null){                    
                for(ACETProviderDetailController.NPI npi: providerDetail.npis){
                    if(npi.npiName != null && npi.npiName != ''){ 
                        if(count <=10){
                            if(math.mod(count, 3)==0){
                                NPIList += npi.npiName+'\n';
                            }else{
                                NPIList += npi.npiName+',';
                            }
                        count++;
                        }
                    }
                }                  
                    NPIList = !String.isBlank(NPIList) ? NPIList.substring(0,NPIList.length()-1) : '';
             }
            }else {
                LanguageList = '';
                if(providerDetail != null && providerDetail.languages != null){
                    for(ACETProviderDetailController.Language lang: providerDetail.languages){
                        system.debug(LoggingLevel.INFO,'lang***'+lang.language);
                        if(lang.language != null && lang.language != ''){ 
                            LanguageList += lang.language+','; 
                        }
                    }
                    LanguageList = !String.isBlank(LanguageList) ? LanguageList.substring(0,LanguageList.length()-1) : '';
                }
                pcpOBGYNLst = '';
                if(providerDetail != null && providerDetail.providerLocationAffiliations != null){
                    for(ACETProviderDetailController.providerLocationAffiliation locatorAffliation: providerDetail.providerLocationAffiliations){
                        system.debug(LoggingLevel.INFO,'locatorAffliation***'+locatorAffliation.id);
                        if(locatorAffliation.id != null && locatorAffliation.id  != ''){ 
                            pcpOBGYNLst += locatorAffliation.id+','; 
                        }
                    }
                    pcpOBGYNLst = !String.isBlank(pcpOBGYNLst) ? pcpOBGYNLst.substring(0,pcpOBGYNLst.length()-1) : '';
                }               
            } 
            
            //Added by Avish on 07142017
            if(String.isNotBlank(GetProviderCalloutResult.Message)) {                
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, GetProviderCalloutResult.Message));
            }                 
      //  }
          if(String.isNotBlank(affiliationAddress) && affiliationAddress == 'I' && String.isNotBlank(PCPRole1)) {                
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'PCP update is not allowed for a provider not actively affiliated with the selected address.'));
            }
        return null;
    }   
    
    public ACETProviderLookUpDetailController() {
        ACETFindAgreementsWS = new ACETFindAgreementsWebservice();
        ACETGetHCOWS = new ACETGetHCOWebservice();
        ACETGetHCPWS = new ACETGetHCPWebservice();
        ACETFindAgreementsWS = new ACETFindAgreementsWebservice();
        providerDetail=new ACETProviderDetailController.ACETProviderDetail();
        StartDate = new Case();
        StartDateNew = new Case();   
        languageOptions = new list<SelectOption>();
        lstCurrentPhysician = new list <CurrentPhysician> (); 
        lstPraticeInformation = new list < PraticeInformation > ();
        //optSelected = 'Active'; //Commented Due to Argument 2 cannot be null Error
        
        String interactionId = ApexPages.currentPage().getParameters().get('interactionId');
        providerId = ApexPages.currentPage().getParameters().get('providerId');
        providerType = ApexPages.currentPage().getParameters().get('providerType');
        taxId = ApexPages.currentPage().getParameters().get('taxId');
        string surrogateKey = ApexPages.currentPage().getParameters().get('SRK');
        wrapper = new ACETCallTopicsDataWrapper();
        wrapper.init();
        if (!String.isEmpty(surrogateKey)){ 
            wrapper.surrogateKey = surrogateKey;
        }  
        wrapper.CaseObj.Topic__c = 'Provider Lookup';
        claimType = ApexPages.currentPage().getParameters().get('claimType');
        networkval = ApexPages.currentPage().getParameters().get('varnetworkval');
        benefitPlanId  = ApexPages.currentPage().getParameters().get('benefitPlanId');
        ShowNonPar  = ApexPages.currentPage().getParameters().get('ShowNonPar');
        affiliationAddress = ApexPages.currentPage().getParameters().get('affiliationAddress');
        pcpLocationAffiliationID = ApexPages.currentPage().getParameters().get('pcpObgnID');
        system.debug(LoggingLevel.Info,'benefitPlanId:: ' + benefitPlanId);        
        system.debug(LoggingLevel.Info,'ShowNonPar:: ' + ShowNonPar);
        system.debug(LoggingLevel.Info,'affiliationAddress:: ' + affiliationAddress); 
        
        String providerResultInfo = ApexPages.currentPage().getParameters().get('ProviderObjJson');
       
        String fullName1 = ApexPages.currentPage().getParameters().get('FacilityName');
        String providerId1  = ApexPages.currentPage().getParameters().get('providerId');
        String providerType1 = ApexPages.currentPage().getParameters().get('providerType');
        String status1 = ApexPages.currentPage().getParameters().get('status');
        
        String taxId1 = ApexPages.currentPage().getParameters().get('taxId');
        String ssn1 = ApexPages.currentPage().getParameters().get('ssn');
        String address1 = ApexPages.currentPage().getParameters().get('address');
        String phoneNumber1 = ApexPages.currentPage().getParameters().get('phoneNumber');
        String Platinum1 =  ApexPages.currentPage().getParameters().get('Platinum');
        system.debug(LoggingLevel.INFO,'Platinum1***'+Platinum1);
        String speciality1 = ApexPages.currentPage().getParameters().get('speciality');
        String gender1 = ApexPages.currentPage().getParameters().get('gender');
        String network1 = ApexPages.currentPage().getParameters().get('network');
        String affiliation1 = ApexPages.currentPage().getParameters().get('affiliation');
        String tieredBenefit = ApexPages.currentPage().getParameters().get('tieredBenefit');
        String uphd1 = ApexPages.currentPage().getParameters().get('uphd');
        PCPRole1 = ApexPages.currentPage().getParameters().get('PCPRole');
        string radious1 = ApexPages.currentPage().getParameters().get('radious');
        string acceptNewPatient1 =  ApexPages.currentPage().getParameters().get('acceptNewPatient');
        string Owner1 =  ApexPages.currentPage().getParameters().get('owner');//Added by Vinay for getHCO
        string hcoTypeCode1 =  ApexPages.currentPage().getParameters().get('hcoTypeCode'); //Added by Vinay for getHCO
        isProviderLookupDetailsResult = false;
        if(ApexPages.currentPage().getParameters().get('isProviderLookupDetailsResult')=='True'){
            isProviderLookupDetailsResult = true;
        }
        
        //Added the variable as a part of US588701 by Avish 04/07/2017
        providerTINTypeCodeParam = ApexPages.currentPage().getParameters().get('providerTINTypeCode');
        addressIdParam = ApexPages.currentPage().getParameters().get('addressId');
        addressTypeCodeParam   = ApexPages.currentPage().getParameters().get('addressTypeCode');
        providerStatusCodeParam = ApexPages.currentPage().getParameters().get('providerStatusCode');
        providerTINStatusCodeParam = ApexPages.currentPage().getParameters().get('providerTINStatusCode');
        providerTINParam = ApexPages.currentPage().getParameters().get('providerTIN');
        returningFromServiceParam = ApexPages.currentPage().getParameters().get('returningFromService');
        
        //Added the variable as a part of US1234488 by Avish on 09/12/2018
        pcpLocatorID = ApexPages.currentPage().getParameters().get('pcpLocatorID');
        
        //Check if User is redirected to Member Search page from Provider detail page  
        lstProviderLookup     = new list<ACETProviderLookupController.ProviderLookupResult>();   
        
		labTypeCode = ApexPages.currentPage().getParameters().get('labTypeCd');														 
        ACETProviderLookupController.ProviderLookupResult objProviderResult = new ACETProviderLookupController.ProviderLookupResult();
        objProviderResult.acceptNewPatient  = acceptNewPatient1 ;
        objProviderResult.radious = radious1 ;
        objProviderResult.uphd= uphd1;
        objProviderResult.PCPRole= PCPRole1;
        if(objProviderResult.PCPRole != null && objProviderResult.PCPRole != ''){
            updatePCPBool = true;
        } else {
            updatePCPBool = false;
        }
        objProviderResult.affiliation = affiliation1 ;
        objProviderResult.network= network1;
        objProviderResult.gender= gender1;
        objProviderResult.speciality = speciality1 ;
        objProviderResult.phoneNumber  = phoneNumber1 ;
        objProviderResult.Platinum  = Platinum1 ;
        objProviderResult.owner  = Owner1 ;
        objProviderResult.hcoTypeCode  = hcoTypeCode1 ;
        objProviderResult.address = address1 ;
        objProviderResult.ssn  = ssn1 ;
        objProviderResult.fullName  = fullName1;
        
        objProviderResult.providerId= providerId1;
        objProviderResult.providerType = providerType1 ;
        objProviderResult.status  = status1 ;
        objProviderResult.taxId = taxId1;
        objProviderResult.tieredBenefit = tieredBenefit;
        objProviderResult.providerLocationAffiliationsStatusCode = affiliationAddress;
		objProviderResult.labTypeCode = labTypeCode;
        if(objProviderResult.providerLocationAffiliationsStatusCode != null && objProviderResult.providerLocationAffiliationsStatusCode != '') {
            addressBool = true;
        } else {
             addressBool = false;
        }
        objProviderResult.pcpObgnID = pcpLocationAffiliationID;
        lstProviderLookup.add(objProviderResult);
        if (!String.isEmpty(interactionId)) {
            interaction = ACETProviderUtility.GetInteractionByID(interactionId);
            sourceOriginator = Interaction.Interaction_Type__c;
        }
        String contactId = ApexPages.currentPage().getParameters().get('contactId');
        if (!String.isEmpty(contactId)) {
            conObj = ACETProviderUtility.GetContactByID(contactId);
        }
        
        if (!String.isEmpty(contactId)) {
            conObj = ACETProviderUtility.GetContactByID(contactId);
            memberId = conObj.EID__c;
        }
        String additionalInfostr = ApexPages.currentPage().getParameters().get('additionalInfo');
        if (!String.isEmpty(additionalInfostr)) {
            additionalInfo = (ACETHighlightsPanelAdditionalInfo) JSON.deserialize(additionalInfostr, ACETHighlightsPanelAdditionalInfo.class);
            policyNumber = additionalInfo.PolicyNumber;
            hpAdditionInfoStr = JSON.serialize(additionalInfo);
        }      
        if((objProviderResult.PCPRole != null && objProviderResult.PCPRole != '') && (AdditionalInfo.MemberId != null ||Interaction.Originator_Type__c == 'Provider')){
            updatePCPBool = true;
        } else {
            updatePCPBool = false;
        }     
        FindAgreementsMessage = Label.ACETNoRecordErrorMessage;
        if(additionalInfo != null && additionalInfo.Network!=Null){
            membNetwork  =(additionalInfo.Network.contains('_'))?additionalInfo.Network.split('_')[0]:additionalInfo.Network;
            
        }
    }
    
        Public void onPageLoad(){
        MemberDetail = new ACETMemberDetail();
        MemberDetail.PreferredCoverage = new ACETMemberDetail.CoverageLine();
        findMemberships(); //Commented Due to Argument 2 cannot be null Error
        system.debug(LoggingLevel.INFO,'2323Memerdetailpcp' + MemberDetail.PCPAssignments);
        lstNewPhysician = new list <NewPhysician> (); 
        NewPhysician objNewPhysician = new NewPhysician();
        
        agreements = new list<ACETProviderContractResult>();
        
        if(MemberDetail.PCPAssignments != null){
            for(ACETMemberDetail.PCPAssignment pcp : MemberDetail.PCPAssignments){
                CurrentPhysician objCurrentPhysician = new CurrentPhysician();  
                objCurrentPhysician.isChecked = false;
                objCurrentPhysician.firstName = pcp.FirstName;
                objCurrentPhysician.lastName = pcp.LastName;  
                objCurrentPhysician.pcpAssignmentType = pcp.pcpAssignmentType;
                objCurrentPhysician.effDate = pcp.effectiveDate;
                objCurrentPhysician.pcpid = pcp.id;
                objCurrentPhysician.pcptype = pcp.identifiertype;                   
                lstCurrentPhysician.add(objCurrentPhysician);   
        }
        }
      
             
    }
    public void findMemberships(){
        if(additionalInfo!= null && additionalInfo.MemberId != null){
        String Id = ApexPages.currentPage().getParameters().get('Id');
        MemberDetail.SurrogateKey = ApexPages.currentPage().getParameters().get('SRK'); //894666785
        string groupNumber = ApexPages.currentPage().getParameters().get('grpnum');
        if(!String.isEmpty(MemberDetail.SurrogateKey)){
            if(MemberDetail != null){
            ACETFindMemCustPurchaseWebservice fmcp = new ACETFindMemCustPurchaseWebservice();
            ACET_WebserviceCalloutFramework wsCallOutFW = new ACET_WebserviceCalloutFramework('Find Membership Customer Purchases API', ACETFindMemCustPurchaseWebservice.getRequestBody(MemberDetail), null);
            HttpResponse response = wsCallOutFW.getResponse();
            ACETWSCalloutResult calloutResult = fmcp.findMembership(Id, MemberDetail,response.getBody());            
                ACETGetMembershipWebService stub2 = new ACETGetMembershipWebService();
                ACETWSCalloutResult calloutResult2 = stub2.getMembership(MemberDetail.SurrogateKey,groupNumber,MemberDetail);
                    if(calloutResult2 != null && calloutResult2.Success != null && calloutResult2.Success == true){
                        MemberDetail = (ACETMemberDetail)calloutResult2.Response;
            } 
        } 
            } 
        else{
        ACETFindMemCustPurchaseWebservice fmcp = new ACETFindMemCustPurchaseWebservice();
            ACET_WebserviceCalloutFramework wsCallOutFW = new ACET_WebserviceCalloutFramework('Find Membership Customer Purchases API', ACETFindMemCustPurchaseWebservice.getRequestBody(MemberDetail), null);
            HttpResponse response = wsCallOutFW.getResponse();
            ACETWSCalloutResult calloutResult = fmcp.findMembership(Id, MemberDetail,response.getBody()); 
                      
            //some fields for coverage lines depends on getMembership service         
            ACETGetMembershipWebService stub2 = new ACETGetMembershipWebService();
            ACETWSCalloutResult calloutResult2 = stub2.getMembership(Id,'',MemberDetail); 
                if(calloutResult2 != null && calloutResult2.Success != null && calloutResult2.Success == true){
                    MemberDetail = (ACETMemberDetail)calloutResult2.Response;
                }
            }
        }  
    }
        //Added for the user story US1093895
         public void CallFindAgreements() {

            ACETFindAgreementsWebservice AgrementsWS = new ACETFindAgreementsWebservice();
            AgrementsWS.Init(providerId, taxId, providerTINTypeCodeParam, addressIdParam, addressTypeCodeParam,benefitPlanIdStr,'','');
            AgrementsWS.GetEndpoint();  
            AgrmntsDTWrapper  = new ACETDatatableWrapper('ACETFindAgreementsWebservice', AgrementsWS);   
            AgrmntsDTWrapper.PageSize = AgrementsWS.PageSize;
            AgrmntsDTWrapper.IsSortEnabled = true;
           // AgrmntsDTWrapper.Columns.add(new ACETDataTableWrapper.DataColumn('Plan Type', 'Product'));
            AgrmntsDTWrapper.Columns.add(new ACETDataTableWrapper.DataColumn('Active', 'Contract_Status'));
            AgrmntsDTWrapper.Columns.add(new ACETDataTableWrapper.DataColumn('Network ID', 'Network_ID'));
            AgrmntsDTWrapper.Columns.add(new ACETDataTableWrapper.DataColumn('Network Name', 'Network_Name'));
            AgrmntsDTWrapper.Columns.add(new ACETDataTableWrapper.DataColumn('Process Order', 'process_Order_Number'));
           // AgrmntsDTWrapper.Columns.add(new ACETDataTableWrapper.DataColumn('Network Schedule ID', 'NetworkSchedule'));
           // AgrmntsDTWrapper.Columns.add(new ACETDataTableWrapper.DataColumn('Benefit Plan ID', 'BenefitPlanId'));
            AgrmntsDTWrapper.Columns.add(new ACETDataTableWrapper.DataColumn('Organization Name', 'organizationName'));
            AgrmntsDTWrapper.Columns.add(new ACETDataTableWrapper.DataColumn('Pricing Set ID', 'Pricing_Set_ID'));
            //AgrmntsDTWrapper.Columns.add(new ACETDataTableWrapper.DataColumn('Status', 'Contract_Status'));
            AgrmntsDTWrapper.Columns.add(new ACETDataTableWrapper.DataColumn('Contract ID', 'ContractDetailId'));
            AgrmntsDTWrapper.Columns.add(new ACETDataTableWrapper.DataColumn('Effective', 'Effective'));
            AgrmntsDTWrapper.Columns.add(new ACETDataTableWrapper.DataColumn('Cancel', 'Cancel'));
            if(lstProviderLookup[0].providerType == 'Physician'){
              AgrmntsDTWrapper.Columns.add(new ACETDataTableWrapper.DataColumn('Accepting New Patients', 'Accepting_New_Patients'));
              AgrmntsDTWrapper.Columns.add(new ACETDataTableWrapper.DataColumn('Assignment Type', 'ProviderAssignmentType'));
            }
            //AgrmntsDTWrapper.Columns.add(new ACETDataTableWrapper.DataColumn('', ''));
            AgrmntsDTWrapper.Columns.add(new ACETDataTableWrapper.DataColumn('Provider Assignment', 'providerAssignmentIndicator'));
            if(lstProviderLookup[0].providerType == 'Facility'){
                AgrmntsDTWrapper.Columns.add(new ACETDataTableWrapper.DataColumn('', ''));
                AgrmntsDTWrapper.Columns.add(new ACETDataTableWrapper.DataColumn('', ''));
            }
            AgrmntsDTWrapper.PageStartNumber = 0;
            AgrmntsDTWrapper.PageNumber = 0;
            AgrmntsDTWrapper.StartRecord = 0;
            AgrmntsDTWrapper.initOnDocumentReady = false;
            AgrmntsDTWrapper.defaultSortBy = 2;
    }
    public void CallFindMedicalProvider() {
        system.debug(LoggingLevel.INFO, 'Provider Type: ' + providerType + ', Provider Id: ' + providerId + ', Tax Id: ' + taxId);        
        if (providerType == 'Facility') {
            ACETFindHCOWebservice ACETAddrWS = new ACETFindHCOWebservice();
            ACETAddrWS.Init(providerId, null, taxId, null, null, null, null, null, null, null,null,null,null,null,null,null,null,AttributeSet,'false',false);
            ACETAddrWS.GetEndpoint();  
            AddrDTWrapper = new ACETDatatableWrapper('ACETFindHCOWebservice', ACETAddrWS);
            AddrDTWrapper.PageSize = ACETAddrWS.PageSize;   
        } else {
            ACETFindHCPWebservice ACETAddrWS = new ACETFindHCPWebservice();
            ACETAddrWS.Init(providerId, null, taxId, null, null, null, null,null,null, null, null, null, null, null, null, null,null,null,null,null,null,null,null,null,AttributeSet,'false');
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
        AddrDTWrapper.Columns.add(new ACETDataTableWrapper.DataColumn('', 'email'));
    }
    
    public void CallFindAffiliations() {
        system.debug(LoggingLevel.INFO, 'Provider Type: ' + providerType + ', Provider Id: ' + providerId + ', Provider Status Code Param: ' + providerStatusCodeParam);
        if (providerType == 'Facility'){
            ACETFindHCOAffiliationsWebservice ACETAffWS = new ACETFindHCOAffiliationsWebservice();
            ACETAffWS.Init(providerId, null, null, null);
            ACETAffWS.GetEndpoint();  
            AffDTWrapper = new ACETDatatableWrapper('ACETFindHCOAffiliationsWebservice', ACETAffWS);   
            AffDTWrapper.PageSize = ACETAffWS.PageSize;
            AffDTWrapper.IsSortEnabled = true;
            AffDTWrapper.Columns.add(new ACETDataTableWrapper.DataColumn('Name', 'affiliation'));
            AffDTWrapper.Columns.add(new ACETDataTableWrapper.DataColumn('Provider ID', 'providerId'));
            AffDTWrapper.Columns.add(new ACETDataTableWrapper.DataColumn('Primary Specialty', 'PrimarySpeciality'));
            AffDTWrapper.Columns.add(new ACETDataTableWrapper.DataColumn('Affiliation Effective Date', 'effective'));
            AffDTWrapper.Columns.add(new ACETDataTableWrapper.DataColumn('', 'EFFECTIVE'));
        } else {
            ACETFindHCPAffiliationsWebservice ACETAffWS = new ACETFindHCPAffiliationsWebservice();
            ACETAffWS.Init(providerId, providerStatusCodeParam);
            ACETAffWS.GetEndpoint();  
            AffDTWrapper = new ACETDatatableWrapper('ACETFindHCPAffiliationsWebservice', ACETAffWS);   
            AffDTWrapper.PageSize = ACETAffWS.PageSize;
            AffDTWrapper.IsSortEnabled = true;
            AffDTWrapper.Columns.add(new ACETDataTableWrapper.DataColumn('Affiliation', 'affiliation'));
            AffDTWrapper.Columns.add(new ACETDataTableWrapper.DataColumn('Provider ID', 'providerId'));
            AffDTWrapper.Columns.add(new ACETDataTableWrapper.DataColumn('Affiliation Effective Date', 'effective'));
            AffDTWrapper.Columns.add(new ACETDataTableWrapper.DataColumn('', 'EFFECTIVE'));
        }  
        AffDTWrapper.PageStartNumber = 0;
        AffDTWrapper.PageNumber = 0;
        AffDTWrapper.StartRecord = 0;
        AffDTWrapper.initOnDocumentReady = false;
        AffdTWrapper.IsSortEnabled = true;
    }
    
    /*Call for UpdateindividualMembership*/
     public PageReference UpdatePCPOBGYN()   {
        
        String memberId = additionalInfo.MemberId;
        String scrId = ApexPages.currentPage().getParameters().get('scrId');
        String groupNumber= additionalInfo.GroupNumber;
        String lastName= additionalInfo.LastName;
        String firstname= additionalInfo.FirstName;
        String ssn = ApexPages.currentPage().getParameters().get('ssnId');
        String gender=additionalInfo.Gender;
        string dob=additionalInfo.DOB;
        string relationshipcode= ApexPages.currentPage().getParameters().get('rl');
        String currentpcpId;
        String currentpcptype;
        String currentpcpAssignmentType;
        String currentpcpeffectiveEndDate;
        String currentpcpeffectiveStartDate;
        
        List<ACETMemberDetail.Phone> PhoneList;
        for(CurrentPhysician cp : lstCurrentPhysician){
            if(cp.isChecked == true){           
                currentpcpId=cp.pcpid;
                currentpcptype=cp.pcptype;
                currentpcpAssignmentType=cp.pcpAssignmentType;
                Date EffDate = Date.parse(cp.effDate);
                system.debug(LoggingLevel.INFO,'232323effdate'+string.valueOf(EffDate));
                currentpcpeffectiveStartDate = ACETUtility.formatDatewithslash(cp.effDate);
                currentpcpeffectiveEndDate = ACETUtility.formatDateYYYYMMDD(string.valueOf(cp.CaseEndDate.tst_Date_Field__c));
            }
        }
      
        String newpcpId=providerDetail.generalInfo.npi;
        String newpcptype='NPI';
        String newpcpAssignmentType=lstProviderLookup[0].PCPRole;
        if(newpcpAssignmentType != null)
            newpcpAssignmentType = newpcpAssignmentType.trim();
        String newpcpEffectiveStartDate = ACETUtility.formatDateYYYYMMDD(string.valueOf(StartDateNew.tst_Date_Field__c));
        ACETUpdateIndividualWebService UpdIndWebsrevice = new ACETUpdateIndividualWebService();  
        //Added by Avish on 09/20/2018       
        system.debug(LoggingLevel.INFO,'providerDetail.generalInfo.npi@@@ ' + providerDetail.generalInfo.npi);
        String npiType='';
        String npiVal = '';
        if(String.isNotBlank(providerDetail.generalInfo.providerType)){
            npiType = 'NPI';                 
        }   
        
        if(String.isNotBlank(providerDetail.generalInfo.npi)){
            npiVal  = providerDetail.generalInfo.npi; 
        }   
        String existpatientindicator; 
        if(lstProviderLookup[0].existpatient!=Null && lstProviderLookup[0].existpatient==true){
            existpatientindicator='Y';
        }else{
            existpatientindicator='';
        }     
        //End    
//DE383511 : Added null checks for FirstName and LastName
         if(lastName !=null && firstName !=null && firstName !='' && lastName !='' && firstName !='null' && lastName !='null'){
        if(currentpcpeffectiveEndDate!='' && currentpcpeffectiveEndDate != null){
                //Added the variable as a part of US1234488 by Avish on 09/12/2018
                if(String.isNotBlank(pcpLocatorID)){
                    system.debug(LoggingLevel.INFO,'provider Type@@@ ' + providerDetail.generalInfo.providerType);
                    currentpcpId = pcpLocatorID;
                    if(providerDetail.generalInfo.providerType == 'Physician')
                        newpcpAssignmentType = 'PCP';                    
                }else{
                    currentpcpId = pcpOBGYNLst;
                    system.debug(LoggingLevel.INFO,'provider Type@@@ ' + providerDetail.generalInfo.providerType);
                    if(providerDetail.generalInfo.providerType == 'Physician')
                        newpcpAssignmentType = 'PCP';                    
                }   
                     
                ACETWSCalloutResult TermCalloutResult = UpdIndWebsrevice.updateMembers(memberId,  scrId, groupNumber, lastName, firstname, '', '', ssn, gender, dob, relationshipcode, '', '', '', PhoneList, currentpcpId, currentpcptype, currentpcpAssignmentType, currentpcpeffectiveStartDate, currentpcpeffectiveEndDate,npiType,npiVal,existpatientindicator);
                if (TermCalloutResult.Success)
                {
                    //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM,'Termination Successful'));
                    setErrorMsg('GN211',null); 

                }
                else
                {
                    //ApexPages.addMessage(new ApexPages.Message(TermCalloutResult.MessageSeverity,TermCalloutResult.Message));
                    setErrorMsg('GN'+TermCalloutResult.statusCode,null); 

                }   
        }
          //DE383511 : Added null checks for FirstName and LastName
        if(newpcpEffectiveStartDate!='' && newpcpEffectiveStartDate!=null){
            
                //Added the variable as a part of US1234488 by Avish on 09/12/2018
                if(String.isNotBlank(pcpLocatorID)){
                    system.debug(LoggingLevel.INFO,'provider Type@@@ ' + providerDetail.generalInfo.providerType);
                    newpcpId = pcpLocatorID;
                    if(providerDetail.generalInfo.providerType == 'Physician')
                        newpcpAssignmentType = 'PCP';
                }else{
                    newpcpId = pcpOBGYNLst;
                    system.debug(LoggingLevel.INFO,'provider Type@@@ ' + providerDetail.generalInfo.providerType);

                    //if(providerDetail.generalInfo.providerType == 'Physician')
                        //newpcpAssignmentType = 'PCP';                    
                }  
                        
                ACETWSCalloutResult UpdateCalloutResult = UpdIndWebsrevice.updateMembers(memberId,  scrId, groupNumber, lastName, firstname, '', '', ssn, gender, dob, relationshipcode, '', '', '', PhoneList, newpcpId, newpcptype, newpcpAssignmentType, newpcpEffectiveStartDate, '9999-12-31',npiType,npiVal,existpatientindicator);
                //UpdateCalloutResult.statusCode = 200;
                ACETUpdIndividualMemResJSON2Apex callResp = (ACETUpdIndividualMemResJSON2Apex)UpdateCalloutResult.response;
                
                if (UpdateCalloutResult.Success !=null && UpdateCalloutResult.Success)
                {
                    if(callResp != null && callResp.UpdateIndividualMembershipResponse != null && callResp.UpdateIndividualMembershipResponse.response != null && callResp.UpdateIndividualMembershipResponse.response.responseCode!= null && callResp.UpdateIndividualMembershipResponse.response.responseCode == '200'){
                    //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM,'Update Successful'));
                    setErrorMsg('GN'+UpdateCalloutResult.statusCode,null); //200--> Update Successful   
                    } else {
                        setErrorMsg('GN208',null);
                    }
                }
                else
                {
                    ApexPages.addMessage(new ApexPages.Message(UpdateCalloutResult.MessageSeverity,UpdateCalloutResult.Message));
                    
            if(UpdateCalloutResult.statusCode!=207)
                      setErrorMsg('GN'+UpdateCalloutResult.statusCode,null); 
                    else
                     setErrorMsg('PCP'+UpdateCalloutResult.statusCode,null); }               
        }
         }
         else
             ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,'Unexpected error occurred.')); 
            
   		return null;
    }
    
    public class CurrentPhysician {
        
        public CurrentPhysician(){
            CaseEndDate = new Case();
        }
        
        public string firstName {
            get;
            set;
        }
        public Boolean isChecked {
            get;
            set;
        }  
        public string lastName {
            get;
            set;
        }
        public string pcpAssignmentType {
            get;
            set;
        }
        public string effDate {
            get;
            set;
        }
       public Date EndDate {
            get; set;}
           
         public string pcpid {
            get;
            set;
        }
         public string pcptype {
            get;
            set;
        }
        public Case CaseEndDate { get; set; }
    } 
    public class NewPhysician {
        public string Name {
            get;
            set;
        }
        public string Network {
            get;
            set;
        }
        public string Address {
            get;
            set;
        }
        public string PhoneNo {
            get;
            set;
        }
        public string Speciality {
            get;
            set;
        }
        public string pcpNewAssignmentType {
            get;
            set;
        }  
        public string newEffDate {
            get;
            set;
        }  
    } 
    public class ProviderDemographics {
        public string addressType {
            get;
            set;
        }
        public string address {
            get;
            set;
        }
        public string phone {
            get;
            set;
        }
        public string fax {
            get;
            set;
        }
        public string email {
            get;
            set;
        }
        public string County {
            get;
            set;
        }
    }
    public class ACETactiveAffiliationsResult {
        public string affiliation {get; set;}
        public string providerID {get; set;}
        public string effective {get; set;}
    }
    
    public class PraticeInformation {
        public string speciality {
            get;
            set;
        }
        public string status {
            get;
            set;
        }
        public string network {
            get;
            set;
        }
        public string panel {
            get;
            set;
        }
        public string pratiseStartDate {
            get;
            set;
        }
        public string patientAgeRange {
            get;
            set;
        }
        public string extendedHours {
            get;
            set;
        }
    }
    
    public class Credencialing {
        public string qualification {
            get;
            set;
        }
        public string affilation {
            get;
            set;
        }
        public string providerRep {
            get;
            set;
        }
        public string uhn {
            get;
            set;
        }
        public string pti {
            get;
            set;
        }
    }
    
    public class UnitedHealthPremium {
        public string premiumDesigination {
            get;
            set;
        }
        public string premiumSpeciality {
            get;
            set;
        }
        public string effective {
            get;
            set;
        }
        public string cancel {
            get;
            set;
        }
    }
    
    public class ContrcatInfo {
        
        public string product {
            get;
            set;
        }
        public string networkID {
            get;
            set;
        }
        public string networkName {
            get;
            set;
        }
        public string networkStatus {
            get;
            set;
        }
        public string feeRegion {
            get;
            set;
        }
        
        public string effective {
            get;
            set;
        }
        public string cancel {
            get;
            set;
        }
        public string Capitation {
            get;
            set;
        }
        public string acceptingNewPatient {
            get;
            set;
        } 
        public string AgreementStatusCode{
            get;
            set;
        }       
       
    }
}