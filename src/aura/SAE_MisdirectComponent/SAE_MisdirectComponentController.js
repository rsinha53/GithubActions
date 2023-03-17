({
    handleKeyup : function(component, event) {
        var elem = event.getSource().get('v.value');
        var max = 2000;
        var remaining = max - elem.length;
        component.set('v.charsRemaining', remaining);
    },
    
    checkCommentsLength : function(component, event) {
        var inputCmp = component.find("commentsId");
        var value = inputCmp.get("v.value");
        var errorMessage = 'Error!  You have reached the maximum character limit.  Add additional comments in Case Details as a new case comment.';
        if (value.length >= 2000) {
            inputCmp.setCustomValidity(errorMessage);
			inputCmp.reportValidity();
        } else {
            inputCmp.setCustomValidity('');
            inputCmp.reportValidity();
        }
    },
    
    checkMandatoryFields: function (cmp, event, helper) {
        var fieldName = event.getSource().get("v.name");
        if (fieldName == "contactNumber") { 
            helper.keepOnlyDigits(cmp, event);
        }
        var eventSource = event.getSource();
        var fieldValue = eventSource.get("v.value");
        //US2598275: Updates to Contact Name Entry Field
        if(fieldName == "contactName" || fieldName == "contactFirstName" || fieldName == "contactLastName"){
            eventSource.set("v.value", fieldValue.trimStart());
            helper.keepOnlyText(cmp, event);
            if(fieldName == "contactFirstName" || fieldName == "contactLastName"){
                var contactName = cmp.get("v.contactFirstName").trim()+' '+cmp.get("v.contactLastName").trim();
                cmp.set("v.contactName", contactName);
                console.log("contactName misdirect: "+cmp.get("v.contactName"));
            }
        }
    },
    
    misDirectReasons: function (cmp, event, helper) {
        
        var pageReference = cmp.get("v.pageReference");
        
        var originatorName = pageReference.state.c__originatorName;
        var originatorType = pageReference.state.c__originatorType;
        var exploreOriginator = pageReference.state.c__exploreOriginator;
        if(!$A.util.isUndefinedOrNull(exploreOriginator)){
            cmp.set("v.exploreOriginator",exploreOriginator);
        }
        //US2903847
        var flowDetails = pageReference.state.c__flowInfo;
        cmp.set("v.flowDetails",flowDetails);
        //var contactName = pageReference.state.c__contactName;
        var subjectName = pageReference.state.c__subjectName;
        var subjectType = pageReference.state.c__subjectType;
        var subjectDOB = pageReference.state.c__subjectDOB;
        var subjectID = pageReference.state.c__subjectID;
        var subjectGrpID = pageReference.state.c__subjectGrpID;
        var interactionID = pageReference.state.c__interactionID;
        
        //DE441126 - Start
        if(!$A.util.isUndefinedOrNull(pageReference.state.c__onShoreRestriction)){
            cmp.set("v.onShoreRestriction", pageReference.state.c__onShoreRestriction);
        }
        if(!$A.util.isUndefinedOrNull(pageReference.state.c__uhgRestriction)){
            cmp.set("v.uhgRestriction", pageReference.state.c__uhgRestriction);
        }
        //DE441126 - ends
		// US1889740 - Sarma (Date: 1st Aug 2019) - Misdirect Case creation - Start
		var mnf = pageReference.state.c__mnf;
        var isMms = pageReference.state.c__isMms;
        var contactUniqueId = pageReference.state.c__contactUniqueId;
        cmp.set("v.contactUniqueId", contactUniqueId);
		// US1889740 - Sarma (Date: 1st Aug 2019) - Misdirect Case creation - End
        var contactDetails = _setandgetvalues.getContactValue(contactUniqueId);
        
        var contactName = '';
        var contactFirstName = '';
        var contactLastName = '';
        var contactNumber = '';
        var contactExt = '';

        if(!$A.util.isEmpty(contactDetails)) {
            console.log('===@@67'+JSON.stringify(contactDetails));
            contactName = contactDetails.contactName;
            contactFirstName = contactDetails.contactFirstName;
            contactLastName = contactDetails.contactLastName;
            contactNumber = contactDetails.contactNumber;
            contactExt = contactDetails.contactExt;
        }
        
        //US2705857 - Sravan - Start
        var isQuickAction = pageReference.state.c__isQuickAction;
        if(isQuickAction == true){
            contactName = pageReference.state.c__contactName;
            contactFirstName =  pageReference.state.c__contactFirstName;
            contactLastName =  pageReference.state.c__contactLastName;
            contactNumber =  pageReference.state.c__contactNumber;
            contactExt =  pageReference.state.c__contactExt;

        }

        //US2705857 - Sravan - End


        //US3612768 - Sravan - Start
        var selectedProviderDetails = pageReference.state.c__selectedProviderDetails;
        var explorePageSourceCode = pageReference.state.c__sourceCode;
        var isOther = pageReference.state.c__isOther;
        var providerDetails = pageReference.state.c__providerDetails;
        var isNoProviderToSearch = false;
        var isProviderNotFound = false;
        var isMemberNotFound = false;
        var isNoMemberToSearch = false;
        if(!$A.util.isUndefinedOrNull(providerDetails) && !$A.util.isEmpty(providerDetails)){
        	isNoProviderToSearch = providerDetails.isNoProviderToSearch;
            isProviderNotFound = providerDetails.isProviderNotFound;
        }
		var selectedProviderName = '';
		var selectedProviderPhone = '';
        var providerId = '';
		if(!$A.util.isUndefinedOrNull(selectedProviderDetails) && !$A.util.isEmpty(selectedProviderDetails)){
			for(var key in selectedProviderDetails){
				var physicianFacilityInformation = selectedProviderDetails[key];
                console.log('Phyisicain key'+ JSON.stringify(physicianFacilityInformation));
				if(!$A.util.isUndefinedOrNull(physicianFacilityInformation) && !$A.util.isEmpty(physicianFacilityInformation)){
					selectedProviderName = physicianFacilityInformation['firstName']+' '+physicianFacilityInformation['lastName'];
                    providerId = physicianFacilityInformation['providerId'];
					var phone = physicianFacilityInformation['phone'];
					if(!$A.util.isUndefinedOrNull(phone) && !$A.util.isEmpty(phone)){
						for(var phonekey in phone){
							selectedProviderPhone = '('+phone[phonekey].areaCode+')'+phone[phonekey].phoneNumber;
                        }
					}
				}

			}
		}
		console.log('Selected Provider Name'+ selectedProviderName);
		console.log('Selected Provider Phone'+selectedProviderPhone);
        cmp.set("v.selectedProviderName",selectedProviderName);
        cmp.set("v.selectedProviderPhone",selectedProviderPhone);
        cmp.set("v.providerId",providerId);
        cmp.set("v.isOther",isOther);
        cmp.set("v.isNoProviderToSearch",isNoProviderToSearch);
        cmp.set("v.isProviderNotFound",isProviderNotFound);

        var memberDetails = pageReference.state.c__memberDetails;
        var selectedMemberDetails = pageReference.state.c__selectedMemberDetails;
        var subjectSourceCode = '';
        if(!$A.util.isUndefinedOrNull(memberDetails) && !$A.util.isEmpty(memberDetails)){
            if(! memberDetails.isAdvancedSearch){
        	subjectName = memberDetails.subjectName;
            subjectSourceCode = memberDetails.sourceCode;
            subjectID = memberDetails.memberId;
            isMemberNotFound = memberDetails.isMemberNotFound;
            isNoMemberToSearch = memberDetails.isNoMemberToSearch;
        }
        }
        if(!$A.util.isUndefinedOrNull(selectedMemberDetails) && !$A.util.isEmpty(selectedMemberDetails)){
            if(selectedMemberDetails.isAdvancedSearch){
        		subjectName = selectedMemberDetails.firstName+' '+selectedMemberDetails.lastName ;
            	subjectSourceCode = selectedMemberDetails.sourceCode;
            	subjectID = selectedMemberDetails.memberId;
            	isMemberNotFound = selectedMemberDetails.isMemberNotFound;
           		isNoMemberToSearch = selectedMemberDetails.isNoMemberToSearch;
            }
        }
        console.log('Selected Subject Name'+ subjectName);

		console.log('Selected Subject SourceCode'+subjectSourceCode);
        console.log('Selected Subject Id'+subjectID);
        if($A.util.isUndefinedOrNull(memberDetails) || $A.util.isEmpty(memberDetails)){
            if(!$A.util.isUndefinedOrNull(explorePageSourceCode) && !$A.util.isEmpty(explorePageSourceCode)){
            	subjectSourceCode = explorePageSourceCode;
            }
        }
        cmp.set("v.subjectSourceCode",subjectSourceCode);
        cmp.set("v.isMemberNotFound",isMemberNotFound);
        cmp.set("v.isNoMemberToSearch",isNoMemberToSearch);

        //US3612768 - Sravan - End

		//US3816776 - Sravan - Start
		var patientInfo = pageReference.state.c__patientInfo;
        if(!$A.util.isUndefinedOrNull(patientInfo) && !$A.util.isEmpty(patientInfo)){
         	cmp.set("v.patientInfo",patientInfo);
			subjectDOB = patientInfo.dobVal;
        }
        var highlightedPolicySourceCode = pageReference.state.c__highlightedPolicySourceCode;
        if(!$A.util.isUndefinedOrNull(highlightedPolicySourceCode) && !$A.util.isEmpty(highlightedPolicySourceCode)){
            cmp.set("v.highlightedPolicySourceCode",highlightedPolicySourceCode);
        }

        var highlightedPolicyNumber = pageReference.state.c__highlightedPolicyNumber;
        if(!$A.util.isUndefinedOrNull(highlightedPolicyNumber) && !$A.util.isEmpty(highlightedPolicyNumber)){
           cmp.set("v.highlightedPolicyNumber",highlightedPolicyNumber);
        }
        //US3816776 - Sravan - End


        cmp.set("v.originatorName", originatorName);
        cmp.set("v.originatorType", originatorType);
        cmp.set("v.contactName", contactName);
         //US2740876 - Sravan - Start
        cmp.set("v.contactFirstName", contactFirstName);
        cmp.set("v.contactLastName", contactLastName);
        //US2740876 - Sravan - End
        cmp.set("v.contactNumber", contactNumber);
        cmp.set("v.contactExt",contactExt);
        cmp.set("v.subjectName", subjectName);
        cmp.set("v.subjectType", subjectType);
        cmp.set("v.subjectDOB", subjectDOB);
        cmp.set("v.subjectID", subjectID);
        cmp.set("v.subjectGrpID", subjectGrpID);
        cmp.set("v.interactionID", interactionID);
		// US1889740 - Sarma (Date: 1st Aug 2019) - Misdirect Case creation - Start
		cmp.set("v.mnf", mnf);
        cmp.set("v.isMms", isMms);
        cmp.set("v.focusedTabId",pageReference.state.c__focusedTabId);
		// US1889740 - Sarma (Date: 1st Aug 2019) - Misdirect Case creation - End
        cmp.set("v.isVCCD",pageReference.state.c__isVCCD);//US2631703 - Durga- 08th June 2020
        cmp.set("v.VCCDObjRecordId",pageReference.state.c__VCCDRespId);//US2631703 - Durga- 08th June 2020
        helper.misDirectReasonsHelper(cmp, event, helper);
        helper.getCallHandlingOneSourceURL(cmp, event, helper);
    },
    
    submitMisDirectReasons: function (component, event, helper) {
        helper.showMisdirectSpinner(component);
        var reasonsId = component.find('misReasonsId');
        var reasonVal = reasonsId.get('v.value');
        console.log('>>> ' + $A.util.isEmpty(reasonVal));
        /*   if(!$A.util.isEmpty(reasonVal)){
            reasonsId.setCustomValidity("Complete this field");
        }else{
            reasonsId.setCustomValidity("");
        } */

        var controlAuraIds = ["misReasonsId","contactNumberID","contactFirstNameID","contactLastNameID"];
        //reducer function iterates over the array and return false if any of the field is invalid otherwise true.
        var isFLNamesValid = controlAuraIds.reduce(function (isValidSoFar, controlAuraIds) {
            //fetches the component details from the auraId
            var inputCmp = component.find(controlAuraIds);
            //displays the error messages associated with field if any
            inputCmp.reportValidity();
            //form will be invalid if any of the field's valid property provides false value.
            return isValidSoFar && inputCmp.checkValidity();
        }, true);

        if (isFLNamesValid) {
			// US1889740 - Sarma (Date: 1st Aug 2019) - Misdirect Case creation - helper method call
			helper.createMisdirectCase(component, event, helper);
            //helper.closeFocusedTab(component, event, helper);
        } else {
            helper.hideMisdirectSpinner(component);
        }

    },

    cancelMisdirect : function(component,event,helper){
        helper.closeFocusedTab(component, event, helper);
    },

    //!Test Function - Delete Later
    closeTabTest: function (component, event, helper) {
        var workspaceAPI = component.find("workspace");
        workspaceAPI.getFocusedTabInfo().then(function (response) {
                var focusedTabId = response.tabId;
                workspaceAPI.closeTab({
                    tabId: focusedTabId
                });
            })
            .catch(function (error) {
                console.log(error);
            });
    },

    //US2384492 enter key press event by vishnu kasu
    enterKeyPress: function (component, event, helper)
    {
        if (event.keyCode === 13)
        {
            var keyAction=component.get('c.submitMisDirectReasons');
            $A.enqueueAction(keyAction);
        }
    },
    changeFocus : function (cmp, event, helper)
    {
        var reasonsId = cmp.find('misReasonsId');
        var reasonVal = reasonsId.get('v.value');
       	if(!$A.util.isUndefinedOrNull(reasonVal) && reasonVal!='None')
        {
         	var firstName = cmp.find("contactFirstNameID");
       		firstName.focus();
        }

    },
    openCallHandlingOneSource: function (cmp, event, helper) {
       var callHandlingOneSourceUrl = cmp.get("v.callHandlingOneSourceURL");
        if(!$A.util.isUndefinedOrNull(callHandlingOneSourceUrl) && !$A.util.isEmpty(callHandlingOneSourceUrl)){
            window.open(callHandlingOneSourceUrl, '_blank');
        }
    }
})