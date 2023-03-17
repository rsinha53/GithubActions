/* Class Name:ACETGetEmployerGroupAPI
* Created Date: 16/03/20201
* Description: API Class for Get Employer Group API
**/
public class ACETGetEmployerGroupAPI {
    
    public ACETGroupDetail oACETGroupDetail;
    public Integer numberDays{get;set;}
    private string taxid, classinclude,planClass,insured,networkId,firstName,middleName,lastName,grpHoldcode,population,OriginalContractDate,addrType ;
    public ACETGroupDetail.groupContactInfo billingInfo = new ACETGroupDetail.groupContactInfo();
    public String returningFromService;
    public Map<String,String> codeVsOnshoreIndicator;
    private integer i;
    
    public String getRequestBody(String groupNumber){
        return JSON.serialize(new ACETGetEmployeeRequestWrapper(groupNumber)); 
    }   
    
    private ACETGroupDetail parseSuccessAdapterResponse(String ResponseBody)
    {
        oACETGroupDetail = new ACETGroupDetail();
        oACETGroupDetail.noCustomerAccount = false;
        oACETGroupDetail.genGroupInfo= new ACETGroupDetail.groupGeneralInfo();
        oACETGroupDetail.grpAffiliationsinfo  = new ACETGroupDetail.GroupAffiliationsinfo();
        oACETGroupDetail.additionalGroupInfo = new ACETGroupDetail.addGroupInfo();
        oACETGroupDetail.groupEmployeeCountInfoList = new list<ACETGroupDetail.employeeCountInfo>(); 
        oACETGroupDetail.groupAddressInfoList = new list<ACETGroupDetail.AddressInfo>();
        oACETGroupDetail.polContract = new list<ACETGroupDetail.PolicyContract>();  //US912388 
        oACETGroupDetail.groupInsuringRules = new list<ACETGroupDetail.GroupInsuringRules>(); 
        
        ACETGetEmployerGroupAdapterJSON2Apex.EmployerGroup EGDetails;
        
        ACETGetEmployerGroupAdapterJSON2Apex.GetEmployerGroup ACETEGDJSON2Apex = (ACETGetEmployerGroupAdapterJSON2Apex.GetEmployerGroup)JSON.deserialize(ResponseBody, ACETGetEmployerGroupAdapterJSON2Apex.GetEmployerGroup.class);
        system.debug('ACETEGDJSON2Apex --->'+ACETEGDJSON2Apex);
        
        EGDetails = ACETEGDJSON2Apex.getEmployerGroupResponse.employerGroup;
        
        
        /*generalGroupInfoMapping(EGDetails);
        groupEmployeeCountMapping(EGDetails);
        groupAddressMapping(EGDetails);
        groupContactInfoMapping(EGDetails);
        groupInsuringRulesMapping(EGDetails); */     //getemp V3
        groupContractVersioningMapping(EGDetails);  //getemp V3  // Combining Policy Contract,Insuring Rules and Benefits 
        
        return oACETGroupDetail;     
        
    }
    
    //getemp V3 starts
    /*private void groupInsuringRulesMapping(ACETGetEmployerGroupAdapterJSON2Apex.EmployerGroup EGDetails) {
        if(EGDetails.GroupInsuringRules != null){
            for(ACETGetEmployerGroupAdapterJSON2Apex.GroupInsuringRules ins: EGDetails.GroupInsuringRules ) {
                ACETGroupDetail.GroupInsuringRules rule = new ACETGroupDetail.GroupInsuringRules();
                rule.classesCode = (ins.classesCode != null)?ins.classesCode.replace(',',''):'';
                rule.cobraAdministrativeIndicator = (ins.cobraAdministrativeIndicator!=null)?ins.cobraAdministrativeIndicator:'';
                rule.continuationResponsibilityType = (ins.continuationResponsibilityType!=null)?ins.continuationResponsibilityType :'' ;
                rule.insuranceContinuationType = (ins.insuranceContinuationType!=null)?ins.insuranceContinuationType:'' ;
                rule.onshoreRestriction = (ins.onshoreRestriction!= null)?ins.onshoreRestriction :'' ;
                rule.insuringRulesEffectiveDates = (ins.insuringRulesEffectiveDates != Null)?string.valueOf(Date.valueOf(ins.insuringRulesEffectiveDates ).format()):'';
                rule.insuringRulesExpirationDates = (ins.insuringRulesExpirationDates != Null)?string.valueOf(Date.valueOf(ins.insuringRulesExpirationDates).format()):'12/31/9999';
                rule.insuringRulesEffectiveDatesNoFormat = (ins.insuringRulesEffectiveDates != Null)?string.valueOf(Date.valueOf(ins.insuringRulesEffectiveDates )):'';
                rule.insuringRulesExpirationDatesNoFormat = (ins.insuringRulesExpirationDates != Null)?string.valueOf(Date.valueOf(ins.insuringRulesExpirationDates)):'9999-12-31';
                rule.pcpRadomization= (ins.pcpRadomization!=null)?ins.pcpRadomization:'' ;
                rule.survivingSpouseIndicator= (ins.survivingSpouseIndicator!=null)?ins.survivingSpouseIndicator:'' ;
                rule.newBornAutoAddIndicator= (ins.newBornAutoAddIndicator!= null)?ins.newBornAutoAddIndicator:'' ;
                rule.countNewbornForCoverageLevelCodeIndicator= (ins.countNewbornForCoverageLevelCodeIndicator!=null)?ins.countNewbornForCoverageLevelCodeIndicator:'' ;
                rule.earlyRetirementIndicator = (ins.earlyRetirementIndicator !=null)?ins.earlyRetirementIndicator:'' ;
                rule.earlyRetirementMinimumAge= (ins.earlyRetirementMinimumAge!= null)?ins.earlyRetirementMinimumAge:'' ;
                rule.workingRetirementIndicator= (ins.workingRetirementIndicator!=null)?ins.workingRetirementIndicator:'' ;
                rule.workingRetirementMinimumAge= (ins.workingRetirementMinimumAge!= null)?ins.workingRetirementMinimumAge:'' ;
                oACETGroupDetail.groupInsuringRules.add(rule); 
            }
            system.debug('@@@ grpinsrule'+oACETGroupDetail.groupInsuringRules);
        }
    }*/
    
