({
    initializeProviderDetails: function (cmp) {
        var providerDetails = {
            "addressId": "",
           // US3128839 - FAST/E2E - Clear Button on Explore Page
            "clearValues":false,
            "addressSequenceId": "",
            "contactType": "",
            "corpMPIN":"",
            "filterType": "Both",
            "firstName": "",
            "isAdvancedSearch": false,
            "interactionType": "Email",
            "isNoProviderToSearch": false,
            "isOther": false,
            "isProviderNotFound": false,
            "isPysician": false,
            "isValidProvider": false,
            "lastName": "",
            "npi": "",
            "phoneNumber": "",
            "practicingStatus": "Active",
            "providerId": "",
            "providerUniqueId": "",
            "primarySpeciality": "",
            "state": "",
            "taxIdOrNPI": "",
            "taxId": "",
            "zip": "",
			"tpsmIndicator":"",
            "addressLine1":"",
            "addressLine2":"",
            "degreeCode":"",
            "EffectivePhoneNumber":"",
            "AddressCity":"",
            "noPdFirstname":"",
             "noPdLastname":"",
             "noPdtaxIdOrNPIAI":"",
             "noPdProvidertype":"",
            "noPdProviderSpeciality":"",
             "caseRecordType":""
            
        };
        return providerDetails;
    },
    
        initializeSPDdetails : function(component){ 
               var selectedProviderDetails = {
            "firstName": "",
            "lastName": "",
            "taxidornpi": "",
            "providerType":"",
            "providerSpeciality": ""
         
        };
        component.set("v.selectedProviderDetails",selectedProviderDetails); 
        },
    checkValidation: function (cmp, event) {
        var providerDetails = cmp.get("v.providerDetails");
        var validationErrorFieldsList = [];
        var validationSuccess = false;
        var providerFieldsToValidate = cmp.get("v.providerFieldsToValidate");
        var validationCounter = 0;
        //Combination checking
        if (providerDetails.isAdvancedSearch && ($A.util.isEmpty(providerDetails.taxIdOrNPI) &&
                                                 ($A.util.isEmpty(providerDetails.lastName) && $A.util.isEmpty(providerDetails.state)))) {
            validationErrorFieldsList.push("Tax ID or NPI (or) Last Name or Facility/Group Name + State");
            this.showValidationErrorMessage(cmp, validationErrorFieldsList);
            return false;
        }
        for (var i in providerFieldsToValidate) {
            var fieldElement = cmp.find(providerFieldsToValidate[i]);
            if (!$A.util.isUndefined(fieldElement)) {
                if (!fieldElement.checkValidity()) {
                    validationCounter++;
                    validationErrorFieldsList.push(fieldElement.get("v.label"));
                }
                fieldElement.reportValidity();
            }
        }
        if (cmp.get("v.providerDetails.isAdvancedSearch")) {
            // wildcard Validation
            var firstNameCmp = cmp.find("providerFirstNameAI");
            var lastNameCmp = cmp.find("providerLastNameAI");
            if (firstNameCmp.get("v.value") != null) {
                if (!this.validateNamesWildCard(firstNameCmp, 3, cmp.get("v.firstNameErrorMessage"))) {
                    validationCounter++;
                }
            }
            if (lastNameCmp.get("v.value") != null) {
                if (!this.validateNamesWildCard(lastNameCmp, 4, cmp.get("v.lastNameErrorMessage"))) {
                    validationCounter++;
                }
            }
        }
        if (validationCounter == 0) {
            // all fields format and data is valid
            validationSuccess = true;
        }
        
        //US2826419
        if(!providerDetails.isProviderNotFound){
            this.showValidationErrorMessage(cmp, validationErrorFieldsList);
        }
        
        return validationSuccess;
    },
    
    validateNamesWildCard: function (inputCmp, charlength, errorMessage) {
        var charString = inputCmp.get("v.value");
        var lastchar = charString[charString.length - 1];
        if ((charString.match(/[*]/g) || []).length > 1) {
            inputCmp.setCustomValidity(errorMessage);
            inputCmp.reportValidity();
            return false;
        } else if (lastchar == "*" && charString.length < charlength) {
            inputCmp.setCustomValidity(errorMessage);
            inputCmp.reportValidity();
            return false;
        } else if (charString.includes("*") && lastchar != "*" && charString.length >= charlength) {
            inputCmp.setCustomValidity(errorMessage);
            inputCmp.reportValidity();
            return false;
        } else {
            inputCmp.setCustomValidity("");
            inputCmp.reportValidity();
            return true;
        }
    },
    
    showValidationErrorMessage: function (cmp, descriptionList) {
        if (!$A.util.isEmpty(descriptionList)) {
            // populate error
            let error = {};
            error.message = "We hit a snag.";
            error.topDescription = "Search criteria must include";
            error.descriptionList = descriptionList;
            error.bottomDescription = "additional fields may be included to help narrow results";
            cmp.set("v.error", error);
            cmp.set("v.showErrorMessage", true);
            // expand the error popup
            setTimeout(function () {
                cmp.find("errorPopup").showPopup();
            }, 100);
        } else {
            cmp.set("v.showErrorMessage", false);
        }
    },
    
    clearFieldValues: function (cmp) {
        var flowDetails = cmp.get("v.flowDetails");
        var providerDetails = cmp.get("v.providerDetails");
        //US3128839 - FAST/E2E - Clear Button on Explore Page
        var selectedProviderDetails = cmp.get("v.selectedProviderDetails");
        flowDetails.interactionType = "Email";
        if (providerDetails.isOther) {
            cmp.set("v.isMemSearchDisabledFromPrv", true);
        } else {
            cmp.set("v.isMemSearchDisabledFromPrv", false);
        }
        cmp.set("v.flowDetails", flowDetails);
        var initializedProviderDetails = this.initializeProviderDetails(cmp);
        initializedProviderDetails.isOther = providerDetails.isOther;
        cmp.set("v.providerDetails", initializedProviderDetails);
        //US3128839 - FAST/E2E - Clear Button on Explore Page
        var initializedSelectedProviderDetails = this.initializeSPDdetails(cmp);
        cmp.set("v.selectedProviderDetails", initializedSelectedProviderDetails);
        
        cmp.set("v.providerSearchResults", null);
        cmp.set("v.calloutProviderNotFound", false);
        cmp.set("v.refineSearchCriteriaMsg", "");
        cmp.set("v.lstproviderSearchResults", "");
    },
    
    clearFieldValidations: function (cmp) {
        //cmp.set("v.providerSearchResults", null);
        cmp.set("v.refineSearchCriteriaMsg", "");
        cmp.set("v.showErrorMessage", false);
        var providerFieldsToValidate = cmp.get("v.providerFieldsToValidate");
        for (var i in providerFieldsToValidate) {
            var fieldElement = cmp.find(providerFieldsToValidate[i]);
            if (!$A.util.isUndefined(fieldElement)) {
                if (fieldElement.get("v.type") == "date") {
                    if ($A.util.isEmpty(fieldElement.get("v.value"))) {
                        fieldElement.set("v.value", $A.localizationService.formatDate(new Date(), "YYYY-MM-DD"));
                        fieldElement.setCustomValidity("");
                        fieldElement.reportValidity();
                        fieldElement.set("v.value", null);
                    } else {
                        fieldElement.reportValidity();
                    }
                } else {
                    if ($A.util.isEmpty(fieldElement.get("v.value"))) {
                        fieldElement.set("v.value", "1");
                        fieldElement.setCustomValidity("");
                        fieldElement.reportValidity();
                        fieldElement.set("v.value", null);
                    } else {
                        fieldElement.reportValidity();
                    }
                }
            }
        }
    },
    
    //checking member not found field validation to disable or enable member search card
    checkPNFMandatoryFields: function (cmp) {
        var mnfMandatoryValuesFields = ["taxIdOrNPIAI", "contactNameAI", "contactNumberAI", "filterType", "providerFirstNameAI", "providerLastNameAI", "providerPhoneNumberAI"];
        var mandatoryValuesCounter = 0;
        for (var i in mnfMandatoryValuesFields) {
            var fieldElement = cmp.find(mnfMandatoryValuesFields[i]);
            if (!$A.util.isUndefined(fieldElement)) {
                if (!fieldElement.checkValidity()) {
                    mandatoryValuesCounter++;
                } else {}
            }
        }
        if (mandatoryValuesCounter != 0 && cmp.get("v.providerDetails.isProviderNotFound")) {
            cmp.set("v.isMemSearchDisabledFromPrv", true);
        } else if (mandatoryValuesCounter == 0 && cmp.get("v.providerDetails.isProviderNotFound")) {
            cmp.set("v.isMemSearchDisabledFromPrv", false);
        } else {
            cmp.set("v.isMemSearchDisabledFromPrv", false);
        }
    },
    
    //checking other search field validation to disable or enable member search card
    checkOtherMandatoryFields: function (cmp) {
        var otherMandatoryValuesFields = ["contactTypeAI", "otherContactNameAI", "otherContactNumberAI","otherContactFirstNameAI","otherContactLastNameAI"];
        var mandatoryValuesCounter = 0;
        for (var i in otherMandatoryValuesFields) {
            var fieldElement = cmp.find(otherMandatoryValuesFields[i]);
            if (!$A.util.isUndefined(fieldElement)) {
                if (!fieldElement.checkValidity()) {
                    mandatoryValuesCounter++;
                } else {}
            }
        }
        if (mandatoryValuesCounter != 0 && cmp.get("v.providerDetails.isOther")) {
            cmp.set("v.isMemSearchDisabledFromPrv", true);
        } else if (mandatoryValuesCounter == 0 && cmp.get("v.providerDetails.isOther")) {
            cmp.set("v.isMemSearchDisabledFromPrv", false);
        } else {
            cmp.set("v.isMemSearchDisabledFromPrv", false);
        }
    },
    
    searchProvider: function (cmp, event) {
        
        cmp.set("v.lstproviderSearchResults", null);
        var action = cmp.get('c.getProviderSearchResults');
        var providerDetails = cmp.get("v.providerDetails");
        providerDetails.isValidProvider = false;
        cmp.set("v.providerDetails", providerDetails);
        providerDetails.taxId = !$A.util.isEmpty(providerDetails.taxIdOrNPI) && providerDetails.taxIdOrNPI.trim().length == 9 ? providerDetails.taxIdOrNPI.trim() : "";
        providerDetails.npi = !$A.util.isEmpty(providerDetails.taxIdOrNPI) && providerDetails.taxIdOrNPI.trim().length == 10 ? providerDetails.taxIdOrNPI.trim() : "";
        providerDetails.firstName = !$A.util.isEmpty(providerDetails.firstName) ? providerDetails.firstName.trim() : '';
        providerDetails.lastName = !$A.util.isEmpty(providerDetails.lastName) ? providerDetails.lastName.trim() : '';
        providerDetails.zip = !$A.util.isEmpty(providerDetails.zip) ? providerDetails.zip.trim() : '';
        console.log(JSON.parse(JSON.stringify(providerDetails)));
        action.setParams({
            "providerDetails": providerDetails
        });
         debugger;
        action.setCallback(this, function (response) {
            cmp.set("v.refineSearchCriteriaMsg", "");
            var state = response.getState();
            if (state == 'SUCCESS') {
                var result = response.getReturnValue();
              
                 var resultList= result.response;
                 var exceptionCheck=result.apiResponse;
          // alert('==hello='+JSON.stringify(result.isSuccess));   
               if (result.isSuccess) {
                if (result.statusCode == 200) { 
                    	console.log('resultList---'+JSON.stringify(resultList));
                       cmp.set("v.calloutProviderNotFound", false);
                        var providerSearchResponse = result.response;
                        cmp.set("v.lstproviderSearchResults", resultList);
                        if ($A.util.isEmpty(exceptionCheck.serviceFault)) {
                            //var providerSearchResults = providerSearchResponse.PhysicianFacilitySummary0002Response;
                         if (!$A.util.isEmpty(resultList) && resultList.length > 0) {
                                cmp.set("v.lstproviderSearchResults", resultList);
                            }
                          /*if (exceptionCheck.metadata.total > 50) {
                                cmp.set("v.refineSearchCriteriaMsg", "Criteria has yielded more than 50 results. Refine your search criteria.");
                            } */
                        } else if (!$A.util.isEmpty(exceptionCheck.serviceFault.message) && exceptionCheck.serviceFault.message == "No records selected for the Query") {
                            cmp.set("v.calloutProviderNotFound", cmp.get("v.providerDetails.isAdvancedSearch"));
                            this.showToastMessage("Error!", 'No provider found.', "error", "dismissible", "10000");
                        }
                    
                       /* var p = cmp.get("v.parent");
    					p.showAlerts();*/
                } else {
                        cmp.set("v.calloutProviderNotFound", cmp.get("v.providerDetails.isAdvancedSearch"));
                        this.showToastMessage("Error!", result.message, "error", "dismissible", "10000");
                    }
                } else {
                    this.showToastMessage("Error!", "Something unexpected happened-1, please try after sometime.", "error", "dismissible", "10000");
                }
            } else if (state == 'ERROR') {
                this.showToastMessage("Error!", "Something unexpected happened-2, please try after sometime.", "error", "dismissible", "10000");
            }
            cmp.find("memberCardSpinnerAI").set("v.isTrue", false);
        });
        $A.enqueueAction(action);
     
    },
    
    keepOnlyDigits: function (cmp, event) {
        var regEx = /[^0-9 ]/g;
        var fieldValue = event.getSource().get("v.value");
        if (fieldValue.match(regEx)) {
            event.getSource().set("v.value", fieldValue.replace(regEx, ''));
            return fieldValue.replace(regEx, '');
        }
        return fieldValue;
    },
    
    keepOnlyText: function (cmp, event) {
        var regEx = /[^a-zA-Z ]/g;
        var fieldValue = event.getSource().get("v.value");
        if (fieldValue.match(regEx)) {
            event.getSource().set("v.value", fieldValue.replace(regEx, ''));
            return fieldValue.replace(regEx, '');
        }
        return fieldValue;
    },
    
    getPracticingStatusOptions: function (cmp) {
        var practicingStatusOptions = ["Active", "Active and Termed"];
        var statusOptions = [];
        for (var i = 0; i < practicingStatusOptions.length; i++) {
            statusOptions.push({
                label: practicingStatusOptions[i],
                value: practicingStatusOptions[i]
            });
        }
        cmp.set('v.practicingStatusOptions', statusOptions);
    },
    
    getFilterTypeOptions: function (cmp) {
        var filterTypeOptionsArray = ["Facility", "Physician"];
        var filterTypeOptions = [];
        for (var i = 0; i < filterTypeOptionsArray.length; i++) {
            filterTypeOptions.push({
                label: filterTypeOptionsArray[i],
                value: filterTypeOptionsArray[i]
            });
        }
        filterTypeOptions.unshift({
            label: 'Both',
            value: 'Both'
        });
        cmp.set('v.filterTypeOptions', filterTypeOptions);
    },
    
    showToastMessage: function (title, message, type, mode, duration) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": title,
            "message": message,
            "type": type,
            "mode": mode,
            "duration": duration
        });
        toastEvent.fire();
    },
    
})