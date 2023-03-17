({
    // US2816952
    keepOnlyDigits: function (cmp, event) {
        var regEx = /[^0-9 ]/g;
        var fieldValue = event.getSource().get("v.value");
        if (fieldValue.match(regEx)) {
            event.getSource().set("v.value", fieldValue.replace(regEx, ''));
        }
        this.bindValues(cmp, event);
    },

    keepOnlyText: function (cmp, event) {
        var regEx = /[^a-zA-Z ]/g;
        var fieldValue = event.getSource().get("v.value");
        if (fieldValue.match(regEx)) {
            event.getSource().set("v.value", fieldValue.replace(regEx, ''));
            return fieldValue.replace(regEx, '');
        }
        this.bindValues(cmp, event);
        return fieldValue;
    },

    // US2816952
    keepAlphanumericAndNoSpecialCharacters: function (cmp, event) {
        var regex = new RegExp("^[a-zA-Z0-9]+$");
        var str = String.fromCharCode(!event.charCode ? event.which : event.charCode);
        if (regex.test(str)) {
            return true;
        } else { 
            event.preventDefault();
            return false;
        }
    },

    // US2816952
    executeValidations: function (cmp, event) {
        var errors = cmp.get('v.errors');
        errors.errorsCC.isValidCC = false;
        errors.errorsCC.errorsList = [];
        var fieldsToValidate = cmp.get('v.fieldsToValidate');
        var validationCounter = 0;
        for (var i in fieldsToValidate) {
            var fieldElement = cmp.find(fieldsToValidate[i]);
            if (!$A.util.isUndefined(fieldElement)) {
                if (!fieldElement.checkValidity()) {
                    validationCounter++;
                    errors.errorsCC.errorsList.push(fieldElement.get("v.label"));
                }
                fieldElement.reportValidity();
            }
        }

        var fax = cmp.find("fax").get("v.value");
        if(fax.length < 10){
            var fieldElement = cmp.find("fax");
            if (!$A.util.isUndefined(fieldElement)) {
                if (!fieldElement.checkValidity()) {
                    validationCounter++;
                    errors.errorsCC.errorsList.push(fieldElement.get("v.label"));
                }
                fieldElement.reportValidity();
            }
        }
        // US3656292   View Authorizations:  Email Address Validation while Creating Auth - Sarma - 30th June 2021
        var email = cmp.find("Email").get("v.value");
        var isValidFormat = this.validateEmail(cmp,email);
        var SRNData = cmp.get('v.SRNData');
        if (!$A.util.isEmpty(SRNData) && !$A.util.isEmpty(SRNData.CommContact) && !$A.util.isEmpty(SRNData.CommContact.Source)) {
            if(!isValidFormat && SRNData.CommContact.Source == 'Email'){
                var fieldElement = cmp.find("Email");
                if (!$A.util.isUndefined(fieldElement)) {
                    var erMsg = 'You have entered an invalid format.';
                    if(email.length < 1){
                        erMsg = 'Complete this field.';
                    }
                    validationCounter++;
                    errors.errorsCC.errorsList.push('Valid Email');
                    fieldElement.set('v.validity','false');
                    fieldElement.setCustomValidity(erMsg);
                    fieldElement.reportValidity();
                }
            } else if(email.length > 0 && !isValidFormat){
                var fieldElement = cmp.find("Email");
                if (!$A.util.isUndefined(fieldElement)) {
                    var erMsg = 'You have entered an invalid format.';
                    validationCounter++;
                    errors.errorsCC.errorsList.push('Valid Email');
                    fieldElement.set('v.validity','false');
                    fieldElement.setCustomValidity(erMsg);
                    fieldElement.reportValidity();
                }
            } else {
                var fieldElement = cmp.find("Email");
                if (!$A.util.isUndefined(fieldElement)) {
                    fieldElement.set('v.validity','true');
                    fieldElement.setCustomValidity('');
                    fieldElement.reportValidity();
                }
            }
        }

        if (0 == validationCounter) {
            errors.errorsCC.isValidCC = true;
        }
        errors.errorsCC;
        cmp.set('v.errors', errors);

    },

    // US2816952
    resetValidations: function (cmp, event) {
        var fieldsToValidate = cmp.get('v.fieldsToValidate');
        for (var i in fieldsToValidate) {
            var el = cmp.find(fieldsToValidate[i]); 
            if (el.checkValidity()) {
                el.showHelpMessageIfInvalid();
            }
        }
    },

    // US2894783
    bindValues: function (cmp, event) {
        var SRNData = cmp.get('v.SRNData');
        var fieldValue = event.getSource().get("v.value");
        var fieldName = event.getSource().get("v.name");
        SRNData.CommContact[fieldName] = fieldValue; 

        if (fieldName == "Role") {
            if (fieldName != "Facility") {
                SRNData.CommContact['Department'] = '';
            }
        }

        cmp.set('v.SRNData', SRNData);

    },
     // US3656292   View Authorizations:  Email Address Validation while Creating Auth - Sarma - 30th June 2021
    validateEmail: function(cmp, email){
        const re = /\S+@\S+\.\S+/;
        return re.test(String(email).toLowerCase());
    }

})