    private void groupContractVersioningMapping(ACETGetEmployerGroupAdapterJSON2Apex.EmployerGroup EGDetails) {
        if(EGDetails.CustomerAccount == null || EGDetails.CustomerAccount.isEmpty() || EGDetails.CustomerAccount.size() == 0){
            oACETGroupDetail.noCustomerAccount = true;
        } else {
            oACETGroupDetail.noCustomerAccount = false;
            for(ACETGetEmployerGroupAdapterJSON2Apex.CustomerAccount acc: EGDetails.customerAccount) {
                
                OriginalContractDate =  (acc.originalContractDate != Null)?string.valueOf(Date.valueOf(acc.originalContractDate).format()):'';
                if(acc.customerAccountOption != null){
                    for(ACETGetEmployerGroupAdapterJSON2Apex.CustomerAccountOption accopt: acc.customerAccountOption) {
                        
                        ACETGroupDetail.PolicyContract pc = new ACETGroupDetail.PolicyContract();
                        //ACETGroupDetail.PolicyGeneralInfo() pc.polGenGroupInfo = new ACETGroupDetail.PolicyGeneralInfo();
                        pc.polGenGroupInfo = new ACETGroupdetail.PolicyGeneralInfo();
                        pc.GroupPlanBenefitList = new list<ACETGroupdetail.GroupPlanWrapper>();
                        pc.insurRules = new list<ACETGroupdetail.InsuredRules>();
                        pc.policyActualStatus = (accopt.statusDescription != null)?accopt.statusDescription:'';
                        if(pc.policyActualStatus == 'Active'){
                            /***POLICY CONTRACT MAPPING***/                            
                            Boolean isPlanAdded = false;
                            pc.population = '';
                            pc.policyOptId = ''; 
                            pc.benefitBundleId = '';
                            pc.policyConId  = (accopt.customerAccountOptionId != null)?accopt.customerAccountOptionId:'';
                            
                            if(accopt.customerAccountGroupPopulation != null){
                                for(ACETGetEmployerGroupAdapterJSON2Apex.CustomerAccountGroupPopulation groupPop:accopt.customerAccountGroupPopulation){
                                    if(pc.population == ''){
                                        if(groupPop.classesDescription != null && groupPop.classesDescription.contains(',')){
                                            pc.population = groupPop.classesDescription.replace(',','');
                                        } else {
                                            pc.population = (groupPop.classesDescription != null)?groupPop.classesDescription:'';
                                        }
                                    } else {
                                        if(groupPop.classesDescription != null && groupPop.classesDescription.contains(',')){
                                            pc.population = pc.population + ', ' + groupPop.classesDescription.replace(',','');
                                        } else {
                                            pc.population = pc.population + ', ' + ((groupPop.classesDescription != null)?groupPop.classesDescription:'');
                                        }
                                    }
                                }
                            }
                            
                            pc.hasPopulation = (pc.population=='')?false:true;
                            ACETGroupDetail.GroupPlanWrapper groupPlanCustomerAcc = new ACETGroupDetail.GroupPlanWrapper();
                            ACETGroupDetail.AgeBandWrap ageBandInfo;  
                            ACETGroupDetail.FamilyBasedWrap familyBasedInfo;
                            if(accopt.customerPurchase != null){
                                for(ACETGetEmployerGroupAdapterJSON2Apex.customerPurchase custPurch: accopt.customerPurchase){
                                    if((accopt.statusCode == 'A') && ((custPurch.contractOptionType=='DN' && custPurch.benefitType=='DN') ||
                                       (custPurch.contractOptionType=='VS' && custPurch.benefitType=='VS'))){
                                        ACETGroupDetail.SpecialtyBenefits_CoverageLine sbc = new ACETGroupDetail.SpecialtyBenefits_CoverageLine();
                                        sbc.ContractOptionType = custPurch.contractOptionTypeDescription;
                                        sbc.ContractOptionStartDate = custPurch.coverageStartDate;
                                        sbc.ContractOptionEndDate = custPurch.coverageExpirationDate;
                                        sbc.planOptionID = custPurch.memberGroupContractPlanOptionID;
                                        sbc.isActive =  Date.valueOf(sbc.ContractOptionStartDate)<=System.today()
                                            && Date.valueOf(sbc.ContractOptionEndDate)>=System.today()?'Active':
                                           Date.valueOf(sbc.ContractOptionStartDate)>System.today()
                                            && Date.valueOf(sbc.ContractOptionEndDate)>=System.today()?'Future':'Inactive';
                                        oACETGroupDetail.specialityBenefits.add(sbc);
                                        isPlanAdded = true;
                                    }
                                   /* if(pc.policyOptId == ''){
                                        pc.policyOptId = pc.policyOptId = (custPurch.memberGroupContractPlanOptionID != null) ? custPurch.memberGroupContractPlanOptionID + (custPurch.bookOfBusinessTypeCode != null ? '-' + custPurch.bookOfBusinessTypeCode: '') : '';
                                    } else {
                                        pc.policyOptId = pc.policyOptId + ', ' + ((custPurch.memberGroupContractPlanOptionID != null) ? custPurch.memberGroupContractPlanOptionID + (custPurch.bookOfBusinessTypeCode != null ? '-' + custPurch.bookOfBusinessTypeCode: '') : '');
                                    }
                                    if(pc.benefitBundleId == ''){
                                        pc.benefitBundleId = (custPurch.benefitBundleOptionID != null)?custPurch.benefitBundleOptionID:'';
                                    } else {
                                        pc.benefitBundleId = pc.benefitBundleId + ', ' + ((custPurch.benefitBundleOptionID != null)?custPurch.benefitBundleOptionID:'');
                                    }
                                    
                                    //Group Plan Topic
                                    groupPlanCustomerAcc = new ACETGroupDetail.GroupPlanWrapper();
                                    groupPlanCustomerAcc.ageBandGroupPlanList = new List<ACETGroupDetail.AgeBandWrap>();
                                    groupPlanCustomerAcc.familyBasedGroupPlanList = new List<ACETGroupDetail.FamilyBasedWrap>();
                                    groupPlanCustomerAcc.groupId = EGDetails.groupNumber;
                                    groupPlanCustomerAcc.contractID = (custPurch.memberGroupContractPlanOptionID != Null)?custPurch.memberGroupContractPlanOptionID:'';
                                    groupPlanCustomerAcc.bundleID = (custPurch.benefitBundleOptionID != Null)?custPurch.benefitBundleOptionID:'';                
                                    groupPlanCustomerAcc.planID = (custPurch.benefitBasePlan != Null)?custPurch.benefitBasePlan:'';                
                                    groupPlanCustomerAcc.Product = (custPurch.benefitPlanDescription != Null)?custPurch.benefitPlanDescription:'';                
                                    groupPlanCustomerAcc.Accumulator = (custPurch.timePeriodQualifier != Null)?custPurch.timePeriodQualifier:'';                
                                    //groupPlanCustomerAcc.stateOfIssueCode = (custPurch.stateOfIssueCode != Null)?custPurch.stateOfIssueCode:'';                
                                    //US957991 starts
                                    groupPlanCustomerAcc.hsaElected = (custPurch.hsaVendorName != Null)?'Yes':'No';
                                    groupPlanCustomerAcc.hsaAvailable = (custPurch.hsaVendorName != Null)?'Yes':'';
                                    groupPlanCustomerAcc.administeredBy = (custPurch.hsaVendorName != Null)?custPurch.hsaVendorName:'N/A';
                                    groupPlanCustomerAcc.phone = (custPurch.hsaVendorName != Null)?'800-791-9361':'N/A';
                                    //US957991 ends
                                    networkId = '';
                                    if(custPurch.networkScheduleId != null && custPurch.networkScheduleId.size() > 0)
                                    {
                                        set<string> uniqueNetworks = new set<string>(); 
                                        list<string> uniqueNetworksList = new list<string>();
                                        uniqueNetworks.addAll(custPurch.networkScheduleId);
                                        uniqueNetworksList.addAll(uniqueNetworks);
                                        
                                        Integer networkIdSize =  uniqueNetworksList.size();
                                        for (Integer j = networkIdSize ; j > 0; j--) 
                                        {
                                            if(networkId == '' || networkId == null)
                                            {
                                                networkId = uniqueNetworksList[j-1];
                                            }
                                            else
                                            {
                                                networkId = networkId+ ', ' +uniqueNetworksList[j-1];
                                            }
                                        }
                                    }
                                    
                                    groupPlanCustomerAcc.Network =  networkId;               
                                    groupPlanCustomerAcc.effecDate = (custPurch.coverageStartDate != Null)?string.valueOf(Date.valueOf(custPurch.coverageStartDate).format()):'';
                                    groupPlanCustomerAcc.endDate = (custPurch.coverageExpirationDate != Null)?string.valueOf(Date.valueOf(custPurch.coverageExpirationDate).format()):'';
                                    groupPlanCustomerAcc.planID = (custPurch.benefitBasePlan != Null)?custPurch.benefitBasePlan:'';
                                    groupPlanCustomerAcc.PlanClass = (pc.population != null)?pc.population:'';
                                    groupPlanCustomerAcc.planOptionDesc = (custPurch.benefitPlanDescription != null)?custPurch.benefitPlanDescription:'';
                                    groupPlanCustomerAcc.planNameHoverVal = (custPurch.planOptionDescription != null)?custPurch.planOptionDescription:'';
                                    
                                    //System.debug('Entering.........'+groupPlanCustomerAcc);
                                    
                                    groupPlanCustomerAcc.PlanMettalicLevel = (custPurch.planMetallicLevel != Null)?custPurch.planMetallicLevel:'N/A';
                                    groupPlanCustomerAcc.Gated = (custPurch.gatedProductIndicator != null && custPurch.gatedProductIndicator != '')?((custPurch.gatedProductIndicator == '1')?'Y':((custPurch.gatedProductIndicator == '0')?'N':'')):'';                
                                    
                                    groupPlanCustomerAcc.PCPRequired =  groupPlanCustomerAcc.Gated;
                                    groupPlanCustomerAcc.domPartner = (custPurch.domesticPartnerIndicator!= null && custPurch.domesticPartnerIndicator!= '')?((custPurch.domesticPartnerIndicator== 'true')?'Y':((custPurch.domesticPartnerIndicator== 'false')?'N':'')):'';
                                    groupPlanCustomerAcc.FundingArrangement = (custPurch.fundingArrangementDescription != Null)?custPurch.fundingArrangementDescription:'';
                                    if(custPurch.BillingSchedule != null)
                                    {
                                        
                                        for(ACETGetEmployerGroupAdapterJSON2Apex.BillingSchedule billingSched:custPurch.BillingSchedule) {
                                            if(billingSched.contractTypeCode !=null) {
                                                // US2816535 - [PGA 1593 - Classic - Two Rates Displaying] - Hasara
                                                if(billingSched.billItemType =='PREMIUM') {
                                                    familyBasedInfo = new ACETGroupDetail.FamilyBasedWrap();
                                                    familyBasedInfo.contractTypeCode = billingSched.contractTypeCode;
                                                    familyBasedInfo.contractTypeDescription = billingSched.contractTypeDescription;
                                                    familyBasedInfo.amount = billingSched.amount;
                                                    groupPlanCustomerAcc.familyBasedGroupPlanList.add(familyBasedInfo);
                                                }
                                            }
                                            else {
                                                if(billingSched.ageBandToValue != null && billingSched.ageBandFromValue != null) {
                                                    Integer ageBandToVal = Integer.valueOf(billingSched.ageBandToValue);
                                                    Integer ageBandFromVal = Integer.valueOf(billingSched.ageBandFromValue);
                                                    if(ageBandToVal > 99)
                                                        ageBandToVal = 99;
                                                    // US2816535 - [PGA 1593 - Classic - Two Rates Displaying] - Hasara
                                                    if(billingSched.billItemType =='PREMIUM') {
                                                        for(Integer i = ageBandFromVal; i <= ageBandToVal; i++) {
                                                            ageBandInfo = new ACETGroupDetail.AgeBandWrap();
                                                            ageBandInfo.AgeBand = String.valueOf(i);
                                                            ageBandInfo.premium = (billingSched.amount != null && billingSched.amount != '')?billingSched.amount:'0'; //Modified for DE380225
                                                            groupPlanCustomerAcc.ageBandGroupPlanList.add(ageBandInfo); 
                                                            groupPlanCustomerAcc.ageBandGroupPlanList.sort();                                    
                                                        }  
                                                    }
                                                } 
                                            }                            
                                        }
                                    }
                                    pc.GroupPlanBenefitList.add(groupPlanCustomerAcc);    */                
                                    
                                }
                            }    
                           /* String todayDate = Date.Today().year() + '-' + Date.Today().month() + '-' + Date.Today().day();
                            if(accopt.startDate != null && (Date.valueOf(accopt.startDate) > Date.valueOf(todayDate ))){ 
                                pc.policyStatus = 'Future';
                            } else if(accopt.terminationDate != null && (Date.valueOf(accopt.terminationDate) < Date.valueOf(todayDate ))){
                                pc.policyStatus = 'Termed';
                            } else if(accopt.startDate != null && accopt.terminationDate != null && (Date.valueOf(accopt.startDate) <= Date.valueOf(todayDate ) && Date.valueOf(accopt.terminationDate) >= Date.valueOf(todayDate ))){
                                pc.policyStatus = 'Active';
                            }
                            
                            pc.effectiveDate = (accopt.startDate != null)?string.valueOf(Date.valueOf(accopt.startDate).format()):'';
                            pc.effectiveDatenoformat = (accopt.startDate != null)?string.valueOf(Date.valueOf(accopt.startDate)):'';
                            pc.endDate = (accopt.terminationDate != null)?string.valueOf(Date.valueOf(accopt.terminationDate).format()):'';
                            pc.endDatenoformat = (accopt.terminationDate != null)?string.valueOf(Date.valueOf(accopt.terminationDate)):'';
                            pc.migrated = (acc.migrationIndicator != null)?(acc.migrationIndicator.equals('true')?'Yes':'No'):''; 
                            pc.stateOfIssueCode = (accopt.stateOfIssueDescription != null)?accopt.stateOfIssueDescription:'';
                            pc.groupSitusState = (accopt.stateOfIssueCode != null)?accopt.stateOfIssueCode:'';
                            pc.exchangeType = (accopt.exchangeTypeDescription != null)?accopt.exchangeTypeDescription:'';     //US1744101
                            pc.polGenGroupInfo.contractId = (accopt.customerAccountOptionId != null)?accopt.customerAccountOptionId:'';
                            pc.polGenGroupInfo.contractDesc = (accopt.customerAccountOptionDescription != null)?accopt.customerAccountOptionDescription:'';
                            pc.polGenGroupInfo.contractStatus = (accopt.statusDescription != null)?accopt.statusDescription:'';
                            pc.polGenGroupInfo.contractEffectiveDate = (accopt.startDate != null)?string.valueOf(Date.valueOf(accopt.startDate).format()):'';
                            pc.polGenGroupInfo.contractEndDate = (accopt.terminationDate != null)?string.valueOf(Date.valueOf(accopt.terminationDate).format()):'';
                            pc.polGenGroupInfo.memberGroupId = (EGDetails.groupNumber != null)?EGDetails.groupNumber:'';
                            pc.polGenGroupInfo.contractType = (accopt.customerAccountOptionType != null)?accopt.customerAccountOptionType:'';
                            pc.polGenGroupInfo.originalContractDate = (acc.originalContractDate != null)?string.valueOf(Date.valueOf(acc.originalContractDate).format()):'';
                            pc.polGenGroupInfo.migratedContract = (acc.migrationIndicator != null)?(acc.migrationIndicator.equals('true')?'Yes':'No'):'';
                            pc.polGenGroupInfo.enrollmetIns = (accopt.enrollmentInsuringRulesPopulationIndicator != null)?(accopt.enrollmentInsuringRulesPopulationIndicator.equals('true')?'Yes':'No'):'';
                            pc.polGenGroupInfo.situsState = (accopt.stateOfIssueCode != null)?accopt.stateOfIssueCode:'';
                            pc.polGenGroupInfo.contractDCN = '';
                            pc.polGenGroupInfo.participationType = '';
                            pc.polGenGroupInfo.sourceSys = (acc.migrationSourceSystem != null && acc.migrationSourceSystem.name != null)?acc.migrationSourceSystem.name:'N/A';
                            pc.polGenGroupInfo.sourceSysId = (acc.migrationSourceSystem != null && acc.migrationSourceSystem.id != null)?acc.migrationSourceSystem.id:'N/A';
                            pc.polGenGroupInfo.billingPrefType = '';
                            pc.polGenGroupInfo.renewalDate = (accopt.renewalDate != null)?String.valueOf(Date.valueOf(accopt.renewalDate).format()):'';
                            
                            //Start of Onshore Restriction Changes
                            system.debug('!!!'+oACETGroupDetail.groupInsuringRules);
                            
                            if(oACETGroupDetail.groupInsuringRules != null){
                                pc.OnshoreRestrictionText ='';
                                pc.OnshoreRestrictionCode ='00';
                                pc.OnshoreRestrictionTooltip ='';
                                pc.continuationType ='';
                                pc.responsibilityType ='';
                                pc.onshoreRestrictionBoolean = '';
                                pc.onshoreRestrictionError = false;
                                pc.isRestrict = false;
                                Set<String> onshoreRest_lst = new Set<String>();
                                
                                for(ACETGroupDetail.GroupInsuringRules ins:oACETGroupDetail.groupInsuringRules ){
                                    system.debug('----------ins------'+ins);
                                    String mon = (String.valueOf(Date.Today().month()).length() == 1?('0'+String.Valueof(Date.Today().month())):String.valueof(Date.Today().month()));
                                    String day = (String.valueOf(Date.Today().day()).length() == 1?('0'+String.Valueof(Date.Today().day())):String.Valueof(Date.Today().day()));
                                    String currentDate = Date.Today().year() + '-' + mon + '-' + day;
                                    
                                    if(pc.population != '' && pc.population.contains(',') ){
                                        system.debug('%%%grpinsrulepopmultiple');  
                                        if(pc.policyStatus == 'Active'){
                                            if(Date.ValueOf(ins.insuringRulesEffectiveDatesNoFormat) <= Date.ValueOf(currentDate) && Date.ValueOf(currentDate)<= Date.ValueOf(ins.insuringRulesExpirationDatesNoFormat)){
                                                system.debug('%%%Activeinsidecurrentdate');
                                                system.debug('------ins.onshoreRestriction---------'+ins.onshoreRestriction);  
                                                List<String> lstpop = pc.population.split(',');
                                                
                                                if(ins.classesCode != '' ){  
                                                    for(String str:lstpop){
                                                        str = str.trim();        
                                                        if(ins.classesCode == str){
                                                            if(String.isNotBlank(ins.onshoreRestriction))
                                                                onshoreRest_lst.add(ins.onshoreRestriction);
                                                            
                                                            
                                                            
                                                            system.debug('%%%% Multi pop opt - Active - pop grp ins rules');
                                                            
                                                        }
                                                    }
                                                    system.debug('%%%%%%Multi pop New onshore'+onshoreRest_lst+onshoreRest_lst.size());
                                                    if(onshoreRest_lst.size() == 1 && lstpop.size() >= 1){
                                                        for(string onr: onshoreRest_lst){
                                                            pc.OnshoreRestrictionCode = ACETOnshoreIndicatorVerbiage__c.getValues(onr).Code_Description__c; 
                                                            pc.OnshoreRestrictionTooltip = ACETOnshoreIndicatorVerbiage__c.getValues(onr).Hover_Help_Description__c;   
                                                        }
                                                        
                                                    } if(onshoreRest_lst.size() == 0 && lstpop.size() == 0){ //DE376648
                                                        pc.onshoreRestrictionBoolean = '';
                                                        pc.OnshoreRestrictionCode = '00';   
                                                        pc.onshoreRestrictionError = true;
                                                    }
                                                    system.debug('%%%%% Multi pop New onshore code'+pc.OnshoreRestrictionCode);
                                                } 
                                                if(String.isBlank(ins.classesCode)){
                                                    system.debug('%%%% Multi pop opt - Active - plain grp ins rules');
                                                    pc.OnshoreRestrictionCode = (String.isNotBlank(ins.onshoreRestriction))?ACETOnshoreIndicatorVerbiage__c.getValues(ins.onshoreRestriction).Code_Description__c:'00';   
                                                    pc.OnshoreRestrictionTooltip = (String.isNotBlank(ins.onshoreRestriction))?ACETOnshoreIndicatorVerbiage__c.getValues(ins.onshoreRestriction).Hover_Help_Description__c:'';   
                                                    system.debug('%%%% Multi pop opt - Active - plain grp ins rules'+pc.OnshoreRestrictionCode);
                                                    
                                                }
                                                
                                                if(pc.continuationType == ''){
                                                    system.debug('~~~ Active Contract Option insuring Rule');
                                                    pc.continuationType = (ins.insuranceContinuationType != null)?ins.insuranceContinuationType:'';
                                                    
                                                } 
                                                
                                                
                                            }
                                            
                                        }
                                        else if(pc.policyStatus == 'Termed'){
                                            if(Date.ValueOf(ins.insuringRulesEffectiveDatesNoFormat) <= Date.ValueOf(pc.endDateNoFormat) && Date.ValueOf(ins.insuringRulesExpirationDatesNoFormat) >= Date.ValueOf(pc.endDateNoFormat) )
                                            {
                                                system.debug('------inside if dates---------'+pc.OnshoreRestrictionCode);  
                                                system.debug('------ins.onshoreRestriction---------'+ins.onshoreRestriction);  
                                                List<String> lstpop = pc.population.split(',');
                                                //Set<String> onshoreRest_lst = new Set<String>();
                                                system.debug('---lstpop ---------'+lstpop);
                                                if(ins.classesCode != '' ){  
                                                    for(String str:lstpop){
                                                        str = str.trim();        
                                                        if(ins.classesCode == str){
                                                            if(String.isNotBlank(ins.onshoreRestriction))
                                                                onshoreRest_lst.add(ins.onshoreRestriction);
                                                        }
                                                    }
                                                    
                                                    system.debug('%%%%%%Multi pop New onshore'+onshoreRest_lst+onshoreRest_lst.size());
                                                    if(onshoreRest_lst.size() == 1 && lstpop.size() >= 1){
                                                        for(string onr: onshoreRest_lst){
                                                            pc.OnshoreRestrictionCode = ACETOnshoreIndicatorVerbiage__c.getValues(onr).Code_Description__c; 
                                                            pc.OnshoreRestrictionTooltip = ACETOnshoreIndicatorVerbiage__c.getValues(onr).Hover_Help_Description__c;   
                                                        }
                                                    }else{
                                                        pc.onshoreRestrictionBoolean = '';
                                                        pc.OnshoreRestrictionCode = '00';   
                                                        pc.onshoreRestrictionError = true;
                                                    }
                                                    system.debug('%%%%% Multi pop New onshore code Termed'+pc.OnshoreRestrictionCode);
                                                    
                                                }
                                                
                                                if(pc.continuationType == ''){
                                                    system.debug('~~~ Termed Contract Option insuring Rule');
                                                    pc.continuationType = ins.insuranceContinuationType;
                                                } 
                                                if(String.isBlank(ins.classesCode)){
                                                    system.debug('%%%% Multi pop opt - Termed- plain grp ins rules');
                                                    pc.OnshoreRestrictionCode = (String.isNotBlank(ins.onshoreRestriction))?ACETOnshoreIndicatorVerbiage__c.getValues(ins.onshoreRestriction).Code_Description__c:'00';   
                                                    pc.OnshoreRestrictionTooltip = (String.isNotBlank(ins.onshoreRestriction))?ACETOnshoreIndicatorVerbiage__c.getValues(ins.onshoreRestriction).Hover_Help_Description__c:'';   
                                                    system.debug('%%%% Multi pop opt - Termed- plain grp ins rules'+pc.OnshoreRestrictionCode);
                                                    
                                                }
                                                
                                                system.debug('%%% pc.OnshoreRestrictionCode'+pc.OnshoreRestrictionCode);
                                                
                                            }
                                        }
                                        else if(pc.policyStatus == 'Future'){
                                            if(Date.ValueOf(ins.insuringRulesEffectiveDatesNoFormat) <= Date.ValueOf(pc.effectiveDateNoFormat) && Date.ValueOf(ins.insuringRulesExpirationDatesNoFormat) >= Date.ValueOf(pc.effectiveDateNoFormat) )
                                            {
                                                system.debug('------inside if dates---------'+pc.OnshoreRestrictionCode);  
                                                system.debug('------ins.onshoreRestriction---------'+ins.onshoreRestriction);  
                                                List<String> lstpop = pc.population.split(',');
                                                //Set<String> onshoreRest_lst = new Set<String>();
                                                system.debug('---lstpop ---------'+lstpop);
                                                if(ins.classesCode != '' ){  
                                                    for(String str:lstpop){
                                                        str = str.trim();        
                                                        if(ins.classesCode == str){
                                                            
                                                            if(String.isNotBlank(ins.onshoreRestriction))
                                                                onshoreRest_lst.add(ins.onshoreRestriction);
                                                            pc.continuationType = (pc.continuationType == '')?ins.insuranceContinuationType:pc.continuationType ;
                                                            system.debug('@@@cont & resp '+pc.continuationType +'; '+pc.responsibilityType); 
                                                        }
                                                        
                                                    }
                                                    
                                                    system.debug('%%%%%%Multi pop New onshore Future'+onshoreRest_lst+onshoreRest_lst.size());
                                                    if(onshoreRest_lst.size() == 1 && lstpop.size() >= 1){
                                                        for(string onr: onshoreRest_lst){
                                                            pc.OnshoreRestrictionCode = ACETOnshoreIndicatorVerbiage__c.getValues(onr).Code_Description__c; 
                                                            pc.OnshoreRestrictionTooltip = ACETOnshoreIndicatorVerbiage__c.getValues(onr).Hover_Help_Description__c;   
                                                        }
                                                    }else{
                                                        pc.onshoreRestrictionBoolean = '';
                                                        pc.OnshoreRestrictionCode = '00';   
                                                        pc.onshoreRestrictionError = true;
                                                    }
                                                    system.debug('%%%%% Multi pop New onshore code Future'+pc.OnshoreRestrictionCode);
                                                    
                                                }
                                                if(pc.continuationType == ''){
                                                    system.debug('~~~ Future Contract Option insuring Rule');
                                                    pc.continuationType = ins.insuranceContinuationType;
                                                } 
                                                if(String.isBlank(ins.classesCode)){
                                                    system.debug('%%%% Multi pop opt - Future- plain grp ins rules');
                                                    pc.OnshoreRestrictionCode = (String.isNotBlank(ins.onshoreRestriction))?ACETOnshoreIndicatorVerbiage__c.getValues(ins.onshoreRestriction).Code_Description__c:'00';   
                                                    pc.OnshoreRestrictionTooltip = (String.isNotBlank(ins.onshoreRestriction))?ACETOnshoreIndicatorVerbiage__c.getValues(ins.onshoreRestriction).Hover_Help_Description__c:'';   
                                                    system.debug('%%%% Multi pop opt - Future- plain grp ins rules'+pc.OnshoreRestrictionCode);
                                                    
                                                }
                                                system.debug('%%% isRestrict'+pc.isRestrict);
                                            }
                                        }
                                        system.debug('######@@@ Check Check'+pc.onshoreRestrictionCode);
                                        if(String.isNotBlank(pc.OnshoreRestrictionCode)){
                                            if(pc.OnshoreRestrictionCode != '00'){
                                                if(pc.OnshoreRestrictionCode == '05' || pc.OnshoreRestrictionCode == '07' || pc.OnshoreRestrictionCode == '08'){
                                                    pc.onshoreRestrictionBoolean = 'Yes';
                                                    pc.isRestrict = true;
                                                    pc.onshoreRestrictionError = false;
                                                }else{
                                                    pc.onshoreRestrictionBoolean = 'No';
                                                    pc.isRestrict = false;
                                                    pc.onshoreRestrictionError = false;
                                                } 
                                                
                                            }
                                            else{
                                                pc.onshoreRestrictionBoolean = '';
                                                pc.isRestrict = false;
                                                pc.onshoreRestrictionError = true;
                                            }
                                            
                                        }
                                        
                                        system.debug('###### Multi pop : OnshoreCode'+pc.onshoreRestrictionCode+'>>'+pc.onshoreRestrictionBoolean+'>>'+pc.onshoreRestrictionError);
                                        
                                    }
                                    // This condition is for Single population is defined at Contract Option and Group insuring rule Level OR No Population OR Population is defined at Contract Option level but Not at Group Insuring Rule level
                                    else if((pc.population != '' && ins.classesCode != ''  && pc.population == ins.classesCode)||(pc.population == '' && ins.classesCode == '') || (pc.population != '' && ins.classesCode == '' && !pc.population.contains(','))){
                                        system.debug('%%%grpinsrulepopsingle/Nopop');  
                                        if(pc.policystatus == 'Active'){
                                            system.debug('%%%Activesinglepop/Nopop'+pc.population);
                                            if(Date.ValueOf(ins.insuringRulesEffectiveDatesNoFormat) <= Date.ValueOf(currentDate) && Date.ValueOf(currentDate)<= Date.ValueOf(ins.insuringRulesExpirationDatesNoFormat)){
                                                system.debug('%%%Activeinsidecurrentdate');
                                                pc.continuationType = ins.insuranceContinuationType;
                                                pc.responsibilityType = ins.continuationResponsibilityType;
                                                if(String.isNotBlank(ins.onshoreRestriction)){
                                                    system.debug('!!!!'+ins.onshoreRestriction);
                                                    
                                                    pc.OnshoreRestrictionText = ins.onshoreRestriction;
                                                    pc.OnshoreRestrictionCode    = ACETOnshoreIndicatorVerbiage__c.getValues(ins.onshoreRestriction).Code_Description__c;
                                                    pc.OnshoreRestrictionTooltip = ACETOnshoreIndicatorVerbiage__c.getValues(ins.onshoreRestriction).Hover_Help_Description__c ; 
                                                    if((pc.OnshoreRestrictionCode == '05' || pc.OnshoreRestrictionCode == '07' || pc.OnshoreRestrictionCode == '08') )//&& IsOnshore== false)
                                                    {
                                                        pc.IsRestrict = true;
                                                        pc.onshoreRestrictionBoolean = 'Yes';
                                                    }else{
                                                        pc.IsRestrict = false;
                                                        pc.onshoreRestrictionBoolean = 'No';
                                                    }
                                                    
                                                }
                                                else{
                                                    pc.IsRestrict = false;
                                                    pc.onshoreRestrictionBoolean = '';
                                                    pc.OnshoreRestrictionCode = '00';   
                                                    pc.onshoreRestrictionError = true;  
                                                    
                                                }
                                                system.debug('%%% isRestrict'+pc.isRestrict);
                                            }
                                            
                                            
                                        }
                                        else if(pc.policystatus == 'Termed'){
                                            system.debug('%%%Termedsinglepop');
                                            
                                            if(Date.ValueOf(ins.insuringRulesEffectiveDatesNoFormat) <= Date.ValueOf(pc.endDateNoFormat) && Date.ValueOf(ins.insuringRulesExpirationDatesNoFormat) >= Date.ValueOf(pc.endDateNoFormat) )
                                            {
                                                system.debug('%%%Termedinsidelastdatebucket');
                                                
                                                pc.continuationType = ins.insuranceContinuationType;
                                                pc.responsibilityType = ins.continuationResponsibilityType;
                                                if(String.isNotBlank(ins.onshoreRestriction)){
                                                    
                                                    pc.OnshoreRestrictionText = ins.onshoreRestriction;
                                                    pc.OnshoreRestrictionCode    = ACETOnshoreIndicatorVerbiage__c.getValues(ins.onshoreRestriction).Code_Description__c;
                                                    // getEmp V3 changes End
                                                    
                                                    pc.OnshoreRestrictionTooltip = ACETOnshoreIndicatorVerbiage__c.getValues(ins.onshoreRestriction).Hover_Help_Description__c ; 
                                                    if((pc.OnshoreRestrictionCode == '05' || pc.OnshoreRestrictionCode == '07' || pc.OnshoreRestrictionCode == '08') )//&& IsOnshore== false)
                                                    {
                                                        pc.IsRestrict = true;
                                                        pc.onshoreRestrictionBoolean = 'Yes';
                                                    }else{
                                                        pc.IsRestrict = false;
                                                        pc.onshoreRestrictionBoolean = 'No';
                                                    }
                                                    
                                                }
                                                else{
                                                    pc.IsRestrict = false;
                                                    
                                                    pc.onshoreRestrictionBoolean = '';
                                                    pc.OnshoreRestrictionCode = '00';   
                                                    pc.onshoreRestrictionError = true;
                                                }    
                                                system.debug('%%% isRestrict'+pc.isRestrict);
                                                
                                            }
                                        }
                                        else if(pc.policystatus == 'Future'){
                                            if(Date.ValueOf(ins.insuringRulesEffectiveDatesNoFormat) <= Date.ValueOf(pc.effectiveDateNoFormat) && Date.ValueOf(ins.insuringRulesExpirationDatesNoFormat) >= Date.ValueOf(pc.effectiveDateNoFormat) )
                                            {
                                                system.debug('%%%Futuresinglepop');
                                                system.debug('%%%Futuredate');
                                                
                                                pc.continuationType = ins.insuranceContinuationType;
                                                pc.responsibilityType = ins.continuationResponsibilityType;
                                                if(String.isNotBlank(ins.onshoreRestriction)){
                                                    
                                                    pc.OnshoreRestrictionText = ins.onshoreRestriction;
                                                    pc.OnshoreRestrictionCode    = ACETOnshoreIndicatorVerbiage__c.getValues(ins.onshoreRestriction).Code_Description__c;
                                                    // getEmp V3 changes End
                                                    
                                                    pc.OnshoreRestrictionTooltip = ACETOnshoreIndicatorVerbiage__c.getValues(ins.onshoreRestriction).Hover_Help_Description__c ; 
                                                    if((pc.OnshoreRestrictionCode == '05' || pc.OnshoreRestrictionCode == '07' || pc.OnshoreRestrictionCode == '08') )//&& IsOnshore== false)                                                 {
                                                    {
                                                        pc.IsRestrict = true;
                                                        pc.onshoreRestrictionBoolean = 'Yes';
                                                    }else{
                                                        pc.IsRestrict = false;
                                                        pc.onshoreRestrictionBoolean = 'No';
                                                    }
                                                    
                                                }
                                                else{
                                                    pc.IsRestrict = false;
                                                    
                                                    pc.onshoreRestrictionBoolean = '';
                                                    pc.OnshoreRestrictionCode = '00';   
                                                    pc.onshoreRestrictionError = true;
                                                }    
                                                system.debug('%%% isRestrict'+pc.isRestrict);
                                            }
                                        }
                                    }
                                    
                                }
                            }*/
                            //End of Onshore Restriction Changes
                            
                            if(accopt.customerAccountInsuringRules != null){
                                for(ACETGetEmployerGroupAdapterJSON2Apex.CustomerAccountInsuringRules rul:accopt.customerAccountInsuringRules)
                                {
                                    ACETGroupDetail.InsuredRules ins = new ACETGroupDetail.InsuredRules();
                                    
                                    ins.hasPopulation = (rul.classesDescription != null )?true:false;
                                    
                                    String currentDate = Date.Today().year() + '-' + Date.Today().month() + '-' + Date.Today().day();
                                    if(rul.insuringRuleEffectiveDates != null && (Date.valueOf(rul.insuringRuleEffectiveDates ) > Date.valueOf(currentDate))){ 
                                        ins.Status = 'Future';
                                    } else if(rul.insuringRuleExpirationDates != null && (Date.valueOf(rul.insuringRuleExpirationDates) < Date.valueOf(currentDate))){
                                        ins.Status = 'Termed';
                                    } else if(rul.insuringRuleEffectiveDates != null && rul.insuringRuleExpirationDates != null && (Date.valueOf(rul.insuringRuleEffectiveDates ) <= Date.valueOf(currentDate) && Date.valueOf(rul.insuringRuleExpirationDates) >= Date.valueOf(currentDate))){
                                        ins.Status = 'Active';
                                    }
                                    
                                    ins.EffectiveDate = (rul.insuringRuleEffectiveDates != null )?String.valueof(Date.valueOf(rul.insuringRuleEffectiveDates).format()):'';
                                    ins.endDate = (rul.insuringRuleExpirationDates != null)?String.valueof(Date.valueOf(rul.insuringRuleExpirationDates).format()):'12/31/9999';
                                    ins.dependentCutOff = rul.insRulesDesc = (rul.dependentCutOff != null && rul.dependentCutOffType != null)?('Age '+rul.dependentCutOff +' '+rul.dependentCutOffType):'N/A';
                                    ins.population = (rul.classesDescription != null )?rul.classesDescription.replace(',',''):'';
                                    system.debug('@@@pop'+ins.population + '   '+rul.insuringRuleEffectiveDates );
                                    
                                    ins.insrules = new list<ACETGroupDetail.InsRule>();
                                    for(i=0;i<6;i++)
                                    {
                                        ACETGroupDetail.InsRule insRuleItem = new ACETGroupDetail.InsRule();
                                        insRuleItem.pop = ins.population;
                                        
                                        if(rul.waiveWaitingPeriodForNewHireIndicator != null && i==0)
                                        {
                                            insRuleItem.insRules = 'New Hire Waiting Period';
                                            if(rul.waitingPeriodRules != null){
                                                for(ACETGetEmployerGroupAdapterJSON2Apex.WaitingPeriodRules wp:rul.waitingPeriodRules){
                                                    if(wp.qualifyingEvent != null && wp.qualifyingEvent == 'Initial Enrollment' ){
                                                        if(wp.waitingDurationType != null || wp.waitingDurationValue != null || wp.waitingPeriodType !=null){
                                                            if(wp.waitingPeriodType!=null && wp.waitingPeriodType == 'FOFM after Specified Duration'){
                                                                insRuleItem.insRulesDesc = 'First of the month after '+(wp.waitingDurationValue!= null?wp.waitingDurationValue.removeStart('0'):'' )+' '+(wp.waitingDurationType!=null?((wp.waitingDurationValue != null && wp.waitingDurationValue =='01')?wp.waitingDurationType.removeEnd('s'):wp.waitingDurationType):'');
                                                            }
                                                            else if(wp.waitingPeriodType!=null && wp.waitingPeriodType == 'Specified Duration'){
                                                                insRuleItem.insRulesDesc = (wp.waitingDurationValue!= null?wp.waitingDurationValue.removeStart('0'):'' )+' '+(wp.waitingDurationType!=null?((wp.waitingDurationValue != null && wp.waitingDurationValue =='01')?wp.waitingDurationType.removeEnd('s'):wp.waitingDurationType):'') +' after Date of Hire';
                                                            }
                                                            else if(wp.waitingPeriodType!=null && wp.waitingPeriodType == 'First of the Following Month (FOFM)'){
                                                                insRuleItem.insRulesDesc = 'First of the month after Date of Hire';
                                                            }
                                                            else {
                                                                insRuleItem.insRulesDesc = (wp.waitingPeriodType!=null?wp.waitingPeriodType:'' );
                                                            }
                                                            
                                                        }else 
                                                            insRuleItem.insRulesDesc = 'N/A' ;  
                                                    }
                                                }     
                                            }
                                            else {
                                                insRuleItem.insRulesDesc = 'N/A';
                                            }
                                            //}     //US1589796   
                                            
                                        }
                                        else if(rul.terminationLagDescription != null && i==1)
                                        {
                                            insRuleItem.insRules = 'Termination Lag';
                                            insRuleItem.insRulesDesc = (rul.terminationLagDescription!=null)?rul.terminationLagDescription:'N/A';
                                            
                                        }
                                        
                                        else if(rul.dependentCutOff != null && rul.dependentCutOffType != null && i==2)
                                        {
                                            insRuleItem.insRules = 'Dependent Cutoff';
                                            insRuleItem.insRulesDesc = (rul.dependentCutOff != null && rul.dependentCutOffType != null)?('Age '+rul.dependentCutOff +' '+rul.dependentCutOffType):'N/A';
                                            
                                        }
                                        else if(rul.waiveRehiredIndefiniteIndicator != null && i==3)
                                        {
                                            insRuleItem.insRules = 'Rehire';
                                            if(rul.waiveRehiredIndefiniteIndicator == 'false')
                                            {
                                                if(rul.waiveRehiredWithinCount != null && rul.waiveRehiredWithinType != null)
                                                {
                                                    insRuleItem.insRulesDesc = 'Waive With in '+rul.waiveRehiredWithinCount+' '+((rul.waiveRehiredWithinType == 'D')?((rul.waiveRehiredWithinCount == '1')?'Day':'Days'):((rul.waiveRehiredWithinType == 'M')?((rul.waiveRehiredWithinCount == '1')?'Month':'Months'):''));
                                                }
                                                else
                                                    insRuleItem.insRulesDesc = 'N/A';
                                            }    
                                            else
                                                insRuleItem.insRulesDesc = 'Waive Indefinitely';
                                            
                                            
                                        }
                                        
                                        else if(i==4 && rul.nonStandardWaitingPeriodIndicator != null){
                                            insRuleItem.insRules = 'Non Standard Waiting Period';
                                            insRuleItem.insRulesDesc = (( rul.nonStandardWaitingPeriodIndicator == 'true')? ((rul.nonStandardWaitingPeriodValue != null )?rul.nonStandardWaitingPeriodValue:'') :'N/A');
                                            
                                        }
                                        
                                        else if(i==5 && accopt.defineOpenEnrollmentbyPopulationIndicator != null){
                                            insRuleItem.insRules = 'Open Enrollment Period';
                                            if(accopt.defineOpenEnrollmentbyPopulationIndicator == 'true' && accopt.customerAccountGroupPopulation!= null){
                                                for(ACETGetEmployerGroupAdapterJSON2Apex.CustomerAccountGroupPopulation gp:accopt.customerAccountGroupPopulation){
                                                    system.debug('Inside group population'+ins.population + '   '+ gp.classesDescription );
                                                    if(ins.population == gp.classesDescription && gp.populationOpenEnrollmentStartDate != null && gp.populationOpenEnrollmentEndDate != null){
                                                        insRuleItem.insRulesDesc = String.ValueOf(Date.ValueOf(gp.populationOpenEnrollmentStartDate).format())+' to '+String.ValueOf(Date.ValueOf(gp.populationOpenEnrollmentEndDate).format());                                                    
                                                    }else
                                                        insRuleItem.insRulesDesc = ((accopt.openEnrollmentStartDate != null && accopt.openEnrollmentEndDate!= null)?(String.ValueOf(Date.ValueOf(accopt.openEnrollmentStartDate).format())+' to '+String.ValueOf(Date.ValueOf(accopt.openEnrollmentEndDate).format())):'');                                                   
                                                }
                                            }
                                            else {
                                                insRuleItem.insRulesDesc = ((accopt.openEnrollmentStartDate != null && accopt.openEnrollmentEndDate!= null)?(String.ValueOf(Date.ValueOf(accopt.openEnrollmentStartDate).format())+' to '+String.ValueOf(Date.ValueOf(accopt.openEnrollmentEndDate).format())):'');                                            
                                            }
                                        }
                                        ins.insrules.add(insRuleItem);
                                    }
                                    system.debug('$$$insruleitem'+ins.insrules);
                                    pc.insurRules.add(ins);
                                }
                            }
                            if(!isPlanAdded){
                                oACETGroupDetail.polContract.add(pc);  
                            }
                        }
                        else{
                            /*for(ACETGetEmployerGroupAdapterJSON2Apex.customerPurchase custPurch: accopt.customerPurchase){
                                    if((accopt.statusCode == 'A') && (custPurch.contractOptionType=='DN' && custPurch.benefitType=='DN') ||
                                       (custPurch.contractOptionType=='VS' && custPurch.benefitType=='VS')){
                                        ACETGroupDetail.SpecialtyBenefits_CoverageLine sbc = new ACETGroupDetail.SpecialtyBenefits_CoverageLine();
                                        sbc.ContractOptionType = custPurch.contractOptionTypeDescription;
                                        sbc.ContractOptionStartDate = custPurch.coverageStartDate;
                                        sbc.ContractOptionEndDate = custPurch.coverageExpirationDate;
                                        sbc.planOptionID = custPurch.memberGroupContractPlanOptionID;
                                        sbc.isActive =Date.valueOf(sbc.ContractOptionStartDate)<=System.today()
                                            && Date.valueOf(sbc.ContractOptionEndDate)>=System.today()?'Active':'Inactive';
                                        oACETGroupDetail.specialityBenefits.add(sbc); 
                                    }
                            }*/
                        }
                    } 
                }
                
            }
        }
    }
    //getemp V3 ends
    
