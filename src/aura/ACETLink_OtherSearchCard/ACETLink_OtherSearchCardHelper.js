({
    clearInputs: function (cmp, event, helper) {
        var conName = cmp.find('conName');
        var conNumber = cmp.find('conNumber');
        var otherConExt = cmp.find('otherConExt');
        helper.clearData(cmp, event, helper, conName);
        helper.clearData(cmp, event, helper, conNumber);
        helper.clearData(cmp, event, helper, otherConExt);
         var otherDetails = {
            "conName": "",
            "conNumber": "",
            "contactType": "--None--",
             "firstName": "",
            "lastName": "",
            "phoneNumber": "",
            "otherConExt": ""
        };
        cmp.set("v.otherDetails", otherDetails);
        cmp.set('v.isClear', true);
        cmp.set('v.isValidOtherSearch', false);

    },

    clearData: function (cmp, event, helper, input) {
        input.set("v.value", "1");
        input.setCustomValidity("");
        input.reportValidity();
        input.set("v.value", null);

    },

    executeOtherSearchValidations : function(component, event, helper, validateAll) {
        component.set('v.isValidOtherSearch', false);
        var conType =  component.get("v.otherDetails").contactType;
        var fieldName = event.getSource().get("v.name");
        if (validateAll || fieldName == 'conType'){
            component.set('v.isClear', false);
            if (conType == undefined || conType == '' || conType == '--None--') {
                $A.util.addClass(component.find('conType'), 'slds-has-error'); 
                if (!validateAll || (validateAll && !fieldName == undefined)){
                    return;
                }   
            } else {
                $A.util.removeClass(component.find('conType'), 'slds-has-error'); 
            }
        }
        var conName = component.find('conName').checkValidity();
        var conNumber = component.find('conNumber').checkValidity();
        if ((validateAll || fieldName == 'conName') && !conName) {
            component.find('conName').reportValidity();
            if (!validateAll || (validateAll && !fieldName == undefined)){
                return;
            } 
        }

        if ((validateAll || fieldName == 'conNumber') && !conNumber) {
            component.find('conNumber').reportValidity();
            if (!validateAll || (validateAll && !fieldName == undefined)){
                return;
            } 
        }
        if (conType != '' && conType != '--None--' && conName && conNumber){
            component.set('v.isValidOtherSearch', true);
        }
    }
})