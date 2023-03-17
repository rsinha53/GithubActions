({
	// US3304569 - Thanish - 18th Mar 2021
    paCheckErrorMessage: "Unexpected Error Occurred with Authorization Determination. Please try again. If problem persists please contact the help desk",
    paBenefitCheckErrMsg : "Unexpected error occurred with Benefit Check Please try again. If problem persists please contact the help desk",

	// US2974833
	doInit: function (component, event) {
		var error = {
			topDescription: 'Benefit Check criteria must include',
			bottomDescription: '',
			message: 'We hit a snag.',
			descriptionList: []
		};
		component.set('v.error', error);
		component.set('v.showErrorMessage', false);
	},

	// US3089189
	callBenefitCheck: function (cmp, event, helper) {

		var interactionOverviewTabId = cmp.get("v.interactionOverviewTabId");
		var interactionOverviewData = _setAndGetSessionValues.getInteractionDetails(interactionOverviewTabId);
		var providerDetails = interactionOverviewData.providerDetails;

		var currentid = cmp.get('v.currenttabId');
		var extended = _setAndGetSessionValues.gettingValue("Policy:" + currentid + ":" + currentid);
		var memberData = _setAndGetSessionValues.gettingValue("Member:" + currentid + ":" + currentid);

		var benefitData = {
			"memberCardData": JSON.stringify(cmp.get("v.memberCardSnap")),
			"providerDetail": JSON.stringify(providerDetails),
			"PACheckData": JSON.stringify(cmp.get("v.PACheckData")),
			"extendeResult": JSON.stringify(extended),
			"memberDataResult": JSON.stringify(memberData)
		};
		
		var spinner = cmp.find('pacheckprocedure');
		$A.util.removeClass(spinner, 'slds-hide');
		$A.util.addClass(spinner, 'slds-show');

		var action = cmp.get('c.benefitCheck');
		action.setParams({
			"benefitData": JSON.stringify(benefitData)
		});

		action.setCallback(this, function (response) {
			let state = response.getState();

			if (state == "SUCCESS") {

				let result = response.getReturnValue();

				if (!$A.util.isUndefinedOrNull(result) && (!$A.util.isEmpty(result))) {
					//US3137795
					if((result.statusCode==200) && (!$A.util.isUndefinedOrNull(result.resultWrapper.serviceStatusCode)) && (result.resultWrapper.serviceStatusCode=='999')) {
						cmp.set('v.isShowBenefitResults', false);
						this.fireToastMessage("Error!", 'Benefit Check cannot be performed at this time. Please try again later.', "error", "dismissible", "6000");
					}
					else if ((result.success) && (result.statusCode==200)) {
						cmp.set('v.isShowBenefitResults', true);
						cmp.set('v.benefitCheckResult', result.resultWrapper);
					} else {
						cmp.set('v.isShowBenefitResults', false);
						//US3137795
						var errorMsg='';
						if((result.statusCode == 400 || result.statusCode == 500)) {
							errorMsg= this.paCheckErrorMessage; // US3304569 - Thanish - 18th Mar 2021
						} else if (result.statusCode == 404) {
							errorMsg= 'No Results Found.';
						} else {
							errorMsg= 'Web Service or External System is temporarily unavailable.';
						}
						this.fireToastMessage("We hit a snag.", errorMsg, "error", "dismissible", "30000");// US3304569 - Thanish - 18th Mar 2021
					}

				} else {
					cmp.set('v.isShowBenefitResults', false);
					//US3137795
					this.fireToastMessage("We hit a snag.", this.paCheckErrorMessage, "error", "dismissible", "30000");// US3304569 - Thanish - 18th Mar 2021
				}

			} else if (state === "ERROR") {
				cmp.set('v.isShowBenefitResults', false);
				this.fireToastMessage("We hit a snag.", this.paCheckErrorMessage, "error", "dismissible", "30000");// US3304569 - Thanish - 18th Mar 2021
			}

			$A.util.removeClass(spinner, 'slds-show');
			$A.util.addClass(spinner, 'slds-hide');

		});
		$A.enqueueAction(action);


	},

	callPriorAuthResult: function (cmp, event, helper) {
		var interactionOverviewTabId = cmp.get("v.interactionOverviewTabId");
		var interactionOverviewData = _setAndGetSessionValues.getInteractionDetails(interactionOverviewTabId);
		var providerTaxId = interactionOverviewData.providerDetails.taxId;

		var currentid = cmp.get('v.currenttabId');
		var extended = _setAndGetSessionValues.gettingValue("Policy:" + currentid + ":" + currentid);
		var memberData = _setAndGetSessionValues.gettingValue("Member:" + currentid + ":" + currentid);

		var PACheckData = cmp.get('v.PACheckData');
		var procedureCodes = '';
		var diagnosisCode = '';
		var proCode = '';
		var diagCode = '';
		var codesCounter = 0;

		// US3379720
		var lastRequestCount = parseInt(cmp.get('v.lastRequestCount'));
		var priorAuthResultSize = parseInt(cmp.get('v.priorAuthResultSize'));

		for (var i = lastRequestCount; i < PACheckData.ProcedureCode.ProcedureCodes.length; i++) {
			proCode = PACheckData.ProcedureCode.ProcedureCodes[i].procedureCode;
			diagCode = PACheckData.ProcedureCode.ProcedureCodes[i].diagnosisCode;
			if (!$A.util.isEmpty(proCode) && proCode.length > 0) {
				procedureCodes += (proCode + ',');
			}
			if (!$A.util.isEmpty(diagCode) && diagCode.length > 0) {
				diagnosisCode += (diagCode + ',');
				++codesCounter;
			}
		}

		var indexVal = cmp.get('v.policySelectedIndex');

		// DE424032
		var stateOfIssueCode = '';
		if (!$A.util.isUndefinedOrNull(extended) && !$A.util.isUndefinedOrNull(extended.policyResultWrapper) &&
			!$A.util.isUndefinedOrNull(extended.policyResultWrapper.resultWrapper) &&
			!$A.util.isUndefinedOrNull(extended.policyResultWrapper.resultWrapper.policyRes) &&
			!$A.util.isUndefinedOrNull(extended.policyResultWrapper.resultWrapper.policyRes.stateOfIssueCode)) {
			stateOfIssueCode = extended.policyResultWrapper.resultWrapper.policyRes.stateOfIssueCode;
		}

		var planTypeCode = '';
		if (!$A.util.isUndefinedOrNull(memberData) && !$A.util.isUndefinedOrNull(memberData.CoverageLines[indexVal]) &&
			!$A.util.isUndefinedOrNull(memberData.CoverageLines[indexVal].insuranceTypeCode)) {
			planTypeCode = memberData.CoverageLines[indexVal].insuranceTypeCode;
		}

		// US3379720
		if ($A.util.isEmpty(procedureCodes) || $A.util.isEmpty(diagnosisCode)) {
			return;
		}

		var diagCodes = diagnosisCode.split(',');
		const mapFinal = new Map();
		for (var i = 0; i < diagCodes.length; i++) {
			var diagCode = diagCodes[i];
			if (!$A.util.isEmpty(diagCode)) {
				var proCode = procedureCodes.split(',')[i];
				if (!mapFinal.has(diagCode)) {
					mapFinal.set(diagCode, '');
				}
				var pCodes = mapFinal.get(diagCode) + proCode + ',';
				//diagCodes = diagCodes.replace(/,(\s+)?$/, '');
				mapFinal.set(diagCode, pCodes);
			}
		}
		console.log('JJJJJJJ ::: ' + mapFinal);
		console.log('JJJJJJJ ::: ' + JSON.stringify(this.mapToObject(mapFinal)));
		var priorAuthData = {
			"codesMap": JSON.stringify(this.mapToObject(mapFinal)), // US3379720
			"taxIdNumber": JSON.stringify(providerTaxId),
			"stateOfIssueCode": stateOfIssueCode, // DE424032
			"planTypeCode": planTypeCode // DE424032
		};

		var spinner = cmp.find('pacheckprocedure');
		$A.util.removeClass(spinner, 'slds-hide');
		$A.util.addClass(spinner, 'slds-show');

		var priorAuthResult = cmp.get('v.priorAuthResult');
		var procedureCodeList = cmp.find('procedureCode');
		var diagnosisCodeList = cmp.find('diagnosisCode');
		var procedureCmp = '';
		var diagnosisCmp = '';
		var procedureCode = '';
		var diagnosisCode = '';
		var hasError = false;
		for (var x in procedureCodeList) {
			procedureCmp = procedureCodeList[x];
			diagnosisCmp = diagnosisCodeList[x];
			procedureCmp.removeRequired();
			diagnosisCmp.removeRequired();
		}

        this.callGetKLdata(cmp, event, helper);

		var action = cmp.get('c.getPriorAuthInquiry'); // US3290723
		action.setParams({
			"priorAuthData": JSON.stringify(priorAuthData)
		});
		action.setCallback(this, function (response) {
			let state = response.getState();
			var memberInfo = cmp.get('v.memberInfo');

			if (state == "SUCCESS") {
				// US3290723
				let result = response.getReturnValue();
				console.log('-result-');
				console.log(result);
				if ($A.util.isEmpty(priorAuthResult)) {
					priorAuthResult = [];
				}
				priorAuthResult.length = priorAuthResultSize;
				if (!$A.util.isUndefinedOrNull(result) && (!$A.util.isEmpty(result))) {
					for (var i = 0; i < result.length; i++) {
						if (result[i].statusCode == 200) {
							priorAuthResult.push(result[i]);
						} else {
							hasError = true;
							var arr = result[i].failedProCode.split(',');
							for (var y in arr) {
								if (!$A.util.isEmpty(arr[y]) && 0 < arr[y].length) {
									for (var x in procedureCodeList) {
										procedureCmp = procedureCodeList[x];
										diagnosisCmp = diagnosisCodeList[x];
										procedureCode = PACheckData.ProcedureCode.ProcedureCodes[x]['procedureCode'];
										diagnosisCode = PACheckData.ProcedureCode.ProcedureCodes[x]['diagnosisCode'];
										if (!$A.util.isEmpty(procedureCode)) {
											if (arr[y] == procedureCode) {
												procedureCmp.makeHighlighted();
												diagnosisCmp.makeHighlighted();
											}
										}
									}

								}
							}
						}
					}

					// US3379720
					console.log('-priorAuthResult-');
					console.log(priorAuthResult);

					if (priorAuthResult.length > 0) {
						cmp.set('v.priorAuthResultTemp', priorAuthResult);
						if (!$A.util.isUndefinedOrNull(memberInfo) && (!$A.util.isEmpty(memberInfo)) && (memberInfo.sourceCode === 'CS') ) {
							this.CallBenefitMemberCheck(cmp, event, helper);
						} else {
							cmp.set('v.priorAuthResult', priorAuthResult);
						}
						if (hasError) { // if(result.statusCode==400 ||result.statusCode==500)
							this.fireToastMessage("Error!", (result.statusCode == 400 || result.statusCode == 500) ? 'Unexpected error occurred. Please try again. If problem persists contact help desk.' : (result.statusCode == 404) ? 'No Results Found.' : 'Web Service or External System is temporarily unavailable.', "error", "dismissible", "6000");
						}
					}

					if (!hasError && codesCounter == 5) {
						lastRequestCount = parseInt((lastRequestCount + 5));
						cmp.set('v.lastRequestCount', lastRequestCount);
						cmp.set('v.priorAuthResultSize', priorAuthResult.length);
						cmp.set('v.showAddNewLink', true);
						var procedureObject = null;
						for (var i = 0; i < PACheckData.ProcedureCode.ProcedureCodes.length; i++) {
							procedureObject = PACheckData.ProcedureCode.ProcedureCodes[i];
							procedureObject.disabled = true;
							PACheckData.ProcedureCode.ProcedureCodes[i] = procedureObject;
						}
						cmp.set('v.PACheckData', PACheckData);
					}

					/*if (result[0].statusCode == 200) {
						if ($A.util.isEmpty(priorAuthResult)) {
							priorAuthResult = [];
						}
						priorAuthResult.push(result);
						cmp.set('v.priorAuthResultTemp', priorAuthResult);
						if (!$A.util.isUndefinedOrNull(memberInfo) && (!$A.util.isEmpty(memberInfo)) && memberInfo.sourceCode === 'CS') {
							this.callRCED(cmp, event, helper);
						} else {
							cmp.set('v.priorAuthResult', priorAuthResult);
						}
					}
					else// if(result.statusCode==400 ||result.statusCode==500)
					{
						this.fireToastMessage("Error!", (result.statusCode == 400 || result.statusCode == 500) ? 'Unexpected error occurred. Please try again. If problem persists contact help desk.' : (result.statusCode == 404) ? 'No Results Found.' : 'Web Service or External System is temporarily unavailable.', "error", "dismissible", "6000");
					}*/

				} else {
					helper.fireToastMessage("We hit a snag.", this.paCheckErrorMessage, "error", "dismissible", "30000");// US3304569 - Thanish - 18th Mar 2021

				}

			} else if (state === "ERROR") {

				var errors = response.getError();
				if (errors) {
					if (errors[0] && errors[0].message) {
						console.log('errors');
						console.log(JSON.stringify(errors));
						console.log(errors);
					}
				} else {
				 
				}
			}
			$A.util.removeClass(spinner, 'slds-show');
			$A.util.addClass(spinner, 'slds-hide');
		});
		$A.enqueueAction(action);
	},

    CallBenefitMemberCheck: function(cmp,event,helper){
        var spinner = cmp.find('pacheckprocedure');
		$A.util.removeClass(spinner, 'slds-hide');
		$A.util.addClass(spinner, 'slds-show');

        var interactionOverviewTabId = cmp.get("v.interactionOverviewTabId");
		var interactionOverviewData = _setAndGetSessionValues.getInteractionDetails(interactionOverviewTabId);
		var providerDetails = interactionOverviewData.providerDetails;

		var currentid = cmp.get('v.currenttabId');
		var extended = _setAndGetSessionValues.gettingValue("Policy:" + currentid + ":" + currentid);
		var memberData = _setAndGetSessionValues.gettingValue("Member:" + currentid + ":" + currentid);

		var benefitData = {
			"memberCardData": JSON.stringify(cmp.get("v.memberCardSnap")),
			"providerDetail": JSON.stringify(providerDetails),
			"PACheckData": JSON.stringify(cmp.get("v.PACheckData")),
			"extendeResult": JSON.stringify(extended),
            "policyIndex": JSON.stringify(cmp.get('v.policySelectedIndex')),
			"memberDataResult": JSON.stringify(memberData)
		};

        var action = cmp.get('c.getBenefitCheckData');
		action.setParams({
			"benefitData": JSON.stringify(benefitData)
		});

		action.setCallback(this, function (response) {
			let state = response.getState();

			if (state == "SUCCESS") {

				let result = response.getReturnValue();
                console.log('=@BTotalRes'+JSON.stringify(result));
                if(result && result.calloutResult && result.calloutResult.isSuccess && result.calloutResult.statusCode  == 200){
                    cmp.set('v.benefitResult',result);
                    cmp.set("v.priorAuthResult", cmp.get("v.priorAuthResultTemp"));
                }
                else{
                    this.fireToastMessage("We hit a snag.", this.paBenefitCheckErrMsg , "error", "dismissible", "30000");
                     cmp.set("v.priorAuthResult", cmp.get("v.priorAuthResultTemp"));
                }

			} else if (state === "ERROR") {
                 cmp.set("v.priorAuthResult", cmp.get("v.priorAuthResultTemp"));
				this.fireToastMessage("We hit a snag.", this.paBenefitCheckErrMsg, "error", "dismissible", "30000");
			}
            $A.util.removeClass(spinner, 'slds-show');
			$A.util.addClass(spinner, 'slds-hide');

		});
		$A.enqueueAction(action);
    },


	// US3089189
	addRaw: function (cmp, event, helper) {
		var PACheckData = cmp.get('v.PACheckData');
		if (PACheckData.ProcedureCode.ProcedureCodes.length < 20) { // US2974833 Swapnil // US3290723
			// US3379720
			for (var i = 0; i < 5; i++) {
				let procedureObject = {
					"procedureCode": "",
					"diagnosisCode": "",
					"modifier": "",
					"charge": "10",
					"count": "1",
					"units": "1",
					"measure": "Units",
					"frequency": "1",
					"disabled": false,
                    "copyClick" :false
				};
				PACheckData.ProcedureCode.ProcedureCodes.push(procedureObject);
				cmp.set('v.PACheckData', PACheckData);
			}
		}
		// US3379720
		cmp.set('v.showAddNewLink', false);

	},

	//US2974833 Swapnil
	keepAlphanumericAndNoSpecialCharacters: function (cmp, event) {
		var regex = new RegExp("^[a-zA-Z0-9]+$");
		var str = String.fromCharCode(!event.charCode ? event.which : event.charCode);
		if (regex.test(str)) {
			return true;
		} else {
			event.preventDefault();
			return false;
		}
	},

	// US2974833 Swapnil
	validateCodesWithDot: function (cmp, event) {
		var fieldName = event.getSource().get("v.name");
		var fieldValue = event.getSource().get("v.value");
		var field = event.getSource()
		field.setCustomValidity('');
		if (fieldValue.length > 0) {//US3068996 lower to upper convert
			fieldValue = fieldValue.toUpperCase();
			if (fieldValue.length == 3) {
				fieldValue = fieldValue.toUpperCase();
			}
			if (fieldValue.length < 3) {
				//US3068996 lower to upper convert
				fieldValue = fieldValue.toUpperCase();
				field.setCustomValidity('Invalid input.');
			} else if (fieldValue.length > 3) {
				var fs = fieldValue.substring(0, 3);
				var sc = '';
				if (fieldValue.length == 4 && fieldValue.substr(fieldValue.length - 1) == '.') {
					fieldValue = (fs);
				} else {
					if (fieldValue.indexOf('.') !== -1) {
						sc = fieldValue.substring(4, fieldValue.length);
					} else {
						sc = fieldValue.substring(3, fieldValue.length);
					}//US3068996 lower to upper convert
					fieldValue = (fs.toUpperCase() + '.' + sc.toUpperCase());
				}
			}
		}
		cmp.set("v.PACheckData.ProcedureCode.ProcedureCodes[" + fieldName.split('diagnosisCode')[1] + "].diagnosisCode", fieldValue);
	},

	// US2974833 Swapnil
	executeValidations: function (cmp, event) {
		var errors = cmp.get('v.errors');
		errors.errorsPC.isValidPC = false;
		errors.errorsPC.errorsList = [];
		var validationCounter = 0;
		var PACheckData = cmp.get('v.PACheckData');
		var procedureCodeList = cmp.find('procedureCode');
		var diagnosisCodeList = cmp.find('diagnosisCode');
		var procedureCmp = '';
		var diagnosisCmp = '';
		var procedureCode = '';
		var diagnosisCode = '';
		for (var i in procedureCodeList) {
			procedureCmp = procedureCodeList[i];
			diagnosisCmp = diagnosisCodeList[i];
			procedureCode = PACheckData.ProcedureCode.ProcedureCodes[i]['procedureCode'];
			diagnosisCode = PACheckData.ProcedureCode.ProcedureCodes[i]['diagnosisCode'];
			var procedureCodeDesc = procedureCmp.get('v.selectedCodeDesc');
			var diagnosisCodeDesc = diagnosisCmp.get('v.selectedCodeDesc');
			var procedureCodeValue = procedureCmp.get('v.value');
			var isValidProcedureCode = false;
			if (!$A.util.isEmpty(procedureCode) && !$A.util.isEmpty(diagnosisCode)) {

			} else {
				if ($A.util.isEmpty(procedureCode) && !$A.util.isEmpty(diagnosisCode)) {
					validationCounter++;
					errors.errorsPC.errorsList.push('Procedure Code');
					procedureCmp.makeRequired();
					diagnosisCmp.removeRequired();
				} else if (!$A.util.isEmpty(procedureCode) && $A.util.isEmpty(diagnosisCode)) {
					validationCounter++;
					errors.errorsPC.errorsList.push('Diagnosis Code');
					diagnosisCmp.makeRequired();
					procedureCmp.removeRequired();
				} else {
					procedureCmp.removeRequired();
					diagnosisCmp.removeRequired();
				}
			}

			//  US3437462	Plan Benefits: Benefit & PA Check Results: Validations - Sarma - 09 Mar 2021
			if(!$A.util.isEmpty(procedureCodeDesc) && (procedureCodeDesc.toLowerCase().includes("incomplete code") || procedureCodeDesc.toLowerCase().includes("invalid") || procedureCodeDesc.toLowerCase().includes("deleted"))){
				procedureCmp.addDeletedError();
				validationCounter++;
				errors.errorsPC.errorsList.push('Valid Procedure Code');
			}
			else{
				procedureCmp.removeRequired();
				isValidProcedureCode = true;
			}
			if(!$A.util.isEmpty(diagnosisCodeDesc) && (diagnosisCodeDesc.toLowerCase().includes("incomplete code") || diagnosisCodeDesc.toLowerCase().includes("invalid") || diagnosisCodeDesc.toLowerCase().includes("deleted"))){
				diagnosisCmp.addDeletedError();
				validationCounter++;
				errors.errorsPC.errorsList.push('Valid Diagnosis Code');
			}
			else{
				diagnosisCmp.removeRequired();
			}
			// Duplicate check
			if (isValidProcedureCode) {
				var isDuplicatefound = false;
				for(var j in procedureCodeList){
					var proCode = procedureCodeList[j].get('v.value');
					if(!$A.util.isEmpty(procedureCodeValue) && !$A.util.isEmpty(proCode) && procedureCodeValue == proCode && i != j){
						isDuplicatefound = true;
						break;
					}
				}
				if(isDuplicatefound){
					validationCounter++;
					procedureCmp.makeHighlighted();
					errors.errorsPC.errorsList.push('Non-Duplicate Procedure Code');
				} else{
					procedureCmp.removeRequired(); // removing highlight
				}
			}

			//  US3437462 - Ends


		}
		if (0 == validationCounter) {
			errors.errorsPC.isValidPC = true;
		}

		var uniqueChars = errors.errorsPC.errorsList.filter((c, index) => {
			return errors.errorsPC.errorsList.indexOf(c) === index;
		});

		errors.errorsPC.errorsList = uniqueChars;
		cmp.set('v.errors', errors);
	},

	// US3089189
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


    /*callRCED: function (cmp, event, helper) {


        var memberInfo = cmp.get('v.memberInfo');

		var action = cmp.get('c.getRCEDres');
		action.setParams({
			"subscriberId": memberInfo.EEID,
            "policyNumber":memberInfo.memberPlan,
            "sourceCode":memberInfo.sourceCode
		});
		action.setCallback(this, function (response) {
			let state = response.getState();

			if (state == "SUCCESS") {

				let result = response.getReturnValue();
				if (result.statusCode == "200" && !$A.util.isUndefinedOrNull(result) && (!$A.util.isEmpty(result)) && (!$A.util.isUndefinedOrNull(result.vendor)) && (!$A.util.isEmpty(result.vendor))
                    && (!$A.util.isUndefinedOrNull(result.vendor.healthServiceProductCode)) && (!$A.util.isEmpty(result.vendor.healthServiceProductCode)) && (!$A.util.isUndefinedOrNull(result.vendor.vendorBenefitOptionTypeCode)) && (!$A.util.isEmpty(result.vendor.vendorBenefitOptionTypeCode))  ) {

					console.log("healthServiceProductCode: "+result.vendor.healthServiceProductCode);
					console.log("vendorBenefitOptionTypeCode: "+result.vendor.vendorBenefitOptionTypeCode);
                    cmp.set("v.healthServiceProductCode", result.vendor.healthServiceProductCode);
                    cmp.set("v.vendorBenefitOptionTypeCode", result.vendor.vendorBenefitOptionTypeCode);
                    if(result.vendor.healthServiceProductCode =="AC"){
                        this.callPESservices(cmp, event, helper);
                    }else{
                        cmp.set("v.priorAuthResult", cmp.get("v.priorAuthResultTemp"));
                    }
                } else {
                    cmp.set("v.priorAuthResult", cmp.get("v.priorAuthResultTemp"));
                    this.fireToastMessage("We hit a snag.", this.paCheckErrorMessage, "error", "dismissible", "30000");// US3304569 - Thanish - 18th Mar 2021
                }

			} else if (state === "ERROR") {
                cmp.set("v.priorAuthResult", cmp.get("v.priorAuthResultTemp"));
				this.fireToastMessage("We hit a snag.", this.paCheckErrorMessage, "error", "dismissible", "30000");// US3304569 - Thanish - 18th Mar 2021
			}

		});
		$A.enqueueAction(action);
	},

    callPESservices: function (cmp, event, helper) {
        var interactionOverviewTabId = cmp.get("v.interactionOverviewTabId");
        var interactionOverviewData = _setAndGetSessionValues.getInteractionDetails(interactionOverviewTabId);
        //if (!$A.util.isUndefinedOrNull(interactionOverviewData.providerDetails) && (!$A.util.isEmpty(interactionOverviewData.providerDetails)) && (!$A.util.isUndefinedOrNull(interactionOverviewData.providerDetails.taxId)) && (!$A.util.isEmpty(interactionOverviewData.providerDetails.taxId))
           // && (!$A.util.isUndefinedOrNull(result.vendor.healthServiceProductCode)) && (!$A.util.isEmpty(result.vendor.healthServiceProductCode)) && (!$A.util.isUndefinedOrNull(result.vendor.vendorBenefitOptionTypeCode)) && (!$A.util.isEmpty(result.vendor.vendorBenefitOptionTypeCode))  ) {

            var providerTaxId = interactionOverviewData.providerDetails.taxId;

            var addressSequenceId = interactionOverviewData.providerDetails.addressSequenceId;

            var providerId = interactionOverviewData.providerDetails.providerId;

            var currentid = cmp.get('v.currenttabId');
            var extended = _setAndGetSessionValues.gettingValue("Policy:" + currentid + ":" + currentid);
            var memberData = _setAndGetSessionValues.gettingValue("Member:" + currentid + ":" + currentid);

            var PACheckData = cmp.get('v.PACheckData');

            var memberInfo = cmp.get('v.memberInfo');

            var action = cmp.get('c.getPESres');
            action.setParams({
                "providerId": providerId,
                "taxId":providerTaxId,
                "addressSeq":addressSequenceId
            });
            action.setCallback(this, function (response) {
                let state = response.getState();

                if (state == "SUCCESS") {
        			// US3304569 - Thanish - 18th Mar 2021
					var retValue = response.getReturnValue();
                    let result = retValue.isParticipating;
					if(retValue.statusCode!=200){
						this.fireToastMessage("We hit a snag.", this.paCheckErrorMessage, "error", "dismissible", "30000");// US3304569 - Thanish - 18th Mar 2021
					}

                    if (!$A.util.isUndefinedOrNull(result) && (!$A.util.isEmpty(result))) {
                        cmp.set("v.isParticipating", result);
                        cmp.set("v.priorAuthResult", cmp.get("v.priorAuthResultTemp"));
                    } else {
                        cmp.set("v.priorAuthResult", cmp.get("v.priorAuthResultTemp"));
                    }

                } else if (state === "ERROR") {
                    cmp.set("v.priorAuthResult", cmp.get("v.priorAuthResultTemp"));
                    this.fireToastMessage("We hit a snag.", this.paCheckErrorMessage, "error", "dismissible", "30000");// US3304569 - Thanish - 18th Mar 2021
                }

            });
            $A.enqueueAction(action);
       //}
    },*/

	setPriorAuthResult: function (cmp, event, helper) {
		cmp.set("v.priorAuthResult", cmp.get("v.priorAuthResultTemp"));
		cmp.set("v.isParticipating", result);
	},

	// US3379720
	mapToObject: function (map) {
		const obj = {}
		for (let [k, v] of map)
			obj[k] = v
		return obj
	},

    callGetKLdata: function (cmp, event, helper) {
        var PACheckData = cmp.get('v.PACheckData');
        var procedureCodes = '';
        var diagnosisCode = '';
        var proCode = '';
        var diagCode = '';
        var codesCounter = 0;

        var lastRequestCount = 0;
        var priorAuthResultSize = 0;

        for (var i = lastRequestCount; i < PACheckData.ProcedureCode.ProcedureCodes.length; i++) {
            proCode = PACheckData.ProcedureCode.ProcedureCodes[i].procedureCode;
            diagCode = PACheckData.ProcedureCode.ProcedureCodes[i].diagnosisCode;
            if (!$A.util.isEmpty(proCode) && proCode.length > 0) {
                if (!$A.util.isEmpty(procedureCodes) && procedureCodes.length > 0) {
                    procedureCodes += ','+proCode;
                }else{
                    procedureCodes += proCode;
                }
                //procedureCodes.push(proCode);

            }
            if (!$A.util.isEmpty(diagCode) && diagCode.length > 0) {
                if (!$A.util.isEmpty(diagnosisCode) && diagnosisCode.length > 0) {
                    diagnosisCode += ','+diagCode;
                }else{
                    diagnosisCode += diagCode;
                }
                //diagnosisCode.push(diagCode);
            }
	}

        var klInputs = {
            "procedureCodes": procedureCodes,
            "diagnosisCode": diagnosisCode
        }

        var action = cmp.get('c.getKLData');
        action.setParams({
            "klInputs": JSON.stringify(klInputs)
        });
        action.setCallback(this, function (response) {
            let state = response.getState();

            if (state == "SUCCESS") {

                let result = response.getReturnValue();
                cmp.set("v.procedureCodeMap", result);
                /*console.log("getKLData: "+JSON.stringify(result));
                cmp.set("v.priorAuthResult", cmp.get("v.priorAuthResultTemp"));
                if (!$A.util.isUndefinedOrNull(result) && (!$A.util.isEmpty(result))) {
                    cmp.set("v.priorAuthResult", cmp.get("v.priorAuthResultTemp"));
                } else {
                    cmp.set("v.priorAuthResult", cmp.get("v.priorAuthResultTemp"));
                    this.fireToastMessage("We hit a snag.", this.paCheckErrorMessage, "error", "dismissible", "30000");// US3304569 - Thanish - 18th Mar 2021
                }*/

            } else if (state === "ERROR") {
                cmp.set("v.priorAuthResult", cmp.get("v.priorAuthResultTemp"));
                this.fireToastMessage("We hit a snag.", this.paCheckErrorMessage, "error", "dismissible", "30000");// US3304569 - Thanish - 18th Mar 2021
            }



        });
        $A.enqueueAction(action);
    },

})