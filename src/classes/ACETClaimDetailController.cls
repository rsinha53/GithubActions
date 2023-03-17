/* 
Apex Class Name: ACETClaimDetailController
Purpose: This class is created to support the functionalities of ACETClaimDetail Visualforce Page.
Developed By: Khoushik Selvaraj
Date created:08/23/2016
Rally User Stories ID: US335878.
 */
public with sharing class ACETClaimDetailController extends ACETErrorHandler{

    //public Boolean showCoverageMessage { get; set; }
    Public String EID {get;set;}
    public String body = '';
    public String ClaimId {get;set;}
    public String ClaimType {get;set;}
    public Boolean noresult{get;set;}
    public Interaction__c Interaction {get;set;}
    public String option {get;set;}
    Public String surrogateKey {get;set;}

    public List<SelectOption> Originators {get;set;}
    public Boolean IsProviderFlow {get;set;}
    public List<ACETClaimSearchResult> claimList{get;set;}
    public Contact Subject {get;set;}
    public String response{get;set;}
    public String SourceOriginator {get;set;}
    public ACETHighlightsPanelAdditionalInfo AdditionalInfo {get;set;}
    public String hpAdditionInfoStr {get;set;}
    public Boolean isClaim {get;set;}
    public boolean isCancelCaseCreation{get;set;}
    public ACETCallTopicsDataWrapper wrapper {get;set;}
    public ACETMemberDetail MemberDetail{get;set;}
    public Map<String,String> codeDescriptionMap {get;set;}

    private static ACETWSCalloutResult institutionalResult;

    public Transient ACETDatatableWrapper DTMemberEOBWrapper {get;set;}
    public Transient ACETDatatableWrapper DTProviderPRAWrapper {get;set;}
    public  Transient ACETDatatableWrapper DTClaimLetterWrapper {get;set;}
    public Transient ACETDatatableWrapper DTPhysicalHealthLetterWrapper {get;set;}
    
    Public String CheckImageUrl{get;set;}
    
    Public String SeriesDesignator{get;set;}
    Public String bookOfBusinessTypeCode{get;set;}
    Public String CheckEFTNumber{get;set;}
    Public Integer resultStatusCode{get;set;}
    Public boolean isMemberEOB{get;set;}
    Public boolean isProviderRA{get;set;}
    Public boolean isClaimLetter{get;set;}
    Public boolean isPhysicalhealth{get;set;}
    Public String claimStatus {get; set;}
    Public string errorMessage {get;set;}

    public void renderCancelCaseSection(){
        isCancelCaseCreation=true;  
    }
    public ACETClaimDetailController()
    {
          bookOfBusinessTypeCode=ApexPages.currentPage().getParameters().get('bookOfBusinessTypeCode');

        surrogateKey = ApexPages.currentPage().getParameters().get('SRK');
            system.debug('surrogateKey '+surrogateKey );
    EID = ApexPages.currentPage().getParameters().get('EIDstring');
             system.debug('EID >>>>'+EID );     
        wrapper = new ACETCallTopicsDataWrapper();
        wrapper.init();
        if (!String.isEmpty(surrogateKey)){ 
            wrapper.surrogateKey = surrogateKey;
        }  
        
        system.debug(wrapper.surrogateKey + ' wrapper in claim details '+wrapper);
        
        ClaimId = ApexPages.currentPage().getParameters().get('claimId');
        ClaimType = ApexPages.currentPage().getParameters().get('claimType');
        claimStatus = ApexPages.currentPage().getParameters().get('claimstatus');
        
        System.debug('ClaimId '+ClaimId);
        System.debug('ClaimType'+ClaimType );
        System.debug('claimStatus'+claimStatus );

        
        if(claimStatus == 'In Process') {
           ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'This claim is in process.  Do not communicate claim adjudication details until it is finalized.'));
        }
        
        System.debug('claim status:::'+claimStatus);
    }
    
    public PageReference displayCoverageMessage(){
      ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Claim DOS is outside of the selected coverage period.'));
      
        return null;
    }
    public void init(){
        isClaim = true;
        AdditionalInfo = new ACETHighlightsPanelAdditionalInfo();
        //Get Provider Interaction SFDC Id
        String interactionId = ApexPages.currentPage().getParameters().get('interactionId');    
        //Check if User is redirected to Member Search page from Provider detail page         
        if (!String.isEmpty(interactionId)){                        
            system.debug('InteractionId: ' + InteractionId);

            //Query Provider Interaction details
            Interaction = ACETProviderUtility.GetInteractionByID(interactionId);
            SourceOriginator = Interaction.Interaction_Type__c;
            system.debug('Interaction: ' + Interaction + ', SourceOriginator: ' + SourceOriginator);
        }
        String contactId = ApexPages.currentPage().getParameters().get('contactId');
        if (!String.isEmpty(contactId)){ 
            subject = ACETProviderUtility.GetContactByID(contactId);
        }


        String strAdditionalInfo = ApexPages.currentPage().getParameters().get('additionalInfo');
        if (!String.isEmpty(strAdditionalInfo)){ 
            AdditionalInfo = (ACETHighlightsPanelAdditionalInfo)JSON.deserialize(strAdditionalInfo, ACETHighlightsPanelAdditionalInfo.class);
        }
        hpAdditionInfoStr = JSON.serialize(AdditionalInfo);  
        if(Interaction.Originator_Type__c == 'Member'){
                //Member only
                
            isMemberEOB = true;
            isClaimLetter = true; 
            isPhysicalhealth = true;
            isProviderRA = true;
                
            }
            else if(Interaction.Originator_Type__c == 'Group/Employer' || Interaction.Originator_Type__c == 'Broker' || Interaction.Originator_Type__c == 'General Agent' || Interaction.Originator_Type__c == 'UHG' || Interaction.Originator_Type__c == 'Third Party'){
                if(AdditionalInfo.isMember != null && AdditionalInfo.isMember.contains('false')){
                    //Group Member in focus
                    system.debug('Group Member in focus');
                    isMemberEOB = true;
                    isClaimLetter = true;
                    isPhysicalhealth = true;
                }
                else{
                    //Group only
                    system.debug('Group only');
                    system.debug('GroupN is '+AdditionalInfo.producerId);
                   
                }        
            }
            else if(Interaction.Originator_Type__c == 'Producer'){
                 if(AdditionalInfo.isMember != null && AdditionalInfo.isMember.contains('false')){
                    //Producer Member in focus
                    system.debug('Producer Member in focus');
                    isMemberEOB = true;
                     isClaimLetter = true;
                    isPhysicalhealth = true;
                }
               else if(AdditionalInfo.isGroup != null && AdditionalInfo.isGroup.contains('false')){
                    //Producer Group in focus
                    system.debug('Producer Group in focus');
                    
                    
                }

                else {
                    //Producer only
                    system.debug('Producer only');
                    
                    
                }        
            }
            else if(Interaction.Originator_Type__c == 'Provider'){
                if(AdditionalInfo.isMember  != null && AdditionalInfo.isMember.contains('false')){
                    //Provider Member in focus
                    system.debug('Provider Member in focus');
                    isProviderRA = true;
                    isClaimLetter = true;
                    isPhysicalhealth = true;
                }
               else {
                    //Provider only
                    system.debug('Provider only');
                   isProviderRA = true;
                   isClaimLetter = true;
                   //isPhysicalhealth = true;
                }
            }        
        //pagination data table wrappers for claim documents        
        initClaimDocuments(); 
        
    }
    
    public void initClaimDocuments(){      
        String memberId = AdditionalInfo.MemberId;
        String claimId = ApexPages.currentPage().getParameters().get('claimId'); 
               
        DTMemberEOBWrapper = initClaimDocDatatable('u_oxf_med_eob', '', claimId);
        DTProviderPRAWrapper = initClaimDocDatatable('u_oxf_pra', memberId, claimId);
        DTClaimLetterWrapper = initClaimDocDatatable('u_clm_ltr', '', claimId);
        DTPhysicalHealthLetterWrapper = initClaimDocDatatable('u_optum_physical_health_ltr', memberId, claimId); // Updated doc class for Physical Health letter by Abhinav
    }
    
    private ACETDatatableWrapper initClaimDocDatatable(String docType, String memberId, String claimId){
        ACETFindDocWebservice findDocService = new ACETFindDocWebservice();
        List<ACETFindDocWebservice.documentKey> findDocKeys = new List<ACETFindDocWebservice.documentKey>();
        
        if(!String.isEmpty(memberId)){
            ACETFindDocWebservice.documentKey memberIdKey = new ACETFindDocWebservice.documentKey();
            memberIdKey.value = memberId;
            memberIdKey.name = (docType=='u_optum_physical_health_ltr')?'u_id_crd_srl_nbr':'u_mbr_id'; // Updated doc class for Physical Health letter by Abhinav
            memberIdKey.dataTypeIndicator = 'string';
            memberIdKey.operator = '=';
            findDocKeys.add(memberIdKey);
        }
        
        if(!String.isEmpty(claimId)){
            ACETFindDocWebservice.documentKey claimIdKey = new ACETFindDocWebservice.documentKey();
            claimIdKey.value = claimId;
            claimIdKey.name = (docType=='u_oxf_pra' || docType=='u_oxf_med_eob')?'u_claim_nbr':'u_clm_nbr'; // Updated doc class for Provider RA and Member EOB by Abhinav
            claimIdKey.dataTypeIndicator = 'string';
            claimIdKey.operator = '=';
            findDocKeys.add(claimIdKey);
        }
                
        //change operator to = ANY for WS MultiValue Field
        List<Document_Type_Search_By_Field__mdt> listSearchByFields = [SELECT Document_Type__r.WS_Field_Name__c, WS_MultiValue_Field__c, Document_Type_Field__r.WS_Field_Name__c FROM Document_Type_Search_By_Field__mdt where WS_MultiValue_Field__c=TRUE];
        for(Document_Type_Search_By_Field__mdt sf : listSearchByFields){
            for(ACETFindDocWebservice.documentKey docKey : findDocKeys){
                if(docType == sf.Document_Type__r.WS_Field_Name__c && sf.Document_Type_Field__r.WS_Field_Name__c == docKey.name){
                    docKey.operator += ' ANY';
                }   
            }   
        }
        
        findDocService.init(docType, findDocKeys); 
        integer recordsCount =  integer.valueOf( ACETDataTableController.queryPaginatedData('ACETFindDocWebservice',JSON.serialize(findDocService).replace('\'', '&#x27;'),1,1,1 ).totalCount);
        Integer statuscode =  integer.valueOf( ACETDataTableController.queryPaginatedData('ACETFindDocWebservice',JSON.serialize(findDocService).replace('\'', '&#x27;'),1,1,1 ).statusCode);
         system.debug('statuscode -->'+statuscode );
         system.debug('recordsCount -->'+recordsCount);
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
         else if(statuscode==200 && recordsCount==0) {
             set<string> msg_set = setErrorMsgInDataTable('CLD200', null);
             if(msg_set != null){
                  for (string setElement : msg_set) {
                      errorMessage  = setElement;
                   }              
             msg_set.clear();
             }
         }
          system.debug('errorMessage  --->'+errorMessage  );
        ACETDatatableWrapper DTWrapper = new ACETDatatableWrapper('ACETFindDocWebservice', findDocService);
        DTWrapper.errorMessage = errorMessage;
    DTWrapper.Columns.add(new ACETDataTableWrapper.DataColumn('Document ID', 'DocumentId')); 
        if(docType=='u_optum_physical_health_ltr' || docType=='u_clm_ltr'){  // Updated doc class for Physical Health letter by Abhinav
            DTWrapper.Columns.add(new ACETDataTableWrapper.DataColumn('Document Name', 'u_tmplt_nm')); 
        }
        
        if(docType=='u_oxf_med_eob' || docType=='u_oxf_pra'){ 
            DTWrapper.Columns.add(new ACETDataTableWrapper.DataColumn('Payment Cycle Date', 'u_pay_cyc_dt')); 
            DTWrapper.Columns.add(new ACETDataTableWrapper.DataColumn('', '')); 
            
        }
        else{
            DTWrapper.Columns.add(new ACETDataTableWrapper.DataColumn('Created Date/Time', 'u_orig_creation_date'));  // Updated by Abhinav
            
        }
        DTWrapper.InitOnDocumentReady = false;
        DTWrapper.PageSize = 25;    
        
        return DTWrapper;   
    }
    
    
    public void addStdErrorMsgClm() {
        if(resultStatusCode!=null && resultStatusCode !=200 &&(resultStatusCode == 400 || resultStatusCode == 404 || resultStatusCode == 500)) {
            setErrorMsg('GN'+resultStatusCode);
        }
    }
    public void addStdErrorMsgPmt() {
        if(resultStatusCode!=null && resultStatusCode !=200 &&(resultStatusCode == 400 || resultStatusCode == 404 || resultStatusCode == 500)) {
            setErrorMsg('GN'+resultStatusCode);
        }
    }
    
    public void getcheckimageurl()
    {
        User usr = [select FederationIdentifier from user where id=:userinfo.getUserId()];
                String baseURL = String.valueof(URL.getSalesforceBaseUrl().toExternalForm());
                String orginstance ;
                for(ACETOrgInstanceURLToOrgNameMap__c orgname:ACETOrgInstanceURLToOrgNameMap__c.getAll().values()) {
                    
                    if(baseURL.contains(orgname.Name)) {
                        system.debug('tname '+orgname.name);
                        orginstance = ACETOrgInstanceURLToOrgNameMap__c.getValues(orgname.name).Org_Name__c;
                    }
                }
                if(orginstance != null){
                    system.debug('orginstance is '+orginstance);
                    ACETOrgNameToSwivelEndpointMap__c wrapURL = ACETOrgNameToSwivelEndpointMap__c.getValues(orginstance+'_IDRS');
                   //	US2564113 Start
                    ISL_Webservice_Config__c appName =  ISL_Webservice_Config__c.getValues(orginstance+'_doc360Appname');
                    system.debug('wrapURL is '+wrapURL);
                    string doc360Appname ;
                    doc360Appname = appName.value__c;
                    CheckImageUrl = wrapURL.Swivel_Endpoint__c;
                   // SeriesDesignator ='SY';
                   // CheckEFTNumber='10509822';
                    if(doc360Appname != null && doc360Appname != ''){
                        String strparams = 'appId='+doc360Appname+'&user='+usr.FederationIdentifier+'&datagroup=trsy&screen=4'+'&key0='+SeriesDesignator+'&key1='+CheckEFTNumber;
                        system.debug('before encoding '+strparams);
                        blob params = blob.valueOf(strparams);
                        String base64params = EncodingUtil.base64Encode(params);
                        CheckImageUrl+= base64params;
                        system.debug('CheckImageUrl is '+CheckImageUrl);
                     }
                    //	US2564113 End
                }

    }

    
    @testvisible
    private void initInteractionAndSubject(){
        String interactionId = ApexPages.currentPage().getParameters().get('InteractionId'); 
        system.debug('InteractionId: ' + InteractionId);    

        if (!String.isEmpty(interactionId)){                                                        
            //Query Provider Interaction details
            Interaction = ACETProviderUtility.GetInteractionByID(interactionId);    
            //IsProviderFlow = true;                   
        }else{
            //IsProviderFlow = false;
        } 

        //create a new interaction if not passed from provider page        
        If(Interaction == null){
            createInteraction();
        }  

        //setup originator options
        Originators = new List<SelectOption>();        
        //redirected from provider page, add provider as originator
        if(IsProviderFlow){ 
            if(Interaction.Originator_Type__c == 'Other')
                originators.add(new SelectOption(Interaction.Third_Party__c, Interaction.Third_Party__r.LastName__c));
            else              
                originators.add(new SelectOption(Interaction.Originator__c, Interaction.Originator__r.Name));       
        }else{
               
        }                                                         
    }
    @testvisible
    private void createInteraction(){
        Interaction = new Interaction__c();
        Interaction.Originator__c = Subject.Id;

        //for now, we only have the use case as member calls themselves
        Interaction.Interaction_Type__c = SourceOriginator;
        Interaction.Originator_Type__c = 'Member';

        Insert Interaction; 

        //query referenced originator information
        Interaction = ACETProviderUtility.GetInteractionByID(Interaction.Id);            
        system.debug(Interaction);
    }

    @RemoteAction
    public static ACETWSCalloutResult queryGetProfessionalClaims(String claimType,String claimId){       
        ACETgetProfessionalWebservice ws = new ACETgetProfessionalWebservice();
        return ws.GetProfessionalClaimsWS(claimType,claimId);                             
    }    

    @RemoteAction
    public static ACETWSCalloutResult queryGetInstitutionalClaims(String claimType,String claimId){       
        ACETgetInstitutionalWebservice ws = new ACETgetInstitutionalWebservice();
        return ws.GetInstitutionalClaimsWS(claimType,claimId);
    }
    
    @RemoteAction
    public static ACETWSCalloutResult getEncoderProDescription(String data){
        
        Map<String,List<String>> codesMap = (Map<String,List<String>>)JSON.deserialize(data , Map<String,List<String>>.class);
        ACETWSCalloutResult result = new ACETWSCalloutResult();
        Set<String> codeToProcessSet = new Set<String>();//bring it from ui
        List<String> codeToProcessLst = new  List<String>();
        for(String section : codesMap.keySet() ){
            for(String code : codesMap.get(section)){
                codeToProcessSet.add(code);
            }
        }
        codeToProcessLst.addAll(codeToProcessSet);//This will make the list with unique codes
        return queryEncoderProDescription(codeToProcessLst);
    }
    public static ACETWSCalloutResult queryEncoderProDescription(List<String> codeToProcessLst){
        ACETEncoderProWebservice encoderWS = new ACETEncoderProWebservice();
        return encoderWS.getCodeDescriptions(codeToProcessLst);
    }
    @RemoteAction
    public static ACETWSCalloutResult queryClaimPayment(String claimId){       
        ACETFindClaimPaymentWebService service = new ACETFindClaimPaymentWebService();
        return service.getClaimPayments(claimId);                    
    }

    @RemoteAction
    public static ACETWSCalloutResult queryCheckStatus(String checkSeriesDesignator, String checkEFTNumber){       
        ACETGetCheckStatusWebService service = new ACETGetCheckStatusWebService();
        return service.getCheckStatus(checkSeriesDesignator,checkEFTNumber);                             
    }

    public void getClaimsCodeDescriptions(){
        system.debug('institutionalResult >>>>> '+institutionalResult);
    }


}