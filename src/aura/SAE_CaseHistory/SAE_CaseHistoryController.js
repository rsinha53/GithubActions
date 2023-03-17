({
    init :function(component,event,helper){
        // US2041480 - Thanish 31st March 2020
        component.set("v.cmpUniqueId", new Date().getTime());
    },
	showCaseSpinner: function(component,event,helper){
        debugger;
        if(event.getParam("isSpinner")){
            helper.showCaseSpinner(component);
            if(event.getParam("snapShot") == 'snapShot'){
                component.set("v.isToggleOnOff",false);
            } 
        }else{
            helper.hideCaseSpinner(component);
            if(event.getParam("snapShot") == 'snapShot'){
                component.set("v.isToggleOnOff",false);
            } 
        }
	},
	handleMouseOut : function(component,event,helper){
		component.set("v.togglehover",false);	
	},

    onPrev: function(component, event, helper) {
        var table = $('#' + component.get("v.dataTblId")).DataTable();
        table.page('previous').draw('page');
	},
	
    onNext: function(component, event, helper) {
        var table = $('#' + component.get("v.dataTblId")).DataTable();
        table.page('next').draw('page');
	},
	
    onFirst: function(component, event, helper) {
        var table = $('#' + component.get("v.dataTblId")).DataTable();
        table.page('first').draw('page');
	},
	
    onLast: function(component, event, helper) {
        var table = $('#' + component.get("v.dataTblId")).DataTable();
        table.page('last').draw('page');
	},
	
    processMe: function(component, event, helper) {
        var selectdpage = parseInt(event.target.name) - 1;
        var table = $('#' + component.get("v.dataTblId")).DataTable();
        table.page(selectdpage).draw('page');
	},
	
	showResults: function(component, event, helper) {
        if(component.get("v.memberTabId") == event.getParam("memberTabId")){
        var caseHistoryList = event.getParam("caseHistoryList");
        component.set("v.caseHistoryList", caseHistoryList);
        if (caseHistoryList == '' || caseHistoryList == null || caseHistoryList == undefined) {
            if(component.get("v.IsInitializedTable")){
                var dataTblId = ('#' + component.get('v.dataTblId'));
                if ($.fn.DataTable.isDataTable(dataTblId)){
                    $(dataTblId).DataTable().destroy();
                }
                component.set("v.caseHistory", []);
            }
            return null;
        }
        component.set("v.xRefId",event.getParam("xRefId"));
        helper.showResults(component, helper);
        }
	},
    
    showResultsToggle: function(component, event, helper) {
        if(component.get("v.memberTabId") == event.getParam("memberTabId")){
        var caseHistoryList = event.getParam("caseHistoryList");
        component.set("v.caseHistoryList", caseHistoryList);
        if (caseHistoryList == '' || caseHistoryList == null || caseHistoryList == undefined) {
            if(component.get("v.IsInitializedTable")){
                var dataTblId = ('#' + component.get('v.dataTblId'));
                if ($.fn.DataTable.isDataTable(dataTblId)){
                    $(dataTblId).DataTable().destroy();
                }
                component.set("v.caseHistory", []);
            }
            return null;
        }
        helper.showResults(component, helper);
        }
    },
	
    openCaseDetail: function (component, event, helper) {
        debugger;
        var caseId = event.currentTarget.getAttribute("data-caseId");
        console.log(caseId);
        
        var workspaceAPI = component.find("workspace");
        workspaceAPI.openSubtab({
            pageReference: {
                type: 'standard__recordPage',
                attributes: {
                    actionName: 'view',
                    objectApiName: 'Case',
                    recordId : caseId  
                },
            },
            focus: true
        }).then(function(response) {
            workspaceAPI.getTabInfo({
                tabId: response
                
            }).then(function(tabInfo) {
                /*workspaceAPI.setTabLabel({
                        tabId: tabInfo.tabId,
                        label: 'Detail-'+lastName
                    });
                    workspaceAPI.setTabIcon({
                        tabId: tabInfo.tabId,
                        icon: "standard:people",
                        iconAlt: "Member"
                    });*/
                });
            }).catch(function(error) {
                console.log(error);
            });
    },
	
	openServiceRequestDetail: function (cmp, event, helper) {
        // US2041480 - Thanish 31st March 2020
        let clickedLink = event.currentTarget;
        let caseId = clickedLink.getAttribute("data-caseId");
        $A.util.addClass(clickedLink, "disabledLink");
        
        var workspaceAPI = cmp.find("workspace");
        workspaceAPI.getEnclosingTabId().then(function (enclosingTabId) {
                workspaceAPI.openSubtab({
                    parentTabId: enclosingTabId,
                    pageReference: {
                        "type": "standard__component",
                        "attributes": {
                            "componentName": "c__ACET_ServiceRequestDetail"
                        },
                        "state": {
                            // US2041480 - Thanish 31st March 2020
                            "c__caseId": caseId,
                            "c__parentUniqueId": cmp.get("v.cmpUniqueId")
                        }
                    },
                    focus: true
                }).then(function (subtabId) {
                    // US2041480 - Thanish 31st March 2020
                    $A.util.addClass(clickedLink, subtabId);

                    workspaceAPI.setTabLabel({
                        tabId: subtabId,
                        label: caseId
                    });
                    workspaceAPI.setTabIcon({
                        tabId: subtabId,
                        icon: "action:record",
                        iconAlt: "Service Request Detail"
                    });
                }).catch(function (error) {
                    console.log(error);
                });
            });
    },

    // US2041480 - Thanish 31st March 2020
    handleSRITabClosed : function (cmp, event, helper) {
        if(event.getParam("parentUniqueId") == cmp.get("v.cmpUniqueId")) {
            let elementList = document.getElementsByClassName(event.getParam("closedTabId"));
            if(elementList.length > 0) {
                $A.util.removeClass(elementList[0], "disabledLink");
                $A.util.removeClass(elementList[0], event.getParam("closedTabId"));
            }
        }
    }
})