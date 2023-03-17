({
	getClaimIssues : function(cmp){
		cmp.set("v.showSpinner", true);
		var action = cmp.get("c.getClaimIssues");
        action.setParams({
            "claimNumber": cmp.get("v.claimNumber"),
            "taxId": cmp.get("v.taxId"),
            "issueId": ""
        });
        action.setCallback(this, function (response){
            let state = response.getState();
            if(state === "SUCCESS") {
				var result = response.getReturnValue();
				if(!$A.util.isEmpty(result)){
					cmp.set("v.externalIdInfo", result);
				}
				cmp.set("v.showSpinner", false);
			} else{

				cmp.set("v.showSpinner", false);
			}
		});
        $A.enqueueAction(action);
	},
    
    openClaimDetail: function(cmp, event, orsId, issueType) {
        var index = event.currentTarget.getAttribute("data-index");
        var workspaceAPI = cmp.find("workspace");
        workspaceAPI.getEnclosingTabId().then(function (enclosingTabId) {
            workspaceAPI.openSubtab({
                parentTabId: enclosingTabId,
                pageReference: {
                    "type": "standard__component",
                    "attributes": {
                        "componentName": "c__ACET_ClaimServiceRequestDetail"
                    },
                    "state": {
                        "c__issueId": orsId,
                        "c__issueType": issueType,
                        "c__taxId": cmp.get("v.taxId"),
                        "c__parentUniqueId": cmp.get("v.cmpUniqueId"),
                        "c__recordId": ""
                    }
                },
                focus: true
            }).then(function (subtabId) {
                var externalIdInfo = cmp.get("v.externalIdInfo");
                externalIdInfo[index].tabId = subtabId;
                externalIdInfo[index].class = "disableLink";
                cmp.set("v.externalIdInfo", externalIdInfo);
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
    },
    
    openORSDetail: function(cmp, event, orsId, issueType) {
        var index = event.currentTarget.getAttribute("data-index");
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
                        "c__parentUniqueId": cmp.get("v.cmpUniqueId"),
                        "c__sfCaseId": "",
                        "c__isFacetsDataPresent": false,
                        "c__facetsResponse": null,
                        "c__recordId": "",
                        "c__idType": issueType
                    }
                },
                focus: true
            }).then(function (subtabId) {
                var externalIdInfo = cmp.get("v.externalIdInfo");
                externalIdInfo[index].tabId = subtabId;
                externalIdInfo[index].class = "disableLink";
                cmp.set("v.externalIdInfo", externalIdInfo);
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
    },

    // US3177995 - Thanish - 22nd Jun 2021
    getPurgedORSRecords: function(cmp){
        cmp.set("v.showSpinner", true);
        var action = cmp.get("c.getPurgedORSRecords");
        action.setParams({
            "searchId": cmp.get("v.memberEEID")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state=='SUCCESS') {
                var result = response.getReturnValue();
                var externalIdInfo = cmp.get("v.externalIdInfo");
                var concatData = externalIdInfo.concat(result.response);

                cmp.set("v.externalIdInfo", concatData);
                cmp.set("v.purgedORSLoaded", true); // US3667124 - Thanish - 6th Jul 2021
            } else if(state=='ERROR') {
            }
            cmp.set("v.showSpinner", false);
        });
        $A.enqueueAction(action);
    },

    // US3667124 - Thanish - 6th Jul 2021
    filterPurgedORSRecords: function(cmp, hide){
        cmp.set("v.showSpinner", true);
        var externalIdInfo = cmp.get("v.externalIdInfo");
        for(var info of externalIdInfo){
            if(info.IdType == 'Purged ORS'){
                info.hideRow = hide;
            } else {
                info.hideRow = false;
            }
        }
        cmp.set("v.externalIdInfo", externalIdInfo);
        cmp.set("v.showSpinner", false);
    },

    openPurgedDetails: function(cmp, event, objectId, orsId){
        var workspaceAPI = cmp.find("workspace");
        var index = event.currentTarget.getAttribute("data-index"); // US3667124 - Thanish - 6th Jul 2021

        workspaceAPI.getEnclosingTabId().then(function (enclosingTabId) {
            workspaceAPI.openSubtab({
                parentTabId: enclosingTabId,
                pageReference: {
                    "type": "standard__component",
                    "attributes": {
                        "componentName": "c__ACET_PurgedDocument"
                    },
                    "state": {
                        "c__objectId": objectId,
                        "c__parentUniqueId": cmp.get("v.cmpUniqueId") // US3667124 - Thanish - 6th Jul 2021
                    }
                },
                focus: true
            }).then(function (subtabId) {
                // US3667124 - Thanish - 6th Jul 2021
                var externalIdInfo = cmp.get("v.externalIdInfo");
                externalIdInfo[index].tabId = subtabId;
                externalIdInfo[index].class = "disableLink";
                cmp.set("v.externalIdInfo", externalIdInfo);

                workspaceAPI.setTabLabel({
                    tabId: subtabId,
                    label: orsId
                });
                workspaceAPI.setTabIcon({
                    tabId: subtabId,
                    icon: "action:record",
                    iconAlt: "Purged ORS Detail"
                });
            }).catch(function (error) {
                console.log(error);
            });
        });
    }
})