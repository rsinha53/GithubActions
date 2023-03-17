({
	getMAndRProviderStatus : function(component) {
		component.set("v.showSpinner", true);
		// US3244384 Integration for Member Div to Provider Div Mapping - Sarma - 02/03/2021
		// Hard coded Div translation logic & 2nd server callout removed
		let filterParameters = component.get("v.filterParameters");
		let contractApiParameters = component.get("v.contractApiParameters");

        let action2 = component.get("c.getMAndRProviderStatus");
        action2.setParams({
            "providerId": contractApiParameters.providerId,
            "taxId": contractApiParameters.taxId,
            "addressId": contractApiParameters.addressId,
			"cosDiv": filterParameters.cosmosDiv,
			"cosPanNum": filterParameters.cosmosPanelNbr,
			"coverageStartDate": filterParameters.coverageStartDate,
			"coverageEndDate": filterParameters.coverageEndDate,
            "provDiv" : filterParameters.providerDiv //US3574032
        });

        action2.setCallback(this, function (response2) {
            if(response2.getState() === "SUCCESS") {
                if (!response2.getReturnValue().success) {
                    // US3291595 - Err Code handling
                    this.fireToastMessage();
                }
                let mnrProviderStatus = response2.getReturnValue();
                let cardDetails = mnrProviderStatus.mnrCardDetails;
				// US3691213
				if (component.get("v.isLookup")) {
					var caseItemsExtId = component.get("v.selectedRowData").caseItemsExtId;
					cardDetails.caseItemsExtId = caseItemsExtId;
					cardDetails.reportingHeader = 'Provider Status';
					cardDetails.cardData.forEach(field => {
						field.isReportable = true;
					});
				}
                cardDetails.cardData.forEach(function(data){
                    if(data.fieldName == "DIV"){
                        data.iconText = filterParameters.cosmosDiv;
                        //US3574032
                        /*if (filterParameters.cosmosDiv == "ATL" || filterParameters.cosmosDiv == "KEN" || filterParameters.cosmosDiv == "KLC" ||
                            filterParameters.cosmosDiv == "MNR" || filterParameters.cosmosDiv == "NTL" || filterParameters.cosmosDiv == "OEB" ||
                            filterParameters.cosmosDiv == "STL")*/
                        if(filterParameters.providerDiv == "MNR"){
                            component.set("v.isMNRDiv", true);
                        }
                    }
                    if (data.fieldName == 'Status' && data.fieldValue == 'OON') {
                        component.set("v.isOON", true);
                    }
                });
                mnrProviderStatus.mnrCardDetails = cardDetails;
                component.set("v.mnrProviderStatus", mnrProviderStatus);

                var claimNo = component.get("v.claimNo");
                var maxAutoDocComponents = component.get("v.maxAutoDocComponents");
                var currentIndexOfOpenedTabs = component.get("v.currentIndexOfOpenedTabs");

                if(component.get("v.isClaim")){
                    cardDetails.componentName="Provider Status: "+claimNo;
                    cardDetails.componentOrder=20.07+(maxAutoDocComponents*currentIndexOfOpenedTabs);

                 }

            } else {
                // US3291595 - Err Code handling
                this.fireToastMessage();
            }
			component.set("v.showSpinner", false);
        });
        $A.enqueueAction(action2);

	},

	getEAndINewProviderStatus: function(cmp,helper){
        let eniData = cmp.get("v.ENIAllData");
        var matchedData = [];
        if(!$A.util.isEmpty(eniData)){
            if(eniData && eniData != '{}' && (eniData[0].rowColumnData[0].fieldLabel != "NO RECORDS")){
                matchedData = eniData.filter(function (row) {
                    let marketSite = row.rowColumnData[5].fieldValue.split("-");
                    return ( 'ALL PRODUCTS' == row.rowColumnData[3].fieldValue && ( '8888888'  == marketSite[0]   ||  '8777777'  == marketSite[0]) );

                });
            }
        }
        console.log('=matchedData='+JSON.stringify(matchedData));

        if( !$A.util.isEmpty(matchedData) ){
          helper.getEIbyContractStatus(cmp,matchedData);
        }
        else{
          helper.getEAndIProviderStatus(cmp);
        }


    },

    getEIbyContractStatus: function(cmp,matchedData){
        cmp.set("v.showSpinner", true);
        var effDate = matchedData[0].rowColumnData[7].fieldValue;

        let filterParameters = cmp.get("v.filterParameters");
		let contractApiParameters = cmp.get("v.contractApiParameters");

        let eniProviderStatus = {
			"eniCardDetails": {
				"componentName": "Provider Status ("+ effDate + ")",
				"reportingHeader":"Provider Status",
				"componentOrder": 7,
				"noOfColumns": "slds-size_1-of-10",
				"type": "card",
				"cardData": [
				  {
					"checked": false,
					"defaultChecked": false,
					"fieldName": "Status",
					"fieldType": "outputText",
					"fieldValue": "INN",
						"showCheckbox": true,
						"isReportable": true
				  },
				  {
					"checked": false,
					"defaultChecked": false,
					"fieldName": "Network Key",
					"fieldType": "outputText",
					"fieldValue": "--",
						"showCheckbox": true,
						"isReportable": true
				  },
				  {
					"checked": false,
					"defaultChecked": false,
					"fieldName": "Product",
					"fieldType": "iconWithText",
                      "fieldValue": "Match",
  				     "iconName": "action:approval",
					"iconText": filterParameters.productType,
						"showCheckbox": true,
						"isReportable": true
				  },
				  {
					"checked": false,
					"defaultChecked": false,
					"fieldName": "Market Type",
					"fieldType": "iconWithText",
                     "fieldValue": "Match",
  				     "iconName": "action:approval",
					"iconText": filterParameters.marketType,
						"showCheckbox": true,
						"isReportable": true
				  },
				  {
					"checked": false,
					"defaultChecked": false,
					"fieldName": "Market",
					"fieldType": "iconWithText",
                      "fieldValue": "Match",
  				     "iconName": "action:approval",
					"iconText": filterParameters.marketSite,
						"showCheckbox": true,
						"isReportable": true
				  },
				  {
					"checked": false,
					"defaultChecked": false,
					"fieldName": "IPA",
					"fieldType": "iconWithText",
                    "fieldValue": "Match",
  				    "iconName": "action:approval",
					"iconText": cmp.get('v.memberIPAValue'),
						"showCheckbox": true,
						"isReportable": true
				  }
				]
			}
		};

		// US3691213
		if (cmp.get("v.isLookup")) {
			var caseItemsExtId = cmp.get("v.selectedRowData").caseItemsExtId;
			eniProviderStatus.eniCardDetails.caseItemsExtId = caseItemsExtId;
		}
        cmp.set("v.eniProviderStatus", eniProviderStatus);
        cmp.set("v.showSpinner", false);

    },

	getEAndIProviderStatus : function(component) {
		component.set("v.showSpinner", true);
		
		let filterParameters = component.get("v.filterParameters");
		let contractApiParameters = component.get("v.contractApiParameters");

		let actionNetworkKey = component.get("c.getNetworkKeyStatus");
		actionNetworkKey.setParams({
			"subscriberId": filterParameters.subscriberID,
			"policyNumber": filterParameters.policyNumber,
			"sourceCode": component.get("v.sourceCode"),
			"coverageLevel": filterParameters.coverageLevelNum,
			"coverageStartDate": filterParameters.coverageStartDate, // US3308070 - Thanish - 2nd Mar 2021
			"isTermedPolicy": filterParameters.isTermedPolicy // US3308070 - Thanish - 2nd Mar 2021
		});
		actionNetworkKey.setCallback(this, function (response) {
			if(response.getState() === "SUCCESS") {
				let returnValue = response.getReturnValue();

				if(returnValue.success){
					if(returnValue.callENIContracts){
						let actionENI = component.get("c.getEAndIProviderStatusNew");
						actionENI.setParams({
							"providerId": contractApiParameters.providerId,
							"taxId": contractApiParameters.taxId,
							"addressSeq": contractApiParameters.addressSeq,
							"marketType": filterParameters.marketType,
							"marketSite": filterParameters.marketSite,
							"insTypeCode": filterParameters.insuranceTypeCode,
							"networkKey": returnValue.networkKey,
                            "ipaValue" : filterParameters.selectedIPAValue
						});
						actionENI.setCallback(this, function (response) {

							if(response.getState() === "SUCCESS") {
								let eniResponse = response.getReturnValue();

								if(eniResponse.success){
									// US3691213
									if (component.get("v.isLookup")) {
										var caseItemsExtId = component.get("v.selectedRowData").caseItemsExtId;
										eniResponse.eniCardDetails.caseItemsExtId = caseItemsExtId;
										eniResponse.eniCardDetails.reportingHeader = 'Provider Status';
										eniResponse.eniCardDetails.cardData.forEach(field => {
											field.isReportable = true;
										});
									}
									component.set("v.eniProviderStatus", eniResponse);

                                    var claimNo = component.get("v.claimNo");
                                    var maxAutoDocComponents = component.get("v.maxAutoDocComponents");
                                    var currentIndexOfOpenedTabs = component.get("v.currentIndexOfOpenedTabs");

                                    if(component.get("v.isClaim")){
                                        var eniProviderStatus=component.get("v.eniProviderStatus");
                                        eniProviderStatus.eniCardDetails.componentName=eniProviderStatus.eniCardDetails.componentName+": "+claimNo;
                                        eniProviderStatus.eniCardDetails.autodocHeaderName=eniProviderStatus.eniCardDetails.autodocHeaderName+": "+claimNo;
                                        eniProviderStatus.eniCardDetails.componentOrder=20.07+(maxAutoDocComponents*currentIndexOfOpenedTabs);
                                    }

                                    if(!$A.util.isUndefinedOrNull(eniResponse) && !$A.util.isUndefinedOrNull(eniResponse.eniCardDetails) &&
                                       !$A.util.isUndefinedOrNull(eniResponse.eniCardDetails.cardData) &&  !$A.util.isUndefinedOrNull(filterParameters.productType)){
										let cardData =  eniResponse.eniCardDetails.cardData;

                                        for(let i=0; i<cardData.length; i++){
                                            if(cardData[i].fieldName == 'Status' && cardData[i].fieldValue == 'OON'){
                                                component.set("v.isOON",true);
                                            }
                                            if(cardData[i].fieldName == 'Product'){

                                                cardData[i].iconText = filterParameters.productType;
                                                component.set("v.eniProviderStatus", eniResponse);
                                                break;
                                            }
                                        }

									}
                                    component.set("v.showSpinner", false);
								}else{
									// DE421882 - Thanish - 11th Mar 2021
									let eniProviderStatus = this.getDefaultENIStatusCard(component);
									component.set("v.eniProviderStatus", eniProviderStatus);
									this.fireToastMessage();
                                    component.set("v.showSpinner", false);
								}
							}else{
								// DE421882 - Thanish - 11th Mar 2021
								let eniProviderStatus = this.getDefaultENIStatusCard(component);
								component.set("v.eniProviderStatus", eniProviderStatus);
								this.fireToastMessage();
							}
							component.set("v.showSpinner", false);
						});
						$A.enqueueAction(actionENI);

					}else{
						// DE421882 - Thanish - 11th Mar 2021
						let eniProviderStatus = this.getDefaultENIStatusCard(component);
						eniProviderStatus.eniCardDetails.cardData.push({
							"checked": false,
							"defaultChecked": false,
							"fieldName": "Contiguous Market Table",
							"fieldType": "outputText",
							"fieldValue": "Access CGI screen in UNET and enter the following control line: CGI, Product, Market Type, Market Number",
							"showCheckbox": true
						});
						component.set("v.eniProviderStatus", eniProviderStatus);
                        component.set("v.showSpinner", false);
					}
				}else{
					// DE421882 - Thanish - 11th Mar 2021
					let eniProviderStatus = this.getDefaultENIStatusCard(component);
					component.set("v.eniProviderStatus", eniProviderStatus);
					this.fireToastMessage();
                    component.set("v.showSpinner", false);
				}
			}else{
				// DE421882 - Thanish - 11th Mar 2021
				let eniProviderStatus = this.getDefaultENIStatusCard(component);
				component.set("v.eniProviderStatus", eniProviderStatus);
				this.fireToastMessage();
				component.set("v.showSpinner", false);
            }
		});
		$A.enqueueAction(actionNetworkKey);
	},

	fireToastMessage: function () {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "We hit a snag.",
            "message": "Unexpected Error Occurred on the Provider Status Card. Please try again. If problem persists please contact the help desk.",
            "type": "error",
            "mode": "pesky",
            "duration": "30000"
        });
        toastEvent.fire();
    },

    getCSPProviderStatus: function (component) {
        component.set("v.showSpinner", true);

        let filterParameters = component.get("v.filterParameters");
        let contractApiParameters = component.get("v.contractApiParameters");
        let action = component.get("c.getCnsProviderStatusDetails");
        action.setParams({
            "providerId": contractApiParameters.providerId,
            "taxId": contractApiParameters.taxId,
            "addressId": contractApiParameters.addressId,
            "isActive": false,
            "benefitPlanId": contractApiParameters.benefitPlanId
        });
        action.setCallback(this, function (response) {
            if (response.getState() === "SUCCESS") {
                var result = response.getReturnValue();
                component.set("v.cspProviderStatus", result);

                var claimNo = component.get("v.claimNo");
                var maxAutoDocComponents = component.get("v.maxAutoDocComponents");
                var currentIndexOfOpenedTabs = component.get("v.currentIndexOfOpenedTabs");

                if (!$A.util.isUndefinedOrNull(result) && !$A.util.isUndefinedOrNull(result.mnrCardDetails) &&
                    !$A.util.isUndefinedOrNull(result.mnrCardDetails.cardData)) {
                    let cardData = result.mnrCardDetails.cardData;
                    for (let i = 0; i < cardData.length; i++) {
                        if (cardData[i].fieldName == 'Status' && cardData[i].fieldValue == 'OON') {
                            component.set("v.isOON", true);
                        }
                    }
                }

                if(component.get("v.isClaim")){
                    var cspProviderStatus=component.get("v.cspProviderStatus");

                    cspProviderStatus.componentName=cspProviderStatus.componentName+": "+claimNo;
                    cspProviderStatus.autodocHeaderName=cspProviderStatus.autodocHeaderName+": "+claimNo;
                    cspProviderStatus.componentOrder=20.07+(maxAutoDocComponents*currentIndexOfOpenedTabs);

                }
			} else {}
			component.set("v.showSpinner", false);
		});
		$A.enqueueAction(action);;
	},

	// DE421882 - Thanish - 11th Mar 2021
	getDefaultENIStatusCard: function (cmp) {
		let eniProviderStatus = {
			"eniCardDetails": {
				"componentName": "Provider Status",
				"reportingHeader":"Provider Status",
				"componentOrder": 7,
				"noOfColumns": "slds-size_1-of-10",
				"type": "card",
				"cardData": [
				  {
					"checked": false,
					"defaultChecked": false,
					"fieldName": "Status",
					"fieldType": "outputText",
					"fieldValue": "--",
						"showCheckbox": true,
						"isReportable": true
				  },
				  {
					"checked": false,
					"defaultChecked": false,
					"fieldName": "Network Key",
					"fieldType": "outputText",
					"fieldValue": "--",
						"showCheckbox": true,
						"isReportable": true
				  },
				  {
					"checked": false,
					"defaultChecked": false,
					"fieldName": "Product",
					"fieldType": "outputText",
					"fieldValue": "--",
						"showCheckbox": true,
						"isReportable": true
				  },
				  {
					"checked": false,
					"defaultChecked": false,
					"fieldName": "Market Type",
					"fieldType": "outputText",
					"fieldValue": "--",
						"showCheckbox": true,
						"isReportable": true
				  },
				  {
					"checked": false,
					"defaultChecked": false,
					"fieldName": "Market",
					"fieldType": "outputText",
					"fieldValue": "--",
						"showCheckbox": true,
						"isReportable": true
				  },
				  {
					"checked": false,
					"defaultChecked": false,
					"fieldName": "IPA",
					"fieldType": "outputText",
					"fieldValue": "--",
						"showCheckbox": true,
						"isReportable": true
				  }
				]
			}
		};
		// US3691213
		if (cmp.get("v.isLookup")) {
			var caseItemsExtId = cmp.get("v.selectedRowData").caseItemsExtId;
			eniProviderStatus.eniCardDetails.caseItemsExtId = caseItemsExtId;
		}
		return eniProviderStatus;
	}
})