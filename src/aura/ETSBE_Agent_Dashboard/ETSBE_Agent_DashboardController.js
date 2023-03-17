({
	doInit : function(component, event, helper) {
		var workspaceAPI = component.find("workspace");
    workspaceAPI.getFocusedTabInfo().then(function(response) {
        var focusedTabId = response.tabId;
        workspaceAPI.setTabLabel({
            tabId: focusedTabId,
            label: "Agent Dashboard" //set label you want to set
        });
        workspaceAPI.setTabIcon({
            tabId: focusedTabId,
            icon: "standard:dashboard", //set icon you want to set
            iconAlt: "Edit Contact" //set label tooltip you want to set
        });
    })
	}
})