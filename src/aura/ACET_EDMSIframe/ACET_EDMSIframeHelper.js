({
    getFocusedTabIdHelper: function (component,event) {
        var workspaceAPI = component.find("workspace");
        workspaceAPI.getTabInfo().then(function(response) {
            JSON.parse(JSON.stringify(response));
            var focusedTabId = response.tabId;
            component.set("v.currentTabId", focusedTabId);
        })
        .catch(function(error) {
            console.log(error);
        });
    }
})