    //Mapping General Group Info Section
   /* private void generalGroupInfoMapping(ACETGetEmployerGroupAdapterJSON2Apex.EmployerGroup EGDetails)
    {
        if (EGDetails != null )
        {   
            oACETGroupDetail.genGroupInfo.groupName = (EGDetails.groupName != Null)?EGDetails.groupName.replaceAll('(\\s+)', ' '):''; 
            oACETGroupDetail.genGroupInfo.groupId = (EGDetails.groupNumber != Null)?EGDetails.groupNumber:''; 
            taxId = '';
            if(EGDetails.taxIdentificationNumber != null)
            {
                Integer taxIdSize =  EGDetails.taxIdentificationNumber.size();
                for (Integer j = taxIdSize ; j > 0; j--) 
                {
                    //taxId = (taxId == Null)?EGDetails.taxIdentificationNumber[j-1]:taxId + ', ' +EGDetails.taxIdentificationNumber[j-1]; 
                    if(taxId == '' || taxId == null)
                    {
                        taxId = EGDetails.taxIdentificationNumber[j-1];
                    }
                    else
                    {
                        taxId = taxId + ', ' +EGDetails.taxIdentificationNumber[j-1];
                    }                
                }
            }
            
            oACETGroupDetail.genGroupInfo.groupTaxId = taxId;
            //getemp V3 starts
            // Group Level Hold code
            oACETGroupDetail.holdCode = new List<ACETGroupDetail.holdCodeInfo>();
            if(EGDetails.GroupLevelHold != null){
                for(ACETGetEmployerGroupAdapterJSON2Apex.GroupLevelHold holdGroup:EGDetails.GroupLevelHold){
                    ACETGroupDetail.holdCodeInfo holdingCode = new ACETGroupDetail.holdCodeInfo();
                    holdingCode.holdID = (holdGroup.groupHoldCreatedByUserId != null)?holdGroup.groupHoldCreatedByUserId:'';
                    holdingCode.holdCode = (holdGroup.groupHoldCode != null)?holdGroup.groupHoldCode:'';
                    holdingCode.holdDescription = (holdGroup.groupHoldShortDescription != null)?holdGroup.groupHoldShortDescription:'';
                    holdingCode.holdEffectiveDate = (holdGroup.groupHoldEffectiveDates != null)?String.valueof(Date.valueOf(holdGroup.groupHoldEffectiveDates).format()):'';
                    holdingCode.holdExpirationDate = (holdGroup.groupHoldExpirationDates != null)?String.valueof(Date.valueOf(holdGroup.groupHoldExpirationDates).format()):'';
                    holdingCode.holdProcessedOn = (holdGroup.groupHoldTransactionDate != null)?String.valueof(Date.valueOf(holdGroup.groupHoldTransactionDate).format()):'';
                    oACETGroupDetail.holdCode.add(holdingCode);
                }
            }
            
            //US1699536 starts
            oACETGroupDetail.groupSettings = new List<ACETGroupDetail.cobAttestation>();
            if(EGDetails.groupSettings != null) {
                for(ACETGetEmployerGroupAdapterJSON2Apex.cobAttestation groupSet:EGDetails.groupSettings) {
                    ACETGroupDetail.cobAttestation settings = new ACETGroupDetail.cobAttestation();
                    settings.cobAttestationFrequency = (groupSet.cobAttestationFrequency != null)?groupSet.cobAttestationFrequency:'';
                    settings.cobAttestationDenyGracePeriod = (groupSet.cobAttestationDenyGracePeriod != null)?groupSet.cobAttestationDenyGracePeriod:'';
                    settings.religiousExemptionTypeDescription = (groupSet.religiousExemptionTypeDescription != null)?groupSet.religiousExemptionTypeDescription:'';
                    settings.effectiveDate = (groupSet.effectiveDate != null)?groupSet.effectiveDate:'';
                    settings.expirationDate = (groupSet.expirationDate != null)?groupSet.expirationDate:'';
                    oACETGroupDetail.groupSettings.add(settings);
                    
                    String effDate = settings.effectiveDate.split('-')[0] + settings.effectiveDate.split('-')[1] + settings.effectiveDate.split('-')[2];
                    String expDate = settings.expirationDate.split('-')[0] + settings.expirationDate.split('-')[1] + settings.expirationDate.split('-')[2];
                    String curr = string.valueOf(Date.today());
                    curr = curr.split('-')[0] + curr.split('-')[1] + curr.split('-')[2];
                    if(effDate <= curr && curr <= expDate){
                        oACETGroupDetail.genGroupInfo.religiousExemptionType = settings.religiousExemptionTypeDescription;
                    } else if(oACETGroupDetail.genGroupInfo.religiousExemptionType == null || oACETGroupDetail.genGroupInfo.religiousExemptionType == ''){
                        oACETGroupDetail.genGroupInfo.religiousExemptionType = '';
                    }
                    
                }
                List<ReligiousExemptionMap__mdt> relExemp = [select ReligiousType__c, ReligiousDescription__c from ReligiousExemptionMap__mdt WHERE ReligiousType__c = :oACETGroupDetail.genGroupInfo.religiousExemptionType];
                if(relExemp.size() > 0){
                    oACETGroupDetail.genGroupInfo.religiousExemptionDesc = (relExemp[0].ReligiousDescription__c != null)?relExemp[0].ReligiousDescription__c:'';
                }
            }
            //US1699536 ends 
            
            String currentDate = Date.Today().year() + '-' + Date.Today().month() + '-' + Date.Today().day();
            system.debug('%%%current date'+currentDate);
            
            if(oACETGroupDetail.holdCode.size() == 0){
                system.debug('Inside No Hold');
                oACETGroupDetail.genGroupInfo.holdCodeIndicator = false;
                oACETGroupDetail.genGroupInfo.holdCode = 'No';
            }
            else {
                Boolean holds = false; 
                for(ACETGroupDetail.holdCodeInfo hc:oACETGroupDetail.holdCode){
                    Date newHoldEffDate = Date.newInstance(Integer.valueOf(hc.holdEffectiveDate.split('/')[2]), Integer.valueOf(hc.holdEffectiveDate.split('/')[0]), Integer.valueOf(hc.holdEffectiveDate.split('/')[1]));
                    Date newHoldExpDate = Date.newInstance(Integer.valueOf(hc.holdExpirationDate.split('/')[2]), Integer.valueOf(hc.holdExpirationDate.split('/')[0]), Integer.valueOf(hc.holdExpirationDate.split('/')[1]));
                    
                    if(Date.Valueof(newHoldEffDate) <= Date.ValueOf(currentDate) && Date.ValueOf(currentDate) <= Date.Valueof(newHoldExpDate)){
                        system.debug('Inside Current Hold');
                        holds = true;
                        break;
                    }
                }
                if(holds){
                    system.debug('Inside Current Hold');
                    oACETGroupDetail.genGroupInfo.holdCodeIndicator = true;
                    oACETGroupDetail.genGroupInfo.holdCode = 'Yes';
                }
                else {
                    system.debug('Inside Past Hold');
                    oACETGroupDetail.genGroupInfo.holdCodeIndicator = true;
                    oACETGroupDetail.genGroupInfo.holdCode = 'No';
                }
                
            }
            
            //getemp V3 ends
            oACETGroupDetail.genGroupInfo.groupTeamSize = (EGDetails.sizeDefinitionDescription != Null)?EGDetails.sizeDefinitionDescription:''; 
            oACETGroupDetail.genGroupInfo.riskManagement = (EGDetails.riskManagementIndicator != Null)?((EGDetails.riskManagementIndicator == 'true')?'Yes':((EGDetails.riskManagementIndicator == 'false')?'No':'')):'';  
            oACETGroupDetail.genGroupInfo.asianInitIndicator = 'No'; //US1024400
            oACETGroupDetail.genGroupInfo.parentIndicator = '';
            
            
            if(EGDetails.alphaParentGroup!= Null && EGDetails.alphaParentGroup.name != null &&EGDetails.parentGroup!= Null && EGDetails.parentGroup.name != null){
                oACETGroupDetail.genGroupInfo.parentGroup = EGDetails.parentGroup.id +' - '+EGDetails.parentGroup.name ;
                oACETGroupDetail.genGroupInfo.alphaParentGroup = EGDetails.alphaParentGroup.id +' - '+EGDetails.alphaParentGroup.name ;
            }else{
                oACETGroupDetail.genGroupInfo.parentGroup = 'N/A';
                oACETGroupDetail.genGroupInfo.alphaParentGroup = 'N/A';
            }
            //US2810030
            if(EGDetails.migrationSourceSystem != Null && EGDetails.migrationSourceSystem.size()>0
               && EGDetails.migrationSourceSystem[0].name!=null && EGDetails.migrationSourceSystem[0].id!=null){
                   
                   oACETGroupDetail.genGroupInfo.migrationSourceSystem
                       = EGDetails.migrationSourceSystem[0].name +' - '+EGDetails.migrationSourceSystem[0].id; 
               }  
            else{
                oACETGroupDetail.genGroupInfo.migrationSourceSystem = 'N/A';
            }
            if(EGDetails.parentGroup != null && EGDetails.parentGroup.name != null){
                oACETGroupDetail.grpAffiliationsinfo.parentGroupname = EGDetails.parentGroup.name;
            }
            if(EGDetails.parentGroup != null && EGDetails.parentGroup.id != null){
                oACETGroupDetail.grpAffiliationsinfo.parentGroupid = EGDetails.parentGroup.id;
            }
            if(EGDetails.alphaParentGroup != null && EGDetails.alphaParentGroup.name != null){
                oACETGroupDetail.grpAffiliationsinfo.alphaParentGroupname = EGDetails.alphaParentGroup.name;
            }
            if(EGDetails.alphaParentGroup != null && EGDetails.alphaParentGroup.id != null){
                oACETGroupDetail.grpAffiliationsinfo.alphaParentGroupid = EGDetails.alphaParentGroup.id;
            }
            String childGroups;
            String childGroupsname;
            String childGroupsids;
            oACETGroupDetail.grpAffiliationsinfo.childGroupidlist  = new List<String>();
            oACETGroupDetail.grpAffiliationsinfo.childGroupnamelist  = new List<String>();
            if(EGDetails.childGroup != null){
                childGroups = '';
                for(ACETGetEmployerGroupAdapterJSON2Apex.ParentGroup cg:EGDetails.childGroup){
                    if(childGroups == '')
                        childGroups = ((cg.name!=null)?cg.name:'');
                    else
                        childGroups = childGroups + ' & '+((cg.name!=null)?cg.name:'');
                    
                    oACETGroupDetail.grpAffiliationsinfo.childGroupidlist.add(cg.id);
                    oACETGroupDetail.grpAffiliationsinfo.childGroupnamelist.add(cg.name);
                    
                }
                
            }
            
            
            system.debug('!!!parentindicator'+oACETGroupDetail.genGroupInfo.parentIndicator );
            if(EGDetails.CustomerAccount == null || EGDetails.CustomerAccount.isEmpty() || EGDetails.CustomerAccount.size() == 0){
                oACETGroupDetail.noCustomerAccount = true;
            } else {
                oACETGroupDetail.noCustomerAccount = false;
                oACETGroupDetail.genGroupInfo.originalgrpStartDate =(EGDetails.CustomerAccount[0] != null && EGDetails.CustomerAccount[0].originalContractDate!= Null)?String.valueof(Date.valueOf(EGDetails.CustomerAccount[0].originalContractDate).format()):'';
                oACETGroupDetail.genGroupInfo.legacyGroupNumber =(EGDetails.CustomerAccount[0] != null && EGDetails.CustomerAccount[0].migrationSourceSystem!= Null && EGDetails.CustomerAccount[0].migrationIndicator!= Null && EGDetails.CustomerAccount[0].migrationIndicator=='true')?EGDetails.CustomerAccount[0].migrationSourceSystem.Id:'N/A';
                
            }
            //Additional Information
            oACETGroupDetail.additionalGroupInfo.memGroupClassification = (EGDetails.groupClassification!= Null)?EGDetails.groupClassification:'';
            oACETGroupDetail.additionalGroupInfo.enrollmentMethod= (EGDetails.enrollmentType!= Null)?EGDetails.enrollmentType:'';
            
        }    
        
    }    */
    
    // Mapping Attestations sections 
  /*  private void groupEmployeeCountMapping(ACETGetEmployerGroupAdapterJSON2Apex.EmployerGroup EGDetails)
    {
        if (EGDetails != null )
        {
            
            ACETGroupDetail.employeeCountInfo employeeCountInfo = new ACETGroupDetail.employeeCountInfo();
            
            if(EGDetails.employeeCounts != null)
            {
                set<string> uniqueYears = new set<string>{String.valueof(Date.Today().Year()),String.valueof(Date.Today().Year()-1)};
                    
                    
                    system.debug('###years'+uniqueYears);
                map<string,ACETGroupDetail.employeeCountInfo> employeeCountMap = new map<string,ACETGroupDetail.employeeCountInfo>();
                for(string s:uniqueYears){
                    system.debug('###yearsinside'+s);
                    
                    for(ACETGetEmployerGroupAdapterJSON2Apex.EmployeeCounts addEmpCount:EGDetails.employeeCounts)
                    {
                        //employeeCountInfo = new ACETGroupDetail.employeeCountInfo();
                        if(addEmpCount.reportingYear == s){
                            system.debug('###insideEmpCountloop');
                            
                            if(addEmpCount.employeeCountDescription == 'Average Total Number of Employees (ATNE)') 
                                employeeCountInfo.employeeAtne = addEmpCount.employeeCount;
                            if(addEmpCount.employeeCountDescription == 'Total Count of Full Time Employees')
                                employeeCountInfo.fullTime = addEmpCount.employeeCount;
                            if(addEmpCount.employeeCountDescription == 'Part-time')
                                employeeCountInfo.partTime = addEmpCount.employeeCount;
                            if(addEmpCount.employeeCountDescription == 'Total Eligible')
                                employeeCountInfo.totalEligible = addEmpCount.employeeCount;
                            if(addEmpCount.employeeCountDescription == 'Union Eligible')
                                employeeCountInfo.unionEligible = addEmpCount.employeeCount;
                            if(addEmpCount.employeeCountDescription == 'Full-Time-Equivalent')
                                employeeCountInfo.fullTimeEquivalent = addEmpCount.employeeCount;
                            employeeCountInfo.lastUpdate = (addEmpCount.transactionDate != null)?String.valueof(Date.valueOf(addEmpCount.transactionDate).format()):'';
                            employeeCountInfo.renewalYear = (addEmpCount.reportingYear != null)?addEmpCount.reportingYear:'';
                            
                        }
                        
                    }
                    
                    if(employeeCountInfo.renewalYear != null){
                        employeeCountInfo.employeeAtne = (employeeCountInfo.employeeAtne != null)?employeeCountInfo.employeeAtne:'0';
                        employeeCountInfo.fullTime = (employeeCountInfo.fullTime != null)?employeeCountInfo.fullTime:'0';
                        employeeCountInfo.partTime = (employeeCountInfo.partTime != null)?employeeCountInfo.partTime:'0';
                        employeeCountInfo.totalEligible = (employeeCountInfo.totalEligible != null)?employeeCountInfo.totalEligible:'0';
                        employeeCountInfo.unionEligible = (employeeCountInfo.unionEligible != null)?employeeCountInfo.unionEligible:'0';
                        employeeCountInfo.fullTimeEquivalent = (employeeCountInfo.fullTimeEquivalent != null)?employeeCountInfo.fullTimeEquivalent:'0';
                        employeeCountMap.put(s,employeeCountInfo);
                    }
                    employeeCountInfo = new ACETGroupDetail.employeeCountInfo();
                    
                    
                }
                system.debug('###Map'+employeeCountMap);
                
                if(!employeeCountMap.isEmpty()){
                    for (String s : employeeCountMap.keySet())
                    {
                        System.debug('###key'+s);
                        System.debug('###get'+employeeCountMap.get(s));
                        oACETGroupDetail.groupEmployeeCountInfoList.add(employeeCountMap.get(s));
                    }
                }
            }
        }    
        
    }*/
    
