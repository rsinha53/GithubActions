({
    checkValidation: function (cmp, event) {
        $A.util.addClass(cmp.find("combinationErrorMsgAI"), "slds-hide");
        var validationSuccess = false;
        var memberFieldsToValidate = cmp.get("v.memberFieldsToValidate");
        var validationCounter = 0;
        for (var i in memberFieldsToValidate) {
            var fieldElement = cmp.find(memberFieldsToValidate[i]);
            if (!$A.util.isUndefined(fieldElement)) {
                if (!fieldElement.checkValidity()) {
                    validationCounter++;
                }
                fieldElement.reportValidity();
            }
        }
        if (validationCounter == 0) {
            // all fields format and data is valid
            validationSuccess = true;
            var memberDetails = cmp.get("v.memberDetails");
            if (cmp.get("v.isAdvancedSearch")) {
                if (!$A.util.isEmpty(memberDetails.dob) && !$A.util.isEmpty(memberDetails.memberId)) {
                    validationSuccess = true;
                } else if (!$A.util.isEmpty(memberDetails.dob) && !$A.util.isEmpty(memberDetails.firstName) && !$A.util.isEmpty(memberDetails.lastName)) {
                    validationSuccess = true;
                } else {
                    // validation error message beside search button
                    validationSuccess = false;
                    $A.util.removeClass(cmp.find("combinationErrorMsgAI"), "slds-hide");
                }
            }
        }
        return validationSuccess;
    },

    clearFieldValidations: function (cmp, event) {
        var memberFieldsToValidate = cmp.get("v.memberFieldsToValidate");
        for (var i in memberFieldsToValidate) {
            var fieldElement = cmp.find(memberFieldsToValidate[i]);
            if (!$A.util.isUndefined(fieldElement)) {
                if (fieldElement.get("v.type") == "date") {
                    if ($A.util.isEmpty(fieldElement.get("v.value"))) {
                        fieldElement.set("v.value", $A.localizationService.formatDate(new Date(), "YYYY-MM-DD"));
                        fieldElement.reportValidity();
                        fieldElement.set("v.value", null);
                    } else {
                        fieldElement.reportValidity();
                    }
                } else {
                    if ($A.util.isEmpty(fieldElement.get("v.value"))) {
                        fieldElement.set("v.value", "1");
                        fieldElement.reportValidity();
                        fieldElement.set("v.value", null);
                    } else {
                        fieldElement.reportValidity();
                    }
                }
            }
        }
    },

    clearFieldValues: function (cmp, event) {
        var memberDetails = cmp.get("v.memberDetails");
        memberDetails.showAdvance = false;
        memberDetails.memberId = "";
        memberDetails.dob = null;
        memberDetails.firstName = "";
        memberDetails.lastName = "";
        memberDetails.groupNumber = "";
        memberDetails.zip = "";
        memberDetails.phone = "";
        memberDetails.state = "";
        cmp.set("v.memberDetails", memberDetails)
    },

    checkDuplicateProviderOrMember: function (cmp, event) {
        var providerDetails = cmp.get("v.providerDetails");
        var memberDetails = cmp.get("v.memberDetails");
        var providerMembersSearched = cmp.get("v.providerMembersSearched");
        for (var i in providerMembersSearched) {
            if (providerMembersSearched[i].providerDetailsAlreadySearched.taxIdOrNPI == providerDetails.taxIdOrNPI &&
                providerMembersSearched[i].memberDetailsAlreadySearched.memberDOB == memberDetails.dob &&
                (providerMembersSearched[i].memberDetailsAlreadySearched.memberId == memberDetails.memberId ||
                    providerMembersSearched[i].memberDetailsAlreadySearched.memberName == memberDetails.firstName + "  " + memberDetails.lastName)) {
                this.showToastMessage("Information!", "Member already searched, focused on respective tab.", "warning", "dismissible", "10000");
                this.focusOnExistingTab(cmp, event, providerDetails.taxIdOrNPI);
                return false;
            }
        }
        return true;
    },

    focusOnExistingTab: function (cmp, event, taxIdOrNPI) {
        var existingTab;
        var workspaceAPI = cmp.find("workspace");
        workspaceAPI.getAllTabInfo().then(function (response) {
            if (!$A.util.isEmpty(response)) {
                for (var i = 0; i < response.length; i++) {
                    if (response[i].pageReference.attributes.componentName == "c__SAE_InteractionOverviewPage" &&
                        response[i].pageReference.state.c__providerTaxOrNPI == taxIdOrNPI) {
                        existingTab = response[i];
                    }
                }
            }
            workspaceAPI.openTab({
                url: existingTab.url
            }).then(function (response) {
                workspaceAPI.focusTab({
                    tabId: response
                });
            }).catch(function (error) {
                console.log(error);
            });
        })
    },

    searchMember: function (cmp, event) {
        var action = cmp.get('c.findMembers');
        var memberDetails = cmp.get("v.memberDetails");
        var searchOption = "";
        if (memberDetails.memberId != '' && (!$A.util.isEmpty(memberDetails.firstName)) && (!$A.util.isEmpty(memberDetails.lastName)) && (!$A.util.isEmpty(memberDetails.groupNumber)) && memberDetails.dob != '') {
            searchOption = 'MemberIDNameGroupNumberDateOfBirth';
        } else if (memberDetails.memberId != '' && (!$A.util.isEmpty(memberDetails.firstName)) && (!$A.util.isEmpty(memberDetails.lastName)) && memberDetails.dob != '') {
            searchOption = 'MemberIDNameDateOfBirth';
        } else if (memberDetails.memberId != '' && (!$A.util.isEmpty(memberDetails.firstName)) && (!$A.util.isEmpty(memberDetails.lastName))) {
            searchOption = 'MemberIDName';
        } else if (memberDetails.memberId != '' && (!$A.util.isEmpty(memberDetails.lastName)) && memberDetails.dob != '') {
            searchOption = 'MemberIDLastNameDateOfBirth';
        } else if (memberDetails.memberId != '' && (!$A.util.isEmpty(memberDetails.firstName)) && memberDetails.dob != '') {
            searchOption = 'MemberIDFirstNameDateOfBirth';
        } else if ((!$A.util.isEmpty(memberDetails.firstName)) && (!$A.util.isEmpty(memberDetails.lastName)) && memberDetails.dob != '') {
            searchOption = 'NameDateOfBirth';
        } else if (memberDetails.memberId != '' && memberDetails.dob != '') {
            searchOption = 'MemberIDDateOfBirth';
        }
        action.setParams({
            "memberId": memberDetails.memberId,
            "memberDOB": memberDetails.dob,
            "firstName": memberDetails.firstName,
            "lastName": memberDetails.lastName,
            "groupNumber": memberDetails.groupNumber,
            "searchOption": searchOption
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state == 'SUCCESS') {
                var result = response.getReturnValue();
                if (result.statusCode == 200) {
                    cmp.set("v.responseData", result);
                    cmp.set("v.interactionCard", result.resultWrapper.interactionView);
                    cmp.set("v.subjectCard", result.resultWrapper.subjectCard);
                    cmp.set("v.responseMemberNotFound", false);
                    this.openInteractionOverview(cmp, event, searchOption);
                } else if (result.statusCode == 400 && (searchOption == "NameDateOfBirth" || searchOption == "MemberIDDateOfBirth")) {
                    this.showToastMessage("Error!", result.message.replace(". ", ". \n"), "error", "dismissible", "10000");
                } else {
                    cmp.set("v.responseMemberNotFound", true);
                    this.showToastMessage("Error!", result.message, "error", "dismissible", "10000");
                }
            }
        });
        $A.enqueueAction(action);
    },

    openInteractionOverview: function (cmp, event, searchOption) {
        var providerDetails = cmp.get("v.providerDetails");
        var memberDetails = cmp.get("v.memberDetails");
        if (!memberDetails.memberNotFound) {
            var subjectCard = cmp.get('v.subjectCard');
            subjectCard.memberDOB = memberDetails.dob;
            var providerMembersSearched = cmp.get("v.providerMembersSearched");
            providerMembersSearched.push({
                providerDetailsAlreadySearched: JSON.parse(JSON.stringify(providerDetails)),
                memberDetailsAlreadySearched: subjectCard
            });
            cmp.set("v.providerMembersSearched", providerMembersSearched);
        }
        //Open Intreaction Overview Tab
        var matchingTabs = [];
        var workspaceAPI = cmp.find("workspace");
        workspaceAPI.getAllTabInfo().then(function (response) {
            if (!$A.util.isEmpty(response)) {
                for (var i = 0; i < response.length; i++) {
                    if (response[i].pageReference.attributes.componentName == "c__SAE_InteractionOverviewPage" &&
                        response[i].pageReference.state.c__providerTaxOrNPI == providerDetails.taxIdOrNPI) {
                        matchingTabs.push(response[i]);
                    }
                }
            }
            if (matchingTabs.length === 0) {
                workspaceAPI.openTab({
                    pageReference: {
                        "type": "standard__component",
                        "attributes": {
                            "componentName": "c__SAE_InteractionOverviewPage"
                        },
                        "state": {
                            "c__providerDetails": providerDetails,
                            "c__memberDetails": memberDetails,
                            "c__interactionCard": cmp.get('v.interactionCard'),
                            "c__subjectCard": cmp.get('v.subjectCard'),
                            "c__searchOption": searchOption,
                            "c__interactionRecord": "",
                            "c__interactionType": cmp.get("v.interactionType"),
                            "c__providerTaxOrNPI": providerDetails.taxIdOrNPI
                        }
                    },
                    focus: true
                }).then(function (response) {
                    workspaceAPI.getTabInfo({
                        tabId: response
                    }).then(function (tabInfo) {
                        var providerLName = cmp.get("v.interactionCard.providerLN");
                        var interactionOverviewTabLabel = "Interaction Overview";
                        if (!$A.util.isEmpty(providerLName)) {
                            interactionOverviewTabLabel = providerLName.charAt(0) + providerLName.slice(1).toLowerCase();
                        }
                        workspaceAPI.setTabLabel({
                            tabId: tabInfo.tabId,
                            label: interactionOverviewTabLabel
                        });
                        workspaceAPI.setTabIcon({
                            tabId: tabInfo.tabId,
                            icon: "standard:contact_list",
                            iconAlt: "Interaction Overview : "
                        });
                    });
                }).catch(function (error) {
                    console.log(error);
                });
            } else {
                var focusTabId = matchingTabs[0].tabId;
                var tabURL = matchingTabs[0].url;
                var appEvent = $A.get("e.c:SAE_SubjectCardAE");
                appEvent.setParams({
                    "subjectCard": subjectCard,
                    "searchedMember": "",
                    "memberNotFoundDetails": memberDetails
                });
                appEvent.fire();
                workspaceAPI.openTab({
                    url: tabURL
                }).then(function (response) {
                    workspaceAPI.focusTab({
                        tabId: response
                    });
                }).catch(function (error) {
                    console.log(error);
                });
            }
        })
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

    getStateValues: function (cmp) {
        var action = cmp.get('c.getStateValues');
        action.setCallback(this, function (actionResult) {
            var stateOptions = [];
            for (var i = 0; i < actionResult.getReturnValue().length; i++) {
                stateOptions.push({
                    label: actionResult.getReturnValue()[i].DeveloperName,
                    value: actionResult.getReturnValue()[i].DeveloperName
                });
            }
            stateOptions.unshift({
                label: '--None--',
                value: ''
            });
            cmp.set('v.stateOptions', stateOptions);
        });
        $A.enqueueAction(action);
    },

    keepOnlyDigits: function (cmp, event) {
        var regEx = /[^0-9 ]/g;
        var fieldValue = event.getSource().get("v.value");
        if (fieldValue.match(regEx)) {
            event.getSource().set("v.value", fieldValue.replace(regEx, ''));
        }
    },

})