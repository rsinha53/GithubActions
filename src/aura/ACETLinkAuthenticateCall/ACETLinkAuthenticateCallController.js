({
    handleChange: function (cmp, event) {
        var selectedOptionValue = event.getParam("value");
    },
    
    setProviderDetails: function (cmp, event, helper) {
        cmp.set("v.providerValidated", event.getParam("providerValidated"));
        cmp.set("v.providerDetails", event.getParam("providerDetails"));
        cmp.set("v.isProviderSearchDisabled", event.getParam("isProviderSearchDisabled"));
    },
    
    chooseCallOPtions:function (cmp, event) {
        var selectedCallVal = event.getParam("value");
        cmp.set("v.interactionType",selectedCallVal);        
    },
    
    navigateToInteraction: function (cmp, event, helper) {
        debugger;
        helper.getProviderDetails(cmp);
        if (!cmp.get("v.providerValidated")) {
            return;
        }
        var matchingTabs = [];
        var workspaceAPI = cmp.find("workspace");
        workspaceAPI.getAllTabInfo().then(function (response) {
            if (!$A.util.isEmpty(response)) {
                for (var i = 0; i < response.length; i++) {
                    if (response[i].pageReference.state.c__tabOpened) {
                        matchingTabs.push(response[i]);
                    }
                }
            }
            if (matchingTabs.length === 0) {
                workspaceAPI.openTab({
                    pageReference: {
                        "type": "standard__component",
                        "attributes": {
                            "componentName": "c__SAE_InteractionOverview"
                        },
                        "state": {
                            "c__tabOpened": true,
                            "c__providerDetails": cmp.get("v.providerDetails"),
                            "c__isProviderSearchDisabled": cmp.get("v.isProviderSearchDisabled"),
                            "c__providerNotFound": cmp.get("v.providerNotFound"),
                            "c__noMemberToSearch": cmp.get("v.noMemberToSearch")
                        }
                    },
                    focus: true
                }).then(function (response) {
                    workspaceAPI.getTabInfo({
                        tabId: response
                    }).then(function (tabInfo) {
                        console.log("The recordId for this tab is: " + tabInfo.recordId);
                        var focusedTabId = tabInfo.tabId;
                        var providerLName = cmp.get("v.providerDetails.lastName");
                        // If the value in "interactionCard" attribute is null or empty then show "Interaction Overview" as the label.
                        if (!$A.util.isEmpty(providerLName)) {
                            var IOLabel = providerLName.charAt(0) + providerLName.slice(1).toLowerCase();
                        } else {
                            var IOLabel = "Interaction Overview";
                        }
                        workspaceAPI.setTabLabel({
                            tabId: focusedTabId,
                            label: IOLabel
                        });
                        workspaceAPI.setTabIcon({
                            tabId: focusedTabId,
                            icon: "standard:contact_list",
                            iconAlt: "Interaction Overview : "
                        });
                    });
                }).catch(function (error) {
                    console.log(error);
                });
            } else {
                console.log('##ML:NOT-OPEN');
                var focusTabId = matchingTabs[0].tabId;
                var tabURL = matchingTabs[0].url;
                console.log('##TAB-ID:' + focusTabId);
                workspaceAPI.openTab({
                    url: tabURL
                }).then(function (response) {
                    workspaceAPI.focusTab({
                        tabId: response
                    });
                }).catch(function (error) {
                    console.log(error);
                });
            }
        })
    },
    
    doInit : function(component, event, helper) {
        var action = component.get("c.fetchUser");
        var storeResponse;
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                storeResponse = response.getReturnValue();
                // set current user information on userInfo attribute
                component.set("v.profileDetail", storeResponse);
            }
        });
        $A.enqueueAction(action);
     },
    
    disableContinueBtn : function(cmp, event, helper){
        var memNotFoundVal = event.getParam("isCheckedMemNotFound");
        cmp.set('v.memberNotFound',memNotFoundVal);
    }
})