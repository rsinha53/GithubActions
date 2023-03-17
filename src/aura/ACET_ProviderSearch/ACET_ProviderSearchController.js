({
	doInit: function (cmp, event, helper) {
		cmp.set("v.providerDetails", helper.initializeProviderDetails(cmp));
		helper.getFilterTypeOptions(cmp);
		helper.getPracticingStatusOptions(cmp);
	},
    
    handleOnBlur: function (cmp, event, helper) {
		var eventSource = event.getSource();
		var fieldName = eventSource.get("v.name");
		var fieldValue = eventSource.get("v.value");
        if (fieldName == "taxIdOrNPI") {
            if(!$A.util.isEmpty(fieldValue) && fieldValue.length < 9) {
                eventSource.setCustomValidity('Enter nine digits.');
            } else {
                eventSource.setCustomValidity('');
            }
            eventSource.reportValidity();   
		}
	},

	handleOnChange: function (cmp, event, helper) {
		var flowDetails = cmp.get("v.flowDetails");
		var providerDetails = cmp.get("v.providerDetails");
		var eventSource = event.getSource();
		var fieldName = eventSource.get("v.name");
		var fieldValue = eventSource.get("v.value");
        //US2598275: Updates to Contact Name Entry Field
        var contactFirstName = flowDetails.contactFirstName;
        var contactLastName = flowDetails.contactLastName;
        if (fieldName == "taxIdOrNPI") {
			eventSource.set("v.value", fieldValue.trim());
		}
		if (fieldName == "contactName" || fieldName == "contactFirstName" || fieldName == "contactLastName") {
            eventSource.set("v.value", fieldValue.trimStart());
			var fieldValue = helper.keepOnlyText(cmp, event);
            //US2598275: Updates to Contact Name Entry Field
            if(fieldName == "contactFirstName"){
                flowDetails.contactFirstName = fieldValue;
                if(!$A.util.isEmpty(flowDetails.contactFirstName) && !$A.util.isEmpty(flowDetails.contactLastName)){
                flowDetails.contactName = flowDetails.contactFirstName.trim() +' '+ flowDetails.contactLastName.trim();
            }
            }
            if(fieldName == "contactLastName"){
                flowDetails.contactLastName = fieldValue;
                if(!$A.util.isEmpty(flowDetails.contactFirstName) && !$A.util.isEmpty(flowDetails.contactLastName)){
                flowDetails.contactName = flowDetails.contactFirstName.trim() +' '+ flowDetails.contactLastName.trim();
            }
            }
			//flowDetails.contactName = fieldValue;
		}
		if (fieldName == "phoneNumber" || fieldName == "contactNumber" || fieldName == "contactExt" || fieldName == "otherContactNumber" || fieldName == "otherContactExt") {
			var fieldValue = helper.keepOnlyDigits(cmp, event);
			if (fieldName == "contactNumber") {
				flowDetails.contactNumber = fieldValue;
			}
			if (fieldName == "contactExt") {
				flowDetails.contactExt = fieldValue;
			}
		}
		cmp.set("v.flowDetails", flowDetails);
		//checking member not found field validation to disable or enable member search card
		if (providerDetails.isProviderNotFound) {
			helper.checkPNFMandatoryFields(cmp);
		} else if (providerDetails.isOther) {
			helper.checkOtherMandatoryFields(cmp);
		}
		if (cmp.get("v.showErrorMessage")) {
			var timer = cmp.get('v.timer');
			clearTimeout(timer);
			var timer = setTimeout(function () {
				helper.checkValidation(cmp, event);
				clearTimeout(timer);
				cmp.set('v.timer', null);
			}, 3000);
			cmp.set('v.timer', timer);
		}
        //US2598275: Updates to Contact Name Entry Field
		if (fieldName != "contactName" && fieldName != "contactNumber" && fieldName != "contactExt" && fieldName != "contactFirstName" && fieldName != "contactLastName") {
			cmp.set("v.providerSearchResults", null);
			cmp.set("v.refineSearchCriteriaMsg", "");
		}
	},

	clearFieldValidationsAndValues: function (cmp, event, helper) {
        //US2757958-Contact Number/Ext - Carry Over to Other/Misdirect Entry Fields
        cmp.set("v.isClearbuttonClciked",true);
		helper.clearFieldValues(cmp);
		helper.clearFieldValidations(cmp);
		cmp.set("v.refineSearchCriteriaMsg", "");
	},

	searchProvider: function (cmp, event, helper) {
		cmp.find("memberCardSpinnerAI").set("v.isTrue", true);
		if (helper.checkValidation(cmp, event)) {

			//US3181616 - Sravan -Start
			var flowDetails = cmp.get("v.flowDetails");
			flowDetails.conStartTime = cmp.get("v.startTime");
			flowDetails.conStartType = cmp.get("v.startTimeType");
			flowDetails.conEndTime = cmp.get("v.endTime");
			flowDetails.conEndType = cmp.get("v.endTimeType");
			flowDetails.conTimeZone = cmp.get("v.timeZone");
			cmp.set("v.flowDetails", flowDetails);
			//US3181616 - Sravan - End
			console.log('Flow Details'+ JSON.stringify(cmp.get("v.flowDetails")));
			helper.searchProvider(cmp, event);
		} else {
			cmp.find("memberCardSpinnerAI").set("v.isTrue", false);
		}
	},

	showOrHideAdvancedSearch: function (cmp, event, helper) {
		cmp.set("v.providerDetails.isAdvancedSearch", !cmp.get("v.providerDetails.isAdvancedSearch"));
		helper.clearFieldValidations(cmp);
	},

	handleNoProviderToSearch: function (cmp, event, helper) {
		var providerDetails = helper.initializeProviderDetails(cmp);
		providerDetails.isNoProviderToSearch = event.getParam("checked");
		cmp.set("v.providerDetails", providerDetails);
		cmp.set("v.calloutProviderNotFound", false);
		cmp.set("v.isMemSearchDisabledFromPrv", false);
		helper.clearFieldValidations(cmp);
		cmp.set("v.providerSearchResults", null);
	},

	handleProviderNotFound: function (cmp, event, helper) {
		var providerDetails = cmp.get("v.providerDetails");
		providerDetails.isNoProviderToSearch = false;
		providerDetails.isOther = false;
		providerDetails.isValidProvider = false;
		cmp.set("v.providerDetails", providerDetails);
		helper.checkPNFMandatoryFields(cmp);
		helper.clearFieldValidations(cmp);
		cmp.set("v.providerSearchResults", null);
	},

	handleOtherChange: function (cmp, event, helper) {
		var providerDetails = cmp.get("v.providerDetails");
		providerDetails.isOther = !event.getParam("value");
		cmp.set("v.providerDetails", providerDetails);
		cmp.set("v.calloutProviderNotFound", false);
		helper.clearFieldValidations(cmp);
		helper.clearFieldValues(cmp);
		if (!event.getParam("value")) {
			helper.checkOtherMandatoryFields(cmp);
		}
	},
    
    /**
     * To Handle VCCD Application Event .
     *
     * @param objComponent To access dom elements.
     * @param objEvent To handle events.
     * @param objHelper To handle events.
     */
    handleVCCDEvent : function (objComponent, objEvent, objHelper) {
        let strMessage = objEvent.getParam("message");
        if ($A.util.isUndefinedOrNull(strMessage) === false && strMessage !== '') {
            try {
                let objMessage = JSON.parse(strMessage);
                objComponent.set("v.isOther", true);
                objHelper.clearFieldValues(objComponent);
                objHelper.clearFieldValidations(objComponent);
                objComponent.set("v.providerDetails.taxIdOrNPI", objMessage.objRecordData.TaxId__c);
                objComponent.set("v.flowDetails.contactNumber", (objMessage.objRecordData.Ani__c.length > 10 ? objMessage.objRecordData.Ani__c.substring(objMessage.objRecordData.Ani__c.length-10) : objMessage.objRecordData.Ani__c ));
                objEvent.stopPropagation();
            } catch (exception) {
                console.log('Inside VCCD Handle Exception' + exception);
            }
        }
    },
    
    onClickOfEnter : function(cmp,event, helper) {
        if (event.keyCode === 13 && event.target.className != 'linkField') {
            event.preventDefault();
            var providerDetail = cmp.get("v.providerDetails");
            
            if(!cmp.get("v.providerDetails").isOther && !cmp.get("v.providerDetails").isProviderNotFound ){
                JSON.parse(JSON.stringify(cmp.get("v.providerDetails")));
                console.log("v.providerDetails.isNoProviderToSearch");
                cmp.find("memberCardSpinnerAI").set("v.isTrue", true);
                if (helper.checkValidation(cmp, event)) {
                    var flowDetails = cmp.get("v.flowDetails");
                    flowDetails.conStartTime = cmp.get("v.startTime");
                    flowDetails.conStartType = cmp.get("v.startTimeType");
                    flowDetails.conEndTime = cmp.get("v.endTime");
                    flowDetails.conEndType = cmp.get("v.endTimeType");
                    flowDetails.conTimeZone = cmp.get("v.timeZone");
                    cmp.set("v.flowDetails", flowDetails);
                    helper.searchProvider(cmp, event);
                } else {
                    cmp.find("memberCardSpinnerAI").set("v.isTrue", false);
                } 
            }
            
        }
	},
	
	//US2826419
	handlePrvValidation: function(cmp,event, helper) {
        cmp.set('v.isContactDetailsRequired', true);
        if (!helper.checkValidation(cmp, event)) {
            return false;
        }
            cmp.set("v.firePrvValidationFromMember",event.getParam('fireValidation') );
    },

	//US3181616 - Sravan -Start
	latestValues: function(component, event, helper){
		var flowDetails = component.get("v.flowDetails");
		console.log('Flow Details'+ JSON.stringify(flowDetails));
		var eventSource = event.getSource();
		var fieldName = eventSource.get("v.name");
		var fieldValue = eventSource.get("v.value");
		if(fieldName == "startTimeType"){
			flowDetails.conStartType = fieldValue;
		}
		if(fieldName == "endTimeType"){
			flowDetails.conEndType = fieldValue;
		}
		if(fieldName == "timeZone"){
			flowDetails.conTimeZone = fieldValue;
		}
		component.set("v.flowDetails", flowDetails);
	},

	startTimeChange: function(component, event, helper){
		var flowDetails = component.get("v.flowDetails");
		flowDetails.conStartTime = component.get("v.startTime");
		component.set("v.flowDetails", flowDetails);

	},

	endTimeChange: function(component, event, helper){
		var flowDetails = component.get("v.flowDetails");
		flowDetails.conEndTime = component.get("v.endTime");
		component.set("v.flowDetails", flowDetails);
	}
	//US3181616 - Sravan - End
})