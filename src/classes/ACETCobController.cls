public with sharing class ACETCobController extends ACETErrorHandler{
    public List<wrapperCommercial> commercial{get;set;}
    public List<wrapperMedicare> medicare{get;set;}
    public String response{get;set;}
    public List<ACETMemberDetail.COB> cobList{get;set;}
    public List<ACETMemberDetail.COB> commercialcobList{get;set;}
    public List<ACETMemberDetail.COB> governmentcobList{get;set;}
    public List<ACETMemberDetail.FamilyMember> FamilyMembers {get;set;}
    public ACETMemberDetail MemberDetail{get;set;}
    public Interaction__c Interaction {get;set;}
    public Contact Subject {get;set;}
    public String SourceOriginator {get;set;}
    public ACETHighlightsPanelAdditionalInfo AdditionalInfo {get;set;}
    public Boolean isClaim {get;set;}
    public boolean isCancelCaseCreation{get;set;}
    public ACETCallTopicsDataWrapper wrapper {get;set;}
    public string surrogateKey {get; set;}
    public boolean showUpdateSection{get;set;}
    public boolean isCommercialActive{get;set;}
    public string selectCommericial{get;set;}
    public case caseEffectiveCommDate{get;set;}
    public case caseEndCommDate{get;set;}
    public case caseEffectiveGovDate{get;set;}
    public case caseEndGovDate{get;set;}
    public string custodialSelect{get;set;}
    public string otherInsuranceType{get;set;}
    public string otherInsuranceTypeval{get;set;}
    public string otherInsuranceCarrierName{get;set;}
    public string otherInsuranceIdNumber{get;set;}
    public string coverageTypeval{get;set;}
    public string govcoverageTypeval{get;set;}
    public string entitlementreasonval{get;set;}
    public Case effectiveDate{get;set;}
    public String selectedValue { get; set; }
    String[] otherInsuranceTypelist = new String[]{};
   /* public List<String> OtherInsType {get; set; }
    public List<String> OtherGovInsType {get; set; }*/
    
    public ACETMemberDetail.CoverageLine MemberDetailCOB  { get; set; }
    public ACETMemberDetail MemberDetailObj { get; set; }
    private String memCOBParam;
    transient ACETGetFamilyMemberWebService ACETGetFamMemWebservice;
    
    public Object CallWSonPageLoad11(){
        
      Continuation PageLoadContinuation;
      try{
        ACETGetFamMemWebservice = new ACETGetFamilyMemberWebService();
        
        if(MemberDetailObj!=null)    
            PageLoadContinuation = ACETGetFamMemWebservice.StartRequest(MemberDetailObj.SurrogateKey, MemberDetailObj,'GetMembershipCallback11',null);    
      }catch(Exception e){
          system.debug(LoggingLevel.INFO, 'Some error has occurred : '+e.getStackTraceString());
          setErrorMsg('GN997',e);//997-->Unknown Error 
            
      }
        return PageLoadContinuation;
    }

    public Object GetMembershipCallback11() {
        ACETWSCalloutResult getFamMemCalloutResults;        
        try{
            if(MemberDetailObj!=null)
                getFamMemCalloutResults = ACETGetFamMemWebservice.ProcessResponse(ACETGetFamMemWebservice.RequestLabel, MemberDetailObj);
        }catch(Exception e){
          system.debug(LoggingLevel.INFO, 'Some error has occurred : '+e.getStackTraceString());
          setErrorMsg('GN997',e);//997-->Unknown Error 
            
        } 
        try{   
            if(getFamMemCalloutResults!=null && getFamMemCalloutResults.Success) {                
                MemberDetail = (ACETMemberDetail)getFamMemCalloutResults.Response;
                if(MemberDetail!=null)
                    childconsolefunction(MemberDetail);
            }
            else{
                setErrorMsg('GN'+getFamMemCalloutResults.statusCode,null); 
                
            }
            
        }catch(Exception e){
          system.debug(LoggingLevel.INFO, 'Some error has occurred : '+e.getStackTraceString());
          setErrorMsg('GN997',e);//997-->Unknown Error 
            
        } 
        return null;
    }
    
    public void updateCommercial(){
        showUpdateSection = True;
    }
    public void childconsolefunction(ACETMemberDetail MemberDetail){
     try{  
        if(MemberDetail != null)
        {
            if(MemberDetail.FamilyMembers != null){
              FamilyMembers = MemberDetail.FamilyMembers;
            }
            cobList = MemberDetail.lstCOB;
            commercialcobList =  new List<ACETMemberDetail.COB>();
            governmentcobList =  new List<ACETMemberDetail.COB>();
            Map<String,ACETMemberDetail.COB> mapCobCom = new Map<String,ACETMemberDetail.COB>();
            Map<String,ACETMemberDetail.COB> mapCobGov = new Map<String,ACETMemberDetail.COB>();
            if(cobList != null && cobList.size()>0){
                for(ACETMemberDetail.COB cobItem : cobList){
                    if(String.isNotBlank(cobItem.CoverageTypeCode) && (cobItem.CoverageTypeCode == '1' || cobItem.CoverageTypeCode == '3' || cobItem.CoverageTypeCode == '4' || cobItem.CoverageTypeCode == '5')){
                        commercialcobList.add(cobItem);
                        if(String.isNotBlank(cobItem.MemberId) && !mapCobCom.containsKey(cobItem.MemberId))
                        {
                          mapCobCom.put(cobItem.memberId,cobitem);
                        }                        
                    }else if(String.isNotBlank(cobItem.CoverageTypeCode) && cobItem.CoverageTypeCode == '2'){
                        governmentcobList.add(cobItem);
                        if(String.isNotBlank(cobItem.MemberId) && !mapCobGov.containsKey(cobItem.MemberId))
                        {
                          mapCobGov.put(cobItem.memberId,cobitem);
                        }
                    }
                }
                if(FamilyMembers != null && mapCobCom != null){
                  addFamilyMemberstoCoblist(mapCobCom,'Comm');  
                }
                if(FamilyMembers != null && mapCobGov != null){
                  addFamilyMemberstoCoblist(mapCobGov,'Gov');  
                }
            }
        }
       }catch(Exception e){
          system.debug(LoggingLevel.INFO, 'Some error has occurred : '+e.getStackTraceString());
          setErrorMsg('GN997',e);//997-->Unknown Error   
       } 
    }
    public void addFamilyMemberstoCoblist(Map<String,ACETMemberDetail.COB> mapCob, String section){   
     try{
      if(String.isNotBlank(section) && section == 'Comm'){
       if(FamilyMembers!=null && FamilyMembers.size()>0){
        for(ACETMemberDetail.FamilyMember famMembers : FamilyMembers){
          if(String.isNotBlank(famMembers.EID) && !mapCob.containsKey(famMembers.EID)){
            ACETMemberDetail.COB cob = new ACETMemberDetail.COB();
            cob.MemberId = famMembers.EID;
            cob.Name = String.isNotBlank(famMembers.FirstName)?famMembers.FirstName:'';
            cob.Name = String.isNotBlank(famMembers.LastName)?cob.Name + ' ' + famMembers.LastName:cob.Name;
            cob.Age = famMembers.Age;
            cob.Relationship = famMembers.Relationship;
            cob.DateOfBirth = famMembers.DOB;
            commercialcobList.add(cob);  
          }                       
        }
       }
      }
      if(String.isNotBlank(section) && section == 'Gov'){      
        if(FamilyMembers!=null && FamilyMembers.size()>0){
        for(ACETMemberDetail.FamilyMember famMembers : FamilyMembers){
          if(String.isNotBlank(famMembers.EID) && !mapCob.containsKey(famMembers.EID)){
            ACETMemberDetail.COB cob = new ACETMemberDetail.COB();
            cob.MemberId = famMembers.EID;
            cob.Name = String.isNotBlank(famMembers.FirstName)?famMembers.FirstName:'';
            cob.Name = String.isNotBlank(famMembers.LastName)?cob.Name + ' ' + famMembers.LastName:cob.Name;
            cob.Age = famMembers.Age;
            cob.Relationship = famMembers.Relationship;
            cob.DateOfBirth = famMembers.DOB;
            governmentcobList.add(cob);  
          }                       
        }
       }
      }
     }catch(Exception e){
          system.debug(LoggingLevel.INFO, 'Some error has occurred : '+e.getStackTraceString());
          setErrorMsg('GN997',e);//997-->Unknown Error   
     }
    }
    public void renderCancelCaseSection(){
        isCancelCaseCreation=true;  
    }
    public ACETCobController(){
    
        caseEffectiveCommDate = new Case();
        caseEndCommDate = new Case();
        caseEffectiveGovDate = new Case();
        caseEndGovDate = new Case();
        showUpdateSection = False; 
    try{       
        wrapper = new ACETCallTopicsDataWrapper();
        wrapper.CallTopic ='Coordination Of Benefits';
        wrapper.init(); 
        wrapper.CaseObj.Topic__c =wrapper.CaseObj!=null? 'Coordination Of Benefits':'';    
        otherInsuranceTypeval = '--None--';
    }catch(Exception e){
          system.debug(LoggingLevel.INFO, 'Some error has occurred : '+e.getStackTraceString());
          setErrorMsg('GN997',e);//997-->Unknown Error         
    }
        AdditionalInfo = new ACETHighlightsPanelAdditionalInfo();
        List<ACETMemberDetail.COB> cobList = new List<ACETMemberDetail.COB>();
        //Get Provider Interaction SFDC Id
        String interactionId = ApexPages.currentPage().getParameters().get('interactionId');    
        //Check if User is redirected to Member Search page from Provider detail page         
    try{    
        if (String.isNotBlank(interactionId)){                        
            system.debug('InteractionId: ' + InteractionId);            
            //Query Provider Interaction details
            Interaction = ACETProviderUtility.GetInteractionByID(interactionId);
            SourceOriginator = Interaction!=null?Interaction.Interaction_Type__c:'';
            system.debug('Interaction: ' + Interaction + ', SourceOriginator: ' + SourceOriginator);
        }
    }catch(Exception e){
          system.debug(LoggingLevel.INFO, 'Some error has occurred : '+e.getStackTraceString());
          setErrorMsg('GN997',e);//997-->Unknown Error 
            
        }
        String contactId = ApexPages.currentPage().getParameters().get('contactId');
    try{    
        if (String.isNotBlank(contactId)){ 
            subject = ACETProviderUtility.GetContactByID(contactId);
        }
    }catch(Exception e){
          system.debug(LoggingLevel.INFO, 'Some error has occurred : '+e.getStackTraceString());
          setErrorMsg('GN997',e);//997-->Unknown Error 
            
        }
        String stradditionalInfo= ApexPages.currentPage().getParameters().get('additionalInfo');
    try{    
        if (String.isNotBlank(contactId)){ 
            AdditionalInfo = (ACETHighlightsPanelAdditionalInfo)JSON.deserialize(stradditionalInfo, ACETHighlightsPanelAdditionalInfo.class);
        }
    }catch(Exception e){
          system.debug(LoggingLevel.INFO, 'Some error has occurred : '+e.getStackTraceString());
          setErrorMsg('GN997',e);//997-->Unknown Error 
            
        }
    try{    
        surrogateKey = ApexPages.currentPage().getParameters().get('SRK');
        if (String.isNotBlank(surrogateKey)){ 
            wrapper.surrogateKey = surrogateKey;
        } 
  
        String groupNumberCOB = ApexPages.currentPage().getParameters().get('groupNumber');
        String SRKCOB = ApexPages.currentPage().getParameters().get('SRKCOB');
        String effectiveDateCOB = ApexPages.currentPage().getParameters().get('effectiveDate');
        
        MemberDetailObj = new ACETMemberDetail();
        ACETMemberDetail.CoverageLine PreferredCoverage = new ACETMemberDetail.CoverageLine();
        PreferredCoverage.GroupNumber = groupNumberCOB; 
        PreferredCoverage.SurrogateKey = SRKCOB;
        PreferredCoverage.EffectiveDate =  effectiveDateCOB; 
        MemberDetailObj.PreferredCoverage = PreferredCoverage;   
    }catch(Exception e){
          system.debug(LoggingLevel.INFO, 'Some error has occurred : '+e.getStackTraceString());
          setErrorMsg('GN997',e);//997-->Unknown Error 
            
        }
       /* OtherInsType = new List<String>();
        Map<String, ACETOtherInsuranceType__c> InsuranceType = ACETOtherInsuranceType__c.getAll();
        if(InsuranceType != null){
          OtherInsType.addAll(InsuranceType.keySet());
          OtherInsType.sort();  
        }
        OtherInsType.add('Other');
        
        OtherGovInsType = new List<String>();
        Map<String, ACETGovCoveragesTypes__c> CoveragesTypes = ACETGovCoveragesTypes__c.getAll();
        if(CoveragesTypes != null){
          OtherGovInsType.addAll(CoveragesTypes.keySet());
          OtherGovInsType.sort();
        }
        OtherGovInsType.add('Other');*/
        
    }
    public void rerenderPB(){
    }
    public PageReference Save(){
        PageReference caseDetailsReference;
        try{
        wrapper.caseObj.Topic__c ='Coordination Of Benefits';
        wrapper.createCase();            
        caseDetailsReference = new PageReference('/' + wrapper.CaseObj.Id);
        }catch(Exception e){
          system.debug(LoggingLevel.INFO, 'Some error has occurred : '+e.getStackTraceString());
          setErrorMsg('GN997',e);//997-->Unknown Error 
            
        }
        return caseDetailsReference;
    }
    public PageReference SaveAndClose(){
        PageReference caseDetailsReference;
        try{
        wrapper.caseObj.Topic__c ='Coordination Of Benefits';
        wrapper.caseObj.Status='Closed';
        wrapper.createCase();            
        caseDetailsReference = new PageReference('/apex/ACETCallTopicSaveAndClose?caseId=' + wrapper.CaseObj.Id);
        system.debug('wrapper.CaseObj.Id  >>>  '+wrapper.CaseObj.Id);
        }catch(Exception e){
          system.debug(LoggingLevel.INFO, 'Some error has occurred : '+e.getStackTraceString());
          setErrorMsg('GN997',e);//997-->Unknown Error 
            
        }
        return caseDetailsReference;
    }
    public list<SelectOption> getOtherInsuranceTypes(){
        List<SelectOption> OtherInsuranceTypeOptions = new List<SelectOption> ();
       OtherInsuranceTypeOptions.add(new SelectOption('--None--','--None--'));         
        // Find all the countries in the custom setting
        try{
        Map<String, ACETOtherInsuranceType__c> InsuranceType = ACETOtherInsuranceType__c.getAll();
        system.debug('232323InsuranceType ' + InsuranceType );
        // Sort them by name
        List<String> InsuranceTypeNames = new List<String>();
        InsuranceTypeNames.addAll(InsuranceType.keySet());
        InsuranceTypeNames.sort();
        
        // Create the Select Options.
        for (String InsuranceTypeName : InsuranceTypeNames) {
            ACETOtherInsuranceType__c InsType = InsuranceType.get(InsuranceTypeName);
            OtherInsuranceTypeOptions.add(new SelectOption(InsType.OtherInsuranceType__c, InsType.Name));
        }
        OtherInsuranceTypeOptions.add(new SelectOption('Other','Other'));
        }catch(Exception e){
          system.debug(LoggingLevel.INFO, 'Some error has occurred : '+e.getStackTraceString());
          setErrorMsg('GN997',e);//997-->Unknown Error 
            
        }
        return OtherInsuranceTypeOptions;
    } 
    public list<SelectOption> getCoverageTypes(){
        List<SelectOption> CoverageTypesoptions = new List<SelectOption> ();
       // CoverageTypesoptions.add(new SelectOption('Medical Care','Medical Care'));         
        
        try{
        Map<String, ACETCoveragesTypes__c> CoveragesTypes = ACETCoveragesTypes__c.getAll();
        List<String> CoveragesTypesNames = new List<String>();
        CoveragesTypesNames.addAll(CoveragesTypes.keySet());
        CoveragesTypesNames.sort();
        
        // Create the Select Options.
        for (String CoveragesType : CoveragesTypesNames) {
            ACETCoveragesTypes__c CovType = CoveragesTypes.get(CoveragesType);
            CoverageTypesoptions.add(new SelectOption(CovType.Name, CovType.CoverageType__c));
        }
        }catch(Exception e){
          system.debug(LoggingLevel.INFO, 'Some error has occurred : '+e.getStackTraceString());
          setErrorMsg('GN997',e);//997-->Unknown Error 
            
        }
        return CoverageTypesoptions;
    }   
    public list<SelectOption> getGovCoverageTypes(){
        List<SelectOption> CoverageTypesoptions = new List<SelectOption> ();
        CoverageTypesoptions.add(new SelectOption('--None--','--None--'));       
        try{
        Map<String, ACETGovCoveragesTypes__c> CoveragesTypes = ACETGovCoveragesTypes__c.getAll();
       
        List<String> CoveragesTypesNames = new List<String>();
        CoveragesTypesNames.addAll(CoveragesTypes.keySet());
        CoveragesTypesNames.sort();
        
        // Create the Select Options.
        for (String CoveragesType : CoveragesTypesNames) {
            ACETGovCoveragesTypes__c CovType = CoveragesTypes.get(CoveragesType);
            CoverageTypesoptions.add(new SelectOption(CovType.Name, CovType.CoveragesTypes__c));
        }
        }catch(Exception e){
          system.debug(LoggingLevel.INFO, 'Some error has occurred : '+e.getStackTraceString());
          setErrorMsg('GN997',e);//997-->Unknown Error 
            
        }
        CoverageTypesoptions.add(new SelectOption('Other','Other'));  
        return CoverageTypesoptions;
    }
    public list<SelectOption> getEntitlementreason(){
        
        List<SelectOption> CoverageTypesoptions = new List<SelectOption> ();
        CoverageTypesoptions.add(new SelectOption('--None--','--None--'));         
        try{
        Map<String, ACETEntitlementReason__c> CoveragesTypes = ACETEntitlementReason__c.getAll();
       
        List<String> CoveragesTypesNames = new List<String>();
        CoveragesTypesNames.addAll(CoveragesTypes.keySet());
        CoveragesTypesNames.sort();
        
        // Create the Select Options.
        for (String CoveragesType : CoveragesTypesNames) {
            ACETEntitlementReason__c CovType = CoveragesTypes.get(CoveragesType);
            CoverageTypesoptions.add(new SelectOption(CovType.Name, CovType.Reason__c));
        }
        }catch(Exception e){
          system.debug(LoggingLevel.INFO, 'Some error has occurred : '+e.getStackTraceString());
          setErrorMsg('GN997',e);//997-->Unknown Error 
            
        }
        return CoverageTypesoptions;
    }
    @TestVisible    
    private class wrapperCommercial{
        public String comName{get;set;}
        public String comRelationship{get;set;}
        public String comDob{get;set;}
        public String comAge{get;set;}
        public String comMemberOtherInsurance{get;set;}
        public String comInsuranceType{get;set;}
        public String comPrimary{get;set;}
        public String comComemricalEffectivestart{get;set;}
        public String comComemricalEffectiveEnd{get;set;}
        public String comCustodialParent{get;set;}
        public String comLastDate{get;set;}
        public String comSource{get;set;}
        public String comComments{get;set;}
        public wrapperCommercial()
        {
        }
    }
    @TestVisible
    private class wrapperMedicare{
        public String Name{get;set;}
        public String Relationship{get;set;}
        public String MedicareType{get;set;}
        public String Dob{get;set;}
        public String Age{get;set;}
        public String MedicarePrimary{get;set;}
        public String CrossoverIndicator{get;set;}
        public String EntitleReason{get;set;}
        public String EstimationApplies{get;set;}
        public String EffectiveStartA{get;set;}
        public String EffectiveEndA{get;set;}
        public String EffectiveStartB{get;set;}
        public String EffectiveEndB{get;set;}
        public String EffectiveStartD{get;set;}
        public String EffectiveEndD{get;set;}
        public String LastUpdate{get;set;}
        public String Source{get;set;}
        public String Comments{get;set;}
        public wrapperMedicare(){
        }
    }
}