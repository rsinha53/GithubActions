({
    //Test branch Commit
    openMisDirect:function(component,event,helper){
        /**/
        var workspaceAPI = component.find("workspace");
        workspaceAPI.getEnclosingTabId().then(function(enclosingTabId) {
            if(enclosingTabId == false){
                workspaceAPI.openTab({
                    pageReference: {
                        "type": "standard__component",
                        "attributes": {
                            "componentName": "c__SAE_MisdirectComponent" // c__<comp Name>
                        },
                        "state": {
                        }
                    },
                    focus: true
                }).then(function(response) {            
                    workspaceAPI.getTabInfo({
                        tabId: response
                    }).then(function(tabInfo) {
                        console.log("The recordId for this tab is: " + tabInfo.recordId);
                        var focusedTabId = tabInfo.tabId;
                        workspaceAPI.setTabLabel({
                            tabId: focusedTabId,
                            label: "Misdirect"
                        });
                        // US1831550 Thanish (Date: 5th July 2019) start {
                        workspaceAPI.setTabIcon({
                            tabId: focusedTabId,
                            icon: "standard:decision",
                            iconAlt: "Misdirect"
                        });
                        // } US1831550 Thanish end
                    });
                }).catch(function(error) {
                    console.log(error);
                });
            }else{
                workspaceAPI.openSubtab({
                    parentTabId: enclosingTabId,
                    pageReference: {
                        "type": "standard__component",
                        "attributes": {
                            "componentName": "c__SAE_MisdirectComponent" // c__<comp Name>
                        },
                        "state": {
                            "c__originatorName": component.get('v.originatorName'),
                            "c__originatorType": component.get('v.originatorType'),
                            "c__contactName": component.get('v.contactName'),
                            "c__subjectName": component.get('v.subjectName'),
                            "c__subjectType": component.get('v.subjectType'),
                            "c__subjectDOB": component.get('v.subjectDOB'),
                            "c__subjectID": component.get('v.subjectID'),
                            "c__subjectGrpID": component.get('v.subjectGrpID'),
                            "c__interactionID": component.get('v.interactionID')
                        }
                    }
                }).then(function(subtabId) {
                    console.log("The new subtab ID is:" + subtabId);
                    workspaceAPI.setTabLabel({
                        tabId: subtabId,
                        label: "Misdirect" //set label you want to set
                    });
                    // US1831550 Thanish (Date: 5th July 2019) start {
                    workspaceAPI.setTabIcon({
                        tabId: subtabId,
                        icon: "standard:decision",
                        iconAlt: "Misdirect"
                    });
                    // } US1831550 Thanish end
                }).catch(function(error) {
                    console.log(error);
                });
            }
            
        });
    }
})