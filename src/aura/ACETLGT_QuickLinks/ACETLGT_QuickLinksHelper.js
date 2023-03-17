({
    loadData: function(cmp, event, helper) {
        var action = cmp.get("c.getQuickLinksList");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                cmp.set('v.bookmarks', response.getReturnValue());
            } else if (state === "INCOMPLETE") {

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
        });
        $A.enqueueAction(action);
    },
    
    //Cirrus US
	getCIRRUSURL : function(component, event, helper) {

        var cirrusURL = component.get("v.cirrusURL");
        console.log('cirrusURL New :: '+cirrusURL);
        
        window.open(cirrusURL, 'CIRRUS', 'toolbars=0,width=1200,height=800,left=0,top=0,scrollbars=1,resizable=1');
		
	}    
})