({
	getMAndRProviderStatus: function (cmp, createSrnNetworkStatusRequestParams) {

		cmp.set("v.showSpinner", true);

		let action = cmp.get("c.getMAndRProviderStatus");
		action.setParams({
			"providerId": createSrnNetworkStatusRequestParams.providerId,
			"taxId": createSrnNetworkStatusRequestParams.taxId,
			"addressId": createSrnNetworkStatusRequestParams.addressId,
			"cosDiv": createSrnNetworkStatusRequestParams.cosmosDiv,
            "provDiv" : createSrnNetworkStatusRequestParams.providerDiv, //US3574032
			"cosPanNum": createSrnNetworkStatusRequestParams.cosmosPanelNbr,
			"coverageStartDate": createSrnNetworkStatusRequestParams.coverageStartDate, // US3244384 - Sarma
			"coverageEndDate": createSrnNetworkStatusRequestParams.coverageEndDate // US3244384 - Sarma
		});

		action.setCallback(this, function (response) {
			if (response.getState() === "SUCCESS") {

				let mnrProviderStatus = response.getReturnValue();

				let returnedStatus = '--';

                if(!$A.util.isUndefinedOrNull(mnrProviderStatus) && !$A.util.isUndefinedOrNull(mnrProviderStatus.mnrCardDetails) && !$A.util.isUndefinedOrNull(mnrProviderStatus.mnrCardDetails.cardData)){
                    let cardData =  mnrProviderStatus.mnrCardDetails.cardData;

                    for(let i=0; i<cardData.length; i++){
                    	if(cardData[i].fieldName == 'Status'){
                    		returnedStatus = cardData[i].fieldValue;
                    	}
                    }
                }

				let srnProviderDetailObject = cmp.get('v.srnProviderDetailObject');
				srnProviderDetailObject.hscProviderDetails.networkStatusTypeDesc = returnedStatus;

				if (returnedStatus == 'INN') {
					srnProviderDetailObject.hscProviderDetails.networkStatusType = '1';
				} else if (returnedStatus == 'ONN') {
					srnProviderDetailObject.hscProviderDetails.networkStatusType = '2';
				}
				cmp.set('v.srnProviderDetailObject', srnProviderDetailObject);
			} else {

			}

			cmp.set("v.showSpinner", false);
		});
		$A.enqueueAction(action);
	},

	getEAndIProviderStatus: function (cmp, createSrnNetworkStatusRequestParams) {

		cmp.set("v.showSpinner", true);

		let action = cmp.get("c.getNetworkKeyStatus");
		action.setParams({
			"subscriberId": createSrnNetworkStatusRequestParams.subscriberID,
			"policyNumber": createSrnNetworkStatusRequestParams.policyNumber,
			"sourceCode": createSrnNetworkStatusRequestParams.sourceCode,
			"coverageLevel": createSrnNetworkStatusRequestParams.coverageLevelNum
		});

		action.setCallback(this, function (response) {
			if (response.getState() === "SUCCESS") {

				let returnValue = response.getReturnValue();

				if (returnValue.success) {

					if (returnValue.callENIContracts) {
						let actionENI = cmp.get("c.getEAndIProviderStatus");
						actionENI.setParams({
							"providerId": createSrnNetworkStatusRequestParams.providerId,
							"taxId": createSrnNetworkStatusRequestParams.taxId,
							"addressSeq": createSrnNetworkStatusRequestParams.addressSequence,
							"marketType": createSrnNetworkStatusRequestParams.marketType,
							"marketSite": createSrnNetworkStatusRequestParams.marketSite,
							"insTypeCode": createSrnNetworkStatusRequestParams.insuranceTypeCode,
							"networkKey": returnValue.networkKey
						});

						actionENI.setCallback(this, function (response) {

							if (response.getState() === "SUCCESS") {
								let eniResponse = response.getReturnValue();

								if (eniResponse.success) {

									let returnedStatus = '--';

									if(!$A.util.isUndefinedOrNull(eniResponse) && !$A.util.isUndefinedOrNull(eniResponse.eniCardDetails) && !$A.util.isUndefinedOrNull(eniResponse.eniCardDetails.cardData)){
										let cardData =  eniResponse.eniCardDetails.cardData;

										for(let i=0; i<cardData.length; i++){
											if(cardData[i].fieldName == 'Status'){
												returnedStatus = cardData[i].fieldValue;
											}
										}
									}


									let srnProviderDetailObject = cmp.get('v.srnProviderDetailObject');
									srnProviderDetailObject.hscProviderDetails.networkStatusTypeDesc = returnedStatus;

									if (returnedStatus == 'INN') {
										srnProviderDetailObject.hscProviderDetails.networkStatusType = '1';
									} else if (returnedStatus == 'ONN') {
										srnProviderDetailObject.hscProviderDetails.networkStatusType = '2';
									}
									cmp.set('v.srnProviderDetailObject', srnProviderDetailObject);
								}
							}

							cmp.set("v.showSpinner", false);
						});
						$A.enqueueAction(actionENI);
					}
				}
				cmp.set("v.showSpinner", false);
			}
			cmp.set("v.showSpinner", false);
		});
		$A.enqueueAction(action);
	},

	// US2971523
	fireRoleChangesEvent: function (cmp, event) {
		var compEvent = cmp.getEvent("CreateSRNProviderRoleActionEvent");
		compEvent.fire();
	},

	// US2971523
	executeValidations: function (cmp, event) {

		var srnProviderDetailObject = cmp.get('v.srnProviderDetailObject');

		if (srnProviderDetailObject.isShowProviderDetails) {

			cmp.set('v.hasErrors', false);

			var isProviderPCP = cmp.get('v.isProviderPCP');
			var isProviderFacility = cmp.get('v.isProviderFacility');
			var isProviderAttending = cmp.get('v.isProviderAttending');
			var isProviderRequesting = cmp.get('v.isProviderRequesting');
			var isProviderAdmitting = cmp.get('v.isProviderAdmitting');
			var isProviderServicing = cmp.get('v.isProviderServicing');

			if (!isProviderPCP && !isProviderFacility && !isProviderAttending && !isProviderRequesting &&
				!isProviderAdmitting && !isProviderServicing) {
				cmp.set('v.hasErrors', true);
			}

			//US3507481 Swapnil
			var SRNData= cmp.get('v.SRNData');
			var procedureData= SRNData.RequiredInfo.ProcedureData;
			var srnProviderDetailList = cmp.get('v.srnProviderDetailList');
			var servicingCounter= 0;
			for(var i in srnProviderDetailList) {
				var providerRoles= srnProviderDetailList[i].providerRoleDetails;
				if(providerRoles.isProviderServicing) {
					servicingCounter++;
					break;
				}
			}
			if( servicingCounter == 0 ) {
				for(var i in procedureData){
					if(! (procedureData[i].ProcedureCode == "") ) {
						cmp.set('v.hasServicingError',true);
						cmp.set('v.isServicingRequired',true);
						break;
					}
				}
		 	} else {
				cmp.set('v.hasServicingError',false);
				cmp.set('v.isServicingRequired',false);
			} // US3507481
		}
	},

	// US3507490	Mapping for Contract Org Type and Amendment Sarma - 19th May 2021
	getAdditionalProviderDetails: function (cmp,  helper) {

		let action = cmp.get("c.getProviderData");
		let providerDetails = cmp.get("v.srnProviderDetailObject");
		action.setParams({
			"providerId": providerDetails.createSrnNetworkStatusRequestParams.providerId,
			"taxId" : providerDetails.createSrnNetworkStatusRequestParams.taxId,
			"adrseq" : providerDetails.createSrnNetworkStatusRequestParams.addressSequence
		});
		action.setCallback(this, function (response) {
			if (response.getState() === "SUCCESS") {

				 let detailResponse = response.getReturnValue();
				 if (detailResponse.isSuccess) {
					providerDetails.hscProviderDetails.providerContractAmendments = detailResponse.providerContractAmendments;
					cmp.set('v.srnProviderDetailObject',providerDetails);
	}

			} else {

			}
		});
		$A.enqueueAction(action);
	},

	showSpinner: function (cmp) {
        var spinner = cmp.find("create-auth-provider-spinner");
        $A.util.removeClass(spinner, "slds-hide");
        $A.util.addClass(spinner, "slds-show");
    },

    hideSpinner: function (cmp) {
        var spinner = cmp.find("create-auth-provider-spinner");
        $A.util.removeClass(spinner, "slds-show");
        $A.util.addClass(spinner, "slds-hide");
    },

})