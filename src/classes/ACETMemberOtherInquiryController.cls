public with sharing class ACETMemberOtherInquiryController {    
    public ACETCallTopicsDataWrapper wrapper {get;set;}
    public String Topic {get;set;}
    public string surrogateKey {get; set;}    
    public string mnf {get;set;}
    public boolean isCancelCaseCreation{get;set;}
    public ACETMemberOtherInquiryController() {
        wrapper = new ACETCallTopicsDataWrapper();
        wrapper.updategroupinfoSave = true; // Added by Harish for DE111178
        wrapper.init();
        wrapper.CaseObj.Topic__c = 'Member Other Inquiry';
        initHighlightPanelAdditionalInfo();
        surrogateKey = ApexPages.currentPage().getParameters().get('SRK');
        if(wrapper.AdditionalInfo != null && wrapper.AdditionalInfo.isMemNotFound == '1') {
            wrapper.setNotFound('Member', wrapper.AdditionalInfo.MemberId);
        }
        if (!String.isEmpty(surrogateKey)){ 
            wrapper.surrogateKey = surrogateKey;
        }        
    }
    private void initHighlightPanelAdditionalInfo(){
        String additionalInfoStr = apexpages.currentpage().getparameters().get('additionalInfo');
        wrapper.AdditionalInfo = (ACETHighlightsPanelAdditionalInfo)json.deserialize(additionalInfoStr,ACETHighlightsPanelAdditionalInfo.class);            
    }

    public PageReference routeCase(){
        wrapper.caseObj.Topic__c ='Member Other Inquiry';
        wrapper.createCase();            
        PageReference caseDetailsReference = new PageReference('/' + wrapper.CaseObj.Id);
        return caseDetailsReference;
    }
}