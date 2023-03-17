({
    //US3625667: View Payments -  Error Code Handling - Swapnil
    paymentSearchErrorMsg: "Unexpected Error Occurred in the Payment Search Card. Please try again. If problem persists please contact help desk.",

    //US1994689 Swapnil
    executeValidations: function (cmp, event) {
        var errors = new Object();
        errors.isValid = false;
        errors.errorsList = [];
        var fieldsToValidate = cmp.get('v.fieldsToValidate');
        var validationCounter = 0;
        for (var i in fieldsToValidate) {
            var fieldElement = cmp.find(fieldsToValidate[i]);
            if (!$A.util.isUndefined(fieldElement)) {
                if (!fieldElement.checkValidity()) {
                    if (fieldsToValidate[i] == 'seriesDesignatorID' || fieldsToValidate[i] == 'checkNumberID') {
                    validationCounter++;
                        if (!errors.errorsList.includes('Series Designator + Check Number')) {
                            errors.errorsList.push('Series Designator + Check Number');
                        }
                    }
                    if(fieldsToValidate[i] =='taxId' && cmp.get('v.isTINRequired'))
                    {
                        validationCounter++;
                        errors.errorsList.push('View Payment must include Provider Tax ID for E-Payment.');
                    }
                }
                fieldElement.reportValidity();
            }
        }

        if (0 == validationCounter) {
            errors.isValid = true;
        }

        cmp.set('v.errors', errors);
    },

    searchPaymentResults: function (cmp, event, helper) {
        var spinner = cmp.find('srncspinner');
        cmp.set("v.isShowPaymentCheckDetails", false);
        cmp.set("v.isShowCheckPaymentDetails", false);
        cmp.set("v.checkSearchRespObj", "");
        cmp.set("v.readCheckResp", "");
        //Contructing parameters
        var requestObj = cmp.get('v.requestObject');
        if ($A.util.isUndefinedOrNull(requestObj)) {
            requestObj = new Object();
        }

        var checkSearchRespObj = [];

        requestObj.seriesDesignator = cmp.find("seriesDesignatorID").get("v.value");
        requestObj.checkNumber = cmp.find("checkNumberID").get("v.value");
        requestObj.remitNumber = '';
        requestObj.nextKey = '';

        cmp.set('v.requestObject', requestObj);

        $A.util.removeClass(spinner, 'slds-hide');
        $A.util.addClass(spinner, 'slds-show');

        var action = cmp.get("c.searchPayment");
        action.setParams({
            requestObject: requestObj
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state == 'SUCCESS') {
                var result = response.getReturnValue();
                if ((!$A.util.isUndefinedOrNull(result['readCheckResp'])) && (result['readCheckResp'].statusCode == 200 || result['readCheckResp'].statusCode == 201)) {
                    cmp.set("v.readCheckResp", result['readCheckResp']);
                    if (!$A.util.isUndefinedOrNull(result['checkSearchResp'])) {
                        checkSearchRespObj.push(result['checkSearchResp']);
                        cmp.set("v.checkSearchRespObj", checkSearchRespObj);
                    }
                } else if ((!$A.util.isUndefinedOrNull(result['TOPSResp']))) {
                    cmp.set("v.readCheckResp", result['TOPSResp']);
                } else if ((!$A.util.isUndefinedOrNull(result['COSMOSResp']))) {
                    cmp.set("v.readCheckResp", result['COSMOSResp']);
                }
            }
            cmp.set("v.isShowCheckPaymentDetails", true);
            $A.util.removeClass(spinner, 'slds-show');
            $A.util.addClass(spinner, 'slds-hide');
        });
        $A.enqueueAction(action);
    },
    fireToastMessage: function (title, message, type, mode, duration) {
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
    getEpayCodes: function(cmp,event)
    {
        var action=cmp.get('c.getAllSeriesDesignator');
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state == 'SUCCESS') {
                var result = response.getReturnValue();
                var valuesArr=[];
                for(var i=0;i<result.length;i++)
                {
                    valuesArr[i]=result[i].Label;
                }
                cmp.set('v.epayCodes',valuesArr);
            }
        });
        $A.enqueueAction(action);
    },

    // US3660103: View Payments - Series Designator & Check # Search Using Enter Key- Swapnil
    fireValidations: function(cmp, event, helper) {
        helper.executeValidations(cmp, event, helper);
        setTimeout(function () {
            var errors = cmp.get('v.errors');
            var error = cmp.get('v.error');
            error.descriptionList = errors.errorsList;
            cmp.set('v.error', error);
            if (!errors.isValid) {
                cmp.set('v.showErrorMessage', true);
                cmp.find("errorPopup").showPopup();
            } else {
                cmp.set("v.isShowCheckPaymentDetails", false);
                helper.searchPaymentResults(cmp, event, helper);
                cmp.set('v.showErrorMessage', false);
            }
        });
    }
})