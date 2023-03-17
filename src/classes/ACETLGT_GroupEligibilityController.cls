/**
 * Will be used as the controller for the ACETLGT_GroupEligibility component
 * Created as part of US2167804
 * 
 **/
public class ACETLGT_GroupEligibilityController extends ACETErrorHandler{
    
    public class SearchResultWrapper{
        @AuraEnabled public ACETLGT_GroupDetail resultWrapper { get; set; }
        @AuraEnabled public List<ACETLGT_GroupDetail.PolicyContract> groupPolicyResultsList { get; set; }
        @AuraEnabled public Map<String, Map<String, List<ACETLGT_GroupDetail.GroupInsuredRules>>> grpsettingsResultMap { get; set; }
        @AuraEnabled public List<ACETLGT_GroupDetail.InsuredRules> allGroupInsuringResults { get; set; }
        @AuraEnabled public Map<String, List<ACETLGT_GroupDetail.InsRule>> settingsResultMap { get; set; }
        @AuraEnabled public String populationSelected { get; set; }
        @AuraEnabled public List<String> populationsList { get; set; }
        @AuraEnabled public List<String> datesList { get; set; }
        @AuraEnabled public Boolean isShow { get; set; }
        @AuraEnabled public Boolean isPop { get; set; }
        @AuraEnabled public String dateSelected { get; set; }
        @AuraEnabled public String ErrorMessage {get;set;}
    }
    
    public class GroupEligibilityWrapper {
        public ACETLGT_GroupDetail resultWrapper;
        public List<ACETLGT_GroupDetail.PolicyContract> groupPolicyResultsList;
        public String populationSelected;
        public String custacctpoplst;
        public String dateSelected;
        public String groupNumber;
        public String contractOptionStatus;
        public String contractOptionEffDate;
        public String contractOptionId;
        public List<String> populationsList;
        public List<String> datesList;
        public List<String> popList;
        public Boolean isCustAcctPop;
        public List<String> contAcctpopList;
        public Boolean isShow;
        public String isMemberFlow;
        public String covEffDate;
        public String covEndDate;
        public String filterStatus;
        public Boolean isPop;
        public Map<String, Map<String, List<ACETLGT_GroupDetail.GroupInsuredRules>>> grpsettingsResultMap;
        public List<ACETLGT_GroupDetail.InsuredRules> allGroupInsuringResults;
        public Map<String, List<ACETLGT_GroupDetail.InsRule>> settingsResultMap;
    }
    
