({
	    doInit : function(component, event, helper) {
        // call apex method to fetch list view dynamically 
        var action = component.get("c.listValues");
        action.setParams({
            "objectInfos" : component.get("v.objectInfos")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var checklistViewResult = response.getReturnValue();
               if(checklistViewResult.length > 0){
                   component.set("v.bShowListView", true);
				   component.set("v.ListResult",response.getReturnValue());
                   
                }        } 
            else if (state === "INCOMPLETE") {
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
    },
    
    onPicklistChange: function(component, event, helper) {
        // unrenders listView 
        component.set("v.bShowListView", false); 
        
        // get current selected listview Name 
        var lstViewName = event.getSource().get("v.value"); 
        
        // set new listName for listView
        component.set("v.currentListViewName", lstViewName);
        
        // rendere list view again with new listNew  
        component.set("v.bShowListView", true); 
    },
})