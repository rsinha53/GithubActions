public with sharing class ACETGroupPolicyContractController extends ACETErrorHandler{
    public ACETCallTopicsDataWrapper wrapper {get;set;}
    public string comments{get;set;} 
    public string InteractionId {get;set;}
    public boolean IsShowActiveCoveragesOnly {get;set;}
    public String callTopic {get; set;}
    public Contact Subject { get; set; }
    public boolean notResearchUser {get;set;}
    public Interaction__c  Interaction { get; set; }
    //public Boolean IsShowActiveBenefitsOnly {get;set;}
    public string groupNumber{get;set;}  
    public AcetGroupDetail groupDetails{get;set;}  
    public static AcetGroupDetail groupPolicyDetails{get;set;}
    public static AcetGroupDetail.PolicyContract GroupPolicyDummy {get;set;}
    public static List<AcetGroupDetail.PolicyContract> GroupPolicySearchResults {get; set;}
    public static List<AcetGroupDetail.PolicyContractStatus> GroupPolicyStatusResults {get; set;} // US936960
    public List<AcetGroupDetail.PolicyContract> GroupPolicyResultsList {get; set;}
    public List<AcetGroupDetail.PolicyContractStatus> GroupPolicyStatusList{get; set;}  //US936960
    public AcetGroupDetail.PolicyContract polContractGenInfo{get;set;}
    public string policyoption{get;set;}
    public ACETHighlightsPanelAdditionalInfo AdditionalInfo {get;set;}
    public String hpAdditionInfoStr {get{
        return JSON.serialize(AdditionalInfo);
    }set;} 
    public string contractId {get;set;}
    public String status {get;set;}
    public String effectDate {get;set;}
    public String endDate {get;set;}
    public String filterStatus {get;set;}
    
    public ACETGroupPolicyContractController() {
      try{
        groupNumber = apexpages.currentpage().getparameters().get('groupId');
        contractId = apexpages.currentpage().getparameters().get('contractId');
        System.debug('Grou Pd'+groupNumber);
        InteractionId = apexpages.currentpage().getparameters().get('interactionId');
        policyoption = apexpages.currentpage().getparameters().get('PolicyOption');
        callTopic = apexpages.currentpage().getparameters().get('callTopic');
        filterStatus = apexpages.currentpage().getparameters().get('filterStatus');
        if(InteractionId != null && InteractionId != '')
            Interaction = ACETProviderUtility.GetInteractionByID(InteractionId);
        wrapper = new ACETCallTopicsDataWrapper();
        wrapper.CaseObj.Topic__c = callTopic;
        wrapper.AutodocComment = comments;
        initHighlightPanelAdditionalInfo();
        system.debug('###callTopic '+callTopic );
        system.debug('###contractId '+contractId );
        }catch(Exception ex){
          setErrorMsg('MGD997',ex);
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
                AcetGroupDetailsWrapper deserializedExceptionData = (AcetGroupDetailsWrapper)JSON.deserialize(Interaction.Highlight_Panel_GroupInfo__c, AcetGroupDetailsWrapper.class);
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
              
        }  
        hpAdditionInfoStr = JSON.serialize(AdditionalInfo);
    }
    
    public void ShowPolicyContract() {
        system.debug('##########>>>>>>>>> Inside Show PolicyContract' );
        groupPolicyDetails = new AcetGroupDetail(); 
        GroupPolicyResultsList = new List<AcetGroupDetail.PolicyContract>();
        GroupPolicyStatusList= new List<AcetGroupDetail.PolicyContractStatus>();  //US936960
        
        groupNumber = apexpages.currentpage().getparameters().get('groupId');
        contractId = apexpages.currentpage().getparameters().get('contractId');
        status = apexpages.currentpage().getparameters().get('status');
        effectDate = apexpages.currentpage().getparameters().get('effectDate');
        endDate = apexpages.currentpage().getparameters().get('endDate');
        System.debug('###Group Id is' + groupNumber );
        system.debug('###contractId '+contractId );
        system.debug('###contractstatus '+status);
        //contractId = '80521';
        try {
            ACETWSCalloutResult responseGroupPolicyData = callwebservice(groupNumber);
            System.debug('Response1###...'+responseGroupPolicyData );
            if(responseGroupPolicyData.Success) {
                GroupPolicySearchResults = new List<AcetGroupDetail.PolicyContract>();
                GroupPolicyStatusResults = new List<AcetGroupDetail.PolicyContractStatus>(); // US936960
                polContractGenInfo = new ACETGroupDetail.PolicyContract();
                
                groupPolicyDetails = (AcetGroupDetail)responseGroupPolicyData.response;
               //groupPolicyDetails =null;
                System.debug('Response2###...'+groupPolicyDetails );
                System.debug('###'+groupPolicyDetails.polContract);  
                //System.debug('###'+groupPolicyDetails.PolicyResultsList);  
                
                GroupPolicySearchResults = groupPolicyDetails.polContract; //PolicyResultsList;
                GroupPolicyStatusResults = groupPolicyDetails.PolicyStatusList;
                
                System.debug('###@@@ GroupPolicySearchResults '+GroupPolicySearchResults );  
                if(GroupPolicySearchResults != null) {
                    for(AcetGroupDetail.PolicyContract polContract:GroupPolicySearchResults ) {
                        System.debug('contract from page******'+contractId );
                            System.debug('All1******'+polContract);
                            if(status == polContract.policyActualStatus && contractId == polContract.policyConId && effectDate == polContract.effectiveDate && endDate == polContract.endDate){
                                System.debug('Adding the policy contracts' );
                                GroupPolicyResultsList.add(polContract);
                                
                            } 
                            System.debug('before ID comparison if: ' + contractId + ',' + polContract.policyConId);
                            if(status == polContract.policyActualStatus && contractId == polContract.policyConId && effectDate == polContract.effectiveDate && endDate == polContract.endDate){
                                System.debug('polContract genGroupInfo: ' + polContract.polGenGroupInfo);
                                polContractGenInfo = polContract;
                                System.debug('polContractGenInfo1 ' + polContractGenInfo.polGenGroupInfo);
                            }
                    }
                }
                system.debug('GroupPolicyResultsList = ' +GroupPolicyResultsList);
                
                //US936960 ***
                if(GroupPolicyStatusResults != null) {
                    for(AcetGroupDetail.PolicyContractStatus ren:GroupPolicyStatusResults ) {
                            GroupPolicyStatusList.add(ren);
                    }
                }
                //***
                        
            }
            else{ 
               if(responseGroupPolicyData.statusCode==400){
                     setErrorMsg('GN'+'400B',null);
                  }else{
                    setErrorMsg('GN'+responseGroupPolicyData.statusCode,null);
                 }
                //ApexPages.addMessage(new ApexPages.Message(responseGroupPolicyData.MessageSeverity, responseGroupPolicyData.Message));  
            }
            System.debug('polContractGenInfo2 ' + polContractGenInfo.polGenGroupInfo);
        }  
        catch(Exception ex)
        { 
            setErrorMsg('MGD997',ex);
           // ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, label.ACETOILNotAvailable )); 
        }
        
    }
}