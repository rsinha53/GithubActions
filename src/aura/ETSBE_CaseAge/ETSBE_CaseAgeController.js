({
    doInit : function(component, event, helper) {
        
        var action = component.get("c.calculateCaseAge");
        action.setParams({ caseId : component.get("v.recordId") });        
        action.setCallback(this, function(response) {    
            var state = response.getState();            
            if (state === "SUCCESS") {
                component.set("v.age", response.getReturnValue());
            }            
        });        
        $A.enqueueAction(action);
        
    }
})