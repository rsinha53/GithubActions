({
    initializeMemberCardCount: function (cmp) {
        var items = [];
        for (var i = 1; i < 21; i++) {
            var item = {
                "label": i,
                "value": i.toString(),
            };
            items.push(item);
        }
        cmp.set("v.numbers", items);
        cmp.set("v.selMemberChild", new Object());
    },

    initializeMemberCard: function (component, event, helper) {
        component.set('v.showSections', true);
        var addMem = component.get("v.addMembers");
        var memCardArray = [];
        var memberCard = 0;

        for (i in addMem) {
            if (addMem.length == 1) {
                if (!addMem[i].hasOwnProperty('row')) {
                    memberCard = 0;
                    addMem = [];
                    component.set('v.addMembers', addMem);
                }
                memberCard = 1;
                break;
            }

        }
        memberCard = addMem.length;
        //US2717679: Interaction Overview Page - Member Card Alignment
        if (event.getParam("numbers")) {
            var numberOfSections = event.getParam("numbers");
        } else {
            var numberOfSections = component.find('numbersId').get('v.value');
        }
        numberOfSections = parseInt(numberOfSections);
        var j = parseInt(numberOfSections) + parseInt(memberCard);
        var defaultPayerValue = component.get('v.defaultPayerValue');
        var defaultPayerLabel = component.get('v.defaultPayerLabel');

        for (var i = memberCard; i < j; i++) {
            var memberVar = {
                "row": i,
                "showCard": false,
                "showAdvance": false,
                "memberId": "",
                "dob": "",
                "firstName": "",
                "lastName": "",
                "groupNumber": "",
                "searchOption": "",
                "zip": "",
                "state": "",
                "phone": "",
                "phoneAfterUpdate": "",
                "isAdvancedSearch": false,
                "isFromExplore": false,
                "isFindIndividualSearch": false,
                "isMemberNotFound": false,
                "isNoMemberToSearch": false,
                "isValidMember": false,
                "subjectCard": "",
                "displayMNFFlag": false,
                "mnf": "",
                "mnfCheckBox": false,
                "fieldValidationFlag": false,
                "validationFlag": false,
                "mnfSubjectCard": false,
                "addMemberCard": true,
                "isClear": false,
                "isMultipleMemberResponse": false,
                "enableContinueBtn": false,
                "showDropDown": false,
                "selectedMemberDetails": "",
                "multipleMemberResponses": [],
                "mapError": [],
                "isdelete": false,
                "payerObj": {
                    "payerValue": defaultPayerValue,
                    "payerLabel": defaultPayerLabel,
                    "displayPayer": false,
                    "typeText": ""
                },
                "errorMessage": "",
                "topDescription": "",
                "descriptionList": [],
                "bottomDescription": "",
                "isSnagHit": false
            };
            addMem.push(memberVar);
        }
        component.set('v.addMembers', addMem);
        this.getStateValuesMDT(component, event);
    },

    openInteractionOverview: function (cmp, event, CardNo) {
        var interactionOverviewTabId = cmp.get("v.interactionOverviewTabId");
        this.checkDuplicateMember(cmp, interactionOverviewTabId, false, CardNo);
    },

    checkDuplicateMember: function (cmp, interactionOverviewTabId, lastIteration, CardNo) {
        var selectedIndividualMemberDetails = cmp.get("v.memberDetails");
        var addMembers = cmp.get('v.addMembers');
        var memberDetails = addMembers[CardNo];
        console.log(JSON.parse(JSON.stringify(selectedIndividualMemberDetails)));
        /*var selectedCard = cmp.get("v.selectedIndividualMemberDetails");
        console.log(JSON.parse(JSON.stringify(selectedCard)));*/
        if (addMembers[CardNo].isFindIndividualSearch) {
            memberDetails = {
                "memberId": addMembers[CardNo].memberId,
                "firstName": (selectedIndividualMemberDetails != null) ? selectedIndividualMemberDetails.firstName : "",
                "lastName": (selectedIndividualMemberDetails != null) ? selectedIndividualMemberDetails.lastName : "",
                "dob": selectedIndividualMemberDetails.birthDate,
                "payerId": addMembers[CardNo].payerObj.payerValue,
                "isAdvancedSearch": true, // US3204295 - Thanish - 5th Feb 2021
                "sourceCode": (selectedIndividualMemberDetails != null) ? selectedIndividualMemberDetails.sourceCode : ""
            }
        } else {
            var dob;
            if (addMembers[CardNo].dob.includes("-")) {
                var splittedDOB = addMembers[CardNo].dob.split("-");
                dob = splittedDOB[1] + "/" + splittedDOB[2] + "/" + splittedDOB[0];
            }
            memberDetails = {
                "memberId": addMembers[CardNo].memberId,
                "dob": dob,
                "payerId": addMembers[CardNo].payerObj.payerValue,
                "firstName": addMembers[CardNo].firstName,
                "lastName": addMembers[CardNo].lastName,
                "groupNumber": addMembers[CardNo].groupNumber,
                "isMemberNotFound": addMembers[CardNo].mnfCheckBox,
                "isNoMemberToSearch": addMembers[CardNo].isNoMemberToSearch,
                "isAdvancedSearch": true // US3204295 - Thanish - 5th Feb 2021
            }
        }

        var oldMembersData;
        var searchedMember = false;
        var interactionOverviewData = _setAndGetSessionValues.getInteractionDetails(interactionOverviewTabId);
        if (!$A.util.isEmpty(interactionOverviewData)) {
            if (memberDetails.isNoMemberToSearch) {
                searchedMember = true;
            } else {
                oldMembersData = interactionOverviewData.membersData;
                for (var k = 0; k < oldMembersData.length; k++) {
                    if ($A.util.isEmpty(oldMembersData[k].memberId) && $A.util.isEmpty(oldMembersData[k].dob) &&
                        $A.util.isEmpty(oldMembersData[k].firstName) && $A.util.isEmpty(oldMembersData[k].lastName)) {
                        oldMembersData.splice(k, 1);
                    }
                }
                for (var oldMemberDetails of oldMembersData) {
                    if (memberDetails.isMemberNotFound) {
                        if ((memberDetails.firstName.toUpperCase() == oldMemberDetails.firstName.toUpperCase() && memberDetails.lastName.toUpperCase() == oldMemberDetails.lastName.toUpperCase() && memberDetails.dob == oldMemberDetails.dob) ||
                            (memberDetails.memberId == oldMemberDetails.memberId && memberDetails.firstName.toUpperCase() == oldMemberDetails.firstName.toUpperCase() && memberDetails.lastName.toUpperCase() == oldMemberDetails.lastName.toUpperCase() && memberDetails.dob == oldMemberDetails.dob)) {
                            searchedMember = true;
                            break;
                        }
                    } else {
                        if ((memberDetails.memberId == oldMemberDetails.memberId && memberDetails.dob == oldMemberDetails.dob) ||
                            ((!$A.util.isEmpty(memberDetails.firstName) && (memberDetails.firstName.toUpperCase() == oldMemberDetails.firstName.toUpperCase())) &&
                                (!$A.util.isEmpty(memberDetails.firstName) && (memberDetails.lastName.toUpperCase() == oldMemberDetails.lastName.toUpperCase())) &&
                                (memberDetails.dob == oldMemberDetails.dob || memberDetails.memberId == oldMemberDetails.memberId))) { // DE411393 - Thanish - 11th Feb 2021
                            searchedMember = true;
                            break;
                        }
                    }
                }
            }
        }

        if (searchedMember) {
            this.hideMemberSpinner(cmp, CardNo);
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Information!",
                "message": "Member was already searched.",
                "type": "warning"
            });
            toastEvent.fire();
        } else {
            if (addMembers[CardNo].mnfCheckBox) {
                selectedIndividualMemberDetails = this.getMemberDetails(cmp, null, CardNo);
                _setAndGetSessionValues.addNewMember(cmp.get("v.interactionOverviewTabId"), selectedIndividualMemberDetails);
                this.OpenMNFCard(cmp, CardNo);
            } else {
                var selectedProviderDetails = cmp.get("v.providerDetails");
                this.searchMember(cmp, selectedProviderDetails, memberDetails, CardNo, 'Continue');
            }
        }
        return false;
    },

    OpenMNFCard: function (cmp, CardNo) {
        var addMembers = cmp.get('v.addMembers');
        var memberDetails = addMembers[CardNo];
        JSON.parse(JSON.stringify(addMembers[CardNo]));

        if (!$A.util.isEmpty(addMembers[CardNo].dob)) {
            var dob = addMembers[CardNo].dob;
            if (dob.includes('-')) {
                dob = dob.split("-");
                addMembers[CardNo].dob = dob[1] + "/" + dob[2] + "/" + dob[0];
            }
        }
        var mnfPhoneNumber = addMembers[CardNo].phone;
        var mnfPhoneFormat;
        if (mnfPhoneNumber.length == 10) {
            mnfPhoneFormat = mnfPhoneNumber.substring(0, 3) + '-' + mnfPhoneNumber.substring(3, 6) + '-' + mnfPhoneNumber.substring(6, 10);
            //Ends US1895326
            addMembers[CardNo].phone = mnfPhoneFormat;
        }
        addMembers[CardNo].mnfSubjectCard = true;
        addMembers[CardNo].showCard = true;
        addMembers[CardNo].addMemberCard = false;
        addMembers[CardNo].showAdvance = false;
        cmp.set('v.addMembers', addMembers);
    },

    executeMemberSearch: function (cmp, event) {
        event.currentTarget.className
        var srcName;
        if (event.keyCode === 13) {
            srcName = event.currentTarget.className;
        } else {
            var source = event.getSource();
            srcName = source.get('v.name');
        }

        var addMembers = cmp.get('v.addMembers');
        var memberCard = addMembers[srcName];

        if ((!addMembers[srcName].enableContinueBtn || (event.type == "click" && event.getSource().get("v.label") == 'Search')) && !addMembers[srcName].mnfCheckBox) {
            if (addMembers[srcName].isFindIndividualSearch) {
                addMembers[srcName].isFindIndividualSearch = false;
                addMembers[srcName].mnfCheckBox = false;
                addMembers[srcName].enableContinueBtn = false;
                addMembers[srcName].isValidMember = false;
                addMembers[srcName].isMultipleMemberResponse = false;
                addMembers[srcName].multipleMemberResponses = [];
                cmp.set("v.addMembers", addMembers);
            }
        }

        addMembers[srcName].memberId = !$A.util.isEmpty(addMembers[srcName].memberId) ? addMembers[srcName].memberId.trim() : '';
        //DE355414 - Avish
        var dobLst = cmp.find("inputDOB");
        console.log(JSON.parse(JSON.stringify(dobLst)));
        if (Array.isArray(dobLst)) {
            for (var i in dobLst) {
                if (dobLst[i].get("v.name") == srcName) {
                    addMembers[srcName].dob = !$A.util.isEmpty(dobLst[i].get("v.value")) ? dobLst[i].get("v.value").trim() : '';
                }
            }
        } else {
            if (dobLst.get("v.name") == srcName) {
                addMembers[srcName].dob = !$A.util.isEmpty(dobLst.get("v.value")) ? dobLst.get("v.value").trim() : '';
            }
        }
        //DE355414 - Ends
        //addMembers[srcName].dob = !$A.util.isEmpty(addMembers[srcName].dob) ? addMembers[srcName].dob.trim() : '' ;
        addMembers[srcName].firstName = !$A.util.isEmpty(addMembers[srcName].firstName) ? addMembers[srcName].firstName.trim() : '';
        addMembers[srcName].lastName = !$A.util.isEmpty(addMembers[srcName].lastName) ? addMembers[srcName].lastName.trim() : '';
        addMembers[srcName].groupNumber = !$A.util.isEmpty(addMembers[srcName].groupNumber) ? addMembers[srcName].groupNumber.trim() : '';
        cmp.set("v.addMembers", addMembers);

        console.log(JSON.parse(JSON.stringify(memberCard)));
        var interactionOverviewData = _setAndGetSessionValues.getInteractionDetails(cmp.get("v.interactionOverviewTabId"));
        if (!$A.util.isUndefinedOrNull(interactionOverviewData.providerDetails)) {
            cmp.set("v.providerDetails", interactionOverviewData.providerDetails);
        }
        var selectedProviderDetails = cmp.get("v.providerDetails");
        console.log(JSON.stringify(cmp.get("v.memberDetails")));
        if (this.validateAllFields(cmp, event, srcName)) {
            this.showMemberSpinner(cmp, srcName);
            // US3204295 - Thanish - 5th Feb 2021
            if(!memberCard.showAdvance && !addMembers[srcName].enableContinueBtn){
                addMembers[srcName].isFindIndividualSearch = false;
                addMembers[srcName].memberId = addMembers[srcName].memberId.trim();
                cmp.set("v.addMembers", addMembers);
                this.searchMember(cmp, selectedProviderDetails, addMembers[srcName], srcName, 'Search');
            } else {
                addMembers[srcName].memberId = !$A.util.isEmpty(addMembers[srcName].memberId) ? addMembers[srcName].memberId.trim() : '';
                addMembers[srcName].dob = !$A.util.isEmpty(addMembers[srcName].dob) ? addMembers[srcName].dob.trim() : '';
                if (addMembers[srcName].showAdvance) {
                    addMembers[srcName].firstName = !$A.util.isEmpty(addMembers[srcName].firstName) ? addMembers[srcName].firstName.trim() : '';
                    addMembers[srcName].lastName = !$A.util.isEmpty(addMembers[srcName].lastName) ? addMembers[srcName].lastName.trim() : '';
                    addMembers[srcName].groupNumber = !$A.util.isEmpty(addMembers[srcName].groupNumber) ? addMembers[srcName].groupNumber.trim() : '';
                }
                cmp.set("v.addMembers", addMembers);
                this.openInteractionOverview(cmp, event, srcName);
            }
        }
    },

    searchMember: function (cmp, selectedProviderDetails, memberDetailsToSend, CardNo, btnContinue) {
        //US2699880-Interaction Overview Page - Remove EEID & SSN Fields and Add 'Source Code' Field - START
        var selectedMemberDetailss = cmp.get("v.memberDetails");
        var currentSourceValue = '';
        if (!$A.util.isUndefinedOrNull(selectedMemberDetailss) && !$A.util.isUndefinedOrNull(selectedMemberDetailss.selectedSearchMember)) {
            var selectedValue = selectedMemberDetailss.selectedSearchMember;
            var sourceValue = selectedValue.split(' ');
            currentSourceValue = sourceValue[0];
            console.log(JSON.parse(JSON.stringify(currentSourceValue)));
            cmp.set("v.memberDetails.selectedSearchMember", "");
        }
        //US2699880-Interaction Overview Page - Remove EEID & SSN Fields and Add 'Source Code' Field - END
        var addMembers = cmp.get('v.addMembers');
        var memberCard = addMembers[CardNo];

        JSON.parse(JSON.stringify(addMembers[CardNo]));
        var action = cmp.get('c.getMemberDetails');
        action.setParams({
            "flowDetails": null,
            "providerDetails": selectedProviderDetails,
            "memberDetails": memberDetailsToSend
        });

        action.setCallback(this, function (response) {
            var state = response.getState();
            var result = response.getReturnValue();
            if (state == 'SUCCESS') {

                if (result.isSuccess) {
                    if (result.statusCode == 200) {
                        this.hideMemberSpinner(cmp, CardNo);
                        if (!addMembers[CardNo].showAdvance && btnContinue != "Continue") { // US3204295 - Thanish - 5th Feb 2021
                            addMembers[CardNo].isMultipleMemberResponse = true;
                            addMembers[CardNo].isFindIndividualSearch = true;
                            addMembers[CardNo].multipleMemberResponses = result.response.lstSAEMemberStandaloneSearch;
                            if(result.response.lstSAEMemberStandaloneSearch && result.response.lstSAEMemberStandaloneSearch.length > 0 &&
                                result.response.lstSAEMemberStandaloneSearch[0].emailIds && result.response.lstSAEMemberStandaloneSearch[0].emailIds.length > 0) {
                                addMembers[CardNo].emails = result.response.lstSAEMemberStandaloneSearch[0].emailIds.join('<br/>');
                            } else {
                                addMembers[CardNo].emails = '';
                            }
                            addMembers[CardNo].isClear = false;
                            addMembers[CardNo].enableContinueBtn = false;
                            cmp.set("v.findIndividualSearchResults", addMembers[CardNo]);
                            var memDetails = {};
                            cmp.set("v.memberDetails", memDetails);
                            cmp.set("v.addMembers", addMembers);
                        } else {
                            addMembers[CardNo].isValidMember = true;
                            addMembers[CardNo].showCard = true;
                            addMembers[CardNo].addMemberCard = false;

                            if (!$A.util.isEmpty(result.response)) {
                                var subjCardObj = {
                                    "memberDOB": "",
                                    "memberId": "",
                                    "firstName": "",
                                    "lastName": "",
                                    "relationship": "",
                                    "groupNumber": "",
                                    "EEID": "",
                                    "maskedEEID": "",
                                    "SSN": "",
                                    "maskedSSN": "",
                                    "SourceCode": "", //US2699880-Interaction Overview Page - Remove EEID & SSN Fields and Add 'Source Code' Field
                                    "formattedSSN": "",
                                    "searchQueryPayerId": "",
                                    "policyandPayerMap": ""
                                };
                                subjCardObj.SourceCode = currentSourceValue; //US2699880-Interaction Overview Page - Remove EEID & SSN Fields and Add 'Source Code' Field
                                subjCardObj.memberDOB = $A.localizationService.formatDate(result.response.dob, "MM/dd/yyyy");
                                if (!$A.util.isUndefinedOrNull(result.response.searchQueryPayerId)) {
                                    subjCardObj.searchQueryPayerId = result.response.searchQueryPayerId;
                                }
                                if (!$A.util.isUndefinedOrNull(result.response.policyandPayerMap)) {
                                    subjCardObj.policyandPayerMap = result.response.policyandPayerMap;
                                }
                                subjCardObj.memberId = result.response.memberId;
                                subjCardObj.firstName = result.response.firstName;
                                subjCardObj.lastName = result.response.lastName;
                                subjCardObj.relationship = result.response.relationship;
                                subjCardObj.groupNumber = result.response.groupNumber;
                                subjCardObj.EEID = result.response.eeId;
                                subjCardObj.SSN = result.response.SSN;
                                if (!$A.util.isEmpty(result.response.SSN)) {
                                    var ssnValue = result.response.SSN;
                                    subjCardObj.maskedSSN = 'xxx-xx-' + ssnValue.substring(5, 9);
                                    subjCardObj.formattedSSN = ssnValue.substring(0, 3) + '-' + ssnValue.substring(3, 5) + '-' + ssnValue.substring(5, 9);
                                }
                                if (!$A.util.isEmpty(result.response.EEID)) {
                                    var eeIdValue = result.response.EEID;
                                    subjCardObj.maskedEEID = 'xxxxx' + eeIdValue.substring(5, 9);
                                }
                                addMembers[CardNo].subjectCard = subjCardObj;

                            }
                            // US3204284: Explore Page and Interaction Overview
                            addMembers[CardNo].mnf = '';
                            addMembers[CardNo].isdelete = true;
                            cmp.set("v.addMembers", addMembers);
                            console.log(JSON.stringify(cmp.get("v.addMembers")));
                            var memberSearchResponse = result.response;
                            var selectedMemberDetails = this.getMemberDetails(cmp, memberSearchResponse, CardNo);
                            _setAndGetSessionValues.addNewMember(cmp.get("v.interactionOverviewTabId"), selectedMemberDetails);
                        }
                    } else {
                        this.hideMemberSpinner(cmp, CardNo);
                        if (addMembers[CardNo].showAdvance && !($A.util.isEmpty(addMembers[CardNo].firstName) || $A.util.isEmpty(addMembers[CardNo].lastName))) {
                            addMembers[CardNo].isMemberNotFound = addMembers[CardNo].showAdvance;
                            cmp.set("v.addMembers", addMembers);
                        }
                        // US3204284: Explore Page and Interaction Overview: Source Code is Not Available

                        this.showToastMessage("We hit a snag.", (result != null) ? result.message : '', "error", "dismissible", "30000");
                    }
                } else {
                    this.hideMemberSpinner(cmp, CardNo);
                    if (addMembers[CardNo].showAdvance) {
                        addMembers[CardNo].isMemberNotFound = addMembers[CardNo].showAdvance;
                        cmp.set("v.addMembers", addMembers);
                    }
                    this.showToastMessage("We hit a snag.", (result != null) ? result.message : '', "error", "dismissible", "30000");
                }
            } else if (state == 'ERROR') {
                this.hideMemberSpinner(cmp, CardNo);
                this.showToastMessage("We hit a snag.", (result != null) ? result.message : '', "error", "dismissible", "30000");
            }
        });
        $A.enqueueAction(action);
    },

    getMemberDetails: function (cmp, memberSearchResponse, CardNo) {
        var addMembers = cmp.get('v.addMembers');
        var memberDetails = addMembers[CardNo];
        var flowDetails = cmp.get("v.flowDetails");
        var selectedMemberDetails = {
            "age": "",
            "dob": "",
            "eeId": "",
            "firstName": "",
            "gender": "",
            "groupNumber": "",
            "isAdvancedSearch": memberDetails.isAdvancedSearch,
            "isFromExplore": false,
            "isFindIndividualSearch": memberDetails.isFindIndividualSearch,
            "isMemberNotFound": memberDetails.mnfCheckBox,
            "isNoMemberToSearch": memberDetails.isNoMemberToSearch,
            "isValidMember": memberDetails.isValidMember,
            "lastName": "",
            "memberId": "",
            "memberUniqueId": "",
            "phoneNumber": "",
            "phone": "",
            "payerId": memberDetails.payerId,
            "relationship": "",
            "searchOption": "",
            "ssn": "",
            "state": "",
            "zip": "",
            "policyandPayerMap": memberDetails.policyandPayerMap,
            "searchQueryPayerId": memberDetails.searchQueryPayerId
        };

        if (memberDetails.mnfCheckBox) {
            selectedMemberDetails.age = "";
            var dob;
            if (memberDetails.dob.includes("-")) {
                var splittedDOB = memberDetails.dob.split("-");
                dob = splittedDOB[1] + "/" + splittedDOB[2] + "/" + splittedDOB[0];
            }
            selectedMemberDetails.dob = dob;
            selectedMemberDetails.eeId = "";
            selectedMemberDetails.firstName = memberDetails.firstName;
            selectedMemberDetails.gender = "";
            selectedMemberDetails.groupNumber = "";
            selectedMemberDetails.lastName = memberDetails.lastName;
            selectedMemberDetails.memberId = "";
            selectedMemberDetails.memberUniqueId = "";
            selectedMemberDetails.middleName = "";
            selectedMemberDetails.payerId = memberDetails.payerId;
            var mnfPhoneNumber = memberDetails.phone;
            if (mnfPhoneNumber.length == 10) {
                var mnfPhoneFormat = mnfPhoneNumber.substring(0, 3) + '-' + mnfPhoneNumber.substring(3, 6) + '-' + mnfPhoneNumber.substring(6, 10);
                selectedMemberDetails.phoneNumber = mnfPhoneFormat;
                selectedMemberDetails.phone = mnfPhoneFormat;
            }
            selectedMemberDetails.relationship = "";
            selectedMemberDetails.searchOption = "";
            selectedMemberDetails.ssn = "";
            selectedMemberDetails.state = memberDetails.state;
        } else if (memberDetails.isNoMemberToSearch) {

        } else if (memberDetails.isValidMember) {
            // valid member
            selectedMemberDetails.age = memberSearchResponse.age;
            var dob;
            if (memberSearchResponse.dob.includes("-")) {
                var splittedDOB = memberSearchResponse.dob.split("-");
                dob = splittedDOB[1] + "/" + splittedDOB[2] + "/" + splittedDOB[0];
            }
            selectedMemberDetails.dob = dob;
            selectedMemberDetails.eeId = memberSearchResponse.eeId;
            selectedMemberDetails.firstName = memberSearchResponse.firstName;
            selectedMemberDetails.gender = memberSearchResponse.gender;
            selectedMemberDetails.groupNumber = memberSearchResponse.groupNumber;
            selectedMemberDetails.lastName = memberSearchResponse.lastName;
            selectedMemberDetails.memberId = memberSearchResponse.memberId;
            selectedMemberDetails.memberUniqueId = "";
            selectedMemberDetails.middleName = memberSearchResponse.middleName;
            selectedMemberDetails.payerId = memberSearchResponse.payerId;
            selectedMemberDetails.phoneNumber = "";
            selectedMemberDetails.relationship = memberSearchResponse.relationship;
            selectedMemberDetails.searchOption = memberSearchResponse.searchOption;
            selectedMemberDetails.ssn = memberSearchResponse.ssn;
            selectedMemberDetails.state = "";
        }
        return selectedMemberDetails;
    },

    resetMembers: function (cmp, event, helper) {
        //cmp.set("v.optionValue", 1);
        var addMembers = cmp.get('v.addMembers');
        var resetAll = [];
        var selectedCard = [];
        for (var i = 0; i < addMembers.length; i++) {
            if (addMembers[i].showCard) {
                selectedCard.push(addMembers[i]);
            } else {
                resetAll.push(addMembers[i]);
            }
        }
        if (resetAll.length == addMembers.length) {
            cmp.set('v.showSections', false);
            $A.util.addClass(cmp.find("hideNumberSelctions"), "slds-hide");
            cmp.set('v.showMembersSelction', "");
            cmp.set('v.showSections', false);
            cmp.set('v.addMembers', []);
            cmp.set('v.isMms', false);
        }

        if (selectedCard.length > 0) {
            for (var i = 0; i < selectedCard.length; i++) {
                if (i != selectedCard[i].row) {
                    selectedCard[i].row = i;
                }
            }
        }
        var memDetails = {};
        cmp.set("v.memberDetails", memDetails);
        cmp.set("v.addMembers", selectedCard);
    },

    getStateValuesMDT: function (component, event) {
        var action = component.get('c.getStateValues');
        action.setCallback(this, function (actionResult) {
            var opts = [];
            for (var i = 0; i < actionResult.getReturnValue().length; i++) {
                opts.push({
                    label: actionResult.getReturnValue()[i].DeveloperName,
                    value: actionResult.getReturnValue()[i].DeveloperName
                });
            }
            opts.unshift({
                label: '--None--',
                value: ''
            });
            component.set('v.options', opts);
        });
        $A.enqueueAction(action);
    },

    validateAllFields: function (cmp, event, cardNo) {
        var validationSuccess = false;
        var mandatoryFieldCmp = "";
        var validationCounter = 0;
        var addMembers = cmp.get('v.addMembers');
        var mandatoryFields;
        addMembers[cardNo].mapError = [];
        JSON.parse(JSON.stringify(addMembers[cardNo]));
        if(!addMembers[cardNo].showAdvance){
            mandatoryFields = ["memberId","inputDOB"];
        }else{
            if(addMembers[cardNo].mnfCheckBox){
                mandatoryFields = ["inputDOB", "memFirstNameId", "memLastNameId", "phoneId", "stateMemId"];
            }else{
                mandatoryFields = ["inputDOB", "memFirstNameId", "memLastNameId", "phoneId","zipCodeId"];
            }
        }
        for (var i in mandatoryFields) {
            if(mandatoryFields[i] == 'stateMemId') {
                if(addMembers[cardNo].mnfCheckBox && (addMembers[cardNo]['state'] == '' || addMembers[cardNo]['state'] == null || addMembers[cardNo]['state'] == 'undefined') ) {
                    cmp.find("stateMemId").find('StateAI').checkValidation();
                    cmp.find('stateMemId').find('StateAI').find('comboboxFieldAI').reportValidity();
                   	validationCounter++;
                    addMembers[cardNo].mapError.push({key: 'stateMemId', value: 'State'});
                    addMembers[cardNo].fieldValidationFlag = true;
                    addMembers[cardNo].errorMessage = "We hit a snag.";
                    addMembers[cardNo].topDescription = "Search criteria must include";
                    addMembers[cardNo].descriptionList = [];
                    addMembers[cardNo].descriptionList.push('State');
                    addMembers[cardNo].bottomDescription = "additional fields may be included to help narrow results";
                    addMembers[cardNo].isSnagHit = true;
                    cmp.set('v.addMembers', addMembers);
                    cmp.set('v.cardNumberError', cardNo);
                }
                continue;
            }
            mandatoryFieldCmp = cmp.find(mandatoryFields[i]);
            if (!$A.util.isUndefined(mandatoryFieldCmp)) {
                if (!Array.isArray(mandatoryFieldCmp)) {
                    console.log('labelName@@@ ' + mandatoryFieldCmp.get("v.label"));
                    if (!mandatoryFieldCmp.checkValidity()) {
                        validationCounter++;
                        addMembers[cardNo].mapError.push({
                            key: mandatoryFieldCmp.getLocalId(),
                            value: mandatoryFieldCmp.get('v.label')
                        });
                        addMembers[cardNo].fieldValidationFlag = true;
                        addMembers[cardNo].errorMessage = "We hit a snag.";
                        addMembers[cardNo].topDescription = "Search criteria must include";
                        addMembers[cardNo].descriptionList = [];
                        addMembers[cardNo].descriptionList.push(mandatoryFieldCmp.get('v.label'));
                        addMembers[cardNo].bottomDescription = "additional fields may be included to help narrow results";
                        addMembers[cardNo].isSnagHit = true;
                        cmp.set('v.addMembers', addMembers);
                        cmp.set('v.cardNumberError', cardNo);
                    }
                    mandatoryFieldCmp.reportValidity();
                } else {
                    for (var i in mandatoryFieldCmp) {
                        if (!mandatoryFieldCmp[i].checkValidity() && mandatoryFieldCmp[i].get("v.name") == cardNo) {
                            if (!mandatoryFieldCmp[i].checkValidity()) {
                                validationCounter++;
                                addMembers[cardNo].mapError.push({
                                    key: mandatoryFieldCmp[i].getLocalId(),
                                    value: mandatoryFieldCmp[i].get('v.label')
                                });
                                addMembers[cardNo].fieldValidationFlag = true;
                                addMembers[cardNo].errorMessage = "We hit a snag.";
                                addMembers[cardNo].topDescription = "Search criteria must include";
                                addMembers[cardNo].descriptionList = [];
                                addMembers[cardNo].descriptionList.push(mandatoryFieldCmp[i].get('v.label'));
                                addMembers[cardNo].bottomDescription = "additional fields may be included to help narrow results";
                                addMembers[cardNo].isSnagHit = true;
                                cmp.set('v.addMembers', addMembers);
                                cmp.set('v.cardNumberError', cardNo);
                            }
                            mandatoryFieldCmp[i].reportValidity();
                        }
                    }
                }
            }
        }

        if (addMembers[cardNo].showAdvance) {
            // Wildcard Validation
            var mandatoryFieldsFNLN = ["memFirstNameId", "memLastNameId"];
            validationSuccess = this.validateNamesWildCard(cmp, mandatoryFieldsFNLN, event, cardNo);

            var isCombinationValid = false;
            if (!$A.util.isEmpty(addMembers[cardNo].memberId) && !$A.util.isEmpty(addMembers[cardNo].dob)) {
                isCombinationValid = true;
            } else if (!$A.util.isEmpty(addMembers[cardNo].memberId) && !$A.util.isEmpty(addMembers[cardNo].dob) && !$A.util.isEmpty(addMembers[cardNo].firstName) && !$A.util.isEmpty(addMembers[cardNo].lastName)) {
                isCombinationValid = true;
            } else if (!$A.util.isEmpty(addMembers[cardNo].memberId) && !$A.util.isEmpty(addMembers[cardNo].firstName) && !$A.util.isEmpty(addMembers[cardNo].lastName)) {
                isCombinationValid = true;
            } else if (!$A.util.isEmpty(addMembers[cardNo].memberId) && !$A.util.isEmpty(addMembers[cardNo].firstName) && !$A.util.isEmpty(addMembers[cardNo].dob)) {
                isCombinationValid = true;
            } else if (!$A.util.isEmpty(addMembers[cardNo].memberId) && !$A.util.isEmpty(addMembers[cardNo].dob) && !$A.util.isEmpty(addMembers[cardNo].lastName)) {
                isCombinationValid = true;
            } else if (!$A.util.isEmpty(addMembers[cardNo].firstName) && !$A.util.isEmpty(addMembers[cardNo].dob) && !$A.util.isEmpty(addMembers[cardNo].lastName)) {
                isCombinationValid = true;
            } else {
                isCombinationValid = false;
            }
            /*if(!$A.util.isEmpty(addMembers[cardNo].memberId)){
                if((!$A.util.isEmpty(addMembers[cardNo].firstName) && !$A.util.isEmpty(addMembers[cardNo].lastName) && !$A.util.isEmpty(addMembers[cardNo].dob) && !$A.util.isEmpty(addMembers[cardNo].groupNumber) &&
                    $A.util.isEmpty(addMembers[cardNo].state) && $A.util.isEmpty(addMembers[cardNo].zip) && $A.util.isEmpty(addMembers[cardNo].phone)) ||
                   (!$A.util.isEmpty(addMembers[cardNo].firstName) && !$A.util.isEmpty(addMembers[cardNo].lastName) && !$A.util.isEmpty(addMembers[cardNo].dob) &&
                    $A.util.isEmpty(addMembers[cardNo].state) && $A.util.isEmpty(addMembers[cardNo].zip) && $A.util.isEmpty(addMembers[cardNo].phone) && $A.util.isEmpty(addMembers[cardNo].groupNumber)) ||
                   (!$A.util.isEmpty(addMembers[cardNo].lastName) && !$A.util.isEmpty(addMembers[cardNo].dob) && $A.util.isEmpty(addMembers[cardNo].firstName) &&
                    $A.util.isEmpty(addMembers[cardNo].state) && $A.util.isEmpty(addMembers[cardNo].zip) && $A.util.isEmpty(addMembers[cardNo].phone) && $A.util.isEmpty(addMembers[cardNo].groupNumber)) ||
                   (!$A.util.isEmpty(addMembers[cardNo].firstName) && !$A.util.isEmpty(addMembers[cardNo].lastName) && $A.util.isEmpty(addMembers[cardNo].dob) &&
                    $A.util.isEmpty(addMembers[cardNo].state) && $A.util.isEmpty(addMembers[cardNo].zip) && $A.util.isEmpty(addMembers[cardNo].phone) && $A.util.isEmpty(addMembers[cardNo].groupNumber)) ||
                   (!$A.util.isEmpty(addMembers[cardNo].firstName) && !$A.util.isEmpty(addMembers[cardNo].dob) && $A.util.isEmpty(addMembers[cardNo].lastName) &&
                    $A.util.isEmpty(addMembers[cardNo].state) && $A.util.isEmpty(addMembers[cardNo].zip) && $A.util.isEmpty(addMembers[cardNo].phone) && $A.util.isEmpty(addMembers[cardNo].groupNumber)) ||
                   (!$A.util.isEmpty(addMembers[cardNo].dob)) ||
                   ($A.util.isEmpty(addMembers[cardNo].firstName) && $A.util.isEmpty(addMembers[cardNo].lastName) && $A.util.isEmpty(addMembers[cardNo].dob) &&
                    $A.util.isEmpty(addMembers[cardNo].groupNumber) && (!$A.util.isEmpty(addMembers[cardNo].zip)) && (!$A.util.isEmpty(addMembers[cardNo].phone)) &&
                    (!$A.util.isEmpty(addMembers[cardNo].state))) ||
                   ($A.util.isEmpty(addMembers[cardNo].firstName) && $A.util.isEmpty(addMembers[cardNo].lastName) &&
                    $A.util.isEmpty(addMembers[cardNo].dob) && $A.util.isEmpty(addMembers[cardNo].groupNumber) && ($A.util.isEmpty(addMembers[cardNo].zip)) &&
                    ($A.util.isEmpty(addMembers[cardNo].phone)) && ($A.util.isEmpty(addMembers[cardNo].state)))
                  ){
                    addMembers[cardNo].validationFlag = false;
                    addMembers[cardNo].fieldValidationFlag = false;
                } else if(!addMembers[cardNo].mnfCheckBox){
                    validationCounter++;
                    addMembers[cardNo].validationFlag = true;
                    addMembers[cardNo].errorMessage = "We hit a snag.";
                    addMembers[cardNo].descriptionList = [];
                    addMembers[cardNo].descriptionList.push('Member ID or');
                    addMembers[cardNo].descriptionList.push('DOB + First Name + Last Name');
                    addMembers[cardNo].descriptionList.push('additional fields may be included to');
                    addMembers[cardNo].descriptionList.push('help narrow results');
                    addMembers[cardNo].bottomDescription = "additional fields may be included to help narrow results";
                    addMembers[cardNo].isSnagHit = true;
                }else{
                    addMembers[cardNo].validationFlag = false;
                    addMembers[cardNo].fieldValidationFlag = false;
                }
            } else if($A.util.isEmpty(addMembers[cardNo].memberId) && (!$A.util.isEmpty(addMembers[cardNo].firstName) && !$A.util.isEmpty(addMembers[cardNo].lastName) && !$A.util.isEmpty(addMembers[cardNo].dob))){
                addMembers[cardNo].validationFlag = false;
                addMembers[cardNo].fieldValidationFlag = false;
            }else{
                validationCounter++;
                addMembers[cardNo].validationFlag = true;
                addMembers[cardNo].errorMessage = "We hit a snag.";
                addMembers[cardNo].descriptionList = [];
                addMembers[cardNo].descriptionList.push('Member ID or');
                addMembers[cardNo].descriptionList.push('DOB + First Name + Last Name');
                addMembers[cardNo].descriptionList.push('additional fields may be included to');
                addMembers[cardNo].descriptionList.push('help narrow results');
                addMembers[cardNo].bottomDescription = "additional fields may be included to help narrow results";
                addMembers[cardNo].isSnagHit = true;
            }*/
        } else {
            isCombinationValid = true;
        }

        if (!isCombinationValid) {
            validationCounter++;
            addMembers[cardNo].validationFlag = true;
            addMembers[cardNo].errorMessage = "We hit a snag.";
            addMembers[cardNo].topDescription = "Search criteria must include";
            addMembers[cardNo].descriptionList = [];
            addMembers[cardNo].descriptionList.push('Member ID or DOB + First Name + Last Name');
            addMembers[cardNo].bottomDescription = "additional fields may be included to help narrow results";
            addMembers[cardNo].isSnagHit = true;
        }

        if (validationCounter == 0) {
            validationSuccess = true;
            addMembers[cardNo].fieldValidationFlag = false;
            addMembers[cardNo].validationFlag = false;
            addMembers[cardNo].isSnagHit = false;
            cmp.set('v.addMembers', addMembers);
        } else {
            validationSuccess = false;
            cmp.set('v.addMembers', addMembers);
        }
        return validationSuccess;
    },

    validateNamesWildCard: function (cmp, mandatoryFields, event, cardNo) {
        var validationSuccess = false;
        var mandatoryFieldCmp = "";
        var validationCounter = 0;
        for (var i in mandatoryFields) {
            mandatoryFieldCmp = cmp.find(mandatoryFields[i]);
            if (!$A.util.isUndefined(mandatoryFieldCmp)) {
                if (!Array.isArray(mandatoryFieldCmp)) {
                    if (mandatoryFieldCmp.get("v.label") == 'First Name') {
                        var charString = mandatoryFieldCmp.get("v.value");
                        var lastchar = charString[charString.length - 1];
                        if (lastchar == "*" && charString.length < 3) {
                            validationCounter++;
                            mandatoryFieldCmp.setCustomValidity(cmp.get("v.firstNameErrorMessage"));
                            mandatoryFieldCmp.reportValidity();
                        } else if (charString.includes("*") && lastchar != "*" && charString.length >= 3) {
                            validationCounter++;
                            mandatoryFieldCmp.setCustomValidity(cmp.get("v.firstNameErrorMessage"));
                            mandatoryFieldCmp.reportValidity();
                        } else {
                            mandatoryFieldCmp.setCustomValidity("");
                            mandatoryFieldCmp.reportValidity();
                        }
                    } else if (mandatoryFieldCmp.get("v.label") == 'Last Name') {
                        var charString = mandatoryFieldCmp.get("v.value");
                        var lastchar = charString[charString.length - 1];
                        if (lastchar == "*" && charString.length < 4) {
                            validationCounter++;
                            mandatoryFieldCmp.setCustomValidity(cmp.get("v.lastNameErrorMessage"));
                            mandatoryFieldCmp.reportValidity();
                        } else if (charString.includes("*") && lastchar != "*" && charString.length >= 4) {
                            validationCounter++;
                            mandatoryFieldCmp.setCustomValidity(cmp.get("v.lastNameErrorMessage"));
                            mandatoryFieldCmp.reportValidity();
                        } else {
                            mandatoryFieldCmp.setCustomValidity("");
                            mandatoryFieldCmp.reportValidity();
                        }
                    }
                } else {
                    for (var i in mandatoryFieldCmp) {
                        if (mandatoryFieldCmp[i].get("v.name") == cardNo) {
                            if (mandatoryFieldCmp[i].get("v.label") == 'First Name') {
                                var charString = mandatoryFieldCmp[i].get("v.value");
                                var lastchar = charString[charString.length - 1];
                                if (lastchar == "*" && charString.length < 3) {
                                    validationCounter++;
                                    mandatoryFieldCmp[i].setCustomValidity("Enter at least two character followed by an asterisk, and no character after the asterisk, in order to perform a wildcard search on the first name field (example: ab*)");
                                    mandatoryFieldCmp[i].reportValidity();
                                } else if (charString.includes("*") && lastchar != "*" && charString.length >= 3) {
                                    mandatoryFieldCmp[i].setCustomValidity("Enter at least two character followed by an asterisk, and no character after the asterisk, in order to perform a wildcard search on the first name field (example: ab*)");
                                    mandatoryFieldCmp[i].reportValidity();
                                    validationCounter++;
                                } else {
                                    mandatoryFieldCmp[i].setCustomValidity("");
                                    mandatoryFieldCmp[i].reportValidity();
                                }
                            } else if (mandatoryFieldCmp[i].get("v.label") == 'Last Name') {
                                var charString = mandatoryFieldCmp[i].get("v.value");
                                var lastchar = charString[charString.length - 1];
                                if (lastchar == "*" && charString.length < 4) {
                                    validationCounter++;
                                    mandatoryFieldCmp[i].setCustomValidity("Enter at least three characters followed by an asterisk, and no character after the asterisk, in order to perform a wildcard search on the last name field (example: abc*)");
                                    mandatoryFieldCmp[i].reportValidity();
                                } else if (charString.includes("*") && lastchar != "*" && charString.length >= 4) {
                                    mandatoryFieldCmp[i].setCustomValidity("Enter at least three characters followed by an asterisk, and no character after the asterisk, in order to perform a wildcard search on the last name field (example: abc*)");
                                    mandatoryFieldCmp[i].reportValidity();
                                    validationCounter++;
                                } else {
                                    mandatoryFieldCmp[i].setCustomValidity("");
                                    mandatoryFieldCmp[i].reportValidity();
                                }
                            }
                        }
                    }
                }
            }
        }

        if (validationCounter == 0) {
            validationSuccess = true;
        }
        return validationSuccess;
    },

    clearMemberCardInputs: function (cmp, event, helper) {
        var source = event.getSource();
        var srcName = source.get('v.name');
        this.clearFieldValues(cmp, event, srcName);
        var mandatoryFields = ["inputDOB", "memberId"];
        this.clearFieldValidations(cmp, mandatoryFields, event, srcName);
        var defaultPayerValue = cmp.get('v.defaultPayerValue');
        var defaultPayerLabel = cmp.get('v.defaultPayerLabel');
        var addMembers = cmp.get('v.addMembers');
        var index = source.get('v.name');
        var payerObj = {};
        payerObj.payerValue = defaultPayerValue;
        payerObj.payerLabel = defaultPayerLabel;
        payerObj.typeText = defaultPayerLabel;
        payerObj.displayPayer = false;
        addMembers[index].payerObj = payerObj;
        $A.util.removeClass(addMembers[index], "slds-has-error");
        $A.util.removeClass(addMembers[index], "show-error-message");
        $A.util.removeClass(addMembers[index], "slds-form-element__help");
        $A.util.addClass(addMembers[index], "hide-error-message");
        addMembers[index].isClear = false;
        addMembers[index].enableContinueBtn = false;
        cmp.set('v.addMembers', addMembers);
        addMembers[index].isClear = true;
        var memDetails = {};
        cmp.set("v.memberDetails", memDetails);
        cmp.set("v.findIndividualSearchResults", addMembers[index]);
    },

    clearFieldValidations: function (cmp, mandatoryFields, event, cardNo) {
        var mandatoryFieldCmp = "";
        for (var i in mandatoryFields) {
            mandatoryFieldCmp = cmp.find(mandatoryFields[i]);
            if (!$A.util.isUndefined(mandatoryFieldCmp)) {
                if (!Array.isArray(mandatoryFieldCmp)) {
                    if (mandatoryFieldCmp.get("v.type") == "date") {
                        if ($A.util.isEmpty(mandatoryFieldCmp.get("v.value"))) {
                            mandatoryFieldCmp.set("v.value", $A.localizationService.formatDate(new Date(), "YYYY-MM-DD"));
                            mandatoryFieldCmp.setCustomValidity("");
                            mandatoryFieldCmp.reportValidity();
                            mandatoryFieldCmp.set("v.value", null);
                        }
                    } else {
                        mandatoryFieldCmp.set("v.value", "1");
                        mandatoryFieldCmp.setCustomValidity("");
                        mandatoryFieldCmp.reportValidity();
                        mandatoryFieldCmp.set("v.value", null);
                    }
                } else {
                    for (var i in mandatoryFieldCmp) {
                        if (mandatoryFieldCmp[i].get("v.name") == cardNo) {
                            if (mandatoryFieldCmp[i].get("v.type") == "date") {
                                if ($A.util.isEmpty(mandatoryFieldCmp[i].get("v.value"))) {
                                    mandatoryFieldCmp[i].set("v.value", $A.localizationService.formatDate(new Date(), "YYYY-MM-DD"));
                                    mandatoryFieldCmp[i].setCustomValidity("");
                                    mandatoryFieldCmp[i].reportValidity();
                                    mandatoryFieldCmp[i].set("v.value", null);
                                    $A.util.removeClass(mandatoryFieldCmp[i], "slds-has-error");
                                    $A.util.removeClass(mandatoryFieldCmp[i], "show-error-message");
                                    $A.util.removeClass(mandatoryFieldCmp[i], "slds-form-element__help");
                                }
                            } else {
                                mandatoryFieldCmp[i].set("v.value", "1");
                                mandatoryFieldCmp[i].setCustomValidity("");
                                mandatoryFieldCmp[i].reportValidity();
                                mandatoryFieldCmp[i].set("v.value", null);
                                $A.util.removeClass(mandatoryFieldCmp[i], "slds-has-error");
                                $A.util.removeClass(mandatoryFieldCmp[i], "show-error-message");
                                $A.util.removeClass(mandatoryFieldCmp[i], "slds-form-element__help");
                            }
                        }
                    }
                }
            }
        }
    },

    clearFieldValues: function (cmp, event, srcName) {

        var addMembers = cmp.get('v.addMembers');
        var openedCardsCount = cmp.get('v.addMembers');
        var memberNameCmp = "";
        var todayDate = $A.localizationService.formatDate(new Date(), "YYYY-MM-DD");
        memberNameCmp = cmp.find("memberId");
        var dateCmp = cmp.find("inputDOB");
        addMembers[srcName].showAdvance = false;
        addMembers[srcName].mnfCheckBox = false;
        addMembers[srcName].firstName = "";
        addMembers[srcName].memberName = "";
        addMembers[srcName].dob = null;
        addMembers[srcName].lastName = "";
        addMembers[srcName].state = "";
        addMembers[srcName].phone = "";
        addMembers[srcName].mnf = "";
        addMembers[srcName].groupNumber = '';
        addMembers[srcName].zip = '';
        addMembers[srcName].mnfCheckBox = false;
        addMembers[srcName].validationFlag = false;
        addMembers[srcName].fieldValidationFlag = false;
        addMembers[srcName].mapError = null;
        addMembers[srcName].combiErrorMsg = false;
        addMembers[srcName].isMultipleMemberResponse = false;
        addMembers[srcName].isMemberNotFound = false;
        addMembers[srcName].multipleMemberResponses = [];
        addMembers[srcName].errorMessage = "";
        addMembers[srcName].topDescription = "";
        addMembers[srcName].descriptionList = [];
        addMembers[srcName].bottomDescription = "";
        addMembers[srcName].isSnagHit = false;
        $A.util.removeClass(addMembers[srcName], "slds-has-error");
        $A.util.removeClass(addMembers[srcName], "hide-error-message");
        $A.util.removeClass(addMembers[srcName], "slds-form-element__help");
        cmp.set('v.addMembers', addMembers);
    },

    getStateOptions: function (cmp) {
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

    keepOnlyDigits: function (cmp, event) {
        var regEx = /[^0-9 ]/g;
        var fieldValue = event.getSource().get("v.value");
        if (fieldValue.match(regEx)) {
            event.getSource().set("v.value", fieldValue.replace(regEx, ''));
        }
    },

    checkIfNotNumberMember: function (cmp, event, cardNo) {
        var regEx = /[^a-zA-Z0-9 ]/g;
        var addMembers = cmp.get('v.addMembers');
        var searchDetails = addMembers[cardNo];
        var fieldValue = searchDetails.memberName;
        if (fieldValue.match(regEx)) {
            event.getSource().set("v.value", fieldValue.replace(regEx, ''));
        }
    },

    showMemberSpinner: function (component, srcName) {
        var addMembers = component.get('v.addMembers');
        JSON.parse(JSON.stringify(addMembers));
        var newMemberCard = [];
        var count = 0;
        var checkFlg = false;
        for (var i = 0; i < addMembers.length; i++) {
            if (!addMembers[i].showCard) {
                newMemberCard.push(addMembers[i]);
            }
        }
        JSON.parse(JSON.stringify(newMemberCard));

        for (var i = 0; i < newMemberCard.length; i++) {
            if (newMemberCard[i].row == srcName) {
                var spinner;
                if (!Array.isArray(component.find("memberSearchIO-spinner"))) {
                    spinner = component.find("memberSearchIO-spinner");
                } else {
                    spinner = component.find("memberSearchIO-spinner")[i];
                }

                $A.util.removeClass(spinner, "slds-hide");
                $A.util.addClass(spinner, "slds-show");
            }
        }
    },

    hideMemberSpinner: function (component, srcName) {
        var addMembers = component.get('v.addMembers');
        JSON.parse(JSON.stringify(addMembers));
        var newMemberCard = [];
        var checkFlg = false;
        for (var i = 0; i < addMembers.length; i++) {
            if (!addMembers[i].showCard) {
                newMemberCard.push(addMembers[i]);
            }
        }
        JSON.parse(JSON.stringify(newMemberCard));
        for (var i = 0; i < newMemberCard.length; i++) {
            if (newMemberCard[i].row == srcName) {
                var spinner;
                if (!Array.isArray(component.find("memberSearchIO-spinner"))) {
                    spinner = component.find("memberSearchIO-spinner");
                } else {
                    spinner = component.find("memberSearchIO-spinner")[i];
                }
                $A.util.removeClass(spinner, "slds-show");
                $A.util.addClass(spinner, "slds-hide");
            }
        }
    },
})