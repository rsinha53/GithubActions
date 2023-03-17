public with Sharing class ACETEmployerBrokerOtherInquiryController 
{
    //public String buttonClicked { get; set; }
    public ACETHighlightsPanelAdditionalInfo AdditionalInfo {get;set;}
    public ACETCallTopicsDataWrapper wrapper {get;set;}
    //public boolean notResearchUser {get;set;}
    public String selectedTopic{get;set;}   
    //public String comments{get;set;}
    public String swivelATNE_URL{get;set;}
    public String calltopic{get;set;}
    //Case OEcase = new Case(); 
    public String swivelORBIT_URL{get;set;} 
    public Interaction__c Interaction { get; set; } 
    public Contact Subject { get; set; }    
    public String hpAdditionInfoStr {get{
        return JSON.serialize(AdditionalInfo);
    }set;}  
             
     public ACETEmployerBrokerOtherInquiryController(){      
         calltopic = '';
         wrapper = new ACETCallTopicsDataWrapper();
         wrapper.updategroupinfoSave = true; // Added by Harish for DE111182 
         String InteractionId = apexpages.currentpage().getparameters().get('interactionId');
        system.debug('InteractionId--->'+InteractionId);
        if(InteractionId != null && InteractionId != ''){
           Interaction = ACETProviderUtility.GetInteractionByID(InteractionId);
        }
        calltopic = apexpages.currentpage().getparameters().get('callTopic');
        wrapper.CaseObj.Topic__c = callTopic;
        system.debug('Interaction --->'+Interaction ); 
         initHighlightPanelAdditionalInfo();
         if(wrapper.AdditionalInfo != null && wrapper.AdditionalInfo.isGroupNotFound == '1') {
             wrapper.setNotFound('Group/Employer', wrapper.AdditionalInfo.GroupNumber);
        }
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
            ACETGroupDetailsWrapper deserializedExceptionData = (ACETGroupDetailsWrapper)JSON.deserialize(Interaction.Highlight_Panel_GroupInfo__c, ACETGroupDetailsWrapper.class);
            AdditionalInfo.UHCBS = deserializedExceptionData.UHCBS;    
            AdditionalInfo.GroupN = deserializedExceptionData.GroupName ;
            AdditionalInfo.GroupStatus = deserializedExceptionData.GroupStatus;
            AdditionalInfo.ServiceTeam = deserializedExceptionData.ServiceTeam;
            //AdditionalInfo.EffectiveStartDate = deserializedExceptionData.EffectiveStartDate;
            AdditionalInfo.RiskManagement = deserializedExceptionData.RiskManagement;
            AdditionalInfo.RatingMethod = '';
            AdditionalInfo.RenewalDate= deserializedExceptionData.RenewalDate; 
            AdditionalInfo.RelationshipType = deserializedExceptionData.RelationshipType ;
            AdditionalInfo.groupSName = deserializedExceptionData.groupSName;
        }
        hpAdditionInfoStr = JSON.serialize(AdditionalInfo);
    }
}