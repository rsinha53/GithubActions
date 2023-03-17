({
    showECAASpinner: function (component) {
        var spinner = component.find("ecaaspinner");
        $A.util.removeClass(spinner, "slds-hide");
        $A.util.addClass(spinner, "slds-show");
    },
    hideECAASpinner: function (component) {
        var spinner = component.find("ecaaspinner");
        $A.util.removeClass(spinner, "slds-show");
        $A.util.addClass(spinner, "slds-hide");
    },
	initEccaTable: function(cmp, helper) {
 
        if(cmp.get("v.eccaObj").length){
            if (!cmp.get("v.IsInitializedTable")) {
                cmp.set('v.dataTblId', 'AuthEccaTbl' + new Date().getTime());
            }  
        }

        if(!$A.util.isEmpty(cmp.get('v.dataTblId'))){
            var dataTblId = ('#' + cmp.get('v.dataTblId'));
            if ($.fn.DataTable.isDataTable(dataTblId)) {
                $(dataTblId).DataTable().destroy();
            }
        }

        if(!$A.util.isEmpty(dataTblId)){
            setTimeout(function() {
                $(dataTblId).DataTable({
                    "oLanguage": {
                        "sEmptyTable": "No records found."
                    },
                    "sPaginationType": "full_numbers",
                    "bRetrieve": true,
                    "aLengthMenu": [
                        [10, 25, 50, 100, 200, -1],
                        [10, 25, 50, 100, 200, "All"]
                    ],
                    "iDisplayLength": 7,
                    "destroy": true,
                    "order": [
                        [1, "desc"]
                    ],
                    "dom": '<"toolbar">frtip',
                    initComplete: function() {
                        $(dataTblId + '_filter').remove();
                    },
                    "bPaging": false,
                    "bInfo": false,
                    "bPaginate": false,
                    "pageLength": 7
                });
            }, 1000);
        }
        cmp.set("v.IsInitializedTable", true);

    },

    // US2445831
    fireToastMessage: function (title, message, type, mode, duration) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": title,
            "message": message,
            "type": type,
            "mode": mode,
            "duration": duration
        });
        toastEvent.fire();
    },
    
    getFocusedTabIdHelper: function (component,event) {
        var workspaceAPI = component.find("workspace");
        workspaceAPI.getTabInfo().then(function(response) {
            var focusedTabId = response.tabId;
            component.set("v.currentTabId", focusedTabId);
        })
        .catch(function(error) {
            console.log(error);
        });
    },
    
    closeSubTabs: function (cmp, event, helper,closedTabId) {
        
        if (closedTabId == cmp.get("v.currentTabId")) {
            
            var appEvent = $A.get("e.c:ACET_ECAATabClosed");
            appEvent.setParams({
                "srn": cmp.get('v.SRN'),
                "docIDToClose" : cmp.get("v.docIdLst")
            });
            appEvent.fire();
        }
    }

})