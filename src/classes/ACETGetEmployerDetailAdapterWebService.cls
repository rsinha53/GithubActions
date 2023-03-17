public class ACETGetEmployerDetailAdapterWebService extends ACETWebService{
    
    public ACETGroupDetail oACETGroupDetail;
    public Integer numberDays{get;set;}
    private string taxid, classinclude,planClass,insured,networkId,firstName,middleName,lastName,grpHoldcode,population,OriginalContractDate,addrType ;
    public ACETGroupDetail.groupContactInfo billingInfo = new ACETGroupDetail.groupContactInfo();
    public String returningFromService;
    public Map<String,String> codeVsOnshoreIndicator;
    private integer i;
    String maxDateString = '12/31/9999';
                      
    public override void getEndpoint(){
        GetEndpointDetail('GetEmployerGroupEndpoint');
    }
    public ACETGetEmployerDetailAdapterWebService() {
        if(!Test.isRunningTest())
            super('Stargate');
    }
    public void getRequestBody(String groupNumber){
        system.debug('Group Number========>'+groupNumber);
        RequestBody = '{"getEmployerGroup":{"getEmployerGroupRequest":{"groupNumber":"'+groupNumber+'"}}}';       
    
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
         
       ACETGetEmployerGroupAdapterJSON2Apex ACETEGDJSON2Apex = (ACETGetEmployerGroupAdapterJSON2Apex)JSON.deserialize(ResponseBody, ACETGetEmployerGroupAdapterJSON2Apex.class);
       system.debug('ACETEGDJSON2Apex --->'+ACETEGDJSON2Apex);
       EGDetails = ACETEGDJSON2Apex.GetEmployerGroup.GetEmployerGroupResponse.EmployerGroup;
       
	if(EGDetails!=null){
            oACETGroupDetail.isChildPEO = EGDetails.organizationRelationshipTypeCode=='PEO';
        if(oACETGroupDetail.isChildPEO){
            oACETGroupDetail.parentPEOId = EGDetails.parentGroup.Id;
        }
        }
       
       generalGroupInfoMapping(EGDetails);
       groupEmployeeCountMapping(EGDetails);
       groupAddressMapping(EGDetails);
       groupContactInfoMapping(EGDetails);
       groupInsuringRulesMapping(EGDetails);      //getemp V3
       groupContractVersioningMapping(EGDetails);  //getemp V3  // Combining Policy Contract,Insuring Rules and Benefits 
       
       return oACETGroupDetail;     
    
    }
    
    //getemp V3 starts
    private void groupInsuringRulesMapping(ACETGetEmployerGroupAdapterJSON2Apex.EmployerGroup EGDetails) {
        if(EGDetails.GroupInsuringRules != null){
             for(ACETGetEmployerGroupAdapterJSON2Apex.GroupInsuringRules ins: EGDetails.GroupInsuringRules ) {
                    ACETGroupDetail.GroupInsuringRules rule = new ACETGroupDetail.GroupInsuringRules();
                    rule.classesCode = (ins.classesCode != null)?ins.classesCode.replace(',',''):'';
                    rule.cobraAdministrativeIndicator = (ins.cobraAdministrativeIndicator!=null)?ins.cobraAdministrativeIndicator:'';
                    rule.continuationResponsibilityType = (ins.continuationResponsibilityType!=null)?ins.continuationResponsibilityType :'' ;
                    rule.insuranceContinuationType = (ins.insuranceContinuationType!=null)?ins.insuranceContinuationType:'' ;
                    rule.onshoreRestriction = (ins.onshoreRestriction!= null)?ins.onshoreRestriction :'' ;
                    //rule.insuringRulesEffectiveDates = (ins.insuringRulesEffectiveDates != Null)?string.valueOf(Date.valueOf(ins.insuringRulesEffectiveDates ).format()):'';
                    rule.insuringRulesEffectiveDates = (ins.insuringRulesEffectiveDates != Null)?string.valueOf(ACETUtility.format(Date.valueOf(ins.insuringRulesEffectiveDates ))):''; // Gabe Grimley: ICU Date Format Changes US3687557
                    //rule.insuringRulesExpirationDates = (ins.insuringRulesExpirationDates != Null)?string.valueOf(Date.valueOf(ins.insuringRulesExpirationDates).format()):'12/31/9999';
                    rule.insuringRulesExpirationDates = (ins.insuringRulesExpirationDates != Null)?string.valueOf(ACETUtility.format(Date.valueOf(ins.insuringRulesExpirationDates))):maxDateString; // Gabe Grimley: ICU Date Format Changes US3687557
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
    }
    
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
                                
                          if(ACETViewEmployerGroupController.planOptionIds==null ||  !ACETViewEmployerGroupController.planOptionIds.contains(custPurch.memberGroupContractPlanOptionID)){  
                                if(pc.policyOptId == ''){
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
                              	// US3584879 Start : Added by Manish
                                pc.bookOfBusinessTypeCode = '';
                                pc.bookOfBusinessTypeDesc = '';
                                if(String.isNotBlank(custPurch.bookOfBusinessTypeCode) && String.isNotBlank(custPurch.bookOfBusinessTypeDescription) 
                                 && custPurch.lineOfBusiness != null && custPurch.lineOfBusiness.size() > 0 &&  String.isNotBlank(custPurch.lineOfBusiness[0].name))
                                {
                                  pc.bookOfBusinessTypeCode = custPurch.bookOfBusinessTypeCode;
                                  pc.bookOfBusinessTypeDesc = custPurch.bookOfBusinessTypeDescription + ' ' + custPurch.lineOfBusiness[0].name; 
                                }
                              	// US3584879 End 
                                pc.GroupPlanBenefitList.add(groupPlanCustomerAcc);                    
                                
                            }
                        }   
                      }
                        String todayDate = Date.Today().year() + '-' + Date.Today().month() + '-' + Date.Today().day();
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
                        }
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
                                        //Commmented for US1589796   
                                        /*if(rul.waiveWaitingPeriodForNewHireIndicator == 'true'){
                                            insRuleItem.insRulesDesc = 'Effective Immediately';
                                        } */
                                       // else {    
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
                                                    insRuleItem.insRulesDesc = 'No';
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
                          if(pc.policyOptId!=''){                              
                              oACETGroupDetail.polContract.add(pc);   
                          }                 
                    }
                  } 
                }
            
             }
        }
    }
    //getemp V3 ends
    
    //Mapping General Group Info Section
    private void generalGroupInfoMapping(ACETGetEmployerGroupAdapterJSON2Apex.EmployerGroup EGDetails)
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
                
            //US2810030 end
            /*if(EGDetails.alphaParentGroup!= Null && EGDetails.alphaParentGroup.name != null && oACETGroupDetail.genGroupInfo.groupName == EGDetails.alphaParentGroup.name){
              oACETGroupDetail.genGroupInfo.parentGroup = 'N/A';
              oACETGroupDetail.genGroupInfo.alphaParentGroup = 'N/A';
   
            }else if(EGDetails.alphaParentGroup!= Null && EGDetails.alphaParentGroup.name != null && EGDetails.parentGroup!= Null && EGDetails.parentGroup.name != null && oACETGroupDetail.genGroupInfo.groupName == EGDetails.parentGroup.name){
                     oACETGroupDetail.genGroupInfo.parentGroup = EGDetails.parentGroup.id +' - '+EGDetails.parentGroup.name ;
                    oACETGroupDetail.genGroupInfo.alphaParentGroup = EGDetails.alphaParentGroup.id +' - '+EGDetails.alphaParentGroup.name ;
            }
            else if(EGDetails.alphaParentGroup!= Null && EGDetails.alphaParentGroup.name == null && EGDetails.parentGroup!= Null && EGDetails.parentGroup.name != null && oACETGroupDetail.genGroupInfo.groupName == EGDetails.parentGroup.name){
                     oACETGroupDetail.genGroupInfo.parentGroup = 'N/A';
                    oACETGroupDetail.genGroupInfo.alphaParentGroup = 'N/A' ;
            }*/
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
    
    }    
        
    // Mapping Attestations sections 
    private void groupEmployeeCountMapping(ACETGetEmployerGroupAdapterJSON2Apex.EmployerGroup EGDetails)
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
        
    }
    
    // Mapping Address Section
    private void groupAddressMapping(ACETGetEmployerGroupAdapterJSON2Apex.EmployerGroup EGDetails)
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
                /*Uncommented by Vishkaha for Communication call topic want Group Separate Data -START*/
                addressInfo.addrLine1  = addEGC.addressLine1;
                addressInfo.addrLine2  = (addEGC.addressLine2 != Null && addEGC.addressLine2 != '')?addEGC.addressLine2:''; 
                addressInfo.city  = addEGC.addressCity;
                addressInfo.zip  = addEGC.addressPostalCode;
                addressInfo.state = addEGC.addressStateCode;
                /*Uncommented by Vishkaha for Communication call topic want Group Separate Data -END*/
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
    }
  
  
    private void groupContactInfoMapping(ACETGetEmployerGroupAdapterJSON2Apex.EmployerGroup EGDetails)
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
                        //	US2909463 START
                        if(contactData.endDate != null){
                        Date eDate = Date.valueOf(contactData.endDate);
                        contactData.endDate = eDate.month() + '/' + eDate.day() + '/' + eDate.year();
                        }else{
                         contactData.endDate= maxDateString;
                        }
                        // 	US2909463 END
                        adminInfo.firstName = (contactData.firstName != Null)?contactData.firstName:adminInfo.firstName;
                        adminInfo.LastName = (contactData.lastName != Null)?contactData.lastName:adminInfo.LastName;
                        adminInfo.middleName = (contactData.middleName != Null)?contactData.middleName:adminInfo.middleName;
                        
                        adminInfo.startDate = (contactData.assignmentStartDate != Null)?String.valueof(Date.valueOf(contactData.assignmentStartDate).format()):adminInfo.startDate;
                        adminInfo.endDate = (contactData.endDate != Null)?contactData.endDate:adminInfo.endDate; //	US2909463
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
                       System.debug('sam--------------------------------------------------'+Date.today()+'-----'+DateTime.newInstance(integer.valueof(contactData.endDate.split('/')[2]),integer.valueof(contactData.endDate.split('/')[0]),integer.valueof(contactData.endDate.split('/')[1]), 0, 0, 0));

                        if(contactData.assignmentEndDate != Null && contactData.assignmentStartDate != Null && date.today().daysBetween(Date.valueOf(contactData.assignmentEndDate)) >= 0 &&  (Date.valueOf(contactData.assignmentStartDate).daysBetween(date.today()) >= 0 || date.today().daysBetween(Date.valueOf(contactData.assignmentStartDate)) >= 0) && DateTime.newInstance(integer.valueof(contactData.endDate.split('/')[2]),integer.valueof(contactData.endDate.split('/')[0]),integer.valueof(contactData.endDate.split('/')[1]), 0, 0, 0) >= Date.today())
                        {
                            adminInfo.activeStatus = 'Y'; 
                            adminInfo.startDate = Date.valueOf(contactData.assignmentStartDate).format();
                            adminInfo.endDate =  contactData.endDate; // 	US2909463
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
                            if(contactData.assignmentEndDate != Null && contactData.assignmentStartDate != Null && DateTime.newInstance(integer.valueof(contactData.endDate.split('/')[2]),integer.valueof(contactData.endDate.split('/')[0]),integer.valueof(contactData.endDate.split('/')[1]), 0, 0, 0) <= Date.today()){
                            adminInfo.activeStatus = 'N'; 
                            adminInfo.startDate = Date.valueOf(contactData.assignmentStartDate).format();
                            adminInfo.endDate = contactData.endDate; //	US2909463
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
    }
    //Please don't remove this code. It is using in group plan controller - divya    
    public ACETWSCalloutResult getEmployerGroupDetail(string groupNumber){
        ACETWSCalloutResult oACETWSCalloutResult = new ACETWSCalloutResult();
        ACETGroupDetail oACETGroupDetail;
        
   try
       {
            
                HttpResponse Response;
                GetEndpoint();
                GetRequestBody(groupNumber);
                Response = Send(OAuthConfig);
                //Response.setStatusCode(400);
              system.debug('Response----->'+Response);
            /*StaticResource GetDummyResp = [SELECT Body FROM StaticResource WHERE Name = 'Test_GetEmpResponse'];
            String GetEmpGrpRes = GetDummyResp.Body.toString();
            system.debug('@@@Custom Response'+GetEmpGrpRes);*/
            //oACETWSCalloutResult.Response = parseSuccessAdapterResponse(ReplaceKeywords(GetEmpGrpRes));  
             oACETWSCalloutResult.statusCode=response!=null?response.getStatusCode():null;
 
            if (Response.getStatusCode() == 200)
            {
                oACETWSCalloutResult.Success = true;
                oACETWSCalloutResult.Message = '';
                oACETWSCalloutResult.Response = parseSuccessAdapterResponse(ReplaceKeywords(Response.getBody()));  
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
    
    public Continuation StartRequest(string groupNumber, String CallbackMethodName, Continuation oContinuation)
    {
        
            HttpResponse Response;
            GetEndpoint();
            GetRequestBody(groupNumber);
            oContinuation = AddHttpRequest(OAuthConfig, CallbackMethodName, oContinuation);
            Long dt1Long = DateTime.now().getTime();
            system.debug('date11111111111111'+dt1Long);
        
  
        return oContinuation;         
    }
    public ACETWSCalloutResult ProcessResponse(String HttpRequestLabel, ACETMemberDetail memberDetail) {
        
        ACETWSCalloutResult oACETWSCalloutResult = new ACETWSCalloutResult();
        try {
            HttpResponse Response = GetHttpResponse(HttpRequestLabel);
            oACETWSCalloutResult.statusCode=response!=null?response.getStatusCode():null;
            //Response.setStatusCode(500);
            if (Response.getStatusCode() == 200) {
              String responseBody = response.getBody();
              if(!String.isEmpty(responseBody)){
                  System.debug('Try Here '+responseBody);
                  ACETGetEmployerGroupAdapterJSON2Apex.EmployerGroup EGDetails;
                  ACETGetEmployerGroupAdapterJSON2Apex ACETEGDJSON2Apex = (ACETGetEmployerGroupAdapterJSON2Apex)JSON.deserialize(responseBody, ACETGetEmployerGroupAdapterJSON2Apex.class);
                  System.debug('TestContinuation1 here1 ' + ACETEGDJSON2Apex);
                  System.debug('TestContinuation1 here2 ' + ACETEGDJSON2Apex.GetEmployerGroup);
                  System.debug('TestContinuation1 here3 ' + ACETEGDJSON2Apex.GetEmployerGroup.GetEmployerGroupResponse);
                  
                  List<ACETMemberDetail.customerPurchaseinfo> custinfolist = new List<ACETMemberDetail.customerPurchaseinfo>();
                  //DE469102 Start
                  custinfolist.addall(MemberDetail.membershipCustInfoList); 
                  MemberDetail.listcustinfo = new List<ACETMemberDetail.customerPurchaseinfo>();
                  //DE469102 End
                  if(ACETEGDJSON2Apex != null && ACETEGDJSON2Apex.GetEmployerGroup != null && ACETEGDJSON2Apex.GetEmployerGroup.GetEmployerGroupResponse != null){
                      EGDetails = ACETEGDJSON2Apex.GetEmployerGroup.GetEmployerGroupResponse.EmployerGroup;
                      if(EGDetails != null){
		      	   if(EGDetails.organizationRelationshipTypeCode != Null && 'PEO'.equals(EGDetails.organizationRelationshipTypeCode)
                             && EGDetails.parentGroup!= Null ){
                              memberDetail.parentPEOId = EGDetails.parentGroup.Id;
                          }
                          
            //US2874415 START
                          if(EGDetails.alphaParentGroup!= Null && EGDetails.alphaParentGroup.name != null &&EGDetails.parentGroup!= Null && EGDetails.parentGroup.name != null){
                              memberDetail.parentGroup = EGDetails.parentGroup.id +' - '+EGDetails.parentGroup.name ;
                              memberDetail.alphaParentGroup = EGDetails.alphaParentGroup.id +' - '+EGDetails.alphaParentGroup.name ;
                          }else{
                              memberDetail.parentGroup = 'N/A';
                              memberDetail.alphaParentGroup = 'N/A';
                          }
			  //US2874415 END
                      if(memberDetail.PreferredCoverage != null){
                           system.debug('%%%pref coverage benefit'+memberDetail.PreferredCoverage.BenefitPlanId );
                           system.debug('%%%pref coverage benefit'+memberDetail.BenefitPlanId );
                           system.debug('%%%pref coverage '+memberDetail.PreferredCoverage);
                                            
                           // getEmp V3 changes for Member side
                           // To select the contract option Id from Benefit Plan Id and Bundle option Id from Coverage selected
                           if(EGDetails.CustomerAccount == null || EGDetails.CustomerAccount.isEmpty() || EGDetails.CustomerAccount.size() == 0){
                                //oACETGroupDetail.noCustomerAccount = true;
                           } else {
                                //oACETGroupDetail.noCustomerAccount = false;
                                for(ACETGetEmployerGroupAdapterJSON2Apex.CustomerAccount acc: EGDetails.customerAccount) {
                                    System.debug('Made it here!!!!' + acc);
                                    if(acc.customerAccountOption != null){
                                    
                                        for(ACETGetEmployerGroupAdapterJSON2Apex.CustomerAccountOption accopt: acc.customerAccountOption) {
                                          Date newCovEffDate = Date.newInstance(Integer.valueOf(memberDetail.custPurchaseinfo.benefitEffectivedate.split('/')[2]), Integer.valueOf(memberDetail.custPurchaseinfo.benefitEffectivedate.split('/')[0]), Integer.valueOf(memberDetail.custPurchaseinfo.benefitEffectivedate.split('/')[1]));// US2962032 : updting pcdates with benefit effective and enddates  
                                          Date newCovEndDate = Date.newInstance(Integer.valueOf(memberDetail.custPurchaseinfo.benefitEnddate.split('/')[2]), Integer.valueOf(memberDetail.custPurchaseinfo.benefitEnddate.split('/')[0]), Integer.valueOf(memberDetail.custPurchaseinfo.benefitEnddate.split('/')[1]));
                                          String currentDate = Date.Today().year() + '-' + Date.Today().month() + '-' + Date.Today().day();
                                          system.debug('%%%current date'+currentDate);
                                          set<ACETMemberDetail.customerPurchaseinfo> setcustinfo = new set<ACETMemberDetail.customerPurchaseinfo>();
                                          for(ACETMemberDetail.customerPurchaseinfo cust :custinfolist){
                                        for(ACETGetEmployerGroupAdapterJSON2Apex.customerPurchase custPurch: accopt.customerPurchase){
              
                                              ACETMemberDetail.customerPurchaseinfo cu = new ACETMemberDetail.customerPurchaseinfo();
                                            if(cust.planOptionId == custPurch.memberGroupContractPlanOptionID && ACETUtility.formatDateFromDashToSlash(custPurch.coverageExpirationDate) ==cust.contractOptionExpiryDate && ACETUtility.formatDateFromDashToSlash(custPurch.coverageStartDate) ==cust.contractOptionEffectiveDate){
                                               cu.benefitBundleOptionId = custPurch.benefitBundleOptionID; 
                                               cu.contractOptionEffectiveDate = cust.contractOptionEffectiveDate;
                                               cu.contractOptionExpiryDate = cust.contractOptionExpiryDate;
                                               cu.groupNumber = cust.groupNumber;
                                               cu.customerPurchaseIdentifier = cust.customerPurchaseIdentifier;
                                               setcustinfo.add(cu);
                                            }
                                        }
                                        }  
                                           MemberDetail.listcustinfo.addall(setcustinfo);
                                            /* ******************************************************************************************
                                             Below logic is to pick single contract option version even if plans are same among the versions 
                                             or different options
                                            Filter criteria:
                                            [Active version] and (Active Coverage)||(Termed Coverage)||(Future Coverage)
                                            *******************************************************************************************/
                                          // Filter not working - termed contract is getting pulled for active coverage
                                          System.debug('%%%%%%% '+accopt.statusDescription+':Active,'+Date.valueOf(accopt.startDate)+'<='+Date.valueOf(newCovEffDate)+','+Date.valueOf(newCovEffDate)+'<='+Date.valueOf(currentDate)+','+Date.valueOf(currentDate)+'<='+Date.valueOf(accopt.terminationDate)+','+Date.valueOf(accopt.terminationDate)+'<='+Date.valueOf(newCovEndDate)+',OR '+Date.valueOf(accopt.startDate)+'<='+Date.valueOf(newCovEndDate )+','+Date.valueOf(newCovEndDate)+'<='+Date.valueOf(accopt.terminationDate)+',OR '+Date.valueOf(accopt.startDate)+'<='+ Date.valueOf(newCovEffDate )+','+Date.valueOf(newCovEffDate)+'<='+Date.valueOf(accopt.terminationDate));
                                          if(accopt.statusDescription  == 'Active' && ((Date.valueOf(accopt.startDate) <= Date.valueOf(newCovEffDate) && Date.valueOf(newCovEffDate) <= Date.valueOf(currentDate) &&  Date.valueOf(currentDate) <= Date.valueOf(accopt.terminationDate) && Date.valueOf(accopt.terminationDate)>= Date.valueOf(newCovEndDate))||(Date.valueOf(accopt.startDate)<= Date.valueOf(newCovEndDate ) && Date.valueOf(newCovEndDate)<=Date.valueOf(accopt.terminationDate))||(Date.valueOf(accopt.startDate)<= Date.valueOf(newCovEffDate ) && Date.valueOf(newCovEffDate)<=Date.valueOf(accopt.terminationDate)&& Date.valueOf(newCovEndDate)<=Date.valueOf(accopt.terminationDate)))){
                                            system.debug('%%% Active version of coverage selected%%%%');
                                            if(accopt.customerPurchase != null){
                                                for(ACETGetEmployerGroupAdapterJSON2Apex.customerPurchase custPurch: accopt.customerPurchase){
						    if( ((custPurch.contractOptionType=='DN' && custPurch.benefitType=='DN') ||
                                                                                      (custPurch.contractOptionType=='VS' && custPurch.benefitType=='VS'))){break;}
                                                    system.debug('%%%% benefit plan and bundle '+custPurch.benefitBundleOptionID +':null,'+custPurch.benefitBasePlan+':null,'+custPurch.benefitBundleOptionID+':'+MemberDetail.BundleOptionID+','+custPurch.benefitBasePlan+':'+MemberDetail.BenefitPlanId);
                                                    system.debug('memberGroupContractPlanOptionID--->'+custPurch);
                                   if(custPurch.memberGroupContractPlanOptionID != null && custPurch.memberGroupContractPlanOptionID == memberDetail.custPurchaseinfo.planOptionId){ // US2962032 update replaced BundleOptionID check with planOptionId to sync with lighting 
                                                        system.debug('%%%% benefit plan and bundle matched%%%%');
                                                        //if(accopt.statusDescription  == 'Active' && ((Date.valueOf(newCovEffDate)<= Date.valueOf(currentDate) && Date.valueOf(newCovEndDate)>= Date.valueOf(currentDate))||(Date.valueOf(accopt.startDate)<= Date.valueOf(newCovEndDate ) && Date.valueOf(newCovEndDate)<=Date.valueOf(accopt.terminationDate))||(Date.valueOf(accopt.startDate)<= Date.valueOf(newCovEffDate ) && Date.valueOf(newCovEffDate)<=Date.valueOf(accopt.terminationDate)))){
                                          
                                                        
                                                        //String currentDate = Date.Today().year() + '-' + Date.Today().month() + '-' + Date.Today().day();
                                                        
                                                        if(accopt.startDate != null && (Date.valueOf(accopt.startDate) > Date.valueOf(currentDate))){ 
                                                            memberDetail.coverageGroupContractOptionFilterStatus = 'Future';
                                                        } else if(accopt.terminationDate != null && (Date.valueOf(accopt.terminationDate) < Date.valueOf(currentDate))){
                                                            memberDetail.coverageGroupContractOptionFilterStatus = 'Termed';
                                                        } else if(accopt.startDate != null && accopt.terminationDate != null && (Date.valueOf(accopt.startDate) <= Date.valueOf(currentDate) && Date.valueOf(accopt.terminationDate) >= Date.valueOf(currentDate))){
                                                            memberDetail.coverageGroupContractOptionFilterStatus = 'Active';
                                                        }
                                                        
                                                        if(custPurch.gatedProductIndicator != Null && custPurch.gatedProductIndicator != ''){
                                                            memberDetail.gatedPlanIndicator = custPurch.gatedProductIndicator == '0'? 'No':'Yes';
                                                        }
                                                        
                                                        memberDetail.coverageGroupContractOptionId = (accopt.customerAccountOptionId != null)?accopt.customerAccountOptionId:'';
                                                        memberDetail.coverageGroupContractOptionEffDate = (accopt.startDate != null)?string.valueOf(Date.valueOf(accopt.startDate).format()):'';
                                                        //COntract Option status
                                                        memberDetail.coverageGroupContractOptionStatus = (accopt.statusDescription!= null)?accopt.statusDescription:'';
                                                        memberDetail.exchangeType = (accopt.exchangeTypeDescription != null)?accopt.exchangeTypeDescription:'';     //US1744309
                                                        memberDetail.exchangeState = (accopt.stateOfIssueCode != null)?accopt.stateOfIssueCode:''; //US1744309
                                       			        // US3584877 Start : Added by Manish
                                       			        memberDetail.bookOfBusinessTypeCode = '';
                                                        memberDetail.bookOfBusinessTypeDesc = '';
                                                        if(String.isNotBlank(custPurch.bookOfBusinessTypeCode) && String.isNotBlank(custPurch.bookOfBusinessTypeDescription) 
                                                           && custPurch.lineOfBusiness != null && custPurch.lineOfBusiness.size() > 0 &&  String.isNotBlank(custPurch.lineOfBusiness[0].name))
                                                        {
                                                            memberDetail.bookOfBusinessTypeCode = custPurch.bookOfBusinessTypeCode;
                                                            memberDetail.bookOfBusinessTypeDesc = custPurch.bookOfBusinessTypeDescription + ' ' + custPurch.lineOfBusiness[0].name; 
                                                        }
                                       			        System.debug('Level Funded ---> ' +memberDetail.bookOfBusinessTypeCode + ' : ' + memberDetail.bookOfBusinessTypeDesc);
                                       			        // US3584877 End
                                                        if(accopt.customerAccountGroupPopulation != null && accopt.customerAccountGroupPopulation.size()>0){
                                                            population='';
                                                            for(ACETGetEmployerGroupAdapterJSON2Apex.CustomerAccountGroupPopulation gp:accopt.customerAccountGroupPopulation){
                                                                if(population == ''){
                                                                    population = (gp.classesDescription != null)?gp.classesDescription.replace(',',''):'';
                                                                } else {
                                                                    population = population + ', ' + ((gp.classesDescription != null)?gp.classesDescription.replace(',',''):'');
                                                                }   
                                                                if(population !=''){
                                                                    memberdetail.hasPopulation = true;
                                                                    memberdetail.contractOptionPopulations = population;
                                                                } 
                                                                else{
                                                                    memberdetail.hasPopulation = false;
                                                                    memberdetail.contractOptionPopulations = '';
                                                                }
                                                            } 
                                                            system.debug('&&& hasPopulation ' + memberDetail.hasPopulation + ', population ' + population);
                                                        }
                                                        else
                                                        {
                                                            memberdetail.hasPopulation = false;
                                                        }
                                                        
                                                        system.debug('%%%%%%%% memberdetail.hasPopulation'+memberdetail.hasPopulation);
                                                                                        
                                                        memberDetail.SitusState = (accopt.stateOfIssueCode != null)?accopt.stateOfIssueCode:'';
                                                        memberDetail.FundingArragement = (custPurch.fundingArrangementDescription != Null)?custPurch.fundingArrangementDescription:'';
                                                        system.debug('%%%Inside Member Contract Option Id'+memberDetail.coverageGroupContractOptionId+ '  ' +memberDetail.FundingArragement);
                                                        
                                                        // Group Insuring Rules for Contract Option
                                                        if(EGDetails.GroupInsuringRules != null){
                                                              memberDetail.PreferredCoverage.onshoreRestrictionCode = '';
                                                              //memberDetail.PreferredCoverage.OnshoreRestriction = '';
                                                              memberDetail.PreferredCoverage.OnshoreRestrictionVerbiage ='';
                                                              memberDetail.PreferredCoverage.OnshoreRestrictionError = false;
                                                              memberdetail.responsibilityType ='';
                                                              memberdetail.continuationType ='';
                                                              Set<String> onshoreRest_lst = new Set<String>();
                                                                            
                                                              for(ACETGetEmployerGroupAdapterJSON2Apex.GroupInsuringRules ins: EGDetails.GroupInsuringRules ) {
                                                                system.debug('%%%Member preferred coverage'+memberDetail.PreferredCoverage.EffectiveDate + ' '+memberDetail.PreferredCoverage.EndDate);  
                                                                system.debug('%%%Member preferred coverage ins'+ins.insuringRulesEffectiveDates+ ' '+ins.insuringRulesExpirationDates);  
                                                                
                                                                Date newEffectiveDate = Date.newInstance(Integer.valueOf(memberDetail.custPurchaseinfo.benefitEffectivedate.split('/')[2]), Integer.valueOf(memberDetail.custPurchaseinfo.benefitEffectivedate.split('/')[0]), Integer.valueOf(memberDetail.custPurchaseinfo.benefitEffectivedate.split('/')[1]));//US2962032 updates 
                                                                Date newEndDate = Date.newInstance(Integer.valueOf(memberDetail.custPurchaseinfo.benefitEnddate.split('/')[2]), Integer.valueOf(memberDetail.custPurchaseinfo.benefitEnddate.split('/')[0]), Integer.valueOf(memberDetail.custPurchaseinfo.benefitEnddate.split('/')[1]));
                                                                system.debug('%%%Member preferred coverage dates fomatted'+memberDetail.PreferredCoverage.EffectiveDate + ' '+memberDetail.PreferredCoverage.EndDate);  
                                                    
                                                               system.debug('%%%%%%%% group ins rules memberdetail.hasPopulation'+memberdetail.hasPopulation +';;;'+population);
                                                    
                                                               // Below condition is to check when multiple populations are assigned to a contract option
                                                               //if(memberdetail.hasPopulation && ins.classesCode != null && population.contains(',')){
                                                               if(memberdetail.hasPopulation && population.contains(',')){
                                                               
                                                                   // Logic for Continuation Type, Continuation Responsibility and onshore restriction as in Group Detail Controller
                                                                   System.debug('&&& onshorerestriction '+Date.valueof(newEffectiveDate)+'>='+Date.ValueOf(ins.insuringRulesEffectiveDates)+','+Date.ValueOf(newEndDate)+'<='+Date.ValueOf(ins.insuringRulesExpirationDates));
                                                                   
                                                                   if(memberDetail.coverageGroupContractOptionFilterStatus == 'Active' && memberDetail.coverageGroupContractOptionStatus == 'Active'){
                                                                        if(Date.ValueOf(ins.insuringRulesEffectiveDates) <= Date.ValueOf(currentDate) && Date.ValueOf(currentDate) <= Date.ValueOf(ins.insuringRulesExpirationDates)){
                                                                            system.debug('```Multiple pop Active');
                                                                            List<String> lstpop = population.split(',');
                                                                            //List<String> onshoreRest_lst = new List<String>();
                                                                            system.debug('---lstpop ---------'+lstpop);
                                                                            if(ins.classesCode != '' ){  
                                                                                for(String str:lstpop){
                                                                                str = str.trim();        
                                                                                if(ins.classesCode == str){
                                                                                  
                                                                                 /****************************  ONSHORE RESTRICTION Multiple POP  *****************************************/
                                                                                //Collect Onshore Restriction values of all populations to check if all restrictions are identical 
                                                                                /********************************************************************************************************/
                                                                            
                                                                                    if(String.isNotBlank(ins.onshoreRestriction))
                                                                                       onshoreRest_lst.add(ins.onshoreRestriction);
                                                       
                                                                                    
                                                                                    memberdetail.responsibilityType = memberdetail.responsibilityType + ins.continuationResponsibilityType + ' (' + ins.classesCode +') ; ';
                                                                                    memberdetail.continuationType = memberdetail.continuationType + ins.insuranceContinuationType + ' (' + ins.classesCode +') ; ';
                                                                            
                                                                                system.debug('%%% multiple pop and  resp & cont'+memberdetail.responsibilityType + ';;;'+memberdetail.continuationType );
                                                                                }  
                                                                            }
                                                                            system.debug('%%%%%%Multi pop New onshore'+onshoreRest_lst+onshoreRest_lst.size());
                                                                            if(onshoreRest_lst.size() == 1 && lstpop.size() >= 1){
                                                                                   for(string onr: onshoreRest_lst){
                                                                                       memberDetail.PreferredCoverage.onshoreRestrictionCode = ACETOnshoreIndicatorVerbiage__c.getValues(onr).Code_Description__c; 
                                                                                       memberDetail.PreferredCoverage.OnshoreRestrictionVerbiage = ACETOnshoreIndicatorVerbiage__c.getValues(onr).Hover_Help_Description__c;   
                                                                                  }
                                                                            }
                                                                          }  
                                                                            if(String.isBlank(ins.classesCode)){
                                                                                system.debug('%%%% Multi pop opt - Active - plain grp ins rules');
                                                                                memberDetail.PreferredCoverage.onshoreRestrictionCode = ACETOnshoreIndicatorVerbiage__c.getValues(ins.onshoreRestriction).Code_Description__c; 
                                                                                memberDetail.PreferredCoverage.OnshoreRestrictionVerbiage = ACETOnshoreIndicatorVerbiage__c.getValues(ins.onshoreRestriction).Hover_Help_Description__c;//pc.onshoreRestrictionError = true;  
                                                                                  system.debug('%%%% Multi pop opt - Active - plain grp ins rules'+memberDetail.PreferredCoverage.onshoreRestrictionCode);
                                                                                
                                                                            }
                                                                        }
                                                                   }
                                                                   else if(memberDetail.coverageGroupContractOptionFilterStatus == 'Future' && memberDetail.coverageGroupContractOptionStatus == 'Active'){
                                                                        //if(Date.ValueOf(newEffectiveDate) >= Date.ValueOf(ins.insuringRulesEffectiveDates) ){
                                                                        system.debug('!!!Date comparision Future multi popCO'+ins.insuringRulesEffectiveDates+'//'+newEffectiveDate+'//'+ins.insuringRulesExpirationDates);
                                                                          if(Date.ValueOf(ins.insuringRulesEffectiveDates) <= Date.ValueOf(newEffectiveDate) && Date.ValueOf(newEffectiveDate) <= Date.ValueOf(ins.insuringRulesExpirationDates) && ins.insuringRulesExpirationDates != maxDateString || 
                                                                                (Date.ValueOf(ins.insuringRulesEffectiveDates) <= Date.ValueOf(newEffectiveDate) && ins.insuringRulesExpirationDates == maxDateString)){
    
                                                                            system.debug('```Multiple pop Future');
                                                                            List<String> lstpop = population.split(',');
                                                                            //List<String> onshoreRest_lst = new List<String>();
                                                                            system.debug('---lstpop ---------'+lstpop);
                                                                            if(ins.classesCode != '' ){  
                                                                                for(String str:lstpop){
                                                                                str = str.trim();        
                                                                                if(ins.classesCode == str){
                                                                                
                                                                                 /****************************  ONSHORE RESTRICTION Multiple POP  *****************************************/
                                                                                //Collect Onshore Restriction values of all populations to check if all restrictions are identical 
                                                                                /********************************************************************************************************/
                                                                            
                                                                                    if(String.isNotBlank(ins.onshoreRestriction))
                                                                                       onshoreRest_lst.add(ins.onshoreRestriction);
                                                       
                                                                                    memberdetail.responsibilityType = memberdetail.responsibilityType + ins.continuationResponsibilityType + ' (' + ins.classesCode +') ; ';
                                                                                    memberdetail.continuationType = memberdetail.continuationType + ins.insuranceContinuationType + ' (' + ins.classesCode +') ; ';
                                                                            
                                                                                system.debug('%%% multiple pop and  resp & cont'+memberdetail.responsibilityType + ';;;'+memberdetail.continuationType );
                                                                                                                                                       
                                                                                    }  
                                                                                }
                                                                            
                                                                             system.debug('%%%%%%Multi pop New onshore'+onshoreRest_lst+onshoreRest_lst.size());
                                                                                if(onshoreRest_lst.size() == 1 && lstpop.size() >= 1){
                                                                                       for(string onr: onshoreRest_lst){
                                                                                           memberDetail.PreferredCoverage.onshoreRestrictionCode = ACETOnshoreIndicatorVerbiage__c.getValues(onr).Code_Description__c; 
                                                                                           memberDetail.PreferredCoverage.OnshoreRestrictionVerbiage = ACETOnshoreIndicatorVerbiage__c.getValues(onr).Hover_Help_Description__c;   
                                                                                      }
                                                                                }
                                                                            }
                                                                             if(String.isBlank(ins.classesCode)){
                                                                                system.debug('%%%% Multi pop opt - Future- plain grp ins rules');
                                                                                memberDetail.PreferredCoverage.onshoreRestrictionCode = ACETOnshoreIndicatorVerbiage__c.getValues(ins.onshoreRestriction).Code_Description__c; 
                                                                                memberDetail.PreferredCoverage.OnshoreRestrictionVerbiage = ACETOnshoreIndicatorVerbiage__c.getValues(ins.onshoreRestriction).Hover_Help_Description__c;//pc.onshoreRestrictionError = true;  
                                                                                  system.debug('%%%% Multi pop opt - Future- plain grp ins rules'+memberDetail.PreferredCoverage.onshoreRestrictionCode);
                                                                                
                                                                            }
                                                                            
                                                                        }
                                                        
                                                                   
                                                                   }
                                                                   else if(memberDetail.coverageGroupContractOptionFilterStatus == 'Termed' && memberDetail.coverageGroupContractOptionStatus == 'Active'){
                                                                        system.debug('!!!Date comparision Termed CO multi pop'+ins.insuringRulesEffectiveDates+'//'+newEffectiveDate+'//'+ins.insuringRulesExpirationDates);
                                                                        
                                                                        //if(Date.ValueOf(ins.insuringRulesEffectiveDates) > Date.ValueOf(newEffectiveDate) && Date.ValueOf(newEndDate) == Date.ValueOf(ins.insuringRulesExpirationDates) && ins.insuringRulesExpirationDates != '12/31/9999' || (Date.ValueOf(ins.insuringRulesEffectiveDates) == Date.ValueOf(newEffectiveDate) && ins.insuringRulesExpirationDates == '12/31/9999')){
                                                                         if(Date.ValueOf(ins.insuringRulesEffectiveDates) <= Date.ValueOf(newEndDate) && Date.ValueOf(newEndDate) <= Date.ValueOf(ins.insuringRulesExpirationDates) && ins.insuringRulesExpirationDates != maxDateString || 
                                                                            (Date.ValueOf(ins.insuringRulesEffectiveDates) <= Date.ValueOf(newEndDate) && ins.insuringRulesExpirationDates == maxDateString)){
      
                                                                            system.debug('```Multiple pop Termed');
                                                                            List<String> lstpop = population.split(',');
                                                                            //List<String> onshoreRest_lst = new List<String>();
                                                                            system.debug('---lstpop ---------'+lstpop);
                                                                            if(ins.classesCode != '' ){  
                                                                                for(String str:lstpop){
                                                                                str = str.trim();        
                                                                                if(ins.classesCode == str){
                                                                                     /****************************  ONSHORE RESTRICTION Multiple POP  *****************************************/
                                                                                //Collect Onshore Restriction values of all populations to check if all restrictions are identical 
                                                                                /********************************************************************************************************/
                                                                            
                                                                                    if(String.isNotBlank(ins.onshoreRestriction))
                                                                                       onshoreRest_lst.add(ins.onshoreRestriction);
                                                       
                                                                                    memberdetail.responsibilityType = memberdetail.responsibilityType + ins.continuationResponsibilityType + ' (' + ins.classesCode +') ; ';
                                                                                    memberdetail.continuationType = memberdetail.continuationType + ins.insuranceContinuationType + ' (' + ins.classesCode +') ; ';
                                                                            
                                                                            system.debug('%%% multiple pop and  resp & cont'+memberdetail.responsibilityType + ';;;'+memberdetail.continuationType );
                                                                            
                                                                                }  
                                                                            }
                                                                            
                                                                             system.debug('%%%%%%Multi pop New onshore'+onshoreRest_lst+onshoreRest_lst.size());
                                                                                if(onshoreRest_lst.size() == 1 && lstpop.size() >= 1){
                                                                                       for(string onr: onshoreRest_lst){
                                                                                           memberDetail.PreferredCoverage.onshoreRestrictionCode = ACETOnshoreIndicatorVerbiage__c.getValues(onr).Code_Description__c; 
                                                                                           memberDetail.PreferredCoverage.OnshoreRestrictionVerbiage = ACETOnshoreIndicatorVerbiage__c.getValues(onr).Hover_Help_Description__c;   
                                                                                      }
                                                                                }
                                                                            }
                                                                            
                                                                            if(String.isBlank(ins.classesCode)){
                                                                                system.debug('%%%% Multi pop opt - Termed- plain grp ins rules');
                                                                                memberDetail.PreferredCoverage.onshoreRestrictionCode =ACETOnshoreIndicatorVerbiage__c.getValues(ins.onshoreRestriction).Code_Description__c; 
                                                                                memberDetail.PreferredCoverage.OnshoreRestrictionVerbiage = ACETOnshoreIndicatorVerbiage__c.getValues(ins.onshoreRestriction).Hover_Help_Description__c;//pc.onshoreRestrictionError = true;  
                                                                                  system.debug('%%%% Multi pop opt - Termed- plain grp ins rules'+memberDetail.PreferredCoverage.onshoreRestrictionCode);
                                                                                
                                                                            }
                                                                            
                                                                        }
                                                                    }
                                                                }
                                                               // Below condition is to check when single/No population is assigned to a contract option
                                                               else if((memberdetail.hasPopulation && ins.classesCode != null && population == ins.classesCode)||(ins.classesCode == null && memberdetail.hasPopulation == false)||(memberdetail.hasPopulation && ins.classesCode == null)){
                                                                    system.debug('%%%Member grpinsrulepop/Nopop'+population);  
                                                                    system.debug('%%%Status'+memberDetail.coverageGroupContractOptionFilterStatus +';;;'+accopt.statusDescription);
                                                                    system.debug('```single/No pop ');
                                                                            
                                                                    if(memberDetail.coverageGroupContractOptionFilterStatus == 'Active' && memberDetail.coverageGroupContractOptionStatus == 'Active'){
                                                                        if(Date.ValueOf(ins.insuringRulesEffectiveDates) <= Date.ValueOf(currentDate) && Date.ValueOf(currentDate) <= Date.ValueOf(ins.insuringRulesExpirationDates)){
                                                                            system.debug('%%%Member grpinsrulepop Inside'); 
                                                                            system.debug('```single/No pop Active');
                                                                    
                                                                            memberdetail.cobraAdministrativeIndicator = (ins.cobraAdministrativeIndicator!=null)?ins.cobraAdministrativeIndicator:'';
                                                                            memberdetail.responsibilityType = (ins.continuationResponsibilityType!=null)?ins.continuationResponsibilityType :'' ;
                                                                            memberdetail.continuationType = (ins.insuranceContinuationType!=null)?ins.insuranceContinuationType:'' ;
                                                                            memberdetail.onshoreRestriction = (ins.onshoreRestriction != null)?ins.onshoreRestriction:'' ;
                                                                            if(!String.isEmpty( memberdetail.onshoreRestriction )){
                                                                                  
                                                                                  system.debug('%%%@@@onshoreRestriction with one pop/no pop@@ ' + memberdetail.onshoreRestriction);
                                                                                  if(EGDetails != null && ACETOnshoreIndicatorVerbiage__c.getValues(memberdetail.onshoreRestriction ) != null){
                                                                                      memberDetail.PreferredCoverage.onshoreRestrictionCode = ACETOnshoreIndicatorVerbiage__c.getValues(memberdetail.onshoreRestriction ).Code_Description__c;
                                                                                      memberDetail.PreferredCoverage.OnshoreRestrictionVerbiage = ACETOnshoreIndicatorVerbiage__c.getValues(memberdetail.onshoreRestriction ).Hover_Help_Description__c; 
                                                                                  }
                                                                            }
                                                                        }
                                                                    }
                                                                    else if(memberDetail.coverageGroupContractOptionFilterStatus == 'Future' && memberDetail.coverageGroupContractOptionStatus == 'Active'){
                                                                        system.debug('!!!Date comparision Future single/no pop CO'+ins.insuringRulesEffectiveDates+'//'+newEffectiveDate+'//'+ins.insuringRulesExpirationDates);
                                                                        
                                                                        
                  if(Date.ValueOf(ins.insuringRulesEffectiveDates) <= Date.ValueOf(newEffectiveDate) && Date.ValueOf(newEffectiveDate) <= Date.ValueOf(ins.insuringRulesExpirationDates) && ins.insuringRulesExpirationDates != maxDateString || 
                                                                                (Date.ValueOf(ins.insuringRulesEffectiveDates) <= Date.ValueOf(newEffectiveDate) && ins.insuringRulesExpirationDates == maxDateString)){
                                                                              system.debug('%%%Member grpinsrulepop Inside'); 
                                                                            system.debug('```single/No pop Future');
                                                                            memberdetail.cobraAdministrativeIndicator = (ins.cobraAdministrativeIndicator!=null)?ins.cobraAdministrativeIndicator:'';
                                                                            memberdetail.responsibilityType = (ins.continuationResponsibilityType!=null)?ins.continuationResponsibilityType :'' ;
                                                                            memberdetail.continuationType = (ins.insuranceContinuationType!=null)?ins.insuranceContinuationType:'' ;
                                                                            memberdetail.onshoreRestriction = (ins.onshoreRestriction != null)?ins.onshoreRestriction:'' ;
                                                                            if(!String.isEmpty( memberdetail.onshoreRestriction )){
                                                                                  
                                                                                  system.debug('%%%@@@onshoreRestriction with pop@@ ' + memberdetail.onshoreRestriction);
                                                                                  if(EGDetails != null && ACETOnshoreIndicatorVerbiage__c.getValues(memberdetail.onshoreRestriction ) != null){
                                                                                      memberDetail.PreferredCoverage.onshoreRestrictionCode = ACETOnshoreIndicatorVerbiage__c.getValues(memberdetail.onshoreRestriction ).Code_Description__c;
                                                                                      memberDetail.PreferredCoverage.OnshoreRestrictionVerbiage = ACETOnshoreIndicatorVerbiage__c.getValues(memberdetail.onshoreRestriction ).Hover_Help_Description__c; 
                                                                                  }
                                                                            }
                                                                        }
                                                                    }
                                                                    else if(memberDetail.coverageGroupContractOptionFilterStatus == 'Termed' && memberDetail.coverageGroupContractOptionStatus == 'Active'){
                                                                        system.debug('!!!Date comparision Future single/No popCO'+ins.insuringRulesEffectiveDates+'//'+newEffectiveDate+'//'+ins.insuringRulesExpirationDates);
                                                                        
                                                                       
                        if(Date.ValueOf(ins.insuringRulesEffectiveDates) <= Date.ValueOf(newEndDate) && Date.ValueOf(newEndDate) <= Date.ValueOf(ins.insuringRulesExpirationDates) && ins.insuringRulesExpirationDates != maxDateString || 
                                                                            (Date.ValueOf(ins.insuringRulesEffectiveDates) <= Date.ValueOf(newEndDate) && ins.insuringRulesExpirationDates == maxDateString)){
     
                                                                            system.debug('%%%Member grpinsrulepop Inside'); 
                                                                            system.debug('```single/No pop Termed');
                                                                            memberdetail.cobraAdministrativeIndicator = (ins.cobraAdministrativeIndicator!=null)?ins.cobraAdministrativeIndicator:'';
                                                                            memberdetail.responsibilityType = (ins.continuationResponsibilityType!=null)?ins.continuationResponsibilityType :'' ;
                                                                            memberdetail.continuationType = (ins.insuranceContinuationType!=null)?ins.insuranceContinuationType:'' ;
                                                                            memberdetail.onshoreRestriction = (ins.onshoreRestriction != null)?ins.onshoreRestriction:'' ;
                                                                            if(!String.isEmpty( memberdetail.onshoreRestriction )){
                                                                                  
                                                                                  system.debug('%%%@@@onshoreRestriction with pop@@ ' + memberdetail.onshoreRestriction);
                                                                                  if(EGDetails != null && ACETOnshoreIndicatorVerbiage__c.getValues(memberdetail.onshoreRestriction ) != null){
                                                                                      memberDetail.PreferredCoverage.onshoreRestrictionCode = ACETOnshoreIndicatorVerbiage__c.getValues(memberdetail.onshoreRestriction ).Code_Description__c;
                                                                                      //memberDetail.PreferredCoverage.OnshoreRestriction = codeVsOnshoreIndicator.get(memberDetail.PreferredCoverage.onshoreRestrictionCode);
                                                                                      memberDetail.PreferredCoverage.OnshoreRestrictionVerbiage = ACETOnshoreIndicatorVerbiage__c.getValues(memberdetail.onshoreRestriction ).Hover_Help_Description__c; 
                                                                                  }
                                                                            }
                                                                        }
                                                                    } 
                                                                 }
                                                                 
                                                                 
                                                            }
                                                        }
                                                         //End of Group Insurirng Rues Logic     
                                                            if(string.isNotBlank(memberDetail.PreferredCoverage.OnshoreRestriction)){
                                                               memberDetail.PreferredCoverage.OnshoreRestriction = memberDetail.PreferredCoverage.OnshoreRestriction.removeEnd('; ');
                                                            }
                                                            if(string.isNotBlank(memberDetail.PreferredCoverage.onshoreRestrictionCode)){
                                                               memberDetail.PreferredCoverage.onshoreRestrictionCode = memberDetail.PreferredCoverage.onshoreRestrictionCode.removeEnd('; '); 
                                                             }if(string.isNotBlank(memberDetail.PreferredCoverage.OnshoreRestrictionVerbiage)){
                                                                memberDetail.PreferredCoverage.OnshoreRestrictionVerbiage = memberDetail.PreferredCoverage.OnshoreRestrictionVerbiage.removeEnd('; '); 
                                                            }
                                                     }
                                                  }
                                                  system.debug('~~~~~~Member detail onshore error, code'+memberDetail.PreferredCoverage.onshoreRestrictionError+memberDetail.PreferredCoverage.onshoreRestrictionCode);
                                                  
                                               } 
                                            }// End of Customer Account Option Loop
                                          }
                                        }
                                    }
                                }
                            }
                        
                          
                        memberDetail.GroupSize = (EGDetails.sizeDefinitionDescription != null)?EGDetails.sizeDefinitionDescription:'';
                        memberDetail.enrollmentMethod= (EGDetails.enrollmentType != null)?EGDetails.enrollmentType:'';
                        
            //US2884153
            if(EGDetails.migrationSourceSystem != Null && EGDetails.migrationSourceSystem.size()>0
               && EGDetails.migrationSourceSystem[0].name!=null && EGDetails.migrationSourceSystem[0].id!=null){
                   
                   memberDetail.migrationSourceSystem
                       = EGDetails.migrationSourceSystem[0].name +' - '+EGDetails.migrationSourceSystem[0].id; 
               }  
            else{
                memberDetail.migrationSourceSystem = 'N/A';
            }
                
            //US2884153 end
                      
                      system.debug('%%%%%%%% Continuation type , responsibility, onshore restriction code , onshore restriction text'+memberdetail.continuationType + ' %% '+memberdetail.responsibilityType +' %% '+memberDetail.PreferredCoverage.onshoreRestrictionCode +' %% '+memberDetail.PreferredCoverage.onshoreRestriction);
                      //US1699536 starts
                      memberDetail.groupSettings = new List<ACETMemberDetail.cobAttestation>();
                      if(EGDetails.groupSettings != null) {
                        for(ACETGetEmployerGroupAdapterJSON2Apex.cobAttestation groupSet:EGDetails.groupSettings) {
                            ACETMemberDetail.cobAttestation settings = new ACETMemberDetail.cobAttestation();
                            settings.cobAttestationFrequency = (groupSet.cobAttestationFrequency != null)?groupSet.cobAttestationFrequency:'';
                            settings.cobAttestationDenyGracePeriod = (groupSet.cobAttestationDenyGracePeriod != null)?groupSet.cobAttestationDenyGracePeriod:'';
                            settings.religiousExemptionTypeDescription = (groupSet.religiousExemptionTypeDescription != null)?groupSet.religiousExemptionTypeDescription:'';
                            settings.effectiveDate = (groupSet.effectiveDate != null)?groupSet.effectiveDate:'';
                            settings.expirationDate = (groupSet.expirationDate != null)?groupSet.expirationDate:'';
                            memberDetail.groupSettings.add(settings);
                            
                        }
                      }
                      //US1699536 ends  
                      // US1053027 changes start
                      if(EGDetails.groupContact != null)
                      {  
                          for(ACETGetEmployerGroupAdapterJSON2Apex.GroupContact contactData:EGDetails.groupContact)
                          {
                              
                              if(contactData != Null && contactData.roleDescription == 'Benefit Administrator' && (contactData.primaryIndicatorDescription  == 'Yes' || contactData.primaryIndicatorDescription == 'Primary'))
                              {
                                  firstName  = (contactData.firstName != Null)?contactData.firstName:'' ;
                                  middleName  = (contactData.middleName != Null)?contactData.middleName:'';
                                  lastName  = (contactData.lastName != Null)?contactData.lastName:'' ;
                                  memberDetail.benefitAdmin = firstName + ' ' + middleName + ' ' + lastName;
                                  memberDetail.benefitAdminPhone = '';
                                  ACETGroupDetail.groupContactInfo benefitAdminInfo = new ACETGroupDetail.groupContactInfo();
                                  benefitAdminInfo.contactPhones = new list<ACETGroupDetail.contactPhoneInfo>();
                        
                                  if(contactData.phone != Null && !contactData.phone.isEmpty())
                                  {
                                      for(ACETGetEmployerGroupAdapterJSON2Apex.Phone phoneInfo:contactData.phone)
                                      {
                                          ACETGroupDetail.contactPhoneInfo adminPhoneInfo = new ACETGroupDetail.contactPhoneInfo();
                                          adminPhoneInfo.phoneNumber = (phoneInfo != Null && phoneInfo.telephoneNumber != Null)?phoneInfo.telephoneNumber:'' ;
                                          
                                          if(adminPhoneInfo != Null)
                                            benefitAdminInfo.contactPhones.add(adminPhoneInfo );
                                      }
                                      if(benefitAdminInfo.contactPhones != Null)
                                      memberDetail.benefitAdminPhone = benefitAdminInfo.contactPhones[0].phoneNumber ;
                                  }
                              }
                              
                          }
                      } 
                      else
                      {
                          memberDetail.benefitAdmin = '';
                          memberDetail.benefitAdminPhone = '';
                      }  
                       // US1053027 changes end
                      }
                  }
                 
                oACETWSCalloutResult.Success = true;
                  oACETWSCalloutResult.Message = '';
                  oACETWSCalloutResult.response = memberDetail;
              }
            } else {
              oACETWSCalloutResult = ParseFailureResponse(Response);  
              oACETWSCalloutResult.statusCode=response!=null?response.getStatusCode():null;
              

            } 
        }
        catch(Exception ex)
        {
            system.debug(LoggingLevel.INFO, 'Exception in ProcessResponse. Details: ' + ex.getstackTraceString()); 
            system.debug(LoggingLevel.INFO, 'Exception in ProcessResponse. Details: ' + ex); 
            oACETWSCalloutResult.Success = false;
            oACETWSCalloutResult.response = memberDetail;
            oACETWSCalloutResult.Message = ex.getMessage();
            oACETWSCalloutResult.MessageSeverity = ApexPages.Severity.ERROR;
            oACETWSCalloutResult.statusCode=999;

        }
        return oACETWSCalloutResult;
    } 
    public ACETWSCalloutResult ProcessResponse(String HttpRequestLabel) {
        ACETWSCalloutResult oACETWSCalloutResult = new ACETWSCalloutResult();
        try {
            HttpResponse Response = GetHttpResponse(HttpRequestLabel);
            //Response.setStatusCode(400);
            oACETWSCalloutResult.Success = true;
            oACETWSCalloutResult.statusCode=response!=null?response.getStatusCode():null;

          
            if (Response.getStatusCode() == 200) {
            system.debug('Response.getBody()----->'+Response.getBody());
                oACETWSCalloutResult.Success = true;
                oACETWSCalloutResult.Message = '';
                oACETWSCalloutResult.Response = parseSuccessAdapterResponse(ReplaceKeywords(Response.getBody()));   //Response.getBody()   GetEmpGrpRes
            } else {
              oACETWSCalloutResult = ParseFailureResponse(Response);  
              oACETWSCalloutResult.statusCode=response!=null?response.getStatusCode():null;
            }  
            Long dt2Long = DateTime.now().getTime();
            system.debug('oACETWSCalloutResult---->'+oACETWSCalloutResult);
        }
        catch(Exception ex)
        {
            system.debug(LoggingLevel.INFO, 'Exception in ProcessResponse. Details: ' + ex.getstackTraceString()); 
            oACETWSCalloutResult.Success = false;
            oACETWSCalloutResult.Message = ex.getMessage();
            oACETWSCalloutResult.MessageSeverity = ApexPages.Severity.ERROR;
            oACETWSCalloutResult.statusCode=999;
        }
        system.debug('oACETWSCalloutResult: ' + oACETWSCalloutResult);        
        return oACETWSCalloutResult;
    } 
    
     public String getBlankDefaultDate(String defaultDate){
        if(defaultDate == maxDateString) 
            return null;
        else 
            return defaultDate;
    }  
}