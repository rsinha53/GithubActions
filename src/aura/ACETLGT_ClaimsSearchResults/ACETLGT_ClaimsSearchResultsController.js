({
	openClaimDetail : function(component, event, helper) {
		var dataset = event.target.dataset;
		var workspaceAPI = component.find("workspace");
		workspaceAPI.getEnclosingTabId().then(function (enclosingTabId) {
            workspaceAPI.openSubtab({
                parentTabId: enclosingTabId,
                pageReference: {
                    "type": "standard__component",
                    "attributes": {
                        "componentName": "c__ACETLGT_ClaimDetail"
                    },
                    "state": {
                        "c__claimID" : dataset.claimId,
						"c__claimType": dataset.claimType,
						"c__cirrClaimID": dataset.cirrClaimId,
						"c__phi": dataset.phi,
						"c__taxID": dataset.taxId,
						"c__provider": dataset.provider,
						"c__network": dataset.network,
						"c__dosStart": dataset.dosStart,
						"c__dosEnd": dataset.dosEnd,
						"c__charged": dataset.charged,
						"c__paid": dataset.paid,
						"c__deductible": dataset.deductible,
						"c__patientResp": dataset.patientResp,
						"c__statusDate": dataset.statusDate,
						"c__status": dataset.status,
						"c__eventType": dataset.eventType,
						"c__primaryDX": dataset.primaryDx
                    }
                }
            }).then(function(response) {
                workspaceAPI.getTabInfo({
                    tabId: response
                }).then(function(tabInfo) {
                    workspaceAPI.setTabLabel({
                        tabId: tabInfo.tabId,
                        label: "Claim - " + dataset.claimId
                    });
                    workspaceAPI.setTabIcon({
                        tabId: tabInfo.tabId,
                        icon: "standard:people",
                        iconAlt: "Member"
                    });
                });
            }).catch(function(error) {
                console.log(error);
            });
        });
   	alert('claim type: ' + dataset.claimid + '||'+ dataset.claimtype);
	}	
})