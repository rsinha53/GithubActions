({
    getPCPInfo: function(component, event, helper) {
        helper.showSpinner2(component,event,helper);
        var action = component.get("c.getPCPInfoWrapper");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var PCPAssignments = response.getReturnValue().PCPAssignments;
                console.log('!!!!pcp'+PCPAssignments+'!!'+PCPAssignments.length);
                component.set('v.PCPInfoWrapper', PCPAssignments);
                console.log('@@@'+PCPAssignments.length);
                if(PCPAssignments.length > 0){
                	component.find("PCPINfoAccordion").set('v.activeSectionName', 'PCPINfoSection');
                }
            } else if (state === "INCOMPLETE") {
                console.log("Error message: INCOMPLETE");
            } else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
            helper.hideSpinner2(component,event,helper);
        });
        $A.enqueueAction(action);
    },
    hideSpinner2: function(component, event, helper) {        
        component.set("v.Spinner", false);
        console.log('Hide');
    },
    // this function automatic call by aura:waiting event  
    showSpinner2: function(component, event, helper) {
        // make Spinner attribute true for display loading spinner 
        component.set("v.Spinner", true);
        console.log('show');
	}

})