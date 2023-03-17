({ 
    //US1909381 - Sarma - 04/09/2019 - Interaction Overview - Other (Third Party) : Added Init
    doInit: function (cmp, event, helper) {
        /*var otherDetails = {
            "firstName": "",
            "lastName": "",
            "contactType": "--None--",
            "phoneNumber": ""
        };*/
        var otherDetails = {
            "conName": "",
            "conNumber": "",
             "firstName": "",
            "lastName": "",
            "phoneNumber": "",
            "contactType": "--None--",
            "otherConExt": ""
        };
        cmp.set("v.otherDetails", otherDetails);
        helper.clearInputs(cmp, event, helper);
    },
    //End
    // US2031725 - Validation for Explore - Other (Third Party) - Kavinda
    validateOtherSearch : function(component, event, helper) {
        helper.executeOtherSearchValidations(component, event, helper, false);
        var otherDetails = component.get("v.otherDetails");
        _setandgetvalues.setContactValue('exploreContactData',otherDetails.conName,otherDetails.conNumber,otherDetails.otherConExt);
    },

    // US2031725 - Validation for Explore - Other (Third Party) - Kavinda
    clearData: function(cmp, event, helper) {
        helper.clearInputs(cmp, event, helper);
        _setandgetvalues.setContactValue('exploreContactData','','','');
    },

    // US2031725 - Validation for Explore - Other (Third Party) - Kavinda
    handleOtherSearchValidations: function(cmp, event, helper) {
        helper.executeOtherSearchValidations(cmp, event, helper, true);
        var message = event.getParam("message");
        var isValidOtherSearch = cmp.get('v.isValidOtherSearch');
    }

})