({  
   addSearchedMember: function (cmp, event) {
        // Fix - DE246060 - Ravindra - 17-07-2019
        debugger;
        if(!cmp.get('v.isOtherSearch')){
            if (event.getParam("clearMemberSearchArray")) {
                var memberSearches = cmp.get("v.memberSearches");
                console.log(JSON.parse(JSON.stringify(memberSearches)));
                for (var i = 0; i < memberSearches.length; i++) {
                    if(memberSearches[i] != undefined){     //DE302199 - Avish
                        var alreadySearchedMemberArray = memberSearches[i].split(";");
                        if (event.getParam("providerUniqueId") == alreadySearchedMemberArray[0]) {
                            memberSearches = memberSearches.splice(i, 1);
                            cmp.set("v.memberSearches", ''); //Added  by Avish on 09/27/2019 as a part of defect
                        }/* Added  by Avish on 09/27/2019 as a part of defect */ 
                        else { 
                            memberSearches = memberSearches.splice(i, 1); 
                            cmp.set("v.memberSearches", memberSearches); 
                        } /* Defects ends  */
                    }
                }
                
                /**** Code added by Avish on 07/25/2019 ***/
                cmp.set("v.subjectCard", '');
                cmp.set("v.interactionCard", null);
                cmp.set("v.checkFlagmeberCard",false);
                cmp.set("v.mnfDetailsLst", '');
                /** code ends here ***/
            } else {
                var memberSearches = cmp.get("v.memberSearches");
                memberSearches.push(event.getParam("searchedMember"));
                cmp.set("v.memberSearches", memberSearches);
            }
        }
    },

    handleChange: function (cmp, event) {
        var selectedOptionValue = event.getParam("value");
    },
    
    setProviderDetails: function (cmp, event, helper) {
        cmp.set("v.providerValidated", event.getParam("providerValidated"));
        cmp.set("v.providerDetails", event.getParam("providerDetails"));
        cmp.set("v.isProviderSearchDisabled", event.getParam("isProviderSearchDisabled"));
        cmp.set("v.providerSelected", event.getParam("providerSelected"));
    },
    
    chooseCallOPtions:function (cmp, event) {
        var selectedCallVal = event.getParam("value");
        cmp.set("v.interactionType",selectedCallVal);        
    },
  
    navigateToInteraction: function (cmp, event, helper) {
		if (cmp.get("v.providerSelected") || cmp.get("v.providerNotFound") || cmp.get("v.isProviderSearchDisabled") || cmp.get("v.isOtherSearch")) {
        }else{
            helper.fireToastMessage("Error!", "Complete provider search.", "error", "dismissible", "10000");
            return;  
        }
		
        //US2132239 : Member Only - No Provider to Search
        let memUniqueId = '';
        let setSearchedMemUniqueIds;
        let toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "Information!",
            "message": "Member was already searched.",
            "type": "warning"
        });

        // US2060237	Other Card Validation - Snapshot - Other (Third Party) - 10/10/2019 - Sarma - Start
        // Replacing code from previous sprint, as other search with Member Standalone search was failing
        if (!cmp.get("v.isOtherSearch")) {
            helper.getProviderDetails(cmp);
            if (!cmp.get("v.providerValidated")) {
                return;
            }
        }

        // US2060237 - End
        //DE260181
        helper.getMemberDetails(cmp);
        if (!cmp.get("v.memberValidated")) {
            return;
        }

        var flowType = cmp.get("v.flowType");

        //US2132239 : Member Only - No Provider to Search (START)
        if (!cmp.get('v.isOtherSearch') && !$A.util.isUndefinedOrNull(cmp.get("v.memUniqueId")) && !$A.util.isUndefinedOrNull(cmp.get("v.findIndividualFlag")) && cmp.get("v.findIndividualFlag") && flowType == 'Member') {
            if(!cmp.get("v.noMemberToSearch")){ //// DE289290 - Avish 
                memUniqueId = cmp.get("v.memUniqueId");

                if(memUniqueId != null && memUniqueId != undefined){
                    var memUniqueIdlst = memUniqueId.split(';');
                    let memberSearches = cmp.get("v.memberSearches");
                    
                    //--------------------------- DE289241 : START -------------------------------------
                    var dob = '';
                    if (!$A.util.isUndefinedOrNull(memUniqueIdlst) && memUniqueIdlst.length == 3) {
                        dob = helper.formatDateMMDDYYYY(cmp, memUniqueIdlst[2].split('/'));
                    } else if (!$A.util.isUndefinedOrNull(memUniqueIdlst) && memUniqueIdlst.length == 4) {
                        dob = helper.formatDateMMDDYYYY(cmp, memUniqueIdlst[3].split('/'));
                    }
                    //--------------------------- DE289241 : END ---------------------------------------
                    
                    memUniqueId = memUniqueIdlst[0] + ';' + memUniqueIdlst[1] + ';' + memUniqueIdlst[2] + ';' + dob;
                }

                let selectedMemberDetails = cmp.get("v.selectedMemberDetails");

                if (!$A.util.isUndefinedOrNull(memberSearches)) {
                    let memberSearchesold = [];
                    for (var i = 0; i < memberSearches.length; i++) {
                        if (!$A.util.isEmpty(memberSearches[i])) {
                            var alreadySearchedMemberArray = memberSearches[i].split(";");
                            var dob = helper.formatDateMMDDYYYY(cmp, alreadySearchedMemberArray[3].split('/'));
                            memberSearchesold.push(alreadySearchedMemberArray[0] + ';' + alreadySearchedMemberArray[1] + ';' + alreadySearchedMemberArray[2] + ';' + dob);
                        }
                    }
                    setSearchedMemUniqueIds = new Set(memberSearchesold);
                    if (setSearchedMemUniqueIds.has(memUniqueId)) {
                        toastEvent.fire();
                        helper.hideMemberSpinner(cmp);
                        var workspaceAPI = cmp.find("workspace");
                        workspaceAPI.getAllTabInfo().then(function (response) {
                            let isProviderSearchDisabled = cmp.get("v.providerSearchFlag");
                            let isProviderNotFound = cmp.get("v.providerNotFound");
                            if (!$A.util.isEmpty(response)) {
                                for (var i = 0; i < response.length; i++) {
                                    if (!isProviderSearchDisabled && !isProviderNotFound) {
                                        if (response[i].pageReference.state.c__providerUniqueId == selectedMemberDetails.interactionCard.taxIdOrNPI) {
                                            workspaceAPI.openTab({
                                                url: response[i].url
                                            }).then(function (response) {
                                                workspaceAPI.focusTab({
                                                    tabId: response
                                                });

                                            }).catch(function (error) {
                                                console.log(error);
                                            });
                                        }
                                    } else if (!isProviderSearchDisabled && isProviderNotFound) {
                                        if (response[i].pageReference.state.c__providerUniqueId == selectedMemberDetails.interactionCard.taxIdOrNPI) {
                                            workspaceAPI.openTab({
                                                url: response[i].url
                                            }).then(function (response) {
                                                workspaceAPI.focusTab({
                                                    tabId: response
                                                });

                                            }).catch(function (error) {
                                                console.log(error);
                                            });
                                        }
                                    } else if (isProviderSearchDisabled && !isProviderNotFound) {
                                        if (isProviderSearchDisabled && response[i].pageReference.state.c__HouseholdUniqueId == selectedMemberDetails.memberID) {
                                            workspaceAPI.openTab({
                                                url: response[i].url
                                            }).then(function (response) {
                                                workspaceAPI.focusTab({
                                                    tabId: response
                                                });

                                            }).catch(function (error) {
                                                console.log(error);
                                            });
                                        }
                                    }
                                }
                            }
                        })
                    } else {
                        helper.showMemberSpinner(cmp);
                        helper.findIndividualSearch(cmp, event, helper);
                    }
                } else { // DE289290 - Avish 
                    helper.showMemberSpinner(cmp);
                    helper.findIndividualSearch(cmp, event, helper);
                }
            }else{ // DE289290 - Avish 
                var selectedProvdDetails = cmp.get("v.selectedPrvdDetails");
                
                var providerType = "";
                var providerLName = "";
                
                if (!$A.util.isEmpty(selectedProvdDetails)) {
                    if (selectedProvdDetails.providerType == 'O') {
                        providerType = "Facility";
                    } else if (selectedProvdDetails.providerType == 'P') {
                        providerType = "Physician";
                    } else {
                        providerType = "";
                    }
                    providerLName = selectedProvdDetails.lastName;
                }
                //DE264357
                if (selectedProvdDetails == null) {
                    selectedProvdDetails = cmp.get("v.providerDetails");
                }
                
                // End of Code - US2039716 - Thanish - 17th Sept 2019
                //rr
                var matchingTabs = [];
                var workspaceAPI = cmp.find("workspace");
                var providerDetails = cmp.get("v.providerDetails");
                workspaceAPI.getAllTabInfo().then(function (response) {
                    if (!$A.util.isEmpty(response)) {
                        for (var i = 0; i < response.length; i++) {
                            if (response[i].pageReference.state.c__providerUniqueId == providerDetails.taxIdOrNPI) {
                                matchingTabs.push(response[i]);
                            }
                        }
                    }
                    if (matchingTabs.length === 0) {
                        //close tab after refreshing tab or logout session
                        var interactionOverviewStatus = _setAndGetInteractionOverviewStatus.setValue(true);
                        workspaceAPI.openTab({
                            pageReference: {
                                "type": "standard__component",
                                "attributes": {
                                    "componentName": "c__SAE_InteractionOverview"
                                },
                                "state": {
                                    "c__tabOpened": true,
                                    "c__providerDetails": cmp.get("v.noMemberToSearch") ? selectedProvdDetails : cmp.get("v.providerDetails"), // US2039716 - Thanish - 17th Sept 2019
                                    "c__isProviderSearchDisabled": cmp.get("v.isProviderSearchDisabled"),
                                    "c__providerNotFound": cmp.get("v.providerNotFound"),
                                    "c__noMemberToSearch": cmp.get("v.noMemberToSearch"),
                                    "c__mnf": cmp.get("v.memberNotFound"),
                                    "c__providerType": providerType, // US2039716 - Thanish - 17th Sept 2019
                                    "c__isOtherSearch": false, // US2039716 - Thanish - 18th Sept 2019
                                    "c__intType": cmp.get("v.interactionType"),// US2039716 - Thanish - 18th Sept 2019
                                    "c__providerUniqueId": providerDetails.taxIdOrNPI,
                                    "c__isVCCD" : cmp.get("v.isVCCD"),//US2631703 - Durga- 08th June 2020
                                    "c__VCCDRespId":cmp.get("v.VCCDObjRecordId"),//US2631703 - Durga- 08th June 2020
                                    "c__VCCDQuestionType":cmp.get("v.VCCDQuestionType")//US2570805 - Sravan - 08/06/2020
                                }
                            },
                            focus: true
                        }).then(function (response) {
                            workspaceAPI.getTabInfo({
                                tabId: response
                            }).then(function (tabInfo) {
                                console.log("The recordId for this tab is: " + tabInfo.recordId);
                                var focusedTabId = tabInfo.tabId;
                                var providerLName = cmp.get("v.providerDetails.lastName");
                                // If the value in "interactionCard" attribute is null or empty then show "Interaction Overview" as the label.
                                
                                if (!$A.util.isEmpty(providerLName)) {
                                    var IOLabel = providerLName.charAt(0) + providerLName.slice(1).toLowerCase();
                                } else {
                                    var IOLabel = "Interaction Overview";
                                }
                                workspaceAPI.setTabLabel({
                                    tabId: focusedTabId,
                                    label: IOLabel
                                });
                                workspaceAPI.setTabIcon({
                                    tabId: focusedTabId,
                                    icon: "standard:contact_list",
                                    iconAlt: "Interaction Overview : "
                                });
                            });
                        }).catch(function (error) {
                            console.log(error);
                        });
                    } else {
                        console.log('##ML:NOT-OPEN');
                        var focusTabId = matchingTabs[0].tabId;
                        var tabURL = matchingTabs[0].url;
                        console.log('##TAB-ID:' + focusTabId);
                        workspaceAPI.openTab({
                            url: tabURL
                        }).then(function (response) {
                            workspaceAPI.focusTab({
                                tabId: response
                            });
                            workspaceAPI.getTabInfo({
                                tabId: response
                            }).then(function (tabInfo) {
                                console.log("The recordId for this tab is: " + tabInfo.recordId);
                                var focusedTabId = tabInfo.tabId;
                                var providerLName = cmp.get("v.providerDetails.lastName");
                                // If the value in "interactionCard" attribute is null or empty then show "Interaction Overview" as the label.
                                
                                if (!$A.util.isEmpty(providerLName)) {
                                    var IOLabel = providerLName.charAt(0) + providerLName.slice(1).toLowerCase();
                                } else {
                                    var IOLabel = "Interaction Overview";
                                }
                                workspaceAPI.setTabLabel({
                                    tabId: focusedTabId,
                                    label: IOLabel
                                });
                                workspaceAPI.setTabIcon({
                                    tabId: focusedTabId,
                                    icon: "standard:contact_list",
                                    iconAlt: "Interaction Overview : "
                                });
                            });
                        }).catch(function (error) {
                            console.log(error);
                        });
                    }
                })
            }// DE289290 - ENds 
        } else {
            cmp.set("v.findIndividualFlag", false);
            if (flowType == 'Member' && !cmp.get("v.findIndividualFlag")) {
                var memberDetails = cmp.get("v.selectedMemberDetails");
                var providerDetails = cmp.get("v.providerDetails");
                var memberSearches = cmp.get("v.memberSearches");
                var isProviderSearchDisabled = cmp.get("v.isProviderSearchDisabled");
                var isOtherSearch = cmp.get('v.isOtherSearch');
                var memberAlreadySearched = false;
                var providerUniqueId = "";

                if (isProviderSearchDisabled) {
                    providerUniqueId = "No Provider To Search";
                    cmp.set("v.providerDetails", null);
                    providerDetails = null;
                } else if (isOtherSearch) {
                    providerUniqueId = "Other";
                    cmp.set("v.providerDetails", null);
                    providerDetails = null;
                } else if (!isProviderSearchDisabled) {
                    providerUniqueId = providerDetails.taxIdOrNPI;
                }

                if (!$A.util.isEmpty(providerDetails) && providerDetails != null) {
                    for (var i = 0; i < memberSearches.length; i++) {
                        var alreadySearchedMemberArray = memberSearches[i].split(";");
                        if (providerDetails.taxIdOrNPI == alreadySearchedMemberArray[0] &&
                            ((memberDetails.memberId == alreadySearchedMemberArray[1] || memberDetails.firstName + " " + memberDetails.lastName == alreadySearchedMemberArray[2]) || memberDetails.memberDOB == alreadySearchedMemberArray[3])) {
                            memberAlreadySearched = true;
                            break;
                        }
                    }
                } else if (isOtherSearch) { //DE302199 - Avish
                    for (var i = 0; i < memberSearches.length; i++) {
                        var alreadySearchedMemberArray = memberSearches[i].split(";");
                        
                        if ((alreadySearchedMemberArray[0] == 'Other') &&
                            ((memberDetails.memberId == alreadySearchedMemberArray[1] || memberDetails.firstName + " " + memberDetails.lastName == alreadySearchedMemberArray[2]) || memberDetails.memberDOB == alreadySearchedMemberArray[3])) {
                            memberAlreadySearched = true;
                            break;
                        }
                        
                    }   //DE302199 - Ends
                }else {
                    var providerUniqueId = "No Provider To Search";
                    for (var i = 0; i < memberSearches.length; i++) {
                        var alreadySearchedMemberArray = memberSearches[i].split(";");

                        if ((isProviderSearchDisabled && alreadySearchedMemberArray[0] == 'No Provider To Search') &&
                            ((memberDetails.memberId == alreadySearchedMemberArray[1] || memberDetails.firstName + " " + memberDetails.lastName == alreadySearchedMemberArray[2]) || memberDetails.memberDOB == alreadySearchedMemberArray[3])) {
                            memberAlreadySearched = true;
                            break;
                        }

                    }
                }

                if (memberAlreadySearched) {
                    helper.hideMemberSpinner(cmp);
                    var workspaceAPI = cmp.find("workspace");
                    workspaceAPI.getAllTabInfo().then(function (response) {
                        if (!$A.util.isEmpty(response)) {
                            for (var i = 0; i < response.length; i++) {
                                debugger;
                                //rr
                                var providerDetails = cmp.get('v.providerDetails');

                                if (!isOtherSearch && response[i].pageReference.state.c__providerUniqueId == providerUniqueId) {

                                    var appEvent = $A.get("e.c:SAE_RefreshProviderCardAE");
                                    appEvent.setParams({
                                        "providerDetails": providerDetails,
                                        "providerUniqueId": providerUniqueId
                                    });

                                    appEvent.fire();

                                    workspaceAPI.openTab({
                                        url: response[i].url
                                    }).then(function (response) {
                                        workspaceAPI.focusTab({
                                            tabId: response
                                        });

                                        var tabLabel = providerDetails.lastName.charAt(0).toUpperCase() + providerDetails.lastName.slice(1);
                                        workspaceAPI.setTabLabel({
                                            tabId: response,
                                            label: tabLabel
                                        });


                                    }).catch(function (error) {
                                        console.log(error);
                                    });
                                } 
                            }
                        }
                    })
                    //mm
                } else {
                    helper.showMemberSpinner(cmp);
                    helper.findIndividualSearch(cmp, event, helper);
                    cmp.set("v.findIndividualFlag", true);
                }

            } else {

                // US2039716 - Thanish - 17th Sept 2019
                if(!cmp.get("v.providerNotFound"))
                var selectedProvdDetails = cmp.get("v.selectedPrvdDetails");

                var providerType = "";
                var providerLName = "";

                if (!$A.util.isEmpty(selectedProvdDetails)) {
                    if (selectedProvdDetails.providerType == 'O') {
                        providerType = "Facility";
                    } else if (selectedProvdDetails.providerType == 'P') {
                        providerType = "Physician";
                    } else {
                        providerType = "";
                    }
                    providerLName = selectedProvdDetails.lastName;
                }
                //DE264357
                if (selectedProvdDetails == null) {
                    selectedProvdDetails = cmp.get("v.providerDetails");
                }

                // End of Code - US2039716 - Thanish - 17th Sept 2019
                //rr
                var matchingTabs = [];
                var workspaceAPI = cmp.find("workspace");
                var providerDetails = cmp.get("v.providerDetails");
                workspaceAPI.getAllTabInfo().then(function (response) {
                    if (!$A.util.isEmpty(response)) {
                        for (var i = 0; i < response.length; i++) {
                            if (response[i].pageReference.state.c__providerUniqueId == providerDetails.taxIdOrNPI) {
                                matchingTabs.push(response[i]);
                            }
                        }
                    }
                    if (matchingTabs.length === 0) {
                        //close tab after refreshing tab or logout session
                        var interactionOverviewStatus = _setAndGetInteractionOverviewStatus.setValue(true);
                        workspaceAPI.openTab({
                            pageReference: {
                                "type": "standard__component",
                                "attributes": {
                                    "componentName": "c__SAE_InteractionOverview"
                                },
                                "state": {
                                    "c__tabOpened": true,
                                    "c__providerDetails": cmp.get("v.noMemberToSearch") ? selectedProvdDetails : cmp.get("v.providerDetails"), // US2039716 - Thanish - 17th Sept 2019
                                    "c__isProviderSearchDisabled": cmp.get("v.isProviderSearchDisabled"),
                                    "c__providerNotFound": cmp.get("v.providerNotFound"),
                                    "c__noMemberToSearch": cmp.get("v.noMemberToSearch"),
                                    "c__mnf": cmp.get("v.memberNotFound"),
                                    "c__providerType": providerType, // US2039716 - Thanish - 17th Sept 2019
                                    "c__isOtherSearch": false, // US2039716 - Thanish - 18th Sept 2019
                                    "c__intType": cmp.get("v.interactionType"),// US2039716 - Thanish - 18th Sept 2019
                                    "c__providerUniqueId": providerDetails.taxIdOrNPI,
                                    "c__isVCCD" : cmp.get("v.isVCCD"),//US2631703 - Durga- 08th June 2020
                                    "c__VCCDRespId":cmp.get("v.VCCDObjRecordId"),//US2631703 - Durga- 08th June 2020
                                    "c__VCCDQuestionType":cmp.get("v.VCCDQuestionType")//US2570805 - Sravan - 08/06/2020
                                }
                            },
                            focus: true
                        }).then(function (response) {
                            workspaceAPI.getTabInfo({
                                tabId: response
                            }).then(function (tabInfo) {
                                console.log("The recordId for this tab is: " + tabInfo.recordId);
                                var focusedTabId = tabInfo.tabId;
                                var providerLName = cmp.get("v.providerDetails.lastName");
                                // If the value in "interactionCard" attribute is null or empty then show "Interaction Overview" as the label.

                                if (!$A.util.isEmpty(providerLName)) {
                                    var IOLabel = providerLName.charAt(0) + providerLName.slice(1).toLowerCase();
                                } else {
                                    var IOLabel = "Interaction Overview";
                                }
                                workspaceAPI.setTabLabel({
                                    tabId: focusedTabId,
                                    label: IOLabel
                                });
                                workspaceAPI.setTabIcon({
                                    tabId: focusedTabId,
                                    icon: "standard:contact_list",
                                    iconAlt: "Interaction Overview : "
                                });
                            });
                        }).catch(function (error) {
                            console.log(error);
                        });
                    } else {
                        console.log('##ML:NOT-OPEN');
                        var focusTabId = matchingTabs[0].tabId;
                        var tabURL = matchingTabs[0].url;
                        var isProviderSearchDisabled = cmp.get("v.isProviderSearchDisabled");
                        let isProviderNotFound = cmp.get("v.providerNotFound");
                        if (!isProviderSearchDisabled) {
                            providerUniqueId = providerDetails.taxIdOrNPI;
                            var appEvent = $A.get("e.c:SAE_RefreshProviderCardAE");
                            appEvent.setParams({
                                "providerDetails": providerDetails,
                                "providerUniqueId": providerUniqueId
                            });
                            
                            appEvent.fire();
                        }
                        
                        console.log('##TAB-ID:' + focusTabId);
                        workspaceAPI.openTab({
                            url: tabURL
                        }).then(function (response) {
                            workspaceAPI.focusTab({
                                tabId: response
                            });
                            if (!isProviderSearchDisabled) {
                                workspaceAPI.getTabInfo({
                                    tabId: response
                                }).then(function (tabInfo) {
                                    console.log("The recordId for this tab is: " + tabInfo.recordId);
                                    var focusedTabId = tabInfo.tabId;
                                    var providerLName = cmp.get("v.providerDetails.lastName");
                                    // If the value in "interactionCard" attribute is null or empty then show "Interaction Overview" as the label.
                                    
                                    if (!$A.util.isEmpty(providerLName)) {
                                        var IOLabel = providerLName.charAt(0) + providerLName.slice(1).toLowerCase();
                                    } else {
                                        var IOLabel = "Interaction Overview";
                                    }
                                    workspaceAPI.setTabLabel({
                                        tabId: focusedTabId,
                                        label: IOLabel
                                    });
                                    workspaceAPI.setTabIcon({
                                        tabId: focusedTabId,
                                        icon: "standard:contact_list",
                                        iconAlt: "Interaction Overview : "
                                    });
                                });
                            }
                        }).catch(function (error) {
                            console.log(error);
                        });
                    }
                })
            }
        }
        //US2132239 : Member Only - No Provider to Search (END) 
    },
    
    init: function (cmp, event, helper) {
        var staticLabel = $A.get("$Label.c.ph_DOB");
        //US2076634 - HIPAA Guidelines Button - Sravan
        //Get the hipaa url
        helper.getHipaaDetails(cmp, event, helper);
    },
    
    disableContinueBtn : function(cmp, event, helper){
        var memNotFoundVal = event.getParam("isCheckedMemNotFound");
        cmp.set('v.memberNotFound',memNotFoundVal);
        var noProviderVal = event.getParam('isChecked');
        cmp.set('v.providerSearchFlag',noProviderVal);

        /** DE289290 - Avish **/
        if(event.getParam("isNoMemberToSearch")){
            cmp.set("v.isNoMemberToSearch",event.getParam("isNoMemberToSearch"));
            var memberSearches = cmp.get("v.memberSearches");
            cmp.set("v.memUniqueId","")
            memberSearches = [];
            cmp.set("v.memberSearches",memberSearches);
        }else{
            cmp.set("v.isNoMemberToSearch",false);
        }
        /** DE289290 - Ends **/
},
    // US1909477 - Thanish (30th July 2019)
  // Purpose - Add misdirect button to page header.
  // Copied from SAE_MisdirectController.js
    openMisdirectComp: function(component,event, helper) {
        helper.openMisDirect(component,event,helper);
    },
    // Thanish - End of Code.


    // US1727075: Explorer - Other (Third Party) - Kavinda
    handleOtherToggle: function(cmp, event, helper) {
        var isOtherSearch = cmp.get('v.isOtherSearch');
        var isValidOtherSearch = cmp.get('v.isValidOtherSearch');
        cmp.set('v.isOtherSearch', !isOtherSearch);
    },

    // US2031725 - Validation for Explore - Other (Third party) - Kavinda
    changeOtherSearch: function(cmp, event, helper) {
        var isOtherSearch = cmp.get('v.isOtherSearch');
        var isValidOtherSearch = cmp.get('v.isValidOtherSearch');
        if (isOtherSearch) {
            cmp.set('v.isMemSearchDisabledFromPrv', !isValidOtherSearch);
        } else {
            cmp.set('v.isMemSearchDisabledFromPrv', false);
        }
        // US1699139 - Continue button - Sanka
        cmp.set("v.validFlowProvider", isValidOtherSearch);
        _setandgetvalues.setContactValue('exploreContactData','','');
    },
