({
	getProviderData: function (component, event, helper) {
		var action = component.get("c.getProviderData");
        action.setParams({ 
            providerId : component.get("v.providerId"),
            taxId : component.get("v.taxId"),
            adrseq : component.get("v.addrSequence")
        });
		action.setCallback(this, function (response) {
			var state = response.getState();
			if (state === "SUCCESS") {
				console.log(JSON.stringify(response.getReturnValue()));

				// US1918689 - Thanish - 13th Nov 2019
				var pDetails = response.getReturnValue();
				if(pDetails.ProviderCardDetails.Address != null && pDetails.ProviderCardDetails.Address != undefined){
                    var pAddress = pDetails.ProviderCardDetails.Address.split("<br/>");
                    pDetails.ProviderCardDetails.Address = pAddress;
                }
                component.set("v.ProviderDetails", pDetails);
                //this.getMemberCaseHistory(component,component.get("v.taxId"));
				var appEvent = $A.get("e.c:SAE_CaseHistoryEvent");
				appEvent.setParams({
					"xRefId" : "",
					"memberID": component.get("v.taxId"),
					"memberTabId": component.get('v.taxId'),
					"flowType": 'Provider'
				});
					
				appEvent.fire();
				// End of Code - US1918689 - Thanish - 13th Nov 2019

				// US1934400 - Thanish - 8th Nov 2019 - Provider Autodoc
				/*setTimeout(function () {
                        var tabKey = component.get("v.AutodocKey");
                        window.lgtAutodoc.initAutodoc(tabKey);
                    }, 1);*/

			} else if (state === "INCOMPLETE") {
				// do something
			} else if (state === "ERROR") {
				var errors = response.getError();
				if (errors) {
					if (errors[0] && errors[0].message) {
						console.log("Error message: " +
							errors[0].message);
					}
				} else {
					console.log("Unknown error");
				}
			}
		});
		$A.enqueueAction(action);
	},
    
    openMisDirect: function (component, event, helper) {
        /**/
        var workspaceAPI = component.find("workspace");
        workspaceAPI.getEnclosingTabId().then(function (enclosingTabId) {
            if (enclosingTabId == false) {
                workspaceAPI.openTab({
                    pageReference: {
                        "type": "standard__component",
                        "attributes": {
                            "componentName": "c__SAE_MisdirectComponent" // c__<comp Name>
                        },
                        "state": {}
                    },
                    focus: true
                }).then(function (response) {
                    workspaceAPI.getTabInfo({
                        tabId: response
                    }).then(function (tabInfo) {
                        console.log("The recordId for this tab is: " + tabInfo.recordId);
                        var focusedTabId = tabInfo.tabId;
                        workspaceAPI.setTabLabel({
                            tabId: focusedTabId,
                            label: "Misdirect"
                        });
                        // US1831550 Thanish (Date: 5th July 2019) start {
                        workspaceAPI.setTabIcon({
                            tabId: focusedTabId,
                            icon: "standard:decision",
                            iconAlt: "Misdirect"
                        });
                        // } US1831550 Thanish end
                    });
                }).catch(function (error) {
                    console.log(error);
                });
            } else {
                workspaceAPI.openSubtab({
                    parentTabId: enclosingTabId,
                    pageReference: {
                        "type": "standard__component",
                        "attributes": {
                            "componentName": "c__SAE_MisdirectComponent" // c__<comp Name>
                        },
                        "state": {
                            "c__originatorName": component.get('v.originatorName'),
                            "c__originatorType": component.get('v.originatorType'),
                            "c__contactName": component.get('v.contactName'),
                            "c__subjectName": component.get('v.subjectName'),
                            "c__subjectType": component.get('v.subjectType'),
                            "c__subjectDOB": component.get('v.subjectDOB'),
                            "c__subjectID": component.get('v.subjectID'),
                            "c__subjectGrpID": component.get('v.subjectGrpID'),
                            "c__interactionID": component.get('v.interactionId'),
                            "c__contactUniqueId": component.get('v.interactionId'),
                            "c__focusedTabId": enclosingTabId
                        }
                    }
                }).then(function (subtabId) {

                    workspaceAPI.setTabLabel({
                        tabId: subtabId,
                        label: "Misdirect" //set label you want to set
                    });
                    // US1831550 Thanish (Date: 5th July 2019) start {
                    workspaceAPI.setTabIcon({
                        tabId: subtabId,
                        icon: "standard:decision",
                        iconAlt: "Misdirect"
                    });
                    // } US1831550 Thanish end
                }).catch(function (error) {
                    console.log(error);
                });
            }

        });
    },

	//US2465288 - Avish
	getMemberCaseHistory: function (cmp,taxID){
        var action = cmp.get("c.getRelatedCasesHistory");
        
        action.setParams({
            "taxMemberID": taxID,
            "xRefIdIndividual": '',
            "toggleOnOff": false,
            "flowType": 'Provider'
        });
        
        action.setCallback(this, function(response){
            debugger;
            var state = response.getState();
            if (state == 'SUCCESS') {
                debugger;
                var result = response.getReturnValue();
                cmp.set("v.caseHistoryList", result);
                var appEvent = $A.get("e.c:SAE_CaseHistoryEvent");
                appEvent.setParams({"caseHistoryList" : cmp.get("v.caseHistoryList"),
                                    "memberTabId": taxID});
                appEvent.fire();
                
            } else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " +
                                    errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
    },
})