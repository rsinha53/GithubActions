({
    togglePopup: function (cmp, event) {
        let showPopup = event.currentTarget.getAttribute("data-popupId");
        cmp.find(showPopup).toggleVisibility();
    },

    createBulk: function (cmp, event, helper) {
        var checkSearchRespObj = cmp.get('v.checkSearchRespObj');
        var selectedProviderID = '';
        if (!$A.util.isUndefinedOrNull(checkSearchRespObj[0]) && !$A.util.isUndefinedOrNull(checkSearchRespObj[0].response) &&
            !$A.util.isUndefinedOrNull(checkSearchRespObj[0].response.data.checkSummary) &&
            !$A.util.isUndefinedOrNull(checkSearchRespObj[0].response.data.checkSummary.draftDetail[0]) &&
            !$A.util.isUndefinedOrNull(checkSearchRespObj[0].response.data.checkSummary.draftDetail[0].providerId)) {
            selectedProviderID = checkSearchRespObj[0].response.data.checkSummary.draftDetail[0].providerId.providerTin;
        }

        if (selectedProviderID != '') {
            var action = cmp.get("c.getBulkRecoveryData");
            var requestObj = new Object();
            requestObj.paymentReference = cmp.get("v.checkNumber");
            requestObj.paymentType = 'P';
            requestObj.chkSerDeg = cmp.get("v.seriesDesignator");
            requestObj.taxId = selectedProviderID;
            action.setParams({
                bulkRequest: requestObj
            });
            action.setCallback(this, function (response) {
                var state = response.getState();
                if (state == 'SUCCESS') {
                    var result = response.getReturnValue();
                    cmp.set("v.bulkRecoveryData", result);
                    console.log(JSON.stringify(result));
                } else {
                    console.log('Error');
                }
            });
            $A.enqueueAction(action);
        }

    }
})