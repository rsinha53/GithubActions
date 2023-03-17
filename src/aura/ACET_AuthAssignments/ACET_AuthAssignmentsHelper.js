({
	cmpList:[],

    addCmpToList: function (cmp) {
        this.cmpList.push(cmp);
    },

    updateCmpTableDetails: function(tableDetails, srn){
        var cmp;
        for(cmp of this.cmpList){
            if(cmp.get("v.SRN") == srn){
                cmp.set("v.tableDetails", tableDetails);
            }
        }
	},

	sortHelper : function(cmp, index, searchDir, tableDetails) {
		var data = tableDetails.tableBody;

        function compareValues(index, order = 'asc'){
            return function innerSort(a, b) {
                let first = a.rowColumnData[index].fieldValue;
                let second = b.rowColumnData[index].fieldValue;
                const varA = (typeof first === 'string')
                ? first.toUpperCase() : first;
                const varB = (typeof second === 'string')
                ? second.toUpperCase() : second;

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

        data.sort(compareValues(index,searchDir));

		tableDetails.tableBody = data;
        this.updateCmpTableDetails(tableDetails, cmp.get("v.SRN"));
    },

    //US2061071 - Format Date
    convertMilitaryDate: function (dateParam, type) {
        let format = "";
        if (type == 'dt') {
            format = 'MM/dd/yyyy';
        } else if (type == 'dttm') {
            format = 'MM/dd/yyyy hh:mm:ss a';
        }
        let returnDate = '';
        if (!$A.util.isUndefinedOrNull(dateParam)) {
            try {
                returnDate = $A.localizationService.formatDate(dateParam, format);
            } catch (error) { }
        }
        return returnDate;
    },

    setTableData: function(cmp){
		var autodocCmp = _autodoc.getAutodocComponent(cmp.get("v.autodocUniqueId"), cmp.get("v.autodocUniqueIdCmp"), 'Authorization Assignments: ' + cmp.get("v.SRN"));

		if(!$A.util.isEmpty(autodocCmp)){
			cmp.set("v.originalTableBody", autodocCmp.originalTableBody);
            cmp.set("v.tableDetails", autodocCmp);
        } else{
			var authDetailsObj = cmp.get("v.authDetailsObj");
			var tableDetails = new Object();
            var currentIndexOfOpenedTabs = cmp.get("v.currentIndexOfOpenedTabs");
            var maxAutoDocComponents = cmp.get("v.maxAutoDocComponents");
            var claimNo=cmp.get("v.claimNo");
            var currentIndexOfAuthOpenedTabs=cmp.get("v.currentIndexOfAuthOpenedTabs");
            var maxAutoDocAuthComponents=cmp.get("v.maxAutoDocAuthComponents");
			tableDetails.type = "table";
             if(cmp.get("v.isClaimDetail")){
                 tableDetails.autodocHeaderName = ('Authorization Assignments: ' + cmp.get("v.SRN")+": "+claimNo);
			tableDetails.componentOrder =16.02 +(maxAutoDocAuthComponents*currentIndexOfAuthOpenedTabs)+(maxAutoDocComponents*currentIndexOfOpenedTabs);
                // US3653575
                // tableDetails.componentName = ('Authorization Assignments: ' + cmp.get("v.SRN") + ": " + claimNo);
            } else {
			tableDetails.autodocHeaderName = ('Authorization Assignments: ' + cmp.get("v.SRN"));
			tableDetails.componentOrder = 5.5;
                // US3653575
                // tableDetails.componentName = ('Authorization Assignments: ' + cmp.get("v.SRN"));
            }
            // US3653575
            tableDetails.componentName = cmp.get('v.isMainComponent') ? 'Authorization Assignments' : 'Authorization Detail Assignments';
			tableDetails.showComponentName = false;
			tableDetails.tableHeaders = [ "WORK QUEUE", "ASSIGN DATE/TIME", "DESCRIPTOR/TEXT", "ASSIGNMENT TYPE", "PRIORITY","STATUS","ASSIGNED BY", "DUE DATE" ];
			tableDetails.selectAll = false;
			// table search
			tableDetails.searchValue = "";
			// table sort
			tableDetails.selectedTabsoft = "";
			tableDetails.arrowDirection = "";
			tableDetails.isAsc;

			tableDetails.selectedRows = [];
			tableDetails.tableBody = [];
            var assignObj; var i = 0;
            if(!$A.util.isEmpty(authDetailsObj.assignments) && !$A.util.isUndefinedOrNull(authDetailsObj.assignments) )
            {
                if(authDetailsObj.assignments.length > 0){

                    for(assignObj of authDetailsObj.assignments){
                        let descriptor = "--";
                        let assignmentType = "--";
                        let priority = "--";
                        let status = "--";

                        if(!$A.util.isEmpty(assignObj.assignmentDescriptor) && !$A.util.isEmpty(assignObj.assignmentDescriptor.description)){
                            descriptor = assignObj.assignmentDescriptor.description;
                        }
                        if(!$A.util.isEmpty(assignObj.assignmentType) && !$A.util.isEmpty(assignObj.assignmentType.description)){
                            assignmentType = assignObj.assignmentType.description;
                        }
                        if(!$A.util.isEmpty(assignObj.assignmentPriority) && !$A.util.isEmpty(assignObj.assignmentPriority.description)){
                            priority = assignObj.assignmentPriority.description;
                        }
                        if(!$A.util.isEmpty(assignObj.assignmentStatus) && !$A.util.isEmpty(assignObj.assignmentStatus.description)){
                            status = assignObj.assignmentStatus.description;
                        }

                        // US3157932
                        var rowColumnData = [];
                        rowColumnData.push(setRowColumnData('outputText', assignObj.assignedTo, i));
                        rowColumnData.push(setRowColumnData('outputText', assignObj.assignmentDateAndTimeFormated, i));
                        rowColumnData.push(setRowColumnData('outputText', descriptor, i));
                        rowColumnData.push(setRowColumnData('outputText', assignmentType, i));
                        rowColumnData.push(setRowColumnData('outputText', priority, i));
                        rowColumnData.push(setRowColumnData('outputText', status, i));
                        rowColumnData.push(setRowColumnData('outputText', assignObj.assignedBy, i));
                        rowColumnData.push(setRowColumnData('outputText', assignObj.assignmentDueDateFormated, i));

                        var row = {
                            "checked" : false,
                            "uniqueKey" : i,
                            "rowColumnData": rowColumnData // US3157932
                        }

                        // US3653575
                        row.caseItemsExtId = cmp.get("v.isClaimDetail") ? claimNo : cmp.get("v.SRN");

                        tableDetails.tableBody.push(row);
                        i++;
                    }

                    // US3157932
                    function setRowColumnData(ft, fv, uk) {
                        var rowColumnData = new Object();
                        rowColumnData.fieldType = ft;
                        rowColumnData.key = uk;
                        if (!$A.util.isUndefinedOrNull(fv) && !$A.util.isEmpty(fv) && fv.length > 0) {
                            if (fv.length > 20) {
                                rowColumnData.fieldValue = fv.substring(0, 20) + '...';
                                rowColumnData.titleName = fv;
                            } else {
                                rowColumnData.fieldValue = fv;
                                rowColumnData.titleName = '';
                            }
                        } else {
                            rowColumnData.fieldValue = '--';
                            rowColumnData.titleName = '';
                        }
                        rowColumnData.isReportable = true;
                        if ('link' == ft) {
                            rowColumnData.isLink = true;
                        } else if ('outputText' == ft) {
                            rowColumnData.isOutputText = true;
                        } else if ('isStatusIcon' == ft) {
                            rowColumnData.isIcon = true;
                        } else {
                            rowColumnData.isOutputText = true;
                        }
                        return rowColumnData;
                    }

                }
            }

			if(i == 0){
				var row = {
					"checked" : false,
					"uniqueKey" : i,
					"rowColumnData" : [
						{
							"isNoRecords" : true,
							"fieldLabel" : "No Records",
							"fieldValue" : "No Records Found",
							"key" : i
                    }]
						}
                // US3653575
                row.caseItemsExtId = cmp.get("v.isClaimDetail") ? claimNo : cmp.get("v.SRN");
                row.isReportable = true;
				tableDetails.tableBody.push(row);
			}
			tableDetails.originalTableBody = tableDetails.tableBody;
			cmp.set("v.originalTableBody", tableDetails.tableBody);
			cmp.set("v.tableDetails", tableDetails);
		}
    },

    // US3125332 - Thanish - 7th Jan 2021
    refreshAutodoc : function(cmp) {
        var tableDetails = cmp.get("v.tableDetails");
        var tableBody = tableDetails.tableBody;
        for(var row of tableBody){
            row.checked = false;
            row.resolved = false;
            row.checkBoxDisabled = false;
    }
        tableDetails.selectAll = false;
        tableDetails.selectedRows = [];
        tableDetails.tableBody = tableBody;
        cmp.set("v.originalTableBody", tableBody);
        cmp.set("v.tableDetails", tableDetails);
        _autodoc.setAutodoc(cmp.get("v.autodocUniqueId"), cmp.get("v.autodocUniqueIdCmp"), tableDetails);
    }

})