({
    showMemberSpinner: function (component) {
        var spinner = component.find("AuthenticateSearch-spinner");
        $A.util.removeClass(spinner, "slds-hide");
        $A.util.addClass(spinner, "slds-show");
    },
    hideMemberSpinner: function (component) {
        var spinner = component.find("AuthenticateSearch-spinner");
        $A.util.removeClass(spinner, "slds-show");
        $A.util.addClass(spinner, "slds-hide");
    },
    getProviderDetails: function (cmp) {
        var appEvent = $A.get("e.c:SAE_GetProviderDetailsAE");
        appEvent.setParams({
            "requestedCmp": "AuthenticateCall"
        });
        appEvent.fire();
    },

    //DE260181
    getMemberDetails: function (cmp) {
        var appEvent = $A.get("e.c:SAE_GetMemberDetailsAE");
        appEvent.fire();
    },

    // Added by Avish 09/21/2019
    findIndividualSearch:function(cmp,event,helper){
        debugger;
        if(!cmp.get("v.isNoMemberToSearch")){
            var selectedMemberDetails = cmp.get("v.selectedMemberDetails");
            var birthDate;
            if(selectedMemberDetails.DOB != '' || selectedMemberDetails.DOB != null){
                var birthdateTemp = selectedMemberDetails.DOB.split('/');
                birthDate = birthdateTemp[2]+'-'+birthdateTemp[0] + '-' + birthdateTemp[1];
            }
            console.log(birthdateTemp);
            // US1944108 - Accommodate Multiple Payer ID's
            var payerValue = cmp.get('v.payerValue');
            var action = cmp.get('c.findMembers');
            
            action.setParams({
                "memberId": selectedMemberDetails.memberID,
                "memberDOB": birthDate,
                "firstName": selectedMemberDetails.firstName,
                "lastName": selectedMemberDetails.lastName,
                "groupNumber": '',
                "searchOption": 'MemberIDNameDateOfBirth',
                "payerID": payerValue, // US1944108
                "providerFN": (selectedMemberDetails.interactionCard != null) ? selectedMemberDetails.interactionCard.firstName : '',
                "providerLN": (selectedMemberDetails.interactionCard != null) ? selectedMemberDetails.interactionCard.lastName : '',
                "providerNPI": (selectedMemberDetails.interactionCard != null) ? selectedMemberDetails.interactionCard.npi : '',
                "providerFlow": selectedMemberDetails.providerFlow
            });

            action.setCallback(this, function(response){
                var state = response.getState();
                if (state == 'SUCCESS') {
                    var result = response.getReturnValue();
                    if (result.statusCode == 200) {
                        console.log(result);
                        var subjectCard = result.resultWrapper.subjectCard;
                        cmp.set("v.subjectCard", subjectCard);
                        cmp.set("v.interactionCard", result.resultWrapper.interactionView);
                        helper.hideMemberSpinner(cmp);
                        helper.openFindIndivdualInteractionOverview(cmp,helper);
                    }else if (result.statusCode == 400) {
                        helper.hideMemberSpinner(cmp);
                        //this.fireToastMessage("Error!", result.message, "dismissible", "5000");
                        this.fireToastMessage("Error!", result.message.replace(". ", ". \n"), "error", "dismissible", "10000");
                    }else if (result.statusCode == 999) {
                        helper.hideMemberSpinner(cmp);
                        //this.fireToastMessage("Error!", result.message, "dismissible", "5000");
                        this.fireToastMessage("Error!", result.message.replace(". ", ". \n"), "error", "dismissible", "10000");
                    }else{
                        helper.hideMemberSpinner(cmp);
                        this.fireToastMessage("Error!", result.message.replace(". ", ". \n"), "error", "dismissible", "10000");
                    }
                }else{
                    helper.hideMemberSpinner(cmp);
                }

            });
            $A.enqueueAction(action);
        }else{
            helper.hideMemberSpinner(cmp);
            
            //helper.openFindIndivdualInteractionOverview(cmp,helper);
        }
    },

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

    // Added by Avish 09/25/2019 - US2070352
    //US2132239 : Member Only - No Provider to Search 
    openFindIndivdualInteractionOverview: function (cmp, helper) {

        var matchingTabs = [];
        var memUniqueId;
        var workspaceAPI = cmp.find("workspace");

        var providerDetails = cmp.get("v.providerDetails");
        
        var memberDetails = cmp.get("v.selectedMemberDetails");

        var memberSearches = cmp.get("v.memberSearches");
        var isProviderSearchDisabled = cmp.get("v.providerSearchFlag");
        var isOtherSearch = cmp.get('v.isOtherSearch');
        var memberAlreadySearched = false;

        var providerUniqueId = "";
        if (isProviderSearchDisabled) {
            providerUniqueId = "No Provider To Search";
        } else if (isOtherSearch) {
            providerUniqueId = "Other";
        } else if (!isProviderSearchDisabled) {
            providerUniqueId = providerDetails != null ? providerDetails.taxIdOrNPI : '';
        }


        //US2132239 : Member Only - No Provider to Search - PART2 : Date format
        let memDob = '';
        if (!$A.util.isUndefinedOrNull(memberDetails.DOB)) {
            let tempDob = new Date(memberDetails.DOB);
            memDob = ('0' + (tempDob.getMonth() + 1)).slice(-2) + '/' + ('0' + tempDob.getDate()).slice(-2) + '/' + tempDob.getFullYear();
        }

        if (providerDetails != null) {
            if (cmp.get("v.findIndividualFlag")) {
                //US2132239 : Member Only - No Provider to Search - PART2
                memUniqueId = providerUniqueId + ";" + memberDetails.memberID + ";" + memberDetails.firstName.toUpperCase() + " " + memberDetails.lastName.toUpperCase() + ";" + memDob;
            } else {
                //US2132239 : Member Only - No Provider to Search - PART2
                memUniqueId = providerUniqueId + ";" + memberDetails.memberId + ";" + memberDetails.firstName.toUpperCase() + " " + memberDetails.lastName.toUpperCase() + ";" + memDob;
            }
            var memberSearches = cmp.get("v.memberSearches");
            memberSearches.push(memUniqueId);
            cmp.set("v.memberSearches", memberSearches);
        } else if (isProviderSearchDisabled) {
            if (cmp.get("v.findIndividualFlag")) {
                //US2132239 : Member Only - No Provider to Search - PART2
                memUniqueId = providerUniqueId + ";" + memberDetails.memberID + ";" + memberDetails.firstName.toUpperCase() + " " + memberDetails.lastName.toUpperCase() + ";" + memDob;
            } else {
                //US2132239 : Member Only - No Provider to Search - PART2
                memUniqueId = providerUniqueId + ";" + memberDetails.memberId + ";" + memberDetails.firstName.toUpperCase() + " " + memberDetails.lastName.toUpperCase() + ";" + memDob;
            }
            var memberSearches = cmp.get("v.memberSearches");
            memberSearches.push(memUniqueId);
            cmp.set("v.memberSearches", memberSearches);
        } else if (isOtherSearch) {
            let selectedMember = cmp.get("v.selectedMemberDetails");
            let memDob = '';

            if (!$A.util.isUndefinedOrNull(selectedMember.DOB)) {
                let tempDate = new Date(selectedMember.DOB);
                memDob = ('0' + (tempDate.getMonth() + 1)).slice(-2) + '/' + ('0' + tempDate.getDate()).slice(-2) + '/' + tempDate.getFullYear();
            }
           
            memUniqueId = 'Other;' + selectedMember.memberID + ';' + selectedMember.firstName.toUpperCase() + ';' + selectedMember.lastName.toUpperCase() + ';' + memDob;
            let otherCard = cmp.get("v.otherDetails");
            let otherFlowUniqueId = 'Other;' + otherCard.firstName + ';' + otherCard.lastName + ';' + otherCard.contactType + ';' + otherCard.phoneNumber;
            providerUniqueId = otherFlowUniqueId;
        }


        //US2132239 : Member Only - No Provider to Search
        cmp.set("v.memUniqueId", memUniqueId);

        let mapParentTabIdsForIndividualSearch;
        workspaceAPI.getAllTabInfo().then(function (response) {

            //US2132239 : Member Only - No Provider to Search
            let memSubjectCard = cmp.get("v.subjectCard");
            let memIsFindIndividualSearch = cmp.get("v.findIndividualFlag");
            let householdUniqueId = '';
            let mapOpenedHouseholdMap = new Map();
            let mapOpenedProviderMap = new Map();
            let mapOpenedOtherMap = new Map();
            //US2132239 : Member Only - No Provider to Search
            if (isProviderSearchDisabled && memIsFindIndividualSearch && !$A.util.isUndefinedOrNull(memSubjectCard)) {
                householdUniqueId = memSubjectCard.memberId;
            }


            if (!$A.util.isEmpty(response)) {

                //US2132239 : Member Only - No Provider to Search
                if ($A.util.isUndefinedOrNull(cmp.get("v.TabsAsHouseHoldsMap"))) {
                    cmp.set("v.TabsAsHouseHoldsMap", mapOpenedHouseholdMap);
                } else {
                    mapOpenedHouseholdMap = cmp.get("v.TabsAsHouseHoldsMap")
                }

                if ($A.util.isUndefinedOrNull(cmp.get("v.TabsAsProviderMap"))) {
                    cmp.set("v.TabsAsProviderMap", mapOpenedProviderMap);
                } else {
                    mapOpenedProviderMap = cmp.get("v.TabsAsProviderMap")
                }

                if ($A.util.isUndefinedOrNull(cmp.get("v.OpenedOtherTabs"))) {
                    cmp.set("v.OpenedOtherTabs", mapOpenedOtherMap);
                } else {
                    mapOpenedOtherMap = cmp.get("v.OpenedOtherTabs")
                }

                for (var i = 0; i < response.length; i++) {

                    //US2132239 : Member Only - No Provider to Search
                    if (!isProviderSearchDisabled && memIsFindIndividualSearch) {

                        if (isOtherSearch) {                    
                            if (response[i].pageReference.state.c__providerUniqueId == providerUniqueId) {
                                matchingTabs.push(response[i]);
                                mapOpenedOtherMap.set(providerUniqueId, response[i]);
                               
                            }
                            
                        } else {
                            if (response[i].pageReference.state.c__providerUniqueId == providerUniqueId) {
                                matchingTabs.push(response[i]);
                                mapOpenedProviderMap.set(providerUniqueId, response[i]);
                            }
                        }

                    } else if (isProviderSearchDisabled && memIsFindIndividualSearch) {

                        if (response[i].pageReference.state.c__HouseholdUniqueId == householdUniqueId) {
                            matchingTabs.push(response[i]);
                            mapOpenedHouseholdMap.set(householdUniqueId, response[i]);
                        }
                    }


                }

                //US2132239 : Member Only - No Provider to Search.
                cmp.set("v.TabsAsHouseHoldsMap", mapOpenedHouseholdMap);
                cmp.set("v.TabsAsProviderMap", mapOpenedProviderMap);
                cmp.set("v.OpenedOtherTabs", mapOpenedOtherMap);
            }

            // US1944108 - Accommodate Multiple Payer ID's - Kavinda
            var subjectCard = cmp.get("v.subjectCard");
            var payerValue = cmp.get('v.payerValue');
            subjectCard['payerID'] = payerValue;
            cmp.get("v.subjectCard", subjectCard);

            if (matchingTabs.length === 0) {
                //close tab after refreshing tab or logout session
                var interactionOverviewStatus = _setAndGetInteractionOverviewStatus.setValue(true);
                var providerData = cmp.get("v.providerDetails");
                var otherData = cmp.get("v.otherDetails");
                var memberData = cmp.get("v.selectedMemberDetails");
                var contactName = '';
                var contactNumber = '';
                
                if(!$A.util.isEmpty(providerData)) {
                    contactName = providerData.contactName;
                    contactNumber = providerDetails.contactNumber;
                } else if(!$A.util.isEmpty(memberData)) {
                    contactName = cmp.get("v.providerSearchFlag") ? cmp.get("v.providerContactName") : cmp.get("v.memberContactName");
                    contactNumber = cmp.get("v.memberContactNumber");
                }
                if(!$A.util.isEmpty(otherData)) {
                    contactName = otherData.firstName+' '+otherData.lastName;
                    contactNumber = otherData.phoneNumber;
                }
                
                //_setandgetvalues.setContactValue(providerUniqueId,contactName,contactNumber);
                workspaceAPI.openTab({
                    pageReference: {
                        "type": "standard__component",
                        "attributes": {
                            "componentName": "c__SAE_InteractionOverview"
                        },
                        "state": {
                            "c__HouseholdUniqueId": householdUniqueId,//US2132239 : Member Only - No Provider to Search
                            "c__tabOpened": true,
                            "c__providerNotFound": cmp.get("v.providerNotFound"), //DE267648 - Thanish - 17th Oct 2019 
                            "c__subjectCard": cmp.get("v.subjectCard"),
                            "c__findIndividualFlag": cmp.get("v.findIndividualFlag"),
                            "c__interactionCard": cmp.get("v.interactionCard"),
                            "c__memberUniqueId": cmp.get("v.memUniqueId"),
                            "c__providerUniqueId": providerUniqueId,
                            "c__providerSearchFlag": cmp.get("v.providerSearchFlag"),
                            "c__isOtherSearch": cmp.get("v.isOtherSearch"),
                            "c__otherDetails": cmp.get("v.otherDetails"),
                            "c__providerDetails": cmp.get("v.providerDetails"),
                            "c__providerContactName": cmp.get("v.providerContactName"),
                            "c__memberContactName": contactName,
                            "c__memberContactNumber": contactNumber,
                            "c__providerFlow": memberDetails.providerFlow,
                            "c__noMemberToSearch": cmp.get("v.noMemberToSearch"),
                            "c__intType": cmp.get("v.interactionType"), //US2061732 - Added by Avish
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
                        var selectedMemberDetails = cmp.get("v.selectedMemberDetails");

                        if (cmp.get("v.isProviderSearchDisabled")) {
                            // If the value in "interactionCard" attribute is null or empty then show "Interaction Overview" as the label.
                            if (!$A.util.isEmpty(selectedMemberDetails.lastName)) {
                                var IOLabel = selectedMemberDetails.lastName.charAt(0) + selectedMemberDetails.lastName.slice(1).toLowerCase();
                            }
                        } else {
                            var providerLName = cmp.get("v.providerDetails.lastName");
                            if (cmp.get("v.isOtherSearch")) {
                                //US2536668 changes
                                //var otherLastname = cmp.get("v.otherDetails.lastName");
                                IOLabel = cmp.get("v.otherDetails.conName");//otherLastname.charAt(0).toUpperCase() + otherLastname.slice(1);
                            } else {
                                if (!$A.util.isEmpty(providerLName)) {
                                    IOLabel = providerLName.charAt(0) + providerLName.slice(1).toLowerCase();
                                } else {
                                    IOLabel = "Interaction Overview";
                                }
                            }
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

                //US2132239 : Member Only - No Provider to Search
                if (isProviderSearchDisabled && memIsFindIndividualSearch) {
                    if (!$A.util.isUndefinedOrNull(mapOpenedHouseholdMap) && mapOpenedHouseholdMap.has(householdUniqueId)) {
                        let focusTab = mapOpenedHouseholdMap.get(householdUniqueId);
                        var focusTabId = focusTab.tabId;
                        var tabURL = focusTab.url;
   
                        var appEvent = $A.get("e.c:SAE_SubjectCardAE");
                        if (cmp.get('v.mnf') != 'mnf') {

                            appEvent.setParams({
                                "subjectCard": cmp.get("v.subjectCard"),
                                "searchedMember": cmp.get("v.memUniqueId"),
                                "existingMemberCardFlag": cmp.get("v.checkFlagmeberCard"),
                                "providerUniqueId": providerUniqueId,
                                "providerDetails": cmp.get('v.providerDetails')
                            });
                        } else {
                            appEvent.setParams({
                                "searchedMember": memUniqueId,
                                "mnfMemberFN": mnfMemberFN.toUpperCase(),
                                "mnfMemberLN": mnfMemberLN.toUpperCase(),
                                "mnfDOB": mnfDOB,
                                "mnfMemberState": mnfstateVal,
                                "mnfMemberPhNo": mnfPhoneFormat,
                                "mnf": cmp.get('v.mnf'),
                                "mnfIntDetailLst": cmp.get("v.mnfDetailsLst"),
                                "providerUniqueId": providerUniqueId,
                                "providerDetails": cmp.get('v.providerDetails')
                            });
                        }

                        appEvent.fire();

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
                                var selectedMemberDetails = cmp.get("v.selectedMemberDetails");
                                
                                if (cmp.get("v.isProviderSearchDisabled")) {
                                    // If the value in "interactionCard" attribute is null or empty then show "Interaction Overview" as the label.
                                    if (!$A.util.isEmpty(selectedMemberDetails.lastName)) {
                                        var IOLabel = selectedMemberDetails.lastName.charAt(0) + selectedMemberDetails.lastName.slice(1).toLowerCase();
                                    }
                                } else {
                                    var providerLName = cmp.get("v.providerDetails.lastName");
                                    if (cmp.get("v.isOtherSearch")) {
                                        //US2536668 changes
                                        //var otherLastname = cmp.get("v.otherDetails.lastName");
                                        IOLabel =cmp.get("v.otherDetails.conName");//otherLastname.charAt(0).toUpperCase() + otherLastname.slice(1);
                                    } else {
                                        if (!$A.util.isEmpty(providerLName)) {
                                            IOLabel = providerLName.charAt(0) + providerLName.slice(1).toLowerCase();
                                        } else {
                                            IOLabel = "Interaction Overview";
                                        }
                                    }
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
                } else if (!isProviderSearchDisabled && memIsFindIndividualSearch && !isOtherSearch) {                    
                    if (!$A.util.isUndefinedOrNull(mapOpenedProviderMap) && mapOpenedProviderMap.has(providerUniqueId)) {
                        let focusTab = mapOpenedProviderMap.get(providerUniqueId);
                        let focusTabId = focusTab.tabId;
                        let tabURL = focusTab.url;
                        var appEvent = $A.get("e.c:SAE_SubjectCardAE");
                        if (cmp.get('v.mnf') != 'mnf') {

                            appEvent.setParams({
                                "subjectCard": cmp.get("v.subjectCard"),
                                "searchedMember": cmp.get("v.memUniqueId"),
                                "existingMemberCardFlag": cmp.get("v.checkFlagmeberCard"),
                                "providerUniqueId": providerUniqueId,
                                "providerDetails": cmp.get('v.providerDetails')
                            });
                        } else {
                            appEvent.setParams({
                                "searchedMember": memUniqueId,
                                "mnfMemberFN": mnfMemberFN.toUpperCase(),
                                "mnfMemberLN": mnfMemberLN.toUpperCase(),
                                "mnfDOB": mnfDOB,
                                "mnfMemberState": mnfstateVal,
                                "mnfMemberPhNo": mnfPhoneFormat,
                                "mnf": cmp.get('v.mnf'),
                                "mnfIntDetailLst": cmp.get("v.mnfDetailsLst"),
                                "providerUniqueId": providerUniqueId,
                                "providerDetails": cmp.get('v.providerDetails')
                            });
                        }

                        appEvent.fire();

                        workspaceAPI.openTab({
                            url: tabURL
                        }).then(function (response) {
                            workspaceAPI.focusTab({
                                tabId: focusTabId
                            });
                            workspaceAPI.getTabInfo({
                                tabId: response
                            }).then(function (tabInfo) {
                                console.log("The recordId for this tab is: " + tabInfo.recordId);
                                var focusedTabId = tabInfo.tabId;
                                var selectedMemberDetails = cmp.get("v.selectedMemberDetails");
                                
                                if (cmp.get("v.isProviderSearchDisabled")) {
                                    // If the value in "interactionCard" attribute is null or empty then show "Interaction Overview" as the label.
                                    if (!$A.util.isEmpty(selectedMemberDetails.lastName)) {
                                        var IOLabel = selectedMemberDetails.lastName.charAt(0) + selectedMemberDetails.lastName.slice(1).toLowerCase();
                                    }
                                } else {
                                    var providerLName = cmp.get("v.providerDetails.lastName");
                                    if (cmp.get("v.isOtherSearch")) {
                                        //US2536668 changes
                                        //var otherLastname = cmp.get("v.otherDetails.lastName");
                                        IOLabel =cmp.get("v.otherDetails.conName");//otherLastname.charAt(0).toUpperCase() + otherLastname.slice(1);
                                    } else {
                                        if (!$A.util.isEmpty(providerLName)) {
                                            IOLabel = providerLName.charAt(0) + providerLName.slice(1).toLowerCase();
                                        } else {
                                            IOLabel = "Interaction Overview";
                                        }
                                    }
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
                } else if (!isProviderSearchDisabled && memIsFindIndividualSearch && isOtherSearch) {
                    if (!$A.util.isUndefinedOrNull(mapOpenedOtherMap) && mapOpenedOtherMap.has(providerUniqueId)) {
                      
                        let focusTab = mapOpenedOtherMap.get(providerUniqueId);
                        let focusTabId = focusTab.tabId;
                        let tabURL = focusTab.url;
                        let appEvent = $A.get("e.c:SAE_SubjectCardAE");
                        appEvent.setParams({
                            "subjectCard": cmp.get("v.subjectCard"),
                            "searchedMember": cmp.get("v.memUniqueId"),
                            "existingMemberCardFlag": cmp.get("v.checkFlagmeberCard"),
                            "providerUniqueId": providerUniqueId,
                            "providerDetails": cmp.get('v.providerDetails')
                        });
                        appEvent.fire();          
                        workspaceAPI.openTab({
                            url: tabURL
                        }).then(function (response) {
                            workspaceAPI.focusTab({
                                tabId: focusTabId
                            });
                            workspaceAPI.getTabInfo({
                                tabId: response
                            }).then(function (tabInfo) {
                                console.log("The recordId for this tab is: " + tabInfo.recordId);
                                var focusedTabId = tabInfo.tabId;
                                var selectedMemberDetails = cmp.get("v.selectedMemberDetails");
                                
                                if (cmp.get("v.isProviderSearchDisabled")) {
                                    // If the value in "interactionCard" attribute is null or empty then show "Interaction Overview" as the label.
                                    if (!$A.util.isEmpty(selectedMemberDetails.lastName)) {
                                        var IOLabel = selectedMemberDetails.lastName.charAt(0) + selectedMemberDetails.lastName.slice(1).toLowerCase();
                                    }
                                } else {
                                    var providerLName = cmp.get("v.providerDetails.lastName");
                                    if (cmp.get("v.isOtherSearch")) {
                                         //US2536668 changes
                                        //var otherLastname = cmp.get("v.otherDetails.lastName");
                                        IOLabel =cmp.get("v.otherDetails.conName");//otherLastname.charAt(0).toUpperCase() + otherLastname.slice(1);
                                    } else {
                                        if (!$A.util.isEmpty(providerLName)) {
                                            IOLabel = providerLName.charAt(0) + providerLName.slice(1).toLowerCase();
                                        } else {
                                            IOLabel = "Interaction Overview";
                                        }
                                    }
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
                }
            }

        })
    },

    navigateToInteractionHelper:function(cmp,event,helper,flagMNFnav){
        //helper.openInteractionOverview(cmp,event,helper);
        //var memConId = cmp.find('memContactId');
        //var memConVal = memConId.get('v.value');
        /*var controlAuraIds =  [];

        var memFNameId = cmp.find('memFirstNameId');
        var memLNameId = cmp.find('memLastNameId');
        var memPhoneNum = cmp.find('memPhoneNumber');
        var memState = cmp.find('stateMemId');

        console.log('memFNameId@@@ ' + memFNameId);
        $A.util.removeClass(memFNameId, "hide-error-message");
        $A.util.removeClass(memLNameId, "hide-error-message");
        $A.util.removeClass(memPhoneNum, "hide-error-message");
        $A.util.removeClass(memState, "hide-error-message");
        console.log('memLNameId@@@ ' + memLNameId);

        //if(!$A.util.isEmpty(memConVal)){
        if(cmp.get('v.disableMemberSec') == true){

            controlAuraIds = ["memFirstNameId","memLastNameId","memPhoneNumber","memContactId","inputDOB","stateMemId"];
        }else{

            controlAuraIds = ["memFirstNameId","memLastNameId","memPhoneNumber","inputDOB","stateMemId"];
        }
        var memFN = cmp.find('memFirstNameId').get('v.value');
        var memLN = cmp.find('memLastNameId').get('v.value');
        var memPhNo = cmp.find('memPhoneNumber').get('v.value');
        var contactMNFId = cmp.find('memContactId').get('v.value');
        var memDOB = cmp.find('inputDOB').get('v.value');

        //reducer function iterates over the array and return false if any of the field is invalid otherwise true.
        var isAllValid = controlAuraIds.reduce(function(isValidSoFar, controlAuraId){
            //fetches the component details from the auraId
            var inputCmp='';
            console.log('controlAuraId@@ ' + controlAuraId);
            console.log('controlAuraIdValue@@ ' + $A.util.isEmpty(controlAuraId));
            if(!$A.util.isEmpty(controlAuraId)){
                if(controlAuraId == 'stateMemId'){
                    console.log('controlAuraIdIf@@>> ' + controlAuraId);
                    var tempState = cmp.find('stateMemId').find('provStateId').get("v.value");
                    console.log('tempState11### ' + tempState + ' @@@$value@@@ ' + $A.util.isEmpty(tempState));
                    var elem = cmp.find('stateMemId').find('provStateId');
                    if($A.util.isEmpty(tempState)){
                        cmp.find('stateMemId').find('provStateId').reportValidity();
                        return false;
                    }else{
                        return true;
                    }

                }else{
                    console.log('controlAuraIdElseState@@ ' + controlAuraId);
                    inputCmp = cmp.find(controlAuraId);

                    inputCmp.reportValidity();
                }
                //form will be invalid if any of the field's valid property provides false value.
                return true;
            }else{
                console.log('controlAuraIdElse@@ ' + controlAuraId);
                inputCmp = cmp.find(controlAuraId);
                inputCmp.reportValidity();
                //form will be invalid if any of the field's valid property provides false value.
                return false;
            }
            //displays the error messages associated with field if any

        },true);
        console.log('isAllValid>>>> ' + isAllValid);
        if(!$A.util.isEmpty(memConVal)){
            if(isAllValid ){
                if((!$A.util.isEmpty(memFN) && !$A.util.isEmpty(memLN) && !$A.util.isEmpty(memPhNo) && memPhNo.length == 10 && !$A.util.isEmpty(memDOB) && !$A.util.isEmpty(contactMNFId))){
                    isAllValid = true;
                } else {
                    isAllValid = false;
                }
            }else{
                isAllValid = false;
            }
        }else{

            if(isAllValid ){
                if((!$A.util.isEmpty(memFN) && !$A.util.isEmpty(memLN) && !$A.util.isEmpty(memPhNo) && memPhNo.length == 10 && !$A.util.isEmpty(memDOB))){
                    isAllValid = true;
                } else {
                    isAllValid = false;
                }
            }else{
                isAllValid = false;
            }
        }

        if(isAllValid != undefined && isAllValid != false && flagMNFnav){
            helper.openInteractionOverview(cmp,event,helper);
        }*/
    },

    // US1909477 - Thanish (30th July 2019)
 	// Purpose - Add misdirect button to page header.
 	// Copied from SAE_MisdirectHelper.js
	openMisDirect:function(component,event,helper){
        /**/
        var workspaceAPI = component.find("workspace");
        workspaceAPI.getEnclosingTabId().then(function(enclosingTabId) {
            if(enclosingTabId == false){
                workspaceAPI.openTab({
                    pageReference: {
                        "type": "standard__component",
                        "attributes": {
                            "componentName": "c__SAE_MisdirectComponent" // c__<comp Name>
                        },
                        "state": {
                            "c__contactUniqueId": "exploreContactData",
                            "c__focusedTabId": "exploretab",
                            "c__isVCCD" : component.get("v.isVCCD"),//US2631703 - Durga- 08th June 2020
                            "c__VCCDRespId":component.get("v.VCCDObjRecordId")//US2631703 - Durga- 08th June 2020
                        }
                    },
                    focus: true
                }).then(function(response) {
                    workspaceAPI.getTabInfo({
                        tabId: response
                    }).then(function(tabInfo) {
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
                }).catch(function(error) {
                    console.log(error);
                });
            }else{
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
                            "c__interactionID": component.get('v.interactionID'),
                            "c__contactUniqueId": "exploreContactData",
                            "c__isVCCD" : component.get("v.isVCCD"),//US2631703 - Durga- 08th June 2020
                            "c__VCCDRespId":component.get("v.VCCDObjRecordId")//US2631703 - Durga- 08th June 2020
                        }
                    }
                }).then(function(subtabId) {
                    console.log("The new subtab ID is:" + subtabId);
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
                }).catch(function(error) {
                    console.log(error);
                });
            }

        });
    },
    // Thanish - End of code.
	
    //Re-added by Malinda
    formatDateMMDDYYYY: function (cmp, dobToFormat) {
        var dobMM;
        var dobDD;
        var dob;

        if (dobToFormat[0].charAt(0) == '0') {
            dobMM = dobToFormat[0].charAt(1);
        } else {
            dobMM = dobToFormat[0];
        }

        if (dobToFormat[1].charAt(0) == '0') {
            dobDD = dobToFormat[1].charAt(1);
        } else {
            dobDD = dobToFormat[1];
        }
        dob = dobMM + '/' + dobDD + '/' + dobToFormat[2];
        return dob;
    },
    //US2076634 - HIPAA Guidelines Button - Sravan
    getHipaaDetails:function(component, event, helper){
        var getHippaEndPoint = component.get("c.getHippaGuideLinesUrl");
        getHippaEndPoint.setCallback(this,function(response){
            var state = response.getState();
            if(state == 'SUCCESS'){
                var responseUrl = response.getReturnValue();
                component.set("v.hipaaEndpointUrl",responseUrl);
            }
        })
        $A.enqueueAction(getHippaEndPoint);
    }
})