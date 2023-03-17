({
    wrapperResults: function(component, event, helper) {
        var sendToListInputs = {
            "advocateRole": "Select",
            "teamQuickList": "Select",
            "office": "Select",
            "department": "Select",
            "team": "Select",
            "individual": "",
            "state": "Select",
            'issue': "Select",
            "city": "",
            "phoneNumber": "",
            "comments": "",
            "officeAPI": "",
            "departmentAPI": "",
            "teamAPI": "",
            "memberName": "",
            "memberId": "",
            "memberDOB": "",
            "providerName": "",
            "NPI": "",
            "MPIN": "",
            "TIN": "",
            "escalationReason": "Select"

        };
        component.set("v.sendToListInputs", sendToListInputs);
    },

    openMisDirect: function(cmp) {
        var workspaceAPI = cmp.find("workspace");
        var caseWrapper = cmp.get("v.caseWrapper");
        workspaceAPI.getEnclosingTabId().then(function(enclosingTabId) {
            if (enclosingTabId == false) {
                workspaceAPI.openTab({
                    pageReference: {
                        "type": "standard__component",
                        "attributes": {
                            "componentName": "c__SAE_MisdirectComponent"
                        },
                        "state": {}
                    },
                    focus: true
                }).then(function(response) {
                    workspaceAPI.getTabInfo({
                        tabId: response
                    }).then(function(tabInfo) {
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
                }).catch(function(error) {
                    console.log(error);
                });
            } else {
                workspaceAPI.openSubtab({
                    parentTabId: enclosingTabId,
                    pageReference: {
                        "type": "standard__component",
                        "attributes": {
                            "componentName": "c__SAE_MisdirectComponent"
                        },
                        "state": {
                            "c__originatorName": caseWrapper.OriginatorName,
                            "c__originatorType": caseWrapper.OriginatorType,
                            "c__contactName": caseWrapper.OriginatorContactName,
                            "c__subjectName": caseWrapper.SubjectName,
                            "c__subjectType": caseWrapper.SubjectType,
                            "c__subjectDOB": caseWrapper.SubjectDOB,
                            "c__subjectID": caseWrapper.SubjectId,
                            "c__subjectGrpID": caseWrapper.SubjectGroupId,
                            "c__interactionID": caseWrapper.Interaction,
                            "c__contactUniqueId": caseWrapper.Interaction,
                            "c__focusedTabId": enclosingTabId
                        }
                    }
                }).then(function(subtabId) {
                    workspaceAPI.setTabLabel({
                        tabId: subtabId,
                        label: "Misdirect"
                    });
                    workspaceAPI.setTabIcon({
                        tabId: subtabId,
                        icon: "standard:decision",
                        iconAlt: "Misdirect"
                    });
                }).catch(function(error) {
                    console.log(error);
                });
            }
        });
    },

    getORSMetaDataRecords: function(component, event, helper) {
        debugger;
        var action = component.get("c.getRoutingInfo");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var orsMetaData = response.getReturnValue();
                component.set("v.orsMap", orsMetaData.orsMap);
                var orsMetaDataList = orsMetaData.mdtList;
                component.set("v.orsMetaDataList", orsMetaDataList);
                console.log('orsMetaData', orsMetaData)
                console.log('orsMetaDataList', orsMetaDataList)

                //added by sravani
                if (!$A.util.isEmpty(orsMetaData)) {
                    component.set("v.isorsMetaDataTrue", true);
                }
            }
        });
        $A.enqueueAction(action);
    },

    getReasonCodesRecords: function(component, event, helper) {
        debugger;
        var action = component.get("c.getSAEReasonCodes");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var reasonCodeData = response.getReturnValue();
                component.set("v.reasonCodesMap", reasonCodeData.reasonCodeMap);
                var reasonCodeList = reasonCodeData.reasonCodeList;
                var reasonCodeMap = reasonCodeData.reasonCodeMap;
                component.set("v.reasonCodesList", reasonCodeList);
                var topic = component.get("v.ttsTopic");
                //added by sravani
                if (!$A.util.isEmpty(reasonCodeData.reasonCodeList)) {
                    console.log('------------------->', reasonCodeList)
                    console.log('------------------->', reasonCodeMap)
                    component.set("v.isreasonCodeMapTrue", true);
                }


                for (var i in reasonCodeMap) {
                    if (topic == reasonCodeMap[i].Issue__c) {
                        component.set("v.sendToListInputs.issue", reasonCodeMap[i].Issue__c);
                    }
                }
            }
        });
        $A.enqueueAction(action);

    },

    validateAllFields: function(cmp, event, mandatoryFields, parentCmpId, childCmpId) {
        var controlAuraIds = ["stateId", "issueId", "advocateRoleId", "teamQuickListId", "officeId", "departmentId", "teamId"];
        var validationSuccess = false;
        var mandatoryFieldCmp = "";
        var validationCounter = 0;
        var errMap = [];
        cmp.set("v.mapError", errMap);

        for (var i in mandatoryFields) {
            mandatoryFieldCmp = cmp.find(parentCmpId).find(childCmpId).find(mandatoryFields[i]);
            if (mandatoryFieldCmp.get("v.value") == '' || mandatoryFieldCmp.get("v.value") == null || mandatoryFieldCmp.get("v.value") == undefined) {
                validationCounter++;
                errMap.push({
                    key: mandatoryFieldCmp.getLocalId(),
                    value: mandatoryFieldCmp.get('v.label')
                });
                cmp.set("v.mapError", errMap);
                cmp.set("v.fieldValidationFlag", true);
                mandatoryFieldCmp.checkValidity();
                mandatoryFieldCmp.reportValidity();
            } else {
                mandatoryFieldCmp.checkValidity();
                mandatoryFieldCmp.reportValidity();
            }
            var isAllValid = controlAuraIds.reduce(function(isValidSoFar, controlAuraId) {
                if (!$A.util.isEmpty(controlAuraId)) {
                    if (controlAuraId == 'issueId' || controlAuraId == 'advocateRoleId' ||
                        controlAuraId == 'teamQuickListId' || controlAuraId == 'officeId' || controlAuraId == 'departmentId' ||
                        controlAuraId == 'teamId') {
                        //var tempState = cmp.find('stateId').find('StateAI').find('comboboxFieldAI').get("v.value");
                        var tempState1 = cmp.find('idServiceRequestTabs').find('idServiceRequest').find('issueId').find('comboboxFieldAI').get("v.value");
                        var tempState2 = cmp.find('idServiceRequestTabs').find('idSendToNonClaims').find('advocateRoleId').find('comboboxFieldAI').get("v.value");
                        var tempState3 = cmp.find('idServiceRequestTabs').find('idSendToNonClaims').find('teamQuickListId').find('comboboxFieldAI').get("v.value");
                        var tempState4 = cmp.find('idServiceRequestTabs').find('idSendToNonClaims').find('officeId').find('comboboxFieldAI').get("v.value");
                        var tempState5 = cmp.find('idServiceRequestTabs').find('idSendToNonClaims').find('departmentId').find('comboboxFieldAI').get("v.value");
                        var tempState6 = cmp.find('idServiceRequestTabs').find('idSendToNonClaims').find('teamId').find('comboboxFieldAI').get("v.value");
                        if (tempState1 == 'Select' || tempState2 == 'Select' || tempState3 == 'Select' ||
                            tempState4 == 'Select' || tempState5 == 'Select' || tempState6 == 'Select') {
                            //cmp.find('stateId').find('StateAI').find('comboboxFieldAI').reportValidity();
                            if (!$A.util.isUndefined(cmp.find('idServiceRequestTabs').find('idServiceRequest').find('issueId').find('comboboxFieldAI')) ||
                                !$A.util.isUndefined(cmp.find('idServiceRequestTabs').find('idSendToNonClaims').find('advocateRoleId').find('comboboxFieldAI')) ||
                                !$A.util.isUndefined(cmp.find('idServiceRequestTabs').find('idSendToNonClaims').find('teamQuickListId').find('comboboxFieldAI')) ||
                                !$A.util.isUndefined(cmp.find('idServiceRequestTabs').find('idSendToNonClaims').find('officeId').find('comboboxFieldAI')) ||
                                !$A.util.isUndefined(cmp.find('idServiceRequestTabs').find('idSendToNonClaims').find('departmentId').find('comboboxFieldAI')) ||
                                !$A.util.isUndefined(cmp.find('idServiceRequestTabs').find('idSendToNonClaims').find('teamId').find('comboboxFieldAI'))) {
                                if(!cmp.find('idServiceRequestTabs').find('idServiceRequest').find("issueId").find('comboboxFieldAI').get("v.disabled")) {
                                    cmp.find('idServiceRequestTabs').find('idServiceRequest').find('issueId').checkValidation();
                                cmp.find('idServiceRequestTabs').find('idServiceRequest').find('issueId').find('comboboxFieldAI').reportValidity();
                                }
                                if(!cmp.find('idServiceRequestTabs').find('idSendToNonClaims').find("advocateRoleId").find('comboboxFieldAI').get("v.disabled")) {
                                    cmp.find('idServiceRequestTabs').find('idSendToNonClaims').find("advocateRoleId").checkValidation();
                                cmp.find('idServiceRequestTabs').find('idSendToNonClaims').find('advocateRoleId').find('comboboxFieldAI').reportValidity();
                                }
                                if(!cmp.find('idServiceRequestTabs').find('idSendToNonClaims').find("teamQuickListId").find('comboboxFieldAI').get("v.disabled")) {
                                    cmp.find('idServiceRequestTabs').find('idSendToNonClaims').find("teamQuickListId").checkValidation();
                                cmp.find('idServiceRequestTabs').find('idSendToNonClaims').find('teamQuickListId').find('comboboxFieldAI').reportValidity();
                                }
                                if(!cmp.find('idServiceRequestTabs').find('idSendToNonClaims').find("departmentId").find('comboboxFieldAI').get("v.disabled")) {
                                    cmp.find('idServiceRequestTabs').find('idSendToNonClaims').find("departmentId").checkValidation();
                                cmp.find('idServiceRequestTabs').find('idSendToNonClaims').find('departmentId').find('comboboxFieldAI').reportValidity();
                                }
                                if(!cmp.find('idServiceRequestTabs').find('idSendToNonClaims').find("teamId").find('comboboxFieldAI').get("v.disabled")) {
        							cmp.find('idServiceRequestTabs').find('idSendToNonClaims').find("teamId").checkValidation();
                                cmp.find('idServiceRequestTabs').find('idSendToNonClaims').find('teamId').find('comboboxFieldAI').reportValidity();
                                }
                                if(!cmp.find('idServiceRequestTabs').find('idSendToNonClaims').find("officeId").find('comboboxFieldAI').get("v.disabled")) {
                                    cmp.find('idServiceRequestTabs').find('idSendToNonClaims').find("officeId").checkValidation();
                                    cmp.find('idServiceRequestTabs').find('idSendToNonClaims').find('officeId').find('comboboxFieldAI').reportValidity();
                                }

                            }
                            return false;
                        }
                    }
                }
            }, true);
        }

        if (validationCounter == 0) {
            validationSuccess = true;
            cmp.set("v.fieldValidationFlag", false);
        }
        return validationSuccess;
    },

    //Navigate to case detail - Sravan
    navigateToCaseDetail: function(component, event, helper) {
        this.hideSpinner(component, event, helper);
        var caseId = component.get("v.caseId");

        // US2815284 - Sanka
        if (!$A.util.isEmpty(caseId)) {
            this.callRefreshEvent(component);
        }

        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "Success!",
            "message": "Success! The case was routed successfully.",
            "type": "success"
        });
        if (!$A.util.isEmpty(caseId)) {
            toastEvent.fire();
        }
        var workspaceAPI = component.find("workspace");
        workspaceAPI.openSubtab({
            url: '#/sObject/' + caseId + '/view',
            focus: true
        });
        workspaceAPI.getFocusedTabInfo().then(function(response) {
                var focusedTabId = response.tabId;
                workspaceAPI.closeTab({
                    tabId: focusedTabId
                });
            })
            .catch(function(error) {
                console.log(error);
            });
    },

    commentsUI: function(cmp, event, helper) {
        var flowDetails = cmp.get("v.flowDetails");
        var allList = cmp.get("v.sendToListInputs");
        var providerDetails = cmp.get("v.providerDetails");
        var caseWrapper = cmp.get("v.data");
        var uhcProduct = !$A.util.isEmpty(cmp.get('v.uhcProduct')) ? cmp.get('v.uhcProduct') : '';
        var memberName = !$A.util.isEmpty(allList.memberName) ? allList.memberName : '';
        var memberId = !$A.util.isEmpty(allList.memberId) ? allList.memberId : '';
        var memberDOB = !$A.util.isEmpty(allList.memberDOB) ? allList.memberDOB : '';
        var city = !$A.util.isEmpty(allList.city) ? allList.city : '';
        var phoneNumber = !$A.util.isEmpty(allList.phoneNumber) ? allList.phoneNumber : '';
        var commentsInput = !$A.util.isEmpty(allList.comments) ? allList.comments : '';
        var TIN = '';
        var MPIN = '';
        var NPI = '';
        var providerName = '';
        if (!$A.util.isEmpty(providerDetails)) {
            TIN = !$A.util.isEmpty(providerDetails[0].taxId) ? providerDetails[0].taxId : '';
            MPIN = !$A.util.isEmpty(providerDetails[0].corpMpin) ? providerDetails[0].corpMpin : '';
            NPI = !$A.util.isEmpty(providerDetails[0].npi) ? providerDetails[0].npi : '';
            providerName = !$A.util.isEmpty(providerDetails[0].firstName) ? providerDetails[0].firstName + ' ' + providerDetails[0].lastName : '';
        }
        var resCodeCon = cmp.get('v.reasonCode');
        var categoryCon = cmp.get('v.category');
        var reasonCode = !$A.util.isEmpty(resCodeCon) ? resCodeCon : '';
        var category = !$A.util.isEmpty(categoryCon) ? categoryCon : '';

        var isProvider = cmp.get("v.isProvider");
        var memberCommentsFields = '';
        var state;
        var issue;
        if(!isProvider){
            memberCommentsFields = ','+
                'UHC Product-'+uhcProduct+', '+
                'Member Name-'+memberName+', '+
                'Member ID-'+memberId+', '+
                'Member DOB-'+memberDOB
        }

        if (allList.state != 'Select' || allList.issue != 'Select') {
            state = allList.state;
            issue = allList.issue;
        } else {
            state = '';
            issue = '';
        }

        let lstUnResolvedProviderValues = cmp.get("v.lstUnResolvedProviders");
        let lstKeys = ['sourceCode','PROVIDERNAME', 'TAXID', 'PROVIDERIDMPIN', 'NPI', 'specialty', 'city', 'state'];
        var strComments = '';

        var hoursOfOperation= cmp.get("v.hoursOfOperation" );
        var hoursOfOpStr = 'HOURS OF OPERATION-' + hoursOfOperation.startTime + ' '+
            hoursOfOperation.startTimeType + ' TO '+
            hoursOfOperation.endTime+ ' ' +
            hoursOfOperation.endTimeType + ' '+
            hoursOfOperation.timeZone ;

        var comments = commentsInput +' , ' +
            'ISSUE-'+issue + ' , ' +
        	'CONTACT NUMBER-'+phoneNumber+' , '+
             hoursOfOpStr + ' , ';
        	//'TAT PROVIDED- '+'15 CAL ' + ' , ';

        var onlyConcatComments = 'ISSUE- '+issue  + ' , ' +
        'CONTACT NUMBER-'+phoneNumber+' , '+
         hoursOfOpStr + ' , ';
        //'TAT PROVIDED-'+'15 CAL ' + ' , ';

        lstUnResolvedProviderValues.forEach(function(objKey){
            if(!objKey['IsDelegatedSpeciality']) {
                lstKeys.forEach(function(eachKey){

                    if(eachKey == 'sourceCode') {
                        strComments = strComments +
                        'SOURCE- '+  objKey[eachKey].trimEnd() + ' , '
                    }

                    if(eachKey == 'PROVIDERNAME') {
                        strComments = strComments +
                        'PROVIDER NAME- '+  objKey[eachKey].trimEnd() + ' , '
                    }

                    if(eachKey == 'TAXID') {
                        strComments = strComments +
                        'TIN- '+  objKey[eachKey] + ' , '
                    }

                    if(eachKey == 'PROVIDERIDMPIN') {
                        strComments = strComments +
                        'MPIN AND SUFFIX- '+  objKey[eachKey] + ' , '
                    }

                    if(eachKey == 'NPI') {
                        strComments = strComments +
                        'NPI- '+  objKey[eachKey]+ ' , '
                    }

                    if(eachKey == 'specialty') {
                        strComments = strComments +
                        'SPECIALTY- '+  objKey[eachKey]+ ' , '
                    }

                    if(eachKey == 'city') {
                        strComments = strComments +
                        'City- '+  objKey[eachKey]+ ' , '
                    }

                    if(eachKey == 'state') {
                        strComments = strComments +
                        'State- '+  objKey[eachKey] + ' , '
                    }
                });
            }
        });
        var comments = comments + strComments;
        var onlyConcatComments = onlyConcatComments + strComments;

        comments = comments + 'IS THIS AN ESCALATED REQUEST?- '+'NO'+' , ';
        onlyConcatComments = onlyConcatComments + 'IS THIS AN ESCALATED REQUEST?- '+'NO'+' , ';

        if(!cmp.get('v.isDoesNotKnowChecked') ) {
            comments = comments + 'EXPECTED PAYMENT AMOUNT-' + cmp.get('v.strPaymentAmount') + ' , ';
            onlyConcatComments = onlyConcatComments + 'EXPECTED PAYMENT AMOUNT-' + cmp.get('v.strPaymentAmount') + ' \n';
        } else {
            comments = comments + 'EXPECTED PAYMENT AMOUNT-' + cmp.get('v.strPaymentAmount') + ' , ';
            onlyConcatComments = onlyConcatComments + 'EXPECTED PAYMENT AMOUNT- Does not Know' + ' , ';
        }
        var isCalender=cmp.get("v.isCalender");

        if(isCalender){
            comments = comments + 'TAT PROVIDED- '+cmp.get('v.strTatProvided') + 'Cal'+' , ';
        	onlyConcatComments = onlyConcatComments + 'TAT PROVIDED- '+cmp.get('v.strTatProvided') + 'Cal'+' , ';
        }
        else{
            comments = comments + 'TAT PROVIDED- '+cmp.get('v.strTatProvided') + 'Bus'+', ';
        	onlyConcatComments = onlyConcatComments + 'TAT PROVIDED- '+cmp.get('v.strTatProvided')+ 'Bus'+' , ';
        }


        cmp.set("v.concatComments",onlyConcatComments);
        cmp.set("v.comments",comments);
    },

    getDelegatedProviderInfo: function(cmp) {
        var action = cmp.get("c.getDelegatedProviderData");
        console.log(cmp.get("v.providerDetailsForRoutingScreen"));
        action.setParams({
            speciality: cmp.get("v.providerDetailsForRoutingScreen.primarySpeciality")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                if (result) {
                    cmp.set("v.selectedRadioValue", 'Yes');
                    cmp.set("v.delegatedSpeciality", true);
                } else {
                    cmp.set("v.delegatedSpeciality", false);
                    cmp.set("v.selectedRadioValue", 'No');
                    cmp.set("v.hideEntireSection", true);
                    cmp.set("v.disableRoleField", false);
                    //cmp.set("v.disableQuickListField",false);DE418730 - Sravan
                    console.log('disableQuickListField'+ cmp.get("v.disableQuickListField"));
                    cmp.set("v.quickListFieldsRequiredSymbol", false);
                }
            } else {
                console.log('FAIL## ' + JSON.stringify(response.getReturnValue()));
            }
        });
        $A.enqueueAction(action);
    },

    showSpinner: function(component, event, helper) {
        component.set("v.showSpinner", true);
    },

    hideSpinner: function(component, event, helper) {
        component.set("v.showSpinner", false);
    },

    getProviderDetails: function(component, event, helper) {
        var appEvent = $A.get("e.c:SAE_GetProviderDetailsAE");
        appEvent.fire();
    },

    getContactDetails: function(component, event, helper) {
        /*debugger;
        var appEvent = $A.get("e.c:ACET_GetContactNumber");
        appEvent.fire();*/
        if(component.get('v.ttsTopic') != 'View Claims') {
            var providerDetails = component.get("v.providerDetailsForRoutingScreen");
            if (!$A.util.isEmpty(providerDetails)) {
                component.set("v.providerDetails", providerDetails);
            }
        }
        var flowDetails = component.get("v.flowDetailsForRoutingScreen");

        var contactNumber = flowDetails.contactNumber;
        var contactExt = flowDetails.contactExt;
        var contactNum = contactNumber;

        var s = ("" + contactNum).replace(/\D/g, '');
        var m = s.match(/^(\d{3})(\d{3})(\d{4})$/);
        var formattedPhone = (!m) ? null : m[1] + "-" + m[2] + "-" + m[3];
        var contactNumberExt = formattedPhone + ' Ext(' + contactExt + ')';
        if (!$A.util.isUndefinedOrNull(contactNumberExt)) {
            component.set("v.sendToListInputs.phoneNumber", contactNumberExt);
        }

    },

    // US2815284 - Sanka
    callRefreshEvent: function(cmp) {
        var caseWrapper = cmp.get("v.caseWrapper");
        var appEvent = $A.get("e.c:ACET_CaseHistoryRefreshEvt");
        appEvent.setParams({
            "uniqueId": caseWrapper.refreshUnique
        });
        appEvent.fire();

        // DE408715 - 5th Feb 2021
        var refreshEvent = $A.get("e.c:ACET_AutoDocRefreshEvent");
        refreshEvent.setParams({
            "autodocUniqueId": cmp.get("v.AutodocKey")
        });
        refreshEvent.fire();
    },

    //US3068299 - Sravan - 21/11/2020
    createExternalCases: function(component, event, helper) {
        var pageReference = component.get("v.pageReference");
        var caseWrapper = component.get("v.caseWrapper");
        var finalPolicyMap = pageReference.state.c__finalPolicyMap;
        var memberMap = pageReference.state.c__memberMap;
        console.log('Routing Policy Map' + JSON.stringify(pageReference.state.c__finalPolicyMap));
        console.log('Routing Member Map' + JSON.stringify(pageReference.state.c__memberMap));
        if (!$A.util.isUndefinedOrNull(finalPolicyMap) && !$A.util.isEmpty(finalPolicyMap)) {
            for (var key in finalPolicyMap) {
                if (finalPolicyMap.hasOwnProperty(key)) {
                    caseWrapper.SubjectGroupId = finalPolicyMap[key].selectedGroup;
                    caseWrapper.SubjectId = finalPolicyMap[key].memberId;
                    caseWrapper.policyNumber = finalPolicyMap[key].selectedGroup;
					caseWrapper.strSourceCode = finalPolicyMap[key].selectedSourceCode;
					caseWrapper.strMemberId = finalPolicyMap[key].memberId;
                    //US3117073 - Multiple Policies -  Creating Multiple Unique ORS Records Check In ISET - Sravan - Start
                    var memberPolicyNumberMap = component.get("v.memberPolicyNumberMap");
                    console.log('memberPolicyNumberMap' + JSON.stringify(memberPolicyNumberMap));
                    console.log('finalPolicyMap[key].selectedGroup' + finalPolicyMap[key].selectedGroup);
                    if (!$A.util.isUndefinedOrNull(memberPolicyNumberMap) && !$A.util.isEmpty(memberPolicyNumberMap)) {
                        if (memberPolicyNumberMap.hasOwnProperty(finalPolicyMap[key].selectedGroup)) {
                            caseWrapper.policyNumber = memberPolicyNumberMap[finalPolicyMap[key].selectedGroup];
                        }
                    }
                    //US3117073 - Multiple Policies -  Creating Multiple Unique ORS Records Check In ISET - Sravan - End

                   //US3149404 - Sravan - Start
				    var relatedCaseItemMap = finalPolicyMap[key].relatedCaseItemsMap;
					caseWrapper.relatedCaseItemsMap = relatedCaseItemMap;
					if(!$A.util.isUndefinedOrNull(relatedCaseItemMap) && !$A.util.isEmpty(relatedCaseItemMap)){
						caseWrapper.relatedCaseItems = '';
						for(var caseItemKey in relatedCaseItemMap){
							if($A.util.isUndefinedOrNull(caseWrapper.relatedCaseItems) || $A.util.isEmpty(caseWrapper.relatedCaseItems)){
								caseWrapper.relatedCaseItems = 'External ID '+relatedCaseItemMap[caseItemKey].uniqueKey;
                                    }
							else{
								caseWrapper.relatedCaseItems = caseWrapper.relatedCaseItems+','+' External ID '+relatedCaseItemMap[caseItemKey].uniqueKey;
                                        }
                                }
                            }
                   //US3149404 - Sravan - End


                    if (finalPolicyMap[key].selectedSourceCode != 'AP') {
                        //caseWrapper.allowOpenCaseCreation = finalPolicyMap[key].isUnResolved;
                        //caseWrapper.allowCloseCaseCreation = finalPolicyMap[key].isResolved;
                    }
                    component.set("v.caseWrapper", caseWrapper);
                    if (finalPolicyMap[key].selectedSourceCode != 'AP') {
                        //ORS Flow
                        helper.createOrsCase(component, event, helper);
                    } else {
                        //FACETS FLOW
                        helper.createCaseItemsForApPolicy(component, event, helper);
                        helper.createFacetsCase(component, event, helper);
                    }

                }
            }
        } else {
            if (caseWrapper.AddInfoTopic != 'Member Not Found') { //US2951245 - Sravan
                //ORS Flow
                helper.createOrsCase(component, event, helper);
            } else {
                //FACETS FLOW
                helper.createCaseItemsForApPolicy(component, event, helper);
                helper.createFacetsCase(component, event, helper);
            }
        }
    },

    //US3068299 - Sravan - 21/11/2020
    createOrsCase: function(component, event, helper) {
        var caseWrapper = component.get("v.caseWrapper");

        var lstUnResolvedProviders = component.get("v.lstUnResolvedProviders") ;

           if(caseWrapper.AddInfoTopic == "Provider Details"){
                    if( !$A.util.isEmpty(lstUnResolvedProviders) && lstUnResolvedProviders[0].IsDelegatedSpeciality){

                        if ( caseWrapper.relatedCaseItemsMap != undefined && !$A.util.isEmpty(caseWrapper.relatedCaseItemsMap)  ){

                            for (const [key, value] of Object.entries(caseWrapper.relatedCaseItemsMap)) {

                                var relatedCaseItem = value;
                                if(relatedCaseItem.topic == "Provider Details" ){
                                    relatedCaseItem.isResolved = true;
                                }

                            };

                        }
                    }
            }
        console.log('In Routing' + JSON.stringify(caseWrapper));
        var caseId = component.get("v.caseId");
        var strWrapper = '';
        if (!$A.util.isUndefinedOrNull(caseWrapper) && !$A.util.isEmpty(caseWrapper)) {
            strWrapper = JSON.stringify(caseWrapper);
        }

        var actionORS = component.get("c.saveOrsCase");
        actionORS.setParams({
            'strRecord': strWrapper,
            'caseId': caseId
        });
        actionORS.setCallback(this, function(responseORS) {
            let strTitle, strMessage;
            let toastEvent = $A.get("e.force:showToast");
            var state = responseORS.getState();
            var responseList = responseORS.getReturnValue();
            if (state === "SUCCESS") {
                if (responseList.length > 0) {
                    if (responseList[0].resultStatus != 200) {
                        strTitle = 'success';
                        strMessage = responseList[0].resultStatusMessage;
                        //this.fireErrorToastMessage(responseList[0].resultStatusMessage);
                    }
                }
                helper.navigateToCaseDetail(component, event, helper);
            } else {
                strTitle = 'error';
                strMessage = "Unexpected error occured. Please try again. If problem persists contact help desk.";
                //this.fireErrorToastMessage("Unexpected error occured. Please try again. If problem persists contact help desk.");
                helper.navigateToCaseDetail(component, event, helper);
            }
            toastEvent.setParams({
                "title": "Info !!",
                "message": strMessage,
                "type": strTitle
            });
            toastEvent.fire();
        });
        $A.enqueueAction(actionORS);
    },

    //US3068299 - Sravan - 21/11/2020
    createFacetsCase: function(objComponent, objEvent, objHelper) {
        var caseWrapper = objComponent.get("v.caseWrapper");
        console.log('In Routing' + JSON.stringify(caseWrapper));
        var caseId = objComponent.get("v.caseId");
        var strWrapper = '';
        if (!$A.util.isUndefinedOrNull(caseWrapper) && !$A.util.isEmpty(caseWrapper)) {
            strWrapper = JSON.stringify(caseWrapper);
        }
        let action = objComponent.get("c.saveFacetsCase");
        action.setParams({
            'strRecord': strWrapper,
            'caseId': caseId
        });
        action.setCallback(this, function(response) {
            let objResponse, strTitle, strMessage;
            let toastEvent = $A.get("e.force:showToast");
            if (response && response.getState() == 'SUCCESS') {
                objResponse = response.getReturnValue();
                strTitle = '';
                if (objResponse) {
                    objResponse = JSON.parse(objResponse);
                    if (objResponse.strResponse) {
                        strMessage = objResponse.strResponse;
                    } else {
                        strMessage = '';
                    }
                    if (objResponse.isSuccess == true) {
                        strTitle = 'success';
                    } else {
                        strTitle = 'error'
                    }
                }
            } else {
                strTitle = 'error';
                strMessage = 'Facets Case Creation Failed'
            }
            toastEvent.setParams({
                "title": "Info !!",
                "message": strMessage,
                "type": strTitle
            });
            toastEvent.fire();
            objHelper.navigateToCaseDetail(objComponent, objEvent, objHelper);
        });
        $A.enqueueAction(action);
    },

    getUnResolvedProviderData: function(component, mapOfSpecialityData, objCaseWrapper) {
        let objAutoDocData = JSON.parse(objCaseWrapper['savedAutodoc']),
            unResolvedProviderData = new Map(),
            lstHeaders = [],
            mapEachSelectedUnResolvedRow = new Map(),
            lstUniqueKeys = [],
            lstData = [],
            lstDelegatedData = [],
            lstAllDelegatedData = [],
            mapOfSelectedRowsWithPolicies = new Map(),
        	strSourceCode = '--';
        if (objAutoDocData) {
            objAutoDocData.forEach(function(objKey) {
                if(objKey && objKey['autodocHeaderName'] && (objKey['autodocHeaderName'] == 'Policies') ) {
                    objKey['selectedRows'].forEach(function(objSelectedRow) {
                        if(objSelectedRow && objSelectedRow['rowColumnData']) {
                            strSourceCode = objSelectedRow['rowColumnData'][1]['fieldValue'];
                        }
                    });
                }

                if (objKey['autodocHeaderName'] && objKey['autodocHeaderName'] == 'Provider Lookup Results') {
                    lstUniqueKeys = [];
                    lstHeaders = objKey['tableHeaders'];

                    objKey['selectedRows'].forEach(function(objSelectedRow) {
                        if (objSelectedRow && objSelectedRow['resolved'] == false && objSelectedRow['createSRNProviderDetails']) {
                            unResolvedProviderData.set(objSelectedRow['uniqueKey'], objSelectedRow['createSRNProviderDetails']);
                            mapEachSelectedUnResolvedRow.set(objSelectedRow['uniqueKey'], objSelectedRow['rowColumnData']);
                            if(!lstUniqueKeys.includes(objSelectedRow['uniqueKey'])) {
                                lstUniqueKeys.push(objSelectedRow['uniqueKey']);
                            }
                        }
                    });
                    let isDelegated = false;
                    lstUniqueKeys.forEach(function(strEachKey) {
                        let objRowData = mapEachSelectedUnResolvedRow.get(strEachKey),
                            objModifiedData = {},
                            objDelegatedData = {},
                            objSRNData = unResolvedProviderData.get(strEachKey);
                        for (let i = 0; i < lstHeaders.length; i++) {
                            objModifiedData[lstHeaders[i].replace(' ', '').replace('/', '')] = objRowData[i]['fieldValue'];
                        }
                        objModifiedData['state'] = objSRNData['state'];
                        objModifiedData['city'] = objSRNData['city'];
                        objModifiedData['specialty'] = objSRNData['specialtyTypeDesc'];
                        objModifiedData['sourceCode'] = strSourceCode ? strSourceCode : '--';
                        objModifiedData['IsDelegatedSpeciality'] = mapOfSpecialityData.has(objSRNData['specialtyTypeDesc']) ? true : false;
                        objModifiedData['uniqueKey'] = strEachKey;
                        lstData.push(objModifiedData);
                        lstDelegatedData.push(objModifiedData['IsDelegatedSpeciality']);
                        objDelegatedData['uniqueKey'] = strEachKey;
                        objDelegatedData['isDelegatedSpecialty'] = mapOfSpecialityData.has(objSRNData['specialtyTypeDesc']) ? true : false;
                        lstAllDelegatedData.push(objDelegatedData);
                    });
                }
            });
            component.set('v.lstUnResolvedProviders', lstData);
            let isDelegated = lstDelegatedData.every(val => val === true) ? true : false;
            component.set("v.IsDelegatedSpeciality", isDelegated);
            component.set("v.strDelegatedData", JSON.stringify(lstAllDelegatedData));

			if($A.util.isUndefinedOrNull(component.get('v.lstUnResolvedProviders')) || $A.util.isEmpty(component.get('v.lstUnResolvedProviders'))){
                var lstSelectedRoutedProviders= [];
                var providerDetailsForRoutingScreen = component.get("v.providerDetailsForRoutingScreen");
                var objModifiedData={};
                objModifiedData['sourceCode'] = '--';
                objModifiedData['TAXID'] = providerDetailsForRoutingScreen.taxId;
                objModifiedData['PROVIDERNAME'] = providerDetailsForRoutingScreen.firstName + ' ' + providerDetailsForRoutingScreen.lastName;
                objModifiedData['PROVIDERIDMPIN'] = providerDetailsForRoutingScreen.providerId;
                objModifiedData['state'] = providerDetailsForRoutingScreen.state;
                objModifiedData['city'] = providerDetailsForRoutingScreen.AddressCity;
                objModifiedData['specialty'] = providerDetailsForRoutingScreen.specialtyTypeDesc == null ? '--' : providerDetailsForRoutingScreen.specialtyTypeDesc;
                objModifiedData['NPI'] =providerDetailsForRoutingScreen.npi;
                objModifiedData['IsDelegatedSpeciality']=mapOfSpecialityData.has( providerDetailsForRoutingScreen.specialtyTypeDesc) ? true : false;
                lstSelectedRoutedProviders.push(objModifiedData);
                component.set("v.lstUnResolvedProviders",lstSelectedRoutedProviders);

            }
        }
    },

    getSpecialityData: function(component, event, helper, caseWrapper) {
        let action = component.get("c.getRoutedDelatedData");
        action.setCallback(this, function(response) {
            if (response && response.getState() == 'SUCCESS') {
                let mapOfSpecialityData = new Map();
                response.getReturnValue().forEach(function(objSpeciality) {
                    mapOfSpecialityData.set(objSpeciality.Specialty_Short_Description__c, true);
                });
                helper.getUnResolvedProviderData(component, mapOfSpecialityData, caseWrapper);
            }
        });
        $A.enqueueAction(action);
    },

    setResolvedData: function(component, event, helper) {
            //Case Items
        let CaseWrapper = component.get("v.caseWrapper"),
            lstData = component.get('v.lstUnResolvedProviders');
            let saveAutodoc = JSON.parse(CaseWrapper.savedAutodoc);
            saveAutodoc.forEach(function(eachAutodoc) {
                let lstUpdateTableData = [];
                if (eachAutodoc.autodocHeaderName == 'Provider Lookup Results') {
                    for (let index = 0; index < eachAutodoc.selectedRows.length; index++) {
                        let element = eachAutodoc.selectedRows[index];
                        lstData.forEach(function(objDelegatedData) {
                        if (objDelegatedData.uniqueKey == element.uniqueKey && objDelegatedData.IsDelegatedSpeciality) {
                                element['resolved'] = true;
                            }
                        });
                        lstUpdateTableData.push(element);
                    }
                    eachAutodoc.selectedRows = lstUpdateTableData;
                }
            });
            CaseWrapper.savedAutodoc = JSON.stringify(saveAutodoc);
            component.set("v.caseWrapper", CaseWrapper);
        },

    //US3644559 - Sravan - Start
    createCaseItemsForApPolicy: function(component,event,helper){
      var insertCaseItems = component.get("c.insertCaseItems");
      insertCaseItems.setParams({
           caseId : component.get("v.caseId"),
           caseWrapper : JSON.stringify(component.get("v.caseWrapper"))
       });
      insertCaseItems.setCallback(this, function(response){
          var state = response.getState();
          if(state == 'SUCCESS'){

          }
          else{
              console.log('Error in case items creation for ap policies');
        }
      });
      $A.enqueueAction(insertCaseItems);
     }
    //US3644559 - Sravan - End
})