    @AuraEnabled
    public static SearchResultWrapper getEligibilities(String groupNumber, String contractOptionStatus,
                   String contractOptionEffDate, String contractOptionId, String covEffDate, String covEndDate, String isMemberFlow) {
        try{
        ACETLGT_GroupEligibilityController controller = new ACETLGT_GroupEligibilityController();
        GroupEligibilityWrapper wrapper = new GroupEligibilityWrapper();	// to track and handle internal params
        ACETLGT_GetEmployerGroupWebservice service = new ACETLGT_GetEmployerGroupWebservice();
        SearchResultWrapper resultsWrapper = new SearchResultWrapper();
        resultsWrapper.isPop = false;
        ACETLGT_GroupDetail response = new ACETLGT_GroupDetail();
        ACETWSCalloutResult CalloutResult = null;
        
        if (String.isNotBlank(groupNumber)) {
            CalloutResult = service.getEmployerGroupDetail(groupNumber);
            System.debug('results : ' + CalloutResult.Response);
            if (CalloutResult != null && CalloutResult.Success){    
                //	convert into the correct wrapper model
                response = (ACETLGT_GroupDetail)CalloutResult.Response;
                resultsWrapper.resultWrapper = response;
                resultsWrapper.groupPolicyResultsList = controller.getGroupPolicyRestults(response, contractOptionId, contractOptionStatus, contractOptionEffDate);
                
                wrapper.groupPolicyResultsList = resultsWrapper.groupPolicyResultsList;
                wrapper.resultWrapper = response;
                wrapper.contractOptionStatus = contractOptionStatus;
                wrapper.contractOptionId = contractOptionId;
                wrapper.contractOptionEffDate = contractOptionEffDate;
                wrapper.groupNumber = groupNumber;
                wrapper.isMemberFlow = isMemberFlow;	//'true';
                wrapper.covEffDate = covEffDate;
                wrapper.covEndDate = covEndDate;
                
                GroupEligibilityWrapper wr1 = controller.insuringRulesSelection(wrapper);
                resultsWrapper.populationsList = wr1.populationsList;
                resultsWrapper.datesList = wr1.datesList;
                resultsWrapper.dateSelected = wr1.dateSelected;
                resultsWrapper.populationSelected = wr1.populationSelected;
                System.debug('wrapper.populationSelected : ' + wrapper.populationSelected);
                System.debug('wr1.dateSelected : ' + wr1.dateSelected);
                wrapper.populationSelected = wr1.populationSelected;
                wrapper.popList = wr1.popList;
                wrapper.isCustAcctPop = wr1.isCustAcctPop;
                wrapper.custacctpoplst = wr1.custacctpoplst;
                wrapper.contAcctpopList = wr1.contAcctpopList;
                wrapper.isShow = wr1.isShow;
                resultsWrapper.isShow = wr1.isShow;
                
                GroupEligibilityWrapper wr2 = controller.getGroupInsuringRules(wrapper);
                resultsWrapper.isPop = wr2.isPop;
                resultsWrapper.grpsettingsResultMap = wr2.grpsettingsResultMap;
                resultsWrapper.allGroupInsuringResults = wr2.allGroupInsuringResults;
                resultsWrapper.settingsResultMap = wr2.settingsResultMap;
                
                System.debug(' Internal wrapper isPop: ' + resultsWrapper.isPop);
                return resultsWrapper;
            }else{
                SearchResultWrapper detWrap = new SearchResultWrapper();
                detWrap.resultWrapper = new ACETLGT_GroupDetail();
                if(CalloutResult.statusCode == 400)
                    detWrap.ErrorMessage = setLightningErrorMsg('GN'+'400B');
            	else
                detWrap.ErrorMessage = setLightningErrorMsg('GN'+CalloutResult.statusCode );
                system.debug('Val res::: '+detWrap );
                return detWrap;
            }              
        }else{
            SearchResultWrapper detWrap = new SearchResultWrapper();
            detWrap.resultWrapper = new ACETLGT_GroupDetail();
            detWrap.ErrorMessage = setLightningErrorMsg('GN'+CalloutResult.statusCode );
            return detWrap; 
        }                
        }catch(exception e){
            SearchResultWrapper detWrap = new SearchResultWrapper();
            detWrap.resultWrapper = new ACETLGT_GroupDetail();
            detWrap.ErrorMessage = setLightningErrorMsg('MGD997');
            system.debug('Val res::: '+detWrap );
        
            return detWrap;
        }
    }
    
    private List<ACETLGT_GroupDetail.PolicyContract> getGroupPolicyRestults(ACETLGT_GroupDetail groupDetails, String contractId, String status, String effDate) {
        List<ACETLGT_GroupDetail.PolicyContract> contracts = new List<ACETLGT_GroupDetail.PolicyContract>();
        if(groupDetails != null && groupDetails.polContract != null) {
            for(ACETLGT_GroupDetail.PolicyContract polContract : groupDetails.polContract ) {
                System.debug('checking : ' + status + ':' + polContract.policyActualStatus + ',' + contractId +':' + polContract.policyConId +','+effDate+':'+polContract.effectiveDate);
                if(status == polContract.policyActualStatus && contractId == polContract.policyConId && effDate == polContract.effectiveDate){
                    contracts.add(polContract);
                }
            }
        }
        
        return contracts;
    }
    
