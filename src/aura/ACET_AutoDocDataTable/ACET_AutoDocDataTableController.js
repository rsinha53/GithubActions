({
    // US3786086 - Thanish - 20th Aug 2021
    doinit: function (cmp, event) {
        let today = new Date();
        cmp.set("v.tableTimestampId", today.getTime());

        // cmp.set("v.currentStartNumber", cmp.get("v.currentPageNumber"));
        // if (cmp.get("v.noOfRecordPerPage") > cmp.get("v.tableBody.length")) {
        //     cmp.set("v.currentEndNumber", cmp.get("v.tableBody.length"));
        // } else {
        //     cmp.set("v.currentEndNumber", cmp.get("v.noOfRecordPerPage"));
        // }
    },
    /* method to show  tooltip for Plan Waivers Motion */
	showToolTipActive:function(component,event,helper){
        var index=event.currentTarget.getAttribute("data-index");
       var prIndex=document.getElementById(index);
        prIndex.style.display="block";
       
    },
    /* method to hide tooltip for Plan Waivers Motion */
    HideToolTipActive:function(component,event,helper){
       var index=event.currentTarget.getAttribute("data-index");
       var prIndex=document.getElementById(index);
        prIndex.style.display="none";
    },															 
    toggleSection: function(cmp,event) {
        var indexValue = event.target.getAttribute("data-index");
        var iconName = event.target.getAttribute("class");
        let tableRows = cmp.get("v.tableBody");
        for (var index = Math.min(indexValue) + 1; index < tableRows.length; index++) {
            if(!tableRows[index].isChildRow) {
                break;
            } else {
                if(iconName == 'slds-section slds-is-close') {
                    event.target.setAttribute('class', 'slds-section slds-is-open');
                    tableRows[index].hideChildRow = false;
                } else {
                    event.target.setAttribute('class', 'slds-section slds-is-close');
                    tableRows[index].hideChildRow = true;
                }
            }
        }
        cmp.set("v.tableBody", tableRows);
    },
    // US2917434, US3208169
    fireAutodocEvent: function (cmp, event) {
        var currentRowIndex = event.currentTarget.parentElement.parentElement.getAttribute("data-index");
        var cellIndex = event.currentTarget.getAttribute("data-cell-index");
        var tableBody = cmp.get("v.tableBody");
        cmp.set("v.tempTableBody",tableBody);
        var tableDetails = cmp.get("v.tableDetails");
        var selectedRows = cmp.get("v.selectedRows");
        var currentRow = cmp.get("v.tableBody")[currentRowIndex];
        if(!cmp.get("v.overrideDefaultBehaviour")){
        currentRow.linkDisabled = cmp.get("v.overrideLinkDisabled");
        currentRow.checked = true;
        currentRow.resolved = true;
        if (currentRow.checked) {
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
                //DE378167
                selectedRows = [];
                selectedRows.push(currentRow);
            }
        }
        tableBody[currentRowIndex] = currentRow;
        cmp.set("v.tableBody", tableBody);
        cmp.set("v.selectedRows", selectedRows);
        tableDetails.selectedRows = selectedRows;
            _autodoc.setAutodoc(cmp.get("v.autodocUniqueId"), cmp.get("v.autodocUniqueIdCmp"), tableDetails);
        }
        var compEvent = cmp.getEvent("selectedRowLink");
        compEvent.setParams({
            "selectedRows": currentRow,
            "currentRowIndex":currentRowIndex,
            "currentCellIndex": cellIndex
        });
        compEvent.fire();

    },
    
    enableLink : function (cmp, event) {
        var tableBody = cmp.get("v.tempTableBody");
        //var selectedRowData =  event.getParam("openedLinkData");
        //var closedTabId = event.getParam("closedTabId");
        var currentRowIndex = event.getParam("currentRowIndex");
        var currentRow =  tableBody[currentRowIndex];
       // currentRow.linkDisabled = false;
        tableBody[currentRowIndex] = currentRow;
        cmp.set("v.tableBody", tableBody);
    },
    
    onRowClick : function (cmp, event) {
        // US2816983 Populate Selected Provider from Provider Lookup on Create SRN Page - Sarma - 30/09/2020
        // Highlighting row on click of the Row logic
        // Single Row will be highlighted in yellow color. No muliple selection option & Autodoc checkboxes willnot be checked on row click
        if(cmp.get('v.isSingleRowHighlight') && cmp.get('v.isCreateSrnComponent')){
            var currentTr = event.currentTarget;
            let rowList = document.getElementsByClassName("highlight_dataTable");
            if(rowList.length > 0){
                for(let index = 0; index < rowList.length; index++){
                    $A.util.removeClass(rowList[index], "highlight_dataTable");
                }
            }

            $A.util.addClass(currentTr, "highlight_dataTable");

            // Sending Selected row data
            var currentRowIndex = event.currentTarget.getAttribute("data-index");
        var currentRow = cmp.get("v.tableBody")[currentRowIndex];
        var compEvent = cmp.getEvent("selectedRowData");
        compEvent.setParams({
                "selectedRows": currentRow
        });
        compEvent.fire();

        }


    },
    
    selectRow: function (cmp, event) {
        var checked = event.getSource().get("v.checked");
        var currentRowIndex = event.getSource().get("v.name");
        var tableDetails = cmp.get("v.tableDetails");
        var selectedRows = cmp.get("v.selectedRows");
        var tableBody = cmp.get("v.tableBody");
        var currentRow = tableBody[currentRowIndex];
        
        if(!cmp.get('v.isResolvedChecked')){
        	currentRow.resolved = checked;
        }
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
                //DE378167
                selectedRows = [];
                selectedRows.push(currentRow);
                
            }
        } else {
            selectedRows = selectedRows.filter(function (value, index, arr) {
                return value.uniqueKey != currentRow.uniqueKey;
            });
            
        }
        tableBody[currentRowIndex] = currentRow;
        cmp.set("v.tableBody", tableBody);
        cmp.set("v.selectedRows", selectedRows);
        tableDetails.selectedRows = selectedRows;
        var compEvent = cmp.getEvent("selectedRowData");
        compEvent.setParams({
            "selectedRows": tableDetails.selectedRows,
            "tableuniqueId":tableDetails.autodocHeaderName
        });
        compEvent.fire();
        
        //_autodoc.setAutodoc(cmp.get("v.autodocUniqueId"), tableDetails);
        _autodoc.setAutodoc(cmp.get("v.autodocUniqueId"), cmp.get("v.autodocUniqueIdCmp"), tableDetails);
        
    },
    
    checkAutodocOnRowClick: function (cmp, event) {
        var currentRowIndex = event.currentTarget.getAttribute("data-index");
        var tableDetails = cmp.get("v.tableDetails");
        var selectedRows = cmp.get("v.selectedRows");
        var tableBody = cmp.get("v.tableBody");
        var currentRow = tableBody[currentRowIndex];

        if(!currentRow.checkBoxDisabled){
            var checked = !currentRow.checked;
            currentRow.checked = checked;
            currentRow.resolved = checked;

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
                    //DE378167
                	selectedRows = [];
                    selectedRows.push(currentRow);

                }
            } else {
                selectedRows = selectedRows.filter(function (value, index, arr) {
                    return value.uniqueKey != currentRow.uniqueKey;
                });

            }
            tableBody[currentRowIndex] = currentRow;
            cmp.set("v.tableBody", tableBody);
            cmp.set("v.selectedRows", selectedRows);
            tableDetails.selectedRows = selectedRows;
            var compEvent = cmp.getEvent("selectedRowData");
            compEvent.setParams({
                "selectedRows": tableDetails.selectedRows
            });
            compEvent.fire();

            _autodoc.setAutodoc(cmp.get("v.autodocUniqueId"), cmp.get("v.autodocUniqueIdCmp"), tableDetails);
        }
    },

  	checkResolved: function (cmp, event, helper) {
        var resolved = event.getSource().get("v.checked");
        var tableDetails = cmp.get("v.tableDetails");
        var tableBody = cmp.get("v.tableBody");
		 var selectedRows = cmp.get("v.selectedRows");
        var currentRowIndex = event.getSource().get("v.name").replace('_resolved', '');
        var currentRow = tableBody[currentRowIndex];
        currentRow.checkBoxDisabled = resolved;
        currentRow.resolved = resolved;
        if (resolved) {
            currentRow.checked = resolved;
            if (!$A.util.isEmpty(selectedRows)) {
                
                var existingRecord = false;
                
                for (var i of selectedRows) {
                    if (i.uniqueKey == currentRow.uniqueKey) {
                        //US2573718: Auto Doc When No Results Are Displayed - Sravan
                        //i = currentRow;
                        var rowIndex = selectedRows.indexOf(i);
                        selectedRows[rowIndex] = currentRow;
                        existingRecord = true;
                        break;
                    }
                }
                if (!existingRecord) {
                    selectedRows.push(currentRow);
                }
            } else {
                //DE378167
                selectedRows = [];
                selectedRows.push(currentRow);
                
            }
        } else if(!resolved){
            if (!$A.util.isEmpty(selectedRows)) {
                
                var existingRecord = false;
                
                for (var i of selectedRows) {
                    if (i.uniqueKey == currentRow.uniqueKey) {
                        //US2573718: Auto Doc When No Results Are Displayed - Sravan
                        //i = currentRow;
                        var rowIndex = selectedRows.indexOf(i);
                        selectedRows[rowIndex] = currentRow;
                        existingRecord = true;
                        break;
                    }
                }
                if (!existingRecord) {
                    selectedRows.push(currentRow);
                }
            } else {
                //DE378167
                selectedRows = [];
                selectedRows.push(currentRow);
                
            }
        }else {
            selectedRows = selectedRows.filter(function (value, index, arr) {
                return value.uniqueKey != currentRow.uniqueKey;
            });            
        }
        tableBody[currentRowIndex] = currentRow;
        cmp.set("v.tableBody", tableBody);
        cmp.set("v.selectedRows", selectedRows);
        tableDetails.selectedRows = selectedRows;
        //Save Case Consolidation - US3424763
        let hasUnresolved = selectedRows.filter(row => !row.resolved);
        tableDetails.hasUnresolved = hasUnresolved.length > 0 ? true : false;
        // US3507762 - Create Overall Save Case Button on Provider Snapshot Page - Thanish - 20th May 2021
        cmp.set("v.hasUnresolvedRows", tableDetails.hasUnresolved);
        var compEvent = cmp.getEvent("selectedRowData");
        compEvent.setParams({
            "selectedRows": tableDetails.selectedRows,
            "tableuniqueId":tableDetails.autodocHeaderName
        });
        compEvent.fire();
        _autodoc.setAutodoc(cmp.get("v.autodocUniqueId"), cmp.get("v.autodocUniqueIdCmp"), tableDetails);
    },
    
    selectAll: function (cmp, event) {
        var checked = event.getSource().get("v.checked");
        var tableDetails = cmp.get("v.tableDetails");
        var tableBody = cmp.get("v.tableBody");
        var selectedRows = cmp.get("v.selectedRows");
        if($A.util.isEmpty(selectedRows)){
            selectedRows = [];
        }
        var selectedRowsUniqueKey = new Set();
        for (var i of selectedRows) {
            selectedRowsUniqueKey.add(i.uniqueKey);
        }
        if (checked) {
            if (!$A.util.isEmpty(selectedRows)) {
                for (var i of tableBody) {
                    i.checked = true;
                    if(!cmp.get('v.isResolvedChecked')){
                    	i.resolved = true;
                    }
                    if (!selectedRowsUniqueKey.has(i.uniqueKey)) {
                        selectedRows.push(i);
                    }
                }
            } else {
                for (var i of tableBody) {
                    i.checked = true;
                    if(!cmp.get('v.isResolvedChecked')){
                    	i.resolved = true;
                    }
                    selectedRows.push(i);
                }
            }
        } else {
            var unselectedRowUniqueKey = new Set();
            for (var i of tableBody) {
                i.checked = false;
                i.resolved = false;
                i.checkBoxDisabled = false;
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
        cmp.set("v.selectedRows", selectedRows);
        tableDetails.selectedRows = selectedRows;
        //cmp.set("v.tableDetails", tableDetails);
        cmp.set("v.tableBody", tableBody);
         var compEvent = cmp.getEvent("selectedRowData");
        compEvent.setParams({
            "selectedRows": tableDetails.selectedRows,
            "tableuniqueId":tableDetails.autodocHeaderName
        });
        compEvent.fire();
     
        //_autodoc.setAutodoc(cmp.get("v.autodocUniqueId"), tableDetails);
        _autodoc.setAutodoc(cmp.get("v.autodocUniqueId"), cmp.get("v.autodocUniqueIdCmp"), tableDetails);
        cmp.set("v.selectAllCheckBox", checked);
    },
    
    refreshTable: function (cmp, event) {
        var tableBody = cmp.get("v.tableBody");
        var selectedRows = cmp.get("v.selectedRows");
        if($A.util.isEmpty(selectedRows)){
            selectedRows = [];
            cmp.set("v.selectedRows",selectedRows);
        }
        var selectedRowsUniqueKey = new Set();
        for (var i of selectedRows) {
            selectedRowsUniqueKey.add(i.uniqueKey);
        }
        for (var i of tableBody) {
            if (selectedRowsUniqueKey.has(i.uniqueKey)) {
                i.checked = true;
            }
        }
        cmp.set("v.tableBody", tableBody);
        cmp.set("v.selectAllCheckBox", false);
    },
    
    //Pagination code - start
    firstPage: function (cmp, event, helper) {
        cmp.set("v.pageNumber", 1);
        // cmp.set("v.currentStartNumber", cmp.get("v.pageNumber"));
        // if (cmp.get("v.noOfRecordPerPage") > cmp.get("v.tableBody.length")) {
        //     cmp.set("v.currentEndNumber", cmp.get("v.tableBody.length"));
        // } else {
        //     cmp.set("v.currentEndNumber", cmp.get("v.noOfRecordPerPage"));
        // }
        
        var changePageEvent = cmp.getEvent("changePageEvent");
        changePageEvent.setParams({
            "requestedPageNumber": cmp.get("v.pageNumber")
        });
        changePageEvent.fire();
    },
    
    prevPage: function (cmp, event, helper) {
        cmp.set("v.pageNumber", Math.max(cmp.get("v.pageNumber") - 1, 1));
        // cmp.set("v.currentStartNumber", (cmp.get("v.currentStartNumber") - cmp.get("v.noOfRecordPerPage")));
        // cmp.set("v.currentEndNumber", (cmp.get("v.currentStartNumber") + cmp.get("v.noOfRecordPerPage")) - 1);
        
        var changePageEvent = cmp.getEvent("changePageEvent");
        changePageEvent.setParams({
            "requestedPageNumber": cmp.get("v.pageNumber")
        });
        changePageEvent.fire();
    },
    
    nextPage: function (cmp, event, helper) {
        
        cmp.set("v.pageNumber", Math.min(cmp.get("v.pageNumber") + 1, cmp.get("v.maxPageNumber")));
        // var pageNumber = cmp.get("v.pageNumber");
        // cmp.set("v.currentStartNumber", (pageNumber * cmp.get("v.noOfRecordPerPage")) + 1);
        // var endNumber = cmp.get("v.currentStartNumber");
        // cmp.set("v.currentEndNumber", (endNumber + cmp.get("v.noOfRecordPerPage")) - 1);
        
        var changePageEvent = cmp.getEvent("changePageEvent");
        changePageEvent.setParams({
            "requestedPageNumber": cmp.get("v.pageNumber")
        });
        changePageEvent.fire();
    },
    
    lastPage: function (cmp, event, helper) {
        
        cmp.set("v.pageNumber", cmp.get("v.maxPageNumber"));
        // var pageNumber = cmp.get("v.pageNumber");
        // var pageSize = cmp.get("v.noOfRecordPerPage");
        // var allData = cmp.get("v.tableBody");
        // var x = (pageNumber - 1) * pageSize;
        // cmp.set("v.currentStartNumber", x + 1);
        // cmp.set("v.currentEndNumber", allData.length);
        
        var changePageEvent = cmp.getEvent("changePageEvent");
        changePageEvent.setParams({
            "requestedPageNumber": cmp.get("v.pageNumber")
        });
        changePageEvent.fire();
    },
    
    enterPage: function (cmp, event, helper) {
        var enteredValue = event.getSource().get("v.value");
        
        if (!$A.util.isEmpty(enteredValue)) {
            if (enteredValue > cmp.get("v.maxPageNumber")) {
                event.getSource().set('v.value', cmp.get("v.maxPageNumber"));
            } else if (isNaN(enteredValue)) {
                event.getSource().set('v.value', 1);
            }
            
            var changePageEvent = cmp.getEvent("changePageEvent");
            changePageEvent.setParams({
                "requestedPageNumber": cmp.get("v.pageNumber")
            });
            changePageEvent.fire();
        } else {
            event.getSource().set('v.value', 1);
            var changePageEvent = cmp.getEvent("changePageEvent");
            changePageEvent.setParams({
                "requestedPageNumber": cmp.get("v.pageNumber")
            });
            changePageEvent.fire();
        }
    },
    
    //Pagination code - end
    sortColumn: function (cmp, event, helper) {
        var colName = event.currentTarget.getAttribute("data-colname");
        var index = event.currentTarget.getAttribute("data-index");
        //autodoc
        //var colIndex = event.currentTarget.getAttribute("data-colIndex") + 1;
        var direction = 'asc';
        cmp.set("v.selectedTabsoft", colName);
        var currentDir = cmp.get("v.arrowDirection");
        if (currentDir == 'arrowdown') {
            cmp.set("v.arrowDirection", 'arrowup');
            cmp.set("v.isAsc", true);
            direction = 'asc';
        } else {
            cmp.set("v.arrowDirection", 'arrowdown');
            cmp.set("v.isAsc", false);
            direction = 'desc';
        }
        helper.sortHelper(cmp, index, direction);
    },
    
    onLoad: function (cmp, event, helper) {
        console.log('library loaded');
    },
    
    
    
    dataLoaded: function (cmp, event, helper) {
        var tableDetails = cmp.get("v.tableDetails");
        if (tableDetails != null) {
            cmp.set("v.currentStartNumber", tableDetails.startNumber);
            cmp.set("v.tableBody", tableDetails.tableBody);
            cmp.set("v.tableBodyOriginal", tableDetails.tableBody);
            cmp.set("v.tempTableBody",tableDetails.tableBody)

            cmp.set("v.currentEndNumber", tableDetails.endNumber);
            cmp.set("v.maxPageNumber", tableDetails.noOfPages);
            
            // DE389967
            if (tableDetails.recordCount == 0) {
                cmp.set("v.maxPageNumber", 1);
            }

            cmp.set("v.headerSize", tableDetails.tableHeaders.length);
            cmp.set("v.bodySize", tableDetails.tableBody.length);

            // US2816983 Populate Selected Provider from Provider Lookup on Create SRN Page - Sarma - 30/09/2020
            // Removing Row hover color as it's conflicting with row highlight logic color
            if(cmp.get('v.isSingleRowHighlight')){
                cmp.set('v.noRowHover','slds-no-row-hover');
            }
        }
        
        helper.refreshTable(cmp, event, helper);

        // US3537364
        helper.filterLoaded(cmp);
    },
    
    search: function (cmp, event, helper) {
        var data = cmp.get("v.tableBodyOriginal");
        let inputValue;
        if(cmp.get("v.isCreateReferral") ||cmp.get("v.isClaimServiceAuth")) {
            let params = event.getParam('arguments');
            if(params) {
                inputValue = params.strInput;
            }
            cmp.set("v.isClaimServiceAuth",false);
        } else {
            inputValue = event.getSource().get('v.value').toUpperCase();
        }
        var filtered = [];
        
        data.forEach(filterRecs);
        
        function filterRecs(item, index) {
            let obj = item.rowColumnData.filter(function (el) {
                if (el.fieldValue != undefined) {
                    return el.isNoRecords || (el.fieldValue.toUpperCase().indexOf(inputValue) > -1); // DE378457 - Thanish - 22nd Oct 2020
                }
                
            });
            if (obj.length > 0) {
                filtered.push(item);
            }
        }

        // DE391662
        if(inputValue == ""){
            var tableDetails = cmp.get("v.tableDetails");
            cmp.set("v.currentStartNumber",tableDetails.startNumber);
            cmp.set("v.currentEndNumber",tableDetails.endNumber);
        }else{
            cmp.set("v.currentStartNumber",1);
            cmp.set("v.currentEndNumber",filtered.length);
        }

        cmp.set("v.tableBody", filtered);
    },
    // function automatic called by aura:waiting event  
    showSpinner: function (component, event, helper) {
        // remove slds-hide class from mySpinner
        var spinner = component.find("mySpinner");
        $A.util.removeClass(spinner, "slds-hide");
    },
    
    // function automatic called by aura:doneWaiting event 
    hideSpinner: function (component, event, helper) {
        // add slds-hide class from mySpinner     
        var spinner = component.find("mySpinner");
        $A.util.addClass(spinner, "slds-hide");
    },
    
    fixHeaders: function (component, event, helper) {
        var el = event.currentTarget;
        var scrollTop = el.scrollTop;
        const allTh = el.querySelectorAll("th");
        for (let i = 0; i < allTh.length; i++) {
            allTh[i].style.borderTop = "1px solid #dddbda";
            allTh[i].style.zIndex = "1";
        }
    },
    //US2573718 - Auto Doc When No Results Are Displayed - Sravan
    autoCheckCall : function(component, event, helper){
        if(component.get("v.allowAutoCheck")){
            helper.autoCheck(component, event, helper);
        }
    },

    // US2931847
    invokeOnclick: function (cmp, event) {
        // US2931847 - Invoke onclick from a parent
        var params = event.getParam('arguments');
        var currentRowIndex = params.currentRowIndex;
        var tableBody = cmp.get("v.tableBody");
        cmp.set("v.tempTableBody",tableBody);
        var tableDetails = cmp.get("v.tableDetails");
        var selectedRows = cmp.get("v.selectedRows");
        var currentRow = cmp.get("v.tableBody")[currentRowIndex];
        currentRow.linkDisabled = true;
        currentRow.checked = true;
        currentRow.resolved = true;
        if (currentRow.checked) {
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
                //DE378167
                selectedRows = [];
                selectedRows.push(currentRow);
    }
        }
        tableBody[currentRowIndex] = currentRow;
        cmp.set("v.tableBody", tableBody);
        cmp.set("v.selectedRows", selectedRows);
        tableDetails.selectedRows = selectedRows;
        var compEvent = cmp.getEvent("selectedRowLink");
        compEvent.setParams({
            "selectedRows": currentRow,
            "currentRowIndex":currentRowIndex
        });
        compEvent.fire();
        _autodoc.setAutodoc(cmp.get("v.autodocUniqueId"), cmp.get("v.autodocUniqueIdCmp"), tableDetails);
    },

    // US3125332 - Thanish - 7th Jan 2021
    handleAutodocRefresh : function(cmp, event, helper){
        if(cmp.get("v.enableRefreshAutodoc") && (event.getParam("autodocUniqueId") == cmp.get("v.autodocUniqueId"))){
            helper.refreshAutodoc(cmp);
        }
    },

    // US3786086 - Thanish - 20th Aug 2021
    checkHeaderOverflow: function(cmp, event, helper){
        var el = document.getElementById(event.currentTarget.getAttribute("data-thId"));
        var curOverflow = el.style.overflow;

        if ( !curOverflow || curOverflow === "visible" ){
            el.style.overflow = "hidden";
        }
        if(el.clientWidth < el.scrollWidth || el.clientHeight < el.scrollHeight){
            el.title = event.currentTarget.getAttribute("data-thTitle");
        }
        el.style.overflow = curOverflow;
    }

});