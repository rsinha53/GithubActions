({
	closeSubTabs: function (cmp, event, helper,closedTabId) { 
        if (closedTabId == cmp.get("v.currentTabId")) { 
            var appEvent = $A.get("e.c:ACET_ECAATabClosed");
            appEvent.setParams({
                "srn": cmp.get('v.searchParam'),
                "docIDToClose" : cmp.get("v.docIdLst")
            });
            appEvent.fire();
        }
    },
})