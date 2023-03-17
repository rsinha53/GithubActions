trigger ECMTaskTrigger on Task (before insert, before update) {

    if(trigger.isBefore){
        for(task tsk :trigger.new){
            if(trigger.isInsert ||( tsk.OwnerId != Null && trigger.oldMap != null && tsk.OwnerId != trigger.oldMap.get(tsk.id).OwnerId)  ){
                
                tsk.HiddenOwnerID__c= tsk.OwnerId;
            
            }
            
        }
    
    }
    /* ACET FAST PIP code starts from here */
    if(trigger.isBefore){
        if(Trigger.isInsert){
            ACET_Fast_CaseTaskOwnerTrgHandler.handleBeforeInsertOrUpdate(trigger.new,trigger.oldMap, 'Insert');
        }
        if(Trigger.isUpdate && ACET_Fast_CaseTaskOwnerTrgHandler.isFirstTime){
            ACET_Fast_CaseTaskOwnerTrgHandler.isFirstTime=false;
            ACET_Fast_CaseTaskOwnerTrgHandler.handleBeforeInsertOrUpdate(trigger.new,trigger.oldMap, 'Update');
        }
    }
    /* ACET FAST PIP code ends here */
}