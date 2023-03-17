({
    doInit: function(cmp, event, helper) {
        // helper.setTableDetails(cmp, []);
    },
    
    handleAutodocRefresh: function(cmp, event) {
        if (event.getParam("autodocUniqueId") == cmp.get("v.autodocUniqueId")) {
            let tableList = cmp.get("v.tableList");
            for(var table of tableList) {
                if(!$A.util.isEmpty(table)){
                    table.allChecked = false;
                    table.selectedRows = [];
                    var tableBody = table.tableBody;
                    for(var i of tableBody) {
                        i.checked = false;
                    }
                    table.tableBody = tableBody;   
                }
            }
            cmp.set("v.tableList", tableList);
        }
    },

    extendedCoverageChange: function(cmp, event, helper) {
       var extendCoverage = cmp.get("v.extendedCoverage");
       if(!$A.util.isUndefinedOrNull(extendCoverage) && !$A.util.isUndefinedOrNull(extendCoverage.resultWrapper) && !$A.util.isUndefinedOrNull(extendCoverage.resultWrapper.policyRes)){
            cmp.set("v.pcpHistoryData",extendCoverage.resultWrapper.policyRes.pcpHistoryList);

            if(!$A.util.isEmpty(extendCoverage.resultWrapper.policyRes.pcpHistoryList)){
                helper.setTableDetails(cmp, extendCoverage.resultWrapper.policyRes.pcpHistoryList);
            } else{
                helper.setTableDetails(cmp, []); // DE373966 - 8th Oct 2020
            }
        }

            setTimeout(function(){
            helper.hidePCPHistorySpinner(cmp);
            },1);
    },

    closePCPTable: function(cmp){
        cmp.set("v.isShowPCPHistory", false);
        var appevent = $A.get("e.c:SAE_PCPHistoryEvent");
        appevent.setParams({
            "historyViewed" : false,
            "originPage" : cmp.get("v.memberTabId")
        });
        appevent.fire();
    },

    selectRow: function (cmp, event) {
        var checked = event.getSource().get("v.checked");
        var currentRowIndex = event.getSource().get("v.name");
        var tableList = cmp.get("v.tableList");
        var tableDetails = tableList[cmp.get("v.policySelectedIndex")];
        var selectedRows = tableDetails.selectedRows;
        var currentRow = tableDetails.tableBody[currentRowIndex];

        if (checked) {
            if (!$A.util.isEmpty(selectedRows)) {
                var existingRecord = false;
                for (var i of selectedRows) {
                    if (i.uniqueKey == currentRow.uniqueKey) {
                        i = currentRow;
                        existingRecord = true;
                        break;
                    }
                }
                if (!existingRecord) {
                    selectedRows.push(currentRow);
                }
            } else {
                selectedRows.push(currentRow);
            }
        } else {
            selectedRows = selectedRows.filter(function (value, index, arr) {
                return value.uniqueKey != currentRow.uniqueKey;
            });
            tableDetails.allChecked = false;
        }

        tableDetails.selectedRows = selectedRows;
        tableList[cmp.get("v.policySelectedIndex")] = tableDetails;
        cmp.set("v.tableList", tableList);

        _autodoc.setAutodoc(cmp.get("v.autodocUniqueId"), cmp.get("v.policySelectedIndex"), tableDetails);
    },

    selectAll: function (cmp, event) {
        var checked = event.getSource().get("v.checked");
        var tableList = cmp.get("v.tableList");
        var tableDetails = tableList[cmp.get("v.policySelectedIndex")];
        var tableBody = tableDetails.tableBody;
        var selectedRows = tableDetails.selectedRows;

        var selectedRowsUniqueKey = new Set();
        for (var i of selectedRows) {
            selectedRowsUniqueKey.add(i.uniqueKey);
        }
        if (checked) {
            if (!$A.util.isEmpty(selectedRows)) {
                for (var i of tableBody) {
                    i.checked = true;
                    if (!selectedRowsUniqueKey.has(i.uniqueKey)) {
                        selectedRows.push(i);
                    }
                }
            } else {
                for (var i of tableBody) {
                    i.checked = true;
                    selectedRows.push(i);
	}
            }
        } else {
            var unselectedRowUniqueKey = new Set();
            for (var i of tableBody) {
                i.checked = false;
                unselectedRowUniqueKey.add(i.uniqueKey);
            }
            selectedRows = selectedRows.filter(function (value, index, arr) {
                if (unselectedRowUniqueKey.has(value.uniqueKey)) {
                    return false;
                } else {
                    return true;
                }
            });
        }

        tableDetails.selectedRows = selectedRows;
        tableDetails.tableBody = tableBody;
        tableList[cmp.get("v.policySelectedIndex")] = tableDetails;
        cmp.set("v.tableList", tableList);

        _autodoc.setAutodoc(cmp.get("v.autodocUniqueId"), cmp.get("v.policySelectedIndex"), tableDetails);
    },
})