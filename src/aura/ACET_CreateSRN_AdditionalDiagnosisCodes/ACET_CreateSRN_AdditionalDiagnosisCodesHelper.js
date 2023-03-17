({
    bindValues: function (cmp, event, helper) {
        var RequiredInfo = cmp.get('v.RequiredInfo');
        var Diagnosis = cmp.get('v.Diagnosis');
        var index = cmp.get('v.index');
        RequiredInfo.DiagnosisData[index] = Diagnosis;
        cmp.set('v.RequiredInfo', RequiredInfo);
    },

    validateCodesWithDot: function (cmp, event) {
        var fieldName = event.getSource().get("v.name");
        var fieldValue = event.getSource().get("v.value");
        var field = cmp.find(fieldName);
        field.setCustomValidity('');
        var Diagnosis = cmp.get('v.Diagnosis');
        if (fieldValue.length > 0) {
            if (fieldValue.length < 3) {
                field.setCustomValidity('Invalid input.');
            } if (fieldValue.length > 3) {
                var fs = fieldValue.substring(0, 3);
                var sc = '';
                if (fieldValue.length == 4 && fieldValue.substr(fieldValue.length - 1) == '.') {
                    Diagnosis.DiagnosisCode = (fs);
                } else {
                    if (fieldValue.indexOf('.') !== -1) {
                        sc = fieldValue.substring(4, fieldValue.length);
                    } else {
                        sc = fieldValue.substring(3, fieldValue.length);
                    }
                    Diagnosis.DiagnosisCode = (fs + '.' + sc);
                }
                field.setCustomValidity('');
            }
        }
        //US3068996 lower to upper convert
        Diagnosis.DiagnosisCode=Diagnosis.DiagnosisCode.toUpperCase();
        cmp.set('v.Diagnosis', Diagnosis);
        this.bindValues(cmp, event);
    },

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

    executeValidations: function (cmp, event) {
        var errorsRI = cmp.get('v.errorsRI');
        errorsRI.isValidRIDC = false;
        var fieldsToValidate = cmp.get('v.fieldsToValidate');
        var validationCounter = 0;
        for (var i in fieldsToValidate) {
            var fieldElement = cmp.find(fieldsToValidate[i]);
            if (!$A.util.isUndefined(fieldElement)) {
                if (!fieldElement.checkValidity()) {
                    validationCounter++;
                    errorsRI.errorsList.push(fieldElement.get("v.label"));
                }
                fieldElement.reportValidity();
            }
        }

        if (0 == validationCounter) {
            errorsRI.isValidRIDC = true;
        }
        cmp.set('v.errorsRI', errorsRI);
    }

})