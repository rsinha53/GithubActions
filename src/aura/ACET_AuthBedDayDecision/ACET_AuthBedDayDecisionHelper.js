({
    setTableData: function(cmp) {
        var authDetailsObj = cmp.get("v.authDetailsObj");
        var tableDetails = new Object();
        tableDetails.type = "table";
        var currentIndexOfOpenedTabs = cmp.get("v.currentIndexOfOpenedTabs");
        var maxAutoDocComponents = cmp.get("v.maxAutoDocComponents");
        var claimNo=cmp.get("v.claimNo");
         var currentIndexOfAuthOpenedTabs=cmp.get("v.currentIndexOfAuthOpenedTabs");
         var maxAutoDocAuthComponents=cmp.get("v.maxAutoDocAuthComponents");
        if(cmp.get("v.isClaimDetail")){
        tableDetails.autodocHeaderName = "Bed Day Decision: " + cmp.get("v.SRN")+": "+claimNo;
        tableDetails.componentOrder =16.04 +(maxAutoDocComponents*currentIndexOfOpenedTabs)+(maxAutoDocAuthComponents*currentIndexOfAuthOpenedTabs);
        tableDetails.componentName = "Bed Day Decision: " + cmp.get("v.SRN")+": "+claimNo;
        }
        else{
        tableDetails.autodocHeaderName = "Bed Day Decision: " + cmp.get("v.SRN");
        tableDetails.componentOrder = 7;
        tableDetails.componentName = "Bed Day Decision: " + cmp.get("v.SRN");
        }
        tableDetails.showComponentName = false;
        tableDetails.tableHeaders = [
            "BEGIN/END DATE", "IPMNR ALLOWED", "DECISION UPDATE", "DECISION", "REASON", "CLAIM COMMENTS",
            "DECISION BY", "BED TYPE", "OVERRIDE REASON", "DISCHARGE LOCATION"
        ];
        tableDetails.tableBody = [];

        var i = 0; var fac;
        if(!$A.util.isEmpty(authDetailsObj.facility) && !$A.util.isEmpty(authDetailsObj.facility.facilityDecision) && !$A.util.isEmpty(authDetailsObj.facility.facilityDecision.bedDayDecision)){

        for(fac of authDetailsObj.facility.facilityDecision.bedDayDecision){
                // US2969157 - TECH - View Authorization Enhancements for new auto doc framework - Sarma - 7/10/2020
                // Null check in each level of object nodes to prevent exception
                let decision = "--";
                let ipmnrAllowed = "--";
                let reason = "--";
                let decisionBy = "--";
                let bedType = "--";
                let dischargeLocation = "--";

                if(!$A.util.isEmpty(fac.decisionOutcomeCode) && !$A.util.isEmpty(fac.decisionOutcomeCode.description)){
                    decision = fac.decisionOutcomeCode.description;
                }
                if(!$A.util.isEmpty(authDetailsObj.facility.ipmnrAllowed)){
                    ipmnrAllowed = authDetailsObj.facility.ipmnrAllowed;
                }
                if(!$A.util.isEmpty(fac.bedTypeCode) && !$A.util.isEmpty(fac.bedTypeCode.description)){
                    bedType = fac.bedTypeCode.description;
                }
                // These 3 can be moved out side of the for loop if needed
                if(!$A.util.isEmpty(authDetailsObj.facility.facilityDecision.decisionReasonCode) && !$A.util.isEmpty(authDetailsObj.facility.facilityDecision.decisionReasonCode.description)){
                    reason = authDetailsObj.facility.facilityDecision.decisionReasonCode.description;
                }
                if(!$A.util.isEmpty(authDetailsObj.facility.facilityDecision.madeByUserId)){
                    decisionBy = authDetailsObj.facility.facilityDecision.madeByUserId;
                }

                // US3222404
                if(!$A.util.isEmpty(authDetailsObj.facility.dischargeDispositionType) && !$A.util.isEmpty(authDetailsObj.facility.dischargeDispositionType.description)){
                    dischargeLocation = authDetailsObj.facility.dischargeDispositionType.description;
                }

                // US3157932
                var rowColumnData = [];
                rowColumnData.push(setRowColumnData('outputText', fac.BeginEndDays, i));
                rowColumnData.push(setRowColumnData('outputText', ipmnrAllowed, i));
                rowColumnData.push(setRowColumnData('outputText', fac.decisionUpdateDateTimeRendered, i));
                rowColumnData.push(setRowColumnData('outputText', decision, i));
                rowColumnData.push(setRowColumnData('outputText', reason, i));
                rowColumnData.push(setRowColumnData('outputText', fac.claimNoteText, i));
                rowColumnData.push(setRowColumnData('outputText', decisionBy, i));
                rowColumnData.push(setRowColumnData('outputText', bedType, i));
                rowColumnData.push(setRowColumnData('outputText', '--', i));
                rowColumnData.push(setRowColumnData('outputText', dischargeLocation, i));

            var row = {
                "checked" : false,
                "uniqueKey" : i,
                    "rowColumnData": rowColumnData // US3157932
            };
            row.caseItemsExtId = cmp.get("v.isClaimDetail") ? claimNo : cmp.get("v.SRN"); // US3691220: Add missing fields/components to autodoc reporting (Topic = View Authorizations)
            tableDetails.tableBody.push(row);
            i++;
        }

            // US3157932
            function setRowColumnData(ft, fv, uk) {
                var rowColumnData = new Object();
                rowColumnData.fieldType = ft;
                rowColumnData.key = uk;
                if (!$A.util.isUndefinedOrNull(fv) && !$A.util.isEmpty(fv) && fv.length > 0) {
                    if (fv.length > 20) {
                        rowColumnData.fieldValue = fv.substring(0, 20) + '...';
                        rowColumnData.titleName = fv;
                    } else {
                        rowColumnData.fieldValue = fv;
                        rowColumnData.titleName = '';
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
            }

        }
        if(i == 0){
            var row = {
                "checked" : false,
                "uniqueKey" : 0,
                "rowColumnData" : [
                    {
                        "isNoRecords" : true,
                        "fieldLabel" : "No Records",
                        "fieldValue" : "No Records Found",
                        "key" : 0
                    }
                ]
            }
            row.caseItemsExtId = cmp.get("v.isClaimDetail") ? claimNo : cmp.get("v.SRN"); // US3691220: Add missing fields/components to autodoc reporting (Topic = View Authorizations)
            tableDetails.tableBody.push(row);
        }
        cmp.set("v.tableDetails", tableDetails);
    }
})