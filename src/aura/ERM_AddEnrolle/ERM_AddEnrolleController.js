({
    doInit: function(component, event) {
        let action = component.get("c.getrequestdata");
        var recordId = component.get("v.recordId");
        action.setParams({ caseId: recordId });
        action.setCallback(this, function(response) {
            let state = response.getState();
            var reqData = response.getReturnValue();
            if (state === "SUCCESS") {
                var workspaceAPI = component.find("workspace");
                workspaceAPI
                .openTab({
                    pageReference: {
                        type: "standard__component",
                        attributes: {
                            componentName: "c__ERM_CreateRequestFlow"
                        },
                        state: {
                            c__recordId: component.get("v.recordId"),
                            c__reqType: reqData.reqType,
                            c__platform: reqData.platform,
                            c__editEnrollee: true                  
                        }
                    },
                    focus: true
                })
                .then(function(response) {
                    workspaceAPI
                    .getTabInfo({
                        tabId: response
                    })
                    .then(function(tabInfo) {
                        workspaceAPI.setTabLabel({
                            tabId: tabInfo.tabId,
                            label: "Add Enrolle"
                        });
                        workspaceAPI.setTabIcon({
                            tabId: tabInfo.tabId,
                            icon: "standard:people",
                            iconAlt: "Member"
                        });
                    });
                })
                .catch(function(error) {
                    console.log(error);
                });
            } else {
                console.log("##UNKNOWN-STATE:", state);
            }
        });
        $A.enqueueAction(action);
    }
});