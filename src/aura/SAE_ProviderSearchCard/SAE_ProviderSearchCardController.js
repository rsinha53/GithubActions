({
    doInit: function (cmp, event, helper) {
        var providerDetails = {
            "taxIdOrNPI": "",
            "contactName": "",
            "filterType": "",
            "firstName": "",
            "lastName": "",
            "searchOption": "",
            "state": "",
            "zip": "",
            "phone": "",
            "providerNotFound": false,
            
        };
        cmp.set("v.providerDetails", providerDetails);
        helper.getStateOptions(cmp);
        helper.getFilterTypeOptions(cmp);
    },

    checkMandatoryFields: function (cmp, event, helper) {
        helper.checkMandatoryFields(cmp, event);
        var fieldName = event.getSource().get("v.name");
        if (fieldName == "taxIdOrNPI" || fieldName == "providerPhoneNumber") {
            helper.keepOnlyDigits(cmp, event);
        }
    },

    chooseCallOptions: function (cmp, event) {
        var selectedCallVal = event.getParam("value");
        cmp.set("v.interactionType", selectedCallVal);
    },

    showOrHideAdvancedSearch: function (cmp, event, helper) {
        var eventSource = event.target;
        var linkName = eventSource.innerHTML;
        if (linkName == "Show Advanced Search") {
            eventSource.innerHTML = "Hide Advanced Search";
            cmp.set("v.isAdvancedSearch", true);
            helper.clearFieldValidations(cmp, event);
        } else if (linkName == "Hide Advanced Search") {
            eventSource.innerHTML = "Show Advanced Search";
            cmp.set("v.isAdvancedSearch", false);
        }
    },

    searchProvider: function (cmp, event, helper) {
        if (helper.checkValidation(cmp, event)) {
            // call web service
            helper.searchProvider(cmp, event)
        }
    },

    clearFieldValidationsAndValues: function (cmp, event, helper) {
        helper.clearFieldValues(cmp, event);
        helper.clearFieldValidations(cmp, event);
    },

    handleProviderNotFound: function (cmp, event, helper) {
        if (event.getSource().get("v.checked")) {
            cmp.set("v.isMemSearchDisabledFromPrv", true);
        } else {
            cmp.set("v.isMemSearchDisabledFromPrv", false);
        }
    },

    onChangeZip: function (cmp, event, helper) {
        helper.keepOnlyDigits(cmp, event);
    },
})