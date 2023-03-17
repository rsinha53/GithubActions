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
		var autodocCmp = _autodoc.getAutodocComponent(cmp.get("v.autodocUniqueId"), cmp.get("v.autodocUniqueIdCmp"), 'Authorization Notes: ' + cmp.get("v.SRN"));

		if(!$A.util.isEmpty(autodocCmp)){
			// DE378121 - Thanish - 22nd Oct 2020
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
			tableDetails.autodocHeaderName = ('Authorization Notes: ' + cmp.get("v.SRN")+": "+claimNo);
			tableDetails.componentOrder = 16.09 +(maxAutoDocComponents*currentIndexOfOpenedTabs)+(maxAutoDocAuthComponents*currentIndexOfAuthOpenedTabs);
			tableDetails.componentName = ('Authorization Notes: ' + cmp.get("v.SRN")+": "+claimNo);
            }
            else{
			tableDetails.autodocHeaderName = ('Authorization Notes: ' + cmp.get("v.SRN"));
			tableDetails.componentOrder = 12;
			tableDetails.componentName = ('Authorization Notes: ' + cmp.get("v.SRN"));
            }
			// US3653575
            tableDetails.componentName = cmp.get('v.isMainComponent') ? 'Authorization Notes' : 'Authorization Detail Notes';
			tableDetails.showComponentName = false;
			tableDetails.tableHeaders = [ "CREATED DATE", "CREATED BY", "DEPARTMENT", "SUBJECT TYPE", "NOTE DETAILS" ];
			tableDetails.selectAll = false;
			// table search
			tableDetails.searchValue = "";
			// table sort
			tableDetails.selectedTabsoft = "";
			tableDetails.arrowDirection = "";
			tableDetails.isAsc;

			tableDetails.selectedRows = [];
			tableDetails.tableBody = [];
			var notes; var i = 0;
			for(notes of authDetailsObj.notes){
				let noteDetails = "--";
				let subjectType = "--";

				if(!$A.util.isEmpty(notes.text)){
                    noteDetails = notes.text;
				}
				if(!$A.util.isEmpty(notes.categoryCode) && !$A.util.isEmpty(notes.categoryCode.description)){
                    subjectType = notes.categoryCode.description;
                }

				// US3157932
				var rowColumnData = [];
				rowColumnData.push(setRowColumnData('outputText', notes.createDateTimeFormated, i));
				rowColumnData.push(setRowColumnData('outputText', notes.createdByUserId, i));
				rowColumnData.push(setRowColumnData('outputText', notes.department, i));
				rowColumnData.push(setRowColumnData('outputText', subjectType, i));
				rowColumnData.push(setRowColumnData('outputText', noteDetails, i));

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

			if(i == 0){
				var row = {
					"checked" : false,
					"uniqueKey" : i,
					"rowColumnData" : [
						{
							"isNoRecords" : true,
							"fieldLabel" : "No Records",
							"fieldValue" : "No Records Found",
						"key": i,
                        "isReportable": true // US3653575
					}]
						}
				// US3653575
				row.caseItemsExtId = cmp.get("v.isClaimDetail") ? claimNo : cmp.get("v.SRN");
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