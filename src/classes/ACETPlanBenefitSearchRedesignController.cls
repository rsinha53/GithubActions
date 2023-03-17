public with sharing class ACETPlanBenefitSearchRedesignController extends ACETErrorHandler {
    public ACETCallTopicsDataWrapper wrapper {get;set;}    
    public Case CaseStub {get;set;} //stub record to display a calendar for date of birth
    public String PolicyNumber {get;set;}
    public ACETHighlightsPanelAdditionalInfo AdditionalInfo {get;set;}
    public String hpAdditionInfoStr {get {
        return JSON.serialize(wrapper.AdditionalInfo);
    }set;}
    public string surrogateKey {get; set;}
    public Interaction__c Interaction {get;set;}
    public Contact subject{get;set;}    
    public String SourceOriginator {get;set;}
    public List<String> networkSchList {get;set;}
    //for temporary purpose
    public String MemberId {get;set;}
    public String FirstName {get;set;}
    public String LastName {get;set;}
    public String ZipCode {get;set;}
    public String State {get;set;}
    public boolean noGroupsFound {get;set;}
    public boolean noPlansFound {get;set;}
    //searchResults
   // public List<ACETPlanBenefitSearchResult> Results {get;set;} 
    public String ErrorMessage {get;set;}   
    //sort member search result    
    public String SortBy {get;set;}
    public String SortOrder {get;set;}
    public String LastSortBy{get;set;}
    public List<ACETGroupSearchResult> GroupInfos {get;set;}
    public String groupNumber {get;set;}
    public String groupName {get;set;}
    public boolean groupSearchResult{get;set;}
    public String interactionId{get;set;}

    //US1744572 ends
    
    //To be removed once moved to adapter
    public ACETGroupDetail oACETGroupDetail;
    private string networkId;
    public String SRKID {get;set;}
    public String SubSRKID {get;set;}
    public String bundleOptionId {get;set;}                
    public String CoverageType {get;set;}
    public String EffectiveDate {get;set;}
    public String EndDate {get;set;}
      public String benefitEffectivedate {get;set;} //US2962032
    public String benefitEnddate {get;set;}
    public String accumAsOfDate {get;set;}

    public Boolean IsShowActiveBenefitsOnly {get;set;}
    public List<ACETGroupPlanBenefitWrapper.PlanInformationWrapper> planInfoList {get; set;}
    public ACETGroupPlanBenefitWrapper planInfoWrapper {get; set;} 
    public Boolean errorFlagForNoRecords {get;set;}  
    
    public string covLevel {get;set;}
    public Set<String> benefitErrorMsgs {get;set;}
    public String exchangeType{get;set;} //US1744352
    public String fundingArrang{get;set;}
    public String  customerPurchaseid{get;set;}
    //START: US1287072
    public string polcontractId {get;set;}
    public string polstatus {get;set;}
    public string poleffectDate {get;set;}
    public string polendDate {get;set;}
    public string policyStatusSelected{get;set;}
    public List<SelectOption> PolicyStatus {get;set;}
    public ACETGroupDetail groupDetails{get;set;}
    public List<AcetGroupDetail.PolicyContract> GroupPolicyResultsList {get; set;}
    public string selectedActiveAndAll {get;set;}
   // public List<AcetGroupDetail.GroupPlanWrapper> GroupPlanBenefitResultsList {get; set;}
    //END: US1287072
    
    
    public ACETStateCodeContainer StateCode { get; set; }
    public ACETPlanBenefitSearchRedesignController () {
        polcontractId = '';     
        policyStatusSelected = 'Active';
        selectedActiveAndAll = 'Active';
        PolicyStatus = new list<SelectOption>();
        PolicyStatus.add(new SelectOption('Active','Active'));
        PolicyStatus.add(new SelectOption('Future','Future'));
        PolicyStatus.add(new SelectOption('Termed','Termed'));
        
        CaseStub = new Case();
        Casestub.tst_Date_Field__c = Date.today();
        wrapper = new ACETCallTopicsDataWrapper();
        wrapper.init();
        wrapper.CaseObj.Topic__c = 'Plan Benefits'; 
        //wrapper.caseItem.Topic = 'Plan Benefits';  
        interactionId = ApexPages.currentPage().getParameters().get('interactionId');   
        String additionalInfoStr = apexpages.currentpage().getparameters().get('additionalInfo');
        bundleOptionId = apexpages.currentpage().getparameters().get('bundleOptionId');        
        CoverageType = apexpages.currentpage().getparameters().get('CoverageType');
        EffectiveDate = apexpages.currentpage().getparameters().get('EffectiveDate');
        EndDate = apexpages.currentpage().getparameters().get('EndDate');
        benefitEnddate = apexpages.currentpage().getparameters().get('benefitEnddate'); //US2962032
        benefitEffectivedate = apexpages.currentpage().getparameters().get('benefitEffectivedate');
        MemberId = apexpages.currentpage().getparameters().get('MemberId');
        groupNumber = apexpages.currentpage().getparameters().get('groupNumber');
        SRKID = apexpages.currentpage().getparameters().get('SRK');
        SubSRKID = apexpages.currentpage().getparameters().get('coverageSRK');
        covLevel = ApexPages.currentPage().getParameters().get('clevel');
        accumAsOfDate = ApexPages.currentPage().getParameters().get('accumAsOf');
        exchangeType = ApexPages.currentPage().getParameters().get('exchangeType');
        fundingArrang = Apexpages.currentPage().getParameters().get('fundingArrang');
        customerPurchaseid = Apexpages.currentPage().getParameters().get('cpid');
        system.debug('clevel-->' + covLevel);
        system.debug('SRKID---->'+ SRKID);
        system.debug('MemberId---->'+  MemberId);
        errorFlagForNoRecords = false;  
        
        if(CoverageType == 'Medical'){
            CoverageType = 'M';
        }        
        
        system.debug(LoggingLevel.INFO,'bundleOptionId:: '+ bundleOptionId + ' ::CoverageType:: ' + CoverageType + '::EffectiveDate:: ' + EffectiveDate + '::EndDate:: ' + EndDate + ' ::groupNumber:: ' + groupNumber);
         if(!String.isEmpty(additionalInfoStr )){  
        wrapper.AdditionalInfo = (ACETHighlightsPanelAdditionalInfo)json.deserialize(additionalInfoStr,ACETHighlightsPanelAdditionalInfo.class); 
         
        AdditionalInfo = new ACETHighlightsPanelAdditionalInfo();
        }
         if(wrapper.AdditionalInfo != null && wrapper.AdditionalInfo.isMemNotFound == '1') {
            wrapper.setNotFound('Member', wrapper.AdditionalInfo.MemberId);
         }
        surrogateKey = ApexPages.currentPage().getParameters().get('SRK');
         if (!String.isEmpty(surrogateKey)){ 
            wrapper.surrogateKey = surrogateKey;
        }
        //searchByGroupName();
        noGroupsFound = false;
        groupSearchResult=false;           
        StateCode = new ACETStateCodeContainer('');
        networkSchList = new List<String>();
        noPlansFound = false;
         }
         
    public void CallGetSubscriptionBenefitWS(){
        system.debug(LoggingLevel.INFO,'Inside CallGetSubscriptionBenefitWS ');
        benefitErrorMsgs = new set<String>();
        String bundleOptionIdparam = ApexPages.currentPage().getParameters().get('bundleOptionIdparam');
        if(!String.isEmpty(bundleOptionIdparam ) && bundleOptionIdparam != 'undefined'){
        bundleOptionId = bundleOptionIdparam;
        }
        String benefitEffectivedateparam = ApexPages.currentPage().getParameters().get('benefitEffectivedateparam');
        if(!String.isEmpty(benefitEffectivedateparam) && benefitEffectivedateparam!= 'undefined'){
        benefitEffectivedate = benefitEffectivedateparam;
        }
        String benefitEnddateparam = ApexPages.currentPage().getParameters().get('benefitEnddateparam');
        if(!String.isEmpty(benefitEnddateparam) && benefitEnddateparam!= 'undefined'){
        benefitEnddate = benefitEnddateparam;
        }
        String groupNumberparam = ApexPages.currentPage().getParameters().get('groupNumberparam');
        if(!String.isEmpty(groupNumberparam) && groupNumberparam!= 'undefined'){
        groupNumber = groupNumberparam;
        }
        String customerPurchaseidparam = ApexPages.currentPage().getParameters().get('customerPurchaseidparam');
        if(!String.isEmpty(customerPurchaseidparam) && customerPurchaseidparam!= 'undefined'){
        customerPurchaseid= customerPurchaseidparam;
        }
        
        planInfoList  = new List<ACETGroupPlanBenefitWrapper.PlanInformationWrapper>();
        if(!String.isEmpty(MemberId) && MemberId != 'undefined' && !String.isEmpty(SRKID) && SRKID != 'undefined') {
        ACETNimbusGetSSBAPI stubData = new ACETNimbusGetSSBAPI();
        noPlansFound = false;
        system.debug('SRKID ** ' + SRKID + ' **EffectiveDate** ' + EffectiveDate + ' **EndDate** ' + EndDate + ' **CoverageType** ' + CoverageType + ' **groupNumber** ' + groupNumber);
        ACETWSCalloutResult responseData = stubData.getSubscriptionBenefitSearch(bundleOptionId, MemberId,SRKID,SubSRKID, benefitEffectivedate,benefitEnddate,CoverageType,groupNumber,'','', customerPurchaseid);//US2962032 
        system.debug(LoggingLevel.INFO,'responseData:: ' + responseData);
        //if(responseData.success != null && responseData.success) {
            if(responseData != null && responseData.Success) {
            errorFlagForNoRecords = false; 
            planInfoList  = new List<ACETGroupPlanBenefitWrapper.PlanInformationWrapper>();
            planInfoWrapper = (ACETGroupPlanBenefitWrapper)responseData.response;
            if(planInfoWrapper != null) {
                planInfoList = planInfoWrapper.planInfoWrapperList;
                system.debug(LoggingLevel.INFO,'planInfoList:: ' + planInfoList);
                if(planInfoList!=null) {             
                    for(ACETGroupPlanBenefitWrapper.PlanInformationWrapper networkSch : planInfoList){
                        if(networkSch.networkSchedules != null){
                            for(ACETGroupPlanBenefitWrapper.networkScheduleIds netSchObj : networkSch.networkSchedules ){
                                networkSchList.add(netSchObj.networkSchId);
                          }
                        }
                    }
                }
            }  
            
        }
        else if(String.isNotBlank(responseData.Message) && (responseData.Message.contains('No Records found') || responseData.Message.contains('No Group Found') || responseData.Message.contains('No Enrollee Individual Found'))){             
        //  else if(responseData.Message.contains('No Package Found')) {
                system.debug(LoggingLevel.INFO, 'Errors Auth :: ' + responseData);
                errorFlagForNoRecords = true;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'No Records Found'));
        }
        else {          
                errorFlagForNoRecords = false;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, responseData.Message));        
                benefitErrorMsgs.add(responseData.Message);
        }
        /*if(benefitErrorMsgs != null && !benefitErrorMsgs.isEmpty()) { 
            for(String msg : benefitErrorMsgs) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error, msg));
            }
        }*/
      }
        else {
                errorFlagForNoRecords = false;
                noPlansFound = true;
        }
    }

    public ACETWSCalloutResult callwebservice(string groupId)
    {
       
        ACETGetEmployerDetailAdapterWebService stubData = new ACETGetEmployerDetailAdapterWebService();
        ACETWSCalloutResult responseData = stubData.GetEmployerGroupDetail(groupId);     
        System.debug('Allowing.................'+responseData);
        return responseData;
    }      

    public void sortTable(){   
        if(LastSortBy != null){             
            if(LastSortBy != SortBy){
                SortOrder = 'Asc';                      
            }else{
                SortOrder = (SortOrder == 'Asc'? 'Desc' : 'Asc');
            }
        }
        
        ACETMemberSearchResult.SortBy = SortBy;
        ACETMemberSearchResult.SortOrder = SortOrder;
       // Results.sort();
        LastSortBy = SortBy;                                
    }
    
    public class PlanInfo{
        public String PolicyNumber {get;set;}
        public String PlanId {get;set;}
        public String Product {get;set;}
        public String EffectiveDate {get;set;}
        public String EndDate {get;set;}
        public String ExpirationDate{get;set;}
        public String RevisionDate {get;set;}
        public String GroupName {get;set;}
    }
    public class GroupInfo{
        public String groupName {get;set;}
        public String address {get;set;}
        public String city {get;set;}
        public String status {get;set;}
        public String state {get;set;}
        public String zip {get;set;}
        public String phoneNumber {get;set;}
    }
    public String ReplaceKeywords(String ResponsBody) {
        return ResponsBody.replaceAll('"desc"','"descr"').replaceAll('"date"','"dte"').replaceAll('"dateTime"','"dteTime"').replaceAll('"number"','"numbr"').replaceAll('"type"','"eType"').replaceAll('"object"','"Object_Z"');
    }
    public string isActive{get;set;} 

}