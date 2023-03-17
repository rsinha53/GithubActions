public with sharing class ACETClaimSearchController extends ACETErrorHandler{
    public ACETDatatableWrapper DTWrapper {get;set;}
    public ACETCallTopicsDataWrapper wrapper {get;set;}
    //public ACETHighlightsPanelAdditionalInfo AdditionalInfo {get;set;}
    public String searchBy{get;set;}
    public String dateOfService{get;set;}
    public String status{get;set;}
    public Boolean deductible{get;set;}
    public String inNetwork{get;set;}
    public String claimnumber{get;set;}
    public string MemberId {get;set;}
    public string EID {get;set;}
    
    public String claimtype{get;set;}
    public Boolean startdatedisabled{get;set;}
    public Boolean enddatedisabled{get;set;}
    public Boolean  dateofservicedisabled {get;set;}
    Public String bookOfBusinessTypeCode{get;set;}
    public String taxid{get;set;}
    public String AuthorizationNumber{get;set;}
    public String ReferralNumber{get;set;}
    // Hide or UnHide Fields
    public Boolean authnumberhide{get;set;}
    public Boolean referralhide{get;set;}
    public Boolean casenumberhide{get;set;}
    public Boolean networkstatushide{get;set;}
    public Boolean deductiblehide{get;set;}
    public Boolean claimtypehide{get;set;}
    public Boolean taxidhide{get;set;}
    public Boolean claimnumberhide{get;set;}
    public Interaction__c startdate {get;set;}
    public Interaction__c enddate {get;set;}
    // Make Field Required
    public String claimNoReqd{get;set;}
    public String startDateReqd{get;set;}
    public String endDateReqd{get;set;}
    public String authorizationNoReqd{get;set;}
    public String taxIdReqd{get;set;}
    public String referralNoReqd{get;set;}
    public Boolean claimmandatory{get;set;}
    public String providers{get;set;}
     public String Encounters{get;set;}
    public boolean notResearchUser {get;set;}
    public boolean disableDates {get;set;}
    
    //added by khoushik for sorting
    public String SortBy {get;set;}
    public String SortOrder {get;set;}
    public String LastSortBy{get;set;}
    public String strSelectedClaims{get;set;}
    public string surrogateKey {get; set;}
    
    public List<ACETClaimSearchResult>  Claims{ set; get; }
    public String ClaimsResultJson{get;set;}
    public Interaction__c Interaction { get; set; }
    public String SourceOriginator {get;set;}
    public Contact Provider {get;set;}  
    public Contact Subject {get;set;}
    public ACETHighlightsPanelAdditionalInfo AdditionalInfo {get;set;}
    public Boolean isClaim {get;set;}
    public String hpAdditionInfoStr {get;set;}
    public boolean isCancelCaseCreation{get;set;}
    //Added By Prakash: This Method is used to call the components of HighlightsPanel
    Public List<SelectOption> SearchbyOption{get;set;}
    Public string errorMessage {get;set;}
    /*Public List<SelectOption> getSearchbyOption(){
        List<SelectOption> SearchOption = new List<SelectOption>();
        if(Interaction.Originator_Type__c == 'Provider'){
        
            if(AdditionalInfo.isMember  != null && AdditionalInfo.isMember.contains('false')){
                
                SearchOption.add(new SelectOption('Subject','Subject'));
                SearchOption.add(new SelectOption('Claim ID','Claim ID'));
            }
            else{
                
            SearchOption.add(new SelectOption('Claim ID','Claim ID'));
            }
        }
        else{
            
            SearchOption.add(new SelectOption('Subject','Subject'));
            SearchOption.add(new SelectOption('Claim ID','Claim ID'));
        }
        searchBy = 'ClaimID';
        return SearchOption;
    }*/
    
    public void init(){
        wrapper = new ACETCallTopicsDataWrapper();
        wrapper.init();
        wrapper.CaseObj.Topic__c = 'View Claims';
        system.debug('ApexPages.currentPage().getParameters() is '+ApexPages.currentPage().getParameters());
        EID = ApexPages.currentPage().getParameters().get('EIDstring');
        //system.debug('EAD1234'+EID);
        bookOfBusinessTypeCode=ApexPages.currentPage().getParameters().get('bookOfBusinessTypeCode');
        AdditionalInfo = new ACETHighlightsPanelAdditionalInfo();
        String AddInfo = ApexPages.currentPage().getParameters().get('additionalInfo');
        if(AddInfo.contains('&'))
        {
            AddInfo = AddInfo.replace('&', 'and');
        }
        AdditionalInfo = (ACETHighlightsPanelAdditionalInfo)JSON.deserialize(AddInfo, ACETHighlightsPanelAdditionalInfo.class);
        system.debug('AdditionalInfo is '+AdditionalInfo);
        
        String interactionId = ApexPages.currentPage().getParameters().get('interactionId');    
        MemberId = AdditionalInfo.MemberId;

        if (!String.isEmpty(interactionId)){                        
            system.debug('InteractionId: ' + InteractionId);
            
            Interaction = ACETProviderUtility.GetInteractionByID(interactionId);
            SourceOriginator = Interaction.Interaction_Type__c;
            system.debug('Interaction: ' + Interaction + ', SourceOriginator: ' + SourceOriginator);
        }
        String contactId = ApexPages.currentPage().getParameters().get('contactId');
        if (!String.isEmpty(contactId)){ 
            subject = ACETProviderUtility.GetContactByID(contactId);
        }
        
        hpAdditionInfoStr = JSON.serialize(AdditionalInfo);
        system.debug('ApexPages.currentPage().getParameters().get'+ApexPages.currentPage().getParameters().get('memberid'));
        if(Interaction.Originator_Type__c == 'Provider'){ 
        
            if(AdditionalInfo.isMember  != null && AdditionalInfo.isMember.contains('false')){
                if(Apexpages.currentPage().getparameters().containskey('claimId')){
                SearchbyOption = new List<SelectOption>();
                SearchbyOption.add(new SelectOption('Subject','Subject'));
                SearchbyOption.add(new SelectOption('ClaimID','Claim Number'));
                searchBy = 'ClaimID';
                }else{
                    SearchbyOption = new List<SelectOption>();
                SearchbyOption.add(new SelectOption('Subject','Subject'));
                SearchbyOption.add(new SelectOption('ClaimID','Claim Number'));
                    searchBy = 'Subject';
                }
                surrogateKey = ApexPages.currentPage().getParameters().get('SRK');
                
                
            }
            else
            { 
                if(Apexpages.currentPage().getparameters().containskey('claimId'))
        {
                SearchbyOption = new List<SelectOption>();
                SearchbyOption.add(new SelectOption('ClaimID','Claim Number'));
            searchBy = 'ClaimID';
        }else{
            
            SearchbyOption = new List<SelectOption>();
                SearchbyOption.add(new SelectOption('Subject','Subject'));
                SearchbyOption.add(new SelectOption('ClaimID','Claim Number'));
            searchBy = 'Subject';
        }
               string MemFirstName = ApexPages.currentPage().getParameters().get('FirstName');
                string MemLastName =  ApexPages.currentPage().getParameters().get('LastName');
                memberid = ApexPages.currentPage().getParameters().get('memberid');
                ACETFindMemberWebService ws = new ACETFindMemberWebService();
                ws.init(memberid, '', '', '', '', '');
                ACETWSCalloutResult result = ws.queryPaginatedData(1,10,1);
                if(result.Success){
                    List<ACETMemberSearchResult> memberresult = new List<ACETMemberSearchResult>();
                    system.debug('memberresult is '+memberresult);
                    memberresult = (List<ACETMemberSearchResult>)result.Response;
                                        system.debug('memberresult is '+memberresult);

                    surrogateKey = memberresult[0].SurrogateKey;
                    //system.debug('srk1234'+surrogateKey );
                    //String  memindividualIdentifier='';
                    //iterating on member
                    for(ACETMemberSearchResult mem : memberresult ){                                          
                    if(mem.FirstName == MemFirstName && mem.LastName == MemLastName){
                    system.debug('loop1');
                    EID  = mem.individualIdentifier;                   
                    }
                    else if(mem.MiddleInitial != Null){                    
                    string firstandmiddlename = mem.FirstName+=' '+ mem.MiddleInitial;
                    system.debug('firstandmiddlename>>>'+firstandmiddlename);
                    if(firstandmiddlename == MemFirstName && mem.LastName == MemLastName){                   
                      
                    EID  = mem.individualIdentifier;
                    }
                    }
                    
                    }
                    //end of iteration
                  // system.debug('>>>> memindividualIdentifier    '+memindividualIdentifier   );
                      }
            }
            
        }
        else{
            if(Apexpages.currentPage().getparameters().containskey('claimId')){
            SearchbyOption = new List<SelectOption>();
            SearchbyOption.add(new SelectOption('Subject','Subject'));
            SearchbyOption.add(new SelectOption('ClaimID','Claim Number'));
            searchBy = 'ClaimID';
            }
            else{
                SearchbyOption = new List<SelectOption>();
            SearchbyOption.add(new SelectOption('Subject','Subject'));
            SearchbyOption.add(new SelectOption('ClaimID','Claim Number'));
            searchBy = 'Subject';
            }
            surrogateKey = ApexPages.currentPage().getParameters().get('SRK');
        }
        
        system.debug('surrogateKey is '+surrogateKey);
        if (!String.isEmpty(surrogateKey)){ 
            wrapper.surrogateKey = surrogateKey;
        }  
        
        /*String providerId = ApexPages.currentPage().getParameters().get('id');
if(!String.isEmpty(providerId)){
Provider = [select FirstName, LastName, Tax_ID__c, NPI__c from Contact where Id = :providerId];
}

//Get Provider Interaction SFDC Id
String interactionId = ApexPages.currentPage().getParameters().get('interactionId');    
//Check if User is redirected to Member Search page from Provider detail page   
system.debug('-----------taxid---'+interactionId );      
if (!String.isEmpty(interactionId)){                        
Interaction = ACETProviderUtility.GetInteractionByID(interactionId);
SourceOriginator = Interaction.Interaction_Type__c;
}
String contactId = ApexPages.currentPage().getParameters().get('contactId');
if (!String.isEmpty(contactId)){ 
subject = ACETProviderUtility.GetContactByID(contactId);
}
TaxId = Interaction!=null && Interaction.Third_Party__r!=null && Interaction.Third_Party__r.Tax_ID__c!=null? Interaction.Third_Party__r.Tax_ID__c:Interaction.Originator__r.Tax_ID__c;

//hpAdditionInfoStr = JSON.serialize(AdditionalInfo);

*/ 
    }
    
    //Constructor Class
    public ACETClaimSearchController(){
        
        //added by khoushik
        disableDates = false;
        
        //Claims = new list<ACETClaimSearchResult>();        
        //making sure default value is blank for input paramters
        
        inNetwork='';
        claimtype='MD';
        
        deductible=false;
        ClaimNumber ='';
        AuthorizationNumber='';
        ReferralNumber='';        
        
        claimnumberhide = false;
        networkstatushide=true;
        enddatedisabled = false;
        startdatedisabled = false;
        dateofservicedisabled =true;
        deductiblehide=true;
        taxidhide=true;
        inNetwork='All';
        claimtype='MD';
        providers='All';
        Encounters='All';
        claimtypehide=true;
        startdate = new Interaction__c();
        enddate= new Interaction__c();
        //searchBy='Subject';
        taxid='';
        authnumberhide = true;
        referralhide=true;
        ClaimNoReqd = '';
        startDateReqd = '';
        endDateReqd = '';
        authorizationNoReqd = '';
        taxIdReqd = '';
        referralNoReqd = '';
        //Added by Raj (Motorhead). This is required to check the logged-in User profile on the page load for Research User
        getloggedinProfileName();
        system.debug('Apexpages.currentPage().getparameters() is '+Apexpages.currentPage().getparameters());
        system.debug('Interaction is '+Interaction);
        if(Apexpages.currentPage().getparameters().containskey('claimId'))
        {
            searchBy = 'ClaimID';
            searchbyaction();
            claimnumber = Apexpages.currentPage().getparameters().get('claimId');
            system.debug('Apexpages.currentPage().getparameters()claimId is '+Apexpages.currentPage().getparameters().get('claimId'));

        }
        
        
        //init(); 
        dateOfService = 'All';    
        if(dateOfService == 'Day'& dateOfService!= Null ){
            startdate.tst_Date_Field__c = null;
            // enddate.tst_Date_Field__c = Date.Today();
            enddatedisabled=false;            
            
        }  
        //dateServiceChange();
        
        
    }
    
    public PageReference clear()
    {
        startdate.tst_Date_Field__c = null;
        enddate.tst_Date_Field__c = null;
        deductible =false;
        inNetwork = 'All';
        taxidhide= null;
        dateOfService = 'All';
        searchBy = 'Subject';
        claimtype='MD';
        searchbyaction();
        taxid='';
        authnumberhide = false;
        referralhide=false;
        ClaimNoReqd = '';
        startDateReqd = '';
        endDateReqd = '';
        authorizationNoReqd = '';
        taxIdReqd = '';
        referralNoReqd = '';
        claimmandatory=false;
        Encounters='All';
        
        providers='All';
        ReferralNumber='';
        AuthorizationNumber='';
        //Claims.clear();
        Claims = null;
        return null;
    }
    
    public void search(){
        ACETFindClaimWebservice findClaimService = new ACETFindClaimWebservice();
        
        if(providers.contains('Facility')){
            providers = '02';    
        }
        else if(providers.contains('Physician')){
            providers = '03';    
        }
        else{
            providers = ''; 
        }
        
        if(inNetwork.contains('In Network')){
            inNetwork = 'I';
        }
        else if(inNetwork.contains('Out of Network')){
            inNetwork = 'O';
        }
        else if(inNetwork.contains('Combination')){
            inNetwork = 'B';
        }
        else {
            inNetwork = '';
        }
        String strdeductible = deductible?'Y':'';
        
        if(dateOfService.contains('Day')){
            enddate.tst_Date_Field__c = startdate.tst_Date_Field__c;
        }
        else if(dateOfService == 'All'){
            
            if(AdditionalInfo.DOB != null){
                list<String> OILDateSplit = (AdditionalInfo.DOB).split('/');
                startdate.tst_Date_Field__c = Date.newInstance(Integer.valueof(OILDateSplit[2]),Integer.valueof(OILDateSplit[0]),Integer.valueof(OILDateSplit[1]));
                system.debug('startdate.tst_Date_Field__c is '+startdate.tst_Date_Field__c);
            } 
            else{
                startdate.tst_Date_Field__c = Date.newInstance(9999, 12, 31);
                system.debug('startdate.tst_Date_Field__c is '+startdate.tst_Date_Field__c);
            }
            
            enddate.tst_Date_Field__c = Date.newInstance(9999, 12, 31);
            
        }
        else if(dateOfService == 'ThisYear'){
            Date dt = Date.today();
            startdate.tst_Date_Field__c  = Date.newInstance(dt.year(), 1, 1);
            enddate.tst_Date_Field__c = Date.newInstance(dt.year(), 12, 31);
        }
        else if(dateOfService == 'LastYear'){
            Date dt = Date.today();
            startdate.tst_Date_Field__c = Date.newInstance(dt.year()-1, 1, 1);
            enddate.tst_Date_Field__c = Date.newInstance(dt.year()-1, 12, 31);
        }

        findClaimService.init(taxid,inNetwork,string.valueOf(startdate.tst_Date_Field__c),string.valueOf(enddate.tst_Date_Field__c),strdeductible,claimnumber,AuthorizationNumber,ReferralNumber,providers,MemberId,EID,Encounters);
        integer recordsCount =  integer.valueOf( ACETDataTableController.queryPaginatedData('ACETFindClaimWebservice',JSON.serialize(findClaimService).replace('\'', '&#x27;'),1,1,1 ).totalCount);
        Integer statuscode =  integer.valueOf( ACETDataTableController.queryPaginatedData('ACETFindClaimWebservice',JSON.serialize(findClaimService).replace('\'', '&#x27;'),1,1,1 ).statusCode);
         system.debug('statuscode -->'+statuscode );
         if(statuscode != 200){
             if(statuscode == 400 || statuscode == 404 || statuscode == 500){
                 // errorMessage  = String.join(new List<String>(setErrorMsgInDataTable('CM400',null)), '');
                 set<string> msg_set = setErrorMsgInDataTable('GN' + statuscode,null);
                 if(msg_set != null){
                  for (string setElement : msg_set) {
                      errorMessage  = setElement;
        
                       }              
                     msg_set.clear();
                   }
              
              }
          }
          system.debug('errorMessage  --->'+errorMessage  );
        
        
        DTWrapper = new ACETDatatableWrapper('ACETFindClaimWebservice', findClaimService);
        DTWrapper.initOnDocumentReady = false;
        DTWrapper.PageSize = 50;       
        DTWrapper.IsSortEnabled = true;
        DTWrapper.DefaultSortBy = 6;
        DTWrapper.DefaultSortDir ='desc';
        DTWrapper.errorMessage = errorMessage;
        DTWrapper.Columns.add(new ACETDataTableWrapper.DataColumn('Claim Number', 'ClaimID'));
        DTWrapper.Columns.add(new ACETDataTableWrapper.DataColumn('Cirrus Claim ID', 'SourceClaimId'));
        DTWrapper.Columns.add(new ACETDataTableWrapper.DataColumn('PHI', 'PHIRestriction'));
        DTWrapper.Columns.add(new ACETDataTableWrapper.DataColumn('Tax ID', 'TaxID'));
        DTWrapper.Columns.add(new ACETDataTableWrapper.DataColumn('Provider', 'Provider'));
        DTWrapper.Columns.add(new ACETDataTableWrapper.DataColumn('Network', 'Network'));
        DTWrapper.Columns.add(new ACETDataTableWrapper.DataColumn('DOS Start','ServiceStart'));
        DTWrapper.Columns.add(new ACETDataTableWrapper.DataColumn('DOS End', 'ServiceEnd'));
        DTWrapper.Columns.add(new ACETDataTableWrapper.DataColumn('Charged', 'TotalCharged'));
        DTWrapper.Columns.add(new ACETDataTableWrapper.DataColumn('Paid', 'TotalPaid'));
        DTWrapper.Columns.add(new ACETDataTableWrapper.DataColumn('Deductible', 'Deductible'));
        DTWrapper.Columns.add(new ACETDataTableWrapper.DataColumn('Patient Resp', 'patientResponsibility'));
        DTWrapper.Columns.add(new ACETDataTableWrapper.DataColumn('Status Date','claimEventStatusDate'));
        DTWrapper.Columns.add(new ACETDataTableWrapper.DataColumn('Status', 'Status')); 
        DTWrapper.Columns.add(new ACETDataTableWrapper.DataColumn('Encounter', 'claimEncounterIndicator'));       
        DTWrapper.Columns.add(new ACETDataTableWrapper.DataColumn('Event Type', 'claimEvtType'));
        DTWrapper.Columns.add(new ACETDataTableWrapper.DataColumn('Primary Dx ','PrimaryDiagnosisCode'));
    }
    
    public void clearResults(){
        DTWrapper = null;
    }
    
    public void onClickDetail(){
        
        //ACETgetProfessionalWebservice getProfessionalService = new ACETgetProfessionalWebservice ();
        //getProfessionalService.init(ClaimType,claimnumber);
        
    }
    
    public void sortTable(){   
        if(LastSortBy != null){             
            if(LastSortBy != SortBy){
                SortOrder = 'Asc';                      
            }else{
                SortOrder = (SortOrder == 'Asc'? 'Desc' : 'Asc');
            }
        }
        
        ACETClaimSearchResult.SortBy = SortBy;
        system.debug('ACETClaimSearchResult.SortBy'+ACETClaimSearchResult.SortBy);
        ACETClaimSearchResult.SortOrder = SortOrder;
        Claims.sort();
        LastSortBy = SortBy;                                
    }
    public void renderCancelCaseSection(){
        isCancelCaseCreation=true;  
    }
    
    
    public PageReference searchbyaction() {
        
        ApexPages.currentPage().getParameters().put('noAutoSearch','true');
        
        ClaimNoReqd = '';
        startDateReqd = '';
        endDateReqd = '';
        authorizationNoReqd = '';
        taxIdReqd = '';
        referralNoReqd = '';       
        claimnumber = '';
        ReferralNumber='';
        //@Rama: Clear Taxid on searchBy Change
        TaxId = '';
        AuthorizationNumber='';
        
        //claimnumber = '';
        //disableDates = false;
        //startdatedisabled = true;
        //enddatedisabled = true;
        
        //@Rama : Commenting the hard code of searchBy
        //searchBy = 'ClaimNumber';
        
        authnumberhide = true;        
        dateOfService = 'Date Range';
        startdate.tst_Date_Field__c = null;
        enddate.tst_Date_Field__c = null;
        
        
        
        if(dateOfService =='Date Range'){
            if(searchBy == 'ClaimNumber'){
                disableDates = true;
                startdatedisabled  =false;
                enddatedisabled  =false;
            }else{
                disableDates = false;
                startdatedisabled  =true;
                enddatedisabled  =true;
            }
        }
        
        if(searchBy == 'ClaimID'){
            claimnumberhide = true;
            startdatedisabled = false;
            enddatedisabled = false;
            dateofservicedisabled = false;
            authnumberhide=false;
            networkstatushide=false;
            taxidhide=false;
            deductiblehide=false;
            claimtypehide=false;
            referralhide=false;
            claimmandatory = true;
            Encounters='All';
            system.debug('inside the claim  number block');
        }
        
        
        else if(searchby=='AuthorizationNumber'){
            claimnumberhide = false;
            startdatedisabled = true;
            enddatedisabled = true;
            dateofservicedisabled = true;
            networkstatushide=true;
            taxidhide=false;
            deductiblehide=true;
            claimtypehide=false;
            authnumberhide =true;
            referralhide=false;
        }
        else if(searchby=='referralnumber'){
            claimnumberhide = false;
            startdatedisabled = true;
            enddatedisabled = true;
            dateofservicedisabled = true;
            networkstatushide=true;
            taxidhide=false;
            deductiblehide=true;
            claimtypehide=false;
            authnumberhide = false;
            referralhide=true;
        }
        
        
        else {
            claimnumberhide = false;
            disabledates=true;
            enddatedisabled = false;
            startdatedisabled = false;
            dateofservicedisabled = true;
            networkstatushide=true;
            taxidhide=true;
            deductiblehide=true;
            claimtypehide=false;
            authnumberhide=true;
            referralhide=true;
            dateOfService='All';            
        }
        
        return null;
    }
    
    
    private void getloggedinProfileName(){ 
        notResearchUser = true;
        List<Profile> PROFILE = [SELECT Id, Name FROM Profile WHERE Id=:userinfo.getProfileId() LIMIT 1];
        String loggedinProfileName = PROFILE[0].Name;
        
        //Check if the logged-in User has profile 'Research' type
        if(loggedinProfileName.contains('Research'))
        { 
            notResearchUser = false;
        }
    }
    
    public PageReference dateServiceChange(){
        disableDates  = false;
        startDateReqd = '';
        endDateReqd = '';
        startdatedisabled = true;
        enddatedisabled = true;
        referralNoReqd = '';
        authorizationNoReqd = '';
        startdate.tst_Date_Field__c = null;
        enddate.tst_Date_Field__c = null;
        if(dateOfService == 'Day'){
            enddatedisabled=false;            
        }
        else if(dateOfService == 'ThisYear'){
            disableDates = true;    
            Date dt = Date.today();
            startdate.tst_Date_Field__c  = Date.newInstance(dt.year(), 1, 1);
            enddate.tst_Date_Field__c = Date.newInstance(dt.year(), 12, 31);
        }
        else if(dateOfService == 'LastYear'){
            disableDates = true;
            Date dt = Date.today();
            startdate.tst_Date_Field__c = Date.newInstance(dt.year()-1, 1, 1);
            enddate.tst_Date_Field__c = Date.newInstance(dt.year()-1, 12, 31);
        }
        else if(dateOfService == 'All'){
            enddatedisabled = false;
            startdatedisabled = false;
            
            
        }
        else{
            startdate.tst_Date_Field__c = null;
            enddate.tst_Date_Field__c = null;
        }
        return null;
    }
    
    
    
    public class ACETClaimMessageWrapper{
        public FindClaimResult findClaimsResult;
    }
    
    public class FindClaimResult{
        public List<FC_Error> errors;
    }
    
    public class FC_Error{
        public String code;
        public String name;
        public String severity;
        public String origin;
        public String description;
    }
    @RemoteAction
    public static ACETWSCalloutResult getEncoderProDescriptionMap(List<String> data){
        
        //Map<String,List<String>> codesMap = (Map<String,List<String>>)JSON.deserialize(data , Map<String,List<String>>.class);
        //System.debug('codesMap@@@ ' + codesMap);
        ACETWSCalloutResult result = new ACETWSCalloutResult();
        Set<String> codeToProcessSet = new Set<String>();//bring it from ui
        List<String> codeToProcessLst = new  List<String>();
        /*for(String section : codesMap.keySet() ){
for(String code : codesMap.get(section)){
codeToProcessSet.add(code);
}
}*/
        codeToProcessSet.addAll(data);
        System.debug('codeToProcessSet@@@ ' + codeToProcessSet);
        codeToProcessLst.addAll(codeToProcessSet);//This will make the list with unique codes
        System.debug('codeToProcessLst@@@ ' + codeToProcessLst);
        
        result=queryEncoderProDescription(codeToProcessLst);
        System.debug('result='+result);
        return result;
    }
    public static ACETWSCalloutResult queryEncoderProDescription(List<String> codeToProcessLst){
        ACETEncoderProWebservice encoderWS = new ACETEncoderProWebservice();
        
        return encoderWS.getCodeDescriptions(codeToProcessLst);
    }
}