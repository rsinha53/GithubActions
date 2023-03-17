public with sharing class ACETMisdirectedCallController {
    public ACETCallTopicsDataWrapper CaseData {get;set;}
    public String Comments {get;set;}
    public String SurrogateKey {get;set;}  
    public String profileName {get;set;}  
    
    public ACETMisdirectedCallController(){
        //Case currentCaseObj = new Case();
        CaseData = new ACETCallTopicsDataWrapper();
        SurrogateKey = ApexPages.currentPage().getParameters().get('SRK');
        system.debug('232323SurrogateKey::'+SurrogateKey);
        String errorMessage = ApexPages.currentPage().getParameters().get('errMsg');
        System.debug('232323'+errorMessage );
        if(errorMessage != null && errorMessage != ''){
                String strLabel = 'System.Label.'+errorMessage;
                System.debug('strLabel '+strLabel);
                AddErrorMessage(errorMessage);
        }
                
        String currentCaseId = ApexPages.currentPage().getParameters().get('currentCaseId');        
        system.debug('>> '+currentCaseId);        
        if(!String.isEmpty(currentCaseId)){
            CaseData.CaseObj = [select id, interaction__c, Misdirected_Reason__c, CaseNumber from case where id =:currentCaseId];                                   
        }else{           
            CaseData.init();            
        }
        profileName = ACETUtility.GetUserProfileName(); 
    }
    public void fetchProfile(){
      profileName = ACETUtility.GetUserProfileName(); 
    }
    public void AddErrorMessage(String ErrorMessage)
    {
        if(ErrorMessage == 'ACETMemberOffshoreError'){
               ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, System.Label.ACETMemberOffshoreError));     
        }
        if(ErrorMessage == 'ACETMemberOffshoreUHGError'){
               ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, System.Label.ACETMemberOffshoreUHGError));     
        }
    }
    
    public void checkMisdirectCase(){
        system.debug('inside checkMisdirectCase :: '+JSON.serialize(CaseData));
        if(String.isEmpty(CaseData.CaseObj.id)){
            system.debug('inserting misdirect case');
            
            CaseData.cancelCase();
            system.debug(CaseData.CaseObj.id);                                    
        }
        String onshoreRestrictionReason = ApexPages.currentPage().getParameters().get('misdirectReason');
        if(onshoreRestrictionReason == 'true'){
            CaseData.CaseObj.Misdirected_Reason__c = 'Global Restricted' ;
        }
        
        String defaultValue = ApexPages.currentPage().getParameters().get('defaultVal');
        System.debug('232323'+defaultValue );
        if(defaultValue != null && defaultValue != ''){
            CaseData.CaseObj.Misdirected_Reason__c = defaultValue;
        }        
    } 
    
     public void save() {     
        CaseData.CaseObj.Status='Canceled';
        CaseData.CaseObj.isComplete__c =true;
        CaseData.CaseObj.Surrogate_Key__c = SurrogateKey;
        
        upsert CaseData.CaseObj;   
        
        //add comment from cancel page
        ACETCallTopicsDataWrapper.addCaseComment(CaseData.CaseObj.Id, Comments); 
    }          
}