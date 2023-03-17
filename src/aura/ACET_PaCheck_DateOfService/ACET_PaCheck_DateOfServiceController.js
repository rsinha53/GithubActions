({
	// US2974833
	init: function (component, event, helper) {
        //US3597798 - Sravan - Start
        var delegationValue = component.get("v.delegationValue");
        console.log('Delegation Value'+ JSON.stringify(delegationValue));
        if(!$A.util.isUndefinedOrNull(delegationValue) && !$A.util.isEmpty(delegationValue)){
            component.set("v.showPostAcuteCareServices",true);
         /*  if(delegationValue != 'No'){
                component.set("v.showDelegatedToIntake",true);
            }
            else{
                component.set("v.showDelegatedToIntake",false);
            } */
        }
        else{
            component.set("v.showPostAcuteCareServices",false);
        }
        //US3597798 - Sravan - End
		helper.doInit(component, event,helper);
	},

	// US3089189
	bindValues: function (cmp, event, helper) {
		helper.bindValues(cmp, event);
        helper.updateAutoDoc(cmp, event,helper);//US3584404 - Sravan
	},

	// US2974833
	fireValidations: function (cmp, event, helper) { 
		if (!$A.util.isUndefinedOrNull(event.getParam("tabId")) && event.getParam("tabId") == cmp.get('v.paCheckTabId')) {
			helper.executeValidations(cmp, event);
		}
	},

    handleSelectCheckBox: function (component, event, helper) {
        var cardDetails = component.get("v.cardDetails");
        var PACheckData = component.get("v.PACheckData");
        if (!$A.util.isUndefinedOrNull(cardDetails)) {
            var checked = event.getSource().get("v.checked");
            var inputFieldName = event.getSource().get("v.name");
            if(inputFieldName === "Date of Service"){
                component.set("v.isDateOfServiceCheckBox", checked);
                cardDetails.cardData[0].checked = checked;
                cardDetails.cardData[0].fieldValue = (($A.util.isUndefinedOrNull(PACheckData) || $A.util.isUndefinedOrNull(PACheckData.DOSAndPOS) || $A.util.isUndefinedOrNull(PACheckData.DOSAndPOS.DateOfService)) ? "--" : PACheckData.DOSAndPOS.DateOfService);
            }
            if(inputFieldName === "Place of Service"){
                component.set("v.isPlaceOfServiceCheckBox", checked);
                cardDetails.cardData[1].checked = checked;
                cardDetails.cardData[1].fieldValue = (($A.util.isUndefinedOrNull(PACheckData) || $A.util.isUndefinedOrNull(PACheckData.DOSAndPOS) || $A.util.isUndefinedOrNull(PACheckData.DOSAndPOS.PlaceOfService)) ? "--" : PACheckData.DOSAndPOS.PlaceOfService);
            }
            var cardDataListNew = [];
            var isDateOfServiceCheckBox = component.get("v.isDateOfServiceCheckBox");
            var isPlaceOfServiceCheckBox = component.get("v.isPlaceOfServiceCheckBox");
            if( isDateOfServiceCheckBox && isPlaceOfServiceCheckBox){
                component.set("v.isSelectAll", true);
            }else{
                component.set("v.isSelectAll", false);
            }
            /*if(isDateOfServiceCheckBox){
                var dateOfServiceAutoDocRec = {
                    "checked": true,
                    "fieldName": "Date of Service",
                    "fieldType": "outputText",
                    "fieldValue": (($A.util.isUndefinedOrNull(PACheckData) || $A.util.isUndefinedOrNull(PACheckData.DOSAndPOS) || $A.util.isUndefinedOrNull(PACheckData.DOSAndPOS.DateOfService)) ? "--" : PACheckData.DOSAndPOS.DateOfService),
                    "showCheckbox": true,
                    "isReportable":true
                }
                cardDataListNew.push(dateOfServiceAutoDocRec);
            }

            if(isPlaceOfServiceCheckBox){
                var placeOfServiceAutoDocRec = {
                    "checked": true,
                    "fieldName": "Place of Service",
                    "fieldType": "outputText",
                    "fieldValue": (($A.util.isUndefinedOrNull(PACheckData) || $A.util.isUndefinedOrNull(PACheckData.DOSAndPOS) || $A.util.isUndefinedOrNull(PACheckData.DOSAndPOS.PlaceOfService)) ? "--" : PACheckData.DOSAndPOS.PlaceOfService),
                    "showCheckbox": true,
                    "isReportable":true
                }
                cardDataListNew.push(placeOfServiceAutoDocRec);
            }

            cardDetails.cardData = cardDataListNew;*/

            component.set("v.cardDetails", cardDetails);
            _autodoc.setAutodoc(component.get("v.autodocUniqueId"),component.get("v.autodocUniqueIdCmp"), cardDetails);
        }
    },

    selectAll: function (component, event, helper) {
        var checked = event.getSource().get("v.checked");
        var cardDetails = component.get("v.cardDetails");
        component.set("v.isDateOfServiceCheckBox", checked);
        component.set("v.isPlaceOfServiceCheckBox", checked);
        component.set("v.isSelectAll", checked);
        var cardData = cardDetails.cardData;
        for (var i of cardData) {
            if (i.showCheckbox && !i.defaultChecked) {
                i.checked = checked;
            }
        }
        component.set("v.cardDetails", cardDetails);
        _autodoc.setAutodoc(component.get("v.autodocUniqueId"),component.get("v.autodocUniqueIdCmp"), cardDetails);
	}

})