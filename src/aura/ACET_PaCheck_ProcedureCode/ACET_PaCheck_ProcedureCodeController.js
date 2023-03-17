({
	// US2974833
	init: function (component, event, helper) {
		helper.doInit(component, event);
	},

	deleteRaw: function (cmp, event, helper) {

		var rowIndex = event.currentTarget.getAttribute("data-row-index");

		// US3089189
		var PACheckData = cmp.get('v.PACheckData');

		for (var i = 0; i < PACheckData.ProcedureCode.ProcedureCodes.length; i++) {
			if (i == rowIndex) {
				// US3379720
				let procedureObject = {
					"procedureCode": "",
					"diagnosisCode": "",
					"modifier": "",
					"charge": "10",
					"count": "1",
					"units": "1",
					"measure": "Units",
					"frequency": "1"
				};
				PACheckData.ProcedureCode.ProcedureCodes[i] = procedureObject;
				cmp.set('v.PACheckData', PACheckData);
				break;
			}
		}

	},

    copyDX: function (cmp, event, helper){
        var rowIndex = event.currentTarget.getAttribute("data-row-index");
        var PACheckData = cmp.get('v.PACheckData');
        var aboveData = PACheckData.ProcedureCode.ProcedureCodes[rowIndex -1];
        var currentRowData = PACheckData.ProcedureCode.ProcedureCodes[rowIndex];
        if(!$A.util.isEmpty(aboveData.diagnosisCode)){
            currentRowData.diagnosisCode = aboveData.diagnosisCode;
            currentRowData.copyClick = true;
            PACheckData.ProcedureCode.ProcedureCodes[rowIndex] = currentRowData;
            cmp.set('v.PACheckData', PACheckData);
        }

    },

	addRaw: function (cmp, event, helper) {

		// US3089189
		helper.addRaw(cmp, event, helper);

	},

	// US3067258 Swapnil
	showBenefitandAuthResults: function (cmp, event, helper) {
		//US2974833
		cmp.set('v.btnClicked', 'PriorAuth');
		var appEvent = $A.get("e.c:ACET_PaCheck_FireValidations");
		appEvent.setParams({
			"tabId": cmp.get('v.paCheckTabId')
		});
		appEvent.fire();
	},

	// US3089189
	callBenefitCheck: function (cmp, event, helper) {
		// US2974833
		cmp.set('v.btnClicked', 'BenefitCheck');
		var appEvent = $A.get("e.c:ACET_PaCheck_FireValidations");
		appEvent.setParams({
			"tabId": cmp.get('v.paCheckTabId')
		});
		appEvent.fire();
	},

	// US2974833
	fireValidations: function (cmp, event, helper) {

		if (!$A.util.isUndefinedOrNull(event.getParam("tabId")) && event.getParam("tabId") == cmp.get('v.paCheckTabId')) {

			// US2950839
			helper.executeValidations(cmp, event);

			// US2974833
			setTimeout(function () {
				var errors = cmp.get('v.errors');
				var error = cmp.get('v.error');
				var isValidDOS = errors.errorsDOS.isValidDOS;
				var isValidPC = errors.errorsPC.isValidPC;
				error.descriptionList = [];
				var arr = error.descriptionList.concat(errors.errorsDOS.errorsList);
				arr = arr.concat(errors.errorsPC.errorsList);
				error.descriptionList = arr;
				cmp.set('v.error', error);
				if (!isValidDOS || !isValidPC) {
					cmp.set('v.showErrorMessage', true);
					cmp.find("errorPopup").showPopup();
				} else {
					var btnClicked = cmp.get('v.btnClicked');
					if (btnClicked === 'BenefitCheck') {
						helper.callBenefitCheck(cmp, event, helper);
					} else if (btnClicked === 'PriorAuth') {
						helper.callPriorAuthResult(cmp, event, helper);
					}
					cmp.set('v.showErrorMessage', false);
				}
			});

		}

	},

	// US2974833 Swapnil
	alphanumericAndNoSpecialCharacters: function (cmp, event, helper) {
		helper.keepAlphanumericAndNoSpecialCharacters(cmp, event);
	},

	// US2974833 Swapnil
	bindValues: function (cmp, event, helper) {
		var fieldName = event.getSource().get("v.name");
		var fieldValue = event.getSource().get("v.value");
		if (fieldName.startsWith('diagnosisCode')) {
			helper.validateCodesWithDot(cmp, event);
		} else if (fieldName.startsWith('procedureCode')) {
			event.getSource().setCustomValidity('');
			if (fieldValue.length < 5) {
				event.getSource().setCustomValidity('Invalid input.');
			}
			fieldValue = fieldValue.toUpperCase();
			cmp.set("v.PACheckData.ProcedureCode.ProcedureCodes[" + fieldName.split('procedureCode')[1] + "].procedureCode", fieldValue);
		}
	},
    handleKLData: function (cmp, event, helper) {
        var cmpsss=cmp.get('v.selectedKLDataMap');
     	var objectDt = event.getParam("selectedKLRecord");
        cmpsss[objectDt.Name]=objectDt.Code_Description__c;
        cmp.set('v.selectedKLDataMap',cmpsss);
	}


})