({
    // US3299151 - Thanish - 16th Mar 2021
    showEligibilityErrorMessage: true,
    eligibilityErrorMessage: "Unexpected Error Occured in the Policies Card. Please try again. If problem persists please contact the help desk",

    //DE364195 - Avish
    closedSnapShotHandler: function (cmp, event) {
        if (event.getParam('currentTabId') == cmp.get("v.currentTabId")) {
            cmp.set("v.isClosedTab", true);
        }
    },

    updateProviderDetails: function (cmp, event) {
        if (event.getParam('currentTabId') == cmp.get("v.currentTabId")) {
            var interactionOverviewTabId = cmp.get("v.interactionOverviewTabId");
            if (!cmp.get("v.isClosedTab")) {
                if (!$A.util.isUndefinedOrNull(cmp.get("v.isClosedTab")) && !cmp.get("v.isClosedTab")) {
                    if (!$A.util.isUndefinedOrNull(interactionOverviewTabId)) {
                        var interactionOverviewData = JSON.parse(JSON.stringify(_setAndGetSessionValues.getInteractionDetails(interactionOverviewTabId)));
                        var providerDetailsNew = interactionOverviewData.providerDetails;
                        var interactionCard = cmp.get("v.interactionCard");
                        var flowDetailsNew = interactionOverviewData.flowDetails;
                        //US3259671 - Sravan - Start
                        component.set("v.flowDetails",flowDetailsNew);
                        //US3259671 - Sravan - End
                        JSON.parse(JSON.stringify(interactionCard));
                        JSON.parse(JSON.stringify(providerDetailsNew));
                        var phoneNumber = providerDetailsNew.phoneNumber;
                        if (!phoneNumber.includes("(")) {
                            providerDetailsNew.phoneNumber = '(' + phoneNumber.substring(0, 3) + ') ' + phoneNumber.substring(3, 6) + '-' + phoneNumber.substring(6, 10);
                        }
                        if (interactionCard.contactName != flowDetailsNew.contactName ||
                            interactionCard.contactNumber != flowDetailsNew.contactNumber ||
                            interactionCard.contactExt != flowDetailsNew.contactExt ||
                            interactionCard.taxId != providerDetailsNew.taxId ||
                            interactionCard.npi != providerDetailsNew.npi ||
                            interactionCard.firstName != providerDetailsNew.firstName ||
                            interactionCard.lastName != providerDetailsNew.lastName ||
                            interactionCard.state != providerDetailsNew.state ||
                            interactionCard.filterType != providerDetailsNew.filterType ||
                            interactionCard.zip != providerDetailsNew.zip ||
                            interactionCard.phone != providerDetailsNew.phoneNumber) {
                            if (!interactionCard.isNoProviderToSearch) {
                                var interactionObj = {
                                    "contactName": flowDetailsNew.contactName,
                                    "contactNumber": interactionCard.contactNumber,
                                    "contactExt": flowDetailsNew.contactExt,
                                    "taxId": providerDetailsNew.taxId,
                                    "npi": providerDetailsNew.npi,
                                    "firstName": providerDetailsNew.firstName,
                                    "lastName": providerDetailsNew.lastName,
                                    "state": providerDetailsNew.state,
                                    "phone": providerDetailsNew.phoneNumber,
                                    "primarySpeaciality": providerDetailsNew.primarySpeciality,
                                    "taxIdOrNPI": interactionCard.taxIdOrNPI
                                };
                                cmp.set("v.interactionCard", interactionObj);
                            }
                        }
                    }
                }
            }
        }
    },

    getEnclosingTabIdHelper: function (cmp, event) {
        var workspaceAPI = cmp.find("workspace");
        workspaceAPI.getEnclosingTabId().then(function (tabId) {
                console.log(tabId);
                cmp.set("v.currentTabId", tabId);
                cmp.set("v.callTopicTabId", tabId);
            })
            .catch(function (error) {
                console.log(error);
            });
    }, //DE364195 - Ends

    getMemberData: function (component, event, helper) {

        //US1761826 - UHC/Optum Exclusion UI : START
        let action = component.get("c.getOptumExlusions");
        action.setCallback(this, function (response) {
            let state = response.getState();
            if (state === "SUCCESS") {

                component.set("v.lstExlusions", response.getReturnValue());
                helper.processMemberData(component, event, helper);
            } else {

            }
        });
        $A.enqueueAction(action);
        //US1761826 - UHC/Optum Exclusion UI : END

    },

    createGUID: function (component, event, helper) {
        var len = 20;
        var buf = [],
            chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789',
            charlen = chars.length,
            length = len || 32;

        for (var i = 0; i < length; i++) {
            buf[i] = chars.charAt(Math.floor(Math.random() * charlen));
        }
        var GUIkey = buf.join('');
        component.set("v.guid", GUIkey);
    },

    //US1970508 - Ravindra - start
    createOrUpdatePersonAccount: function (cmp, mnf, firstName, lastName, memberDOB, memberId, groupNumber, memberPhone) {

        var action = cmp.get("c.upsertPersonAccount");

        //var subjectCard = cmp.get("v.subjectCard");
        //var srkUnique = memberDOB.replace(/\//g,''); //firstName + lastName + memberDOB.replace(/\//g,'') + memberId + groupNumber;
        //cmp.set("v.xRefId",srkUnique);
        if (!$A.util.isEmpty(memberDOB)) {
            var dobMem = memberDOB.split('/');
            cmp.set("v.xRefId", firstName + lastName + dobMem[0] + dobMem[1] + dobMem[2] + memberId + groupNumber);

            // US2667560 -  Sanka - ORS Family Filtering
            cmp.set("v.xRefIdORS", firstName + memberId + '0' + groupNumber);
        }
        //cmp.set("v.xRefId", firstName + lastName + memberDOB.replace('/', '') + memberId + groupNumber);//ii
        action.setParams({
            "memberFirstName": firstName,
            "memberLastName": lastName,
            "memberDOB": memberDOB,
            "memberId": memberId,
            "groupNumber": groupNumber,
            "memberPhone": memberPhone,
            //"xRefId": cmp.get("v.xRefId"),
            "interactionId": cmp.get("v.interactionRec.Id"),
            "mnf": mnf,
            "isProviderSearchDisabled": cmp.get("v.isProviderSearchDisabled"),
            "isOtherSearch": cmp.get("v.isOtherSearch")
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state == 'SUCCESS') {
                //US2465288 - Avish
                this.hideGlobalSpinner(cmp);
                //this.getMemberCaseHistory(cmp,memberId,cmp.get("v.xRefId"));
                var result = response.getReturnValue();
                cmp.set("v.memberPersonAccount", result);
                if (mnf != 'mnf') {
                    var MNFCaseWrapper = cmp.get("v.caseWrapperMNF");
                    MNFCaseWrapper.memberContactId = result.PersonContactId;
                    cmp.set("v.caseWrapperMNF", MNFCaseWrapper);
                }
            } else {
                this.hideGlobalSpinner(cmp);
            }
        });
        $A.enqueueAction(action);
    },
    //US1970508 - Ravindra - end

    //US2465288 - Avish
    getMemberCaseHistory: function (cmp, memberId, xRefId) {
        var action = cmp.get("c.getRelatedCasesHistory");
        action.setParams({
            "taxMemberID": memberId,
            "xRefIdIndividual": xRefId,
            "toggleOnOff": false,
            "flowType": 'Member'
        });

        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state == 'SUCCESS') {
                this.hideGlobalSpinner(cmp);
                var caselst = [];

                caselst = response.getReturnValue();
                cmp.set("v.caseHistoryList", caselst);
                var appEvent = $A.get("e.c:SAE_CaseHistoryEvent");
                appEvent.setParams({
                    "caseHistoryList": cmp.get("v.caseHistoryList"),
                    "xRefId": xRefId,
                    "memberID": memberId,
                    "memberTabId": cmp.get('v.memberTabId')
                });
                appEvent.fire();

            } else {
                this.hideGlobalSpinner(cmp);
            }
        });
        $A.enqueueAction(action);
    },


    fetchMockStatus: function (component) {
        let action = component.get("c.getMockStatus");
        action.setCallback(this, function (response) {
            let state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.isMockEnabled", response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    },

    fireToast: function (message) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "Error!",
            "message": message,
            "type": "error",
            "mode": "sticky"
        });
        toastEvent.fire();
    },

    // DE387123 - Thanish - 18th Nov 2020
    showGlobalSpinner: function (cmp) {
        var spinner = document.getElementById(cmp.get("v.currentTabId") + "global-spinner");
        $A.util.removeClass(spinner, "slds-hide");
        $A.util.addClass(spinner, "slds-show");
    },

    hideGlobalSpinner: function (cmp) {
        var spinner = document.getElementById(cmp.get("v.currentTabId") + "global-spinner");
        $A.util.removeClass(spinner, "slds-show");
        $A.util.addClass(spinner, "slds-hide");
    },

    //US1761826 - UHC/Optum Exclusion UI - START
    fetchExlusionMdtData: function (component, event, helper) {
        let action = component.get("c.getOptumExlusions");
        action.setCallback(this, function (response) {
            let state = response.getState();
            if (state === "SUCCESS") {

                component.set("v.lstExlusions", response.getReturnValue());
                let lstExclusions = component.get("v.lstExlusions");
            } else {}
        });
        $A.enqueueAction(action);
    },
    //US1761826 - UHC/Optum Exclusion UI : START
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
    //US1761826 - UHC/Optum Exclusion UI : END
    processMemberData: function (component, event, helper) {
        //vishnu start
        var tabId;
        var workspaceAPI = component.find("workspace");
        workspaceAPI.getFocusedTabInfo().then(function (response) {
                tabId = response.tabId;

            })
            .catch(function (error) {
                console.log(error);
            });
        //vishnu end
        //US1761826 - UHC/Optum Exclusion UI : START
        let lstExclusions = component.get("v.lstExlusions");
        //alert(lstExclusions.length);
        let mapExclusions = new Map();
        //mapExclusions.set('706577', '706577');
        for (let i = 0; lstExclusions.length > i; i++) {
            mapExclusions.set(lstExclusions[i].MasterLabel, lstExclusions[i].MasterLabel);
        }


        //US1761826 - UHC/Optum Exclusion UI : END
        var action;
        var isCallout = true;
        if (component.get("v.isMockEnabled")) {
            action = component.get("c.getElibilityMockData");
        } else {
            action = component.get("c.callEligibilityServices");
        }

        var memberDOBVar = component.get("v.memberDOB");
        var memberDOB = "";
        if (!$A.util.isEmpty(memberDOBVar)) {
            var memberDOBArray = memberDOBVar.split("/");
            memberDOB = memberDOBArray[2] + '-' + memberDOBArray[0] + '-' + memberDOBArray[1];
        }

        /*** US3076045 - Avish **/
        var memberDetails = {
            memberId: component.get("v.memberId"),
            memberDOB: memberDOB,
            firstName: component.get("v.memberFN"),
            lastName: component.get("v.memberLN"),
            groupNumber: '',
            searchOption: component.get("v.searchOption"),
            payerID: component.get("v.payerID"),
            isFourthCallout: false
        };

        /*** US3076045 - End **/
        action.setParams({
            memberDetails: memberDetails, //US3076045 - Avish 
            providerDetails: component.get("v.providerDetails")
        });

        action.setCallback(this, function (response) {
            var state = response.getState();
            // US1813580 - Error Message Translation
            // Sanka Dharmasena - 12/06/2019
            var result = response.getReturnValue();
            //US2100807: Added by Ravindra
            result = JSON.parse(result);

            if (state == "SUCCESS" && result.statusCode == 200) {
                this.hideGlobalSpinner(component);
                // component.get("v.interactionOverviewTabId")+
                if (!$A.util.isUndefinedOrNull(tabId)) {
                    _setAndGetSessionValues.settingValue("Member:" + tabId + ":" + tabId, result.resultWrapper);
                }
                // var retval=_setAndGetSessionValues.getSRNEligibilityData(component.get("v.interactionOverviewTabId")+"123");
                // US2804912 - Avish
                if (isCallout) {
                    isCallout = false;
                    this.processEligibilityRepsonse(component, event, result);
                }

            } else {
                // US2804912 - Avishs
                if (result != null && (result.message != '' && result.message != null)) {
                    if (result.message.includes('AAA:72') || result.message.includes('AAA:73') || result.message.includes('AAA:76') ||
                        result.message.includes('AAA:7371')) {
                        var action2 = component.get("c.fourthCallout");
                        var isCalloutFourth = true;
                        /*** US3076045 - Avish **/
                        var memberDetails = {
                            memberId: component.get("v.memberId"),
                            memberDOB: memberDOB,
                            firstName: component.get("v.memberFN"),
                            lastName: component.get("v.memberLN"),
                            groupNumber: '',
                            searchOption: 'NameDateOfBirth',
                            payerID: component.get("v.payerID"),
                            isFourthCallout: true
                        };
                        /*** US3076045 - End **/
                        action2.setParams({
                            memberDetails: memberDetails, //US3076045 - Avish 
                            providerDetails: component.get("v.providerDetails")
                        });

                        action2.setCallback(this, function (response) {
                            var state = response.getState();
                            var resultFourthCall = response.getReturnValue();
                            resultFourthCall = JSON.parse(resultFourthCall);

                            if (state == "SUCCESS" && resultFourthCall.statusCode == 200) {
                                this.hideGlobalSpinner(component);
                                if (!$A.util.isUndefinedOrNull(tabId)) {
                                    _setAndGetSessionValues.settingValue("Member:" + tabId + ":" + tabId, resultFourthCall.resultWrapper);
                                }
                                if (isCalloutFourth) {
                                    isCalloutFourth = false;

                                    this.processEligibilityRepsonse(component, event, resultFourthCall);
                                }
                            } else {
                                this.hideGlobalSpinner(component);
                                component.set("v.isNoPolicies", true);
                                if (resultFourthCall != null) {
                                    var memberLst = [];
                                    // var indexStr = resultFourthCall.message.indexOf("(");
                                    // var res = resultFourthCall.message.substring(0, indexStr);
                                    // US3299151 - Thanish - 16th Mar 2021
                                    if(this.showEligibilityErrorMessage){
                                        helper.fireToastMessage("We hit a snag.", this.eligibilityErrorMessage, "error", "error", "30000");
                                        this.showEligibilityErrorMessage = false;
                                    }
                                    component.set("v.memberPolicies", memberLst);
                                }
                            }
                            component.set("v.policySpinner", false); // US3299151 - Thanish - 16th Mar 2021
                        });
                        $A.enqueueAction(action2);

                    } else {
                        this.hideGlobalSpinner(component);
                        component.set("v.isNoPolicies", true);
                        if (result != null && (result.message != '' && result.message != null)) {
                            var memberLst = [];
                            // var indexStr = result.message.indexOf("(");
                            // var res = result.message.substring(0, indexStr);
                            // US3299151 - Thanish - 16th Mar 2021
                            if(this.showEligibilityErrorMessage){
                                helper.fireToastMessage("We hit a snag.", this.eligibilityErrorMessage, "error", "error", "30000");
                                this.showEligibilityErrorMessage = false;
                            }
                            component.set("v.memberPolicies", memberLst);
                        }
                        component.set("v.policySpinner", false); // US3299151 - Thanish - 16th Mar 2021
                    }
                } // US2804912 - Ends
            }

        });
        $A.enqueueAction(action);
    },

    processEligibilityRepsonse: function (component, event, result) {
        //US1933887 - UHG Access
        //Sanka D. - 31.07.2019
        if (!$A.util.isEmpty(result.hasAccess)) {
            component.set('v.uhgAccess', result.hasAccess); // Moved this code inside the loop as a part of DE289195 - Avish
        }
        var coverageLines = result.resultWrapper.CoverageLines;
        var ishighlightedPolicy;

        //Ketki open member snapshot for claim
        var iVRDetails=component.get("v.iVRDetails");
        var isVCCD=component.get("v.isVCCD");
        let claimsDOSMD ="";
        if(isVCCD){
            var iVRDetails=component.get("v.iVRDetails");
            console.log("iVRDetails "+iVRDetails);
            claimsDOSMD=iVRDetails.ClaimsDOSMD__c;
        }

        var policyDateRange = component.get("v.policyDateRange");
        var memberGrpN = component.get("v.memberGrpN");

        if (!$A.util.isEmpty(claimsDOSMD)) {
            var claimsDOS = Date.parse(claimsDOSMD.trim());
            for ( var i = 0; i<coverageLines.length ; i++){
                var cov= coverageLines[i];
                var eligibleDates = cov.eligibleDates;
                var eligibleDatesArr = eligibleDates.split('-')
                var eligibleDateBegin = Date.parse(eligibleDatesArr[0].trim());
                var eligibleDateEnd = Date.parse(eligibleDatesArr[1].trim());

                if (eligibleDateBegin <= claimsDOS && eligibleDateEnd >= claimsDOS ){
                    cov.highlightedPolicy = true;
                    break;
                } else {
                    cov.highlightedPolicy = null;

                }
             }
        }

        if (!$A.util.isEmpty(policyDateRange)) {

            var policyDateRangeArr = policyDateRange.split('-')
            var policyDateBegin = Date.parse(policyDateRangeArr[0].trim());
            var policyDateEnd = Date.parse(policyDateRangeArr[1].trim());
			for ( var i = 0; i<coverageLines.length ; i++){
                var cov= coverageLines[i];
                var eligibleDates = cov.eligibleDates;
                var eligibleDatesArr = eligibleDates.split('-')
                var eligibleDateBegin = Date.parse(eligibleDatesArr[0].trim());
                var eligibleDateEnd = Date.parse(eligibleDatesArr[1].trim());
                var groupNbr = cov.GroupNumber;

                if (eligibleDateBegin <= policyDateBegin && eligibleDateEnd >= policyDateBegin && memberGrpN == groupNbr){
                    cov.highlightedPolicy = true;
                    break;
                } else {
                    cov.highlightedPolicy = null;

                }
            }
        }

        //Ketki open member snapshot for claim end

        for (var i = 0; i < coverageLines.length; i++) {
            if (coverageLines[i].highlightedPolicy == true) {
                ishighlightedPolicy = true;
                component.set("v.tranId", coverageLines[i].transactionId);
                component.set("v.currentTransactionId", coverageLines[i].transactionId); //US2855833
                component.set("v.contactAddress", coverageLines[i].addressLine1);
                component.set("v.city", coverageLines[i].city);
                component.set("v.state", coverageLines[i].state);
                component.set("v.zip", coverageLines[i].zip);

            }
        }

        if ($A.util.isEmpty(result.resultWrapper.CoverageLines) && result.resultWrapper.CoverageLines.length == 0) {
            component.set("v.isNoPolicies", true);
        } else if (!ishighlightedPolicy) {
            component.set("v.isNoPolicies", true);
            component.set("v.memberPolicies", result.resultWrapper.CoverageLines);
        } else {
            component.set("v.isNoPolicies", false);
            component.set("v.memberPolicies", result.resultWrapper.CoverageLines);
        }

        //USS2221006 - START
        if (!$A.util.isUndefinedOrNull(result.message) && result.message.includes('AAA:72')) {
            // US3299151 - Thanish - 16th Mar 2021
            if(this.showEligibilityErrorMessage){
                helper.fireToastMessage("We hit a snag.", this.eligibilityErrorMessage, "error", "error", "30000");
                this.showEligibilityErrorMessage = false;
            }
        }
        //USS2221006 - END

        component.set("v.memberCardData", result.resultWrapper);

        //US2137922: Added by Ravindra
        //To refresh member details in member details card
        var memberCmp = component.find("memberDetailsAI");
        if (memberCmp != null && memberCmp != undefined) {
            memberCmp.refreshPatientDetails();
        }

    },

    processSubjectCardData: function (component, event, helper) {


        var memberDOBVar = component.get("v.memberDOB");
        var memberDOB = "";
        if (!$A.util.isEmpty(memberDOBVar)) {
            var memberDOBArray = memberDOBVar.split("/");
            memberDOB = memberDOBArray[2] + '-' + memberDOBArray[0] + '-' + memberDOBArray[1];
        }

        var action = component.get('c.subjectCardPopulation');
        var providerDetails = component.get("v.providerDetails");

        /*** US3076045 - Avish **/
        var memberDetails = {
            memberId: component.get("v.memberId"),
            memberDOB: memberDOB,
            firstName: component.get("v.memberFN"),
            lastName: component.get("v.memberLN"),
            groupNumber: component.get("v.memberGrpN"),
            searchOption: component.get("v.searchOption"),
            payerID: component.get("v.payerID"),
            isFourthCallout : false
        };

        /*** US3076045 - End **/
        action.setParams({
            memberDetails : memberDetails, //US3076045 - Avish
            providerDetails: component.get("v.providerDetails")
        });

        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state == 'SUCCESS') {
                var result = response.getReturnValue();
                if (result.statusCode == 200) {

                    var subjectCard = result.resultWrapper.subjectCard;
                    if (subjectCard != "" && subjectCard != undefined) {
                        var ssnValue = subjectCard.SSN;
                        var eeIdValue = subjectCard.EEID;
                        subjectCard.maskedSSN = 'xxx-xx-' + ssnValue.substring(5, 9);
                        subjectCard.formattedSSN = ssnValue.substring(0, 3) + '-' + ssnValue.substring(3, 5) + '-' + ssnValue.substring(5, 9);
                        subjectCard.maskedEEID = 'xxxxx' + eeIdValue.substring(5, 9);
                    }

                    component.set("v.memberCardSnap", subjectCard);
                    this.createOrUpdatePersonAccount(component, component.get("v.mnf"), component.get("v.memberFN"), component.get("v.memberLN"), component.get("v.memberDOB"), component.get("v.memberId"), component.get("v.memberGrpN")); //DE284951 Avish
                } else {
                    // US3299151 - Thanish - 16th Mar 2021
                    if(this.showEligibilityErrorMessage){
                        helper.fireToastMessage("We hit a snag.", this.eligibilityErrorMessage, "error", "error", "30000");
                        this.showEligibilityErrorMessage = false;
                    }
                }
            }

        });
        $A.enqueueAction(action);
    },

    //US1970508 - Ravindra - start
    saveCase: function (cmp, event, helper) {
        var caseWrapper = {}; // cmp.get('v.SAETTSCaseWrapper');
        /*// Case
        caseWrapper.Status = 'Open';
        caseWrapper.Interaction = cmp.get('v.interactionRec').Id;
        // Originator
        caseWrapper.OriginatorName = cmp.get('v.interactionCard').name;
        caseWrapper.OriginatorRelationship = ''; // cmp.get('v.memberId');
        caseWrapper.OriginatorType = 'Provider';
        caseWrapper.OriginatorPhone = cmp.get('v.memPhone');
        caseWrapper.OriginatorEmail = cmp.get('v.memPhone');
        caseWrapper.OriginatorContactName = cmp.get('v.contactName');
        // Subject
        var memberCardData = cmp.get('v.memberCardData');
        caseWrapper.SubjectName = (memberCardData.fullName == undefined ? '' : memberCardData.fullName);
        caseWrapper.SubjectType = 'Member';
        caseWrapper.SubjectDOB = (memberCardData.dob == undefined ? '' : memberCardData.dob);
        caseWrapper.SubjectId = (memberCardData.MemberId == undefined ? '' : memberCardData.MemberId);
        caseWrapper.SubjectGroupId = (cmp.get('v.memberPolicies')[0] == undefined ? '' : cmp.get('v.memberPolicies')[0].GroupNumber); // cmp.get('v.memberGrpN');
        // Additional Info
        caseWrapper.AddInfoTopic = cmp.get('v.Topic'); // 'View Member Eligibility';
        caseWrapper.AddInfoOrginType = cmp.get('v.Type'); // 'Issue Resolved';
        caseWrapper.AddInfoOrginSubType = cmp.get('v.SubType'); // 'Verify Eligibility';
        // Comments
        caseWrapper.CommentPublic = '';
        caseWrapper.CommentDesc = '';*/
        var interactionRec = cmp.get("v.interactionRec");
        var interactionCard = cmp.get("v.interactionCard");

        var providerNameID = "";
        var providerId = "";
        if (cmp.get("v.providerNotFound")) {
            providerNameID = interactionCard.taxIdOrNPI;
        } else if (cmp.get("v.isProviderSearchDisabled")) {
            providerNameID = "";
        } else {
            providerNameID = interactionCard.taxId;
            providerId = interactionCard.providerId;
        }
        var memberFirstName = "";
        var memberLastName = "";
        var subjectCard = cmp.get("v.subjectCard");
        if (!$A.util.isEmpty(subjectCard)) {
            memberFirstName = subjectCard.firstName;
            memberLastName = subjectCard.lastName;
        }
        //provider flow info
        caseWrapper.providerNotFound = cmp.get("v.providerNotFound");
        caseWrapper.noProviderToSearch = cmp.get("v.isProviderSearchDisabled");
        caseWrapper.isOtherSearch = cmp.get("v.isOther");

        caseWrapper.mnf = cmp.get("v.mnf");


        // Case
        caseWrapper.Status = 'Open';
        caseWrapper.Interaction = interactionRec.Id;
        // Originator
        caseWrapper.ContactId = interactionRec.Originator__c; //
        caseWrapper.providerId = providerId; //
        caseWrapper.TaxId = providerNameID; //
        caseWrapper.OriginatorName = interactionRec.name;
        caseWrapper.OriginatorRelationship = ''; // cmp.get('v.memberId');
        caseWrapper.OriginatorType = 'Provider';
        caseWrapper.OriginatorPhone = cmp.get('v.memPhone');
        caseWrapper.OriginatorEmail = cmp.get('v.memPhone');
        caseWrapper.OriginatorContactName = cmp.get('v.contactName');
        // Subject
        var memberCardData = cmp.get('v.memberCardData');
        //caseWrapper.xRefId = cmp.get("v.xRefId"); //
        caseWrapper.SubjectName = (memberCardData.fullName == undefined ? '' : memberCardData.fullName);
        caseWrapper.SubjectType = 'Member';
        caseWrapper.SubjectDOB = (memberCardData.dob == undefined ? '' : memberCardData.dob);
        caseWrapper.SubjectId = (memberCardData.MemberId == undefined ? '' : memberCardData.MemberId);
        caseWrapper.SubjectGroupId = (cmp.get('v.memberPolicies')[0] == undefined ? '' : cmp.get('v.memberPolicies')[0].GroupNumber); // cmp.get('v.memberGrpN');
        // Additional Info
        caseWrapper.AddInfoTopic = cmp.get('v.Topic'); // 'View Member Eligibility';
        caseWrapper.AddInfoOrginType = cmp.get('v.Type'); // 'Issue Resolved';
        caseWrapper.AddInfoOrginSubType = cmp.get('v.SubType'); // 'Verify Eligibility';
        // Comments
        caseWrapper.CommentPublic = '';
        caseWrapper.CommentDesc = '';
        cmp.set('v.caseWrapper', caseWrapper);
        var strWrapper = JSON.stringify(caseWrapper);
        var action = cmp.get("c.postCaseWrapper");
        action.setParams({
            'strWrapper': strWrapper
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                cmp.set('v.IsCaseSaved', false);
                var response = response.getReturnValue();
                /*var navEvt = $A.get("e.force:navigateToSObject");
                navEvt.setParams({
                  "recordId": response,
                  "slideDevName": "Detail"
                });
                navEvt.fire();*/
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success!",
                    "message": "The case record has been created successfully.",
                    "type": "success"
                });
                toastEvent.fire();
                var workspaceAPI = cmp.find("workspace");
                workspaceAPI.openTab({
                    url: '#/sObject/' + response + '/view',
                    focus: true
                });
            } else if (state === "INCOMPLETE") {

            } else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {

                    }
                } else {

                }
            }
        });
        $A.enqueueAction(action);
    },
    //US1970508 - Ravindra - end
    // US1909477 - Thanish (30th July 2019)
    // Purpose - Add misdirect button to page header.
    // Copied from SAE_MisdirectHelper.js
    openMisDirect: function (component, event, helper) {
        /**/
        var workspaceAPI = component.find("workspace");
        var misdirectCase = component.get("v.caseWrapperMNF"); //DE441126
        var interactionRecord = component.get("v.interactionRec");
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
                            "c__subjectName": misdirectCase.SubjectName,//US3612768 - Sravan
                            "c__subjectType": component.get('v.subjectType'),
                            "c__subjectDOB": component.get('v.subjectDOB'),
                            "c__subjectID": misdirectCase.SubjectId,//US3612768 - Sravan
                            "c__subjectGrpID": misdirectCase.SubjectGroupId,//US3612768 - Sravan
                            "c__interactionID": interactionRecord.Id,
                            "c__contactUniqueId": interactionRecord.Id,
                            "c__focusedTabId": enclosingTabId,
                            "c__onShoreRestriction" : misdirectCase.onShoreRestriction,
                            "c__uhgRestriction" : misdirectCase.uhgRestriction,
                            "c__sourceCode" : component.get("v.explorePageSourceCode"),//US2740876 - Sravan
                            "c__patientInfo": component.get("v.patientInfo"),//US3816776 - Sravan
                            "c__highlightedPolicySourceCode": component.get("v.highlightedPolicySourceCode"),//US3816776 - Sravan
                            "c__highlightedPolicyNumber" : component.get("v.highlightedPolicyNumber")//US3816776 - Sravan
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

                });
            }

        });
    },
    // Thanish - End of code.

    // US1959855 - Thanish - 23rd January 2020
    createCaseWrapper: function (cmp) {
        let caseWrapper = {};
        let interactionRec = cmp.get("v.interactionRec");
        let interactionCard = cmp.get("v.interactionCard");

        let providerNameID = "";
        let providerId = "";
        if (cmp.get("v.providerNotFound")) {
            providerNameID = interactionCard.taxIdOrNPI;
        } else if (cmp.get("v.isProviderSearchDisabled")) {
            providerNameID = "";
        } else {
            // US1958736 - Thanish - 6th Feb 2020 - interaction card returns empty in other search flow
            if (!$A.util.isEmpty(interactionCard)) {
                providerNameID = interactionCard.taxId;
                providerId = interactionCard.providerId;
            } else {
                providerNameID = '';
                providerId = '';
            }
        }
        let memberFirstName = "";
        let memberLastName = "";
        let subjectCard = cmp.get("v.subjectCard");
        if (!$A.util.isEmpty(subjectCard)) {
            memberFirstName = subjectCard.firstName;
            memberLastName = subjectCard.lastName;
        }
        //provider flow info
        caseWrapper.providerNotFound = cmp.get("v.providerNotFound");
        caseWrapper.noProviderToSearch = cmp.get("v.isProviderSearchDisabled");
        caseWrapper.isOtherSearch = cmp.get("v.isOther");
        caseWrapper.mnf = cmp.get("v.mnf");

        // Case
        caseWrapper.Status = 'Open';
        caseWrapper.Interaction = interactionRec.Id;
        // Originator
        caseWrapper.ContactId = interactionRec.Originator__c;
        caseWrapper.providerId = providerId;
        caseWrapper.TaxId = providerNameID;
        caseWrapper.OriginatorName = interactionRec.name;
        caseWrapper.OriginatorRelationship = '';
        caseWrapper.OriginatorType = 'Provider';
        caseWrapper.OriginatorPhone = cmp.get('v.memPhone');
        caseWrapper.OriginatorEmail = cmp.get('v.memPhone');
        // Production issue - Thanish - 3rd Feb 2020
        caseWrapper.OriginatorContactName = ($A.util.isEmpty(interactionCard) ? cmp.get("v.contactName") : interactionCard.contactName);
        // Subject
        // US2917371 - Thanish - 8th Dec 2020 - handling null exceptions for memberCardSnap
        caseWrapper.SubjectName = ($A.util.isEmpty(cmp.get('v.memberCardSnap.memberName')) ? '' : cmp.get('v.memberCardSnap.memberName'));
        caseWrapper.SubjectType = 'Member';
        caseWrapper.SubjectDOB = ($A.util.isEmpty(cmp.get('v.memberCardSnap.memberDOB')) ? '' : cmp.get('v.memberCardSnap.memberDOB'));
        caseWrapper.SubjectId = ($A.util.isEmpty(cmp.get('v.memberCardSnap.memberId')) ? '' : cmp.get('v.memberCardSnap.memberId'));
        caseWrapper.SubjectGroupId = (cmp.get('v.memberPolicies')[0] == undefined ? '' : cmp.get('v.memberPolicies')[0].GroupNumber);
        // Additional Info
        caseWrapper.AddInfoTopic = cmp.get('v.Topic');
        caseWrapper.AddInfoOrginType = cmp.get('v.Type');
        caseWrapper.AddInfoOrginSubType = cmp.get('v.SubType');
        // Comments
        caseWrapper.CommentPublic = '';
        caseWrapper.CommentDesc = '';
        caseWrapper.EEID = '';

        cmp.set("v.caseWrapper", caseWrapper);
    },
    postActionHousehold: function (component) {
        //US1857687
        var HouseholdData = component.get('v.extendedHouseholdData')
        var MNFCaseWrapper = component.get("v.caseWrapperMNF");
        for (var i in HouseholdData.houseHoldList) {
            MNFCaseWrapper.Relationship = HouseholdData.houseHoldList[i].relationship;
            component.set("v.caseWrapperMNF", MNFCaseWrapper);
            break;
        }
        component.set("v.houseHoldData", HouseholdData.houseHoldList);
    },

    getCSPProviderID: function (cmp, event, helper) {
        var providerDetails = cmp.get("v.providerDetails");
        var addressIdValue = '';
        if (!$A.util.isUndefinedOrNull(providerDetails) && !$A.util.isUndefinedOrNull(providerDetails.addressId)) {
            addressIdValue = providerDetails.addressId;
        }
        var providerIdValue = cmp.get("v.alertProviderId");
        var taxIdValue = cmp.get("v.alertTaxId");
        console.log('=Add ' + addressIdValue + ' P ' + providerIdValue + ' T ' + taxIdValue);

        let action = cmp.get("c.getCSPProviderId");
        action.setParams({
            providerId: providerIdValue,
            taxId: taxIdValue,
            addressId: addressIdValue
        });
        action.setCallback(this, function (response) {
            let state = response.getState();
            if (state === "SUCCESS") {
                console.log('=@#CSProviderValue' + JSON.parse(JSON.stringify(response.getReturnValue())));
                let objCaseWrapper = cmp.get("v.caseWrapperMNF");
                if(!$A.util.isUndefinedOrNull(objCaseWrapper) && !$A.util.isEmpty(objCaseWrapper)){
                    if(!$A.util.isUndefinedOrNull(response.getReturnValue()) && !$A.util.isEmpty(response.getReturnValue())){
                        objCaseWrapper['CSPProviderId'] =  response.getReturnValue();
                    }
                }
                cmp.set("v.caseWrapperMNF", objCaseWrapper);
                cmp.set("v.CSPProviderId", response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    },

    //US2478836 - Member Not Found Plan Type Card Link to OneSource - Sravan
    getOneSourceLink: function (component, event, helper) {
        var getOneSource = component.get("c.getOneSourceLink");
        getOneSource.setCallback(this, function (response) {
            var state = response.getState();
            if (state == 'SUCCESS') {
                if (!$A.util.isUndefinedOrNull(response.getReturnValue()) && !$A.util.isEmpty(response.getReturnValue())) {
                    component.set("v.oneSourceLink", response.getReturnValue());
                }
            }
        });
        $A.enqueueAction(getOneSource);
    },

    // US3536342 - Thanish - 3rd Jun 2021 - removed toggle comments and show hide comments

    openSaveCaseHelper: function (cmp, event, helper) {
        //need to call individual topics to get the proper case wrapper
        var caseNotSavedTopics = cmp.get("v.caseNotSavedTopics");
        var autodocUniqueId = cmp.get("v.autodocUniqueId");
        console.log(caseNotSavedTopics);
        //Autodoc String
        var returnObject = _autodoc.getAllAutoDoc(autodocUniqueId, false);
        var autodocValue = returnObject.selectedList;
        var unresolved = returnObject.unresolvedTopics;
        var jsString = JSON.stringify(autodocValue);

        let idToTopic = new Map([
            ['View Member Eligibility', autodocUniqueId],
            ['View Authorizations', autodocUniqueId + 'Auth'],
            ['Plan Benefits', autodocUniqueId + 'Financials'],
            ['View PCP Referrals', autodocUniqueId + 'Referrals'],
            ['Provider Lookup', autodocUniqueId + 'providerLookup'],
            ['View Claims', autodocUniqueId + 'claim'],
            ['View Payments', autodocUniqueId + 'payment'], //US3632386: View Payments - Auto Doc - Swapnil
            ['View Appeals', autodocUniqueId + 'appeals']
        ]);

        if (unresolved.size > 0 || !cmp.get("v.disableButtons")) {
            var warningStr = '<ul>';
            var topics = Array.from(unresolved);
            if (unresolved.size > 0) {
                topics.forEach(element => {
                    warningStr += '<li>' + element + '</li>';
                });
            }
            if (!cmp.get("v.disableButtons")) {
                warningStr += '<li>View Member Eligibility</li>';
            }
            warningStr += '</ul>';
            cmp.set("v.warningMessage", warningStr);
            cmp.set("v.showWarning", true);
        } else {
            if (caseNotSavedTopics.includes('Plan Benefits')) {
                var caseEvent = $A.get("e.c:ACET_HandleCaseWrapperEvent");
                caseEvent.setParams({
                    "autodocUniqueId": autodocUniqueId + 'Financials'
                });
                caseEvent.fire();
            }

            if (caseNotSavedTopics.includes('View Claims')) {
                var caseEvent = $A.get("e.c:ACET_HandleCaseWrapperEvent");
                caseEvent.setParams({
                    "autodocUniqueId": idToTopic.get('View Claims')
                });
                caseEvent.fire();
            }

            var openedTopicUniqueIds = cmp.get("v.openedTopicUniqueIds");
            caseNotSavedTopics.forEach(topic=>{
                if(!openedTopicUniqueIds.includes(topic)){
                    openedTopicUniqueIds.push(idToTopic.get(topic));
                }
            });

            cmp.set("v.openedTopicUniqueIds",openedTopicUniqueIds);
            //Get updated autodoc String - DE461397
            var autoItems = _autodoc.getAllAutoDoc(autodocUniqueId, false);
            jsString = JSON.stringify(autoItems.selectedList);
            var caseWrapper = cmp.get("v.caseWrapperMNF");
            caseWrapper.savedAutodoc = jsString;
            cmp.set("v.caseWrapperMNF", caseWrapper);

            // US3692809: Validating MNF Plan Type Card while save case - Krish - 2nd August 2021
             if(cmp.get('v.mnf') == 'mnf'){
                var isValidationSuccess = false;
                var memberNotFoundPlanType = cmp.find('memberNotFoundPlanType');
                if(!$A.util.isUndefinedOrNull(memberNotFoundPlanType)){
                    isValidationSuccess = memberNotFoundPlanType.fireSaveCaseValidations();
                }
                if(!isValidationSuccess){
                    return false;
                }
            }
            cmp.set("v.openSaveCase", true);
        }
    },
})