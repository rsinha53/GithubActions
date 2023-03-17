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
        tableDetails.autodocHeaderName = "Diagnosis Details: " + cmp.get("v.SRN")+": "+claimNo;
        tableDetails.componentOrder = 16.06 +(maxAutoDocComponents*currentIndexOfOpenedTabs)+(maxAutoDocAuthComponents*currentIndexOfAuthOpenedTabs);
        tableDetails.componentName = "Diagnosis Details: " + cmp.get("v.SRN")+": "+claimNo;
        }
        else{
        tableDetails.autodocHeaderName = "Diagnosis Details: " + cmp.get("v.SRN");
        tableDetails.componentOrder = 9;
        tableDetails.componentName = "Diagnosis Details: " + cmp.get("v.SRN");
        }
        tableDetails.componentName = 'Diagnosis Details';
        tableDetails.showComponentName = false;
        tableDetails.tableHeaders = [ "Primary", "DX Code" ];
        tableDetails.tableBody = [];

        var i = 0; var diag;
        for(diag of authDetailsObj.diagnosis){
             // US2969157 - TECH - View Authorization Enhancements for new auto doc framework - Sarma - 7/10/2020
            // Null check in each level of object nodes to prevent exception
            let dxCode = "--";
            let dxCodeDesc = "";
            if(!$A.util.isEmpty(diag.diagnosisCode) && !$A.util.isEmpty(diag.diagnosisCode.code)){
                dxCode = diag.diagnosisCode.code;
            }
            if(!$A.util.isEmpty(diag.diagnosisCode) && !$A.util.isEmpty(diag.diagnosisCode.codeDesc)){
                dxCodeDesc = diag.diagnosisCode.codeDesc;
            }
            var row = {
                "checked" : false,
                "uniqueKey" : i,
                "rowColumnData" : [
                    {
                        "isOutputText" : true,
                        "fieldLabel" : "Primary",
                        "fieldValue" : ((diag.primaryInd == '1') || (diag.primaryInd == 'true')) ? "Yes" : "No",
                        "key" : i,
                        "isReportable": true // US2834058 - Thanish - 13th Oct 2020
                    },
                    {
                        "isOutputText" : true,
                        "fieldLabel" : "DX Code",
                        "fieldValue" : dxCode,
                        "titleName" : dxCodeDesc,
                        "key" : i,
                        "isReportable": true // US2834058 - Thanish - 13th Oct 2020
                    }
                ]
            }
            row.caseItemsExtId = cmp.get("v.isClaimDetail") ? claimNo : cmp.get("v.SRN");
            tableDetails.tableBody.push(row);
            i++;
        }
        if( i == 0){
            var row = {
                "checked" : false,
                "uniqueKey" : 0,
                "rowColumnData" : [
                    {
                        "isNoRecords" : true,
                        "fieldLabel" : "No Records",
                        "fieldValue" : "No Records Found",
                        "key" : 0,
                        "isReportable": true //US3653575
        }
                ]
        }
            row.caseItemsExtId = cmp.get("v.isClaimDetail") ? claimNo : cmp.get("v.SRN");
            tableDetails.tableBody.push(row);
        }
        cmp.set("v.tableDetails", tableDetails);
    }
})