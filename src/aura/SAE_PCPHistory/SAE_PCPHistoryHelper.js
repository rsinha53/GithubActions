({
	initHelper : function(component,event,helper) {
        debugger;
		 var action = component.get("c.getPCPHistoryWS");
         var transactionId = component.get("v.transactionId");
        action.setParams({
            "transactionId": transactionId                        
        });
        
        let isRunSpinner = component.get("v.isFireSpinner");
        if(isRunSpinner) {
            helper.showPCPHistorySpinner(component);
        }
       
        action.setCallback(this, function(response) {  
            var state = response.getState();
            
            if(state == 'SUCCESS') {
                var result = response.getReturnValue();
                if(result.statusCode == 200){  
                    helper.showPCPHistorySpinner(component);
                    component.set("v.pcpHistoryData",result.Response);
                }
                else{ }
            } else if(state == 'ERROR'){
                this.showToastMessage("Error!",'Web Service or External System is temporarily unavailable.', "error", "dismissible", "10000");
            }
            helper.hidePCPHistorySpinner(component);
            
        });
        
        $A.enqueueAction(action);
	},

    setTableDetails: function(cmp, pcpHistoryData){
        this.showPCPHistorySpinner(cmp);
        var rcedResultWrapper=cmp.get("v.rcedResultWrapper");
        console.log("rcedResultWrap"+JSON.stringify(rcedResultWrapper));
       // console.log("ipa1234"+JSON.stringify(rcedResultWrapper.ipaMarketRes.mktIPAName));
        var autodocCmp = _autodoc.getAutodocComponent(cmp.get("v.autodocUniqueId"), cmp.get("v.policySelectedIndex"), "Primary Care Provider History (PCP)");
        var tableList = [];
        var mktIPAName="";
        if(!$A.util.isEmpty(rcedResultWrapper)){
             if(!$A.util.isEmpty(rcedResultWrapper.ipaMarketRes)){
                 mktIPAName=rcedResultWrapper.ipaMarketRes.mktIPAName;
             }
        }
        // US3691233: Add missing fields/components to autodoc reporting - Krish - 11th Aug 2021 - START
        var caseItemsExtId = '';
        var groupNumber = '';
        var memberId = '';
        var sourceCode = '';
        var extendedCoverage = cmp.get('v.extendedCoverage');
        var memberCardData = cmp.get("v.memberCardData");
        var policySelectedIndex = cmp.get("v.policySelectedIndex");

        if(!$A.util.isUndefinedOrNull(extendedCoverage) && !$A.util.isUndefinedOrNull(extendedCoverage.resultWrapper) && !$A.util.isUndefinedOrNull(extendedCoverage.resultWrapper.policyRes)){
            groupNumber = !$A.util.isEmpty(extendedCoverage.resultWrapper.policyRes.groupNumber) ? extendedCoverage.resultWrapper.policyRes.groupNumber : '';
            sourceCode = !$A.util.isEmpty(extendedCoverage.resultWrapper.policyRes.sourceCode) ? extendedCoverage.resultWrapper.policyRes.sourceCode : '';
            // memberId = !$A.util.isEmpty(extendedCoverage.resultWrapper.policyRes.memberInfo.memberID) ? extendedCoverage.resultWrapper.policyRes.memberInfo.memberID : '';
        }
        // Trimming leading 0
        if(groupNumber.length > 0 && groupNumber.charAt(0) == 0){
            groupNumber = groupNumber.substring(1);
        }
        if(!$A.util.isUndefinedOrNull(memberCardData) && !$A.util.isUndefinedOrNull(memberCardData.CoverageLines) && !$A.util.isUndefinedOrNull(memberCardData.CoverageLines[policySelectedIndex]) && !$A.util.isUndefinedOrNull(memberCardData.CoverageLines[policySelectedIndex].patientInfo)){
            memberId = !$A.util.isUndefinedOrNull(memberCardData.CoverageLines[policySelectedIndex].patientInfo.MemberId) ? memberCardData.CoverageLines[policySelectedIndex].patientInfo.MemberId : '';
        }
        caseItemsExtId = groupNumber + '/' + sourceCode + '/' + memberId;
        console.log('SAE_PCPHistory Card: caseItemsExtId: '+JSON.stringify(caseItemsExtId));
        // US3691233: Add missing fields/components to autodoc reporting - Krish - 11th Aug 2021 - END
        if(!$A.util.isEmpty(autodocCmp)){
            tableList[cmp.get("v.policySelectedIndex")] = autodocCmp;
            cmp.set("v.tableList", tableList);

        } else {
            var tableDetails = new Object();
            tableDetails.type = "table";
            tableDetails.autodocHeaderName = "Primary Care Provider History (PCP)";
            tableDetails.componentName = "Primary Care Provider History (PCP)";
            tableDetails.componentOrder = 6;
            tableDetails.showComponentName = false;
            tableDetails.allChecked = false;
            tableDetails.caseItemsExtId = caseItemsExtId; // US3691233: Add missing fields/components to autodoc reporting - Krish - 11th Aug 2021
            tableDetails.tableHeaders = [
               "Start Date", "End Date", "GROUP #", "GROUP NAME","IPA NAME",
                "PCP NAME/#", "Tax ID (TIN)"
            ];
            tableDetails.tableBody = [];
            tableDetails.selectedRows = [];
            var pcp; var i = 0;
            for(pcp of pcpHistoryData){
                var row = {
                    "checked" : false,
                     "resolved" : true,
                    "uniqueKey" : i,
                    "caseItemsExtId": caseItemsExtId, // US3691233: Add missing fields/components to autodoc reporting - Krish - 11th Aug 2021
                    "rowColumnData" : [
                        {
                            "isOutputText" : true,
                            "fieldLabel" : "Start Date",
                            "fieldValue" : $A.util.isEmpty(pcp.StartDate) ? "--" : pcp.StartDate,
                            "key" : i,
                            "isReportable":true
                        },
                        {
                            "isOutputText" : true,
                            "fieldLabel" : "End Date",
                            "fieldValue" : $A.util.isEmpty(pcp.EndDate) ? "--" : pcp.EndDate,
                            "key" : i,
                            "isReportable":true
                        },
                        {
                            "isOutputText" : true,
                            "fieldLabel" : "GROUP #",
                            "fieldValue" : $A.util.isEmpty(pcp.ProviderGroupNumber) ? "--" : pcp.ProviderGroupNumber,
                            "key" : i,
                            "isReportable":true
                        },
                        {
                            "isOutputText" : true,
                            "fieldLabel" : "GROUP NAME",
                            "fieldValue" : $A.util.isEmpty(pcp.ProviderGroupName) ? "--" : pcp.ProviderGroupName,
                            "key" : i,
                            "isReportable":true
                        },
                         {
                            "isOutputText" : true,
                            "fieldLabel" : "IPA NAME",
                            "fieldValue" : $A.util.isEmpty(mktIPAName) ? "--" : mktIPAName,
                            "key" : i,
                            "isReportable":true
                        },
                        {
                            "isOutputText" : true,
                            "fieldLabel" : " PCP NAME/#",
                            "fieldValue" :($A.util.isEmpty(pcp.PCPName) ? "--" : pcp.PCPName )+"/"+ ($A.util.isEmpty(pcp.PCPNumber) ? "--" : pcp.PCPNumber),
                            "key" : i,
                            "isReportable":true
                        },
                        {
                            "isOutputText" : true,
                            "fieldLabel" : "Tax ID (TIN)",
                            "fieldValue" : $A.util.isEmpty(pcp.TaxId) ? "--" : pcp.TaxId,
                            "key" : i,
                            "isReportable":true
                        }
                    ]
                }
                tableDetails.tableBody.push(row);
                i++;
            }
            if(i == 0){
                var row = {
                    "checked" : true,
                    "resolved":true,
                    "uniqueKey" : i,
                    "caseItemsExtId": caseItemsExtId, // US3691233: Add missing fields/components to autodoc reporting - Krish - 11th Aug 2021
                    "isNoRecords" : true,
                    "rowColumnData" : [
                        {
                            "isNoRecords" : true,
                            "fieldLabel" : "No Records",
                            /* "fieldValue" : "No Records Found",*/
                            "fieldValue" : "No Primary Care Provider History (PCP) Results Found",
                            "key" : i,
                            "isReportable":true
                        }
                    ]
                }
                tableDetails.selectedRows.push(row); // US3691233: Add missing fields/components to autodoc reporting - Krish - 11th Aug 2021
                tableDetails.tableBody.push(row);
                // _autodoc.setAutodoc(cmp.get("v.autodocUniqueId"), cmp.get("v.policySelectedIndex"), tableDetails); // To capture no records in autodoc by default
            }
            
            tableList[cmp.get("v.policySelectedIndex")] = tableDetails;
            cmp.set("v.tableList", tableList);
        }
         this.hidePCPHistorySpinner(cmp);
    },

    showPCPHistorySpinner: function (cmp) {
        var spinner = cmp.find("pcp-history-spinner");
        $A.util.removeClass(spinner, "slds-hide");
        $A.util.addClass(spinner, "slds-show");
    },  

    hidePCPHistorySpinner: function (cmp) {
        var spinner = cmp.find("pcp-history-spinner");
        $A.util.removeClass(spinner, "slds-show");
        $A.util.addClass(spinner, "slds-hide");
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
})