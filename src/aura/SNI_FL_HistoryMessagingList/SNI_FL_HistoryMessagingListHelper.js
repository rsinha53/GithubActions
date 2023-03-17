({
	sendBlankMemAffId : function(component,evenet) {
		var cmpEvent = component.getEvent("SNI_FL_SendMemberAffiliationEvt");
        cmpEvent.setParams({
            memberAffiliationId : ''
        });
        cmpEvent.fire();
	},
    handlerSpinner : function(component,event,isShowSpinner) {
		var cmpEvent = component.getEvent("SNI_FL_ProviderAffHandleSpinnerEvt");
        cmpEvent.setParams({
            showSpinner : isShowSpinner
        });
        cmpEvent.fire();
	},
})