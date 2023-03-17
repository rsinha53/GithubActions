({
	doInit: function (cmp, event, helper) {
		cmp.set("v.providerDetails", helper.initializeProviderDetails(cmp));
		helper.getFilterTypeOptions(cmp);
		helper.getPracticingStatusOptions(cmp);
        helper.initializeSPDdetails(cmp);
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
  // US3067950 - Numeric field validation 
     numericFieldValidation: function (cmp, event, helper) {
 var fieldValue = event.getSource().get('v.value');
        if(isNaN(fieldValue)){
            event.getSource().set('v.value','');
        }
        var action = cmp.get('c.handleOnChange');
        $A.enqueueAction(action);
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
			var fieldValue = helper.keepOnlyText(cmp, event);
            //US2598275: Updates to Contact Name Entry Field
            if(fieldName == "contactFirstName"){
                flowDetails.contactFirstName = fieldValue;
                flowDetails.contactName = flowDetails.contactFirstName +' '+ flowDetails.contactLastName;
            }
            if(fieldName == "contactLastName"){
                flowDetails.contactLastName = fieldValue;
                flowDetails.contactName = flowDetails.contactFirstName +' '+ flowDetails.contactLastName;
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
        if(fieldName != "taxIdOrNPI")
        eventSource.set("v.value", fieldValue);
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
      //  alert('SS:',+JSON.stringify(providerDetails)); 
	},

	clearFieldValidationsAndValues: function (cmp, event, helper) {
        //US2757958-Contact Number/Ext - Carry Over to Other/Misdirect Entry Fields
        cmp.set("v.isClearbuttonClciked",true);
        
		helper.clearFieldValues(cmp);
		helper.clearFieldValidations(cmp);
        // US3128839 - FAST/E2E - Clear Button on Explore Page
		cmp.set("v.refineSearchCriteriaMsg", "");
        var providerDetails = helper.initializeProviderDetails(cmp);
        var flowDetails = cmp.get("v.flowDetails");
        var isFastrecordtype = cmp.get("v.isFastrecordtype");
		cmp.set("v.providerDetails", providerDetails);
		helper.clearFieldValidations(cmp);
		cmp.set("v.providerSearchResults", null);
       if(flowDetails.caseRecordType=='Reactive Resolution')
          cmp.set("v.isFastrecordtype", true); 
        providerDetails.caseRecordType=flowDetails.caseRecordType; 
        cmp.set("v.clearValues",true);
        providerDetails.clearValues = true;
        var appEvent = $A.get("e.c:ACETFast_ProviderFlowDetailsEvent"); 
        appEvent.setParams({"providerFlowDetails" : cmp.get("v.providerDetails"),
                           "selectedProviderDetails" : cmp.get("v.providerDetails")}); 
        appEvent.fire();
	},

	searchProvider: function (cmp, event, helper) {
         cmp.set("v.isClearbuttonClciked",false);
		cmp.find("memberCardSpinnerAI").set("v.isTrue", true);
        
		if (helper.checkValidation(cmp, event)) {
			helper.searchProvider(cmp, event);
		} else {
			cmp.find("memberCardSpinnerAI").set("v.isTrue", false);
		}
	},

	showOrHideAdvancedSearch: function (cmp, event, helper) {
		cmp.set("v.providerDetails.isAdvancedSearch", !cmp.get("v.providerDetails.isAdvancedSearch"));
		console.log('=tt='+cmp.get("v.providerDetails.isAdvancedSearch")); 
        helper.clearFieldValidations(cmp);
	},

	handleNoProviderToSearch: function (cmp, event, helper) {
		var providerDetails = helper.initializeProviderDetails(cmp);
        var flowDetails = cmp.get("v.flowDetails");
        var isFastrecordtype = cmp.get("v.isFastrecordtype");
		providerDetails.isNoProviderToSearch = event.getParam("checked");
		cmp.set("v.providerDetails", providerDetails);
		cmp.set("v.calloutProviderNotFound", false);
		cmp.set("v.isMemSearchDisabledFromPrv", false);
		helper.clearFieldValidations(cmp);
		cmp.set("v.providerSearchResults", null);
       if(flowDetails.caseRecordType=='Reactive Resolution')
          cmp.set("v.isFastrecordtype", true); 
        providerDetails.caseRecordType=flowDetails.caseRecordType; 
        var appEvent = $A.get("e.c:ACETFast_ProviderFlowDetailsEvent"); 
        appEvent.setParams({"providerFlowDetails" : cmp.get("v.providerDetails"),
                           "selectedProviderDetails" : cmp.get("v.providerDetails")}); 
        //alert(JSON.stringify(cmp.get("v.providerDetails"))); 
        appEvent.fire(); 
	},
    doAction: function (cmp, event, helper) {
        var flowDetails = cmp.get("v.flowDetails");
          var params = event.getParam('arguments');
        if (params) {
            var param1 = params.caseRecordType;
            flowDetails.caseRecordType==param1;
            if(param1=='Reactive Resolution'){
           cmp.set("v.isFastrecordtype", true); 
           
            } else {
                cmp.set("v.isFastrecordtype", false); 
            }
            
           // alert('Hello'+cmp.get("v.isFastrecordtype"));
        }
    },

	handleProviderNotFound: function (cmp, event, helper) {
		var providerDetails = cmp.get("v.providerDetails");
        var flowDetails = cmp.get("v.flowDetails");
		providerDetails.isNoProviderToSearch = false;
		providerDetails.isOther = false;
		providerDetails.isValidProvider = false;
		cmp.set("v.providerDetails", providerDetails);
		helper.checkPNFMandatoryFields(cmp);
		helper.clearFieldValidations(cmp);

		cmp.set("v.providerSearchResults", null);
        var latestproviderDetails=cmp.get("v.providerDetails");
         if(latestproviderDetails.isProviderNotFound){
          var appEvent = $A.get("e.c:ACETFast_ProviderFlowDetailsEvent"); 
        latestproviderDetails.caseRecordType=flowDetails.caseRecordType;
        latestproviderDetails.interactionType=flowDetails.interactionType;
        appEvent.setParams({"providerFlowDetails" : latestproviderDetails,
                           "selectedProviderDetails" : latestproviderDetails}); 
        appEvent.fire();  
            // alert(JSON.stringify(latestproviderDetails));
        }
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
                objComponent.set("v.flowDetails.contactNumber", objMessage.objRecordData.Ani__c);
                objEvent.stopPropagation();
            } catch (exception) {
                console.log('Inside VCCD Handle Exception' + exception);
            }
        }
    },
    
handleOnChangeNoproviderSearch: function (cmp, event, helper) {
	    var flowDetails= cmp.get("v.flowDetails");
 		var providerDetails = cmp.get("v.providerDetails");
        providerDetails.caseRecordType=flowDetails.caseRecordType;
        providerDetails.interactionType=flowDetails.providerDetails;
    
		var eventSource = event.getSource();
		var fieldName = eventSource.get("v.name");
		var fieldValue = eventSource.get("v.value");
  
        if (fieldName == "taxIdOrNPI") {
			eventSource.set("v.value", fieldValue.trim());
                   //Get the event
        var appEvent = $A.get("e.c:ACETFast_ProviderFlowDetailsEvent"); 
        //Set event attribute value
        appEvent.setParams({"providerFlowDetails" : cmp.get("v.providerDetails"),
                           "selectedProviderDetails" : cmp.get("v.selectedProviderDetails")}); 
            
        appEvent.fire(); 
		}
		if (fieldName == "noPdFirstname" || fieldName == "noPdLastname" || fieldName == "noPdProvidertype" || fieldName == "noPdProviderSpeciality") {
	          eventSource.set("v.value", fieldValue);
        //Get the event
        var appEvent = $A.get("e.c:ACETFast_ProviderFlowDetailsEvent"); 
        //Set event attribute value
        appEvent.setParams({"providerFlowDetails" : cmp.get("v.providerDetails"),
                           "selectedProviderDetails" : cmp.get("v.selectedProviderDetails")});
          //alert(JSON.stringify( cmp.get("v.providerDetails")));
        appEvent.fire(); 
		}
	
      
		if (fieldName != "noPdFirstname" || fieldName != "noPdLastname" || fieldName != "noPdProvidertype" || fieldName != "noPdProviderSpeciality") {
			cmp.set("v.providerSearchResults", null);
			cmp.set("v.refineSearchCriteriaMsg", "");
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
                    helper.searchProvider(cmp, event);
                } else {
                    cmp.find("memberCardSpinnerAI").set("v.isTrue", false);
                } 
            }
            
        }
	},
	
	//US2826419
	handlePrvValidation: function(cmp,event, helper) {
        if(helper.checkValidation(cmp, event)){
            cmp.set("v.firePrvValidationFromMember",event.getParam('fireValidation') );
        }        
    },
})