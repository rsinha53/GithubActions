({
    onDatachange: function(cmp, event, helper) {
        helper.setTableData(cmp);
    },

    //US3653687
    navigateToDetail: function (cmp, event, helper) {
        helper.navigateToDetails(cmp, event, helper);
    },

    onTabClosed: function (cmp, event, helper) {
        let tabFromEvent = event.getParam("tabId");
        var openedTabs = cmp.get("v.openedTabs");
        var currentRowIndex = openedTabs[tabFromEvent];
        if (currentRowIndex != null) {
            var tableDetails = cmp.get("v.tableDetails");
            var tableRows = tableDetails.tableBody;
            tableRows[currentRowIndex].linkDisabled = false;
            tableDetails.tableBody = tableRows;
            cmp.set("v.tableDetails", tableDetails);
        }
    }
})