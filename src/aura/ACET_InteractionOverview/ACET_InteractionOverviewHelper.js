({
    getEnclosingTabIdHelper: function (cmp, event) {
        var workspaceAPI = cmp.find("workspace");
        workspaceAPI.getEnclosingTabId().then(function (tabId) {
            console.log(tabId);
            cmp.set("v.currentTabId", tabId);
        })
        .catch(function (error) {
            console.log(error);
        });
    },
    
    updateInteractionDetails: function (cmp, event) {
        //var interactionOverviewTabId = event.getParam("interactioOverviewTabUniqueId");
        //if (interactionOverviewTabId == cmp.get("v.interactionOverviewTabId")) {
        if (event.getParam('currentTabId') == cmp.get("v.currentTabId")) {
            var interactionOverviewTabId = cmp.get("v.interactionOverviewTabId");
            var interactionOverviewData = JSON.parse(JSON.stringify(_setAndGetSessionValues.getInteractionDetails(interactionOverviewTabId)));
            if (cmp.get("v.focusedCount") != interactionOverviewData.focusedCount) {
                cmp.set("v.focusedCount", interactionOverviewData.focusedCount);
                var flowDetailsOld = cmp.get("v.flowDetails");
                console.log(JSON.parse(JSON.stringify(flowDetailsOld)));
                var flowDetailsNew = interactionOverviewData.flowDetails;
                var contactNumber = flowDetailsNew.contactNumber;
                flowDetailsNew.contactNumber = '('+contactNumber.substring(0, 3) + ') ' + contactNumber.substring(3, 6) + '-' + contactNumber.substring(6, 10);
                var providerDetailsOld = cmp.get("v.providerDetails");
                console.log(JSON.parse(JSON.stringify(providerDetailsOld)));
                var providerDetailsNew = interactionOverviewData.providerDetails;
                var phoneNumber = providerDetailsNew.phoneNumber;
                providerDetailsNew.phoneNumber = phoneNumber.substring(0, 3) + '-' + phoneNumber.substring(3, 6) + '-' + phoneNumber.substring(6, 10);
                console.log(JSON.parse(JSON.stringify(providerDetailsNew)));
                if (flowDetailsOld.contactName != flowDetailsNew.contactName ||
                    flowDetailsOld.contactNumber != flowDetailsNew.contactNumber ||
                    flowDetailsOld.contactExt != flowDetailsNew.contactExt ||
                    providerDetailsOld.taxId != providerDetailsNew.taxId ||
                    providerDetailsOld.npi != providerDetailsNew.npi ||
                    providerDetailsOld.firstName != providerDetailsNew.firstName ||
                    providerDetailsOld.lastName != providerDetailsNew.lastName ||
                    providerDetailsOld.state != providerDetailsNew.state ||
                    providerDetailsOld.filterType != providerDetailsNew.filterType ||
                    providerDetailsOld.zip != providerDetailsNew.zip ||
                    providerDetailsOld.phoneNumber != providerDetailsNew.phoneNumber) {
                    if (!providerDetailsOld.isNoProviderToSearch) {
                        this.showToastMessage("Success!", 'Updates you have made on a provider have been applied.', "success", "dismissible", "10000");
                    }
                    cmp.set("v.flowDetails", interactionOverviewData.flowDetails);
                    cmp.set("v.providerDetails", providerDetailsNew);
                    this.getInteractionRecordDetails(cmp, interactionOverviewData);
                }
                var memberDetailsOld = cmp.get("v.memberDetails");
                var memberDetailsNew = interactionOverviewData.membersData;
                cmp.set("v.memberDetails", memberDetailsNew);
                //US2717679: Interaction Overview Page - Member Card Alignment - Praveen - start
                var memcount = 0;
                var memDetailsCountCheck = cmp.get("v.memberDetails");
                for (var mc in memDetailsCountCheck) {
                    if (memDetailsCountCheck[mc].isFromExplore) {
                        memcount++;
                    }
                }
                console.log("memcount ==> " + memcount);
                
                var numberOfMembers = interactionOverviewData.membersData.length;
                if (memcount == 1) {
                    cmp.set("v.enableAddMembersToSearch", true);
                }
                if (memcount > 1) {
                    if ((memcount % 2) === 0) {
                        cmp.set("v.enableAddMembersToSearch", false);
                    } else {
                        cmp.set("v.enableAddMembersToSearch", true);
                    }
                }
                var memDetailsCheck = cmp.get("v.memberDetails");
                console.log("memDetailsCheck update ==> " + JSON.stringify(memDetailsCheck));
                var mdc;
                for (mdc in memDetailsCheck) {
                    if (memDetailsCheck[mdc].isValidMember) {
                        cmp.set("v.enableAddMembersToSearchMf", true);
                        break;
                    }
                }
                var mnfdc;
                for (mnfdc in memDetailsCheck) {
                    if (memDetailsCheck[mnfdc].isMemberNotFound) {
                        cmp.set("v.enableAddMembersToSearchMnf", true);
                        break;
                    }
                }
                //US2717679: Interaction Overview Page - Member Card Alignment - Praveen - end
                if (!$A.util.isEmpty(memberDetailsNew) && !memberDetailsNew[0].isNoMemberToSearch && memberDetailsOld.length == memberDetailsNew.length) {
                    this.showToastMessage("Warning!", 'Member was already searched.', "warning", "dismissible", "10000");
                }
                cmp.find("alertsAI").alertsMethod();
            }
        }
    },
    
    getInteractionRecordDetails: function (cmp, interactionOverviewData) {
        if ($A.util.isEmpty(interactionOverviewData.interactionDetails)) {
            var action = cmp.get('c.createInteraction');
            action.setParams({
                "flowDetails": interactionOverviewData.flowDetails,
                "providerDetails": $A.util.isEmpty(interactionOverviewData.providerDetails) ? null : interactionOverviewData.providerDetails,
                "memberResponseData": $A.util.isEmpty(interactionOverviewData.membersData) ? null : (interactionOverviewData.membersData[0].isNoMemberToSearch ? null : interactionOverviewData.membersData[0]),
                "isVCCD": cmp.get("v.isVCCD"),
                "VCCDRecordId": cmp.get("v.VCCDObjRecordId")
            });
            action.setCallback(this, function (response) {
                var state = response.getState();
                if (state == 'SUCCESS') {
                    var result = response.getReturnValue();
                    if (!$A.util.isEmpty(result)) {
                        _setAndGetSessionValues.setInteractionRecordDetails(cmp.get("v.interactionOverviewTabId"), result);
                        _setandgetvalues.setContactValue(result.Id, interactionOverviewData.flowDetails.contactName, interactionOverviewData.flowDetails.contactNumber,interactionOverviewData.flowDetails.contactExt,interactionOverviewData.flowDetails.contactFirstName,interactionOverviewData.flowDetails.contactLastName);
                        cmp.set("v.interactionDetails", result);
                        cmp.find("alertsAI").alertsMethod();   
                    } else {
                        this.fireErrorToastMessage("Close the IO page and reopen to ensure an Interaction ID is generated.");   
                    }
                } else {
                    this.fireErrorToastMessage("Close the IO page and reopen to ensure an Interaction ID is generated.");
                    console.log('There was a problem : ' + JSON.stringify(response.getError()));
                }
                cmp.find("interactionCardSpinnerAI").set("v.isTrue", false);
            });
            $A.enqueueAction(action);
        } else {
            var action = cmp.get('c.updateInteraction');
            action.setParams({
                "flowDetails": interactionOverviewData.flowDetails,
                "providerDetails": $A.util.isEmpty(interactionOverviewData.providerDetails) ? null : interactionOverviewData.providerDetails,
                "interactionId": interactionOverviewData.interactionDetails.Id,
                "isVCCD": cmp.get("v.isVCCD"),
                "VCCDRecordId": cmp.get("v.VCCDObjRecordId")
            });
            action.setCallback(this, function (response) {
                var state = response.getState();
                if (state == 'SUCCESS') {
                    var result = response.getReturnValue();
                    _setAndGetSessionValues.setInteractionRecordDetails(cmp.get("v.interactionOverviewTabId"), result);
                    cmp.set("v.interactionDetails", result);
                }
                cmp.find("interactionCardSpinnerAI").set("v.isTrue", false);
            });
            $A.enqueueAction(action);
        }
    },
    
    //Error Message
    fireErrorToastMessage: function (message) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "Error",
            "message": message,
            "type": "error",
            "mode": "pesky",
            "duration": "10000"
        });
        toastEvent.fire();
    },
    
    copyFieldValue: function (cmp, event, text) {
        //copy SSN Value to clipboard
        var hiddenInput = document.createElement("input");
        hiddenInput.setAttribute("value", text);
        document.body.appendChild(hiddenInput);
        hiddenInput.select();
        document.execCommand("copy");
        document.body.removeChild(hiddenInput);
        var orignalLabel = event.getSource().get("v.label");
        event.getSource().set("v.label", 'copied');
        setTimeout(function () {
            event.getSource().set("v.label", orignalLabel);
        }, 700);
    },
    
    closeInteractionOverviewTabs: function (cmp) {
        var workspaceAPI = cmp.find("workspace");
        workspaceAPI.getAllTabInfo().then(function (response) {
            if (!$A.util.isEmpty(response)) {
                for (var i = 0; i < response.length; i++) {
                    if (response[i].pageReference.attributes.componentName == "c__ACET_InteractionOverview") {
                        var focusedTabId = response[i].tabId;
                        workspaceAPI.closeTab({
                            tabId: focusedTabId
                        });
                    }
                }
            }
        })
        .catch(function (error) {
            console.log(error);
        });
    },
    
    openMisDirect: function (cmp) {
        var workspaceAPI = cmp.find("workspace");
        var memberDetails = cmp.get("v.memberDetails");
        var providerDetails = cmp.get("v.providerDetails");
        var interactionDetails = cmp.get("v.interactionDetails");
        var flowDetails = cmp.get("v.flowDetails");
        workspaceAPI.getEnclosingTabId().then(function (enclosingTabId) {
            if (enclosingTabId == false) {
                workspaceAPI.openTab({
                    pageReference: {
                        "type": "standard__component",
                        "attributes": {
                            "componentName": "c__SAE_MisdirectComponent"
                        },
                        "state": {
                            "c__isVCCD": cmp.get("v.isVCCD"),
                            "c__VCCDRespId": cmp.get("v.VCCDObjRecordId")
                        }
                    },
                    focus: true
                }).then(function (response) {
                    workspaceAPI.getTabInfo({
                        tabId: response
                    }).then(function (tabInfo) {
                        var focusedTabId = tabInfo.tabId;
                        workspaceAPI.setTabLabel({
                            tabId: focusedTabId,
                            label: "Misdirect"
                        });
                        
                        workspaceAPI.setTabIcon({
                            tabId: focusedTabId,
                            icon: "standard:decision",
                            iconAlt: "Misdirect"
                        });
                    });
                }).catch(function (error) {
                    console.log(error);
                });
            } else {
                var originatorName = '';
                if (providerDetails.isValidProvider && !providerDetails.isNoProviderToSearch) {
                    originatorName = providerDetails.firstName + ' ' + providerDetails.lastName;
                } else if (providerDetails.isOther) {
                    originatorName = providerDetails.firstName + ' ' + providerDetails.lastName;
                } else if(providerDetails.isProviderNotFound){
                    originatorName = providerDetails.firstName + ' ' + providerDetails.lastName;
                } else {
                    originatorName = memberDetails[0].firstName + ' ' + memberDetails[0].lastName;
                }
                workspaceAPI.openSubtab({
                    parentTabId: enclosingTabId,
                    pageReference: {
                        "type": "standard__component",
                        "attributes": {
                            "componentName": "c__SAE_MisdirectComponent"
                        },
                        "state": {
                            "c__originatorName": originatorName,
                            "c__originatorType": "",
                            "c__contactName": flowDetails.contactName,
                            "c__contactNumber": flowDetails.contactNumber,
                            "c__subjectName": !$A.util.isEmpty(memberDetails) ? memberDetails[0].firstName + ' ' + memberDetails[0].lastName : "",
                            "c__subjectType": "Member",
                            "c__subjectDOB": !$A.util.isEmpty(memberDetails) ? memberDetails[0].dob : "",
                            "c__subjectID": !$A.util.isEmpty(memberDetails) ? memberDetails[0].memberId : "",
                            "c__subjectGrpID": !$A.util.isEmpty(memberDetails) ? memberDetails[0].groupNumber : "",
                            "c__interactionID": interactionDetails.Id,
                            "c__mnf": !$A.util.isEmpty(memberDetails) ? (memberDetails[0].isMemberNotFound ? "mnf" : "") : "",
                            "c__isMms": false,
                            "c__contactUniqueId": interactionDetails.Id,
                            "c__focusedTabId": enclosingTabId
                        }
                    }
                }).then(function (subtabId) {
                    workspaceAPI.setTabLabel({
                        tabId: subtabId,
                        label: "Misdirect"
                    });
                    workspaceAPI.setTabIcon({
                        tabId: subtabId,
                        icon: "standard:decision",
                        iconAlt: "Misdirect"
                    });
                }).catch(function (error) {
                    console.log(error);
                });
            }
        });
    },
    
    showToastMessage: function (title, message, type, mode, duration) {
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
    
    //US2873801 - Genesys - Member Snapshot Page - Topic Integration - Sravan
    //US2880283 - Genesys - Provider Snapshot Page - Topic Integration - Sravan
    setTopicValue : function(component, event, helper){
        var flowDetails = component.get("v.flowDetails");
        if(!$A.util.isUndefinedOrNull(flowDetails) && !$A.util.isEmpty(flowDetails)){
            var isGenesys = flowDetails.isGenesys;
            if(isGenesys){
                component.set("v.isVCCD",true);
                component.set("v.VCCDQuestionType",flowDetails.GeneysysQuestionType);
                
            }
        }
        
    }
    
})