({
    fetchAlert: function(component, event, helper) {
        var intId = component.get("v.intId");
        if (intId != undefined) {
            var childCmp = component.find("cComp");
            var memID = component.get("v.memId");
            var GrpNum = component.get("v.grpNum");
            childCmp.childMethodForAlerts(intId, memID, GrpNum, '', '');
        }
    },

    launchProviderLookup: function(component, event, helper) {
        var pagereferenceobj = component.get("v.pageRef");
        var workspaceAPI = component.find("workspace");
        workspaceAPI.getEnclosingTabId().then(function(enclosingTabId) {
            workspaceAPI.openSubtab({
                parentTabId: enclosingTabId,
                pageReference: {
                    "type": "standard__component",
                    "attributes": {
                        "componentName": "c__ACETLGT_ProviderLookup"
                    },
                    "state": {
                        "c__taxID": component.get("v.taxID"),
                        "c__memberid": component.get("v.memId"),
                        "c__srk": pagereferenceobj.state.c__srk,
                        "c__userInfo": component.get("v.userInfo"),
                        "c__hgltPanelData": component.get("v.highlightPanelData"),
                        "c__int": component.get("v.int"),
                        "c__intId": component.get("v.intId"),
                        "c__originatorval": pagereferenceobj.state.c__originatorval,
                        "c__userInfo": pagereferenceobj.state.c__userInfo,
                        "c__hgltPanelData": pagereferenceobj.state.c__hgltPanelData,
                        "c__hgltPanelDataString": pagereferenceobj.state.c__hgltPanelDataString,
                        "c__callTopic": "Provider Lookup",
                        "c__gId": component.get("v.grpNum"),
                        "c__FromClaims": "true"
                    }
                }
            }).then(function(response) {
                workspaceAPI.getTabInfo({
                    tabId: response
                }).then(function(tabInfo) {
                    workspaceAPI.setTabLabel({
                        tabId: tabInfo.tabId,
                        label: "Provider Lookup"
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
        });
    }
})