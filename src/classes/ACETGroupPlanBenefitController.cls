public with sharing class ACETGroupPlanBenefitController extends ACETErrorHandler{
    public ACETCallTopicsDataWrapper wrapper {get;set;}
    public string comments{get;set;} 
    public string InteractionId {get;set;}
    public boolean IsShowActiveCoveragesOnly {get;set;}
    public String callTopic {get; set;}
    public Contact Subject { get; set; }
    public boolean notResearchUser {get;set;}
    public Interaction__c  Interaction { get; set; }
    public Boolean IsShowActiveBenefitsOnly {get;set;}
    public string groupNumber{get;set;}
    //getemp V3 starts  
    public List<AcetGroupDetail.PolicyContract> GroupPolicyResultsList {get; set;}
    public String contractId {get;set;}
    public String status {get;set;}
    public String effectDate {get;set;}
    public String endDate {get;set;}
    //getemp V3 ends
    public ACETGroupDetail groupDetails{get;set;}  
    public static ACETGroupDetail groupPlanDetails{get;set;}
    public static List<ACETGroupDetail.GroupPlanWrapper> GroupPlanSearchResults {get; set;}
    //public List<ACETGroupDetail.GroupPlanWrapper> GroupPlanBenefitList {get; set;}
    public List<ACETGroupDetail.GroupPlanWrapper> GroupPlanBenefitResultsList {get; set;}
    
    public ACETHighlightsPanelAdditionalInfo AdditionalInfo {get;set;}
    public String hpAdditionInfoStr {get{
        return JSON.serialize(AdditionalInfo);
    }set;} 
    public String RenewalDate{get;set;} 
    public String filterStatus {get;set;}
    
    public ACETGroupPlanBenefitController() {
      try{
        groupNumber = apexpages.currentpage().getparameters().get('groupId');
        System.debug('Grou Pd'+groupNumber);
        InteractionId = apexpages.currentpage().getparameters().get('interactionId');
        callTopic = apexpages.currentpage().getparameters().get('callTopic');
        //getemp V3 starts
        contractId = apexpages.currentpage().getparameters().get('contractId');
        status = apexpages.currentpage().getparameters().get('status');
        effectDate = apexpages.currentpage().getparameters().get('effectDate');
        endDate = apexpages.currentpage().getparameters().get('endDate');
        
        filterStatus = apexpages.currentpage().getparameters().get('filterStatus');
        //getemp V3 ends
        if(InteractionId != null && InteractionId != '')
            Interaction = ACETProviderUtility.GetInteractionByID(InteractionId);
        wrapper = new ACETCallTopicsDataWrapper();
        wrapper.CaseObj.Topic__c = callTopic;
        wrapper.AutodocComment = comments;
        initHighlightPanelAdditionalInfo();
        System.debug('*****'+RenewalDate);
        }catch(Exception e){
           setErrorMsg('MGD997',e);
        }
        
    }
    
    public void init() {
        toggleShowPlanBenefits();
    }
    
    public static ACETWSCalloutResult callwebservice(string groupId)
    {
        ACETGetEmployerDetailAdapterWebService stubData = new ACETGetEmployerDetailAdapterWebService();
        ACETWSCalloutResult responseData = stubData.getEmployerGroupDetail(groupId);
        System.debug('Allowing.................'+responseData);
        return responseData;
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

        if(Interaction != Null && Interaction.Highlight_Panel_GroupInfo__c != null)
        {
            System.debug('Entering NUll Check'+AdditionalInfo);
            if(AdditionalInfo != null) {
                ACETGroupDetailsWrapper deserializedExceptionData = (ACETGroupDetailsWrapper)JSON.deserialize(Interaction.Highlight_Panel_GroupInfo__c, ACETGroupDetailsWrapper.class);
                AdditionalInfo.UHCBS = deserializedExceptionData.UHCBS;    
                AdditionalInfo.GroupN = deserializedExceptionData.GroupName ;
                AdditionalInfo.GroupStatus = deserializedExceptionData.GroupStatus;
                AdditionalInfo.ServiceTeam = deserializedExceptionData.ServiceTeam;
                AdditionalInfo.RiskManagement = deserializedExceptionData.RiskManagement;
                AdditionalInfo.RatingMethod = '';
                RenewalDate = AdditionalInfo.RenewalDate= deserializedExceptionData.RenewalDate; 
                AdditionalInfo.RelationshipType = deserializedExceptionData.RelationshipType ;
                AdditionalInfo.groupSName = deserializedExceptionData.groupSName;    
            }
              
        }  
        hpAdditionInfoStr = JSON.serialize(AdditionalInfo);
       }catch(Exception e){
           setErrorMsg('MGD997',e);
       } 
    }
    
    public void toggleShowPlanBenefits() {
        //getemp V3 starts
        contractId = apexpages.currentpage().getparameters().get('contractId');
        status = apexpages.currentpage().getparameters().get('status');
        effectDate = apexpages.currentpage().getparameters().get('effectDate');
        endDate = apexpages.currentpage().getparameters().get('endDate');
        GroupPolicyResultsList = new List<AcetGroupDetail.PolicyContract>();
        
        
        //getemp V3 ends
        if(IsShowActiveBenefitsOnly == null) {
            IsShowActiveBenefitsOnly = true;   
        }
        else{
            IsShowActiveBenefitsOnly = !IsShowActiveBenefitsOnly;
        }
        System.debug('All******'+GroupPlanSearchResults);
        groupPlanDetails = new ACETGroupDetail(); 
        GroupPlanBenefitResultsList = new List<ACETGroupDetail.GroupPlanWrapper>();
        try {
            ACETWSCalloutResult responseGroupPlanData = callwebservice(groupNumber);
            System.debug('Response1...'+responseGroupPlanData);
            if(responseGroupPlanData.Success) {
                GroupPlanSearchResults = new List<ACETGroupDetail.GroupPlanWrapper>();
                groupPlanDetails = (ACETGroupDetail)responseGroupPlanData.response;
                System.debug('Response2...'+groupPlanDetails);
                //GroupPlanSearchResults = groupPlanDetails.GroupPlanBenefitList;
                System.debug('callout result for Groupdetails'+GroupPlanSearchResults);  
                if(groupPlanDetails.polContract != null){
                    for(ACETGroupDetail.PolicyContract polCon:groupPlanDetails.polContract){
                        if(contractId == polCon.policyConId && status == polCon.policyActualStatus && effectDate == polCon.effectiveDate && endDate == polCon.endDate){
                            if(polCon.GroupPlanBenefitList != null){
                                for(ACETGroupDetail.GroupPlanWrapper groupPlan:polCon.GroupPlanBenefitList) {
                                    if(!IsShowActiveBenefitsOnly || groupPlan.getImage() == 'active') {
                                        System.debug('All1******'+groupPlan);
                                        GroupPlanBenefitResultsList.add(groupPlan);
                                    }
                                }
                            }
                            System.debug('contract from page******'+contractId );
                            System.debug('All1******'+polCon);
                            System.debug('before ID comparison if: ' + contractId + ',' + polCon.policyConId);
                            if(status == polCon.policyActualStatus && contractId == polCon.policyConId && effectDate == polCon.effectiveDate && endDate == polCon.endDate){
                                System.debug('Adding the policy contracts' );
                                GroupPolicyResultsList.add(polCon);
                                
                            } 
                            
                        }
                    }
                }          
            }
            else{
               if(responseGroupPlanData.statusCode==400){
                 setErrorMsg('GN'+'400B',null); 
               }else{               
                 setErrorMsg('GN'+responseGroupPlanData.statusCode,null); 
               }
               // ApexPages.addMessage(new ApexPages.Message(responseGroupPlanData.MessageSeverity, responseGroupPlanData.Message));  
            }
        }  
        catch(Exception ex){ 
            setErrorMsg('MGD997',ex);
            //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, label.ACETOILNotAvailable )); 
        }
        
    }
}