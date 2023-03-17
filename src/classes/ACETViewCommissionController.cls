public with sharing class ACETViewCommissionController
{
    public ACETHighlightsPanelAdditionalInfo AdditionalInfo {get; set;}
    public ACETCallTopicsDataWrapper wrapper {get; set;}    
    public String swivelBASICS_URL{get; set;}
    public Interaction__c Interaction { get; set; }    
     public ACETViewCommissionController(){  
        fetchBASICSsysURL(); 
        wrapper = new ACETCallTopicsDataWrapper();
        wrapper.updategroupinfoSave = true; // Added by Harish for DE111182
        String InteractionId = apexpages.currentpage().getparameters().get('InteractionId');
        string callTopic = apexpages.currentpage().getparameters().get('callTopic');
        wrapper.caseObj.Topic__c = callTopic;
        if(InteractionId != null && InteractionId != ''){
           Interaction = ACETProviderUtility.GetInteractionByID(InteractionId);
        }
        initHighlightPanelAdditionalInfo();              
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
            AdditionalInfo.RiskManagement = deserializedExceptionData.RiskManagement;
            AdditionalInfo.RatingMethod = '';
            AdditionalInfo.RenewalDate= deserializedExceptionData.RenewalDate; 
            AdditionalInfo.RelationshipType = deserializedExceptionData.RelationshipType ;
            AdditionalInfo.groupSName = deserializedExceptionData.groupSName;
        }
    }     
     
    public void fetchBASICSsysURL()
    {
        string sandboxName = ACETUtility.GetOrgName();
        swivelBASICS_URL = ACETUtility.GetSwivelEndpointByOrgName(sandboxName, 'BASICS');
    }  
}