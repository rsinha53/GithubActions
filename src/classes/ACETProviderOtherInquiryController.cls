public with sharing class ACETProviderOtherInquiryController {
    
    
    public ACETHighlightsPanelAdditionalInfo AdditionalInfo {get;set;}
    public ACETCallTopicsDataWrapper wrapper {get;set;}
    //private String interactionId;
    public boolean isDetailPage{get;set;}
    public boolean isCancelCaseCreation{get;set;}
    public boolean isMisdirectCaseCreation{get;set;}
    public Contact Subject {get;set;}
    public Interaction__c Interaction {get;set;}
    
    public ACETProviderOtherInquiryController(){
        init();
        String interactionId = ApexPages.currentPage().getParameters().get('interactionId');   
        
        string ptc =  ApexPages.currentPage().getParameters().get('addressInfo'); 
        system.debug('^^%%815 in providerother inquiry '+ptc);          
    }
        
    public void init(){
        isDetailPage = true;
        wrapper = new ACETCallTopicsDataWrapper();
        wrapper.updategroupinfoSave = true; // Added by Harish for DE111178 
        wrapper.CaseRecordTypeLabel = 'Employer&Broker';
        String strSurrogateKey = apexpages.currentpage().getparameters().get('SRK');
         wrapper.SurrogateKey = strSurrogateKey;
        // wrapper.caseObj = new Case();
        // isCancelCaseCreation=false;
        // isMisdirectCaseCreation=false;
        wrapper.init();  
        wrapper.CaseObj.Topic__c = 'Provider Other Inquiry';
     //   wrapper.CaseObj.Provider_Type__c = ApexPages.currentPage().getParameters().get('addressInfo'); 
        //initInteractionAndSubject(); 
        initHighlightPanelAdditionalInfo();  
    }
    
    //private void initInteractionAndSubject(){
        //wrapper.init();                                                                            
    //}
    
    private void initHighlightPanelAdditionalInfo(){
        String additionalInfoStr = apexpages.currentpage().getparameters().get('additionalInfo');
        system.debug(additionalInfoStr);
        if(additionalInfoStr!=null)
        wrapper.AdditionalInfo = (ACETHighlightsPanelAdditionalInfo)json.deserialize(additionalInfoStr,ACETHighlightsPanelAdditionalInfo.class);
    }
    
    //public PageReference save(){ 
         //wrapper.caseObj.Topic__c ='Provider Other Inquiry';
         //wrapper.createCase();            
        //PageReference caseDetailsReference = new PageReference('/' + wrapper.CaseObj.Id);
        //return caseDetailsReference;                              
    //}

    public void renderCancelCaseSection(){
        isCancelCaseCreation=true;
        isDetailPage=false;  
    }
    public void renderMisdirectCaseSection(){
        isMisdirectCaseCreation=true;
        isDetailPage=false;  
    }
    public PageReference routeCase(){
        wrapper.caseObj.Topic__c ='Provider Other Inquiry';
        wrapper.createCase();            
        PageReference caseDetailsReference = new PageReference('/' + wrapper.CaseObj.Id);
        return caseDetailsReference;
    }
    
    //public PageReference SaveAndClose(){
        //wrapper.caseObj.Topic__c ='Provider Other Inquiry';
        //wrapper.caseObj.Status='Closed';

        //wrapper.createCase();            
        //PageReference caseDetailsReference = new PageReference('/apex/ACETCallTopicSaveAndClose?caseId=' + wrapper.CaseObj.Id);
        //system.debug('wrapper.CaseObj.Id  >>>  '+wrapper.CaseObj.Id);
        //return caseDetailsReference;
    //}   
     
    public List<SelectOption> getTopics(){
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('','--None--'));
        options.add(new SelectOption('Provider Credentialing','Provider Credentialing'));
        options.add(new SelectOption('Provider Education','Provider Education'));
        options.add(new SelectOption('Provider Network Management','Provider Network Management'));
        options.add(new SelectOption('Provider Portal Education/Support','Provider Portal Education/Support'));
        options.add(new SelectOption('Other Provider Inquiry','Other Provider Inquiry'));
        return options;        
   }           
}