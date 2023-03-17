({
   getFocusedTabIdHelper: function (component,event) {
        var workspaceAPI = component.find("workspace");
        workspaceAPI.getTabInfo().then(function(response) {
            var focusedTabId = response.tabId;
            component.set("v.currentTabId", focusedTabId);
        })
        .catch(function(error) {
            console.log(error);
        });
    },
     showECAASpinner: function (component) {
        var spinner = component.find("ecaaspinner");
        $A.util.removeClass(spinner, "slds-hide");
        $A.util.addClass(spinner, "slds-show");
    },
    hideECAASpinner: function (component) {
        var spinner = component.find("ecaaspinner");
        $A.util.removeClass(spinner, "slds-show");
        $A.util.addClass(spinner, "slds-hide");
    },
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
    }
})