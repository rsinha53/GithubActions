trigger ERM_permissionValidation on ERM_EServices_Policy_User__c (before insert,before update) {   
    
    if(Trigger.isExecuting && Trigger.isBefore && (Trigger.isInsert || Trigger.isUpdate)){
        
       
            
            ERM_RequestController.validatePermission(Trigger.new); 
            System.Debug('Validation Successfull');
            
        
        
    }
    
}