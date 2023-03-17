public with sharing class ACETLifeInquiryController 
{
    public ACETHighlightsPanelAdditionalInfo AdditionalInfo {get;set;}
    public ACETCallTopicsDataWrapper wrapper {get;set;}
    public String comments{get;set;}
    public String swivelFacets_URL{get;set;}
    public Interaction__c Interaction { get; set; } 
    public Contact Subject { get; set; }    
    public String hpAdditionInfoStr {get{
        return JSON.serialize(AdditionalInfo);
    }set;}   
        
     public ACETLifeInquiryController(){
        fetchATNESysURL();
        wrapper = new ACETCallTopicsDataWrapper();
        wrapper.CaseRecordTypeLabel = 'Employer&Broker';
        String strSurrogateKey = apexpages.currentpage().getparameters().get('SRK');
        String callTopic = apexpages.currentpage().getparameters().get('callTopic');
        wrapper.SurrogateKey = strSurrogateKey;
        wrapper.caseObj.Topic__c = callTopic;
        String InteractionId = apexpages.currentpage().getparameters().get('interactionId');
        if(InteractionId != null && InteractionId != '')
        Interaction = ACETProviderUtility.GetInteractionByID(InteractionId);
        String contactId = ApexPages.currentPage().getParameters().get('contactId');
        if (!String.isEmpty(contactId)){ 
            subject = ACETProviderUtility.GetContactByID(contactId);
        }
        initHighlightPanelAdditionalInfo();
     }    
    private void initHighlightPanelAdditionalInfo(){
        if(AdditionalInfo == null){
            AdditionalInfo = new ACETHighlightsPanelAdditionalInfo(); 
        }        
        string addInfo = ApexPages.currentPage().getParameters().get('additionalInfo');
        System.debug('Additional Info'+addInfo);
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
            AdditionalInfo.EffectiveStartDate = deserializedExceptionData.EffectiveStartDate;
            AdditionalInfo.RiskManagement = deserializedExceptionData.RiskManagement;
            AdditionalInfo.RatingMethod = '';
            AdditionalInfo.RenewalDate= deserializedExceptionData.RenewalDate; 
            AdditionalInfo.RelationshipType = deserializedExceptionData.RelationshipType ;
            AdditionalInfo.groupSName = deserializedExceptionData.groupSName;
        }
           
        hpAdditionInfoStr = JSON.serialize(AdditionalInfo);
    }
    
     public void fetchATNESysURL()
    {
         string sandboxName = ACETUtility.GetOrgName();
         swivelFacets_URL = ACETUtility.GetSwivelEndpointByOrgName(sandboxName,'FACETS');
    }
    
}