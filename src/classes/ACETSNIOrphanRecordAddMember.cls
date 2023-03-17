public class ACETSNIOrphanRecordAddMember {
 @AuraEnabled 
    public static searchResult addMemberOnWorkOrder(String workOrderId){
        Id familyAccRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Family').getRecordTypeId();
        Id personAccRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Individual').getRecordTypeId();
        searchResult result = new searchResult();
        String famId;
        String pId;
        WorkOrder wo = [select Id,AccountId,Policy_ID__c,Member_ID__c,Date_of_Birth__c,First_Name__c,Last_Name__c from WorkOrder where id=:workOrderId];
        if(wo.AccountId != null){
            result.checkAccount = 'Account Exist';
 
        }
        else{
            for(Account acc: [Select id from Account where Policy_ID__c=:wo.Policy_ID__c and Member_ID__c=:wo.Member_ID__c and recordtypeId=:familyAccRecordTypeId]){
                
                if(acc !=null)
                    famId=acc.id;
            }
            
            if(String.isNotBlank(famId)){
                System.debug('Family Id'+ famId);
                for(AccountContactRelation acr: [Select ContactId,accountId,Relationship__c,contact.FirstName,contact.LastName,
                                                 contact.BirthDate,contact.Name,
                                                 Member_ID__c,Policy_ID__c,Contact.AccountId from AccountContactRelation
                                                 where accountId =:famId]){
                                                     System.debug('Acrs ,'+ acr);
                                                     System.debug('Acrs ,'+ acr.contact.FirstName);
                                                     System.debug('Acrs ,'+ acr.contact.LastName);
                                                     System.debug('Acrs ,'+ acr.Contact.BirthDate);
                                                     System.debug('wo ,'+ wo.First_Name__c);
                                                     System.debug('wo ,'+ wo.Last_Name__c);
                                                     System.debug('wo ,'+ wo.Date_of_Birth__c);
                                                     if(wo.First_Name__c.equalsIgnoreCase(acr.contact.FirstName) && wo.Last_Name__c.equalsIgnoreCase(acr.contact.LastName) && wo.Date_of_Birth__c==acr.contact.BirthDate)
                                                         pId=acr.Contact.AccountId;  
                                                     
                                                 }
                System.debug('Pid'+pId);
                if(String.isNotBlank(pId)){
                    system.debug('check2');
                    wo.Add_Member__c = false;
                    wo.AccountId=pId;
                    update wo;
                    result.checkAccount = 'Account added from Salesforce';
                    
                } else{
                    result.checkAccount = 'Account added from SNI';
                    system.debug('check3');
                }    
                
                    
            }else{
                result.checkAccount = 'Account added from SNI';
                system.debug('check4');
            }
        }
        result.workod = wo;
        return result;
    }
    
    public class searchResult{
        @AuraEnabled public String checkAccount = '';
        @AuraEnabled public WorkOrder workod = new WorkOrder();
    }
}