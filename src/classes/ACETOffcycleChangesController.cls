public with sharing class ACETOffcycleChangesController{

    public ACETCallTopicsDataWrapper wrapper {get;set;}
    public string comments{get;set;} 
    public Contact Subject { get; set; }
    public Interaction__c  Interaction { get; set; }    
    public string redirectUrl {get; set;} 
    public String[] selectedValue{get;set;}
    public id interactionId{get;set;}
    public id contactid{get;set;}
    public ACETGroupDetail groupDetails{get;set;}
    
    public ACETHighlightsPanelAdditionalInfo AdditionalInfo {get;set;}
    public String hpAdditionInfoStr {get{
        return JSON.serialize(AdditionalInfo);
    }set;}          
    
    public ACETOffcycleChangesController()
    {   
        string InteractionId = apexpages.currentpage().getparameters().get('InteractionId');
        string contactId = apexpages.currentpage().getparameters().get('contactId');
        string callTopic = apexpages.currentpage().getparameters().get('callTopic');
        Interaction = ACETProviderUtility.GetInteractionByID(InteractionId);        
        wrapper = new ACETCallTopicsDataWrapper();
        wrapper.updategroupinfoSave = true; // Added by Harish for DE111182
        wrapper.CaseObj.Topic__c = callTopic;
        wrapper.AutodocComment = comments;
        initHighlightPanelAdditionalInfo();
        selectedValue = new String[]{};
        redirectUrl = '/apex/ACETViewEmployerGroup?Originator='+Interaction.Originator__r.Name+'&OriginatorType='+Interaction.Originator_Type__c+'&InteractionId='+InteractionId+'&contactid='+Interaction.Originator__c; 
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
        
        /******added by sourabh ****/
        if(Interaction != Null && Interaction.Highlight_Panel_GroupInfo__c != null)
        {
            ACETGroupDetailsWrapper deserializedExceptionData = (ACETGroupDetailsWrapper)JSON.deserialize(Interaction.Highlight_Panel_GroupInfo__c, ACETGroupDetailsWrapper.class);
            System.debug('Group Additional information'+deserializedExceptionData);
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