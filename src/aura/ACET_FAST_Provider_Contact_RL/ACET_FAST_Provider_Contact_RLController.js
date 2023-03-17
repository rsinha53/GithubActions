({
    doInit: function(component, event, helper) {
        var recordId = component.get("v.recordId");        
        var action = component.get('c.getAccountRecord');
        action.setParams({
            'recordId': recordId
        });
        action.setCallback(this, function (actionResult) {
            var state = actionResult.getState();            
            if (state === "SUCCESS") {                
                component.set("v.caseRec", actionResult.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    }
})