    // Mapping Address Section
   /* private void groupAddressMapping(ACETGetEmployerGroupAdapterJSON2Apex.EmployerGroup EGDetails)
    {
        ACETGroupDetail.AddressInfo addressBillingInfo = new ACETGroupDetail.AddressInfo();
        oACETGroupDetail.groupAddressInfoPastList = new List<ACETGroupDetail.AddressInfo>();
        oACETGroupDetail.groupAddressInfoCurrFutureList = new List<ACETGroupDetail.AddressInfo>();
        if(EGDetails.groupAddress != null)
            for(ACETGetEmployerGroupAdapterJSON2Apex.GroupAddress addEGC:EGDetails.groupAddress )
        {  
            if(addEGC.addressTypeCode != null)
            {
                ACETGroupDetail.AddressInfo addressInfo = new ACETGroupDetail.AddressInfo();  
                addressInfo.addrType  = (addEGC.addressTypeDescription != null)?addEGC.addressTypeDescription:'';
                addressInfo.addrLine1  = addEGC.addressLine1;
                addressInfo.addrLine2  = (addEGC.addressLine2 != Null && addEGC.addressLine2 != '')?addEGC.addressLine2:''; 
                addressInfo.city  = addEGC.addressCity;
                addressInfo.zip  = addEGC.addressPostalCode;
                addressInfo.state = addEGC.addressStateCode;
                addressInfo.concatAddrLines='';
                addressInfo.concatAddrLines = addressInfo.concatAddrLines + ((addEGC.addressLine1!= Null && addEGC.addressLine1!= '')?addEGC.addressLine1:'');
                addressInfo.concatAddrLines = addressInfo.concatAddrLines + ((addEGC.addressLine2!= Null && addEGC.addressLine2!= '')?', '+addEGC.addressLine2:'');
                addressInfo.concatAddrLines = addressInfo.concatAddrLines + ((addEGC.addressLine3!= Null && addEGC.addressLine3!= '')?', '+addEGC.addressLine3:'');
                addressInfo.concatAddrLines = addressInfo.concatAddrLines.removeStart(',');
                
                addressInfo.address='';
                addressInfo.address = addressInfo.address + ((addEGC.addressLine1!= Null && addEGC.addressLine1!= '')?addEGC.addressLine1:'');                    
                addressInfo.address = addressInfo.address + ((addEGC.addressLine2!= Null && addEGC.addressLine2!= '')?', '+addEGC.addressLine2:'');
                addressInfo.address = addressInfo.address + ((addEGC.addressLine3!= Null && addEGC.addressLine3!= '')?', '+addEGC.addressLine3:'');
                addressInfo.address = addressInfo.address + ((addEGC.addressCity!= Null && addEGC.addressCity!= '')?', '+addEGC.addressCity:'');
                addressInfo.address = addressInfo.address + ((addEGC.addressStateCode!= Null && addEGC.addressStateCode!= '')?', '+addEGC.addressStateCode:'');            
                addressInfo.address = addressInfo.address + ((addEGC.addressPostalCode!= Null && addEGC.addressPostalCode!= '')?', '+addEGC.addressPostalCode:'');
                addressInfo.address = addressInfo.address.removeStart(',');
                addressInfo.effectiveDate = (addEGC.effectiveDate != null && addEGC.effectiveDate != '')?Date.valueOf(addEGC.effectiveDate).format():'';
                addressInfo.expirationDate = (addEGC.expirationDate != null && addEGC.expirationDate != '')?Date.valueOf(addEGC.expirationDate).format():'';   
                system.debug(addressInfo.addrType);
                if(addressInfo.addrType=='CORP')
                    addressInfo.addrType = 'Corporate';
                else if(addressInfo.addrType=='PHY')
                    addressInfo.addrType = 'Physical';           
                oACETGroupDetail.groupAddressInfoList.add(addressInfo);
                
                
                String memExpDate = addEGC.expirationDate.split('-')[0] + addEGC.expirationDate.split('-')[1] + addEGC.expirationDate.split('-')[2];
                String curr = string.valueOf(Date.today());
                curr = curr.split('-')[0] + curr.split('-')[1] + curr.split('-')[2];
                if(memExpDate < curr){
                    oACETGroupDetail.groupAddressInfoPastList.add(addressInfo);
                } else {
                    oACETGroupDetail.groupAddressInfoCurrFutureList.add(addressInfo);
                }
                
            }
        }
    }*/
    
    
    /*private void groupContactInfoMapping(ACETGetEmployerGroupAdapterJSON2Apex.EmployerGroup EGDetails)
    {
        if (EGDetails != null )
        {
            ACETGroupDetail.groupContactInfo employeeGrpInfo = new ACETGroupDetail.groupContactInfo();
            ACETGroupDetail.groupContactInfo adminInfo = new ACETGroupDetail.groupContactInfo();
            ACETGroupDetail.groupContactInfo contactInfo = new ACETGroupDetail.groupContactInfo(); //US966071 
            list<ACETGroupDetail.contactPhoneInfo> contactPhoneList;
            ACETGroupDetail.contactPhoneInfo contactPhoneInfo;
            ACETGroupDetail.addressInfo contactAddressInfo;
            
            ACETGroupDetail.groupContactInfo groupContactInfo = new ACETGroupDetail.groupContactInfo();
            oACETGroupDetail.groupExternalContactInfoFullList = new list<ACETGroupDetail.groupContactInfo>();  //US966071 
            oACETGroupDetail.groupExternalContactInfoList = new list<ACETGroupDetail.groupContactInfo>();
            oACETGroupDetail.groupExternalContactInfoHistoryList = new list<ACETGroupDetail.groupContactInfo>();
            oACETGroupDetail.groupInternalContactInfoList = new list<ACETGroupDetail.groupContactInfo>();
            
            if(EGDetails.groupContact != null)
            {  
                for(ACETGetEmployerGroupAdapterJSON2Apex.GroupContact contactData:EGDetails.groupContact)
                {
                    
                    if(contactData != Null )
                    {
                        
                        adminInfo = new ACETGroupDetail.groupContactInfo();
                        adminInfo.contactPhones = new list<ACETGroupDetail.contactPhoneInfo>();
                        adminInfo.contactAddress = new list<ACETGroupDetail.AddressInfo>();
                        adminInfo.contactEmails = new list<String>();
                        
                        
                        adminInfo.primaryContactType = (contactData.roleDescription != Null)?contactData.roleDescription:adminInfo.primaryContactType ;
                        // US2909463 START
                        if(contactData.endDate != null){
                            Date eDate = Date.valueOf(contactData.endDate);
                            contactData.endDate = eDate.month() + '/' + eDate.day() + '/' + eDate.year();
                        }else{
                            contactData.endDate= '12/31/9999';
                        }
                        // US2909463 END
                        adminInfo.firstName = (contactData.firstName != Null)?contactData.firstName:adminInfo.firstName;
                        adminInfo.LastName = (contactData.lastName != Null)?contactData.lastName:adminInfo.LastName;
                        adminInfo.middleName = (contactData.middleName != Null)?contactData.middleName:adminInfo.middleName;
                        
                        adminInfo.startDate = (contactData.assignmentStartDate != Null)?String.valueof(Date.valueOf(contactData.assignmentStartDate).format()):adminInfo.startDate;
                        adminInfo.endDate = (contactData.endDate != Null)?contactData.endDate:adminInfo.endDate; //      US2909463
                        adminInfo.Organization = ( contactData.organizationName != Null)?contactData.organizationName:'';//getemp V3 starts
                        adminInfo.address = '';
                        
                        
                        if(contactData.primaryIndicatorDescription == 'Yes'  || contactData.primaryIndicatorDescription == 'Primary')
                        {
                            adminInfo.contactType = 'Primary';
                        }else
                        {
                            adminInfo.contactType = 'Additional';
                        }
                        
                        
                        if(contactData.phone != Null && !contactData.phone.isEmpty())
                        {
                            for(ACETGetEmployerGroupAdapterJSON2Apex.Phone phoneInfo:contactData.phone)
                            {
                                contactPhoneInfo = new ACETGroupDetail.contactPhoneInfo();
                                contactPhoneInfo.phoneNumber = (phoneInfo != Null && phoneInfo.telephoneNumber != Null)?phoneInfo.telephoneNumber:contactPhoneInfo.phoneNumber ;
                                contactPhoneInfo.phoneExt = (phoneInfo != Null && phoneInfo.phoneExtension != Null)?phoneInfo.phoneExtension:contactPhoneInfo.phoneExt ;
                                contactPhoneInfo.phoneType = (phoneInfo != Null && phoneInfo.phoneType != Null)?phoneInfo.phoneType:contactPhoneInfo.phoneType;
                                //getemp V3 starts
                                if(phoneInfo.phoneType == '6' && phoneInfo.telephoneNumber != null){
                                    adminInfo.fax = phoneInfo.telephoneNumber;
                                } else if(phoneInfo.telephoneNumber != null && (adminInfo.phone == null || adminInfo.phone == '') 
                                          && (phoneInfo.phoneType == '2' || phoneInfo.phoneType == '8')){
                                              adminInfo.phone = phoneInfo.telephoneNumber;
                                              adminInfo.extension = (phoneInfo != null && phoneInfo.phoneExtension != null)?phoneInfo.phoneExtension:adminInfo.extension;
                                          }
                                if(contactPhoneInfo != Null)
                                    adminInfo.contactPhones.add(contactPhoneInfo);
                            }
                            //if(adminInfo.contactPhones != Null)
                            //adminInfo.Phone = adminInfo.contactPhones[0].phoneNumber ;
                            //getemp V3 ends
                        } 
                        
                        if(contactData.email != Null && !contactData.email.isEmpty())
                        {
                            for(ACETGetEmployerGroupAdapterJSON2Apex.Email emailInfo:contactData.email)
                            {
                                if(emailInfo.electronicAddress != Null)
                                    adminInfo.contactEmails.add(emailInfo.electronicAddress);
                            }
                            if(adminInfo.contactEmails != Null)
                                adminInfo.EmailAddress = adminInfo.contactEmails[0];
                            
                        }
                        //US966071 changes start
                        if(adminInfo.primaryContactType == 'Benefit Administrator' && (contactData.primaryIndicatorDescription == 'Yes' || contactData.primaryIndicatorDescription == 'Primary' ))
                        {
                            firstName  = adminInfo.firstName ;
                            middleName  = adminInfo.middleName ;
                            lastName  = adminInfo.lastName ;
                            
                        }
                        //US966071 Changes End
                        
                        if(contactData.address != Null)
                        {
                            
                            for(ACETGetEmployerGroupAdapterJSON2Apex.Address addrInfo:contactData.address )
                            {
                                addrType ='';
                                addrType= (addrInfo.addressTypeDescription != null)?addrInfo.addressTypeDescription:'';
                                
                                if(addrType == 'Physical Address')
                                {
                                    system.debug('$$$inside physical address');
                                    adminInfo.address = '';
                                    adminInfo.address = adminInfo.address + ((addrInfo.addressLine1 != Null && addrInfo.addressLine1 != '')?addrInfo.addressLine1:'');
                                    adminInfo.address = adminInfo.address + ((addrInfo.addressLine2 != Null && addrInfo.addressLine2 != '')?','+addrInfo.addressLine2:'');
                                    adminInfo.address = adminInfo.address + ((addrInfo.addressLine3 != Null && addrInfo.addressLine3 != '')?','+addrInfo.addressLine3:'');
                                    adminInfo.address = adminInfo.address + ((addrInfo.addressCity != Null && addrInfo.addressCity != '')?','+addrInfo.addressCity:'');
                                    adminInfo.address = adminInfo.address + ((addrInfo.addressStateCode != Null && addrInfo.addressStateCode != '')?','+addrInfo.addressStateCode:'');
                                    adminInfo.address = adminInfo.address + ((addrInfo.addressPostalCode != Null && addrInfo.addressPostalCode != '')?','+addrInfo.addressPostalCode:'');
                                    adminInfo.addressType = (addrInfo.addressTypeDescription != null)?addrInfo.addressTypeDescription:'';
                                    if(adminInfo.primaryContactType != 'Billing Contact')
                                        break;
                                }
                                else if(addrType == 'Billing')
                                {
                                    system.debug('$$$inside billing address');
                                    adminInfo.address = '';
                                    adminInfo.address = adminInfo.address + ((addrInfo.addressLine1 != Null && addrInfo.addressLine1 != '')?addrInfo.addressLine1:'');
                                    adminInfo.address = adminInfo.address + ((addrInfo.addressLine2 != Null && addrInfo.addressLine2 != '')?','+addrInfo.addressLine2:'');
                                    adminInfo.address = adminInfo.address + ((addrInfo.addressLine3 != Null && addrInfo.addressLine3 != '')?','+addrInfo.addressLine3:'');
                                    adminInfo.address = adminInfo.address + ((addrInfo.addressCity != Null && addrInfo.addressCity != '')?','+addrInfo.addressCity:'');
                                    adminInfo.address = adminInfo.address + ((addrInfo.addressStateCode != Null && addrInfo.addressStateCode != '')?','+addrInfo.addressStateCode:'');
                                    adminInfo.address = adminInfo.address + ((addrInfo.addressPostalCode != Null && addrInfo.addressPostalCode != '')?','+addrInfo.addressPostalCode:'');
                                    adminInfo.addressType = (addrInfo.addressTypeDescription != null)?addrInfo.addressTypeDescription:'';
                                    if(adminInfo.primaryContactType == 'Billing Contact')
                                        break;
                                    
                                }
                            }
                            system.debug('$$$Address'+adminInfo.address );
                        }
                        System.debug('--------------------------------------------------');
                        if(contactData.assignmentEndDate != Null && contactData.assignmentStartDate != Null && date.today().daysBetween(Date.valueOf(contactData.assignmentEndDate)) >= 0 &&  (Date.valueOf(contactData.assignmentStartDate).daysBetween(date.today()) >= 0 || date.today().daysBetween(Date.valueOf(contactData.assignmentStartDate)) >= 0))
                        {
                            adminInfo.activeStatus = 'Y'; 
                            adminInfo.startDate = Date.valueOf(contactData.assignmentStartDate).format();
                            adminInfo.endDate =  contactData.endDate; //               US2909463
                            //getemp V3 starts
                            if(adminInfo.firstName != null && adminInfo.lastName != null){
                                adminInfo.fullName = adminInfo.firstName + ' ' + adminInfo.lastName ;
                            } else {
                                adminInfo.fullName = ( contactData.organizationName != Null)?contactData.organizationName:'';
                            }
                            //getemp V3 ends
                            oACETGroupDetail.groupExternalContactInfoFullList.add(adminInfo);                   
                        }else
                        {
                            if(contactData.assignmentEndDate != Null && contactData.assignmentStartDate != Null ){
                                adminInfo.activeStatus = 'N'; 
                                adminInfo.startDate = Date.valueOf(contactData.assignmentStartDate).format();
                                adminInfo.endDate = contactData.endDate; //              US2909463
                                oACETGroupDetail.groupExternalContactInfoHistoryList.add(adminInfo);
                            } else if (contactData.assignmentEndDate == Null && contactData.assignmentStartDate == Null) {
                                adminInfo.startDate = '';
                                adminInfo.endDate = '';
                                oACETGroupDetail.groupExternalContactInfoFullList.add(adminInfo);
                            }                 
                        }
                        
                    }
                }
                oACETGroupDetail.groupExternalContactInfoList = oACETGroupDetail.groupExternalContactInfoFullList;
                
                
            }
            
            
            if(EGDetails.groupSupportTeamContact != null){
                for(ACETGetEmployerGroupAdapterJSON2Apex.GroupSupportTeamContact contactData:EGDetails.groupSupportTeamContact)
                {
                    //US1024400          
                    if (contactData != Null){
                        if(contactData.roleDescription =='Language Team'){
                            oACETGroupDetail.genGroupInfo.asianInitIndicator = 'Yes';
                        }
                    }
                    if(contactData != Null)
                    {
                        
                        employeeGrpInfo = new ACETGroupDetail.groupContactInfo();
                        employeeGrpInfo.contactPhones = new list<ACETGroupDetail.contactPhoneInfo>();
                        employeeGrpInfo.contactEmails = new list<String>();
                        // ACETGroupDetail.contactPhoneInfo contactPhoneInfo;
                        employeeGrpInfo.primaryContactType = contactData.roleDescription;
                        
                        employeeGrpInfo.firstName = ( contactData.firstName != Null)?contactData.firstName:employeeGrpInfo.firstName;
                        employeeGrpInfo.LastName = ( contactData.lastName != Null)?contactData.lastName:employeeGrpInfo.LastName;
                        employeeGrpInfo.middleName = ( contactData.middleName != Null)?contactData.middleName:employeeGrpInfo.middleName;
                        
                        employeeGrpInfo.startDate = (contactData.startDate != Null)?String.valueof(Date.valueOf(contactData.startDate).format()):employeeGrpInfo.startDate;
                        employeeGrpInfo.endDate = (contactData.endDate != Null)?String.valueof(Date.valueOf(contactData.endDate).format()):employeeGrpInfo.endDate;
                        employeeGrpInfo.Organization = ( contactData.serviceTeam != Null)?contactData.serviceTeam:employeeGrpInfo.Organization;
                        if(contactData.phone != Null && !contactData.phone.isEmpty())
                        {
                            for(ACETGetEmployerGroupAdapterJSON2Apex.Phone phoneInfo:contactData.phone)
                            {
                                contactPhoneInfo = new ACETGroupDetail.contactPhoneInfo();
                                contactPhoneInfo.phoneType = (phoneInfo != Null && phoneInfo.phoneType != Null)?phoneInfo.phoneType:contactPhoneInfo.phoneType;
                                contactPhoneInfo.phoneNumber = (phoneInfo != Null && phoneInfo.telephoneNumber != Null)?phoneInfo.telephoneNumber:contactPhoneInfo.phoneNumber ;
                                contactPhoneInfo.phoneExt = (phoneInfo != Null && phoneInfo.phoneExtension!= Null)?phoneInfo.phoneExtension:contactPhoneInfo.phoneExt;
                                if(contactPhoneInfo != Null)
                                    employeeGrpInfo.contactPhones.add(contactPhoneInfo);
                                //getemp V3 starts
                                if(phoneInfo.telephoneNumber != null && (employeeGrpInfo.Phone == null || employeeGrpInfo.Phone == '') && (employeeGrpInfo.extension == null || employeeGrpInfo.extension == '')  
                                   && (phoneInfo.phoneType == '8' ||phoneInfo.phoneType == '2' || phoneInfo.phoneType == '3')){
                                       employeeGrpInfo.Phone = phoneInfo.telephoneNumber;
                                       employeeGrpInfo.extension = phoneInfo.phoneExtension;
                                   }
                            }
                            
                            //getemp V3 ends
                        }
                        
                        if(contactData.email != Null && !contactData.email.isEmpty())
                        {
                            for(ACETGetEmployerGroupAdapterJSON2Apex.Email emailInfo:contactData.email)
                            {
                                if(emailInfo.electronicAddress != Null)
                                    employeeGrpInfo.contactEmails.add(emailInfo.electronicAddress);
                            }
                            if(employeeGrpInfo.contactEmails != Null)
                                employeeGrpInfo.EmailAddress = employeeGrpInfo.contactEmails[0];
                        }
                        
                        if(contactData.endDate != Null && contactData.startDate != Null && date.today().daysBetween(Date.valueOf(contactData.endDate)) > 0 &&  (Date.valueOf(contactData.startDate).daysBetween(date.today()) > 0 || date.today().daysBetween(Date.valueOf(contactData.startDate)) > 0))
                        {
                            oACETGroupDetail.groupInternalContactInfoList.add(employeeGrpInfo);
                        }            
                    }
                }
            }            
        }                 
    }*/
    //Please don't remove this code. It is using in group plan controller - divya    
    public ACETWSCalloutResult getEmployerGroupDetail(string groupNumber){
        ACETWSCalloutResult oACETWSCalloutResult = new ACETWSCalloutResult();
        try{
        ACETGroupDetail oACETGroupDetail;
        
            ACET_WebserviceCalloutFramework wsCallOutFW = new ACET_WebserviceCalloutFramework();
            wsCallOutFW.serviceName = 'Get Employer Group API';
            wsCallOutFW.requestBody = getRequestBody(groupNumber); 
            wsCallOutFW.encodeURLParameters = true;
        if(Test.isRunningTest()){
            wsCallOutFW = new ACET_WebserviceCalloutFramework();
        }
            HttpResponse Response;
        if(Test.isRunningTest() && !ACETViewEmployerGroupControllerTest.failureScenario){
            Response = new HTTPResponse();
            Response.setBody('{"getEmployerGroupResponse":{"employerGroup":{"groupNumber":"1004278","groupName":"Acet_test_four_20210312014927","sourceSysCode":"CIRRUS","organizationTypeCode":"1","organizationTypeDescription":"Corporation","taxIdentificationNumber":["424660716"],"sizeDefinitionCode":"01","sizeDefinitionDescription":"Small Group","groupClassification":"Group","enrollmentType":"EDI and Paper","migrationSourceSystem":[{"id":"031201492","name":"PUL"}],"riskManagementIndicator":"false","erisaIndicator":"true","groupLevelHoldIndicator":"true","groupLevelHold":[{"groupHoldCode":"FULFIL","groupHoldShortDescription":"Hold Fulfillment","groupHoldEffectiveDates":"2021-03-12","groupHoldExpirationDates":"9999-12-31"},{"groupHoldCode":"WELKIT","groupHoldShortDescription":"Welcome Kit","groupHoldEffectiveDates":"2021-03-12","groupHoldExpirationDates":"9999-12-31"}],"groupSettings":[{"cobAttestationFrequency":"0","cobAttestationDenyGracePeriod":"0","religiousExemptionTypeDescription":"Not a Religious Exempt Group","effectiveDate":"2020-01-01","expirationDate":"9999-12-31"}],"groupAddress":[{"addressTypeCode":"PHY","addressTypeDescription":"Physical Address","addressLine1":"460 Natalya Road","addressLine2":"Suite 613","addressCity":"HARTFORD","addressPostalCode":"06103","addressStateCode":"CT","addressCountryCode":"US","addressCountryDescription":"United States of America","salesOfficeCode":"339","salesOfficeDescription":"Hartford/oth","effectiveDate":"2020-01-01","expirationDate":"9999-12-31"}],"groupContact":[{"roleType":"2","roleDescription":"Billing Contact","primaryIndicatorCode":"true","primaryIndicatorDescription":"Primary","firstName":"Mallory","lastName":"Berry","startDate":"2020-01-01","endDate":"9999-12-31","assignmentStartDate":"2020-01-01","assignmentEndDate":"9999-12-31","phone":[{"phoneType":"8","telephoneNumber":"732-769-2603","phoneTypeDescription":"Other"}],"email":[{"communicationTypeCode":"EML","electronicAddress":"Mallory.Berry@optum.com"}],"address":[{"addressTypeCode":"PHY","addressTypeDescription":"Physical Address","addressLine1":"587 Margene Road","addressLine2":"Suite 613","addressCity":"HARTFORD","addressPostalCode":"06103","addressStateCode":"CT","addressCountryCode":"US","addressCountryDescription":"United States of America"}]},{"roleType":"1","roleDescription":"Benefit Administrator","primaryIndicatorCode":"true","primaryIndicatorDescription":"Primary","firstName":"Dixie","lastName":"Kelley","startDate":"2020-01-01","endDate":"9999-12-31","assignmentStartDate":"2020-01-01","assignmentEndDate":"9999-12-31","phone":[{"phoneType":"8","telephoneNumber":"732-769-2603","phoneTypeDescription":"Other"}],"email":[{"communicationTypeCode":"EML","electronicAddress":"Dixie.Kelley@optum.com"}],"address":[{"addressTypeCode":"PHY","addressTypeDescription":"Physical Address","addressLine1":"460 Natalya Road","addressLine2":"Suite 613","addressCity":"HARTFORD","addressPostalCode":"06103","addressStateCode":"CT","addressCountryCode":"US","addressCountryDescription":"United States of America"}]},{"roleType":"8","roleDescription":"SBC Contact","primaryIndicatorCode":"true","primaryIndicatorDescription":"Primary","firstName":"Leonie","lastName":"Harper","startDate":"2020-01-01","endDate":"9999-12-31","assignmentStartDate":"2020-01-01","assignmentEndDate":"9999-12-31","phone":[{"phoneType":"8","telephoneNumber":"732-769-2603","phoneTypeDescription":"Other"}],"email":[{"communicationTypeCode":"EML","electronicAddress":"Leonie.Harper@optum.com"}],"address":[{"addressTypeCode":"PHY","addressTypeDescription":"Physical Address","addressLine1":"932 Mandie Road","addressLine2":"Suite 613","addressCity":"HARTFORD","addressPostalCode":"06103","addressStateCode":"CT","addressCountryCode":"US","addressCountryDescription":"United States of America"}]}],"groupInsuringRules":[{"cobraAdministrativeIndicator":"0","continuationResponsibilityType":"Member Group","insuranceContinuationType":"COBRA","onshoreRestriction":"All Services Offshore","insuringRulesEffectiveDates":"2020-01-01","insuringRulesExpirationDates":"9999-12-31","pcpRadomization":"01","survivingSpouseIndicator":"true","newBornAutoAddIndicator":"true","countNewbornForCoverageLevelCodeIndicator":"true"},{"classesCode":"POP_1","cobraAdministrativeIndicator":"0","earlyRetirementIndicator":"false","earlyRetirementMinimumAge":"0","workingRetirementIndicator":"false","workingRetirementMinimumAge":"0","insuringRulesEffectiveDates":"2020-01-01","insuringRulesExpirationDates":"9999-12-31","pcpRadomization":"01","survivingSpouseIndicator":"true","newBornAutoAddIndicator":"true","countNewbornForCoverageLevelCodeIndicator":"true"},{"classesCode":"POP_2","cobraAdministrativeIndicator":"0","earlyRetirementIndicator":"false","earlyRetirementMinimumAge":"0","workingRetirementIndicator":"false","workingRetirementMinimumAge":"0","insuringRulesEffectiveDates":"2020-01-01","insuringRulesExpirationDates":"9999-12-31","pcpRadomization":"01","survivingSpouseIndicator":"true","newBornAutoAddIndicator":"true","countNewbornForCoverageLevelCodeIndicator":"true"}],"groupPopulation":[{"classesCode":"POP_1","classesDescription":"POP_1"},{"classesCode":"POP_2","classesDescription":"POP_2"}],"customerAccount":[{"originalContractDate":"2020-01-01","migrationIndicator":"false","customerAccountOption":[{"customerAccountOptionId":"29196595","customerAccountOptionDescription":"ContractOptDescription-Medical-20210312014927","customerAccountOptionType":"12 Months","statusCode":"A","statusDescription":"Active","exchangeTypeDescription":"Non-Exchange","startDate":"2020-01-01","renewalDate":"2021-01-01","terminationDate":"2020-12-31","stateOfIssueCode":"CT","stateOfIssueDescription":"CONNECTICUT","openEnrollmentStartDate":"2020-01-01","openEnrollmentEndDate":"2020-02-01","enrollmentInsuringRulesPopulationIndicator":"true","defineOpenEnrollmentbyPopulationIndicator":"true","customerAccountGroupPopulation":[{"classesCode":"POP_1","classesDescription":"POP_1","populationOpenEnrollmentStartDate":"2020-01-01","populationOpenEnrollmentEndDate":"2020-02-01"}],"customerAccountInsuringRules":[{"dependentCutOff":"26","dependentCutOffType":"Date of Event","studentMaximumAge":"26","studentmaximumAgeType":"Date of Event","waiveRehiredIndefiniteIndicator":"true","waiveWaitingPeriodForNewHireIndicator":"true","waiveRehiredWithinCount":"1","waiveRehiredWithinType":"M","terminationLagType":"001","terminationLagDescription":"Date of Event","overrideRetroBenefitAddIndicator":"false","overrideRetroBenefitChangeIndicator":"false","overrideRetroBenefitTerminationIndicator":"false","insuringRuleEffectiveDates":"2020-01-01","insuringRuleExpirationDates":"2020-12-31","nonStandardWaitingPeriodIndicator":"false","waitingPeriodRules":[{"waitingPeriodType":"Specified Duration","waitingDurationType":"Months","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"Specified Duration","waitingDurationType":"Months","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"Specified Duration","waitingDurationType":"Days","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"First of the Following Month after Specified Duration","waitingDurationType":"Days","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"First of the Following Month after Specified Duration","waitingDurationType":"Months","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"First of the Following Month after Specified Duration","waitingDurationType":"Months","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"Specified Duration","waitingDurationType":"Days","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"Specified Duration","waitingDurationType":"Days","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Plan Change"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Re-enrollment"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Rehire"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Special Enrollment"},{"waitingPeriodType":"Specified Duration","waitingDurationType":"Days","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Adoption"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Benefit Selection"},{"waitingPeriodType":"First of the Following Month after Specified Duration","waitingDurationType":"Days","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Birth"},{"waitingPeriodType":"First of the Following Month","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"First of the Following Month after Specified Duration","waitingDurationType":"Days","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Consolidation Omnibus Budget Reconciliation Act (COBRA)"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Late Enrollee"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Marriage"}]}],"customerPurchase":[{"memberGroupContractPlanOptionID":"PO100001","planOptionDescription":"Plan Option 3501010","fundingArrangementCode":"01","fundingArrangementDescription":"Fully Insured","coverageStartDate":"2020-01-01","coverageExpirationDate":"2020-12-31","benefitBundleOptionID":"3501010","timePeriodQualifier":"Calender Year","benefitBasePlan":"M000000745","benefitPlanDescription":"CT S FRDM NG 30/60/2500/100 PPO HSA 20","gatedProductIndicator":"0","hsaVendorId":"0","networkScheduleId":["FREEDOM_CHOICEPLUS"],"domesticPartnerIndicator":"false","benefitServiceArea":"OXFORD_TRI_STATE","lineOfBusiness":[{"name":"Small Business","description":"Small Business  (UHC definition = 2 to 50, and Sole Prop)"}],"lineOfBusinessId":"2","carrierId":"5","carrierName":"Oxford Health Insurance, Inc.","bookOfBusinessTypeCode":"OX","bookOfBusinessTypeDescription":"Oxford FI/ASO","brandingEntityName":"UNITEDHEALTHCARE_OXFORD","brandingEntityDescription":"UnitedHealthcare Oxford","contractOptionType":"MD","contractOptionTypeDescription":"Medical","benefitType":"MD"}]},{"customerAccountOptionId":"29196596","customerAccountOptionDescription":"ContractOptDescription-Medical-20210312014927","customerAccountOptionType":"12 Months","statusCode":"A","statusDescription":"Active","exchangeTypeDescription":"Non-Exchange","startDate":"2021-01-01","renewalDate":"2022-01-01","terminationDate":"2021-12-31","stateOfIssueCode":"CT","stateOfIssueDescription":"CONNECTICUT","openEnrollmentStartDate":"2021-01-01","openEnrollmentEndDate":"2021-02-01","enrollmentInsuringRulesPopulationIndicator":"true","defineOpenEnrollmentbyPopulationIndicator":"true","customerAccountGroupPopulation":[{"classesCode":"POP_2","classesDescription":"POP_2","populationOpenEnrollmentStartDate":"2021-01-01","populationOpenEnrollmentEndDate":"2021-02-01"}],"customerAccountInsuringRules":[{"dependentCutOff":"26","dependentCutOffType":"Date of Event","studentMaximumAge":"26","studentmaximumAgeType":"Date of Event","waiveRehiredIndefiniteIndicator":"true","waiveWaitingPeriodForNewHireIndicator":"true","waiveRehiredWithinCount":"1","waiveRehiredWithinType":"M","terminationLagType":"001","terminationLagDescription":"Date of Event","overrideRetroBenefitAddIndicator":"false","overrideRetroBenefitChangeIndicator":"false","overrideRetroBenefitTerminationIndicator":"false","insuringRuleEffectiveDates":"2021-01-01","insuringRuleExpirationDates":"2021-12-31","nonStandardWaitingPeriodIndicator":"false","waitingPeriodRules":[{"waitingPeriodType":"Specified Duration","waitingDurationType":"Months","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"Specified Duration","waitingDurationType":"Months","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"Specified Duration","waitingDurationType":"Days","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"First of the Following Month after Specified Duration","waitingDurationType":"Days","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"First of the Following Month after Specified Duration","waitingDurationType":"Months","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"First of the Following Month after Specified Duration","waitingDurationType":"Months","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"Specified Duration","waitingDurationType":"Days","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"Specified Duration","waitingDurationType":"Days","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Plan Change"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Re-enrollment"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Rehire"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Special Enrollment"},{"waitingPeriodType":"Specified Duration","waitingDurationType":"Days","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Adoption"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Benefit Selection"},{"waitingPeriodType":"First of the Following Month after Specified Duration","waitingDurationType":"Days","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Birth"},{"waitingPeriodType":"First of the Following Month","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"First of the Following Month after Specified Duration","waitingDurationType":"Days","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Consolidation Omnibus Budget Reconciliation Act (COBRA)"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Late Enrollee"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Marriage"}]},{"classesCode":"POP_2","classesDescription":"POP_2","dependentCutOff":"26","dependentCutOffType":"Date of Event","studentMaximumAge":"26","studentmaximumAgeType":"Date of Event","waiveRehiredIndefiniteIndicator":"true","waiveWaitingPeriodForNewHireIndicator":"true","waiveRehiredWithinCount":"1","waiveRehiredWithinType":"M","terminationLagType":"001","terminationLagDescription":"Date of Event","overrideRetroBenefitAddIndicator":"false","overrideRetroBenefitChangeIndicator":"false","overrideRetroBenefitTerminationIndicator":"false","insuringRuleEffectiveDates":"2021-01-01","insuringRuleExpirationDates":"2021-12-31","nonStandardWaitingPeriodIndicator":"false","waitingPeriodRules":[{"waitingPeriodType":"Specified Duration","waitingDurationType":"Months","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"Specified Duration","waitingDurationType":"Months","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"Specified Duration","waitingDurationType":"Days","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"First of the Following Month after Specified Duration","waitingDurationType":"Days","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"First of the Following Month after Specified Duration","waitingDurationType":"Months","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"First of the Following Month after Specified Duration","waitingDurationType":"Months","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"Specified Duration","waitingDurationType":"Days","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"Specified Duration","waitingDurationType":"Days","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Plan Change"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Re-enrollment"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Rehire"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Special Enrollment"},{"waitingPeriodType":"Specified Duration","waitingDurationType":"Days","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Adoption"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Benefit Selection"},{"waitingPeriodType":"First of the Following Month after Specified Duration","waitingDurationType":"Days","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Birth"},{"waitingPeriodType":"First of the Following Month","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"First of the Following Month after Specified Duration","waitingDurationType":"Days","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Consolidation Omnibus Budget Reconciliation Act (COBRA)"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Late Enrollee"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Marriage"}]}],"customerPurchase":[{"memberGroupContractPlanOptionID":"PO100002","planOptionDescription":"Plan Option 1018484","fundingArrangementCode":"01","fundingArrangementDescription":"Fully Insured","coverageStartDate":"2021-01-01","coverageExpirationDate":"2021-12-31","benefitBundleOptionID":"3622803","timePeriodQualifier":"Calender Year","benefitBasePlan":"M000000782","benefitPlanDescription":"CT S FRDM NG 30/75/4750/75 PPO 21","gatedProductIndicator":"0","hsaVendorId":"0","networkScheduleId":["FREEDOM_CHOICEPLUS"],"domesticPartnerIndicator":"false","benefitServiceArea":"OXFORD_TRI_STATE","lineOfBusiness":[{"name":"Small Business","description":"Small Business  (UHC definition = 2 to 50, and Sole Prop)"}],"lineOfBusinessId":"2","carrierId":"5","carrierName":"Oxford Health Insurance, Inc.","bookOfBusinessTypeCode":"OX","bookOfBusinessTypeDescription":"Oxford FI/ASO","brandingEntityName":"UNITEDHEALTHCARE_OXFORD","brandingEntityDescription":"UnitedHealthcare Oxford","contractOptionType":"MD","contractOptionTypeDescription":"Medical","benefitType":"MD"}]},{"customerAccountOptionId":"29196597","customerAccountOptionDescription":"ContractOptDescription-Dental-20210312014927","customerAccountOptionType":"12 Months","statusCode":"A","statusDescription":"Active","exchangeTypeDescription":"Non-Exchange","startDate":"2020-01-01","renewalDate":"2021-01-01","terminationDate":"2020-12-31","stateOfIssueCode":"CT","stateOfIssueDescription":"CONNECTICUT","enrollmentInsuringRulesPopulationIndicator":"false","defineOpenEnrollmentbyPopulationIndicator":"true","customerAccountGroupPopulation":[{}],"customerAccountInsuringRules":[{"dependentCutOff":"26","dependentCutOffType":"Date of Event","studentMaximumAge":"26","studentmaximumAgeType":"Date of Event","waiveRehiredIndefiniteIndicator":"true","waiveWaitingPeriodForNewHireIndicator":"true","waiveRehiredWithinCount":"1","waiveRehiredWithinType":"M","terminationLagType":"001","terminationLagDescription":"Date of Event","overrideRetroBenefitAddIndicator":"false","overrideRetroBenefitChangeIndicator":"false","overrideRetroBenefitTerminationIndicator":"false","insuringRuleEffectiveDates":"2020-01-01","insuringRuleExpirationDates":"2020-12-31","nonStandardWaitingPeriodIndicator":"false","waitingPeriodRules":[{"waitingPeriodType":"Specified Duration","waitingDurationType":"Months","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"Specified Duration","waitingDurationType":"Months","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"Specified Duration","waitingDurationType":"Days","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"First of the Following Month after Specified Duration","waitingDurationType":"Days","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"First of the Following Month after Specified Duration","waitingDurationType":"Months","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"First of the Following Month after Specified Duration","waitingDurationType":"Months","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"Specified Duration","waitingDurationType":"Days","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"Specified Duration","waitingDurationType":"Days","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Plan Change"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Re-enrollment"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Rehire"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Special Enrollment"},{"waitingPeriodType":"Specified Duration","waitingDurationType":"Days","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Adoption"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Benefit Selection"},{"waitingPeriodType":"First of the Following Month after Specified Duration","waitingDurationType":"Days","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Birth"},{"waitingPeriodType":"First of the Following Month","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"First of the Following Month after Specified Duration","waitingDurationType":"Days","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Consolidation Omnibus Budget Reconciliation Act (COBRA)"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Late Enrollee"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Marriage"}]}],"customerPurchase":[{"memberGroupContractPlanOptionID":"DN100002","planOptionDescription":"Plan_dental_2020","fundingArrangementCode":"01","fundingArrangementDescription":"Fully Insured","coverageStartDate":"2020-01-01","coverageExpirationDate":"2020-12-31","benefitBundleOptionID":"10262975","timePeriodQualifier":"Calender Year","benefitBasePlan":"I0690","benefitPlanDescription":"I0690_Indemnity_VWU.85","gatedProductIndicator":"0","hsaVendorId":"0","networkScheduleId":[null],"domesticPartnerIndicator":"false","benefitServiceArea":"UNITED_STATES","lineOfBusinessId":"2","carrierId":"36","bookOfBusinessTypeCode":"UH","bookOfBusinessTypeDescription":"UnitedHealthcare Insurance Company","contractOptionType":"DN","contractOptionTypeDescription":"Dental","benefitType":"DN","billingSchedule":[{"billingScheduleID":"BILLINGSCHEDULE_1003629_25134723","scheduleEffectiveDate":"2020-01-01","scheduleExpirationDate":"2020-12-31","ratingMethodology":"02","contractTypeCode":"4","contractTypeDescription":"F","amount":"20.20","flatRateAmt":"0.00","billItemType":"PREMIUM"},{"billingScheduleID":"BILLINGSCHEDULE_1003629_25134723","scheduleEffectiveDate":"2020-01-01","scheduleExpirationDate":"2020-12-31","ratingMethodology":"02","contractTypeCode":"3","contractTypeDescription":"PCH","amount":"20.20","flatRateAmt":"0.00","billItemType":"PREMIUM"},{"billingScheduleID":"BILLINGSCHEDULE_1003629_25134723","scheduleEffectiveDate":"2020-01-01","scheduleExpirationDate":"2020-12-31","ratingMethodology":"02","contractTypeCode":"2","contractTypeDescription":"C","amount":"20.20","flatRateAmt":"0.00","billItemType":"PREMIUM"},{"billingScheduleID":"BILLINGSCHEDULE_1003629_25134723","scheduleEffectiveDate":"2020-01-01","scheduleExpirationDate":"2020-12-31","ratingMethodology":"02","contractTypeCode":"1","contractTypeDescription":"S","amount":"20.20","flatRateAmt":"0.00","billItemType":"PREMIUM"},{"billingScheduleID":"BILLINGSCHEDULE_1003629_25134723","scheduleEffectiveDate":"2020-01-01","scheduleExpirationDate":"2020-12-31","ratingMethodology":"02","contractTypeCode":"4","contractTypeDescription":"F","amount":"20.20","flatRateAmt":"0.00","billItemType":"COB_PREM"},{"billingScheduleID":"BILLINGSCHEDULE_1003629_25134723","scheduleEffectiveDate":"2020-01-01","scheduleExpirationDate":"2020-12-31","ratingMethodology":"02","contractTypeCode":"3","contractTypeDescription":"PCH","amount":"20.20","flatRateAmt":"0.00","billItemType":"COB_PREM"},{"billingScheduleID":"BILLINGSCHEDULE_1003629_25134723","scheduleEffectiveDate":"2020-01-01","scheduleExpirationDate":"2020-12-31","ratingMethodology":"02","contractTypeCode":"2","contractTypeDescription":"C","amount":"20.20","flatRateAmt":"0.00","billItemType":"COB_PREM"},{"billingScheduleID":"BILLINGSCHEDULE_1003629_25134723","scheduleEffectiveDate":"2020-01-01","scheduleExpirationDate":"2020-12-31","ratingMethodology":"02","contractTypeCode":"1","contractTypeDescription":"S","amount":"20.20","flatRateAmt":"0.00","billItemType":"COB_PREM"}]}]},{"customerAccountOptionId":"29196598","customerAccountOptionDescription":"ContractOptDescription-Vision-20210312014927","customerAccountOptionType":"12 Months","statusCode":"A","statusDescription":"Active","exchangeTypeDescription":"Non-Exchange","startDate":"2020-01-01","renewalDate":"2021-01-01","terminationDate":"2020-12-31","stateOfIssueCode":"CT","stateOfIssueDescription":"CONNECTICUT","enrollmentInsuringRulesPopulationIndicator":"false","defineOpenEnrollmentbyPopulationIndicator":"true","customerAccountGroupPopulation":[{}],"customerAccountInsuringRules":[{"dependentCutOff":"26","dependentCutOffType":"Date of Event","studentMaximumAge":"26","studentmaximumAgeType":"Date of Event","waiveRehiredIndefiniteIndicator":"true","waiveWaitingPeriodForNewHireIndicator":"true","waiveRehiredWithinCount":"1","waiveRehiredWithinType":"M","terminationLagType":"001","terminationLagDescription":"Date of Event","overrideRetroBenefitAddIndicator":"false","overrideRetroBenefitChangeIndicator":"false","overrideRetroBenefitTerminationIndicator":"false","insuringRuleEffectiveDates":"2020-01-01","insuringRuleExpirationDates":"2020-12-31","nonStandardWaitingPeriodIndicator":"false","waitingPeriodRules":[{"waitingPeriodType":"Specified Duration","waitingDurationType":"Months","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"Specified Duration","waitingDurationType":"Months","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"Specified Duration","waitingDurationType":"Days","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"First of the Following Month after Specified Duration","waitingDurationType":"Days","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"First of the Following Month after Specified Duration","waitingDurationType":"Months","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"First of the Following Month after Specified Duration","waitingDurationType":"Months","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"Specified Duration","waitingDurationType":"Days","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"Specified Duration","waitingDurationType":"Days","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Plan Change"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Re-enrollment"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Rehire"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Special Enrollment"},{"waitingPeriodType":"Specified Duration","waitingDurationType":"Days","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Adoption"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Benefit Selection"},{"waitingPeriodType":"First of the Following Month after Specified Duration","waitingDurationType":"Days","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Birth"},{"waitingPeriodType":"First of the Following Month","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"First of the Following Month after Specified Duration","waitingDurationType":"Days","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Consolidation Omnibus Budget Reconciliation Act (COBRA)"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Late Enrollee"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Marriage"}]}],"customerPurchase":[{"memberGroupContractPlanOptionID":"VS100002","planOptionDescription":"Plan_11","fundingArrangementCode":"01","fundingArrangementDescription":"Fully Insured","coverageStartDate":"2020-01-01","coverageExpirationDate":"2020-12-31","benefitBundleOptionID":"10252860","timePeriodQualifier":"Calender Year","benefitBasePlan":"V1002","benefitPlanDescription":"V1002_100% ER Paid","gatedProductIndicator":"0","hsaVendorId":"0","networkScheduleId":[null],"domesticPartnerIndicator":"false","benefitServiceArea":"UNITED_STATES","lineOfBusinessId":"2","carrierId":"36","bookOfBusinessTypeCode":"UH","bookOfBusinessTypeDescription":"UnitedHealthcare Insurance Company","contractOptionType":"VS","contractOptionTypeDescription":"Vision","benefitType":"VS","billingSchedule":[{"billingScheduleID":"BILLINGSCHEDULE_1001130_VS100001","scheduleEffectiveDate":"2020-01-01","scheduleExpirationDate":"2020-12-31","ratingMethodology":"02","contractTypeCode":"2","contractTypeDescription":"C","amount":"10.00","flatRateAmt":"0.00","billItemType":"PREMIUM"},{"billingScheduleID":"BILLINGSCHEDULE_1001130_VS100001","scheduleEffectiveDate":"2020-01-01","scheduleExpirationDate":"2020-12-31","ratingMethodology":"02","contractTypeCode":"1","contractTypeDescription":"S","amount":"5.00","flatRateAmt":"0.00","billItemType":"PREMIUM"},{"billingScheduleID":"BILLINGSCHEDULE_1001130_VS100001","scheduleEffectiveDate":"2020-01-01","scheduleExpirationDate":"2020-12-31","ratingMethodology":"02","contractTypeCode":"4","contractTypeDescription":"F","amount":"20.23","flatRateAmt":"0.00","billItemType":"PREMIUM"},{"billingScheduleID":"BILLINGSCHEDULE_1001130_VS100001","scheduleEffectiveDate":"2020-01-01","scheduleExpirationDate":"2020-12-31","ratingMethodology":"02","contractTypeCode":"3","contractTypeDescription":"PCH","amount":"15.00","flatRateAmt":"0.00","billItemType":"PREMIUM"},{"billingScheduleID":"BILLINGSCHEDULE_1001130_VS100001","scheduleEffectiveDate":"2020-01-01","scheduleExpirationDate":"2020-12-31","ratingMethodology":"02","contractTypeCode":"2","contractTypeDescription":"C","amount":"10.00","flatRateAmt":"0.00","billItemType":"PREMIUM"},{"billingScheduleID":"BILLINGSCHEDULE_1001130_VS100001","scheduleEffectiveDate":"2020-01-01","scheduleExpirationDate":"2020-12-31","ratingMethodology":"02","contractTypeCode":"1","contractTypeDescription":"S","amount":"5.00","flatRateAmt":"0.00","billItemType":"PREMIUM"},{"billingScheduleID":"BILLINGSCHEDULE_1001130_VS100001","scheduleEffectiveDate":"2020-01-01","scheduleExpirationDate":"2020-12-31","ratingMethodology":"02","contractTypeCode":"4","contractTypeDescription":"F","amount":"20.23","flatRateAmt":"0.00","billItemType":"PREMIUM"},{"billingScheduleID":"BILLINGSCHEDULE_1001130_VS100001","scheduleEffectiveDate":"2020-01-01","scheduleExpirationDate":"2020-12-31","ratingMethodology":"02","contractTypeCode":"3","contractTypeDescription":"PCH","amount":"15.00","flatRateAmt":"0.00","billItemType":"PREMIUM"}]}]},{"customerAccountOptionId":"29196599","customerAccountOptionDescription":"ContractOptDescription-Dental-20210312014927","customerAccountOptionType":"12 Months","statusCode":"I","statusDescription":"Inactive","exchangeTypeDescription":"Non-Exchange","startDate":"2021-01-01","renewalDate":"2022-01-01","terminationDate":"2021-12-31","stateOfIssueCode":"CT","stateOfIssueDescription":"CONNECTICUT","enrollmentInsuringRulesPopulationIndicator":"false","defineOpenEnrollmentbyPopulationIndicator":"true","customerAccountGroupPopulation":[{}],"customerAccountInsuringRules":[{"dependentCutOff":"26","dependentCutOffType":"Date of Event","studentMaximumAge":"26","studentmaximumAgeType":"Date of Event","waiveRehiredIndefiniteIndicator":"true","waiveWaitingPeriodForNewHireIndicator":"true","waiveRehiredWithinCount":"1","waiveRehiredWithinType":"M","terminationLagType":"001","terminationLagDescription":"Date of Event","overrideRetroBenefitAddIndicator":"false","overrideRetroBenefitChangeIndicator":"false","overrideRetroBenefitTerminationIndicator":"false","insuringRuleEffectiveDates":"2021-01-01","insuringRuleExpirationDates":"2021-12-31","nonStandardWaitingPeriodIndicator":"false","waitingPeriodRules":[{"waitingPeriodType":"Specified Duration","waitingDurationType":"Months","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"Specified Duration","waitingDurationType":"Months","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"Specified Duration","waitingDurationType":"Days","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"First of the Following Month after Specified Duration","waitingDurationType":"Days","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"First of the Following Month after Specified Duration","waitingDurationType":"Months","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"First of the Following Month after Specified Duration","waitingDurationType":"Months","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"Specified Duration","waitingDurationType":"Days","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"Specified Duration","waitingDurationType":"Days","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Plan Change"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Re-enrollment"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Rehire"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Special Enrollment"},{"waitingPeriodType":"Specified Duration","waitingDurationType":"Days","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Adoption"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Benefit Selection"},{"waitingPeriodType":"First of the Following Month after Specified Duration","waitingDurationType":"Days","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Birth"},{"waitingPeriodType":"First of the Following Month","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"First of the Following Month after Specified Duration","waitingDurationType":"Days","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Consolidation Omnibus Budget Reconciliation Act (COBRA)"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Late Enrollee"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Marriage"}]}],"customerPurchase":[{"memberGroupContractPlanOptionID":"DN100001","planOptionDescription":"Plan Option 10252727","fundingArrangementCode":"01","fundingArrangementDescription":"Fully Insured","coverageStartDate":"2021-01-01","coverageExpirationDate":"2021-12-31","benefitBundleOptionID":"10252727","timePeriodQualifier":"Calender Year","benefitBasePlan":"1P364","benefitPlanDescription":"1P364_PPO_CICU.80","gatedProductIndicator":"0","hsaVendorId":"0","networkScheduleId":[null],"domesticPartnerIndicator":"false","benefitServiceArea":"UNITED_STATES","lineOfBusinessId":"2","carrierId":"36","bookOfBusinessTypeCode":"UH","bookOfBusinessTypeDescription":"UnitedHealthcare Insurance Company","contractOptionType":"DN","contractOptionTypeDescription":"Dental","benefitType":"DN"}]},{"customerAccountOptionId":"29196600","customerAccountOptionDescription":"ContractOptDescription-Vision-20210312014927","customerAccountOptionType":"12 Months","statusCode":"A","statusDescription":"Active","exchangeTypeDescription":"Non-Exchange","startDate":"2021-01-01","renewalDate":"2022-01-01","terminationDate":"2021-12-31","stateOfIssueCode":"CT","stateOfIssueDescription":"CONNECTICUT","enrollmentInsuringRulesPopulationIndicator":"false","defineOpenEnrollmentbyPopulationIndicator":"true","customerAccountGroupPopulation":[{}],"customerAccountInsuringRules":[{"dependentCutOff":"26","dependentCutOffType":"Date of Event","studentMaximumAge":"26","studentmaximumAgeType":"Date of Event","waiveRehiredIndefiniteIndicator":"true","waiveWaitingPeriodForNewHireIndicator":"true","waiveRehiredWithinCount":"1","waiveRehiredWithinType":"M","terminationLagType":"001","terminationLagDescription":"Date of Event","overrideRetroBenefitAddIndicator":"false","overrideRetroBenefitChangeIndicator":"false","overrideRetroBenefitTerminationIndicator":"false","insuringRuleEffectiveDates":"2021-01-01","insuringRuleExpirationDates":"2021-12-31","nonStandardWaitingPeriodIndicator":"false","waitingPeriodRules":[{"waitingPeriodType":"Specified Duration","waitingDurationType":"Months","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"Specified Duration","waitingDurationType":"Months","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"Specified Duration","waitingDurationType":"Days","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"First of the Following Month after Specified Duration","waitingDurationType":"Days","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"First of the Following Month after Specified Duration","waitingDurationType":"Months","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"First of the Following Month after Specified Duration","waitingDurationType":"Months","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"Specified Duration","waitingDurationType":"Days","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"Specified Duration","waitingDurationType":"Days","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Plan Change"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Re-enrollment"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Rehire"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Special Enrollment"},{"waitingPeriodType":"Specified Duration","waitingDurationType":"Days","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Adoption"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Benefit Selection"},{"waitingPeriodType":"First of the Following Month after Specified Duration","waitingDurationType":"Days","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Birth"},{"waitingPeriodType":"First of the Following Month","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"First of the Following Month after Specified Duration","waitingDurationType":"Days","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Consolidation Omnibus Budget Reconciliation Act (COBRA)"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Late Enrollee"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Marriage"}]}],"customerPurchase":[{"memberGroupContractPlanOptionID":"VS100001","planOptionDescription":"Plan Option 10293468","fundingArrangementCode":"01","fundingArrangementDescription":"Fully Insured","coverageStartDate":"2021-01-01","coverageExpirationDate":"2021-12-31","benefitBundleOptionID":"10293468","timePeriodQualifier":"Calender Year","benefitBasePlan":"V1074","benefitPlanDescription":"V1074_100% ER Paid","gatedProductIndicator":"0","hsaVendorId":"0","networkScheduleId":[null],"domesticPartnerIndicator":"false","benefitServiceArea":"UNITED_STATES","lineOfBusinessId":"2","carrierId":"36","bookOfBusinessTypeCode":"UH","bookOfBusinessTypeDescription":"UnitedHealthcare Insurance Company","contractOptionType":"VS","contractOptionTypeDescription":"Vision","benefitType":"VS","billingSchedule":[{"billingScheduleID":"BRMS_UAT_SPB_V_5","scheduleEffectiveDate":"2021-01-01","scheduleExpirationDate":"2021-12-31","ratingMethodology":"02","contractTypeCode":"3","contractTypeDescription":"PCH","amount":"15.00","flatRateAmt":"0.00","billItemType":"PREMIUM"},{"billingScheduleID":"BRMS_UAT_SPB_V_5","scheduleEffectiveDate":"2021-01-01","scheduleExpirationDate":"2021-12-31","ratingMethodology":"02","contractTypeCode":"4","contractTypeDescription":"F","amount":"20.23","flatRateAmt":"0.00","billItemType":"PREMIUM"},{"billingScheduleID":"BRMS_UAT_SPB_V_5","scheduleEffectiveDate":"2021-01-01","scheduleExpirationDate":"2021-12-31","ratingMethodology":"02","contractTypeCode":"1","contractTypeDescription":"S","amount":"5.00","flatRateAmt":"0.00","billItemType":"PREMIUM"},{"billingScheduleID":"BRMS_UAT_SPB_V_5","scheduleEffectiveDate":"2021-01-01","scheduleExpirationDate":"2021-12-31","ratingMethodology":"02","contractTypeCode":"2","contractTypeDescription":"C","amount":"10.00","flatRateAmt":"0.00","billItemType":"PREMIUM"},{"billingScheduleID":"BRMS_UAT_SPB_V_5","scheduleEffectiveDate":"2021-01-01","scheduleExpirationDate":"2021-12-31","ratingMethodology":"02","contractTypeCode":"3","contractTypeDescription":"PCH","amount":"15.00","flatRateAmt":"0.00","billItemType":"PREMIUM"},{"billingScheduleID":"BRMS_UAT_SPB_V_5","scheduleEffectiveDate":"2021-01-01","scheduleExpirationDate":"2021-12-31","ratingMethodology":"02","contractTypeCode":"4","contractTypeDescription":"F","amount":"20.23","flatRateAmt":"0.00","billItemType":"PREMIUM"},{"billingScheduleID":"BRMS_UAT_SPB_V_5","scheduleEffectiveDate":"2021-01-01","scheduleExpirationDate":"2021-12-31","ratingMethodology":"02","contractTypeCode":"1","contractTypeDescription":"S","amount":"5.00","flatRateAmt":"0.00","billItemType":"PREMIUM"},{"billingScheduleID":"BRMS_UAT_SPB_V_5","scheduleEffectiveDate":"2021-01-01","scheduleExpirationDate":"2021-12-31","ratingMethodology":"02","contractTypeCode":"2","contractTypeDescription":"C","amount":"10.00","flatRateAmt":"0.00","billItemType":"PREMIUM"}]}]},{"customerAccountOptionId":"29196595","customerAccountOptionDescription":"ContractOptDescription-Medical-20210312014927","customerAccountOptionType":"12 Months","statusCode":"I","statusDescription":"Inactive","exchangeTypeDescription":"Non-Exchange","startDate":"2020-01-01","renewalDate":"2021-01-01","terminationDate":"2020-12-31","stateOfIssueCode":"CT","stateOfIssueDescription":"CONNECTICUT","openEnrollmentStartDate":"2020-01-01","openEnrollmentEndDate":"2020-02-01","enrollmentInsuringRulesPopulationIndicator":"true","defineOpenEnrollmentbyPopulationIndicator":"true","customerAccountGroupPopulation":[{"classesCode":"POP_1","classesDescription":"POP_1","populationOpenEnrollmentStartDate":"2020-01-01","populationOpenEnrollmentEndDate":"2020-02-01"}],"customerAccountInsuringRules":[{"dependentCutOff":"26","dependentCutOffType":"Date of Event","studentMaximumAge":"26","studentmaximumAgeType":"Date of Event","waiveRehiredIndefiniteIndicator":"true","waiveWaitingPeriodForNewHireIndicator":"true","waiveRehiredWithinCount":"1","waiveRehiredWithinType":"M","terminationLagType":"001","terminationLagDescription":"Date of Event","overrideRetroBenefitAddIndicator":"false","overrideRetroBenefitChangeIndicator":"false","overrideRetroBenefitTerminationIndicator":"false","insuringRuleEffectiveDates":"2020-01-01","insuringRuleExpirationDates":"2020-12-31","nonStandardWaitingPeriodIndicator":"false","waitingPeriodRules":[{"waitingPeriodType":"Specified Duration","waitingDurationType":"Months","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"Specified Duration","waitingDurationType":"Months","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"Specified Duration","waitingDurationType":"Days","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"First of the Following Month after Specified Duration","waitingDurationType":"Days","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"First of the Following Month after Specified Duration","waitingDurationType":"Months","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"First of the Following Month after Specified Duration","waitingDurationType":"Months","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"Specified Duration","waitingDurationType":"Days","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"Specified Duration","waitingDurationType":"Days","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Plan Change"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Re-enrollment"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Rehire"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Special Enrollment"},{"waitingPeriodType":"Specified Duration","waitingDurationType":"Days","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Adoption"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Benefit Selection"},{"waitingPeriodType":"First of the Following Month after Specified Duration","waitingDurationType":"Days","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Birth"},{"waitingPeriodType":"First of the Following Month","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"First of the Following Month after Specified Duration","waitingDurationType":"Days","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Consolidation Omnibus Budget Reconciliation Act (COBRA)"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Late Enrollee"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Marriage"}]}],"customerPurchase":[{"memberGroupContractPlanOptionID":"PO100001","planOptionDescription":"Plan Option 3501010","fundingArrangementCode":"01","fundingArrangementDescription":"Fully Insured","coverageStartDate":"2020-01-01","coverageExpirationDate":"2020-12-31","benefitBundleOptionID":"3501010","timePeriodQualifier":"Calender Year","benefitBasePlan":"M000000745","benefitPlanDescription":"CT S FRDM NG 30/60/2500/100 PPO HSA 20","gatedProductIndicator":"0","hsaVendorId":"0","networkScheduleId":["FREEDOM_CHOICEPLUS"],"domesticPartnerIndicator":"false","benefitServiceArea":"OXFORD_TRI_STATE","lineOfBusiness":[{"name":"Small Business","description":"Small Business  (UHC definition = 2 to 50, and Sole Prop)"}],"lineOfBusinessId":"2","carrierId":"5","carrierName":"Oxford Health Insurance, Inc.","bookOfBusinessTypeCode":"OX","bookOfBusinessTypeDescription":"Oxford FI/ASO","brandingEntityName":"UNITEDHEALTHCARE_OXFORD","brandingEntityDescription":"UnitedHealthcare Oxford","contractOptionType":"MD","contractOptionTypeDescription":"Medical","benefitType":"MD"}]},{"customerAccountOptionId":"29196597","customerAccountOptionDescription":"ContractOptDescription-Dental-20210312014927","customerAccountOptionType":"12 Months","statusCode":"I","statusDescription":"Inactive","exchangeTypeDescription":"Non-Exchange","startDate":"2020-01-01","renewalDate":"2021-01-01","terminationDate":"2020-12-31","stateOfIssueCode":"CT","stateOfIssueDescription":"CONNECTICUT","enrollmentInsuringRulesPopulationIndicator":"false","defineOpenEnrollmentbyPopulationIndicator":"true","customerAccountGroupPopulation":[{}],"customerAccountInsuringRules":[{"dependentCutOff":"26","dependentCutOffType":"Date of Event","studentMaximumAge":"26","studentmaximumAgeType":"Date of Event","waiveRehiredIndefiniteIndicator":"true","waiveWaitingPeriodForNewHireIndicator":"true","waiveRehiredWithinCount":"1","waiveRehiredWithinType":"M","terminationLagType":"001","terminationLagDescription":"Date of Event","overrideRetroBenefitAddIndicator":"false","overrideRetroBenefitChangeIndicator":"false","overrideRetroBenefitTerminationIndicator":"false","insuringRuleEffectiveDates":"2020-01-01","insuringRuleExpirationDates":"2020-12-31","nonStandardWaitingPeriodIndicator":"false","waitingPeriodRules":[{"waitingPeriodType":"Specified Duration","waitingDurationType":"Months","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"Specified Duration","waitingDurationType":"Months","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"Specified Duration","waitingDurationType":"Days","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"First of the Following Month after Specified Duration","waitingDurationType":"Days","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"First of the Following Month after Specified Duration","waitingDurationType":"Months","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"First of the Following Month after Specified Duration","waitingDurationType":"Months","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"Specified Duration","waitingDurationType":"Days","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"Specified Duration","waitingDurationType":"Days","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Plan Change"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Re-enrollment"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Rehire"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Special Enrollment"},{"waitingPeriodType":"Specified Duration","waitingDurationType":"Days","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Adoption"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Benefit Selection"},{"waitingPeriodType":"First of the Following Month after Specified Duration","waitingDurationType":"Days","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Birth"},{"waitingPeriodType":"First of the Following Month","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"First of the Following Month after Specified Duration","waitingDurationType":"Days","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Consolidation Omnibus Budget Reconciliation Act (COBRA)"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Late Enrollee"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Marriage"}]}],"customerPurchase":[{"memberGroupContractPlanOptionID":"DN100002","planOptionDescription":"Plan_dental_2020","fundingArrangementCode":"01","fundingArrangementDescription":"Fully Insured","coverageStartDate":"2020-01-01","coverageExpirationDate":"2020-12-31","benefitBundleOptionID":"10262975","timePeriodQualifier":"Calender Year","benefitBasePlan":"I0690","benefitPlanDescription":"I0690_Indemnity_VWU.85","gatedProductIndicator":"0","hsaVendorId":"0","networkScheduleId":[null],"domesticPartnerIndicator":"false","benefitServiceArea":"UNITED_STATES","lineOfBusinessId":"2","carrierId":"36","bookOfBusinessTypeCode":"ER","contractOptionType":"DN","contractOptionTypeDescription":"Dental","benefitType":"DN"}]},{"customerAccountOptionId":"29196598","customerAccountOptionDescription":"ContractOptDescription-Vision-20210312014927","customerAccountOptionType":"12 Months","statusCode":"I","statusDescription":"Inactive","exchangeTypeDescription":"Non-Exchange","startDate":"2020-01-01","renewalDate":"2021-01-01","terminationDate":"2020-12-31","stateOfIssueCode":"CT","stateOfIssueDescription":"CONNECTICUT","enrollmentInsuringRulesPopulationIndicator":"false","defineOpenEnrollmentbyPopulationIndicator":"true","customerAccountGroupPopulation":[{}],"customerAccountInsuringRules":[{"dependentCutOff":"26","dependentCutOffType":"Date of Event","studentMaximumAge":"26","studentmaximumAgeType":"Date of Event","waiveRehiredIndefiniteIndicator":"true","waiveWaitingPeriodForNewHireIndicator":"true","waiveRehiredWithinCount":"1","waiveRehiredWithinType":"M","terminationLagType":"001","terminationLagDescription":"Date of Event","overrideRetroBenefitAddIndicator":"false","overrideRetroBenefitChangeIndicator":"false","overrideRetroBenefitTerminationIndicator":"false","insuringRuleEffectiveDates":"2020-01-01","insuringRuleExpirationDates":"2020-12-31","nonStandardWaitingPeriodIndicator":"false","waitingPeriodRules":[{"waitingPeriodType":"Specified Duration","waitingDurationType":"Months","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"Specified Duration","waitingDurationType":"Months","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"Specified Duration","waitingDurationType":"Days","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"First of the Following Month after Specified Duration","waitingDurationType":"Days","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"First of the Following Month after Specified Duration","waitingDurationType":"Months","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"First of the Following Month after Specified Duration","waitingDurationType":"Months","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"Specified Duration","waitingDurationType":"Days","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"Specified Duration","waitingDurationType":"Days","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Plan Change"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Re-enrollment"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Rehire"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Special Enrollment"},{"waitingPeriodType":"Specified Duration","waitingDurationType":"Days","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Adoption"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Benefit Selection"},{"waitingPeriodType":"First of the Following Month after Specified Duration","waitingDurationType":"Days","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Birth"},{"waitingPeriodType":"First of the Following Month","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"First of the Following Month after Specified Duration","waitingDurationType":"Days","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Consolidation Omnibus Budget Reconciliation Act (COBRA)"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Late Enrollee"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Marriage"}]}],"customerPurchase":[{"memberGroupContractPlanOptionID":"VS100002","planOptionDescription":"Plan_11","fundingArrangementCode":"01","fundingArrangementDescription":"Fully Insured","coverageStartDate":"2020-01-01","coverageExpirationDate":"2020-12-31","benefitBundleOptionID":"10252860","timePeriodQualifier":"Calender Year","benefitBasePlan":"V1002","benefitPlanDescription":"V1002_100% ER Paid","gatedProductIndicator":"0","hsaVendorId":"0","networkScheduleId":[null],"domesticPartnerIndicator":"false","benefitServiceArea":"UNITED_STATES","lineOfBusinessId":"2","carrierId":"36","bookOfBusinessTypeCode":"UH","bookOfBusinessTypeDescription":"UnitedHealthcare Insurance Company","contractOptionType":"VS","contractOptionTypeDescription":"Vision","benefitType":"VS","billingSchedule":[{"billingScheduleID":"BRMS_UAT_SPB_V_5","scheduleEffectiveDate":"2020-01-01","scheduleExpirationDate":"2020-12-31","ratingMethodology":"02","contractTypeCode":"3","contractTypeDescription":"PCH","amount":"15.00","flatRateAmt":"0.00","billItemType":"PREMIUM"},{"billingScheduleID":"BRMS_UAT_SPB_V_5","scheduleEffectiveDate":"2020-01-01","scheduleExpirationDate":"2020-12-31","ratingMethodology":"02","contractTypeCode":"4","contractTypeDescription":"F","amount":"20.23","flatRateAmt":"0.00","billItemType":"PREMIUM"},{"billingScheduleID":"BRMS_UAT_SPB_V_5","scheduleEffectiveDate":"2020-01-01","scheduleExpirationDate":"2020-12-31","ratingMethodology":"02","contractTypeCode":"1","contractTypeDescription":"S","amount":"5.00","flatRateAmt":"0.00","billItemType":"PREMIUM"},{"billingScheduleID":"BRMS_UAT_SPB_V_5","scheduleEffectiveDate":"2020-01-01","scheduleExpirationDate":"2020-12-31","ratingMethodology":"02","contractTypeCode":"2","contractTypeDescription":"C","amount":"10.00","flatRateAmt":"0.00","billItemType":"PREMIUM"},{"billingScheduleID":"BRMS_UAT_SPB_V_5","scheduleEffectiveDate":"2020-01-01","scheduleExpirationDate":"2020-12-31","ratingMethodology":"02","contractTypeCode":"3","contractTypeDescription":"PCH","amount":"15.00","flatRateAmt":"0.00","billItemType":"COB_PREM"},{"billingScheduleID":"BRMS_UAT_SPB_V_5","scheduleEffectiveDate":"2020-01-01","scheduleExpirationDate":"2020-12-31","ratingMethodology":"02","contractTypeCode":"4","contractTypeDescription":"F","amount":"20.23","flatRateAmt":"0.00","billItemType":"COB_PREM"},{"billingScheduleID":"BRMS_UAT_SPB_V_5","scheduleEffectiveDate":"2020-01-01","scheduleExpirationDate":"2020-12-31","ratingMethodology":"02","contractTypeCode":"1","contractTypeDescription":"S","amount":"5.00","flatRateAmt":"0.00","billItemType":"COB_PREM"},{"billingScheduleID":"BRMS_UAT_SPB_V_5","scheduleEffectiveDate":"2020-01-01","scheduleExpirationDate":"2020-12-31","ratingMethodology":"02","contractTypeCode":"2","contractTypeDescription":"C","amount":"10.00","flatRateAmt":"0.00","billItemType":"COB_PREM"}]}]},{"customerAccountOptionId":"29196599","customerAccountOptionDescription":"ContractOptDescription-Dental-20210312014927","customerAccountOptionType":"12 Months","statusCode":"A","statusDescription":"Active","exchangeTypeDescription":"Non-Exchange","startDate":"2021-01-01","renewalDate":"2022-01-01","terminationDate":"2021-12-31","stateOfIssueCode":"CT","stateOfIssueDescription":"CONNECTICUT","enrollmentInsuringRulesPopulationIndicator":"false","defineOpenEnrollmentbyPopulationIndicator":"true","customerAccountGroupPopulation":[{}],"customerAccountInsuringRules":[{"dependentCutOff":"26","dependentCutOffType":"Date of Event","studentMaximumAge":"26","studentmaximumAgeType":"Date of Event","waiveRehiredIndefiniteIndicator":"true","waiveWaitingPeriodForNewHireIndicator":"true","waiveRehiredWithinCount":"1","waiveRehiredWithinType":"M","terminationLagType":"001","terminationLagDescription":"Date of Event","overrideRetroBenefitAddIndicator":"false","overrideRetroBenefitChangeIndicator":"false","overrideRetroBenefitTerminationIndicator":"false","insuringRuleEffectiveDates":"2021-01-01","insuringRuleExpirationDates":"2021-12-31","nonStandardWaitingPeriodIndicator":"false","waitingPeriodRules":[{"waitingPeriodType":"Specified Duration","waitingDurationType":"Months","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"Specified Duration","waitingDurationType":"Months","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"Specified Duration","waitingDurationType":"Days","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"First of the Following Month after Specified Duration","waitingDurationType":"Days","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"First of the Following Month after Specified Duration","waitingDurationType":"Months","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"First of the Following Month after Specified Duration","waitingDurationType":"Months","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"Specified Duration","waitingDurationType":"Days","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"Specified Duration","waitingDurationType":"Days","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Plan Change"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Re-enrollment"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Rehire"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Special Enrollment"},{"waitingPeriodType":"Specified Duration","waitingDurationType":"Days","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Adoption"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Benefit Selection"},{"waitingPeriodType":"First of the Following Month after Specified Duration","waitingDurationType":"Days","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Birth"},{"waitingPeriodType":"First of the Following Month","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"First of the Following Month after Specified Duration","waitingDurationType":"Days","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Consolidation Omnibus Budget Reconciliation Act (COBRA)"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Late Enrollee"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Marriage"}]}],"customerPurchase":[{"memberGroupContractPlanOptionID":"DN100001","planOptionDescription":"Plan Option 10252727","fundingArrangementCode":"01","fundingArrangementDescription":"Fully Insured","coverageStartDate":"2021-01-01","coverageExpirationDate":"2021-12-31","benefitBundleOptionID":"10252727","timePeriodQualifier":"Calender Year","benefitBasePlan":"1P364","benefitPlanDescription":"1P364_PPO_CICU.80","gatedProductIndicator":"0","hsaVendorId":"0","networkScheduleId":[null],"domesticPartnerIndicator":"false","benefitServiceArea":"UNITED_STATES","lineOfBusinessId":"2","carrierId":"36","bookOfBusinessTypeCode":"UH","bookOfBusinessTypeDescription":"UnitedHealthcare Insurance Company","contractOptionType":"DN","contractOptionTypeDescription":"Dental","benefitType":"DN","billingSchedule":[{"billingScheduleID":"BILLINGSCHEDULE_1003629_25134723","scheduleEffectiveDate":"2021-01-01","scheduleExpirationDate":"2021-12-31","ratingMethodology":"02","contractTypeCode":"4","contractTypeDescription":"F","amount":"20.20","flatRateAmt":"0.00","billItemType":"PREMIUM"},{"billingScheduleID":"BILLINGSCHEDULE_1003629_25134723","scheduleEffectiveDate":"2021-01-01","scheduleExpirationDate":"2021-12-31","ratingMethodology":"02","contractTypeCode":"3","contractTypeDescription":"PCH","amount":"20.20","flatRateAmt":"0.00","billItemType":"PREMIUM"},{"billingScheduleID":"BILLINGSCHEDULE_1003629_25134723","scheduleEffectiveDate":"2021-01-01","scheduleExpirationDate":"2021-12-31","ratingMethodology":"02","contractTypeCode":"2","contractTypeDescription":"C","amount":"20.20","flatRateAmt":"0.00","billItemType":"PREMIUM"},{"billingScheduleID":"BILLINGSCHEDULE_1003629_25134723","scheduleEffectiveDate":"2021-01-01","scheduleExpirationDate":"2021-12-31","ratingMethodology":"02","contractTypeCode":"1","contractTypeDescription":"S","amount":"20.20","flatRateAmt":"0.00","billItemType":"PREMIUM"},{"billingScheduleID":"BILLINGSCHEDULE_1003629_25134723","scheduleEffectiveDate":"2021-01-01","scheduleExpirationDate":"2021-12-31","ratingMethodology":"02","contractTypeCode":"4","contractTypeDescription":"F","amount":"20.20","flatRateAmt":"0.00","billItemType":"COB_PREM"},{"billingScheduleID":"BILLINGSCHEDULE_1003629_25134723","scheduleEffectiveDate":"2021-01-01","scheduleExpirationDate":"2021-12-31","ratingMethodology":"02","contractTypeCode":"3","contractTypeDescription":"PCH","amount":"20.20","flatRateAmt":"0.00","billItemType":"COB_PREM"},{"billingScheduleID":"BILLINGSCHEDULE_1003629_25134723","scheduleEffectiveDate":"2021-01-01","scheduleExpirationDate":"2021-12-31","ratingMethodology":"02","contractTypeCode":"2","contractTypeDescription":"C","amount":"20.20","flatRateAmt":"0.00","billItemType":"COB_PREM"},{"billingScheduleID":"BILLINGSCHEDULE_1003629_25134723","scheduleEffectiveDate":"2021-01-01","scheduleExpirationDate":"2021-12-31","ratingMethodology":"02","contractTypeCode":"1","contractTypeDescription":"S","amount":"20.20","flatRateAmt":"0.00","billItemType":"COB_PREM"}]}]},{"customerAccountOptionId":"29196600","customerAccountOptionDescription":"ContractOptDescription-Vision-20210312014927","customerAccountOptionType":"12 Months","statusCode":"I","statusDescription":"Inactive","exchangeTypeDescription":"Non-Exchange","startDate":"2021-01-01","renewalDate":"2022-01-01","terminationDate":"2021-12-31","stateOfIssueCode":"CT","stateOfIssueDescription":"CONNECTICUT","enrollmentInsuringRulesPopulationIndicator":"false","defineOpenEnrollmentbyPopulationIndicator":"true","customerAccountGroupPopulation":[{}],"customerAccountInsuringRules":[{"dependentCutOff":"26","dependentCutOffType":"Date of Event","studentMaximumAge":"26","studentmaximumAgeType":"Date of Event","waiveRehiredIndefiniteIndicator":"true","waiveWaitingPeriodForNewHireIndicator":"true","waiveRehiredWithinCount":"1","waiveRehiredWithinType":"M","terminationLagType":"001","terminationLagDescription":"Date of Event","overrideRetroBenefitAddIndicator":"false","overrideRetroBenefitChangeIndicator":"false","overrideRetroBenefitTerminationIndicator":"false","insuringRuleEffectiveDates":"2021-01-01","insuringRuleExpirationDates":"2021-12-31","nonStandardWaitingPeriodIndicator":"false","waitingPeriodRules":[{"waitingPeriodType":"Specified Duration","waitingDurationType":"Months","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"Specified Duration","waitingDurationType":"Months","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"Specified Duration","waitingDurationType":"Days","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"First of the Following Month after Specified Duration","waitingDurationType":"Days","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"First of the Following Month after Specified Duration","waitingDurationType":"Months","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"First of the Following Month after Specified Duration","waitingDurationType":"Months","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"Specified Duration","waitingDurationType":"Days","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"Specified Duration","waitingDurationType":"Days","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Plan Change"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Re-enrollment"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Rehire"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Special Enrollment"},{"waitingPeriodType":"Specified Duration","waitingDurationType":"Days","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Adoption"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Benefit Selection"},{"waitingPeriodType":"First of the Following Month after Specified Duration","waitingDurationType":"Days","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Birth"},{"waitingPeriodType":"First of the Following Month","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"First of the Following Month after Specified Duration","waitingDurationType":"Days","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Consolidation Omnibus Budget Reconciliation Act (COBRA)"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Late Enrollee"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Marriage"}]}],"customerPurchase":[{"memberGroupContractPlanOptionID":"VS100001","planOptionDescription":"Plan Option 10293468","fundingArrangementCode":"01","fundingArrangementDescription":"Fully Insured","coverageStartDate":"2021-01-01","coverageExpirationDate":"2021-12-31","benefitBundleOptionID":"10293468","timePeriodQualifier":"Calender Year","benefitBasePlan":"V1074","benefitPlanDescription":"V1074_100% ER Paid","gatedProductIndicator":"0","hsaVendorId":"0","networkScheduleId":[null],"domesticPartnerIndicator":"false","benefitServiceArea":"UNITED_STATES","lineOfBusinessId":"2","carrierId":"36","bookOfBusinessTypeCode":"ER","contractOptionType":"VS","contractOptionTypeDescription":"Vision","benefitType":"VS","billingSchedule":[{"billingScheduleID":"BILLINGSCHEDULE_1004278_25216025","scheduleEffectiveDate":"2021-01-01","scheduleExpirationDate":"2021-12-31","ratingMethodology":"02","contractTypeCode":"3","contractTypeDescription":"PCH","amount":"330.20","flatRateAmt":"0.00","billItemType":"PREMIUM"},{"billingScheduleID":"BILLINGSCHEDULE_1004278_25216025","scheduleEffectiveDate":"2021-01-01","scheduleExpirationDate":"2021-12-31","ratingMethodology":"02","contractTypeCode":"2","contractTypeDescription":"C","amount":"270.20","flatRateAmt":"0.00","billItemType":"PREMIUM"},{"billingScheduleID":"BILLINGSCHEDULE_1004278_25216025","scheduleEffectiveDate":"2021-01-01","scheduleExpirationDate":"2021-12-31","ratingMethodology":"02","contractTypeCode":"4","contractTypeDescription":"F","amount":"350.20","flatRateAmt":"0.00","billItemType":"PREMIUM"},{"billingScheduleID":"BILLINGSCHEDULE_1004278_25216025","scheduleEffectiveDate":"2021-01-01","scheduleExpirationDate":"2021-12-31","ratingMethodology":"02","contractTypeCode":"1","contractTypeDescription":"S","amount":"240.20","flatRateAmt":"0.00","billItemType":"PREMIUM"}]}]}]}]}}}');
              Response.setStatusCode(200); 
        }
                             else if(Test.isRunningTest() && ACETViewEmployerGroupControllerTest.failureScenario){
                                 Response = new HTTPResponse();
                                 Response.setBody('{"getEmployerGroupResponse":{"employerGroup":{"groupNumber":"1004278","groupName":"Acet_test_four_20210312014927","sourceSysCode":"CIRRUS","organizationTypeCode":"1","organizationTypeDescription":"Corporation","taxIdentificationNumber":["424660716"],"sizeDefinitionCode":"01","sizeDefinitionDescription":"Small Group","groupClassification":"Group","enrollmentType":"EDI and Paper","migrationSourceSystem":[{"id":"031201492","name":"PUL"}],"riskManagementIndicator":"false","erisaIndicator":"true","groupLevelHoldIndicator":"true","groupLevelHold":[{"groupHoldCode":"FULFIL","groupHoldShortDescription":"Hold Fulfillment","groupHoldEffectiveDates":"2021-03-12","groupHoldExpirationDates":"9999-12-31"},{"groupHoldCode":"WELKIT","groupHoldShortDescription":"Welcome Kit","groupHoldEffectiveDates":"2021-03-12","groupHoldExpirationDates":"9999-12-31"}],"groupSettings":[{"cobAttestationFrequency":"0","cobAttestationDenyGracePeriod":"0","religiousExemptionTypeDescription":"Not a Religious Exempt Group","effectiveDate":"2020-01-01","expirationDate":"9999-12-31"}],"groupAddress":[{"addressTypeCode":"PHY","addressTypeDescription":"Physical Address","addressLine1":"460 Natalya Road","addressLine2":"Suite 613","addressCity":"HARTFORD","addressPostalCode":"06103","addressStateCode":"CT","addressCountryCode":"US","addressCountryDescription":"United States of America","salesOfficeCode":"339","salesOfficeDescription":"Hartford/oth","effectiveDate":"2020-01-01","expirationDate":"9999-12-31"}],"groupContact":[{"roleType":"2","roleDescription":"Billing Contact","primaryIndicatorCode":"true","primaryIndicatorDescription":"Primary","firstName":"Mallory","lastName":"Berry","startDate":"2020-01-01","endDate":"9999-12-31","assignmentStartDate":"2020-01-01","assignmentEndDate":"9999-12-31","phone":[{"phoneType":"8","telephoneNumber":"732-769-2603","phoneTypeDescription":"Other"}],"email":[{"communicationTypeCode":"EML","electronicAddress":"Mallory.Berry@optum.com"}],"address":[{"addressTypeCode":"PHY","addressTypeDescription":"Physical Address","addressLine1":"587 Margene Road","addressLine2":"Suite 613","addressCity":"HARTFORD","addressPostalCode":"06103","addressStateCode":"CT","addressCountryCode":"US","addressCountryDescription":"United States of America"}]},{"roleType":"1","roleDescription":"Benefit Administrator","primaryIndicatorCode":"true","primaryIndicatorDescription":"Primary","firstName":"Dixie","lastName":"Kelley","startDate":"2020-01-01","endDate":"9999-12-31","assignmentStartDate":"2020-01-01","assignmentEndDate":"9999-12-31","phone":[{"phoneType":"8","telephoneNumber":"732-769-2603","phoneTypeDescription":"Other"}],"email":[{"communicationTypeCode":"EML","electronicAddress":"Dixie.Kelley@optum.com"}],"address":[{"addressTypeCode":"PHY","addressTypeDescription":"Physical Address","addressLine1":"460 Natalya Road","addressLine2":"Suite 613","addressCity":"HARTFORD","addressPostalCode":"06103","addressStateCode":"CT","addressCountryCode":"US","addressCountryDescription":"United States of America"}]},{"roleType":"8","roleDescription":"SBC Contact","primaryIndicatorCode":"true","primaryIndicatorDescription":"Primary","firstName":"Leonie","lastName":"Harper","startDate":"2020-01-01","endDate":"9999-12-31","assignmentStartDate":"2020-01-01","assignmentEndDate":"9999-12-31","phone":[{"phoneType":"8","telephoneNumber":"732-769-2603","phoneTypeDescription":"Other"}],"email":[{"communicationTypeCode":"EML","electronicAddress":"Leonie.Harper@optum.com"}],"address":[{"addressTypeCode":"PHY","addressTypeDescription":"Physical Address","addressLine1":"932 Mandie Road","addressLine2":"Suite 613","addressCity":"HARTFORD","addressPostalCode":"06103","addressStateCode":"CT","addressCountryCode":"US","addressCountryDescription":"United States of America"}]}],"groupInsuringRules":[{"cobraAdministrativeIndicator":"0","continuationResponsibilityType":"Member Group","insuranceContinuationType":"COBRA","onshoreRestriction":"All Services Offshore","insuringRulesEffectiveDates":"2020-01-01","insuringRulesExpirationDates":"9999-12-31","pcpRadomization":"01","survivingSpouseIndicator":"true","newBornAutoAddIndicator":"true","countNewbornForCoverageLevelCodeIndicator":"true"},{"classesCode":"POP_1","cobraAdministrativeIndicator":"0","earlyRetirementIndicator":"false","earlyRetirementMinimumAge":"0","workingRetirementIndicator":"false","workingRetirementMinimumAge":"0","insuringRulesEffectiveDates":"2020-01-01","insuringRulesExpirationDates":"9999-12-31","pcpRadomization":"01","survivingSpouseIndicator":"true","newBornAutoAddIndicator":"true","countNewbornForCoverageLevelCodeIndicator":"true"},{"classesCode":"POP_2","cobraAdministrativeIndicator":"0","earlyRetirementIndicator":"false","earlyRetirementMinimumAge":"0","workingRetirementIndicator":"false","workingRetirementMinimumAge":"0","insuringRulesEffectiveDates":"2020-01-01","insuringRulesExpirationDates":"9999-12-31","pcpRadomization":"01","survivingSpouseIndicator":"true","newBornAutoAddIndicator":"true","countNewbornForCoverageLevelCodeIndicator":"true"}],"groupPopulation":[{"classesCode":"POP_1","classesDescription":"POP_1"},{"classesCode":"POP_2","classesDescription":"POP_2"}],"customerAccount":[{"originalContractDate":"2020-01-01","migrationIndicator":"false","customerAccountOption":[{"customerAccountOptionId":"29196595","customerAccountOptionDescription":"ContractOptDescription-Medical-20210312014927","customerAccountOptionType":"12 Months","statusCode":"A","statusDescription":"Active","exchangeTypeDescription":"Non-Exchange","startDate":"2020-01-01","renewalDate":"2021-01-01","terminationDate":"2020-12-31","stateOfIssueCode":"CT","stateOfIssueDescription":"CONNECTICUT","openEnrollmentStartDate":"2020-01-01","openEnrollmentEndDate":"2020-02-01","enrollmentInsuringRulesPopulationIndicator":"true","defineOpenEnrollmentbyPopulationIndicator":"true","customerAccountGroupPopulation":[{"classesCode":"POP_1","classesDescription":"POP_1","populationOpenEnrollmentStartDate":"2020-01-01","populationOpenEnrollmentEndDate":"2020-02-01"}],"customerAccountInsuringRules":[{"dependentCutOff":"26","dependentCutOffType":"Date of Event","studentMaximumAge":"26","studentmaximumAgeType":"Date of Event","waiveRehiredIndefiniteIndicator":"true","waiveWaitingPeriodForNewHireIndicator":"true","waiveRehiredWithinCount":"1","waiveRehiredWithinType":"M","terminationLagType":"001","terminationLagDescription":"Date of Event","overrideRetroBenefitAddIndicator":"false","overrideRetroBenefitChangeIndicator":"false","overrideRetroBenefitTerminationIndicator":"false","insuringRuleEffectiveDates":"2020-01-01","insuringRuleExpirationDates":"2020-12-31","nonStandardWaitingPeriodIndicator":"false","waitingPeriodRules":[{"waitingPeriodType":"Specified Duration","waitingDurationType":"Months","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"Specified Duration","waitingDurationType":"Months","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"Specified Duration","waitingDurationType":"Days","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"First of the Following Month after Specified Duration","waitingDurationType":"Days","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"First of the Following Month after Specified Duration","waitingDurationType":"Months","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"First of the Following Month after Specified Duration","waitingDurationType":"Months","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"Specified Duration","waitingDurationType":"Days","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"Specified Duration","waitingDurationType":"Days","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Plan Change"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Re-enrollment"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Rehire"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Special Enrollment"},{"waitingPeriodType":"Specified Duration","waitingDurationType":"Days","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Adoption"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Benefit Selection"},{"waitingPeriodType":"First of the Following Month after Specified Duration","waitingDurationType":"Days","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Birth"},{"waitingPeriodType":"First of the Following Month","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"First of the Following Month after Specified Duration","waitingDurationType":"Days","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Consolidation Omnibus Budget Reconciliation Act (COBRA)"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Late Enrollee"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Marriage"}]}],"customerPurchase":[{"memberGroupContractPlanOptionID":"PO100001","planOptionDescription":"Plan Option 3501010","fundingArrangementCode":"01","fundingArrangementDescription":"Fully Insured","coverageStartDate":"2020-01-01","coverageExpirationDate":"2020-12-31","benefitBundleOptionID":"3501010","timePeriodQualifier":"Calender Year","benefitBasePlan":"M000000745","benefitPlanDescription":"CT S FRDM NG 30/60/2500/100 PPO HSA 20","gatedProductIndicator":"0","hsaVendorId":"0","networkScheduleId":["FREEDOM_CHOICEPLUS"],"domesticPartnerIndicator":"false","benefitServiceArea":"OXFORD_TRI_STATE","lineOfBusiness":[{"name":"Small Business","description":"Small Business  (UHC definition = 2 to 50, and Sole Prop)"}],"lineOfBusinessId":"2","carrierId":"5","carrierName":"Oxford Health Insurance, Inc.","bookOfBusinessTypeCode":"OX","bookOfBusinessTypeDescription":"Oxford FI/ASO","brandingEntityName":"UNITEDHEALTHCARE_OXFORD","brandingEntityDescription":"UnitedHealthcare Oxford","contractOptionType":"MD","contractOptionTypeDescription":"Medical","benefitType":"MD"}]},{"customerAccountOptionId":"29196596","customerAccountOptionDescription":"ContractOptDescription-Medical-20210312014927","customerAccountOptionType":"12 Months","statusCode":"A","statusDescription":"Active","exchangeTypeDescription":"Non-Exchange","startDate":"2021-01-01","renewalDate":"2022-01-01","terminationDate":"2021-12-31","stateOfIssueCode":"CT","stateOfIssueDescription":"CONNECTICUT","openEnrollmentStartDate":"2021-01-01","openEnrollmentEndDate":"2021-02-01","enrollmentInsuringRulesPopulationIndicator":"true","defineOpenEnrollmentbyPopulationIndicator":"true","customerAccountGroupPopulation":[{"classesCode":"POP_2","classesDescription":"POP_2","populationOpenEnrollmentStartDate":"2021-01-01","populationOpenEnrollmentEndDate":"2021-02-01"}],"customerAccountInsuringRules":[{"dependentCutOff":"26","dependentCutOffType":"Date of Event","studentMaximumAge":"26","studentmaximumAgeType":"Date of Event","waiveRehiredIndefiniteIndicator":"true","waiveWaitingPeriodForNewHireIndicator":"true","waiveRehiredWithinCount":"1","waiveRehiredWithinType":"M","terminationLagType":"001","terminationLagDescription":"Date of Event","overrideRetroBenefitAddIndicator":"false","overrideRetroBenefitChangeIndicator":"false","overrideRetroBenefitTerminationIndicator":"false","insuringRuleEffectiveDates":"2021-01-01","insuringRuleExpirationDates":"2021-12-31","nonStandardWaitingPeriodIndicator":"false","waitingPeriodRules":[{"waitingPeriodType":"Specified Duration","waitingDurationType":"Months","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"Specified Duration","waitingDurationType":"Months","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"Specified Duration","waitingDurationType":"Days","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"First of the Following Month after Specified Duration","waitingDurationType":"Days","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"First of the Following Month after Specified Duration","waitingDurationType":"Months","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"First of the Following Month after Specified Duration","waitingDurationType":"Months","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"Specified Duration","waitingDurationType":"Days","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"Specified Duration","waitingDurationType":"Days","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Plan Change"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Re-enrollment"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Rehire"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Special Enrollment"},{"waitingPeriodType":"Specified Duration","waitingDurationType":"Days","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Adoption"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Benefit Selection"},{"waitingPeriodType":"First of the Following Month after Specified Duration","waitingDurationType":"Days","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Birth"},{"waitingPeriodType":"First of the Following Month","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"First of the Following Month after Specified Duration","waitingDurationType":"Days","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Consolidation Omnibus Budget Reconciliation Act (COBRA)"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Late Enrollee"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Marriage"}]},{"classesCode":"POP_2","classesDescription":"POP_2","dependentCutOff":"26","dependentCutOffType":"Date of Event","studentMaximumAge":"26","studentmaximumAgeType":"Date of Event","waiveRehiredIndefiniteIndicator":"true","waiveWaitingPeriodForNewHireIndicator":"true","waiveRehiredWithinCount":"1","waiveRehiredWithinType":"M","terminationLagType":"001","terminationLagDescription":"Date of Event","overrideRetroBenefitAddIndicator":"false","overrideRetroBenefitChangeIndicator":"false","overrideRetroBenefitTerminationIndicator":"false","insuringRuleEffectiveDates":"2021-01-01","insuringRuleExpirationDates":"2021-12-31","nonStandardWaitingPeriodIndicator":"false","waitingPeriodRules":[{"waitingPeriodType":"Specified Duration","waitingDurationType":"Months","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"Specified Duration","waitingDurationType":"Months","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"Specified Duration","waitingDurationType":"Days","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"First of the Following Month after Specified Duration","waitingDurationType":"Days","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"First of the Following Month after Specified Duration","waitingDurationType":"Months","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"First of the Following Month after Specified Duration","waitingDurationType":"Months","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"Specified Duration","waitingDurationType":"Days","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"Specified Duration","waitingDurationType":"Days","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Plan Change"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Re-enrollment"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Rehire"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Special Enrollment"},{"waitingPeriodType":"Specified Duration","waitingDurationType":"Days","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Adoption"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Benefit Selection"},{"waitingPeriodType":"First of the Following Month after Specified Duration","waitingDurationType":"Days","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Birth"},{"waitingPeriodType":"First of the Following Month","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"First of the Following Month after Specified Duration","waitingDurationType":"Days","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Consolidation Omnibus Budget Reconciliation Act (COBRA)"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Late Enrollee"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Marriage"}]}],"customerPurchase":[{"memberGroupContractPlanOptionID":"PO100002","planOptionDescription":"Plan Option 1018484","fundingArrangementCode":"01","fundingArrangementDescription":"Fully Insured","coverageStartDate":"2021-01-01","coverageExpirationDate":"2021-12-31","benefitBundleOptionID":"3622803","timePeriodQualifier":"Calender Year","benefitBasePlan":"M000000782","benefitPlanDescription":"CT S FRDM NG 30/75/4750/75 PPO 21","gatedProductIndicator":"0","hsaVendorId":"0","networkScheduleId":["FREEDOM_CHOICEPLUS"],"domesticPartnerIndicator":"false","benefitServiceArea":"OXFORD_TRI_STATE","lineOfBusiness":[{"name":"Small Business","description":"Small Business  (UHC definition = 2 to 50, and Sole Prop)"}],"lineOfBusinessId":"2","carrierId":"5","carrierName":"Oxford Health Insurance, Inc.","bookOfBusinessTypeCode":"OX","bookOfBusinessTypeDescription":"Oxford FI/ASO","brandingEntityName":"UNITEDHEALTHCARE_OXFORD","brandingEntityDescription":"UnitedHealthcare Oxford","contractOptionType":"MD","contractOptionTypeDescription":"Medical","benefitType":"MD"}]},{"customerAccountOptionId":"29196597","customerAccountOptionDescription":"ContractOptDescription-Dental-20210312014927","customerAccountOptionType":"12 Months","statusCode":"A","statusDescription":"Active","exchangeTypeDescription":"Non-Exchange","startDate":"2020-01-01","renewalDate":"2021-01-01","terminationDate":"2020-12-31","stateOfIssueCode":"CT","stateOfIssueDescription":"CONNECTICUT","enrollmentInsuringRulesPopulationIndicator":"false","defineOpenEnrollmentbyPopulationIndicator":"true","customerAccountGroupPopulation":[{}],"customerAccountInsuringRules":[{"dependentCutOff":"26","dependentCutOffType":"Date of Event","studentMaximumAge":"26","studentmaximumAgeType":"Date of Event","waiveRehiredIndefiniteIndicator":"true","waiveWaitingPeriodForNewHireIndicator":"true","waiveRehiredWithinCount":"1","waiveRehiredWithinType":"M","terminationLagType":"001","terminationLagDescription":"Date of Event","overrideRetroBenefitAddIndicator":"false","overrideRetroBenefitChangeIndicator":"false","overrideRetroBenefitTerminationIndicator":"false","insuringRuleEffectiveDates":"2020-01-01","insuringRuleExpirationDates":"2020-12-31","nonStandardWaitingPeriodIndicator":"false","waitingPeriodRules":[{"waitingPeriodType":"Specified Duration","waitingDurationType":"Months","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"Specified Duration","waitingDurationType":"Months","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"Specified Duration","waitingDurationType":"Days","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"First of the Following Month after Specified Duration","waitingDurationType":"Days","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"First of the Following Month after Specified Duration","waitingDurationType":"Months","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"First of the Following Month after Specified Duration","waitingDurationType":"Months","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"Specified Duration","waitingDurationType":"Days","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"Specified Duration","waitingDurationType":"Days","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Plan Change"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Re-enrollment"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Rehire"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Special Enrollment"},{"waitingPeriodType":"Specified Duration","waitingDurationType":"Days","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Adoption"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Benefit Selection"},{"waitingPeriodType":"First of the Following Month after Specified Duration","waitingDurationType":"Days","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Birth"},{"waitingPeriodType":"First of the Following Month","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"First of the Following Month after Specified Duration","waitingDurationType":"Days","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Consolidation Omnibus Budget Reconciliation Act (COBRA)"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Late Enrollee"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Marriage"}]}],"customerPurchase":[{"memberGroupContractPlanOptionID":"DN100002","planOptionDescription":"Plan_dental_2020","fundingArrangementCode":"01","fundingArrangementDescription":"Fully Insured","coverageStartDate":"2020-01-01","coverageExpirationDate":"2020-12-31","benefitBundleOptionID":"10262975","timePeriodQualifier":"Calender Year","benefitBasePlan":"I0690","benefitPlanDescription":"I0690_Indemnity_VWU.85","gatedProductIndicator":"0","hsaVendorId":"0","networkScheduleId":[null],"domesticPartnerIndicator":"false","benefitServiceArea":"UNITED_STATES","lineOfBusinessId":"2","carrierId":"36","bookOfBusinessTypeCode":"UH","bookOfBusinessTypeDescription":"UnitedHealthcare Insurance Company","contractOptionType":"DN","contractOptionTypeDescription":"Dental","benefitType":"DN","billingSchedule":[{"billingScheduleID":"BILLINGSCHEDULE_1003629_25134723","scheduleEffectiveDate":"2020-01-01","scheduleExpirationDate":"2020-12-31","ratingMethodology":"02","contractTypeCode":"4","contractTypeDescription":"F","amount":"20.20","flatRateAmt":"0.00","billItemType":"PREMIUM"},{"billingScheduleID":"BILLINGSCHEDULE_1003629_25134723","scheduleEffectiveDate":"2020-01-01","scheduleExpirationDate":"2020-12-31","ratingMethodology":"02","contractTypeCode":"3","contractTypeDescription":"PCH","amount":"20.20","flatRateAmt":"0.00","billItemType":"PREMIUM"},{"billingScheduleID":"BILLINGSCHEDULE_1003629_25134723","scheduleEffectiveDate":"2020-01-01","scheduleExpirationDate":"2020-12-31","ratingMethodology":"02","contractTypeCode":"2","contractTypeDescription":"C","amount":"20.20","flatRateAmt":"0.00","billItemType":"PREMIUM"},{"billingScheduleID":"BILLINGSCHEDULE_1003629_25134723","scheduleEffectiveDate":"2020-01-01","scheduleExpirationDate":"2020-12-31","ratingMethodology":"02","contractTypeCode":"1","contractTypeDescription":"S","amount":"20.20","flatRateAmt":"0.00","billItemType":"PREMIUM"},{"billingScheduleID":"BILLINGSCHEDULE_1003629_25134723","scheduleEffectiveDate":"2020-01-01","scheduleExpirationDate":"2020-12-31","ratingMethodology":"02","contractTypeCode":"4","contractTypeDescription":"F","amount":"20.20","flatRateAmt":"0.00","billItemType":"COB_PREM"},{"billingScheduleID":"BILLINGSCHEDULE_1003629_25134723","scheduleEffectiveDate":"2020-01-01","scheduleExpirationDate":"2020-12-31","ratingMethodology":"02","contractTypeCode":"3","contractTypeDescription":"PCH","amount":"20.20","flatRateAmt":"0.00","billItemType":"COB_PREM"},{"billingScheduleID":"BILLINGSCHEDULE_1003629_25134723","scheduleEffectiveDate":"2020-01-01","scheduleExpirationDate":"2020-12-31","ratingMethodology":"02","contractTypeCode":"2","contractTypeDescription":"C","amount":"20.20","flatRateAmt":"0.00","billItemType":"COB_PREM"},{"billingScheduleID":"BILLINGSCHEDULE_1003629_25134723","scheduleEffectiveDate":"2020-01-01","scheduleExpirationDate":"2020-12-31","ratingMethodology":"02","contractTypeCode":"1","contractTypeDescription":"S","amount":"20.20","flatRateAmt":"0.00","billItemType":"COB_PREM"}]}]},{"customerAccountOptionId":"29196598","customerAccountOptionDescription":"ContractOptDescription-Vision-20210312014927","customerAccountOptionType":"12 Months","statusCode":"A","statusDescription":"Active","exchangeTypeDescription":"Non-Exchange","startDate":"2020-01-01","renewalDate":"2021-01-01","terminationDate":"2020-12-31","stateOfIssueCode":"CT","stateOfIssueDescription":"CONNECTICUT","enrollmentInsuringRulesPopulationIndicator":"false","defineOpenEnrollmentbyPopulationIndicator":"true","customerAccountGroupPopulation":[{}],"customerAccountInsuringRules":[{"dependentCutOff":"26","dependentCutOffType":"Date of Event","studentMaximumAge":"26","studentmaximumAgeType":"Date of Event","waiveRehiredIndefiniteIndicator":"true","waiveWaitingPeriodForNewHireIndicator":"true","waiveRehiredWithinCount":"1","waiveRehiredWithinType":"M","terminationLagType":"001","terminationLagDescription":"Date of Event","overrideRetroBenefitAddIndicator":"false","overrideRetroBenefitChangeIndicator":"false","overrideRetroBenefitTerminationIndicator":"false","insuringRuleEffectiveDates":"2020-01-01","insuringRuleExpirationDates":"2020-12-31","nonStandardWaitingPeriodIndicator":"false","waitingPeriodRules":[{"waitingPeriodType":"Specified Duration","waitingDurationType":"Months","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"Specified Duration","waitingDurationType":"Months","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"Specified Duration","waitingDurationType":"Days","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"First of the Following Month after Specified Duration","waitingDurationType":"Days","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"First of the Following Month after Specified Duration","waitingDurationType":"Months","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"First of the Following Month after Specified Duration","waitingDurationType":"Months","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"Specified Duration","waitingDurationType":"Days","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"Specified Duration","waitingDurationType":"Days","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Plan Change"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Re-enrollment"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Rehire"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Special Enrollment"},{"waitingPeriodType":"Specified Duration","waitingDurationType":"Days","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Adoption"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Benefit Selection"},{"waitingPeriodType":"First of the Following Month after Specified Duration","waitingDurationType":"Days","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Birth"},{"waitingPeriodType":"First of the Following Month","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"First of the Following Month after Specified Duration","waitingDurationType":"Days","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Consolidation Omnibus Budget Reconciliation Act (COBRA)"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Late Enrollee"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Marriage"}]}],"customerPurchase":[{"memberGroupContractPlanOptionID":"VS100002","planOptionDescription":"Plan_11","fundingArrangementCode":"01","fundingArrangementDescription":"Fully Insured","coverageStartDate":"2020-01-01","coverageExpirationDate":"2020-12-31","benefitBundleOptionID":"10252860","timePeriodQualifier":"Calender Year","benefitBasePlan":"V1002","benefitPlanDescription":"V1002_100% ER Paid","gatedProductIndicator":"0","hsaVendorId":"0","networkScheduleId":[null],"domesticPartnerIndicator":"false","benefitServiceArea":"UNITED_STATES","lineOfBusinessId":"2","carrierId":"36","bookOfBusinessTypeCode":"UH","bookOfBusinessTypeDescription":"UnitedHealthcare Insurance Company","contractOptionType":"VS","contractOptionTypeDescription":"Vision","benefitType":"VS","billingSchedule":[{"billingScheduleID":"BILLINGSCHEDULE_1001130_VS100001","scheduleEffectiveDate":"2020-01-01","scheduleExpirationDate":"2020-12-31","ratingMethodology":"02","contractTypeCode":"2","contractTypeDescription":"C","amount":"10.00","flatRateAmt":"0.00","billItemType":"PREMIUM"},{"billingScheduleID":"BILLINGSCHEDULE_1001130_VS100001","scheduleEffectiveDate":"2020-01-01","scheduleExpirationDate":"2020-12-31","ratingMethodology":"02","contractTypeCode":"1","contractTypeDescription":"S","amount":"5.00","flatRateAmt":"0.00","billItemType":"PREMIUM"},{"billingScheduleID":"BILLINGSCHEDULE_1001130_VS100001","scheduleEffectiveDate":"2020-01-01","scheduleExpirationDate":"2020-12-31","ratingMethodology":"02","contractTypeCode":"4","contractTypeDescription":"F","amount":"20.23","flatRateAmt":"0.00","billItemType":"PREMIUM"},{"billingScheduleID":"BILLINGSCHEDULE_1001130_VS100001","scheduleEffectiveDate":"2020-01-01","scheduleExpirationDate":"2020-12-31","ratingMethodology":"02","contractTypeCode":"3","contractTypeDescription":"PCH","amount":"15.00","flatRateAmt":"0.00","billItemType":"PREMIUM"},{"billingScheduleID":"BILLINGSCHEDULE_1001130_VS100001","scheduleEffectiveDate":"2020-01-01","scheduleExpirationDate":"2020-12-31","ratingMethodology":"02","contractTypeCode":"2","contractTypeDescription":"C","amount":"10.00","flatRateAmt":"0.00","billItemType":"PREMIUM"},{"billingScheduleID":"BILLINGSCHEDULE_1001130_VS100001","scheduleEffectiveDate":"2020-01-01","scheduleExpirationDate":"2020-12-31","ratingMethodology":"02","contractTypeCode":"1","contractTypeDescription":"S","amount":"5.00","flatRateAmt":"0.00","billItemType":"PREMIUM"},{"billingScheduleID":"BILLINGSCHEDULE_1001130_VS100001","scheduleEffectiveDate":"2020-01-01","scheduleExpirationDate":"2020-12-31","ratingMethodology":"02","contractTypeCode":"4","contractTypeDescription":"F","amount":"20.23","flatRateAmt":"0.00","billItemType":"PREMIUM"},{"billingScheduleID":"BILLINGSCHEDULE_1001130_VS100001","scheduleEffectiveDate":"2020-01-01","scheduleExpirationDate":"2020-12-31","ratingMethodology":"02","contractTypeCode":"3","contractTypeDescription":"PCH","amount":"15.00","flatRateAmt":"0.00","billItemType":"PREMIUM"}]}]},{"customerAccountOptionId":"29196599","customerAccountOptionDescription":"ContractOptDescription-Dental-20210312014927","customerAccountOptionType":"12 Months","statusCode":"I","statusDescription":"Inactive","exchangeTypeDescription":"Non-Exchange","startDate":"2021-01-01","renewalDate":"2022-01-01","terminationDate":"2021-12-31","stateOfIssueCode":"CT","stateOfIssueDescription":"CONNECTICUT","enrollmentInsuringRulesPopulationIndicator":"false","defineOpenEnrollmentbyPopulationIndicator":"true","customerAccountGroupPopulation":[{}],"customerAccountInsuringRules":[{"dependentCutOff":"26","dependentCutOffType":"Date of Event","studentMaximumAge":"26","studentmaximumAgeType":"Date of Event","waiveRehiredIndefiniteIndicator":"true","waiveWaitingPeriodForNewHireIndicator":"true","waiveRehiredWithinCount":"1","waiveRehiredWithinType":"M","terminationLagType":"001","terminationLagDescription":"Date of Event","overrideRetroBenefitAddIndicator":"false","overrideRetroBenefitChangeIndicator":"false","overrideRetroBenefitTerminationIndicator":"false","insuringRuleEffectiveDates":"2021-01-01","insuringRuleExpirationDates":"2021-12-31","nonStandardWaitingPeriodIndicator":"false","waitingPeriodRules":[{"waitingPeriodType":"Specified Duration","waitingDurationType":"Months","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"Specified Duration","waitingDurationType":"Months","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"Specified Duration","waitingDurationType":"Days","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"First of the Following Month after Specified Duration","waitingDurationType":"Days","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"First of the Following Month after Specified Duration","waitingDurationType":"Months","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"First of the Following Month after Specified Duration","waitingDurationType":"Months","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"Specified Duration","waitingDurationType":"Days","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"Specified Duration","waitingDurationType":"Days","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Plan Change"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Re-enrollment"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Rehire"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Special Enrollment"},{"waitingPeriodType":"Specified Duration","waitingDurationType":"Days","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Adoption"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Benefit Selection"},{"waitingPeriodType":"First of the Following Month after Specified Duration","waitingDurationType":"Days","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Birth"},{"waitingPeriodType":"First of the Following Month","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"First of the Following Month after Specified Duration","waitingDurationType":"Days","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Consolidation Omnibus Budget Reconciliation Act (COBRA)"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Late Enrollee"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Marriage"}]}],"customerPurchase":[{"memberGroupContractPlanOptionID":"DN100001","planOptionDescription":"Plan Option 10252727","fundingArrangementCode":"01","fundingArrangementDescription":"Fully Insured","coverageStartDate":"2021-01-01","coverageExpirationDate":"2021-12-31","benefitBundleOptionID":"10252727","timePeriodQualifier":"Calender Year","benefitBasePlan":"1P364","benefitPlanDescription":"1P364_PPO_CICU.80","gatedProductIndicator":"0","hsaVendorId":"0","networkScheduleId":[null],"domesticPartnerIndicator":"false","benefitServiceArea":"UNITED_STATES","lineOfBusinessId":"2","carrierId":"36","bookOfBusinessTypeCode":"UH","bookOfBusinessTypeDescription":"UnitedHealthcare Insurance Company","contractOptionType":"DN","contractOptionTypeDescription":"Dental","benefitType":"DN"}]},{"customerAccountOptionId":"29196600","customerAccountOptionDescription":"ContractOptDescription-Vision-20210312014927","customerAccountOptionType":"12 Months","statusCode":"A","statusDescription":"Active","exchangeTypeDescription":"Non-Exchange","startDate":"2021-01-01","renewalDate":"2022-01-01","terminationDate":"2021-12-31","stateOfIssueCode":"CT","stateOfIssueDescription":"CONNECTICUT","enrollmentInsuringRulesPopulationIndicator":"false","defineOpenEnrollmentbyPopulationIndicator":"true","customerAccountGroupPopulation":[{}],"customerAccountInsuringRules":[{"dependentCutOff":"26","dependentCutOffType":"Date of Event","studentMaximumAge":"26","studentmaximumAgeType":"Date of Event","waiveRehiredIndefiniteIndicator":"true","waiveWaitingPeriodForNewHireIndicator":"true","waiveRehiredWithinCount":"1","waiveRehiredWithinType":"M","terminationLagType":"001","terminationLagDescription":"Date of Event","overrideRetroBenefitAddIndicator":"false","overrideRetroBenefitChangeIndicator":"false","overrideRetroBenefitTerminationIndicator":"false","insuringRuleEffectiveDates":"2021-01-01","insuringRuleExpirationDates":"2021-12-31","nonStandardWaitingPeriodIndicator":"false","waitingPeriodRules":[{"waitingPeriodType":"Specified Duration","waitingDurationType":"Months","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"Specified Duration","waitingDurationType":"Months","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"Specified Duration","waitingDurationType":"Days","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"First of the Following Month after Specified Duration","waitingDurationType":"Days","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"First of the Following Month after Specified Duration","waitingDurationType":"Months","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"First of the Following Month after Specified Duration","waitingDurationType":"Months","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"Specified Duration","waitingDurationType":"Days","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"Specified Duration","waitingDurationType":"Days","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Plan Change"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Re-enrollment"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Rehire"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Special Enrollment"},{"waitingPeriodType":"Specified Duration","waitingDurationType":"Days","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Adoption"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Benefit Selection"},{"waitingPeriodType":"First of the Following Month after Specified Duration","waitingDurationType":"Days","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Birth"},{"waitingPeriodType":"First of the Following Month","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"First of the Following Month after Specified Duration","waitingDurationType":"Days","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Consolidation Omnibus Budget Reconciliation Act (COBRA)"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Late Enrollee"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Marriage"}]}],"customerPurchase":[{"memberGroupContractPlanOptionID":"VS100001","planOptionDescription":"Plan Option 10293468","fundingArrangementCode":"01","fundingArrangementDescription":"Fully Insured","coverageStartDate":"2021-01-01","coverageExpirationDate":"2021-12-31","benefitBundleOptionID":"10293468","timePeriodQualifier":"Calender Year","benefitBasePlan":"V1074","benefitPlanDescription":"V1074_100% ER Paid","gatedProductIndicator":"0","hsaVendorId":"0","networkScheduleId":[null],"domesticPartnerIndicator":"false","benefitServiceArea":"UNITED_STATES","lineOfBusinessId":"2","carrierId":"36","bookOfBusinessTypeCode":"UH","bookOfBusinessTypeDescription":"UnitedHealthcare Insurance Company","contractOptionType":"VS","contractOptionTypeDescription":"Vision","benefitType":"VS","billingSchedule":[{"billingScheduleID":"BRMS_UAT_SPB_V_5","scheduleEffectiveDate":"2021-01-01","scheduleExpirationDate":"2021-12-31","ratingMethodology":"02","contractTypeCode":"3","contractTypeDescription":"PCH","amount":"15.00","flatRateAmt":"0.00","billItemType":"PREMIUM"},{"billingScheduleID":"BRMS_UAT_SPB_V_5","scheduleEffectiveDate":"2021-01-01","scheduleExpirationDate":"2021-12-31","ratingMethodology":"02","contractTypeCode":"4","contractTypeDescription":"F","amount":"20.23","flatRateAmt":"0.00","billItemType":"PREMIUM"},{"billingScheduleID":"BRMS_UAT_SPB_V_5","scheduleEffectiveDate":"2021-01-01","scheduleExpirationDate":"2021-12-31","ratingMethodology":"02","contractTypeCode":"1","contractTypeDescription":"S","amount":"5.00","flatRateAmt":"0.00","billItemType":"PREMIUM"},{"billingScheduleID":"BRMS_UAT_SPB_V_5","scheduleEffectiveDate":"2021-01-01","scheduleExpirationDate":"2021-12-31","ratingMethodology":"02","contractTypeCode":"2","contractTypeDescription":"C","amount":"10.00","flatRateAmt":"0.00","billItemType":"PREMIUM"},{"billingScheduleID":"BRMS_UAT_SPB_V_5","scheduleEffectiveDate":"2021-01-01","scheduleExpirationDate":"2021-12-31","ratingMethodology":"02","contractTypeCode":"3","contractTypeDescription":"PCH","amount":"15.00","flatRateAmt":"0.00","billItemType":"PREMIUM"},{"billingScheduleID":"BRMS_UAT_SPB_V_5","scheduleEffectiveDate":"2021-01-01","scheduleExpirationDate":"2021-12-31","ratingMethodology":"02","contractTypeCode":"4","contractTypeDescription":"F","amount":"20.23","flatRateAmt":"0.00","billItemType":"PREMIUM"},{"billingScheduleID":"BRMS_UAT_SPB_V_5","scheduleEffectiveDate":"2021-01-01","scheduleExpirationDate":"2021-12-31","ratingMethodology":"02","contractTypeCode":"1","contractTypeDescription":"S","amount":"5.00","flatRateAmt":"0.00","billItemType":"PREMIUM"},{"billingScheduleID":"BRMS_UAT_SPB_V_5","scheduleEffectiveDate":"2021-01-01","scheduleExpirationDate":"2021-12-31","ratingMethodology":"02","contractTypeCode":"2","contractTypeDescription":"C","amount":"10.00","flatRateAmt":"0.00","billItemType":"PREMIUM"}]}]},{"customerAccountOptionId":"29196595","customerAccountOptionDescription":"ContractOptDescription-Medical-20210312014927","customerAccountOptionType":"12 Months","statusCode":"I","statusDescription":"Inactive","exchangeTypeDescription":"Non-Exchange","startDate":"2020-01-01","renewalDate":"2021-01-01","terminationDate":"2020-12-31","stateOfIssueCode":"CT","stateOfIssueDescription":"CONNECTICUT","openEnrollmentStartDate":"2020-01-01","openEnrollmentEndDate":"2020-02-01","enrollmentInsuringRulesPopulationIndicator":"true","defineOpenEnrollmentbyPopulationIndicator":"true","customerAccountGroupPopulation":[{"classesCode":"POP_1","classesDescription":"POP_1","populationOpenEnrollmentStartDate":"2020-01-01","populationOpenEnrollmentEndDate":"2020-02-01"}],"customerAccountInsuringRules":[{"dependentCutOff":"26","dependentCutOffType":"Date of Event","studentMaximumAge":"26","studentmaximumAgeType":"Date of Event","waiveRehiredIndefiniteIndicator":"true","waiveWaitingPeriodForNewHireIndicator":"true","waiveRehiredWithinCount":"1","waiveRehiredWithinType":"M","terminationLagType":"001","terminationLagDescription":"Date of Event","overrideRetroBenefitAddIndicator":"false","overrideRetroBenefitChangeIndicator":"false","overrideRetroBenefitTerminationIndicator":"false","insuringRuleEffectiveDates":"2020-01-01","insuringRuleExpirationDates":"2020-12-31","nonStandardWaitingPeriodIndicator":"false","waitingPeriodRules":[{"waitingPeriodType":"Specified Duration","waitingDurationType":"Months","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"Specified Duration","waitingDurationType":"Months","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"Specified Duration","waitingDurationType":"Days","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"First of the Following Month after Specified Duration","waitingDurationType":"Days","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"First of the Following Month after Specified Duration","waitingDurationType":"Months","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"First of the Following Month after Specified Duration","waitingDurationType":"Months","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"Specified Duration","waitingDurationType":"Days","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"Specified Duration","waitingDurationType":"Days","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Plan Change"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Re-enrollment"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Rehire"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Special Enrollment"},{"waitingPeriodType":"Specified Duration","waitingDurationType":"Days","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Adoption"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Benefit Selection"},{"waitingPeriodType":"First of the Following Month after Specified Duration","waitingDurationType":"Days","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Birth"},{"waitingPeriodType":"First of the Following Month","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"First of the Following Month after Specified Duration","waitingDurationType":"Days","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Consolidation Omnibus Budget Reconciliation Act (COBRA)"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Late Enrollee"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Marriage"}]}],"customerPurchase":[{"memberGroupContractPlanOptionID":"PO100001","planOptionDescription":"Plan Option 3501010","fundingArrangementCode":"01","fundingArrangementDescription":"Fully Insured","coverageStartDate":"2020-01-01","coverageExpirationDate":"2020-12-31","benefitBundleOptionID":"3501010","timePeriodQualifier":"Calender Year","benefitBasePlan":"M000000745","benefitPlanDescription":"CT S FRDM NG 30/60/2500/100 PPO HSA 20","gatedProductIndicator":"0","hsaVendorId":"0","networkScheduleId":["FREEDOM_CHOICEPLUS"],"domesticPartnerIndicator":"false","benefitServiceArea":"OXFORD_TRI_STATE","lineOfBusiness":[{"name":"Small Business","description":"Small Business  (UHC definition = 2 to 50, and Sole Prop)"}],"lineOfBusinessId":"2","carrierId":"5","carrierName":"Oxford Health Insurance, Inc.","bookOfBusinessTypeCode":"OX","bookOfBusinessTypeDescription":"Oxford FI/ASO","brandingEntityName":"UNITEDHEALTHCARE_OXFORD","brandingEntityDescription":"UnitedHealthcare Oxford","contractOptionType":"MD","contractOptionTypeDescription":"Medical","benefitType":"MD"}]},{"customerAccountOptionId":"29196597","customerAccountOptionDescription":"ContractOptDescription-Dental-20210312014927","customerAccountOptionType":"12 Months","statusCode":"I","statusDescription":"Inactive","exchangeTypeDescription":"Non-Exchange","startDate":"2020-01-01","renewalDate":"2021-01-01","terminationDate":"2020-12-31","stateOfIssueCode":"CT","stateOfIssueDescription":"CONNECTICUT","enrollmentInsuringRulesPopulationIndicator":"false","defineOpenEnrollmentbyPopulationIndicator":"true","customerAccountGroupPopulation":[{}],"customerAccountInsuringRules":[{"dependentCutOff":"26","dependentCutOffType":"Date of Event","studentMaximumAge":"26","studentmaximumAgeType":"Date of Event","waiveRehiredIndefiniteIndicator":"true","waiveWaitingPeriodForNewHireIndicator":"true","waiveRehiredWithinCount":"1","waiveRehiredWithinType":"M","terminationLagType":"001","terminationLagDescription":"Date of Event","overrideRetroBenefitAddIndicator":"false","overrideRetroBenefitChangeIndicator":"false","overrideRetroBenefitTerminationIndicator":"false","insuringRuleEffectiveDates":"2020-01-01","insuringRuleExpirationDates":"2020-12-31","nonStandardWaitingPeriodIndicator":"false","waitingPeriodRules":[{"waitingPeriodType":"Specified Duration","waitingDurationType":"Months","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"Specified Duration","waitingDurationType":"Months","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"Specified Duration","waitingDurationType":"Days","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"First of the Following Month after Specified Duration","waitingDurationType":"Days","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"First of the Following Month after Specified Duration","waitingDurationType":"Months","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"First of the Following Month after Specified Duration","waitingDurationType":"Months","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"Specified Duration","waitingDurationType":"Days","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"Specified Duration","waitingDurationType":"Days","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Plan Change"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Re-enrollment"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Rehire"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Special Enrollment"},{"waitingPeriodType":"Specified Duration","waitingDurationType":"Days","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Adoption"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Benefit Selection"},{"waitingPeriodType":"First of the Following Month after Specified Duration","waitingDurationType":"Days","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Birth"},{"waitingPeriodType":"First of the Following Month","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"First of the Following Month after Specified Duration","waitingDurationType":"Days","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Consolidation Omnibus Budget Reconciliation Act (COBRA)"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Late Enrollee"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Marriage"}]}],"customerPurchase":[{"memberGroupContractPlanOptionID":"DN100002","planOptionDescription":"Plan_dental_2020","fundingArrangementCode":"01","fundingArrangementDescription":"Fully Insured","coverageStartDate":"2020-01-01","coverageExpirationDate":"2020-12-31","benefitBundleOptionID":"10262975","timePeriodQualifier":"Calender Year","benefitBasePlan":"I0690","benefitPlanDescription":"I0690_Indemnity_VWU.85","gatedProductIndicator":"0","hsaVendorId":"0","networkScheduleId":[null],"domesticPartnerIndicator":"false","benefitServiceArea":"UNITED_STATES","lineOfBusinessId":"2","carrierId":"36","bookOfBusinessTypeCode":"ER","contractOptionType":"DN","contractOptionTypeDescription":"Dental","benefitType":"DN"}]},{"customerAccountOptionId":"29196598","customerAccountOptionDescription":"ContractOptDescription-Vision-20210312014927","customerAccountOptionType":"12 Months","statusCode":"I","statusDescription":"Inactive","exchangeTypeDescription":"Non-Exchange","startDate":"2020-01-01","renewalDate":"2021-01-01","terminationDate":"2020-12-31","stateOfIssueCode":"CT","stateOfIssueDescription":"CONNECTICUT","enrollmentInsuringRulesPopulationIndicator":"false","defineOpenEnrollmentbyPopulationIndicator":"true","customerAccountGroupPopulation":[{}],"customerAccountInsuringRules":[{"dependentCutOff":"26","dependentCutOffType":"Date of Event","studentMaximumAge":"26","studentmaximumAgeType":"Date of Event","waiveRehiredIndefiniteIndicator":"true","waiveWaitingPeriodForNewHireIndicator":"true","waiveRehiredWithinCount":"1","waiveRehiredWithinType":"M","terminationLagType":"001","terminationLagDescription":"Date of Event","overrideRetroBenefitAddIndicator":"false","overrideRetroBenefitChangeIndicator":"false","overrideRetroBenefitTerminationIndicator":"false","insuringRuleEffectiveDates":"2020-01-01","insuringRuleExpirationDates":"2020-12-31","nonStandardWaitingPeriodIndicator":"false","waitingPeriodRules":[{"waitingPeriodType":"Specified Duration","waitingDurationType":"Months","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"Specified Duration","waitingDurationType":"Months","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"Specified Duration","waitingDurationType":"Days","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"First of the Following Month after Specified Duration","waitingDurationType":"Days","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"First of the Following Month after Specified Duration","waitingDurationType":"Months","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"First of the Following Month after Specified Duration","waitingDurationType":"Months","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"Specified Duration","waitingDurationType":"Days","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"Specified Duration","waitingDurationType":"Days","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Plan Change"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Re-enrollment"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Rehire"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Special Enrollment"},{"waitingPeriodType":"Specified Duration","waitingDurationType":"Days","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Adoption"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Benefit Selection"},{"waitingPeriodType":"First of the Following Month after Specified Duration","waitingDurationType":"Days","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Birth"},{"waitingPeriodType":"First of the Following Month","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"First of the Following Month after Specified Duration","waitingDurationType":"Days","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Consolidation Omnibus Budget Reconciliation Act (COBRA)"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Late Enrollee"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Marriage"}]}],"customerPurchase":[{"memberGroupContractPlanOptionID":"VS100002","planOptionDescription":"Plan_11","fundingArrangementCode":"01","fundingArrangementDescription":"Fully Insured","coverageStartDate":"2020-01-01","coverageExpirationDate":"2020-12-31","benefitBundleOptionID":"10252860","timePeriodQualifier":"Calender Year","benefitBasePlan":"V1002","benefitPlanDescription":"V1002_100% ER Paid","gatedProductIndicator":"0","hsaVendorId":"0","networkScheduleId":[null],"domesticPartnerIndicator":"false","benefitServiceArea":"UNITED_STATES","lineOfBusinessId":"2","carrierId":"36","bookOfBusinessTypeCode":"UH","bookOfBusinessTypeDescription":"UnitedHealthcare Insurance Company","contractOptionType":"VS","contractOptionTypeDescription":"Vision","benefitType":"VS","billingSchedule":[{"billingScheduleID":"BRMS_UAT_SPB_V_5","scheduleEffectiveDate":"2020-01-01","scheduleExpirationDate":"2020-12-31","ratingMethodology":"02","contractTypeCode":"3","contractTypeDescription":"PCH","amount":"15.00","flatRateAmt":"0.00","billItemType":"PREMIUM"},{"billingScheduleID":"BRMS_UAT_SPB_V_5","scheduleEffectiveDate":"2020-01-01","scheduleExpirationDate":"2020-12-31","ratingMethodology":"02","contractTypeCode":"4","contractTypeDescription":"F","amount":"20.23","flatRateAmt":"0.00","billItemType":"PREMIUM"},{"billingScheduleID":"BRMS_UAT_SPB_V_5","scheduleEffectiveDate":"2020-01-01","scheduleExpirationDate":"2020-12-31","ratingMethodology":"02","contractTypeCode":"1","contractTypeDescription":"S","amount":"5.00","flatRateAmt":"0.00","billItemType":"PREMIUM"},{"billingScheduleID":"BRMS_UAT_SPB_V_5","scheduleEffectiveDate":"2020-01-01","scheduleExpirationDate":"2020-12-31","ratingMethodology":"02","contractTypeCode":"2","contractTypeDescription":"C","amount":"10.00","flatRateAmt":"0.00","billItemType":"PREMIUM"},{"billingScheduleID":"BRMS_UAT_SPB_V_5","scheduleEffectiveDate":"2020-01-01","scheduleExpirationDate":"2020-12-31","ratingMethodology":"02","contractTypeCode":"3","contractTypeDescription":"PCH","amount":"15.00","flatRateAmt":"0.00","billItemType":"COB_PREM"},{"billingScheduleID":"BRMS_UAT_SPB_V_5","scheduleEffectiveDate":"2020-01-01","scheduleExpirationDate":"2020-12-31","ratingMethodology":"02","contractTypeCode":"4","contractTypeDescription":"F","amount":"20.23","flatRateAmt":"0.00","billItemType":"COB_PREM"},{"billingScheduleID":"BRMS_UAT_SPB_V_5","scheduleEffectiveDate":"2020-01-01","scheduleExpirationDate":"2020-12-31","ratingMethodology":"02","contractTypeCode":"1","contractTypeDescription":"S","amount":"5.00","flatRateAmt":"0.00","billItemType":"COB_PREM"},{"billingScheduleID":"BRMS_UAT_SPB_V_5","scheduleEffectiveDate":"2020-01-01","scheduleExpirationDate":"2020-12-31","ratingMethodology":"02","contractTypeCode":"2","contractTypeDescription":"C","amount":"10.00","flatRateAmt":"0.00","billItemType":"COB_PREM"}]}]},{"customerAccountOptionId":"29196599","customerAccountOptionDescription":"ContractOptDescription-Dental-20210312014927","customerAccountOptionType":"12 Months","statusCode":"A","statusDescription":"Active","exchangeTypeDescription":"Non-Exchange","startDate":"2021-01-01","renewalDate":"2022-01-01","terminationDate":"2021-12-31","stateOfIssueCode":"CT","stateOfIssueDescription":"CONNECTICUT","enrollmentInsuringRulesPopulationIndicator":"false","defineOpenEnrollmentbyPopulationIndicator":"true","customerAccountGroupPopulation":[{}],"customerAccountInsuringRules":[{"dependentCutOff":"26","dependentCutOffType":"Date of Event","studentMaximumAge":"26","studentmaximumAgeType":"Date of Event","waiveRehiredIndefiniteIndicator":"true","waiveWaitingPeriodForNewHireIndicator":"true","waiveRehiredWithinCount":"1","waiveRehiredWithinType":"M","terminationLagType":"001","terminationLagDescription":"Date of Event","overrideRetroBenefitAddIndicator":"false","overrideRetroBenefitChangeIndicator":"false","overrideRetroBenefitTerminationIndicator":"false","insuringRuleEffectiveDates":"2021-01-01","insuringRuleExpirationDates":"2021-12-31","nonStandardWaitingPeriodIndicator":"false","waitingPeriodRules":[{"waitingPeriodType":"Specified Duration","waitingDurationType":"Months","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"Specified Duration","waitingDurationType":"Months","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"Specified Duration","waitingDurationType":"Days","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"First of the Following Month after Specified Duration","waitingDurationType":"Days","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"First of the Following Month after Specified Duration","waitingDurationType":"Months","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"First of the Following Month after Specified Duration","waitingDurationType":"Months","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"Specified Duration","waitingDurationType":"Days","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"Specified Duration","waitingDurationType":"Days","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Plan Change"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Re-enrollment"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Rehire"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Special Enrollment"},{"waitingPeriodType":"Specified Duration","waitingDurationType":"Days","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Adoption"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Benefit Selection"},{"waitingPeriodType":"First of the Following Month after Specified Duration","waitingDurationType":"Days","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Birth"},{"waitingPeriodType":"First of the Following Month","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"First of the Following Month after Specified Duration","waitingDurationType":"Days","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Consolidation Omnibus Budget Reconciliation Act (COBRA)"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Late Enrollee"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Marriage"}]}],"customerPurchase":[{"memberGroupContractPlanOptionID":"DN100001","planOptionDescription":"Plan Option 10252727","fundingArrangementCode":"01","fundingArrangementDescription":"Fully Insured","coverageStartDate":"2021-01-01","coverageExpirationDate":"2021-12-31","benefitBundleOptionID":"10252727","timePeriodQualifier":"Calender Year","benefitBasePlan":"1P364","benefitPlanDescription":"1P364_PPO_CICU.80","gatedProductIndicator":"0","hsaVendorId":"0","networkScheduleId":[null],"domesticPartnerIndicator":"false","benefitServiceArea":"UNITED_STATES","lineOfBusinessId":"2","carrierId":"36","bookOfBusinessTypeCode":"UH","bookOfBusinessTypeDescription":"UnitedHealthcare Insurance Company","contractOptionType":"DN","contractOptionTypeDescription":"Dental","benefitType":"DN","billingSchedule":[{"billingScheduleID":"BILLINGSCHEDULE_1003629_25134723","scheduleEffectiveDate":"2021-01-01","scheduleExpirationDate":"2021-12-31","ratingMethodology":"02","contractTypeCode":"4","contractTypeDescription":"F","amount":"20.20","flatRateAmt":"0.00","billItemType":"PREMIUM"},{"billingScheduleID":"BILLINGSCHEDULE_1003629_25134723","scheduleEffectiveDate":"2021-01-01","scheduleExpirationDate":"2021-12-31","ratingMethodology":"02","contractTypeCode":"3","contractTypeDescription":"PCH","amount":"20.20","flatRateAmt":"0.00","billItemType":"PREMIUM"},{"billingScheduleID":"BILLINGSCHEDULE_1003629_25134723","scheduleEffectiveDate":"2021-01-01","scheduleExpirationDate":"2021-12-31","ratingMethodology":"02","contractTypeCode":"2","contractTypeDescription":"C","amount":"20.20","flatRateAmt":"0.00","billItemType":"PREMIUM"},{"billingScheduleID":"BILLINGSCHEDULE_1003629_25134723","scheduleEffectiveDate":"2021-01-01","scheduleExpirationDate":"2021-12-31","ratingMethodology":"02","contractTypeCode":"1","contractTypeDescription":"S","amount":"20.20","flatRateAmt":"0.00","billItemType":"PREMIUM"},{"billingScheduleID":"BILLINGSCHEDULE_1003629_25134723","scheduleEffectiveDate":"2021-01-01","scheduleExpirationDate":"2021-12-31","ratingMethodology":"02","contractTypeCode":"4","contractTypeDescription":"F","amount":"20.20","flatRateAmt":"0.00","billItemType":"COB_PREM"},{"billingScheduleID":"BILLINGSCHEDULE_1003629_25134723","scheduleEffectiveDate":"2021-01-01","scheduleExpirationDate":"2021-12-31","ratingMethodology":"02","contractTypeCode":"3","contractTypeDescription":"PCH","amount":"20.20","flatRateAmt":"0.00","billItemType":"COB_PREM"},{"billingScheduleID":"BILLINGSCHEDULE_1003629_25134723","scheduleEffectiveDate":"2021-01-01","scheduleExpirationDate":"2021-12-31","ratingMethodology":"02","contractTypeCode":"2","contractTypeDescription":"C","amount":"20.20","flatRateAmt":"0.00","billItemType":"COB_PREM"},{"billingScheduleID":"BILLINGSCHEDULE_1003629_25134723","scheduleEffectiveDate":"2021-01-01","scheduleExpirationDate":"2021-12-31","ratingMethodology":"02","contractTypeCode":"1","contractTypeDescription":"S","amount":"20.20","flatRateAmt":"0.00","billItemType":"COB_PREM"}]}]},{"customerAccountOptionId":"29196600","customerAccountOptionDescription":"ContractOptDescription-Vision-20210312014927","customerAccountOptionType":"12 Months","statusCode":"I","statusDescription":"Inactive","exchangeTypeDescription":"Non-Exchange","startDate":"2021-01-01","renewalDate":"2022-01-01","terminationDate":"2021-12-31","stateOfIssueCode":"CT","stateOfIssueDescription":"CONNECTICUT","enrollmentInsuringRulesPopulationIndicator":"false","defineOpenEnrollmentbyPopulationIndicator":"true","customerAccountGroupPopulation":[{}],"customerAccountInsuringRules":[{"dependentCutOff":"26","dependentCutOffType":"Date of Event","studentMaximumAge":"26","studentmaximumAgeType":"Date of Event","waiveRehiredIndefiniteIndicator":"true","waiveWaitingPeriodForNewHireIndicator":"true","waiveRehiredWithinCount":"1","waiveRehiredWithinType":"M","terminationLagType":"001","terminationLagDescription":"Date of Event","overrideRetroBenefitAddIndicator":"false","overrideRetroBenefitChangeIndicator":"false","overrideRetroBenefitTerminationIndicator":"false","insuringRuleEffectiveDates":"2021-01-01","insuringRuleExpirationDates":"2021-12-31","nonStandardWaitingPeriodIndicator":"false","waitingPeriodRules":[{"waitingPeriodType":"Specified Duration","waitingDurationType":"Months","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"Specified Duration","waitingDurationType":"Months","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"Specified Duration","waitingDurationType":"Days","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"First of the Following Month after Specified Duration","waitingDurationType":"Days","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"First of the Following Month after Specified Duration","waitingDurationType":"Months","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"First of the Following Month after Specified Duration","waitingDurationType":"Months","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"Specified Duration","waitingDurationType":"Days","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"Specified Duration","waitingDurationType":"Days","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Plan Change"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Re-enrollment"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Rehire"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Special Enrollment"},{"waitingPeriodType":"Specified Duration","waitingDurationType":"Days","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Adoption"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Benefit Selection"},{"waitingPeriodType":"First of the Following Month after Specified Duration","waitingDurationType":"Days","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Birth"},{"waitingPeriodType":"First of the Following Month","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"First of the Following Month after Specified Duration","waitingDurationType":"Days","qualifyingEvent":"Initial Enrollment"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Consolidation Omnibus Budget Reconciliation Act (COBRA)"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Late Enrollee"},{"waitingPeriodType":"Date of Event","qualifyingEvent":"Marriage"}]}],"customerPurchase":[{"memberGroupContractPlanOptionID":"VS100001","planOptionDescription":"Plan Option 10293468","fundingArrangementCode":"01","fundingArrangementDescription":"Fully Insured","coverageStartDate":"2021-01-01","coverageExpirationDate":"2021-12-31","benefitBundleOptionID":"10293468","timePeriodQualifier":"Calender Year","benefitBasePlan":"V1074","benefitPlanDescription":"V1074_100% ER Paid","gatedProductIndicator":"0","hsaVendorId":"0","networkScheduleId":[null],"domesticPartnerIndicator":"false","benefitServiceArea":"UNITED_STATES","lineOfBusinessId":"2","carrierId":"36","bookOfBusinessTypeCode":"ER","contractOptionType":"VS","contractOptionTypeDescription":"Vision","benefitType":"VS","billingSchedule":[{"billingScheduleID":"BILLINGSCHEDULE_1004278_25216025","scheduleEffectiveDate":"2021-01-01","scheduleExpirationDate":"2021-12-31","ratingMethodology":"02","contractTypeCode":"3","contractTypeDescription":"PCH","amount":"330.20","flatRateAmt":"0.00","billItemType":"PREMIUM"},{"billingScheduleID":"BILLINGSCHEDULE_1004278_25216025","scheduleEffectiveDate":"2021-01-01","scheduleExpirationDate":"2021-12-31","ratingMethodology":"02","contractTypeCode":"2","contractTypeDescription":"C","amount":"270.20","flatRateAmt":"0.00","billItemType":"PREMIUM"},{"billingScheduleID":"BILLINGSCHEDULE_1004278_25216025","scheduleEffectiveDate":"2021-01-01","scheduleExpirationDate":"2021-12-31","ratingMethodology":"02","contractTypeCode":"4","contractTypeDescription":"F","amount":"350.20","flatRateAmt":"0.00","billItemType":"PREMIUM"},{"billingScheduleID":"BILLINGSCHEDULE_1004278_25216025","scheduleEffectiveDate":"2021-01-01","scheduleExpirationDate":"2021-12-31","ratingMethodology":"02","contractTypeCode":"1","contractTypeDescription":"S","amount":"240.20","flatRateAmt":"0.00","billItemType":"PREMIUM"}]}]}]}]}}}');
                                                  Response.setStatusCode(500); 
                             }
                             else{
                                 Response = wsCallOutFW.getResponse();
                             }
            String responseStr = Response!=null?Response.getBody():'';
            oACETWSCalloutResult.statusCode=Response!=null?Response.getStatusCode():null;
            
            if (Response!=null && Response.getStatusCode() == 200)
            {
                oACETWSCalloutResult.Success = true;
                oACETWSCalloutResult.Message = '';
                ACETGetEmployerDetailAdapterWebService aws = new ACETGetEmployerDetailAdapterWebService();
                oACETWSCalloutResult.Response = parseSuccessAdapterResponse(aws.ReplaceKeywords(Response.getBody()));  
            }
            else
            {
                oACETWSCalloutResult = ParseFailureResponse(Response);   
                oACETWSCalloutResult.statusCode=response!=null?response.getStatusCode():null;
            } 
                             }
        catch(Exception ex)
        {
            system.debug(LoggingLevel.INFO, 'Exception in GetEmployer. Details: ' + ex + ex.getLineNumber() +ex.getMessage()); 
            oACETWSCalloutResult.Success = false;
            oACETWSCalloutResult.Message = ex.getMessage();
            oACETWSCalloutResult.MessageSeverity = ApexPages.Severity.ERROR;
            oACETWSCalloutResult.statusCode=999;

        }    

        system.debug('oACETWSCalloutResult: ' + oACETWSCalloutResult);        
        return oACETWSCalloutResult;
    }   

    
    public virtual ACETWSCalloutResult ParseFailureResponse(HttpResponse FailureResponse)   {
        ACETWSCalloutResult oACETWSCalloutResult = new ACETWSCalloutResult();
        oACETWSCalloutResult.Success = false;
        oACETWSCalloutResult.MessageSeverity = ApexPages.Severity.ERROR;
        try {
            Map<String, Object> mapRootNode = (Map<String, Object>)JSON.deserializeUntyped(FailureResponse.getBody());
            if (FailureResponse.getStatusCode() == 500 &&
                (mapRootNode.containsKey('ErrorCode') && mapRootNode.containsKey('Advice'))) {
                    //Parse failure repsonse from ISL
                    oACETWSCalloutResult.Message = Label.ACETUnexpectedErrorMessage;
                } else {
                    //Parse failure response from OIL
                    Map<String, Object> mapErrors = (Map<String, Object>)mapRootNode.values().get(0);
                    system.debug('Map Errors:' + mapErrors);
                    List<Object> lstErrors = (List<Object>)mapErrors.get('errors');
                    system.debug('List Errors:' + lstErrors);
                    if (lstErrors == null) {
                        Map<String, Object> mapTypeNode = (Map<String, Object>)mapErrors.values().get(0);
                        lstErrors = (List<Object>)mapTypeNode.get('errors');
                        system.debug('List Errors 2:' + lstErrors);
                    }
                    Map<String, Object> mapError;
                    String ErrorDescription;
                    if(lstErrors != null) {
                        for (Object oError :lstErrors) {
                            mapError = (Map<String, Object>)oError;
                            system.debug('Error: ' + mapError);
                            ErrorDescription = String.valueOf(mapError.get('description'));
                            if (String.isBlank(oACETWSCalloutResult.Message)) {
                                oACETWSCalloutResult.Message = ErrorDescription;
                            } else {
                                if (oACETWSCalloutResult.Message.length() + ErrorDescription.length() <= 255) {
                                    oACETWSCalloutResult.Message += '; ' + ErrorDescription;
                                } else {
                                    break;
                                }
                            }
                        }
                    }
                }
        }
        catch(Exception ex)
        {
            system.debug(LoggingLevel.INFO, 'Error serializing error response JSON. Details: ' + ex);
            oACETWSCalloutResult.Message = FailureResponse.getBody();
        }
        
        return oACETWSCalloutResult;
    }
    
    
}