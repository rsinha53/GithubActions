({
    doInit : function(component, event, helper) {
        var action = component.get("c.getInstanceType");
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state == 'SUCCESS') {
                var result = response.getReturnValue();
                component.set("v.isSandbox",result);
            } else {
                
            }
        });
        $A.enqueueAction(action);
    }
})