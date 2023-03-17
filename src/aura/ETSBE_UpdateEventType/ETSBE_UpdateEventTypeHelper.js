({
	fireToastMessage: function (title, message, type, mode, duration) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": title,
            "message": message,
            "type": type,
            "mode": mode,
            "duration": duration
        });
        toastEvent.fire();
    },
    
    openSpecInsTab : function(component, event, helper) {
        var grpSelected = component.get('v.groupSelected');
        var workspaceAPI = component.find("workspace");
        workspaceAPI.openTab({
            pageReference: {
                "type": "standard__component",
                "attributes": {
                    "componentName": "c__ETSBE_SpecialInstructions"
                },
                "state": {
                    "c__InteractionRecord": component.get("v.interactionRec"),
                    "c__CaseRecord": component.get("v.caseRec"),
                    "c__isNotChildCase": true,
                    "c__GroupData": component.get("v.groupData"), //jangi
                    "c__InternalContacts": component.get("v.internalContacts") //jangi
                }
            },
            focus: true
        }).then(function(response) {
            
            workspaceAPI.getTabInfo({
                tabId: response
                
            }).then(function(tabInfo) {
                
                workspaceAPI.setTabLabel({
                    tabId: tabInfo.tabId,
                    label: 'Special Instructions'
                });
                workspaceAPI.setTabIcon({
                    tabId: tabInfo.tabId,
                    icon: "standard:people",
                    iconAlt: "Member"
                });
                
            });
        }).catch(function(error) {
            console.log(error);
        });
    }
})