public with sharing class ACETCancelCaseController {
    //public ACETCallTopicsDataWrapper CaseData {get;set;}  
    public Case CaseObj {get;set;}  
    public String Comments {get;set;}
    
    public ACETCancelCaseController (){
        String caseId= ApexPages.currentPage().getParameters().get('caseId');        
        CaseObj = [select id,Topic__c, Cancel_Reason__c,Comments__c, CaseNumber ,isComplete__c from case where id = : caseId];
        
        
        //Case currentCaseObj;
        //String currentCaseId = ApexPages.currentPage().getParameters().get('currentCaseId');
        //if(!String.isEmpty(currentCaseId)){
            //currentCaseObj = [select id, interaction__c from case where id =:currentCaseId];
        //}
        
        //CaseData = new ACETCallTopicsDataWrapper();
        //CaseData.caseObj = currentCaseObj;
        //caseData.init();  
        
    }
    
    public void save(){
        CaseObj.Status='Canceled';
        caseObj.isComplete__c =true;
        upsert caseObj;   
        
        //add comment from cancel page
        ACETCallTopicsDataWrapper.addCaseComment(caseObj.Id, Comments); 
    }        
}