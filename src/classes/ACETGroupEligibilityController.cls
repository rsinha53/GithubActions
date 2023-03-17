public with sharing class ACETGroupEligibilityController extends ACETErrorHandler{
    
    public ACETHighlightsPanelAdditionalInfo AdditionalInfo {get;set;}
    public ACETCallTopicsDataWrapper wrapper {get;set;}
    public String swivelcirrusBtn_URL {get; set;}
    public Contact Subject { get; set; } 
    public string groupNumber{get;set;}
    public String callTopic{get;set;}
    public String contractId {get;set;}
    public String status {get;set;}
    public String filterStatus {get;set;}
    public String surrogateKey{get;set;}  
    public String hpAdditionInfoStr {get{
        return JSON.serialize(AdditionalInfo);
    }set;}  
    public Interaction__c Interaction { get; set; }  
    public ACETGroupDetail groupPolicyDetails{get;set;} 
    public ACETGroupDetail groupDetails{get;set;} 
    public List<ACETGroupDetail.PolicyContract> GroupPolicyResultsList {get; set;}
    public static List<ACETGroupDetail.PolicyContract> GroupPolicySearchResults {get; set;}
    public List<ACETGroupDetail.InsRule> GroupInsuringResults {get; set;}
    public String populationSelected{get;set;} 
    public String dateSelected{get;set;}
    public List<SelectOption> populationsList{get;set;} 
    public List<SelectOption> datesList{get;set;}
    public boolean isShow{get;set;}
    public String effDate;
    public String covEffDate ,covEndDate ;
    public String isMemberFlow;
    public List<ACETGroupDetail.InsuredRules> allGroupInsuringResults {get; set;}
    public List<ACETGroupDetail.InsRule> mainGroupInsuringResults {get; set;}
    public integer i;
    public Map<String, List<ACETGroupDetail.InsRule>> settingsResultMap{get;set;}
    public string dateRangeSelected{get;set;}
    public boolean iscollapsed{get;set;}
    public boolean isPop{get;set;}
    public boolean isCustAcctPop{get;set;}
    public string custacctpoplst{get;set;}
    public Map<String, Map<String, List<ACETGroupDetail.GroupInsuredRules>>> grpsettingsResultMap{get;set;}
    List<string> popList{get;set;}
    List<string> datList{get;set;}
    List<string> contAcctpopList{get;set;}
    
    public ACETGroupEligibilityController()
    {
        try{
            groupNumber = apexpages.currentpage().getparameters().get('groupId');
            callTopic = apexpages.currentpage().getparameters().get('callTopic'); 
            contractId = apexpages.currentpage().getparameters().get('contractId');
            status = apexpages.currentpage().getparameters().get('status');
            filterStatus = apexpages.currentpage().getparameters().get('filterStatus');
            effDate= apexpages.currentpage().getparameters().get('effDate');
            covEffDate = apexpages.currentpage().getparameters().get('covEffDate');
            covEndDate = apexpages.currentpage().getparameters().get('covEndDate');
            isMemberFlow= apexpages.currentpage().getparameters().get('isMemberFlow');
            system.debug('Group info in eligibility=======>'+callTopic);
            
            system.debug('Group info in eligibility=======>'+groupNumber);
            String InteractionId = apexpages.currentpage().getparameters().get('InteractionId');
            
            if(filterStatus == null && isMemberFlow=='true'){
                
                String todayDate = Date.Today().year() + '-' + Date.Today().month() + '-' + Date.Today().day();
                if(covEffDate != null && (Date.valueOf(covEffDate.split('/')[2]+'-'+covEffDate.split('/')[0]+'-'+covEffDate.split('/')[1]) > Date.valueOf(todayDate ))){ 
                    filterStatus = 'Future';
                } else if(covEndDate != null && (Date.valueOf(covEndDate.split('/')[2]+'-'+covEndDate.split('/')[0]+'-'+covEndDate.split('/')[1]) < Date.valueOf(todayDate ))){
                    filterStatus = 'Termed';
                } else if(covEffDate != null && covEndDate != null && (Date.valueOf(covEffDate.split('/')[2]+'-'+covEffDate.split('/')[0]+'-'+covEffDate.split('/')[1]) <= Date.valueOf(todayDate ) && Date.valueOf(covEndDate.split('/')[2]+'-'+covEndDate.split('/')[0]+'-'+covEndDate.split('/')[1]) >= Date.valueOf(todayDate ))){
                    filterStatus = 'Active';
                }
            }
            if(InteractionId != null && InteractionId != '')
            {
                Interaction = ACETProviderUtility.GetInteractionByID(InteractionId);
            }
            isShow = false;
            isPop = false;
            isCustAcctPop = false;
            List<SelectOption> populationsList = new List<SelectOption>();
            List<SelectOption> datesList= new List<SelectOption>();
            allGroupInsuringResults  = new List<ACETGroupDetail.InsuredRules>();
            init();
            
            settingsResultMap =new Map<String,List<ACETGroupDetail.InsRule>>();
        }catch(Exception e){
            setErrorMsg('MGD997',e);
        }  
        
    }
    public void init(){
        try{  
            wrapper = new ACETCallTopicsDataWrapper();
            wrapper.init();
            wrapper.CaseObj.Topic__c = callTopic ;
            wrapper.updategroupinfoSave = true;
            initHighlightPanelAdditionalInfo();
            surrogateKey = ApexPages.currentPage().getParameters().get('SRK');
            if (!String.isEmpty(surrogateKey)){ 
                wrapper.surrogateKey = surrogateKey;
            } 
        }catch(Exception e){
            setErrorMsg('MGD997',e);
        } 
    }
    
    
    
    public static ACETWSCalloutResult callwebservice(string groupId)
    {
        ACETGetEmployerDetailAdapterWebService response = new ACETGetEmployerDetailAdapterWebService();
        ACETWSCalloutResult responseData = response.getEmployerGroupDetail(groupId);
        System.debug('Allowing.................'+responseData);
        return responseData;
    }
    
    
    
    private void initHighlightPanelAdditionalInfo(){
        try{
            String additionalInfoStr = apexpages.currentpage().getparameters().get('additionalInfo');
            
            if(AdditionalInfo == null){
                AdditionalInfo = new ACETHighlightsPanelAdditionalInfo(); 
            } 
            system.debug('addinfo before====='+ApexPages.currentPage().getParameters().get('additionalInfo'));
            string addInfo = ApexPages.currentPage().getParameters().get('additionalInfo');
            //  addInfo = addInfo.replace('&','&amp;');
            system.debug('addinfo====='+addInfo);
            if(addInfo != null)
            {
                AdditionalInfo  = (ACETHighlightsPanelAdditionalInfo)JSON.deserialize(addInfo, ACETHighlightsPanelAdditionalInfo.class);
            }
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
            }
            
            hpAdditionInfoStr = JSON.serialize(AdditionalInfo);
            hpAdditionInfoStr = hpAdditionInfoStr.replace('&','&amp;');
            wrapper.AdditionalInfo = (ACETHighlightsPanelAdditionalInfo)json.deserialize(hpAdditionInfoStr,ACETHighlightsPanelAdditionalInfo.class);            
        }catch(Exception e){
            setErrorMsg('MGD997',e);
        } 
    }
    
    
    public void insuringRulesSelection(){
        try{
            system.debug('$$$Inside Insuring - pol list'+GroupPolicyResultsList); 
            system.debug('$$$Pop'+populationSelected);
            system.debug('$$$Date'+dateSelected);
            populationsList = new List<SelectOption>();
            datesList= new List<SelectOption>();
            set<string> uniquePop = new set<string>();
            set<string> uniqueDate = new set<string>();
            popList = new list<string>(); 
            datList = new list<String>(); 
            
            if(GroupPolicyResultsList != null){
                for(ACETGroupDetail.PolicyContract pol:GroupPolicyResultsList){
                    if(contractId == pol.policyConId && status == pol.policyActualStatus && pol.insurRules != null){
                        if(pol.hasPopulation){
                            isCustAcctPop = true;
                        }
                        custacctpoplst = pol.population;
                        contAcctpopList = pol.population.split(',');
                        system.debug('---------pol.insurRules--------'+pol.insurRules);
                        for(ACETGroupDetail.InsuredRules ins:pol.insurRules) {
                            system.debug('$$$pop'+ins.population);
                            system.debug('$$$hasPopulation'+ins.hasPopulation);
                            if(ins.hasPopulation){
                                isShow = true;
                                if(ins.population != null && ins.effectiveDate!= null){
                                    uniquePop.add(ins.population);
                                    uniqueDate.add(ins.effectiveDate);
                                }
                                
                            }else{
                                isShow = false;
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
                        populationsList.add(new selectoption(pop,pop));
                        popList.add(pop);
                    }
                    
                    populationSelected  = popList[0];
                    system.debug('$$$populationsList'+populationsList);
                    system.debug('$$$populationSelected '+populationSelected );
                    
                }
                if(isMemberFlow == 'true'){
                    if(uniqueDate != null){
                        System.debug('IN MEMBER FLOW');    
                        for(string dt:uniqueDate){
                            datesList.add(new selectoption(dt,dt));
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
                        List<String> dateParts = covEffDate.split('/');
                        List<String> dateParts2 = covEndDate.split('/');
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
                        for(ACETGroupDetail.PolicyContract pol:GroupPolicyResultsList){
                            if(contractId == pol.policyConId && status == pol.policyActualStatus && pol.insurRules != null){
                                for(ACETGroupDetail.InsuredRules ins:pol.insurRules) {
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
                            datesList.add(new selectoption(dt,dt));
                            datList.add(dt);
                        }
                        system.debug('%%%filterStatus '+filterStatus );
                        system.debug('$$$datList'+datList);
                        //datList= sortByDate(datList);
                        system.debug('$$$datList'+datList);
                        if(filterStatus == 'Active' || filterStatus=='Termed' ){
                            if(datList != null && datList.size() > 0){
                                dateSelected  = datList[datList.size()-1];
                            } 
                        }
                        else if(filterStatus == 'Future' ){
                            dateSelected  = datList[0];
                        }
                        system.debug('$$$datesList'+datesList);
                        system.debug('$$$dateSelected' +dateSelected );
                        
                    }
                }
            }
        }catch(Exception e){
            setErrorMsg('MGD997',e);
        } 
    }
    
    public void getInsuringRules(){
        try{
            system.debug('$$$get Inside Insuring - pol list'+GroupPolicyResultsList); 
            system.debug('$$$get Pop'+populationSelected);
            system.debug('$$$get Date'+dateSelected);
            system.debug('$$$geteff '+effDate);
            system.debug('$$$get Date'+dateSelected);
            groupInsuringResults = new list<ACETGroupDetail.InsRule>();
            if(GroupPolicyResultsList != null){
                for(ACETGroupDetail.PolicyContract pol:GroupPolicyResultsList){
                    if(contractId == pol.policyConId && status == pol.policyActualStatus &&  effDate == pol.effectiveDate && pol.insurRules != null){
                        for(ACETGroupDetail.InsuredRules ins:pol.insurRules) {
                            system.debug('$$$insrule'+ins.insRules);
                            // For No population defined at contract option level
                            if(pol.population == '')
                            {
                                if(dateSelected == ins.effectiveDate && ins.insRules!=null){
                                    for(ACETGroupDetail.InsRule ir:ins.insRules){
                                        system.debug('$$$insrule inside no pop'+ir);
                                        groupInsuringResults.add(ir);
                                    }
                                }   
                                
                            }
                            else {
                                // For Population Insuring rules
                                if(pol.population != '' && ins.haspopulation == true){
                                    if(populationSelected == ins.population && dateSelected == ins.effectiveDate && ins.insRules!=null){
                                        groupInsuringResults = new list<ACETGroupDetail.InsRule>();
                                        for(ACETGroupDetail.InsRule ir:ins.insRules){
                                            system.debug('$$$insrule inside poppop Ins rules'+ir);
                                            if(ir.pop != '' && populationSelected == ir.pop){
                                                groupInsuringResults.add(ir);
                                            }
                                        }
                                    }
                                }
                                if(groupInsuringResults.size() == 0){
                                    if(pol.population != '' && ins.haspopulation == false){
                                        if(dateSelected == ins.effectiveDate && ins.insRules!=null){
                                            for(ACETGroupDetail.InsRule ir:ins.insRules){
                                                system.debug('$$$insrule inside conOpt Ins rules'+ir);
                                                groupInsuringResults.add(ir);
                                            }
                                        }
                                    }
                                }
                                
                            }
                        }
                    }
                }
            }
            system.debug('$$$groupInsuringResults'+groupInsuringResults);
        }catch(Exception e){
            setErrorMsg('MGD997',e);
        }
    }
    
    public void getGroupInsuringRules(){
        try{
            system.debug('***getgroupIns'+groupPolicyDetails);
            system.debug('***getgroupIns Policy Selected'+GroupPolicyResultsList);
            system.debug('$$$get Pop'+populationSelected);
            system.debug('$$$ has population'+isShow );
            system.debug('---------custacctpoplst -------'+custacctpoplst);
            settingsResultMap =new Map<String,List<ACETGroupDetail.InsRule>>();
            grpsettingsResultMap = new Map<String, Map<String, List<ACETGroupDetail.GroupInsuredRules>>>();
            allGroupInsuringResults = new list<ACETGroupDetail.InsuredRules>();
            
            if(groupPolicyDetails.groupInsuringRules != null){
                for(ACETGroupDetail.GroupInsuringRules grpinsRul:groupPolicyDetails.groupInsuringRules) {
                    
                    //Contract option is not defined by population and group settings are standard
                    if(!isCustAcctPop && custacctpoplst ==''){ 
                        system.debug('-------No population---------');
                        mainGroupInsuringResults = new list<ACETGroupDetail.InsRule>();
                        ACETGroupDetail.InsuredRules ins = new ACETGroupDetail.InsuredRules();
                        system.debug('------grpinsRul--------'+grpinsRul);
                            
                            mainGroupInsuringResults = getinsrules(grpinsRul);
                        system.debug('~~~~~~maingrpins'+mainGroupInsuringResults);
                        ins.insrules = mainGroupInsuringResults;
                        ins.population = grpinsRul.classesCode;
                        ins.effectiveDate = grpinsRul.insuringRulesEffectiveDates ;
                        ins.fullDate = grpinsRul.insuringRulesEffectiveDates + ' to '+grpinsRul.insuringRulesExpirationDates;
                        allGroupInsuringResults.add(ins);
                        system.debug('!!! pop'+populationSelected);
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
                    
                    
                    else {
                        //Contract option defined by population and group settings also defined by population
                        if(isCustAcctPop && custacctpoplst!=''&&custacctpoplst.contains(grpinsRul.classesCode)){
                            system.debug('-------with population---------');
                            mainGroupInsuringResults = new list<ACETGroupDetail.InsRule>();
                            ACETGroupDetail.InsuredRules ins = new ACETGroupDetail.InsuredRules();
                            system.debug('------grpinsRul-------'+grpinsRul);
                            mainGroupInsuringResults = getinsrules(grpinsRul);
                            system.debug('~~~~~~maingrpins'+mainGroupInsuringResults);
                            ins.insrules = mainGroupInsuringResults;
                            ins.population = grpinsRul.classesCode;
                            ins.effectiveDate = grpinsRul.insuringRulesEffectiveDates ;
                            ins.fullDate = grpinsRul.insuringRulesEffectiveDates + ' to '+grpinsRul.insuringRulesExpirationDates;
                            allGroupInsuringResults.add(ins);
                            system.debug('!!! pop'+populationSelected);
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
                    if(allGroupInsuringResults.size()==0){
                        if(isCustAcctPop && custacctpoplst!='' && grpinsRul.classesCode ==''){
                            system.debug('-------with population--but group settings not defined by population-------');
                            mainGroupInsuringResults = new list<ACETGroupDetail.InsRule>();
                            ACETGroupDetail.InsuredRules ins = new ACETGroupDetail.InsuredRules();
                            mainGroupInsuringResults = getinsrules(grpinsRul);
                            system.debug('~~~~~~maingrpins'+mainGroupInsuringResults);
                            ins.insrules = mainGroupInsuringResults;
                            ins.population = grpinsRul.classesCode;
                            ins.effectiveDate = grpinsRul.insuringRulesEffectiveDates ;
                            ins.fullDate = grpinsRul.insuringRulesEffectiveDates + ' to '+grpinsRul.insuringRulesExpirationDates;
                            allGroupInsuringResults.add(ins);
                            system.debug('!!! pop'+populationSelected);
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
                system.debug('!@#!@#'+popList);
                system.debug('!@#!@#'+contAcctpopList);
                if(contAcctpopList.size()>0){
                    for(String p : contAcctpopList){                                                
                        ACETGroupDetail.GroupRules itemgr = new ACETGroupDetail.GroupRules();
                        for(ACETGroupDetail.InsuredRules r1:allGroupInsuringResults){
                            if(p.trim() == r1.population.trim()){ 
                                itemgr.newRules = new list<ACETGroupDetail.GroupInsuredRules>();
                                ACETGroupDetail.GroupInsuredRules itemgir = new ACETGroupDetail.GroupInsuredRules();
                                
                                system.debug('!@# Population matched'+r1.population+ '---'+r1.fullDate);
                                itemgir.pop = r1.population;
                                itemgir.effectiveDate = r1.effectiveDate;
                                itemgir.endDate = r1.endDate;
                                itemgir.fullDate = r1.fullDate;
                                
                                itemgir.insrules = r1.insrules;
                                System.debug(itemgir.fullDate +' Date '+'itemgir.insrules'+ itemgir.insrules);
                                itemgr.newRules.add(itemgir);
                                if(!grpsettingsResultMap.containsKey(p)) {
                                    grpsettingsResultMap.put(p, new map<string,List<ACETGroupDetail.GroupInsuredRules>>{itemgir.fullDate => itemgr.newRules});
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
            system.debug('~~~!!! Map for group settings'+settingsResultMap);
        }catch(Exception e){
            setErrorMsg('MGD997',e);
        }
        
    }
    public List<ACETGroupDetail.InsRule> getinsrules(ACETGroupDetail.GroupInsuringRules grpinsRul){
               list<ACETGroupDetail.InsRule>  mainGroupInsuringResults = new list<ACETGroupDetail.InsRule>();
                      for(i=0;i<10;i++){
                                ACETGroupDetail.InsRule mainInsRuleItem = new ACETGroupDetail.InsRule();
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
    public void showPolicyContract()
    {
        system.debug('****Inside call webservice');
        groupNumber = apexpages.currentpage().getparameters().get('groupId');
        contractId = apexpages.currentpage().getparameters().get('contractId');
        status = apexpages.currentpage().getparameters().get('status');
        effDate= apexpages.currentpage().getparameters().get('effDate');
        
        system.debug('****groupNumber '+groupNumber );
        system.debug('****contractId '+contractId );
        system.debug('****status  '+status );
        system.debug('****effDate  '+effDate );
        groupPolicyDetails = new ACETGroupDetail(); 
        GroupPolicyResultsList = new List<ACETGroupDetail.PolicyContract>();
        GroupPolicySearchResults = new List<ACETGroupDetail.PolicyContract>(); 
        
        try{
            
            System.debug('****Calling the service');
            ACETWSCalloutResult responseData = callwebservice(groupNumber);
            System.debug('***ACETCallOutResult responseData ='+responseData);
            if(responseData.Success){    
                groupPolicyDetails = (ACETGroupDetail)responseData.response; 
                
                GroupPolicySearchResults = groupPolicyDetails.polContract; 
                
                if(GroupPolicySearchResults != null) {
                    for(ACETGroupDetail.PolicyContract polContract:GroupPolicySearchResults ) {
                        System.debug('contract from page******'+contractId );
                        System.debug('All******'+polContract);
                        System.debug(status + ':' + polContract.policyActualStatus + ',' + contractId +':' + polContract.policyConId +','+effDate+':'+polContract.effectiveDate);
                        if(status == polContract.policyActualStatus && contractId == polContract.policyConId && effDate == polContract.effectiveDate){
                            GroupPolicyResultsList.add(polContract);
                        }
                    }
                }            
            }
            else{ 
                if(responseData.statusCode==400){
                    setErrorMsg('GN'+'400B',null);
                }else{
                    setErrorMsg('GN'+responseData.statusCode,null);
                }
                //ApexPages.addMessage(new ApexPages.Message(responseData.MessageSeverity, responseData.Message));  
            } 
        }   
        catch(Exception ex){ 
            setErrorMsg('MGD997',ex);
            //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, label.ACETOILNotAvailable )); 
        }
    }
    
}