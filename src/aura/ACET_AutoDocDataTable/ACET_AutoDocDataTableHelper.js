({
    refreshTable: function (cmp, event, helper) {
        var tableBody = cmp.get("v.tableBody");
        var selectedRows = cmp.get("v.selectedRows");
        var selectedRowsUniqueKey = new Set();
        if(!$A.util.isUndefinedOrNull(selectedRows) && !$A.util.isEmpty(selectedRows)){
        for (var i of selectedRows) {
            selectedRowsUniqueKey.add(i.uniqueKey);
        }
        }
        for (var i of tableBody) {
            if (selectedRowsUniqueKey.has(i.uniqueKey)) {
                i.checked = true;
            }
        }
        cmp.set("v.tableBody", tableBody);
        cmp.set("v.selectAllCheckBox", false);
        //US2573718 - Auto Doc When No Results Are Displayed - Sravan
        if(cmp.get("v.autoCheck")){
            if(!cmp.get("v.allowAutoCheck")){
                helper.autoCheck(cmp, event, helper);
            }
        }
        //  US2969157  - View Authorization Enhancements for new auto doc framework
        // Default Sorting logic
        if(cmp.get("v.isDefaultSorting")){
            let direction = cmp.get("v.defaultSortingDirection");
            if(direction == 'asc'){
                cmp.set("v.arrowDirection", 'arrowup');
                cmp.set("v.isAsc", true);
            } else if (direction = 'desc'){
                cmp.set("v.arrowDirection", 'arrowdown');
                cmp.set("v.isAsc", false);
            }
            cmp.set("v.selectedTabsoft", cmp.get("v.defaultSortingColName"));
            this.sortHelper(cmp, cmp.get("v.defaultSortingColIndex"), cmp.get("v.defaultSortingDirection"));
        }

    },
    
   sortHelper : function(cmp, index, searchDir) {
        var data = cmp.get("v.tableBody");
        
        function compareValues(index, order = 'asc'){
            return function innerSort(a, b) {
                let first = a.rowColumnData[index].fieldValue;
                let second = b.rowColumnData[index].fieldValue;
                var varA = '';
                var varB = '';

                if (cmp.get("v.dateFields").includes(index)) {
                    varA = new Date(first);
                    varB = new Date(second);
                } else if (cmp.get("v.dateRangeFields").includes(index)) {
                    var date_A = first.split('-');
                    varA = new Date(date_A[0].trim());
                    var date_B = second.split('-');
                    varB = new Date(date_B[0].trim());
                //US3562758 Tech Story: AutoDoc framework update for sorting (amount with decimal)
                } if (cmp.get("v.currencySort").includes(index)) {
                    varA = new Number(first);
                    varB = new Number(second);
                } else {
                    varA = (typeof first === 'string') ? first.toUpperCase() : first;
                    varB = (typeof second === 'string') ? second.toUpperCase() : second;
                }
                
                let comparison = 0;
                if (varA > varB) {
                    comparison = 1;
                } else if (varA < varB) {
                    comparison = -1;
                }
                return (
                    (order === 'desc') ? (comparison * -1) : comparison
                );
            };            
        }  
        
        //US3562758 Tech Story: AutoDoc framework update for sorting - Date sorting with year
       if (cmp.get("v.dateFieldWithYear").includes(index)) {
        var reverse = searchDir == 'asc' ? 1: -1;
        let parser = (v) => v;
        parser = (v) => (v && new Date(v));
        data = data.sort((a,b) => {
            let a1 = parser(a.rowColumnData[index].fieldValue), b1 = parser(b.rowColumnData[index].fieldValue);
            let r1 = a1 < b1, r2 = a1 === b1;
            return r2? 0: r1? -reverse: reverse;
        });
        }else{
        data.sort(compareValues(index,searchDir));
        }
        
        cmp.set("v.tableBody",data);
    },

    //US2573718 - Auto Doc When No Results Are Displayed - Sravan
    autoCheck : function(cmp, event, helper){
        cmp.set("v.selectAllCheckBox",true);
        cmp.set("v.checked",true);
        var tableBody = cmp.get("v.tableBody");

        var selectedRows = cmp.get("v.selectedRows");
        var tableDetails = cmp.get("v.tableDetails");
        var selectedRowsUniqueKey = new Set();
        var autoSelected = [];

        if(!$A.util.isUndefinedOrNull(tableDetails) && !$A.util.isEmpty(tableDetails)){
        if(!$A.util.isUndefinedOrNull(tableBody) && !$A.util.isEmpty(tableBody)){
             if(!$A.util.isUndefinedOrNull(selectedRows) && !$A.util.isEmpty(selectedRows)){
                 for (var i of selectedRows) {
                    selectedRowsUniqueKey.add(i.uniqueKey);
                  }
                 for(var i of tableBody){
                     i.checked = true;
                     i.resolved = true;
                     if (!selectedRowsUniqueKey.has(i.uniqueKey)) {
                         selectedRows.push(i);
                     }
                 }
             }
             else{
                 for (var i of tableBody) {
                     i.checked = true;
                     i.resolved = true;
                     autoSelected.push(i);
                 }
             }

        }
        if(!$A.util.isUndefinedOrNull(selectedRows) && !$A.util.isEmpty(selectedRows)){
            cmp.set("v.selectedRows", selectedRows);
            tableDetails.selectedRows = selectedRows;
        }
        else{
            cmp.set("v.selectedRows", autoSelected);
            tableDetails.selectedRows = autoSelected;
        }
         cmp.set("v.tableBody", tableBody);
         var compEvent = cmp.getEvent("selectedRowData");
          compEvent.setParams({
             "selectedRows": tableDetails.selectedRows
         });
          compEvent.fire();
          _autodoc.setAutodoc(cmp.get("v.autodocUniqueId"), cmp.get("v.autodocUniqueIdCmp"), tableDetails);
        }
    },

    // US3125332 - Thanish - 7th Jan 2021
    refreshAutodoc : function(cmp) {
        var tableDetails = cmp.get("v.tableDetails");
        if(!$A.util.isEmpty(tableDetails)){
            var tableBody = cmp.get("v.tableBody");
            for(var row of tableBody){
                row.checked = false;
                row.resolved = false;
                row.checkBoxDisabled = false;
                row.linkDisabled = false;
            }
            tableDetails.selectedRows = [];
            cmp.set("v.selectedRows", []);
            cmp.set("v.tableBody", tableBody);
            // Save Case Consolidation - US3424763
            tableDetails.hasUnresolved = false;
            _autodoc.setAutodoc(cmp.get("v.autodocUniqueId"), cmp.get("v.autodocUniqueIdCmp"), tableDetails);
            cmp.set("v.selectAllCheckBox", false);
            // DE477689
            cmp.set("v.hasUnresolvedRows", false);
        }
    },

    // US3537364
    filterLoaded: function (cmp) {
        var filterPhrase = cmp.get("v.defaultSearchVal");
        if (filterPhrase != null && filterPhrase != '') {
            var data = cmp.get("v.tableBodyOriginal");
            var filtered = [];
            data.forEach(filterRecs);
            function filterRecs(item, index) {
                let obj = item.rowColumnData.filter(function (el) {
                    if (el.fieldValue != undefined) {
                        return el.isNoRecords || (el.fieldValue.toUpperCase().indexOf(filterPhrase.toUpperCase()) > -1); // DE378457 - Thanish - 22nd Oct 2020
                    }
                });
                if (obj.length > 0) {
                    filtered.push(item);
                }
            }

            cmp.set("v.currentStartNumber", 1);
            cmp.set("v.currentEndNumber", filtered.length);
            cmp.set("v.tableBody", filtered);
        }
    }

})