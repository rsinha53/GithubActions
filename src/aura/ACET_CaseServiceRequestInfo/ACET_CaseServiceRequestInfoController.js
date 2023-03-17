({
	doInit : function(cmp, event, helper) {
        // US2041480 - Thanish 31st March 2020
        cmp.set("v.cmpUniqueId", new Date().getTime());
        helper.setData(cmp);
	},

	onRefresh : function(cmp, event, helper) {
        helper.setData(cmp);
	},

    enableORSIdLink : function(cmp,event,helper){
        // US2041480 - Thanish 31st March 2020
        if(event.getParam("parentUniqueId") == cmp.get("v.cmpUniqueId")) {
            let elementList = document.getElementsByClassName(event.getParam("orsId"));
            if(elementList.length > 0) {
                $A.util.removeClass(elementList[0], "disableLink");
                $A.util.removeClass(elementList[0], event.getParam("closedTabId"));

                let openedTabs = cmp.get("v.openedTabs");
                if(openedTabs.length > 0) {
                    let index;
                    for(index = 0; index < openedTabs.length; index++) {
                        if(openedTabs[index] == event.getParam("orsId")) {
                            openedTabs.splice(index, 1);
                            cmp.set("v.openedTabs", openedTabs);
                            break;
                        }
                    }
                }
            }
        }
    },

	columnOptionsChange: function(cmp) {
        var selectedColumn = cmp.get('v.selectedColumn');
        var selectedOption = cmp.get('v.selectedOption');
        var columnOptions = cmp.get('v.columnOptions');
        columnOptions[selectedColumn] = selectedOption;
        cmp.set('v.columnOptions', columnOptions);
    },
    
    openServiceRequestDetail: function (cmp, event) {
        var orsId = event.currentTarget.getAttribute("data-orsId");
        var facetResponse = event.currentTarget.getAttribute("data-facetResp");
        let boolIsFacetsData = false;
        if(facetResponse && typeof JSON.parse(facetResponse) == 'object') {
			boolIsFacetsData = true;
        }
        console.log('==facetResponse 1 is'+facetResponse);
        // US2041480 - Thanish 31st March 2020
        $A.util.addClass(event.currentTarget, orsId);
        $A.util.addClass(event.currentTarget, "disableLink");
        let openedTabs = cmp.get("v.openedTabs");
        openedTabs.push(orsId);
        cmp.set("v.openedTabs", openedTabs);

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
                        "c__caseId": orsId,
                        // US2041480 - Thanish 31st March 2020
                        "c__parentUniqueId": cmp.get("v.cmpUniqueId"),
                        "c__sfCaseId" :  cmp.get("v.recordId"),
                        "c__isFacetsDataPresent": boolIsFacetsData,
                        "c__facetsResponse": (boolIsFacetsData ? encodeURIComponent(facetResponse) : null),
                        "c__createdBy" : event.currentTarget.getAttribute("data-createdBy"),
                        "c__recordId": cmp.get("v.recordId"),//US3145625 - Sravan
                        "c__idType" : event.currentTarget.getAttribute("data-idType")
                        }
                    },
                    focus: true
                }).then(function (subtabId) {
                    workspaceAPI.setTabLabel({
                        tabId: subtabId,
                        label: orsId
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
    }
})