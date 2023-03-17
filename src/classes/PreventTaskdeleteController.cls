Public class PreventTaskdeleteController {

    public id taskId{get;set;}
    public id caseId{get;set;}
    public string baseURL{get;set;}
    

    public PreventTaskdeleteController(ApexPages.StandardController controller) {
         taskId = ApexPages.currentPage().getParameters().get('id');
        baseURL = System.URL.getSalesforceBaseUrl().toExternalForm();
    
        

        task taskRelCase = [SELECT Id, WhatId FROM Task where id=: taskId] ;
    
        caseId = taskrelcase.whatid;
        
     
    
    }


}