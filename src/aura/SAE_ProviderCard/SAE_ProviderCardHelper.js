({
    showProviderSpinner: function (component) {
        var spinner = component.find("provider-spinner");
        $A.util.removeClass(spinner, "slds-hide");
        $A.util.addClass(spinner, "slds-show");
    },
    hideProviderSpinner: function (component) {
        var spinner = component.find("provider-spinner");
        $A.util.removeClass(spinner, "slds-show");
        $A.util.addClass(spinner, "slds-hide");
        //return null;
    },
    checkValidation: function (cmp, event, helper) {
        var validationSuccess = false;
        var providerFieldsToValidate = cmp.get("v.providerFieldsToValidate");
        var validationCounter = 0;
        for (var i in providerFieldsToValidate) {
            var fieldElement = cmp.find(providerFieldsToValidate[i]);
            if (!$A.util.isUndefined(fieldElement)) {
                if (!fieldElement.checkValidity()) {
                    validationCounter++;
                } 
                fieldElement.reportValidity();
            }
        }
        
        // US1671978 - Sanka
        if(cmp.get("v.isAdvancedSearch")){
            //Wildcard Validation
            var firstNameCmp = cmp.find("providerFirstNameAI");
            var lastNameCmp = cmp.find("providerLastNameAI");
            if (firstNameCmp.get("v.value") != null) {
                if (!helper.validateNamesWildCard(cmp, event, true, firstNameCmp, 3)) {
                    validationCounter++;
                }
            }
            if (lastNameCmp.get("v.value") != null) {
                if (!helper.validateNamesWildCard(cmp, event, false, lastNameCmp, 4)) {
                    validationCounter++;
                }
            }
            //end
            //Combination checking
            if((!$A.util.isEmpty(cmp.find("taxIdOrNPIAI").get("v.value"))) || 
               (!$A.util.isEmpty(cmp.find("providerLastNameAI").get("v.value")) && !$A.util.isEmpty(cmp.find("StateAI").get("v.value")))){
                cmp.set("v.IsValidSearch", true);            
            }else{
                validationCounter++;
                cmp.set("v.IsValidSearch", false);        
            }
            //end
        }
        if (validationCounter == 0) {
            // all fields format and data is valid
            validationSuccess = true;
        }
        return validationSuccess;
    },

    clearFieldValidations: function (cmp, event) {
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
                    //$A.util.removeClass(fieldElement, "slds-has-error");
                    //$A.util.addClass(fieldElement, "hide-error-message");
                }
            }
        }
    },

    clearFieldValues: function (cmp, event) {
        var providerDetails = cmp.get("v.providerDetails");
        //providerDetails.showAdvance = false;
        providerDetails.taxIdOrNPI = "";
       // providerDetails.contactName = "";
		providerDetails.filterType = "Both";
        providerDetails.practicingStatus = "Active"
        providerDetails.firstName = "";
        providerDetails.lastName = "";
        providerDetails.zip = "";
        providerDetails.phone = "";
        providerDetails.state = "";
        //US2291039 - Avish - DE325705
        providerDetails.contactNumber = "";
        providerDetails.contactExt = "";
        //US2291039 - Ends
        cmp.set("v.providerDetails", providerDetails)
       // cmp.set("v.providerContactName", ""); //US2039716 - Thanish - 19th Sept 2019
        cmp.set("v.IsValidSearch", true);
    },
    
    checkMandatoryFields: function (cmp, event) {
        var mandatoryValuesFields = ["taxIdOrNPIAI", "contactNameAI", "contactNumberID", "filterType", "providerFirstNameAI", "providerLastNameAI", "providerPhoneNumberAI"];
        var mandatoryValuesCounter = 0;
        for (var i in mandatoryValuesFields) {
            var fieldElement = cmp.find(mandatoryValuesFields[i]);
            if (!$A.util.isUndefined(fieldElement)) {
                // US1671978 - Sanka
                if (!fieldElement.checkValidity()) {
                    mandatoryValuesCounter++;
                    //fieldElement.reportValidity();
                }else{
                    //fieldElement.reportValidity();
                }
            }
        }
        if (mandatoryValuesCounter != 0 && cmp.get("v.providerNotFound")) {
            cmp.set("v.isMemSearchDisabledFromPrv", true);
        }else if(mandatoryValuesCounter == 0 && cmp.get("v.providerNotFound")){
            // US1699139 - Continue button - Sanka
            cmp.set("v.validFlowProvider", true);
            cmp.set("v.isMemSearchDisabledFromPrv", false);
        } else {
            cmp.set("v.isMemSearchDisabledFromPrv", false);
        }
    },

    searchProvider: function (cmp, event) {
        /*if (cmp.get("v.isAdvancedSearch")) {
            cmp.set("v.responseProviderNotFound", true);
            this.showToastMessage("Error!", "No results found.", "error", "dismissible", "10000");
        }*/
        var action = cmp.get('c.getProviderSearchResponse');
        var providerDetails = cmp.get("v.providerDetails");
        action.setParams({
            "providerDetails": providerDetails,
            "isAdvancedSearch": cmp.get("v.isAdvancedSearch")
        });
        action.setCallback(this, function (response) {
            debugger;
           
            cmp.set("v.refineSearchCriteria", "");
            var state = response.getState();
            if (state == 'SUCCESS') {
                var result = response.getReturnValue();
                //var responseJSON = JSON.parse(result.mockJSON);
                //cmp.set("v.providerResults", responseJSON);
                if (result.statusCode == 200) {
                    cmp.set("v.responseProviderNotFound", false);
                    var responseJSON = JSON.parse(result.providerResponseJSON);
                    if (responseJSON.serviceFault == undefined) {
                        cmp.set("v.providerResults", responseJSON);
                        
                        if (responseJSON.metadata.total > 50) {
                            cmp.set("v.refineSearchCriteria", "Criteria has yielded more than 50 results. Refine your search criteria.");
                            //return;
                        }
                        this.sendProviderDetails(cmp);
                        this.hideProviderSpinner(cmp);
                    } else {
			this.hideProviderSpinner(cmp);
                        cmp.set("v.responseProviderNotFound", cmp.get("v.isAdvancedSearch"));
                        cmp.set("v.providerResults", null);
                        cmp.set("v.selectedProviderDetails", null);
                        this.showToastMessage("Error!", 'No provider found.', "error", "dismissible", "10000");
                        this.sendProviderDetails(cmp);
                    }
                } else {
                    this.hideProviderSpinner(cmp);
                    cmp.set("v.responseProviderNotFound", cmp.get("v.isAdvancedSearch"));
                    this.showToastMessage("Error!",result.Message, "error", "dismissible", "10000");
                }
            }
        });
        $A.enqueueAction(action);
    },

    sendProviderDetails: function (cmp) {
        debugger;
        var searchResults = cmp.get("v.providerResults");
        var prodContact = cmp.get("v.providerDetails");
        _setandgetvalues.setContactValue('exploreContactData',prodContact.contactName,prodContact.contactNumber,prodContact.contactExt);
        var appEvent = $A.get("e.c:SAE_ProviderSearchResultsEvent");
        appEvent.setParams({
            "providerResults": searchResults
        });
        appEvent.fire();
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

    getStateOptions: function (cmp) {
        var action = cmp.get('c.getStateValues');
        action.setCallback(this, function (actionResult) {
            var stateOptions = [];
            for (var i = 0; i < actionResult.getReturnValue().length; i++) {
                stateOptions.push({
                    label: actionResult.getReturnValue()[i].DeveloperName,
                    value: actionResult.getReturnValue()[i].DeveloperName
                });
            }
            stateOptions.unshift({
                label: '--None--',
                value: ''
            });
            cmp.set('v.stateOptions', stateOptions);
        });
        $A.enqueueAction(action);
    },

    keepOnlyDigits: function (cmp, event) {
        var regEx = /[^0-9 ]/g;
        var fieldValue = event.getSource().get("v.value");
        if (fieldValue.match(regEx)) {
            event.getSource().set("v.value", fieldValue.replace(regEx, ''));
        }
    },
    
    // US1671978 - Sanka
    keepOnlyText: function(cmp,event){
        var regEx = /[^a-zA-Z ]/g;
        var fieldValue = event.getSource().get("v.value");
        if (fieldValue.match(regEx)) {            
            event.getSource().set("v.value", fieldValue.replace(regEx, ''));
        }
    },
    
    // US1671978 - Sanka
    validateNamesWildCard: function (component, event, isFirstName, inputComp, charlengthNum) {
        var charString = inputComp.get("v.value");
        var lastchar = charString[charString.length - 1];

        if ((charString.match(/[*]/g) || []).length > 1) {
            if (isFirstName) {
                inputComp.setCustomValidity(component.get("v.FirstNameErrorMessage"));
                inputComp.reportValidity();
            } else {
                inputComp.setCustomValidity(component.get("v.LastNameErrorMessage"));
                inputComp.reportValidity();
            }
            return false;
        } else if (lastchar == "*" && charString.length < charlengthNum) {
            if (isFirstName) {
                inputComp.setCustomValidity(component.get("v.FirstNameErrorMessage"));
                inputComp.reportValidity();
            } else {
                inputComp.setCustomValidity(component.get("v.LastNameErrorMessage"));
                inputComp.reportValidity();
            }
            return false;
        } else if (charString.includes("*") && lastchar != "*" && charString.length >= charlengthNum) {
            if (isFirstName) {
                inputComp.setCustomValidity(component.get("v.FirstNameErrorMessage"));
                inputComp.reportValidity();
            } else {
                inputComp.setCustomValidity(component.get("v.LastNameErrorMessage"));
                inputComp.reportValidity();
            }
            return false;
        } else {
            if (isFirstName) {
                inputComp.setCustomValidity("");
                inputComp.reportValidity();
            } else {
                inputComp.setCustomValidity("");
                inputComp.reportValidity();
            }
            return true;
        }
    },
    getPracticeStatusOptions: function (cmp) {
        var pracStatusArray = ["Active and Termed"];
        var statusOptions = [];
        statusOptions.push({
            label: 'Active',
            value: 'Active'
        });
        for (var i = 0; i < pracStatusArray.length; i++) {
            statusOptions.push({
                label: pracStatusArray[i],
                value: pracStatusArray[i]
            });
        }
        cmp.set('v.pracStatusOptions', statusOptions);
    },


})