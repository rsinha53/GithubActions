({
    dateFormat : function(component, event, helper) {
        var denialStatusDate = component.get("v.data.denialStatusDate");
		var claimPostDate = component.get("v.data.claimPostDate");
        if(denialStatusDate != null || !typeof denialStatusDate === "undefined" || !denialStatusDate ===""){
            component.set("v.denialStatusDate",$A.localizationService.formatDate(denialStatusDate, "MM/dd/YYYY"));
        }
		if(claimPostDate != null || !typeof claimPostDate === "undefined" || !claimPostDate ===""){
            component.set("v.claimPostDate",$A.localizationService.formatDate(claimPostDate, "MM/dd/YYYY"));
        }
    },
	setAutodocCardData: function (cmp, event, helper) {
        var autodocCmp = _autodoc.getAutodocComponent(cmp.get("v.autodocUniqueId"), cmp.get("v.autodocUniqueIdCmp"), "claimsInfo");
        if(!$A.util.isEmpty(autodocCmp)){
            cmp.set("v.cardDetails", autodocCmp);
        }
		 if((!$A.util.isUndefinedOrNull(cmp.get("v.data.repaymentAmount")))){
            var repaymentAmount ='$'+(cmp.get("v.data.repaymentAmount"));
        }
        if((!$A.util.isUndefinedOrNull(cmp.get("v.data.submittedClaimAmount")))){
            var submittedClaimAmount ='$'+(cmp.get("v.data.submittedClaimAmount"));
        }
        if((!$A.util.isUndefinedOrNull(cmp.get("v.data.deniedClaimAmount")))){
            var deniedClaimAmount ='$'+(cmp.get("v.data.deniedClaimAmount"));
        }
         if((!$A.util.isUndefinedOrNull(cmp.get("v.data.pendingClaimAmount")))){
            var pendingClaimAmount ='$'+(cmp.get("v.data.pendingClaimAmount"));
        } 
        if((!$A.util.isUndefinedOrNull(cmp.get("v.data.paidClaimAmount")))){
            var paidClaimAmount ='$'+(cmp.get("v.data.paidClaimAmount"));
        } 
        if((!$A.util.isUndefinedOrNull(cmp.get("v.data.approvedClaimAmount")))){
            var approvedClaimAmount ='$'+(cmp.get("v.data.approvedClaimAmount"));
        } 
         var cardDetails = new Object();
            cardDetails.componentName = "Claims Details"+' ('+(cmp.get("v.data.claimNumber")+' - '+cmp.get("v.data.claimStatus"))+')';
            cardDetails.componentOrder = 2;
            cardDetails.noOfColumns = "slds-size_1-of-7";
            cardDetails.type = "card";
            cardDetails.allChecked = false;
            cardDetails.cardData = [
                {
                    "checked": false,
                    "disableCheckbox": false,
                    "defaultChecked": false,
                    "fieldName": "Claim Description",
                    "fieldType":"outputText",
                    "fieldValue": cmp.get("v.data.claimDescription") ,
                    "showCheckbox": true,
                    "isReportable":true
                },
                {
                    "checked": false,
                    "disableCheckbox": false,
                    "defaultChecked": false,
                    "fieldName": "Merchant Name",
                    "fieldType":"outputText",
                    "fieldValue": cmp.get("v.data.provider") ,
                    "showCheckbox": true,
                    "isReportable":true
                },
                {
                    "checked": false,
                    "disableCheckbox": false,
                    "defaultChecked": false,
                    "fieldName": "Claim Post Date",
                    "fieldType":"outputText",
                    "fieldValue": cmp.get("v.claimPostDate") ,
                    "showCheckbox": true,
                    "isReportable":true
                },
                {
                    "checked": false,
                    "disableCheckbox": false,
                    "defaultChecked": false,
                    "fieldName": "Payee",
                    "fieldType":"outputText",
                    "fieldValue": cmp.get("v.data.claimIncurredFor") ,
                    "showCheckbox": true,
                    "isReportable":true
                },
                {
                    "checked": false,
                    "disableCheckbox": false,
                    "defaultChecked": false,
                    "fieldName": "Recurring Claim",
                    "fieldType":"outputText",
                   // "fieldValue": cmp.get("v.data.") ,
                    "showCheckbox": true,
                    "isReportable":true
                },
                {
                    "checked": false,
                    "disableCheckbox": false,
                    "defaultChecked": false,
                    "fieldName": "Receipt Status",
                    "fieldType":"outputText",
                    "fieldValue": cmp.get("v.data.receiptStatus") ,
                    "showCheckbox": true,
                    "isReportable":true
                },
                {
                    "checked": false,
                    "disableCheckbox": false,
                    "defaultChecked": false,
                    "fieldName": "Receipt Received*",
                    "fieldType":"outputText",
                    //"fieldValue": cmp.get("v.data.") ,
                    "showCheckbox": true,
                    "isReportable":true
                },
              
             // second row
               
                {
                    "checked": false,
                    "disableCheckbox": false,
                    "defaultChecked": false,
                    "fieldName": "Repayment Status",
                    "fieldType":"outputText",
                    "fieldValue": cmp.get("v.data.repaymentStatus") ,
                    "showCheckbox": true,
                    "isReportable":true
                },
                {
                    "checked": false,
                    "disableCheckbox": false,
                    "defaultChecked": false,
                    "fieldName": "Repayment Amount",
                    "fieldType":"outputText",
                    "fieldValue": repaymentAmount,
                    "showCheckbox": true,
                    "isReportable":true
                },
                {
                    "checked": false,
                    "disableCheckbox": false,
                    "defaultChecked": false,
                    "fieldName": "Repayment EFT Flag",
                    "fieldType":"outputText",
                    "fieldValue": cmp.get("v.data.repaymentEftFlag") ,
                    "showCheckbox": true,
                    "isReportable":true
                },
                {
                    "checked": false,
                    "disableCheckbox": false,
                    "defaultChecked": false,
                    "fieldName": "Denial Reason",
                    "fieldType":"outputText",
                    "fieldValue": cmp.get("v.data.reasonForDenial") ,
                    "showCheckbox": true,
                    "isReportable":true
                },
                {
                    "checked": false,
                    "disableCheckbox": false,
                    "defaultChecked": false,
                    "fieldName": "Denial Status Date",
                    "fieldType":"outputText",
                    "fieldValue": cmp.get("v.denialStatusDate") ,
                    "showCheckbox": true,
                    "isReportable":true
                },
                {
                    "checked": false,
                    "disableCheckbox": false,
                    "defaultChecked": false,
                    "fieldName": "Image ID*",
                    "fieldType":"outputText",
                    //"fieldValue": cmp.get("v.data.") ,
                    "showCheckbox": true,
                    "isReportable":true
                },
                //three row
                {
                    "checked": false,
                    "disableCheckbox": false,
                    "defaultChecked": false,
                    "fieldName": "Effective Date of Service",
                    "fieldType":"outputText",
                    "fieldValue": cmp.get("v.data.claimDateofServiceEffectiveDate") ,
                    "showCheckbox": true,
                    "isReportable":true
                },
                {
                    "checked": false,
                    "disableCheckbox": false,
                    "defaultChecked": false,
                    "fieldName": "Submitted Amount",
                    "fieldType":"outputText",
                    "fieldValue": submittedClaimAmount ,
                    "showCheckbox": true,
                    "isReportable":true
                },
                {
                    "checked": false,
                    "disableCheckbox": false,
                    "defaultChecked": false,
                    "fieldName": "Denial Amount",
                    "fieldType":"outputText",
                    "fieldValue": deniedClaimAmount,
                    "showCheckbox": true,
                    "isReportable":true
                },
                {
                    "checked": false,
                    "disableCheckbox": false,
                    "defaultChecked": false,
                    "fieldName": "Pending Amount",
                    "fieldType":"outputText",
                    "fieldValue": pendingClaimAmount,
                    "showCheckbox": true,
                    "isReportable":true
                },
                {
                    "checked": false,
                    "disableCheckbox": false,
                    "defaultChecked": false,
                    "fieldName": "Paid Amount",
                    "fieldType":"outputText",
                    "fieldValue": paidClaimAmount,
                    "showCheckbox": true,
                    "isReportable":true
                },
                {
                    "checked": false,
                    "disableCheckbox": false,
                    "defaultChecked": false,
                    "fieldName": "Approved Amount",
                    "fieldType":"outputText",
                    "fieldValue": approvedClaimAmount,
                    "showCheckbox": true,
                    "isReportable":true
                }
                
                ];
                cmp.set("v.cardDetails", cardDetails);

    },
    autoDenialHistory:function(cmp, event, helper) {
        var autoDocTabData = cmp.get("v.data");
        var denialDetails = [];
        var details={denialStatusDate:cmp.get("v.denialStatusDate")
                     ,reasonForDenial:cmp.get("v.data.reasonForDenial")
                     ,denialby:''
                     ,deniedClaimAmount:cmp.get("v.data.deniedClaimAmount")
                     ,status:''
                    };
         denialDetails.push(details);
         var action = cmp.get('c.getAutoDocDenialHis');
         action.setParams({
            "denialHis": denialDetails
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            var responseValue = JSON.stringify(response.getReturnValue());
            if ((state === "SUCCESS")){
                cmp.set("v.denialHistory" ,response.getReturnValue());
           }
        });
        $A.enqueueAction(action);
        
        }

})