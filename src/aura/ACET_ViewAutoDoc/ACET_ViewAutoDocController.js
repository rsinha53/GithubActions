({
    onInit : function(cmp, event, helper) {
        setTimeout(function(){
            var action = cmp.get("c.getAutoDocInfo");
            action.setParams({ CaseId : cmp.get("v.recordId") });
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    if(response.getReturnValue() != null && response.getReturnValue() != ''){
                        var itemsSe = JSON.parse(response.getReturnValue());
                        cmp.set('v.tableDetails_prev',itemsSe);
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
            $A.enqueueAction(action);
        },1);        
    }
})