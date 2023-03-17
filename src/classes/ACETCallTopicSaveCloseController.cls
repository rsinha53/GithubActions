public with sharing class ACETCallTopicSaveCloseController{
    public ACETCallTopicsDataWrapper caseData{get;set;}
    public Case caseObj {get;set;}
    public boolean removeNone {get;set;}
    public String Comments {get;set;}
    
    public ACETCallTopicSaveCloseController(){
        String caseId= ApexPages.currentPage().getParameters().get('caseId'); 
       
        caseObj = [select id,Topic__c,New_Closed_Reason__c,Comments__c, casenumber ,isComplete__c from case where id = : caseId];
         /**** added by vishakha 12/02 US413581 START*****/
        if(CaseObj.Topic__c == 'View Consumer Dashboard'){
            String ConDashboardTopic = ApexPages.currentPage().getParameters().get('blockedCallTopic ');
            if(ConDashboardTopic != null && caseObj.New_Closed_Reason__c != 'System Unavailable') {
                caseObj.New_Closed_Reason__c = 'Opportunity '+ ConDashboardTopic;
            }
        }
        if(CaseObj.Topic__c == 'Create Authorization' || CaseObj.Topic__c == 'Create PCP Referral'){
            String createCloseReason = ApexPages.currentPage().getParameters().get('blockedCallTopic ');
            if(createCloseReason != null && caseObj.New_Closed_Reason__c != 'System Unavailable' && CaseObj.Topic__c == 'Create Authorization') {
                caseObj.New_Closed_Reason__c = 'Authorization '+ createCloseReason ;
            }
            if(createCloseReason != null && caseObj.New_Closed_Reason__c != 'System Unavailable' && CaseObj.Topic__c == 'Create PCP Referral') {
                caseObj.New_Closed_Reason__c = 'Referral '+ createCloseReason ;
            }
        }
        /**** added by vishakha 12/02 US413581 END*****/
        caseObj.Comments__c ='';
        system.debug(caseObj);
             
    }
    public void save(){
       
        caseObj.isComplete__c =true;
        upsert caseObj;
        
        //add case comment from save and close page
        ACETCallTopicsDataWrapper.addCaseComment(caseObj.Id, Comments); 

    }  
    public void RemoveNone(){
        removeNone = true;
    }  
}