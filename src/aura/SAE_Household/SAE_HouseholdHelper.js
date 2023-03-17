({
    // US2579637
    updateHouseHold: function (cmp) {
        var houseHoldData = cmp.get("v.houseHoldData");
        cmp.set("v.ChangedHouseHoldData", houseHoldData);
    },
        
    // US2808743 - Thanish - 4th Sep 2020 - New Autodoc Framework
    setAutodocTableData: function (cmp) {
        var autodocCmp = _autodoc.getAutodocComponent(cmp.get("v.autodocUniqueId"), cmp.get("v.policySelectedIndex"), "Household");

        if(!$A.util.isEmpty(autodocCmp) && !autodocCmp.isDummyData){ // DE418896 - Thanish - 22nd Mar 2021
            cmp.set("v.tableDetails", autodocCmp);

        } else {
            var changedHouseHoldData = cmp.get("v.ChangedHouseHoldData");
            var tableDetails = new Object();
            tableDetails.type = "table";
            tableDetails.componentOrder = 5;
            tableDetails.autodocHeaderName = "Household";
            tableDetails.componentName = "Household";
            tableDetails.allChecked = false;
            tableDetails.isDummyData = false; // DE418896 - Thanish - 22nd Mar 2021
            tableDetails.tableHeaders = [
                "NAME", "GENDER", "DOB", "RELATIONSHIP"
            ];
            tableDetails.tableBody = [];
            tableDetails.selectedRows = [];
            var data;
            for(data of changedHouseHoldData){
                var row = {
                    "checked" : false,
                    "caseItemsExtId": cmp.get("v.memberGrpN"),
                    "uniqueKey" : data.memberId + data.dob + data.firstName,
                    "memberId" : data.memberId,
                    "dob" : data.dob,
                    "groupNumber" : data.groupNumber,
                    "firstName" : data.firstName,
                    "lastName" : data.lastName,
                    "relationship" : data.relationship,
                    "isMainMember" : data.isMainMember,
                    "rowColumnData" : [
                        {
                            "isOutputText" : true,
                            "fieldLabel" : "NAME",
                            "fieldValue" : data.fullName,
                            "isReportable":true
                        },
                        {
                            "isOutputText" : true,
                            "fieldLabel" : "GENDER",
                            "fieldValue" : data.gender,
                            "isReportable":true
	},
                        {
                            "isOutputText" : true,
                            "fieldLabel" : "DOB",
                            "fieldValue" : data.dob,
                            "isReportable":true
                        },
                        {
                            "isOutputText" : true,
                            "fieldLabel" : "RELATIONSHIP",
                            "fieldValue" : data.relationship,
                            "isReportable":true
                        }
                    ]
                }
                tableDetails.tableBody.push(row);
            }
            cmp.set("v.tableDetails", tableDetails);
        }
    },

    // DE418896 - Thanish - 22nd Mar 2021
    setEmptyAutoDocData: function(cmp){
        var tableDetails = new Object();
        tableDetails.type = "table";
        tableDetails.componentOrder = 5;
        tableDetails.autodocHeaderName = "Household";
        tableDetails.componentName = "Household";
        tableDetails.allChecked = false;
        tableDetails.isDummyData = true;
        tableDetails.tableHeaders = [
            "NAME", "GENDER", "DOB", "RELATIONSHIP"
        ];
        tableDetails.tableBody = [];
        tableDetails.selectedRows = [];
        var row = {
            "checked" : false,
            "uniqueKey" : "0",
            "memberId" : "--",
            "dob" : "--",
            "groupNumber" : "--",
            "firstName" : "--",
            "lastName" : "--",
            "relationship" : "--",
            "isMainMember" : "--",
            "rowColumnData" : [
                {
                    "isOutputText" : true,
                    "fieldLabel" : "NAME",
                    "fieldValue" : "--",
                    "isReportable":true
                },
                {
                    "isOutputText" : true,
                    "fieldLabel" : "GENDER",
                    "fieldValue" : "--",
                    "isReportable":true
                },
                {
                    "isOutputText" : true,
                    "fieldLabel" : "DOB",
                    "fieldValue" : "--",
                    "isReportable":true
                },
                {
                    "isOutputText" : true,
                    "fieldLabel" : "RELATIONSHIP",
                    "fieldValue" : "--",
                    "isReportable":true
                }
            ]
        }
        tableDetails.tableBody.push(row);
        cmp.set("v.tableDetails", tableDetails);
    }
})