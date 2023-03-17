({
	errorMsg500 : "Unexpected Error Occurred on the OON Reimbursement card. Please try again. If problem persists please contact the help desk.",

	getDefaultCard : function(cmp) {
		var cardDetails = new Object();
		cardDetails.componentName = "Out of Network Reimbursement";
		cardDetails.componentOrder = cmp.get("v.componentOrder");
		cardDetails.noOfColumns = "slds-size_12-of-12";
		cardDetails.type = "card";
		cardDetails.allChecked = false;
		cardDetails.cardData = [
			{
				"checked": false,
				"fieldName": "",
				"fieldType": "noFieldName",
				"fieldValue": "Fee Schedule Lookup for this type is unavailable. Based on the member's reimbursement type, follow your standard process for Out of Network reimbursement research.",
				"showCheckbox": true
			}
		];
		return cardDetails;
	},

	loadCardDetails : function(cmp) {
		var cardDetails = cmp.get("v.cardDetails");
		if($A.util.isEmpty(cardDetails)){
			cardDetails = this.getDefaultCard(cmp);
			switch(cmp.get("v.sourceCode")){
				case 'CO':
					cardDetails.cardData.unshift({
						"checked": false,
						"fieldName": "",
						"fieldType": "noFieldName",
						"fieldValue": "Member Reimbursement Type: Out of Network reimbursement is based on Medicare Allowable.",
						"showCheckbox": true
					});
					cmp.set("v.cardDetails", cardDetails);
					break;
				case 'CS':
					this.getBenefitId(cmp);
					break;
				case 'AP':
					cardDetails.cardData.unshift({
						"checked": false,
						"fieldName": "",
						"fieldType": "noFieldName",
						"fieldValue": "Member Reimbursement Type: Out of Network reimbursement is based on the state fee schedule.",
						"showCheckbox": true
					});
					cmp.set("v.cardDetails", cardDetails);
					break;
				default:
					cmp.set("v.cardDetails", cardDetails);
			}

			this.setCardData(cmp);
		}
	},

	getBenefitId: function(cmp){
		cmp.set("v.showSpinner", true);
		var transactionId = cmp.get("v.transactionId");
		var action = cmp.get("c.getBenefitId");
		action.setParams({
			"transactionId": ($A.util.isEmpty(transactionId) ? "" : transactionId)
		});
		action.setCallback(this, function (response) {
			if(response.getState() === "SUCCESS") {
				var returnWrapper = response.getReturnValue();
				if(returnWrapper.statusCode == 200 && !$A.util.isEmpty(returnWrapper.benefitId)){
					this.getENIReimbursement(cmp, returnWrapper.benefitId, transactionId);
				} else{
					var cardDetails = this.getDefaultCard(cmp);
					cardDetails.cardData.unshift({
						"checked": false,
						"fieldName": "",
						"fieldType": "noFieldName",
						"fieldValue": "Member Reimbursement Type: --",
						"showCheckbox": true
					});
					cmp.set("v.cardDetails", cardDetails);
					cmp.set("v.showSpinner", false);
				}
				// error code handling
				if(returnWrapper.statusCode == 500 || returnWrapper.statusCode == 400){
					this.fireToastMessage("We hit a snag.", this.errorMsg500, "error", "dismissible", "30000");
				}
			} else {
				var cardDetails = this.getDefaultCard(cmp);
				cardDetails.cardData.unshift({
					"checked": false,
					"fieldName": "",
					"fieldType": "noFieldName",
					"fieldValue": "Member Reimbursement Type: --",
					"showCheckbox": true
				});
				cmp.set("v.cardDetails", cardDetails);
				cmp.set("v.showSpinner", false);
			}

			this.setCardData(cmp);
		});
		$A.enqueueAction(action);
	},

	getENIReimbursement: function(cmp, benefitId, transactionId){
		cmp.set("v.showSpinner", true);
		var action = cmp.get("c.getENIReimbursement");
		action.setParams({
			"transactionId": transactionId,
			"benefitCode": benefitId
		});
		action.setCallback(this, function (response) {
			var cardDetails = this.getDefaultCard(cmp);
			if(response.getState() === "SUCCESS") {
				var returnWrapper = response.getReturnValue();
				if(returnWrapper.statusCode == 200){
					cardDetails.cardData.unshift({
						"checked": false,
						"fieldName": "",
						"fieldType": "noFieldName",
						"fieldValue": "Member Reimbursement Type: " + returnWrapper.benefitDetails,
						"showCheckbox": true
					});
				} else{
					cardDetails.cardData.unshift({
						"checked": false,
						"fieldName": "",
						"fieldType": "noFieldName",
						"fieldValue": "Member Reimbursement Type: --",
						"showCheckbox": true
					});
				}
				// error code handling
				if(returnWrapper.statusCode == 500 || returnWrapper.statusCode == 400){
					this.fireToastMessage("We hit a snag.", this.errorMsg500, "error", "dismissible", "30000");
				}
			} else{
				cardDetails.cardData.unshift({
					"checked": false,
					"fieldName": "",
					"fieldType": "noFieldName",
					"fieldValue": "Member Reimbursement Type: --",
					"showCheckbox": true
				});
			}
			cmp.set("v.cardDetails", cardDetails);
			cmp.set("v.showSpinner", false);

			this.setCardData(cmp);
		});
		$A.enqueueAction(action);
	},

	fireToastMessage: function (title, message, type, mode, duration) {
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

	setCardData: function (cmp){
		var cardDetails = cmp.get("v.cardDetails");
		window.setTimeout(
            $A.getCallback(function () {
                if(!$A.util.isEmpty(cardDetails)){
					if (cmp.get("v.isLookup") && !$A.util.isEmpty(cmp.get("v.selectedRowData"))) {
						var caseItemsExtId = cmp.get("v.selectedRowData").caseItemsExtId;
						cardDetails.caseItemsExtId = caseItemsExtId;
						cardDetails.cardData.forEach(field => {
							field.isReportable = true;
							if(field.fieldValue.includes('Member Reimbursement Type:')){
								field.fieldName = 'Member Reimbursement Type';
							}
						});
						cmp.set("v.cardDetails",cardDetails);
					}
				}
            }), 1000
        );

    }
})