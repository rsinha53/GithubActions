({

    // US2950839
    bindValues: function (cmp, event) {
        var SRNData = cmp.get('v.SRNData');
        var fieldValue = event.getSource().get("v.value");
        var fieldName = event.getSource().get("v.name");
        SRNData.SubmitInfo[fieldName] = fieldValue;
        cmp.set('v.SRNData', SRNData);
    },

    // US2950839
    executeValidations: function (cmp, event) {

        // All the Submit Card Validateions
        var errorsSB = new Object();
        errorsSB.isValidSB = false;
        errorsSB.errorsList = [];
        var fieldsToValidate = cmp.get('v.fieldsToValidate');
        var validationCounter = 0;
        for (var i in fieldsToValidate) {
            var fieldElement = cmp.find(fieldsToValidate[i]);
            if (!$A.util.isUndefined(fieldElement)) {
                if (!fieldElement.checkValidity()) {
                    validationCounter++;
                    errorsSB.errorsList.push('Alternative Fax And/Or Send letter by Mail');
                }
                fieldElement.reportValidity();
            }
        }

        var uniqueChars = errorsSB.errorsList.filter((c, index) => {
            return errorsSB.errorsList.indexOf(c) === index;
        });

        errorsSB.errorsList = uniqueChars;

        if (0 == validationCounter) {
            errorsSB.isValidSB = true;
        }

        var errors = cmp.get('v.errors');
        errors.errorsSB = errorsSB;

        // US3026437
        var SRNData = cmp.get('v.SRNData');
        var ServiceSetting = SRNData.RequiredInfo.ServiceSetting;

        // All the provider card validations
        var errorsPR = new Object();
        errorsPR.isValidPR = true;
        errorsPR.errorsList = [];
        var srnProviderDetailList = cmp.get('v.srnProviderDetailList');
        var validationCounter = 0;
        var validationAttending = 0;
        var servicingProviderCounter = 0; // US3507481 Swapnil
        // US3077461	Validations Part 4 - Inpatient/Outpatient/Outpatient Facility - Ability to Remove Provider Card When Needed - Sarma - 18/11/2020
        var validationDefaultProvider = 0;
        if(srnProviderDetailList.length == 1 && !(srnProviderDetailList[0].isShowProviderDetails)){
            validationDefaultProvider++;
        }
        for (var i = 0; i < srnProviderDetailList.length; i++) {
            if (srnProviderDetailList[i].isShowProviderDetails) {
                var prodtl = srnProviderDetailList[i].providerRoleDetails;
                if (!prodtl.isProviderPCP && !prodtl.isProviderFacility && !prodtl.isProviderAttending &&
                    !prodtl.isProviderRequesting && !prodtl.isProviderAdmitting && !prodtl.isProviderServicing) {
                    ++validationCounter;
                }
                // US3026437
                if (prodtl.isProviderAttending) {
                    ++validationAttending;
                }
                if(prodtl.isProviderServicing) {
                    servicingProviderCounter++;
                }
            }
        }

        // US3507481 Swapnil
        if(servicingProviderCounter == 0) {
            var SRNData= cmp.get('v.SRNData');
            var procedureData= SRNData.RequiredInfo.ProcedureData;
            for( var j in procedureData) {
                if( !(procedureData[j].ProcedureCode == "") ) {
                    errorsPR.isValidPR = false;
                    errorsPR.errorsList.push('Servicing Role is required for Provider ');
                    break;
                }
            }
        } //US3507481 ends

        if (0 < validationCounter) {
            errorsPR.isValidPR = false;
            errorsPR.errorsList.push('Provider Card role missing');
        }
        // US3026437
        // US3065991
        // if (0 == validationAttending && ServiceSetting == 'Inpatient') {
            // errorsPR.isValidPR = false;
            // errorsPR.errorsList.push('Attending role must be required for Physician');
        // }
         // US3077461
        if (0 < validationDefaultProvider) {
            errorsPR.isValidPR = false;
            errorsPR.errorsList.push('Add atleast 1 Provider');
        }
        cmp.set('v.errorsPR', errorsPR);
        errors.errorsPR = errorsPR;

        cmp.set('v.errors', errors);


    },

    // US2950839
    keepOnlyDigits: function (cmp, event) {
        var regEx = /[^0-9 ]/g;
        var fieldValue = event.getSource().get("v.value");
        if (fieldValue.match(regEx)) {
            event.getSource().set("v.value", fieldValue.replace(regEx, ''));
        }
        this.bindValues(cmp, event);
    },

})