({

    // US2816952
    doInit: function (cmp, event, helper) {
        cmp.set('v.isModalOpen', false);
        var error = {
            topDescription: 'Create Authorization criteria must include',
            bottomDescription: '',
            message: 'We hit a snag.',
            descriptionList: []
        };
        cmp.set('v.error', error);
    },

    createSRN: function (cmp, event, helper) {

        // US3094699
        var appEvent = $A.get("e.c:ACET_CreateSRN_FireValidations");
        appEvent.setParams({
            "tabId": cmp.get('v.srnTabId') // US3094699
        });
        appEvent.fire();

    },

    closeModal: function (cmp, event, helper) {
        cmp.set('v.isModalOpen', false);
    },

    // US2950839
    bindValues: function (cmp, event, helper) {
        helper.bindValues(cmp, event);
    },

    // US2950839
    handleOnChange: function (cmp, event, helper) {
        var eventSource = event.getSource();
        var fieldName = eventSource.get("v.name");

        if (fieldName == "AlternativeFax") {
            var SRNData = cmp.get('v.SRNData');
            var AlternativeFax = SRNData.SubmitInfo.AlternativeFax;
            if (!$A.util.isUndefined(AlternativeFax) && AlternativeFax.length > 0) {
                SRNData.SubmitInfo.ConfirmFax = true;
            } else {
                SRNData.SubmitInfo.ConfirmFax = false;
            }
            cmp.set('v.SRNData', SRNData);
        }

        if (fieldName == "AlternativeFax") {
            helper.keepOnlyDigits(cmp, event);
        }
    },

    // US3094699
    fireValidations: function (cmp, event, helper) {

        if (!$A.util.isUndefinedOrNull(event.getParam("tabId")) && event.getParam("tabId") == cmp.get('v.srnTabId')) {

        // US2950839
        helper.executeValidations(cmp, event);

        setTimeout(function () {
            var errors = cmp.get('v.errors');
            var error = cmp.get('v.error');
            var isValidCC = errors.errorsCC.isValidCC;
            var isValidRI = errors.errorsRI.isValidRI;
            var isValidRIDC = errors.errorsRI.isValidRIDC;
            var isValidRIPC = errors.errorsRI.isValidRIPC;
            // DE449740
            if(isValidRIPC == undefined){
                isValidRIPC = true;
            }
            var isValidSB = errors.errorsSB.isValidSB; // US2950839
            var isValidPR = errors.errorsPR.isValidPR; // US2971523
            error.descriptionList = [];
            var arr = error.descriptionList.concat(errors.errorsCC.errorsList);
            arr = arr.concat(errors.errorsRI.errorsList);
            arr = arr.concat(errors.errorsSB.errorsList); // US2950839
            arr = arr.concat(errors.errorsPR.errorsList); // US2971523
            error.descriptionList = arr;
            cmp.set('v.error', error);
            if (!isValidCC || !isValidRI || !isValidRIDC || !isValidRIPC || !isValidSB || !isValidPR) {
                cmp.set('v.showErrorMessage', true);
                cmp.find("errorPopup").showPopup();
            } else {
                cmp.set('v.showErrorMessage', false);
                cmp.set('v.isModalOpen', true);
            }
        });

        }
    }

})