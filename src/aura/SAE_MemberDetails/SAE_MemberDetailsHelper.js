({
	copyTextHelper : function(component,event,text) {
        debugger;
        // Create an hidden input
        var hiddenInput = document.createElement("input");
        // passed text into the input
        hiddenInput.setAttribute("value", text);
        // Append the hiddenInput input to the body
        document.body.appendChild(hiddenInput);
        // select the content
        hiddenInput.select();
        // Execute the copy command
        document.execCommand("copy");
        // Remove the input from the body after copy text
        document.body.removeChild(hiddenInput); 
        // store target button label value
        var orignalLabel = event.getSource().get("v.label");
        // change button icon after copy text
        //event.getSource().set("v.iconName" , 'utility:check');
        // change button label with 'copied' after copy text 
        event.getSource().set("v.label" , 'copied');
        
        // set timeout to reset icon and label value after 700 milliseconds 
        setTimeout(function(){ 
            //event.getSource().set("v.iconName" , 'utility:copy_to_clipboard'); 
            event.getSource().set("v.label" , orignalLabel);
        }, 700);
        
    },

    // US2808743 - Thanish - 3rd Sep 2020 - New Autodoc Framework
    setAutodocCardData: function (cmp) {
        var autodocCmp = _autodoc.getAutodocComponent(cmp.get("v.autodocUniqueId"), cmp.get("v.policySelectedIndex"), "Member Details");

        // US3691233: Add missing fields/components to autodoc reporting - Krish - 11th Aug 2021 - START
        var caseItemsExtId = '';
        var groupNumber = '';
        var memberId = '';
        var sourceCode = '';
        var policyMemberId = cmp.get("v.policyMemberId");
        var extendedCoverage = cmp.get('v.extendedCoverage');
        var memberCardData = cmp.get("v.memberCardData");
        var policySelectedIndex = cmp.get("v.policySelectedIndex");

        if(!$A.util.isUndefinedOrNull(extendedCoverage) && !$A.util.isEmpty(extendedCoverage) && !$A.util.isEmpty(extendedCoverage.resultWrapper) && !$A.util.isEmpty(extendedCoverage.resultWrapper.policyRes) && !$A.util.isEmpty(extendedCoverage.resultWrapper.policyRes.sourceCode)){
            sourceCode = extendedCoverage.resultWrapper.policyRes.sourceCode;
        }
        if(!$A.util.isUndefinedOrNull(memberCardData) && !$A.util.isEmpty(memberCardData)){
            if(!$A.util.isUndefinedOrNull(memberCardData.CoverageLines) && !$A.util.isUndefinedOrNull(memberCardData.CoverageLines[policySelectedIndex])){
                groupNumber = !$A.util.isUndefinedOrNull(memberCardData.CoverageLines[policySelectedIndex].GroupNumber) ? memberCardData.CoverageLines[policySelectedIndex].GroupNumber : '';
            }
            memberId = !$A.util.isUndefinedOrNull(memberCardData.MemberId) ? memberCardData.MemberId : '';
        }
        // Timming leading 0
        if(groupNumber.length > 0 && groupNumber.charAt(0) ==0){
            groupNumber = groupNumber.substring(1);
        }
        caseItemsExtId = groupNumber + '/' + sourceCode + '/' + policyMemberId;
        console.log('SAE_MemberDetails Card: caseItemsExtId: '+JSON.stringify(caseItemsExtId));
        // US3691233: Add missing fields/components to autodoc reporting - Krish - 11th Aug 2021 - END
        if(!$A.util.isEmpty(autodocCmp)){
            // Updating the case Items external id if the autodoc is already there
            autodocCmp.caseItemsExtId = caseItemsExtId;
            console.log('Autodoc: '+JSON.stringify(autodocCmp));
            cmp.set("v.cardDetails", autodocCmp);

        } else {
            var patientInfo = cmp.get("v.patientInfo");
            var subjectCard = cmp.get("v.subjectCard");

            var address = "--";
            if(!$A.util.isEmpty(patientInfo.AddressLine1) || !$A.util.isEmpty(patientInfo.AddressLine2) || !$A.util.isEmpty(patientInfo.City) || !$A.util.isEmpty(patientInfo.State) || !$A.util.isEmpty(patientInfo.Zip)){
                address = patientInfo.AddressLine1 + " " + patientInfo.AddressLine2 + "\n" + patientInfo.City + ", " + patientInfo.State +"\n" + patientInfo.Zip;
            }

            // US2917371 - Thanish - 7th Dec 2020
            var provider = "--";
            var providerPCP = cmp.get("v.pcpAssignment.providerPCP");
            var pcpFieldType = "outputText";
            var isLinkHover = false;
            providerPCP = providerPCP.trim();
            if($A.util.isEmpty(providerPCP) || providerPCP.includes("No PCP")){
                provider = "No PCP on file.";
            } else if(providerPCP.length > 20){
                provider = providerPCP.substring(0, 19) + "...";
                pcpFieldType = "hoverText";
                isLinkHover = true;
            } else {
                provider = providerPCP;
                pcpFieldType = "link";
            }

            var cardDetails = new Object();
            cardDetails.componentName = "Member Details";
            cardDetails.componentOrder = 2;
            cardDetails.noOfColumns = "slds-size_6-of-12";
            cardDetails.type = "card";
            cardDetails.caseItemsExtId = caseItemsExtId; // US3691233: Add missing fields/components to autodoc reporting - Krish - 11th Aug 2021
            cardDetails.allChecked = false;
            cardDetails.cardData = [
                {
                    "checked": true,
                    "disableCheckbox": true,
                    "defaultChecked": true,
                    "fieldName": "Name",
                    "fieldType": "outputText",
                    "fieldValue": ($A.util.isEmpty(patientInfo.fullName) ? "--" : patientInfo.fullName),
                    "showCheckbox": true,
                    "isReportable":true
                },
                {
                    "checked": true,
                    "disableCheckbox": true,
                    "defaultChecked": true,
                    "fieldName": "Member ID",
                    "fieldType": "outputText",
                    "fieldValue": ($A.util.isEmpty(patientInfo.MemberId) ? "--" : patientInfo.MemberId),
                    "showCheckbox": true,
                    "isReportable":true
                },
                {
                    "checked": false,
                    "defaultChecked": false,
                    "fieldName": "EEID",
                    "fieldType": "maskedText",
                    "fieldValue": ($A.util.isEmpty(subjectCard) || $A.util.isUndefinedOrNull(subjectCard) || $A.util.isEmpty(subjectCard.EEID)) ? "--" : subjectCard.maskedEEID, // DE373873 - Thanish - 8th Oct 2020
                    "unmaskedValue": ($A.util.isEmpty(subjectCard) || $A.util.isUndefinedOrNull(subjectCard) || $A.util.isEmpty(subjectCard.EEID)) ? "--" : subjectCard.EEID,
                    "showCheckbox": true,
                    "isReportable":true
                },
                {
                    "checked": false,
                    "defaultChecked": false,
                    "fieldName": "SSN",
                    "fieldType": "maskedText",
                    "fieldValue": ($A.util.isEmpty(subjectCard) || $A.util.isUndefinedOrNull(subjectCard) || $A.util.isEmpty(subjectCard.SSN)) ? "--" : subjectCard.maskedSSN, // DE373873 - Thanish - 8th Oct 2020
                    "unmaskedValue": ($A.util.isEmpty(subjectCard) || $A.util.isUndefinedOrNull(subjectCard) || $A.util.isEmpty(subjectCard.SSN)) ? "--" : subjectCard.SSN,
                    "showCheckbox": true,
                    "isReportable":true
                },
                {
                    "checked": true,
                    "disableCheckbox": true,
                    "defaultChecked": true,
                    "fieldName": "DOB",
                    "fieldType": "outputText",
                    "fieldValue": ($A.util.isEmpty(patientInfo.dob) ? "--" : patientInfo.dob),
                    "showCheckbox": true,
                    "isReportable":true
                },
                {
                    "checked": false,
                    "defaultChecked": false,
                    "fieldName": "Gender",
                    "fieldType": "outputText",
                    "fieldValue": ($A.util.isEmpty(patientInfo.gender) ? "--" : patientInfo.gender),
                    "showCheckbox": true,
                    "isReportable":true
                },
                {
                    "checked": false,
                    "defaultChecked": false,
                    "fieldName": "Phone",
                    "fieldType": "outputText",
                    "fieldValue": ($A.util.isEmpty(cmp.get("v.extendedCoverage.resultWrapper.policyRes.homeTelephoneNumber")) ? "--" : cmp.get("v.extendedCoverage.resultWrapper.policyRes.homeTelephoneNumber")),
                    "showCheckbox": true,
                    "isReportable":true // US3691233
                },
                {
                    "checked": false,
                    "defaultChecked": false,
                    "fieldName": "Address",
                    "fieldType": "formattedText",
                    "fieldValue": address,
                    "showCheckbox": true,
                    "isReportable":true //US3691233
                },
                {
                    "checked": false,
                    "defaultChecked": false,
                    "fieldName": "Email Address",
                    "fieldType": "unescapedHtml",
                    "fieldValue": cmp.get("v.strEmails") ? cmp.get("v.strEmails") : '--', // email address was not mapped!
                    "showCheckbox": true,
                    "isReportable":true // US3691233
                },
                {
                    "checked": false,
                    "defaultChecked": false,
                    "fieldType": "emptySpace",
                    "showCheckbox": false
                },
                {
                    "checked": false,
                    "defaultChecked": false,
                    "fieldName": "",
                    "fieldType": "customWidthText",
                    "fieldValue": "Primary Care Provider (PCP)",
                    "showCheckbox": false,
                    "width": "200%",
                    "fieldValueStyle": "font-weight: bold; font-size: 16px; color: #080707;"
                },
                {
                    "checked": false,
                    "defaultChecked": false,
                    "fieldType": "emptySpace",
                    "showCheckbox": false
                },
                {
                    "checked": false,
                    "defaultChecked": false,
                    "fieldName": "Provider",
                    "fieldType": pcpFieldType, // US2917371 - Thanish - 7th Dec 2020
                    "isLinkHover":isLinkHover, // US2917371 - Thanish - 7th Dec 2020
                    "fieldValue": providerPCP,
                    "popupId": "providerHover",
                    "alternateFieldValue": provider,
                    "description": providerPCP,
                    "showCheckbox": true,
                    "isReportable":true
                },
                {
                    "checked": false,
                    "defaultChecked": false,
                    "fieldName": "PCP History",
                    "fieldType": "link",
                    "fieldValue": "View History",
                    "showCheckbox": false
                }
            ];
            cardDetails.ignoreClearAutodoc = true; // DE456923 - Thanish - 30th Jun 2021
            cmp.set("v.cardDetails", cardDetails);
        }
    },

    // DE436023 - Thanish - 12th May 2021
    setEmptyCardData: function (cmp) {
        var cardDetails = new Object();
        cardDetails.componentName = "Member Details";
        cardDetails.componentOrder = 2;
        cardDetails.noOfColumns = "slds-size_6-of-12";
        cardDetails.type = "card";
        cardDetails.caseItemsExtId = "--";
        cardDetails.allChecked = false;
        cardDetails.cardData = [
            {
                "checked": true,
                "disableCheckbox": true,
                "defaultChecked": false,
                "fieldName": "Name",
                "fieldType": "outputText",
                "fieldValue": "--",
                "showCheckbox": true,
                "isReportable":true
            },
            {
                "checked": true,
                "disableCheckbox": true,
                "defaultChecked": false,
                "fieldName": "Member ID",
                "fieldType": "outputText",
                "fieldValue": "--",
                "showCheckbox": true,
                "isReportable":true
            },
            {
                "checked": false,
                "defaultChecked": false,
                "fieldName": "EEID",
                "fieldType": "outputText",
                "fieldValue": "--",
                "showCheckbox": true,
                "isReportable":true
            },
            {
                "checked": false,
                "defaultChecked": false,
                "fieldName": "SSN",
                "fieldType": "outputText",
                "fieldValue": "--",
                "showCheckbox": true,
                "isReportable":true
            },
            {
                "checked": true,
                "disableCheckbox": true,
                "defaultChecked": false,
                "fieldName": "DOB",
                "fieldType": "outputText",
                "fieldValue": "--",
                "showCheckbox": true,
                "isReportable":true
            },
            {
                "checked": false,
                "defaultChecked": false,
                "fieldName": "Gender",
                "fieldType": "outputText",
                "fieldValue": "--",
                "showCheckbox": true,
                "isReportable":true
            },
            {
                "checked": false,
                "defaultChecked": false,
                "fieldName": "Phone",
                "fieldType": "outputText",
                "fieldValue": "--",
                "showCheckbox": true
            },
            {
                "checked": false,
                "defaultChecked": false,
                "fieldName": "Address",
                "fieldType": "outputText",
                "fieldValue": "--",
                "showCheckbox": true
            },
            {
                "checked": false,
                "defaultChecked": false,
                "fieldName": "Email Address",
                "fieldType": "outputText",
                "fieldValue": '--',
                "showCheckbox": true
            },
            {
                "checked": false,
                "defaultChecked": false,
                "fieldType": "emptySpace",
                "showCheckbox": false
            },
            {
                "checked": false,
                "defaultChecked": false,
                "fieldName": "",
                "fieldType": "customWidthText",
                "fieldValue": "Primary Care Provider (PCP)",
                "showCheckbox": false,
                "width": "200%",
                "fieldValueStyle": "font-weight: bold; font-size: 16px; color: #080707;"
            },
            {
                "checked": false,
                "defaultChecked": false,
                "fieldType": "emptySpace",
                "showCheckbox": false
            },
            {
                "checked": false,
                "defaultChecked": false,
                "fieldName": "Provider",
                "fieldType": "outputText",
                "fieldValue": "--",
                "showCheckbox": true,
                "isReportable":true
            },
            {
                "checked": false,
                "defaultChecked": false,
                "fieldName": "PCP History",
                "fieldType": "outputText",
                "fieldValue": "--",
                "showCheckbox": false
            }
        ];
        cardDetails.ignoreClearAutodoc = true; // DE456923 - Thanish - 30th Jun 2021
        cmp.set("v.cardDetails", cardDetails);
    },

    showPCPHistory: function (cmp) {
        var appevent = $A.get("e.c:SAE_PCPHistoryEvent");
        appevent.setParams({
            "historyViewed": true,
            "transactionId": cmp.get("v.transactionId"),
            "originPage" : cmp.get("v.memberTabId")
        });
        appevent.fire();
    }
})