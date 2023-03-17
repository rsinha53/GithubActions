({
    //  US2728364: Auto Doc: Member Snapshot - Have Provider Card Included in Eligibility Auto Doc Automatically - Krish - 6th July 2021
    setAutodocCardData : function(cmp) {
        var providerStatus = cmp.get("v.providerStatus");
        var CSPProviderId = cmp.get("v.CSPProviderId");        
        var interactionCard = cmp.get("v.interactionCard");
        var providerFullName = '';
        var providerComponentName = '';
        var policyDetails = cmp.get('v.policyDetails');
        if(!$A.util.isUndefinedOrNull(interactionCard) && !$A.util.isEmpty(interactionCard)){
            providerFullName = interactionCard.firstName + ' ' + interactionCard.lastName;
            providerComponentName = 'Provider: '+ ($A.util.isEmpty(providerFullName) ? "" : providerFullName);
        }
        
        // US3691233: Add missing fields/components to autodoc reporting - Krish - 11th Aug 2021
        var memberCardData = cmp.get('v.memberCardData'); // Using Member Id from Eligibility for proper case items linking
        var caseItemsExtId = '';
        var sourceCode = '';
        var groupNumber = '';
        var memberId = '';
        var policySelectedIndex = cmp.get("v.policySelectedIndex");
        if(!$A.util.isUndefinedOrNull(policyDetails) && !$A.util.isUndefinedOrNull(policyDetails.resultWrapper) && !$A.util.isUndefinedOrNull(policyDetails.resultWrapper.policyRes)){
            var policyRes = policyDetails.resultWrapper.policyRes;
            groupNumber = !$A.util.isUndefinedOrNull(policyRes.groupNumber) ? policyRes.groupNumber : '';
            // Trim Leading 0s
            if(groupNumber.length > 0 && groupNumber.charAt(0) == '0'){
                groupNumber = groupNumber.substring(1);
            }
            sourceCode = !$A.util.isUndefinedOrNull(policyRes.sourceCode) ? policyRes.sourceCode :''; 
        }
        if(!$A.util.isUndefinedOrNull(memberCardData) && !$A.util.isUndefinedOrNull(memberCardData.CoverageLines) && memberCardData.CoverageLines.length > 0){
            memberId = !$A.util.isUndefinedOrNull(memberCardData.CoverageLines[policySelectedIndex].patientInfo.MemberId) ? memberCardData.CoverageLines[policySelectedIndex].patientInfo.MemberId : '' ;
        }
        caseItemsExtId = groupNumber + '/' + sourceCode + '/' + memberId;
        console.log('Provider Card: caseItemsExtId: '+JSON.stringify(caseItemsExtId));
        // Forming the autodoc card
        var cardDetails = new Object();
        cardDetails.componentName = providerComponentName;
        cardDetails.componentOrder = 1.5; // This is to keep it in second position after policy card. Do not change
        cardDetails.noOfColumns = "slds-size_6-of-12";
        cardDetails.type = "card";
        cardDetails.caseItemsExtId = caseItemsExtId; // US3691233: Add missing fields/components to autodoc reporting - Krish - 11th Aug 2021
        cardDetails.allChecked = false;
        cardDetails.ignoreClearAutodoc = true; // US3698810: Default autodoc after save case
        cardDetails.cardData = [
            // US3691233: Add missing fields/components to autodoc reporting - Krish - 11th Aug 2021
            {
                "checked": true,
                "disableCheckbox": true,
                "defaultChecked": true,
                "fieldName": "Name",
                "fieldType": "outputText",
                "fieldValue": ($A.util.isEmpty(providerFullName) ? "--" : providerFullName),
                "showCheckbox": true,
                "isReportable": (!$A.util.isEmpty(providerFullName)),
                "hideField" : true,
            },
            {
                "checked": true,
                "disableCheckbox": true,
                "defaultChecked": true,
                "fieldName": "Tax ID (TIN)",
                "fieldType": "outputText",
                "fieldValue": ($A.util.isEmpty(interactionCard.taxId) ? "--" : interactionCard.taxId),
                "showCheckbox": true,
                "isReportable":true
            },
            {
                "checked": true,
                "disableCheckbox": true,
                "defaultChecked": true,
                "fieldName": "CSP Provider ID",
                "fieldType": "outputText",
                "fieldValue": ($A.util.isEmpty(CSPProviderId) ? "--" : CSPProviderId),
                "showCheckbox": true,
                "isReportable":true
            },
            {
                "checked": true,
                "disableCheckbox": true,
                "defaultChecked": true,
                "fieldName": "NPI",
                "fieldType": "outputText",
                "fieldValue": ($A.util.isEmpty(interactionCard.npi) ? "--" : interactionCard.npi),
                "showCheckbox": true,
                "isReportable":true
            },
            {
                "checked": true,
                "disableCheckbox": true,
                "defaultChecked": true,
                "fieldName": "Phone #",
                "fieldType": "outputText",
                "fieldValue": ($A.util.isEmpty(interactionCard.phone) ? "--" : interactionCard.phone),
                "showCheckbox": true,
                "isReportable":true
            },
            {
                "checked": true,
                "disableCheckbox": true,
                "defaultChecked": true,
                "fieldName": "Primary Specialty",
                "fieldType": "outputText",
                "fieldValue": ($A.util.isEmpty(interactionCard.primarySpeaciality) ? "--" : interactionCard.primarySpeaciality),
                "showCheckbox": true,
                "isReportable":true
            },
            {
                "checked": true,
                "disableCheckbox": true,
                "defaultChecked": true,
                "fieldName": "Contact Name",
                "fieldType": "outputText",
                "fieldValue": ($A.util.isEmpty(interactionCard.contactName) ? "--" : interactionCard.contactName),
                "showCheckbox": true,
                "isReportable":true
            },
            {
                "checked": true,
                "disableCheckbox": true,
                "defaultChecked": true,
                "fieldName": "Contact Number",
                "fieldType": "outputText",
                "fieldValue": ($A.util.isEmpty(interactionCard.contactNumber) ? "--" : interactionCard.contactNumber),
                "showCheckbox": true,
                "isReportable":true
            },
            {
                "checked": true,
                "disableCheckbox": true,
                "defaultChecked": true,
                "fieldName": "Ext",
                "fieldType": "outputText",
                "fieldValue": ($A.util.isEmpty(interactionCard.contactExt) ? "--" : interactionCard.contactExt),
                "showCheckbox": true,
                "isReportable":true
            },
            {
                "checked": true,
                "disableCheckbox": true,
                "defaultChecked": true,
                "fieldName": "Status",
                "fieldType": "outputText",
                "fieldValue": ($A.util.isEmpty(providerStatus) ? "--" : providerStatus),
                "showCheckbox": true,
                "isReportable":true
            }
        ];
        _autodoc.setAutodoc(cmp.get("v.autodocUniqueId"), cmp.get("v.policySelectedIndex"), cardDetails);
    }
})