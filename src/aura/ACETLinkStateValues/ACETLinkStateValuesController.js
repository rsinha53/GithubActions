({
	init : function(component, event, helper) {
        helper.getStateValuesMDT(component,event);
    },
    stateChange:function(component,event,helper){
        var stateId = component.find('provStateId').get('v.value');
        var stateEvnt = component.getEvent("stateChangedEvent");
        
        stateEvnt.setParams({
            selectedState:stateId
        }).fire();
    },
    clearStateValues:function(component,event,helper){
        //US1797978 - Malinda
        component.find('provStateId').set('v.value',"");
    }
})