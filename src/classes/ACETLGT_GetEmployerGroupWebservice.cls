public class ACETLGT_GetEmployerGroupWebservice extends ACETWebService{
    private string firstName,middleName,LastName,population,addrType,taxId,OriginalContractDate,networkId;
    public ACETLGT_GroupDetail oACETGroupDetail;
    private integer i;
    
    public override void getEndpoint(){
        GetEndpointDetail('GetEmployerGroupEndpoint');
    }
    
	public ACETLGT_GetEmployerGroupWebservice() {
        if(!Test.isRunningTest())
			super('Stargate');
    }
    public void getRequestBody(String groupNumber){
        system.debug('Group Number========>'+groupNumber);
        RequestBody = '{"getEmployerGroup":{"getEmployerGroupRequest":{"groupNumber":"'+groupNumber+'"}}}';        
    }
    
    public ACETWSCalloutResult getGroupInfo(String groupNumber, String pcEffDate, String pcEndDate, String pcBenefitPlanId, String pcBenefitBundleOptionId, String originatorType, boolean isOnshore,String planOptionId){ 
        //originatorType and isOnshore needs to be passed
        
        ACETWSCalloutResult calloutResult = new ACETWSCalloutResult();
        ACETLGT_MemberSearchCoveragesResult memberDetail = new ACETLGT_MemberSearchCoveragesResult();
        memberDetail.CoverageGroupInfo  = new ACETLGT_MemberSearchCoveragesResult.CoverageGroupInfo();
		memberDetail.customerPurchase = new List<ACETLGT_MemberSearchCoveragesResult.CustomerPurchase>();
        system.debug('::::Inside webservice'+groupNumber+pcEffDate+pcBenefitPlanId+pcEndDate+pcBenefitBundleOptionId+originatorType+isOnshore+planOptionId);
        try{
            getEndpoint();
            GetRequestBody(groupNumber);
            HttpResponse response = Send(OAuthConfig);
            system.debug(':::response'+response);
            if(response!=null){
                //response.setStatusCode(500);
                
                calloutResult.statusCode = response.getStatusCode();
            	
                if(response.getStatusCode() == 200){
                    if(!String.isEmpty(response.getBody())){
                        system.debug(':::Inside Successful response');
                        ACETLGT_GetEmployerGroupAdapterJSON2Apex.EmployerGroup EGDetails;
                        ACETLGT_GetEmployerGroupAdapterJSON2Apex ACETEGDJSON2Apex = (ACETLGT_GetEmployerGroupAdapterJSON2Apex)JSON.deserialize(response.getBody(), ACETLGT_GetEmployerGroupAdapterJSON2Apex.class);
                        if(ACETEGDJSON2Apex != null && ACETEGDJSON2Apex.GetEmployerGroup != null && ACETEGDJSON2Apex.GetEmployerGroup.GetEmployerGroupResponse != null){
                            
                            EGDetails = ACETEGDJSON2Apex.GetEmployerGroup.GetEmployerGroupResponse.EmployerGroup;
                            if(EGDetails != null){
							 //fetching only Customer Purchases for Plan Dates
                                for(ACETLGT_GetEmployerGroupAdapterJSON2Apex.CustomerAccount acc: EGDetails.customerAccount) {
                                     if(acc.customerAccountOption != null){
                                                for(ACETLGT_GetEmployerGroupAdapterJSON2Apex.CustomerAccountOption accopt: acc.customerAccountOption) {
                                                    if(accopt.customerPurchase != null){
                                                            for(ACETLGT_GetEmployerGroupAdapterJSON2Apex.customerPurchase custPurch: accopt.customerPurchase){
                                                                ACETLGT_MemberSearchCoveragesResult.CustomerPurchase cp = new ACETLGT_MemberSearchCoveragesResult.CustomerPurchase();
                                                                cp.benefitBundleOptionID = custPurch.benefitBundleOptionID;
                                                                cp.coverageStartDate = custPurch.coverageStartDate;
                                                                cp.coverageExpirationDate = custPurch.coverageExpirationDate;
                                                                cp.memberGroupContractPlanOptionID = custPurch.memberGroupContractPlanOptionID;
                                                             	memberDetail.customerPurchase.add(cp);
                                                            }
                                                    }
                                                }
                                         
                                     }
                                    
                                }
                                System.debug('**** Here ' + EGDetails);
                                memberDetail.CoverageGroupInfo.GroupSize = (EGDetails.sizeDefinitionDescription != null)?EGDetails.sizeDefinitionDescription:'';
                                memberDetail.CoverageGroupInfo.enrollmentMethod= (EGDetails.enrollmentType != null)?EGDetails.enrollmentType:'';
                                memberDetail.GroupSize = (EGDetails.sizeDefinitionDescription != null)?EGDetails.sizeDefinitionDescription:'';
                                memberDetail.enrollmentMethod= (EGDetails.enrollmentType != null)?EGDetails.enrollmentType:'';
                                if(EGDetails.organizationRelationshipTypeCode=='PEO'){
                                    memberDetail.parentPEOId = EGDetails.parentGroup.Id;
                                }
                                if(pcEffDate != null && pcEndDate!=null && planOptionId != null ){   // && pcBenefitBundleOptionId != null   COmmented temp till we pass cov Line (Benefit Plan Id, Eff Date, End Date)
                                    if(!EGDetails.CustomerAccount.isEmpty()){
                                        for(ACETLGT_GetEmployerGroupAdapterJSON2Apex.CustomerAccount acc: EGDetails.customerAccount) {
                                            // Logic for Contract Option and related attributes
                                            if(acc.customerAccountOption != null){
                                                for(ACETLGT_GetEmployerGroupAdapterJSON2Apex.CustomerAccountOption accopt: acc.customerAccountOption) {
                                                    Date newCovEffDate = Date.newInstance(Integer.valueOf(pcEffDate.split('/')[2]), Integer.valueOf(pcEffDate.split('/')[0]), Integer.valueOf(pcEffDate.split('/')[1]));
                                                    Date newCovEndDate = Date.newInstance(Integer.valueOf(pcEndDate.split('/')[2]), Integer.valueOf(pcEndDate.split('/')[0]), Integer.valueOf(pcEndDate.split('/')[1]));
                                                    system.debug('%%%Member preferred coverage dates fomatted'+pcEffDate + ' '+pcEndDate);  
                                                    String currentDate = Date.Today().year() + '-' + Date.Today().month() + '-' + Date.Today().day();
                                                    system.debug('%%%current date'+currentDate);
                                                    /* ******************************************************************************************
                                                    Below logic is to pick single contract option version even if plans are same among the versions 
                                                    or different options
                                                    Filter criteria:
                                                    [Active version] and (Active Coverage)||(Termed Coverage)||(Future Coverage)
                                                    *******************************************************************************************/
                                                    System.debug('%%%%%%% '+accopt.statusDescription+':Active,'+Date.valueOf(accopt.startDate)+'<='+Date.valueOf(newCovEffDate)+','+Date.valueOf(newCovEffDate)+'<='+Date.valueOf(currentDate)+','+Date.valueOf(currentDate)+'<='+Date.valueOf(accopt.terminationDate)+','+Date.valueOf(accopt.terminationDate)+'<='+Date.valueOf(newCovEndDate)+',OR '+Date.valueOf(accopt.startDate)+'<='+Date.valueOf(newCovEndDate )+','+Date.valueOf(newCovEndDate)+'<='+Date.valueOf(accopt.terminationDate)+',OR '+Date.valueOf(accopt.startDate)+'<='+ Date.valueOf(newCovEffDate )+','+Date.valueOf(newCovEffDate)+'<='+Date.valueOf(accopt.terminationDate));
                                                    if(accopt.statusDescription  == 'Active' && ((Date.valueOf(accopt.startDate) <= Date.valueOf(newCovEffDate) && Date.valueOf(newCovEffDate) <= Date.valueOf(currentDate) &&  Date.valueOf(currentDate) <= Date.valueOf(accopt.terminationDate) && Date.valueOf(accopt.terminationDate)>= Date.valueOf(newCovEndDate))
                                                                                                 ||(Date.valueOf(accopt.startDate)<= Date.valueOf(newCovEndDate ) && Date.valueOf(newCovEndDate)<=Date.valueOf(accopt.terminationDate))
                                                                                                 ||(Date.valueOf(accopt.startDate)<= Date.valueOf(newCovEffDate ) && Date.valueOf(newCovEffDate)<=Date.valueOf(accopt.terminationDate)&& Date.valueOf(newCovEndDate)<=Date.valueOf(accopt.terminationDate)))){
                                                        system.debug('%%% Active version of coverage selected%%%%');
                                                        if(accopt.customerPurchase != null){
                                                            for(ACETLGT_GetEmployerGroupAdapterJSON2Apex.customerPurchase custPurch: accopt.customerPurchase){
                                                                system.debug('%%%% benefit plan and bundle '+custPurch.benefitBundleOptionID +':null,'+custPurch.benefitBasePlan+':null,'+custPurch.benefitBundleOptionID+':'+MemberDetail.BundleOptionID+','+custPurch.benefitBasePlan+':'+MemberDetail.BenefitPlanId);
                                                                
                                                                //if(custPurch.benefitBundleOptionID != null && custPurch.benefitBasePlan != null && custPurch.benefitBasePlan == pcBenefitPlanId && custPurch.benefitBundleOptionID == pcBenefitBundleOptionId){     
                                                                if(custPurch.memberGroupContractPlanOptionID != null && custPurch.memberGroupContractPlanOptionID == planOptionId){
                                                                    system.debug('%%%% Plan Option matched%%%%');
                                                                    if(accopt.startDate != null && (Date.valueOf(accopt.startDate) > Date.valueOf(currentDate))){ 
                                                                        memberDetail.CoverageGroupInfo.coverageGroupContractOptionFilterStatus = 'Future';
                                                                    } else if(accopt.terminationDate != null && (Date.valueOf(accopt.terminationDate) < Date.valueOf(currentDate))){
                                                                        memberDetail.CoverageGroupInfo.coverageGroupContractOptionFilterStatus = 'Termed';
                                                                    } else if(accopt.startDate != null && accopt.terminationDate != null && (Date.valueOf(accopt.startDate) <= Date.valueOf(currentDate) && Date.valueOf(accopt.terminationDate) >= Date.valueOf(currentDate))){
                                                                        memberDetail.CoverageGroupInfo.coverageGroupContractOptionFilterStatus = 'Active';
                                                                    }
                                                                    
                                                                    /*if(custPurch.gatedProductIndicator != Null && custPurch.gatedProductIndicator != ''){
                                                                        memberDetail.CoverageGroupInfo.gatedPlanIndicator = custPurch.gatedProductIndicator == '0'? 'No':'Yes';
																	}*/
																	memberDetail.CoverageGroupInfo.gatedPlanIndicator = (custPurch.gatedProductIndicator != null && custPurch.gatedProductIndicator != '') ? ((custPurch.gatedProductIndicator == '1') ? 'Yes' : ((custPurch.gatedProductIndicator == '0') ? 'No' : '')) : '';                
																	system.debug('Gated'+memberDetail.CoverageGroupInfo.gatedPlanIndicator);
                                                                    
                                                                    //US2884153
                                                                    if(EGDetails.migrationSourceSystem != Null && EGDetails.migrationSourceSystem.size()>0
                                                                       && EGDetails.migrationSourceSystem[0].name!=null && EGDetails.migrationSourceSystem[0].id!=null){
                                                                           
                                                                           memberDetail.CoverageGroupInfo.migrationSourceSystem
                                                                               = EGDetails.migrationSourceSystem[0].name +' - '+EGDetails.migrationSourceSystem[0].id; 
                                                                       }  
                                                                    else{
                                                                           memberDetail.CoverageGroupInfo.migrationSourceSystem = 'N/A';
                                                                        }
                                                                    //US2884153 end
                                                                    
                                                                    //US2874415 Start
                                                                    if(EGDetails.alphaParentGroup!= Null && EGDetails.alphaParentGroup.name != null 
                                                                       && EGDetails.parentGroup!= Null && EGDetails.parentGroup.name != null){
                                                                           memberDetail.CoverageGroupInfo.parentGroup = EGDetails.parentGroup.id +' - '+EGDetails.parentGroup.name ;
                                                                           memberDetail.CoverageGroupInfo.alphaParentGroup = EGDetails.alphaParentGroup.id +' - '+EGDetails.alphaParentGroup.name ;
                                                                       }else{
                                                                           memberDetail.CoverageGroupInfo.parentGroup = 'N/A';
                                                                           memberDetail.CoverageGroupInfo.alphaParentGroup = 'N/A';
                                                                       }
                                                                    //US2874415 end
                                                                    
                                                                    memberDetail.CoverageGroupInfo.coverageGroupContractOptionId = (accopt.customerAccountOptionId != null)?accopt.customerAccountOptionId:'';
                                                                    memberDetail.CoverageGroupInfo.coverageGroupContractOptionEffDate = (accopt.startDate != null)?string.valueOf(ACETUtility.format(Date.valueOf(accopt.startDate))):'';
                                                                    //COntract Option status
                                                                    memberDetail.CoverageGroupInfo.coverageGroupContractOptionStatus = (accopt.statusDescription!= null)?accopt.statusDescription:'';
                                                                    memberDetail.CoverageGroupInfo.exchangeType = (accopt.exchangeTypeDescription != null)?accopt.exchangeTypeDescription:'';     //US1744309
                                                                    memberDetail.CoverageGroupInfo.exchangeState = (accopt.stateOfIssueCode != null)?accopt.stateOfIssueCode:''; //US1744309
                                                                    // US3584878
                                                                    memberDetail.bookOfBusinessTypeCode = '';
                                                                    memberDetail.bookOfBusinessTypeDesc = '';
                                                                    if(String.isNotBlank(custPurch.bookOfBusinessTypeCode) && String.isNotBlank(custPurch.bookOfBusinessTypeDescription) 
                                                                       && custPurch.lineOfBusiness != null && custPurch.lineOfBusiness.size() > 0 &&  String.isNotBlank(custPurch.lineOfBusiness[0].name))
                                                                    {
                                                                        memberDetail.bookOfBusinessTypeCode = custPurch.bookOfBusinessTypeCode;
                                                                        memberDetail.bookOfBusinessTypeDesc = custPurch.bookOfBusinessTypeDescription + ' ' + custPurch.lineOfBusiness[0].name; 
                                                                    }
                                                                    //US3584878
                                                                    if(accopt.customerAccountGroupPopulation != null && accopt.customerAccountGroupPopulation.size()>0){
                                                                        population='';
                                                                        for(ACETLGT_GetEmployerGroupAdapterJSON2Apex.CustomerAccountGroupPopulation gp:accopt.customerAccountGroupPopulation){
                                                                            if(population == ''){
                                                                                population = (gp.classesDescription != null)?gp.classesDescription.replace(',',''):'';
                                                                            } else {
                                                                                population = population + ', ' + ((gp.classesDescription != null)?gp.classesDescription.replace(',',''):'');
                                                                            }   
                                                                            if(population !=''){
                                                                                memberdetail.CoverageGroupInfo.hasPopulation = true;
                                                                                memberdetail.CoverageGroupInfo.contractOptionPopulations = population;
                                                                            } 
                                                                            else{
                                                                                memberdetail.CoverageGroupInfo.hasPopulation = false;
                                                                                memberdetail.CoverageGroupInfo.contractOptionPopulations = '';
                                                                            }
                                                                            system.debug('&&& hasPopulation ' + memberDetail.CoverageGroupInfo.hasPopulation + ', population ' + population);
                                                                        }
                                                                    }
                                                                    else
                                                                    {
                                                                        memberdetail.CoverageGroupInfo.hasPopulation = false;
                                                                    }
                                                                    
                                                                    system.debug('%%%%%%%% memberdetail.hasPopulation'+memberdetail.CoverageGroupInfo.hasPopulation);
                                                                    
                                                                    memberDetail.CoverageGroupInfo.SitusState = (accopt.stateOfIssueCode != null)?accopt.stateOfIssueCode:'';
                                                                    memberDetail.CoverageGroupInfo.FundingArragement = (custPurch.fundingArrangementDescription != Null)?custPurch.fundingArrangementDescription:'';
                                                                    system.debug('%%%Inside Member Contract Option Id'+memberDetail.CoverageGroupInfo.coverageGroupContractOptionId+ '  ' +memberDetail.CoverageGroupInfo.FundingArragement+ '  ' +memberDetail.CoverageGroupInfo.SitusState);
                                                                    
                                                                    // Group Insuring Rules for Contract Option
                                                                    if(EGDetails.GroupInsuringRules != null){
                                                                        memberDetail.CoverageGroupInfo.onshoreRestrictionCode = '';
                                                                        memberDetail.CoverageGroupInfo.OnshoreRestriction = '';
                                                                        memberDetail.CoverageGroupInfo.OnshoreRestrictionVerbiage ='';
                                                                        memberDetail.CoverageGroupInfo.OnshoreRestrictionError = false;
                                                                        memberdetail.CoverageGroupInfo.responsibilityType ='';
                                                                        memberdetail.CoverageGroupInfo.continuationType ='';
                                                                        //memberDetail.CoverageGroupInfo.onshoreRestrictionDisp = 'No';  
                                                                        Set<String> onshoreRest_lst = new Set<String>();
                                                                        
                                                                        for(ACETLGT_GetEmployerGroupAdapterJSON2Apex.GroupInsuringRules ins: EGDetails.GroupInsuringRules ) {
                                                                            system.debug('%%%Member preferred coverage'+pcEffDate + ' '+pcEndDate);  
                                                                            system.debug('%%%Member preferred coverage ins'+ins.insuringRulesEffectiveDates+ ' '+ins.insuringRulesExpirationDates);  
                                                                            
                                                                            Date newEffectiveDate = Date.newInstance(Integer.valueOf(pcEffDate.split('/')[2]), Integer.valueOf(pcEffDate.split('/')[0]), Integer.valueOf(pcEffDate.split('/')[1]));
                                                                            Date newEndDate = Date.newInstance(Integer.valueOf(pcEndDate.split('/')[2]), Integer.valueOf(pcEndDate.split('/')[0]), Integer.valueOf(pcEndDate.split('/')[1]));
                                                                            system.debug('%%%Member preferred coverage dates fomatted'+pcEffDate + ' '+pcEndDate);  
                                                                            
                                                                            system.debug('%%%%%%%% group ins rules memberdetail.hasPopulation'+memberdetail.CoverageGroupInfo.hasPopulation +';;;'+population);
                                                                            
                                                                            // Below condition is to check when multiple populations are assigned to a contract option
                                                                            //if(memberdetail.CoverageGroupInfo.hasPopulation && ins.classesCode != null && population.contains(',')){
                                                                            if(memberdetail.CoverageGroupInfo.hasPopulation && population.contains(',')){
                                                                                
                                                                                // Logic for Continuation Type, Continuation Responsibility and onshore restriction as in Group Detail Controller
                                                                                System.debug('&&& onshorerestriction '+Date.valueof(newEffectiveDate)+'>='+Date.ValueOf(ins.insuringRulesEffectiveDates)+','+Date.ValueOf(newEndDate)+'<='+Date.ValueOf(ins.insuringRulesExpirationDates));
                                                                                
                                                                                if(memberDetail.CoverageGroupInfo.coverageGroupContractOptionFilterStatus == 'Active' && memberDetail.CoverageGroupInfo.coverageGroupContractOptionStatus == 'Active'){
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
                                                                                                    //Collect Onshore Restriction codes of all populations to check all restrictions are identical 
                                                                                                    /********************************************************************************************************/
                                                                                                    
                                                                                                    if(String.isNotBlank(ins.onshoreRestriction))
                                                                                                        onshoreRest_lst.add(ins.onshoreRestriction);
                                                                                                    
                                                                                                    
                                                                                                    memberdetail.CoverageGroupInfo.responsibilityType = memberdetail.CoverageGroupInfo.responsibilityType + ins.continuationResponsibilityType + ' (' + ins.classesCode +') ; ';
                                                                                                    memberdetail.CoverageGroupInfo.continuationType = memberdetail.CoverageGroupInfo.continuationType + ins.insuranceContinuationType + ' (' + ins.classesCode +') ; ';
                                                                                                    
                                                                                                    system.debug('%%% multiple pop and  resp & cont'+memberdetail.CoverageGroupInfo.responsibilityType + ';;;'+memberdetail.CoverageGroupInfo.continuationType );
                                                                                                } 
                                                                                                
                                                                                                
                                                                                                
                                                                                            }
                                                                                            system.debug('%%%%%%Multi pop New onshore'+onshoreRest_lst+onshoreRest_lst.size());
                                                                                            if(onshoreRest_lst.size() == 1 && lstpop.size() >= 1){
                                                                                                for(string onr: onshoreRest_lst){
                                                                                                    memberDetail.CoverageGroupInfo.onshoreRestrictionCode = ACETOnshoreIndicatorVerbiage__c.getValues(onr).Code_Description__c; 
                                                                                                    memberDetail.CoverageGroupInfo.OnshoreRestrictionVerbiage = ACETOnshoreIndicatorVerbiage__c.getValues(onr).Hover_Help_Description__c;   
                                                                                                }
                                                                                            }
                                                                                        }  
                                                                                        if(String.isBlank(ins.classesCode)){
                                                                                            system.debug('%%%% Multi pop opt - Active - plain grp ins rules');
                                                                                            memberDetail.CoverageGroupInfo.onshoreRestrictionCode = ACETOnshoreIndicatorVerbiage__c.getValues(ins.onshoreRestriction).Code_Description__c; 
                                                                                            memberDetail.CoverageGroupInfo.OnshoreRestrictionVerbiage = ACETOnshoreIndicatorVerbiage__c.getValues(ins.onshoreRestriction).Hover_Help_Description__c;//pc.onshoreRestrictionError = true;  
                                                                                            system.debug('%%%% Multi pop opt - Active - plain grp ins rules'+memberDetail.CoverageGroupInfo.onshoreRestrictionCode);
                                                                                            
                                                                                        }
                                                                                    }
                                                                                }
                                                                                else if(memberDetail.CoverageGroupInfo.coverageGroupContractOptionFilterStatus == 'Future' && memberDetail.CoverageGroupInfo.coverageGroupContractOptionStatus == 'Active'){
                                                                                    //if(Date.ValueOf(newEffectiveDate) >= Date.ValueOf(ins.insuringRulesEffectiveDates) ){
                                                                                    system.debug('!!!Date comparision Future multi popCO'+ins.insuringRulesEffectiveDates+'//'+newEffectiveDate+'//'+ins.insuringRulesExpirationDates);
                                                                                    if(Date.ValueOf(ins.insuringRulesEffectiveDates) <= Date.ValueOf(newEffectiveDate) && Date.ValueOf(newEffectiveDate) <= Date.ValueOf(ins.insuringRulesExpirationDates) && ins.insuringRulesExpirationDates != '12/31/9999' || 
                                                                                       (Date.ValueOf(ins.insuringRulesEffectiveDates) <= Date.ValueOf(newEffectiveDate) && ins.insuringRulesExpirationDates == '12/31/9999')){
                                                                                           
                                                                                           system.debug('```Multiple pop Future');
                                                                                           List<String> lstpop = population.split(',');
                                                                                           //List<String> onshoreRest_lst = new List<String>();
                                                                                           system.debug('---lstpop ---------'+lstpop);
                                                                                           if(ins.classesCode != '' ){  
                                                                                               for(String str:lstpop){
                                                                                                   str = str.trim();        
                                                                                                   if(ins.classesCode == str){
                                                                                                       
                                                                                                       /****************************  ONSHORE RESTRICTION Multiple POP  *****************************************/
                                                                                                       //Collect Onshore Restriction codes of all populations to check all restrictions are identical 
                                                                                                       /********************************************************************************************************/
                                                                                                       
                                                                                                       if(String.isNotBlank(ins.onshoreRestriction))
                                                                                                           onshoreRest_lst.add(ins.onshoreRestriction);
                                                                                                       
                                                                                                       
                                                                                                       memberdetail.CoverageGroupInfo.responsibilityType = memberdetail.CoverageGroupInfo.responsibilityType + ins.continuationResponsibilityType + ' (' + ins.classesCode +') ; ';
                                                                                                       memberdetail.CoverageGroupInfo.continuationType = memberdetail.CoverageGroupInfo.continuationType + ins.insuranceContinuationType + ' (' + ins.classesCode +') ; ';
                                                                                                       
                                                                                                       system.debug('%%% multiple pop and  resp & cont'+memberdetail.CoverageGroupInfo.responsibilityType + ';;;'+memberdetail.CoverageGroupInfo.continuationType );
                                                                                                   } 
                                                                                               }
                                                                                               system.debug('%%%%%%Multi pop New onshore'+onshoreRest_lst+onshoreRest_lst.size());
                                                                                               if(onshoreRest_lst.size() == 1 && lstpop.size() >= 1){
                                                                                                   
                                                                                                   for(string onr: onshoreRest_lst){
                                                                                                       memberDetail.CoverageGroupInfo.onshoreRestrictionCode = ACETOnshoreIndicatorVerbiage__c.getValues(onr).Code_Description__c; 
                                                                                                       memberDetail.CoverageGroupInfo.OnshoreRestrictionVerbiage = ACETOnshoreIndicatorVerbiage__c.getValues(onr).Hover_Help_Description__c;   
                                                                                                   } 
                                                                                               }
                                                                                           }  
                                                                                           if(String.isBlank(ins.classesCode)){
                                                                                               system.debug('%%%% Multi pop opt - Future - plain grp ins rules');
                                                                                               memberDetail.CoverageGroupInfo.onshoreRestrictionCode = ACETOnshoreIndicatorVerbiage__c.getValues(ins.onshoreRestriction).Code_Description__c; 
                                                                                               memberDetail.CoverageGroupInfo.OnshoreRestrictionVerbiage = ACETOnshoreIndicatorVerbiage__c.getValues(ins.onshoreRestriction).Hover_Help_Description__c;//pc.onshoreRestrictionError = true;  
                                                                                               system.debug('%%%% Multi pop opt - Future - plain grp ins rules'+memberDetail.CoverageGroupInfo.onshoreRestrictionCode);
                                                                                               
                                                                                           }
                                                                                       }
                                                                                    
                                                                                    
                                                                                }
                                                                                else if(memberDetail.CoverageGroupInfo.coverageGroupContractOptionFilterStatus == 'Termed' && memberDetail.CoverageGroupInfo.coverageGroupContractOptionStatus == 'Active'){
                                                                                    
                                                                                    // if(Date.ValueOf(ins.insuringRulesEffectiveDates) > Date.ValueOf(newEffectiveDate) && Date.ValueOf(newEndDate) == Date.ValueOf(ins.insuringRulesExpirationDates) && ins.insuringRulesExpirationDates != '12/31/9999' || (Date.ValueOf(ins.insuringRulesEffectiveDates) == Date.ValueOf(newEffectiveDate) && ins.insuringRulesExpirationDates == '12/31/9999')){
                                                                                    if(Date.ValueOf(ins.insuringRulesEffectiveDates) <= Date.ValueOf(newEndDate) && Date.ValueOf(newEndDate) <= Date.ValueOf(ins.insuringRulesExpirationDates) && ins.insuringRulesExpirationDates != '12/31/9999' || 
                                                                                       (Date.ValueOf(ins.insuringRulesEffectiveDates) <= Date.ValueOf(newEndDate) && ins.insuringRulesExpirationDates == '12/31/9999')){
                                                                                           
                                                                                           system.debug('```Multiple pop Termed');
                                                                                           List<String> lstpop = population.split(',');
                                                                                           //List<String> onshoreRest_lst = new List<String>();
                                                                                           system.debug('---lstpop ---------'+lstpop);
                                                                                           if(ins.classesCode != '' ){  
                                                                                               for(String str:lstpop){
                                                                                                   str = str.trim();        
                                                                                                   if(ins.classesCode == str){
                                                                                                       
                                                                                                       /****************************  ONSHORE RESTRICTION Multiple POP  *****************************************/
                                                                                                       //Collect Onshore Restriction codes of all populations to check all restrictions are identical 
                                                                                                       /********************************************************************************************************/
                                                                                                       
                                                                                                       if(String.isNotBlank(ins.onshoreRestriction))
                                                                                                           onshoreRest_lst.add(ins.onshoreRestriction);
                                                                                                       
                                                                                                       
                                                                                                       memberdetail.CoverageGroupInfo.responsibilityType = memberdetail.CoverageGroupInfo.responsibilityType + ins.continuationResponsibilityType + ' (' + ins.classesCode +') ; ';
                                                                                                       memberdetail.CoverageGroupInfo.continuationType = memberdetail.CoverageGroupInfo.continuationType + ins.insuranceContinuationType + ' (' + ins.classesCode +') ; ';
                                                                                                       
                                                                                                       system.debug('%%% multiple pop and  resp & cont'+memberdetail.CoverageGroupInfo.responsibilityType + ';;;'+memberdetail.CoverageGroupInfo.continuationType );
                                                                                                   } 
                                                                                               }
                                                                                               system.debug('%%%%%%Multi pop New onshore'+onshoreRest_lst+onshoreRest_lst.size());
                                                                                               if(onshoreRest_lst.size() == 1 && lstpop.size() >= 1){
                                                                                                   
                                                                                                   for(string onr: onshoreRest_lst){
                                                                                                       memberDetail.CoverageGroupInfo.onshoreRestrictionCode = ACETOnshoreIndicatorVerbiage__c.getValues(onr).Code_Description__c; 
                                                                                                       memberDetail.CoverageGroupInfo.OnshoreRestrictionVerbiage = ACETOnshoreIndicatorVerbiage__c.getValues(onr).Hover_Help_Description__c;   
                                                                                                   }
                                                                                               }
                                                                                           }  
                                                                                           if(String.isBlank(ins.classesCode)){
                                                                                               system.debug('%%%% Multi pop opt - Termed - plain grp ins rules');
                                                                                               memberDetail.CoverageGroupInfo.onshoreRestrictionCode = ACETOnshoreIndicatorVerbiage__c.getValues(ins.onshoreRestriction).Code_Description__c; 
                                                                                               memberDetail.CoverageGroupInfo.OnshoreRestrictionVerbiage = ACETOnshoreIndicatorVerbiage__c.getValues(ins.onshoreRestriction).Hover_Help_Description__c;//pc.onshoreRestrictionError = true;  
                                                                                               system.debug('%%%% Multi pop opt - Termed - plain grp ins rules'+memberDetail.CoverageGroupInfo.onshoreRestrictionCode);
                                                                                               
                                                                                           }
                                                                                       }
                                                                                    
                                                                                } 
                                                                            }
                                                                            // Below condition is to check when single/No population is assigned to a contract option
                                                                            else if((memberdetail.CoverageGroupInfo.hasPopulation && ins.classesCode != null && population == ins.classesCode)||(ins.classesCode == null && memberdetail.CoverageGroupInfo.hasPopulation == false)||(memberdetail.CoverageGroupInfo.hasPopulation && ins.classesCode == null)){
                                                                                system.debug('%%%Member grpinsrulepop/Nopop'+population);  
                                                                                system.debug('%%%Status'+memberDetail.CoverageGroupInfo.coverageGroupContractOptionFilterStatus +';;;'+accopt.statusDescription);
                                                                                system.debug('```single/No pop ');
                                                                                
                                                                                if(memberDetail.CoverageGroupInfo.coverageGroupContractOptionFilterStatus == 'Active' && memberDetail.CoverageGroupInfo.coverageGroupContractOptionStatus == 'Active'){
                                                                                    if(Date.ValueOf(ins.insuringRulesEffectiveDates) <= Date.ValueOf(currentDate) && Date.ValueOf(currentDate) <= Date.ValueOf(ins.insuringRulesExpirationDates)){
                                                                                        system.debug('%%%Member grpinsrulepop Inside'); 
                                                                                        system.debug('```single/No pop Active');
                                                                                        
                                                                                        memberdetail.CoverageGroupInfo.cobraAdministrativeIndicator = (ins.cobraAdministrativeIndicator!=null)?ins.cobraAdministrativeIndicator:'';
                                                                                        memberdetail.CoverageGroupInfo.responsibilityType = (ins.continuationResponsibilityType!=null)?ins.continuationResponsibilityType :'' ;
                                                                                        memberdetail.CoverageGroupInfo.continuationType = (ins.insuranceContinuationType!=null)?ins.insuranceContinuationType:'' ;
                                                                                        memberdetail.CoverageGroupInfo.onshoreRestriction = (ins.onshoreRestriction != null)?ins.onshoreRestriction:'' ;
                                                                                        if(!String.isEmpty( memberdetail.CoverageGroupInfo.onshoreRestriction )){
                                                                                            
                                                                                            system.debug('%%%@@@onshoreRestriction with pop/no pop@@ ' + memberdetail.CoverageGroupInfo.onshoreRestriction);
                                                                                            if(EGDetails != null && ACETOnshoreIndicatorVerbiage__c.getValues(memberdetail.CoverageGroupInfo.onshoreRestriction ) != null){
                                                                                                memberDetail.CoverageGroupInfo.onshoreRestrictionCode = ACETOnshoreIndicatorVerbiage__c.getValues(memberdetail.CoverageGroupInfo.onshoreRestriction ).Code_Description__c;
                                                                                                
                                                                                                memberDetail.CoverageGroupInfo.OnshoreRestrictionVerbiage = ACETOnshoreIndicatorVerbiage__c.getValues(memberdetail.CoverageGroupInfo.onshoreRestriction ).Hover_Help_Description__c; 
                                                                                            }
                                                                                        }
                                                                                    }
                                                                                }
                                                                                else if(memberDetail.CoverageGroupInfo.coverageGroupContractOptionFilterStatus == 'Future' && memberDetail.CoverageGroupInfo.coverageGroupContractOptionStatus == 'Active'){
                                                                                    system.debug('!!!Date comparision Future single/no pop CO'+ins.insuringRulesEffectiveDates+'//'+newEffectiveDate+'//'+ins.insuringRulesExpirationDates);
                                                                                    
                                                                                    //if(Date.ValueOf(newEffectiveDate) >= Date.ValueOf(ins.insuringRulesEffectiveDates) ){
                                                                                    if(Date.ValueOf(ins.insuringRulesEffectiveDates) <= Date.ValueOf(newEffectiveDate) && Date.ValueOf(newEffectiveDate) <= Date.ValueOf(ins.insuringRulesExpirationDates) && ins.insuringRulesExpirationDates != '12/31/9999' || 
                                                                                       (Date.ValueOf(ins.insuringRulesEffectiveDates) <= Date.ValueOf(newEffectiveDate) && ins.insuringRulesExpirationDates == '12/31/9999')){
                                                                                           system.debug('%%%Member grpinsrulepop Inside'); 
                                                                                           system.debug('```single/No pop Future');
                                                                                           memberdetail.CoverageGroupInfo.cobraAdministrativeIndicator = (ins.cobraAdministrativeIndicator!=null)?ins.cobraAdministrativeIndicator:'';
                                                                                           memberdetail.CoverageGroupInfo.responsibilityType = (ins.continuationResponsibilityType!=null)?ins.continuationResponsibilityType :'' ;
                                                                                           memberdetail.CoverageGroupInfo.continuationType = (ins.insuranceContinuationType!=null)?ins.insuranceContinuationType:'' ;
                                                                                           memberdetail.CoverageGroupInfo.onshoreRestriction = (ins.onshoreRestriction != null)?ins.onshoreRestriction:'' ;
                                                                                           if(!String.isEmpty( memberdetail.CoverageGroupInfo.onshoreRestriction )){
                                                                                               
                                                                                               system.debug('%%%@@@onshoreRestriction with pop@@ ' + memberdetail.CoverageGroupInfo.onshoreRestriction);
                                                                                               if(EGDetails != null && ACETOnshoreIndicatorVerbiage__c.getValues(memberdetail.CoverageGroupInfo.onshoreRestriction ) != null){
                                                                                                   memberDetail.CoverageGroupInfo.onshoreRestrictionCode = ACETOnshoreIndicatorVerbiage__c.getValues(memberdetail.CoverageGroupInfo.onshoreRestriction ).Code_Description__c;
                                                                                                   
                                                                                                   memberDetail.CoverageGroupInfo.OnshoreRestrictionVerbiage = ACETOnshoreIndicatorVerbiage__c.getValues(memberdetail.CoverageGroupInfo.onshoreRestriction ).Hover_Help_Description__c; 
                                                                                               }
                                                                                           }
                                                                                           
                                                                                       }
                                                                                    
                                                                                    
                                                                                }
                                                                                else if(memberDetail.CoverageGroupInfo.coverageGroupContractOptionFilterStatus == 'Termed' && memberDetail.CoverageGroupInfo.coverageGroupContractOptionStatus == 'Active'){
                                                                                    
                                                                                    //if(Date.ValueOf(ins.insuringRulesEffectiveDates) > Date.ValueOf(newEffectiveDate) && Date.ValueOf(newEndDate) == Date.ValueOf(ins.insuringRulesExpirationDates) && ins.insuringRulesExpirationDates != '12/31/9999' || (Date.ValueOf(ins.insuringRulesEffectiveDates) == Date.ValueOf(newEffectiveDate) && ins.insuringRulesExpirationDates == '12/31/9999')){
                                                                                    if(Date.ValueOf(ins.insuringRulesEffectiveDates) <= Date.ValueOf(newEndDate) && Date.ValueOf(newEndDate) <= Date.ValueOf(ins.insuringRulesExpirationDates) && ins.insuringRulesExpirationDates != '12/31/9999' || 
                                                                                       (Date.ValueOf(ins.insuringRulesEffectiveDates) <= Date.ValueOf(newEndDate) && ins.insuringRulesExpirationDates == '12/31/9999')){
                                                                                           
                                                                                           system.debug('%%%Member grpinsrulepop Inside'); 
                                                                                           system.debug('```single/No pop Termed');
                                                                                           memberdetail.CoverageGroupInfo.cobraAdministrativeIndicator = (ins.cobraAdministrativeIndicator!=null)?ins.cobraAdministrativeIndicator:'';
                                                                                           memberdetail.CoverageGroupInfo.responsibilityType = (ins.continuationResponsibilityType!=null)?ins.continuationResponsibilityType :'' ;
                                                                                           memberdetail.CoverageGroupInfo.continuationType = (ins.insuranceContinuationType!=null)?ins.insuranceContinuationType:'' ;
                                                                                           memberdetail.CoverageGroupInfo.onshoreRestriction = (ins.onshoreRestriction != null)?ins.onshoreRestriction:'' ;
                                                                                           if(!String.isEmpty( memberdetail.CoverageGroupInfo.onshoreRestriction )){
                                                                                               
                                                                                               system.debug('%%%@@@onshoreRestriction with pop@@ ' + memberdetail.CoverageGroupInfo.onshoreRestriction);
                                                                                               if(EGDetails != null && ACETOnshoreIndicatorVerbiage__c.getValues(memberdetail.CoverageGroupInfo.onshoreRestriction ) != null){
                                                                                                   memberDetail.CoverageGroupInfo.onshoreRestrictionCode = ACETOnshoreIndicatorVerbiage__c.getValues(memberdetail.CoverageGroupInfo.onshoreRestriction ).Code_Description__c;
                                                                                                   //memberDetail.CoverageGroupInfo.OnshoreRestriction = codeVsOnshoreIndicator.get(memberDetail.CoverageGroupInfo.onshoreRestrictionCode);
                                                                                                   memberDetail.CoverageGroupInfo.OnshoreRestrictionVerbiage = ACETOnshoreIndicatorVerbiage__c.getValues(memberdetail.CoverageGroupInfo.onshoreRestriction ).Hover_Help_Description__c; 
                                                                                               }
                                                                                           }
                                                                                       }
                                                                                } // End If Termed
                                                                            }// End if No pop
                                                                            
                                                                        }// End for
                                                                        
                                                                        //if(Memberdetail.CoverageGroupInfo.haspopulation!=null && Memberdetail.CoverageGroupInfo.haspopulation &&  memberdetail.CoverageGroupInfo!=null && memberdetail.CoverageGroupInfo.onshorerestrictioncode!=null && memberdetail.CoverageGroupInfo.onshorerestrictioncode.contains(';'))
                                                                        
                                                                        if(Memberdetail.CoverageGroupInfo.haspopulation!=null && Memberdetail.CoverageGroupInfo.haspopulation && String.isNotBlank(memberdetail.CoverageGroupInfo.contractOptionPopulations) && memberdetail.CoverageGroupInfo.contractOptionPopulations.contains(','))						{
                                                                            
                                                                            system.debug('~~~~~Inside Onshore restriction with population');
                                                                            
                                                                            if(( MemberDetail.CoverageGroupInfo.OnshoreRestrictionCode == '08' ||  MemberDetail.CoverageGroupInfo.OnshoreRestrictionCode=='07' ||
                                                                                (MemberDetail.CoverageGroupInfo.OnshoreRestrictionCode =='06'  && (originatorType == 'Member' || originatorType == 'Provider' )) ||
                                                                                (MemberDetail.CoverageGroupInfo.OnshoreRestrictionCode =='05' && originatorType != 'Member' && originatorType != 'Provider')||
                                                                                (MemberDetail.CoverageGroupInfo.OnshoreRestrictionCode =='04'  && originatorType == 'Member')
                                                                               ) ){
                                                                                   memberDetail.CoverageGroupInfo.isRestrict = (isOnshore == false)?true:false;
                                                                                   memberDetail.CoverageGroupInfo.onshoreRestrictionDisp = 'Yes';                                                  
                                                                                   
                                                                               }
                                                                            else if(MemberDetail.CoverageGroupInfo.OnshoreRestrictionCode=='01' || MemberDetail.CoverageGroupInfo.OnshoreRestrictionCode=='02' || MemberDetail.CoverageGroupInfo.OnshoreRestrictionCode=='03'){
                                                                                
                                                                                memberDetail.CoverageGroupInfo.isRestrict = false;
                                                                                memberDetail.CoverageGroupInfo.onshoreRestrictionDisp = 'No';                                                  
                                                                                
                                                                                
                                                                            }
                                                                            else if(MemberDetail.CoverageGroupInfo.OnshoreRestrictionCode =='00'){
                                                                                memberDetail.CoverageGroupInfo.isRestrict = false;
                                                                                memberDetail.CoverageGroupInfo.onshoreRestrictionDisp = '';
                                                                                memberDetail.CoverageGroupInfo.OnshoreRestrictionVerbiage ='';                                                  
                                                                                
                                                                            }else {
                                                                                memberDetail.CoverageGroupInfo.isRestrict = false;
                                                                                memberDetail.CoverageGroupInfo.onshoreRestrictionDisp = (String.isBlank(memberDetail.CoverageGroupInfo.OnshoreRestrictionVerbiage))?'':'No';                                                 
                                                                                
                                                                            }
                                                                            
                                                                            system.debug('###$$$ multip pop xyz'+MemberDetail.CoverageGroupInfo.OnshoreRestrictionCode+memberDetail.CoverageGroupInfo.onshoreRestrictionDisp+memberDetail.CoverageGroupInfo.isRestrict);
                                                                            system.debug('###$$$ multip pop'+memberDetail.CoverageGroupInfo.OnshoreRestrictionVerbiage );
                                                                            system.debug(LoggingLevel.INFO, '@@@@multi pop IsRestrict '+memberDetail.CoverageGroupInfo.IsRestrict +memberDetail.CoverageGroupInfo.onshoreRestrictionDisp);
                                                                            
                                                                            
                                                                        }
                                                                        /*************************************************************************************/
                                                                        //Onshore restriction logic for a group with single/No populations to a contract option
                                                                        /*************************************************************************************/
                                                                        else{
                                                                            system.debug(LoggingLevel.INFO,'@@@@code'+MemberDetail.CoverageGroupInfo.OnshoreRestrictionCode );
                                                                            system.debug(LoggingLevel.INFO,'@@@@code'+MemberDetail.CoverageGroupInfo.OnshoreRestrictionVerbiage);
                                                                            system.debug(LoggingLevel.INFO,'@@@@'+MemberDetail.CoverageGroupInfo.OnshoreRestrictionDisp);
                                                                            system.debug(LoggingLevel.INFO,'@@@@IsOnshore'+isOnshore);
                                                                            if(( MemberDetail.CoverageGroupInfo.OnshoreRestrictionCode == '07' || MemberDetail.CoverageGroupInfo.OnshoreRestrictionCode == '08')|| 
                                                                               (MemberDetail.CoverageGroupInfo.OnshoreRestrictionCode == '05' && originatorType != 'Member' && originatorType != 'Provider' )||
                                                                               (MemberDetail.CoverageGroupInfo.OnshoreRestrictionCode == '06' && (originatorType == 'Member' || originatorType == 'Provider'))||
                                                                               (MemberDetail.CoverageGroupInfo.OnshoreRestrictionCode == '04' && originatorType == 'Member' )
                                                                               
                                                                              ){
                                                                                  memberDetail.CoverageGroupInfo.isRestrict = (isOnshore == false)?true:false;
                                                                                  MemberDetail.CoverageGroupInfo.onshoreRestrictionDisp = 'Yes';
                                                                              }
                                                                            else if(MemberDetail.CoverageGroupInfo.OnshoreRestrictionCode == '03' || MemberDetail.CoverageGroupInfo.OnshoreRestrictionCode == '02'||MemberDetail.CoverageGroupInfo.OnshoreRestrictionCode == '01'){
                                                                                memberDetail.CoverageGroupInfo.isRestrict = false;
                                                                                MemberDetail.CoverageGroupInfo.onshoreRestrictionDisp = 'No'; 
                                                                            }
                                                                            else if(MemberDetail.CoverageGroupInfo.OnshoreRestrictionCode =='00'){
                                                                                memberDetail.CoverageGroupInfo.isRestrict = false;
                                                                                MemberDetail.CoverageGroupInfo.onshoreRestrictionDisp = '';  
                                                                                memberDetail.CoverageGroupInfo.OnshoreRestrictionVerbiage ='';                                                
                                                                                
                                                                            }else {
                                                                                memberDetail.CoverageGroupInfo.isRestrict = false;
                                                                                MemberDetail.CoverageGroupInfo.onshoreRestrictionDisp = (String.isBlank(memberDetail.CoverageGroupInfo.OnshoreRestrictionVerbiage))?'':'No';                                                  
                                                                                
                                                                            }
                                                                            system.debug(LoggingLevel.INFO, '@@@@IsRestrict '+memberDetail.CoverageGroupInfo.IsRestrict +MemberDetail.CoverageGroupInfo.OnshoreRestrictionDisp);
                                                                            
                                                                        }  
                                                                        
                                                                        
                                                                    }// Group Insuring Rules - End If
                                                                    
                                                                }
                                                            }
                                                        }//Customer Purchase - End If
                                                    }
                                                }
                                            }// Customer Account Option - End Id
                                        }
                                    } // Customer Account Empty check
                                    
                                    /*memberDetail.CoverageGroupInfo.GroupSize = (EGDetails.sizeDefinitionDescription != null)?EGDetails.sizeDefinitionDescription:'';
                                    memberDetail.CoverageGroupInfo.enrollmentMethod= (EGDetails.enrollmentType != null)?EGDetails.enrollmentType:'';
                                    memberDetail.GroupSize = (EGDetails.sizeDefinitionDescription != null)?EGDetails.sizeDefinitionDescription:'';
                                    memberDetail.enrollmentMethod= (EGDetails.enrollmentType != null)?EGDetails.enrollmentType:'';*/
                                    
                                    
                                    /*system.debug('%%%%%%%% Continuation type , responsibility, onshore restriction code , onshore restriction text'+memberdetail.continuationType + ' %% '+memberdetail.responsibilityType +' %% '+memberDetail.PreferredCoverage.onshoreRestrictionCode +' %% '+memberDetail.PreferredCoverage.onshoreRestriction);
                                    //US1699536 starts
                                    memberDetail.groupSettings = new List<ACETMemberDetail.cobAttestation>();
                                    if(EGDetails.groupSettings != null) {
                                    for(ACETLGT_GetEmployerGroupAdapterJSON2Apex.cobAttestation groupSet:EGDetails.groupSettings) {
                                    ACETMemberDetail.cobAttestation settings = new ACETMemberDetail.cobAttestation();
                                    settings.cobAttestationFrequency = (groupSet.cobAttestationFrequency != null)?groupSet.cobAttestationFrequency:'';
                                    settings.cobAttestationDenyGracePeriod = (groupSet.cobAttestationDenyGracePeriod != null)?groupSet.cobAttestationDenyGracePeriod:'';
                                    settings.religiousExemptionTypeDescription = (groupSet.religiousExemptionTypeDescription != null)?groupSet.religiousExemptionTypeDescription:'';
                                    settings.effectiveDate = (groupSet.effectiveDate != null)?groupSet.effectiveDate:'';
                                    settings.expirationDate = (groupSet.expirationDate != null)?groupSet.expirationDate:'';
                                    memberDetail.groupSettings.add(settings);
                                    
                                    }
                                    }
                                    //US1699536 ends  */
                                    if(EGDetails.groupContact != null){  
                                        for(ACETLGT_GetEmployerGroupAdapterJSON2Apex.GroupContact contactData:EGDetails.groupContact){
                                            if(contactData != Null && contactData.roleDescription == 'Benefit Administrator' && (contactData.primaryIndicatorDescription  == 'Yes' || contactData.primaryIndicatorDescription == 'Primary')){
                                                firstName  = (contactData.firstName != Null)?contactData.firstName:'' ;
                                                middleName  = (contactData.middleName != Null)?contactData.middleName:'';
                                                lastName  = (contactData.lastName != Null)?contactData.lastName:'' ;
                                                memberDetail.CoverageGroupInfo.benefitAdmin = firstName + ' ' +middleName + ' ' + lastName ;
                                                //memberDetail.benefitAdmin = firstName + ' ' +middleName + ' ' + lastName ;
                                                memberDetail.CoverageGroupInfo.benefitAdminPhone = '';
                                                ACETLGT_GroupDetail.groupContactInfo benefitAdminInfo = new ACETLGT_GroupDetail.groupContactInfo();
                                                benefitAdminInfo.contactPhones = new list<ACETLGT_GroupDetail.contactPhoneInfo>();
                                                
                                                if(contactData.phone != Null && !contactData.phone.isEmpty()){
                                                    for(ACETLGT_GetEmployerGroupAdapterJSON2Apex.Phone phoneInfo:contactData.phone){
                                                        ACETLGT_GroupDetail.contactPhoneInfo adminPhoneInfo = new ACETLGT_GroupDetail.contactPhoneInfo();
                                                        adminPhoneInfo.phoneNumber = (phoneInfo != Null && phoneInfo.telephoneNumber != Null)?phoneInfo.telephoneNumber:'' ;
                                                        
                                                        if(adminPhoneInfo != Null)
                                                            benefitAdminInfo.contactPhones.add(adminPhoneInfo );
                                                    }
                                                    if(benefitAdminInfo.contactPhones != Null)
                                                        memberDetail.CoverageGroupInfo.benefitAdminPhone = benefitAdminInfo.contactPhones[0].phoneNumber ;
                                                }
                                            }
                                            
                                        }
                                    } 
                                    else
                                    {
                                        memberDetail.CoverageGroupInfo.benefitAdmin = '';
                                        memberDetail.CoverageGroupInfo.benefitAdminPhone = '';
                                    }  
                                    
                                } //pc attributes null check
                                system.debug('*** Values CHeck New'+memberDetail.CoverageGroupInfo);
                                //system.debug('*** Values CHeck Old'+memberDetail.benefitAdminPhone+'///'+ memberDetail.enrollmentMethod);
                            }
                            
                            
                            calloutResult.Success = true;
                            calloutResult.Message = '';
                            calloutResult.response = memberDetail;
                        }
                    }
                }
                else
                {
                    calloutResult = ParseFailureResponse(Response);   
                    calloutResult.Success = false;
                    calloutResult.statusCode=response!=null?response.getStatusCode():null;
                }
            }
            
        }
        catch(Exception ex){
            system.debug(LoggingLevel.INFO, 'Exception in ProcessResponse. Details: ' + ex.getstackTraceString()); 
            calloutResult.Success = false;
            calloutResult.response = memberDetail;
            calloutResult.Message = ex.getMessage();
            calloutResult.MessageSeverity = ApexPages.Severity.ERROR;
            calloutResult.statusCode=999;
        }
        return calloutResult;
    }
    
    //US2167804	code move starts
    public ACETWSCalloutResult getEmployerGroupDetail(String groupNumber) {
        ACETWSCalloutResult oACETWSCalloutResult = new ACETWSCalloutResult();
        ACETGroupDetail oACETGroupDetail;

        try {            
            HttpResponse Response;
            GetEndpoint();
            GetRequestBody(groupNumber);
            Response = Send(OAuthConfig);
            
            //response.setStatusCode(500);
            System.debug('Response----->'+Response);
            oACETWSCalloutResult.statusCode = response!=null ? response.getStatusCode() : null;
            
            if (Response.getStatusCode() == 200) {
                oACETWSCalloutResult.Success = true;
                oACETWSCalloutResult.Message = '';
                oACETWSCalloutResult.Response = parseSuccessAdapterResponse(ReplaceKeywords(Response.getBody()));  
            } else {
                oACETWSCalloutResult = ParseFailureResponse(Response);   
                oACETWSCalloutResult.Success = false;
                oACETWSCalloutResult.Message = ACETWebserviceHelper.getErrorMessageFromCode(response.getStatusCode());
                oACETWSCalloutResult.statusCode = response!=null ? response.getStatusCode() : null;
            }            
        }
        catch(Exception ex) {
            System.debug(LoggingLevel.INFO, 'Exception in GetEmployer. Details: ' + ex + ex.getLineNumber() +ex.getMessage()); 
            oACETWSCalloutResult.Success = false;
            oACETWSCalloutResult.Message = ex.getMessage();
            oACETWSCalloutResult.MessageSeverity = ApexPages.Severity.ERROR;
            oACETWSCalloutResult.statusCode = 999;            
        }    
        System.debug('oACETWSCalloutResult: ' + oACETWSCalloutResult);        
        return oACETWSCalloutResult;
    }
    
    private ACETLGT_GroupDetail parseSuccessAdapterResponse(String ResponseBody) {
       oACETGroupDetail = new ACETLGT_GroupDetail();
       oACETGroupDetail.genGroupInfo= new ACETLGT_GroupDetail.groupGeneralInfo();
       oACETGroupDetail.additionalGroupInfo = new ACETLGT_GroupDetail.addGroupInfo();
       oACETGroupDetail.groupEmployeeCountInfoList = new List<ACETLGT_GroupDetail.employeeCountInfo>(); 
       oACETGroupDetail.groupAddressInfoList = new List<ACETLGT_GroupDetail.AddressInfo>();
       oACETGroupDetail.polContract = new List<ACETLGT_GroupDetail.PolicyContract>();  //US912388 
       oACETGroupDetail.groupInsuringRules = new List<ACETLGT_GroupDetail.GroupInsuringRules>(); 
       
       ACETLGT_GetEmployerGroupAdapterJSON2Apex.EmployerGroup EGDetails;
         
       ACETLGT_GetEmployerGroupAdapterJSON2Apex ACETEGDJSON2Apex = (ACETLGT_GetEmployerGroupAdapterJSON2Apex)JSON.deserialize(ResponseBody, ACETLGT_GetEmployerGroupAdapterJSON2Apex.class);
       System.debug('ACETEGDJSON2Apex --->'+ACETEGDJSON2Apex);
       EGDetails = ACETEGDJSON2Apex.GetEmployerGroup.GetEmployerGroupResponse.EmployerGroup;
       
       
       generalGroupInfoMapping(EGDetails);
       groupEmployeeCountMapping(EGDetails);
       groupAddressMapping(EGDetails);
       groupContactInfoMapping(EGDetails);
       groupInsuringRulesMapping(EGDetails);      //getemp V3
       groupContractVersioningMapping(EGDetails);  //getemp V3  // Combining Policy Contract,Insuring Rules and Benefits  
       return oACETGroupDetail;    
    }
    
    //getemp V3 starts
    private void groupInsuringRulesMapping(ACETLGT_GetEmployerGroupAdapterJSON2Apex.EmployerGroup EGDetails) {
        if(EGDetails.GroupInsuringRules != null){
             for(ACETLGT_GetEmployerGroupAdapterJSON2Apex.GroupInsuringRules ins : EGDetails.GroupInsuringRules ) {
                    ACETLGT_GroupDetail.GroupInsuringRules rule = new ACETLGT_GroupDetail.GroupInsuringRules();
                    rule.classesCode = (ins.classesCode != null)?ins.classesCode.replace(',',''):'';
                    rule.cobraAdministrativeIndicator = (ins.cobraAdministrativeIndicator!=null)?ins.cobraAdministrativeIndicator:'';
                    rule.continuationResponsibilityType = (ins.continuationResponsibilityType!=null) ? ins.continuationResponsibilityType : '';
                    rule.insuranceContinuationType = (ins.insuranceContinuationType!=null) ? ins.insuranceContinuationType : '';
                    rule.onshoreRestriction = (ins.onshoreRestriction!= null) ? ins.onshoreRestriction : '';
                    rule.insuringRulesEffectiveDates = (ins.insuringRulesEffectiveDates != Null) ? string.valueOf(ACETUtility.format(Date.valueOf(ins.insuringRulesEffectiveDates ))) : '';
                    rule.insuringRulesExpirationDates = (ins.insuringRulesExpirationDates != Null) ? string.valueOf(ACETUtility.format(Date.valueOf(ins.insuringRulesExpirationDates))) : '12/31/9999';
                    rule.insuringRulesEffectiveDatesNoFormat = (ins.insuringRulesEffectiveDates != Null) ? string.valueOf(Date.valueOf(ins.insuringRulesEffectiveDates )) : '';
                    rule.insuringRulesExpirationDatesNoFormat = (ins.insuringRulesExpirationDates != Null) ? string.valueOf(Date.valueOf(ins.insuringRulesExpirationDates)) : '9999-12-31';
                    rule.pcpRadomization= (ins.pcpRadomization!=null) ? ins.pcpRadomization : '';
                    rule.survivingSpouseIndicator= (ins.survivingSpouseIndicator!=null) ? ins.survivingSpouseIndicator : '';
                    rule.newBornAutoAddIndicator= (ins.newBornAutoAddIndicator!= null) ? ins.newBornAutoAddIndicator : '';
                    rule.countNewbornForCoverageLevelCodeIndicator= (ins.countNewbornForCoverageLevelCodeIndicator!=null) ? ins.countNewbornForCoverageLevelCodeIndicator : '';
                    rule.earlyRetirementIndicator = (ins.earlyRetirementIndicator !=null) ? ins.earlyRetirementIndicator : '';
                    rule.earlyRetirementMinimumAge= (ins.earlyRetirementMinimumAge!= null) ? ins.earlyRetirementMinimumAge : '';
                    rule.workingRetirementIndicator= (ins.workingRetirementIndicator!=null) ? ins.workingRetirementIndicator : '';
                    rule.workingRetirementMinimumAge= (ins.workingRetirementMinimumAge!= null) ? ins.workingRetirementMinimumAge :'';
                    oACETGroupDetail.groupInsuringRules.add(rule); 
            }
            system.debug('@@@ grpinsrule'+oACETGroupDetail.groupInsuringRules);
        }
    }
    
    private void groupContractVersioningMapping(ACETLGT_GetEmployerGroupAdapterJSON2Apex.EmployerGroup EGDetails) {        
        if(!EGDetails.CustomerAccount.isEmpty()){            
            for(ACETLGT_GetEmployerGroupAdapterJSON2Apex.CustomerAccount acc: EGDetails.customerAccount) {
                
                OriginalContractDate = (acc.originalContractDate != Null) ? String.valueOf(ACETUtility.format(Date.valueOf(acc.originalContractDate))) : '';
                if(acc.customerAccountOption != null) {
                    for(ACETLGT_GetEmployerGroupAdapterJSON2Apex.CustomerAccountOption accopt: acc.customerAccountOption) {                        
                        ACETLGT_GroupDetail.PolicyContract pc = new ACETLGT_GroupDetail.PolicyContract();
                        pc.polGenGroupInfo = new ACETLGT_Groupdetail.PolicyGeneralInfo();
                        pc.GroupPlanBenefitList = new list<ACETLGT_Groupdetail.GroupPlanWrapper>();
                        pc.insurRules = new list<ACETLGT_Groupdetail.InsuredRules>();
                        pc.policyActualStatus = (accopt.statusDescription != null)?accopt.statusDescription:'';
                        
                        if(pc.policyActualStatus == 'Active') {
                            /***POLICY CONTRACT MAPPING***/
                            pc.population = '';
                            pc.policyOptId = '';
                            pc.benefitBundleId = '';
                            pc.policyConId  = (accopt.customerAccountOptionId != null)?accopt.customerAccountOptionId:'';
                            
                        if(accopt.customerAccountGroupPopulation != null){
                            for(ACETLGT_GetEmployerGroupAdapterJSON2Apex.CustomerAccountGroupPopulation groupPop:accopt.customerAccountGroupPopulation){
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
                            
                            pc.hasPopulation = (pc.population == '') ? false : true;
                            ACETLGT_GroupDetail.GroupPlanWrapper groupPlanCustomerAcc = new ACETLGT_GroupDetail.GroupPlanWrapper();
                            ACETLGT_GroupDetail.AgeBandWrap ageBandInfo;  
                            ACETLGT_GroupDetail.FamilyBasedWrap familyBasedInfo;
                            if(accopt.customerPurchase != null) {
                                for(ACETLGT_GetEmployerGroupAdapterJSON2Apex.customerPurchase custPurch : accopt.customerPurchase) {
                                    if(pc.policyOptId == '') {
                                        pc.policyOptId = (custPurch.memberGroupContractPlanOptionID != null)?custPurch.memberGroupContractPlanOptionID:'';
                                    } else {
                                        pc.policyOptId = pc.policyOptId + ', ' + ((custPurch.memberGroupContractPlanOptionID != null)?custPurch.memberGroupContractPlanOptionID:'');
                                    }
                                    if(pc.benefitBundleId == '') {
                                        pc.benefitBundleId = (custPurch.benefitBundleOptionID != null)?custPurch.benefitBundleOptionID:'';
                                    } else {
                                        pc.benefitBundleId = pc.benefitBundleId + ', ' + ((custPurch.benefitBundleOptionID != null)?custPurch.benefitBundleOptionID:'');
                                    }
                                    
                                    //Group Plan Topic
                                    groupPlanCustomerAcc = new ACETLGT_GroupDetail.GroupPlanWrapper();
                                    groupPlanCustomerAcc.ageBandGroupPlanList = new List<ACETLGT_GroupDetail.AgeBandWrap>();
                                    groupPlanCustomerAcc.familyBasedGroupPlanList = new List<ACETLGT_GroupDetail.FamilyBasedWrap>();
                                    groupPlanCustomerAcc.groupId = EGDetails.groupNumber;
                                    groupPlanCustomerAcc.contractID = (custPurch.memberGroupContractPlanOptionID != Null)?custPurch.memberGroupContractPlanOptionID:'';
                                    groupPlanCustomerAcc.bundleID = (custPurch.benefitBundleOptionID != Null)?custPurch.benefitBundleOptionID:'';                
                                    groupPlanCustomerAcc.planID = (custPurch.benefitBasePlan != Null)?custPurch.benefitBasePlan:'';                
                                    groupPlanCustomerAcc.Product = (custPurch.benefitPlanDescription != Null)?custPurch.benefitPlanDescription:'';                
                                    groupPlanCustomerAcc.Accumulator = (custPurch.timePeriodQualifier != Null)?custPurch.timePeriodQualifier:'';
                                    //US957991 starts
                                    groupPlanCustomerAcc.hsaElected = (custPurch.hsaVendorName != Null) ? 'Yes' : 'No';
                                    groupPlanCustomerAcc.hsaAvailable = (custPurch.hsaVendorName != Null) ? 'Yes' : '';
                                    groupPlanCustomerAcc.administeredBy = (custPurch.hsaVendorName != Null) ? custPurch.hsaVendorName : 'N/A';
                                    groupPlanCustomerAcc.phone = (custPurch.hsaVendorName != Null) ? '800-791-9361' : 'N/A';
                                    //US957991 ends
                                    networkId = '';
                                    if(custPurch.networkScheduleId != null && custPurch.networkScheduleId.size() > 0) {
                                        Set<string> uniqueNetworks = new Set<string>(); 
                                        List<string> uniqueNetworksList = new List<string>();
                                        uniqueNetworks.addAll(custPurch.networkScheduleId);
                                        uniqueNetworksList.addAll(uniqueNetworks);
                                        
                                        Integer networkIdSize =  uniqueNetworksList.size();
                                        for (Integer j = networkIdSize ; j > 0; j--) {
                                            if(networkId == '' || networkId == null) {
                                                networkId = uniqueNetworksList[j-1];
                                            }
                                            else {
                                                networkId = networkId+ ', ' +uniqueNetworksList[j-1];
                                            }
                                        }
                                    }
                                    
                                    groupPlanCustomerAcc.Network =  networkId;               
                                    groupPlanCustomerAcc.effecDate = (custPurch.coverageStartDate != Null) ? String.valueOf(ACETUtility.format(Date.valueOf(custPurch.coverageStartDate))) : '';
                                    groupPlanCustomerAcc.endDate = (custPurch.coverageExpirationDate != Null) ? String.valueOf(ACETUtility.format(Date.valueOf(custPurch.coverageExpirationDate))) : '';
                                    groupPlanCustomerAcc.planID = (custPurch.benefitBasePlan != Null) ? custPurch.benefitBasePlan : '';
                                    groupPlanCustomerAcc.PlanClass = (pc.population != null) ? pc.population : '';
                                    groupPlanCustomerAcc.planOptionDesc = (custPurch.benefitPlanDescription != null) ? custPurch.benefitPlanDescription : '';
                                    
                                    groupPlanCustomerAcc.PlanMettalicLevel = (custPurch.planMetallicLevel != Null) ? custPurch.planMetallicLevel : 'N/A';
                                    groupPlanCustomerAcc.Gated = (custPurch.gatedProductIndicator != null && custPurch.gatedProductIndicator != '') ? ((custPurch.gatedProductIndicator == '1') ? 'Y' : ((custPurch.gatedProductIndicator == '0') ? 'N' : '')) : '';                
                                    
                                    groupPlanCustomerAcc.PCPRequired =  groupPlanCustomerAcc.Gated;
                                    groupPlanCustomerAcc.domPartner = (custPurch.domesticPartnerIndicator!= null && custPurch.domesticPartnerIndicator!= '') ? ((custPurch.domesticPartnerIndicator== 'true') ? 'Y' : ((custPurch.domesticPartnerIndicator== 'false') ? 'N' : '')) : '';
                                    
                                    if(custPurch.BillingSchedule != null) {                                        
                                        for(ACETLGT_GetEmployerGroupAdapterJSON2Apex.BillingSchedule billingSched : custPurch.BillingSchedule) {
                                            if(billingSched.contractTypeCode != null) {
                                                familyBasedInfo = new ACETLGT_GroupDetail.FamilyBasedWrap();
                                                familyBasedInfo.contractTypeCode = billingSched.contractTypeCode;
                                                familyBasedInfo.contractTypeDescription = billingSched.contractTypeDescription;
                                                familyBasedInfo.amount = billingSched.amount;
                                                groupPlanCustomerAcc.familyBasedGroupPlanList.add(familyBasedInfo);
                                            }
                                            else {
                                                if(billingSched.ageBandToValue != null && billingSched.ageBandFromValue != null) {
                                                    Integer ageBandToVal = Integer.valueOf(billingSched.ageBandToValue);
                                                    Integer ageBandFromVal = Integer.valueOf(billingSched.ageBandFromValue);
                                                if(ageBandToVal > 99)
                                                    ageBandToVal = 99;
                                                    for(Integer i = ageBandFromVal; i <= ageBandToVal; i++) {
                                                        ageBandInfo = new ACETLGT_GroupDetail.AgeBandWrap();
                                                        ageBandInfo.AgeBand = String.valueOf(i);
                                                        ageBandInfo.premium = (billingSched.amount != null && billingSched.amount != '') ? billingSched.amount.substring(0,billingSched.amount.length()-2) : '0'; //Modified for US812201
                                                        groupPlanCustomerAcc.ageBandGroupPlanList.add(ageBandInfo); 
                                                        groupPlanCustomerAcc.ageBandGroupPlanList.sort();                                    
                                                    }                                
                                                } 
                                            }                            
                                        }
                                    }
                                    pc.GroupPlanBenefitList.add(groupPlanCustomerAcc);                                                        
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
                            
                            pc.effectiveDate = (accopt.startDate != null) ? string.valueOf(ACETUtility.format(Date.valueOf(accopt.startDate))) : '';
                            pc.effectiveDatenoformat = (accopt.startDate != null) ? string.valueOf(Date.valueOf(accopt.startDate)) : '';
                            pc.endDate = (accopt.terminationDate != null) ? string.valueOf(ACETUtility.format(Date.valueOf(accopt.terminationDate))) : '';
                            pc.endDatenoformat = (accopt.terminationDate != null) ? string.valueOf(Date.valueOf(accopt.terminationDate)) : '';
                            pc.migrated = (acc.migrationIndicator != null) ? (acc.migrationIndicator.equals('true')?'Yes':'No') : ''; 
                            pc.stateOfIssueCode = (accopt.stateOfIssueDescription != null) ? accopt.stateOfIssueDescription : '';
                        pc.groupSitusState = (accopt.stateOfIssueCode != null)?accopt.stateOfIssueCode:'';
                        pc.exchangeType = (accopt.exchangeTypeDescription != null)?accopt.exchangeTypeDescription:'';     //US1744101
                        pc.polGenGroupInfo.contractId = (accopt.customerAccountOptionId != null)?accopt.customerAccountOptionId:'';
                            pc.polGenGroupInfo.contractDesc = (accopt.customerAccountOptionDescription != null) ? accopt.customerAccountOptionDescription : '';
                            pc.polGenGroupInfo.contractStatus = (accopt.statusDescription != null) ? accopt.statusDescription : '';
                            pc.polGenGroupInfo.contractEffectiveDate = (accopt.startDate != null) ? string.valueOf(ACETUtility.format(Date.valueOf(accopt.startDate))) : '';
                            pc.polGenGroupInfo.contractEndDate = (accopt.terminationDate != null) ? string.valueOf(ACETUtility.format(Date.valueOf(accopt.terminationDate))) : '';
                            pc.polGenGroupInfo.memberGroupId = (EGDetails.groupNumber != null) ? EGDetails.groupNumber : '';
                            pc.polGenGroupInfo.contractType = (accopt.customerAccountOptionType != null) ? accopt.customerAccountOptionType : '';
                            pc.polGenGroupInfo.originalContractDate = (acc.originalContractDate != null) ? string.valueOf(ACETUtility.format(Date.valueOf(acc.originalContractDate))) : '';
                            pc.polGenGroupInfo.migratedContract = (acc.migrationIndicator != null) ? (acc.migrationIndicator.equals('true')?'Yes':'No') : '';
                            pc.polGenGroupInfo.enrollmetIns = (accopt.enrollmentInsuringRulesPopulationIndicator != null) ? (accopt.enrollmentInsuringRulesPopulationIndicator.equals('true') ? 'Yes' : 'No') : '';
                            pc.polGenGroupInfo.situsState = (accopt.stateOfIssueCode != null) ? accopt.stateOfIssueCode : '';
                            pc.polGenGroupInfo.contractDCN = '';
                            pc.polGenGroupInfo.participationType = '';
                            pc.polGenGroupInfo.sourceSys = (acc.migrationSourceSystem != null && acc.migrationSourceSystem.name != null) ? acc.migrationSourceSystem.name : 'N/A';
                            pc.polGenGroupInfo.sourceSysId = (acc.migrationSourceSystem != null && acc.migrationSourceSystem.id != null) ? acc.migrationSourceSystem.id : 'N/A';
                            pc.polGenGroupInfo.billingPrefType = '';
                            pc.polGenGroupInfo.renewalDate = (accopt.renewalDate != null)?String.valueOf(ACETUtility.format(Date.valueOf(accopt.renewalDate))) : '';
                            
                            //Start of Onshore Restriction Changes
                            system.debug('!!!'+oACETGroupDetail.groupInsuringRules);
                            
                            if(oACETGroupDetail.groupInsuringRules != null){
                                pc.OnshoreRestrictionText = '';
                            pc.OnshoreRestrictionCode ='00';
                            pc.OnshoreRestrictionTooltip ='';
                            pc.continuationType ='';
                            pc.responsibilityType ='';
                            pc.onshoreRestrictionBoolean = '';
                            pc.onshoreRestrictionError = false;
                            pc.isRestrict = false;
                            Set<String> onshoreRest_lst = new Set<String>();
                                                            
                                for(ACETLGT_GroupDetail.GroupInsuringRules ins : oACETGroupDetail.groupInsuringRules ){
                                    system.debug('----------ins------'+ins);
                                    String mon = (String.valueOf(Date.Today().month()).length() == 1 ? ('0'+String.Valueof(Date.Today().month())) : String.valueof(Date.Today().month()));
                                    String day = (String.valueOf(Date.Today().day()).length() == 1 ? ('0'+String.Valueof(Date.Today().day())) : String.Valueof(Date.Today().day()));
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
                                for(ACETLGT_GetEmployerGroupAdapterJSON2Apex.CustomerAccountInsuringRules rul:accopt.customerAccountInsuringRules)
                                {
                                    ACETLGT_GroupDetail.InsuredRules ins = new ACETLGT_GroupDetail.InsuredRules();
                                    
                                    ins.hasPopulation = (rul.classesDescription != null )?true:false;
                                    
                                    String currentDate = Date.Today().year() + '-' + Date.Today().month() + '-' + Date.Today().day();
                                    if(rul.insuringRuleEffectiveDates != null && (Date.valueOf(rul.insuringRuleEffectiveDates ) > Date.valueOf(currentDate))){ 
                                        ins.Status = 'Future';
                                    } else if(rul.insuringRuleExpirationDates != null && (Date.valueOf(rul.insuringRuleExpirationDates) < Date.valueOf(currentDate))){
                                        ins.Status = 'Termed';
                                    } else if(rul.insuringRuleEffectiveDates != null && rul.insuringRuleExpirationDates != null && (Date.valueOf(rul.insuringRuleEffectiveDates ) <= Date.valueOf(currentDate) && Date.valueOf(rul.insuringRuleExpirationDates) >= Date.valueOf(currentDate))){
                                        ins.Status = 'Active';
                                    }
                                    
                                    ins.EffectiveDate = (rul.insuringRuleEffectiveDates != null )?String.valueof(ACETUtility.format(Date.valueOf(rul.insuringRuleEffectiveDates))):'';
                                    ins.endDate = (rul.insuringRuleExpirationDates != null)?String.valueof(ACETUtility.format(Date.valueOf(rul.insuringRuleExpirationDates))):'12/31/9999';
                                ins.population = (rul.classesDescription != null )?rul.classesDescription.replace(',',''):'';
                                system.debug('@@@pop'+ins.population + '   '+rul.insuringRuleEffectiveDates );
                                    
                                    ins.insrules = new list<ACETLGT_GroupDetail.InsRule>();
                                    for(i=0;i<6;i++)
                                    {
                                        ACETLGT_GroupDetail.InsRule insRuleItem = new ACETLGT_GroupDetail.InsRule();
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
                                                for(ACETLGT_GetEmployerGroupAdapterJSON2Apex.WaitingPeriodRules wp : rul.waitingPeriodRules){
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
                                                for(ACETLGT_GetEmployerGroupAdapterJSON2Apex.CustomerAccountGroupPopulation gp : accopt.customerAccountGroupPopulation){
                                                    system.debug('Inside group population'+ins.population + '   '+ gp.classesDescription);
                                                    if(ins.population == gp.classesDescription && gp.populationOpenEnrollmentStartDate != null && gp.populationOpenEnrollmentEndDate != null){
                                                        insRuleItem.insRulesDesc = String.ValueOf(ACETUtility.format(Date.ValueOf(gp.populationOpenEnrollmentStartDate)))+' to '+String.ValueOf(ACETUtility.format(Date.ValueOf(gp.populationOpenEnrollmentEndDate)));                                                    
                                                    }else
                                                        insRuleItem.insRulesDesc = ((accopt.openEnrollmentStartDate != null && accopt.openEnrollmentEndDate!= null)?(String.ValueOf(ACETUtility.format(Date.ValueOf(accopt.openEnrollmentStartDate)))+' to '+String.ValueOf(ACETUtility.format(Date.ValueOf(accopt.openEnrollmentEndDate)))):'');                                                   
                                                }
                                            }
                                            else {
                                                insRuleItem.insRulesDesc = ((accopt.openEnrollmentStartDate != null && accopt.openEnrollmentEndDate!= null)?(String.ValueOf(ACETUtility.format(Date.ValueOf(accopt.openEnrollmentStartDate)))+' to '+String.ValueOf(ACETUtility.format(Date.ValueOf(accopt.openEnrollmentEndDate)))):'');                                            
                                            }
                                        }
                                        ins.insrules.add(insRuleItem);
                                    }
                                    system.debug('$$$insruleitem'+ins.insrules);
                                    pc.insurRules.add(ins);
                                }
                            }
                            
                            oACETGroupDetail.polContract.add(pc);                    
                        }
                    } 
                }
                
            }
        }
    }
    //getemp V3 ends
    
    //Mapping General Group Info Section
    private void generalGroupInfoMapping(ACETLGT_GetEmployerGroupAdapterJSON2Apex.EmployerGroup EGDetails) {
        if(EGDetails != null) {   
            oACETGroupDetail.genGroupInfo.groupName = (EGDetails.groupName != Null)?EGDetails.groupName.replaceAll('(\\s+)', ' '):''; 
            oACETGroupDetail.genGroupInfo.groupId = (EGDetails.groupNumber != Null)?EGDetails.groupNumber:''; 
            taxId = '';
            if(EGDetails.taxIdentificationNumber != null) {
                Integer taxIdSize =  EGDetails.taxIdentificationNumber.size();
                for (Integer j = taxIdSize ; j > 0; j--) {
                    if(taxId == '' || taxId == null) {
                        taxId = EGDetails.taxIdentificationNumber[j-1];
                    }
                    else {
                        taxId = taxId + ', ' +EGDetails.taxIdentificationNumber[j-1];
                    }                
                }
            }
            
            oACETGroupDetail.genGroupInfo.groupTaxId = taxId;
            //getemp V3 starts
            // Group Level Hold code
            oACETGroupDetail.holdCode = new List<ACETLGT_GroupDetail.holdCodeInfo>();
            if(EGDetails.GroupLevelHold != null){
                for(ACETLGT_GetEmployerGroupAdapterJSON2Apex.GroupLevelHold holdGroup : EGDetails.GroupLevelHold){
                    ACETLGT_GroupDetail.holdCodeInfo holdingCode = new ACETLGT_GroupDetail.holdCodeInfo();
                    holdingCode.holdID = (holdGroup.groupHoldCreatedByUserId != null)?holdGroup.groupHoldCreatedByUserId:'';
                    holdingCode.holdCode = (holdGroup.groupHoldCode != null)?holdGroup.groupHoldCode:'';
                    holdingCode.holdDescription = (holdGroup.groupHoldShortDescription != null)?holdGroup.groupHoldShortDescription:'';
                    holdingCode.holdEffectiveDate = (holdGroup.groupHoldEffectiveDates != null)?String.valueof(ACETUtility.format(Date.valueOf(holdGroup.groupHoldEffectiveDates))):'';
                    holdingCode.holdExpirationDate = (holdGroup.groupHoldExpirationDates != null)?String.valueof(ACETUtility.format(Date.valueOf(holdGroup.groupHoldExpirationDates))):'';
                    holdingCode.holdProcessedOn = (holdGroup.groupHoldTransactionDate != null)?String.valueof(ACETUtility.format(Date.valueOf(holdGroup.groupHoldTransactionDate))):'';
                    oACETGroupDetail.holdCode.add(holdingCode);
                }
            }
            //US1699536 starts
            oACETGroupDetail.groupSettings = new List<ACETLGT_GroupDetail.cobAttestation>();
            if(EGDetails.groupSettings != null) {
                for(ACETLGT_GetEmployerGroupAdapterJSON2Apex.cobAttestation groupSet:EGDetails.groupSettings) {
                    ACETLGT_GroupDetail.cobAttestation settings = new ACETLGT_GroupDetail.cobAttestation();
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
                /*List<ReligiousExemptionMap__mdt> relExemp = [select ReligiousType__c, ReligiousDescription__c from ReligiousExemptionMap__mdt WHERE ReligiousType__c = :oACETGroupDetail.genGroupInfo.religiousExemptionType];
                if(relExemp.size() > 0){
                    oACETGroupDetail.genGroupInfo.religiousExemptionDesc = (relExemp[0].ReligiousDescription__c != null)?relExemp[0].ReligiousDescription__c:'';
                }*/
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
                for(ACETLGT_GroupDetail.holdCodeInfo hc:oACETGroupDetail.holdCode){
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
                        
            if(EGDetails.alphaParentGroup!= Null && EGDetails.alphaParentGroup.name != null && oACETGroupDetail.genGroupInfo.groupName == EGDetails.alphaParentGroup.name){
                oACETGroupDetail.genGroupInfo.parentIndicator = oACETGroupDetail.genGroupInfo.groupName;
            }else if(EGDetails.alphaParentGroup!= Null && EGDetails.alphaParentGroup.name != null && EGDetails.parentGroup!= Null && EGDetails.parentGroup.name != null && oACETGroupDetail.genGroupInfo.groupName != EGDetails.alphaParentGroup.name && EGDetails.parentGroup.name == EGDetails.alphaParentGroup.name){
                oACETGroupDetail.genGroupInfo.parentIndicator = EGDetails.alphaParentGroup.name +' - '+oACETGroupDetail.genGroupInfo.groupName;
            }else if(EGDetails.alphaParentGroup!= Null && EGDetails.alphaParentGroup.name != null && EGDetails.parentGroup!= Null && EGDetails.parentGroup.name != null && oACETGroupDetail.genGroupInfo.groupName != EGDetails.parentGroup.name && EGDetails.parentGroup.name != EGDetails.alphaParentGroup.name){
                oACETGroupDetail.genGroupInfo.parentIndicator = EGDetails.alphaParentGroup.name +' - '+EGDetails.parentGroup.name +' - '+oACETGroupDetail.genGroupInfo.groupName;
            }
            String childGroups;
            if(EGDetails.childGroup != null) {
                childGroups = '';
                for(ACETLGT_GetEmployerGroupAdapterJSON2Apex.ParentGroup cg:EGDetails.childGroup) {
                    if(childGroups == '')
                        childGroups = ((cg.name!=null)?cg.name:'');
                    else
                        childGroups = childGroups + ' & '+((cg.name!=null)?cg.name:'');
                }
                if(EGDetails.childGroup.size() > 0)
                    oACETGroupDetail.genGroupInfo.parentIndicator = oACETGroupDetail.genGroupInfo.parentIndicator + ' -('+childGroups + ')';
            }
                        
            System.debug('!!!parentindicator'+oACETGroupDetail.genGroupInfo.parentIndicator );
            
            if(!EGDetails.CustomerAccount.isEmpty()) {
                oACETGroupDetail.genGroupInfo.originalgrpStartDate =(EGDetails.CustomerAccount[0] != null && EGDetails.CustomerAccount[0].originalContractDate!= Null)?String.valueof(ACETUtility.format(Date.valueOf(EGDetails.CustomerAccount[0].originalContractDate))):'';
                oACETGroupDetail.genGroupInfo.legacyGroupNumber =(EGDetails.CustomerAccount[0] != null && EGDetails.CustomerAccount[0].migrationSourceSystem!= Null && EGDetails.CustomerAccount[0].migrationIndicator!= Null && EGDetails.CustomerAccount[0].migrationIndicator=='true')?EGDetails.CustomerAccount[0].migrationSourceSystem.Id:'N/A';
            }
            //Additional Information
            oACETGroupDetail.additionalGroupInfo.memGroupClassification = (EGDetails.groupClassification!= Null)?EGDetails.groupClassification:'';
            oACETGroupDetail.additionalGroupInfo.enrollmentMethod= (EGDetails.enrollmentType!= Null)?EGDetails.enrollmentType:'';           
        }        
    }

    // Mapping Attestations sections 
    private void groupEmployeeCountMapping(ACETLGT_GetEmployerGroupAdapterJSON2Apex.EmployerGroup EGDetails) {
        if(EGDetails != null ) {        
            ACETLGT_GroupDetail.employeeCountInfo employeeCountInfo = new ACETLGT_GroupDetail.employeeCountInfo();
            
            if(EGDetails.employeeCounts != null) {
                Set<string> uniqueYears = new Set<string>{String.valueof(Date.Today().Year()),String.valueof(Date.Today().Year()-1)};                                
                System.debug('###years'+uniqueYears);
                Map<string,ACETLGT_GroupDetail.employeeCountInfo> employeeCountMap = new map<string,ACETLGT_GroupDetail.employeeCountInfo>();
                for(string s:uniqueYears){
                    system.debug('###yearsinside'+s);
                    
                    for(ACETLGT_GetEmployerGroupAdapterJSON2Apex.EmployeeCounts addEmpCount:EGDetails.employeeCounts) {
                        if(addEmpCount.reportingYear == s) {
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
                            employeeCountInfo.lastUpdate = (addEmpCount.transactionDate != null)?String.valueof(ACETUtility.format(Date.valueOf(addEmpCount.transactionDate))):'';
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
                    employeeCountInfo = new ACETLGT_GroupDetail.employeeCountInfo();                                        
                }
                System.debug('###Map'+employeeCountMap);
                
                if(!employeeCountMap.isEmpty()) {
                    for (String s : employeeCountMap.keySet()) {
                        System.debug('###key'+s);
                        System.debug('###get'+employeeCountMap.get(s));
                        oACETGroupDetail.groupEmployeeCountInfoList.add(employeeCountMap.get(s));
                    }
                }
            }
        }    
        
    }
    
	// Mapping Address Section
    private void groupAddressMapping(ACETLGT_GetEmployerGroupAdapterJSON2Apex.EmployerGroup EGDetails) {
        ACETLGT_GroupDetail.AddressInfo addressBillingInfo = new ACETLGT_GroupDetail.AddressInfo();
        oACETGroupDetail.groupAddressInfoPastList = new List<ACETLGT_GroupDetail.AddressInfo>();
        oACETGroupDetail.groupAddressInfoCurrFutureList = new List<ACETLGT_GroupDetail.AddressInfo>();
        if(EGDetails.groupAddress != null)
            for(ACETLGT_GetEmployerGroupAdapterJSON2Apex.GroupAddress addEGC:EGDetails.groupAddress) {  
                if(addEGC.addressTypeCode != null) {
                    ACETLGT_GroupDetail.AddressInfo addressInfo = new ACETLGT_GroupDetail.AddressInfo();  
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
                addressInfo.effectiveDate = (addEGC.effectiveDate != null && addEGC.effectiveDate != '')?ACETUtility.format(Date.valueOf(addEGC.effectiveDate)):'';
                addressInfo.expirationDate = (addEGC.expirationDate != null && addEGC.expirationDate != '')?ACETUtility.format(Date.valueOf(addEGC.expirationDate)):'';   
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
    
    private void groupContactInfoMapping(ACETLGT_GetEmployerGroupAdapterJSON2Apex.EmployerGroup EGDetails) {
        if (EGDetails != null )
        {
            ACETLGT_GroupDetail.groupContactInfo employeeGrpInfo = new ACETLGT_GroupDetail.groupContactInfo();
            ACETLGT_GroupDetail.groupContactInfo adminInfo = new ACETLGT_GroupDetail.groupContactInfo();
            ACETLGT_GroupDetail.groupContactInfo contactInfo = new ACETLGT_GroupDetail.groupContactInfo(); //US966071 
            list<ACETLGT_GroupDetail.contactPhoneInfo> contactPhoneList;
            ACETLGT_GroupDetail.contactPhoneInfo contactPhoneInfo;
            ACETLGT_GroupDetail.addressInfo contactAddressInfo;
            
            ACETLGT_GroupDetail.groupContactInfo groupContactInfo = new ACETLGT_GroupDetail.groupContactInfo();
            oACETGroupDetail.groupExternalContactInfoFullList = new list<ACETLGT_GroupDetail.groupContactInfo>();  //US966071 
            oACETGroupDetail.groupExternalContactInfoList = new list<ACETLGT_GroupDetail.groupContactInfo>();
            oACETGroupDetail.groupExternalContactInfoHistoryList = new list<ACETLGT_GroupDetail.groupContactInfo>();
            oACETGroupDetail.groupInternalContactInfoList = new list<ACETLGT_GroupDetail.groupContactInfo>();
            
            if(EGDetails.groupContact != null)
            {  
                for(ACETLGT_GetEmployerGroupAdapterJSON2Apex.GroupContact contactData:EGDetails.groupContact)
                {
                    
                    if(contactData != Null )
                    {
                     
                        adminInfo = new ACETLGT_GroupDetail.groupContactInfo();
                        adminInfo.contactPhones = new list<ACETLGT_GroupDetail.contactPhoneInfo>();
                        adminInfo.contactAddress = new list<ACETLGT_GroupDetail.AddressInfo>();
                        adminInfo.contactEmails = new list<String>();
                       
                        
                        adminInfo.primaryContactType = (contactData.roleDescription != Null)?contactData.roleDescription:adminInfo.primaryContactType ;
                        
                        adminInfo.firstName = (contactData.firstName != Null)?contactData.firstName:adminInfo.firstName;
                        adminInfo.LastName = (contactData.lastName != Null)?contactData.lastName:adminInfo.LastName;
                        adminInfo.middleName = (contactData.middleName != Null)?contactData.middleName:adminInfo.middleName;
                        
                        adminInfo.startDate = (contactData.assignmentStartDate != Null)?String.valueof(ACETUtility.format(Date.valueOf(contactData.assignmentStartDate))):adminInfo.startDate;
                        adminInfo.endDate = (contactData.assignmentEndDate != Null)?String.valueof(ACETUtility.format(Date.valueOf(contactData.assignmentEndDate))):adminInfo.endDate;
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
                            for(ACETLGT_GetEmployerGroupAdapterJSON2Apex.Phone phoneInfo:contactData.phone)
                            {
                                contactPhoneInfo = new ACETLGT_GroupDetail.contactPhoneInfo();
                                contactPhoneInfo.phoneNumber = (phoneInfo != Null && phoneInfo.telephoneNumber != Null)?phoneInfo.telephoneNumber:contactPhoneInfo.phoneNumber ;
                                contactPhoneInfo.phoneExt = (phoneInfo != Null && phoneInfo.phoneExtension != Null)?phoneInfo.phoneExtension:contactPhoneInfo.phoneExt ;
                                contactPhoneInfo.phoneType = (phoneInfo != Null && phoneInfo.phoneType != Null)?phoneInfo.phoneType:contactPhoneInfo.phoneType;
                                //getemp V3 starts
                                if(phoneInfo.phoneType == 'F' && phoneInfo.telephoneNumber != null){
                                    adminInfo.fax = phoneInfo.telephoneNumber;
                                } else if(phoneInfo.telephoneNumber != null && (adminInfo.phone == null || adminInfo.phone == '') 
                                    && (phoneInfo.phoneType == 'B' ||phoneInfo.phoneType == 'W' || phoneInfo.phoneType == 'O')){
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
                            for(ACETLGT_GetEmployerGroupAdapterJSON2Apex.Email emailInfo:contactData.email)
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
                       
                           for(ACETLGT_GetEmployerGroupAdapterJSON2Apex.Address addrInfo:contactData.address )
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
                        if(contactData.assignmentEndDate != Null && contactData.assignmentStartDate != Null && date.today().daysBetween(Date.valueOf(contactData.assignmentEndDate)) >= 0 &&  (Date.valueOf(contactData.assignmentStartDate).daysBetween(date.today()) >= 0 || date.today().daysBetween(Date.valueOf(contactData.assignmentStartDate)) >= 0))
                        {
                            adminInfo.activeStatus = 'Y'; 
                            adminInfo.startDate = ACETUtility.format(Date.valueOf(contactData.assignmentStartDate));
                            adminInfo.endDate = ACETUtility.format(Date.valueOf(contactData.assignmentEndDate));
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
                            adminInfo.startDate = ACETUtility.format(Date.valueOf(contactData.assignmentStartDate));
                            adminInfo.endDate = ACETUtility.format(Date.valueOf(contactData.assignmentEndDate));
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
            for(ACETLGT_GetEmployerGroupAdapterJSON2Apex.GroupSupportTeamContact contactData:EGDetails.groupSupportTeamContact)
            {
                    //US1024400          
                    if (contactData != Null){
                        if(contactData.roleDescription =='Language Team'){
                            oACETGroupDetail.genGroupInfo.asianInitIndicator = 'Yes';
                        }
                    }
                if(contactData != Null)
                {                       
                    employeeGrpInfo = new ACETLGT_GroupDetail.groupContactInfo();
                    employeeGrpInfo.contactPhones = new list<ACETLGT_GroupDetail.contactPhoneInfo>();
                    employeeGrpInfo.contactEmails = new list<String>();
                    employeeGrpInfo.primaryContactType = contactData.roleDescription;
                    
                    employeeGrpInfo.firstName = ( contactData.firstName != Null)?contactData.firstName:employeeGrpInfo.firstName;
                    employeeGrpInfo.LastName = ( contactData.lastName != Null)?contactData.lastName:employeeGrpInfo.LastName;
                    employeeGrpInfo.middleName = ( contactData.middleName != Null)?contactData.middleName:employeeGrpInfo.middleName;
                    
                    employeeGrpInfo.startDate = (contactData.startDate != Null)?String.valueof(ACETUtility.format(Date.valueOf(contactData.startDate))):employeeGrpInfo.startDate;
                    employeeGrpInfo.endDate = (contactData.endDate != Null)?String.valueof(ACETUtility.format(Date.valueOf(contactData.endDate))):employeeGrpInfo.endDate;
                    employeeGrpInfo.Organization = ( contactData.serviceTeam != Null)?contactData.serviceTeam:employeeGrpInfo.Organization;
                    if(contactData.phone != Null && !contactData.phone.isEmpty())
                    {
                        for(ACETLGT_GetEmployerGroupAdapterJSON2Apex.Phone phoneInfo:contactData.phone)
                        {
                            contactPhoneInfo = new ACETLGT_GroupDetail.contactPhoneInfo();
                            contactPhoneInfo.phoneType = (phoneInfo != Null && phoneInfo.phoneType != Null)?phoneInfo.phoneType:contactPhoneInfo.phoneType;
                            contactPhoneInfo.phoneNumber = (phoneInfo != Null && phoneInfo.telephoneNumber != Null)?phoneInfo.telephoneNumber:contactPhoneInfo.phoneNumber ;
                            contactPhoneInfo.phoneExt = (phoneInfo != Null && phoneInfo.phoneExtension!= Null)?phoneInfo.phoneExtension:contactPhoneInfo.phoneExt;
                            if(contactPhoneInfo != Null)
                            employeeGrpInfo.contactPhones.add(contactPhoneInfo);
                            //getemp V3 starts
                            if(phoneInfo.telephoneNumber != null && (employeeGrpInfo.Phone == null || employeeGrpInfo.Phone == '') && (employeeGrpInfo.extension == null || employeeGrpInfo.extension == '')  
                                && (phoneInfo.phoneType == 'B' ||phoneInfo.phoneType == 'W' || phoneInfo.phoneType == 'O')){
                                employeeGrpInfo.Phone = phoneInfo.telephoneNumber;
                                employeeGrpInfo.extension = phoneInfo.phoneExtension;
                            }
                        }                        
                        //getemp V3 ends
                    }
                    
                    if(contactData.email != Null && !contactData.email.isEmpty())
                    {
                        for(ACETLGT_GetEmployerGroupAdapterJSON2Apex.Email emailInfo:contactData.email)
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
    //US2167804 code move ends
}