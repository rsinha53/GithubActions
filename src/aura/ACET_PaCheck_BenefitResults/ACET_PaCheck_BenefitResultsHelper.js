({
    setTableData: function (cmp, event) {
        var tableDetails = new Object();
        tableDetails.type = "table";
        // US3067235	Auto Doc - Plan Benefits Check - Sarma 
        tableDetails.showComponentName = false;
        tableDetails.componentName = 'Benefit Results'+ cmp.get('v.paCheckTabId');
        tableDetails.autodocHeaderName = 'Benefit Results';
        tableDetails.tableHeaders = ["PROCEDURE CODE", "PROCEDURE CODE DESCRIPTION", "PAY CODE STATUS", "COVERAGE", "CARC/RARC", "BENEFIT CHECK REMARK CODE", "BENEFIT CHECK REMARK DESCRIPTION"];

        tableDetails.tableBody = [];

        // US3089189
        var benefitCheckResult = cmp.get('v.benefitCheckResult');
        // var serviceStatusCode = benefitCheckResult.serviceStatusCode;
        var serviceStatusDescription = ($A.util.isUndefinedOrNull(benefitCheckResult.serviceStatusDescription) ? '--' : benefitCheckResult.serviceStatusDescription);
        // var rtaID = benefitCheckResult.rtaID;
        // var icn = benefitCheckResult.icn;
        // var transID = benefitCheckResult.transID;

        // var to handle no records found/web serice error scenario - Sarma
        var count = 0;
        if (!$A.util.isUndefinedOrNull(benefitCheckResult.serviceLines)) {
            var selectedKLDataMap=cmp.get('v.selectedKLDataMap');
            var serviceLines = benefitCheckResult.serviceLines;
            for (var i = 0; i < serviceLines.length; i++) {
                var status = ($A.util.isUndefinedOrNull(serviceLines[i].status) ? '--' : serviceLines[i].status);
                var procedureCode = ($A.util.isUndefinedOrNull(serviceLines[i].procedureCode) ? '--' : serviceLines[i].procedureCode);
                var reasonCode = ($A.util.isUndefinedOrNull(serviceLines[i].reasonCode) ? '--' : serviceLines[i].reasonCode);
                var reasonDescription = ($A.util.isUndefinedOrNull(serviceLines[i].reasonDescription) ? '--' : serviceLines[i].reasonDescription);
                var row = {
                    "checked": false,
                    "uniqueKey": 2,
                    "caseItemsExtId": "PA Check",
                    "rowColumnData": [
                        {
                            "isOutputText": true,
                            "fieldLabel": "Procedure Code",
                            "fieldValue": (procedureCode.length > 20) ? procedureCode.substring(0, 20) + "..." : procedureCode,
                            "titleName": procedureCode,
                            "key": 1,
                            "isReportable": true
                        },
                        {
                            "isOutputText": true,
                            "fieldLabel": "Procedure Code Description",
                            "fieldValue": (!$A.util.isUndefinedOrNull(selectedKLDataMap[procedureCode]) && (selectedKLDataMap[procedureCode].length > 20)) ? selectedKLDataMap[procedureCode].substring(0, 20) + "--" : selectedKLDataMap[procedureCode],
                            "titleName": (!$A.util.isUndefinedOrNull(selectedKLDataMap[procedureCode]))?selectedKLDataMap[procedureCode]:'--',
                            "key": 2,
                            "isReportable": true
                        },
                        {
                            "isOutputText": true,
                            "fieldLabel": "Pay Code Status",
                            "fieldValue": "--",
                            "titleName": "--",
                            "key": 3,
                            "isReportable": true
                        },
                        {
                            "isOutputText": true,
                            "fieldLabel": "Coverage",
                            "fieldValue": (status.length > 20) ? status.substring(0, 20) + "..." : status,
                            "titleName": status,
                            "key": 4,
                            "isReportable": true
                        },
                        {
                            "isOutputText": true,
                            "fieldLabel": "CARC/RARC",
                            "fieldValue": (reasonCode.length > 20) ? reasonCode.substring(0, 20) + "..." : reasonCode,
                            "titleName": reasonCode,
                            "key": 5,
                            "isReportable": true
                        },
                        {
                            "isOutputText": true,
                            "fieldLabel": "Benefit Check Remark Code",
                            "fieldValue": (reasonDescription.length > 20) ? reasonDescription.substring(0, 20) + "..." : reasonDescription,
                            "titleName": reasonDescription,
                            "key": 6,
                            "isReportable": true
                        },
                        {
                            "isOutputText": true,
                            "fieldLabel": "Benefit Check Remark Description",
                            "fieldValue": (serviceStatusDescription.length > 20) ? serviceStatusDescription.substring(0, 20) + "..." : serviceStatusDescription,
                            "titleName": serviceStatusDescription,
                            "key": 7,
                            "isReportable": true
                        }
                    ]
                };
                tableDetails.tableBody.push(row);
                count++;
            }
        }

        if (count == 0) {
            var row = {
                "checked": false,
                "uniqueKey": i,
                "caseItemsExtId": "PA Check",
                "rowColumnData": [
                    {
                        "isNoRecords": true,
                        "fieldLabel": "No Records",
                        "fieldValue": "No Records Found",
                        "key": i,
                        "isReportable": true
                    }
                ]
            }
            tableDetails.tableBody.push(row);
        }

        cmp.set("v.tableDetails", tableDetails);
    }
})