({
    doInit: function(cmp, event, helper) {
        helper.loadData(cmp, event, helper);
    },
    
    
	loadCirrusPage : function(component, event, helper) {   
                
               var action = component.get("c.GenerateCIRRUS");
                action.setParams({
                
                });
                action.setCallback(this, function(response) {
                        var state = response.getState();
                        if (state === "SUCCESS") {
                                var storeResponse = response.getReturnValue();                
                                component.set("v.cirrusURL", storeResponse); 
                                helper.getCIRRUSURL(component, event, helper);               
                        }
                });
                $A.enqueueAction(action);
                
	}
    
})