({
    //US3625667: View Payments -  Error Code Handling - Swapnil
    paymentDetailsErrorMsg: "Unexpected Error Occurred in the Payment Detail Card. Please try again. If problem persists please contact help desk. ",

    // US3456351 - Kavinda
    setTableData: function (cmp, event) {

        var requestObject = cmp.get('v.requestObject');
        var checkSearchRespObj = cmp.get('v.checkSearchRespObj');

        // US3449703
        if(!$A.util.isUndefinedOrNull(cmp.get("v.policyDetails"))){
        var policyCode = cmp.get("v.policyDetails").resultWrapper.policyRes.sourceCode;
        var result = cmp.get("v.bulkRecoveryData");
        var bulkResponse;
        if (result != null && result.isSuccess && policyCode == 'CS') {
            bulkResponse = result.response;
            cmp.set("v.enableRecovery", true);
        }
}
        var tableDetails = new Object();
        tableDetails.type = "table";
        tableDetails.showComponentName = false;
        tableDetails.componentName = 'Payment Details: ' + requestObject.checkNumber;
        tableDetails.autodocHeaderName = 'Payment Details: ' + requestObject.checkNumber;
        // US3653575
        tableDetails.reportingHeader = 'Payment Details';

        	tableDetails.tableHeaders = ["GROUP #", "MEMBER NAME", "RELATIONSHIP", "CLAIM #", "SERVICE DATES", "PAID AMOUNT"];

        tableDetails.caseItemsEnabled = false;
        if( cmp.get('v.isFromClaimDetails') ) {
            //Component Order for Payment Details card on Claim Details tab - Swapnil
            tableDetails.componentOrder = 8 + (20*(cmp.get('v.currentIndexOfOpenedTabs'))) ;
        } else {
        tableDetails.componentOrder= 3.5; //DE466140- Swapnil
        }
        tableDetails.tableBody = [];

        var showViewMoreBtn = false;

        // US3678785
        var un = 0;

        for (var x = 0; x < checkSearchRespObj.length; x++) {

            showViewMoreBtn = false;

            if (!$A.util.isUndefinedOrNull(checkSearchRespObj[x].response)) {

                var response = checkSearchRespObj[x].response;

                if (!$A.util.isUndefinedOrNull(response.data)
                    && !$A.util.isUndefinedOrNull(response.data.checkSummary)
                    && !$A.util.isUndefinedOrNull(response.data.checkSummary.draftDetail)) {
                    var draftDetail = response.data.checkSummary.draftDetail;

                    for (var i = 0; i < draftDetail.length; i++) {

                        var rowColumnData = [];
                        var payment = draftDetail[i];

                        var paidAmount = '';
                        if (!$A.util.isUndefinedOrNull(payment.draftItem)) {
                            paidAmount = payment.draftItem.paidAmount;
                        }

                        //rowColumnData.push(this.setRowColumnData('outputText', payment.subscriberId, un, ''));

                            rowColumnData.push(this.setRowColumnData('outputText', payment.policyNumber, un, ''));
                        rowColumnData.push(this.setRowColumnData('outputText', payment.firstName + ' ' + payment.lastName, un, ''));

                        	//rowColumnData.push(this.setRowColumnData('outputText', '', un, '')); // DOB - GAP

                        rowColumnData.push(this.setRowColumnData('outputText', payment.relationshipCode, i, ''));
                        rowColumnData.push(this.setRowColumnData('link', payment.icn, un, ''));
                        rowColumnData.push(this.setRowColumnData('link', 'Show Dates', un, ''));
                        rowColumnData.push(this.setRowColumnData('Currency',paidAmount, un, ''));

                        var row = {
                            "checked": false,
                            "uniqueKey": un,
                            "rowColumnData": rowColumnData
                        };

                        // US3449703
                        if (bulkResponse != null) {
                            var bulkRec = bulkResponse.filter(resp => resp.draftNbr == payment.draftItem.draftNumber);
                            if (bulkRec != null && bulkRec.length > 0) {
                                row.hasRecovery = true;
                                row.recoveryAmt = bulkRec[0].paidAmount;
                                row.paidAmount = paidAmount;
                            } else {
                                row.hasRecovery = false;
                                row.paidAmount = paidAmount;
                            }
                        }else {
                            row.hasRecovery = false;
                            row.paidAmount = paidAmount;
                        }

                        //row.caseItemsExtId=payment.subscriberId; // US3632386 Swapnil
                        row.uniqueKey = un;
                        // US3653575
                        if (cmp.get('v.isFromClaimDetails') && cmp.get("v.claimInput") != null) {
                            row.caseItemsExtId = cmp.get("v.claimInput").claimNumber;
                        }
                        tableDetails.tableBody.push(row);

                        ++un;
                        // US3678785

                    }
                    if (!$A.util.isUndefinedOrNull(response.data.pagingState)) {
                        var pagingState = response.data.pagingState;
                        if (!$A.util.isUndefinedOrNull(pagingState.moreData)
                            && !$A.util.isUndefinedOrNull(pagingState.nextKey)) {
                            if (pagingState.moreData == "true" && pagingState.nextKey.trim().length > 0) {
                                cmp.set('v.nextKey', pagingState.nextKey);
                                showViewMoreBtn = true;
                            }
                        }
                    } else {
                        showViewMoreBtn = false;
                    }

                }
            }
        }

        // US3449703
        // tableDetails = this.callBulkRecovery(cmp);

        cmp.set('v.showViewMoreBtn', showViewMoreBtn);

        for(var i in tableDetails.tableBody){
            if(tableDetails.tableBody[i].rowColumnData.length > 1){
                tableDetails.tableBody[i].rowColumnData.find( r=> r.fieldType == 'Currency').isOutputText = false;
                tableDetails.tableBody[i].rowColumnData.find( r=> r.fieldType == 'Currency').isCurrencyOutputText = true;
            }
        }

        cmp.set("v.tableDetails", tableDetails);
        // _autodoc.setAutodoc(cmp.get("v.autodocUniqueId"), cmp.get("v.autodocUniqueIdCmp"), tableDetails);
    },

    setRowColumnData: function (ft, fv, uk, hover) {
        var rowColumnData = new Object();
        rowColumnData.fieldType = ft;
        rowColumnData.key = uk;
        if (!$A.util.isUndefinedOrNull(fv) && !$A.util.isEmpty(fv) && fv.length > 0) {
            if (fv.length > 20) {
                rowColumnData.fieldValue = fv.substring(0, 20) + '...';
                rowColumnData.titleName = (hover != '' ? hover : fv);
            } else {
                rowColumnData.fieldValue = fv;
                rowColumnData.titleName = (hover != '' ? hover : '');
            }
        } else {
            rowColumnData.fieldValue = '--';
            rowColumnData.titleName = '';
        }
        rowColumnData.isReportable = true;
        if ('link' == ft) {
            rowColumnData.isLink = true;
        } else if ('outputText' == ft) {
            rowColumnData.isOutputText = true;
        } else if ('isStatusIcon' == ft) {
            rowColumnData.isIcon = true;
        } else {
            rowColumnData.isOutputText = true;
        }
        return rowColumnData;
    },

    //US3389389: Select Claim # Hyperlink in Payment Details - Swapnil 6/11/21
    navigateToDetail: function (component, event, helper, selectedRowdata, selectedClaimNo) {
        let policyDetails = component.get("v.policyDetails");
        let insuranceTypeCode = component.get("v.insuranceTypeCode");
        let contractFilterData = {};
        if (!$A.util.isEmpty(policyDetails)) {
            contractFilterData = {
                "marketType": policyDetails.resultWrapper.policyRes.marketType,
                "marketSite": policyDetails.resultWrapper.policyRes.marketSite,
                "productCode": insuranceTypeCode,
                "platform": policyDetails.resultWrapper.policyRes.platform

            }
        }

        let selectedClaimDetailCard = component.get("v.mapClaimSummaryDetails");
        let selectedClaimStatusTable = component.get("v.listClaimStatusDetails");
        let selectedmemberInfoDetails = component.get("v.memberInfoDetails");
        let selectedClaimSearchResult = component.get("v.mapClaimSearchResult");
        let mapInOutPatientDetails = component.get("v.mapInOutPatientDetails"); // DE477141 Swapnil

        let PROVIDERID = selectedClaimDetailCard.cardData[2].fieldValue;

        let memberID = component.get("v.memberId");
        if (!$A.util.isUndefinedOrNull(selectedClaimDetailCard) && !$A.util.isEmpty(selectedClaimDetailCard)) {
            var fieldString = selectedClaimDetailCard.cardData[6].fieldValue;
            var array = [];
            array = fieldString.split('-');
        }

        var firstSvcDateParts = array[0].trim().split('/');
        var firstSvcDate = firstSvcDateParts[2] + '-' + firstSvcDateParts[0] + '-' + firstSvcDateParts[1] + 'T00:00:00.000Z';
        var lastSvcDateParts = array[1].trim().split('/');
        var lastSvcDate = lastSvcDateParts[2] + '-' + lastSvcDateParts[0] + '-' + lastSvcDateParts[1] + 'T00:00:00.000Z';
        var receivedDate = selectedmemberInfoDetails.receivedDate.trim().split('/');
        var receivedDate = receivedDate[2] + '-' + receivedDate[0] + '-' + receivedDate[1] + 'T00:00:00.000Z';
        let relatedDocData = {
            "FirstDateofService": firstSvcDate,
            "LastDateofService": lastSvcDate,
            "MemberID": memberID,
            "TIN": selectedClaimDetailCard.cardData[1].fieldValue,
            "ClaimNumber": selectedClaimNo,
            "FirstName": selectedmemberInfoDetails.ptntFn,
            "LastName": selectedmemberInfoDetails.ptntLn,
            "receivedDate": receivedDate,
            "selectedmemberInfoDetails": selectedmemberInfoDetails,
            "policyNumber": component.get("v.policyNumber"),
            "platform": selectedmemberInfoDetails.platform,
            "PatientFullName": selectedmemberInfoDetails.ptntFn + ' ' + selectedmemberInfoDetails.ptntLn
        };

        var serviceDates = selectedClaimDetailCard.cardData[6].fieldValue;
        var dates = serviceDates.split("-");
        var startDate = dates[0].split("/");
        var endDate = dates[1].split("/");
        var claimStartDate = startDate[2].trim() + "-" + startDate[0].trim() + "-" + startDate[1].trim();
        var claimEndDate = endDate[2].trim() + "-" + endDate[0].trim() + "-" + endDate[1].trim();

        let claimStatus = selectedClaimStatusTable.tableBody[0].rowColumnData[2].fieldValue;
        var claimStatusSet = component.get("v.claimStatusSet");
        let claimStatusSetNew = new Set();
        for (var x in claimStatusSet) {
            claimStatusSetNew.add(claimStatusSet[x]);
        }
        let isClaimNotOnFile = claimStatusSetNew.has(claimStatus) ? true : false;
        var currentRowIndex = event.getParam("currentRowIndex");

        // US3707305
        var matchingTabs = [];
        let claimNoTabUniqueId = component.get('v.memberTabId') + selectedClaimNo;
        var memberPolicesTOsend = component.get("v.memberPolicies");
        var selectedPolicy = component.get("v.selectedPolicy");
        var callTopicLstSelected = component.get("v.callTopicLstSelected");

        let mapOpenedTabs = component.get('v.TabMap');
        if ($A.util.isUndefinedOrNull(mapOpenedTabs)) {
            mapOpenedTabs = new Map();
        }

        var extProviderTable = _autodoc.getAutodocComponent(component.get("v.autodocUniqueId"), component.get("v.autodocUniqueIdCmp"), 'Payment Details: ' + component.get('v.requestObject').checkNumber);
        var currentIndexOfOpenedTabs;
        if (!$A.util.isUndefinedOrNull(extProviderTable) && !$A.util.isUndefinedOrNull(extProviderTable.selectedRows)) {
            currentIndexOfOpenedTabs = extProviderTable.selectedRows.length - 1;
        }
        // Launch Claim Detail Page
        let workspaceAPI = component.find("workspace");
        workspaceAPI.getAllTabInfo().then(function (response) {

            // US3707305
            if (!$A.util.isEmpty(response)) {
                for (var i = 0; i < response.length; i++) {
                    for (var j = 0; j < response[i].subtabs.length; j++) {
                        if (response[i].subtabs.length > 0) {
                            var tabclaimNoTabUniqueId = response[i].subtabs[j].pageReference.state.c__claimNoTabUnique;
                            if (claimNoTabUniqueId === tabclaimNoTabUniqueId) {
                                matchingTabs.push(response[i].subtabs[j]);
                                break;
                            }
                        }
                    }
                }
            }

            if (matchingTabs.length === 0) {
            var callTopics = [];
            if (!$A.util.isUndefinedOrNull(callTopicLstSelected) && !$A.util.isEmpty(callTopicLstSelected)) {
                callTopics = JSON.stringify(callTopicLstSelected);
            }
            var providerDetails = JSON.stringify(component.get("v.providerDetails"));
            if (component.get("v.policyDetails").resultWrapper.policyRes.sourceCode == "CO") {
                component.set("v.isMRlob", true);
            } else {
                component.set("v.isMRlob", false);
            }
            workspaceAPI.openSubtab({
                pageReference: {
                    "type": "standard__component",
                    "attributes": {
                        "componentName": "c__ACET_ClaimDetails"
                    },
                    "state": {
                        "c__claimNo": selectedClaimNo,
                        "c__resultsTableRowData": selectedClaimSearchResult.tableBody[0],
                        "c__currentRowIndex": currentRowIndex,
                        "c__claimNoTabUnique": claimNoTabUniqueId,
                        "c__hipaaEndpointUrl": component.get("v.hipaaEndpointUrl"),
                        "c__contactUniqueId": component.get("v.contactUniqueId"),
                        "c__interactionRec": JSON.stringify(component.get('v.interactionRec')),
                        "c__interactionOverviewTabId": component.get("v.interactionOverviewTabId"),
                        "c__claimInput": component.get("v.claimInput"),
                        "c__isMRlob": component.get("v.isMRlob"),
                        "c__selectedClaimDetailCard": JSON.stringify(selectedClaimDetailCard),
                        "c__selectedClaimStatusTable": JSON.stringify(selectedClaimStatusTable),
                        "c__contractFilterData": JSON.stringify(contractFilterData),
                        "c__autodocUniqueId": component.get("v.autodocUniqueId"),
                        "c__autodocUniqueIdCmp": component.get("v.autodocUniqueIdCmp"),
                        "c__caseWrapperMNF": component.get("v.caseWrapperMNF"),
                        "c__componentId": component.get("v.componentId"),
                        "c__memberDOB": component.get("v.memberDOB"),
                        "c__policyDetails": component.get("v.policyDetails"),
                        "c__memberFN": component.get("v.memberFN"),
                        "c__memberCardData": component.get("v.memberCardData"),
                        "c__memberCardSnap": component.get("v.memberCardSnap"),
                        "c__policyNumber": component.get("v.policyNumber"),
                        "c__houseHoldData": JSON.stringify(component.get("v.houseHoldData")),
                        "c__dependentCode": component.get("v.dependentCode"),
                        "c__regionCode": component.get("v.regionCode"),
                        "c__cobData": JSON.stringify(component.get("v.cobData")),
                        "c__secondaryCoverageList": JSON.stringify(component.get("v.secondaryCoverageList")),
                        "c__cobMNRCommentsTable": JSON.stringify(component.get("v.cobMNRCommentsTable")),
                        "c__cobENIHistoryTable": JSON.stringify(component.get("v.cobENIHistoryTable")),
                        "c__houseHoldMemberId": component.get("v.houseHoldMemberId"),
                        "c__memberPolicies": JSON.stringify(memberPolicesTOsend),
                        "c__policySelectedIndex": component.get("v.policySelectedIndex"),
                        "c__currentPayerId": component.get("v.currentPayerId"),
                        "c__memberautodocUniqueId": component.get("v.memberautodocUniqueId"),
                        "c__autoDocToBeDeleted": component.get("v.autoDocToBeDeleted"),
                        "c__serviceFromDate": claimStartDate,
                        "c__serviceToDate": claimEndDate,
                        "c__memberLN": component.get("v.memberLN"),
                        "c__AuthAutodocPageFeatur": component.get("v.AuthAutodocPageFeature"),
                        "c__authContactName": component.get("v.authContactName"),
                        "c__SRNFlag": component.get("v.SRNFlag"),
                        "c__interactionType": component.get("v.interactionType"),
                        "c__AutodocPageFeatureMemberDtl": component.get("v.AutodocPageFeatureMemberDtl"),
                        "c__AutodocKeyMemberDtl": component.get("v.AutodocKeyMemberDtl"),
                        "c__isHippaInvokedInProviderSnapShot": component.get("v.isHippaInvokedInProviderSnapShot"),
                        "c__noMemberToSearch": component.get("v.noMemberToSearch"),
                        "c__interactionCard": component.get("v.interactionCard"),
                        "c__selectedTabTyp": component.get("v.selectedTabType"),
                        "c__originatorType": component.get("v.originatorType"),
                        "c__memberTabId": component.get("v.memberTabId"),
                        "c__providerId": PROVIDERID,
                        "c__currentIndexOfOpenedTabs": (extProviderTable.selectedRows.length-1),
                        "c__selectedPolicy": JSON.stringify(selectedPolicy),
                        "c__callTopicOrder": JSON.stringify(component.get("v.callTopicOrder")),
                        "c__planLevelBenefitsRes": JSON.stringify(component.get("v.planLevelBenefitsRes")),
                        "c__eligibleDate": component.get("v.eligibleDate"),
                        "c__highlightedPolicySourceCode": component.get("v.highlightedPolicySourceCode"),
                        "c__isSourceCodeChanged": component.get("v.isSourceCodeChanged"),
                        "c__policyStatus": component.get("v.policyStatus"),
                        "c__isTierOne": component.get("v.isTierOne"),
                        "c__callTopicLstSelected": callTopics,
                        "c__callTopicTabId": component.get("v.callTopicTabId"),
                        "c__relatedDocData": relatedDocData,
                        "c__providerDetails": providerDetails,
                        "c__addClaimType": selectedClaimSearchResult.tableBody[0].additionalData.ClaimType, //US3502296 - Raviteja - Team Blinkers
                        "c__addnetworkStatus": selectedClaimSearchResult.tableBody[0].additionalData.NetworkStatus, //US3502296 - Raviteja - Team Blinkers
                        "c__addbilltype": selectedClaimSearchResult.tableBody[0].additionalData.billtype, //US3502296 - Raviteja - Team Blinkers
                        "c__isClaimNotOnFile": isClaimNotOnFile,
                        "c__insuranceTypeCode": component.get("v.insuranceTypeCode"), // US3705824
                        "c__providerDetailsForRoutingScreen": component.get("v.providerDetailsForRoutingScreen"),
                        "c__flowDetailsForRoutingScreen": component.get("v.flowDetailsForRoutingScreen"),
                        "c__mapInOutPatientDetail": JSON.stringify(mapInOutPatientDetails), //DE477141 Swapnil
                        "c__selectedIPAValue": component.get("v.selectedIPAValue")
                    }
                },
                focus: true
            }).then(function (response) {
                var info = {};
                    info.tabUniqueId= claimNoTabUniqueId;
                    info.claimNumber= selectedClaimNo;
                    mapOpenedTabs[response]=info;
                    console.log("mapOpenedTabs value "+ JSON.stringify(mapOpenedTabs));
                    component.set('v.TabMap', mapOpenedTabs);

                currentIndexOfOpenedTabs++;
                component.set('v.currentIndexOfOpenedTabs',currentIndexOfOpenedTabs);

                workspaceAPI.setTabLabel({
                    tabId: response,
                    label: selectedClaimNo
                });
                workspaceAPI.setTabIcon({
                    tabId: response,
                    icon: "custom:custom17",
                    iconAlt: "Claim Detail"
                });
            }).catch(function (error) {

                });

                $A.util.removeClass(event.currentTarget, "disableLink");

            } else {
                // US3701717: View Claims: Select Claim # Hyperlink in Payment Status Card - Swapnil
                var info={};
                info.tabUniqueId= claimNoTabUniqueId;
                info.claimNumber= selectedClaimNo;
                mapOpenedTabs[matchingTabs[0].tabId]=info;
                console.log("mapOpenedTabs value "+ JSON.stringify(mapOpenedTabs));
                component.set('v.TabMap', mapOpenedTabs);
                currentIndexOfOpenedTabs++;
                component.set('v.currentIndexOfOpenedTabs',currentIndexOfOpenedTabs);

                // US3707305
                var focusTabId = matchingTabs[0].tabId;
                var tabURL = matchingTabs[0].url;
                workspaceAPI.openTab({
                    url: tabURL
                }).then(function (response) {
                    workspaceAPI.focusTab({
                        tabId: response
            });
        }).catch(function (error) {

                });

            }

        }).catch(function (error) {

        });
    },

    // US3476420
    searchPaymentDetails: function (cmp, event, helper) {

        var spinner = cmp.find('srncspinner');
        var checkSearchRespObj = cmp.get("v.checkSearchRespObj");
        var requestObj = cmp.get('v.requestObject');
        if ($A.util.isUndefinedOrNull(requestObj)) {
            requestObj = new Object();
        }
        requestObj.nextKey = cmp.get('v.nextKey');
        $A.util.removeClass(spinner, 'slds-hide');
        $A.util.addClass(spinner, 'slds-show');
        var action = cmp.get("c.doPaymentCheckSearch");
        action.setParams({
            requestObject: requestObj
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            $A.util.removeClass(spinner, 'slds-show');
            $A.util.addClass(spinner, 'slds-hide');
            if (state == 'SUCCESS') {
                var result = response.getReturnValue();
                if (result.statusCode == 200 || result.statusCode == 201) {
                    checkSearchRespObj.push(result);
                    cmp.set("v.checkSearchRespObj", checkSearchRespObj);
                    helper.setTableData(cmp, event);
                } else {
                    //US3625667: View Payments -  Error Code Handling - Swapnil
                    this.fireToastMessage("We hit a snag.", this.paymentDetailsErrorMsg, "error", "dismissible", "6000");
                    cmp.set("v.isShowCheckPaymentDetails", false);
                }
            } else {
                //US3625667: View Payments -  Error Code Handling - Swapnil
                this.fireToastMessage("We hit a snag.", this.paymentDetailsErrorMsg, "error", "dismissible", "6000");
            }

        });
        $A.enqueueAction(action);
    },

    // US3476420
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

    // US3449703
    callBulkRecovery: function (cmp, tableDetails) {
        var policyCode = cmp.get("v.policyDetails").resultWrapper.policyRes.sourceCode;
        var result = cmp.get("v.bulkRecoveryData");
        if (result.isSuccess && policyCode == 'CS') {
            cmp.set("v.enableRecovery", true);
        }
    }

})