({
    // US3299151 - Thanish - 16th Mar 2021
    cobErrorMessage: "Unexpected Error Occurred in the Coordination of Benefits Card. Please try again. If problem persists please contact the help desk",

    setCobHistoryDetails : function(cmp) {
        var claimNo = cmp.get("v.claimNo");
        var autodocCmp = _autodoc.getAutodocComponent(cmp.get("v.autodocUniqueId"), cmp.get("v.policySelectedIndex"), "Coordination Of Benefits (COB) History");

        if(!$A.util.isEmpty(autodocCmp)){
            cmp.set("v.cobHistoryDetails", autodocCmp);
            cmp.set("v.isCobHistoryLoaded", true);
        } else {
            this.getCOBHistory(cmp);
            cmp.set("v.isCobHistoryLoaded", true);
        }
    },
    // US3269760 - Thanish - 15th Feb 2021
    setCobCommentsDetails : function(cmp) {
        var claimNo = cmp.get("v.claimNo");
        var autodocCmp = _autodoc.getAutodocComponent(cmp.get("v.autodocUniqueId"), cmp.get("v.policySelectedIndex"), "Coordination Of Benefits (COB) Comments");
        if(!$A.util.isEmpty(autodocCmp)){
            cmp.set("v.cobCommentsDetails", autodocCmp);
            cmp.set("v.isCobCommentsLoaded", true);
        } else {
            var sourceCode = cmp.get("v.policyDetails.resultWrapper.policyRes.sourceCode");
            let policyList = cmp.get("v.memberPolicies");
            var policyLine = policyList[cmp.get("v.policySelectedIndex")];
            if(sourceCode == 'CO'){ // M&R
                var cobMNRCommentsTable = cmp.get("v.cobMNRCommentsTable");
                if(!$A.util.isEmpty(cobMNRCommentsTable)){
                    cmp.set("v.cobCommentsDetails", cobMNRCommentsTable);
                } else{
                    // DE416854 - Thanish - 25th Feb 2021 - assign no records found for cob comments by default
                    var comments = new Object();
                    comments.type = "table";
                    if(cmp.get("v.isClaim")){
                        comments.autodocHeaderName = 'Coordination Of Benefits (COB) Comments: '+claimNo;
                        comments.componentOrder = 13+(cmp.get("v.currentIndexOfOpenedTabs")*cmp.get("v.maxAutoDocComponents"));
                        comments.componentName = 'Coordination Of Benefits (COB) Comments: '+claimNo;
                    }else{
                        comments.autodocHeaderName = 'Coordination Of Benefits (COB) Comments';
                        comments.componentOrder = 8;
                        comments.componentName = 'Coordination Of Benefits (COB) Comments';
                    }
                    comments.showComponentName = false;
                    comments.tableHeaders = ['Type', 'Date', 'Comment'];
                    comments.tableBody = [];
                    var row = {
                        "checked" : false,
                        "uniqueKey" : cmp.get("v.policySelectedIndex"),
                        "caseItemsExtId" : policyLine.GroupNumber,
                        "rowColumnData" : [
                            {
                                "isNoRecords" : true,
                                "fieldLabel" : "No Records",
                                "fieldValue" : "No COB Comments Results Found",
                                "key" : 0,
                                "isReportable":true
                            }
                        ]
                    }
                    comments.tableBody.push(row);
                    cmp.set("v.cobCommentsDetails", comments);
                }
                cmp.set("v.isCobCommentsLoaded", true);
                this.setReportingAttributesComments(cmp);

            } else if(sourceCode == 'CS'){ // E&I
                var action = cmp.get('c.getCOBCommentsENI');
                var empId = cmp.get("v.policyDetails.resultWrapper.policyRes.subscriberID");
                if(!$A.util.isEmpty(empId) && empId.length > 9){
                    empId = empId.slice(-9);
                }
                var policyId = cmp.get("v.policyDetails.resultWrapper.policyRes.policyNumber");
                if(!$A.util.isEmpty(policyId) && policyId.length > 6){
                    policyId = policyId.slice(-6);
                }
                action.setParams({
                    'sysName': cmp.get("v.regionCode"),
                    'empId': empId,
                    'policyId': policyId
                });
                action.setCallback(this, function (response) {
                    // US3299151 - Thanish - 16th Mar 2021
                    var result = response.getReturnValue();
                    if(result.statusCode!=200){
                        this.showToastMessage("We hit a snag.", this.cobErrorMessage, "error", "dismissible", "30000");
                    }
                    var tableComments = result.comments;
                    var tableRows = tableComments.tableBody;
                    for(var i=0 ; i<tableComments.tableBody.length; i++) {
                        tableComments.tableBody[i].caseItemsExtId = policyLine.GroupNumber;
                    }
                    if(cmp.get("v.isClaim")){
                        tableComments.autodocHeaderName = 'Coordination Of Benefits (COB) Comments: '+claimNo;
                        tableComments.componentOrder = 13+(cmp.get("v.currentIndexOfOpenedTabs")*cmp.get("v.maxAutoDocComponents"));
                        tableComments.componentName = 'Coordination Of Benefits (COB) Comments: '+claimNo;
                    }
                    cmp.set("v.cobCommentsDetails", tableComments);
                    
                    cmp.set("v.isCobCommentsLoaded", true);
                    this.setReportingAttributesComments(cmp);
                });
                $A.enqueueAction(action);
            } else{
                var tableDetails = new Object();
                tableDetails.type = "table";
                if(cmp.get("v.isClaim")){
                    tableDetails.autodocHeaderName = 'Coordination Of Benefits (COB) Comments: '+claimNo;
                    tableDetails.componentOrder = 13+(cmp.get("v.currentIndexOfOpenedTabs")*cmp.get("v.maxAutoDocComponents"));
                    tableDetails.componentName = 'Coordination Of Benefits (COB) Comments: '+claimNo;
                }else{
                    tableDetails.autodocHeaderName = 'Coordination Of Benefits (COB) Comments';
                    tableDetails.componentOrder = 8;
                    tableDetails.componentName = 'Coordination Of Benefits (COB) Comments';
                }
                tableDetails.showComponentName = false;
                tableDetails.tableHeaders = [
                    "Type", "Date", "Comment"
                ];
                tableDetails.tableBody = [];
                tableDetails.selectedRows = [];
                var row = {
                    "checked" : false,
                    "uniqueKey" : cmp.get("v.policySelectedIndex"),
                    "caseItemsExtId" : policyLine.GroupNumber,
                    "rowColumnData" : [
                        {
                            "isNoRecords" : true,
                            "fieldLabel" : "No Records",
                            "fieldValue" : "No COB Comments Results Found",
                            "key" : 0,
                            "isReportable":true
                        }
                    ]
                }
                tableDetails.tableBody.push(row);
                cmp.set("v.cobCommentsDetails", tableDetails);
                cmp.set("v.isCobCommentsLoaded", true);
                this.setReportingAttributesComments(cmp);
            }
        }
    },
    // US2890614: COB History Integration M&R - Krishnanshu - 16th Feb 2021
    getCOBHistory: function(cmp){
        var claimNo = cmp.get("v.claimNo");
        var policyDetails = cmp.get('v.policyDetails');
        let policyList = cmp.get("v.memberPolicies");
        var policyLine = policyList[cmp.get("v.policySelectedIndex")];
        console.log(JSON.stringify(policyLine));
        if(policyDetails.resultWrapper.policyRes.sourceCode == 'CO'){
            // For MNR
            var action=cmp.get('c.getCOBHistoryMNR');
            var cobHistoryRequestParam = {
                'cosmosDivision': !$A.util.isEmpty(policyDetails.resultWrapper.policyRes.cosmosDivision) ? policyDetails.resultWrapper.policyRes.cosmosDivision : '',
                'groupNumber': !$A.util.isEmpty(policyLine.GroupNumber) ? policyLine.GroupNumber : !$A.util.isEmpty(policyDetails.resultWrapper.policyRes.policyNumber) ? policyDetails.resultWrapper.policyRes.policyNumber : '',
                'subscriberId': !$A.util.isEmpty(policyDetails.resultWrapper.policyRes.subscriberID) ? policyDetails.resultWrapper.policyRes.subscriberID : '',
                'dependentCode': cmp.get("v.dependentCode"),
                'effectiveDate' : !$A.util.isEmpty(policyDetails.resultWrapper.policyRes.coverageStartDate) ? policyDetails.resultWrapper.policyRes.coverageStartDate : '',
                'medicareType': !$A.util.isEmpty(policyDetails.resultWrapper.policyRes.medicareIndicator) ? policyDetails.resultWrapper.policyRes.medicareIndicator : '',
                'medicareEntReason': !$A.util.isEmpty(policyDetails.resultWrapper.policyRes.medicareEntitlementReason) ? policyDetails.resultWrapper.policyRes.medicareEntitlementReason : '',
            };      
            action.setParams({
                'cobHistoryRequest': cobHistoryRequestParam
            });
            action.setCallback(this, function (response) { 
                var state = response.getState();
                var result = response.getReturnValue();
                console.log(JSON.stringify(response));
                if (state == 'SUCCESS') {
                    if (result.isSuccess) {
                        if (result.statusCode == 200) {
                            var tableHistory = result.response;
                            var tableRows = tableHistory.tableBody;
                            for(var i=0 ; i<tableHistory.tableBody.length; i++) {
                                tableHistory.tableBody[i].caseItemsExtId = policyLine.GroupNumber;
                            }
                            if(cmp.get("v.isClaim")){
                                tableHistory.autodocHeaderName = 'Coordination Of Benefits (COB) History: '+claimNo;
                                tableHistory.componentOrder = 12+(cmp.get("v.currentIndexOfOpenedTabs")*cmp.get("v.maxAutoDocComponents"));
                                tableHistory.componentName = 'Coordination Of Benefits (COB) History: '+claimNo;
                            }
                            cmp.set("v.cobHistoryDetails", tableHistory);
                        }else{
                            this.showToastMessage("We hit a snag.", this.cobErrorMessage, "error", "dismissible", "30000");// US3299151 - Thanish - 16th Mar 2021
                        }
                    }else{
                        this.showToastMessage("We hit a snag.", this.cobErrorMessage, "error", "dismissible", "30000");// US3299151 - Thanish - 16th Mar 2021
    }
                    }else{
                    this.showToastMessage("We hit a snag.", this.cobErrorMessage, "error", "dismissible", "30000");// US3299151 - Thanish - 16th Mar 2021
                }
                //cmp.find("cobHistoryCardSpinnerAI").set("v.isTrue", false);
                this.setReportingAttributesHistory(cmp);
            });
            $A.enqueueAction(action);
        }else if(policyDetails.resultWrapper.policyRes.sourceCode == 'CS'){
            // For ENI - use from COB - cobENIHistoryTable
            // US2585035: COB History Integration E&I - Krish - 16th Feb 2021
            var cobENIHistoryTable = cmp.get('v.cobENIHistoryTable');
            if(!$A.util.isEmpty(cobENIHistoryTable)){
            cmp.set("v.cobHistoryDetails", cobENIHistoryTable);
            }else{
                this.setCOBHistoryAutodocTable(cmp);
            }
            this.setReportingAttributesHistory(cmp);
        }else{
            // For other that MNR and ENI
			this.setCOBHistoryAutodocTable(cmp);
            this.setReportingAttributesHistory(cmp);
		}
    },
	
    showToastMessage: function (title, message, type, mode, duration) {
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
    
    setCOBHistoryAutodocTable: function(cmp){
        var claimNo = cmp.get("v.claimNo");
        let policyList = cmp.get("v.memberPolicies");
        var policyLine = policyList[cmp.get("v.policySelectedIndex")];
        // For other that MNR and ENI
        var tableDetails = $A.util.isEmpty(cmp.get("v.cobHistoryDetails")) ? new Object() : cmp.get("v.cobHistoryDetails");
        tableDetails.type = "table";
        if(cmp.get("v.isClaim")){
            tableDetails.autodocHeaderName = "Coordination Of Benefits (COB) History: "+claimNo;
            tableDetails.componentOrder = 12+(cmp.get("v.currentIndexOfOpenedTabs")*cmp.get("v.maxAutoDocComponents"));
            tableDetails.componentName = "Coordination Of Benefits (COB) History: "+claimNo;
        }else{
            tableDetails.autodocHeaderName = "Coordination Of Benefits (COB) History";
            tableDetails.componentOrder = 7;
            tableDetails.componentName = "Coordination Of Benefits (COB) History";
        }
        tableDetails.showComponentName = false;
        tableDetails.tableHeaders = [
            "Updated", "OI Primary", "OI Type", "Payer Name",
            "Eligible Dates","Medicare Type", "Medicare Entitlement Reason"
        ];
        //DE431589
        tableDetails.selectedRows = [];
        tableDetails.tableBody = [];
        var row = {
            "checked" : false,
            "uniqueKey" : cmp.get("v.policySelectedIndex"),
            "caseItemsExtId" : policyLine.GroupNumber,
            "rowColumnData" : [
                {
                    "isNoRecords" : true,
                    "fieldLabel" : "No Records",
                    "fieldValue" : "No Coordination Of Benefits (COB) History Results Found",
                    "key" : 0,
                    "isReportable":true
                }
            ]
        }
        tableDetails.tableBody.push(row);
        cmp.set("v.cobHistoryDetails", tableDetails);
    },

    setReportingAttributesHistory: function (cmp) {
        var tableDetails = cmp.get("v.cobHistoryDetails");
        tableDetails.reportingHeader = "Coordination Of Benefits (COB) History";
        var caseItemExtId = "";
        if (cmp.get("v.isClaim")) {
            caseItemExtId = cmp.get("v.claimNo");
        }else{
            caseItemExtId =  this.getCaseItemsExternalId(cmp);
        }
            for (var i = 0; i < tableDetails.tableBody.length; i++) {
            tableDetails.tableBody[i].caseItemsExtId = caseItemExtId;
        }
        cmp.set("v.cobHistoryDetails", tableDetails);
    },

    setReportingAttributesComments: function (cmp) {
        var tableDetails = cmp.get("v.cobCommentsDetails");
        tableDetails.reportingHeader = "Coordination Of Benefits (COB) Comments";
        var caseItemExtId = "";
        if (cmp.get("v.isClaim")) {
            caseItemExtId = cmp.get("v.claimNo"); 
        }else{
            caseItemExtId =  this.getCaseItemsExternalId(cmp);
        }
            for (var i = 0; i < tableDetails.tableBody.length; i++) {
            tableDetails.tableBody[i].caseItemsExtId = caseItemExtId;
        }
        cmp.set("v.cobCommentsDetails", tableDetails);
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