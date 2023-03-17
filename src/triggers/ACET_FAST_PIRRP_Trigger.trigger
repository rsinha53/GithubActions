trigger ACET_FAST_PIRRP_Trigger on PIR_Resolution_Partner__c (before insert, before update) {

    if(Trigger.isBefore && (Trigger.isInsert || Trigger.isUpdate)){
            ACET_FAST_PIRRP_TriggerHandler.handleBeforeInsertOrUpdate(Trigger.new);
    }
}