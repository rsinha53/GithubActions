({
    initializeMemberDetails: function (cmp) {
        var memberDetails = {
            "calloutMemberNotFound": false,
            //"disableMemberCard": false,
            "dob": "",
            "firstName": "",
            "groupNumber": "",
            "isAdvancedSearch": false,
            "isFindIndividualSearch": false,
            "isMemberNotFound": false,
            "isNoMemberToSearch": false,
            "isValidMember": false,
            "lastName": "",
            "memberId": "",
            "memberUniqueId": "",
            "phoneNumber": "",
            "payerId": "87726",
            "searchOption": "",
            "state": "",
            "zip": "",
            "ssn": "",
            "FISourceCode": ""
        };
        cmp.set("v.memberDetails", memberDetails);
        cmp.find('dobAI').set("v.value", "");

    },

    checkValidation: function (cmp, event) {
        var validationErrorFieldsList = [];
        var memberDetails = cmp.get("v.memberDetails");
        var validationSuccess = false;
        var memberFieldsToValidate = cmp.get("v.memberFieldsToValidate");
        var validationCounter = 0;
        // Combination checking
        var isCombinationValid = false;
        if (memberDetails.isAdvancedSearch) {
            if (!$A.util.isEmpty(memberDetails.memberId) && !$A.util.isEmpty(memberDetails.dob)) {
                isCombinationValid = true;
            } else if (!$A.util.isEmpty(memberDetails.memberId) && !$A.util.isEmpty(memberDetails.dob) && !$A.util.isEmpty(memberDetails.firstName) && !$A.util.isEmpty(memberDetails.lastName)) {
                isCombinationValid = true;
            } else if (!$A.util.isEmpty(memberDetails.memberId) && !$A.util.isEmpty(memberDetails.firstName) && !$A.util.isEmpty(memberDetails.lastName)) {
                isCombinationValid = true;
            } else if (!$A.util.isEmpty(memberDetails.memberId) && !$A.util.isEmpty(memberDetails.firstName) && !$A.util.isEmpty(memberDetails.dob)) {
                isCombinationValid = true;
            } else if (!$A.util.isEmpty(memberDetails.memberId) && !$A.util.isEmpty(memberDetails.dob) && !$A.util.isEmpty(memberDetails.lastName)) {
                isCombinationValid = true;
            } else if (!$A.util.isEmpty(memberDetails.firstName) && !$A.util.isEmpty(memberDetails.dob) && !$A.util.isEmpty(memberDetails.lastName)) {
                isCombinationValid = true;
            } else {
                isCombinationValid = false;
            }
        } else {
            isCombinationValid = true;
        }

        if(memberDetails.isAdvancedSearch) {
            let mapOfStateandCodes = cmp.get("v.mapOfStateandCodes");
            var strStateValue = cmp.find('StateAI').find('StateAI').find('comboboxFieldAI').get("v.value");
            if(strStateValue == '' || strStateValue == null || strStateValue == 'undefined' || strStateValue == 'Select') {
                cmp.set("v.memberDetails.state", '');
            } else {
                cmp.set("v.memberDetails.state", mapOfStateandCodes.get(strStateValue));
            }
        }

        for (var i in memberFieldsToValidate) {
            if(memberFieldsToValidate[i] === 'StateAI') {
                if(cmp.get("v.memberDetails.isMemberNotFound") && memberDetails.isAdvancedSearch && (cmp.get("v.memberDetails.state") == '' || cmp.get("v.memberDetails.state") == null || cmp.get("v.memberDetails.state") == 'undefined')) {
                    validationCounter++;
                    validationErrorFieldsList.push('State');
                    cmp.find("StateAI").find('StateAI').checkValidation();
                    cmp.find('StateAI').find('StateAI').find('comboboxFieldAI').reportValidity();
                }
            } else {
                var fieldElement = cmp.find(memberFieldsToValidate[i]);
                if (!$A.util.isUndefined(fieldElement)) {
                    if (!fieldElement.checkValidity()) {
                        validationCounter++;
                        validationErrorFieldsList.push(fieldElement.get("v.label"));
                    }
                    fieldElement.reportValidity();
                }
            }
        }
        if (memberDetails.isAdvancedSearch) {
            // Wildcard Validation
            var firstNameCmp = cmp.find("firstNameAI");
            var lastNameCmp = cmp.find("lastNameAI");
            if (firstNameCmp.get("v.value") != null) {
                if (!this.validateNamesWildCard(firstNameCmp, 3, cmp.get("v.firstNameErrorMessage"))) {
                    validationCounter++;
                }
            }
            if (lastNameCmp.get("v.value") != null) {
                if (!this.validateNamesWildCard(lastNameCmp, 4, cmp.get("v.lastNameErrorMessage"))) {
                    validationCounter++;
                }
            }
        }
        if (!isCombinationValid) {
            validationErrorFieldsList.push("Member Id or DOB + First Name + Last Name");
            this.showValidationErrorMessage(cmp, validationErrorFieldsList);
            return false;
        }
        if (validationCounter == 0) {
            // all fields format and data is valid
            validationSuccess = true;
        }
        this.showValidationErrorMessage(cmp, validationErrorFieldsList);
        return validationSuccess;
    },

    validateNamesWildCard: function (inputCmp, charlength, errorMessage) {
        var charString = inputCmp.get("v.value");
        var lastchar = charString[charString.length - 1];
        if ((charString.match(/[*]/g) || []).length > 1) {
            inputCmp.setCustomValidity(errorMessage);
            inputCmp.reportValidity();
            return false;
        } else if (lastchar == "*" && charString.length < charlength) {
            inputCmp.setCustomValidity(errorMessage);
            inputCmp.reportValidity();
            return false;
        } else if (charString.includes("*") && lastchar != "*" && charString.length >= charlength) {
            inputCmp.setCustomValidity(errorMessage);
            inputCmp.reportValidity();
            return false;
        } else {
            inputCmp.setCustomValidity("");
            inputCmp.reportValidity();
            return true;
        }
    },

    showValidationErrorMessage: function (cmp, descriptionList) {
        if (!$A.util.isEmpty(descriptionList)) {
            // populate error
            var error = {};
            error.message = "We hit a snag.";
            error.topDescription = "Search criteria must include";
            error.descriptionList = descriptionList;
            error.bottomDescription = "additional fields may be included to help narrow results";
            cmp.set("v.error", error);
            cmp.set("v.showErrorMessage", true);
            // expand the error popup
            var errorcmp = cmp.find("errorPopup");
            if ($A.util.isArray(errorcmp)) {
                errorcmp = errorcmp[0];
            }
            setTimeout(function () {
                errorcmp.showPopup();
            }, 100);
        } else {
            cmp.set("v.showErrorMessage", false);
        }
    },

    clearFieldValues: function (cmp) {
        this.initializeMemberDetails(cmp);
        cmp.set("v.findIndividualSearchResults", null);
        cmp.set('v.isContactDetailsRequired', false);
    },

    clearFieldValidations: function (cmp) {
        //cmp.set("v.findIndividualSearchResults", null);
        cmp.set("v.showErrorMessage", false);
        var memberFieldsToValidate = cmp.get("v.memberFieldsToValidate");
        for (var i in memberFieldsToValidate) {
            if (memberFieldsToValidate[i] == 'StateAI') {
                cmp.set("v.memberDetails.state", "");
            } else {
                var fieldElement = cmp.find(memberFieldsToValidate[i]);
                if (!$A.util.isUndefined(fieldElement)) {
                    if (fieldElement.get("v.type") == "date") {
                        if ($A.util.isEmpty(fieldElement.get("v.value"))) {
                            fieldElement.set("v.value", $A.localizationService.formatDate(new Date(), "YYYY-MM-DD"));
                            fieldElement.setCustomValidity("");
                            fieldElement.reportValidity();
                            fieldElement.set("v.value", null);
                        } else {
                            fieldElement.reportValidity();
                        }
                    } else {
                        if ($A.util.isEmpty(fieldElement.get("v.value"))) {
                            fieldElement.set("v.value", "1");
                            fieldElement.setCustomValidity("");
                            fieldElement.reportValidity();
                            fieldElement.set("v.value", null);
                        } else {
                            fieldElement.reportValidity();
                        }
                    }
                }
            }
        }
    },

    executeMemberSearch: function (cmp, event) {
        //DE482480- Swapnil 08/25/2021
        if( this.checkProviderCardValidation(cmp, event) && (cmp.get('v.isContactDetailsInvalid')) ) {
            return;
        }
        cmp.set("v.selectedMemberSource", ""); //US2699880-Interaction Overview Page - Remove EEID & SSN Fields and Add 'Source Code' Field
        cmp.find("memberCardSpinnerAI").set("v.isTrue", true);
        var memberDetails = cmp.get("v.memberDetails");
        console.log(JSON.stringify(memberDetails));
        memberDetails.isValidMember = false;
        var selectedIndividualMemberDetails = cmp.get("v.selectedIndividualMemberDetails");

        // US3625646
        var blockMemberSources = cmp.get('v.blockMemberSources');
        var validationErrorFieldsList = [];
        if(blockMemberSources.includes(memberDetails.sourceSysCode)){
            validationErrorFieldsList.push('This Plan Type is not currently supported. This is a misdirected contact.');
            this.showValidationErrorMessage(cmp, validationErrorFieldsList);
            cmp.find("memberCardSpinnerAI").set("v.isTrue", false);
        }
        this.showValidationErrorMessage(cmp, validationErrorFieldsList);

        if ((event.keyCode == 13 && !$A.util.isUndefinedOrNull(selectedIndividualMemberDetails)) || (event.type == "click" && event.getSource().get("v.label") != "Continue")) {
            memberDetails.isFindIndividualSearch = false;
            cmp.set("v.findIndividualSearchResults", null);
        }
        var memDOB = cmp.find('dobAI').get('v.value');
        memberDetails.memberId = !$A.util.isEmpty(memberDetails.memberId) ? memberDetails.memberId.trim() : '';
        memberDetails.dob = !$A.util.isEmpty(memDOB) ? memDOB.trim() : '';
        memberDetails.firstName = !$A.util.isEmpty(memberDetails.firstName) ? memberDetails.firstName.trim().toUpperCase() : ''; // DE450628 - Krish - 4th June 2021
        memberDetails.lastName = !$A.util.isEmpty(memberDetails.lastName) ? memberDetails.lastName.trim().toUpperCase() : ''; // DE450628 - Krish - 4th June 2021
        memberDetails.groupNumber = !$A.util.isEmpty(memberDetails.groupNumber) ? memberDetails.groupNumber.trim() : '';
        memberDetails.emails = selectedIndividualMemberDetails ? (selectedIndividualMemberDetails.emailIds ? (
        selectedIndividualMemberDetails.emailIds.join('<br/>')) : '') : '';
            //!$A.util.isEmpty(memberDetails.emailIds) ? memberDetails.emailIds.join('<br/>'): '';
        cmp.set("v.memberDetails", memberDetails);
        var providerDetails = cmp.get("v.providerDetails");
        var flowDetails = cmp.get("v.flowDetails");
        // DE450628 - Krish - 4th June 2021 
        flowDetails.contactFirstName = !$A.util.isEmpty(flowDetails.contactFirstName) ? flowDetails.contactFirstName.toUpperCase() : '';
        flowDetails.contactLastName = !$A.util.isEmpty(flowDetails.contactLastName) ? flowDetails.contactLastName.toUpperCase() : '';
        flowDetails.contactName = !$A.util.isEmpty(flowDetails.contactName) ? flowDetails.contactName.toUpperCase() : '';
        providerDetails.firstName = !$A.util.isEmpty(providerDetails.firstName) ? providerDetails.firstName.toUpperCase() : '';
        providerDetails.lastName = !$A.util.isEmpty(providerDetails.lastName) ? providerDetails.lastName.toUpperCase() : '';

        //US2826419 - Avish
        var providernotFoundFlag = false;
        if (providerDetails.isProviderNotFound && !cmp.get("v.isMemSearchDisabledFromPrv")) {
            providernotFoundFlag = true;
        }

        if (!(providerDetails.isNoProviderToSearch || providerDetails.isOther || providerDetails.isValidProvider || providernotFoundFlag)) {
            var appEvent = $A.get("e.c:SAE_ProviderValidationFromMemberEvent");
            appEvent.setParams({
                "fireValidation": true
            });
            appEvent.fire();
            //US2826419 - Ends
            this.showToastMessage("We hit a snag", "Complete provider search.", "error", "dismissible", "10000");
            cmp.find("memberCardSpinnerAI").set("v.isTrue", false);
            return;
        }
        if (!(providerDetails.isNoProviderToSearch || providerDetails.isOther || providernotFoundFlag) && (flowDetails.conStartTime == "Select" || flowDetails.conEndTime == "Select")) {
            var appEvent = $A.get("e.c:SAE_ProviderValidationFromMemberEvent");
            appEvent.setParams({
                "fireValidation": true
            });
            appEvent.fire();
            this.showToastMessage("We hit a snag", "Complete Hours of Operation.", "error", "dismissible", "10000");
            cmp.find("memberCardSpinnerAI").set("v.isTrue", false);
            return;
        }
        if (this.checkValidation(cmp, event)) {
            if (!memberDetails.isAdvancedSearch && (event.type == "click" && event.getSource().get("v.label") != "Continue")) { // US3204295 - Thanish - 3rd Feb 2021
                var selectedProviderDetails = this.getProviderDetails(cmp, event);
                this.searchMember(cmp, selectedProviderDetails, memberDetails, null);
            } else {
                this.openInteractionOverview(cmp, event);
            }
        } else {
            cmp.find("memberCardSpinnerAI").set("v.isTrue", false);
        }
    },

    openInteractionOverview: function (cmp, event) {
        //US2699880-Interaction Overview Page - Remove EEID & SSN Fields and Add 'Source Code' Field
        var selectedIndividualMemberDetails = cmp.get("v.selectedIndividualMemberDetails");
        if (!$A.util.isUndefinedOrNull(selectedIndividualMemberDetails) && !$A.util.isUndefinedOrNull(selectedIndividualMemberDetails.sourceSysCode)) {
            cmp.set("v.selectedMemberSource", selectedIndividualMemberDetails.sourceSysCode);
        }
        var flowDetails = cmp.get("v.flowDetails");
        var providerDetails = cmp.get("v.providerDetails");
        var memberDetails = cmp.get("v.memberDetails");
        var selectedProviderDetails = this.getProviderDetails(cmp, event);
        var selectedMemberDetails;
        if (memberDetails.isNoMemberToSearch || memberDetails.isMemberNotFound) {
            selectedMemberDetails = this.getMemberDetails(cmp, null);
        }
        var oldMembersData;

        if (providerDetails.isNoProviderToSearch) {
            var noProviderFoundTabNo = cmp.get("v.noProviderFoundTabNo");
            var interactionOverviewTabId;
            for (var i = 1; i <= noProviderFoundTabNo; i++) {
                interactionOverviewTabId = "NoProviderToSearch" + i;
                if (this.checkDuplicateMember(cmp, interactionOverviewTabId, i == noProviderFoundTabNo ? true : false)) {
                    if (memberDetails.isNoMemberToSearch || memberDetails.isMemberNotFound) {
                        noProviderFoundTabNo++;
                        cmp.set("v.noProviderFoundTabNo", noProviderFoundTabNo);
                    }
                    break;
                }
            }
        } else if (providerDetails.isProviderNotFound) {
            var interactionOverviewTabId = "ProviderNotFound" + providerDetails.taxIdOrNPI;
            this.checkDuplicateMember(cmp, interactionOverviewTabId, false);
        } else if (providerDetails.isValidProvider) {
            var interactionOverviewTabId = selectedProviderDetails.taxId;
            this.checkDuplicateMember(cmp, interactionOverviewTabId, false);
        } else if (providerDetails.isOther) {
            var interactionOverviewTabId = flowDetails.contactName; //US2330408  - Avish
            this.checkDuplicateMember(cmp, interactionOverviewTabId, false);
        }
    },

    checkDuplicateMember: function (cmp, interactionOverviewTabId, lastIteration) {
        var flowDetails = cmp.get("v.flowDetails");
        var providerDetails = cmp.get("v.providerDetails");
        var memberDetails = cmp.get("v.memberDetails");
        var selectedIndividualMemberDetails = cmp.get("v.selectedIndividualMemberDetails");
        if (memberDetails.isFindIndividualSearch) {
            memberDetails = {
                "memberId": memberDetails.memberId,
                "firstName": selectedIndividualMemberDetails.firstName,
                "lastName": selectedIndividualMemberDetails.lastName,
                "dob": selectedIndividualMemberDetails.birthDate,
                "payerId": memberDetails.payerId,
                "isAdvancedSearch": true, // US3204295 - Thanish - 3rd Feb 2021
                "sourceCode": selectedIndividualMemberDetails.sourceSysCode
            }
        }
        var selectedProviderDetails = this.getProviderDetails(cmp, event);
        var selectedMemberDetails;
        if (memberDetails.isNoMemberToSearch || memberDetails.isMemberNotFound) {
            selectedMemberDetails = this.getMemberDetails(cmp, null);
        }
        var oldMembersData;
        var interactionOverviewData = _setAndGetSessionValues.getInteractionDetails(interactionOverviewTabId);
        var searchedMember = false;
        if (!$A.util.isEmpty(interactionOverviewData)) {
            if (memberDetails.isNoMemberToSearch) {
                searchedMember = true;
            } else {
                oldMembersData = interactionOverviewData.membersData;
                memberDetails.firstName = $A.util.isEmpty(memberDetails.firstName) ? "" : memberDetails.firstName;
                memberDetails.lastName = $A.util.isEmpty(memberDetails.lastName) ? "" : memberDetails.lastName;
                for (var oldMemberDetails of oldMembersData) {
                    oldMemberDetails.firstName = $A.util.isEmpty(oldMemberDetails.firstName) ? "" : oldMemberDetails.firstName;
                    oldMemberDetails.lastName = $A.util.isEmpty(oldMemberDetails.lastName) ? "" : oldMemberDetails.lastName;
                    if (memberDetails.isMemberNotFound) {
                        if (memberDetails.firstName.toUpperCase() == oldMemberDetails.firstName.toUpperCase() && memberDetails.lastName.toUpperCase() == oldMemberDetails.lastName.toUpperCase() && $A.localizationService.formatDate(memberDetails.dob, "MM/dd/yyyy") == oldMemberDetails.dob) {
                            searchedMember = true;
                            break;
                        }
                    } else {
                        if ((memberDetails.memberId == oldMemberDetails.memberId && $A.localizationService.formatDate(memberDetails.dob, "MM/dd/yyyy") == oldMemberDetails.dob) ||
                            (memberDetails.firstName.toUpperCase() == oldMemberDetails.firstName.toUpperCase() && memberDetails.lastName.toUpperCase() == oldMemberDetails.lastName.toUpperCase() && $A.localizationService.formatDate(memberDetails.dob, "MM/dd/yyyy") == oldMemberDetails.dob) ||
                            (memberDetails.memberId == oldMemberDetails.memberId && memberDetails.firstName.toUpperCase() == oldMemberDetails.firstName.toUpperCase() && memberDetails.lastName.toUpperCase() == oldMemberDetails.lastName.toUpperCase())) {
                            searchedMember = true;
                            break;
                        }
                    }
                }
            }
            _setAndGetSessionValues.updateProviderDetails(interactionOverviewTabId, selectedProviderDetails);
            _setAndGetSessionValues.updateFlowDetails(interactionOverviewTabId, flowDetails);
            if (searchedMember) {
                this.checkSourceCode(cmp, memberDetails.sourceCode, interactionOverviewTabId);
                return true;
            } else if (!providerDetails.isNoProviderToSearch || lastIteration) {
                if (memberDetails.isNoMemberToSearch || memberDetails.isMemberNotFound) {

                    cmp.set('v.isContactDetailsRequired', true);
                    cmp.find("memberCardSpinnerAI").set("v.isTrue", false);
                    if (!this.checkValidation(cmp, event)) {
                        return false;
                    }

                    var interactionOverviewData = _setAndGetSessionValues.getInteractionDetails(interactionOverviewTabId);
                    var flowDetails = interactionOverviewData.flowDetails;

                    if ( ($A.util.isUndefinedOrNull(flowDetails.contactFirstName) || $A.util.isEmpty(flowDetails.contactFirstName)) ||
                          ($A.util.isUndefinedOrNull(flowDetails.contactLastName) || $A.util.isEmpty(flowDetails.contactLastName))) 
                    {
                        return false;
                    }

                    _setAndGetSessionValues.addNewMember(interactionOverviewTabId, selectedMemberDetails);
                    this.focusInteractionOverviewTab(cmp, interactionOverviewTabId);
                } else {
                    this.searchMember(cmp, selectedProviderDetails, memberDetails, interactionOverviewTabId);
                }
                return true;
            }
        } else {
            if (memberDetails.isNoMemberToSearch || memberDetails.isMemberNotFound) {

                cmp.set('v.isContactDetailsRequired', true);
                cmp.find("memberCardSpinnerAI").set("v.isTrue", false);
                if (!this.checkValidation(cmp, event)) {
                    return false;
                }

                _setAndGetSessionValues.setInteractionDetails(interactionOverviewTabId, flowDetails, selectedProviderDetails, selectedMemberDetails, null, null);
                this.openInteractionOverviewTab(cmp, interactionOverviewTabId);
            } else {
                this.searchMember(cmp, selectedProviderDetails, memberDetails, interactionOverviewTabId);
            }
            return true;
        }
        return false;
    },
    checkSourceCode: function(cmp, sourceCode, interactionOverviewTabId) {
        var action = cmp.get('c.getSupportedPlanType');
        action.setParams({
            "sourceCode": sourceCode
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state == 'SUCCESS') {
                var result = response.getReturnValue();
                if(!result) {
                    this.showToastMessage("We hit a snag.", "This Plan Type is not currently supported. This is a misdirected contact.", "error", "dismissible", "10000");
                    cmp.find("memberCardSpinnerAI").set("v.isTrue", false);
                } else {
                    cmp.set('v.isContactDetailsRequired', true);
                    cmp.find("memberCardSpinnerAI").set("v.isTrue", false);
                    if (!this.checkValidation(cmp, event)) {
                        return false;
                    }
                    this.focusInteractionOverviewTab(cmp, interactionOverviewTabId);
                }
            } else {
                this.showToastMessage("We hit a snag.", "This Plan Type is not currently supported. This is a misdirected contact.", "error", "dismissible", "10000");
                cmp.find("memberCardSpinnerAI").set("v.isTrue", false);
            }
        });
        $A.enqueueAction(action);
    },

    searchMember: function (cmp, selectedProviderDetails, memberDetails, interactionOverviewTabId) {
        var flowDetails = cmp.get("v.flowDetails");
        console.log(JSON.parse(JSON.stringify(selectedProviderDetails)));
        console.log(JSON.parse(JSON.stringify(memberDetails)));
        var action = cmp.get('c.getMemberDetails');
        action.setParams({
            "flowDetails": flowDetails,
            "providerDetails": selectedProviderDetails,
            "memberDetails": memberDetails
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            var result = response.getReturnValue(); // US3204295 - Thanish - 3rd Feb 2021
            if (state == 'SUCCESS') {
                if (result.isSuccess) {
                    if (result.statusCode == 200) {
                        // check find individual or valid member search
                        if (!memberDetails.isAdvancedSearch) { // US3204295 - Thanish - 3rd Feb 2021
                            var findIndividualSearchResults = [];
                            findIndividualSearchResults.push.apply(findIndividualSearchResults, result.response.lstSAEMemberStandaloneSearch);
                            if(result.response.lstSAEMemberStandaloneSearch && result.response.lstSAEMemberStandaloneSearch.length > 0 &&
                                result.response.lstSAEMemberStandaloneSearch[0].emailIds && result.response.lstSAEMemberStandaloneSearch[0].emailIds.length > 0) {
                                cmp.set("v.strEmails", result.response.lstSAEMemberStandaloneSearch[0].emailIds.join('<br/>'));
                            } else {
                                cmp.set("v.strEmails","");
                            }
                            console.log(JSON.parse(JSON.stringify(findIndividualSearchResults)));
                            if (!$A.util.isEmpty(findIndividualSearchResults)) {
                                cmp.set("v.findIndividualSearchResults", findIndividualSearchResults);
                            } else {
                                cmp.set("v.findIndividualSearchResults", null);
                            }
                        } else {
                            cmp.set("v.calloutMemberNotFound", false);
                            var memberSearchResponse = result.response;
                            cmp.set("v.memberDetails.isValidMember", true);
                            //DE343974 - Payer ID fetching as per the Member drop down value, not from the real time service - Durga - START
                            if (!$A.util.isUndefinedOrNull(memberSearchResponse) && !$A.util.isUndefinedOrNull(memberSearchResponse.policyandPayerMap) &&
                                !$A.util.isUndefinedOrNull(cmp.get("v.memberDetails"))) {
                                cmp.set("v.memberDetails.policyandPayerMap", memberSearchResponse.policyandPayerMap);
                            }
                            if (!$A.util.isUndefinedOrNull(memberSearchResponse) && !$A.util.isUndefinedOrNull(memberSearchResponse.searchQueryPayerId) &&
                                !$A.util.isUndefinedOrNull(cmp.get("v.memberDetails"))) {
                                cmp.set("v.memberDetails.searchQueryPayerId", memberSearchResponse.searchQueryPayerId);
                            }
                            //DE343974 - Payer ID fetching as per the Member drop down value, not from the real time service - Durga - END
                            //if (memberDetails.isValidMember) {
                            var noProviderFoundTabNo = cmp.get("v.noProviderFoundTabNo");
                            noProviderFoundTabNo++;
                            cmp.set("v.noProviderFoundTabNo", noProviderFoundTabNo);
                            //}
                            var selectedMemberDetails = this.getMemberDetails(cmp, memberSearchResponse);
                            var interactionOverviewData = _setAndGetSessionValues.getInteractionDetails(interactionOverviewTabId);

                            cmp.set('v.isContactDetailsRequired', true);
                            cmp.find("memberCardSpinnerAI").set("v.isTrue", false);
                            if (!this.checkValidation(cmp, event)) {
                                return false;
                            }

                            var appEvent = $A.get("e.c:SAE_ProviderValidationFromMemberEvent");
                            appEvent.setParams({
                                "fireValidation": true
                            });
                            appEvent.fire();

                            var flowDetails = cmp.get('v.flowDetails');
                            if ( $A.util.isUndefinedOrNull(flowDetails) || ($A.util.isUndefinedOrNull(flowDetails.contactFirstName) || $A.util.isEmpty(flowDetails.contactFirstName)) ||
                                  ($A.util.isUndefinedOrNull(flowDetails.contactLastName) || $A.util.isEmpty(flowDetails.contactLastName)))
                            {
                                return false;
                            }


                            if ($A.util.isUndefinedOrNull(interactionOverviewData) || $A.util.isEmpty(interactionOverviewData)) {
                                _setAndGetSessionValues.setInteractionDetails(interactionOverviewTabId, flowDetails, selectedProviderDetails, selectedMemberDetails, null, null);
                                this.openInteractionOverviewTab(cmp, interactionOverviewTabId);
                            } else {
                                _setAndGetSessionValues.addNewMember(interactionOverviewTabId, selectedMemberDetails);
                                this.focusInteractionOverviewTab(cmp, interactionOverviewTabId);
                            }
                        }
                    } else {
                        if (memberDetails.isAdvancedSearch && !($A.util.isEmpty(memberDetails.firstName) || $A.util.isEmpty(memberDetails.lastName))) {
                            cmp.set("v.calloutMemberNotFound", cmp.get("v.memberDetails.isAdvancedSearch"));
                        }
                        // US3204299: Member Search Shows No Results- Update
                        this.showToastMessage("We hit a snag.", result.message, "error", "dismissible", "30000");
                    }
                } else {
                    cmp.set("v.calloutMemberNotFound", cmp.get("v.memberDetails.isAdvancedSearch"));
                    this.showToastMessage("We hit a snag.", result.message, "error", "dismissible", "30000"); //US3020344 - Sravan
                }
            } else if (state == 'ERROR') {
                this.showToastMessage("We hit a snag.", result.message, "error", "dismissible", "30000");
            }
            cmp.find("memberCardSpinnerAI").set("v.isTrue", false);
        });
        $A.enqueueAction(action);
    },

    openInteractionOverviewTab: function (cmp, interactioOverviewTabUniqueId) {
        //cmp.find("memberCardSpinnerAI").set("v.isTrue", false);
        var workspaceAPI = cmp.find("workspace");
        var interactionOverviewData = _setAndGetSessionValues.getInteractionDetails(interactioOverviewTabUniqueId);
        var flowDetails = interactionOverviewData.flowDetails;

        if ( ($A.util.isUndefinedOrNull(flowDetails.contactFirstName) || $A.util.isEmpty(flowDetails.contactFirstName)) ||
              ($A.util.isUndefinedOrNull(flowDetails.contactLastName) || $A.util.isEmpty(flowDetails.contactLastName)))
        {
            return false;
        } // ($A.util.isUndefinedOrNull(flowDetails.contactNumber) || $A.util.isEmpty(flowDetails.contactNumber))

        var providerDetails = interactionOverviewData.providerDetails;
        var memberDetails = interactionOverviewData.membersData;
        //_setandgetvalues.setContactValue("exploreContactData", flowDetails.contactName, flowDetails.contactNumber);
        workspaceAPI.openTab({
            pageReference: {
                "type": "standard__component",
                "attributes": {
                    "componentName": "c__ACET_InteractionOverview"
                },
                "state": {
                    "c__interactioOverviewTabUniqueId": interactioOverviewTabUniqueId,
                    "c__isVCCD": cmp.get("v.isVCCD"), //US2631703 - Durga- 08th June 2020
                    "c__VCCDRespId": cmp.get("v.VCCDObjRecordId"), //US2631703 - Durga- 08th June 2020
                    "c__VCCDQuestionType": cmp.get("v.VCCDQuestionType"), //US2570805 - Sravan - 08/06/2020
                    "c__Code": cmp.get("v.selectedMemberSource"), //US2699880-Interaction Overview Page - Remove EEID & SSN Fields and Add 'Source Code' Field
                    "c__EmailAddress": cmp.get("v.strEmails") //Add Emails

                }
            },
            focus: true
        }).then(function (response) {
            workspaceAPI.getTabInfo({
                tabId: response
            }).then(function (tabInfo) {
                var focusedTabId = tabInfo.tabId;
                var tabName = "Interaction Overview";
                if (!$A.util.isEmpty(providerDetails.lastName)) {
                    tabName = providerDetails.lastName.charAt(0) + providerDetails.lastName.slice(1).toLowerCase();
                } else if (providerDetails.isOther) {
                    tabName = flowDetails.contactName.charAt(0) + flowDetails.contactName.slice(1).toLowerCase(); // DE450628 - Krish - 4th June 2021
                } else if (!$A.util.isEmpty(memberDetails[0].lastName)) {
                    tabName = memberDetails[0].lastName.charAt(0) + memberDetails[0].lastName.slice(1).toLowerCase();
                }
                workspaceAPI.setTabLabel({
                    tabId: focusedTabId,
                    label: tabName
                });
                workspaceAPI.setTabIcon({
                    tabId: focusedTabId,
                    icon: "standard:contact_list",
                    iconAlt: "Interaction Overview"
                });
            });
            cmp.find("memberCardSpinnerAI").set("v.isTrue", false);
        }).catch(function (error) {
            console.log(error);
        });
    },

    focusInteractionOverviewTab: function (cmp, interactioOverviewTabUniqueId) {
        //cmp.find("memberCardSpinnerAI").set("v.isTrue", false);

        var appEvent = $A.get("e.c:SAE_ProviderValidationFromMemberEvent");
        appEvent.setParams({
            "fireValidation": true
        });
        appEvent.fire();

        var workspaceAPI = cmp.find("workspace");
        var interactionOverviewData = _setAndGetSessionValues.getInteractionDetails(interactioOverviewTabUniqueId);
        _setAndGetSessionValues.updateFocusedCount(interactioOverviewTabUniqueId);
        var flowDetails = interactionOverviewData.flowDetails;

        if ( ($A.util.isUndefinedOrNull(flowDetails.contactFirstName) || $A.util.isEmpty(flowDetails.contactFirstName)) ||
              ($A.util.isUndefinedOrNull(flowDetails.contactLastName) || $A.util.isEmpty(flowDetails.contactLastName)))
        {
            return false;
        }  /* US3796055 Changes */

        var providerDetails = interactionOverviewData.providerDetails;
        var memberDetails = interactionOverviewData.membersData;
        var focusedTabId;
        var url;
        workspaceAPI.getAllTabInfo().then(function (response) {
                if (!$A.util.isEmpty(response)) {
                    for (var i = 0; i < response.length; i++) {
                        if (interactioOverviewTabUniqueId == response[i].pageReference.state.c__interactioOverviewTabUniqueId) {
                            url = response[i].url;
                            focusedTabId = response[i].tabId;
                            break;
                        }
                    }
                    workspaceAPI.openTab({
                        url: url,
                        focus: true
                    }).then(function (response) {
                        /* workspaceAPI.focusTab({
                            tabId: response
                        }); */
                        workspaceAPI.getTabInfo({
                            tabId: response
                        }).then(function (tabInfo) {
                            var focusedTabId = tabInfo.tabId;
                            var tabName = 'Interaction Overview';
                            if (!$A.util.isEmpty(providerDetails.lastName)) {
                                tabName = providerDetails.lastName.charAt(0) + providerDetails.lastName.slice(1).toLowerCase();
                            } else if (providerDetails.isOther) {
                                tabName = flowDetails.contactName;
                            } else if (!$A.util.isEmpty(memberDetails[0].lastName)) {
                                tabName = memberDetails[0].lastName.charAt(0) + memberDetails[0].lastName.slice(1).toLowerCase();
                            }
                            workspaceAPI.setTabLabel({
                                tabId: focusedTabId,
                                label: tabName
                            });
                            workspaceAPI.setTabIcon({
                                tabId: focusedTabId,
                                icon: "standard:contact_list",
                                iconAlt: "Interaction Overview : "
                            });
                        });
                        cmp.find("memberCardSpinnerAI").set("v.isTrue", false);
                    }).catch(function (error) {
                        console.log(error);
                    });
                }
            })
            .catch(function (error) {
                console.log(error);
            });
        /* // update interaction details when there is change in provider selected for same taxid
        var appEvent = $A.get("e.c:ACET_UpdateInteractionDetailsAppEvt");
        appEvent.setParams({
            "interactioOverviewTabUniqueId": interactioOverviewTabUniqueId
        });
        appEvent.fire(); */
    },

    // US2954656 - TECH - Submit the Authorization Summary & Confirmation Page: Provider Details - Integration - Sarma - 16/10/2020
    // Adding more attributes to provider to be passed to create SRN API
    getProviderDetails: function (cmp) {
        var flowDetails = cmp.get("v.flowDetails");
        var providerDetails = cmp.get("v.providerDetails");
        var selectedProviderDetails = {
            "addressId": "",
            "addressSequenceId": "",
            "isValidProvider": providerDetails.isValidProvider,
            "isProviderNotFound": providerDetails.isProviderNotFound,
            "isNoProviderToSearch": providerDetails.isNoProviderToSearch,
            "isOther": providerDetails.isOther,
            "isAdvancedSearch": providerDetails.isAdvancedSearch,
            "isPysician": false,
            "interactionType": "",
            "providerUniqueId": "",
            "providerId": "",
            "firstName": "",
            "lastName": "",
            "taxId": "",
            "npi": "",
            "filterType": "Both",
            "practicingStatus": "Active",
            "state": "",
            "zip": "",
            "phoneNumber": "",
            "contactType": "",
            "primarySpeciality": "",
            "corpMPIN": "",
            "tpsmIndicator": "",
            "addressLine1": "",
            "addressLine2": "",
            "degreeCode": "",
            "AddressCity": "",
            "EffectivePhoneNumber": "",
            "status": "", // US2330408  - Avish
            "businessName": "", // US2954656 - Sarma - start
            "acoID": "",
            "acoName": "",
            "countyName": "",
            "efficiencyOutcomeType": "",
            "middleName": "",
            "providerCategory": "",
            "providerEffectiveDate": "",
            "providerSeqNum": "",
            "providerTerminationDate": "",
            "qualityOutcomeType": "",
            "uhpdTierDemotInd": "",
            "zipSuffix": "",
            "providerIdentifier": "",
            "primarySpecialityType": "",
            "phoneNumberSRN": "",
            "providerContractOrgs" : "" // US3507490
        };
        // US2954656 - TECH - Submit the Authorization Summary & Confirmation Page: Provider Details - Integration - Sarma - 16/10/2020
        // Adding more provider details to be passed to create SRN API
        if (providerDetails.isValidProvider) {
            var spr = cmp.get("v.selectedProviderRecord");
            selectedProviderDetails.interactionType = providerDetails.interactionType;
            selectedProviderDetails.providerUniqueId = providerDetails.providerUniqueId;
            selectedProviderDetails.providerId = spr.physicianFacilityInformation.providerId;
            selectedProviderDetails.filterType = spr.physicianFacilityInformation.providerType;
            if (selectedProviderDetails.filterType == "Physician" || selectedProviderDetails.filterType == "P") {
                selectedProviderDetails.firstName = spr.physicianFacilityInformation.firstName;
                selectedProviderDetails.lastName = spr.physicianFacilityInformation.lastName;
                selectedProviderDetails.middleName = spr.physicianFacilityInformation.middleName;
                selectedProviderDetails.providerCategory = "P";
                if (!$A.util.isEmpty(spr.physicianFacilityInformation.taxId && !$A.util.isEmpty(spr.physicianFacilityInformation.taxId.corporateOwnerLastName))) {
                    selectedProviderDetails.businessName = spr.physicianFacilityInformation.taxId.corporateOwnerLastName;
                }

            } else if (selectedProviderDetails.filterType == "Facility" || selectedProviderDetails.filterType == "O") {
                selectedProviderDetails.lastName = spr.physicianFacilityInformation.facilityName;
                selectedProviderDetails.providerCategory = "H";
                selectedProviderDetails.businessName = spr.physicianFacilityInformation.facilityName;
            }
            selectedProviderDetails.taxId = spr.physicianFacilityInformation.taxId.taxId;
            selectedProviderDetails.corpMPIN = spr.physicianFacilityInformation.taxId.corpMPIN;
            if(!$A.util.isEmpty(providerDetails.npi)) {
                selectedProviderDetails.npi = providerDetails.npi;
            } else {
                selectedProviderDetails.npi = spr.physicianFacilityInformation.npi[0].npi;   
            }
            selectedProviderDetails.practicingStatus = providerDetails.practicingStatus;
            selectedProviderDetails.state = spr.physicianFacilityInformation.address.postalAddress.state;
            selectedProviderDetails.zip = spr.physicianFacilityInformation.address.postalAddress.zip;
            selectedProviderDetails.phoneNumber = spr.physicianFacilityInformation.phone[0].areaCode + spr.physicianFacilityInformation.phone[0].phoneNumber;
            selectedProviderDetails.phoneNumberSRN = selectedProviderDetails.phoneNumber;
            selectedProviderDetails.contactType = providerDetails.contactType;
            selectedProviderDetails.addressId = spr.physicianFacilityInformation.address.addressId;
            selectedProviderDetails.addressSequenceId = spr.physicianFacilityInformation.address.epdAddressSequenceId;
            selectedProviderDetails.tpsmIndicator = spr.physicianFacilityInformation.taxId.tpsm.tpsmInd;
            selectedProviderDetails.addressLine1 = spr.physicianFacilityInformation.address.postalAddress.addressLine1;
            selectedProviderDetails.addressLine2 = spr.physicianFacilityInformation.address.postalAddress.addressLine2;
            selectedProviderDetails.degreeCode = spr.physicianFacilityInformation.degrees.length > 0 ? spr.physicianFacilityInformation.degrees[0].degreeCode : "";
            //US2784325
            if (!$A.util.isUndefinedOrNull(spr.physicianFacilityInformation) &&
                !$A.util.isUndefinedOrNull(spr.physicianFacilityInformation.address) &&
                !$A.util.isUndefinedOrNull(spr.physicianFacilityInformation.address.postalAddress)) {
                if (!$A.util.isUndefinedOrNull(spr.physicianFacilityInformation.address.postalAddress.city)) {
                    selectedProviderDetails.AddressCity = spr.physicianFacilityInformation.address.postalAddress.city;
                }
                if (!$A.util.isUndefinedOrNull(spr.physicianFacilityInformation.address.postalAddress.county)) {
                    selectedProviderDetails.countyName = spr.physicianFacilityInformation.address.postalAddress.county;
                }
                if (!$A.util.isUndefinedOrNull(spr.physicianFacilityInformation.address.postalAddress.zip4)) {
                    selectedProviderDetails.zipSuffix = spr.physicianFacilityInformation.address.postalAddress.zip4;
                }
            }
            if (!$A.util.isUndefinedOrNull(spr.physicianFacilityInformation) &&
                (!$A.util.isUndefinedOrNull(spr.physicianFacilityInformation.phone) && !$A.util.isEmpty(spr.physicianFacilityInformation.phone))
            ) {
                for (var i = 0; i < spr.physicianFacilityInformation.phone.length; i++) {
                    var phoneInfo = spr.physicianFacilityInformation.phone[i];
                    if (!$A.util.isUndefinedOrNull(phoneInfo.primaryPhoneIndicator) &&
                        !$A.util.isUndefinedOrNull(phoneInfo.phoneNumber) && phoneInfo.primaryPhoneIndicator == 'P') {
                        selectedProviderDetails.EffectivePhoneNumber = phoneInfo.phoneNumber;
                    }
                }
            }
            // US3507490	Mapping for Contract Org Type and Amendment - Sarma - 20th May 2021
            let providerContractOrgs = new Array();
            let providerContractOrg = {
                "providerContractOrg" : []
            };
            if(!$A.util.isUndefinedOrNull(spr.physicianFacilityInformation) && !$A.util.isUndefinedOrNull(spr.physicianFacilityInformation.specialty) && spr.physicianFacilityInformation.specialty.length>0){


                let isPrimaryFound = false;
                // Specialty Contract Orgs

                for(let x=0 ; x < spr.physicianFacilityInformation.specialty.length; x++){
                    if(!$A.util.isUndefinedOrNull(spr.physicianFacilityInformation.specialty[x].specialtyContractOrg) && spr.physicianFacilityInformation.specialty[x].specialtyContractOrg.length>0){
                        for(let y=0; y<spr.physicianFacilityInformation.specialty[x].specialtyContractOrg.length;y++){
                            if(spr.physicianFacilityInformation.specialty[x].specialtyContractOrg[y].primaryCode == 'P'){
                                let providerContractOrgObject = {   "providerContractOrg" : spr.physicianFacilityInformation.specialty[x].specialtyContractOrg[y].contractOrgCode ,
                                                                    "providerContractContext" : "03",
                                                                    "providerContractOrgPriority" : spr.physicianFacilityInformation.specialty[x].specialtyContractOrg[y].primaryCode
                                                                };
                                providerContractOrgs.push(providerContractOrgObject);

                                if(!$A.util.isEmpty(spr.physicianFacilityInformation.specialty[x].specialty.name)){
                                    selectedProviderDetails.specialtyType = spr.physicianFacilityInformation.specialty[x].specialty.name;
                                }

                                if(!$A.util.isEmpty(spr.physicianFacilityInformation.specialty[x].specialty.name)){
                                    selectedProviderDetails.specialtyTypeDesc = spr.physicianFacilityInformation.specialty[x].specialty.value;
                                }

                                isPrimaryFound = true;
                                //break;
                            }

                        }
                    }
                    //if(isPrimaryFound){break;}
                }
                if(!isPrimaryFound && spr.physicianFacilityInformation.specialty.length > 0){
                    if(spr.physicianFacilityInformation.specialty[0].specialtyContractOrg.length>0){

                        for(let y=0; y<spr.physicianFacilityInformation.specialty[0].specialtyContractOrg.length;y++){
                            if(!$A.util.isEmpty(spr.physicianFacilityInformation.specialty[0].specialtyContractOrg[y].primaryCode) && spr.physicianFacilityInformation.specialty[0].specialtyContractOrg[y].primaryCode == 'S'){
                                let providerContractOrgObject = {   "providerContractOrg": spr.physicianFacilityInformation.specialty[0].specialtyContractOrg[y].contractOrgCode ,
                                                                    "providerContractContext": "03",
                                                                    "providerContractOrgPriority": spr.physicianFacilityInformation.specialty[0].specialtyContractOrg[y].primaryCode
                                                                };

                                providerContractOrgs.push(providerContractOrgObject);
                            }
                        }

                        if(!$A.util.isEmpty(spr.physicianFacilityInformation.specialty[0].specialty.name)){
                            selectedProviderDetails.primarySpecialityType = spr.physicianFacilityInformation.specialty[0].specialty.name;
                        }
                        if(!$A.util.isEmpty(spr.physicianFacilityInformation.specialty[0].specialty.value)){
                            selectedProviderDetails.primarySpeciality = spr.physicianFacilityInformation.specialty[0].specialty.value;
                        }
                    }
                }
                // Address contract orgs
                if (!$A.util.isUndefinedOrNull(spr.physicianFacilityInformation) &&
                !$A.util.isUndefinedOrNull(spr.physicianFacilityInformation.address) &&
                !$A.util.isUndefinedOrNull(spr.physicianFacilityInformation.address.addressContractOrg)) {
                    if(spr.physicianFacilityInformation.address.addressContractOrg.length > 0){

                        for(let x=0 ; x < spr.physicianFacilityInformation.address.addressContractOrg.length; x++){
                            let startDate = spr.physicianFacilityInformation.address.addressContractOrg[x].contrOrgEffDate;
                            let endDate = spr.physicianFacilityInformation.address.addressContractOrg[x].contrOrgCancDate;
                            if(!$A.util.isEmpty(startDate) && !$A.util.isEmpty(endDate) && startDate != '' && endDate != ''){
                                let startDateObj = Date.parse(startDate);
                                let endDateObj = Date.parse(endDate);
                                let today = new Date();
                                if(startDateObj <= today && today <= endDateObj){
                                    let providerContractOrgObject = {   "providerContractOrg": spr.physicianFacilityInformation.address.addressContractOrg[x].contractOrgCode,
                                                                        "providerContractContext": "01",
                                                                        "providerContractOrgPriority": spr.physicianFacilityInformation.address.addressContractOrg[x].primaryCode
                                                                    };
                                    providerContractOrgs.push(providerContractOrgObject);
                                    //break;
                                }
                            }
                        }
                    }
                }

                providerContractOrg.providerContractOrg = providerContractOrgs;
                selectedProviderDetails.providerContractOrgs = providerContractOrg;


            }
            // US3507490 Ends
            if (!$A.util.isUndefinedOrNull(spr.physicianFacilityInformation) && !$A.util.isUndefinedOrNull(spr.physicianFacilityInformation.contractInformation)) {
                if (!$A.util.isUndefinedOrNull(spr.physicianFacilityInformation.contractInformation.acoId)) {
                    selectedProviderDetails.acoID = spr.physicianFacilityInformation.contractInformation.acoId;
                }
                if (!$A.util.isUndefinedOrNull(spr.physicianFacilityInformation.contractInformation.acoName)) {
                    selectedProviderDetails.acoName = spr.physicianFacilityInformation.contractInformation.acoName;
                }
                if (!$A.util.isUndefinedOrNull(spr.physicianFacilityInformation.contractInformation.topsUhpdInd)) {
                    selectedProviderDetails.topsUhpdInd = spr.physicianFacilityInformation.contractInformation.topsUhpdInd;
                }
            }
            if (!$A.util.isUndefinedOrNull(spr.physicianFacilityInformation) && !$A.util.isUndefinedOrNull(spr.physicianFacilityInformation.qualityEfficiencyValues)) {
                if (!$A.util.isUndefinedOrNull(spr.physicianFacilityInformation.qualityEfficiencyValues.efficiencyRatingCode)) {
                    selectedProviderDetails.efficiencyOutcomeType = spr.physicianFacilityInformation.qualityEfficiencyValues.efficiencyRatingCode;
                }
                if (!$A.util.isUndefinedOrNull(spr.physicianFacilityInformation.qualityEfficiencyValues.qualityRatingCode)) {
                    selectedProviderDetails.qualityOutcomeType = spr.physicianFacilityInformation.qualityEfficiencyValues.qualityRatingCode;
                }
            }
            if (!$A.util.isUndefinedOrNull(spr.physicianFacilityInformation) && !$A.util.isUndefinedOrNull(spr.physicianFacilityInformation.providerEffectiveDate)) {
                selectedProviderDetails.providerEffectiveDate = spr.physicianFacilityInformation.providerEffectiveDate;
            }
            if (!$A.util.isUndefinedOrNull(spr.physicianFacilityInformation) && !$A.util.isUndefinedOrNull(spr.physicianFacilityInformation.providerCancelDate)) {
                selectedProviderDetails.providerTerminationDate = spr.physicianFacilityInformation.providerCancelDate;
            }
            let providerIdentifiers = new Array();

            let providerIdentifier = {
                "providerIdentifier": []
            };

            if (!$A.util.isUndefinedOrNull(spr.physicianFacilityInformation) && !$A.util.isUndefinedOrNull(spr.physicianFacilityInformation.taxId) && !$A.util.isUndefinedOrNull(spr.physicianFacilityInformation.taxId.taxId)) {
                let taxIdObject = {
                    "providerIDType": "03", //US3587915 - adding 0 prefix for type
                    "providerIDText": spr.physicianFacilityInformation.taxId.taxId
                };
                providerIdentifiers.push(taxIdObject);
            }
            if (!$A.util.isUndefinedOrNull(spr.physicianFacilityInformation) && !$A.util.isUndefinedOrNull(spr.physicianFacilityInformation.npi)) {
                if (spr.physicianFacilityInformation.npi.length > 0) {
                    if (!$A.util.isUndefinedOrNull(spr.physicianFacilityInformation.npi[0].npi)) {
                        let npiObject = {
                            "providerIDType": "06",
                            "providerIDText": spr.physicianFacilityInformation.npi[0].npi
                        };
                        providerIdentifiers.push(npiObject);
                    }
                }
            }
            //US3116511 - additional Identifiers for TTAP API - Sarma - 04/01/2021
            if (!$A.util.isUndefinedOrNull(spr.physicianFacilityInformation) && !$A.util.isUndefinedOrNull(spr.physicianFacilityInformation.providerId)) {
                let mpinObject = {
                    "providerIDType": "01",
                    "providerIDText": spr.physicianFacilityInformation.providerId
                };
                providerIdentifiers.push(mpinObject);
            }
            if (!$A.util.isUndefinedOrNull(spr.physicianFacilityInformation) && !$A.util.isUndefinedOrNull(spr.physicianFacilityInformation.address) && !$A.util.isUndefinedOrNull(spr.physicianFacilityInformation.address.epdAddressSequenceId)) {
                let addSeq = spr.physicianFacilityInformation.address.epdAddressSequenceId;
                addSeq = addSeq.replace(/^0+/, '');
                let addSeqObj = {
                    "providerIDType": "02",
                    "providerIDText": addSeq
                };
                providerIdentifiers.push(addSeqObj);
            }

            providerIdentifier.providerIdentifier = providerIdentifiers;
            selectedProviderDetails.providerIdentifiers = providerIdentifier;

            // US2954656 Ends
        } else if (providerDetails.isProviderNotFound) {
            selectedProviderDetails.interactionType = providerDetails.interactionType;
            selectedProviderDetails.providerUniqueId = providerDetails.providerUniqueId;
            selectedProviderDetails.firstName = providerDetails.firstName;
            selectedProviderDetails.lastName = providerDetails.lastName;
            selectedProviderDetails.taxId = providerDetails.taxIdOrNPI;
            selectedProviderDetails.npi = providerDetails.npi;
            selectedProviderDetails.filterType = providerDetails.filterType;
            selectedProviderDetails.practicingStatus = providerDetails.practicingStatus;
            selectedProviderDetails.state = providerDetails.state;
            selectedProviderDetails.zip = providerDetails.zip;
            selectedProviderDetails.phoneNumber = providerDetails.phoneNumber;
            selectedProviderDetails.contactType = providerDetails.contactTyp;
        } else if (providerDetails.isOther) {
            selectedProviderDetails.contactType = providerDetails.contactType;
        } else if (providerDetails.isNoProviderToSearch) {

        }
        return selectedProviderDetails;
    },

    getMemberDetails: function (cmp, memberSearchResponse) {
        var flowDetails = cmp.get("v.flowDetails");
        var memberDetails = cmp.get("v.memberDetails");
        var selectedMemberDetails = {
            "age": "",
            "dob": "",
            "eeId": "",
            "firstName": "",
            "gender": "",
            "groupNumber": "",
            "insuranceTypeCode": "",
            "isAdvancedSearch": memberDetails.isAdvancedSearch,
            "isFromExplore": true,
            "isFindIndividualSearch": memberDetails.isFindIndividualSearch,
            "isMemberNotFound": memberDetails.isMemberNotFound,
            "isNoMemberToSearch": memberDetails.isNoMemberToSearch,
            "isValidMember": memberDetails.isValidMember,
            "lastName": "",
            "memberId": "",
            "memberUniqueId": "",
            "phoneNumber": "",
            "payerId": memberDetails.payerId,
            "relationship": "",
            "searchOption": "",
            "ssn": "",
            "maskedSSN": "",
            "formattedSSN": "",
            "state": "",
            "zip": "",
            //DE343974 - Payer ID fetching as per the Member drop down value, not from the real time service - Durga
            "policyandPayerMap": memberDetails.policyandPayerMap,
            "searchQueryPayerId": memberDetails.searchQueryPayerId,
            "groupPanelNumber": "", // US2330408  - Avish
            "DIV": "", // US2330408  - Avish
            "policyName": "", // US2330408  - Avish
            "sourceCode": "", // US2330408  - Avish
            "FISourceCode": cmp.get("v.selectedMemberSource"),
            "emails" : memberDetails.emails
        };

        if (memberDetails.isMemberNotFound) {
            var dob;
            if (memberDetails.dob.includes("-")) {
                var splittedDOB = memberDetails.dob.split("-");
                dob = splittedDOB[1] + "/" + splittedDOB[2] + "/" + splittedDOB[0];
            } else {
                dob = memberDetails.dob;
            }
            selectedMemberDetails.dob = dob;
            selectedMemberDetails.age = 0;
            selectedMemberDetails.eeId = "";
            selectedMemberDetails.firstName = memberDetails.firstName;
            selectedMemberDetails.gender = "";
            selectedMemberDetails.groupNumber = "";
            selectedMemberDetails.insuranceTypeCode = "";
            selectedMemberDetails.lastName = memberDetails.lastName;
            //US3172545 - No Provider to Search to MNF - Sravan - Start
            selectedMemberDetails.memberId = memberDetails.memberId;
            //US3172545 - No Provider to Search to MNF - Sravan - End
            selectedMemberDetails.memberUniqueId = "";
            selectedMemberDetails.middleName = "";
            selectedMemberDetails.payerId = memberDetails.payerId;
            selectedMemberDetails.phoneNumber = memberDetails.phoneNumber;
            selectedMemberDetails.relationship = "";
            selectedMemberDetails.searchOption = "";
            selectedMemberDetails.ssn = "";
            selectedMemberDetails.formattedSSN = "";
            selectedMemberDetails.maskedSSN = "";
            selectedMemberDetails.state = memberDetails.state;
            selectedMemberDetails.zip = memberDetails.zip;
        } else if (memberDetails.isNoMemberToSearch) {

        } else if (memberDetails.isValidMember) {
            // valid member
            selectedMemberDetails.age = memberSearchResponse.age;
            //
            var dob;
            if (memberSearchResponse.dob.includes("-")) {
                var splittedDOB = memberSearchResponse.dob.split("-");
                dob = splittedDOB[1] + "/" + splittedDOB[2] + "/" + splittedDOB[0];
            } else {
                dob = memberSearchResponse.dob;
            }
            //
            selectedMemberDetails.dob = dob;
            selectedMemberDetails.eeId = memberSearchResponse.eeId;
            selectedMemberDetails.firstName = memberSearchResponse.firstName;
            selectedMemberDetails.gender = memberSearchResponse.gender;
            selectedMemberDetails.groupNumber = memberSearchResponse.groupNumber;
            selectedMemberDetails.insuranceTypeCode = memberSearchResponse.insuranceTypeCode;
            selectedMemberDetails.lastName = memberSearchResponse.lastName;
            selectedMemberDetails.memberId = memberSearchResponse.memberId;
            selectedMemberDetails.memberUniqueId = "";
            selectedMemberDetails.middleName = memberSearchResponse.middleName;
            selectedMemberDetails.payerId = memberSearchResponse.payerId;
            selectedMemberDetails.phoneNumber = "";
            selectedMemberDetails.relationship = memberSearchResponse.relationship;
            selectedMemberDetails.searchOption = memberSearchResponse.searchOption;
            selectedMemberDetails.ssn = memberSearchResponse.ssn;
            selectedMemberDetails.formattedSSN = memberSearchResponse.ssn.substring(0, 3) + '-' + memberSearchResponse.ssn.substring(3, 5) + '-' + memberSearchResponse.ssn.substring(5, 9);
            selectedMemberDetails.maskedSSN = 'xxx-xx-' + memberSearchResponse.ssn.substring(5, 9);
            selectedMemberDetails.state = "";
            selectedMemberDetails.emails = memberDetails.emails;
        }
        //US3612768 - Sravan  - Start
        cmp.set("v.selectedMemberDetails",selectedMemberDetails);
        //US3612768 - Sravan - End
        console.log('selected member details'+ JSON.stringify(selectedMemberDetails));
        return selectedMemberDetails;
    },

    keepOnlyDigits: function (cmp, event) {
        var regEx = /[^0-9 ]/g;
        var fieldValue = event.getSource().get("v.value");
        if (fieldValue.match(regEx)) {
            event.getSource().set("v.value", fieldValue.replace(regEx, ''));
        }
    },

    keepOnlyText: function (cmp, event) {
        var regEx = /[^a-zA-Z ]/g;
        var fieldValue = event.getSource().get("v.value");
        if (fieldValue.match(regEx)) {
            event.getSource().set("v.value", fieldValue.replace(regEx, ''));
            return fieldValue.replace(regEx, '');
        }
        return fieldValue;
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

    //DE482480- Swapnil 08/25/2021
    checkProviderCardValidation: function(cmp, event) {
        if( (event.type == "click" && event.getSource().get("v.label") == "Continue") || cmp.get("v.memberDetails.isAdvancedSearch" ) ) {
            var appEvent = $A.get("e.c:SAE_ProviderValidationFromMemberEvent");
            appEvent.setParams({
                "fireValidation": true
            });
            appEvent.fire();
            cmp.find("memberCardSpinnerAI").set("v.isTrue", false);
            return true;
        }
        return false;
    }

})