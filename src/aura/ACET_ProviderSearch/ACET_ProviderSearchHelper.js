({
    initializeProviderDetails: function (cmp) {
        var providerDetails = {
            "addressId": "",
            "addressSequenceId": "",
            "contactType": "",
            "corpMPIN":"",
            "filterType": "Both",
            "firstName": "",
            "isAdvancedSearch": false,
            "interactionType": "Incoming Call",
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
            "AddressCity":""
        };
        return providerDetails;
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
        var isHoursValidated = false;
        for (var i in providerFieldsToValidate) {
            var fieldElement = cmp.find(providerFieldsToValidate[i]);
            if (!$A.util.isUndefined(fieldElement)) {
                //US3181616 - Sravan - Start
                if(providerFieldsToValidate[i] == 'startTimeId' || providerFieldsToValidate[i] == 'endTimeId'){
                    cmp.find('startTimeId').checkValidation();
                    cmp.find('startTimeId').find('comboboxFieldAI').reportValidity();
                    cmp.find("endTimeId").checkValidation();
                    cmp.find("endTimeId").find('comboboxFieldAI').reportValidity();

                    if (!cmp.find('startTimeId').find('comboboxFieldAI').reportValidity() || !cmp.find("endTimeId").find('comboboxFieldAI').reportValidity()) {
                        validationCounter++;
                        if(!isHoursValidated){
                        	isHoursValidated = true;
                        	validationErrorFieldsList.push("Complete Hours Of Operation");
                        }
                    }

                }
                else{
                if (!fieldElement.checkValidity()) {
                    //DE482480- Swapnil 08/25/2021
                    if(providerFieldsToValidate[i] == 'contactFirstNameAI' || providerFieldsToValidate[i] == 'contactLastNameAI' || providerFieldsToValidate[i] == 'contactNumberAI'){
                        cmp.set('v.isContactDetailsInvalid', true);
                    } //DE482480- Swapnil 08/25/2021

                    validationCounter++;
                    validationErrorFieldsList.push(fieldElement.get("v.label"));
                }
                fieldElement.reportValidity();
            }
                //US3181616 - Sravan - End
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
            cmp.set('v.isContactDetailsInvalid', false); //DE482480- Swapnil 08/25/2021
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
            var errorcmp = cmp.find("errorPopup");
            if ($A.util.isArray(errorcmp)) {
                errorcmp = errorcmp[0];
            }
            // expand the error popup
            setTimeout(function () {
                errorcmp.showPopup();
            }, 100);
        } else {
            cmp.set("v.showErrorMessage", false);
        }
    },
    
    clearFieldValues: function (cmp) {
        var flowDetails = cmp.get("v.flowDetails");
        var providerDetails = cmp.get("v.providerDetails");
        flowDetails.interactionType = "Incoming Call";
        if (providerDetails.isOther) {
            cmp.set("v.isMemSearchDisabledFromPrv", true);
        } else {
            cmp.set("v.isMemSearchDisabledFromPrv", false);
        }
        cmp.set("v.flowDetails", flowDetails);
        var initializedProviderDetails = this.initializeProviderDetails(cmp);
        initializedProviderDetails.isOther = providerDetails.isOther;
        cmp.set("v.providerDetails", initializedProviderDetails);
        cmp.set("v.providerSearchResults", null);
        cmp.set("v.calloutProviderNotFound", false);
        cmp.set("v.refineSearchCriteriaMsg", "");
        cmp.set('v.isContactDetailsRequired', false);
        cmp.set('v.isContactDetailsInvalid', false); //DE482480- Swapnil 08/25/2021
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
                } else if(providerFieldsToValidate[i] != 'startTimeId' && providerFieldsToValidate[i] != 'endTimeId'){//US3181616
                    if ($A.util.isEmpty(fieldElement.get("v.value"))) {
                        fieldElement.set("v.value", "1");
                        fieldElement.setCustomValidity("");
                        fieldElement.reportValidity();
                        fieldElement.set("v.value", null);
                    } else {
                        fieldElement.reportValidity();
                    }
                } else if(providerFieldsToValidate[i] == 'startTimeId'){
                    cmp.find('startTimeId').find('comboboxFieldAI').setCustomValidity("");
                    cmp.find("startTimeId").find('comboboxFieldAI').reportValidity();
                } else if(providerFieldsToValidate[i] == 'endTimeId'){
                    cmp.find('endTimeId').find('comboboxFieldAI').setCustomValidity("");
                    cmp.find("endTimeId").find('comboboxFieldAI').reportValidity();
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
        cmp.set("v.providerSearchResults", null);
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
        action.setCallback(this, function (response) {
            cmp.set("v.refineSearchCriteriaMsg", "");
            var state = response.getState();
            var result = response.getReturnValue();
            if (state == 'SUCCESS') {
                if (result.isSuccess) {
                    if (result.statusCode == 200) {
                        cmp.set("v.calloutProviderNotFound", false);
                        var providerSearchResponse = result.response;
                        if ($A.util.isEmpty(providerSearchResponse.serviceFault)) {
                            var providerSearchResults = providerSearchResponse.PhysicianFacilitySummary0002Response;
                            if (!$A.util.isEmpty(providerSearchResults) && providerSearchResults.length > 0) {
                                cmp.set("v.providerSearchResults", providerSearchResults);
                            }
                            if (providerSearchResponse.metadata.total > 50) {
                                cmp.set("v.refineSearchCriteriaMsg", "Criteria has yielded more than 50 results. Refine your search criteria.");
                            }
                        } else if (!$A.util.isEmpty(providerSearchResponse.serviceFault.message) && providerSearchResponse.serviceFault.message == "No records selected for the Query") {
                            cmp.set("v.calloutProviderNotFound", cmp.get("v.providerDetails.isAdvancedSearch"));
                            this.showToastMessage("We hit a snag.", 'No results found. Modify search criteria and try again.', "error", "dismissible", "10000");//US3020339 - Sravan
                        }
                    } else {
                        cmp.set("v.calloutProviderNotFound", cmp.get("v.providerDetails.isAdvancedSearch"));
                        this.showToastMessage("We hit a snag.", result.message, "error", "dismissible", "30000");
                    }
                } else {
                    this.showToastMessage("We hit a snag.", result.message, "error", "dismissible", "30000");
                }
            } else if (state == 'ERROR') {
                // US3551763 - Thanish - 24th May 2021
                var retError = response.getError();
                if((retError.length > 0) && (retError[0].exceptionType == "System.LimitException")){
                    this.showToastMessage("We hit a snag.", "Criteria has yielded too many results to display. Refine your search criteria by adding State & Zip Code.", "error", "dismissible", "30000");
                } else{
                    this.showToastMessage("We hit a snag.", result.message, "error", "dismissible", "30000");
                }
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