getProviderRowInfoFromResults:  function(component, event, helper) {
        component.set("v.selectedPrvdDetails", event.getParam("selectedProviderDetails"));
    },
    getMemberRowInfoFromResults:  function(cmp, event, helper) {
        debugger;
        cmp.set("v.selectedMemberDetails", event.getParam("selectedMemberDetails"));
        cmp.set("v.flowType",event.getParam("flowType"));
        cmp.set("v.memUniqueId",event.getParam("memUniqueId"));
        cmp.set("v.providerSearchFlag",event.getParam("providerSearchFlag"));
        cmp.set("v.isOtherSearch",event.getParam("isOtherFlag"));
        cmp.set("v.memberContactName",event.getParam("contactName") != undefined ? event.getParam("contactName").toUpperCase() : '');
        cmp.set("v.memberContactNumber",event.getParam("contactNumber") != undefined ? event.getParam("contactNumber") : '');
    },
    assignInteractionID: function(cmp,event,helper){
        //Get the event message attribute
        var interactionIDVal = event.getParam("interactionEventID");
        //Set the handler attributes based on event data
        cmp.set("v.interactionID", interactionIDVal);
    },

    providerValidation: function (cmp, event, helper) {
        cmp.set("v.disableContinue", false);
    },
	
	// US2291032: Pilot Minot Changes - Move Continue Button to the Top - KAVINDA
    handleOpenInteractionFindIndividual: function (cmp, event, helper) {
        $A.enqueueAction(cmp.get('c.navigateToInteraction'));
    },

    /**
     * To Handle VCCD Application Event .
     *
     * @param objComponent To access dom elements.
     * @param objEvent To handle events.
     * @param objHelper To handle events.
     */
    handleVCCDEvent : function (objComponent, objEvent, objHelper) {
        let strMessage = objEvent.getParam("message");
        if($A.util.isUndefinedOrNull(strMessage) === false && strMessage !== '') {
            try {
                let objMessage = JSON.parse(strMessage);
                console.log('==@@'+JSON.stringify(objMessage));
                objComponent.set("v.isVCCD",objMessage.isVCCD);
                objComponent.set("v.VCCDObjRecordId",objMessage.objRecordData.Id);
                //US2570805 - Sravan - Start
                objComponent.set("v.VCCDQuestionType",objMessage.objRecordData.QuestionType__c);
                objEvent.stopPropagation();
            } catch (exception) {
                console.log('Inside VCCD Handle Exception' + exception);
    }
        }
    },
    //US2076634 - HIPAA Guidelines Button - Sravan
    handleHippaGuideLines : function(component, event, helper) {
        var hipaaEndPointUrl = component.get("v.hipaaEndpointUrl");
        if(!$A.util.isUndefinedOrNull(hipaaEndPointUrl) && !$A.util.isEmpty(hipaaEndPointUrl)){
            window.open(hipaaEndPointUrl, '_blank');
        }

	}

})