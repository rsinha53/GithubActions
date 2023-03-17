({

    init: function (cmp, event, helper) {
        var error = {};
        error.errorsCC = {
            'isValidCC': false,
            'errorsList': []
        };
        error.errorsRI = {
            'isValidRI': false,
            'isValidRIDC': false,
            'isValidRIPC': false,
            'errorsList': []
        };
        // US2950839
        error.errorsSB = {
            'isValidSB': false,
            'errorsList': []
        };

        // US2971523
        error.errorsPR = {
            'isValidPR': false,
            'errorsList': []
        };

        cmp.set('v.errors', error);
    },

    // US2816952
    handleOnChange: function (cmp, event, helper) {
        var eventSource = event.getSource();
        var fieldName = eventSource.get("v.name");

        if (fieldName == "Name") {
            helper.keepOnlyText(cmp, event);
        }

        if (fieldName == "ContactNumber" || fieldName == "Ext" || fieldName == "Fax") {
            helper.keepOnlyDigits(cmp, event);
        }
    },

    // US2816952
    alphanumericAndNoSpecialCharacters: function (cmp, event, helper) {
        helper.keepAlphanumericAndNoSpecialCharacters(cmp, event);
    },

    // US2816952
    fireValidations: function (cmp, event, helper) {
        // US3094699
        if (!$A.util.isUndefinedOrNull(event.getParam("tabId")) && event.getParam("tabId") == cmp.get('v.srnTabId')) {
        helper.executeValidations(cmp, event);
        }
    },

    // US2816952
    handleTypeChange: function (cmp, event, helper) {
        helper.resetValidations(cmp, event);
    },

    // US2894783
    bindValues: function (cmp, event, helper) {
        helper.bindValues(cmp, event);
    }

})