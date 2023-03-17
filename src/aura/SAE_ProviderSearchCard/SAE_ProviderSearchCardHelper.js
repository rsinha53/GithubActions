({
    checkValidation: function (cmp, event) {
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
                        fieldElement.reportValidity();
                        fieldElement.set("v.value", null);
                    } else {
                        fieldElement.reportValidity();
                    }
                } else {
                    if ($A.util.isEmpty(fieldElement.get("v.value"))) {
                        fieldElement.set("v.value", "1");
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
        providerDetails.showAdvance = false;
        providerDetails.taxIdOrNPI = "";
        providerDetails.contactName = "";
        providerDetails.filterType = "";
        providerDetails.firstName = "";
        providerDetails.lastName = "";
        providerDetails.zip = "";
        providerDetails.phone = "";
        providerDetails.state = "";
        cmp.set("v.providerDetails", providerDetails)
    },

    checkMandatoryFields: function (cmp, event) {
        var mandatoryValuesFields = ["taxIdOrNPIAI", "contactNameAI", "filterType", "providerFirstNameAI", "providerLastNameAI", "providerPhoneNumberAI"];
        var mandatoryValuesCounter = 0;
        for (var i in mandatoryValuesFields) {
            var fieldElement = cmp.find(mandatoryValuesFields[i]);
            if (!$A.util.isUndefined(fieldElement)) {
                if (!fieldElement.checkValidity()) {
                    mandatoryValuesCounter++;
                }
            }
        }
        if (mandatoryValuesCounter != 0 && cmp.get("v.providerDetails.providerNotFound")) {
            cmp.set("v.isMemSearchDisabledFromPrv", true);
        } else {
            cmp.set("v.isMemSearchDisabledFromPrv", false);
        }
    },

    searchProvider: function (cmp, event) {
        if (cmp.get("v.isAdvancedSearch")) {
            cmp.set("v.responseProviderNotFound", true);
            this.showToastMessage("Error!", "No results found.", "error", "dismissible", "10000");
        }
        /*var action = cmp.get('c.findProviders');
        var providerDetails = cmp.get("v.providerDetails");
        action.setParams({
            "providerId": providerDetails.providerId,
            "providerDOB": providerDetails.dob,
            "firstName": providerDetails.firstName,
            "lastName": providerDetails.lastName,
            "groupNumber": providerDetails.groupNumber,
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state == 'SUCCESS') {
                var result = response.getReturnValue();
                if (result.statusCode == 200) {
                    cmp.set("v.responseProviderNotFound", false);
                } else {
                    cmp.set("v.responseProviderNotFound", true);
                    this.showToastMessage("Error!", result.message, "error", "dismissible", "10000");
                }
            }
        });
        $A.enqueueAction(action);*/
    },

    showToastMessage: function (title, message, type, mode, duration) {
        /*var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": title,
            "message": message,
            "type": type,
            "mode": mode,
            "duration": duration
        });
        toastEvent.fire();*/
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
            label: '--None--',
            value: ''
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

})