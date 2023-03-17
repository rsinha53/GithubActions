({
    doInit: function (cmp, event, helper) {
        // US3456351 - Kavinda 
        helper.setTableData(cmp, event);
    },

    //US3389389: Select Claim # Hyperlink in Payment Details - Swapnil 6/11/21
    getClaimSummaryData: function (component, event, helper) {
        var selectedRowdata = event.getParam("selectedRows");
        var currentCellIndex = event.getParam("currentCellIndex");
        var currentRowIndex = event.getParam("currentRowIndex");

        component.set('v.currentCellIndex', currentCellIndex);
        component.set('v.currentRowIndex', currentRowIndex);

        // US3678785
        var tableBody = component.get('v.tableBody');

        // US3484619
        if (currentCellIndex == 5 || currentCellIndex == 6) {
            let memberNotInFocus = false;
            var checkSearchRespObj = component.get('v.checkSearchRespObj');
            if(!$A.util.isUndefinedOrNull(checkSearchRespObj[0]) && !$A.util.isUndefinedOrNull(checkSearchRespObj[0].response) &&
               !$A.util.isUndefinedOrNull(checkSearchRespObj[0].response.data.checkSummary) &&
               !$A.util.isUndefinedOrNull(checkSearchRespObj[0].response.data.checkSummary.draftDetail[currentRowIndex]) &&
               !$A.util.isUndefinedOrNull(checkSearchRespObj[0].response.data.checkSummary.draftDetail[currentRowIndex].providerId) ) {
           		var selectedProviderID = checkSearchRespObj[0].response.data.checkSummary.draftDetail[currentRowIndex].providerId.providerTin;
            }
            var selectedClaimNo = selectedRowdata.rowColumnData[5].fieldValue;

            //Setting claim Input object values
            var claimInput = component.get("v.claimInput");
            if ($A.util.isUndefinedOrNull(claimInput)) {
                claimInput = {};
            }
            claimInput.claimNumber = selectedClaimNo;
            claimInput.taxId = selectedProviderID;
            if($A.util.isUndefinedOrNull(component.get("v.memberCardSnap"))) {
                claimInput.payerId='87726';
            } else {
                claimInput.payerId = component.get("v.memberCardSnap").searchQueryPayerId;
            }
            claimInput.isFromPayments = true;
            component.set("v.claimInput", claimInput);

            var action = component.get('c.getClaimsAutodoc');
            action.setParams({
                "claimInputs": claimInput,
                "isDeductible": false,
                "isApplied": false,
                "start": component.get("v.pageNumber"),
                "isMoreThan90days": false
            });
            action.setCallback(this, function (response) {
                var state = response.getState();
                var result = response.getReturnValue();
                if (state == 'SUCCESS') {
                    if (result.statusCode == 200) {

                        if (currentCellIndex == 5) {

                            if (!$A.util.isUndefinedOrNull(claimInput.claimNumber) && !$A.util.isEmpty(claimInput.claimNumber)) {
                                if (!$A.util.isUndefinedOrNull(result.memberInfo) && !$A.util.isEmpty(result.memberInfo)) {
                                    var memberCardData = {};
                                    if (!$A.util.isUndefinedOrNull(component.get("v.memberCardData")) && !$A.util.isEmpty(component.get("v.memberCardData"))) {
                                        var memberCardData = component.get("v.memberCardData").CoverageLines[component.get("v.policySelectedIndex")].patientInfo;
                                    }
                                    //US3389424: View Payments - Select Claim # Hyperlink in Payment Details - For Different Member : Swapnil (7/2/2021)
                                    var serviceDates = result.claimSearchResult.tableBody[0].rowColumnData.
                            						find( r=> r.fieldLabel == 'SERVICE DATES').fieldValue;
                                    component.set("v.claimsServiceDates", serviceDates);
                                    component.set("v.memberInfoDetails", result.memberInfo[0]);

                                    var memberDob = result.memberInfo[0].ptntDob;
                                    var memberFullname = result.memberInfo[0].ptntFn + ' ' + result.memberInfo[0].ptntLn;

                                    if (memberCardData.fullName != memberFullname && memberCardData.dobVal != memberDob) {
                                        component.set("v.showWarning", true);
                                        memberNotInFocus = true;
                                    }
                                }
                            }
                            if (!memberNotInFocus) {
                                var extProviderTable = _autodoc.getAutodocComponent(component.get("v.autodocUniqueId"), component.get("v.autodocUniqueIdCmp"), 'Payment Details: ' + component.get('v.requestObject').checkNumber);
                                var preSelectCLiamList = [];
                                var preSelectMemberList = [];
                                var preSelectClaimStatusList = [];
                                let prevSelectedClaimRows = [];
                                /* if (!$A.util.isEmpty(extProviderTable) && !$A.util.isEmpty(extProviderTable.selectedRows)) {
                                } */
                                component.set("v.mapClaimSummaryDetails", result.claimSummayByClaim[0]);
                                component.set("v.listClaimStatusDetails", result.claimStatusByClaim[0]);
                                component.set("v.mapClaimSearchResult", result.claimSearchResult);
                                component.set("v.mapInOutPatientDetails", result.inOutPatientDetails[0] ); //DE477141 Swapnil

                                helper.navigateToDetail(component, event, helper, selectedRowdata, selectedClaimNo);
                            }
                            tableBody[currentRowIndex].rowColumnData[currentCellIndex].fieldType = 'outputText';
                            tableBody[currentRowIndex].rowColumnData[currentCellIndex].isLink = false;
                            tableBody[currentRowIndex].rowColumnData[currentCellIndex].isOutputText = true;
                        }

                        // US3484619
                        if (currentCellIndex == 6) {
                            var strServiceDt = '';
                            if (!$A.util.isUndefinedOrNull(result.claimSummayByClaim)
                                && !$A.util.isUndefinedOrNull(result.claimSummayByClaim[0])
                                && !$A.util.isUndefinedOrNull(result.claimSummayByClaim[0].cardData)
                                && !$A.util.isUndefinedOrNull(result.claimSummayByClaim[0].cardData)[6]
                                && !$A.util.isUndefinedOrNull(result.claimSummayByClaim[0].cardData[6].fieldValue)) {
                                strServiceDt = result.claimSummayByClaim[0].cardData[6].fieldValue;
                                if ($A.util.isEmpty(strServiceDt)) {
                                    strServiceDt = '--';
                                }
                            }

                            tableBody[currentRowIndex].rowColumnData[currentCellIndex].fieldValue = strServiceDt;
                            tableBody[currentRowIndex].rowColumnData[currentCellIndex].fieldType = 'outputText';
                            tableBody[currentRowIndex].rowColumnData[currentCellIndex].isLink = false;
                            tableBody[currentRowIndex].rowColumnData[currentCellIndex].isOutputText = true;

                        }

                    } else {
                        //US3625667: View Payments -  Error Code Handling - Swapnil
                        helper.fireToastMessage("We hit a snag.", helper.paymentDetailsErrorMsg, "error", "dismissible", "6000");
                     }

                    tableBody[currentRowIndex].linkDisabled = false;
                    component.set('v.tableBody', tableBody);

                } else if (state == 'ERROR') {
                    //US3625667: View Payments -  Error Code Handling - Swapnil
                    tableBody[currentRowIndex].linkDisabled = false;
                    component.set('v.tableBody', tableBody);
                    helper.fireToastMessage("We hit a snag.", helper.paymentDetailsErrorMsg, "error", "dismissible", "6000");
                }
            });
            $A.enqueueAction(action);
        }

        // US3484619
        event.stopPropagation();
    },

    // US3476420
    searchPaymentDetails: function (cmp, event, helper) {
        helper.searchPaymentDetails(cmp, event, helper);
    },

    //US3389424: View Payments - Select Claim # Hyperlink in Payment Details - For Different Member : Swapnil (7/2/2021)
    switchClaimsNo: function (cmp, event, helper) {
        cmp.set("v.showWarning",false);
        var tableBody = cmp.get('v.tableBody');
        var currentRowIndex = cmp.get('v.currentRowIndex');
        var currentCellIndex = cmp.get('v.currentCellIndex');
        tableBody[currentRowIndex].rowColumnData[currentCellIndex].fieldType = 'link';
        tableBody[currentRowIndex].rowColumnData[currentCellIndex].isLink = true;
        tableBody[currentRowIndex].rowColumnData[currentCellIndex].isOutputText = false;
        cmp.set('v.tableBody', tableBody);
    },
    switchClaimsYes: function (component, event, helper) {
        component.set("v.showWarning",false);
        component.set("v.isClaim",true);

        let interactionRecord = component.get("v.interactionRec");
        var workspaceAPI = component.find("workspace");
        var interactionCard = component.get("v.interactionCard");
        var contactName =  component.get("v.contactName");
        var searchOption =  'NameDateOfBirth';

        var groupId = '';
        var memberInfoDetails = component.get("v.memberInfoDetails");
        var selectedMemberId = memberInfoDetails.sbmtMembrId;
        var selectedMemberDob = memberInfoDetails.ptntDob;
        var selectedMemberFirstName=  memberInfoDetails.ptntFn;
        var selectedMemberLasttName= memberInfoDetails.ptntLn;
        var memberGrpN = memberInfoDetails.policyNbr;
        var policyDateRange= component.get("v.claimsServiceDates");
        var memUniqueId =  selectedMemberId + selectedMemberDob + selectedMemberFirstName;

        var isOtherSearch = (component.get("v.isOtherSearch") != null ? component.get("v.isOtherSearch") : false);
        var otherCardDataObj = component.get("v.interactionCard");
        var providerNotFound = component.get("v.providerNotFound");
        var isProviderSearchDisabled = component.get("v.isProviderSearchDisabled");
        var memberCardFlag = (component.get("v.memberCardFlag") != null ? component.get("v.memberCardFlag") : false);
		var noMemberToSearch = component.get("v.noMemberToSearch");

        var matchingTabs = [];

        var claimInput=component.get("v.claimInput");
        claimInput.memberId=selectedMemberId;
        claimInput.memberDOB=selectedMemberDob;

		workspaceAPI.getAllTabInfo().then(function(response) {
            if(!$A.util.isEmpty(response)) {
				for(var i = 0; i < response.length; i++) {

					for(var j = 0; j < response[i].subtabs.length; j++) {
						if(response[i].subtabs.length > 0){
							var	tabMemUniqueId = response[i].subtabs[j].pageReference.state.c__memberUniqueId;
                            var ifCondition = (!$A.util.isUndefinedOrNull(tabMemUniqueId) && tabMemUniqueId.includes(selectedMemberId) && tabMemUniqueId.includes(selectedMemberFirstName));
                            if ((memUniqueId === tabMemUniqueId) || ifCondition) {
                                if (ifCondition) {
                                    memUniqueId = tabMemUniqueId;
                                }
								matchingTabs.push(response[i]);
								break;
                            }
						}
					}
				}
			}
            if(matchingTabs.length === 0) {
                workspaceAPI.getEnclosingTabId().then(function(enclosingTabId) {
                    workspaceAPI.openSubtab({
                        parentTabId: enclosingTabId,
                        pageReference: {
                            "type": "standard__component",
                            "attributes": {
                                "componentName": "c__SAE_SnapshotOfMemberAndPolicies"
                            },
                            "state": {
                                "c__interactionCard":interactionCard,
                                "c__contactName": contactName ,
                                "c__searchOption": "NameDateOfBirth",
                                "c__memberId": selectedMemberId,
                                "c__groupId":'',
                                "c__memberDOB": selectedMemberDob,
                                "c__memberFN": selectedMemberFirstName,
                                "c__memberLN": selectedMemberLasttName,
                                "c__memberGrpN": memberGrpN,
                                "c__memberUniqueId": memUniqueId,
                                "c__subjectCard": null,
                                "c__houseHoldUnique": memUniqueId,
                                "c__payerID" : "87726",
                                "c__providerNotFound": providerNotFound,
                                "c__noMemberToSearch": noMemberToSearch,
                                "c__isProviderSearchDisabled": isProviderSearchDisabled,
                                "c__interactionRecord":interactionRecord,
                                "c__mnf":'',
                                "c__isOtherSearch" : isOtherSearch,
                                "c__otherDetails" : otherCardDataObj,
                                "c__isAdditionalMemberIndividualSearch" : false,
                                "c__isfindIndividualFlag" : false,
                                "c__memberCardFlag" : true,
                                "c__contactCard":component.get("v.contactCard"),
                                "c__providerDetailsForRoutingScreen": component.get("v.providerDetailsForRoutingScreen"),
                                "c__flowDetailsForRoutingScreen": component.get("v.flowDetailsForRoutingScreen"),
                                "c__providerDetails": component.get("v.providerDetailsForRoutingScreen"),// Not sure if we can use this
                                "c__interactionOverviewTabId": component.get("v.interactionOverviewTabId") ,
                                "c__policyDateRange": policyDateRange,
                                "c__isClaim": component.get("v.isClaim"),
                                "c__claimInput": claimInput
                            }
                        }
                    }).then(function(subtabId) {
                        var tabLabel = "";
                        if(!$A.util.isEmpty(selectedMemberFirstName)){
                            tabLabel = selectedMemberFirstName.charAt(0).toUpperCase() + selectedMemberFirstName.slice(1).toLowerCase() + " ";
                        }
                        if(!$A.util.isEmpty(selectedMemberLasttName)){
                            tabLabel = tabLabel + selectedMemberLasttName.charAt(0).toUpperCase() + selectedMemberLasttName.slice(1).toLowerCase();
                        }
                        workspaceAPI.setTabLabel({
                            tabId: subtabId,
                            label: tabLabel
                        });
                        workspaceAPI.setTabIcon({
                            tabId: subtabId,
                            icon: "custom:custom38",
                            iconAlt: "Snapshot"
                        });
                    }).catch(function(error) {

                    });
                });
            } else { //Tab focus for opened tabs
                let mapOpenedTabs = new Map();
                for(var i = 0; i < response.length; i++) {
                    for(var j = 0; j < response[i].subtabs.length; j++) {
                        let subTab = response[i].subtabs[j];
                        mapOpenedTabs.set(subTab.pageReference.state.c__memberUniqueId,subTab);
                    }
                }
                if(mapOpenedTabs.has(memUniqueId)) {
                    let currentTab = mapOpenedTabs.get(memUniqueId);
                    var focusTabId = currentTab.tabId;
                    var tabURL = currentTab.url;

                    workspaceAPI.openTab({
                        url: currentTab.url
                    }).then(function(response) {
                        workspaceAPI.focusTab({tabId : response});
                    }).catch(function(error) {

                    });
                }
            }
        })
    }, //US3389424
    onTabClosed: function (cmp, event, helper) {
        let tabFromEvent = event.getParam("tabId");
        console.log('tabFromEvent');
        var mapOpenedTabs = cmp.get('v.TabMap');
        for (var key in mapOpenedTabs) {
            console.log("key: " + key + "Value: " + mapOpenedTabs[key]);
            if (tabFromEvent == key) {
                var tableBody = cmp.get('v.tableBody');
                var info = mapOpenedTabs[key];
                console.log('info' + JSON.stringify(info));
                for (var i in tableBody) {
                    if (tableBody[i].rowColumnData[5].fieldValue == mapOpenedTabs[key].claimNumber) {
                        tableBody[i].rowColumnData[5].fieldType = 'link';
                        tableBody[i].rowColumnData[5].isLink = true;
                        tableBody[i].rowColumnData[5].isOutputText = false;
                        cmp.set('v.tableBody', tableBody);
                        mapOpenedTabs.delete(key);
                        break;
                    }
                }
            }
        }
    },

    // US3449703
    toggleRecovery: function (cmp, event, helper) {
        var spinner = cmp.find('srncspinner');
        $A.util.removeClass(spinner, 'slds-hide');
        $A.util.addClass(spinner, 'slds-show');

        window.setTimeout(
            $A.getCallback(function () {
                var recoveryRows = [];
                var originalRows = [];
                var tableDetails = cmp.get("v.tableDetails");
                if (cmp.get("v.showRecovery")) {
                    tableDetails.tableBody.forEach(row => {
                        if (row.hasRecovery) {
                            row.rowColumnData[7].fieldValue = row.recoveryAmt;
                            recoveryRows.push(row);
                        }
                        originalRows.push(row);
                    });
                    tableDetails.tableBody = recoveryRows;
                    cmp.set("v.tableDetails", tableDetails);
                    cmp.set("v.originalTableData", originalRows);
                    $A.util.removeClass(spinner, 'slds-show');
                    $A.util.addClass(spinner, 'slds-hide');
                } else {
                    var originalData = cmp.get("v.originalTableData");
                    originalData.forEach(row => {
                        row.rowColumnData[7].fieldValue = row.paidAmount;
                    });
                    tableDetails.tableBody = originalData;
                    cmp.set("v.tableDetails", tableDetails);
                    $A.util.removeClass(spinner, 'slds-show');
                    $A.util.addClass(spinner, 'slds-hide');
                }
            }), 500
        );
    }
})