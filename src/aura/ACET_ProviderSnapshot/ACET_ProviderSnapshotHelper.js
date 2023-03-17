({
    getProviderData: function (cmp) {
        var contactDetails = _setandgetvalues.getContactValue(cmp.get("v.contactUniqueId"));
        cmp.set("v.contactDetails", contactDetails);
        console.log(contactDetails);
        var action = cmp.get("c.getProviderData");
        action.setParams({
            providerId: cmp.get("v.providerId"),
            taxId: cmp.get("v.taxId"),
            adrseq: cmp.get("v.addrSequence"),
            providerType: cmp.get("v.isPhysician") ? "Physician" : "Facility",
            contactWrapper: cmp.get("v.contactDetails")
        });

        var errMessage = 'Unexpected Error Occurred on the Provider Results. Please try again. If problem persists please contact the help desk.';
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var pDetails = response.getReturnValue();
                if (pDetails != null && pDetails.physicianDetails != null && pDetails.physicianDetails.cardData.length > 0) {
                    pDetails.physicianDetails.cardData[0].disableCheckbox = true;
                    pDetails.physicianDetails.cardData[1].disableCheckbox = true;
                }
                cmp.set("v.additionalData", pDetails.additionalDetails);
                cmp.set("v.credData", pDetails.credDetails);
                cmp.set("v.specialityDetails", pDetails.specialityDetails);
                cmp.set("v.providerData", pDetails.physicianDetails);

                if(pDetails.statusCode != 200){
                    this.showToastMessage("We Hit a Snag.", errMessage, "error", "dismissible", "30000");
                }

                //US2812137 - case history card
                var appEvent = $A.get("e.c:SAE_CaseHistoryEvent");
                    appEvent.setParams({
                        "xRefId" : "",
                        "memberID": cmp.get("v.taxId"),
                        "memberTabId": cmp.get('v.taxId'),
                        "flowType": 'Provider'
                    });

                    appEvent.fire();
            } else if (state === "INCOMPLETE") {
                this.showToastMessage("We Hit a Snag.", errMessage, "error", "dismissible", "30000");
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
                this.showToastMessage("We Hit a Snag.", errMessage, "error", "dismissible", "30000");
            }
            this.hideLookupSpinner(cmp);
            // Thanish - optimizing contract summary - 4th Nov 2020
            cmp.set("v.contractApiParameters", { "taxId" : cmp.get("v.taxId"), "providerId" : cmp.get("v.providerId"), "addressId" : cmp.get("v.addressId"), "addressSeq" : cmp.get("v.addrSequence")});
        });
        $A.enqueueAction(action);
    },

    showLookupSpinner: function (cmp) {
        var spinner = cmp.find("lookup-spinner");
        $A.util.removeClass(spinner, "slds-hide");
        $A.util.addClass(spinner, "slds-show");
    },

    hideLookupSpinner: function (cmp) {
        var spinner = cmp.find("lookup-spinner");
        $A.util.removeClass(spinner, "slds-show");
        $A.util.addClass(spinner, "slds-hide");
    },

    getProviderData_x: function (component, event, helper) {
        var action = component.get("c.getProviderData");
        action.setParams({
            providerId: component.get("v.providerId"),
            taxId: component.get("v.taxId"),
            adrseq: component.get("v.addrSequence")
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                // US1918689 - Thanish - 13th Nov 2019
                var pDetails = response.getReturnValue();
                if (pDetails.StatusCode == 200) {
                    if (pDetails.ProviderCardDetails.Address != null && pDetails.ProviderCardDetails.Address != undefined) {
                        var pAddress = pDetails.ProviderCardDetails.Address.split("<br/>");
                        pDetails.ProviderCardDetails.Address = pAddress;
                    }

                    //US2435572
                    if (pDetails.Credentials != null && pDetails.Credentials != undefined && pDetails.Credentials.length > 0) {
                        var degreeList = '';
                        for (let index = 0; index < pDetails.Credentials.length; index++) {
                            degreeList = degreeList + pDetails.Credentials[index].Qualification;
                        }
                        component.set("v.credentialList", degreeList);
                    }

                    component.set("v.ProviderDetails", pDetails);

                    var appEvent = $A.get("e.c:SAE_CaseHistoryEvent");
                    appEvent.setParams({
                        "xRefId": "",
                        "memberID": component.get("v.taxId"),
                        "memberTabId": component.get('v.taxId'),
                        "flowType": 'Provider'
                    });

                    appEvent.fire();
                } else {
                    this.showToastMessage("Error!", pDetails.StatusMessage, "error", "dismissible", "10000");
                }
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

    showToastMessage: function (title, message, type, mode, duration) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "We hit a snag.",
            "message": message,
            "type": type,
            "mode": mode,
            "duration": duration
        });
        toastEvent.fire();
    },

    //US2465288 - Avish
    getMemberCaseHistory: function (cmp, taxID) {
        var action = cmp.get("c.getRelatedCasesHistory");
        action.setParams({
            "taxMemberID": taxID,
            "xRefIdIndividual": '',
            "toggleOnOff": false,
            "flowType": 'Provider'
        });

        action.setCallback(this, function (response) {
            debugger;
            var state = response.getState();
            if (state == 'SUCCESS') {
                debugger;
                var result = response.getReturnValue();
                cmp.set("v.caseHistoryList", result);
                var appEvent = $A.get("e.c:SAE_CaseHistoryEvent");
                appEvent.setParams({
                    "caseHistoryList": cmp.get("v.caseHistoryList"),
                    "memberTabId": taxID
                });
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

    getEnclosingTabIdHelper: function (cmp, event) {
        var workspaceAPI = cmp.find("workspace");
        workspaceAPI.getEnclosingTabId().then(function (tabId) {
            cmp.set("v.callTopicTabId", tabId);
        }).catch(function (error) {
            console.log(error);
        });
    },

    navigateToCallTopicEvent: function(component, event, helper,callTopicName) {
        //var selectedPillId = event.getParam("callTopicName");
        //component.set("v.callTopicName",selectedPillId);
        //var callTopicName = selectedPillId;
        if (!$A.util.isUndefinedOrNull(callTopicName) && callTopicName == "Provider Lookup") {
            component.find("providerLookupPrvdSnapshot").getElement().scrollIntoView({
                behavior: 'smooth',
                block: 'start',
                inline: 'nearest'
            });
        }
        component.set("v.callTopicName","");
    }
})