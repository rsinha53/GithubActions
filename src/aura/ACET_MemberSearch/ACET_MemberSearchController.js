({
	doInit: function (cmp, event, helper) {
		helper.initializeMemberDetails(cmp);
	},

	showOrHideAdvancedSearch: function (cmp, event, helper) {
		cmp.set("v.memberDetails.isAdvancedSearch", !cmp.get("v.memberDetails.isAdvancedSearch"));
		helper.clearFieldValidations(cmp);
	},

	handleOnChange: function (cmp, event, helper) {
		var flowDetails = cmp.get("v.flowDetails");
		var eventSource = event.getSource();
		var fieldName = eventSource.get("v.name");
		var fieldValue = eventSource.get("v.value");
		if (fieldName == "contactName" || fieldName == "contactFirstName" || fieldName == "contactLastName") {
        			//US2598275: Updates to Contact Name Entry Field
        			eventSource.set("v.value", fieldValue.trimStart());
        			fieldValue = helper.keepOnlyText(cmp, event);
        			if(fieldName == "contactFirstName"){
                        flowDetails.contactFirstName = fieldValue;
                        flowDetails.contactName = flowDetails.contactFirstName.trim()+' '+ flowDetails.contactLastName.trim();
                    }
                    if(fieldName == "contactLastName"){
                        flowDetails.contactLastName = fieldValue;
                        flowDetails.contactName = flowDetails.contactFirstName.trim() +' '+ flowDetails.contactLastName.trim();
                    }
        		}
        		cmp.set("v.flowDetails", flowDetails);
		if (fieldName == "memberId" || fieldName == "dob" || fieldName == "firstName" || fieldName == "lastName"|| fieldName == "groupNumber") {
			cmp.set("v.findIndividualSearchResults", null);
            var memberDetails = cmp.get("v.memberDetails");
            memberDetails.isFindIndividualSearch = false;
            cmp.set("v.memberDetails",memberDetails);
		}
		if (fieldName == "phoneNumber" || fieldName == "contactNumber" || fieldName == "contactExt") {
			helper.keepOnlyDigits(cmp, event);
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
	},

	handleMemSearchDisabledFromPrvChange: function (cmp, event, helper) {
		helper.clearFieldValidations(cmp, event);
		//cmp.set("v.findIndividualSearchResults", null);
	},

	clearFieldValidationsAndValues: function (cmp, event, helper) {
		helper.clearFieldValues(cmp, event);
		helper.clearFieldValidations(cmp, event);
		cmp.set("v.calloutMemberNotFound", false);
		//cmp.set("v.findIndividualSearchResults", null);
	},
    
    onClickOfEnter : function(cmp,event, helper) {
        if (event.keyCode === 13 && event.target.className != 'linkField') {
            //event.preventDefault();
            helper.executeMemberSearch(cmp, event);
        }
    },

	openInteractionOverview: function (cmp, event, helper) {
        if (event.keyCode === 13) {
            //event.preventDefault();
            helper.executeMemberSearch(cmp, event);
        }else{
            helper.executeMemberSearch(cmp, event);
        }
        
	},

	handleNoMemberToSearch: function (cmp, event, helper) {
		helper.clearFieldValidations(cmp, event);
		var flowDetails = cmp.get("v.flowDetails");
		var memberDetails = cmp.get("v.memberDetails");
		memberDetails.isFindIndividualSearch = false;
		memberDetails.isValidMember = false;
		memberDetails.isMemberNotFound = false;
		memberDetails.isAdvancedSearch = false;
		cmp.set("v.flowDetails", flowDetails);
		cmp.set("v.memberDetails", memberDetails);
		cmp.set("v.findIndividualSearchResults", null);
	},

	handleMemberNotFound: function (cmp, event, helper) {
		helper.clearFieldValidations(cmp, event);
		var flowDetails = cmp.get("v.flowDetails");
		var memberDetails = cmp.get("v.memberDetails");
		memberDetails.isFindIndividualSearch = false;
		memberDetails.isValidMember = false;
		memberDetails.isNoMemberToSearch = false;
		cmp.set("v.memberDetails", memberDetails);
		cmp.set("v.flowDetails", flowDetails);
		cmp.set("v.findIndividualSearchResults", null);
	},
	/**
     * To Handle VCCD Application Event .
     *
     * @param objComponent To access dom elements.
     * @param objEvent To handle events.
     *
     * @param objHelper To handle events.
     */
    handleVCCDEvent : function (objComponent, objEvent, objHelper) {
        let strMessage = objEvent.getParam("message");
        if($A.util.isUndefinedOrNull(strMessage) === false && strMessage !== '') {
            try {
                let objMessage = JSON.parse(strMessage);
                objHelper.clearFieldValues(objComponent);
                objHelper.clearFieldValidations(objComponent);
                objComponent.set("v.memberDetails.memberId", objMessage.objRecordData.MemberId__c);
                console.log('==@@' + JSON.stringify(objMessage));
                objComponent.set("v.isVCCD", objMessage.isVCCD); //US2631703 - Durga- 08th June 2020
                objComponent.set("v.VCCDObjRecordId", objMessage.objRecordData.Id); //US2631703 - Durga- 08th June 2020
                //US2570805 - Sravan - Start
                objComponent.set("v.VCCDQuestionType",objMessage.objRecordData.QuestionType__c);
                //US2570805 - Sravan - Stop
                if($A.util.isUndefinedOrNull(objMessage.objRecordData.SubjectDOB__c) === false) {
                    objComponent.find("dobAI").set("v.value", objMessage.objRecordData.SubjectDOB__c);
                    objComponent.set("v.memberDetails.dob", objMessage.objRecordData.SubjectDOB__c);
                }
                objEvent.stopPropagation();
            } catch (exception) {
                console.log('Inside VCCD Handle Exception' + exception);
            }
        }
    },
    
    handleSelectedMember: function (cmp, event, helper) {
        setTimeout( function() { 
            var btn = cmp.find("continueBtnID");
            btn.focus();
        },500);
    },
    
    handleSelectedProvider: function (cmp, event, helper) {
        if(!$A.util.isUndefinedOrNull(cmp.get("v.selectedProviderRecord"))){
            var btn = cmp.find("memberIdAI");
            btn.focus();
        }
    },
})