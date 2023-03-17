trigger ECMRoutingConfig on Routing_Configuration__c (before insert, before update) {
	if(trigger.isBefore && (trigger.isInsert || trigger.isUpdate)){
		ECMRoutingConfigUtility.validateData(trigger.new);
	}    
    
}