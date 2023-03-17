({
    onInit: function (cmp, event, helper) {
        var tableDetails = new Object();
        tableDetails.type = "table";
        tableDetails.autodocHeaderName = "Policies";
        tableDetails.componentOrder = 1;
        tableDetails.componentName = "Policies";
        //US3059727 - Sravan
        tableDetails.tableHeaders = [
            "GROUP #", "SOURCE",
            "PLAN", "TYPE", "PRODUCT",
            "COVERAGE LEVEL", "ELIGIBILITY DATES",
            "STATUS", "REF REQ",
            "PCP REQ", "RESOLVED"
        ];
        tableDetails.tableBody = [];
        // Save Case Consolidation - US3424763
        tableDetails.hasUnresolved = false;
        tableDetails.ignoreClearAutodoc = true; // DE456923 - Thanish - 30th Jun 2021
        cmp.set("v.tableDetails", tableDetails);
    },

    onPolicyListChange: function (cmp, event, helper) {
        var tableCopy = {};
        tableCopy.type = "table";
        tableCopy.autodocHeaderName = "Policies";
        tableCopy.componentName = "Policies";
        //US3059727 - Sravan
        tableCopy.tableHeaders = ["GROUP #", "SOURCE", "PLAN", "TYPE", "PRODUCT", "COVERAGE LEVEL", "ELIGIBILITY DATES", "STATUS", "REF REQ", "PCP REQ", "RESOLVED"]; // // US2928520: Policies Card - updated with "TYPE"
        tableCopy.tableBody = [];
        tableCopy.selectedRows = [];
        // Save Case Consolidation - US3424763
        tableCopy.callTopic = 'View Member Eligibility';

        var autodocTables = cmp.get("v.autodocTables");
        cmp.set("v.firstCallout", true);
        cmp.set("v.isTierOne", false);
        var tableDetails = cmp.get("v.tableDetails");
        var policyList = cmp.get("v.policyList");
        var selectedRows = cmp.get("v.selectedRows");
        var policy;
        var i = 0;
        var highlightedIndex = 0;
        var transactionId = "";
        if (policyList.length > 0) {
            for (policy of policyList) {
                var row = {
                    "checked": false,
                    "resolved": false,
                    "disabled": true,
                    "hide": false,
                    "isActive": (policy.planStatus == "true") ? true : false,
                    "isMedicalPolicy": !policy.nonMedicalPolicyBoolean,
                    "uniqueKey": i, // DE371920 - Thanish - 7th Oct 2020
                    "transactionId": policy.transactionId,
                    "highlightedPolicy": policy.highlightedPolicy,
                    "sourceCodeDetail": "",
                    "relationshipCode": "",
                    "caseItemsExtId": policy.GroupNumber,
                    "rowColumnData": [{
                            "isOutputText": true,
                            "fieldLabel": "Group #",
                            "fieldValue": policy.GroupNumber,
                            "titleName": policy.GroupNumber,
                            "key": i,
                            "isReportable": true
                        },
                        {
                            "isOutputText": true,
                            "fieldLabel": "SOURCE",
                            "fieldValue": "--",
                            "titleName": "--",
                            "key": i,
                            "isReportable": true
                        },
                        {
                            "isOutputText": true,
                            "fieldLabel": "PLAN",
                            "fieldValue": policy.CoverageType,
                            "titleName": policy.CoverageType,
                            "key": i,
                            "isReportable": true
                        },
                        // US2928520: Policies Card
                        {
                            "isOutputText": true,
                            "fieldLabel": "TYPE",
                            "fieldValue": "--",
                            "titleName": "--",
                            "key": i,
                            "isReportable": true
                        },
                        {
                            "isOutputText": true,
                            "fieldLabel": "PRODUCT",
                            "fieldValue": policy.PolicyName,
                            "titleName": policy.PolicyName,
                            "key": i,
                            "isReportable": true
                        },
                        {
                            "isOutputText": true,
                            "fieldLabel": "COVERAGE LEVEL",
                            "fieldValue": "--",
                            "titleName": "--",
                            "key": i,
                            "isReportable": true
                        },
                        {
                            "isOutputText": true,
                            "fieldLabel": "ELIGIBLE DATES",
                            "fieldValue": policy.eligibleDates,
                            "titleName": policy.eligibleDates,
                            "key": i,
                            "isReportable": true
                        },
                        {
                            "isIcon": true,
                            "fieldLabel": "STATUS",
                            "iconName": (policy.planStatus == 'true') ? 'action:approval' : (policy.planStatus == 'false') ? 'action:close' : 'standard:macros',
                            "fieldValue": (policy.planStatus == 'true') ? 'Active' : (policy.planStatus == 'false') ? 'Termed' : 'Future', //Changed as part of US2670820 - Sravan
                            "titleName": (policy.planStatus == 'true') ? 'Active' : (policy.planStatus == 'false') ? 'Termed' : 'Future',
                            "key": i,
                            "isReportable": true,
                            "showTextInAutoDoc": true //Added as part of US2670820 - Sravan
                        },
                        {
                            "isOutputText": true,
                            "fieldLabel": "REF REQ",
                            "fieldValue": policy.referral,
                            "titleName": policy.referral,
                            "key": i,
                            "isReportable": true
                        },
                        { // DE388481 - Thanish, Durga - 25th Nov 2020
                            "isLink": policy.referral != 'Yes' ? true : false,
                            "isOutputText": policy.referral != 'Yes' ? false : true,
                            "fieldLabel": "PCP REQ",
                            "fieldValue": policy.referral != 'Yes' ? "Validate" : policy.referral,
                            "titleName": policy.referral != 'Yes' ? "Validate" : policy.referral,
                            "key": i,
                            "isReportable": true
                        },
                        //US3059727 - Sravan
                        {
                            "isOutputText": false,
                            "isCheckBox": true,
                            "fieldLabel": "RESOLVED",
                            "fieldValue": "false",
                            "titleName": " ",
                            "key": i,
                            "isReportable": true
                        }
                    ]
                }
                if (!$A.util.isEmpty(policy.highlightedPolicy) && policy.highlightedPolicy) {
                    cmp.set("v.selectedPolicyKey", i); // DE371920 - Thanish - 7th Oct 2020
                    row.checked = true;
                    //US3059727 - Sravan  - Start
                    row.resolved = true;
                    //US3059727 - Sravan  - End
                    highlightedIndex = i;
                    transactionId = policy.transactionId;
                    selectedRows.push(row);
                    // DE383848 - Thanish - 10th Nov 2020
                    if (row.isMedicalPolicy) {
                        // create case item for selected policy
                        // DE409857 - Thanish - 8th Mar 2021
                        // var caseWrapper = cmp.get("v.caseWrapper");
                        /*var caseItem = new Object();
                        caseItem.uniqueKey = policy.GroupNumber;
                        caseItem.isResolved = true;
                        caseItem.topic = 'View Member Eligibility'; //US3071655 - Sravan
                        var caseItemList = [];
                        caseItemList.push(caseItem);
                        cmp.set("v.caseItemList", caseItemList);Commented and functionality is moved to addCaseItems function - US3683231 - Sravan*/
                        // caseWrapper.caseItems = caseItemList;
                        // cmp.set("v.caseWrapper", caseWrapper);
                    }
                    tableCopy.tableBody.push(row);
                    tableCopy.selectedRows.push(row);
                    tableCopy.componentOrder = 1;
                    tableCopy.ignoreClearAutodoc = true; // DE456923 - Thanish - 30th Jun 2021
                    autodocTables[i] = tableCopy
                }
                tableDetails.tableBody.push(row);
                i++;
            }
            tableDetails.selectedRows = selectedRows;
            tableDetails.ignoreClearAutodoc = true; // DE456923 - Thanish - 30th Jun 2021
            cmp.set("v.tableDetails", tableDetails);
            cmp.set("v.selectedRows", selectedRows);
            _autodoc.setAutodoc(cmp.get("v.autodocUniqueId"), highlightedIndex, tableCopy);
            cmp.set("v.policySelectedIndex", highlightedIndex);

            //US1761826 - UHC/Optum Exclusion UI - START
            helper.fetchOptumExclusionGroupIds(cmp, event, helper);
            var fetchData = [];
            var memberMap = {}; //US2423120 - Sravan

            for (var k in policyList) {

                if (policyList.hasOwnProperty(k)) {
                    var srcCode = (!$A.util.isEmpty(policyList[k].SourceCode)) ? policyList[k].SourceCode : "--";
                    fetchData[k] = {
                        SelectedItem: policyList[k].highlightedPolicy,
                        //US:US1842940 : Start
                        Plan: policyList[k].CoverageType,
                        PlanSubString: policyList[k].CoverageType.substring(0, 20),
                        GroupNumber: policyList[k].GroupNumber,
                        Type: policyList[k].CoverageType,
                        //US1974546 - Sanka
                        CoverageType: "--",
                        //Policy: 'Federal employees health benefit plan Policy',
                        //PolicySubString: 'Federal employees health benefit plan Policy'.substring(0,20),
                        Policy: policyList[k].PolicyName,
                        PolicySubString: policyList[k].PolicyName.substring(0, 20),
                        //US:US1842940 : End
                        IsMedicalPolicy: !policyList[k].nonMedicalPolicyBoolean,
                        endDate: policyList[k].EndDate, //US2061732 - Added by Avish
                        termedFlag: policyList[k].termedFlag, //US2061732 - Added by Avish
                        eligibleDates: policyList[k].eligibleDates,
                        planStatus: policyList[k].planStatus,
                        planStatusIcon: policyList[k].planStatus == "true" ? "action:approval" : "action:close", // Change Icons according to the requirement
                        providerStatusIcon: "",
                        providerStatusIconVariant: "",
                        providerStatus: "",
                        Referral: policyList[k].referral,
                        prodStatus: policyList[k].planStatus,
                        transactionId: policyList[k].transactionId,
                        financials: policyList[k].financialWrapper,
                        sourceCode: srcCode,
                        sourceCodeDetail: "--",
                        relationshipCode: policyList[k].relationshipCode,
                        //Added by Vinay for Address display in Policy Detail Card
                        addressLine1: policyList[k].addressLine1,
                        city: policyList[k].city,
                        state: policyList[k].state,
                        zip: policyList[k].zip,
                        memberId: policyList[k].patientInfo.MemberId //US2423120 - Sravan
                    };

                    memberMap[policyList[k].patientInfo.MemberId] = policyList[k].patientInfo; //US2423120 - Sravan

                    //US2061732 - Added by Avish
                    if (policyList[k].highlightedPolicy) {
                        //US2423120, US2517602, US2517604 Praveen start
                        var selectedPolicyList = cmp.get("v.selectedPolicyLst");
                        let selectedPolicy = {};
                        selectedPolicy.selectedGroup = policyList[k].GroupNumber;
                        selectedPolicy.selectedSourceCode = (!$A.util.isEmpty(policyList[k].SourceCode)) ? policyList[k].SourceCode : "";
                        selectedPolicy.selectedPlan = policyList[k].CoverageType.substring(0, 20);
                        selectedPolicy.selectedTranId = policyList[k].transactionId;
                        selectedPolicy.endDate = policyList[k].EndDate;
                        selectedPolicy.selectedRelationshipCode = policyList[k].RelationshipCode;
                        selectedPolicy.memberId = policyList[k].patientInfo.MemberId;
                        //Jitendra
                        selectedPolicy.strGraceMessageByState = policyList[k].strGraceMessageByState;
                        selectedPolicy.strGracePaidThrough = policyList[k].strGracePaidThrough;
                        selectedPolicy.strGracePeriodMonth = policyList[k].strGracePeriodMonth;

                        selectedPolicyList.push(selectedPolicy);

                        cmp.set("v.selectedPolicyLst", selectedPolicyList);
                        //US2423120, US2517602, US2517604 Praveen end
                        //US2554307
                        cmp.set("v.memberIdAuthDtl", policyList[k].patientInfo.MemberId);
                        cmp.set("v.groupIdAuthDtl", policyList[k].GroupNumber);

                        var srnEvent = $A.get("e.c:SAE_AuthSRNCreateEvent");
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
                    //US2061732 - Ends
                }
            }
            //US2423120 - Sravan - Start
            cmp.set("v.memberMap", memberMap);
            //US2423120 - Sravan - End

            cmp.set("v.data", fetchData);
            cmp.set("v.dataORG", fetchData);
            helper.handleCheckBoxesOnload(cmp, event, helper,highlightedIndex);
            helper.executeFilter(cmp, event, helper);
            //US1761826 - UHC/Optum Exclusion UI - START
            let allowCallouts = cmp.get("v.allowCallouts");
            //US1933887 - UHG Access - Sanka D. - 31.07.2019
            let hasAccess = cmp.get("v.uhgAccess");
            let lstExclusions = cmp.get("v.lstExlusions");
            let mapExclusions = new Map();
            for (let i = 0; lstExclusions.length > i; i++) {
                mapExclusions.set(lstExclusions[i].MasterLabel, lstExclusions[i].MasterLabel);
            }
            //Ends
            var tableData = cmp.get("v.dataORG");
            var providerDetails = cmp.get("v.providerDetails");

            if (cmp.get("v.initialLoading") && tableData.length >= 1 && allowCallouts && hasAccess) {
                if (!$A.util.isEmpty(providerDetails) && !$A.util.isEmpty(providerDetails.isNoProviderToSearch) && !providerDetails.isNoProviderToSearch) {
                    helper.getMemberPolicyNetworkDetails(cmp, tableData[0].transactionId, 0, helper);
                }
                helper.getMemberPolicyDetails(cmp, tableData[0].transactionId, 0, helper);
                cmp.set("v.initialLoading", false);

            }
            // DE391034 - Thanish - 2nd Dec 2020
            else if (tableData.length > 0 && tableData[0].SelectedItem && !$A.util.isEmpty(tableData[0].GroupNumber) && tableData[0].GroupNumber != 'Unable to determine') {
                if (mapExclusions.has(tableData[0].GroupNumber) && !hasAccess) {
                    if (!$A.util.isEmpty(providerDetails) && !$A.util.isEmpty(providerDetails.isNoProviderToSearch) && !providerDetails.isNoProviderToSearch) {
                        helper.getMemberPolicyNetworkDetails(cmp, tableData[0].transactionId, 0, helper);
                    }
                    helper.getMemberPolicyDetails(cmp, tableData[0].transactionId, 0, helper);
                } else {
                    if (!$A.util.isEmpty(providerDetails) && !$A.util.isEmpty(providerDetails.isNoProviderToSearch) && !providerDetails.isNoProviderToSearch) {
                        helper.getMemberPolicyNetworkDetails(cmp, tableData[0].transactionId, 0, helper);
                    }
                    helper.getMemberPolicyDetails(cmp, tableData[0].transactionId, 0, helper);
                }

            } else {
                for (var k in tableData) {
                    if (tableData.hasOwnProperty(k) && tableData[k].SelectedItem) {
                        if (!$A.util.isEmpty(providerDetails) && !$A.util.isEmpty(providerDetails.isNoProviderToSearch) && !providerDetails.isNoProviderToSearch) {
                            helper.getMemberPolicyNetworkDetails(cmp, tableData[k].transactionId, k, helper);
                        }
                        helper.getMemberPolicyDetails(cmp, tableData[k].transactionId, k, helper);
                    }
                }
            }
            helper.filterTableBody(cmp, event);
            helper.getExtendedData(cmp, transactionId, highlightedIndex, helper);
    } else { // US3476452 When no policies found - Sarma - 28th Apr 2021
      var row = {
        "checked" : true,
        "disabled":true,
        "uniqueKey" : 0,
        "resolved": true,
        "rowColumnData" : [
          {
            isOutputText: true,
            fieldLabel: "Group #",
            fieldValue: "--",
            titleName: "--",
          },
          {
            isOutputText: true,
            fieldLabel: "SOURCE",
            fieldValue: "--",
            titleName: "--",
          },
          {
            isOutputText: true,
            fieldLabel: "PLAN",
            fieldValue: "--",
            titleName: "--",
          },
          {
            isOutputText: true,
            fieldLabel: "TYPE",
            fieldValue: "--",
            titleName: "--",
          },
          {
            isOutputText: true,
            fieldLabel: "PRODUCT",
            fieldValue: "--",
            titleName: "--",
          },
          {
            isOutputText: true,
            fieldLabel: "COVERAGE LEVEL",
            fieldValue: "--",
            titleName: "--",
          },
          {
            isOutputText: true,
            fieldLabel: "ELIGIBLE DATES",
            fieldValue: "--",
            titleName: "--",
          },
          {
            isOutputText: true,
            fieldLabel: "STATUS",
            fieldValue: "--",
            titleName: "--",
          },
          {
            isOutputText: true,
            fieldLabel: "REF REQ",
            fieldValue: "--",
            titleName: "--",

          },
          {
            isOutputText: true,
            fieldLabel: "PCP REQ",
            fieldValue: "--",
            titleName: "--",

          },
          {
            isOutputText: false,
            isCheckBox: true,
            fieldLabel: "RESOLVED",
            fieldValue: "false",
            titleName: " ",
          }
        ]
        }
      selectedRows.push(row);
      tableCopy.tableBody.push(row);
      tableCopy.selectedRows.push(row);
      tableCopy.componentOrder = 1;
      tableCopy.ignoreClearAutodoc = true; // DE456923 - Thanish - 30th Jun 2021

      //tableDetails.selectedRows = selectedRows;
      tableDetails.tableBody.push(row);
      tableDetails.ignoreClearAutodoc = true; // DE456923 - Thanish - 30th Jun 2021
      cmp.set("v.tableDetails", tableDetails);
      cmp.set("v.selectedRows", selectedRows);
      _autodoc.setAutodoc(
        cmp.get("v.autodocUniqueId"),
        highlightedIndex,
        tableCopy
      );
      cmp.set("v.selectedPolicyKey",0);
      cmp.set("v.isShowOnlyMedicalDisabled",true);
      cmp.set("v.isShowOnlyActiveDisabled",true);
      cmp.set("v.isSaveCaseDisabled", true);
      // US3504373	Unable to Determine  Policy - Save Case - Sarma - 05th May 2021
      cmp.set("v.isShowComponentBasedOnExclusions", false);
    }

        // Save Case Consolidation - US3424763
        helper.checkResolved(cmp, event, helper);

        // US3476452 End
    },

    fireAutodocEvent: function (cmp, event) {
        var rowIndex = event.currentTarget.parentElement.parentElement.getAttribute("data-index");
        var tableDetails = cmp.get("v.tableDetails");
        var tableBody = tableDetails.tableBody;
        var autodocEvent = cmp.getEvent("AutodocEvent");
        autodocEvent.setParams({
            "autodocCmpName": tableDetails.componentName,
            "cmpType": tableDetails.type,
            "eventData": tableBody[rowIndex]
        });
        autodocEvent.fire();
    },

    onMedicalOnlyChanged: function (cmp, event, helper) {
        helper.filterTableBody(cmp, event);
    },

    onActiveOnlyChanged: function (cmp, event, helper) {
        helper.filterTableBody(cmp, event);
    },

    onCellClick: function (cmp, event, helper) {
        var row = cmp.get("v.tableDetails.tableBody")[event.currentTarget.getAttribute("data-rowIndex")];
        cmp.set("v.firstCallout", true);
        cmp.set("v.isTierOne", false);
        if (cmp.get("v.selectedPolicyKey") != row.uniqueKey) {
            cmp.set("v.showAutodocWarning", true);
        }
        cmp.set("v.clickedRowData", row);

        // DE409857 - Thanish - 8th Mar 2021
        // var caseItem = new Object();
        // caseItem.uniqueKey = row.rowColumnData[0].fieldValue;
        // caseItem.isResolved = true;
        // caseItem.topic = 'View Member Eligibility';
        // var caseItemList = cmp.get("v.caseItemList");
        // caseItemList.push(caseItem);
        // cmp.set("v.caseItemList", caseItemList);
    },
    //US3059727 - Sravan  - Start
    switchPolicy: function (cmp, event, helper) {
        cmp.set('v.showSpinner', true);
        var row = cmp.get("v.clickedRowData");
        var autoDocToBeDeleted = {};
        cmp.set("v.showAutodocWarning", false);
        // remove current policy autodoc if No selected
        if (event.getSource().get("v.label") == "No") {
            _autodoc.deleteAutodoc(cmp.get("v.autodocUniqueId"), cmp.get("v.selectedPolicyKey"));
            autoDocToBeDeleted.doNotRetainAutodDoc = true;
            autoDocToBeDeleted.selectedPolicyKey = cmp.get("v.selectedPolicyKey");
        } else {
            autoDocToBeDeleted.doNotRetainAutodDoc = false;
            autoDocToBeDeleted.selectedPolicyKey = cmp.get("v.selectedPolicyKey");
        }
        cmp.set("v.autoDocToBeDeleted", autoDocToBeDeleted);

        if (!$A.util.isEmpty(row)) {
            cmp.set("v.selectedPolicyKey", row.uniqueKey);
            helper.rowAutodocCheck(cmp, event, !row.checked, row.uniqueKey);
            helper.getExtendedData(cmp, row.transactionId, row.uniqueKey, helper);

            // US2808743 - Thanish - calling handlehiglight on cell click ...
            // TECH - US2692129
            var data = cmp.get("v.dataORG");
            var selectedPolicy = data[row.uniqueKey];

            //US3557591: New Mapping Needed for Notes - Swapnil
            var memberData=_setAndGetSessionValues.gettingValue("Member:"+cmp.get("v.SnapTabId")+":"+cmp.get("v.SnapTabId"));
            var policyListToUpdate = !$A.util.isUndefinedOrNull(memberData)?memberData.CoverageLines:null;
            if(!$A.util.isUndefinedOrNull(policyListToUpdate)){
                for(var i=0;i<policyListToUpdate.length;i++){
                    if(i == row.uniqueKey){
                        memberData.CoverageLines[i].highlightedPolicy = true;
                    }else{
                        memberData.CoverageLines[i].highlightedPolicy = false;
                    }
                }
            }

            if (!$A.util.isUndefinedOrNull(cmp.get("v.SnapTabId"))) {
                _setAndGetSessionValues.settingValue("Member:" + cmp.get("v.SnapTabId") + ":" + cmp.get("v.SnapTabId"), memberData);
            }
            // US3557591 Ends

            var selectedPolicyAttributes = {};
            selectedPolicyAttributes.selectedPlan = selectedPolicy.Plan;
            selectedPolicyAttributes.selectedGroup = selectedPolicy.GroupNumber;
            //US3816776 - Sravan- Start
              cmp.set("v.highlightedPolicyNumber",selectedPolicy.GroupNumber);
            //US3816776 - Sravan - End
            selectedPolicyAttributes.selectedsourcecode = selectedPolicy.sourceCode;
            selectedPolicyAttributes.selectedrelationshipCode = selectedPolicy.relationshipCode;
            selectedPolicyAttributes.selectedmemId = selectedPolicy.memberId;
            selectedPolicyAttributes.selectedTranId = selectedPolicy.transactionId;
            cmp.set("v.currentTransactionId", selectedPolicy.transactionId); //US2855833
            selectedPolicyAttributes.endDate = selectedPolicy.EndDate;
            selectedPolicyAttributes.selectedRowIndex = row.uniqueKey;
            selectedPolicyAttributes.selectedPolicyContactAddress = selectedPolicy.addressLine1;
            selectedPolicyAttributes.city = selectedPolicy.city;
            selectedPolicyAttributes.state = selectedPolicy.state;
            selectedPolicyAttributes.zip = selectedPolicy.zip;
            //Jitendra
            selectedPolicyAttributes.strGraceMessageByState = cmp.get('v.policyList')[row.uniqueKey].strGraceMessageByState;
            selectedPolicyAttributes.strGracePaidThrough = cmp.get('v.policyList')[row.uniqueKey].strGracePaidThrough;
            selectedPolicyAttributes.strGracePeriodMonth = cmp.get('v.policyList')[row.uniqueKey].strGracePeriodMonth;
            cmp.set("v.selectedPolicyAttributes", selectedPolicyAttributes);

            if (selectedPolicy.PlanSubString.includes('Non Medical')) {
                helper.fireToastMessage("Note!", "Case creation is not allowed for non-medical policies. Please select appropriate medical policy for case creation.", "warning", "dismissible", "10000");
            }
            helper.handleHighlightHelper(cmp, event, helper);
            var claimevnt = $A.get("e.c:ACET_PolicyswitchclaimsEvent");
            claimevnt.setParams({
                "selectedPolicy": selectedPolicy,
                "sourcecode": selectedPolicy.sourceCode,
				"uniqueTabID": cmp.get("v.memberTabId"),
                "autoDocToBeDeleted": autoDocToBeDeleted
            });
            claimevnt.fire();
        }

        // DE383848 - Thanish - 10th Nov 2020
        /*if (row.isMedicalPolicy) {
            // create case item for selected policy
            var caseItemList = cmp.get("v.caseItemList");
            var index = -1;
            if (!$A.util.isEmpty(caseItemList) && !$A.util.isUndefinedOrNull(caseItemList)) {
                index = caseItemList.findIndex(function (obj) {
                    return obj.uniqueKey == row.rowColumnData[0].fieldValue;
                });
            } else {
                caseItemList = [];
            }
            if (index == -1) {
                var caseItem = new Object();
                caseItem.uniqueKey = row.rowColumnData[0].fieldValue;
                caseItem.isResolved = true;
                caseItem.topic = 'View Member Eligibility'; //US3071655 - Sravan
                caseItemList.push(caseItem);
                cmp.set("v.caseItemList", caseItemList);
            }
        }Commented and functionality is moved to addCaseItems function - US3683231 - Sravan */

        // Save Case Consolidation - US3424763
        helper.checkResolved(cmp, event, helper);
    },
    //US3059727 - Sravan  - End

    selectRow: function (cmp, event, helper) {
        cmp.set("v.firstCallout", true);
        cmp.set("v.isTierOne", false);
        var row = cmp.get("v.tableDetails.tableBody")[event.getSource().get("v.name")];
        cmp.set("v.selectedPolicyKey", row.uniqueKey);
        helper.rowAutodocCheck(cmp, event, event.getSource().get("v.checked"), event.getSource().get("v.name"));
        helper.getExtendedData(cmp, row.transactionId, event.getSource().get("v.name"), helper);
    },

    getPreview: function (cmp, event) {
        var selectedString = _autodoc.getAutodoc(cmp.get("v.autodocUniqueId"));
        var tableDetails = cmp.get("v.tableDetails");
        console.log("selected string - " + JSON.stringify(selectedString));
        cmp.set("v.tableDetails_prev", selectedString);
        cmp.set("v.showpreview", true);
    },

    // Save Case Consolidation - US3424763
    openModal: function (cmp, event, helper) {
        helper.ttsHelper(cmp, event, helper);
        cmp.set("v.openSaveCase", true);
    },

    togglePopup: function (cmp, event) {
        let showPopup = event.currentTarget.getAttribute("data-popupId");
        cmp.find(showPopup).toggleVisibility();
    },

    handleKeyup: function (cmp) {
        var inputCmp = cmp.find("commentsBoxId");
        var value = inputCmp.get("v.value");
        var errorMessage = 'Error!  You have reached the maximum character limit.  Add additional comments in Case Details as a new case comment.';
        if (value.length >= 2000) {
            inputCmp.setCustomValidity(errorMessage);
            inputCmp.reportValidity();
        } else {
            inputCmp.setCustomValidity('');
            inputCmp.reportValidity();
        }
    },

    // US2644766 - PCP Indicator UI and  Implementation - Durga [08/06/2020]
    navigateToValidateLink: function (cmp, event, helper) {
        try {
            var htmlcmp = event.currentTarget;
            var selectedRowIndex = htmlcmp.getAttribute("data-indexValue");
            var element = "v.dataORG" + "[" + selectedRowIndex + "]";
            var elementValue = cmp.get(element);
            elementValue.isValidated = true;
            cmp.set(element, elementValue);
            helper.getPCPRedirectURL(cmp, event, helper, selectedRowIndex);
        } catch (exception) {
            console.log('=exception in NavigateToValidatelink=' + exception);
        }
    },

    // US2423120, US2517602, US2517604 - Praveen
    getSelectedPolicies: function (cmp, event, helper) {

        //DE378289 - Praveen - 10/22/2020 - Regression defect
        let caseVal = cmp.get('v.caseWrapper');
        var policySubjectId = caseVal.SubjectId;
        var caseSubjectId = event.getParam("subjectId");
        if (policySubjectId == caseSubjectId) {
            var appEvent = $A.get("e.c:ACET_SetPoliciesList");
            var selectedPolicyList = cmp.get('v.selectedPolicyLst');
            appEvent.setParams({
                "selectedPolicyList": selectedPolicyList,
                "memberMap": cmp.get('v.memberMap')
            });
            appEvent.fire();
        }
    },

    // US2554307: View Authorizations Details Page - Add Alerts Button Praveen CR
    setMmberIdGroupIdAuthDtl: function (cmp, event, helper) {
        var appEvent = $A.get("e.c:ACET_SetMmberIdGroupIdAuthDtl");
        appEvent.setParams({
            "memberIdAuthDtl": cmp.get('v.memberIdAuthDtl'),
            "groupIdAuthDtl": cmp.get('v.groupIdAuthDtl'),
            "alertProviderId": cmp.get('v.alertProviderId'),
            "alertTaxId": cmp.get('v.alertTaxId')
        });
        appEvent.fire();
    },

    wrapClipSelect: function (cmp, event, helper) {
        var selectedMenuItemValue = event.getParam("value");
        var index = event.getSource().get("v.name");
        var wrapClip = cmp.get("v.wrapClip");
        if (selectedMenuItemValue == "WRAP") {
            wrapClip[index].class1 = "";
            wrapClip[index].class2 = "slds-cell-wrap";
        } else {
            wrapClip[index].class1 = "truncate";
            wrapClip[index].class2 = "slds-truncate";
        }
        cmp.set("v.wrapClip", wrapClip);
    },

    showAPPolicyWarning: function (cmp, event, helper) {

        cmp.set("v.showAPPolicyWarning", false);
    },

    // Save Case Consolidation - US3424763
    checkResolved: function (cmp, event, helper) {
        helper.checkResolved(cmp, event, helper);
    },

    routeIssue: function (cmp, event, helper) {
        cmp.set("v.openSaveCase", true);
        helper.ttsHelper(cmp, event, helper);
        var casePopup = cmp.find("casePopup");
        casePopup.routeCase();
    },

    openComments: function (cmp) {
        cmp.set("v.showComments", true);
    },
    
    handleAutodocRefresh: function (cmp, event) {
        if (event.getParam("autodocUniqueId") == cmp.get("v.autodocUniqueId")) {
            //_autodoc.resetAutodoc(cmp.get("v.autodocUniqueId"));
            var tableDetails = cmp.get("v.tableDetails");
            for (var i = 0; i < tableDetails.tableBody.length; i++) {
                if (tableDetails.tableBody[i].checked) {
                    tableDetails.tableBody[i].resolved = true;
                }
            }
            tableDetails.ignoreClearAutodoc = true; // DE456923 - Thanish - 30th Jun 2021
            cmp.set("v.tableDetails", tableDetails);
            cmp.set("v.disableButtons", true);
            cmp.set("v.showComments", false);
            cmp.set("v.commentsValue", "");
        }
    }

})