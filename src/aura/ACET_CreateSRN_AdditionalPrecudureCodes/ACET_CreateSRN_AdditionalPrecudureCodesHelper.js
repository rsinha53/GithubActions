({
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
        errorsRI.isValidRIPC = false;
        var fieldsToValidate = cmp.get('v.fieldsToValidate');
        var validationCounter = 0;
        for (var i in fieldsToValidate) {
            var fieldElement = cmp.find(fieldsToValidate[i]);
            // US2974952
            if (fieldsToValidate[i] == 'ProcedureCode') {
                var codeComp = cmp.find(fieldsToValidate[i]);
                var requiredCheck = (codeComp.get('v.required') == true && $A.util.isEmpty(cmp.get('v.Procedure')[fieldsToValidate[i]]));
                if (codeComp.get('v.hasErrors') == true || requiredCheck) {
                    validationCounter++;
                    errorsRI.errorsList.push(codeComp.get('v.label'));
                    if (requiredCheck) {
                        codeComp.fireErrors();
                    }
                }
            } else {
            if (!$A.util.isUndefined(fieldElement)) {
                if (!fieldElement.checkValidity()) {
                    validationCounter++;
                    errorsRI.errorsList.push(fieldElement.get("v.label"));
                }
                fieldElement.reportValidity();
            }
        }
        }

        if (0 == validationCounter) {
            errorsRI.isValidRIPC = true;
        }
        cmp.set('v.errorsRI', errorsRI);
    },

    // US3222360
    onChangeServiceDetail: function (cmp, event) {
        if (!$A.util.isUndefined(cmp.get("v.RequiredInfo").ServiceDetail)) {
         	cmp.set('v.ServiceDetail', cmp.get("v.RequiredInfo").ServiceDetail);
        }
    },

    // US3222360
    onChangeServiceDetailAttr: function (cmp, event) {
        var oldValue = event.getParam("oldValue");
        var value = event.getParam("value");
        if(!$A.util.isEmpty(value) && oldValue != value){
            if (value == 'Durable Medical Equipment') {
                var Procedure = cmp.get('v.Procedure');
                Procedure.ProcedureType = 'HCPCS';
                cmp.set('v.Procedure', Procedure);
            }
        }
    },

    //US3507481
    onChangePlaceOfService: function (cmp, event) {
        if (!$A.util.isUndefined(cmp.get("v.RequiredInfo").PlaceOfService)) {
            cmp.set('v.placeOfService', cmp.get("v.RequiredInfo").PlaceOfService);
       }
    }

})