    private GroupEligibilityWrapper getGroupInsuringRules(GroupEligibilityWrapper wrapper){
        GroupEligibilityWrapper returnWrapper = new GroupEligibilityWrapper();
        Map<String, List<ACETLGT_GroupDetail.InsRule>> settingsResultMap;
        Map<String, Map<String, List<ACETLGT_GroupDetail.GroupInsuredRules>>> grpsettingsResultMap;
        String custacctpoplst = wrapper.custacctpoplst; 	// TODO : need to test properly
        Boolean isCustAcctPop = wrapper.isCustAcctPop != null ? wrapper.isCustAcctPop : false; // TODO : need to test properly
        List<ACETLGT_GroupDetail.InsuredRules> allGroupInsuringResults;
        Boolean isPop = false;	// TODO : check if we need to bring this from top
        List<string> contAcctpopList = wrapper.contAcctpopList;	// TODO : need to test properly
        
        try{
            system.debug('---------custacctpoplst -------'+custacctpoplst);
            settingsResultMap = new Map<String,List<ACETLGT_GroupDetail.InsRule>>();
            grpsettingsResultMap = new Map<String, Map<String, List<ACETLGT_GroupDetail.GroupInsuredRules>>>();
            allGroupInsuringResults = new List<ACETLGT_GroupDetail.InsuredRules>();
            List<ACETLGT_GroupDetail.InsRule> mainGroupInsuringResults;
            ACETLGT_GroupDetail groupPolicyDetails = wrapper.resultWrapper;
            
            if(groupPolicyDetails.groupInsuringRules != null){
                for(ACETLGT_GroupDetail.GroupInsuringRules grpinsRul : groupPolicyDetails.groupInsuringRules) {
                    
                    //Contract option is not defined by population and group settings are standard
                    if(!isCustAcctPop && custacctpoplst == ''){ 
                        system.debug('-------No population---------');
                        mainGroupInsuringResults = new List<ACETLGT_GroupDetail.InsRule>();
                        ACETLGT_GroupDetail.InsuredRules ins = new ACETLGT_GroupDetail.InsuredRules();
                        system.debug('------grpinsRul--------'+grpinsRul);
                            
                        mainGroupInsuringResults = getinsrules(grpinsRul);
                        system.debug('~~~~~~maingrpins'+mainGroupInsuringResults);
                        ins.insrules = mainGroupInsuringResults;
                        ins.population = grpinsRul.classesCode;
                        ins.effectiveDate = grpinsRul.insuringRulesEffectiveDates ;
                        ins.fullDate = grpinsRul.insuringRulesEffectiveDates + ' to '+grpinsRul.insuringRulesExpirationDates;
                        allGroupInsuringResults.add(ins);

                        if(String.isBlank(grpinsRul.classesCode)){
                            system.debug('No Populations !@#');
                            settingsResultMap.put(ins.fullDate , ins.insrules); 
                            isPop = false;
                        }
                        else if(String.isNotBlank(grpinsRul.classesCode)){
                            system.debug('Populations !@#'+grpinsRul.classesCode);
                            isPop = true;
                        }                        
                    }                    
                    
                    else {
                        //Contract option defined by population and group settings also defined by population
                        if(isCustAcctPop && custacctpoplst!=''&&custacctpoplst.contains(grpinsRul.classesCode)){
                            system.debug('-------with population---------');
                            mainGroupInsuringResults = new list<ACETLGT_GroupDetail.InsRule>();
                            ACETLGT_GroupDetail.InsuredRules ins = new ACETLGT_GroupDetail.InsuredRules();
                            system.debug('------grpinsRul-------'+grpinsRul);
                            mainGroupInsuringResults = getinsrules(grpinsRul);
                            system.debug('~~~~~~maingrpins'+mainGroupInsuringResults);
                            ins.insrules = mainGroupInsuringResults;
                            ins.population = grpinsRul.classesCode;
                            ins.effectiveDate = grpinsRul.insuringRulesEffectiveDates ;
                            ins.fullDate = grpinsRul.insuringRulesEffectiveDates + ' to '+grpinsRul.insuringRulesExpirationDates;
                            allGroupInsuringResults.add(ins);

                            if(String.isBlank(grpinsRul.classesCode)){
                                system.debug('No Populations !@#');
                                settingsResultMap.put(ins.fullDate , ins.insrules); 
                                isPop= false;
                            }
                            else if(String.isNotBlank(grpinsRul.classesCode)){
                                system.debug('Populations !@#'+grpinsRul.classesCode);
                                isPop=true;
                            }
                            
                        }
                    } 
                    //Contract option defined by population group settings not defined by population so consider the standard group settings
                    if(allGroupInsuringResults.size() == 0){
                        if(isCustAcctPop && custacctpoplst!='' && grpinsRul.classesCode ==''){
                            system.debug('-------with population--but group settings not defined by population-------');
                            mainGroupInsuringResults = new List<ACETLGT_GroupDetail.InsRule>();
                            ACETLGT_GroupDetail.InsuredRules ins = new ACETLGT_GroupDetail.InsuredRules();
                            mainGroupInsuringResults = getinsrules(grpinsRul);
                            system.debug('~~~~~~maingrpins'+mainGroupInsuringResults);
                            ins.insrules = mainGroupInsuringResults;
                            ins.population = grpinsRul.classesCode;
                            ins.effectiveDate = grpinsRul.insuringRulesEffectiveDates ;
                            ins.fullDate = grpinsRul.insuringRulesEffectiveDates + ' to '+grpinsRul.insuringRulesExpirationDates;
                            allGroupInsuringResults.add(ins);

                            if(String.isBlank(grpinsRul.classesCode)){
                                system.debug('No Populations !@#');
                                settingsResultMap.put(ins.fullDate , ins.insrules); 
                                isPop= false;
                            }
                            else if(String.isNotBlank(grpinsRul.classesCode)){
                                system.debug('Populations !@#'+grpinsRul.classesCode);
                                isPop=true;
                            }
                            
                        }
                    }
                }
            }
            
            allGroupInsuringResults.sort();
            system.debug('~~~~~~allgrpins'+allGroupInsuringResults);
            system.debug('~~~~~~isPop'+isPop);
            
            
            if(isPop){
                system.debug('!@#!@#'+contAcctpopList);
                if(contAcctpopList.size()>0){
                    for(String p : contAcctpopList){                                                
                        ACETLGT_GroupDetail.GroupRules itemgr = new ACETLGT_GroupDetail.GroupRules();
                        for(ACETLGT_GroupDetail.InsuredRules r1 : allGroupInsuringResults){
                            if(p.trim() == r1.population.trim()){ 
                                itemgr.newRules = new list<ACETLGT_GroupDetail.GroupInsuredRules>();
                                ACETLGT_GroupDetail.GroupInsuredRules itemgir = new ACETLGT_GroupDetail.GroupInsuredRules();
                                
                                system.debug('!@# Population matched'+r1.population+ '---'+r1.fullDate);
                                itemgir.pop = r1.population;
                                itemgir.effectiveDate = r1.effectiveDate;
                                itemgir.endDate = r1.endDate;
                                itemgir.fullDate = r1.fullDate;
                                
                                itemgir.insrules = r1.insrules;
                                System.debug(itemgir.fullDate +' Date '+'itemgir.insrules'+ itemgir.insrules);
                                itemgr.newRules.add(itemgir);
                                if(!grpsettingsResultMap.containsKey(p)) {
                                    grpsettingsResultMap.put(p, new map<string,List<ACETLGT_GroupDetail.GroupInsuredRules>>{itemgir.fullDate => itemgr.newRules});
                                    system.debug('!@# Inside no key');
                                }else{
                                    if(!grpsettingsResultMap.get(p).containskey(itemgir.fullDate)){
                                        grpsettingsResultMap.get(p).put(itemgir.fullDate, itemgr.newRules);
                                    }
                                }                            
                            }
                        }
                    }
                }   
            }
            returnWrapper.isPop = isPop;
            returnWrapper.grpsettingsResultMap = grpsettingsResultMap;
            returnWrapper.allGroupInsuringResults = allGroupInsuringResults;
            returnWrapper.settingsResultMap = settingsResultMap;
            system.debug('~~~!!! Map for group settings'+settingsResultMap);
            system.debug('~~~!!! Map for pop group settings'+grpsettingsResultMap);
        }catch(Exception e){
            System.debug('ERROR : ' + e.getMessage());
            //setErrorMsg('MGD997',e);	TODO
        }
        return returnWrapper;
    }
    
