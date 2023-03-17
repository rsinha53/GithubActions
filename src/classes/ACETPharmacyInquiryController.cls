public with Sharing class ACETPharmacyInquiryController 
{
    //public String buttonClicked { get; set; }
    public ACETHighlightsPanelAdditionalInfo AdditionalInfo {get;set;}
    public ACETCallTopicsDataWrapper wrapper {get;set;}
    //public List<String> selectedTopic{get;set;}
    //public String comments{get;set;}
    public Contact Subject { get; set; }    
    public Interaction__c Interaction { get; set; } 
    
    Case pharmacyInquiryCase = new Case();
     
     public ACETPharmacyInquiryController(){
        wrapper = new ACETCallTopicsDataWrapper();
        wrapper.CaseObj.Topic__c = 'Rx Enrollment';
        wrapper.updategroupinfoSave = true;
        wrapper.CaseRecordTypeLabel = 'Employer&Broker';
        system.debug('Test=='+ apexpages.currentpage().getparameters().get('SRK'));
        String strSurrogateKey = apexpages.currentpage().getparameters().get('SRK');
        wrapper.SurrogateKey = strSurrogateKey;
        
        String InteractionId = apexpages.currentpage().getparameters().get('InteractionId');
        if(InteractionId != null && InteractionId != '')
        Interaction = ACETProviderUtility.GetInteractionByID(InteractionId);
        
        String contactId = ApexPages.currentPage().getParameters().get('contactId');
        if (!String.isEmpty(contactId)){ 
            subject = ACETProviderUtility.GetContactByID(contactId);
        }
        initHighlightPanelAdditionalInfo();
        if(wrapper.AdditionalInfo != null && wrapper.AdditionalInfo.isMemNotFound == '1') {
            wrapper.setNotFound('Member', wrapper.AdditionalInfo.MemberId);
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
        
    }
   
    public List<SelectOption> getPharmacyInquiryCallTypes() {
        List<SelectOption> options = new List<SelectOption>();            
        options.add(new SelectOption('Update Member Pharmacy Enrollment Information','Update Member Pharmacy Enrollment Information'));             
        options.add(new SelectOption('Other','Other'));
        return options;
    }
}