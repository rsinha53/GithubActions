({
    onInit : function(cmp, event, helper) {
        cmp.set("v.showSpinner", true);
        var pageReference = cmp.get("v.pageReference");
        cmp.set("v.parentUniqueId", pageReference.state.c__parentUniqueId);
        cmp.set("v.objectId", pageReference.state.c__objectId);
        helper.getDocument(cmp);
    },

    onTabFocused: function (cmp, event, helper) {
        let focusedTabId = event.getParam('currentTabId');
        let tabId = cmp.get("v.tabId");

        if($A.util.isEmpty(tabId)) {
            cmp.set("v.tabId", focusedTabId);
        }
    },

    onTabClosed : function(cmp, event, helper) {
        let tabId = event.getParam('tabId');

        if(tabId == cmp.get("v.tabId")) {
            var tabCloseEvt = $A.get("e.c:ACET_SRICloseTabEvent");
            tabCloseEvt.setParams({
                "closedTabId" : tabId,
                "parentUniqueId" : cmp.get("v.parentUniqueId")
            });
            tabCloseEvt.fire();
        }
    }
})