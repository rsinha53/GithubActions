({
    doInit : function(component, event, helper) {
        var action = component.get("c.getCaseFromId");
        action.setParams({
            accountId : component.get("v.recordId")
        });
        action.setCallback(this, function(a) {
            if (a.getState() === "SUCCESS") {
                component.set("v.caseColumns", a.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    }
})