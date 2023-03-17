({
   
    showOptumFllowUpsCard: function (component, event, helper) {
        component.set("v.isOptumFllowUpsShow","false");
    },
    
    hideOptumFllowUpsCard: function (component, event, helper) {
        component.set("v.isOptumFllowUpsShow","true");
        var val = component.get("v.calloutStatus");
        if(val == undefined){
            helper.loadCommitmentsDetails(component,event,helper);
            component.set("v.calloutStatus","Active");
        }
    }
})