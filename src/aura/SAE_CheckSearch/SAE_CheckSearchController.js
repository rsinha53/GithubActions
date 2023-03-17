({
    doInit: function (cmp, event, helper) {
        //US1994689 Swapnil
        helper.getEpayCodes(cmp,event);
        var pValue=cmp.get("v.providerDetailsForRoutingScreen");
        cmp.set('v.tadIdNum',((!$A.util.isUndefinedOrNull(pValue)) && (!$A.util.isUndefinedOrNull(pValue.taxId)))?pValue.taxId:'');
        if($A.util.isUndefinedOrNull(pValue))
        {
            //tadIdNum
        }
        var error = {
            topDescription: 'Search criteria must include ',
            bottomDescription: '',
            message: 'We hit a snag.',
            descriptionList: []
        };
        cmp.set('v.error', error);
        cmp.set('v.showErrorMessage', false);
    },

    onChangePaymentOption: function (cmp, event, helper) {
        cmp.set("v.paymentOption", event.getParam("value"));
    },

    //US1994689 Swapnil
    preventSpacesAndKeepAlphanumeric: function (cmp, event, helper) {
        var regex = new RegExp("^[a-zA-Z0-9]+$");
        var str = String.fromCharCode(!event.charCode ? event.which : event.charCode);
        if (regex.test(str)) {
            return true;
        } else {
            event.preventDefault();
            return false;
        }
    },

    //US1994689 Swapnil
    fireValidations: function (cmp, event, helper) {
        // US3660103: View Payments - Series Designator & Check # Search Using Enter Key- Swapnil
        helper.fireValidations(cmp, event, helper);
    },

    clearFields: function (cmp, event, helper) {
        cmp.set('v.seriesDesignator', '');
        cmp.set('v.checkNumber', '');
        cmp.set('v.tadIdNum', '');
        cmp.set('v.isTINDisabled',true);
        cmp.set('v.isTINRequired',false);
    },
    checkEpay: function (cmp, event, helper) {
        var sdVal=cmp.get('v.seriesDesignator');
        var epayCodes=cmp.get('v.epayCodes');
        if(sdVal!=undefined && sdVal!='' && epayCodes.includes(sdVal.toUpperCase()))
        {
            cmp.set('v.isTINDisabled',false);
            cmp.set('v.isTINRequired',true);
        }else
        {
            cmp.set('v.isTINDisabled',true);
            cmp.set('v.isTINRequired',false);
        }
    },
    // US3660103: View Payments - Series Designator & Check # Search Using Enter Key- Swapnil
    onClickOfEnter: function(cmp, event, helper) {
        if(event.keyCode === 13) {
            var action = cmp.get('c.checkEpay');
            action.setCallback(this, function(response){
                var state = response.getState();
                if(state == 'SUCCESS'){
            helper.fireValidations(cmp, event, helper);
        }
            });
            $A.enqueueAction(action);
    	}
    }
})