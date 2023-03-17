({
    // US3299151 - Thanish - 16th Mar 2021
    cobErrorMessage: "Unexpected Error Occurred in the Coordination of Benefits Card. Please try again. If problem persists please contact the help desk",

    getENICobInfo: function (cmp,event,helper) {
        let action = cmp.get("c.getENIData");
        var policyDetails = cmp.get("v.policyDetails");
        // console.log(JSON.stringify(policyDetails));
        // console.log(JSON.stringify(cmp.get("v.houseHoldData")));
        let householdList = cmp.get("v.houseHoldData");
        var householdMember;
        for(var i=0 ; i< householdList.length; i++) {
            if(householdList[i].isMainMember) {
                householdMember = householdList[i];
                break;
            }
        }
        let policyList = cmp.get("v.memberPolicies");
        var policyLine = policyList[cmp.get("v.policySelectedIndex")];
        let requestParamObj = {
            subscriberId: policyDetails.resultWrapper.policyRes.subscriberID,
            policyNumber: policyDetails.resultWrapper.policyRes.policyNumber,
            sourceCode: policyDetails.resultWrapper.policyRes.sourceCode,
            firstName: !$A.util.isEmpty(householdMember) ? householdMember.firstName : "",
            dateOfBirth: !$A.util.isEmpty(householdMember) ? householdMember.dob : "",
            isSubscriber: !$A.util.isEmpty(householdMember) ? (householdMember.relationship == 'Subscriber' ? true : false) : false
        }
        action.setParams({
            "reqParams": requestParamObj
        });

        action.setCallback(this, function (response) {
            let state = response.getState();
            if (state == "SUCCESS") {
                let result = response.getReturnValue();
                // US3299151 - Thanish - 16th Mar 2021
                if(policyDetails.resultWrapper.policyRes.sourceCode == "CS" && result.statusCode!=200){
                    this.fireToastMessage("We hit a snag.", this.cobErrorMessage, "error", "dismissible", "30000");
                }
                if (!$A.util.isEmpty(result.response)) {
                    if (policyDetails.resultWrapper.policyRes.sourceCode == "CS") {
                        var cardDetails = result.response.eniAutodocCard;
                        var caseItemsExternalId = this.getCaseItemsExternalId(cmp); // US3833197: Krish - 15th Sept 2021
                        cardDetails.caseItemsExtId = caseItemsExternalId; // US3833197: Krish - 15th Sept 2021
                        cmp.set("v.cardDetails", cardDetails);
                        var tableHistory = result.response.eniCobHistoryTable;
                        var tableRows = tableHistory.tableBody;
                        for(var i=0 ; i<tableHistory.tableBody.length; i++) {
                            tableHistory.tableBody[i].caseItemsExtId = caseItemsExternalId; // US3833197: Krish - 15th Sept 2021
                        }
                        cmp.set("v.cobENIHistoryTable", tableHistory);
                        cmp.set("v.regionCode", result.response.regionCode);
						cmp.set("v.claimEngineCode", result.response.claimEngineCode);																																									 
                        this.hideCobSpinner(cmp);
                    }
           // US3507486 - Setting RCED response to session data to use in Auth Creation
           var tabId = cmp.get('v.currentTabId');
           _setAndGetSessionValues.settingValue("RCED:" + tabId + ":" + tabId, result.response.createAuthDetails);

           // US3507486 Ends
                    cmp.set("v.dependentCode", result.response.dependentCode);
                    if (policyDetails.resultWrapper.policyRes.sourceCode == "CO" && !$A.util.isEmpty(cmp.get("v.dependentCode"))) {
                        this.getMNRCobInfo(cmp);
                    } else if(policyDetails.resultWrapper.policyRes.sourceCode != "CS") {
                        this.setAutodocCardData(cmp);
                    }
                } else {
                    this.setAutodocCardData(cmp);
                }
            } else {
                this.setAutodocCardData(cmp);
                this.fireToastMessage("We hit a snag.", this.cobErrorMessage, "error", "dismissible", "30000"); // US3299151 - Thanish - 16th Mar 2021
            }
            var isClaim = cmp.get("v.isClaim");
            if(isClaim){
                var cardDetails =  cmp.get("v.cardDetails");
                var claimNo =  cmp.get("v.claimNo");
                cardDetails.componentName = 'Coordination Of Benefits (COB): '+claimNo;
                // US3653575
                cardDetails.reportingHeader = 'Coordination Of Benefits (COB)';
                cardDetails.caseItemsExtId = claimNo;
                cardDetails.componentOrder = 11+(cmp.get("v.currentIndexOfOpenedTabs")*cmp.get("v.maxAutoDocComponents"));
                cmp.set("v.cardDetails", cardDetails);
            }
            var groupNumber = policyDetails.resultWrapper.policyRes.groupNumber;
            var appEvent = $A.get("e.c:ACET_claimDetailsCOBEvent");

            appEvent.setParams({"claimEngineCode" : cmp.get("v.claimEngineCode"),
                                "dccFlnNbr": cmp.get("v.dccflnNbr"),
                                "claimNumber":cmp.get("v.claimNo"),
                                "groupNumber": groupNumber});
            appEvent.fire();
        });
        $A.enqueueAction(action);
    },

    getMNRCobInfo: function (cmp) {
        let action = cmp.get("c.getMNRData");
        var policyDetails = cmp.get("v.policyDetails");
        console.log(JSON.stringify(policyDetails));
        let policyList = cmp.get("v.memberPolicies");
        var policyLine = policyList[cmp.get("v.policySelectedIndex")];
        console.log(JSON.stringify(policyLine));
        let requestParamObj = {
            cosmosDiv: policyDetails.resultWrapper.policyRes.cosmosDivision,
            groupNumber: !$A.util.isEmpty(policyLine.GroupNumber) ? policyLine.GroupNumber : policyDetails.resultWrapper.policyRes.policyNumber,
            subscriberId: policyDetails.resultWrapper.policyRes.subscriberID,
            dependentCode: cmp.get("v.dependentCode"),
            effectiveDate: policyDetails.resultWrapper.policyRes.coverageStartDate
        }
        action.setParams({
            "cobRequestInfo": requestParamObj
        });

        action.setCallback(this, function (response) {
            let state = response.getState();
            if (state == "SUCCESS") {
                let result = response.getReturnValue();
                if (!$A.util.isEmpty(result.response)) {
                    var cardDetails = result.response.cobCardData;
                    var caseItemsExternalId = this.getCaseItemsExternalId(cmp); // US3833197: Krish - 15th Sept 2021
                    cardDetails.caseItemsExtId = caseItemsExternalId; // US3833197: Krish - 15th Sept 2021
                    // US3653575
                    if (cmp.get("v.isClaim")) {
                        cardDetails.reportingHeader = 'Coordination Of Benefits (COB)';
                        cardDetails.caseItemsExtId = cmp.get("v.claimNo");
                    }
                    cmp.set("v.cardDetails", cardDetails);
                    var tableComments = result.response.cobCommentsTable;
                    var tableRows = tableComments.tableBody;
                    for(var i=0 ; i<tableComments.tableBody.length; i++) {
                        tableComments.tableBody[i].caseItemsExtId = caseItemsExternalId; // US3833197: Krish - 15th Sept 2021
                    }
                    cmp.set("v.cobMNRCommentsTable", tableComments);
                }
                // US3299151 - Thanish - 16th Mar 2021
                if(result.statusCode!=200){
                    this.fireToastMessage("We hit a snag.", this.cobErrorMessage, "error", "dismissible", "30000");
                }
            } else {
                this.fireToastMessage("We hit a snag.", this.cobErrorMessage, "error", "dismissible", "30000");
            }
            // US3340930 - Thanish - 6th Mar 2021
            this.hideCobSpinner(cmp);
        });
        $A.enqueueAction(action);
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

    showCobSpinner: function (cmp) {
        var spinner = cmp.find("cob-spinner");
        $A.util.removeClass(spinner, "slds-hide");
        $A.util.addClass(spinner, "slds-show");
    },

    hideCobSpinner: function (cmp) {
        var spinner = cmp.find("cob-spinner");
        $A.util.removeClass(spinner, "slds-show");
        $A.util.addClass(spinner, "slds-hide");
    },

    // US2579637
    /*updateCobData: function (component, event, helper) {
        component.set('v.isShowCobHistory', false); // US1954477 - Fix on 07/10/2019

        var COBExtendedData = component.get('v.COBExtendedData');
        component.set("v.cobData", COBExtendedData.cob);
        //US1954477	Targeted COB Details - Integration - 30/09/2019 - Sarma : Start
        var additionalCoverageList = COBExtendedData.additionalCoverageList;
        var secondaryCoverageList = [];
        var primaryCoverageList = []; // US2138007
        component.set('v.isPrimaryCoverageAvailable', false);
        component.set('v.isSecondaryCoverageAvailable', false);
        // US2138007 Update Logic for Targeted COB - 25/10/2019 - Sarma
        if (!$A.util.isEmpty(additionalCoverageList)) { // adding null check - Sarma - 04/11/2019
            var latestDateIndex = 0;
            var latestDateIndexTemp = 0;
            var counter = 0;
            for (var i = 0; i < additionalCoverageList.length; i++) {
                if (additionalCoverageList[i].primaryGroupIndicator == 'Y' || additionalCoverageList[i].primaryGroupIndicator == 'P') {
                    component.set('v.isPrimaryCoverageAvailable', true);
                    additionalCoverageList[i].primaryGroupIndicator = 'Yes';
                    primaryCoverageList.push(additionalCoverageList[i]);
                    if (additionalCoverageList[i].policyEffectiveStartDate < additionalCoverageList[latestDateIndexTemp].policyEffectiveStartDate) {
                        latestDateIndex = counter;
                        latestDateIndexTemp = i;
                    }

                    counter++;
                } else if (!$A.util.isEmpty(additionalCoverageList[i].primaryGroupIndicator)) {

                    additionalCoverageList[i].primaryGroupIndicator = 'No';
                    secondaryCoverageList.push(additionalCoverageList[i]);
                }
            }

            if (primaryCoverageList.length > 1) { //alert('P > 1');
                component.set('v.primaryCoverageDetails', primaryCoverageList[latestDateIndex]);
                primaryCoverageList.splice(latestDateIndex, 1);
                secondaryCoverageList = secondaryCoverageList.concat(primaryCoverageList);
            } else {
                component.set('v.primaryCoverageDetails', primaryCoverageList[0]);
            }

            if (secondaryCoverageList.length > 0) { //alert ( 'sec > 0')
                component.set('v.isSecondaryCoverageAvailable', true);
                component.set('v.secondaryCoverageList', secondaryCoverageList);
            } else {
                component.set('v.secondaryCoverageList', []);
            }
        }
    },*/

    // US2808743 - Thanish - 3rd Sep 2020 - New Autodoc Framework
    setAutodocCardData: function (cmp) {
        var autodocCmp;
        if(!$A.util.isEmpty(cmp.get("v.policyDetails"))) {
            autodocCmp = _autodoc.getAutodocComponent(cmp.get("v.autodocUniqueId"), cmp.get("v.policySelectedIndex"), "Coordination Of Benefits (COB)");   
        }

        if (!$A.util.isEmpty(autodocCmp)) {
            cmp.set("v.cardDetails", autodocCmp);

        } else {
            let policyList = cmp.get("v.memberPolicies");
            var policyLine = policyList[cmp.get("v.policySelectedIndex")];
            /*var isPrimaryCoverageAvailable = cmp.get("v.isPrimaryCoverageAvailable");
            var isSecondaryCoverageAvailable = cmp.get("v.isSecondaryCoverageAvailable");
            var cobData = cmp.get("v.cobData");
            var primaryCoverageDetails = cmp.get("v.primaryCoverageDetails");*/

        var cardDetails = new Object();
        cardDetails.componentName = "Coordination Of Benefits (COB)";
        cardDetails.componentOrder = 4;
        cardDetails.noOfColumns = "slds-size_6-of-12";
        cardDetails.type = "card";
        cardDetails.caseItemsExtId = this.getCaseItemsExternalId(cmp); // US3833197: Krish - 15th Sept 2021
            // US3653575
            if (cmp.get("v.isClaim")) {
                cardDetails.reportingHeader = 'Coordination Of Benefits (COB)';
                cardDetails.caseItemsExtId = cmp.get("v.claimNo");
            }
        cardDetails.allChecked = false;
        cardDetails.cardData = [
            // US3182441: COB Card Update Fields UI START
            {
                "checked": false,
                "defaultChecked": false,
                "fieldName": "Other Insurance/Type",
                "fieldType": "outputText",
                "fieldValue": "No/--",
                "showCheckbox": true,
                "isReportable": true
                }, 
                /*{
                "checked": false,
                "defaultChecked": false,
                    "fieldName": "Type",
                    "fieldType": "outputText",
                    "fieldValue": "--",
                    "showCheckbox": true,
                    "isReportable": true
                },*/
                {
                    "checked": false,
                    "defaultChecked": false,
                    "fieldName": "OI Eligible Dates",
                    "fieldType": "outputText",
                    "fieldValue": "--",
                    "showCheckbox": true,
                    "isReportable": true
                },
                {
                    "checked": false,
                    "defaultChecked": false,
                    "fieldName": "Other Insurance Primary",
                "fieldType": "outputText",
                "fieldValue": "No",
                "showCheckbox": true,
                "isReportable": true
            },
            {
                "checked": false,
                "defaultChecked": false,
                    "fieldName": "Primary Effective Dates",
                "fieldType": "outputText",
                "fieldValue": "--",
                "showCheckbox": true,
                "isReportable": true
            },
            {
                "checked": false,
                "defaultChecked": false,
                "fieldName": "Payer Name",
                "fieldType": "outputText",
                "fieldValue": "--",
                "showCheckbox": true,
                "isReportable": true
            },
            {
                "checked": false,
                "defaultChecked": false,
                "fieldName": "Medicare Information",
                "fieldType": "outputText",
                "fieldValue": "--",
                "showCheckbox": true,
                "isReportable": true
            },
            {
                "checked": false,
                "defaultChecked": false,
                "fieldName": "Update Status",
                "fieldType": "outputText",
                "fieldValue": "--",
                "showCheckbox": true,
                "isReportable": true
            },
            {
                "checked": false,
                "defaultChecked": false,
                "fieldName": "Last Updated Date",
                "fieldType": "outputText",
                "fieldValue": "--",
                "showCheckbox": true,
                "isReportable": true
            },
            {
                "checked": false,
                "defaultChecked": false,
                "fieldName": "",
                "fieldType": "link",
                    "fieldValue": "COB History/Comments",
                    "fieldValueStyle": "font-weight: bold;",
                    "width": "200%",
                    "showCheckbox": false,
                    "isReportable": true
                },
                {
                    "checked": false,
                    "defaultChecked": false,
                    "fieldName": "",
                    "fieldType": "link",
                "fieldValue": "COB Process SOP",
                "fieldValueStyle": "font-weight: bold;",
                "width": "200%",
                "showCheckbox": false,
                "isReportable": true
            },
            //US3182441: COB Card Update Fields UI END
        ];
        cmp.set("v.cardDetails", cardDetails);
        }
        // US3340930 - Thanish - 6th Mar 2021
        this.hideCobSpinner(cmp);
    },

    showCOBHistory: function (cmp) {
        var appevent = $A.get("e.c:SAE_COBHistoryEvent");
        appevent.setParams({
            "cobhistoryViewed": true,
            "originPage": cmp.get("v.memberTabId")
        });
        appevent.fire();
    },

    // US2645457: Health Plan Site & COB History Link Selected in Auto Doc
    handleCOBHistoryLinkClick: function (cmp, event, helper) {
        var eventData = event.getParam("eventData");
        if (eventData.fieldName == "") {
            var cardDetails = cmp.get("v.cardDetails");
            let policyList = cmp.get("v.memberPolicies");
            var policyLine = policyList[cmp.get("v.policySelectedIndex")];
            if($A.util.isEmpty(cardDetails)){
                var cardDetails = new Object();
                cardDetails.componentName = "Coordination Of Benefits (COB)";
                cardDetails.componentOrder = 4;
                cardDetails.noOfColumns = "slds-size_6-of-12";
                cardDetails.type = "card";
                cardDetails.caseItemsExtId = this.getCaseItemsExternalId(cmp); // US3833197: Krish - 15th Sept 2021
                cardDetails.allChecked = false;
                var isClaim = cmp.get("v.isClaim");
                if (isClaim) {
                    var claimNo = cmp.get("v.claimNo");
                    cardDetails.caseItemsExtId = claimNo;
                }
                cardDetails.cardData = [{
                    "checked": true,
                    "defaultChecked": false,
                    "fieldName": "COB History/Comments",
                    "fieldType": "outputText",
                    "fieldValue": "Accessed",
                    "showCheckbox": false,
                    "hideField": true,
                    "isReportable": true
                    }
                ];
                cmp.set("v.cardDetails", cardDetails);
                _autodoc.setAutodoc(component.get("v.autodocUniqueId"),component.get("v.policySelectedIndex"), cardDetails);
            }else{
            var isPresent = false;
            for (var data in cardDetails.cardData) {
                console.log(cardDetails.cardData[data].fieldName + " " + cardDetails.cardData[data].hideField);
                if (cardDetails.cardData[data].fieldName === "COB History/Comments" && cardDetails.cardData[data].hideField == true &&
                    cardDetails.cardData[data].fieldValue === "Accessed") {
                    isPresent = true;
                    console.log("Already Autodoced");
                }
            }
            if (!isPresent) {
                cardDetails.cardData.push({
                    "checked": true,
                    "defaultChecked": false,
                    "fieldName": "COB History/Comments",
                    "fieldType": "outputText",
                    "fieldValue": "Accessed",
                    "showCheckbox": false,
                    "hideField": true,
                    "isReportable": true
                });
            	}
               _autodoc.setAutodoc(cmp.get("v.autodocUniqueId"), cmp.get("v.policySelectedIndex"), cardDetails);
            }
        }
    },
    handleCOBProcessSOPLinkClick: function(cmp, event, helper){
        var cobHistoryURL = cmp.get('v.cobHistoryURL');
        window.open(cobHistoryURL, '_blank');
        var eventData = event.getParam("eventData");
        let policyList = cmp.get("v.memberPolicies");
        var policyLine = policyList[cmp.get("v.policySelectedIndex")];
        if (eventData.fieldName == "") {
            var cardDetails = cmp.get("v.cardDetails");
            if($A.util.isEmpty(cardDetails)){
                var cardDetails = new Object();
                cardDetails.componentName = "Coordination Of Benefits (COB)";
                cardDetails.componentOrder = 4;
                cardDetails.noOfColumns = "slds-size_6-of-12";
                cardDetails.type = "card";
                cardDetails.caseItemsExtId = this.getCaseItemsExternalId(cmp); // US3833197: Krish - 15th Sept 2021
                cardDetails.allChecked = false;
                var isClaim = cmp.get("v.isClaim");
                if (isClaim) {
                    var claimNo = cmp.get("v.claimNo");
                    cardDetails.caseItemsExtId = claimNo;
                }
                cardDetails.cardData = [{
                        "checked": true,
                        "defaultChecked": false,
                        "fieldName": "COB Process SOP",
                        "fieldType": "outputText",
                        "fieldValue": "Accessed",
                        "showCheckbox": false,
                        "hideField": true,
                        "isReportable": true
                    }
                ];
                cmp.set("v.cardDetails", cardDetails);
                _autodoc.setAutodoc(cmp.get("v.autodocUniqueId"), cmp.get("v.policySelectedIndex"), cardDetails);
            }else{
            var isPresent = false;
            for (var data in cardDetails.cardData) {
                console.log(cardDetails.cardData[data].fieldName + " " + cardDetails.cardData[data].hideField);
                if (cardDetails.cardData[data].fieldName === "COB Process SOP" && cardDetails.cardData[data].hideField == true &&
                    cardDetails.cardData[data].fieldValue === "Accessed") {
                    isPresent = true;
                    console.log("Already Autodoced");
                }
            }
            if (!isPresent) {
                cardDetails.cardData.push({
                    "checked": true,
                    "defaultChecked": false,
                    "fieldName": "COB Process SOP",
                    "fieldType": "outputText",
                    "fieldValue": "Accessed",
                    "showCheckbox": false,
                    "hideField": true,
                    "isReportable": true
                });
                    
                }
                _autodoc.setAutodoc(cmp.get("v.autodocUniqueId"), cmp.get("v.policySelectedIndex"), cardDetails);
            }
        }
    },
    getCaseItemsExternalId: function(cmp){
        // US3833197: Krish - 15th Sept 2021
        // This function return case items external Id for autodoc components to link the reporting records with case items.
        // Id = Group Number/Source Code/Member Id
        let policyList = cmp.get("v.policyDetails");
        var policyDetails = policyList; // 
        var caseItemExtId = "";
        var policyLine = "";
        var groupNumber = "";
        var sourceCode = "";
        var memberId = "";
        var memberPolicies = cmp.get("v.memberPolicies");
        var policy = memberPolicies[cmp.get("v.policySelectedIndex")];
        if(!$A.util.isUndefinedOrNull(policy)){
            groupNumber = !$A.util.isEmpty(policy.GroupNumber) ? policy.GroupNumber : "";
            if(!$A.util.isEmpty(policy.patientInfo) && !$A.util.isEmpty(policy.patientInfo.MemberId)){
                memberId = policy.patientInfo.MemberId;
            }
        }
        if(!$A.util.isUndefinedOrNull(policyDetails) && !$A.util.isUndefinedOrNull(policyDetails.resultWrapper) && !$A.util.isUndefinedOrNull(policyDetails.resultWrapper.policyRes) ){
            policyLine = policyDetails.resultWrapper.policyRes;
        }
        if(!$A.util.isEmpty(policyLine)){            
            sourceCode = !$A.util.isEmpty(policyLine.sourceCode) ?  policyLine.sourceCode : "";
            caseItemExtId = groupNumber + '/' + sourceCode + '/' + memberId;
        }
        return caseItemExtId;
    }
})