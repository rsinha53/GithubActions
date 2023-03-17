public with sharing class ACETGroupPlanBenefitExcelController {
    public String baseURL{get;set;}
    public String groupName {get; set;}
    public String groupNameId {get; set;}
    public String bundleID {get; set;}
    public String contractId {get;set;}
    public String groupNumber {get;set;}
    public String bundleOptId{get;set;}
    public Boolean ageBandedBool {get; set;}
    public Boolean familyBasedBool {get; set;}
    public List<ACETGroupDetail.AgeBandWrap> ageBandBelow24List {get; set;}
    public List<ACETGroupDetail.AgeBandWrap> ageBandBelow34List {get; set;}
    public List<ACETGroupDetail.AgeBandWrap> ageBandBelow44List {get; set;}
    public List<ACETGroupDetail.AgeBandWrap> ageBandBelow54List {get; set;}
    public List<ACETGroupDetail.AgeBandWrap> ageBandBelow64List {get; set;}
    public List<ACETGroupDetail.AgeBandWrap> ageBandAbove64List {get; set;}
    public List<ACETGroupDetail.FamilyBasedWrap> familyBasedList {get; set;}
    public ACETGroupDetail groupPlanDetails{get; set;}
    public ACETGroupDetail ACETGroupPlanDetail {get; set;}
    public set<String> getErrorMessages {get; set;}
    public List<ACETGroupDetail.GroupPlanWrapper> GroupPlanBenefitResultsList {get; set;}
    public List<AcetGroupDetail.PolicyContract> GroupPolicyResultsList {get; set;}
    public string currentDate{get;set;}
    public string EffectiveDate{get; set;}
    public string EndDate {get; set;}
    public String groupId{get;set;}
    public String status{get;set;}
    public String effectDate{get;set;}
    public Boolean IsShowActiveBenefitsOnly {get;set;}
    
    public ACETGroupPlanBenefitExcelController() {
        groupNameId = apexpages.currentpage().getparameters().get('groupName');
        bundleID = apexpages.currentpage().getparameters().get('bundleId');
        contractId = apexpages.currentpage().getparameters().get('contractId');
        groupNumber = apexpages.currentpage().getparameters().get('groupNumber');
        bundleOptId= ApexPages.currentPage().getParameters().get('policyNo');
        EffectiveDate = apexpages.currentpage().getparameters().get('effectiveDate');
        EndDate = apexpages.currentpage().getparameters().get('endDate');
        currentDate = Date.Today().month() + '/' + Date.Today().day() + '/' + Date.Today().year();
        baseURL=URL.getSalesforceBaseUrl().toExternalForm();
        if(groupNameId != null) {
            String[] strSplit = groupNameId.split('-');
            if(strSplit.size() > 0) {
                groupId = strSplit[0].trim();
                groupName = strSplit[1].trim();
            }
        } 
        //CallWSOnPageLoad();
    }    
    
    public static ACETWSCalloutResult callwebservice(string groupId)
    {
        ACETGetEmployerDetailAdapterWebService stubData = new ACETGetEmployerDetailAdapterWebService();
        ACETWSCalloutResult responseData = stubData.getEmployerGroupDetail(groupId);
        System.debug('Allowing.................'+responseData);
        return responseData;
    }
    
    public void CallWSOnPageLoad(){    
        
        ACETGroupPlanDetail = new ACETGroupDetail();
        getErrorMessages = new set<String>();
        
        
            //for policy contract
            groupNumber = apexpages.currentpage().getparameters().get('groupNumber');
            contractId = apexpages.currentpage().getparameters().get('contractId');
            status = apexpages.currentpage().getparameters().get('status');
            effectiveDate = apexpages.currentpage().getparameters().get('effectiveDate');
            endDate = apexpages.currentpage().getparameters().get('endDate');
            groupNameId = apexpages.currentpage().getparameters().get('groupIdName');
            bundleID = apexpages.currentpage().getparameters().get('bundleId');
            bundleOptId= ApexPages.currentPage().getParameters().get('policyNo');
            EndDate = apexpages.currentpage().getparameters().get('endDate');
        
            GroupPolicyResultsList = new List<AcetGroupDetail.PolicyContract>();
            GroupPlanBenefitResultsList = new List<ACETGroupDetail.GroupPlanWrapper>();
            if(IsShowActiveBenefitsOnly == null) {
               IsShowActiveBenefitsOnly = true;   
            }
            else{
                IsShowActiveBenefitsOnly = !IsShowActiveBenefitsOnly;
            }
        groupPlanDetails = new ACETGroupDetail(); 
        GroupPlanBenefitResultsList = new List<ACETGroupDetail.GroupPlanWrapper>();
        try {
            ACETWSCalloutResult responseGroupPlanData = callwebservice(groupNumber);
            System.debug('Response1...'+responseGroupPlanData);
            if(responseGroupPlanData.Success) {
                groupPlanDetails = (ACETGroupDetail)responseGroupPlanData.response;
                System.debug('Response2...'+groupPlanDetails);
                System.debug('### All parameters'+contractId + '@@'+status+'@@'+effectiveDate +'@@'+bundleOptId+'@@'+endDate );
                system.debug('###pol'+groupPlanDetails.polContract);
                if(groupPlanDetails.polContract != null){
                    for(ACETGroupDetail.PolicyContract polCon:groupPlanDetails.polContract){
                        system.debug('###politem'+polcon.policyConId + '@@'+polCon.policyActualStatus +'@@'+polCon.effectiveDate +'@@'+polCon.benefitBundleID+'@@'+polCon.endDate);
                    
                    if(contractId == polCon.policyConId && status == polCon.policyActualStatus && effectiveDate == polCon.effectiveDate && endDate == polCon.endDate){
                        System.debug('EXCEL in polCon for loop  Contract MATCHED ' + bundleOptId+ '.' + polCon.benefitBundleID);
                        if(polCon.benefitBundleID.contains(bundleOptId) && polCon.GroupPlanBenefitList != null){
                            System.debug('EXCEL in comparing bundle id if');
                            //for groupplanwrapper
                            for(ACETGroupDetail.GroupPlanWrapper gpw:polCon.GroupPlanBenefitList) {
                                //System.debug('in groupplanwrapper if');
                                //System.debug(LoggingLevel.INFO,'gpw.bundleID:::'+policyNo+gpw.bundleID);
                                if(gpw.bundleID == bundleOptId) {
                                    ageBandBelow24List = new List<ACETGroupDetail.AgeBandWrap>();
                                    ageBandBelow34List = new List<ACETGroupDetail.AgeBandWrap>();
                                    ageBandBelow44List = new List<ACETGroupDetail.AgeBandWrap>();
                                    ageBandBelow54List = new List<ACETGroupDetail.AgeBandWrap>();
                                    ageBandBelow64List = new List<ACETGroupDetail.AgeBandWrap>();
                                    ageBandAbove64List = new List<ACETGroupDetail.AgeBandWrap>();
                                    //System.debug('Entering If Loop>>>'+gpw);
                                    //Plan Summary Info
                                    ACETGroupPlanDetail.policyNo= gpw.bundleID;
                                    ACETGroupPlanDetail.planId= gpw.planId;
                                    ACETGroupPlanDetail.Gated = gpw.Gated;
                                    ACETGroupPlanDetail.Accumulator = gpw.Accumulator;
                                    ACETGroupPlanDetail.PlanClass = gpw.PlanClass;
                                    ACETGroupPlanDetail.Product = gpw.Product;
                                    ACETGroupPlanDetail.Gated = gpw.Gated;
                                    ACETGroupPlanDetail.PCPRequired = gpw.PCPRequired;
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
                                    System.debug('Excel Entering AgeBand......'+gpw.ageBandGroupPlanList);
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
                                                System.debug('Excel <15++++++'+ageBand);
                                                ACETGroupDetail.AgeBandWrap ageWrap  = new ACETGroupDetail.AgeBandWrap();
                                                ageWrap.AgeBand = '<15';
                                                ageWrap.Premium = ageBandgpw.premium;
                                                if(ageBandBelow24List.isEmpty()) {
                                                   ageBandBelow24List.add(ageWrap);
                                                    System.debug('Excel AgeBand 24'+ageBandBelow24List);
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

            }
            else {
                getErrorMessages.add(responseGroupPlanData.Message);
            }
            }
            catch(Exception ex)
        { 
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, label.ACETOILNotAvailable )); 
        }

            System.debug('EXCEL before sizesize');
            System.debug('Excel SIZESIZE ' + GroupPlanBenefitResultsList.size() + ';' + GroupPolicyResultsList.size());
            System.debug('Testing1 ' + ageBandBelow24List);
            System.debug('Testing2 ' + ageBandBelow34List);
            System.debug('Testing3 ' + ageBandBelow44List);
            System.debug('Testing4 ' + ageBandBelow54List);
            System.debug('Testing5 ' + ageBandBelow64List);
            System.debug('Testing6 ' + ageBandAbove64List);
        //} //getemp V3 ends
  
        
        
        //return null;
    }
    public String ChangeDateFormatForOIL(String OILDate) {
        String FormattedDate = '';
        
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
                
                
                FormattedDate = OILDateSplit[2] + '-' + appendMonth + '-' + appendDay;
            }
        }
        
        return FormattedDate;
    }
}