({
    loadHSAValues: function (component,helper)  {
        // create a one-time use instance of the serverEcho action
        // in the server-side controller
        var CPTIN = component.get("v.CPTIN");
        console.log(CPTIN);
            var action = component.get("c.GetHsaSummaryValues");
            action.setParams({ 
                
                ssn :  CPTIN
                
            });
            
            // Create a callback that is executed after 
            // the server-side action returns
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    // Alert the user with the value returned 
                    // from the server
                    //alert("From server: " + response.getReturnValue());
                    //alert("JSON ::: "+JSON.stringify( response.getReturnValue()));
                    var responseVals = response.getReturnValue();
                    
                    //alert("JSON ::: "+JSON.stringify( responseVals));
                    if($A.util.isEmpty(responseVals.ErrorMessage) && !$A.util.isEmpty(responseVals.resultWrapper) && !$A.util.isUndefined(responseVals.resultWrapper)  && !$A.util.isEmpty(responseVals) && !$A.util.isUndefined(responseVals)){
                    component.set("v.summaryResult",responseVals.resultWrapper);
                    helper.hideSpinner(component,event,helper);
                    }else{
                        helper.displayToast('Error!', responseVals.ErrorMessage);
                        helper.hideSpinner(component,event,helper);
                    }
                }
                else if (state === "INCOMPLETE") {
                    // do something
                }
                    else if (state === "ERROR") {
                        var errors = response.getError();
                        if (errors) {
                            if (errors[0] && errors[0].message) {
                                console.log("Error message: " + 
                                            errors[0].message);
                            }
                        } else {
                            console.log("Unknown error");
                        }
                    }
            });
            
            // optionally set storable, abortable, background flag here
            
            // A client-side action could cause multiple events, 
            // which could trigger other events and 
            // other server-side action calls.
            // $A.enqueueAction adds the server-side action to the queue.
            $A.enqueueAction(action);
        
    },


    // function automatic called by aura:doneWaiting event 
    hideSpinner : function(component,event,helper){
        // make Spinner attribute to false for hiding loading spinner    
        component.set("v.spinner", false);
    },
    displayToast: function(title, messages){
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": title,
            "message": messages,
            "type": "error",
            "mode": "dismissible",
            "duration": "10000"
        });
        toastEvent.fire();
		return;
    }    
    
    
})