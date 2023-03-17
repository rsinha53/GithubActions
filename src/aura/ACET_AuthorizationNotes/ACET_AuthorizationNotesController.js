({
    doInit: function (cmp, event, helper) {
        helper.addCmpToList(cmp);
        if(cmp.get("v.isMainComponent")){
            setTimeout(function () {
                helper.setTableData(cmp);
            }, 1000);
        }
    },
    // DE378121 - Thanish - 22nd Oct 2020
    authDetailsObjChanged: function(cmp, event, helper){
        if(!$A.util.isEmpty(cmp.get("v.autodocUniqueId")) && !$A.util.isEmpty(cmp.get("v.autodocUniqueIdCmp"))){
            helper.setTableData(cmp);
        }
    },

    chevToggle : function(component, event, helper) {
        if(component.get('v.toggleName') == 'slds-show'){
            component.set("v.toggleName", "slds-hide");
        }
        else{
            component.set("v.toggleName", "slds-show");
        }
    },

    selectRow: function (cmp, event, helper) {
        var checked = event.getSource().get("v.checked");
        var currentRowIndex = event.getSource().get("v.name");
        var tableDetails = cmp.get("v.tableDetails");
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
        }
        tableDetails.selectedRows = selectedRows;
        _autodoc.setAutodoc(cmp.get("v.autodocUniqueId"), cmp.get("v.autodocUniqueIdCmp"), tableDetails);
        helper.updateCmpTableDetails(tableDetails, cmp.get("v.SRN"));
    },

    selectAll: function (cmp, event, helper) {
        var checked = event.getSource().get("v.checked");
        var tableDetails = cmp.get("v.tableDetails");
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
                    i.resolved = true;
                    if (!selectedRowsUniqueKey.has(i.uniqueKey)) {
                        selectedRows.push(i);
                    }
                }
            } else {
                for (var i of tableBody) {
                    i.checked = true;
                    i.resolved = true;
                    selectedRows.push(i);
                }
            }
        } else {
            var unselectedRowUniqueKey = new Set();
            for (var i of tableBody) {
                i.checked = false;
                i.resolved = false;
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
        tableDetails.tableBody = tableBody;
        tableDetails.selectedRows = selectedRows;
        _autodoc.setAutodoc(cmp.get("v.autodocUniqueId"), cmp.get("v.autodocUniqueIdCmp"), tableDetails);
        helper.updateCmpTableDetails(tableDetails, cmp.get("v.SRN"));
    },

    search: function (cmp, event, helper) {
        var data = cmp.get("v.originalTableBody");
        var tableDetails = cmp.get("v.tableDetails");
        const inputValue = event.getSource().get('v.value').toUpperCase();
        var filtered = [];

        data.forEach(filterRecs);

        function filterRecs(item, index) {
            let obj = item.rowColumnData.filter(function (el) {
                if (el.fieldValue != undefined) {
                    return el.fieldValue.indexOf(inputValue) > -1;
                }

            });
            if (obj.length > 0) {
                filtered.push(item);
            }
        }
        tableDetails.tableBody = filtered;
        helper.updateCmpTableDetails(tableDetails, cmp.get("v.SRN"));
    },

    sortColumn: function (cmp, event, helper) {
        var tableDetails = cmp.get("v.tableDetails");
        var colName = event.currentTarget.getAttribute("data-colname");
        var index = event.currentTarget.getAttribute("data-index");
        var direction = 'asc';
        tableDetails.selectedTabsoft = colName;
        var currentDir = tableDetails.arrowDirection;

        if (currentDir == 'arrowdown') {
            tableDetails.arrowDirection = 'arrowup';
            tableDetails.isAsc = true;
            direction = 'asc';
        } else {
            tableDetails.arrowDirection = 'arrowdown';
            tableDetails.isAsc = false;
            direction = 'desc';
        }
        helper.sortHelper(cmp, index, direction, tableDetails);
    },

    // US3125332 - Thanish - 7th Jan 2021
    handleAutodocRefresh : function(cmp, event, helper){
        if(cmp.get("v.enableRefreshAutodoc") && (event.getParam("autodocUniqueId") == cmp.get("v.autodocUniqueId"))){
            helper.refreshAutodoc(cmp);
        }
    },

    // US3225477 Swapnil
    columnOptionsChange: function(cmp, event,helper) {
        var selectedColumn = cmp.get('v.selectedColumn');
        var selectedOption = cmp.get('v.selectedOption');
        var columnOptions = cmp.get('v.columnOptions');
        var tableDetails= cmp.get("v.tableDetails");
		var tableBody=tableDetails.tableBody;
		for(var i in tableBody) {
			var row= tableBody[i].rowColumnData;
			for(var j in row) {
				if(j== selectedColumn){
					if(selectedOption == 'CLIP') {
						if (row[j].titleName.length > 20) {
							row[j].fieldValue = row[j].titleName.substring(0, 20) + '...';
						} else {
							row[j].fieldValue = row[j].fieldValue;
						}
						console.log('CLIP'+row[j].fieldValue);
					} else if(selectedOption == 'WRAP') {
						if (row[j].titleName.length > 20) {
							row[j].fieldValue= (row[j].titleName);
						} else {
							row[j].fieldValue = row[j].fieldValue;
    }
					}
				}
			}
		}
        cmp.set("v.originalTableBody", tableBody);
        cmp.set("v.tableDetails", tableDetails);
    },

    //US3225477
    preventPropagation: function(cmp,event) {
        event.stopPropagation();
    }
})