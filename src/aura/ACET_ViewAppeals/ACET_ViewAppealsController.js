({
    doInit : function(cmp, event, helper) {
        var error = {};
        error.message = "We hit a snag.";
        error.topDescription = "Search criteria must include";
        error.descriptionList = ["Tax ID and Appeal Number", "Tax ID and Submission Date Range(max range is 30 days)", "Tax ID and Claim Number"];
        cmp.set("v.error", error);
        // Removing !$A.util.isEmpty(cmp.get("v.taxId")) for the member only flow 
        if(!$A.util.isEmpty(cmp.get("v.memberId"))){
            cmp.set("v.showAppealResults", true);
            if(cmp.get("v.sourceCode") == "AP"){
                helper.getCNSAppealTable(cmp);
            } else{
                helper.getENIMNRAppealTable(cmp);
            }
        }
    },
    
    onFromChange : function(cmp, event, helper) {
        var fromDate = cmp.get("v.fromDate");
        if(cmp.find("fromDate").checkValidity() && !$A.util.isEmpty(fromDate)){
            cmp.set("v.toMinDate", fromDate);
            
            var fromDateArr = fromDate.split("-");
            var to = new Date(fromDateArr[0], parseInt(fromDateArr[1]), fromDateArr[2]);
            to.setDate(to.getDate() + 30);
            cmp.set("v.toMaxDate", to.getFullYear() + "-" + to.getMonth() + "-" + to.getDate());
            
        } else{
            cmp.set("v.toDate", "");
            cmp.set("v.toMinDate", "");
            cmp.set("v.toMaxDate", "");
            cmp.find("toDate").reportValidity();
        }
    },
    
    onToChange : function(cmp, event, helper) {
        if(!cmp.find("fromDate").checkValidity() || $A.util.isEmpty(cmp.get("v.fromDate"))){
            cmp.set("v.toDate", "");
        }
    },
    
    onSearch : function(cmp, event, helper) {
        if($A.util.isEmpty(cmp.get("v.taxId")) || !cmp.find("taxId").checkValidity()){
            cmp.find("taxId").reportValidity();
            cmp.set("v.showSearchError", true);
            var errorcmp = cmp.find("errorPopup");
            setTimeout(function () {
                errorcmp.showPopup();
            }, 100);
            
        } else if($A.util.isEmpty(cmp.get("v.appealNum")) && $A.util.isEmpty(cmp.get("v.claimNum")) && $A.util.isEmpty(cmp.get("v.fromDate")) && $A.util.isEmpty(cmp.get("v.toDate"))){		
            cmp.set("v.showSearchError", true);
            var errorcmp = cmp.find("errorPopup");
            setTimeout(function () {
                errorcmp.showPopup();
            }, 100);
            
        } else if(!cmp.find("appealNum").checkValidity() || !cmp.find("claimNum").checkValidity() || !cmp.find("fromDate").checkValidity() || !cmp.find("toDate").checkValidity()){
            cmp.find("appealNum").reportValidity();
            cmp.find("claimNum").reportValidity();
            cmp.find("fromDate").reportValidity();
            cmp.find("toDate").reportValidity();
            cmp.set("v.showSearchError", true);
            var errorcmp = cmp.find("errorPopup");
            setTimeout(function () {
                errorcmp.showPopup();
            }, 100);
            
        } else{
            // All validations complete
            cmp.set("v.showSearchError", false);
            cmp.set("v.showAppealResults", true);
            if(cmp.get("v.sourceCode") == "AP"){
                helper.getCNSAppealTable(cmp);
            } else{
                helper.getENIMNRAppealTable(cmp);
            }
        }
    },
    
    onClear : function(cmp, event, helper) {
        cmp.set("v.taxId", "");
        cmp.set("v.appealNum", "");
        cmp.set("v.claimNum", "");
        cmp.set("v.fromDate", "");
        cmp.set("v.toDate", "");
    },
    
    onPolicyChange : function(cmp, event, helper) {
        cmp.set("v.showAppealResults", false);
        cmp.set("v.showComments", false);
        cmp.set('v.hasUnresolved', false);

        // Removing !$A.util.isEmpty(cmp.get("v.taxId")) for the member only flow 
        if(!$A.util.isEmpty(cmp.get("v.memberId"))){
            cmp.set("v.showAppealResults", true);
            if(cmp.get("v.sourceCode") == "AP"){
                helper.getCNSAppealTable(cmp);
            } else{
                helper.getENIMNRAppealTable(cmp);
            }
        }
        // To reset the buttons based on the autodoc
        // this.handleRowSelect(cmp, event, helper);
    },
    
    togglePopup : function(cmp, event) {
        let showPopup = event.currentTarget.getAttribute("data-popupId");
        cmp.find(showPopup).toggleVisibility();
    },
    
    handleKeyup : function(cmp) {
        var inputCmp = cmp.find("commentsBoxId");
        var value = inputCmp.get("v.value");
        var errorMessage = 'Error!  You have reached the maximum character limit.  Add additional comments in Case Details as a new case comment.';
        if (value.length >= 2000) {
            inputCmp.setCustomValidity(errorMessage);
            inputCmp.reportValidity();
        } else {
            inputCmp.setCustomValidity('');
            inputCmp.reportValidity();
        }
    },
    
    onAddComments : function(cmp) {
        cmp.set("v.showComments", true);
    },
    
    onPreviewAutodoc : function (cmp, event) {
        var selectedString = _autodoc.getAutodoc(cmp.get("v.autodocUniqueId"));
        cmp.set("v.tableDetails_prev", selectedString);
        cmp.set("v.showPreviewAutodoc", true);
    },
    
    onRouteCase : function(cmp) {
        var selectedString = _autodoc.getAutodoc(cmp.get("v.autodocUniqueId"));
        var jsString = JSON.stringify(selectedString);
        var caseWrapper = cmp.get("v.caseWrapper");
        
        caseWrapper.savedAutodoc = jsString;
        cmp.set("v.caseWrapper", caseWrapper);
        cmp.set("v.showRouteCase", true);
    },
    
    navigateToAppealDetail: function(cmp, event) {
        var selectedRowdata = event.getParam("selectedRows");
        var cellIndex = event.getParam("currentCellIndex");
        var rowIndex = event.getParam("currentRowIndex");
        var appealName = selectedRowdata.rowColumnData[cellIndex].fieldValue;
        var taxId = selectedRowdata.rowColumnData[2].fieldValue;
        console.log('selectedRowdata'+JSON.stringify(selectedRowdata));
        
        var workspaceAPI = cmp.find("workspace");
        workspaceAPI.getEnclosingTabId().then(function (enclosingTabId) {
            workspaceAPI.openSubtab({
                parentTabId: enclosingTabId,
                pageReference: {
                    "type": "standard__component",
                    "attributes": {
                        "componentName": "c__ACET_AppealDetail"
                    },
                    "state": {
                        "c__autodocUniqueId": cmp.get("v.autodocUniqueId"),
                        "c__autodocUniqueIdCmp": cmp.get("v.policySelectedIndex"),
                        "c__appealName": appealName,
                        "c__taxId": taxId,
                        "c__currentRowData": selectedRowdata
                    }
                },
                focus: true
            }).then(function (subtabId) {
                workspaceAPI.setTabLabel({
                    tabId: subtabId,
                    label: appealName
                });
                workspaceAPI.setTabIcon({
                    tabId: subtabId,
                    icon: "standard:bundle_policy",
                    iconAlt: "Appeal Detail"
                });
            }).catch(function (error) {
                console.log(error);
            });
        });
    },

    handleRowSelect: function(component, event, helper){

        var data = component.get('v.selectedRows');
        var hasUnresolved = component.get('v.hasUnresolved');
        var sourceCode = component.get('v.sourceCode');

        if(!$A.util.isUndefinedOrNull(data) && !$A.util.isEmpty(data)){
            let checkedrows = data.filter(row => row.checked);
            if(checkedrows.length >0){
                helper.setDefaultAutodoc(component);
            }else{
                _autodoc.deleteAutodoc(component.get("v.autodocUniqueId"), component.get("v.policySelectedIndex"));
            }
        }else{
            _autodoc.deleteAutodoc(component.get("v.autodocUniqueId"), component.get("v.policySelectedIndex"));
        }

        if(sourceCode != 'AP'){
            return;
        }

        if(!$A.util.isUndefinedOrNull(data) && !$A.util.isEmpty(data)){
            let unresolvedRows = data.filter(row => row.checked && !row.resolved);
            // console.log("@@@ ACET_ViewAppealsController.handleRowSelect: row: "+ JSON.stringify(data));
            // console.log("@@@ ACET_ViewAppealsController.handleRowSelect: unresolvedRows: "+ JSON.stringify(unresolvedRows));
            component.set('v.hasUnresolved', (unresolvedRows.length > 0 ? true : false));
        }else{
            component.set('v.hasUnresolved', false);
            component.set('v.showComments', false);
            component.set('v.commentsValue', '');
        }

    },
    
    enableRowLink: function(cmp, event) {
        var openedLinkData = event.getParam("openedLinkData");
        //var closedTabId = event.getParam("closedTabId");
        var tableDetails = cmp.get("v.appealTableDetails");
        var tableRows = tableDetails.tableBody;
        tableRows.forEach(element => {
            if (element.uniqueKey == openedLinkData.uniqueKey) {
                element.linkDisabled = false;
            }
        });
        
        tableDetails.tableBody = tableRows;
        cmp.set("v.appealTableDetails",tableDetails);
    }
})