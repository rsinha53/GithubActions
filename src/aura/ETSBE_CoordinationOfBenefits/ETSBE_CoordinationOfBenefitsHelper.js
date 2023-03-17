({
    getENICobInfo: function (cmp) {
        let action = cmp.get("c.getENIData");
        var policyDetails = cmp.get("v.policyDetails");
        console.log(JSON.stringify(policyDetails));
        console.log(JSON.stringify(cmp.get("v.houseHoldData")));
        let householdList = cmp.get("v.houseHoldData");
        var householdMember;
        for(var i=0 ; i< householdList.length; i++) {
            if(householdList[i].isMainMember) {
                householdMember = householdList[i];
                break;
            }
        }       
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
                console.log(result);
                if (!$A.util.isEmpty(result.response)) {
                    if (policyDetails.resultWrapper.policyRes.sourceCode == "CS") {
                        cmp.set("v.cardDetails", result.response.eniAutodocCard);
                        cmp.set("v.cobENIHistoryTable", result.response.eniCobHistoryTable);
                        cmp.set("v.regionCode", result.response.regionCode);
                        this.hideCobSpinner(cmp);
                    }
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
                this.fireToastMessage("Error!", 'Server side error!', "error", "dismissible", "10000");
            }
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
                    cmp.set("v.cardDetails", result.response.cobCardData);
                    cmp.set("v.cobMNRCommentsTable", result.response.cobCommentsTable);
                }
            } else {
                this.fireToastMessage("Error!", 'Server side error!', "error", "dismissible", "10000");
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

    
    // US2808743 - Thanish - 3rd Sep 2020 - New Autodoc Framework
    setAutodocCardData: function (cmp) {
        var autodocCmp;
        if(!$A.util.isEmpty(cmp.get("v.policyDetails"))) {
            
            autodocCmp = _autodoc.getAutodocComponent(cmp.get("v.autodocUniqueId"), cmp.get("v.policySelectedIndex"), "Coordination Of Benefits (COB)");   
        }

        if (!$A.util.isEmpty(autodocCmp)) {
            cmp.set("v.cardDetails", autodocCmp);

        } else {
            /*var isPrimaryCoverageAvailable = cmp.get("v.isPrimaryCoverageAvailable");
            var isSecondaryCoverageAvailable = cmp.get("v.isSecondaryCoverageAvailable");
            var cobData = cmp.get("v.cobData");
            var primaryCoverageDetails = cmp.get("v.primaryCoverageDetails");*/

        var cardDetails = new Object();
        cardDetails.componentName = "Coordination Of Benefits (COB)";
        cardDetails.componentOrder = 4;
        cardDetails.noOfColumns = "slds-size_6-of-12";
        cardDetails.type = "card";
        cardDetails.allChecked = false;
        cardDetails.cardData = [
            // US3182441: COB Card Update Fields UI START
            {
                "checked": false,
                "defaultChecked": false,
                "fieldName": "Other Insurance/Type",
                "fieldType": "outputText",
                "fieldValue": "No/--",
                "showCheckbox": false,
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
                    "showCheckbox": false,
                    "isReportable": true
                },
                {
                    "checked": false,
                    "defaultChecked": false,
                    "fieldName": "Other Insurance Primary",
                "fieldType": "outputText",
                "fieldValue": "No",
                "showCheckbox": false,
                "isReportable": true
            },
            {
                "checked": false,
                "defaultChecked": false,
                    "fieldName": "Primary Effective Dates",
                "fieldType": "outputText",
                "fieldValue": "--",
                "showCheckbox": false,
                "isReportable": true
            },
            {
                "checked": false,
                "defaultChecked": false,
                "fieldName": "Payer Name",
                "fieldType": "outputText",
                "fieldValue": "--",
                "showCheckbox": false,
                "isReportable": true
            },
            {
                "checked": false,
                "defaultChecked": false,
                "fieldName": "Medicare Information",
                "fieldType": "outputText",
                "fieldValue": "--",
                "showCheckbox": false,
                "isReportable": true
            },
            {
                "checked": false,
                "defaultChecked": false,
                "fieldName": "Update Status",
                "fieldType": "outputText",
                "fieldValue": "--",
                "showCheckbox": false,
                "isReportable": true
            },
            {
                "checked": false,
                "defaultChecked": false,
                "fieldName": "Last Updated Date",
                "fieldType": "outputText",
                "fieldValue": "--",
                "showCheckbox": false,
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
                cmp.set("v.cardDetails", cardDetails);
                _autodoc.setAutodoc(cmp.get("v.autodocUniqueId"), cmp.get("v.autodocUniqueIdCmp"), cardDetails);
            }
        }
    },
    handleCOBProcessSOPLinkClick: function(cmp, event, helper){
        var cobHistoryURL = cmp.get('v.cobHistoryURL');
        window.open(cobHistoryURL, '_blank');
        var eventData = event.getParam("eventData");
        if (eventData.fieldName == "") {
            var cardDetails = cmp.get("v.cardDetails");
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
                cmp.set("v.cardDetails", cardDetails);
                _autodoc.setAutodoc(cmp.get("v.autodocUniqueId"), cmp.get("v.autodocUniqueIdCmp"), cardDetails);
            }
        }
    }
})