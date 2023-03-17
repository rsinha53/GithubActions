({
    onInit: function (cmp, event, helper) {
        var RequiredInfo = cmp.get('v.RequiredInfo');
        var Diagnosis = { DiagnosisCode: '', DiagnosisDesc: '' };
        RequiredInfo.DiagnosisData.push(Diagnosis);
        cmp.set('v.Diagnosis', Diagnosis);
        cmp.set('v.RequiredInfo', RequiredInfo);
    },

    bindValues: function (cmp, event, helper) {
        var fieldName = event.getSource().get("v.name");
        if (fieldName == 'DiagnosisCode') {
            helper.validateCodesWithDot(cmp, event);
        } else {
            helper.bindValues(cmp, event);
        }
    },

    alphanumericAndNoSpecialCharacters: function (cmp, event, helper) {
        helper.keepAlphanumericAndNoSpecialCharacters(cmp, event);
    },
    
    fireValidations: function (cmp, event, helper) {
        // US3094699
        if (!$A.util.isUndefinedOrNull(event.getParam("tabId")) && event.getParam("tabId") == cmp.get('v.srnTabId')) {
        helper.executeValidations(cmp, event);
        }
    },

    // US3050746
    deleteAdditionalRow: function (cmp, event, helper) {
        var cmpEvent = cmp.getEvent("ACET_CreateSRN_AdditionalCodesRemoveEvent");
        cmpEvent.setParams({
            "type": "Diagnosis",
            "index": cmp.get('v.index')
        });
        cmpEvent.fire();
    },
	handleKLData: function (cmp, event, helper)
    {
        var message = event.getParam("selectedKLRecord");
        var Diagnosisdt=cmp.get("v.Diagnosis");
        Diagnosisdt.DiagnosisDesc=message.Code_Description__c;
        cmp.set("v.Diagnosis",Diagnosisdt);
    }

})