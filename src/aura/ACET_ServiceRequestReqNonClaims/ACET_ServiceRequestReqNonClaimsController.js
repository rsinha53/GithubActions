({
	issueChange : function(component, event, helper) {
		component.set("v.strIssue", component.get("v.sendToListInputs.issue"));
	}, 

	setFilterCondition : function(component, event, helper) {
		/*if(event && event.getParam("value")) {
			component.set("v.whereTTSTopics", event.getParam("value"));
			component.find('issueId').callgetComboboxRecords();
		} Commented as part of DE448724 -Sravan*/
		let params = event.getParam('arguments');
		if (params) {
			component.set("v.whereTTSTopics", params.strWhereCondition);
			component.find('issueId').callgetComboboxRecords();
		}//DE448724 - Sravan
	},

	cancel : function(component) {
		let lstDelegatedValues = component.get("v.lstSelectedRoutedProviders"), lstValues = [];
		lstDelegatedValues.forEach(function(objEach){
			let pattern = {};
			pattern['uniqueKey'] = objEach['uniqueKey'];
			pattern['isDelegatedSpecialty'] = objEach['IsDelegatedSpeciality'];
			lstValues.push(pattern);
		});
        component.set("v.strDelegatedData", JSON.stringify(lstValues));
		var cmpEvent = component.getEvent("closeRoutingTab");
		cmpEvent.setParams({"strData" : JSON.stringify(lstValues)});
        cmpEvent.fire();
	},

    handleRadioChange : function(cmp,event,helper){

    },

    handleSSNChanges: function(cmp,event,helper){
         helper.keepOnlyDigits(cmp,event);
    },

	//US3259671 - Sravan - Start
	validateHoursOfOperation : function(component, event, helper){
		var flowDetails = component.get("v.flowDetails");
		if(!$A.util.isUndefinedOrNull(flowDetails) && !$A.util.isEmpty(flowDetails)){
			//Start Time
			if(!$A.util.isUndefinedOrNull(flowDetails.conStartTime) && !$A.util.isEmpty(flowDetails.conStartTime)){
				if(flowDetails.conStartTime == 'Select'){
					component.find('startTimeId').checkValidation();
                    component.find('startTimeId').find('comboboxFieldAI').reportValidity();
				}
			}
			else{
				component.find('startTimeId').checkValidation();
                component.find('startTimeId').find('comboboxFieldAI').reportValidity();
			}
			//End Time
			if(!$A.util.isUndefinedOrNull(flowDetails.conEndTime) && !$A.util.isEmpty(flowDetails.conEndTime)){
				if(flowDetails.conEndTime == 'Select'){
					component.find("endTimeId").checkValidation();
                    component.find("endTimeId").find('comboboxFieldAI').reportValidity();
		}
			}
			else{
				component.find("endTimeId").checkValidation();
				component.find("endTimeId").find('comboboxFieldAI').reportValidity();
			}

		}

	},
	//US3259671 - Sravan - End
	onChangeContact:function(cmp, event, helper){
		var conField = cmp.find("idContactNumber");
		var contact = cmp.find("idContactNumber").get("v.value");
		var removeSpace = contact.replaceAll(' ','');
		var removeDash = removeSpace.replaceAll('-','');
		var index = removeDash.indexOf('Ext');
		 cmp.set("v.isValiadContact",false);
		if(index >= 0){
			var finalContact = removeDash.substring(0,index);
			let charCount = finalContact.length;
			if(charCount != 10){
				conField.setCustomValidity("Enter 10 Digits");
			}else{
                cmp.set("v.isValiadContact",true);
				conField.setCustomValidity("");
			}
		} else  {
			if(removeDash.length == 0){
				conField.setCustomValidity("This field is required");
			}else if(removeDash.length != 10){
				conField.setCustomValidity("Enter 10 Digits");
			}else{
				conField.setCustomValidity("");
                cmp.set("v.isValiadContact",true);
			}
		}
	}
})