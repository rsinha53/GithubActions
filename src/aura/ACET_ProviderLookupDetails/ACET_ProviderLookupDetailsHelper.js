({
    getProviderData: function (cmp) {
        var errMessage = 'Unexpected Error Occurred with Provider Lookup Details. Please try again. If problem persists please contact the help desk.';
        var contactDetails = _setandgetvalues.getContactValue(cmp.get("v.contactUniqueId"));
        cmp.set("v.contactDetails",contactDetails);
        this.getIPAValue(cmp);

        // US3691213
        var contactWrapper = cmp.get("v.contactDetails");
        contactWrapper.caseItemsExtId = cmp.get("v.resultsTableRowData").caseItemsExtId;
        contactWrapper.isProviderLookup = true;

        var action = cmp.get("c.getProviderData");
        action.setParams({
            providerId: cmp.get("v.providerDetails.providerId"),
            taxId: cmp.get("v.providerDetails.taxId"),
            adrseq: cmp.get("v.providerDetails.addressSequence"),
            providerType: cmp.get("v.providerDetails.isPhysician") ? "Physician" : "Facility",
            contactWrapper: contactWrapper
        });
        //should be sending from snap
        var provDetails = cmp.get("v.providerDetails");
        if(cmp.get("v.isClaim")){
        }else{
        var autodocUniqueId = provDetails.taxId;
        cmp.set("v.autodocUniqueIdCmp", provDetails.addressSequence);
            }
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var pDetails = response.getReturnValue();
                cmp.set("v.additionalDataData", pDetails.additionalDetails);
                cmp.set("v.credData", pDetails.credDetails);
                cmp.set("v.specialityDetails", pDetails.specialityDetails);
                cmp.set("v.providerData", pDetails.physicianDetails);

                if(pDetails.statusCode != 200){
                    this.showToastMessage("We Hit a Snag.", errMessage, "error", "dismissible", "30000");
                }

                //Bharat Start
                var claimNo = cmp.get("v.claimNo");
                var maxAutoDocComponents = cmp.get("v.maxAutoDocComponents");
                var currentIndexOfOpenedTabs = cmp.get("v.currentIndexOfOpenedTabs");
                                console.log("currentIndexOfOpenedTabs"+cmp.get("v.currentIndexOfOpenedTabs"));

               if(cmp.get("v.isClaim")){
                var providerData=cmp.get("v.providerData");
                var specialityDetails=cmp.get("v.specialityDetails");
                var credData=cmp.get("v.credData");
				var additionalDataData=cmp.get("v.additionalDataData");
                providerData.autodocHeaderName=providerData.componentName;
                providerData.componentName=providerData.componentName+": "+claimNo;
                specialityDetails.componentName=specialityDetails.componentName+": "+claimNo;
                  specialityDetails.autodocHeaderName=specialityDetails.autodocHeaderName+": "+claimNo;
				additionalDataData.componentName=additionalDataData.componentName+": "+claimNo;
                   if(!$A.util.isEmpty(credData)){
                       credData.componentName=credData.componentName+": "+claimNo;
                       credData.autodocHeaderName=credData.autodocHeaderName+": "+claimNo;
                       credData.componentOrder=20.03+(maxAutoDocComponents*currentIndexOfOpenedTabs);
                       console.log("currentIndexOfOpenedTabs of credData"+credData.componentOrder);

                   }
                   providerData.componentOrder=20.01+(maxAutoDocComponents*currentIndexOfOpenedTabs);
                        console.log("currentIndexOfOpenedTabs of ProviderData"+providerData.componentOrder);

                   specialityDetails.componentOrder=20.02+(maxAutoDocComponents*currentIndexOfOpenedTabs);
                        console.log("currentIndexOfOpenedTabs of specialityDetails"+specialityDetails.componentOrder);

                 //  credData.componentOrder=20.03+(maxAutoDocComponents*currentIndexOfOpenedTabs);
                   additionalDataData.componentOrder=20.05+(maxAutoDocComponents*currentIndexOfOpenedTabs);
                       console.log("currentIndexOfOpenedTabs of additionalDataData"+additionalDataData.componentOrder);

                }
                //Bharat End
                var childComponent = cmp.find("providerDetails");
                childComponent.autodocByDefault();
            } else if (state === "INCOMPLETE") {
                this.showToastMessage("We Hit a Snag.", errMessage, "error", "dismissible", "30000");
            } else if (state === "ERROR") {
                this.showToastMessage("We Hit a Snag.", errMessage, "error", "dismissible", "30000");
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
            this.hideLookupSpinner(cmp);
        });
        $A.enqueueAction(action);
    },
    
    getIPAValue : function(cmp){
        let filterParameters = cmp.get("v.filterParameters");
        var getIPA = cmp.get('c.getIPAValue');
        getIPA.setParams({
            "strInput": filterParameters.selectedIPAValue
        });
        getIPA.setCallback(this, function (response) {
            let state = response.getState();
            if (state === "SUCCESS") {
                cmp.set("v.memberIPAValue", response.getReturnValue());
            }
        });
        $A.enqueueAction(getIPA);
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
                            "c__interactionID": component.get('v.contactUniqueId'),
                            "c__contactUniqueId": component.get('v.contactUniqueId'),
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
    }
})