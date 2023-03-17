({
    fetchMockStatus : function(component) { 
        let action = component.get("c.getMockStatus");
        action.setCallback( this, function(response) {
            let state = response.getState();
            if( state === "SUCCESS") {
                component.set("v.isMockEnabled", response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    },
    clear: function(component,event){
    	component.set("v.uhgAccess", "No");
        component.set("v.createdCaseSFID", "");
        component.set("v.createdCaseID", "");
        component.set("v.createdInteractionSFID", "");
        component.set("v.createdInteractionID", "");
        component.set("v.originatorText", "");
        component.set("v.originatorSelected", "");
        component.set("v.originatorFilter", "");    
        component.set("v.enableEditButton", false);
        component.set("v.searchGroupPolicyNum", "");
        component.set("v.groupSelected", null);
        component.set("v.searchBroker", "");
        component.set("v.producerSelected", null);
        component.set("v.searchMemberIdSSN", "");
        component.set("v.memberSelected", null);
        component.set("v.displayMember", false);
		component.set("v.displayOriginator", false);
        component.set("v.businessUnitText", "None");
        component.set("v.businessUnitSelected", "None");
        component.set("v.topicText", "None");
        component.set("v.topicSelected", "None");
        component.set("v.filesList", "");
        component.set("v.isFilesList", false);
        component.set("v.validateOriginator", false);
        component.set("v.dcsmInfo", "");
        var origField = component.find("originatorField");
        $A.util.removeClass(origField, "slds-has-error");  
        component.find("validateOriginatorError").set("v.errors", null);
        if(component.get("v.oneAndDoneBool") == false){
        	var resolution = component.find("searchResolution");
        	$A.util.removeClass(resolution, "slds-has-error");  
    		component.find("resolutionError").set("v.errors", null);
        }
        var dropdownOptions = [];
        dropdownOptions.push({
            label: "None",
            value: "None"
        });
        component.set('v.topicOptions', dropdownOptions);
        component.set("v.interactionType", "Email");
        component.set("v.eventReceivedDate", "");
        console.log('TESTING TIME1: ' + component.get('v.eventReceivedTime'));
        component.set("v.eventReceivedTime", "");
        console.log('TESTING TIME2: ' + component.get('v.eventReceivedTime'));
        component.set("v.searchResolution", "");
        //broker stuff
        //clear attached files
    },
    searchInstructionRecords : function(component, event) {
        console.log('inside search instructions1');
        var spinner = component.find("dropdown-spinner");
        $A.util.removeClass(spinner, "slds-hide");
        $A.util.addClass(spinner, "slds-show");
		var instructionSearchType = component.get("v.instructionSearchType");
		var businessUnit = component.get("v.businessUnitSelected");
		var topic = '';
		var type = '';
		var action = component.get("c.populateBusinessDropdown");
		var userRole = '';
		if(component.get("v.userInfo").Role_Name__c == "System Administrator"){
			userRole = component.get("v.userInfo").Role_Name__c;
		} else {
			userRole = component.get("v.userInfo").BEO_Specialty__c;
		}
		var userProfile = component.get("v.userInfo").Profile_Name__c;
		console.log("HERE IS THE USER: " + JSON.stringify(component.get("v.userInfo")));
		console.log("HERE IS THE PROFILE: " + userProfile);
		var sendBusinessUnit = businessUnit;
		if(userRole != null && userRole != '' && userRole != undefined){
			action.setParams({
				searchType: instructionSearchType,
				searchBusinessUnit: sendBusinessUnit,
				searchTopic: topic,
				searchTypeSel: type,
				searchUser: userRole,
				searchProfile: userProfile
			});
			console.log('before callback');
			action.setCallback(this,function(response){
				var state = response.getState();
				console.log('STATE: ' + state);
	    		if(state == "SUCCESS"){
	    			var storeResponse = response.getReturnValue();
	    			console.log('RESULTS: ' + storeResponse);
	    			var dropdownOptions = [];
	    			dropdownOptions.push({
		                label: "None",
		                value: "None"
		            });
	    			for (var i = 0; i < storeResponse.length; i++) {
			        	dropdownOptions.push({
			                label: storeResponse[i],
			                value: storeResponse[i]
			            });
			        }
	    			if(instructionSearchType == "Business Unit"){
	    		        component.set('v.businessUnitOptions', dropdownOptions);
	    			} else if(instructionSearchType == "Topic"){
	    				component.set('v.topicOptions', dropdownOptions);
	                    console.log('HERE IS THE TOPIC LIST: ' + component.get('v.topicOptions'));
	    			} 
	                var spinner2 = component.find("dropdown-spinner");
	                $A.util.removeClass(spinner2, "slds-show");
	                $A.util.addClass(spinner2, "slds-hide");
	    		}
			});
			$A.enqueueAction(action);
		} else {
            var dropdownOptions = [];
            dropdownOptions.push({
                label: "None",
                value: "None"
            });
            component.set('v.businessUnitOptions', dropdownOptions);
            component.set('v.topicOptions', dropdownOptions);
            var spinner2 = component.find("dropdown-spinner");
            $A.util.removeClass(spinner2, "slds-show");
            $A.util.addClass(spinner2, "slds-hide");
        }
	},
    fireToast: function (message,duration) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "Error!",
            "message": message,
            "message": message,
            "type": "error",
            "mode": "dismissable",
			"duration": duration
        });
        toastEvent.fire();
    },
	closeAllDropdownsHelper:function(component,event,helper){
		component.set("v.displayBU", false);
    	component.set("v.displayTopic", false);
        component.set("v.displayOriginator", false);
    	if(component.get("v.businessUnitText") == ""){
    		component.set("v.businessUnitText", "None");
    	}
    	if(component.get("v.topicText") == ""){
    		component.set("v.topicText", "None");
    	}
	},
    //TODO starts here
    filterOriginators: function(component, event, helper){
        //if originatortext.length>=4, call controller to search, only return 30 results from DB call
        var typeText = component.get('v.originatorText');
        typeText = typeText.trim();
        if(typeText.length >= 4){
        	if(typeText.toLowerCase() == 'member'){
        		component.set('v.originatorFilter', []);
                component.set('v.displayOriginator', false);
                return;
        	} else {
	            var dataList = component.get("v.originatorOptions");
	            if (typeText == undefined || typeText == '') {
	                component.set('v.originatorFilter', []);
	                component.set('v.displayOriginator', false);
	                return;
	            }
	            typeText = typeText.toLowerCase();
	            var dataListFilter = [];
	            var action = component.get("c.findOriginator");
	            action.setParams({
	                searchField: typeText
	            });
				action.setCallback(this,function(response){
	                var state = response.getState();
	                console.log('STATE: ' + state);
	                if(state == "SUCCESS"){
	                    var storeResponse = response.getReturnValue();
	                    console.log('RESULTS: ' + JSON.stringify(storeResponse));
	                    var dropdownOptions = [];
	                    for (var i = 0; i < storeResponse.length; i++) {
	                    	if(storeResponse[i].Originator_Type__c == 'Other Originator'){
		                        dropdownOptions.push({
		                            label: storeResponse[i].Other_Originator_Type__c + '   ' + storeResponse[i].Last_Name__c + ', ' + storeResponse[i].First_Name__c + '   ' + storeResponse[i].Phone_Number__c + '   ' + storeResponse[i].Email__c,
		                            value: JSON.stringify(storeResponse[i])
		                        });
	
	                    	} else {
		                        dropdownOptions.push({
		                            label: storeResponse[i].Originator_Type__c + '   ' + storeResponse[i].Last_Name__c + ', ' + storeResponse[i].First_Name__c + '   ' + storeResponse[i].Phone_Number__c + '   ' + storeResponse[i].Email__c,
		                            value: JSON.stringify(storeResponse[i])
		                        });
	                    	}
	                    }
	                    console.log('Original filter list ' + JSON.stringify(dropdownOptions));
	                    if (dropdownOptions.length > 0) {
	                        component.set('v.originatorFilter', dropdownOptions);
	                        component.set('v.displayOriginator', true);
	                    } else {
	                        component.set('v.originatorFilter', []);
	                    }
	                }
	            });
	            $A.enqueueAction(action);
        	}
        }
    },
    
    filterBusinessUnits: function(component, event, helper){
        var typeText = component.get('v.businessUnitText');
        var dataList = component.get("v.businessUnitOptions");
        if (typeText == undefined || typeText == '') {
            component.set('v.businessUnitFilter', dataList);
            component.set('v.displayBU', false);
            return;
        }
        typeText = typeText.toLowerCase();
        var dataListFilter = [];
        for (var i = 0; i < dataList.length; i++) {
            if ((dataList[i].value.toLowerCase().indexOf(typeText) != -1) || (dataList[i].label.toLowerCase().indexOf(typeText) != -1)) {
                dataListFilter.push(dataList[i]);
            }
        }
        if (dataListFilter.length > 0) {
            component.set('v.businessUnitFilter', dataListFilter);
            component.set('v.displayBU', true);
        } else {
            component.set('v.businessUnitFilter', dataList);
        }
	},
    filterTopics: function(component, event, helper){
        var typeText = component.get('v.topicText');
        var dataList = component.get("v.topicOptions");
        if (typeText == undefined || typeText == '') {
            component.set('v.topicFilter', dataList);
            component.set('v.displayTopic', false);
            return;
        }
        typeText = typeText.toLowerCase();
        var dataListFilter = [];
        for (var i = 0; i < dataList.length; i++) {
            if ((dataList[i].value.toLowerCase().indexOf(typeText) != -1) || (dataList[i].label.toLowerCase().indexOf(typeText) != -1)) {
                dataListFilter.push(dataList[i]);
            }
        }
        if (dataListFilter.length > 0) {
            component.set('v.topicFilter', dataListFilter);
            component.set('v.displayTopic', true);
        } else {
            component.set('v.topicFilter', dataList);
        }
    },
    resetFields: function(component,event,helper){
		component.set("v.displayBU", false);
    	component.set("v.displayTopic", false);
    	var dropdownOptions = [];
		dropdownOptions.push({
            label: "None",
            value: "None"
        });
    	var getSearchType = component.get("v.instructionSearchType");
    	if(getSearchType == "Topic"){
    		component.set('v.topicOptions', dropdownOptions);
    		component.set('v.topicSelected', "None");
    		component.set('v.topicText', "None");
    	}
	},
    
    closeModal: function(component,event){
        component.set("v.originatorSelectedEdit", "");
        component.set("v.originatorSelectedNew", "");
        component.set("v.isContactModal", false);
        component.set("v.isEditContactModal", false);
        component.set("v.isNewContactModal", false);
        component.set("v.updateEditOriginatorTableBool", false);
        component.set("v.editOriginatorTableBool", false);
        component.set("v.editOriginatorTableData", "");
        component.set('v.editOriginatorTableMessage', "");
        component.set("v.updateAddOriginatorTableBool", false);
    	component.set('v.addOriginatorTableBool',false);
		component.set('v.addOriginatorTableData','');
		component.set('v.addOriginatorTableMessage', "");
    },
    
    submitEditCustomerAdmin: function(component,event,helper){
        console.log('TESTING1');
        var selOrig = component.get("v.originatorSelected");
        console.log('TESTING1.1: ' + JSON.stringify(selOrig));
        var action1 = component.get("c.submitEdit");
        action1.setParams({
            editSfId: selOrig.Id,
            editFirstName: selOrig.First_Name__c,
            editLastName: selOrig.Last_Name__c,
            editPhone: selOrig.Phone_Number__c,
            editPhoneExt: selOrig.Phone_Ext__c,
            editEmail: selOrig.Email__c,
            editOriginatorType: selOrig.Originator_Type__c,
            editAgencyBroker: selOrig.Agency_Broker_Name__c,
            editRewardAccount: selOrig.Reward_Account_Number__c,
            editGeneralAgency: selOrig.General_Agency__c,
            editFranchiseCode: selOrig.Franchise_Code__c,
            editGroupName: selOrig.Group_Name__c,
            editGroupNum: selOrig.Group_Number__c,
            editPolicyNum: selOrig.Policy_Number__c,
            editOtherOrigType: selOrig.Other_Originator_Type__c
        });
        action1.setCallback(this,function(response){
			var state = response.getState();
			console.log('testSTATE: ' + state);
    		if(state == "SUCCESS"){
    			var storeResponse = response.getReturnValue();
    			console.log('testRESULTS: ' + storeResponse);
            }
        });
        $A.enqueueAction(action1);
    },
    
    submitAddCustomerAdmin: function(component,event,helper){
        console.log('TESTING1');
        var selOrig = component.get("v.originatorSelected");
        console.log('TESTING1.1: ' + JSON.stringify(selOrig));
        var action1 = component.get("c.submitAdd");
        action1.setParams({
        	editSfId: selOrig.Id,
            editFirstName: selOrig.First_Name__c,
            editLastName: selOrig.Last_Name__c,
            editPhone: selOrig.Phone_Number__c,
            editPhoneExt: selOrig.Phone_Ext__c,
            editEmail: selOrig.Email__c,
            editOriginatorType: selOrig.Originator_Type__c,
            editAgencyBroker: selOrig.Agency_Broker_Name__c,
            editRewardAccount: selOrig.Reward_Account_Number__c,
            editGeneralAgency: selOrig.General_Agency__c,
            editFranchiseCode: selOrig.Franchise_Code__c,
            editGroupName: selOrig.Group_Name__c,
            editGroupNum: selOrig.Group_Number__c,
            editPolicyNum: selOrig.Policy_Number__c,
            editOtherOrigType: selOrig.Other_Originator_Type__c
        });
        action1.setCallback(this,function(response){
			var state = response.getState();
			console.log('testSTATE: ' + state);
    		if(state == "SUCCESS"){
    			var storeResponse = response.getReturnValue();
    			console.log('testRESULTS: ' + JSON.stringify(storeResponse));
                component.set("v.originatorSelected", storeResponse);
            }
        });
        $A.enqueueAction(action1);
    },
    validateEditContact: function(component,event,helper){
        var validation = false;
    	var errorMsg = '';
        var editOrig = component.get("v.originatorSelectedEdit");
        var editFieldsToValidate = ["editFirstName","editLastName"];
    	if(editOrig.Originator_Type__c == 'Agency/Broker'){
    		editFieldsToValidate.push("editAgencyBroker");
    		editFieldsToValidate.push("editRewardAccount");
    	} else if(editOrig.Originator_Type__c == 'General Agent'){
    		editFieldsToValidate.push("editGeneralAgency");
    		editFieldsToValidate.push("editFranchiseCode");
    	} else if(editOrig.Originator_Type__c == 'Group Contact'){
    		editFieldsToValidate.push("editGroupName");
    		editFieldsToValidate.push("editGroupNumber");
    		editFieldsToValidate.push("editPolicyNumber");
    	} 
    	var validationCounter = 0;
    	for (var i in editFieldsToValidate) {
            var fieldElement = component.find(editFieldsToValidate[i]);
            if (!$A.util.isUndefined(fieldElement)) {
                if (!fieldElement.checkValidity()) {
                    validationCounter++;
                }
                fieldElement.reportValidity();
            }
        }
    	var custEmail = component.find("editEmail");
    	var custPhone = component.find("editPhone");
    	$A.util.removeClass(custPhone, "slds-has-error");  
		component.find("phoneError").set("v.errors", null);
		$A.util.removeClass(custEmail, "slds-has-error");  
		component.find("emailError").set("v.errors", null);
    	if(custPhone.get("v.value") != '' && custPhone.get("v.value").length < 12){
    		$A.util.addClass(custPhone, "slds-has-error");
    		component.find("phoneError").set("v.errors", [{message:"Must enter ten digit phone number."}]);
    		validationCounter++;
    	} else if(custEmail.get("v.value") == '' && custPhone.get("v.value") == ''){
    		$A.util.addClass(custPhone, "slds-has-error");
    		component.find("phoneError").set("v.errors", [{message:"Must enter Telephone and/or Email Address."}]);
    		$A.util.addClass(custEmail, "slds-has-error");
    		component.find("emailError").set("v.errors", [{message:"Must enter Telephone and/or Email Address."}]);
    		validationCounter++;
    	} 
    	if(custEmail.get("v.value") != undefined && custEmail.get("v.value") != null && custEmail.get("v.value") != '') {
            var regExpEmailformat = /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/; 
            if(!(custEmail.get("v.value").match(regExpEmailformat))) {
                $A.util.addClass(custEmail, "slds-has-error");
    			component.find("emailError").set("v.errors", [{message:"You have entered an invalid format."}]);
                validationCounter++;
            }
        }
    	if(editOrig.Originator_Type__c == 'Other Originator'){
    		$A.util.removeClass(component.find("otherOriginatorError"), "slds-has-error");
    		component.find("otherOriginatorError").set("v.errors", null);
    		if(editOrig.Other_Originator_Type__c == "None"){
	    		$A.util.addClass(component.find("otherOriginatorError"), "slds-has-error");
	    		component.find("otherOriginatorError").set("v.errors", [{message:"Select a Type"}]);
	    		validationCounter++;
    		}
    	}
    	if (validationCounter == 0) {
            // all fields format and data is valid
    		validation = true;
        }
    	return validation;
    },
    validateAddContact: function(component,event,helper){
    	var validation = false;
    	var errorMsg = '';
        var editOrig = component.get("v.originatorSelectedAdd");
        var editFieldsToValidate = ["addFirstName","addLastName"];
    	if(editOrig.Originator_Type__c == 'Agency/Broker'){
    		editFieldsToValidate.push("addAgencyBroker");
    		editFieldsToValidate.push("addRewardAccount");
    	} else if(editOrig.Originator_Type__c == 'General Agent'){
    		editFieldsToValidate.push("addGeneralAgency");
    		editFieldsToValidate.push("addFranchiseCode");
    	} else if(editOrig.Originator_Type__c == 'Group Contact'){
    		editFieldsToValidate.push("addGroupName");
    		editFieldsToValidate.push("addGroupNumber");
    		editFieldsToValidate.push("addPolicyNumber");
    	} 
    	var validationCounter = 0;
    	for (var i in editFieldsToValidate) {
            var fieldElement = component.find(editFieldsToValidate[i]);
            if (!$A.util.isUndefined(fieldElement)) {
                if (!fieldElement.checkValidity()) {
                    validationCounter++;
                }
                fieldElement.reportValidity();
            }
        }
    	if(editOrig.Originator_Type__c == "None"){
    		var adminList = component.find("addOriginatorType");
    		$A.util.addClass(adminList, "slds-has-error");
    		component.find("addOriginatorTypeError").set("v.errors", [{message:"Must select an Originator Type."}]);
    		validationCounter++;
    	}
    	var custEmail = component.find("addEmail");
    	var custPhone = component.find("addPhone");
    	$A.util.removeClass(custPhone, "slds-has-error");  
		component.find("addPhoneError").set("v.errors", null);
		$A.util.removeClass(custEmail, "slds-has-error");  
		component.find("addEmailError").set("v.errors", null);
    	if(custPhone.get("v.value") != '' && custPhone.get("v.value").length < 12){
    		$A.util.addClass(custPhone, "slds-has-error");
    		component.find("addPhoneError").set("v.errors", [{message:"Must enter ten digit phone number."}]);
    		validationCounter++;
    	} else if(custEmail.get("v.value") == '' && custPhone.get("v.value") == ''){
    		$A.util.addClass(custPhone, "slds-has-error");
    		component.find("addPhoneError").set("v.errors", [{message:"Must enter Telephone and/or Email Address."}]);
    		$A.util.addClass(custEmail, "slds-has-error");
    		component.find("addEmailError").set("v.errors", [{message:"Must enter Telephone and/or Email Address."}]);
    		validationCounter++;
    	} 
    	if(custEmail.get("v.value") != undefined && custEmail.get("v.value") != null && custEmail.get("v.value") != '') {
            var regExpEmailformat = /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/; 
            if(!(custEmail.get("v.value").match(regExpEmailformat))) {
                $A.util.addClass(custEmail, "slds-has-error");
    			component.find("addEmailError").set("v.errors", [{message:"You have entered an invalid format."}]);
                validationCounter++;
            }
        }
    	if(editOrig.Originator_Type__c == 'Other Originator'){
    		$A.util.removeClass(component.find("addOtherOriginatorError"), "slds-has-error");
    		component.find("addOtherOriginatorError").set("v.errors", null);
    		if(editOrig.Other_Originator_Type__c == "None"){
	    		$A.util.addClass(component.find("addOtherOriginatorError"), "slds-has-error");
	    		component.find("addOtherOriginatorError").set("v.errors", [{message:"Select a Type"}]);
	    		validationCounter++;
    		}
    	}
    	if (validationCounter == 0) {
            // all fields format and data is valid
    		validation = true;
        }
    	return validation;
    },
    validateCreateCase: function(component,event,helper){
    	var validation = true;
    	var errorMsg = '';
    	var originatorText = component.get('v.originatorText');
    	if(originatorText != null && originatorText != undefined){
    		originatorText = originatorText.trim().toLowerCase();
    	}
        var selOrig = component.get("v.originatorSelected");
        var brokerDetail = component.get("v.producerSelected");
        var memberDetail = component.get("v.memberSelected");
        var groupDetail = component.get("v.groupSelected");
        if((selOrig == null || selOrig == undefined || selOrig =='') && originatorText != 'member'){
            console.log("VALIDATE-Originator: FAILED");
    		errorMsg = errorMsg + "Select an Originator|||";
    		validation = false;
        } else if(originatorText != 'member' &&((memberDetail == null || memberDetail == undefined || memberDetail =='') && (groupDetail == null || groupDetail == undefined || groupDetail =='') && (brokerDetail == null || brokerDetail == undefined || brokerDetail ==''))){
            console.log("VALIDATE-Subject: FAILED");
    		errorMsg = errorMsg + "Select a Group or Member or Broker|||";
    		validation = false;
        } else if((memberDetail != null && memberDetail != undefined && memberDetail !='') && (groupDetail == null || groupDetail == undefined || groupDetail =='')){
            console.log("VALIDATE-Subject: FAILED");
    		errorMsg = errorMsg + "Select a Group|||";
    		validation = false;
        } else if(originatorText == 'member' && (memberDetail == null || memberDetail == undefined || memberDetail =='')){
        	console.log("VALIDATE-Member Originator: FAILED");
    		errorMsg = errorMsg + "Select a Member|||";
    		validation = false;
        } else if(component.get("v.isCSOUser") == false && component.get("v.interactionType") == "None" || component.get("v.interactionType") == undefined){
            console.log("VALIDATE-Interaction Type: FAILED");
            errorMsg = errorMsg + "Select an Interaction Type|||";
            validation = false;
        } else if(component.get("v.isCSOUser") == false && component.get("v.interactionType") != "Research" && (component.get("v.eventReceivedDate") == null || component.get("v.eventReceivedDate") == undefined || component.get("v.eventReceivedDate") == '')){
            console.log("VALIDATE-Event Date: FAILED");
            errorMsg = errorMsg + "Select an Event Received Date|||";
            validation = false;
        } else if(component.get("v.isCSOUser") == false && component.get("v.interactionType") != "Research" && (component.get("v.eventReceivedTime") == null || component.get("v.eventReceivedTime") == undefined || component.get("v.eventReceivedTime") == '')){
            console.log("VALIDATE-Event Time: FAILED");
            errorMsg = errorMsg + "Select an Event Received Time|||";
            validation = false;
        } else if(component.get("v.isCSOUser") == false && (component.get("v.dcsmInfo") == null || component.get("v.dcsmInfo") == undefined || component.get("v.dcsmInfo") == '')){
            console.log("VALIDATE-Event Time: FAILED");
            errorMsg = errorMsg + "Enter DCSM Information|||";
            validation = false;
        } else if(component.get('v.searchMemberIdSSN') != null && component.get('v.searchMemberIdSSN') != undefined && component.get('v.searchMemberIdSSN') != '' && !component.get('v.searchMemberIdSSN').includes('-')){
        	errorMsg = errorMsg + $A.get("$Label.c.ETSBE_Explore_Page_Mem_Stop_Processing_Msg")+"|||";
    		validation = false;
        } else if(component.get('v.searchGroupPolicyNum') != null && component.get('v.searchGroupPolicyNum') != undefined && component.get('v.searchGroupPolicyNum') != '' && !component.get('v.searchGroupPolicyNum').includes('-')){
        	errorMsg = errorMsg + $A.get("$Label.c.ETSBE_Explore_Page_Group_Stop_Processing_Msg")+"|||";
    		validation = false;
        } else if(component.get('v.searchBroker') != null && component.get('v.searchBroker') != undefined && component.get('v.searchBroker') != '' && !component.get('v.searchBroker').includes('-')){
        	errorMsg = errorMsg + $A.get("$Label.c.ETSBE_Explore_Page_Broker_Stop_Processing_Msg")+"|||";
    		validation = false;
        }
        
    	if(validation == false){
    		while(errorMsg.includes("|||")){
    			errorMsg = errorMsg.replace("|||", ". \n")
    		}
    		console.log("ERROR MESSAGES: " + errorMsg);
    		this.fireToast(errorMsg, "10000");
    	}
    	return validation;
    },
    validateContinueBtn: function(component,event,helper){
    	var validation = true;
    	var errorMsg = '';
    	var originatorText = component.get('v.originatorText');
    	if(originatorText != null && originatorText != undefined){
    		originatorText = originatorText.trim().toLowerCase();
    	}
        var selOrig = component.get("v.originatorSelected");
        var memberDetail = component.get("v.memberSelected");
        var groupDetail = component.get("v.groupSelected");
        var brokerDetail = component.get("v.producerSelected");
        if((selOrig == null || selOrig == undefined || selOrig =='') && originatorText != 'member'){
            console.log("VALIDATE-Originator: FAILED");
    		errorMsg = errorMsg + "Select an Originator|||";
    		validation = false;
        } else if(originatorText != 'member' &&((memberDetail == null || memberDetail == undefined || memberDetail =='') && (groupDetail == null || groupDetail == undefined || groupDetail =='') && (brokerDetail == null || brokerDetail == undefined || brokerDetail ==''))){
            console.log("VALIDATE-Subject: FAILED");
    		errorMsg = errorMsg + "Select a Group or Member or Broker|||";
    		validation = false;
        } else if((memberDetail != null && memberDetail != undefined && memberDetail !='') && (groupDetail == null || groupDetail == undefined || groupDetail =='')){
            console.log("VALIDATE-Subject: FAILED");
    		errorMsg = errorMsg + "Select a Group|||";
    		validation = false;
        } else if(originatorText == 'member' && (memberDetail == null || memberDetail == undefined || memberDetail =='')){
        	console.log("VALIDATE-Member Originator: FAILED");
    		errorMsg = errorMsg + "Select a Member|||";
    		validation = false;
    	} else if(component.get("v.isResearchUser") == false && (component.get("v.interactionType") == "None" || component.get("v.interactionType") == undefined)){
    		console.log("VALIDATE-Interaction Type: FAILED");
    		errorMsg = errorMsg + "Select an Interaction Type|||";
    		validation = false;
    	} else if(component.get("v.interactionType") != "Research" && (component.get("v.eventReceivedDate") == null || component.get("v.eventReceivedDate") == undefined || component.get("v.eventReceivedDate") == '')){
    		console.log("VALIDATE-Event Date: FAILED");
    		errorMsg = errorMsg + "Select an Event Received Date|||";
    		validation = false;
    	} else if(component.get("v.interactionType") != "Research" && (component.get("v.eventReceivedTime") == null || component.get("v.eventReceivedTime") == undefined || component.get("v.eventReceivedTime") == '')){
    		console.log("VALIDATE-Event Time: FAILED");
    		errorMsg = errorMsg + "Select an Event Received Time|||";
    		validation = false;
    	} 
    	if(validation == false){
    		while(errorMsg.includes("|||")){
    			errorMsg = errorMsg.replace("|||", ". \n")
    		}
    		console.log("ERROR MESSAGES: " + errorMsg);
    		this.fireToast(errorMsg, "10000");
    	}
    	return validation;
    },
    navigateToGeneral: function(component,event,helper){
        var spinner = component.find("dropdown-spinner");
        $A.util.removeClass(spinner, "slds-hide");
        $A.util.addClass(spinner, "slds-show");
        component.set("v.createdCaseSFID", "");
    	component.set("v.createdCaseID", "");
    	component.set("v.filesList", "");
        var memberResultinfo = component.get("v.memberSelected");
        if(memberResultinfo == null){
            memberResultinfo = '';
        }
        console.log('MEMBER DATA FOR PASSING: ' + JSON.stringify(component.get("v.memberSelected")));
        var custmrAdmininfo = component.get("v.originatorSelected");
        var producerinfo = component.get("v.producerSelected");
           console.log('HERE IS CUSTOMER ADMIN FOR PASSING: '+JSON.stringify(producerinfo));
        var groupinfo = component.get("v.groupSelected");
        console.log('HERE IS CUSTOMER ADMIN FOR PASSING: ' + JSON.stringify(custmrAdmininfo));
        if(custmrAdmininfo == null || custmrAdmininfo == undefined){
        	custmrAdmininfo = {"adminType":"Member"};
        	console.log('HERE IS CUSTOMER ADMIN FOR PASSING2: ' + JSON.stringify(custmrAdmininfo));
        }
        var firstname;
        var SearchType;
        var lastname;
        var uniqueId;
        if(producerinfo != null && producerinfo != undefined && producerinfo != ''){
        	if(producerinfo.producerType == 'I'){
        		firstname = producerinfo.producerIndividualName.firstName;
        		lastname = producerinfo.producerIndividualName.lastName;
        	} else {
        		lastname = producerinfo.producerCompanyName;
        	}
        	SearchType = 'Producer';
        	uniqueId = producerinfo.producerID;
        }
        console.log('MEMDETAIL: ' + JSON.stringify(memberResultinfo));
        if(groupinfo != null && groupinfo!= undefined && groupinfo != ""){
        	firstname = '';
             lastname = groupinfo.groupName;
            SearchType = 'Group/Employer';
            uniqueId = groupinfo.groupId;
        }
        if(memberResultinfo != null && memberResultinfo!= undefined && memberResultinfo != ""){
             lastname = memberResultinfo.lastName;
            firstname = memberResultinfo.firstName;
             SearchType = 'Member';
             uniqueId = memberResultinfo.firstName + memberResultinfo.lastName + memberResultinfo.DOB + memberResultinfo.memberID;
        }
        var uhgAccess = component.get('v.uhgAccess');
        var accountaction = component.get("c.createPersonAccount");
        accountaction.setParams({"SearchType" :SearchType, 
                          "firstName": firstname,"lastName":lastname,
                                 "uniqueId":uniqueId,"dob":memberResultinfo.DOB,"uhgAccess":uhgAccess});
         accountaction.setCallback(this,function(response){
        	var state = response.getState();
        	if(state == "SUCCESS"){
                console.log('Person Account ID: ' + response.getReturnValue());
                var contactid = response.getReturnValue();
               
               
                 component.set("v.FlowType",SearchType);
                component.set("v.ContactId",contactid);
                
            }
         });
         $A.enqueueAction(accountaction);
        var selOrig = component.get("v.originatorSelected");
        //create interaction
        var action = component.get("c.createInteractionStandard");
        var interactionRec = '';
        var flowType = '';
        if(producerinfo != null && producerinfo!= undefined && producerinfo.producerId != null && producerinfo.producerId != ''){
            flowType = 'Producer';
        }
        if(groupinfo != null && groupinfo!= undefined && groupinfo.groupId != null && groupinfo.groupId != ''){
            flowType = 'Group/Employer';
        }
        if(memberResultinfo != null && memberResultinfo!= undefined && memberResultinfo.memberID != null && memberResultinfo.memberID != ''){
            flowType = 'Member';
        }
        var typeText = component.get('v.originatorText');
        typeText = typeText.trim();
        var memberFirstName = '';
        var memberLastName = '';
        var memberDOB = '';
        var memberId = '';
        var originatorId = '';
    	if(typeText.toLowerCase() == 'member'){
        	var memberData = component.get('v.memberSelected');
            memberFirstName = memberData.firstName;
            memberLastName = memberData.lastName;
            memberDOB = memberData.DOB;
            memberId = memberData.memberID;
        } else {
            originatorId = selOrig.Id;
        }
        console.log("DETAIL INFO: " + SearchType + ',' + flowType);
        var intType = '';
        if(component.get("v.isResearchUser") == true){
        	intType = "Research";
        } else {
        	intType = component.get("v.interactionType");
        }
        action.setParams({
            origSfId: originatorId,
    		interactionType: intType,
            eventReceivedDate: component.get("v.eventReceivedDate"),
            eventReceivedTime: component.get("v.eventReceivedTime"),
            memberFirstName: memberFirstName,
            memberLastName: memberLastName,
            memberDOB: memberDOB,
            memberId: memberId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state == "SUCCESS"){
                var storeResponse = response.getReturnValue();
                console.log('INTERACTION TO PASS THROUGH: ' + JSON.stringify(storeResponse));
                var interactionRec = storeResponse;
				var toProceedToCreateTheCase = true;
                if(interactionRec != undefined && interactionRec != null) {
                    var interactStatus = interactionRec.Current_Status__c;
                    interactStatus = (interactStatus != undefined && interactStatus != null) ? interactStatus : '';
                    if(interactStatus == 'Closed') {
                        var interactResDate = interactionRec.Resolution_Date__c;
                        interactResDate = (interactResDate != undefined && interactResDate != null) ? interactResDate : '';
                        if(interactResDate != '') {
                            interactResDate = interactResDate.substring(0, interactResDate.indexOf("T"));
                            var d = new Date(interactResDate);                            
                            var compareDate = new Date(d.getFullYear(), d.getMonth(), d.getDate());
                            var diff = Math.ceil(new Date() - compareDate);
                            var noOfDays = Math.floor(diff/(1000 * 60 * 60 * 24));
                            if(noOfDays != undefined && noOfDays != null && noOfDays > 90) {
                                toProceedToCreateTheCase = false;
                            }
                        }                        
                    }
                }
                
                if(toProceedToCreateTheCase) {
                    
                    var workspaceAPI = component.find("workspace");   
                    
                    var tabName='';
                    if(!$A.util.isUndefinedOrNull(producerinfo) && !$A.util.isEmpty(producerinfo)){
                        if(producerinfo.producerCompanyName != '') {
                            component.set('v.TabName', producerinfo.producerCompanyName.toUpperCase());
                        }else{
                            component.set('v.TabName', producerinfo.producerIndividualName.lastName.toUpperCase());   
                        }
                        
                    } 
                    if(!$A.util.isUndefinedOrNull(groupinfo) && !$A.util.isEmpty(groupinfo)){
                        component.set('v.TabName', groupinfo.groupName.toUpperCase());
                    } 
                    if(!$A.util.isUndefinedOrNull(memberResultinfo) && !$A.util.isEmpty(memberResultinfo)){
                        component.set('v.TabName', memberResultinfo.lastName.toUpperCase());
                    }
                    console.log('Person Account ID2: ' + response.getReturnValue());
                    var resolution = '';
                    var businessUnit = '';
                    var issueCategory = '';
                    if(component.get("v.searchResolution") != null && component.get("v.searchResolution") != undefined && component.get("v.searchResolution") != ''){
                        resolution = component.get("v.searchResolution");
                        resolution = resolution.trim();
                    }
                    if(component.get("v.businessUnitSelected") != null && component.get("v.businessUnitSelected") != undefined && component.get("v.businessUnitSelected") != '' && component.get("v.businessUnitSelected") != 'None'){
                        businessUnit = component.get("v.businessUnitSelected");
                    }
                    if(component.get("v.topicSelected") != null && component.get("v.topicSelected") != undefined && component.get("v.topicSelected") != '' && component.get("v.topicSelected") != 'None'){
                        issueCategory = component.get("v.topicSelected");
                    }
                    var specialInstructionsInfo = {
                        "resolution":resolution,
                        "businessUnit":businessUnit,
                        "issueCategory":issueCategory
                    };
                    
                    //add "c__ProducerInfo" :producerinfo, back
                    var isMember = '';
                    if(typeText.toLowerCase() == 'member'){
                        isMember = "Member";
                        custmrAdmininfo = {"Originator_Type__c":"Member"};
                    }
                    console.log('MEMBER INFO PASSED: ' + JSON.stringify(memberResultinfo));
                    workspaceAPI.openTab({
                        pageReference: {
                            "type": "standard__component",
                            "attributes": {
                                "componentName": "c__ETSBE_GeneralInfo"
                            },
                            "state": {
                                "c__MemberInfo" : memberResultinfo,
                                "c__AdminInfo" : custmrAdmininfo,
                                "c__GroupInfo": groupinfo,
                                "c__InteractionRecord": storeResponse,
                                "c__ProducerInfo" :producerinfo,
                                "c__AdminType":isMember,
                                "c__FlowType":component.get("v.FlowType"),
                                "c__ContactId": component.get("v.ContactId"),
                                "c__SpecialInstructionInfo":specialInstructionsInfo
                            }
                        },
                        focus: true
                    }).then(function(response) {
                        
                        workspaceAPI.getTabInfo({
                            tabId: response
                            
                        }).then(function(tabInfo) {
                            
                            workspaceAPI.setTabLabel({
                                tabId: tabInfo.tabId,
                                label:component.get('v.TabName')
                            });
                            workspaceAPI.setTabIcon({
                                tabId: tabInfo.tabId,
                                icon: "standard:people",
                                iconAlt: "Member"
                            });
                            
                        });
                    }).catch(function(error) {
                        console.log(error);
                    }); 
                    //pass to member detail page?                    
                } else {
                    
                    var toastType = "Error";
                    var toastMessage = "Case can only be opened within 90 days of Interaction Closed";
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "type":toastType,
                        "message": toastMessage
                    });
                    toastEvent.fire();
                }
                var spinner2 = component.find("dropdown-spinner");
                $A.util.removeClass(spinner2, "slds-show");
                $A.util.addClass(spinner2, "slds-hide");
        	}
        });
        $A.enqueueAction(action);    
    },
    
    // DE385766  
    createOneNDoneCase : function(component, event, originatorId, strWrapper, flowType, SIDescription, groupName,subjectName) {
        
        strWrapper = strWrapper + '"AddInfoTopic":"",'
        + '"AddInfoOrginType":"",'
        + '"AddInfoOrginSubType":"",'
        + '"ttsType":"",'
        + '"ttsSubType":"",'                    
        + '"noProviderToSearch":true,"isOtherSearch":false,"mnf":"","providerId":"","TaxId":"","noMemberToSearch":false,"OriginatorName":"ROBERT ROBERTS","OriginatorType":"Member","OriginatorRelationship":"","OriginatorContactName":"John Smith","OriginatorPhone":"","OriginatorEmail":"--","SubjectType":"Member","memberContactId":"","Status":"Open","PolicyCount":2,"CaseCreationFrom":"Member_Snapshot_Policies","AutoDoc":"","AutoDocCaseItems":""}';
		console.log('STRWRAPPER: ' + strWrapper);
        var dcsmInfo = component.get("v.dcsmInfo");
        var action1 = component.get("c.createBotCase");
        action1.setParams({
            origSfId: originatorId,
            strRecord: strWrapper,
            isProvider: false,
            contactID:component.get("v.ContactId"),
            flowType: flowType,
            resolution: SIDescription,
            dcsmId: dcsmInfo,
            groupName:groupName,     // DE385766  
            subjectName:subjectName
        });
        action1.setCallback(this, function(response) {
            var state = response.getState();
            if(state == "SUCCESS"){
                var storeResponse = response.getReturnValue();
                var spinner2 = component.find("dropdown-spinner");
                $A.util.removeClass(spinner2, "slds-show");
                $A.util.addClass(spinner2, "slds-hide");                        
                console.log('Case TO PASS THROUGH: ' + JSON.stringify(storeResponse));
                var toastType = "Error";
                var toastMessage = '';
                console.log('TEST RESPONSE LENGTH: ' + storeResponse.length);
                if(storeResponse != null && storeResponse.length > 1){
                    //alert('SUCCESS!');
                    component.set("v.createdCaseSFID", storeResponse[0]);
                    component.set("v.createdCaseID", storeResponse[1]);
                    toastType = "Success!";
                    toastMessage = "Case Number " + storeResponse[1] + " has been created.";
                } else {
                    //alert('FAILURE!');
                    toastMessage = "Issue with case creation.";
                }
                console.log('TEST RESPONSE MESSAGE: ' + toastMessage);
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "type":toastType,
                    "message": toastMessage
                });
                toastEvent.fire();
            } else {
                var spinner2 = component.find("dropdown-spinner");
                $A.util.removeClass(spinner2, "slds-show");
                $A.util.addClass(spinner2, "slds-hide");
                var toastType = "Error";
                var toastMessage = "Issue with case creation1.";
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "type":toastType,
                    "message": toastMessage
                });
                toastEvent.fire();
            }
        });
        $A.enqueueAction(action1); 
    },
    
    navigateToSpecInsPage : function(component, event, interactionRec, flowType, memberRelationship, specialInstructionsInfo) {
        
        var workspaceAPI = component.find("workspace"); 
        workspaceAPI.openTab({
            pageReference: {
                "type": "standard__component",
                "attributes": {
                    "componentName": "c__ETSBE_SpecialInstructions"
                },
                "state": {
                    "c__InteractionRecord": interactionRec,
                    "c__GroupData": component.get('v.groupSelected'),
                    "c__MemberData": component.get('v.memberSelected'),
                    "c__producerData": component.get('v.producerSelected'),
                    "c__CustomerAdminData": component.get('v.originatorSelected'),
                    "c__FlowType":flowType,
                    "c__ContactId":component.get("v.ContactId"),
                    "c__MemberRelationship":memberRelationship,
                    "c__SpecialInstructionInfo":specialInstructionsInfo
                }
            },
            focus: true
        }).then(function(response) {
            
            workspaceAPI.getTabInfo({
                tabId: response
                
            }).then(function(tabInfo) {
                
                workspaceAPI.setTabLabel({
                    tabId: tabInfo.tabId,
                    label: 'Special Instructions'
                });
                workspaceAPI.setTabIcon({
                    tabId: tabInfo.tabId,
                    icon: "standard:people",
                    iconAlt: "Member"
                });
                
            });
        }).catch(function(error) {
            console.log(error);
        }); 
        var spinner2 = component.find("dropdown-spinner");
        $A.util.removeClass(spinner2, "slds-show");
        $A.util.addClass(spinner2, "slds-hide");
    },
    fetchExlusionMdtData : function( component,event, helper ) {
		let action = component.get("c.getOptumExlusions");
        action.setCallback( this, function( response ) {
            let state = response.getState();
            if( state === "SUCCESS") {

                component.set( "v.lstExlusions", response.getReturnValue() );
                let lstExclusions = component.get("v.lstExlusions");
            } else {
                console.log('##UNKNOWN-STATE:',state);
            }
        });
        $A.enqueueAction(action);
    },
    
    searchSolarisOriginatorEdit: function(component,event,helper){
    	
    },
    searchSolarisOriginatorAdd: function(component,event,helper){
    	
    },
    validateSolarisOriginator: function(component,event,helper){
    	
    },
    
      validatedateTime : function(component, event, helper){
        var today = new Date();
        var min=today.getMinutes();
        var hrs=today.getHours();
        var dd = today.getDate();
        var mm = today.getMonth() + 1; 
        var yyyy = today.getFullYear();
        
        if(dd < 10){
            dd = '0' + dd;
        } 
        if(mm < 10){
            mm = '0' + mm;
        }
        if(min<10){
            min = '0' + min;
        }
        if(hrs<10){
            hrs='0' + hrs;
        } 
        
        var currentTime=hrs + ":" + min + ":" + "0" + "0" + "." + "0" + "0" + "0" ;  
        var todayFormattedDate = yyyy+'-'+mm+'-'+dd;
                
        //Date validation
        if(component.get("v.eventReceivedDate") != '' && component.get("v.eventReceivedDate") > todayFormattedDate){
            component.set("v.dateValidationError" , true);
        }
        else if(component.get("v.eventReceivedDate") == todayFormattedDate){
            component.set("v.dateValidationError" , false);
            if(component.get("v.eventReceivedTime")>currentTime){
                component.set("v.timeValidationError" , true);
            }
            else{
                component.set("v.timeValidationError" , false);
            }
            
        }
         else{
              if(component.get("v.eventReceivedTime")!='' && component.get("v.eventReceivedTime")>currentTime){
                     component.set("v.timeValidationError" , true);                   
                }else{
                     component.set("v.timeValidationError" , false);
                }
                component.set("v.dateValidationError" , false);
                component.set("v.timeValidationError" , false); 
            }
        
        //Time validation
        if( component.get("v.eventReceivedTime")!='' && component.get("v.eventReceivedTime")>currentTime
           && (component.get("v.eventReceivedDate") < todayFormattedDate || component.get("v.eventReceivedDate") == todayFormattedDate)){
               component.set("v.timeValidationError" , true);
         }
        else {
            component.set("v.timeValidationError" , false);
         }
        
        if(component.get("v.eventReceivedDate") < todayFormattedDate){
            component.set("v.timeValidationError" , false);
        }
        
    }
})