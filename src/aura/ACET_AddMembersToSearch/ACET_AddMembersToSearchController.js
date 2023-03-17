({
    doInit: function (cmp, event, helper) {
        helper.initializeMemberCardCount(cmp);
        helper.getStateOptions(cmp);
    },

    openMembersSelection: function (cmp, event, helper) {
        if (!cmp.get('v.showMembersSelction')) {
            cmp.set('v.showMembersSelction', true);
            cmp.find("numbersId").set("v.value", "1");
        }
        $A.util.removeClass(cmp.find("hideNumberSelctions"), "slds-hide");
    },

    resetMembersCard: function (cmp, event, helper) {
        cmp.set('v.showMembersSelction', false);
        helper.resetMembers(cmp, event, helper);
    },

    showMembers: function (cmp, event, helper) {
        helper.initializeMemberCard(cmp, event, helper);
        // US3204295 - Thanish - 5th Feb 2021 - this div is for auto scrolling when add member to search is done
        var end = document.getElementById(cmp.get("v.interactionOverviewTabId"));
        setTimeout(function () {
            if(!$A.util.isEmpty(end)){
                end.scrollIntoView({behavior: "smooth", block: "end"});
            }
        }, 100);
    },

    clickAdvanceSearch: function (cmp, event, helper) {
        var srcName = event.target.tabIndex;
        var addFields = cmp.get('v.addMembers');
        addFields[srcName].showAdvance = true;

        cmp.set('v.addMembers', addFields);
    },

    hideAdvanceSearch: function (cmp, event, helper) {
        var srcName = event.target.tabIndex;
        var addFields = cmp.get('v.addMembers');
        addFields[srcName].showAdvance = false;
        addFields[srcName].validationFlag = false;
        addFields[srcName].isSnagHit = false;
        cmp.set('v.addMembers', addFields);
    },

    handleMemberDetailsFindIND: function (cmp, event, helper) {
        JSON.parse(JSON.stringify(cmp.get("v.memberDetails")));
        var memberDetails = cmp.get("v.memberDetails");
        var addMembers = cmp.get("v.addMembers");
        for (var i = 0; i < addMembers.length; i++) {
            if (addMembers[i].row == memberDetails.row) {
                var rowNumber = addMembers[i].row;
                addMembers[i].enableContinueBtn = memberDetails.enableContinueBtn;
                cmp.set('v.addMembers', addMembers);
                setTimeout(function () {
                    var btn = cmp.find("continueBtnID");
                    if (Array.isArray(btn)) {
                        for (var k = 0; k < btn.length; k++) {
                            if (btn[k].get("v.name") == rowNumber) {
                                btn[k].focus();
                            }
                        }
                    } else {
                        if (btn != undefined) {
                            btn.focus();
                        }
                    }
                }, 500);
            }
        }
    },

    handleChangeMNF: function (cmp, event, helper) {
        var source = event.getSource();
        var cardNo = source.get('v.name');
        if (!source.get('v.checked')) {
            var mandatoryFields = ["memFirstNameId", "memLastNameId", "stateMemId", "phoneId"];
            helper.validateAllFields(cmp, event, mandatoryFields, cardNo);
        }
    },

    onClickOfEnter: function (cmp, event, helper) {
        if (event.keyCode === 13 && event.target.className != 'linkField') {
            event.preventDefault();
            helper.executeMemberSearch(cmp, event);
        }
    },

    openSubjectCard: function (cmp, event, helper) {
        event.currentTarget.className
        var srcName;
        if (event.keyCode === 13) {
            srcName = event.currentTarget.className;
        } else {
            var source = event.getSource();
            srcName = source.get('v.name');
        }
        cmp.set('v.cardNumberError', srcName);
        helper.executeMemberSearch(cmp, event);
    },
    handleInteractionTabIDChange: function (cmp, event, helper) {
        var interactionOverviewTabId = cmp.get("v.interactionOverviewTabId");
        console.log(interactionOverviewTabId);
        var sessionData = _setAndGetSessionValues.getSessionData();
        cmp.set("v.interactionOverviewTabId", interactionOverviewTabId);
        var interactionOverviewData = _setAndGetSessionValues.getInteractionDetails(interactionOverviewTabId);
    },

    navigateToSnapshot: function (cmp, event, helper) {
        var interactionOverviewData = _setAndGetSessionValues.getInteractionDetails(cmp.get("v.interactionOverviewTabId"));
        JSON.parse(JSON.stringify(interactionOverviewData));
        for (var i = 0; i < interactionOverviewData.membersData.length; i++) {
            interactionOverviewData.membersData[i].dob = $A.localizationService.formatDate(interactionOverviewData.membersData[i].dob, "MM/dd/yyyy");
        }

        var providerDetails = cmp.get("v.providerDetails");
        JSON.parse(JSON.stringify(providerDetails));
        var interactionDetails = cmp.get("v.interactionDetails"); //interactionOverviewData.interactionDetails;
        var selectedCard = event.target.getAttribute("data-index");
        var selectedCardMemberType = event.target.getAttribute("data-memberType");
        var subjectCard;
        var mnfDetails;
        var memUniqueId;
        var houseHoldUnique;
        var mnf = "";
        if (selectedCardMemberType == "Searched Member") {
            subjectCard = cmp.get("v.addMembers")[selectedCard].subjectCard;
            memUniqueId = subjectCard.memberId + subjectCard.memberDOB + subjectCard.firstName;
            memUniqueId = memUniqueId.concat('_sub');
            houseHoldUnique = subjectCard.memberId + subjectCard.memberDOB + subjectCard.firstName + '_sub';
            var payerValue = cmp.get("v.addMembers")[selectedCard].payerObj.payerValue;
            subjectCard.payerID = payerValue;
			//blinker
            subjectCard.FISourceCode = subjectCard.SourceCode;
        } else if (selectedCardMemberType == "Member not found") {
            subjectCard = cmp.get("v.addMembers")[selectedCard];
            mnfDetails = {
                "mnfState": subjectCard.state,
                "mnfPhoneNumber": subjectCard.phoneAfterUpdate,
                "mnfMemberFN": subjectCard.firstName,
                "mnfMemberLN": subjectCard.lastName,
                "mnfDOB": subjectCard.dob
            };
            mnf = "mnf";
            memUniqueId = mnfDetails.mnfMemberFN + mnfDetails.mnfMemberLN + mnfDetails.mnfDOB;
            memUniqueId = memUniqueId.concat('_sub');
            houseHoldUnique = "";
        }

        //Checking for Opened Tabs
        var workspaceAPI = cmp.find("workspace");
        var matchingTabs = [];
        workspaceAPI.getAllTabInfo().then(function (response) {
            if (!$A.util.isEmpty(response)) {
                for (var i = 0; i < response.length; i++) {
                    for (var j = 0; j < response[i].subtabs.length; j++) {
                        if (response[i].subtabs.length > 0) {
                            var tabMemUniqueId = response[i].subtabs[j].pageReference.state.c__memberUniqueId;
                            if (memUniqueId === tabMemUniqueId) {

                                matchingTabs.push(response[i].subtabs[j]);
                                break;
                            } else {
                                console.log('NO MATCH!!');
                            }
                        } else {
                            console.log('FIRST SUB TAB');
                        }
                    }
                }
            }
            //Open Tab
            if (matchingTabs.length === 0) {
                var addMembers = cmp.get("v.addMembers");
                addMembers[selectedCard].isdelete = false;
                cmp.set("v.addMembers", addMembers);

                var interactionCard = {};
                interactionCard.firstName = cmp.get("v.providerDetails").firstName;
                interactionCard.lastName = cmp.get("v.providerDetails").lastName;
                interactionCard.npi = cmp.get("v.providerDetails").npi;
                if (!$A.util.isEmpty(providerDetails.phoneNumber)) {
                    var phoneNumber = providerDetails.phoneNumber;
                    if (!phoneNumber.includes("(")) {
                        phoneNumber = '(' + phoneNumber.substring(0, 3) + ') ' + phoneNumber.substring(3, 6) + '-' + phoneNumber.substring(6, 10);
                    }
                    interactionCard.phone = phoneNumber;
                }

                //interactionCard.phone = cmp.get("v.providerDetails").phoneNumber;
                interactionCard.primarySpeaciality = cmp.get("v.providerDetails").primarySpeciality;
                interactionCard.providerId = cmp.get("v.providerDetails").providerId;
                interactionCard.providerType = cmp.get("v.providerDetails").filterType;
                interactionCard.filterType = cmp.get("v.providerDetails").filterType;
                interactionCard.state = cmp.get("v.providerDetails").state;
                interactionCard.taxId = cmp.get("v.providerDetails").taxId;
                interactionCard.taxIdOrNPI = cmp.get("v.providerDetails").taxId;
                interactionCard.zip = cmp.get("v.providerDetails").zip;
                interactionCard.contactName = cmp.get("v.flowDetails").contactName;
                interactionCard.contactNumber = cmp.get("v.flowDetails").contactNumber;
                interactionCard.contactExt = cmp.get("v.flowDetails").contactExt;
                interactionCard.conName = cmp.get("v.flowDetails").contactName;
                interactionCard.contactType = cmp.get("v.providerDetails").contactType;
                interactionCard.conNumber = cmp.get("v.flowDetails").contactNumber;
                interactionCard.otherConExt = cmp.get("v.flowDetails").contactExt;
                interactionCard.corpMpin = cmp.get("v.providerDetails").corpMPIN;
                interactionCard.addressLine1 = cmp.get("v.providerDetails").addressLine1;
                interactionCard.addressLine2 = cmp.get("v.providerDetails").addressLine2;
                interactionCard.degreeCode = cmp.get("v.providerDetails").degreeCode;
                interactionCard.tpsmIndicator = cmp.get("v.providerDetails").tpsmIndicator;

                workspaceAPI.getEnclosingTabId().then(function (enclosingTabId) {
                    workspaceAPI.openSubtab({
                        parentTabId: enclosingTabId,
                        pageReference: {
                            "type": "standard__component",
                            "attributes": {
                                "componentName": "c__SAE_SnapshotOfMemberAndPolicies"
                            },
                            "state": {
                                "c__interactionOverviewTabId": cmp.get("v.interactionOverviewTabId"), //DE364195 - Avish
                                "c__interactionCard": interactionCard,
                                "c__contactName": cmp.get("v.flowDetails").contactName,
                                "c__memberUniqueId": memUniqueId,
                                "c__interactionRecord": interactionDetails,
                                "c__searchOption": mnf == "mnf" ? "" : subjectCard.searchOption,
                                "c__mnf": mnf,
                                "c__subjectCard": mnf == "mnf" ? mnfDetails : subjectCard,
                                // US1974034 - Thanish (Date: 21st Aug 2019) - Case creation member not found part 2
                                "c__houseHoldUnique": houseHoldUnique,
                                "c__providerNotFound": cmp.get("v.providerDetails").isProviderNotFound,
                                "c__isProviderSearchDisabled": cmp.get("v.providerDetails").isNoProviderToSearch,
                                "c__isAdditionalMemberIndividualSearch": cmp.get("v.isIndividualSearchOpenSnapshotPage"),
                                "c__hipaaEndpointUrl": cmp.get("v.hipaaEndpointUrl"), //DE347358 fix - Sravan
                                "c__isOtherSearch": false,
                                "c__providerDetails": providerDetails,
                                "c__providerDetailsForRoutingScreen": cmp.get("v.providerDetails"), //DE34738 - Praveen - 15/07/2020
                                "c__flowDetailsForRoutingScreen": cmp.get("v.flowDetails"),
                                "c__memberEmails" : addMembers[selectedCard].emails
                            }
                        },
                        focus: !event.ctrlKey
                    }).then(function (subtabId) {

                        var memberFN = "";
                        if (mnf == 'mnf') {
                            memberFN = mnfDetails.mnfMemberFN
                        } else {
                            memberFN = subjectCard.firstName;
                        }
                        var tabLabel = memberFN.charAt(0).toUpperCase() + memberFN.slice(1).toLowerCase();
                        workspaceAPI.setTabLabel({
                            tabId: subtabId,
                            label: tabLabel
                        });
                        workspaceAPI.setTabIcon({
                            tabId: subtabId,
                            icon: "custom:custom38",
                            iconAlt: "Snapshot"
                        });
                    }).catch(function (error) {
                        console.log(error);
                    });
                });
            } else {
                console.log('##ML:SUB_NOT-OPEN');
                var focusTabId = matchingTabs[0].tabId;
                var tabURL = matchingTabs[0].url;

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

    deleteCard: function (cmp, event, helper) {
        var source = event.getSource();
        var srcName = source.get('v.name');
        var addMembers = cmp.get('v.addMembers');
        var searchedMember = addMembers[srcName];
        _setAndGetSessionValues.removeMember(cmp.get("v.interactionOverviewTabId"), addMembers[srcName]);
        if (addMembers[srcName].showCard) {
            addMembers.splice(srcName, 1);
            for (var i = 0; i < addMembers.length; i++) {
                if (i != addMembers[i].row) {
                    addMembers[i].row = i;
                }
            }
            if (addMembers.length == 0) {
                cmp.set('v.showSections', false);
                $A.util.addClass(cmp.find("hideNumberSelctions"), "slds-hide");
                cmp.set('v.showMembersSelction', "");
                cmp.set('v.showSections', false);
                cmp.set('v.addMembers', []);
                cmp.set('v.isMms', false);
            } else {
                cmp.set("v.addMembers", addMembers);
                cmp.set("v.showSections", false);
                cmp.set("v.showSections", true);
            }
            cmp.set("v.addMembers", addMembers);
            cmp.set("v.memberDetails", "");
        }
    },

    handleOnChange: function (cmp, event, helper) {
        var eventSource = event.getSource();
        var fieldName = eventSource.get("v.name");
        var fieldValue = eventSource.get("v.value");
        if (fieldName == "phoneNumber") {
            helper.keepOnlyDigits(cmp, event);
        }
    },

    onChangeMemberID: function (cmp, event, helper) {
        var source = event.getSource();
        var srcName = source.get('v.name');
        helper.checkIfNotNumberMember(cmp, event, srcName);
    },

    clearCard: function (cmp, event, helper) {
        helper.clearMemberCardInputs(cmp, event, helper);
    },

    onChangePhone: function (cmp, event, helper) {
        var source = event.getSource();
        var srcName = source.get('v.name');
        helper.checkIfNotNumberPhone(cmp, event, srcName);
    },

    onChangeZipCode: function (cmp, event, helper) {
        var source = event.getSource();
        var srcName = source.get('v.name');
        helper.keepOnlyDigits(cmp, event, srcName);
    },

    resetMembersCardHandler: function (cmp, event, helper) {
        helper.resetMembers(cmp, event, helper);
    },

    showMembersHandler: function (cmp, event, helper) {
        helper.initializeMemberCard(cmp, event, helper);
    },

    numberOnchangehandler: function (cmp, event, helper) {
        var optionvalue = cmp.find("numbersId").get("v.value");
        console.log("optionvalue: " + optionvalue);
        cmp.set("v.optionValue", optionvalue);
    },
})