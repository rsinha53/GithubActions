({
    cmpList:[],

    addCmpToList: function (cmp) {
        this.cmpList.push(cmp);
    },

    updateCmpCardDetails: function(cardDetails, srn){
        var cmp;
        for(cmp of this.cmpList){
            if(cmp.get("v.SRN") == srn){
                cmp.set("v.cardDetails", cardDetails);
            }
        }
    },

    showAuthStatusSpinner: function (cmp) {
        var spinner = cmp.find("asdasd");
        $A.util.removeClass(spinner, "slds-hide");
        
    },
    hideAuthStatusSpinner: function (cmp) {
        var spinner = cmp.find("asdasd");
        
        $A.util.addClass(spinner, "slds-hide");
    },
    getICUEURL: function (component, event, helper) {
        var ICUEURL = component.get("v.ICUEURL");
       
        component.set("v.spinnerFlag",false);
        //this.hideAuthStatusSpinner(component);
        window.open(ICUEURL, 'ICUE', 'toolbars=0,width=1200,height=800,left=0,top=0,scrollbars=1,resizable=1');
    },
    getAuthStatusDetails: function (cmp, event, helper) {
        var action = cmp.get("c.getAuthorizationStatus");
        var requestParams = {
            AUTH_ID: cmp.get('v.authID'), // '156627064',
            XREF_ID: cmp.get('v.xrefID') // '625871210'
        };
        action.setParams({ requestObject: requestParams });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state == "SUCCESS") {
                var data = response.getReturnValue();
                if (data.statusCode == 200) {
                    cmp.set('v.authStatusDetails', data.resultWrapper);
                }
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

    /*** DE334279 - Avish **/
    openSRNTab: function(cmp, event){

        var uniqueSRNLst = cmp.get('v.uniqueSRN');
        if(!$A.util.isEmpty(cmp.get('v.SRN'))){
            if(uniqueSRNLst.length == 0){
                uniqueSRNLst.push(cmp.get('v.SRN'));
            }else{
                for (var i = 0; i < uniqueSRNLst.length; i++) {
                    if(cmp.get('v.SRN') != uniqueSRNLst[i]){
                        uniqueSRNLst.push(cmp.get('v.SRN'));
                        break;
                    }
                }
            } 
            cmp.set('v.uniqueSRN',uniqueSRNLst);
        }
        
        var workspaceAPI = cmp.find("workspace");
        workspaceAPI.openSubtab({
            pageReference: {
                "type": "standard__component",
                "attributes": {
                    "componentName": "c__ACET_AuthECAA"
                }, "state": {
                    "c__interactionRec": JSON.stringify(cmp.get('v.interactionRec')),
                    "c__SRN": cmp.get('v.SRN')
                }
            },
            focus: true
        }).then(function (tabId) {
            workspaceAPI.setTabLabel({
                tabId: tabId,
                label: "ECAA " + cmp.get('v.SRN')
            });
            workspaceAPI.setTabIcon({
                tabId: tabId
            });
        })
    },
    
    focusSRNTab: function(cmp, event,srnUnique){
        var workspaceAPI = cmp.find("workspace");
        var focusedTabId;
        var url;
        workspaceAPI.getAllTabInfo().then(function (response) {
            if (!$A.util.isEmpty(response)) {
                for (var i = 0; i < response.length; i++) {
                    for (var k = 0; k < response[i].subtabs.length; k++) {
                        if (srnUnique == response[i].subtabs[k].pageReference.state.c__SRN) {
                            url = response[i].subtabs[k].url;
                            focusedTabId = response[i].subtabs[k].tabId;
                            break;
                        }
                    }
                    
                }
                workspaceAPI.openTab({
                    url: url
                }).then(function (response) {
                    workspaceAPI.focusTab({
                        tabId: focusTabId
                    });
                }).catch(function (error) {
                    console.log(error);
                });
            }
        })
        .catch(function (error) {
            console.log(error);
        });
    },
    /*** DE334279 - Avish **/

    setCardDetails: function(cmp){ 
        var srn;
        if(!$A.util.isEmpty(cmp.get("v.SRN"))){
            srn = cmp.get("v.SRN");
        } else{
            srn = cmp.get("v.authStatusDetails.srn");
        }
        var autodocCmp = _autodoc.getAutodocComponent(cmp.get("v.autodocUniqueId"), cmp.get("v.autodocUniqueIdCmp"), "Authorization Status: " + srn);
        
        if(!$A.util.isEmpty(autodocCmp)){
            cmp.set("v.cardDetails", autodocCmp);
        } else{
            // US2969157 - TECH - View Authorization Enhancements for new auto doc framework - Sarma - 7/10/2020
            // Null check in each level of object nodes to prevent exception
            let status = "--";
            let type = "--";
            let serviceSetting = "--";
            let decisionDateTime = "--";
            let decisionReason = "--";
            let gapOutCome = "--";
            let hscCoverage = "--";
            let reviewPriority = "--";
            let serviceDecisionOutcome = "--"; // US2955613

            if(!$A.util.isEmpty(cmp.get("v.authStatusDetails")) && !$A.util.isEmpty(cmp.get("v.authStatusDetails.AuthDetailsResponse")) ){
                let authDetailsResponse = cmp.get("v.authStatusDetails.AuthDetailsResponse");

                if(!$A.util.isEmpty(authDetailsResponse.statusCode) && !$A.util.isEmpty(authDetailsResponse.statusCode.description)){
                    status = authDetailsResponse.statusCode.description;
                }
                if(authDetailsResponse && authDetailsResponse.statusReasonCode && authDetailsResponse.statusReasonCode.description ){
                    status = status + ' - '+ authDetailsResponse.statusReasonCode.description;
                }

                if(!$A.util.isEmpty(authDetailsResponse.serviceCategoryTypeCode) && !$A.util.isEmpty(authDetailsResponse.serviceCategoryTypeCode.description)){
                    type = authDetailsResponse.serviceCategoryTypeCode.description;
                    hscCoverage = type;
                }
                if(!$A.util.isEmpty(authDetailsResponse.serviceSettingTypeCode) && !$A.util.isEmpty(authDetailsResponse.serviceSettingTypeCode.description)){
                    serviceSetting = authDetailsResponse.serviceSettingTypeCode.description;
                }
                // US3222385 - View Auth- Auth Details Decision Date and Time - Sarma - 11/02/2021
                if((cmp.get("v.authType") == "InPatient") || (cmp.get("v.authType") == "OutPatientFacility")){
                if(!$A.util.isEmpty(authDetailsResponse.facility) && !$A.util.isEmpty(authDetailsResponse.facility.facilityDecision ) && !$A.util.isEmpty(authDetailsResponse.facility.facilityDecision.renderedDateTimeFormated)){
                    decisionDateTime = authDetailsResponse.facility.facilityDecision.renderedDateTimeFormated;
                }
                if(!$A.util.isEmpty(authDetailsResponse.facility) && !$A.util.isEmpty(authDetailsResponse.facility.facilityDecision ) && !$A.util.isEmpty(authDetailsResponse.facility.facilityDecision.decisionReasonCode) && !$A.util.isEmpty(authDetailsResponse.facility.facilityDecision.decisionReasonCode.description)){
                    decisionReason = authDetailsResponse.facility.facilityDecision.decisionReasonCode.description;
                }
                } else if(cmp.get("v.authType") == "OutPatient"){
                    if(!$A.util.isEmpty(authDetailsResponse.services) && authDetailsResponse.services.length > 0){
                        let servicesList = authDetailsResponse.services;
                        for(let n=0; n<servicesList.length; n++){
                            if(servicesList[n].serviceReferenceNumber == srn){
                                if(!$A.util.isEmpty(servicesList[n].serviceDecision) && !$A.util.isEmpty(servicesList[n].serviceDecision.decisionReasonCode ) && !$A.util.isEmpty(servicesList[n].serviceDecision.decisionReasonCode.description)){
                                    decisionReason = servicesList[n].serviceDecision.decisionReasonCode.description;
                                }
                                if(!$A.util.isEmpty(servicesList[n].serviceDecision) && !$A.util.isEmpty(servicesList[n].serviceDecision.decisionRenderedDatetimeFormatted)){
                                    decisionDateTime = servicesList[n].serviceDecision.decisionRenderedDatetimeFormatted;
                                }
                                break;
                            }
                        }
                    }
                }
                // US3222385 End
                if(!$A.util.isEmpty(authDetailsResponse.facility) && !$A.util.isEmpty(authDetailsResponse.facility.facilityDecision ) && !$A.util.isEmpty(authDetailsResponse.facility.facilityDecision.gapReviewOutcomeCode) && !$A.util.isEmpty(authDetailsResponse.facility.facilityDecision.gapReviewOutcomeCode.description)){
                    gapOutCome = authDetailsResponse.facility.facilityDecision.gapReviewOutcomeCode.description;
                }
                if(!$A.util.isEmpty(authDetailsResponse.reviewPriority) && !$A.util.isEmpty(authDetailsResponse.reviewPriority.description)){
                    reviewPriority = authDetailsResponse.reviewPriority.description;
                }
                // US2955613
                if(!$A.util.isEmpty(authDetailsResponse.serviceDecisionOutcome)){
                    serviceDecisionOutcome = authDetailsResponse.serviceDecisionOutcome;
                }
            }

            var cardDetails = new Object();
             var currentIndexOfOpenedTabs = cmp.get("v.currentIndexOfOpenedTabs");
            var maxAutoDocComponents = cmp.get("v.maxAutoDocComponents");
            var claimNo=cmp.get("v.claimNo");
            var currentIndexOfAuthOpenedTabs=cmp.get("v.currentIndexOfAuthOpenedTabs");
            var maxAutoDocAuthComponents=cmp.get("v.maxAutoDocAuthComponents");
             if(cmp.get("v.isClaimDetail")){
                 cardDetails.componentName = "Authorization Status: " + srn+": " +claimNo;
            cardDetails.componentOrder = 16.01 +(maxAutoDocComponents*currentIndexOfOpenedTabs)+(maxAutoDocAuthComponents*currentIndexOfAuthOpenedTabs);
                // US3653575
                cardDetails.caseItemsExtId = claimNo;
            } else {
            cardDetails.componentName = "Authorization Status: " + srn;
            cardDetails.componentOrder = 4;
                // US3653575
                cardDetails.caseItemsExtId = srn;
            }
            // US3653575
            cardDetails.reportingHeader = cmp.get('v.isMainComponent') ? 'Authorization Status' : 'Authorization Detail Status';
            cardDetails.noOfColumns = "slds-size_1-of-5";
            cardDetails.type = "card";
            cardDetails.allChecked = false;
            cardDetails.cardData = [
                {
                    "checked": true,
                    "defaultChecked": true,
                    "disableCheckbox": true, // US2634947
                    "fieldName": "Status",
                    "fieldType": "outputText",
                    "fieldValue": status,
                    "showCheckbox": true,
                    "isReportable": true // US2834058 - Thanish - 13th Oct 2020
                },
                { //US3225477
                    "checked": false,
                    "fieldName": "Review Priority",
                    "fieldType": "outputText",
                    "fieldValue": reviewPriority,
                    "showCheckbox": true,
                    "isReportable": true // US2834058 - Thanish - 13th Oct 2020
                },
                {
                    "checked": false,
                    "fieldName": "Type",
                    "fieldType": "outputText",
                    "fieldValue": type,
                    "showCheckbox": true,
                    "isReportable": true // US2834058 - Thanish - 13th Oct 2020
                },
                {
                    "checked": false,
                    "fieldName": "Service Setting",
                    "fieldType": "outputText",
                    "fieldValue": serviceSetting,
                    "showCheckbox": true,
                    "isReportable": true // US2834058 - Thanish - 13th Oct 2020
                },
                {
                    "checked": false,
                    "fieldName": "Decision Date/Time",
                    "fieldType": "outputText",
                    "fieldValueTitle" : (decisionDateTime.length > 20) ? decisionDateTime : "",
                    "fieldValue": (decisionDateTime.length > 20) ? decisionDateTime.substring(0,19) + "..." : decisionDateTime,
                    "showCheckbox": true,
                    "isReportable": true // US2834058 - Thanish - 13th Oct 2020
                },
                {
                    "checked": false,
                    "fieldName": "Decision Reason",
                    "fieldType": "outputText",
                    "fieldValueTitle" : (decisionReason.length > 20) ? decisionReason : "",
                    "fieldValue": (decisionReason.length > 20) ? decisionReason.substring(0,19) + "..." : decisionReason,
                    "showCheckbox": true,
                    "isReportable": true // US2834058 - Thanish - 13th Oct 2020
                },
                // US2955613
                {
                    "checked": false,
                    "fieldName": "Decision Outcome",
                    "fieldType": "outputText",
                    "fieldValue": serviceDecisionOutcome,
                    "showCheckbox": true,
                    "isReportable": true
                },
                {
                    "checked": false,
                    "fieldName": "GAP Outcome",
                    "fieldType": "outputText",
                    "fieldValue": gapOutCome,
                    "showCheckbox": true,
                    "isReportable": true // US2834058 - Thanish - 13th Oct 2020
                },
                {
                    "checked": false,
                    "fieldName": "HSC Coverage Type",
                    "fieldType": "outputText",
                    "fieldValue": hscCoverage,
                    "showCheckbox": true,
                    "isReportable": true // US2834058 - Thanish - 13th Oct 2020
                },
            ];
            cmp.set("v.cardDetails", cardDetails);
            _autodoc.setAutodoc(cmp.get("v.autodocUniqueId"), cmp.get("v.autodocUniqueIdCmp"), cardDetails);
        }
    },

    openICUEtab: function(cmp, event){

        var uniqueSRNLst = cmp.get('v.uniqueSRN');
        if(!$A.util.isEmpty(cmp.get('v.SRN'))){
            if(uniqueSRNLst.length == 0){
                uniqueSRNLst.push(cmp.get('v.SRN'));
            }else{
                for (var i = 0; i < uniqueSRNLst.length; i++) {
                    if(cmp.get('v.SRN') != uniqueSRNLst[i]){
                        uniqueSRNLst.push(cmp.get('v.SRN'));
                        break;
                    }
                }
            }
            cmp.set('v.uniqueSRN',uniqueSRNLst);
        }

        var workspaceAPI = cmp.find("workspace");
        workspaceAPI.openSubtab({
            pageReference: {
                "type": "standard__component",
                "attributes": {
                    "componentName": "c__ACET_AuthICUE"
                }, "state": {
                    "c__interactionRec": JSON.stringify(cmp.get('v.interactionRec')),
                    "c__hipaaEndpointUrl":cmp.get("v.hipaaEndpointUrl"),
                    "c__autodocUniqueId": cmp.get("v.autodocUniqueId"),
                    "c__originatorType": cmp.get("v.originatorType"),
                    "c__SRNICUE": cmp.get('v.SRN')
                }
            },
            focus: true
        }).then(function (tabId) {
            workspaceAPI.setTabLabel({
                tabId: tabId,
                label: "ICUE: " + cmp.get('v.SRN')
            });
            workspaceAPI.setTabIcon({
                tabId: tabId
            });
        })
    },

    focusICUEtab: function(cmp, event,srnUnique){
        var workspaceAPI = cmp.find("workspace");
        var focusedTabId;
        var url;
        workspaceAPI.getAllTabInfo().then(function (response) {
            if (!$A.util.isEmpty(response)) {
                for (var i = 0; i < response.length; i++) {
                    for (var k = 0; k < response[i].subtabs.length; k++) {
                        if (srnUnique == response[i].subtabs[k].pageReference.state.c__SRNICUE) {
                            url = response[i].subtabs[k].url;
                            focusedTabId = response[i].subtabs[k].tabId;
                            break;
                        }
                    }

    }
                workspaceAPI.openTab({
                    url: url
                }).then(function (response) {
                    workspaceAPI.focusTab({
                        tabId: focusTabId
                    });
                }).catch(function (error) {
                    console.log(error);
                });
            }
        })
        .catch(function (error) {
            console.log(error);
        });
    },

    // US3125332 - Thanish - 7th Jan 2021
	refreshAutodoc : function(cmp) {
		var cardDetails = cmp.get("v.cardDetails");
		var data;
		for(data of cardDetails.cardData){
			if(!data.disableCheckbox){
				data.checked = false;
			}
		}
		cardDetails.allChecked = false;
		cmp.set("v.cardDetails", cardDetails);
		_autodoc.setAutodoc(cmp.get("v.autodocUniqueId"), cmp.get("v.autodocUniqueIdCmp"), cardDetails);
	}
})