public without sharing class ACETMemberSearchController {    
    public ACETDatatableWrapper DTWrapper {get;set;}
    public String SourceOriginator {get;set;}
    public Interaction__c Interaction { get; set; } 
    public Contact Provider {get;set;}  
    public String MemberId {get;set;}
    public String FirstName {get;set;}
    public String dateOfBirth{get;set;}
    public String LastName {get;set;}
    public String ZipCode {get;set;}
    public String State {get;set;}
    public Interaction__c CaseStub {get;set;}
    public boolean isMisdirectCaseCreation{get;set;}
    public ACETCallTopicsDataWrapper wrapper {get;set;}
    
    public List<ACETMemberSearchResult> Results {get;set;}
    public map<String,ACETMemberSearchResult> mapResults{get;set;}
    public ACETMemberSearchResult selectedResult{get;set;}
    
    public String SortBy {get;set;}
    public String SortOrder {get;set;}
    public String LastSortBy{get;set;}
    public Boolean IsShowMisdirectedCall {get;set;}
    public String Comments {get;set;}     
    public String MisdirectedReason {get;set;}
    public String ClosedReason {get;set;}
        
    public String ErrorMessage {get;set;}
    public String groupId{ get; set; }
    public ACETDynatrace ACETDynatraceDetails { get; set; }
    public String addInfo;
    public String IsMemberListing{get;set;}
    public String IsGroupDetail{get;set;}
    public Boolean IsGoToLink {get;set;}
    public string isFromProducer{get;set;}
    public Boolean IsMember{get;set;}
    public String primTabId{get;set;}
    
    public ACETHighlightsPanelAdditionalInfo AdditionalInfo {get;set;}
    public String hpAdditionInfoStr {
        get {
            return EncodingUtil.urlEncode(JSON.serialize(AdditionalInfo), 'UTF-8');
        } 
        set;
    }
    public Interaction__c sourceApplication {get; set;}//US635546-SNI
    public String ProviderId{get;set;}
    Public String TaxId{get;set;}
    public String providerTINTypeCode{get;set;}
    public String addressId{get;set;}
    public String ProvideraddressTypeCode{get;set;}
    public String ProviderTypeCode { get; set; }
    public String providerStatusCode {get;set;}
    public String providerTINStatusCode{get;set;}
    public ACETMemberSearchController() {
        System.debug(ApexPages.currentPage().getParameters().get('vccdParams'));
        String interactionId = ApexPages.currentPage().getParameters().get('interactionId');
        ProviderId= apexpages.currentpage().getparameters().get('ProviderId');
        TaxId= apexpages.currentpage().getparameters().get('TaxId');
        providerTINTypeCode= apexpages.currentpage().getparameters().get('providerTINTypeCode');
        addressId= apexpages.currentpage().getparameters().get('addressId');
        ProvideraddressTypeCode= apexpages.currentpage().getparameters().get('ProvideraddressTypeCode');
        ProviderTypeCode = apexpages.currentpage().getparameters().get('ProviderTypeCode');
        providerStatusCode = apexpages.currentpage().getparameters().get('providerStatusCode');
        providerTINStatusCode= apexpages.currentpage().getparameters().get('providerTINStatusCode');
        primTabId=apexpages.currentpage().getparameters().get('primTabId');
        if (!String.isEmpty(interactionId)) {
            Interaction = ACETProviderUtility.GetInteractionByID(interactionId);
        }
        CaseStub = new Interaction__c();
        IsShowMisdirectedCall = false;
        ACETDynatraceDetails = ACETUtility.GetDynatraceJSURL();
        addInfo = ApexPages.currentPage().getParameters().get('additionalInfo');
        IsGroupDetail = ApexPages.currentPage().getParameters().get('fromGroupDetail');
        IsMemberListing = ApexPages.currentPage().getParameters().get('MemberListing');
        if(IsMemberListing == 'true') {
            MemberId = ApexPages.currentPage().getParameters().get('MemberId');
            dateOfBirth = ApexPages.currentPage().getParameters().get('dob');
            IsGoToLink = Boolean.valueof(ApexPages.currentPage().getParameters().get('GoToLink'));
        }
    }
    
    public void init() {
    
     string vccdParam = ApexPages.currentPage().getParameters().get('vccdParams');
            if (vccdParam != '' && vccdParam != null) {
                ApexPages.currentPage().getParameters().put('autodocsearch','true');
            }
        IsMember = true;
        String providerId = ApexPages.currentPage().getParameters().get('id');
        isMisdirectCaseCreation=false;
        if(!String.isEmpty(providerId)) {
            Provider = [select id,FirstName, LastName, Tax_ID__c, NPI__c from Contact where Id = :providerId];
        }  
        IsMemberListing = ApexPages.currentPage().getParameters().get('MemberListing');
        if(IsMemberListing == 'true') {
            MemberId = ApexPages.currentPage().getParameters().get('MemberId');
            dateOfBirth= ApexPages.currentPage().getParameters().get('dob');
            IsGoToLink = Boolean.valueof(ApexPages.currentPage().getParameters().get('GoToLink'));
        } 
        
        //Get Provider Interaction SFDC Id
        String interactionId = ApexPages.currentPage().getParameters().get('InteractionId');    
        //Check if User is redirected to Member Search page from Provider detail page         
        if (!String.isEmpty(interactionId)) {                        
            //Query Provider Interaction details
            Interaction = ACETMemberQueryUtil.queryInteraction(interactionId);
            IsMember = false;
            SourceOriginator = Interaction.Interaction_Type__c;
        }
        groupId = ApexPages.currentPage().getParameters().get('groupId');
        initHighlightPanelAdditionalInfo();
    }
    
    private void initHighlightPanelAdditionalInfo(){
        if (AdditionalInfo == null) {
            AdditionalInfo = new ACETHighlightsPanelAdditionalInfo();
            if (ApexPages.currentPage().getParameters().get('ProvTypeCode') != null 
                && ApexPages.currentPage().getParameters().get('ProvTypeCode') != '') {
                AdditionalInfo.providerType = ApexPages.currentPage().getParameters().get('ProvTypeCode');
            }
        }        
  
        if (addInfo != null) {
            AdditionalInfo  = (ACETHighlightsPanelAdditionalInfo)JSON.deserialize(addInfo, ACETHighlightsPanelAdditionalInfo.class);
        }
        if (Interaction != Null && Interaction.Highlight_Panel_GroupInfo__c != null) {
            ACETGroupDetailsWrapper deserializedExceptionData = (ACETGroupDetailsWrapper)JSON.deserialize(Interaction.Highlight_Panel_GroupInfo__c, ACETGroupDetailsWrapper.class);
            AdditionalInfo.UHCBS = deserializedExceptionData.UHCBS;    
            AdditionalInfo.GroupN = deserializedExceptionData.GroupName ;
            AdditionalInfo.GroupStatus = deserializedExceptionData.GroupStatus;
            AdditionalInfo.ServiceTeam = deserializedExceptionData.ServiceTeam;
            //AdditionalInfo.EffectiveStartDate = deserializedExceptionData.EffectiveStartDate;
            AdditionalInfo.RiskManagement = deserializedExceptionData.RiskManagement;
            AdditionalInfo.RatingMethod = '';
            AdditionalInfo.RenewalDate= deserializedExceptionData.RenewalDate; 
            if(AdditionalInfo.RelationshipType == '' || AdditionalInfo.RelationshipType == null){
              AdditionalInfo.RelationshipType = deserializedExceptionData.RelationshipType ; 
            }
        }
        if (ApexPages.currentPage().getParameters().get('isFromProducer') == 'true')
        {   
            system.debug('@@@InsideAdditionalInfo'+AdditionalInfo.GroupN );
            isFromProducer = 'true';
            AdditionalInfo.GroupN = '';
        } 
        else
        {
            isFromProducer = 'false';
        }     
        AdditionalInfo.isMembersearch='1';
        hpAdditionInfoStr = JSON.serialize(AdditionalInfo);
    }
        
    public void search() {
        try {
            Results = null;
            mapResults = null;
            ISShowMisdirectedCall = false;   
            ErrorMessage = null;
            String dob;
            if(IsMemberListing == 'true' && !String.isBlank(dateOfBirth)) 
                dob =  dateOfBirth.split('/')[2] + '-'+dateOfBirth.split('/')[0] + '-'+dateOfBirth.split('/')[1];
            else
                dob = CaseStub.Member_Date_of_Birth__c != null ? (CaseStub.Member_Date_of_Birth__c.year() + '-' + CaseStub.Member_Date_of_Birth__c.month() + '-' + CaseStub.Member_Date_of_Birth__c.day())  : '';
            
                       
            ACETFindMemberWebService FindMemberService = new ACETFindMemberWebService();
            FindMemberService.init(MemberId, FirstName, LastName, dob, State, ZipCode);
            system.debug(LoggingLevel.INFO, ' StateCode1****: ' + State);             
            DTWrapper = new ACETDatatableWrapper('ACETFindMemberWebService', FindMemberService); 
            DTWrapper.Columns.add(new ACETDataTableWrapper.DataColumn('Last Name', 'LastName'));
            DTWrapper.Columns.add(new ACETDataTableWrapper.DataColumn('First Name', 'FirstName'));
            DTWrapper.Columns.add(new ACETDataTableWrapper.DataColumn('Middle Name', 'MiddleInitial'));
            DTWrapper.Columns.add(new ACETDataTableWrapper.DataColumn('Member ID', 'Id'));
            DTWrapper.Columns.add(new ACETDataTableWrapper.DataColumn('Date Of Birth', 'DOB'));
            DTWrapper.Columns.add(new ACETDataTableWrapper.DataColumn('Gender', 'Gender'));          
            DTWrapper.Columns.add(new ACETDataTableWrapper.DataColumn('SSN', 'SSN'));
            DTWrapper.Columns.add(new ACETDataTableWrapper.DataColumn('Address', 'Address'));
            //DTWrapper.Columns.add(new ACETDataTableWrapper.DataColumn('City', 'City'));
            //DTWrapper.Columns.add(new ACETDataTableWrapper.DataColumn('State', 'State'));
            //DTWrapper.Columns.add(new ACETDataTableWrapper.DataColumn('Zip', 'Zip'));
            DTWrapper.Columns.add(new ACETDataTableWrapper.DataColumn('SourceCode', 'SourceCode'));
                     
            string vccdParam = ApexPages.currentPage().getParameters().get('vccdParams');
            if (vccdParam != '' && vccdParam != null) {
                ApexPages.currentPage().getParameters().put('noAutoSearch','true');
                ApexPages.currentPage().getParameters().put('vccdParams','');
            }
            
            string isetParams = ApexPages.currentPage().getParameters().get('isetParams');
            if (isetParams != '' && isetParams != null) {
                ApexPages.currentPage().getParameters().put('noAutoSearch','true');
            }
            
        }
        catch (Exception ex) {
            ErrorMessage = ex.getMessage();
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ErrorMessage));
        }
        
       
    }

    public void renderMisdirectCaseSection() {
        isMisdirectCaseCreation = true;  
    }
    
    public void clear() {
        MemberId = '';
        FirstName = '';
        LastName = '';
        ZipCode = '';
        State = '';
        CaseStub = new Interaction__c(); 
        ISShowMisdirectedCall = false;
        SourceOriginator = '';   
        Results = null;
        ErrorMessage = null;
        DTWrapper = null;
        
        ApexPages.currentPage().getParameters().put('vccdParams','');
        
    }
        
    public void saveMisredirectedCase() {
        if (Interaction == null) {
            interaction = new Interaction__c();
            interaction.Interaction_Type__c = SourceOriginator;
            insert interaction; 
        }
        
        Case c = new Case();
        c.Interaction__c = Interaction.Id;
        c.Status = 'Canceled';
        c.Misdirected_Reason__c = MisdirectedReason;
        c.Comments__c = Comments;
        insert c;
        
        clear();    
    }
    
    public void saveSystemUnavailableCase() {
        try {
            if (Interaction == null) {
                interaction = new Interaction__c();
                interaction.Interaction_Type__c = SourceOriginator;
                insert interaction; 
            }
         
            Case c = new Case();
            c.Interaction__c = Interaction.Id;
            c.Status = 'Closed';
            c.New_Closed_Reason__c = 'System Unavailable';
            c.Comments__c = Comments;
            
            insert c;
            
            clear();
        }
        catch(exception e) {
        }    
    }
    
    public void sortTable() {   
        if (LastSortBy != null) {             
            if (LastSortBy != SortBy) {
                SortOrder = 'Asc';                      
            } else {
                SortOrder = (SortOrder == 'Asc'? 'Desc' : 'Asc');
            }
        }
        
        ACETMemberSearchResult.SortBy = SortBy;
        ACETMemberSearchResult.SortOrder = SortOrder;
        if (Results != null) {
            Results.sort();
            LastSortBy = SortBy;
        }                                
    }
    
    public void showMisdirectedCall() {
        ISShowMisdirectedCall = true;
    }
    
    public List<SelectOption> getMisdirectedReasons(){
        List<SelectOption> options = new List<SelectOption>();
        
        options.add(new SelectOption('','--None--'));
        options.add(new SelectOption('Cosmos','Cosmos'));
        options.add(new SelectOption('CSP Facets','CSP Facets'));
        options.add(new SelectOption('Dental Plan','Dental Plan'));
        options.add(new SelectOption('Member Serivce','Member Service'));
        options.add(new SelectOption('Other','Other'));
        options.add(new SelectOption('Pharmacy RX Other','Pharmacy RX Other'));
        options.add(new SelectOption('Prime','Prime'));
        options.add(new SelectOption('Provider Relations','Provider Relations'));
        options.add(new SelectOption('Pulse','Pulse'));
        options.add(new SelectOption('UNET','UNET'));
        options.add(new SelectOption('Vision Plan','Vision Plan'));
        options.add(new SelectOption('Wrong Carrier','Wrong Carrier'));
        return options;     
    }
        
    public List<SelectOption> getClosedReasons() {
        List<SelectOption> options = new List<SelectOption>();                
        options.add(new SelectOption('System Unavailable','System Unavailable'));        
        return options;     
    }
    
    public List<SelectOption> getSourceOriginators() {
        List<SelectOption> lstInteractionTypes = new List<SelectOption>();
        User currentUser = [select profile.Name from User where Id = :UserInfo.getUserId()];
        if (currentUser.profile.Name.contains('Research User')) {
            lstInteractionTypes.add(new SelectOption('Research Only','Research Only')); 
        }
        else {
            for(String IntrType :Label.ACETMemberSearchInteractionTypes.split(',')) {
                lstInteractionTypes.add(new SelectOption(IntrType, IntrType));
            }
        }
        return lstInteractionTypes;
    } 
    
    
    @RemoteAction
    public static String createInteraction(String interactionType, String interactionId){
        
        Interaction__c interaction = new Interaction__c();  
        interaction.Interaction_Type__c = interactionType;
        Interaction.Originator_Type__c = 'Member';
        insert interaction;         
        return interaction.Id;    
            
    }
}