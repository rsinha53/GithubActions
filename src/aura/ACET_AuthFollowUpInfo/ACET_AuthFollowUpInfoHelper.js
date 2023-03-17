({
    setCardDetails : function(cmp) {
        var authDetailsObj = cmp.get("v.authDetailsObj");

        // US2969157 - TECH - View Authorization Enhancements for new auto doc framework - Sarma - 7/10/2020
        // Null check in each level of object nodes to prevent exception

        let name = "--";
        let department = "--";
        let timeZone = "--";

        if(!$A.util.isEmpty(authDetailsObj) && !$A.util.isEmpty(authDetailsObj.authFollowUpContact)){
            if(!$A.util.isEmpty(authDetailsObj.authFollowUpContact.contactFullName)){
                name = authDetailsObj.authFollowUpContact.contactFullName;
            }
            if(!$A.util.isEmpty(authDetailsObj.authFollowUpContact.departmentTypecode) && !$A.util.isEmpty(authDetailsObj.authFollowUpContact.departmentTypecode.code)){
                //US2955631
                var departmentTypeMap= cmp.get("v.departmentTypeMap");
                department =departmentTypeMap[ authDetailsObj.authFollowUpContact.departmentTypecode.code];
            }
            if(!$A.util.isEmpty(authDetailsObj.authFollowUpContact.timeZone)){
                timeZone = authDetailsObj.authFollowUpContact.timeZone;
            }
        }


        var cardDetails = new Object();
        var currentIndexOfOpenedTabs = cmp.get("v.currentIndexOfOpenedTabs");
        var maxAutoDocComponents = cmp.get("v.maxAutoDocComponents");
        var claimNo=cmp.get("v.claimNo");
        var currentIndexOfAuthOpenedTabs=cmp.get("v.currentIndexOfAuthOpenedTabs");
            var maxAutoDocAuthComponents=cmp.get("v.maxAutoDocAuthComponents");
        if(cmp.get("v.isClaimDetail")){
        cardDetails.componentName = "Follow Up Information: " + cmp.get("v.SRN")+": "+claimNo;
        cardDetails.componentOrder = 16.08 +(maxAutoDocComponents*currentIndexOfOpenedTabs)+(maxAutoDocAuthComponents*currentIndexOfAuthOpenedTabs);
        // US3653575
                cardDetails.caseItemsExtId = claimNo;
        }
        else{
        cardDetails.componentName = "Follow Up Information: " + cmp.get("v.SRN");
        cardDetails.componentOrder = 11;
            // US3653575
                cardDetails.caseItemsExtId = cmp.get("v.SRN");
        }
        // US3653575
        cardDetails.reportingHeader = 'Follow Up Information';
        cardDetails.noOfColumns = "slds-size_1-of-8";
        cardDetails.type = "card";
        cardDetails.allChecked = false;
        cardDetails.cardData = [
            {
                "checked": false,
                "fieldName": "Name",
                "fieldType": "outputText",
                "fieldValue": name ,
                "showCheckbox": true,
                "isReportable": true // US2834058 - Thanish - 13th Oct 2020
            },
            {
                "checked": false,
                "fieldName": "Role",
                "fieldType": "outputText",
                "fieldValue": ($A.util.isEmpty(cmp.get("v.finalTextRole")) ? "--" : cmp.get("v.finalTextRole")),
                "showCheckbox": true,
                "isReportable": true // US2834058 - Thanish - 13th Oct 2020
            },
            {
                "checked": false,
                "fieldName": "Department",
                "fieldType": "outputText",
                "fieldValue": department,
                "showCheckbox": true,
                "isReportable": true // US2834058 - Thanish - 13th Oct 2020
            },
            {
                "checked": false,
                "fieldName": "Phone",
                "fieldType": "outputText",
                "fieldValue": ($A.util.isEmpty(cmp.get("v.phone")) ? "--" : cmp.get("v.phone")),
                "showCheckbox": true,
                "isReportable": true // US2834058 - Thanish - 13th Oct 2020
            },
            {
                "checked": false,
                "fieldName": "Fax",
                "fieldType": "outputText",
                "fieldValue": ($A.util.isEmpty(cmp.get("v.fax")) ? "--" : cmp.get("v.fax")),
                "showCheckbox": true,
                "isReportable": true // US2834058 - Thanish - 13th Oct 2020
            },
            {
                "checked": false,
                "fieldName": "Time Zone",
                "fieldType": "outputText",
                "fieldValue": timeZone,
                "showCheckbox": true,
                "isReportable": true // US2834058 - Thanish - 13th Oct 2020
            },
            {
                "checked": false,
                "fieldName": "Created By",
                "fieldType": "outputText",
                "fieldValue": ($A.util.isEmpty(authDetailsObj.createdBy) ? "--" : authDetailsObj.createdBy),
                "showCheckbox": true,
                "isReportable": true // US2834058 - Thanish - 13th Oct 2020
            },
            {
                "checked": false,
                "fieldName": "Created Date/Time",
                "fieldType": "outputText",
                "fieldValue": ($A.util.isEmpty(authDetailsObj.createDateTimeRendered) ? "--" : authDetailsObj.createDateTimeRendered),
                "showCheckbox": true,
                "isReportable": true // US2834058 - Thanish - 13th Oct 2020
            }
        ];
        cmp.set("v.cardDetails", cardDetails);
    }
})