    public List<ACETLGT_GroupDetail.InsRule> getinsrules(ACETLGT_GroupDetail.GroupInsuringRules grpinsRul){
        List<ACETLGT_GroupDetail.InsRule>  mainGroupInsuringResults = new List<ACETLGT_GroupDetail.InsRule>();
        for(Integer i = 0; i < 10; i++){
            ACETLGT_GroupDetail.InsRule mainInsRuleItem = new ACETLGT_GroupDetail.InsRule();
            mainInsRuleItem.pop = grpinsRul.classesCode;
            mainInsRuleItem.fullDate = (grpinsRul.insuringRulesEffectiveDates != null && grpinsRul.insuringRulesExpirationDates !=null)?grpinsRul.insuringRulesEffectiveDates + ' to '+grpinsRul.insuringRulesExpirationDates:'';
            
            if(i==0 && grpinsRul.insuranceContinuationType != null ){
                mainInsRuleItem.insRules = 'Continuation Type';
                mainInsRuleItem.insRulesDesc = grpinsRul.insuranceContinuationType;
                mainGroupInsuringResults.add(mainInsRuleItem);
            }  
            else if(i==1 && grpinsRul.continuationResponsibilityType!= null ){
                mainInsRuleItem.insRules = 'Continuation Responsibility';
                mainInsRuleItem.insRulesDesc = grpinsRul.continuationResponsibilityType;
                mainGroupInsuringResults.add(mainInsRuleItem);
            }    
            else if(i==2 && grpinsRul.onshoreRestriction!= null ){
                mainInsRuleItem.insRules = 'Onshore Restriction';
                mainInsRuleItem.insRulesDesc = grpinsRul.onshoreRestriction;
                mainInsRuleItem.OnshoreRestrictTooltip = ACETOnshoreIndicatorVerbiage__c.getValues(grpinsRul.onshoreRestriction).Hover_Help_Description__c;
                mainGroupInsuringResults.add(mainInsRuleItem);
            }  
            else if(i==3 && grpinsRul.pcpRadomization!= null ){
                mainInsRuleItem.insRules = 'PCP Randomzation';
                mainInsRuleItem.insRulesDesc = ((grpinsRul.pcpRadomization == '01')?'Randomize':((grpinsRul.pcpRadomization == '02')?'Do Not Randomize':(grpinsRul.pcpRadomization == '03')?'Default':''));
                mainGroupInsuringResults.add(mainInsRuleItem);
            }  
            else if(i==4 && grpinsRul.newBornAutoAddIndicator!= null ){
                mainInsRuleItem.insRules = 'New born auto add';
                mainInsRuleItem.insRulesDesc = (grpinsRul.newBornAutoAddIndicator == 'true')?'Yes':(grpinsRul.newBornAutoAddIndicator == 'false')?'No':'N/A';
                mainGroupInsuringResults.add(mainInsRuleItem);
            }  
            else if(i==5 && grpinsRul.survivingSpouseIndicator!= null ){
                mainInsRuleItem.insRules = 'Surviving Spouse';
                mainInsRuleItem.insRulesDesc = (grpinsRul.survivingSpouseIndicator== 'true')?'Yes':(grpinsRul.survivingSpouseIndicator== 'false')?'No':'N/A';
                mainGroupInsuringResults.add(mainInsRuleItem);
            }  
            else if(i==6 && grpinsRul.countNewbornForCoverageLevelCodeIndicator!= null ){
                mainInsRuleItem.insRules = 'Count Newborn for Coverage level Code';
                mainInsRuleItem.insRulesDesc = (grpinsRul.countNewbornForCoverageLevelCodeIndicator== 'true')?'Yes':(grpinsRul.countNewbornForCoverageLevelCodeIndicator== 'false')?'No':'N/A';
                mainGroupInsuringResults.add(mainInsRuleItem);
            }  
            else if(i==7 && grpinsRul.workingRetirementIndicator!=''&& grpinsRul.workingRetirementMinimumAge !='' && grpinsRul.workingRetirementMinimumAge !='0'){
                
                mainInsRuleItem.insRules = 'Working Retirement';
                mainInsRuleItem.insRulesDesc = (grpinsRul.workingRetirementIndicator == '1')?grpinsRul.workingRetirementMinimumAge:'N/A';
                mainGroupInsuringResults.add(mainInsRuleItem);
            }  
            else if(i==8 && grpinsRul.earlyRetirementIndicator!='' && grpinsRul.earlyRetirementMinimumAge != '' && grpinsRul.earlyRetirementMinimumAge!='0'){
                mainInsRuleItem.insRules = 'Early Retirement';
                mainInsRuleItem.insRulesDesc = (grpinsRul.earlyRetirementIndicator == '1')?grpinsRul.earlyRetirementMinimumAge:'N/A';
                mainGroupInsuringResults.add(mainInsRuleItem);
            }            
        }    
        return mainGroupInsuringResults;
    }
    
