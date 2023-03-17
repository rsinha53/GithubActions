public with sharing class ACETGroupPlanDetailControllerRedesign extends ACETErrorHandler{
    public string policyNo {get; set;}
    public string stateName {get; set;}
   
    public Boolean ageBandedBool {get; set;}
    public Boolean familyBasedBool {get; set;}
    public ACETCallTopicsDataWrapper wrapper {get;set;}
    public List<AcetGroupDetail.PolicyContract> GroupPolicyResultsList {get; set;}
    public Interaction__c Interaction { get; set; } 
    public Contact Subject { get; set; }
    public String InteractionId {get; set;}
    public String contactId {get; set;}
    public String callTopic {get; set;}
    public string comments {get;set;}
    public string planOptID {get;set;}
    public String groupNumber {get; set;}
    public String planType {get;set;}
    public Boolean IsShowActiveBenefitsOnly {get;set;}
    public List<ACETGroupDetail.GroupPlanWrapper> GroupPlanBenefitResultsList {get; set;}
    public string memberId {get; set;}
    public string benefitBundleOptionId {get; set;}
    public List<ACETGroupDetail.AgeBandWrap> ageBandBelow24List {get; set;}
    public List<ACETGroupDetail.AgeBandWrap> ageBandBelow34List {get; set;}
    public List<ACETGroupDetail.AgeBandWrap> ageBandBelow44List {get; set;}
    public List<ACETGroupDetail.AgeBandWrap> ageBandBelow54List {get; set;}
    public List<ACETGroupDetail.AgeBandWrap> ageBandBelow64List {get; set;}
    public List<ACETGroupDetail.AgeBandWrap> ageBandAbove64List {get; set;}
    public List<ACETGroupDetail.FamilyBasedWrap> familyBasedList {get; set;}
    public transient ACETGroupDetail ACETGroupPlanBenefitDetail {get; set;}
    public ACETGroupDetail ACETGroupPlanDetail {get; set;}
    public transient List<ACETGroupPlanBenefitWrapper.BenefitWrapper> riderList {get; set;}
     public list<ACETGroupPlanBenefitWrapper.PlanInformationWrapper> planInfoList {get;set;}
    public set<String> getErrorMessages {get; set;}
    
    public List<ACETGroupPlanBenefitWrapper.coPayWrapper> coPaySearchResults {get; set;}
    public ACETGroupPlanBenefitWrapper ACETPlanBenefitOONSearchResults {get; set;}
    public transient ACETGroupPlanBenefitWrapper getSubscriptionBenefitCallOutSearchResults {get; set;}
    public transient ACETNimbusGetSSBAPI ACETGetSubscriptionWS;
    public transient ACETGetEmployerDetailAdapterWebService ACETGetEmployerGroupWS;
    public Map<String,String> copayMapping {get; set;}
    public List<ACETGroupPlanBenefitWrapper.coPayWrapper> coPayList {get; set;}
    public List<ACETGroupPlanBenefitWrapper.individualBenefitWrapper> individualFinalList {get; set;}
    public List<ACETGroupPlanBenefitWrapper.familyBenefitWrapper> familyFinalList {get; set;}
    public List<ACETGroupDetail.GroupPlanWrapper> getEmployerCallOutSearchResults {get; set;}
    
    public transient ACETGroupPlanBenefitWrapper ACETPlanBenefitSearchResults {get; set;}
    public ACETHighlightsPanelAdditionalInfo AdditionalInfo {get;set;}
    public list<AncillaryPlans> ancillaryPlansList{get;set;}
    public Boolean noresults{get;set;}
    public String hpAdditionInfoStr {get{
        return JSON.serialize(AdditionalInfo);
    }set;} 
    
    public ACETNimbusGetSSBAPI ACETGetSubscriptionRedesignWS;
    
    public string CoverageType {get; set;}
    public string EffectiveDate{get; set;}
    public string EndDate {get; set;}
    public string SRKID {get; set;}
    public string covrgLevel {get; set;}
    public string accumAsOf {get; set;}
    public String groupId{get;set;}
    public String renewalDate{get;set;}
    public string groupEffectiveDate{get;set;}
    public String contractId{get;set;}
    public String status{get;set;}
    public String effectDate{get;set;}
    public String SitusState{get;set;}
    public String ACETSubscriptionServices {get; set;}
    
    //US3579758 Start: Added By Manish
    public String bookOfBusinessTypeCode{get;set;} 
    public boolean showCirrusBen{get;set;}
    //US3579758 End
    public ACETGroupPlanDetailControllerRedesign () {
      try{
        individualFinalList = new List<ACETGroupPlanBenefitWrapper.individualBenefitWrapper>();
        familyFinalList = new List<ACETGroupPlanBenefitWrapper.familyBenefitWrapper>();
        copayMapping = new Map<String,String>();      
        InteractionId = apexpages.currentpage().getparameters().get('interactionId');
        contactId = apexpages.currentpage().getparameters().get('contactId');
        callTopic = apexpages.currentpage().getparameters().get('callTopic');
        groupNumber = apexpages.currentpage().getparameters().get('groupId');
        groupId = apexpages.currentpage().getparameters().get('groupId');
        contractId = apexpages.currentpage().getparameters().get('contractId');
        status = apexpages.currentpage().getparameters().get('status');
        effectDate = apexpages.currentpage().getparameters().get('effectDate');
        planOptID = apexpages.currentpage().getparameters().get('planOptionID');
        Interaction = ACETProviderUtility.GetInteractionByID(InteractionId);

        //CoverageType = apexpages.currentpage().getparameters().get('CoverageType');
        EffectiveDate = apexpages.currentpage().getparameters().get('effectiveDate');
        EndDate = apexpages.currentpage().getparameters().get('endDate'); 
        //SRKID = apexpages.currentpage().getparameters().get('SRK');
        //MemberId = apexpages.currentpage().getparameters().get('MemberId');
        //covrgLevel = ApexPages.currentPage().getParameters().get('cvrlevel');

        System.debug('Entering'+Interaction);
        wrapper = new ACETCallTopicsDataWrapper();
        wrapper.CaseObj.Topic__c = callTopic;
        wrapper.AutodocComment = comments;
       // initHighlightPanelAdditionalInfo();
        policyNo = ApexPages.currentPage().getParameters().get('policyNo');
        stateName = ApexPages.currentPage().getParameters().get('stateName');
        /*if(stateName != null) {
          if(stateName == 'CT') {
                ageBandedBool = true;
            }
        }*/
        familyBasedBool = true;
        ageBandedBool = true;
        memberId = '';
        benefitBundleOptionId = policyNo;
        initHighlightPanelAdditionalInfo();
        renewalDate = apexpages.currentpage().getparameters().get('renewalDate');
        groupEffectiveDate = apexpages.currentpage().getparameters().get('effectiveDate');
        System.debug('*****'+groupEffectiveDate);
        System.debug('**** Renewal**'+RenewalDate);
	    System.debug('@@@benefitBundleOptionId '+benefitBundleOptionId);
        System.debug('@@@groupNumber '+groupNumber);
        noresults = true;
        getAncillaryData();
        //US3579758 Start: Added By Manish
        bookOfBusinessTypeCode = apexpages.currentpage().getparameters().get('bookOfBusinessTypeCode');
        showCirrusBen = true;
        if(bookOfBusinessTypeCode != 'OX' && bookOfBusinessTypeCode != 'LF' && bookOfBusinessTypeCode != 'OL'){
              showCirrusBen = false;
        }
        //US3579758 End
        }catch(Exception e){
          setErrorMsg('MGD997',e);
        }
    }
    
    public Object CallWSOnPageLoad()
    {
        system.debug(LoggingLevel.INFO, 'Inside CallWSOnPageLoad.');
        ACETGetEmployerGroupWS = new ACETGetEmployerDetailAdapterWebService();
        Continuation PageLoadContinuation = ACETGetEmployerGroupWS.StartRequest(groupNumber, 'CallWSOnPageLoadCallback', null);
        ACETGetSubscriptionWS = new ACETNimbusGetSSBAPI();
        system.debug('groupNumberHere******'+ groupNumber);
        ACETGetSubscriptionWS.providerStartRequest(benefitBundleOptionId, planOptID , 'SRK', '','', ChangeDateFormatForOIL(EffectiveDate), ChangeDateFormatForOIL(EndDate), '', '', '', '', groupNumber, '','', 'CallWSOnPageLoadCallback', PageLoadContinuation, 'group');
        
        //ACETGetSubscriptionRedesignWS = new ACETGetSubscriptionRedesignWebservice();
        //ACETGetSubscriptionRedesignWS.StartRequest(policyNo, '', 'CallWSOnPageLoadCallback', PageLoadContinuation);
        return PageLoadContinuation; 
    }
    
   
   public PageReference CallWSOnPageLoadCallback() {
        
        ACETGroupPlanBenefitDetail = new ACETGroupDetail();
        ACETGroupPlanDetail = new ACETGroupDetail();
        getErrorMessages = new set<String>();
        getSubscriptionBenefitCallOutSearchResults = new ACETGroupPlanBenefitWrapper();
       
        ACETWSCalloutResult getEmployerCallOutResponse = ACETGetEmployerGroupWS.ProcessResponse(ACETGetEmployerGroupWS.RequestLabel);
        System.debug(LoggingLevel.INFO, 'First callout result: ' + getEmployerCallOutResponse);
        
        if(getEmployerCallOutResponse != null && getEmployerCallOutResponse.Success) {
            getEmployerCallOutSearchResults = new List<ACETGroupDetail.GroupPlanWrapper>();
            ACETGroupPlanBenefitDetail = (ACETGroupDetail)getEmployerCallOutResponse.response; 
            //getEmployerCallOutSearchResults = ACETGroupPlanBenefitDetail.GroupPlanBenefitList;           
            //getemp V3 starts
            //for policy contract
            contractId = apexpages.currentpage().getparameters().get('contractId');
            status = apexpages.currentpage().getparameters().get('status');
            effectDate = apexpages.currentpage().getparameters().get('effectDate');
            endDate = apexpages.currentpage().getparameters().get('endDate');
            GroupPolicyResultsList = new List<AcetGroupDetail.PolicyContract>();
            GroupPlanBenefitResultsList = new List<ACETGroupDetail.GroupPlanWrapper>();
            if(IsShowActiveBenefitsOnly == null) {
                IsShowActiveBenefitsOnly = true;   
            }
            else{
                IsShowActiveBenefitsOnly = !IsShowActiveBenefitsOnly;
            }
            if(ACETGroupPlanBenefitDetail.polContract != null){
                System.debug('inside polContract null check' + ACETGroupPlanBenefitDetail);
                for(ACETGroupDetail.PolicyContract polCon: ACETGroupPlanBenefitDetail.polContract){
                    System.debug('inside polContract ' + polCon);
                    if(polCon.insurRules != null){
                        for(ACETGroupDetail.InsuredRules polinsurRules:polCon.insurRules){
                               if((polinsurRules.EffectiveDate != null && polinsurRules.endDate != null)&&(effectDate == polinsurRules.EffectiveDate)&&(endDate ==  polinsurRules.endDate)){
                            ACETGroupPlanDetail.dependentCutOff = polinsurRules.dependentCutOff;
                            }
                                
                                                                         
                            
                            
                        }
                    }
                    if(polCon.GroupPlanBenefitList != null){
                        for(ACETGroupDetail.GroupPlanWrapper groupPlan:polCon.GroupPlanBenefitList) {
                            if(!IsShowActiveBenefitsOnly || groupPlan.getImage() == 'active') {
                                System.debug('All1******'+groupPlan);
                                GroupPlanBenefitResultsList.add(groupPlan);
                                System.debug('GroupPlanBenefitResultsList***'+GroupPlanBenefitResultsList);
                            }
                        }
                    }
                    System.debug('if statement check '+status+':'+polCon.policyActualStatus+','+contractId+':'+polCon.policyConId+','+effectDate+':'+polCon.effectiveDate+','+endDate+':'+polCon.endDate);
                    if(status == polCon.policyActualStatus && contractId == polCon.policyConId && effectDate == polCon.effectiveDate && endDate == polCon.endDate){
                        System.debug('Adding the policy contracts' );
                        GroupPolicyResultsList.add(polCon);
                        System.debug('GroupPolicyResultsList***'+GroupPolicyResultsList);
                        SitusState = (polCon.groupSitusState != null)?polCon.groupSitusState:'';
                        System.debug('SitusState'+SitusState);
                    } 
                    if(contractId == polCon.policyConId && status == polCon.policyActualStatus && effectDate == polCon.effectiveDate){
                        System.debug('in polCon for loop     ' + policyNo + '.' + polCon.benefitBundleID);
                        //if policyNo == policy contract.benefitbundle id
                        if(polCon.benefitBundleID.contains(policyNo) && polCon.GroupPlanBenefitList != null){
                            System.debug('in comparing bundle id if');
                            //for groupplanwrapper
                            for(ACETGroupDetail.GroupPlanWrapper gpw:polCon.GroupPlanBenefitList) {
                                System.debug('in groupplanwrapper if');
                                System.debug(LoggingLevel.INFO,'gpw.bundleID:::'+policyNo+gpw.bundleID);
                                if(gpw.bundleID == policyNo ) {
                                    ageBandBelow24List = new List<ACETGroupDetail.AgeBandWrap>();
                                    ageBandBelow34List = new List<ACETGroupDetail.AgeBandWrap>();
                                    ageBandBelow44List = new List<ACETGroupDetail.AgeBandWrap>();
                                    ageBandBelow54List = new List<ACETGroupDetail.AgeBandWrap>();
                                    ageBandBelow64List = new List<ACETGroupDetail.AgeBandWrap>();
                                    ageBandAbove64List = new List<ACETGroupDetail.AgeBandWrap>();
                                    System.debug('Entering If Loop>>>'+gpw);
                                    //Plan Summary Info
                                    ACETGroupPlanDetail.policyNo= gpw.bundleID;
                                    ACETGroupPlanDetail.planId= gpw.planId;
                                    ACETGroupPlanDetail.Gated = gpw.Gated;
                                    ACETGroupPlanDetail.Accumulator = gpw.Accumulator;
                                    ACETGroupPlanDetail.PlanClass = gpw.PlanClass;
                                    ACETGroupPlanDetail.Product = gpw.Product;
                                    ACETGroupPlanDetail.Gated = gpw.Gated;
                                    //ACETGroupPlanDetail.PCPRequired = gpw.PCPRequired;
                                    ACETGroupPlanDetail.PlanMettalicLevel = gpw.PlanMettalicLevel;
                                    ACETGroupPlanDetail.Network = gpw.Network;
                                    ACETGroupPlanDetail.Tier = gpw.Tier;
                                    ACETGroupPlanDetail.effecDate= gpw.effecDate;
                                    ACETGroupPlanDetail.endDate = gpw.endDate;
                                    ACETGroupPlanDetail.situsState = (gpw.stateOfIssueCode != Null)?gpw.stateOfIssueCode:'';
                                    //US957991 starts
                                    ACETGroupPlanDetail.hsaAvailable = gpw.hsaAvailable;
                                    ACETGroupPlanDetail.hsaElected = gpw.hsaElected;
                                    ACETGroupPlanDetail.administeredBy = gpw.administeredBy;
                                    ACETGroupPlanDetail.phone = gpw.phone;
                                    //US957991 ends
                                    ACETGroupPlanDetail.domPartner = gpw.domPartner;
                                    ACETGroupPlanDetail.FundingArrangement= gpw.FundingArrangement;
                                    System.debug('Entering AgeBand......'+gpw.ageBandGroupPlanList);
                                    if(gpw.familyBasedGroupPlanList.size() > 0) {  
                                        familyBasedBool = true;
                                        ageBandedBool = false;              
                                        familyBasedList = new list<ACETGroupDetail.FamilyBasedWrap>();
                                        for(ACETGroupDetail.FamilyBasedWrap familyBasedgpw: gpw.familyBasedGroupPlanList) {
                                            ACETGroupDetail.FamilyBasedWrap familyBasedItem = new ACETGroupDetail.FamilyBasedWrap();
                                            familyBasedItem.contractTypeCode = familyBasedgpw.contractTypeCode;
                                            familyBasedItem.contractTypeDescription = familyBasedgpw.contractTypeDescription;
                                            familyBasedItem.amount = familyBasedgpw.amount; 
                                            familyBasedList.add(familyBasedItem);
                                        }
                                        if(familyBasedList != null) {
                                            List<ACETGroupDetail.FamilyBasedWrap> familyBasedUnsortedList = familyBasedList;
                                            familyBasedList = new list<ACETGroupDetail.FamilyBasedWrap>();
                                            
                                            for(ACETGroupDetail.FamilyBasedWrap familyRate:familyBasedUnsortedList){
                                                if(familyRate.contractTypeCode == '1'){
                                                    familyBasedList.add(familyRate);
                                                }
                                            }
                                            for(ACETGroupDetail.FamilyBasedWrap familyRate:familyBasedUnsortedList){
                                                if(familyRate.contractTypeCode == '2'){
                                                    familyBasedList.add(familyRate);
                                                }
                                            }
                                            
                                            for(ACETGroupDetail.FamilyBasedWrap familyRate:familyBasedUnsortedList){
                                                if(familyRate.contractTypeCode == '3'){
                                                    familyBasedList.add(familyRate);
                                                }
                                            }
                                            
                                            for(ACETGroupDetail.FamilyBasedWrap familyRate:familyBasedUnsortedList){
                                                if(familyRate.contractTypeCode == '4'){
                                                    familyBasedList.add(familyRate);
                                                }
                                            }
                                            for(ACETGroupDetail.FamilyBasedWrap familyRate:familyBasedUnsortedList){
                                                if(familyRate.contractTypeCode == '5'){
                                                    familyBasedList.add(familyRate);
                                                }
                                            }
                                            
                                        }
                                    } else if(gpw.ageBandGroupPlanList != null) {
                                        familyBasedBool = false;
                                        ageBandedBool = true;
                                        for(ACETGroupDetail.AgeBandWrap ageBandgpw: gpw.ageBandGroupPlanList) {
                                            Integer ageBand = Integer.valueOf(ageBandgpw.AgeBand);
                                            if(ageBand < 15) {
                                                System.debug('<15++++++'+ageBand);
                                                ACETGroupDetail.AgeBandWrap ageWrap  = new ACETGroupDetail.AgeBandWrap();
                                                ageWrap.AgeBand = '<15';
                                                ageWrap.Premium = ageBandgpw.premium;
                                                if(ageBandBelow24List.isEmpty()) {
                                                    ageBandBelow24List.add(ageWrap);
                                                    System.debug('AgeBand 24'+ageBandBelow24List);
                                                    //ageBandBelow20List.sort();
                                                } 
                                                //break;
                                            }
                                            
                                            if(ageBand >= 15 && ageBand <= 23) {
                                                ageBandBelow24List.add(ageBandgpw);
                                                ageBandBelow24List.sort();
                                            }
                                            if(ageBand >= 24 && ageBand < 34) {
                                                ageBandBelow34List.add(ageBandgpw);
                                                ageBandBelow34List.sort();
                                            }
                                            if(ageBand >= 34 && ageBand < 44) {
                                                ageBandBelow44List.add(ageBandgpw);
                                                ageBandBelow44List.sort();
                                            }
                                            if(ageBand >= 44 && ageBand < 54) {
                                                ageBandBelow54List.add(ageBandgpw);
                                                ageBandBelow54List.sort();
                                            }
                                            if(ageBand >= 54 && ageBand < 64) {
                                                ageBandBelow64List.add(ageBandgpw);
                                                ageBandBelow64List.sort();
                                            }
                                            if(ageBand >= 64) {
                                                ACETGroupDetail.AgeBandWrap ageWrap  = new ACETGroupDetail.AgeBandWrap();
                                                ageWrap.AgeBand = '64+';
                                                ageWrap.Premium = ageBandgpw.premium;
                                                if(ageBandAbove64List.isEmpty()) {
                                                    ageBandAbove64List.add(ageWrap);
                                                } 
                                            } 
                                        }
                                    }
                                }       
                            }
                        }
                    }
                }
            }
            System.debug('SIZESIZE ' + GroupPlanBenefitResultsList.size() + ';' + GroupPolicyResultsList.size());
        } //getemp V3 ends
          else {
            if(getEmployerCallOutResponse.statusCode==400){
              setErrorMsg('GN'+'400B',null);
            }else{
               setErrorMsg('GN'+getEmployerCallOutResponse.statusCode,null);
            }
            //getErrorMessages.add(getEmployerCallOutResponse.Message);
        }    
        
        
        ACETWSCalloutResult getSubscriptionBenefitCallOutResponse = ACETGetSubscriptionWS.ProcessResponse(ACETGetSubscriptionWS.RequestLabel,SitusState);
        System.debug(LoggingLevel.INFO, 'Second callout result: ' + getSubscriptionBenefitCallOutResponse);
        
        if(getSubscriptionBenefitCallOutResponse != null && getSubscriptionBenefitCallOutResponse.Success) {
            try{
                ACETPlanBenefitSearchResults = (ACETGroupPlanBenefitWrapper)getSubscriptionBenefitCallOutResponse.response;
                System.debug('Allwoi'+ACETPlanBenefitSearchResults);
                getSubscriptionBenefitCallOutSearchResults = (ACETGroupPlanBenefitWrapper)getSubscriptionBenefitCallOutResponse.response;
                ACETSubscriptionServices = getSubscriptionBenefitCallOutResponse.responseBody;
                riderList = new List<ACETGroupPlanBenefitWrapper.BenefitWrapper>(); 
                riderList = getSubscriptionBenefitCallOutSearchResults.benefitWrapperList;
                planInfoList =  new list<ACETGroupPlanBenefitWrapper.PlanInformationWrapper>();
                planInfoList = getSubscriptionBenefitCallOutSearchResults.planInfoWrapperList;
                system.debug('planInfoList:::'+planInfoList);
                if(planInfoList.size()>0){
                   for(ACETGroupPlanBenefitWrapper.PlanInformationWrapper pp:planInfoList){
                        system.debug('>>>'+pp.planTypeCode);
                       planType = pp.planTypeCode;
                      
                     
                       ACETGroupPlanDetail.tieredPlan = pp.qualityProviderTierRuleID;
                       ACETGroupPlanDetail.PCPRequired = pp.pcpRequiredIndicator;
                   } 
                } 
                if(getSubscriptionBenefitCallOutSearchResults.individualBenefitWrapperList!=null && !getSubscriptionBenefitCallOutSearchResults.individualBenefitWrapperList.isempty()){
                    individualFinalList.add(getSubscriptionBenefitCallOutSearchResults.individualBenefitWrapperList[0]);
                }
            }
            catch(Exception ex){
                setErrorMsg('MGD997',ex);
            }
        }    
        else {
             getErrorMessages.add(getSubscriptionBenefitCallOutResponse.Message);
         }
        
        if(getErrorMessages != null) {
            for(String msg: getErrorMessages) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error, msg));    
            }
        }
        initHighlightPanelAdditionalInfo();
        return null;
    }
    
    public List<ACETGroupPlanBenefitWrapper.coPayWrapper> getCoPayInfoSearchResults() {
        List<ACETGroupPlanBenefitWrapper.coPayWrapper> coPayList = new List<ACETGroupPlanBenefitWrapper.coPayWrapper>();
        ACETGroupPlanBenefitWrapper.coPayWrapper coPayPCP = new ACETGroupPlanBenefitWrapper.coPayWrapper();
        coPayPCP.Label = 'PCP';
        coPayPCP.value =  (copayMapping.get('PCP') != null)?copayMapping.get('PCP'):'';
        coPayList.add(coPayPCP);
        ACETGroupPlanBenefitWrapper.coPayWrapper coPaySpecialist = new ACETGroupPlanBenefitWrapper.coPayWrapper();
        coPaySpecialist.Label = 'Specialist';
        coPaySpecialist.value = (copayMapping.get('Specialist') != null)?copayMapping.get('Specialist'):'';
        coPayList.add(coPaySpecialist);
        ACETGroupPlanBenefitWrapper.coPayWrapper coPayER = new ACETGroupPlanBenefitWrapper.coPayWrapper();
        coPayER.Label = 'ER Visit';
        coPayER.value = (copayMapping.get('ER Visit') != null)?copayMapping.get('ER Visit'):'';
        coPayList.add(coPayER);
        return coPayList;
    }
    
   private void initHighlightPanelAdditionalInfo(){
     try{
        if(AdditionalInfo == null){
            AdditionalInfo = new ACETHighlightsPanelAdditionalInfo(); 
        }        
        string addInfo = ApexPages.currentPage().getParameters().get('additionalInfo');
        if(addInfo != null)
        {
            AdditionalInfo  = (ACETHighlightsPanelAdditionalInfo)JSON.deserialize(addInfo, ACETHighlightsPanelAdditionalInfo.class);
        }
        /******added by sourabh ****/
        if(Interaction != Null && Interaction.Highlight_Panel_GroupInfo__c != null)
        {
            ACETGroupDetailsWrapper deserializedExceptionData = (ACETGroupDetailsWrapper)JSON.deserialize(Interaction.Highlight_Panel_GroupInfo__c, ACETGroupDetailsWrapper.class);
            AdditionalInfo.UHCBS = deserializedExceptionData.UHCBS;    
            AdditionalInfo.GroupN = deserializedExceptionData.GroupName ;
            AdditionalInfo.GroupStatus = deserializedExceptionData.GroupStatus;
            AdditionalInfo.ServiceTeam = deserializedExceptionData.ServiceTeam;
            AdditionalInfo.RiskManagement = deserializedExceptionData.RiskManagement;
            AdditionalInfo.RatingMethod = '';
            AdditionalInfo.RenewalDate= deserializedExceptionData.RenewalDate; 
            AdditionalInfo.RelationshipType = deserializedExceptionData.RelationshipType ;
            AdditionalInfo.groupSName = deserializedExceptionData.groupSName;
           if(getEmployerCallOutSearchResults != null && !getEmployerCallOutSearchResults.isempty() && getEmployerCallOutSearchResults[0].stateOfIssueCode != Null){
            AdditionalInfo.SitusState = getEmployerCallOutSearchResults[0].stateOfIssueCode;
           }
        }  
        hpAdditionInfoStr = JSON.serialize(AdditionalInfo);
        system.debug('Testing heighlight panel'+hpAdditionInfoStr);
        }catch(Exception ex){
          setErrorMsg('MGD997',ex);
        }
    }
    
    public String ChangeDateFormatForOIL(String OILDate) {
        String FormattedDate = '';
        try{
        if (String.isNotBlank(OILDate)) {
            List<String> OILDateSplit = OILDate.split('/');
            if(OILDateSplit.size() == 3) {
                Integer strMonth = integer.ValueOf(OILDateSplit[0]);
                Integer strDay = integer.ValueOf(OILDateSplit[1]);
                String appendMonth,appendDay;
                if(strMonth < 10)
                    appendMonth = 0 + String.valueOf(strMonth);
                else
                    appendMonth = String.valueOf(strMonth);
                
                if(strDay < 10)    
                    appendDay = 0 + String.valueOf(strDay);
                else 
                    appendDay = String.valueOf(strDay);
                
                //FormattedDate = OILDateSplit[2] + '-' + OILDateSplit[0] + '-' + OILDateSplit[1];
                FormattedDate = OILDateSplit[2] + '-' + appendMonth + '-' + appendDay;
            }
        }
        }
        catch(Exception ex){
         setErrorMsg('MGD997',ex);
        }
        return FormattedDate;
    }
    
    /**
    * @description US3732437 Fetching Ancillary Plans Group Flow
    * @author Raviteja | 08-06-2021 | Styx
    **/
    public void getAncillaryData(){
         ACETLGT_AncillaryPlansController.AncillaryData data = new ACETLGT_AncillaryPlansController.AncillaryData();
         system.debug('testgrp '+groupNumber);
         data.groupNumber = groupNumber.escapeHtml4();
         data.benefitBundleOptionId = benefitBundleOptionId;
         string asofdate;
         String effectiveDateNew = EffectiveDate!=null?EffectiveDate.escapeHtml4():'';
         String endDateNew = EndDate!=null?EndDate.escapeHtml4():'';
         if(Date.parse(effectiveDateNew)<=Date.today() && Date.parse(endDateNew)>=Date.today()){
            asofdate = ACETWebserviceHelper.formatDateFromDashToSlash(String.ValueOf(Date.today()));
         }else if(Date.parse(effectiveDateNew) < System.today()){
            asofdate = ACETWebserviceHelper.formatToYYYYMMDD(effectiveDateNew);
         }else if(Date.parse(endDateNew) < System.today()){
            asofdate = ACETWebserviceHelper.formatToYYYYMMDD(endDateNew);
         }
         
         data.asofdate = asofdate;
         data.memberSearch = false;
         ancillaryPlansList = new ACETMemberDetailController().processAncillaryData(data);
         if(ancillaryPlansList!=null && ancillaryPlansList.size()>0){
            noresults = false;
         }else{
            noresults = true;
         }
     }
    
}