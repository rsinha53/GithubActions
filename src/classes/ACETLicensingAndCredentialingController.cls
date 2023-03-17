public with sharing class ACETLicensingAndCredentialingController {

    public ACETHighlightsPanelAdditionalInfo AdditionalInfo {get; set;}
    public ACETCallTopicsDataWrapper wrapper { get; set; } 
    public Interaction__c Interaction { get; set; } 
    
    public ACETLicensingAndCredentialingController ()
    {
        wrapper = new ACETCallTopicsDataWrapper();
         wrapper.updategroupinfoSave = true; // Added by Harish for DE111182
        String InteractionId = apexpages.currentpage().getparameters().get('InteractionId');
        String callTopic = apexpages.currentpage().getparameters().get('callTopic');
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
    }
}