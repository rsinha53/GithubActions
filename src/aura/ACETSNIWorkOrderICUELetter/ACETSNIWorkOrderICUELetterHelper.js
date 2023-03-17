({
	getSearchParam : function(component, event, helper) {
		var action = component.get("c.getSearchParamValue");
        action.setParams({ recordId : component.get("v.recordId"),searchField : component.get("v.searchField") });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var searchParam = response.getReturnValue();
                if (!($A.util.isUndefinedOrNull(searchParam))) {
                    component.set('v.searchParam', searchParam);
                    this.openICUESubtab(component, event,helper);
                }
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + errors[0].message);
                    }
                } 
            }
        }); 
        $A.enqueueAction(action);
	},
    openICUESubtab: function(component, event, helper){
        var workspaceAPI = component.find("workspace");
        var parentTabId; 
        workspaceAPI.getAllTabInfo().then(function(response) {
                for(var i = 0; i < response.length; i++) {
                var tabfocused = response[i].focused; // title of the tab - usually the record "Name" field, if this is a "customTitle..."
                var tabId = response[i].tabId; // this is the id you'll need to call the closeTab function
                    if(tabfocused) {
                    parentTabId = tabId;
                    break;
                }
            }
		    workspaceAPI.openSubtab({
                parentTabId: parentTabId,
                pageReference: {
                    "type": "standard__component",
                    "attributes": {
                        "componentName": "c__ACETSNIWorkOrderICUELetterDetails"
                    },
                    "state": {
                         "uid":component.get("v.recordId"),
                         "c__currenttabId": parentTabId,
                         "c__searchParam": component.get("v.searchParam"),
                         "c__businessFlow" :component.get("v.businessFlow"),
                         "c__documentType":component.get("v.documentType")
                   }
                },
                focus: true
            }).then(function(tabId) {
                workspaceAPI.setTabLabel({
                tabId: tabId,
                label: "ICUE: " + component.get("v.searchParam")
                });
                workspaceAPI.setTabIcon({
                    tabId: tabId,
                    icon: "standard:work_order"
                });
            }).catch(function(error) {
                console.log(error);
            });
       })
    }
})