({
    // US3299151 - Thanish - 16th Mar 2021
    showPolicyErrorMessage: true,
    policyErrorMessage: "Unexpected Error Occurred in the Policies Card. Please try again. If problem persists please contact the help desk",

    filterTableBody: function (cmp, event) {
        var filterIsMedicalOnly = cmp.get("v.filterIsMedicalOnly");
        var filterIsActive = cmp.get("v.filterIsActive");
        var tableDetails = cmp.get("v.tableDetails");



        var tableBody = tableDetails.tableBody;
        var i;

        for (i = 0; i < tableBody.length; i++) {

            if (filterIsMedicalOnly && filterIsActive) {
                if (tableBody[i].isMedicalPolicy && tableBody[i].isActive) {
                    tableBody[i].hide = false;
                } else {
                    tableBody[i].hide = true;
                }

            } else if (!filterIsMedicalOnly && filterIsActive) {
                if (tableBody[i].isActive) {
                    tableBody[i].hide = false;
                } else {
                    tableBody[i].hide = true;
                }

            } else if (filterIsMedicalOnly && !filterIsActive) {
                if (tableBody[i].isMedicalPolicy) {
                    tableBody[i].hide = false;
                } else {
                    tableBody[i].hide = true;
                }

            } else {
                tableBody[i].hide = false;
            }
        }

        tableDetails.tableBody = tableBody;
        tableDetails.ignoreClearAutodoc = true; // DE456923 - Thanish - 30th Jun 2021
        cmp.set("v.tableDetails", tableDetails);
    },

    rowAutodocCheck: function (cmp, event, checked, currentRowIndex) {
        var tableDetails = cmp.get("v.tableDetails");
        var autodocTables = cmp.get("v.autodocTables");
        var tableCopy = {};
        tableCopy.type = "table";
        tableCopy.autodocHeaderName = "Policies";
        tableCopy.componentOrder = 1;
        tableCopy.componentName = "Policies";
        //US3059727 - Sravan
        tableCopy.tableHeaders = ["GROUP #", "SOURCE", "PLAN", "TYPE", "PRODUCT", "COVERAGE LEVEL", "ELIGIBILITY DATES", "STATUS", "REF REQ", "PCP REQ", "RESOLVED"]; // US2928520: Policies Card - added TYPE and Changed POLICY to PRODUCT
        tableCopy.tableBody = [];
        tableCopy.selectedRows = [];
        var i;

        for (i = 0; i < tableDetails.tableBody.length; i++) {
            if (i == currentRowIndex) {
                tableDetails.tableBody[i].checked = true;
                //US3059727 - Sravan - Start
                tableDetails.tableBody[i].resolved = true;
                //US3059727 - Sravan - End
            } else {
                tableDetails.tableBody[i].checked = false;
            }
        }
        tableDetails.ignoreClearAutodoc = true; // DE456923 - Thanish - 30th Jun 2021
        cmp.set("v.tableDetails", tableDetails);

        tableCopy.tableBody[currentRowIndex] = tableDetails.tableBody[currentRowIndex];
        tableCopy.selectedRows.push(tableDetails.tableBody[currentRowIndex]);
        tableCopy.ignoreClearAutodoc = true; // DE456923 - Thanish - 30th Jun 2021
        autodocTables[currentRowIndex] = tableCopy;

        cmp.set("v.autodocTables", autodocTables);
        _autodoc.setAutodoc(cmp.get("v.autodocUniqueId"), currentRowIndex, cmp.get("v.autodocTables")[currentRowIndex]);
        cmp.set("v.policySelectedIndex", currentRowIndex);
    },

    callRCED: function (component, helper, policyData) {

        component.set("v.showSpinner", true);
        let action = component.get("c.call_RCED_API");
        var params = {
            "subscriberId": policyData.resultWrapper.policyRes.EEID,
            "policyNumber": policyData.resultWrapper.policyRes.policyNumber,
            "sourceCode": policyData.resultWrapper.policyRes.sourceCode
        };
        action.setParams(params);
        action.setCallback(this, function (response) {
            let state = response.getState();
            if (state === "SUCCESS") {
                var rcedResultWrap = response.getReturnValue();
                if (!$A.util.isUndefinedOrNull(rcedResultWrap)) {
                    if (!$A.util.isUndefinedOrNull(rcedResultWrap.statusCode) && rcedResultWrap.statusCode == 200) {
                        component.set("v.rcedResultWrapper", rcedResultWrap);
                        console.log("rcedResultWrap123" + JSON.stringify(rcedResultWrap));
                        //delaying setting of policy details to allow for rced response to be available
                    } else {
                        // US3299151 - Thanish - 16th Mar 2021
                        if(this.showPolicyErrorMessage){
                            this.fireToastMessage("We hit a snag.", this.policyErrorMessage, "error", "dismissible", "30000");
                            this.showPolicyErrorMessage=false;
                    }
                }
            } else {
                    // US3299151 - Thanish - 16th Mar 2021
                    if(this.showPolicyErrorMessage){
                        this.fireToastMessage("We hit a snag.", this.policyErrorMessage, "error", "dismissible", "30000");
                        this.showPolicyErrorMessage=false;
                    }
            }
            } else {
                // US3299151 - Thanish - 16th Mar 2021
                if(this.showPolicyErrorMessage){
                    this.fireToastMessage("We hit a snag.", this.policyErrorMessage, "error", "dismissible", "30000");
                    this.showPolicyErrorMessage=false;
                }
            }
            component.set('v.policyDetails', policyData);
            component.set("v.showSpinner", false);
        });
        $A.enqueueAction(action);
    },

    getExtendedData: function (cmp, transactionId, indexNo, helper) {
        // US3504373	Unable to Determine  Policy - Save Case - Sarma - 05th May 2021
        var tableDetails = cmp.get("v.tableDetails");
        let isUnableToDetermine = false;
        let wordTocheck = 'Unable to determine';
        if ($A.util.isEmpty(tableDetails.tableBody[indexNo].rowColumnData[0].fieldValue) || tableDetails.tableBody[indexNo].rowColumnData[0].fieldValue.includes(wordTocheck)) {
            isUnableToDetermine = true;
        }
        this.showPolicyErrorMessage=true;// US3299151 - Thanish - 16th Mar 2021
        //start
        var tabId;
        var workspaceAPI = cmp.find("workspace");
        workspaceAPI.getFocusedTabInfo().then(function (response) {
                tabId = response.tabId;
            })
            .catch(function (error) {
                console.log(error);
            });
        //end
        var action = cmp.get("c.getExtendedResult");
        action.setParams({
            transactionId: transactionId
        });
        action.setCallback(this, function (response) {
            //US3683231 - Sravan - Start
            var currentSourceCode = '';
            //US3683231 - Sravan - End
            if (response.getState() == 'SUCCESS') {
                var result = response.getReturnValue();
                //Jitendra
                var extendedData, strMemberId, strGraceMessageByState, strGracePaidThrough, strGracePeriodMonth;
                // US3475823	Restricted Policies update message and disalbe save case button - Sarma - 27 Apr 2021
                var isSaveCaseDisabled = false;

                if (result.statusCode == 200) {
                    //Optimization
                    if (!$A.util.isUndefinedOrNull(result.extendedResultObject)) {

                        extendedData = result.extendedResultObject;
                        if (!$A.util.isUndefinedOrNull(tabId)) {
                            cmp.set("v.SnapTabId",tabId); //US3557591:New Mapping Needed for Notes - Swapnil
                            _setAndGetSessionValues.settingValue("Policy:" + tabId + ":" + tabId, extendedData);
                        }

                        if (!$A.util.isUndefinedOrNull(extendedData.planLevelBenefitsRes)) {
                            cmp.set('v.planLevelBenefitsRes', extendedData.planLevelBenefitsRes);
                        }
                        if (!$A.util.isUndefinedOrNull(extendedData.houseHoldWrapper)) {
                            cmp.set('v.extendedHouseholdData', extendedData.houseHoldWrapper);
                        }
                        if (!$A.util.isUndefinedOrNull(extendedData.cobWrapper)) {
                            cmp.set('v.extendedCOBData', extendedData.cobWrapper);
                        }
                        if (!$A.util.isUndefinedOrNull(extendedData.policyResultWrapper)) {
                            extendedData.policyResultWrapper.resultWrapper.policyRes.transactionId = transactionId; //US2669563-MVP- Member Snapshot - Policy Details - Populate Payer ID-Durga

                            var policyDetails = extendedData.policyResultWrapper;

                            if (policyDetails && policyDetails.resultWrapper && policyDetails.resultWrapper.policyRes && policyDetails.resultWrapper.policyRes.benefitPlanId) {
                                cmp.set("v.strBenefitPlandId", policyDetails.resultWrapper.policyRes.benefitPlanId);
                            }

                            if (!$A.util.isUndefinedOrNull(policyDetails.resultWrapper) && !$A.util.isUndefinedOrNull(policyDetails.resultWrapper.policyRes)) {
                                // US2928520: Policies Card - START

                                var policyList = cmp.get("v.policyList");
                                var selectedPolicyObj = policyList[indexNo];
                                var productType = "--";
                                // US2928520: Policies Card - END
                                //US2637492 - Member Snapshot - Add DIV to CO Source Code - Sravan - Start
                                if (!$A.util.isUndefinedOrNull(policyDetails.resultWrapper.policyRes.sourceCode) && !$A.util.isEmpty(policyDetails.resultWrapper.policyRes.sourceCode)) {

                                    if (policyDetails.resultWrapper.policyRes.sourceCode == 'AP' || policyDetails.resultWrapper.policyRes.sourceCode == 'PA') {
                                        cmp.set("v.showAPPolicyWarning", true);
                                        cmp.set("v.selectedPolicyWarning", policyDetails.resultWrapper.policyRes.sourceCode);
                                    }

                                    //US2973232
                                    if (policyDetails.resultWrapper.policyRes.sourceCode == 'CO' || policyDetails.resultWrapper.policyRes.sourceCode == 'CS') {
                                        if (cmp.get("v.firstCallout")) {
                                            cmp.set("v.firstCallout", false);
                                            helper.getTierStatus(cmp, transactionId, event, helper, policyDetails.resultWrapper.policyRes);
                                        }
                                    }

                                    currentSourceCode = policyDetails.resultWrapper.policyRes.sourceCode;//US3683231 - Sravan

                                    if (policyDetails.resultWrapper.policyRes.sourceCode == 'CO') {
                                        if (!$A.util.isUndefinedOrNull(policyDetails.resultWrapper.policyRes.cosmosDivision) && !$A.util.isEmpty(policyDetails.resultWrapper.policyRes.cosmosDivision)) {
                                            tableDetails.tableBody[indexNo].rowColumnData[1].fieldValue = policyDetails.resultWrapper.policyRes.sourceCode + ' - ' + policyDetails.resultWrapper.policyRes.cosmosDivision;
                                            tableDetails.tableBody[indexNo].rowColumnData[1].titleName = policyDetails.resultWrapper.policyRes.sourceCodeDetail;
                                        } else {
                                            tableDetails.tableBody[indexNo].rowColumnData[1].fieldValue = policyDetails.resultWrapper.policyRes.sourceCode;
                                            tableDetails.tableBody[indexNo].rowColumnData[1].titleName = policyDetails.resultWrapper.policyRes.sourceCodeDetail;
                                        }
                                        // US2928520: Policies Card - START
                                        if (!$A.util.isEmpty(policyDetails.resultWrapper.policyRes.productType)) {
                                            console.log('## productType res==>' + policyDetails.resultWrapper.policyRes.productType);
                                            if (!$A.util.isEmpty(selectedPolicyObj.insuranceTypeCode)) {
                                                if (selectedPolicyObj.insuranceTypeCode == "HN") {
                                                    productType = "HMO";
                                                } else if (selectedPolicyObj.insuranceTypeCode == "PR") {
                                                    productType = "PPO";
                                                } else if (selectedPolicyObj.insuranceTypeCode == "PS") {
                                                    productType = "POS";
                                                } else if (selectedPolicyObj.insuranceTypeCode == "C1") {
                                                     productType = "Medica";
                                                 }
                                                console.log('## productType==>' + productType);
                                            }
                                            console.log('## productType==>' + productType);
                                            tableDetails.tableBody[indexNo].rowColumnData[3].fieldValue = productType;
                                            tableDetails.tableBody[indexNo].rowColumnData[3].titleName = productType;
                                        }

                                        // US2928520: Policies Card - END
                                    } else {
                                        tableDetails.tableBody[indexNo].rowColumnData[1].fieldValue = policyDetails.resultWrapper.policyRes.sourceCode;
                                        tableDetails.tableBody[indexNo].rowColumnData[1].titleName = policyDetails.resultWrapper.policyRes.sourceCodeDetail;
                                        // US2928520: Policies Card
                                        if (!$A.util.isEmpty(policyDetails.resultWrapper.policyRes.productType)) {
                                            tableDetails.tableBody[indexNo].rowColumnData[3].fieldValue = policyDetails.resultWrapper.policyRes.productType;
                                            tableDetails.tableBody[indexNo].rowColumnData[3].titleName = policyDetails.resultWrapper.policyRes.productType;
                                        }
                                    }
                                }
                                //US2637492 - Member Snapshot - Add DIV to CO Source Code - Sravan - End
                                tableDetails.tableBody[indexNo].rowColumnData[5].fieldValue = policyDetails.resultWrapper.policyRes.coverageLevel;
                                tableDetails.tableBody[indexNo].rowColumnData[5].titleName = policyDetails.resultWrapper.policyRes.coverageLevel;
                                tableDetails.tableBody[indexNo].sourceCodeDetail = policyDetails.resultWrapper.policyRes.sourceCodeDetail;
                                tableDetails.tableBody[indexNo].relationshipCode = policyDetails.resultWrapper.policyRes.relationshipCode;

                                var relationshipCode;
                                cmp.set("v.highlightedPolicySourceCode", policyDetails.resultWrapper.policyRes.sourceCode);
                                cmp.set("v.isSourceCodeChanged", !cmp.get("v.isSourceCodeChanged"));
                                //US2925631 - Tech: Member Alerts Convert Member ID to EEID and Include the Business Segment - Sravan - Start
                                var memberSubscriberId = cmp.get("v.memberSubscriberId");
                                if (!$A.util.isUndefinedOrNull(memberSubscriberId) && !$A.util.isEmpty(memberSubscriberId)) {
                                    if (memberSubscriberId != policyDetails.resultWrapper.policyRes.EEID) {
                                        cmp.set("v.memberSubscriberId", policyDetails.resultWrapper.policyRes.EEID);
                                    }
                                } else {
                                    cmp.set("v.memberSubscriberId", policyDetails.resultWrapper.policyRes.EEID);
                                }
                                //US2925631 - Tech: Member Alerts Convert Member ID to EEID and Include the Business Segment - Sravan - End

                                //US3117073 - Multiple Policies -  Creating Multiple Unique ORS Records Check In ISET - Sravan - Start
                                var memberPolicyNumberMap = cmp.get("v.memberPolicyNumberMap");
                                var groupNum = policyDetails.resultWrapper.policyRes.groupNumber;
                                var policyNum = policyDetails.resultWrapper.policyRes.policyNumber;
                                if (!$A.util.isUndefinedOrNull(memberPolicyNumberMap) && !$A.util.isEmpty(memberPolicyNumberMap)) {
                                    for (var valueKey in memberPolicyNumberMap) {
                                        if (valueKey != groupNum) {
                                            memberPolicyNumberMap[groupNum] = policyNum;
                                        }
                                    }
                                } else {
                                    memberPolicyNumberMap[groupNum] = policyNum;
                                }
                                cmp.set("v.memberPolicyNumberMap", memberPolicyNumberMap);
                                console.log('Member Policy Number Map' + JSON.stringify(memberPolicyNumberMap));
                                //US3117073 - Multiple Policies -  Creating Multiple Unique ORS Records Check In ISET - Sravan - End

                                // US2423120, US2517602, US2517604 Added by Praveen start
                                var selectedPolicyList = cmp.get("v.selectedPolicyLst");
                                for (var i in selectedPolicyList) {
                                    if (selectedPolicyList[i].selectedTranId == transactionId) {
                                        selectedPolicyList[i].selectedSourceCode = policyDetails.resultWrapper.policyRes.sourceCode;
                                        selectedPolicyList[i].selectedRelationshipCode = policyDetails.resultWrapper.policyRes.relationshipCode;
                                        relationshipCode = selectedPolicyList[i].selectedRelationshipCode;
                                        strMemberId = selectedPolicyList[i].memberId;
                                        //Jitendra
                                        strGraceMessageByState = selectedPolicyList[i].strGraceMessageByState;
                                        strGracePaidThrough = selectedPolicyList[i].strGracePaidThrough;
                                        strGracePeriodMonth = selectedPolicyList[i].strGracePeriodMonth;

                                    }
                                    //US2812137
                                    cmp.set("v.relationShipcode", relationshipCode);
                                    // Setting Case wrapper relationshipCode
                                    var caseWrapper = cmp.get('v.caseWrapper');

                                    caseWrapper.strSourceCode = policyDetails.resultWrapper.policyRes.sourceCode;
                                    caseWrapper.policyNumber = policyDetails.resultWrapper.policyRes.policyNumber;
                                    cmp.set("v.higlightGrpNumber", policyDetails.resultWrapper.policyRes.policyNumber);
                                    caseWrapper.RelationshipCode = relationshipCode;
                                    caseWrapper.strMemberId = strMemberId;
                                    cmp.set('v.caseWrapper', caseWrapper);
                                }
                                // US2423120, US2517602, US2517604 Added by Praveen End
                                // DE371920 - Thanish - 7th Oct 2020
                                if (!$A.util.isUndefinedOrNull(policyDetails.resultWrapper.policyRes.groupNumber) && !$A.util.isUndefinedOrNull(tableDetails.tableBody[indexNo].rowColumnData[0].fieldValue)) {
                                    if(isUnableToDetermine){
                                        tableDetails.tableBody[indexNo].rowColumnData[0].fieldValue = policyDetails.resultWrapper.policyRes.groupNumber;
                                        tableDetails.tableBody[indexNo].rowColumnData[0].titleName = policyDetails.resultWrapper.policyRes.groupNumber;
                                    }
                                }
                                tableDetails.ignoreClearAutodoc = true; // DE456923 - Thanish - 30th Jun 2021
                                cmp.set("v.tableDetails", tableDetails);

                                let hasAccess = cmp.get("v.uhgAccess");
                                let lstExclusions = cmp.get("v.lstExlusions");
                                let mapExclusions = new Map();
                                for (let i = 0; lstExclusions.length > i; i++) {
                                    mapExclusions.set(lstExclusions[i].MasterLabel, lstExclusions[i].MasterLabel);
                                }

                                var isRestrictedPolicy = false;
                                var isOffshoreUser = policyDetails.resultWrapper.policyRes.isOffShoreUser;
                                var originatorType = cmp.get("v.originatorType");
                                var caseWrapper = cmp.get('v.caseWrapper');
                                //Fix for offshore Restriction
                                caseWrapper.onShoreRestriction = 'No';
                                caseWrapper.uhgRestriction = 'No'; //DE441126

                                if (mapExclusions.has(tableDetails.tableBody[indexNo].rowColumnData[0].fieldValue) && !hasAccess) {
                                    caseWrapper.uhgRestriction = 'Yes';
                                    helper.fireShowComponentEvent(cmp, event, helper, false,'This Policy is UHG/UHC restricted Policy. Please use Misdirect.');
                                    isSaveCaseDisabled = true; // US3475823
                                }

                                // US2678265 MVP - Offshore Restriction - Implementation for Member &  Provider Interaction - Starts
                                else if (!$A.util.isUndefinedOrNull(policyDetails.resultWrapper.policyRes.policyRestrictionLevelList)) {
                                    var policyRestrictionLevelList = policyDetails.resultWrapper.policyRes.policyRestrictionLevelList;
                                    if (policyRestrictionLevelList.length > 0) {
                                        for (var i = 0; i < policyRestrictionLevelList.length; i++) {
                                            if (policyRestrictionLevelList[i] == 'L7') {
                                                isRestrictedPolicy = true;
                                                caseWrapper.onShoreRestriction = 'Yes';
                                                break;
                                            } else if (policyRestrictionLevelList[i] == 'L5' && (originatorType == 'Provider' || originatorType == 'Other')) {
                                                isRestrictedPolicy = true;
                                                caseWrapper.onShoreRestriction = 'Yes';
                                                break;
                                            } else if (policyRestrictionLevelList[i] == 'L3' && (originatorType == 'Member')) {
                                                isRestrictedPolicy = true;
                                                caseWrapper.onShoreRestriction = 'Yes';
                                                break;
                                            }
                                        }
                                    }

                                    cmp.set('v.caseWrapper', caseWrapper);

                                    if (isRestrictedPolicy && isOffshoreUser) {
                                        isSaveCaseDisabled = true; // US3475823
                                        helper.fireShowComponentEvent(cmp, event, helper, false, 'This Policy is a Domestic restricted Policy. Please use Misdirect.');
                                    } else {
                                        helper.fireShowComponentEvent(cmp, event, helper, true, '');
                                    }
                                }
                                // US2678265 - End
                            }
                            // US2678265 Sarma - 7/7/2020
                            // changing policy details assiging place to resolve autodoc initialization issue during policy switch
                            // US2330408  - Avish
                            var interactionOverviewData = _setAndGetSessionValues.getInteractionDetails(cmp.get("v.interactionOverviewTabId"));

                            var flowDetails = interactionOverviewData.flowDetails;
                            var providerDetails = interactionOverviewData.providerDetails;
                            var memberDetails = interactionOverviewData.membersData;
                            var extendedDetails = extendedData.policyResultWrapper.resultWrapper;

                            var highlightPanelObj = {
                                "memberName": "",
                                "memberID": "",
                                "policy": "",
                                "groupNumber": "",
                                "DIV": "",
                                "panel": "",
                                "sourceCode": "",
                                "noMemberToSearch": false
                            };


                            var tableDataList = cmp.get("v.data");
                            for (var j = 0; j < tableDataList.length; j++) {
                                if (tableDataList[j].SelectedItem) {
                                    JSON.stringify(cmp.get("v.caseWrapper"));

                                    if (!$A.util.isUndefinedOrNull(cmp.get("v.caseWrapper"))) {
                                        var SubjectCard = cmp.get("v.caseWrapper");
                                        highlightPanelObj.memberName = SubjectCard.SubjectName;
                                    }

                                    highlightPanelObj.memberID = caseWrapper.strMemberId; //extendedDetails.policyRes.alternateId;
                                    highlightPanelObj.policy = tableDataList[j].Policy;
                                    highlightPanelObj.DIV = extendedDetails.policyRes.cosmosDivision;
                                    highlightPanelObj.panel = extendedDetails.policyRes.groupPanelNumber;
                                    highlightPanelObj.sourceCode = tableDetails.tableBody[indexNo].rowColumnData[1].fieldValue;
                                    highlightPanelObj.noMemberToSearch = false;

                                    if (!$A.util.isUndefinedOrNull(extendedDetails.policyRes.groupNumber) && !$A.util.isEmpty(extendedDetails.policyRes.groupNumber)) {
                                        if (extendedDetails.policyRes.groupNumber.charAt(0) == 0) {
                                            highlightPanelObj.groupNumber = extendedDetails.policyRes.groupNumber.slice(1, extendedDetails.policyRes.groupNumber.length);
                                        } else {
                                            highlightPanelObj.groupNumber = extendedDetails.policyRes.groupNumber;
                                        }
                                    }
                                    _setAndGetSessionValues.addNewHighLightMember(cmp.get("v.interactionOverviewTabId"), highlightPanelObj);
                                    //_setAndGetSessionValues.updateHighlightPaneletails(cmp.get("v.interactionOverviewTabId"), memberDetails[i]);
                                    providerDetails.status = tableDataList[j].providerStatus;
                                    _setAndGetSessionValues.updateProviderDetails(cmp.get("v.interactionOverviewTabId"), providerDetails);
                                    break;
                                }
                            }
                            cmp.set("v.interactionOverviewTabId", cmp.get("v.interactionOverviewTabId"));

                            extendedData.policyResultWrapper['strGraceMessageByState'] = strGraceMessageByState;
                            extendedData.policyResultWrapper['strGracePaidThrough'] = strGracePaidThrough;
                            extendedData.policyResultWrapper['strGracePeriodMonth'] = strGracePeriodMonth;

                            // US2330408  - Ends



                            //Ketki RCED begin
                            var policyData = extendedData.policyResultWrapper;
                            if (!$A.util.isEmpty(policyData) && !$A.util.isEmpty(policyData.resultWrapper) &&
                                !$A.util.isEmpty(policyData.resultWrapper.policyRes) && !$A.util.isEmpty(policyData.resultWrapper.policyRes.sourceCode) &&
                                policyData.resultWrapper.policyRes.sourceCode == "CS"
                            ) {
                                helper.callRCED(cmp, helper, policyData);
                            } else {
                                cmp.set('v.policyDetails', extendedData.policyResultWrapper);
                            }
                            //Ketki RCED end
                        }
                    }
                } else if(result.statusCode==500) { // US3299151 - Thanish - 16th Mar 2021
                    if(this.showPolicyErrorMessage){
                        this.fireToastMessage("We hit a snag.", this.policyErrorMessage, "error", "dismissible", "30000");
                        this.showPolicyErrorMessage=false;
                    }
                    //US3504373 - Sarma - 05th of MAy 2021
                    if(isUnableToDetermine){
                        isSaveCaseDisabled = true;
                    }
                } else {
                    // US1964371: Error Code Handling - Extended Coverage Attribute Service - KAVINDA
                    if (!$A.util.isUndefinedOrNull(result.extendedData)) {
                        if (!$A.util.isUndefinedOrNull(result.extendedData.faultCode) && result.extendedData.faultCode != '' && !$A.util.isUndefinedOrNull(result.message) && result.message != '') {
                            this.fireToastMessage("We hit a snag.", (result.message + '(' + result.extendedData.faultCode + ')'), "error", "dismissible", "10000");
                        } else {
                            this.fireToastMessage("We hit a snag.", (result.message), "error", "dismissible", "10000");
                        }
                    } else {
                        this.fireToastMessage("We hit a snag.", (result.message), "error", "dismissible", "10000");
                    }
                    //US3504373 - Sarma - 05th of MAy 2021
                    if(isUnableToDetermine){
                        isSaveCaseDisabled = true;
                    }
                }
                // DE391034 - Thanish - 2nd Dec 2020
                if (!$A.util.isEmpty(cmp.get("v.dataORG")[indexNo]) && cmp.get("v.dataORG")[indexNo].PlanSubString.includes('Non Medical')) {
                    cmp.set("v.isSaveCaseDisabled", true);
                    cmp.set("v.isNoPolicies", true);
                } else if(isSaveCaseDisabled){ // US3475823
                    cmp.set("v.isSaveCaseDisabled", true);
                } else {
                    cmp.set("v.isSaveCaseDisabled", false);
                    cmp.set("v.isNoPolicies", false);
                }
                // optimization ends
                //US3683231 - Sravan - Start
                helper.addCaseItems(cmp,transactionId,currentSourceCode, event, helper);
                //US3683231 - Sravan - End
            }

            //Ketki RCED begin
            //source code CS will call RCED. Spinner will be disabled at end of RCED call
            if ($A.util.isEmpty(policyData) || $A.util.isEmpty(policyData.resultWrapper) ||
                $A.util.isEmpty(policyData.resultWrapper.policyRes) || $A.util.isEmpty(policyData.resultWrapper.policyRes.sourceCode) ||
                policyData.resultWrapper.policyRes.sourceCode != "CS"
            ) {
                cmp.set("v.showSpinner", false);
            }
            //Ketki RCED end
            cmp.set('v.showSpinner', false);
        });

        $A.enqueueAction(action);
    },

    // US1761826 - UHC/Optum Exclusion UI
    fetchOptumExclusionGroupIds: function (cmp, event, helper) {
        let action = cmp.get("c.getOptumExlusions");
        action.setCallback(this, function (response) {
            let state = response.getState();
            if (state === "SUCCESS") {
                cmp.set("v.lstExlusions", response.getReturnValue());
            }
            cmp.set("v.showSpinner", false);
        });
        cmp.set("v.showSpinner", true);
        $A.enqueueAction(action);
    },

    fireShowComponentEvent: function (cmp, event, helper, visible, errorMessage) {
        let shoHideEvent = $A.get("e.c:SAE_HideComponentsForExclusions");
        shoHideEvent.setParams({
            "hide_component": visible,
            "originPage": cmp.get('v.AutodocPageFeature'), // UHG Access Uniquness fix
            "errorMessage": errorMessage // US3475823
        });
        shoHideEvent.fire();
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

    handleCheckBoxesOnload: function (cmp, event, helper, highlightedIndex) {
        var policyList = cmp.get('v.dataORG');
        var activeFound = false;
        var medicalFound = false;
        var nonmedicalFound = false;
       	var activeFoundIndex;
        var nonmedicalFoundIndex;

        for (var k in policyList) {
            if (policyList[k].planStatus == "true") {
                activeFound = true;
                activeFoundIndex = k;
            }
            if (policyList[k].Plan.startsWith("Medical")) {
                medicalFound = true;
            }
            if (policyList[k].Plan.startsWith("Non Medical")) {
                nonmedicalFound = true;
                nonmedicalFoundIndex = k;
            }
        }
        if (policyList.length == 0) {
            helper.fireToastMessage("error!", 'No policies found.', "error", "dismissible", "10000");
            var appEvent = $A.get("e.c:SAE_DisableTopicWhenNoPolicies");
            appEvent.setParams({
                "isDisableTopic": false
            });
            appEvent.fire();
        }
        if (!activeFound) {
            helper.fireToastMessage("Warning!", 'No active policies available.', "warning", "dismissible", "10000");

        }
        if (!medicalFound) {
            helper.fireToastMessage("Warning!", 'No medical policies available.', "warning", "dismissible", "10000");

        }

        if(activeFound && activeFoundIndex!= highlightedIndex ){
            activeFound = false;
        }
        if(nonmedicalFound && nonmedicalFoundIndex == highlightedIndex ){
            medicalFound = false;
        }

        cmp.set("v.filterIsActive", activeFound);
        if (medicalFound) {
            cmp.set("v.filterIsMedicalOnly", medicalFound);
        } else if (nonmedicalFound) {
            cmp.set("v.filterIsMedicalOnly", false);
        }
    },

    executeFilter: function (cmp, event, helper) {
        var filterIsActive = cmp.get('v.filterIsActive');
        var filterIsMedicalOnly = cmp.get('v.filterIsMedicalOnly');
        var policyList = cmp.get('v.dataORG');
        var newData = [];

        if (filterIsActive && !filterIsMedicalOnly) {
            for (var k in policyList) {
                if (policyList.hasOwnProperty(k)) {
                    var planStatus = policyList[k].planStatus;
                    var IsMedicalClaim = policyList[k].IsMedicalPolicy;
                    var IsActivePolicy = (planStatus != "false");
                    if (IsActivePolicy) {
                        newData.push(policyList[k]);
                    }
                }
            }
        } else if (!filterIsActive && filterIsMedicalOnly) {
            for (var k in policyList) {
                if (policyList.hasOwnProperty(k)) {
                    var planStatus = policyList[k].planStatus;
                    var IsMedicalClaim = policyList[k].IsMedicalPolicy;
                    var IsActivePolicy = (planStatus == "true");
                    if (IsMedicalClaim) {
                        newData.push(policyList[k]);
                    }
                }
            }
        } else if (filterIsActive && filterIsMedicalOnly) {
            for (var k in policyList) {
                if (policyList.hasOwnProperty(k)) {
                    var planStatus = policyList[k].planStatus;
                    var IsMedicalClaim = policyList[k].IsMedicalPolicy;
                    var IsActivePolicy = (planStatus != "false");
                    if (IsMedicalClaim && IsActivePolicy) {
                        newData.push(policyList[k]);
                    }
                }
            }
        } else if (!filterIsActive && !filterIsMedicalOnly) {
            for (var k in policyList) {
                newData.push(policyList[k]);
            }
        }

        var highlightedRecordAvailable = false;
        for (var i in newData) {
            if (newData[i].SelectedItem == true) {
                highlightedRecordAvailable = true;
                this.fireNetworkStatusEvent(cmp, i); //US1901028 - Sarma - Member CDHP Integration
            }
        }
        if (!highlightedRecordAvailable && newData.length > 0) {
            //US2166406 - Sanka
            this.fireNetworkStatusEvent(cmp, 0);
            for (var i in policyList) {
                policyList[i].SelectedItem = false;
            }
            newData[0].SelectedItem = true;
            var srnEvent = $A.get("e.c:SAE_AuthSRNCreateEvent"); //DE294039  Added by Avish
            // US2536127 - Avish
            var planStatus;
            if (policyList[k].planStatus == "false") {
                planStatus = true;
            } else {
                planStatus = false;
            }
            srnEvent.setParams({
                "termedFlag": policyList[k].termedFlag,
                "policyStatus": planStatus,
                "memberTabId": cmp.get("v.memberTabId"),
                "policyNumber": policyList[k].GroupNumber
            });
            srnEvent.fire();
        }
    },

    fireNetworkStatusEvent: function (cmp, indexNo) {
        var tableData = cmp.get("v.dataORG");
        var providerStatusMap = cmp.get("v.providerStatusMap");
        var selectedpolicy = tableData[indexNo].financials;
        var providerStatus = tableData[indexNo].providerStatus;
        var eligibleDates = tableData[indexNo].eligibleDates;
        var policyStatus = tableData[indexNo].planStatus;
        cmp.set("v.policyStatus", policyStatus);
        if (providerStatusMap.hasOwnProperty(indexNo)) {
            providerStatus = 'Tier 1';
            tableData[indexNo].providerStatusIcon = "action:approval";
            tableData[indexNo].providerStatusIconVariant = "";
            tableData[indexNo].providerStatus = "Tier 1";
            cmp.set("v.dataORG", tableData);
        }
        var networkEvent = cmp.getEvent("networkStatus");
        networkEvent.setParams({
            "selectedPolicy": selectedpolicy,
            "networkStatus": providerStatus,
            "eligibleDates": eligibleDates
        });
        networkEvent.fire();
    },

    getMemberPolicyNetworkDetails: function (cmp, transactionId, indexNo, helper) {
        var action = cmp.get("c.getMemberPolicyNetworkInfo");
        action.setParams({
            transactionId: transactionId,
            transID: '' //US3076045 - Avish
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                //US1888880
                var responseData = response.getReturnValue();
                var tableData = cmp.get("v.dataORG");
                if (responseData.statusCode == 200) {
                    if (responseData.networkStatus == "In-Network") {
                        tableData[indexNo].providerStatusIcon = "action:approval";
                        tableData[indexNo].providerStatusIconVariant = "";
                        tableData[indexNo].providerStatus = "INN";
                    } else if (responseData.networkStatus == "Tier 1") {
                        tableData[indexNo].providerStatusIcon = "action:approval";
                        tableData[indexNo].providerStatusIconVariant = "";
                        tableData[indexNo].providerStatus = "Tier 1";
                    } else if (responseData.networkStatus == "Out-of-Network") {
                        tableData[indexNo].providerStatusIcon = "utility:warning";
                        tableData[indexNo].providerStatusIconVariant = "warning";
                        tableData[indexNo].providerStatus = "OON";
                    }
                } else if (responseData.statusCode == 400) {
                    tableData[indexNo].providerStatusIcon = "utility:stop";
                    tableData[indexNo].providerStatusIconVariant = "error";
                    tableData[indexNo].providerStatus = null;
                } else {
                    tableData[indexNo].providerStatusIcon = "utility:stop";
                    tableData[indexNo].providerStatusIconVariant = "error";
                    tableData[indexNo].providerStatus = null;
                    // US3299151 - Thanish - 16th Mar 2021
                    if(this.showPolicyErrorMessage){
                        this.fireToastMessage("We hit a snag.", this.policyErrorMessage, "error", "dismissible", "30000");
                        this.showPolicyErrorMessage=false;
                    }
                }
                cmp.set("v.dataORG", tableData);
                helper.fireNetworkStatusEvent(cmp, indexNo);
            } else if (state === "ERROR") {
                //US1888880
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " +
                            errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
    },

    getMemberPolicyDetails: function (cmp, transactionId, indexNo, helper) {
        // US2579637
        helper.fireNetworkStatusEvent(cmp, indexNo);
        helper.getExtendedData(cmp, transactionId, indexNo, helper);
    },

    //US2644766 - PCP Indicator UI and  Implementation - Durga [08/06/2020]
    getPCPRedirectURL: function (cmp, event, helper, index) {
        var PCPRedirectURLAction = cmp.get("c.getPCPURL");
        PCPRedirectURLAction.setCallback(this, function (response) {
            let state = response.getState();
            if (state === "SUCCESS") {
                window.open(response.getReturnValue(), '_blank');

                var tableDetails = cmp.get("v.tableDetails");
                tableDetails.tableBody[index].rowColumnData[9].isLink = false; //DE383845 - 11.9.2020 - updated index
                tableDetails.tableBody[index].rowColumnData[9].isOutputText = true; //DE383845 - 11.9.2020
                tableDetails.tableBody[index].rowColumnData[9].fieldValue = "Validated"; //DE383845 - 11.9.2020
                tableDetails.tableBody[index].rowColumnData[9].titleName = "Validated";
                tableDetails.ignoreClearAutodoc = true; // DE456923 - Thanish - 30th Jun 2021
                cmp.set("v.tableDetails", tableDetails);
            } else {}
        });
        $A.enqueueAction(PCPRedirectURLAction);
    },

    // TECH - US2692129
    handleHighlightHelper: function (cmp, event, helper) {
        cmp.set("v.showCOBHistory", false);
        cmp.set("v.isShowCobHistory", false);
        cmp.set("v.showPCPHistory", false);
        var selectedPolicyAttributes = cmp.get("v.selectedPolicyAttributes");

        // future : call getPolicyDetails apex controller method to do the job
        var selectedPlan = selectedPolicyAttributes.selectedPlan;
        var selectedGroup = selectedPolicyAttributes.selectedGroup;
        var selectedsourcecode = selectedPolicyAttributes.selectedsourcecode;
        var selectedmemId = selectedPolicyAttributes.selectedmemId;
        var selectedTranId = selectedPolicyAttributes.selectedTranId;
        var endDate = selectedPolicyAttributes.endDate;
        var strGraceMessageByState = selectedPolicyAttributes.strGraceMessageByState;
        var strGracePaidThrough = selectedPolicyAttributes.strGracePaidThrough;
        var strGracePeriodMonth = selectedPolicyAttributes.strGracePeriodMonth;
        var selectedPolicyList = cmp.get("v.selectedPolicyLst");

        // Setting Case wrapper group id
        var caseWrapper = cmp.get('v.caseWrapper');
        caseWrapper.SubjectGroupId = selectedGroup;
        cmp.set('v.caseWrapper', caseWrapper);

        var trid = new Set();
        for (var i in selectedPolicyList) {
            trid.add(selectedPolicyList[i].selectedTranId);
        }

        // US2554307
        cmp.set("v.memberIdAuthDtl", selectedmemId);
        cmp.set("v.groupIdAuthDtl", selectedGroup);

        // US2423120, US2517602, US2517604 Added by Praveen start
        if (trid.has(selectedTranId)) {
            console.log('selectedGroup set has' + selectedGroup);
        } else {
            let selectedPolicy = {};
            selectedPolicy.selectedGroup = selectedGroup;
            selectedPolicy.selectedSourceCode = selectedsourcecode;
            selectedPolicy.selectedPlan = selectedPlan;
            selectedPolicy.selectedTranId = selectedTranId;
            selectedPolicy.endDate = endDate;
            selectedPolicy.memberId = selectedmemId;
            selectedPolicy.strGraceMessageByState = strGraceMessageByState;
            selectedPolicy.strGracePaidThrough = strGracePaidThrough;
            selectedPolicy.strGracePeriodMonth = strGracePeriodMonth;
            selectedPolicyList.push(selectedPolicy);
        }
        cmp.set("v.selectedPolicyLst", selectedPolicyList);
        //US2423120, US2517602, US2517604 Praveen End

        // US2137922: Added by Ravindra
        var selectedRowIndex = selectedPolicyAttributes.selectedRowIndex;
        // cmp.set("v.policySelectedIndex", selectedRowIndex);

        var tableDataList = cmp.get("v.dataORG");
        for (var k in tableDataList) {
            if (k == selectedRowIndex) {
                tableDataList[k].SelectedItem = true;
            } else {
                tableDataList[k].SelectedItem = false;
            }
        }
        cmp.set("v.dataORG", tableDataList);

        // US1761826 - UHC/Optum Exclusion UI - START
        let lstExclusions = cmp.get("v.lstExlusions");
        let mapExclusions = new Map();

        for (let i = 0; lstExclusions.length > i; i++) {
            mapExclusions.set(lstExclusions[i].MasterLabel, lstExclusions[i].MasterLabel);
        }
        let hasAccess = cmp.get("v.uhgAccess");

        // New Change
        var providerDetails = cmp.get("v.providerDetails");
        if (tableDataList[selectedRowIndex].SelectedItem && !$A.util.isEmpty(tableDataList[selectedRowIndex].GroupNumber) && tableDataList[selectedRowIndex].GroupNumber != 'Unable to determine') {
            if (mapExclusions.has(tableDataList[selectedRowIndex].GroupNumber) && !hasAccess) {
                if (!$A.util.isEmpty(providerDetails) && !$A.util.isEmpty(providerDetails.isNoProviderToSearch) && !providerDetails.isNoProviderToSearch) {
                    helper.getMemberPolicyNetworkDetails(cmp, tableDataList[selectedRowIndex].transactionId, selectedRowIndex, helper);
                }
                helper.getMemberPolicyDetails(cmp, tableDataList[selectedRowIndex].transactionId, selectedRowIndex, helper);
            } else {
                if (!$A.util.isEmpty(providerDetails) && !$A.util.isEmpty(providerDetails.isNoProviderToSearch) && !providerDetails.isNoProviderToSearch) {
                    helper.getMemberPolicyNetworkDetails(cmp, tableDataList[selectedRowIndex].transactionId, selectedRowIndex, helper);
                }
                helper.getMemberPolicyDetails(cmp, tableDataList[selectedRowIndex].transactionId, selectedRowIndex, helper);
            }
        } else if (tableDataList[selectedRowIndex].providerStatus == "") {
            if (!$A.util.isEmpty(providerDetails) && !$A.util.isEmpty(providerDetails.isNoProviderToSearch) && !providerDetails.isNoProviderToSearch) {
                helper.getMemberPolicyNetworkDetails(cmp, tableDataList[selectedRowIndex].transactionId, selectedRowIndex, helper);
            }
            helper.fireShowComponentEvent(cmp, event, helper, true, '');
            helper.getMemberPolicyDetails(cmp, tableDataList[selectedRowIndex].transactionId, selectedRowIndex, helper);
        } else {
            helper.getMemberPolicyDetails(cmp, tableDataList[selectedRowIndex].transactionId, selectedRowIndex, helper);
            helper.fireNetworkStatusEvent(cmp, selectedRowIndex);
        }
        // End

        // Optimization
        var selectedPolicyContactAddress = selectedPolicyAttributes.selectedPolicyContactAddress;
        var city = selectedPolicyAttributes.city;
        var state = selectedPolicyAttributes.state;
        var zip = selectedPolicyAttributes.zip;
        cmp.set('v.contactAddress', selectedPolicyContactAddress);
        cmp.set('v.city', city);
        cmp.set('v.state', state);
        cmp.set('v.zip', zip);
        helper.getPolicyDataIntoAlert(cmp, event, helper, selectedGroup);

        cmp.set('v.initialClick', false);
        // US2061732 - Added by Avish
        for (var k in tableDataList) {
            var srnEvent = $A.get("e.c:SAE_AuthSRNCreateEvent");
            if (tableDataList[k].SelectedItem) {
                // US2536127 - Avish
                var planStatus;
                if (tableDataList[k].planStatus == 'false') {
                    planStatus = true;
                } else {
                    planStatus = false;
                }
                srnEvent.setParams({
                    "termedFlag": tableDataList[k].termedFlag,
                    "policyStatus": planStatus,
                    "memberTabId": cmp.get("v.memberTabId"),
                    "policyNumber": tableDataList[k].GroupNumber
                });
                srnEvent.fire();
                break;
            }
        }
    },

    // TECH - US2692129 - Edited Signature
    getPolicyDataIntoAlert: function (cmp, event, helper, selectedGroup) {
        var providerTabId = cmp.get("v.providerTabId");
        var memberTabId = cmp.get("v.memberTabId");
        var clickEvent = cmp.getEvent("SAE_PolicyClickforAlerts");
        clickEvent.setParams({
            "data_group": selectedGroup,
            "providerTabId": providerTabId,
            "memberTabId": memberTabId
        });
        clickEvent.fire();
    },

    // US2973232
    getTierStatus: function (cmp, transactionId, event, helper, policyRes) {
        console.log('=@#Tier1Map1' + JSON.stringify(cmp.get("v.tierMap")));
        cmp.set("v.isTierOne", false);
        var tierMap = cmp.get("v.tierMap");
        if (tierMap.hasOwnProperty(transactionId)) {
            var existTResult = tierMap[transactionId];
            cmp.set("v.isTierOne", existTResult.isTierOne);
            if (policyRes.sourceCode == 'CS') {
                cmp.set("v.selectedIPAValue", existTResult.csBenefitSourceValue);
            }
            //cmp.set("v.isTierOne",tierMap[transactionId]);
        } else {
            var tierResult = {
                "csBenefitSourceValue": "",
                "isTierOne": false
            };

            let action = cmp.get("c.getTierStatus");
            action.setParams({
                transactionId: transactionId,
                sourceCode: policyRes.sourceCode
            });
            action.setCallback(this, function (response) {
                let state = response.getState();
                if (state === "SUCCESS") {
                    var result = response.getReturnValue();
                    tierResult = result;
                    console.log('=@#Tier1Resp' + JSON.stringify(result));
                    cmp.set("v.isTierOne", result.isTierOne);
                    if (policyRes.sourceCode == 'CS') {
                        if (result.isTierOne) {
                            var ipaValue = result.csBenefitSourceValue;
                            cmp.set("v.selectedIPAValue", ipaValue);
                            if (cmp.get("v.callCSContractsAPI") && !$A.util.isEmpty(ipaValue)) {
                                helper.getContractServices(cmp, transactionId, event, helper, policyRes, ipaValue);
                            }
                        }
                    }
                    // US3299151 - Thanish - 16th Mar 2021
                    if(result.statusCode == "500" && this.showPolicyErrorMessage){
                        this.fireToastMessage("We hit a snag.", this.policyErrorMessage, "error", "dismissible", "30000");
                        this.showPolicyErrorMessage=false;
                    }
                } else {
                    cmp.set("v.isTierOne", false);
                    // US3299151 - Thanish - 16th Mar 2021
                    if(showPolicyErrorMessage){
                        this.fireToastMessage("We hit a snag.", this.policyErrorMessage, "error", "dismissible", "30000");
                        this.showPolicyErrorMessage=false;
                    }
                }

                //tierMap[transactionId] = cmp.get("v.isTierOne");
                tierMap[transactionId] = tierResult;
                cmp.set("v.tierMap", tierMap);
                cmp.set("v.firstCallout", true);
            });
            $A.enqueueAction(action);
        }
    },

    getContractServices: function (cmp, transactionId, event, helper, policyRes, ipaValue) {
        var tableData = cmp.get("v.dataORG");
        var policySelectedIndex = cmp.get("v.policySelectedIndex");
        var providerStatus = tableData[policySelectedIndex].providerStatus;
        if ($A.util.isUndefinedOrNull(providerStatus) || $A.util.isEmpty(providerStatus) || (!$A.util.isUndefinedOrNull(providerStatus) && providerStatus != 'INN')) {
            return;
        }
        var providerDetails = cmp.get("v.providerDetails");
        var memberCardData = cmp.get("v.memberCardData");
        var insuranceTypeCode = '';
        if (!$A.util.isEmpty(memberCardData)) {
            if (!$A.util.isUndefinedOrNull(memberCardData.CoverageLines[policySelectedIndex])) {
                if (!$A.util.isUndefinedOrNull(memberCardData.CoverageLines[policySelectedIndex].insuranceTypeCode)) {
                    insuranceTypeCode = memberCardData.CoverageLines[policySelectedIndex].insuranceTypeCode;
                }
            }
        }

        let getContractServices = cmp.get("c.getProviderCardStatus");
        getContractServices.setParams({
            "providerId": (!$A.util.isUndefinedOrNull(providerDetails.providerId) ? providerDetails.providerId : ''),
            "taxId": (!$A.util.isUndefinedOrNull(providerDetails.taxId) ? providerDetails.taxId : ''),
            "addressSeq": (!$A.util.isUndefinedOrNull(providerDetails.addressSequenceId) ? providerDetails.addressSequenceId : ''),
            "marketType": (!$A.util.isUndefinedOrNull(policyRes.marketType) ? policyRes.marketType : ''),
            "marketSite": (!$A.util.isUndefinedOrNull(policyRes.marketSite) ? policyRes.marketSite : ''),
            "insTypeCode": insuranceTypeCode,
            "ipaValue": ipaValue
        });

        getContractServices.setCallback(this, function (response) {
            let state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                console.log('IPA Reslut' + JSON.stringify(result));
                if(result.isFound){// US3299151 - Thanish - 16th Mar 2021
                    var providerStatusMap = cmp.get("v.providerStatusMap");
                    providerStatusMap[policySelectedIndex] = 'Tier 1';
                    var tableData = cmp.get("v.dataORG");
                    tableData[policySelectedIndex].providerStatusIcon = "action:approval";
                    tableData[policySelectedIndex].providerStatusIconVariant = "";
                    tableData[policySelectedIndex].providerStatus = "Tier 1";
                    cmp.set("v.dataORG", tableData);
                    helper.fireNetworkStatusEvent(cmp, policySelectedIndex);
                }
                // US3299151 - Thanish - 16th Mar 2021
                if(result.statusCode==500 && this.showPolicyErrorMessage){
                    this.fireToastMessage("We hit a snag.", this.policyErrorMessage, "error", "dismissible", "30000");
                    this.showPolicyErrorMessage=false;
                }
            }
        });
        $A.enqueueAction(getContractServices);
    },

    ttsHelper: function (cmp, event, helper) {
        // DE409857 - Thanish - 8th Mar 2021
        var cWrapper = cmp.get("v.caseWrapper");
        cWrapper.caseItems = cmp.get("v.caseItemList");
        cmp.set("v.caseWrapper", cWrapper);

        var selectedString = _autodoc.getAutodoc(cmp.get("v.autodocUniqueId"));
        var jsString = JSON.stringify(selectedString);
        var caseWrapper = cmp.get("v.caseWrapper");
        caseWrapper.savedAutodoc = jsString;

        //US3059727 - Sravan  - Start

        var caseItems = caseWrapper.caseItems;
        var caseItemMap = {};
        if (!$A.util.isUndefinedOrNull(selectedString) && !$A.util.isEmpty(selectedString)) {
            for (var selectedKey in selectedString) {
                if (selectedString[selectedKey].componentName == 'Policies') {
                    if (!$A.util.isUndefinedOrNull(selectedString[selectedKey]) && !$A.util.isEmpty(selectedString[selectedKey])) {
                        var selectedRow = selectedString[selectedKey].selectedRows;
                        var uniqueKey = '';
                        var count = 0;
                        //US3683231 - Sravan - Start
                        var memberId = '';
                        var memberKey = parseInt(selectedKey) + 1;
                        console.log('Selected String'+ memberKey+ ' '+ JSON.stringify(selectedString[memberKey]));
                        if(!$A.util.isUndefinedOrNull(selectedString[memberKey]) && !$A.util.isEmpty(selectedString[memberKey])){
                            if(selectedString[memberKey].componentName == 'Member Details'){
                                if(!$A.util.isUndefinedOrNull(selectedString[memberKey].cardData) && !$A.util.isEmpty(selectedString[memberKey].cardData)){
                                    var cardData = selectedString[memberKey].cardData;
                                    memberId = cardData[1].fieldValue;
                                }

                            }
                        }
                        //US3683231 - Sravan - End
                        for (var rowKey in selectedRow) {
                            console.log('Row Selected' + JSON.stringify(selectedRow[rowKey]));
                            //US3683231 - Sravan - Start
                            var sourceCode = selectedRow[rowKey].rowColumnData[1].fieldValue;
                            var finalSourceCode = '';
                            var fetchSourceCode = [];
                            if(!$A.util.isUndefinedOrNull(sourceCode) && !$A.util.isEmpty(sourceCode)){
                                if(sourceCode == '--'){
                                    finalSourceCode =  sourceCode;
                                }
                                else{
                                    fetchSourceCode = sourceCode.split('-');
                                    finalSourceCode = fetchSourceCode[0].trim();
                                }

                            }
                            //US3683231 - Sravan - End
                            uniqueKey = selectedRow[rowKey].rowColumnData[0].fieldValue+'/'+finalSourceCode+'/'+memberId;
                            if (!$A.util.isUndefinedOrNull(uniqueKey) && !$A.util.isEmpty(uniqueKey)) {
                                if (caseItemMap.hasOwnProperty(uniqueKey)) {
                                    if (selectedRow[rowKey].resolved) {
                                        if (caseItemMap[uniqueKey]) {
                                            caseItemMap[uniqueKey] = selectedRow[rowKey].resolved;
                                        } else {
                                            caseItemMap[uniqueKey] = false;
                                        }
                                    } else {
                                        caseItemMap[uniqueKey] = selectedRow[rowKey].resolved;
                                    }
                                } else {
                                    caseItemMap[uniqueKey] = selectedRow[rowKey].resolved;
                                }
                            }
                        }
                    }
                }
            }
        }
        //Reframing the case items
        var finalCaseItems = [];
        // caseWrapper.caseItems = []; DE409857 - Thanish - 8th Mar 2021
        if (!$A.util.isUndefinedOrNull(caseItems) && !$A.util.isEmpty(caseItems)) {
            if (!$A.util.isUndefinedOrNull(caseItemMap) && !$A.util.isEmpty(caseItemMap)) {
                for (var caseItemKey in caseItems) {
                    if (caseItemMap.hasOwnProperty(caseItems[caseItemKey].uniqueKey)) {
                        caseItems[caseItemKey].isResolved = caseItemMap[caseItems[caseItemKey].uniqueKey];
                        finalCaseItems.push(caseItems[caseItemKey]);
                    }
                }
            }
            //Creating case items for policies which have been autodoced
            if (!$A.util.isUndefinedOrNull(finalCaseItems) && !$A.util.isEmpty(finalCaseItems)) {
                caseWrapper.caseItems = finalCaseItems;
            }
        }

        console.log('Case Wrapper Case Items' + JSON.stringify(caseWrapper.caseItems));
        //US3059727 - Sravan  - End

        cmp.set("v.caseWrapper", caseWrapper);
    },

    // Save Case Consolidation - US3424763
    checkResolved: function (cmp, event, helper) {
        var selectedString = _autodoc.getAutodoc(cmp.get("v.autodocUniqueId"));
        var policyTables = selectedString.filter(tbl => tbl.type == 'table' && tbl.componentName == 'Policies');
        if (!$A.util.isEmpty(policyTables) && policyTables.length > 0) {
            let unresolved = [];
            for (var table of policyTables) {
                let tableBody = table.tableBody;
                for (var row of tableBody) {
                    if (!$A.util.isEmpty(row) && row.checked && !row.resolved) {
                        unresolved.push(row);
                    }
                }
            }

            //let unresolved = [];
            //unresolved = policyTables.filter(tbl => (tbl.tableBody.filter(row => row.checked && !row.resolved)).length > 0);
            console.log(unresolved);
            if (unresolved.length > 0) {
                cmp.set("v.disableButtons", false);
            } else {
                cmp.set("v.disableButtons", true);
                cmp.set("v.showComments", false);
                cmp.set("v.commentsValue", "");
            }
        } else {
            cmp.set("v.disableButtons", true);
            cmp.set("v.showComments", false);
            cmp.set("v.commentsValue", "");
        }
        //helper.ttsHelper(cmp, event, helper);Commented as part of US3683231 - Sravan
    },
    //US3683231 - Sravan - Start
    addCaseItems : function(component,transactionId,currentSourceCode, event, helper){
        var policyList = component.get("v.policyList");
        var policyDetails = component.get("v.policyDetails");
        console.log('Policy List With Source Code'+ JSON.stringify(policyList));
        console.log('Policy Details With Source Code'+ JSON.stringify(policyDetails));
        var caseItemList = component.get("v.caseItemList");
        var index = -1;
        if(!$A.util.isUndefinedOrNull(policyList) && !$A.util.isEmpty(policyList)){
            for(var key in policyList){
                if(policyList[key].highlightedPolicy){
                    if(!policyList[key].nonMedicalPolicyBoolean){
                        if(policyList[key].transactionId == transactionId){
                            var groupNumber = policyList[key].GroupNumber;
                            var sourceCode =  currentSourceCode;
                            var memberId = policyList[key].patientInfo.MemberId;
                            if (!$A.util.isEmpty(caseItemList) && !$A.util.isUndefinedOrNull(caseItemList)) {
                                index = caseItemList.findIndex(function (obj) {
                                    return obj.uniqueKey == groupNumber+'/'+sourceCode+'/'+memberId;
                                });
                            } else {
                                caseItemList = [];
                            }
                            if (index == -1) {
                                var caseItem = new Object();
                                caseItem.uniqueKey = groupNumber+'/'+sourceCode+'/'+memberId;
                                caseItem.isResolved = true;
                                caseItem.topic = 'View Member Eligibility'; //US3071655 - Sravan
                                caseItemList.push(caseItem);
                                component.set("v.caseItemList", caseItemList);
                                helper.ttsHelper(component, event, helper);
                            }

                        }

                    }
                }
            }
        }
    }
    //US3683231 - Sravan - End
})