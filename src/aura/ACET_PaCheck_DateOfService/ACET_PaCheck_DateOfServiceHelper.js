({
	// US2974833
	doInit: function (component, event,helper) {
		var error = {};
		error.errorsDOS = {
			'isValidDOS': false,
			'errorsList': []
		};
		error.errorsPC = {
			'isValidPC': false,
			'errorsList': []
		};
		component.set('v.errors', error);
        setTimeout(function() {
            helper.createAutoDoc(component, event,helper);
        }, 100);
	},

	// US3089189
	bindValues: function (cmp, event) {
		var PACheckData = cmp.get('v.PACheckData');
		var fieldValue = event.getSource().get("v.value");
		var fieldName = event.getSource().get("v.name");
		PACheckData.DOSAndPOS[fieldName] = fieldValue;
		cmp.set('v.PACheckData', PACheckData);
	},

	// US2974833 Swapnil
	executeValidations: function (cmp, event) { 
		var errors = cmp.get('v.errors');
		errors.errorsDOS.isValidDOS = false;
		errors.errorsDOS.errorsList = [];
		var fieldsToValidate = cmp.get('v.fieldsToValidate');
		var validationCounter = 0;
		for (var i in fieldsToValidate) {
			var fieldElement = cmp.find(fieldsToValidate[i]); 
			if (!$A.util.isUndefined(fieldElement)) { 
				if (!fieldElement.checkValidity()) {
					validationCounter++;
					errors.errorsDOS.errorsList.push(fieldElement.get("v.label"));
				}
				fieldElement.reportValidity();
			}
		}
		if (0 == validationCounter) {
			errors.errorsDOS.isValidDOS = true;
		} 
		cmp.set('v.errors', errors);
	},

    createAutoDoc : function(component, event, helper){
        var PACheckData = component.get("v.PACheckData");
        var cardDetails = new Object();
        cardDetails.componentName = "Date of Service and Place of Service";
        cardDetails.componentOrder = 15;
        cardDetails.noOfColumns = "slds-size_6-of-12";//US3584404 - Sravan
        cardDetails.type = "card";
        cardDetails.caseItemsExtId = "PA Check";
        cardDetails.allChecked = false;
        cardDetails.cardData = [
            {
                "checked": true,
                "disableCheckbox":true,
                "fieldName": "Date of Service",
                "fieldType": "outputText",
                "fieldValue": (($A.util.isUndefinedOrNull(PACheckData) || $A.util.isUndefinedOrNull(PACheckData.DOSAndPOS) || $A.util.isUndefinedOrNull(PACheckData.DOSAndPOS.DateOfService)) ? "--" : PACheckData.DOSAndPOS.DateOfService),
                "showCheckbox": true,
                "isReportable":($A.util.isEmpty(PACheckData) || $A.util.isEmpty(PACheckData.DOSAndPOS) || $A.util.isEmpty(PACheckData.DOSAndPOS.DateOfService)) ? false : true
            },
            {
                "checked": true,
                "disableCheckbox":true,
                "fieldName": "Place of Service",
                "fieldType": "outputText",
                "fieldValue": (($A.util.isUndefinedOrNull(PACheckData) || $A.util.isUndefinedOrNull(PACheckData.DOSAndPOS) || $A.util.isUndefinedOrNull(PACheckData.DOSAndPOS.PlaceOfService)) ? "--" : PACheckData.DOSAndPOS.PlaceOfService),
                "showCheckbox": true,
                "isReportable":(($A.util.isEmpty(PACheckData) || $A.util.isEmpty(PACheckData.DOSAndPOS) || $A.util.isEmpty(PACheckData.DOSAndPOS.PlaceOfService)) ? false : true)
            }
        ];

        component.set("v.cardDetails", cardDetails);

        try {
            _autodoc.setAutodoc(component.get("v.autodocUniqueId"), component.get("v.autodocUniqueIdCmp"), cardDetails);
        }catch(err) {
            console.log("PA Check Date of service autodoc: "+err);
        }
	},

	//US3584404 - Sravan - Start
	updateAutoDoc : function(component, event, helper){
		var PACheckData = component.get("v.PACheckData");
		var cardDetails = component.get("v.cardDetails");
		if(!$A.util.isUndefinedOrNull(cardDetails) && !$A.util.isEmpty(cardDetails)){
			if(!$A.util.isUndefinedOrNull(cardDetails.cardData) && !$A.util.isEmpty(cardDetails.cardData)){
				var cardData = cardDetails.cardData;
				var updatedCardData = [];
				for(var key in cardData){
					if(cardData[key].fieldName == 'Date of Service'){
						cardData[key].fieldValue = 	(($A.util.isUndefinedOrNull(PACheckData) || $A.util.isUndefinedOrNull(PACheckData.DOSAndPOS) || $A.util.isUndefinedOrNull(PACheckData.DOSAndPOS.DateOfService)) ? "--" : PACheckData.DOSAndPOS.DateOfService);
						cardData[key].isReportable = (($A.util.isUndefinedOrNull(PACheckData) || $A.util.isUndefinedOrNull(PACheckData.DOSAndPOS) || $A.util.isUndefinedOrNull(PACheckData.DOSAndPOS.DateOfService)) ? false : true); // US3742854
					}
					else if(cardData[key].fieldName == 'Place of Service'){
						cardData[key].fieldValue = (($A.util.isUndefinedOrNull(PACheckData) || $A.util.isUndefinedOrNull(PACheckData.DOSAndPOS) || $A.util.isUndefinedOrNull(PACheckData.DOSAndPOS.PlaceOfService)) ? "--" : PACheckData.DOSAndPOS.PlaceOfService);
						cardData[key].isReportable = (($A.util.isUndefinedOrNull(PACheckData) || $A.util.isUndefinedOrNull(PACheckData.DOSAndPOS) || $A.util.isUndefinedOrNull(PACheckData.DOSAndPOS.PlaceOfService)) ? false : true); // US3742854
					}
					updatedCardData.push(cardData[key]);
				}
				if(!$A.util.isUndefinedOrNull(updatedCardData) && !$A.util.isEmpty(updatedCardData)){
					cardDetails.cardData = updatedCardData;
	}
				component.set("v.cardDetails",cardDetails);
				try {
					_autodoc.setAutodoc(component.get("v.autodocUniqueId"), component.get("v.autodocUniqueIdCmp"), cardDetails);
				}catch(err) {
					console.log("PA Check Date of service autodoc: "+err);
				}
			}
		}
	}
	//US3584404 - Sravan - End

})