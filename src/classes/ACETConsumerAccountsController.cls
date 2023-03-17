public with sharing class ACETConsumerAccountsController{
    public ACETCallTopicsDataWrapper wrapper {get;set;}
    public boolean notResearchUser {get;set;}
    public string surrogateKey {get; set;}     
    public ACETConsumerAccountsController(){
        init();     
         surrogateKey = ApexPages.currentPage().getParameters().get('SRK');
         if (!String.isEmpty(surrogateKey)){ 
            wrapper.surrogateKey = surrogateKey;
        }       
    }
    public boolean isCancelCaseCreation{get;set;}    
    public void init(){
        wrapper = new ACETCallTopicsDataWrapper(); 
        wrapper.updategroupinfoSave = true; // Added by Harish for DE111182        
        wrapper.init();
        wrapper.CaseObj.Topic__c = 'Consumer Accounts';
        
        initHighlightPanelAdditionalInfo();
        getloggedinProfileName();  
    }
    private void initHighlightPanelAdditionalInfo(){
        String additionalInfoStr = apexpages.currentpage().getparameters().get('additionalInfo');
        wrapper.AdditionalInfo = (ACETHighlightsPanelAdditionalInfo)json.deserialize(additionalInfoStr,ACETHighlightsPanelAdditionalInfo.class);            
    }    
    private void getloggedinProfileName(){ 
    notResearchUser = true;
    List<Profile> PROFILE = [SELECT Id, Name FROM Profile WHERE Id=:userinfo.getProfileId() LIMIT 1];
    String loggedinProfileName = PROFILE[0].Name;
       if(loggedinProfileName.contains('Research'))
        { notResearchUser = false;}
    }
    public void renderCancelCaseSection(){
        isCancelCaseCreation=true;  
    }
    public PageReference routeCase(){
        wrapper.caseObj.Topic__c ='Consumer Accounts';
        wrapper.createCase();            
        PageReference caseDetailsReference = new PageReference('/' + wrapper.CaseObj.Id);
        return caseDetailsReference;
    }
   public PageReference SaveAndClose(){
        wrapper.caseObj.Topic__c ='Consumer Accounts';
        wrapper.caseObj.Status='Closed';
        wrapper.createCase();            
        PageReference caseDetailsReference = new PageReference('/apex/ACETCallTopicSaveAndClose?caseId=' + wrapper.CaseObj.Id);
        system.debug('wrapper.CaseObj.Id  >>>  '+wrapper.CaseObj.Id);
        return caseDetailsReference;
    }           
    public List<SelectOption> getTopics() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Account Balances','Account Balances'));
        options.add(new SelectOption('Check/Payment Inquiry','Check/Payment Inquiry'));
        options.add(new SelectOption('Claim Inquiry','Claim Inquiry'));
        options.add(new SelectOption('Eligibility Expenses','Eligibility Expenses'));
        options.add(new SelectOption('Eligibility Detail','Eligibility Detail'));
        options.add(new SelectOption('Health Care Spending Card/CAC','Health Care Spending Card/CAC'));
        options.add(new SelectOption('Plan Attributes','Plan Attributes'));
        options.add(new SelectOption('Other','Other'));
        return options;
    }
    public List<SelectOption> getAccountTypes() { 
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('FSA','FSA'));
        options.add(new SelectOption('FSA DC','FSA DC'));
        options.add(new SelectOption('HIA','HIA'));
        options.add(new SelectOption('HRA/MRA/PCA','HRA/MRA/PCA'));
        options.add(new SelectOption('HSA','HSA'));
        options.add(new SelectOption('RMSA','RMSA'));
        return options;
    }
    public List<SelectOption> getCancelReasons() { 
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('','--None--'));
        options.add(new SelectOption('Caller Disconnected','Caller Disconnected'));
        options.add(new SelectOption('Created in Error','Created in Error'));
        return options;
    }
    public PageReference endCall() {
        return null;
    }    
}