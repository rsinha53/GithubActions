({
	//Load Ancilliary Data
    loadAncillaryData: function(component, event, helper) {
        
        var memberId = component.get("v.decodedMemberId");
        var action = component.get("c.getAncillaryDetails");
        action.setParams({
            memberId: memberId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var resp = response.getReturnValue();
                console.log('url'+resp);
                
                component.set("v.ancList",resp);
                var val = component.get("v.ancList");
            }
        });
        $A.enqueueAction(action);
    }   
})