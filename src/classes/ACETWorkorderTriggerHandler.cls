public with sharing class ACETWorkorderTriggerHandler {

    // These variables store Trigger.oldMap and Trigger.newMap
    Map<Id, Workorder> oldWOs;
    Map<Id, Workorder> newWOs;
    
    // This is the constructor
    // A map of the old and new records is expected as inputs
    public ACETWorkorderTriggerHandler(
        Map<Id, Workorder> oldTriggerWOs, 
        Map<Id, Workorder> newTriggerWOs) {
            oldWOs = oldTriggerWOs;
            newWOs = newTriggerWOs;
        }
    public void checkWorkorderClosed() {
        List<Id> workOrderStatus =new List<Id>();
        for (Workorder newWO : newWOs.values()) {
            Workorder oldWO  = oldWOs.get(newWO.Id);
            Boolean oldWOStatus = String.isnotblank(oldWO.Status_Detail__c)?oldWO.Status_Detail__c.equals('Decision has been made'):false;
            Boolean newWOStatus = String.isnotblank(newWO.Status_Detail__c)?newWO.Status_Detail__c.equals('Decision has been made'):false;
            Boolean oldWOCancelStatus = String.isnotblank(oldWO.Status_Detail__c)?oldWO.Status_Detail__c.equals('Canceled'):false;
            Boolean newWOCancelStatus = String.isnotblank(newWO.Status_Detail__c)?newWO.Status_Detail__c.equals('Canceled'):false;
            System.debug('oldWOStatus....newWOStatus'+oldWOStatus+newWOStatus);
            System.debug('oldWOCancelStatus....newWOCancelStatus'+oldWOCancelStatus+newWOCancelStatus);
            if ((!oldWOStatus && newWOStatus) || (!oldWOCancelStatus && newWOCancelStatus)){
                workOrderStatus.add(newWO.Id);
            }
        }
        if(workOrderStatus != null && workOrderStatus.size()>0)
        ACETMilestoneUtils.completeMilestone(workOrderStatus);
    }
    
    /*public void updateWorkOrderSpecialStatus(){
        List<Id> updateWorkOrderAccount =new List<Id>();
        List<Id> personContactId = new List<Id>();
        Map<Id,Workorder> workOrderStatus = new Map<Id,Workorder>();
        for (Workorder newWO : newWOs.values()) {
            updateWorkOrderAccount.add(newWO.AccountId);
            workOrderStatus.put(newWO.AccountId,newWO);
        }
        for(Account a:[select PersonContactId from account where Id IN :updateWorkOrderAccount]){
            personContactId.add(a.PersonContactId);
        }
        for(AccountContactRelation acon : [select account.Special_Needs_Status__c,contact.accountId from AccountContactRelation where ContactId IN :personContactId]){
            if(workOrderStatus.get(acon.contact.accountId) != null){
                workOrderStatus.get(acon.contact.accountId).Special_Needs_Status__c = acon.account.Special_Needs_Status__c;
            } 
        }
    }*/
    public void insertWorkOrderSpecialStatus(){
        List<Id> updateWorkOrderAccount =new List<Id>();
        List<Id> personContactId = new List<Id>();
        Map<Id,Workorder> workOrderStatus = new Map<Id,Workorder>();
        for (SObject newWorkOrder : trigger.new) {
            WorkOrder newWO = (WorkOrder)newWorkOrder;
            updateWorkOrderAccount.add(newWO.AccountId);
            workOrderStatus.put(newWO.AccountId,newWO);
        }
        for(Account a:[select PersonContactId from account where Id IN :updateWorkOrderAccount]){
            personContactId.add(a.PersonContactId);
        }
        for(AccountContactRelation acon : [select account.Special_Needs_Status__c,account.UHG_Restriction__c,account.Onshore_Restriction__c,contact.accountId from AccountContactRelation where ContactId IN :personContactId]){
            if(workOrderStatus.get(acon.contact.accountId) != null){
                workOrderStatus.get(acon.contact.accountId).UHG_Restriction__c = acon.account.UHG_Restriction__c;
                workOrderStatus.get(acon.contact.accountId).Onshore_Restriction__c = acon.account.Onshore_Restriction__c;
                workOrderStatus.get(acon.contact.accountId).Special_Needs_Status__c = acon.account.Special_Needs_Status__c;
            } 
        }
        

    }
     public void updateViolationField() { 
        for (Workorder newWO : newWOs.values()) {
            if(newWO.Violation__c  != oldWOs.get(newWO.Id).Violation__c){
                if(newWO.Violation__c){
                    newWO.Milestone_Violated__c = true;
                    newWO.Notification_Date__c = datetime.now();
                }
               /* else if(! newWO.Violation__c && newWO.Milestone_Violated__c){
                 newWO.Milestone_Violated__c = false;   
                }*/
            }
            
        }
    }
    
    //US3192452: ITE: Work Orders with Onshore/UHG Restrictions -Start
    //Test class covered under ACETSNIWorkOrderCreationTest class
    Public static void addUhg_OnshoreRestriction(List<WorkOrder> triggerNew,Map<id,WorkOrder> oldMap){
        
        set<String> uhgRestrictedPolicy=new set<String>();
        For(UHG_Restricted_Plans__mdt mt : [select Label from UHG_Restricted_Plans__mdt]){
            if(String.isNotBlank(mt.Label))
             uhgRestrictedPolicy.add(mt.Label.toUpperCase());
        }
        set<id> accIds=new set<Id>();
        for(WorkOrder wo: triggerNew){
            if(String.isnotblank(wo.Policy_ID__c) && (oldMap==null || oldMap.size()==0  || (oldMap != null && oldMap.size()>0 && oldMap.get(wo.id).Policy_ID__c!=wo.Policy_ID__c)))
            {
                wo.UHG_Restriction__c=uhgRestrictedPolicy!=null && uhgRestrictedPolicy.contains(wo.Policy_ID__c.toUpperCase())?'Yes':'No';
                System.debug(' wo.UHG_Restriction__c='+ wo.UHG_Restriction__c);
            }  
            if(((oldMap==null || oldMap.size()==0) && String.isNotBlank(wo.AccountId)) || (oldMap != null && oldMap.size()>0 && oldMap.get(wo.id).AccountId!=wo.AccountId))
            {
                accIds.add(wo.AccountId);
            }
			//Below is Orphan Queue Scenario 
            else if ((oldMap==null || oldMap.size()==0) && String.isBlank(wo.AccountId))
                wo.Onshore_Restriction__c='Yes';
        } 
        System.debug('accIds='+accIds);
        if(accIds!=null && accIds.size()>0){
            map<String,String> accountOnshoreMap=new map<String,String>();
            for(Member_Information__c mem: [Select Account__c,Onshore_Restriction__c from Member_Information__c where Account__c in: accIds]){
                if(String.isNotBlank(mem.Onshore_Restriction__c))
                  accountOnshoreMap.put(mem.Account__c, mem.Onshore_Restriction__c);
            }
            System.debug('accountOnshoreMap='+accountOnshoreMap);
            for(WorkOrder wo: triggerNew){
              if(accountOnshoreMap!=null && accountOnshoreMap.get(wo.AccountId) !=null && 
                 ((oldMap==null && String.isNotBlank(wo.AccountId)) 
                  || (oldMap != null && oldMap.size()>0 && oldMap.get(wo.id).AccountId!=wo.AccountId)))
                {
                    wo.Onshore_Restriction__c=accountOnshoreMap.get(wo.AccountId);
                    System.debug(' wo.Onshore_Restriction__c='+ wo.Onshore_Restriction__c);
                }
        }
        }
    }
    //end
}