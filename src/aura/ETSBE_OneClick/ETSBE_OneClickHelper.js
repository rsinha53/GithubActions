({
    processEligibilityRepsonse: function (component, event, result,selLabel) {
        //US1933887 - UHG Access
        //Sanka D. - 31.07.2019
        
        if (!$A.util.isEmpty(result.hasAccess)) {
            component.set('v.uhgAccess', result.hasAccess); // Moved this code inside the loop as a part of DE289195 - Avish
        }
        console.log(result);
        var coverageLines = result.resultWrapper.CoverageLines;
        var ishighlightedPolicy;

        for (var i = 0; i < coverageLines.length; i++) {
            if (coverageLines[i].highlightedPolicy == true) {
                ishighlightedPolicy = true;
                component.set("v.tranId", coverageLines[i].transactionId);
                

            }
        }

       
        //USS2221006 - START
        if (!$A.util.isUndefinedOrNull(result.message) && result.message.includes('AAA:72')) {
            helper.fireToastMessage("Error!", result.message, "warning", "error", "10000");
        }
        //USS2221006 - END
    console.log(result.resultWrapper);
        //component.set("v.memberCardData", result.resultWrapper);
		var newLabel1 =  result.resultWrapper.MemberId + ' - ' + selLabel;
	      component.set("v.searchMemberIdSSN", newLabel1);
        
    },
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
    callHouseHoldWS : function(component,event,helper) {

		var action = component.get("c.getHouseHoldData");
        action.setParams({
            "transactionId": component.get("v.tranId")
        });

        action.setCallback(this, function(response) {
            var state = response.getState(); // get the response state
           
            if(state == 'SUCCESS') {
                //US1857687
                var result = response.getReturnValue();

                component.set("v.houseHoldData",result.resultWrapper.houseHoldList);
					var houseHoldList = component.get("v.houseHoldData");
                    var memberRelationship = '';
                    if(houseHoldList != undefined && houseHoldList != null && houseHoldList.length > 0) {
                        for(var i=0; i<houseHoldList.length; i++) {
                            if(houseHoldList[i].isMainMember == true) {
                                memberRelationship = houseHoldList[i].relationship;
                               
                                component.set("v.relationShip",memberRelationship);
                                break;
                            }
                        }    
                    }
            } else {
                //US1857687
               // helper.hideGlobalSpinner(component);
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
        component.set("v.platformText", "None");
        component.set("v.platformSelected", "None");
        component.set("v.filesList", "");
        component.set("v.isFilesList", false);
        component.set("v.isMemberNotFound", false);
        component.set("v.searchMemberFirstName", "");
        component.set("v.searchMemberLastName", "");
        component.set("v.searchMemberDOB", "");
        component.set("v.validateOriginator", false);
        component.find("searchGroupPolicyNum").reportValidity();
        component.find("searchMemberIdSSN").reportValidity();
        component.find("searchBroker").reportValidity();
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
        component.set("v.interactionType", "None");
        component.set("v.eventReceivedDate", "");
        console.log('TESTING TIME1: ' + component.get('v.eventReceivedTime'));
        component.set("v.eventReceivedTime", "");
        console.log('TESTING TIME2: ' + component.get('v.eventReceivedTime'));
        component.set("v.searchResolution", "");
        if(component.get('v.isResearchUser')) {
        	component.set("v.isCreateCase", true);    
        } else {
            component.set("v.isToggle", false);
            component.set("v.isCreateCase", false);
        } 
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
	    			if(component.get("v.specialInstructionsOnloadBool") == false){
                        component.set("v.specialInstructionsOnloadBool", true);
                        if(!$A.util.isUndefinedOrNull(component.get("v.pageReference").state.c__InteractionRecord) && $A.util.isUndefinedOrNull(component.get("v.pageReference").state.c__CaseRecord)){
                            var interactionInfo = component.get("v.pageReference").state.c__InteractionRecord;
                            if(interactionInfo.Business_Unit__c != null && interactionInfo.Business_Unit__c != undefined && interactionInfo.Business_Unit__c != ''){
                                component.set("v.businessUnitText", interactionInfo.Business_Unit__c);
                                component.set("v.businessUnitSelected",interactionInfo.Business_Unit__c);
                                component.set("v.instructionSearchType", "Topic");
                                this.resetFields(component,event);
                                this.searchInstructionRecords(component,event);
                            }
                        }
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
        component.set("v.displayPlatform", false);
        if(component.get("v.platformText") == ""){
    		component.set("v.platformText", "None");
    	}
    	if(component.get("v.businessUnitText") == ""){
    		component.set("v.businessUnitText", "None");
    	}
    	if(component.get("v.topicText") == ""){
    		component.set("v.topicText", "None");
    	}
	},
    //TODO starts here
    filterOriginators: function(component, event, helper) {
        
        if(component.get('v.isResearchUser')) {
        	component.set("v.isCreateCase", true);    
        } else {
            component.set("v.isToggle", false);
            component.set("v.isCreateCase", false);
        }
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
	
	                    	}
                            //US2699973:Change starts
                           else if(storeResponse[i].Originator_Type__c == 'Group Contact'){
                                 dropdownOptions.push({
		                            label: storeResponse[i].Originator_Type__c + ' , ' +storeResponse[i].Policy_Number__c+ ', ' + storeResponse[i].Last_Name__c + ', ' + storeResponse[i].First_Name__c + '   ' + storeResponse[i].Phone_Number__c + '   ' + storeResponse[i].Email__c,
		                            value: JSON.stringify(storeResponse[i])
		                        });
	                                
                            } 
                              else if(storeResponse[i].Originator_Type__c == 'Agency/Broker'){
                                 dropdownOptions.push({
		                            label: storeResponse[i].Originator_Type__c + ' , ' +storeResponse[i].Reward_Account_Number__c+ ', ' + storeResponse[i].Last_Name__c + ', ' + storeResponse[i].First_Name__c + '   ' + storeResponse[i].Phone_Number__c + '   ' + storeResponse[i].Email__c,
		                            value: JSON.stringify(storeResponse[i])
		                        });
	                                
                            } 
                              else if(storeResponse[i].Originator_Type__c == 'General Agent'){
                                 dropdownOptions.push({
		                            label: storeResponse[i].Originator_Type__c + ',  ' +storeResponse[i].Franchise_Code__c+ ', ' + storeResponse[i].Last_Name__c + ', ' + storeResponse[i].First_Name__c + '   ' + storeResponse[i].Phone_Number__c + '   ' + storeResponse[i].Email__c,
		                            value: JSON.stringify(storeResponse[i])
		                        });
	                                
                            } 
                            //US2699973:Change ends
                            else {
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
            editOtherOrigType: selOrig.Other_Originator_Type__c,
            editOtherOrigRole:'' 
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
            editOtherOrigType: selOrig.Other_Originator_Type__c,
            editOtherOrigRole: ''
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
    	} else if(custEmail.get("v.value") == '' && custPhone.get("v.value") == '' && editOrig.Originator_Type__c != 'Internal UHG Employee'){
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
        if(editOrig.Originator_Type__c == 'Internal UHG Employee'){
        	if(editOrig.Phone_Number__c == null ||editOrig.Phone_Number__c =='' ){
                validationCounter++;
                $A.util.addClass(custPhone, "slds-has-error");
        		component.find("phoneError").set("v.errors", [{message:"Must enter Telephone Number."}]);
            }
            if(editOrig.Email__c == null ||editOrig.Email__c =='' ){
                validationCounter++;
                $A.util.addClass(custEmail, "slds-has-error");
        		component.find("emailError").set("v.errors", [{message:"Must enter Email Address."}]);
            }
            
        }
        //alert(validationCounter);
    	if (validationCounter == 0) {
            // all fields format and data is valid
    		validation = true;
        }else{
            validation = false;
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
    	} else if(custEmail.get("v.value") == '' && custPhone.get("v.value") == '' && editOrig.Originator_Type__c != 'Internal UHG Employee'){
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
    	if(editOrig.Originator_Type__c == 'Internal UHG Employee'){
            if(editOrig.Phone_Number__c == null ||editOrig.Phone_Number__c =='' ){
                validationCounter++;
                $A.util.addClass(custPhone, "slds-has-error");
        		component.find("addPhoneError").set("v.errors", [{message:"Must enter Telephone Number."}]);
            }
            if(editOrig.Email__c == null ||editOrig.Email__c =='' ){
                validationCounter++;
                $A.util.addClass(custEmail, "slds-has-error");
        		component.find("addEmailError").set("v.errors", [{message:"Must enter Email Address."}]);
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
        } 
        /* US2623754 - Originator - Remove Validation
         * remove functionality to stop user from creating a case without having valid information compared to Solaris (reward account number, franchise code, group/policy number)
         * temporarily removed until solaris data is more complete
         * else if(originatorText != 'member' && component.get("v.validateOriginator") == false){
        	console.log("VALIDATE-Originator: FAILED");
    		errorMsg = errorMsg + "Update selected Originator|||";
    		validation = false;
        } */
        else if(originatorText != 'member' &&((memberDetail == null || memberDetail == undefined || memberDetail =='') && (groupDetail == null || groupDetail == undefined || groupDetail =='') && (brokerDetail == null || brokerDetail == undefined || brokerDetail ==''))){
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
        } else if(component.get("v.businessUnitText") == null || component.get("v.businessUnitText") == undefined || component.get("v.businessUnitText") == "None" || component.get("v.businessUnitText") == ""){
    		console.log("VALIDATE-Business Unit Type: FAILED");
    		errorMsg = errorMsg + "Select a Business Unit|||";
    		validation = false;
        } else if(component.get("v.topicText") == null || component.get("v.topicText") == undefined || component.get("v.topicText") == "None" || component.get("v.topicText") == ""){
    		console.log("VALIDATE-Issue Category: FAILED");
    		errorMsg = errorMsg + "Select an Issue Category|||";
    		validation = false;
    	} else if(component.get("v.searchResolution") == undefined || component.get("v.searchResolution") == null || component.get("v.searchResolution") == ""){
            errorMsg = errorMsg + "Must enter a resolution|||"; 
    		validation = false;
        } else if(component.get('v.searchMemberIdSSN') != null && component.get('v.searchMemberIdSSN') != undefined && component.get('v.searchMemberIdSSN') != '' && !component.get('v.searchMemberIdSSN').includes('-') && component.get("v.isMemberNotFound") == false){
        	errorMsg = errorMsg + $A.get("$Label.c.ETSBE_Explore_Page_Mem_Stop_Processing_Msg")+"|||";
    		validation = false;
        } else if(component.get('v.searchMemberIdSSN') != null && component.get('v.searchMemberIdSSN') != undefined && component.get('v.searchMemberIdSSN') != '' && component.get("v.isMemberNotFound") == true && (component.get('v.searchMemberFirstName') == null || component.get('v.searchMemberFirstName') == undefined || component.get('v.searchMemberFirstName') == '')){
        	errorMsg = errorMsg + "Enter Member's First Name|||";
    		validation = false;
        } else if(component.get('v.searchMemberIdSSN') != null && component.get('v.searchMemberIdSSN') != undefined && component.get('v.searchMemberIdSSN') != '' && component.get("v.isMemberNotFound") == true && (component.get('v.searchMemberLastName') == null || component.get('v.searchMemberLastName') == undefined || component.get('v.searchMemberLastName') == '')){
        	errorMsg = errorMsg + "Enter Member's Last Name|||";
    		validation = false;
        } else if(component.get('v.searchMemberIdSSN') != null && component.get('v.searchMemberIdSSN') != undefined && component.get('v.searchMemberIdSSN') != '' && component.get("v.isMemberNotFound") == true && (component.get('v.searchMemberDOB') == null || component.get('v.searchMemberDOB') == undefined || component.get('v.searchMemberDOB') == '')){
        	errorMsg = errorMsg + "Enter Member's DOB|||";
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
        } 
        /* US2623754 - Originator - Remove Validation
         * remove functionality to stop user from creating a case without having valid information compared to Solaris (reward account number, franchise code, group/policy number)
         * temporarily removed until solaris data is more complete
         * else if(originatorText != 'member' && component.get("v.validateOriginator") == false){
        	console.log("VALIDATE-Originator: FAILED");
    		errorMsg = errorMsg + "Update selected Originator|||";
    		validation = false;
        } */
         else if(originatorText != 'member' &&((memberDetail == null || memberDetail == undefined || memberDetail =='') && (groupDetail == null || groupDetail == undefined || groupDetail =='') && (brokerDetail == null || brokerDetail == undefined || brokerDetail ==''))){
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
    	} else if(component.get('v.searchMemberIdSSN') != null && component.get('v.searchMemberIdSSN') != undefined && component.get('v.searchMemberIdSSN') != '' && !component.get('v.searchMemberIdSSN').includes('-') && component.get("v.isMemberNotFound") == false){
        	errorMsg = errorMsg + $A.get("$Label.c.ETSBE_Explore_Page_Mem_Stop_Processing_Msg")+"|||";
    		validation = false;
        } else if(component.get('v.searchMemberIdSSN') != null && component.get('v.searchMemberIdSSN') != undefined && component.get('v.searchMemberIdSSN') != '' && component.get("v.isMemberNotFound") == true && (component.get('v.searchMemberFirstName') == null || component.get('v.searchMemberFirstName') == undefined || component.get('v.searchMemberFirstName') == '')){
        	errorMsg = errorMsg + "Enter Member's First Name|||";
    		validation = false;
        } else if(component.get('v.searchMemberIdSSN') != null && component.get('v.searchMemberIdSSN') != undefined && component.get('v.searchMemberIdSSN') != '' && component.get("v.isMemberNotFound") == true && (component.get('v.searchMemberLastName') == null || component.get('v.searchMemberLastName') == undefined || component.get('v.searchMemberLastName') == '')){
        	errorMsg = errorMsg + "Enter Member's Last Name|||";
    		validation = false;
        } else if(component.get('v.searchMemberIdSSN') != null && component.get('v.searchMemberIdSSN') != undefined && component.get('v.searchMemberIdSSN') != '' && component.get("v.isMemberNotFound") == true && (component.get('v.searchMemberDOB') == null || component.get('v.searchMemberDOB') == undefined || component.get('v.searchMemberDOB') == '')){
        	errorMsg = errorMsg + "Enter Member's DOB|||";
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
    navigateToGeneral: function(component,event,helper){
        var spinner = component.find("dropdown-spinner");
        $A.util.removeClass(spinner, "slds-hide");
        $A.util.addClass(spinner, "slds-show");
        var updateCase = component.get("v.updateCaseInfo");
        component.set("v.createdCaseSFID", "");
    	component.set("v.createdCaseID", "");
        component.set("v.createdInteractionSFID", "");
    	component.set("v.createdInteractionID", "");
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
            
            SearchType = 'Group/Employer';
            uniqueId = groupinfo.groupId;
            if(groupinfo.groupName.length<=80){
                firstname = '';
                lastname = groupinfo.groupName;
            } else if(groupinfo.groupName.length>80 && groupinfo.groupName.length<=120){
                firstname = groupinfo.groupName.substring(0,40);
                lastname = groupinfo.groupName.substring(40,groupinfo.groupName.length);
            }
                else if( groupinfo.groupName.length>120){
                    firstname = groupinfo.groupName.substring(0,40);
                    lastname = groupinfo.groupName.substring(40,120);
                }
        }
        if(memberResultinfo != null && memberResultinfo!= undefined && memberResultinfo != ""){
             lastname = memberResultinfo.lastName;
            firstname = memberResultinfo.firstName;
             SearchType = 'Member';
             uniqueId = memberResultinfo.firstName + memberResultinfo.lastName + memberResultinfo.DOB + memberResultinfo.memberID;
        }
        if((firstname == undefined || firstname == null || firstname == '') && (lastname == undefined || lastname == null || lastname == '')) {
           firstname = 'General';
           lastname = 'Inquiry';
        }
        var uhgAccess = component.get('v.uhgAccess');
        var isMemberNotFound = component.get('v.isMemberNotFound');
        console.log('UHG ACCESS FOR PERSON ACCT: ' + uhgAccess);
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
        console.log('BEFORE INTERACTION');
        var updateInteraction = component.get("v.updateCaseInteractionInfo");
        console.log('BEFORE INTERACTION1' + JSON.stringify(updateInteraction));
        console.log('BEFORE INTERACTION2' + JSON.stringify(selOrig));
        console.log('BEFORE INTERACTION3' + originatorId);
        if(updateInteraction != null && updateInteraction != undefined && updateInteraction != '' && updateInteraction.Id != ''){
        	console.log('IN INTERACTION');
        	var action1 = component.get("c.updateInteractionStandard");
            action1.setParams({
                origSfId: originatorId,
                interactionType: intType,
                eventReceivedDate: component.get("v.eventReceivedDate"),
                eventReceivedTime: component.get("v.eventReceivedTime"),
                memberFirstName: memberFirstName,
                memberLastName: memberLastName,
                memberDOB: memberDOB,
                memberId: memberId,
                updateIntId: updateInteraction.Id
            });
            action1.setCallback(this, function(response) {
                var state = response.getState();
                console.log('INTERACTION STATE: ' + state);
                if(state == "SUCCESS") {
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
                        var producerId = (component.get("v.producerSelected.producerID") != null && component.get("v.producerSelected.producerID") != undefined) ? component.get("v.producerSelected.producerID") : '';
                        var groupId = (component.get("v.groupSelected.groupId") != null && component.get("v.groupSelected.groupId") != undefined) ? component.get("v.groupSelected.groupId") : '';
                        //SSN is returned, member is not, maybe run that second service from member detail? Or just take the input text??
                        var memberId = (component.get("v.memberSelected.memberID") != null && component.get("v.memberSelected.memberID") != undefined) ? component.get("v.memberSelected.memberID") : '';
                        var flowType = '';
                        if(producerId != null && producerId != ''){
                            flowType = 'Producer';
                        }
                        if(groupId != null && groupId != ''){
                            flowType = 'Group/Employer';
                        }
                        if(memberId != null && memberId != ''){
                            flowType = 'Member';
                        }
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
                        var isMember = '';
	                    if(typeText.toLowerCase() == 'member'){
	                        isMember = "Member";
	                        custmrAdmininfo = {"Originator_Type__c":"Member"};
	                    }
	                    console.log('MEMBER INFO PASSED: ' + JSON.stringify(memberResultinfo));
	                    console.log('CASE INFO PASSED: ' + JSON.stringify(component.get("v.updateCaseInfo")));
	                    if(component.get("v.updateCaseBool") == true || component.get("v.createCaseFromIntBool") == true){
	                        console.log('SAVECASE10: ' + JSON.stringify(workspaceAPI));

	                        var isSubtab;
	                        workspaceAPI.getTabInfo().then(function (tabInfo) {
	                        	var focusedTabId = tabInfo.tabId;
	                            workspaceAPI.getFocusedTabInfo().then(function(response) {
	                                workspaceAPI.isSubtab({
	                                    tabId: response.tabId
	                                }).then(function(response) {
	                                    if (response) {
	                                        console.log("This tab is a subtab.");
	                                        isSubtab = true;
	                                    }
	                                    else {
	                                        console.log("This tab is not a subtab.");
	                                        isSubtab = false;
	                                    }
	                                    var focusedSubtabID = response.tabId;

	                                	console.log('ENTERED IF: ' + isSubtab);
	                                	workspaceAPI.openTab({
	        		                        pageReference: {
	        		                            "type": "standard__component",
	        		                            "attributes": {
	        		                                "componentName": "c__ETSBE_GeneralInfo"
	        		                            },
	        		                            "state": {
	        		                            	"c__MemberInfo" : memberResultinfo,
	        	                                    "c__UpdateCaseInfo": updateCase,
	        		                                "c__AdminInfo" : custmrAdmininfo,
	        		                                "c__GroupInfo": groupinfo,
	        		                                "c__InteractionRecord": storeResponse,
	        		                                "c__ProducerInfo" :producerinfo,
	        		                                "c__AdminType":isMember,
	        		                                "c__FlowType":component.get("v.FlowType"),
	        		                                "c__ContactId": component.get("v.ContactId"),
	        		                                "c__SpecialInstructionInfo":specialInstructionsInfo,
	        		                                "c__UHGRestricted":component.get("v.uhgAccess"),
                                                    "c__isMockEnabled":component.get("v.isMockEnabled"),
                                                    "c__disableTopic":false
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
	        		                            workspaceAPI.closeTab({tabId:focusedSubtabID});
	        		                        });
	        		                    }).catch(function(error) {
	        		                        console.log(error);
	        		                    }); 
	                                    
	                                });
	                            });
	                        });
	                    } else {
	                    	workspaceAPI.openTab({
		                        pageReference: {
		                            "type": "standard__component",
		                            "attributes": {
		                                "componentName": "c__ETSBE_GeneralInfo"
		                            },
		                            "state": {
		                            	"c__MemberInfo" : memberResultinfo,
	                                    "c__UpdateCaseInfo": updateCase,
		                                "c__AdminInfo" : custmrAdmininfo,
		                                "c__GroupInfo": groupinfo,
		                                "c__InteractionRecord": storeResponse,
		                                "c__ProducerInfo" :producerinfo,
		                                "c__AdminType":isMember,
		                                "c__FlowType":component.get("v.FlowType"),
		                                "c__ContactId": component.get("v.ContactId"),
		                                "c__SpecialInstructionInfo":specialInstructionsInfo,
		                                "c__UHGRestricted":component.get("v.uhgAccess"),
                                        "c__isMockEnabled":component.get("v.isMockEnabled"),
                                        "c__disableTopic" :false
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
                    	}
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
            $A.enqueueAction(action1);
        } else {
        	var action = component.get("c.createInteractionStandard");
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
	                    if(component.get("v.updateCaseBool") == true || component.get("v.createCaseFromIntBool") == true){
	                        console.log('SAVECASE10: ' + JSON.stringify(workspaceAPI));

	                        var isSubtab;
	                        workspaceAPI.getTabInfo().then(function (tabInfo) {
	                        	var focusedTabId = tabInfo.tabId;
	                            workspaceAPI.getFocusedTabInfo().then(function(response) {
	                                workspaceAPI.isSubtab({
	                                    tabId: response.tabId
	                                }).then(function(response) {
	                                    if (response) {
	                                        console.log("This tab is a subtab.");
	                                        isSubtab = true;
	                                    }
	                                    else {
	                                        console.log("This tab is not a subtab.");
	                                        isSubtab = false;
	                                    }
	                                    var focusedSubtabID = response.tabId;

	                                	console.log('ENTERED IF: ' + isSubtab);
	                                	workspaceAPI.openTab({
	        		                        pageReference: {
	        		                            "type": "standard__component",
	        		                            "attributes": {
	        		                                "componentName": "c__ETSBE_GeneralInfo"
	        		                            },
	        		                            "state": {
	        		                            	"c__MemberInfo" : memberResultinfo,
	        	                                    "c__UpdateCaseInfo": updateCase,
	        		                                "c__AdminInfo" : custmrAdmininfo,
	        		                                "c__GroupInfo": groupinfo,
	        		                                "c__InteractionRecord": storeResponse,
	        		                                "c__ProducerInfo" :producerinfo,
	        		                                "c__AdminType":isMember,
	        		                                "c__FlowType":component.get("v.FlowType"),
	        		                                "c__ContactId": component.get("v.ContactId"),
	        		                                "c__SpecialInstructionInfo":specialInstructionsInfo,
	        		                                "c__UHGRestricted":component.get("v.uhgAccess"),
                                                    "c__isMockEnabled":component.get("v.isMockEnabled")
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
	        		                            workspaceAPI.closeTab({tabId:focusedSubtabID});
	        		                        });
	        		                    }).catch(function(error) {
	        		                        console.log(error);
	        		                    }); 
	                                    
	                                });
	                            });
	                        });
	                    } else {
	                    	workspaceAPI.openTab({
		                        pageReference: {
		                            "type": "standard__component",
		                            "attributes": {
		                                "componentName": "c__ETSBE_GeneralInfo"
		                            },
		                            "state": {
		                            	"c__MemberInfo" : memberResultinfo,
	                                    "c__UpdateCaseInfo": updateCase,
		                                "c__AdminInfo" : custmrAdmininfo,
		                                "c__GroupInfo": groupinfo,
		                                "c__InteractionRecord": storeResponse,
		                                "c__ProducerInfo" :producerinfo,
		                                "c__AdminType":isMember,
		                                "c__FlowType":component.get("v.FlowType"),
		                                "c__ContactId": component.get("v.ContactId"),
		                                "c__SpecialInstructionInfo":specialInstructionsInfo,
		                                "c__UHGRestricted":component.get("v.uhgAccess"),
                                        "c__isMockEnabled":component.get("v.isMockEnabled")
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
                    	} 
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
        }
    },
    //US2564216 || US2564216 changes
    uploadfilesList: function(cmp, event, helper){
          var uploadedFiles = event.getParam("files");
          cmp.set("v.isFilesList", true);        
                var filedata=cmp.get("v.fileData");
                uploadedFiles.forEach(function(file){           
                    var temp = []
                    temp.push(file.documentId)
                    temp.push(file.name);  
                    filedata.push(temp);
                });
                
              cmp.set("v.fileData",filedata); 
              
               var value=0;
               var docIds=[];
               for(var i=0;i<filedata.length;i++){
                 value=filedata[i];
                 var toStringVal=value.toString();
                 var splitVal=toStringVal.split(',');
                 docIds.push(splitVal[0]); 
               }
                 cmp.set("v.fileIds",docIds);     
        
             var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "type":"Success!",
                    "message": "Files uploaded Successfully"
                });
                toastEvent.fire();      
        
    }, 
   //US:US2564216
   removeItem : function(component, index, event) {      
    var lines = component.get("v.fileData");
    lines.splice(index, 1);
    component.set("v.fileData", lines);
  
      var value=0;
      var docIds=[];
      for(var i=0;i<lines.length;i++){
         value=lines[i];
         var toStringVal=value.toString();
         var splitVal=toStringVal.split(',');
         docIds.push(splitVal[0]); 
      }
       component.set("v.fileIds",docIds);       
     //US3041121:Change
      if(!$A.util.isEmpty(component.get("v.createdCaseID"))){      
        var action = component.get("c.deleteAttachedFiles");
        
          action.setParams({
            docId: event.target.id,
            caseId: component.get("v.createdCaseID")
          });
           action.setCallback(this, function(response) {
            var state = response.getState();
            if(state == "SUCCESS"){
                
                
            } else if (state === "ERROR") {
                console.log('Error in deleting files');
              }
           });   
          $A.enqueueAction(action);
            
        }
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "type":"Success!",
            "message": "Files Deleted Successfully"
        });
        toastEvent.fire();  
               
  },
    
    //DE385766:Change
    createOneNDoneCase : function(component, event, originatorId, strWrapper, flowType, SIDescription, documentId, groupName,subjectName) {
        strWrapper = strWrapper + '"AddInfoTopic":"",'
        + '"AddInfoOrginType":"",'
        + '"AddInfoOrginSubType":"",'
        + '"ttsType":"",'
        + '"ttsSubType":"",'                    
        + '"noProviderToSearch":true,"isOtherSearch":false,"mnf":"","providerId":"","TaxId":"","noMemberToSearch":false,"OriginatorName":"ROBERT ROBERTS","OriginatorType":"Member","OriginatorRelationship":"","OriginatorContactName":"John Smith","OriginatorPhone":"","OriginatorEmail":"--","SubjectType":"Member","memberContactId":"","Status":"Open","PolicyCount":2,"CaseCreationFrom":"Member_Snapshot_Policies","AutoDoc":"","AutoDocCaseItems":""}';
		console.log('STRWRAPPER: ' + strWrapper);
        var updateCaseId = '';
        console.log('PASS CASE: ' + JSON.stringify(component.get("v.updateCaseInfo")));
        console.log('PASS CASE BOOL: ' + component.get("v.updateCaseBool"));
		if(component.get("v.updateCaseBool") == true){
			var caseInfo = component.get("v.updateCaseInfo");
			console.log('PASS CASE INFO: ' + JSON.stringify(caseInfo));
			if(caseInfo.Id != null && caseInfo.Id != undefined && caseInfo.Id != ''){
				updateCaseId = caseInfo.Id;
			}
        }
        var action1 = component.get("c.createOneNDoneCase");
        action1.setParams({
            origSfId: originatorId,
            strRecord: strWrapper,
            isProvider: false,
            contactID:component.get("v.ContactId"),
            flowType: flowType,
            resolution: SIDescription,
            updateCaseId: updateCaseId,
            docIDs: JSON.stringify(documentId),       //US:US2564216
            groupName:groupName,                        
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
                    if(component.get("v.updateCaseBool") == true){
                    	toastMessage = "Case Number " + storeResponse[1] + " has been updated and closed";
                    } else {
                    	toastMessage = "Case Number " + storeResponse[1] + " has been created and closed";
                    }
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
                if(component.get("v.updateCaseBool") == true || component.get("v.createCaseFromIntBool") == true){
	                var workspaceAPI = component.find("workspace");
	                console.log('SAVECASE10: ' + JSON.stringify(workspaceAPI));
	                /*workspaceAPI.openTab({
	                    url: '#/sObject/'+caseId+'/view',
	                    focus: true
	                });*/
	                var isSubtab;
	                workspaceAPI.getTabInfo().then(function (tabInfo) {
	                	var focusedTabId = tabInfo.tabId;
	                    workspaceAPI.getFocusedTabInfo().then(function(response) {
	                        workspaceAPI.isSubtab({
	                            tabId: response.tabId
	                        }).then(function(response) {
	                            if (response) {
	                                console.log("This tab is a subtab.");
	                                isSubtab = true;
	                            }
	                            else {
	                                console.log("This tab is not a subtab.");
	                                isSubtab = false;
	                            }
	                            var focusedSubtabID = response.tabId;

                            	console.log('ENTERED IF: ' + isSubtab);
                        		if(isSubtab){
		                            workspaceAPI.openSubtab({
		                                parentTabId: focusedTabId,
		                                url: '#/sObject/'+component.get("v.createdCaseSFID")+'/view',
		                                focus: true
		                            });
                        		} else {
                        			workspaceAPI.openTab({
	                                    url: '#/sObject/'+component.get("v.createdCaseSFID")+'/view',
	                                    focus: true
	                                }); 
                        		}
	                            workspaceAPI.closeTab({tabId:focusedSubtabID});
	                        });
	                    });
	                });
	            }
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
       // component.set("v.disabled",true);//US:US2564216
        //component.set("v.isVisible",false);//US:US2564216
    },
    
    navigateToSpecInsPage : function(component, event, interactionRec, flowType, memberRelationship, specialInstructionsInfo, updateCase) {
        var workspaceAPI = component.find("workspace"); 
        if(component.get("v.updateCaseBool") == true || component.get("v.createCaseFromIntBool") == true){
            console.log('SAVECASE10: ' + JSON.stringify(workspaceAPI));

            var isSubtab;
            workspaceAPI.getTabInfo().then(function (tabInfo) {
            	var focusedTabId = tabInfo.tabId;
                workspaceAPI.getFocusedTabInfo().then(function(response) {
                    workspaceAPI.isSubtab({
                        tabId: response.tabId
                    }).then(function(response) {
                        if (response) {
                            console.log("This tab is a subtab.");
                            isSubtab = true;
                        }
                        else {
                            console.log("This tab is not a subtab.");
                            isSubtab = false;
                        }
                        var focusedSubtabID = response.tabId;

                    	console.log('ENTERED IF: ' + isSubtab);
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
                                    "c__UpdateCaseInfo": updateCase,
                                    "c__CustomerAdminData": component.get('v.originatorSelected'),
                                    "c__FlowType":flowType,
                                    "c__ContactId":component.get("v.ContactId"),
                                    "c__MemberRelationship":memberRelationship,
                                    "c__SpecialInstructionInfo":specialInstructionsInfo,
	                                "c__UHGRestricted":component.get("v.uhgAccess")
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
                                workspaceAPI.closeTab({tabId:focusedSubtabID});
                            });
                        }).catch(function(error) {
                            console.log(error);
                        }); 
                        
                    });
                });
            });
        } else {
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
	                    "c__UpdateCaseInfo": updateCase,
	                    "c__CustomerAdminData": component.get('v.originatorSelected'),
	                    "c__FlowType":flowType,
	                    "c__ContactId":component.get("v.ContactId"),
	                    "c__MemberRelationship":memberRelationship,
	                    "c__SpecialInstructionInfo":specialInstructionsInfo,
                        "c__UHGRestricted":component.get("v.uhgAccess")
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
        }
        var spinner2 = component.find("dropdown-spinner");
        $A.util.removeClass(spinner2, "slds-show");
        $A.util.addClass(spinner2, "slds-hide");
    },
    
    searchSolarisOriginatorEdit: function(component,event,helper){
    	console.log('ENTERING SOLARIS EDIT');
    	component.set('v.updateEditOriginatorTableBool',false);
    	component.set("v.editOriginatorTableMessage", "");
    	var selOrig = component.get("v.originatorSelectedEdit");
    	var originatorStr = JSON.stringify(component.get("v.originatorSelectedEdit"));
    	var action = component.get("c.searchOriginatorSolaris");
    	action.setParams({
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
    	action.setCallback(this, function(response){
    		var state = response.getState();
    		console.log('SOLARIS STATE: ' + state);
    		if(state == "SUCCESS"){
    			var storeResponse = response.getReturnValue();
    			if(storeResponse != null && storeResponse != undefined && storeResponse != ''){
    				console.log('SOLARIS RESPONSE: ' + JSON.stringify(storeResponse));
    				var allResults = [];
    				allResults = storeResponse;
                    console.log('ALLRESULTS0: ' +JSON.stringify(allResults));
    				var tableResults = [];
    				var foundMatch = false;
                    if(allResults.length > 0 && allResults[0][0] == 'Too Many Results'){
                        component.set('v.editOriginatorTableBool',false);
                        component.set('v.updateEditOriginatorTableBool',false);
                        component.set('v.editOriginatorTableData','');
                        component.set('v.editOriginatorTableMessage', "Too many results. Please narrow search.");
                    } else {
                        if(selOrig.Originator_Type__c == 'Agency/Broker'){
                            console.log('ALLRESULTS: ' +JSON.stringify(allResults));
                            console.log('ALLRESULTS: ' + allResults.length);
                            for(var i = 0; i < allResults.length; i++){
                                if(allResults[i].length == 2){
                                    var tableData = {
                                        'rewardAccountNumber':allResults[i][0],
                                        'rewardAccountName':allResults[i][1]
                                    }
                                    tableResults.push(tableData);
                                    //look through table, and compare with entered fields, if both don't match, show table
                                    for(var j = 0; j < tableResults.length; j++){
                                        if(tableResults[i].rewardAccountNumber == component.get('v.originatorSelectedEdit.Reward_Account_Number__c') && tableResults[i].rewardAccountName == component.get('v.originatorSelectedEdit.Agency_Broker_Name__c')){
                                            foundMatch = true;
                                            component.set('v.updateEditOriginatorTableBool',true);
                                        }
                                    }
                                }
                            }
                        } else if(selOrig.Originator_Type__c == 'General Agent'){
                            console.log('ALLRESULTS: ' +JSON.stringify(allResults));
                            console.log('ALLRESULTS: ' + allResults.length);
                            for(var i = 0; i < allResults.length; i++){
                                if(allResults[i].length == 2){
                                    var tableData = {
                                        'franchiseCode':allResults[i][0],
                                        'generalAgencyName':allResults[i][1]
                                    }
                                    tableResults.push(tableData);
                                    //look through table, and compare with entered fields, if both don't match, show table
                                    for(var j = 0; j < tableResults.length; j++){
                                        if(tableResults[i].franchiseCode == component.get('v.originatorSelectedEdit.Franchise_Code__c') && tableResults[i].generalAgencyName == component.get('v.originatorSelectedEdit.General_Agency__c')){
                                            foundMatch = true;
                                            component.set('v.updateEditOriginatorTableBool',true);
                                        }
                                    }
                                }
                            }
                        } else if(selOrig.Originator_Type__c == 'Group Contact'){
                            console.log('ALLRESULTS: ' +JSON.stringify(allResults));
                            console.log('ALLRESULTS: ' + allResults.length);
                            for(var i = 0; i < allResults.length; i++){
                                if(allResults[i].length == 3){
                                    var tableData = {
                                        'groupName':allResults[i][0],
                                        'groupNumber':allResults[i][1],
                                        'policyNumber':allResults[i][2]
                                    }
                                    tableResults.push(tableData);
                                    //look through table, and compare with entered fields, if both don't match, show table
                                    for(var j = 0; j < tableResults.length; j++){
                                        if(tableResults[i].groupName == component.get('v.originatorSelectedEdit.Group_Name__c') && tableResults[i].groupNumber == component.get('v.originatorSelectedEdit.Group_Number__c') && tableResults[i].policyNumber == component.get('v.originatorSelectedEdit.Policy_Number__c')){
                                            foundMatch = true;
                                            component.set('v.updateEditOriginatorTableBool',true);
                                        }
                                    }
                                }
                            }
                        }
                        if(foundMatch == false){
                            console.log('SET DATA: ' + tableResults);
                            component.set('v.editOriginatorTableBool',true);
                            component.set('v.updateEditOriginatorTableBool',false);
                            component.set('v.editOriginatorTableData',tableResults);
                            component.set('v.editOriginatorTableMessage', "Click row to update with correct information.");
                            console.log('SET BOOL: ' + component.get("v.editOriginatorTableBool"));
                            console.log('SET DATA: ' + component.get("v.editOriginatorTableData"));
                        }
                    }
    			} else {
        			//message saying search didn't return results try again
        			if(selOrig.Originator_Type__c == 'Agency/Broker'){
        				component.set('v.editOriginatorTableMessage', "No results found. Enter a valid Rewards Account Number and Agency/Broker Name.");
    				} else if(selOrig.Originator_Type__c == 'General Agent'){
    					component.set('v.editOriginatorTableMessage', "No results found. Enter a valid Franchise Code.");
    				} else if(selOrig.Originator_Type__c == 'Group Contact'){
    					component.set('v.editOriginatorTableMessage', "No results found. Enter a valid Group Number or Policy Number.");
    				}
        			
        		}
    			//disable fields not required for search?
    		} else {
    			//message saying search didn't return results try again
    			if(selOrig.Originator_Type__c == 'Agency/Broker'){
    				component.set('v.editOriginatorTableMessage', "No results found. Enter a valid Rewards Account Number.");
				} else if(selOrig.Originator_Type__c == 'General Agent'){
					component.set('v.editOriginatorTableMessage', "No results found. Enter a valid Franchise Code.");
				} else if(selOrig.Originator_Type__c == 'Group Contact'){
					component.set('v.editOriginatorTableMessage', "No results found. Enter a valid Group Number or Policy Number.");
				}
    			
    		}
    	});
    	$A.enqueueAction(action); 
    	
    	console.log('FINAL BOOL: ' + component.get("v.editOriginatorTableBool"));
    	console.log('FINAL DATA: ' + component.get("v.editOriginatorTableData"));
    },
    searchSolarisOriginatorAdd: function(component,event,helper){
    	console.log('ENTERING SOLARIS EDIT');
    	component.set('v.updateAddOriginatorTableBool',false);
    	component.set("v.addOriginatorTableMessage", "");
    	var selOrig = component.get("v.originatorSelectedAdd");
    	var originatorStr = JSON.stringify(component.get("v.originatorSelectedAdd"));
    	var action = component.get("c.searchOriginatorSolaris");
    	action.setParams({
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
    	action.setCallback(this, function(response){
    		var state = response.getState();
    		console.log('SOLARIS STATE: ' + state);
    		if(state == "SUCCESS"){
    			var storeResponse = response.getReturnValue();
    			if(storeResponse != null && storeResponse != undefined && storeResponse != ''){
    				console.log('SOLARIS RESPONSE: ' + JSON.stringify(storeResponse));
    				var allResults = [];
    				allResults = storeResponse;
                    console.log('ALLRESULTS0: ' +JSON.stringify(allResults));
    				var tableResults = [];
    				var foundMatch = false;
                    if(allResults.length > 0 && allResults[0][0] == 'Too Many Results'){
                        component.set('v.addOriginatorTableBool',false);
                        component.set('v.updateAddOriginatorTableBool',false);
                        component.set('v.addOriginatorTableData','');
                        component.set('v.addOriginatorTableMessage', "Too many results. Please narrow search.");
                    } else {
                        if(selOrig.Originator_Type__c == 'Agency/Broker'){
                            console.log('ALLRESULTS: ' +JSON.stringify(allResults));
                            console.log('ALLRESULTS: ' + allResults.length);
                            for(var i = 0; i < allResults.length; i++){
                                if(allResults[i].length == 2){
                                    var tableData = {
                                        'rewardAccountNumber':allResults[i][0],
                                        'rewardAccountName':allResults[i][1]
                                    }
                                    tableResults.push(tableData);
                                    //look through table, and compare with entered fields, if both don't match, show table
                                    for(var j = 0; j < tableResults.length; j++){
                                        if(tableResults[i].rewardAccountNumber == component.get('v.originatorSelectedAdd.Reward_Account_Number__c') && tableResults[i].rewardAccountName == component.get('v.originatorSelectedAdd.Agency_Broker_Name__c')){
                                            foundMatch = true;
                                            component.set('v.updateAddOriginatorTableBool',true);
                                        }
                                    }
                                }
                            }
                        } else if(selOrig.Originator_Type__c == 'General Agent'){
                            console.log('ALLRESULTS: ' +JSON.stringify(allResults));
                            console.log('ALLRESULTS: ' + allResults.length);
                            for(var i = 0; i < allResults.length; i++){
                                if(allResults[i].length == 2){
                                    var tableData = {
                                        'franchiseCode':allResults[i][0],
                                        'generalAgencyName':allResults[i][1]
                                    }
                                    tableResults.push(tableData);
                                    //look through table, and compare with entered fields, if both don't match, show table
                                    for(var j = 0; j < tableResults.length; j++){
                                        if(tableResults[i].franchiseCode == component.get('v.originatorSelectedAdd.Franchise_Code__c') && tableResults[i].generalAgencyName == component.get('v.originatorSelectedAdd.General_Agency__c')){
                                            foundMatch = true;
                                            component.set('v.updateAddOriginatorTableBool',true);
                                        }
                                    }
                                }
                            }
                        } else if(selOrig.Originator_Type__c == 'Group Contact'){
                            console.log('ALLRESULTS: ' +JSON.stringify(allResults));
                            console.log('ALLRESULTS: ' + allResults.length);
                            for(var i = 0; i < allResults.length; i++){
                                if(allResults[i].length == 3){
                                    var tableData = {
                                        'groupName':allResults[i][0],
                                        'groupNumber':allResults[i][1],
                                        'policyNumber':allResults[i][2]
                                    }
                                    tableResults.push(tableData);
                                    //look through table, and compare with entered fields, if both don't match, show table
                                    for(var j = 0; j < tableResults.length; j++){
                                        if(tableResults[i].groupName == component.get('v.originatorSelectedAdd.Group_Name__c') && tableResults[i].groupNumber == component.get('v.originatorSelectedAdd.Group_Number__c') && tableResults[i].policyNumber == component.get('v.originatorSelectedAdd.Policy_Number__c')){
                                            foundMatch = true;
                                            component.set('v.updateAddOriginatorTableBool',true);
                                        }
                                    }
                                }
                            }
                        }
                        if(foundMatch == false){
                            console.log('SET DATA: ' + tableResults);
                            component.set('v.addOriginatorTableBool',true);
                            component.set('v.updateAddOriginatorTableBool',false);
                            component.set('v.addOriginatorTableData',tableResults);
                            component.set('v.addOriginatorTableMessage', "Click row to update with correct information.");
                            console.log('SET BOOL: ' + component.get("v.addOriginatorTableBool"));
                            console.log('SET DATA: ' + component.get("v.addOriginatorTableData"));
                        }
                    }
    			} else {
        			//message saying search didn't return results try again
        			if(selOrig.Originator_Type__c == 'Agency/Broker'){
        				component.set('v.addOriginatorTableMessage', "No results found. Enter a valid Rewards Account Number and Agency/Broker Name.");
    				} else if(selOrig.Originator_Type__c == 'General Agent'){
    					component.set('v.addOriginatorTableMessage', "No results found. Enter a valid Franchise Code.");
    				} else if(selOrig.Originator_Type__c == 'Group Contact'){
    					component.set('v.addOriginatorTableMessage', "No results found. Enter a valid Group Number or Policy Number.");
    				}
        			
        		}
    			//disable fields not required for search?
    		} else {
    			//message saying search didn't return results try again
    			if(selOrig.Originator_Type__c == 'Agency/Broker'){
    				component.set('v.addOriginatorTableMessage', "No results found. Enter a valid Rewards Account Number.");
				} else if(selOrig.Originator_Type__c == 'General Agenct'){
					component.set('v.addOriginatorTableMessage', "No results found. Enter a valid Franchise Code.");
				} else if(selOrig.Originator_Type__c == 'Group Contact'){
					component.set('v.addOriginatorTableMessage', "No results found. Enter a valid Group Number or Policy Number.");
				}
    			
    		}
    	});
    	$A.enqueueAction(action); 
    	
    	console.log('FINAL BOOL: ' + component.get("v.addOriginatorTableBool"));
    	console.log('FINAL DATA: ' + component.get("v.addOriginatorTableData"));
    },
    validateSolarisOriginator: function(component,event,helper){
    	console.log('ENTERING SOLARIS VALIDATE');
    	component.set("v.validateOriginator", false);
    	var selOrig = component.get("v.originatorSelected");
    	if(selOrig.Originator_Type__c == 'Agency/Broker' && ((selOrig.Reward_Account_Number__c == null || selOrig.Reward_Account_Number__c == undefined || selOrig.Reward_Account_Number__c == '') 
    			|| (selOrig.Agency_Broker_Name__c == null || selOrig.Agency_Broker_Name__c == undefined || selOrig.Agency_Broker_Name__c == ''))){
    		component.set("v.validateOriginator", false);
        	var origField = component.find("originatorField");
        	$A.util.addClass(origField, "slds-has-error");
        	component.find("validateOriginatorError").set("v.errors", [{message:"Originator needs to be updated with valid information."}]);
        } else if(selOrig.Originator_Type__c == 'General Agent' && (selOrig.Franchise_Code__c == null || selOrig.Franchise_Code__c == undefined || selOrig.Franchise_Code__c == '')){
        	component.set("v.validateOriginator", false);
        	var origField = component.find("originatorField");
        	$A.util.addClass(origField, "slds-has-error");
        	component.find("validateOriginatorError").set("v.errors", [{message:"Originator needs to be updated with valid information."}]);
        } else if(selOrig.Originator_Type__c == 'Group Contact' && ((selOrig.Group_Number__c == null || selOrig.Group_Number__c == undefined || selOrig.Group_Number__c == '') 
			|| (selOrig.Policy_Number__c == null || selOrig.Policy_Number__c == undefined || selOrig.Policy_Number__c == ''))){
        	component.set("v.validateOriginator", false);
        	var origField = component.find("originatorField");
        	$A.util.addClass(origField, "slds-has-error");
        	component.find("validateOriginatorError").set("v.errors", [{message:"Originator needs to be updated with valid information."}]);
        } else {
	    	var action = component.get("c.searchOriginatorSolaris");
	    	action.setParams({
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
	    	action.setCallback(this, function(response){
	    		var state = response.getState();
	    		console.log('SOLARIS STATE: ' + state);
	    		if(state == "SUCCESS"){
	    			var storeResponse = response.getReturnValue();
	    			if(storeResponse != null && storeResponse != undefined && storeResponse != ''){
	    				console.log('SOLARIS RESPONSE: ' + JSON.stringify(storeResponse));
	    				var allResults = [];
	    				allResults = storeResponse;
	                    console.log('ALLRESULTS0: ' +JSON.stringify(allResults));
	    				var tableResults = [];
	    				var foundMatch = false;
	                    if(allResults.length > 0 && allResults[0][0] == 'Too Many Results'){
	                        //error message here
	                    	component.set("v.validateOriginator", false);
	                    	var origField = component.find("originatorField");
	                    	$A.util.addClass(origField, "slds-has-error");
	                    	component.find("validateOriginatorError").set("v.errors", [{message:"Originator needs to be updated with valid information."}]);
	                    } else {
	                        if(selOrig.Originator_Type__c == 'Agency/Broker'){
	                            for(var i = 0; i < allResults.length; i++){
	                                if(allResults[i].length == 2){
	                                    var tableData = {
	                                        'rewardAccountNumber':allResults[i][0],
	                                        'rewardAccountName':allResults[i][1]
	                                    }
	                                    tableResults.push(tableData);
	                                    //look through table, and compare with entered fields, if both don't match, show table
	                                    for(var j = 0; j < tableResults.length; j++){
	                                        if(tableResults[i].rewardAccountNumber == selOrig.Reward_Account_Number__c && tableResults[i].rewardAccountName == selOrig.Agency_Broker_Name__c){
	                                            foundMatch = true;
	                                            component.set("v.validateOriginator", true);
	                                        }
	                                    }
	                                }
	                            }
	                        } else if(selOrig.Originator_Type__c == 'General Agent'){
	                            console.log('ALLRESULTS: ' +JSON.stringify(allResults));
	                            console.log('ALLRESULTS: ' + allResults.length);
	                            for(var i = 0; i < allResults.length; i++){
	                                if(allResults[i].length == 2){
	                                    var tableData = {
	                                        'franchiseCode':allResults[i][0],
	                                        'generalAgencyName':allResults[i][1]
	                                    }
	                                    tableResults.push(tableData);
	                                    //look through table, and compare with entered fields, if both don't match, show table
	                                    for(var j = 0; j < tableResults.length; j++){
	                                        if(tableResults[i].franchiseCode == selOrig.Franchise_Code__c && tableResults[i].generalAgencyName == selOrig.General_Agency__c){
	                                            foundMatch = true;
	                                            component.set("v.validateOriginator", true);
	                                        }
	                                    }
	                                }
	                            }
	                        } else if(selOrig.Originator_Type__c == 'Group Contact'){
	                            console.log('ALLRESULTS: ' +JSON.stringify(allResults));
	                            console.log('ALLRESULTS: ' + allResults.length);
	                            for(var i = 0; i < allResults.length; i++){
	                                if(allResults[i].length == 3){
	                                    var tableData = {
	                                        'groupName':allResults[i][0],
	                                        'groupNumber':allResults[i][1],
	                                        'policyNumber':allResults[i][2]
	                                    }
	                                    tableResults.push(tableData);
	                                    //look through table, and compare with entered fields, if both don't match, show table
	                                    for(var j = 0; j < tableResults.length; j++){
	                                        if(tableResults[i].groupName == selOrig.Group_Name__c && tableResults[i].groupNumber == selOrig.Group_Number__c && tableResults[i].policyNumber == selOrig.Policy_Number__c){
	                                            foundMatch = true;
	                                            component.set("v.validateOriginator", true);
	                                        }
	                                    }
	                                }
	                            }
	                        }
	                        if(foundMatch == false){
	                            component.set("v.validateOriginator", false);
		                    	var origField = component.find("originatorField");
		                    	$A.util.addClass(origField, "slds-has-error");
		                    	component.find("validateOriginatorError").set("v.errors", [{message:"Originator needs to be updated with valid information."}]);
	                        }
	                    }
	    			} else {
	    				component.set("v.validateOriginator", false);
                    	var origField = component.find("originatorField");
                    	$A.util.addClass(origField, "slds-has-error");
                    	component.find("validateOriginatorError").set("v.errors", [{message:"Originator needs to be updated with valid information."}]);
	        		}
	    		} else {
	    			component.set("v.validateOriginator", false);
                	var origField = component.find("originatorField");
                	$A.util.addClass(origField, "slds-has-error");
                	component.find("validateOriginatorError").set("v.errors", [{message:"Originator needs to be updated with valid information."}]);
	    		}
	    	});
	    	$A.enqueueAction(action); 
        }
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