({
	doInit : function(cmp, event, helper) {
        var pageReference = cmp.get("v.pageReference");
        cmp.set("v.autodocUniqueId", pageReference.state.c__autodocUniqueId);
        cmp.set("v.autodocUniqueIdCmp", pageReference.state.c__autodocUniqueIdCmp);
        cmp.set("v.appealName", pageReference.state.c__appealName);
        cmp.set("v.taxId", pageReference.state.c__taxId);
        cmp.set("v.currentRowData", pageReference.state.c__currentRowData);
        helper.getAppealDetail(cmp);
	},
    
    onTabClosed: function (cmp, event, helper) {
        let tabId = event.getParam('tabId');
        if(tabId == cmp.get("v.tabId")) {
            let tabClosedEvt = $A.get("e.c:ACET_EnableAutoDocLink");
            tabClosedEvt.setParams({
                //"closedTabId" : tabId,
                "openedLinkData":cmp.get("v.currentRowData")
                //"currentRowIndex":cmp.get("v.currentRowIndex")
            });
            tabClosedEvt.fire();
        }
    },

    onTabFocused: function (cmp, event) {
        let focusedTabId = event.getParam('currentTabId');
        let tabId = cmp.get("v.tabId");
        if($A.util.isEmpty(tabId)) {
            cmp.set("v.tabId", focusedTabId);
        }
    },
})