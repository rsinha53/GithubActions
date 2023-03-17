({
    helperMethod : function() {

    },
    validateFields: function (component, event, helper, inputComp, status) {
        if (!status) {
            $A.util.removeClass(inputComp, "hide-error-message");
            $A.util.addClass(inputComp, "slds-has-error");
            inputComp.reportValidity();
        } else {
            $A.util.removeClass(inputComp, "slds-has-error");
            $A.util.addClass(inputComp, "hide-error-message");
        }
    },
    alidateFields: function (component, event, helper, inputComp, status) {
        if (!status) {
            $A.util.removeClass(inputComp, "hide-error-message");
            $A.util.addClass(inputComp, "slds-has-error");
            inputComp.reportValidity();
        } else {
            $A.util.removeClass(inputComp, "slds-has-error");
            $A.util.addClass(inputComp, "hide-error-message");
        }
    },
    getProviderDetails: function (cmp) {
        var appEvent = $A.get("e.c:ACETLinkGetProviderDetailsAE");
        appEvent.fire();
    },
    validateNamesWildCard: function (component, event, helper, isFirstName, inputComp, charlengthNum) {
        //component.set("v.hasFirstNameError",false);
        //component.set("v.hasLastNameError",false);
        var charString = inputComp.get("v.value");
        var lastchar = charString[charString.length - 1];

        if (lastchar == "*" && charString.length < charlengthNum) {
            if (isFirstName) {
                component.set("v.hasFirstNameError", true);
            } else {
                component.set("v.hasLastNameError", true);
            }
            $A.util.addClass(inputComp, "slds-has-error");
            return false;
        } else if (charString.includes("*") && lastchar != "*" && charString.length >= charlengthNum) {
            if (isFirstName) {
                component.set("v.hasFirstNameError", true);
            } else {
                component.set("v.hasLastNameError", true);
            }
            $A.util.addClass(inputComp, "slds-has-error");
            return false;
        } else {
            component.set("v.hasFirstNameError", false);
            component.set("v.hasLastNameError", false);
            $A.util.removeClass(component, "slds-has-error");
            $A.util.addClass(component, "hide-error-message");
            return true;
        }
    },
	/*
    searchResMembers: function (component, event, helper) {
		helper.sniEligibilityCallTest(component, event, helper);
	}, */
    searchResMembers: function (component, event, helper) {

        var action = component.get('c.findMembers');
        var inputMemberId = component.find('memberId');
        var memberIdVal = inputMemberId.get('v.value');

        var inputMemberDOB = component.find('inputDOB');
        var memberDOBVal = inputMemberDOB.get('v.value');

        var inputMemberFN = component.find('memFirstNameId');
        var memberFNVal = component.get('v.memFirstName'); //inputMemberFN.get('v.value');

        var inputMemberLN = component.find('memLastNameId');
        var memberLNVal = component.get('v.memLastName'); //inputMemberLN.get('v.value');

        var inputMemberGrpN = component.find('memGroupNumberId');
        var memberGrpNVal = component.get('v.groupNumber'); //inputMemberGrpN.get('v.value');
        console.log('memberIdVal>> ' + memberIdVal);
        console.log('memberDOBVal>> ' + memberDOBVal);
        console.log('memberFNVal>> ' + memberFNVal);
        console.log('memberLNVal>> ' + memberLNVal);
        console.log('memberGrpNVal>> ' + memberGrpNVal);

        var searchOptionVal = "";
        if (memberIdVal != '' && (!$A.util.isEmpty(memberFNVal)) && (!$A.util.isEmpty(memberLNVal)) && (!$A.util.isEmpty(memberGrpNVal)) && memberDOBVal != '') {
            searchOptionVal = 'MemberIDNameGroupNumberDateOfBirth';
        } else if (memberIdVal != '' && (!$A.util.isEmpty(memberFNVal)) && (!$A.util.isEmpty(memberLNVal)) && memberDOBVal != '') {
            searchOptionVal = 'MemberIDNameDateOfBirth';
        } else if (memberIdVal != '' && (!$A.util.isEmpty(memberFNVal)) && (!$A.util.isEmpty(memberLNVal))) {
            searchOptionVal = 'MemberIDName';
        } else if (memberIdVal != '' && (!$A.util.isEmpty(memberLNVal)) && memberDOBVal != '') {
            searchOptionVal = 'MemberIDLastNameDateOfBirth';
        } else if (memberIdVal != '' && (!$A.util.isEmpty(memberFNVal)) && memberDOBVal != '') {
            searchOptionVal = 'MemberIDFirstNameDateOfBirth';
        } else if ((!$A.util.isEmpty(memberFNVal)) && (!$A.util.isEmpty(memberLNVal)) && memberDOBVal != '') {
            searchOptionVal = 'NameDateOfBirth';
        } else if (memberIdVal != '' && memberDOBVal != '') {
            searchOptionVal = 'MemberIDDateOfBirth';
        }

        component.set("v.searchOptionVal", searchOptionVal);
        // var taxIdInput = component.find('taxID');
        // var taxIdVal = taxIdInput.get('v.value');
        // console.log('memberIdVal@@ ' + memberIdVal + ' >>taxIdVal>> ' + taxIdVal);
        action.setParams({
            "memberId": memberIdVal,
            "memberDOB": memberDOBVal,
            "firstName": memberFNVal,
            "lastName": memberLNVal,
            "groupNumber": memberGrpNVal,
            "searchOption": searchOptionVal
        });


        action.setCallback(this, function (response) {

            var state = response.getState(); // get the response state
            if (state == 'SUCCESS') {
                var result = response.getReturnValue();
                component.set("v.respStatusCode",result.statusCode);
                //console.log('##RESP:'+JSON.stringify(result));
                console.log('code?>>>> ' + result.statusCode);
                /*Code NOT REQUIRED for ITE -
                if (result.statusCode == 200) {
                    component.set("v.searchBtnFlag", true);
                    component.set("v.checkFlagmeberCard",true); //Added By Avish on 07/25/2019
                    console.log(result.resultWrapper.memberProviderResultlst);
                    console.log('result.resultWrapper.memberProviderResultlst');
                    if (component.find('memberId').get('v.value') == '859690190') {
                        component.set("v.responseData", result.resultWrapper.memberProviderResultlst[0]);
                    } else {
                        component.set("v.responseData", result.resultWrapper.memberProviderResultlst);
                    }
                    component.set("v.interactionCard", result.resultWrapper.interactionView);
                    component.set("v.subjectCard", result.resultWrapper.subjectCard);
					console.log('**********');
                    console.log(component.get("v.responseData"));
                    component.set("v.mnf", '');
                    if (component.get('v.responseData') == undefined) {
                        component.set('v.invalidResultFlag', true);
                    } else {
                        component.set('v.invalidResultFlag', false);
                    }
                } */
                if(result.statusCode == 200){
                    console.log('##GET-MEM');
                    var coverageLines = result.resultWrapper.CoverageLines;
                    console.log(coverageLines);
                    for(var i = 0; i < coverageLines.length; i++) {
                        console.log('coverageLines[i].ITEhighlightedPolicyId.....'+coverageLines[i].ITEhighlightedPolicyId);
                        if(coverageLines[i].ITEhighlightedPolicyId == true) {


                            //US1761826 - UHC/Optum Exclusion UI : END ?

                            console.log('##TRNSACTION_ID:'+coverageLines[i].transactionId);
                            component.set("v.tranId", coverageLines[i].transactionId);
                            component.set("v.concatAddress", coverageLines[i].concatAddress);

                            console.log('con Address::::'+coverageLines[i].concatAddress);
                            console.log('con Address::::'+coverageLines[i].transactionId);
                            console.log('TRNSACTION_ID after set up::::'+component.get("v.tranId"));

                        }
                    }

                    component.set("v.memberPolicies",result.resultWrapper.CoverageLines);
                    component.set("v.memberCardData",result.resultWrapper);
                    helper.callHouseHoldWS(component, event, helper);


                }else if (result.statusCode == 400 && (searchOptionVal == "NameDateOfBirth" || searchOptionVal == "MemberIDDateOfBirth")) {
                    //this.fireToastMessage("Error!", result.message, "dismissible", "5000");
                    this.fireToastMessage("Error!", result.message.replace(". ", ". \n"), "error", "dismissible", "10000");
                    helper.hideGlobalSpinner(component); // US2021959 :Code Added By Chandan
                } else {
                    //var responseMsg = result.message;
                    //var jsonString = JSON.parse(responseMsg);
                    component.set('v.showServiceErrors', true);
                    if (component.get("v.showHideMemAdvSearch") == true && component.get("v.displayMNFFlag") == true) {
                        component.set("v.mnf", 'mnf');
                        component.set("v.checkFlagmeberCard",false); //Added By Avish on 07/25/2019
                    }
                    //component.set('v.serviceMessage',jsonString.message);
                    // US1813580 - Error Message Translation
                    component.set('v.serviceMessage', result.message);
                    // If need
                    helper.fireToast(result.message);
                    helper.hideGlobalSpinner(component); // US2021959 :Code Added By Chandan
                }
            }else{
                helper.hideGlobalSpinner(component); // US2021959 :Code Added By Chandan
            }
        });
        $A.enqueueAction(action);
    },
    callHouseHoldWS : function(component,event,helper) {

        var transactionId=component.get("v.tranId");
        console.log('TRNSACTION_ID in callHouseHoldWS::::'+transactionId);

        if(transactionId){
            var action = component.get("c.getHouseHoldData");
            action.setParams({
                "transactionId": transactionId
            });

            action.setCallback(this, function(response) {
                var state = response.getState(); // get the response state
                if(state == 'SUCCESS') {
                    var result = response.getReturnValue();
                    console.log(result);
                    //helper.CallSNIEligibility(component,event,helper);

                    if(result.statusCode == 200){
                        helper.checkUhgAccess(component, event, helper, result);
                      //  helper.sniEligibilityCall(component, event, helper, result);
                    }else {
                        component.set('v.showServiceErrors', true);
                        if (component.get("v.showHideMemAdvSearch") == true && component.get("v.displayMNFFlag") == true) {
                            component.set("v.mnf", 'mnf');
                            component.set("v.checkFlagmeberCard",false); //Added By Avish on 07/25/2019
                        }
                        component.set('v.serviceMessage', result.message);
                        // If need
                        helper.fireToast(result.message);
                        helper.hideGlobalSpinner(component);// US2021959 :Code Added By Chandan
                    }
                } else {
                    helper.hideGlobalSpinner(component); // US2021959 :Code Added By Chandan
                }
            });

            $A.enqueueAction(action);

        }
        else{//Logic to display no active medical coverage
            helper.hideGlobalSpinner(component); // US2021959 :Code Added By Chandan
        }
    },

    fireToast: function (message) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "Error!",
            "message": message,
            "message": message,
            "type": "error",
            "mode": "sticky"
        });
        toastEvent.fire();
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
    navigateToInteractionHelper:function(cmp,event,helper,flagMNFnav){
        //helper.openInteractionOverview(cmp,event,helper);
        helper.getProviderDetails(cmp);
        debugger;
        var memConId = cmp.find('memContactId');
        var memConVal = memConId.get('v.value');
        var controlAuraIds =  [];

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
            console.log('if@@ ' + $A.util.isEmpty(memConVal));
            controlAuraIds = ["memFirstNameId","memLastNameId","memPhoneNumber","memContactId","inputDOB","stateMemId"];
        }else{
            console.log('else@@ ' + $A.util.isEmpty(memConVal));
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

        var mnfData = cmp.get("v.mnfDetailsLst");
        var isExistingMNFMember = false;
        if(!isExistingMNFMember){
            var mnfstateVal2 = cmp.find('stateMemId').find('provStateId').get("v.value");
            for(var i in mnfData){
                if(memFN.toUpperCase() == mnfData[i].mnfMemberFN && memLN.toUpperCase() == mnfData[i].mnfMemberLN && mnfstateVal2 == mnfData[i].mnfState
                   && memPhNo == mnfData[i].mnfPhoneNumber){
                    isExistingMNFMember = true;
                }
            }

            //if(cmp.get('v.mnf') == 'mnf'){

            mnfData.push({
                'mnf': cmp.get('v.mnf'),
                'mnfMemberFN': memFN.toUpperCase(),
                'mnfMemberLN': memLN.toUpperCase(),
                'mnfState': mnfstateVal2,
                'mnfPhoneNumber': memPhNo
            });
            cmp.set("v.mnfDetailsLst",mnfData);
        }

        if(isAllValid != undefined && isAllValid != false && flagMNFnav){
            var memberSearches = cmp.get("v.memberSearches");
            var memDOB = cmp.find('inputDOB').get('v.value');
            var memId = cmp.find('memberId').get('v.value');
            if (memberSearches.indexOf(memId + memDOB) != -1 || isExistingMNFMember) {
                //
                var workspaceAPI = cmp.find("workspace");
                workspaceAPI.getAllTabInfo().then(function (response) {
                    if (!$A.util.isEmpty(response)) {
                        for (var i = 0; i < response.length; i++) {
                            debugger;
                            if (response[i].pageReference.state.c__tabOpened) {
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
                })

                //
            } else {
                helper.openInteractionOverview(cmp,event,helper);
            }
        }
    },
    openInteractionOverview: function (component, helper) {
        debugger;
        console.log('calling navigate method...');
        var workspaceAPI = component.find("workspace");
        var mvfcheckFlag = component.get('v.mnfCheckBox');
        var contactId = component.find('memContactId');
        var contactIdVal = '';
        if(contactId != undefined && contactId != null){
            contactIdVal = contactId.get('v.value');
        }else{
            contactIdVal = "";
        }


        var inputMemberId = component.find('memberId');
        var memberIdVal = inputMemberId.get('v.value');

        var inputMemberDOB = component.find('inputDOB');
        var memberDOBVal = inputMemberDOB.get('v.value');

        var inputMemberFN = component.find('memFirstNameId');
        var memberFNVal = component.get('v.memFirstName');

        var inputMemberLN = component.find('memLastNameId');
        var memberLNVal = component.get('v.memLastName');

        var inputMemberGrpN = component.find('memGroupNumberId');
        var memberGrpNVal = component.get('v.groupNumber');

        //var inputMemberDOB = component.find('inputDOB');
        //var memberDOBVal = inputMemberDOB.get('v.value');

        var mnfMemberFN = component.find('memFirstNameId').get('v.value');
        var mnfMemberLN = component.find('memLastNameId').get('v.value');
        var mnfPhoneNumber = component.find('memPhoneNumber').get('v.value');
        var mnfstateVal = component.find('stateMemId').find('provStateId').get("v.value");
        console.log('interactionType### ' + component.get("v.interactionType"));

        var mnfPhoneFormat = mnfPhoneNumber.substring(0,3) + '-' + mnfPhoneNumber.substring(3,6) + '-' + mnfPhoneNumber.substring(6,10);

        //US1719505 Malinda
        //Get member first name for Snapshot tab's label
        var memDetails = component.get("v.responseData");
        var memFirstNameParam = '';
        console.log('memDetails@@@  ' + memDetails);
        if (memDetails != null && memDetails.length > 0) {
            memFirstNameParam = memDetails[0].firstName;
        }
        //console.log('##memDetails:'+JSON.stringify(memDetails));
        //console.log('##memDetails-FNAME:'+memDetails[0].firstName);
        var memUniqueId;
        var matchingTabs = [];

        //******* Code Updated by Avish on 07/25/2019*******
        if(!component.get('v.mnfCheckBox')){
            var subjectCard = component.get('v.subjectCard');
            if (subjectCard != null && !$A.util.isEmpty(memberDOBVal)) {
                memUniqueId = subjectCard.memberId + ";" + memDetails[0].firstName + " " + memDetails[0].lastName + ";" + memberDOBVal;
                var memberSearches = component.get("v.memberSearches");
                memberSearches.push(memUniqueId);
                component.set("v.memberSearches", memberSearches);
            }
        }else{
            memUniqueId = memberIdVal+ ";" + mnfMemberFN+ ";" + mnfMemberLN+ ";" + memberDOBVal;
            var memberSearches = component.get("v.memberSearches");
            memberSearches.push(memUniqueId);
            component.set("v.memberSearches", memberSearches);
        }
        //***** Code ends here

        workspaceAPI.getAllTabInfo().then(function (response) {
            if (!$A.util.isEmpty(response)) {
                for (var i = 0; i < response.length; i++) {
                    /*var tabMemUniqueId = response[i].pageReference.state.c__memberUniqueId;
        			if(memUniqueId === tabMemUniqueId) {
        				matchingTabs.push(response[i]);
        				console.log('##ML-CHECK'+matchingTabs.length);
        			}*/
                    if (response[i].pageReference.state.c__tabOpened) {
                        matchingTabs.push(response[i]);
                    }
                }
            }
            if (matchingTabs.length === 0) {
                component.set("v.interactionID", '');
                /*** Code Added by Avish 07/25/2019 ***/
                if(component.get('v.mnf') == 'mnf'){
                    console.log('Opening first time mnf>>>>');
                    component.set("v.interactionCard", null);
                    component.set("v.subjectCard", '');
                    component.set("v.checkFlagmeberCard",false);
                }
                /** Code ends here ***/
                workspaceAPI.openTab({
                    pageReference: {
                        "type": "standard__component",
                        "attributes": {
                            "componentName": "c__SAE_InteractionOverview"
                        },
                        "state": {
                            "c__contactName": contactIdVal,
                            "c__interactionCard": component.get('v.interactionCard'),
                            "c__subjectCard": component.get('v.subjectCard'),
                            "c__memberId": memberIdVal,
                            "c__memberDOB": memberDOBVal,
                            "c__memberFN": memFirstNameParam,
                            "c__memberLN": memberLNVal,
                            "c__memberGrpNo": memberGrpNVal,
                            "c__searchOption": component.get('v.searchOptionVal'),
                            "c__mnf": component.get('v.mnf'),
                            "c__mnfMemberFN": mnfMemberFN.toUpperCase(),
                            "c__mnfMemberLN": mnfMemberLN.toUpperCase(),
                            "c__mnfPhoneNumber": mnfPhoneFormat,
                            "c__mnfState": mnfstateVal,
                            "c__intType": component.get("v.interactionType"),
                            //US1719505 Malinda
                            "c__memberUniqueId": memUniqueId,
                            "c__interactionID": component.get("v.interactionID"),
                            "c__statusCode":component.get("v.respStatusCode"),
                            "c__tabOpened": true,
                            "c__providerDetails": component.get("v.providerDetails"),
                            "c__isProviderSearchDisabled": component.get("v.isProviderSearchDisabled"),
                            "c__checkFlagmeberCard" : component.get("v.checkFlagmeberCard") //Added by Avish on 07/25/2019
                        }
                    },
                    focus: true
                }).then(function (response) {
                    workspaceAPI.getTabInfo({
                        tabId: response
                    }).then(function (tabInfo) {
                        console.log("The recordId for this tab is: " + tabInfo.recordId);
                        var focusedTabId = tabInfo.tabId;

                        // ******** US1831550 Thanish (Date: 8th July 2019) start ********
                        var providerLName = component.get("v.interactionCard.providerLN");

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
                        // ******** US1831550 Thanish end ********

                    });
                }).catch(function (error) {
                    console.log(error);
                });
            } else {
                console.log('##ML:NOT-OPEN');
                var focusTabId = matchingTabs[0].tabId;
                var tabURL = matchingTabs[0].url;
                //
                var appEvent = $A.get("e.c:ACETLinkSubjectCardAE");

                /*** Code added by Avish on 07/25/2019 ***/
                if(component.get('v.mnf') == 'mnf'){
                    component.set("v.checkFlagmeberCard",true);
                }

                if(component.get('v.mnf') != 'mnf'){

                    appEvent.setParams({
                        "subjectCard": component.get("v.subjectCard"),
                        "searchedMember": memUniqueId,
                        "existingMemberCardFlag": component.get("v.checkFlagmeberCard")
                    });
                }else{
                    appEvent.setParams({
                        "searchedMember": memUniqueId,
                        "mnfMemberFN": mnfMemberFN.toUpperCase(),
                        "mnfMemberLN": mnfMemberLN.toUpperCase(),
                        "mnfMemberState": mnfstateVal,
                        "mnfMemberPhNo": mnfPhoneFormat,
                        "mnf":component.get('v.mnf'),
                        "mnfIntDetailLst":component.get("v.mnfDetailsLst")
                    });
                }
                /*** code end here ***/

                appEvent.fire();
                //
                console.log('##TAB-ID:' + focusTabId);
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
    setErrorMessage: function (component, event, helper, errorMessage) {
        component.set("v.errorMessage", errorMessage);
        component.set("v.hasErrorMessage", true);
    },
    checkOpnedTab: function (component) {
        var workspaceAPI = component.find("workspace");
        var memSearch = [];
        component.set("v.memberSearches", memSearch);

        workspaceAPI.getAllTabInfo().then(function (response) {
            if (!$A.util.isEmpty(response)) {
                for (var i = 0; i < response.length; i++) {
                    if (response[i].pageReference.state.c__tabOpened) {
                        //matchingTabs.push(response[i]);
                        console.log(JSON.stringify(response));
                        memSearch.push(response[i].pageReference.state.c__memberUniqueId);
                    }
                }
            }
        });

        component.set("v.memberSearches", memSearch);
    },
    checkUhgAccess: function (component, event, helper, result) {
		  //console.log('checkUhgAccess-------------');
		  var plcId = '';
		  for(var i=0; i< result.houseHoldResultWrapper.houseHoldList.length;i++){
          if(result.houseHoldResultWrapper.houseHoldList[i].isMainMember == true) {
				plcId = result.houseHoldResultWrapper.houseHoldList[i].policyId;
			}
		  }
      // plcId = '0700416';
		 var checkUhgAction = component.get("c.checkUHGaccess");
		 checkUhgAction.setParams({"policyId" :plcId});
		 //console.log('checkUhgAccess------plcId-------'+plcId);
		 checkUhgAction.setCallback(this, function(response1) {
			 console.log('checkUhgAccess-------------');
              var state1 = response1.getState();
				console.log('checkUhgAccess-----state1--------'+state1);
              if(state1 == 'SUCCESS') {
					var resultVal = response1.getReturnValue();
					console.log('checkUhgAccess-----resultVal--------'+resultVal);
					if(resultVal){
					//var uhgAcc =  result1.
	                helper.sniEligibilityCall(component, event, helper, result);
					}
					else{
						  component.set('v.showServiceErrors', true);
                      if (component.get("v.showHideMemAdvSearch") == true && component.get("v.displayMNFFlag") == true) {
                          component.set("v.mnf", 'mnf');
                          component.set("v.checkFlagmeberCard",false);
                      }
                     
                     component.set('v.serviceMessage', 'You are not authorized to view this Member due to UHG restrictions.');
                     helper.fireToast('You are not authorized to view this Member due to UHG restrictions.');
                     helper.hideGlobalSpinner(component); 
					}
				}
				else{
				        var errMsg = 'Unexpected error occurred. Please try again.';
						component.set('v.showServiceErrors', true);
						if (component.get("v.showHideMemAdvSearch") == true && component.get("v.displayMNFFlag") == true) {
							component.set("v.mnf", 'mnf');
							component.set("v.checkFlagmeberCard",false);
						}
						component.set('v.serviceMessage', errMsg);
						helper.fireToast(errMsg);
						helper.hideGlobalSpinner(component);  
				}
		 })
		 $A.enqueueAction(checkUhgAction);
	 
	},
	sniEligibilityCall: function (component, event, helper, result) {
         console.log('sniEligibilityCall func starts-----');
        var houseDetail = component.find('house');
        var memberDOBVal;
        var memberIdVal;
		var memberFNVal;
        var memberLNVal;
        var action1 = component.get("c.findSNIDetails");
        var householdlist = result.houseHoldResultWrapper.houseHoldList.length;
        var plcId = '';
        console.log(result.houseHoldResultWrapper.houseHoldList);
        for(var i=0; i< result.houseHoldResultWrapper.houseHoldList.length;i++){

            if(result.houseHoldResultWrapper.houseHoldList[i].isMainMember == true) {
                plcId = result.houseHoldResultWrapper.houseHoldList[i].policyId;
                memberFNVal = result.houseHoldResultWrapper.houseHoldList[i].firstName;
                memberLNVal = result.houseHoldResultWrapper.houseHoldList[i].lastName;
				memberDOBVal = result.houseHoldResultWrapper.houseHoldList[i].dob;
				memberIdVal = result.houseHoldResultWrapper.houseHoldList[i].memberId;
		    }
        }

        //console.log('memberIdVal---- '+memberIdVal+';plcId---- '+plcId+';memberFNVal-----'+memberFNVal+';memberLNVal---- '+memberLNVal+';inputMemberDOB----- '+memberDOBVal);
		if(plcId && memberIdVal && memberDOBVal && memberFNVal && memberLNVal)	{

            var policyIdVar;
            plcId = plcId.toString();
            if (plcId.length < 9) {
                policyIdVar = ('0000000000' + plcId).slice(-9);
            }
            else{
                policyIdVar = plcId;
            }
            action1.setParams({
                "memberId": memberIdVal,
                "policyId" :policyIdVar,
                "firstName": memberFNVal,
                "lastName": memberLNVal,
                "memDob": memberDOBVal
            });

			action1.setCallback(this, function(response1) {
                /*
                var date = new Date(); 
                var timestamp = date.getTime();
                console.log('setCallback time----');
                  console.log(timestamp);
                  */
                var state1 = response1.getState();
                console.log('from js callout sni'+state1);
                if(state1 == 'SUCCESS') {
                    var result1 = response1.getReturnValue();
                    console.log('state1 status code----------'+result1.statusCode);
                    if(result1.statusCode == 200){
                        var sniEligible = result1.SNIresultWrapper.sniEligibility;
                        var advFullName = result1.SNIresultWrapper.advisorFullName;
                        var assignedToVal = result1.SNIresultWrapper.assignedTo;
                        console.log('assignedToVal----------'+assignedToVal);
                        //if(sniEligible != null && sniEligible != '' && typeof sniEligible != 'undefined' && sniEligible != 'not eligible' ){ //add one more condition here
                        if(sniEligible){
                            houseDetail.createAccount(result.houseHoldResultWrapper.houseHoldList,memberDOBVal,memberIdVal,advFullName,sniEligible,policyIdVar,plcId,assignedToVal);
                        }
                    }
                    else {
                        if(result1.statusCode == 839){
                            console.log('result statusCode----------'+result1.statusCode);
                            window.setTimeout(function(){
                                 $A.enqueueAction(action1);
                            }, 8000);
                        }
                        else{
                            component.set('v.showServiceErrors', true);
                            if (component.get("v.showHideMemAdvSearch") == true && component.get("v.displayMNFFlag") == true) {
                                component.set("v.mnf", 'mnf');
                                component.set("v.checkFlagmeberCard",false);
                            }
                           component.set('v.serviceMessage', result1.message);
                           helper.fireToast(result1.message);
                           helper.hideGlobalSpinner(component);  // US2021959 :Code Added By Chandan-start
                        }
                    }

                }else{
                    helper.hideGlobalSpinner(component); // US2021959 :Code Added By Chandan
                }
            });
        }
        else{

            var errMsg = 'Unexpected error occurred. Please try again.';
            component.set('v.showServiceErrors', true);
            if (component.get("v.showHideMemAdvSearch") == true && component.get("v.displayMNFFlag") == true) {
                component.set("v.mnf", 'mnf');
                component.set("v.checkFlagmeberCard",false);
            }
            component.set('v.serviceMessage', errMsg);
            helper.fireToast(errMsg);
            helper.hideGlobalSpinner(component); // US2021959 :Code Added By Chandan
        }
        console.log('SNI Action starts-----');
        $A.enqueueAction(action1);

    },
    // US2021959 :Code Added By Chandan -Start
    // Show Spinner method
    showGlobalSpinner: function (component) {
        var spinner = component.find("global-spinner");
        $A.util.removeClass(spinner, "slds-hide");
        $A.util.addClass(spinner, "slds-show");
        component.set("v.showSpinner",true);
    },//Hide Spinner method
    hideGlobalSpinner: function (component) {
        var spinner = component.find("global-spinner");
        $A.util.removeClass(spinner, "slds-show");
        $A.util.addClass(spinner, "slds-hide");
        component.set("v.showSpinner",false);
        //return null;
    }
    // US2021959 :Code End By Chandan
})