    public GroupEligibilityWrapper insuringRulesSelection(GroupEligibilityWrapper wrapper){
        GroupEligibilityWrapper returnWrapper = new GroupEligibilityWrapper();
		String dateSelected = '';	//	TODO : This need to come from UI, check classic selectList selectedValue
        List<ACETLGT_GroupDetail.PolicyContract> groupPolicyResultsList = wrapper.groupPolicyResultsList;
        try{
            system.debug('$$$Inside Insuring - pol list'+groupPolicyResultsList); 
            system.debug('$$$Pop'+returnWrapper.populationSelected);
            system.debug('$$$Date'+returnWrapper.dateSelected);
            returnWrapper.populationsList = new List<String>();
            returnWrapper.datesList= new List<String>();
            set<string> uniquePop = new set<string>();
            set<string> uniqueDate = new set<string>();
            returnWrapper.popList = new List<string>(); 
            List<String> datList = new List<String>(); 
            
            if(groupPolicyResultsList != null){
                for(ACETLGT_GroupDetail.PolicyContract pol : groupPolicyResultsList){
                    if(wrapper.contractOptionId == pol.policyConId && wrapper.contractOptionStatus == pol.policyActualStatus && pol.insurRules != null){
                        if(pol.hasPopulation){
                            returnWrapper.isCustAcctPop = true;
                        }
                        returnWrapper.custacctpoplst = pol.population;
                        returnWrapper.contAcctpopList = pol.population.split(',');
                        system.debug('---------pol.insurRules--------'+pol.insurRules);
                        for(ACETLGT_GroupDetail.InsuredRules ins : pol.insurRules) {
                            system.debug('$$$pop'+ins.population);
                            system.debug('$$$hasPopulation'+ins.hasPopulation);
                            if(ins.hasPopulation){
                                returnWrapper.isShow = true;
                                if(ins.population != null && ins.effectiveDate!= null){
                                    uniquePop.add(ins.population);
                                    uniqueDate.add(ins.effectiveDate);
                                }                                
                            }else{
                                returnWrapper.isShow = false;
                                if(ins.effectiveDate!= null){
                                    uniqueDate.add(ins.effectiveDate);
                                }
                            }                            
                        }
                    }
                }
                system.debug('@@@pop'+uniquePop.size() + '   '+uniqueDate  );
                if(uniquePop != null && uniquePop.size()>0){
                    for(string pop:uniquePop){
                        returnWrapper.populationsList.add(pop);
                        returnWrapper.popList.add(pop);
                    }
                    
                    returnWrapper.populationSelected  = returnWrapper.popList[0];
                    system.debug('$$$populationsList'+returnWrapper.populationsList);
                    system.debug('$$$populationSelected '+returnWrapper.populationSelected );                    
                }
                if(wrapper.isMemberFlow == 'true'){
                    if(uniqueDate != null){
                        System.debug('IN MEMBER FLOW');    
                        for(string dt:uniqueDate){
                            returnWrapper.datesList.add(dt);
                            datList.add(dt);
                        }
                        String currMonth = String.valueof(Date.Today().Month());
                        String currDay = String.valueof(Date.Today().Day());
                        if(currMonth.length() == 1){
                            currMonth = '0' + currMonth;
                        }
                        if(currDay.length() == 1){
                            currDay = '0' + currDay;
                        }
                        String currentDate = String.valueof(Date.Today().Year()) + currMonth + currDay;
                        String effectiveDate;
                        String endDate;
                        List<String> dateParts = wrapper.covEffDate.split('/');
                        List<String> dateParts2 = wrapper.covEndDate.split('/');
                        if(dateParts[0].length() == 1){
                            dateParts[0] = '0' + dateParts[0];
                        }
                        if(dateParts[1].length() == 1){
                            dateParts[1] = '0' + dateParts[1];
                        }
                        if(dateParts2[0].length() == 1){
                            dateParts2[0] = '0' + dateParts2[0];
                        }
                        if(dateParts2[1].length() == 1){
                            dateParts2[1] = '0' + dateParts2[1];
                        }
                        effectiveDate = dateParts[2] + dateParts[0] + dateParts[1];
                        endDate = dateParts2[2] + dateParts2[0] + dateParts2[1];
                        System.debug('datList*** ' + datList);
                        System.debug('%%%%%curr ' + currentDate + ' eff ' + effectiveDate + ' end ' + endDate);
                        for(ACETLGT_GroupDetail.PolicyContract pol:GroupPolicyResultsList){
                            if(wrapper.contractOptionId == pol.policyConId && wrapper.contractOptionStatus == pol.policyActualStatus && pol.insurRules != null){
                                for(ACETLGT_GroupDetail.InsuredRules ins : pol.insurRules) {
                                    List<String> effectiveList = ins.effectiveDate.split('/');
                                    if(effectiveList[0].length() == 1){
                                        effectiveList[0] = '0' + effectiveList[0];
                                    }
                                    if(effectiveList[1].length() == 1){
                                        effectiveList[1] = '0' + effectiveList[1];
                                    }
                                    String insuringEffective = effectiveList[2] + effectiveList[0] + effectiveList[1];
                                    List<String> endList = ins.endDate.split('/');
                                    if(endList[0].length() == 1){
                                        endList[0] = '0' + endList[0];
                                    }
                                    if(endList[1].length() == 1){
                                        endList[1] = '0' + endList[1];
                                    }
                                    String insuringEnd = endList[2] + endList[0] + endList[1];
                                    System.debug('%%%%% ' + insuringEffective + ' ' + insuringEnd);
                                    if(insuringEffective <= endDate && endDate <= insuringEnd){ //Termed
                                        dateSelected = ins.effectiveDate;
                                    } else if(insuringEffective <= effectiveDate && effectiveDate <= insuringEnd){ //Future
                                        dateSelected = ins.effectiveDate;
                                    } else if ((effectiveDate <= currentDate && currentDate<= endDate) && (insuringEffective <= currentDate && currentDate<= insuringEnd)){
                                        dateSelected = ins.effectiveDate;
                                    }
                                    System.debug('%%%%% dateSelected ' + dateSelected);
                                }
                            }
                        }
                        
                    }
                } else { 
                    if(uniqueDate != null){    
                        for(string dt:uniqueDate){
                            returnWrapper.datesList.add(dt);
                            datList.add(dt);
                        }
                        system.debug('%%%filterStatus '+wrapper.filterStatus );
                        system.debug('$$$datList'+datList);
                        //datList= sortByDate(datList);
                        system.debug('$$$datList'+datList);
                        if(wrapper.filterStatus == 'Active' || wrapper.filterStatus=='Termed' ){
                            if(datList != null && datList.size() > 0){
                                dateSelected  = datList[datList.size()-1];
                            } 
                        }
                        else if(wrapper.filterStatus == 'Future' ){
                            dateSelected  = datList[0];
                        }
                        system.debug('$$$datesList'+returnWrapper.datesList);
                        system.debug('$$$dateSelected' +dateSelected );
                        
                    }
                }
            }
            returnWrapper.dateSelected = dateSelected;
        }catch(Exception e){
            //setErrorMsg('MGD997',e);
        }
        
        return returnWrapper;
    }
}