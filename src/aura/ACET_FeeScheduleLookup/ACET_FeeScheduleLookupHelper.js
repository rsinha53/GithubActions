({
	addInputRows: function (cmp, noOfRows) {
		var inputRows = cmp.get("v.inputRows");
		// US3394407
		var isClaims = cmp.get("v.isClaims");
		if (!isClaims && (inputRows.length + noOfRows > 50)) {
			cmp.set("v.showExcessRowsError", true);
		} else {
			cmp.set("v.showExcessRowsError", false);
			for (var i = 0; i < noOfRows; i++) {
				var row = {
					start: "",
					end: "",
					pos: "",
					cptOrHcpc: "",
					modifier: "",
					dx: "",
					type: "D",
					count: "",
					billedAmnt: "",
					serviceCalled: false
				};
				inputRows.push(row);
			}
			cmp.set("v.inputRows", inputRows);
		}
	},

	clearInputRow: function (row) {
		row.start = "";
		row.end = "";
		row.pos = "";
		row.cptOrHcpc = "";
		row.modifier = "";
		row.dx = "";
		row.type = "D";
		row.count = "";
		row.billedAmnt = "";
		row.serviceCalled = false;
		return row;
	},

	reportValidityOfEmptyRow: function (cmp, index) {
		var inputList = cmp.find("inputfields");
		var startIndex = index * 9;
		for (var i = 0; i < 9; i++) {
			inputList[startIndex].set("v.required", false);
			inputList[startIndex].reportValidity();
			if ((inputList[startIndex].get("v.label") != "modifier") && (inputList[startIndex].get("v.label") != "dx")) {
				inputList[startIndex].set("v.required", true);
			}
			startIndex++;
		}
	},
	//Vishal Change - 12 May 2021
    setUBO4Card:function(cmp, isChecked, claimNumber, value){
        var t = cmp.get("v.allowedAmountValue"); //US3553327: Vishal Change
        var amount = (t.indexOf(".") >= 0) ? (t.substr(0, t.indexOf(".")) + t.substr(t.indexOf("."), 3)) : t; // US3553327: Vishal Change
        var cardDetails = new Object();
        	cardDetails.componentName = "Fee Schedule:  "+ claimNumber;
			cardDetails.reportingHeader = 'Fee Schedule';
            cardDetails.componentOrder = 2;
            cardDetails.noOfColumns = "slds-size_6-of-12";
            cardDetails.type = "card";
            //cardDetails.caseItemsExtId = memberCardData.CoverageLines[policySelectedIndex].GroupNumber;
            cardDetails.caseItemsExtId = claimNumber;
            cardDetails.allChecked = false;
            cardDetails.cardData = [
                {
                    "checked": true,
                    "fieldName": "Allowed Amount",
                    "fieldType": "outputText",
                    "fieldValue": amount,
                    "showCheckbox": true,
                    "isReportable":true
                }
            ];
            cmp.set("v.ub04CardDetails", cardDetails);
        	 _autodoc.setAutodoc(cmp.get("v.autodocUniqueId"), cmp.get("v.autodocUniqueIdCmp"), cardDetails);
			cmp.set("v.allowedAmountValue",amount);//US3553327: Vishal Change

    },
	populatePOSValues: function (cmp) {
		//getPOSCodes
		var getPOSCodes = cmp.get("c.getPOSCodes");
		getPOSCodes.setCallback(this, function (response) {
			var state = response.getState();
			var resp = response.getReturnValue();
			if (state === "SUCCESS") {
				if (resp != '') {
					var vals = JSON.parse(resp);
					var pickListVals = [];
					vals.forEach(obj => {
						pickListVals.push({
							'label': (obj.code + ' ' + obj.desc),
							'value': obj.code
						});
					});
					cmp.set("v.posComboBoxValues", pickListVals);
				}
			} else if (state === "INCOMPLETE") {
				this.showToastMessage('Unexpexted Error Occured!', "error", "pesky", "30000");
			} else if (state === "ERROR") {
				this.showToastMessage('Unexpexted Error Occured!', "error", "pesky", "30000");
			}
			cmp.set("v.showSpinner", false);
		});
		$A.enqueueAction(getPOSCodes);
    cmp.set("v.showSpinner", false);
	},

	// US3400693
	callFeeSchedule: function (cmp) {
        cmp.set("v.showSpinner", true);
		var inputs = cmp.get("v.inputRows");
        var requestList = [];
		var contractId = '';
		var isClaims = cmp.get("v.isClaims");
		var feeScheduleData = cmp.get("v.feeScheduleData");
		try {
            contractId = cmp.get("v.contractData").contractDetails.componentName.split(':')[1].trim();
		} catch (error) {
			contractId = '';
		}
		inputs.forEach(element => {
			if (element.start != "" && !element.serviceCalled) {
				var reqObj = new Object();
				reqObj.startDate = element.start;
				reqObj.endDate = element.end;
				reqObj.pos = element.pos;
				reqObj.cpthcpc = element.cptOrHcpc;
				reqObj.modifier = element.modifier;
				reqObj.dx = element.dx;
				reqObj.type = element.type;
				reqObj.count = element.count;
				reqObj.billedAmount = element.billedAmnt;
				reqObj.contractId = contractId;
				if (!$A.util.isEmpty(feeScheduleData)) {
					reqObj.prodCode = feeScheduleData.prodCode;
					reqObj.prodOffId = feeScheduleData.prodOffId;
					reqObj.taxId = feeScheduleData.taxId;
					reqObj.provId = feeScheduleData.provId;
					reqObj.market = feeScheduleData.market;
					reqObj.mktType = feeScheduleData.mktType;
					reqObj.ipa = feeScheduleData.ipa;
					reqObj.feeSchedNo = feeScheduleData.feeSchedNo;
				}
				requestList.push(reqObj);
				element.searched = true;
			}
		});
		if (isClaims) {
			var consolidated = cmp.get("v.consolidatedData");
			for (let index = 0; index < requestList.length; index++) {
				if(consolidated && consolidated!=null && consolidated.length != null && consolidated.length > index){
					requestList[index].startDate = consolidated[index].startDate;
					requestList[index].endDate = consolidated[index].endDate;
					requestList[index].prodCode = consolidated[index].prodCode;
					requestList[index].prodOffId = consolidated[index].prodOffId;
					requestList[index].taxId = consolidated[index].taxId;
					requestList[index].provId = consolidated[index].provId;
					requestList[index].market = consolidated[index].market;
					requestList[index].mktType = consolidated[index].mktType;
					requestList[index].ipa = consolidated[index].ipa;
					requestList[index].feeSchedNo = consolidated[index].feeSchedNo;
				}else if(consolidated && consolidated!=null && consolidated.length <= index){
					requestList[index].startDate = consolidated[0].startDate;
					requestList[index].endDate = consolidated[0].endDate;
					requestList[index].prodCode = consolidated[0].prodCode;
					requestList[index].prodOffId = consolidated[0].prodOffId;
					requestList[index].taxId = consolidated[0].taxId;
					requestList[index].provId = consolidated[0].provId;
					requestList[index].market = consolidated[0].market;
					requestList[index].mktType = consolidated[0].mktType;
					requestList[index].ipa = consolidated[0].ipa;
					requestList[index].feeSchedNo = consolidated[0].feeSchedNo;
				}
			}
		}
		cmp.set("v.inputRows", inputs);
		var action = cmp.get("c.callScheduleService");
		// requestList: !isClaims ? requestList : cmp.get("v.consolidatedData"),
		action.setParams({
			requestList: requestList,
			currentTbl: cmp.get("v.resultsData")
		});
		action.setCallback(this, function (response) {
			var state = response.getState();
			var resp = response.getReturnValue();
			if (state === "SUCCESS") {
				if (!resp.isSuccess) {
					this.showToastMessage(resp.message, "error", "pesky", "30000");
				}
				var tableData = response.getReturnValue().response;
				if (isClaims) {
					tableData.autodocHeaderName = tableData.autodocHeaderName + cmp.get("v.claimnumber");
					tableData.tableBody.forEach(row => {
						row.caseItemsExtId = cmp.get("v.claimnumber");
					});
				} else {
					tableData.autodocHeaderName = tableData.autodocHeaderName + cmp.get("v.contractData").contractDetails.componentName;
				}

				cmp.set("v.showResults", true);
				cmp.set("v.resultsData", tableData);

				// Setting called status
				inputs.forEach(element => {
					if (element.start != "" && !element.serviceCalled && element.searched) {
						element.serviceCalled = true;
					}
				});
			} else if (state === "INCOMPLETE") {
				this.showToastMessage(resp.message, "error", "pesky", "30000");
			} else if (state === "ERROR") {
				this.showToastMessage(resp.message, "error", "pesky", "30000");
			}
			cmp.set("v.showSpinner", false);
		});
		if(requestList.length > 0){
			$A.enqueueAction(action);
		}
       cmp.set("v.showSpinner", false);
	},

	showToastMessage: function (message, type, mode, duration) {
		var toastEvent = $A.get("e.force:showToast");
		toastEvent.setParams({
			"title": "We hit a snag.",
			"message": message,
			"type": type,
			"mode": mode,
			"duration": duration
		});
		toastEvent.fire();
	},

	// US3394407
	addInputRowsUB: function (cmp, noOfRows) {
		var inputRows = cmp.get("v.us04OutpatientInputRows");
		cmp.set("v.showExcessRowsError", false);
		for (var i = 0; i < noOfRows; i++) {
			var row = {
				start: "",
				end: "",
				revCode: "",
				cptOrHcpc: "",
				modifier: "",
				primaryDx: "",
				addlDx: "",
				rxNdc: "",
				type: "D",
				count: "",
				billedAmnt: "",
				serviceCalled: false
			};
			inputRows.push(row);
		}
		cmp.set("v.us04OutpatientInputRows", inputRows);
	},

	clearInputRowUB: function (row) {
		row.start = "";
		row.end = "";
		row.revCode = "";
		row.cptOrHcpc = "";
		row.modifier = "";
		row.primaryDx = "";
		row.addlDx = "";
		row.rxNdc = "";
		row.type = "D";
		row.count = "";
		row.billedAmnt = "";
		row.serviceCalled = false;
		return row;
	},

	callContractService: function (cmp) {
		cmp.set("v.showSpinner", true);
		var inputs = cmp.get("v.inputRows");
		var requestList = [];
		inputs.forEach(element => {
			if (element.start != "" && !element.serviceCalled) {
				var reqObj = new Object();
				reqObj.startDate = element.start;
				reqObj.endDate = element.end;
				reqObj.pos = element.pos;
				reqObj.cpthcpc = element.cptOrHcpc;
				reqObj.modifier = element.modifier;
				reqObj.dx = element.dx;
				reqObj.type = element.type;
				reqObj.count = element.count;
				reqObj.billedAmount = element.billedAmnt;
				requestList.push(reqObj);
			}
		});
		var action = cmp.get("c.callContractService");
		var policyDetails = cmp.get("v.policyData");
		action.setParams({
			provId : cmp.get("v.providerId"),
			taxId : cmp.get("v.taxId"),
			mktType : policyDetails.marketType,
			mktNbr : policyDetails.marketSite,
			prdtOffCd : policyDetails.productCode,
			requestList : requestList
		});
		action.setCallback(this, function (response) {
			var state = response.getState();
			var resp = response.getReturnValue();
			if (state === "SUCCESS") {				
				if (!resp.isSuccess) {
					this.showToastMessage(resp.message, "error", "pesky", "30000");
				}else{
					cmp.set("v.consolidatedData", response.getReturnValue().response);
                    //this.callFeeSchedule(cmp); //blinker
				}
			} else if (state === "INCOMPLETE") {
				this.showToastMessage(resp.message, "error", "pesky", "30000");
			} else if (state === "ERROR") {
				this.showToastMessage(resp.message, "error", "pesky", "30000");
			}
			cmp.set("v.showSpinner", false);
		});
		$A.enqueueAction(action);
        cmp.set("v.showSpinner", false);
	},

	reportValidity: function (cmp) {
		var allValid = cmp.find('inputfields').reduce(function (validSoFar, inputCmp) {
            inputCmp.reportValidity();
            return validSoFar && inputCmp.checkValidity();
        }, true);

		return allValid;
	},
        
    billType: function(cmp){
	 var action = cmp.get("c.billTypecheck");
		action.setParams({
			billType: cmp.get("v.billtype")	
		});
		action.setCallback(this, function (response) {
			var state = response.getState();
			if (state === "SUCCESS") {
				var result = response.getReturnValue();
                cmp.set("v.radioSelectionInpatientOutpatient",result);
            }
		});
		$A.enqueueAction(action);
	

	},

	// US3464932: 28 April 2021
	autofillClaimToFeeSchedule: function(cmp){
		// This function is to autofill Fee Schedule table using data from Claims
		var claimsData = cmp.get('v.claimsFeeScheduleData');
        var feeScheduletable = cmp.get("v.inputRows");
		if(!$A.util.isEmpty(claimsData)){
            if(claimsData.length > 0){
                var feeScheduleIndex = 0;
                for(var index = 0; index < claimsData.length; index++){
                    if(feeScheduleIndex < feeScheduletable.length){
                        feeScheduletable[feeScheduleIndex].start = claimsData[index].fromDate;
                        feeScheduletable[feeScheduleIndex].end = claimsData[index].toDate;
                        feeScheduletable[feeScheduleIndex].pos = claimsData[index].pos;
                        feeScheduletable[feeScheduleIndex].cptOrHcpc = claimsData[index].procCode;
                        feeScheduletable[feeScheduleIndex].modifier = claimsData[index].modifier;
                        feeScheduletable[feeScheduleIndex].dx = claimsData[index].diagnosisCode;
                        feeScheduletable[feeScheduleIndex].type = claimsData[index].unitType;
                        feeScheduletable[feeScheduleIndex].count = claimsData[index].noOfUnits;
                        feeScheduletable[feeScheduleIndex].billedAmnt = claimsData[index].chargeAmount;
						feeScheduletable[feeScheduleIndex].serviceCalled = false;
                    }else{
                        var row = new Object();
                        row.start = claimsData[index].fromDate;
                        row.end = claimsData[index].toDate;
                        row.pos = claimsData[index].pos;
                        row.cptOrHcpc = claimsData[index].procCode;
                        row.modifier = claimsData[index].modifier;
                        row.dx = claimsData[index].diagnosisCode;
                        row.type = claimsData[index].unitType;
                        row.count = claimsData[index].noOfUnits;
                        row.billedAmnt = claimsData[index].chargeAmount;
						row.serviceCalled = false;
                        feeScheduletable.push(row);
                    }
                    feeScheduleIndex++;
                }
                cmp.set("v.inputRows", feeScheduletable);

				this.callContractService(cmp);
            }
		}
	}
})