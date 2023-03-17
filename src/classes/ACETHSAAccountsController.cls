public with sharing class ACETHSAAccountsController extends ACETErrorHandler {
    public ACETCallTopicsDataWrapper wrapper {get;set;}
    public string comments{get;set;} 
    public string InteractionId {get;set;}
    public String callTopic {get; set;}
    public Contact Subject { get; set; }
    //public boolean notResearchUser {get;set;}
    public Interaction__c  Interaction { get; set; }
    public string surrogateKey{get; set;} 
    public ACETHighlightsPanelAdditionalInfo AdditionalInfo {get;set;}
    public String hpAdditionInfoStr {get{
        return JSON.serialize(AdditionalInfo);
    }set;} 
    public ACETHSASummaryWebservice ACETHSASummary;
    public ACETHSASummaryResult hsaSummaryResult { get; set;}
    public string unmaskedSSN{get;set;}
    public String CPTIN{get;set;}
    public String memberId{get;set;}
    
    public ACETHSAAccountsController() {  
       try{
        InteractionId = apexpages.currentpage().getparameters().get('interactionId');
        memberId = apexpages.currentpage().getparameters().get('memberId');
        callTopic = apexpages.currentpage().getparameters().get('callTopic');
        //getloggedinProfileName();
        if(InteractionId != null && InteractionId != '')
            Interaction = ACETProviderUtility.GetInteractionByID(InteractionId);
        wrapper = new ACETCallTopicsDataWrapper();
        //wrapper.init();
        wrapper.CaseObj.Topic__c = callTopic;
        wrapper.AutodocComment = comments;
        surrogateKey = ApexPages.currentPage().getParameters().get('SRK');
        if (!String.isEmpty(surrogateKey)){ 
            wrapper.surrogateKey = surrogateKey;
        }  
        initHighlightPanelAdditionalInfo();
        }catch(Exception ex){
                 setErrorMsg('MGD997',ex);
        }
    }
   
    public PageReference callWSOnLoad(){
       try{
        ACETWSCalloutResult SummaryResponse;
        ACETHSASummary = new ACETHSASummaryWebservice();
        CPTIN = ApexPages.currentPage().getParameters().get('cptin');
        unmaskedSSN = ApexPages.currentPage().getParameters().get('ssn');
        memberId = apexpages.currentpage().getparameters().get('memberId');
        system.debug('@@@memberId  '+memberId  );
        
        if(unmaskedSSN != 'undefined' && unmaskedSSN != null && unmaskedSSN != ''){
            unmaskedSSN = unmaskedSSN;
        }
        else
        {
            unmaskedSSN  = (cptin != null)?cptin:'';
        }
        //unmaskedSSN = '975946093';
        
        system.debug('@@@unmaskedSSN '+unmaskedSSN  );
        
        SummaryResponse = ACETHSASummary.GetHsaSummary(unmaskedSSN);
        system.debug('@@@response'+SummaryResponse );
        if(SummaryResponse.Success){
            try{
            
            hsaSummaryResult = (ACETHSASummaryResult)SummaryResponse.Response;
            system.debug('@@@result'+hsaSummaryResult );   

            }catch(Exception ex){
                 setErrorMsg('MGD997',ex);
                //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, system.Label.ACETUnexpectedErrorMessage));
            }
        }
        else{
             if(SummaryResponse.statusCode==401){
               setErrorMsg('GN'+'500',null);
             }else if(SummaryResponse.statusCode==400){
               setErrorMsg('GN'+'400B',null);
             }else{
             setErrorMsg('GN'+SummaryResponse.statusCode,null);
             }
            //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, SummaryResponse.Message));
        }
        }
        catch(Exception ex){
                 setErrorMsg('MGD997',ex);
            }
        return null;
    }
    
    private void initHighlightPanelAdditionalInfo(){
       try{
        if(AdditionalInfo == null){
            AdditionalInfo = new ACETHighlightsPanelAdditionalInfo(); 
        }        
        string addInfo = ApexPages.currentPage().getParameters().get('additionalInfo');
        if(addInfo != null)
        {
            AdditionalInfo  = (ACETHighlightsPanelAdditionalInfo)JSON.deserialize(addInfo, ACETHighlightsPanelAdditionalInfo.class);
        }
  
        hpAdditionInfoStr = JSON.serialize(AdditionalInfo);
        }catch(Exception ex){
            setErrorMsg('MGD997',ex);
        }
    }
    
}