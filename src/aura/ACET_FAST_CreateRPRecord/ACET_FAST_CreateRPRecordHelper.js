({
	showToast: function(component, event, title,type,message){
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": title,
            "type": type,
            "message": message,
        });
        toastEvent.fire();
    },
    closeCurrentTab: function(component, event){
        console.log("inside close current tab");
        var workspaceAPIVar = component.find("workspace");
        workspaceAPIVar.getFocusedTabInfo().then(function(response) {
            var focusedTabId = response.tabId;
            workspaceAPIVar.closeTab({tabId: focusedTabId});
        })
        .catch(function(error) {
            console.log("error occurred");
            console.log("error is "+JSON.stringify(error));
        });
    },
})