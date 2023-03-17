({
    doInit: function(component, event, helper) {

        var action = component.get("c.firstMethod");
        var cseId = component.get("v.recordId");
        var randomnumber = Math.floor((Math.random() * 100) + 1);
        var workspaceAPI = component.find("workspace");
        workspaceAPI.isConsoleNavigation().then(function(response) {
            workspaceAPI.getFocusedTabInfo().then(function(response) {
                workspaceAPI.openSubtab({
                    parentTabId: response.tabId,
                    pageReference: {
                        "type": "standard__component",
                        "attributes": {
                            "componentName": "c__ACETLGT_CreateLetter"
                        },
                        "state": {
                            "c__caseId": cseId
                        }
                    },
                    focus: true
                }).then(function(response) {
                    workspaceAPI.getTabInfo({
                        tabId: response
                    }).then(function(tabInfo) {
                        workspaceAPI.setTabLabel({
                            tabId: tabInfo.tabId,
                            label: "Letters"
                        });
                        workspaceAPI.setTabIcon({
                            tabId: tabInfo.tabId,
                            icon: "standard:note",
                            iconAlt: "Letters"
                        });
                    });
                }).catch(function(error) {
                    console.log(error);
                });
            })
        }).catch(function(error) {
            console.log(error);
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                $A.get("e.force:closeQuickAction").fire();
            }
        });
        $A.enqueueAction(action);

    }
})