({
    doInit : function(component, event, helper) {
        var action = component.get("c.getchildaccountFromId");
        action.setParams({
            accountId : component.get("v.recordId")
        });
        action.setCallback(this, function(a) {
            if (a.getState() === "SUCCESS") {
                component.set("v.accountColumns", a.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    }
})