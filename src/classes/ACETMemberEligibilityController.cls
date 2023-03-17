public with sharing class ACETMemberEligibilityController extends ACETErrorHandler{ 
    public String AutoDoc {get;set;}
    public Interaction__c Interaction {get;set;}
    public Contact Subject {get;set;}
    public String response{get;set;}
    public String SourceOriginator {get;set;}
    public ACETHighlightsPanelAdditionalInfo AdditionalInfo {get;set;}
    public Boolean isClaim {get;set;}
    public String memberdetailresponse{get;set;}
    public String memberFullname{get;set;}
    public String PrimaryAddress{get;set;}
    public String MailingAddress{get;set;}
    public Boolean holdCodeAlert{get; set;} 
    public String ClaimAddress{get;set;}
    public String ClaimAddress1{get;set;}    
    public Boolean IsShowActiveCoveragesOnly {get;set;}
    public List<ACETMemberDetail.CoverageLine> Coverages {get;set;}   
    public  List<ACETMemberDetail.CoverageLineHistory> CoverageHistory {get;set;}
    public   ACETMemberDetail.CoverageLine PreferredCoverage {get;set;}
  public String coverageType {get;set;}
  public String coverageGroupNumber {get;set;}
  public String coveragePlanBenId {get;set;}
  public String coverageStartDate {get;set;}
  public String coverageEndDate {get;set;}
  public String coverageToggle {get;set;}
    public String ProferredCoverageGUID {get;set;}    
    public   ACETMemberDetail MemberDetail{get;set;}
    public boolean isCancelCaseCreation{get;set;}
    public boolean isResolved{get;set;}
  public User currentUser {get;set;}
  public String currentAgentProfile {get;set;}
    public ACETCallTopicsDataWrapper wrapper {get;set;}
    public String surrogateKey {get; set;}
  public String selectedSurrogateKey  { get; set; }    
  public String OBGYNName{get;set;}
  public String PCPName{get;set;}
    public static Map<String,String> serviceRequestLabels;
    Transient  ACETGetIndividualWebService ACETGetIndWebservice;
   Transient  ACETFindMembershipWebservice ACETFindMemWebservice;
   Transient  ACETGetMembershipWebService ACETGetMemWebservice;
    transient ACETGetEmployerDetailAdapterWebService ACETGetEmployerService;
   public Set<String> ServiceErrorMSGs  { get; set; }
   public Integer HoldRestStatus;
   public void init(){
     try{
        wrapper = new ACETCallTopicsDataWrapper(); 
        //system.debug(LoggingLevel.INFO,ApexPages.currentPage().getParameters().get('interactionId')); 

        wrapper.CallTopic ='View Member Eligibility';
        wrapper.init(); 
        wrapper.CaseObj.Topic__c = 'View Member Eligibility';
        String strSurrogateKey = apexpages.currentpage().getparameters().get('SRK');
        wrapper.SurrogateKey = strSurrogateKey;
        initHighlightPanelAdditionalInfo();
    currentUser = getUserInfo(UserInfo.getUserId());
        currentAgentProfile = currentUser.profile.name;
     }catch(Exception e){
      system.debug(LoggingLevel.INFO, e.getMessage() +' :: '+e.getStackTraceString());
      setErrorMsg('GN997',e);//GN997-->Unknown Error 

     }
    }
    private void initHighlightPanelAdditionalInfo(){
      try{
        String additionalInfoStr = apexpages.currentpage().getparameters().get('additionalInfo');
        //system.debug(LoggingLevel.INFO,additionalInfoStr );
        if(!String.isEmpty(additionalInfoStr )){ 
            wrapper.AdditionalInfo = (ACETHighlightsPanelAdditionalInfo)json.deserialize(additionalInfoStr,ACETHighlightsPanelAdditionalInfo.class); 
        } 
        System.debug(LoggingLevel.INFO,'AdditionalInfo@@@@='+AdditionalInfo);
      }catch(Exception e){
      system.debug(LoggingLevel.INFO, e.getMessage() +' :: '+e.getStackTraceString());
      setErrorMsg('GN997',e);//GN997-->Unknown Error 

     }
    }
    public void childconsolefunction(){
      try{
        toggleShowCoverages();
      }catch(Exception e){
      system.debug(LoggingLevel.INFO, e.getMessage() +' :: '+e.getStackTraceString());
      setErrorMsg('GN997',e);//GN997-->Unknown Error 
     }
    }

    public void renderCancelCaseSection(){
        isCancelCaseCreation=true;  
    }
    public ACETMemberEligibilityController(){
      try{
        try{
         init();
        }catch(Exception e){
        system.debug(LoggingLevel.INFO, e.getMessage() +' :: '+e.getStackTraceString());
        setErrorMsg('GN997',e);//GN997-->Unknown Error 
        }
        ServiceErrorMSGs = new Set<String>();
        AdditionalInfo = new ACETHighlightsPanelAdditionalInfo();        
        //Get Provider Interaction SFDC Id
        String interactionId = ApexPages.currentPage().getParameters().get('interactionId');    
        //Check if User is redirected to Member Search page from Provider detail page         
        if (!String.isEmpty(interactionId)){                        
            system.debug(LoggingLevel.INFO,'InteractionId: ' + InteractionId);            
            //Query Provider Interaction details
            try{
              Interaction = ACETProviderUtility.GetInteractionByID(interactionId);
            }catch(Exception e){
             system.debug(LoggingLevel.INFO, e.getMessage() +' :: '+e.getStackTraceString());
             setErrorMsg('GN997',e);//GN997-->Unknown Error 
            }
            if(Interaction!=null)
             SourceOriginator = Interaction.Interaction_Type__c;
            system.debug(LoggingLevel.INFO,'Interaction: ' + Interaction + ', SourceOriginator: ' + SourceOriginator);
        }
        String contactId = ApexPages.currentPage().getParameters().get('contactId');
        if (!String.isEmpty(contactId)){ 
             try{
              subject = ACETProviderUtility.GetContactByID(contactId);
             }catch(Exception e){
              system.debug(LoggingLevel.INFO, e.getMessage() +' :: '+e.getStackTraceString());
              setErrorMsg('GN997',e);//GN997-->Unknown Error 
            }
        }
        String addInfo = ApexPages.currentPage().getParameters().get('additionalInfo');
        if(!String.isEmpty(addInfo)){  
            AdditionalInfo = (ACETHighlightsPanelAdditionalInfo)JSON.deserialize(ApexPages.currentPage().getParameters().get('additionalInfo'), ACETHighlightsPanelAdditionalInfo.class);
        }
        surrogateKey = ApexPages.currentPage().getParameters().get('SRK');
        coverageType = ApexPages.currentPage().getParameters().get('CoverageType');
        coverageGroupNumber = ApexPages.currentPage().getParameters().get('CoverageGroupNumber');
        coveragePlanBenId = ApexPages.currentPage().getParameters().get('CoveragePlanId');
        coverageStartDate = ApexPages.currentPage().getParameters().get('coverageStartDate');
        coverageEndDate = ApexPages.currentPage().getParameters().get('coverageEndDate');
        coverageToggle = ApexPages.currentPage().getParameters().get('coverageToggle');
        if (!String.isEmpty(surrogateKey)){ 
            wrapper.surrogateKey = surrogateKey;
        } 
      }catch(Exception e){
        system.debug(LoggingLevel.INFO, e.getMessage() +' :: '+e.getStackTraceString());
        setErrorMsg('GN997',e);//GN997-->Unknown Error 
      }
    }

    public void toggleShowCoverages(){
      try{
        if(IsShowActiveCoveragesOnly == null){
            IsShowActiveCoveragesOnly = true;  
        }else{
            IsShowActiveCoveragesOnly = !IsShowActiveCoveragesOnly;
        }
        system.debug(LoggingLevel.INFO,'IsShowActiveCoveragesOnly '+IsShowActiveCoveragesOnly);
        Coverages = new List<ACETMemberDetail.CoverageLine>();
        if(MemberDetail != null && MemberDetail.CoverageLines != null){      
            for(ACETMemberDetail.CoverageLine c : MemberDetail.CoverageLines){
                if(c.benefitPlanId != null && !string.ISBLANK(c.benefitPlanId) && c.benefitPlanId.length() > 2){
                    if(c.benefitPlanId.toLowerCase().subString(0,2) != 'mr' || c.benefitPlanId.toLowerCase().subString(0,2) != 'MR'){
                        if(!IsShowActiveCoveragesOnly || c.getIsActive()){
                            Coverages.add(c);  
                        }
                    }
                }
                
            }
        }
        system.debug(LoggingLevel.INFO,'Coverages'+Coverages);
        CoverageHistory=new List<ACETMemberDetail.CoverageLineHistory>();
        if(MemberDetail != null && MemberDetail.lstCoverageLineHistory != null){      
            for(ACETMemberDetail.CoverageLineHistory clh : MemberDetail.lstCoverageLineHistory){
                CoverageHistory.add(clh);  
            }
        }
        System.debug(LoggingLevel.INFO,'CoverageHistory='+CoverageHistory);
      }catch(Exception e){
        system.debug(LoggingLevel.INFO, e.getMessage() +' :: '+e.getStackTraceString());
        setErrorMsg('GN997',e);//GN997-->Unknown Error 
      }
    } 
    public void getMemberData(){
        //commented by bhanu: This function is not getting called anywhere
        /*system.debug(LoggingLevel.INFO,'Calling memberData');
        MemberDetail = ACETWebserviceHelper.queryIndividuals(MemberDetail);
        MemberDetail = ACETWebserviceHelper.queryMembership(MemberDetail);
        system.debug(LoggingLevel.INFO,'MemberDetail in eligibility >> '+JSON.serialize(MemberDetail));
        memberFullname = MemberDetail.FirstName + ' ' + MemberDetail.MiddleName + ' ' + MemberDetail.LastName;
        //wrapper.createBlankCase();
        init();*/
    }

    public  Object callMemberServices(){
        /*system.debug(LoggingLevel.INFO,'calling callMemberServices');
        String para = ApexPages.CurrentPage().getParameters().get('param1');
        //System.debug('LoggingLevel.INFO,para@@@@=='+para);
        ApexPages.currentPage().getParameters().put('additionalInfo', para); 
        
        if(!String.isEmpty(para)){  
            AdditionalInfo = (ACETHighlightsPanelAdditionalInfo)JSON.deserialize(para, ACETHighlightsPanelAdditionalInfo.class);
        }*/
        //init();
        //initHighlightPanelAdditionalInfo();

        serviceRequestLabels = new Map<String,String>();
        Continuation PageLoadContinuation;
        MemberDetail = new ACETMemberDetail(); 
        MemberDetail.SurrogateKey = surrogateKey;
        MemberDetail.EligibilityCoverage = new ACETMemberDetail.MemberEligibilityCoverage();
        MemberDetail.isMemberEligibility = true;
        MemberDetail.EligibilityCoverage.CoverageType = ApexPages.currentPage().getParameters().get('CoverageType');
        MemberDetail.EligibilityCoverage.GroupNumber = ApexPages.currentPage().getParameters().get('CoverageGroupNumber');
        MemberDetail.EligibilityCoverage.BenefitPlanId = ApexPages.currentPage().getParameters().get('CoveragePlanId');
        MemberDetail.EligibilityCoverage.EffectiveDate = ApexPages.currentPage().getParameters().get('coverageStartDate');
        MemberDetail.EligibilityCoverage.EndDate = ApexPages.currentPage().getParameters().get('coverageEndDate');
          MemberDetail.custPurchaseinfo  = new ACETMemberDetail.customerPurchaseinfo();
        MemberDetail.custPurchaseinfo.benefitEffectivedate = ApexPages.currentPage().getParameters().get('benefitEffectivedate');//US2962032 added for getemployergroup service callout 
        MemberDetail.custPurchaseinfo.benefitEnddate = ApexPages.currentPage().getParameters().get('benefitEnddate');
        MemberDetail.custPurchaseinfo.planOptionId = ApexPages.currentPage().getParameters().get('planOptionId');
        
    //GetIndividual webservice callout
        ACETGetIndWebservice = new ACETGetIndividualWebService();
        try{
         PageLoadContinuation = ACETGetIndWebservice.StartRequest(MemberDetail.SurrogateKey, MemberDetail,'memberServicesCallback',null);  
        }catch(Exception e){
            system.debug(LoggingLevel.INFO, e.getMessage() +' :: '+e.getStackTraceString());
            setErrorMsg('GN997',e);//GN997-->Unknown Error 
        }
       
        return PageLoadContinuation; 
    }
    public  PageReference memberServicesCallback(){
       try{
        system.debug('LoggingLevel.INFO,calling memberServicesCallback '+ACETGetIndWebservice);
        ACETWSCalloutResult getIndividualResponse, findMembershipResponse,getencodeResponse;
        //ACETMemberDetail MemberDetail;
        try{
         getIndividualResponse = ACETGetIndWebservice.ProcessResponse(ACETGetIndWebservice.RequestLabel, MemberDetail);
        }catch(Exception e){
         system.debug(LoggingLevel.INFO, e.getMessage() +' :: '+e.getStackTraceString());
         setErrorMsg('GN997',e);//GN997-->Unknown Error 
        }
        if(getIndividualResponse!=null && getIndividualResponse.Success) {
            MemberDetail = (ACETMemberDetail)getIndividualResponse.Response;
            if(MemberDetail!=null){
                MemberDetail.OriginatorRelationship = MemberDetail.Relationship;
                system.debug(LoggingLevel.INFO,'MemberDetail Continuation 1 >> '+Json.serialize(MemberDetail));
                if(MemberDetail.disabilityInfo!=Null && MemberDetail.disabilityInfo.size()>0){
                    List<String> diagCodes = new List<String>();
                    if(MemberDetail.disabilityInfo!=null && MemberDetail.disabilityInfo.size()>0){
                        for(ACETMemberDetail.DependentDisability disab: MemberDetail.disabilityInfo){
                         if(!String.isEmpty(disab.diagnosisCode)){
                            diagCodes.add(disab.diagnosisCode);
                         }
                        }
                    }
                    
                    if(diagCodes!=Null && diagCodes.size()>0){
                        system.debug(LoggingLevel.INFO,'getencoder call-----------'+diagCodes);                 
                        ACETEncoderProWebservice encoderWS = new ACETEncoderProWebservice();
                        Map<String, Set<String>> encodeMap =new Map<String, Set<String>>();
                        getencodeResponse=encoderWS.getCodeDescriptions(diagCodes);
                        if(getencodeResponse!=null && getencodeResponse.Success){                    
                            encodeMap = (Map<String, Set<String>>)getencodeResponse.Response;
                            if(MemberDetail.disabilityInfo!=null && MemberDetail.disabilityInfo.size()>0){
                                for(ACETMemberDetail.DependentDisability disab: MemberDetail.disabilityInfo){
                                    if(String.isNotBlank(disab.diagnosisCode) && encodeMap!=null && encodeMap.containskey(disab.diagnosisCode)){
                                        disab.diagnosisDesc= String.join(new List<String>(encodeMap.get(disab.diagnosisCode)), ',');
                                    }
                                }  
                            }
                            
                        }
                    }
                }
            }
            
        }
        else{
            //ApexPages.addMessage(new ApexPages.Message(getIndividualResponse.MessageSeverity,getIndividualResponse.Message));
             ServiceErrorMSGs.add('GN'+getIndividualResponse.statusCode);
             //setErrorMsg('GN'+getIndividualResponse.statusCode,null); 
        }        
       
            ACETWSCalloutResult findMemCalloutResults;
            ACETFindMemCustPurchaseWebservice fmcp = new ACETFindMemCustPurchaseWebservice();
            ACET_WebserviceCalloutFramework wsCallOutFW = new ACET_WebserviceCalloutFramework('Find Membership Customer Purchases API', ACETFindMemCustPurchaseWebservice.getRequestBody(MemberDetail), null);
            HttpResponse response = wsCallOutFW.getResponse();
            findMemCalloutResults  = fmcp.ProcessResponse(response.getBody(), memberDetail);
            if(findMemCalloutResults.Success) {
             MemberDetail = (ACETMemberDetail)findMemCalloutResults.Response;
             }
        system.debug(LoggingLevel.INFO,'MemberDetail first callback '+MemberDetail);
        if(MemberDetail!=null)
         memberFullname = MemberDetail.FirstName!=null?MemberDetail.FirstName:'';
         memberFullname = MemberDetail.MiddleName!=null?memberFullname+ ' '+MemberDetail.MiddleName:memberFullname;
         memberFullname = MemberDetail.LastName!=null?memberFullname+ ' '+MemberDetail.LastName:memberFullname;
        }catch(Exception e){
         system.debug(LoggingLevel.INFO, e.getMessage() +' :: '+e.getStackTraceString());
         setErrorMsg('GN997',e);//GN997-->Unknown Error 
        }
        return null;
    } 

   
    
    public object CallGetMembership(){
        Continuation getMembershipContinuation; 
        try{
        coverageGroupNumber = ApexPages.currentPage().getParameters().get('CoverageGroupNumber');
        ACETGetMemWebservice = new ACETGetMembershipWebService();
        //system.debug(LoggingLevel.INFO,'inside call membership :'+MemberDetail);
        //system.debug(LoggingLevel.INFO,'-------MemberDetail.PreferredCoverage '+MemberDetail.PreferredCoverage );
        //system.debug(LoggingLevel.INFO,'-------MemberDetail.SurrogateKey'+MemberDetail.SurrogateKey);
        if(MemberDetail!=null && MemberDetail.PreferredCoverage != null){
            if(!String.IsEmpty(MemberDetail.SurrogateKey)) {
                ACETGetMemWebservice = new ACETGetMembershipWebService();
                try{
                 getMembershipContinuation = ACETGetMemWebservice.StartRequest(MemberDetail.SurrogateKey,coverageGroupNumber, MemberDetail,'GetMembershipCallback',null); 
                }catch(Exception e){
                  system.debug(LoggingLevel.INFO, e.getMessage() +' :: '+e.getStackTraceString());
                  setErrorMsg('GN997',e);//GN997-->Unknown Error 
                }    
            }else{
                system.debug(LoggingLevel.INFO,'inside call get member id membership');
                ACETGetMemWebservice = new ACETGetMembershipWebService();
                try{
                 //getMembershipContinuation = ACETGetMemWebservice.StartRequest(MemberDetail.MemberId, PreferredCoverage.PolicyNumber, MemberDetail,'GetMembershipCallback',null);
                 getMembershipContinuation = ACETGetMemWebservice.StartRequest(MemberDetail.MemberId, MemberDetail.PreferredCoverage.PolicyNumber, MemberDetail,'GetMembershipCallback',null);
 
                }catch(Exception e){
                  system.debug(LoggingLevel.INFO, e.getMessage() +' :: '+e.getStackTraceString());
                  setErrorMsg('GN997',e);//GN997-->Unknown Error 
                }
             }
                  
         //US1102336 added by Abhinav
         ACETGetEmployerService = new ACETGetEmployerDetailAdapterWebService();
            try{
                getMembershipContinuation = ACETGetEmployerService.StartRequest(MemberDetail.PreferredCoverage.groupNumber, 'GetMembershipCallback' ,getMembershipContinuation );
            }catch(Exception e){
                  system.debug(LoggingLevel.INFO, e.getMessage() +' :: '+e.getStackTraceString());
                  setErrorMsg('GN997',e);//GN997-->Unknown Error 
            }
         }
        }catch(Exception e){
         system.debug(LoggingLevel.INFO, e.getMessage() +' :: '+e.getStackTraceString());
         setErrorMsg('GN997',e);//GN997-->Unknown Error 
        }   
        return  getMembershipContinuation;
    }
    
    public PageReference GetMembershipCallback() {
        system.debug(LoggingLevel.INFO,'inside call bacl method'); 
        ACETWSCalloutResult getMembershipResponse;
        ACETWSCalloutResult getEmployerGroupResult;  // US1102336
        try{
         try{
         getMembershipResponse = ACETGetMemWebservice.ProcessResponse(ACETGetMemWebservice.RequestLabel, MemberDetail);
         }catch(Exception e){
          system.debug(LoggingLevel.INFO, e.getMessage() +' :: '+e.getStackTraceString());
          setErrorMsg('GN997',e);//GN997-->Unknown Error 
         }
        system.debug(LoggingLevel.INFO,'inside call bacl method' + getMembershipResponse); 
        if(getMembershipResponse!=null && getMembershipResponse.Success) {
            MemberDetail = (ACETMemberDetail)getMembershipResponse.Response;
        }
        else{
            system.debug(LoggingLevel.INFO,'getMembershipResponse'+getMembershipResponse);
            //ApexPages.addMessage(new ApexPages.Message(getMembershipResponse.MessageSeverity,getMembershipResponse.Message));
             if(getMembershipResponse.statusCode==400){
              ServiceErrorMSGs.add('GN'+'400B');
            }else{
               ServiceErrorMSGs.add('GN'+getMembershipResponse.statusCode);
            } 
        }
        if(MemberDetail!=null && MemberDetail.OriginatorRelationship == null){
            MemberDetail.OriginatorRelationship = MemberDetail.Relationship;
        }

        //to code refactor
        /*if(PreferredCoverage != null){
            memberDetail.EffectiveDate = PreferredCoverage.EffectiveDate;
            memberDetail.EndDate = PreferredCoverage.EndDate;
            memberDetail.PolicyNumber =  PreferredCoverage.PolicyNumber;
            memberDetail.Product =  PreferredCoverage.Product;
            memberDetail.ProductType =  PreferredCoverage.ProductType;              
        }*/
          if(MemberDetail!=null && MemberDetail.PreferredCoverage != null){
            memberDetail.EffectiveDate = MemberDetail.PreferredCoverage.EffectiveDate;
            memberDetail.EndDate = MemberDetail.PreferredCoverage.EndDate;
            memberDetail.PolicyNumber =  MemberDetail.PreferredCoverage.PolicyNumber;
            memberDetail.Product =  MemberDetail.PreferredCoverage.Product;
            memberDetail.ProductType =  MemberDetail.PreferredCoverage.ProductType;              
        }
        Date endDateformat;
        boolean flag;
        
        //US1102336
         if(MemberDetail!=null)system.debug(LoggingLevel.INFO,'-------MemberDetail.PCPAssignments '+MemberDetail.PCPAssignments );
         if(MemberDetail!=null && MemberDetail.PCPAssignments != null && MemberDetail.PCPAssignments.size()>0){
           for (  ACETMemberDetail.PCPAssignment  pcp: MemberDetail.PCPAssignments){
                Date effectiveDateformat = Date.parse(pcp.effectiveDate);
                
                if(pcp.endDate == '12/31/9999')
                {
                    flag = true;
                }
                else if(pcp.endDate != '12/31/9999')
                {
                    endDateformat = Date.parse(pcp.endDate);
                    flag= false;
                }
                if(flag)
                {
                    if(pcp.pcpAssignmentType == 'OBGYN' && pcp.isActive == true  && effectiveDateformat <= Date.parse(AcetUtility.format(date.today())) ){
                       OBGYNName = pcp.FirstName +' '+ pcp.LastName;
                    }
                    else if (pcp.pcpAssignmentType == 'PCP' && pcp.isActive == true  && effectiveDateformat <= Date.parse(AcetUtility.format(date.today())) ){
                        
                         PCPName = pcp.FirstName +' '+ pcp.LastName;
                        
                    }
                }
                else
                {
                    if(pcp.pcpAssignmentType == 'OBGYN' && pcp.isActive == true  && effectiveDateformat <= Date.parse(AcetUtility.format(date.today())) && EndDateformat >= Date.parse(AcetUtility.format(date.today())) ){
                       OBGYNName = pcp.FirstName +' '+ pcp.LastName;
                        }
                    else if (pcp.pcpAssignmentType == 'PCP' && pcp.isActive == true  && effectiveDateformat <= Date.parse(AcetUtility.format(date.today()))&& EndDateformat >= Date.parse(AcetUtility.format(date.today()))  ){
                        
                         PCPName = pcp.FirstName +' '+ pcp.LastName;
                        
                    }
                }
            }
         }
         }catch(Exception e){
          system.debug(LoggingLevel.INFO, e.getMessage() +' :: '+e.getStackTraceString());
          setErrorMsg('GN997',e);//GN997-->Unknown Error 
         }
        //US1102336

        
         // Changes start for US1102336 by Abhinav
        try{
            try{
            getEmployerGroupResult = ACETGetEmployerService.ProcessResponse(ACETGetEmployerService.RequestLabel, MemberDetail);
            }catch(Exception e){
              system.debug(LoggingLevel.INFO, e.getMessage() +' :: '+e.getStackTraceString());
              setErrorMsg('GN997',e);//GN997-->Unknown Error 
            }
            if(getEmployerGroupResult!=null)system.debug(LoggingLevel.INFO, 'getEmployerGroupResult ::  ' + getEmployerGroupResult + ' ::getEmployerGroupResult.Success :: ' + getEmployerGroupResult.Success);
            if(getEmployerGroupResult!=null && getEmployerGroupResult.Success) {
                MemberDetail = (ACETMemberDetail)getEmployerGroupResult.Response;
                if(MemberDetail!=null)system.debug(LoggingLevel.INFO, 'MemberDetail >> '+JSON.serialize(MemberDetail));
                /*if(Coverages!= null){
                    for(AcetMemberDetail.CoverageLine cl : Coverages){                        
                        if(cl.groupnumber == MemberDetail.PreferredCoverage.groupNumber){
                            cl.OnshoreRestriction = MemberDetail.PreferredCoverage.OnshoreRestriction;
                            cl.OnshoreRestrictionVerbiage = MemberDetail.PreferredCoverage.OnshoreRestrictionVerbiage;
                            cl.onshoreRestrictionCode = MemberDetail.PreferredCoverage.onshoreRestrictionCode;
                        }
                        else{
                            cl.OnshoreRestriction = '';
                            cl.OnshoreRestrictionVerbiage = '';
                            cl.onshoreRestrictionCode = '';
                        }
                    }
                    system.debug(LoggingLevel.INFO,'@@@@code'+MemberDetail.PreferredCoverage.OnshoreRestrictionCode );
                  
                    
                    
                }   */             
            }
            else{
                //bhanu:optimization isServiceError = true;
                //ServiceErrorMSGs.add(getEmployerGroupResult.Message);
                if(getEmployerGroupResult.statusCode==400){
                ServiceErrorMSGs.add('GN'+'400B');
                 }else{
                 ServiceErrorMSGs.add('GN'+getEmployerGroupResult.statusCode);
                 }
            }
            
        }catch(Exception e){
            system.debug(LoggingLevel.INFO, 'getEmployerGroupResult '+e.getstacktracestring());
            setErrorMsg('GN997',e); 

        }
        // Changes end for US1102336 by Abhinav
        system.debug('--------ServiceErrorMSGs-----'+ServiceErrorMSGs);
        if(ServiceErrorMSGs!=null && ServiceErrorMSGs.size()>0){
            for(String s:ServiceErrorMSGs){
             setErrorMsg(s);
            }
        }
        try{
         init();
        }catch(Exception e){
           system.debug(LoggingLevel.INFO, e.getMessage() +' :: '+e.getStackTraceString());
           setErrorMsg('GN997',e);//GN997-->Unknown Error 
         }
            
        if(MemberDetail!=null)system.debug('LoggingLevel.INFO,MemberDetail second callback '+JSON.serialize(MemberDetail));
        return null;
    }  
    
   
  public PageReference saveCase(){                
  try{
     try{
        wrapper.caseObj.Topic__c ='View Member Eligibility';
        wrapper.caseObj.AutoDoc__c = AutoDoc;
        wrapper.createCase();  
      }catch(Exception e){
           system.debug(LoggingLevel.INFO, e.getMessage() +' :: '+e.getStackTraceString());
           setErrorMsg('GN997',e);//GN997-->Unknown Error 
      }
      if(wrapper!=null && wrapper.CaseObj!=null){
        PageReference caseDetailsReference = new PageReference('/' + wrapper.CaseObj.Id);
        return caseDetailsReference;    
      }
     }catch(Exception e){
           system.debug(LoggingLevel.INFO, e.getMessage() +' :: '+e.getStackTraceString());
           setErrorMsg('GN997',e);//GN997-->Unknown Error 
      }
      return null;

    }
    public PageReference routeCase(){
      try{ 
       try{
        wrapper.caseObj.Topic__c ='View Member Eligibility';
        wrapper.createCase();   
        }catch(Exception e){
           system.debug(LoggingLevel.INFO, e.getMessage() +' :: '+e.getStackTraceString());
           setErrorMsg('GN997',e);//GN997-->Technical Issue. Please contact Administrator
        }
        if(wrapper!=null && wrapper.CaseObj!=null){
          PageReference caseDetailsReference = new PageReference('/' + wrapper.CaseObj.Id);
          return caseDetailsReference;
        }
      }catch(Exception e){
           system.debug(LoggingLevel.INFO, e.getMessage() +' :: '+e.getStackTraceString());
           setErrorMsg('GN997',e);//GN997-->Unknown Error 
      }
        return null;
    }    
    public PageReference Save(){
     try{ 
       try{
        wrapper.caseObj.Topic__c ='View Member Eligibility';
        wrapper.caseObj.AutoDoc__c = AutoDoc;
        wrapper.createCase();       
        }catch(Exception e){
           system.debug(LoggingLevel.INFO, e.getMessage() +' :: '+e.getStackTraceString());
           setErrorMsg('GN997',e);//GN997-->Technical Issue. Please contact Administrator 
        }
         if(wrapper!=null && wrapper.CaseObj!=null){
          PageReference caseDetailsReference = new PageReference('/' + wrapper.CaseObj.Id);
          return caseDetailsReference;
         }
        }catch(Exception e){
           system.debug(LoggingLevel.INFO, e.getMessage() +' :: '+e.getStackTraceString());
           setErrorMsg('GN997',e);//GN997-->Unknown Error 
        }
        return null;
    }
    public PageReference SaveAndClose(){
     try{ 
      try{
        wrapper.caseObj.Topic__c ='View Member Eligibility';
        wrapper.caseObj.Status='Closed';
        wrapper.caseObj.AutoDoc__c = AutoDoc;
        wrapper.createCase();     
      }catch(Exception e){
           system.debug(LoggingLevel.INFO, e.getMessage() +' :: '+e.getStackTraceString());
           setErrorMsg('GN997',e);//GN997-->Technical Issue. Please contact Administrator 
      }
      if(wrapper!=null && wrapper.CaseObj!=null){
        PageReference caseDetailsReference = new PageReference('/apex/ACETCallTopicSaveAndClose?caseId=' + wrapper.CaseObj.Id);
        system.debug(LoggingLevel.INFO,'wrapper.CaseObj.Id  >>>  '+wrapper.CaseObj.Id);
        return caseDetailsReference;
      }
    }catch(Exception e){
           system.debug(LoggingLevel.INFO, e.getMessage() +' :: '+e.getStackTraceString());
           setErrorMsg('GN997',e);//GN997-->Unknown Error 
        }
    return null;
    }
    public void showHoldCode(){
        //if(currentAgentProfile == 'ACET Member' || currentAgentProfile == 'ACET Provider') {
            callHoldRestrictions();
        //}
        holdCodeAlert = true;
    }   
    public void hideHoldCode(){
        holdCodeAlert = false;
    }
    private static user getUserInfo(String userId) {
        User userInfo = [select Agent_Type__c,Profile.Name,FederationIdentifier from User where Id=: userId];
        return userInfo;
    }
    public void callHoldRestrictions(){
        try{
            ACETHoldRestrictionsWebservice holdRestWS = new ACETHoldRestrictionsWebservice();
            ACETWSCalloutResult WSResponse = holdRestWS.holdRestriction(MemberDetail.MemberId, AdditionalInfo.GroupNumber, '', 'All', 'All');
            if(!WSResponse.success){
              if(WSResponse.statusCode!=null){
               HoldRestStatus = WSResponse.statusCode;
               }
            }
            ACETMemberDetail tempMem = (ACETMemberDetail)WSResponse.response;
            if(tempMem!=null){
             memberDetail.holdCodeList = tempMem.holdCodeList;
            }
        }catch(Exception e){
             system.debug(LoggingLevel.INFO, e.getMessage() +' :: '+e.getStackTraceString());
             setErrorMsg('MGD997',e);
        }
    }
    public void showHoldErrorMsgs(){
         system.debug('----HoldRestStatus----------'+HoldRestStatus);
          if(HoldRestStatus!=null){
            if(HoldRestStatus==400){
               setErrorMsg('GN'+'400B');
               HoldRestStatus=null;
            }else{
               setErrorMsg('GN'+HoldRestStatus);
               HoldRestStatus=null;
             }
          }   
      }
}