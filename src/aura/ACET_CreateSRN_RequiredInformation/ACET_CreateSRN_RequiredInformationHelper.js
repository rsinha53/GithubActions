({
    // US2894783
    createAdditionalDiagnosisCodes: function (cmp, event) {

        var DiagnosisCardList = cmp.get('v.DiagnosisCardList');
        var DiagnosisCardLimit = cmp.get('v.DiagnosisCardLimit');

        var DiagnosisLength = DiagnosisCardList.length;

        if (DiagnosisCardLimit <= DiagnosisLength) {
            return;
        }

        $A.createComponent('c:ACET_CreateSRN_AdditionalDiagnosisCodes', {
            "RequiredInfo": cmp.getReference('v.SRNData.RequiredInfo'),
            "index": DiagnosisLength,
            "errorsRI": cmp.getReference('v.errorsRI'),
            "srnTabId": cmp.getReference('v.srnTabId') // US3094699
        },
            function (newcmp, status, error) {
                if (status === "SUCCESS") {
                    DiagnosisCardList.push(newcmp);
                    cmp.set("v.DiagnosisCardList", DiagnosisCardList);
                }
            }
        );

    },

    // US2894783
    createAdditionalProcedureCodes: function (cmp, event) {

        var ProcedureCardList = cmp.get('v.ProcedureCardList');
        var ProcedureCardLimit = cmp.get('v.ProcedureCardLimit');

        var ProcedureLength = ProcedureCardList.length;

        if (ProcedureCardLimit <= ProcedureLength) {
            return;
        }

        $A.createComponent('c:ACET_CreateSRN_AdditionalPrecudureCodes', {
            "RequiredInfo": cmp.getReference('v.SRNData.RequiredInfo'),
            "index": ProcedureLength,
            "errorsRI": cmp.getReference('v.errorsRI'),
            "type": cmp.getReference('v.type'),
            "srnTabId": cmp.getReference('v.srnTabId') // US3094699
        },
            function (newcmp, status, error) {
                if (status === "SUCCESS") {
                    ProcedureCardList.push(newcmp);
                    cmp.set("v.ProcedureCardList", ProcedureCardList);
                }
            }
        );

    },

    // US2894783
    createAdditionalModifierCodes: function (cmp, event) {

        var ModifierCardList = cmp.get('v.ModifierCardList');
        var ModifierCardLimit = cmp.get('v.ModifierCardLimit');

        var ModifierLength = ModifierCardList.length;

        if (ModifierCardLimit <= ModifierLength) {
            return;
        }

        $A.createComponent('c:ACET_CreateSRN_AdditionalModifierCodes', {
            "RequiredInfo": cmp.getReference('v.SRNData.RequiredInfo'),
            "index": ModifierLength,
            "srnTabId": cmp.getReference('v.srnTabId') // US3094699
        },
            function (newcmp, status, error) {
                if (status === "SUCCESS") {
                    ModifierCardList.push(newcmp);
                    cmp.set("v.ModifierCardList", ModifierCardList);
                }
            }
        );

    },

    // US2894783
    bindValues: function (cmp, event) {
        var SRNData = cmp.get('v.SRNData');
        var fieldValue = event.getSource().get("v.value");
        var fieldName = event.getSource().get("v.name");
        SRNData.RequiredInfo[fieldName] = fieldValue;
        cmp.set('v.SRNData', SRNData);
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

    add90DatesToServiceStartDate: function (cmp, event) {
        // US3026437
        var SRNData = cmp.get('v.SRNData');
        var fieldValue = SRNData.RequiredInfo['ServiceStartDt'];
        var newDate;
        if (fieldValue == undefined || fieldValue.length == 0 || SRNData.RequiredInfo.ServiceSetting == 'Inpatient') {
            newDate = null;
        } else {
            newDate = new Date(fieldValue);
            newDate.setDate(newDate.getDate() + 90);
            var date = newDate.toJSON().slice(0, 10);
            newDate = date.slice(0, 4) + '-'
                + date.slice(5, 7) + '-'
                + date.slice(8, 10);
        }
        SRNData.RequiredInfo['ServiceEndDt'] = newDate;
        cmp.set('v.SRNData', SRNData);
    },

    validateCodesWithDot: function (cmp, event) {
        var fieldName = event.getSource().get("v.name");
        var fieldValue = event.getSource().get("v.value");
        var SRNData = cmp.get('v.SRNData');
        var field = cmp.find(fieldName);
        field.setCustomValidity('');
        if (fieldValue.length > 0) {//US3068996 lower to upper convert
            if (fieldValue.length == 3) {
                SRNData.RequiredInfo[fieldName] = fieldValue.toUpperCase();
                cmp.set('v.SRNData', SRNData);
            }
            if (fieldValue.length < 3) {
                //US3068996 lower to upper convert
                SRNData.RequiredInfo[fieldName] = fieldValue.toUpperCase();
                cmp.set('v.SRNData', SRNData);
                field.setCustomValidity('Invalid input.');
            } else if (fieldValue.length > 3) {
                var fs = fieldValue.substring(0, 3);
                var sc = '';
                if (fieldValue.length == 4 && fieldValue.substr(fieldValue.length - 1) == '.') {
                    SRNData.RequiredInfo[fieldName] = (fs);
                } else {
                    if (fieldValue.indexOf('.') !== -1) {
                        sc = fieldValue.substring(4, fieldValue.length);
                    } else {
                        sc = fieldValue.substring(3, fieldValue.length);
                    }//US3068996 lower to upper convert
                    SRNData.RequiredInfo[fieldName] = (fs.toUpperCase() + '.' + sc.toUpperCase());
                }
                cmp.set('v.SRNData', SRNData);
            }
        }
    },

    // US2816952
    keepOnlyDigits: function (cmp, event) {
        var regEx = /[^0-9 ]/g;
        var fieldValue = event.getSource().get("v.value");
        if (fieldValue.match(regEx)) {
            event.getSource().set("v.value", fieldValue.replace(regEx, ''));
        }
        this.bindValues(cmp, event);
    },

    executeValidations: function (cmp, event) {
        var errorsRI = new Object();
        errorsRI.isValidRI = false;
        errorsRI.errorsList = [];
        var fieldsToValidate = cmp.get('v.fieldsToValidate');
        var validationCounter = 0;

        //US3674191 View Authorization : Create Auth - Broken Coverage line & Inactive policy - Sarma - 6th July 2021
        debugger;
        var policySelectedIndex = cmp.get('v.policySelectedIndex');
        var memberPolicies = cmp.get('v.memberPolicies');
        var serviceStartDateCmp = cmp.find('ServiceStartDt');
        var serviceEndDateCmp = cmp.find('ServiceEndDt');
        var serviceStartDate = serviceStartDateCmp.get('v.value');
        var serviceEndDate =  serviceEndDateCmp.get('v.value');
        if(!$A.util.isEmpty(serviceStartDate)){
            const myArr = serviceStartDate.split("-");
            if(myArr.length > 2){
                serviceStartDate = myArr[1] + '/' + myArr[2] + '/' + myArr[0];
            }
        }
        if(!$A.util.isEmpty(serviceEndDate)){
            const myArr = serviceEndDate.split("-");
            if(myArr.length > 2){
                serviceEndDate = myArr[1] + '/' + myArr[2] + '/' + myArr[0];
            }
        }
        var policy = cmp.get('v.policy');
        if(!$A.util.isEmpty(memberPolicies) && memberPolicies.length > 0){
            var currentPolicyStartDate = memberPolicies[policySelectedIndex].EffectiveDate;
            var currentPolicyEndDate;
            if(!$A.util.isEmpty(memberPolicies[policySelectedIndex].EndDate)){
                currentPolicyEndDate = memberPolicies[policySelectedIndex].EndDate;
            } else if(!$A.util.isEmpty(policy) && !$A.util.isEmpty(policy.resultWrapper) && !$A.util.isEmpty(policy.resultWrapper.policyRes) && !$A.util.isEmpty(policy.resultWrapper.policyRes.coverageEndDate)){
                currentPolicyEndDate = policy.resultWrapper.policyRes.coverageEndDate;
            } else {
                currentPolicyEndDate = '12/31/9999';
            }
            //var currentPolicyEndDate = $A.util.isEmpty(memberPolicies[policySelectedIndex].EndDate) ? '9999-12-31' : memberPolicies[policySelectedIndex].EndDate;

            if(!$A.util.isEmpty(currentPolicyStartDate) && !$A.util.isEmpty(currentPolicyEndDate)){

                //Start Date Validation
                var invalidStartDate = false;

                if(!$A.util.isEmpty(serviceStartDate)){
                    var policyStartDateObj = new Date(currentPolicyStartDate);
                    var policyEndDateObj = new Date(currentPolicyEndDate);

                    var serviceStartDateObj = new Date(serviceStartDate);
                    if(serviceStartDateObj < policyStartDateObj || serviceStartDateObj > policyEndDateObj){
                        invalidStartDate = true;

                        if(!$A.util.isEmpty(memberPolicies) && memberPolicies.length > 0){
                            for(var x = 0; x < memberPolicies.length; x++){
                                var policyLine = memberPolicies[x];
                                if(policySelectedIndex != x && policyLine.actualCoverageType == 'Medical' && memberPolicies[policySelectedIndex].actualCoverageType == policyLine.actualCoverageType &&
                                    memberPolicies[policySelectedIndex].GroupNumber == policyLine.GroupNumber){
                                        console.log('Broken Policy Found! for Start Date');
                                        if(!$A.util.isEmpty(policyLine.EffectiveDate) && !$A.util.isEmpty(policyLine.EndDate)){
                                            var polStartDate = new Date(policyLine.EffectiveDate);
                                            var polEndDate = new Date(policyLine.EndDate);
                                            if(polStartDate <= serviceStartDateObj && polEndDate >= serviceStartDateObj){
                                                invalidStartDate = false;
                                            }
                                        }

                                    }
                            }
                        }
                    }
                }
                if(invalidStartDate){
                    validationCounter++;
                    errorsRI.errorsList.push('Service Start Date (mm/dd/yyyy) within the members eligibility dates.');
                    serviceStartDateCmp.set('v.validity','false');
                    serviceStartDateCmp.setCustomValidity('Invalid Date.');
                    serviceStartDateCmp.reportValidity();
                    cmp.set('v.isServiceStartDateValidated', true);
                } else{
                    serviceStartDateCmp.set('v.validity','true');
                    serviceStartDateCmp.setCustomValidity('');
                    serviceStartDateCmp.reportValidity();
                    cmp.set('v.isServiceStartDateValidated', false);
                }

                //End Date Validation
                debugger;
                var invalidEndDate = false;
                if(!$A.util.isEmpty(serviceEndDate)){

                    var serviceEndDateObj = new Date(serviceEndDate);
                    if(policyEndDateObj < serviceEndDateObj || serviceEndDateObj < policyStartDateObj){
                        invalidEndDate = true;
                        // var policySelectedIndex = cmp.get('v.policySelectedIndex');
                        // var memberPolicies = cmp.get('v.memberPolicies');

                        if(!$A.util.isEmpty(memberPolicies) && memberPolicies.length > 0){
                            for(var x = 0; x < memberPolicies.length; x++){
                                var policyLine = memberPolicies[x];
                                if(policySelectedIndex != x && policyLine.actualCoverageType == 'Medical' && memberPolicies[policySelectedIndex].actualCoverageType == policyLine.actualCoverageType &&
                                    memberPolicies[policySelectedIndex].GroupNumber == policyLine.GroupNumber){
                                        console.log('Broken Policy Found! for End Date');
                                        if(!$A.util.isEmpty(policyLine.EffectiveDate) && !$A.util.isEmpty(policyLine.EndDate)){
                                            var polStartDate = new Date(policyLine.EffectiveDate);
                                            var polEndDate = new Date(policyLine.EndDate);
                                            if(polStartDate <= serviceEndDateObj && polEndDate >= serviceEndDateObj){
                                                invalidEndDate = false;
                                            }
                                        }

                                    }
                            }
                        }
                    }

                }
                if(invalidEndDate){
                    validationCounter++;
                    errorsRI.errorsList.push('Service End Date (mm/dd/yyyy) within the members eligibility dates.');
                    serviceEndDateCmp.set('v.validity','false');
                    serviceEndDateCmp.setCustomValidity('Invalid Date.');
                    serviceEndDateCmp.reportValidity();
                    cmp.set('v.isServiceEndDateValidated', true);
                } else{
                    serviceEndDateCmp.set('v.validity','true');
                    serviceEndDateCmp.setCustomValidity('');
                    serviceEndDateCmp.reportValidity();
                    cmp.set('v.isServiceEndDateValidated', false);
                }
            }

        }
        // US3674191 Ends

        // US3446963
        var SRNData = cmp.get('v.SRNData');
        var isValidDiagnosisCode = true;
        var isValidProcedureCode = true;
        for (var i in fieldsToValidate) {
            var fieldElement = cmp.find(fieldsToValidate[i]);
            // US2974952
            if (fieldsToValidate[i] == 'PrimaryCode') {
                var codeComp = cmp.find(fieldsToValidate[i]);
                var requiredCheck = (codeComp.get('v.required') == true && $A.util.isEmpty(cmp.get('v.SRNData').RequiredInfo[fieldsToValidate[i]]));
                // US3446963
                var PrimaryDescription = SRNData.RequiredInfo.PrimaryDescription;
                if (codeComp.get('v.hasErrors') == true || requiredCheck) {
                    validationCounter++;
                    errorsRI.errorsList.push(codeComp.get('v.label'));
                    if (requiredCheck) {
                        codeComp.fireErrors();                    }
                } else if (!$A.util.isEmpty(PrimaryDescription) && (PrimaryDescription.toLowerCase().includes("incomplete code") || PrimaryDescription.toLowerCase().includes("invalid") || PrimaryDescription.toLowerCase().includes("deleted"))) {
                    codeComp.addDeletedError();
                    isValidDiagnosisCode = false;
                } else {
                    codeComp.removeRequired();
                }
            } else if (fieldsToValidate[i] == 'AdmittingCode') { // US3446963
                var codeComp = cmp.find(fieldsToValidate[i]);
                var AdmittingDescription = SRNData.RequiredInfo.AdmittingDescription;
                if (!$A.util.isEmpty(AdmittingDescription) && (AdmittingDescription.toLowerCase().includes("incomplete code") || AdmittingDescription.toLowerCase().includes("invalid") || AdmittingDescription.toLowerCase().includes("deleted"))) {
                    codeComp.addDeletedError();
                    isValidDiagnosisCode = false;
                } else {
                    codeComp.removeRequired();
                }
            } else if (fieldsToValidate[i] == 'ServiceStartDt') {
                if(!cmp.get('v.isServiceStartDateValidated')){
                    if (!fieldElement.checkValidity()) {
                        validationCounter++;
                        errorsRI.errorsList.push(fieldElement.get("v.label"));
                    }
                    fieldElement.reportValidity();
                }
            } else if (fieldsToValidate[i] == 'ServiceEndDt') {
                if(!cmp.get('v.isServiceEndDateValidated')){
                    if (!fieldElement.checkValidity()) {
                        validationCounter++;
                        errorsRI.errorsList.push(fieldElement.get("v.label"));
                    }
                    fieldElement.reportValidity();
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

        // US3446963
        var DiagnosisCardList = cmp.get('v.DiagnosisCardList');
        var DiagnosisCmp = '';
        var Diagnosis = '';
        var DiagnosisDesc = '';
        for (var i = 0; i < DiagnosisCardList.length; i++) {
            DiagnosisCmp = DiagnosisCardList[i];
            Diagnosis = DiagnosisCmp.get('v.Diagnosis');
            DiagnosisDesc = Diagnosis.DiagnosisDesc;
            if (!$A.util.isEmpty(DiagnosisDesc) && (DiagnosisDesc.toLowerCase().includes("incomplete code") || DiagnosisDesc.toLowerCase().includes("invalid") || DiagnosisDesc.toLowerCase().includes("deleted"))) {
                DiagnosisCmp.find('DiagnosisCode').addDeletedError();
                isValidDiagnosisCode = false;
            } else {
                DiagnosisCmp.find('DiagnosisCode').removeRequired();
            }
        }

        var ProcedureCardList = cmp.get('v.ProcedureCardList');
        var ProcedureCmp = '';
        var Procedure = '';
        var ProcedureDesc = '';
        for (var i = 0; i < ProcedureCardList.length; i++) {
            ProcedureCmp = ProcedureCardList[i];
            Procedure = ProcedureCmp.get('v.Procedure');
            ProcedureDesc = Procedure.ProcedureDesc;
            if (!$A.util.isEmpty(ProcedureDesc) && (ProcedureDesc.toLowerCase().includes("incomplete code") || ProcedureDesc.toLowerCase().includes("invalid") || ProcedureDesc.toLowerCase().includes("deleted"))) {
                ProcedureCmp.find('ProcedureCode').addDeletedError();
                isValidProcedureCode = false;
            } else {
                ProcedureCmp.find('ProcedureCode').removeRequired();
            }
        }

        if (!isValidDiagnosisCode) {
            validationCounter++;
            errorsRI.errorsList.push('Valid Diagnosis Code');
        }

        if (!isValidProcedureCode) {
            validationCounter++;
            errorsRI.errorsList.push('Valid Procedure Code');
        }

        if (0 == validationCounter) {
            errorsRI.isValidRI = true;
        }

        // US3065991
        var SRNData = cmp.get('v.SRNData');
        if (!$A.util.isUndefinedOrNull(SRNData) && !$A.util.isUndefinedOrNull(SRNData.RequiredInfo)) {
            if (!$A.util.isUndefinedOrNull(SRNData.RequiredInfo.PlaceOfService) && SRNData.RequiredInfo.PlaceOfService == 'Hospice') {
                if (!$A.util.isUndefinedOrNull(SRNData.RequiredInfo.ServiceDetail) && SRNData.RequiredInfo.ServiceDetail != 'Hospice') {
                    errorsRI.isValidRI = false;
                    errorsRI.errorsList.push('Service detail should be Hospice');
                }
            }
        }

        // US3507484
        if (SRNData.RequiredInfo.ServiceSetting == 'Inpatient') {

            var diffActDt = this.checkAdmissionDateLogic(cmp, event);
            if (diffActDt) {
                errorsRI.isValidRI = false;
                errorsRI.errorsList.push('Actual admission date cannot be a future date.');
            }

            var diffDisDt = this.checkDischargeDateLogic(cmp, event);
            if (diffDisDt) {
                errorsRI.isValidRI = false;
                errorsRI.errorsList.push('The request must be within 93 calendar days from discharge.');
            }
        }
        cmp.set('v.errorsRI', errorsRI);
    },

    // US2816952
    resetValidations: function (cmp, event) {
        var fieldsToValidate = cmp.get('v.fieldsToValidate');
        for (var i in fieldsToValidate) {
            var el = cmp.find(fieldsToValidate[i]);
            // US2974952
            if (fieldsToValidate[i] == 'PrimaryCode') {
                var codeComp = cmp.find(fieldsToValidate[i]);
                var requiredCheck = (codeComp.get('v.required') == true && $A.util.isEmpty(cmp.get('v.SRNData').RequiredInfo[fieldsToValidate[i]]));
                if (requiredCheck) {
                    codeComp.removeRequired();
                }
            } else if (fieldsToValidate[i] == 'AdmittingCode') {

            } else {
            if (!$A.util.isUndefined(el)) {
                if (el.checkValidity()) {
                    el.showHelpMessageIfInvalid();
                }
            }
        }
        }
    },

    // US2964353
    onChangeReviewPriority: function (cmp, event) {
        var fieldValue = event.getSource().get("v.value");
        var type = cmp.get('v.type');
        var SRNData = cmp.get('v.SRNData');
        if (type == 'Inpatient' && (fieldValue == 'Concurrent Expedited' || fieldValue == 'Concurrent Routine')) {
            SRNData.RequiredInfo.HasAdmitted = 'Yes';
        } else {
            SRNData.RequiredInfo.HasAdmitted = 'No';
        }
        cmp.set('v.SRNData', SRNData);
        this.bindValues(cmp, event);
    },

    //US2978756
    setRemainingChars: function (cmp, event) {
        var fieldValue = event.getSource().get("v.value");
		var length = fieldValue.length;
        var remaining= 2000 - length;
        cmp.set("v.charsremaining", remaining);
    },

    // US3065991
    onChangePlaceOfService: function (cmp, event) {
        var fieldValue = event.getSource().get("v.value");
        var SRNData = cmp.get('v.SRNData');
        if (fieldValue == 'Hospice') {
            SRNData.RequiredInfo.ServiceDetail = 'Hospice';
	}
        cmp.set('v.SRNData', SRNData);
        this.bindValues(cmp, event);
    },

    // US3507484
    checkDischargeDateLogic: function (cmp, event) {
        var SRNData = cmp.get('v.SRNData');
        var today = Date.now();
        var ActualDischargeDt = SRNData.RequiredInfo['ActualDischargeDt'];
        var ActualDischargeDt;
        if ((ActualDischargeDt != undefined && ActualDischargeDt.length > 0)) {
            ActualDischargeDt = new Date(ActualDischargeDt).getTime();
            var DiffDays = ((today - ActualDischargeDt) / (1000 * 3600 * 24));
            if (DiffDays > 93) {
                return true;
            }
        }
        return false;
    },

    // US3507484
    onChangeHasAdmitted: function (cmp, event) {
        var fieldValue = event.getSource().get("v.value");
        var SRNData = cmp.get('v.SRNData');
        if (fieldValue == 'No') {
            SRNData.RequiredInfo.ActualDischargeDt = '';
        }
        cmp.set('v.SRNData', SRNData);
    },

    // US3507484
    checkAdmissionDateLogic: function (cmp, event) {
        var SRNData = cmp.get('v.SRNData');
        var ActualAdmissionDt = SRNData.RequiredInfo['ActualAdmissionDt'];
        if (ActualAdmissionDt != undefined && (ActualAdmissionDt != undefined)) {
            ActualAdmissionDt = new Date(ActualAdmissionDt).getTime();
            if (ActualAdmissionDt > Date.now()) {
                return true;
    }
        }
        return false;
    },

    // DE445499: Create Auth Additional Case Types Available for Outpatient
    containsValue: function (lst, value){
        console.log(JSON.stringify(lst));
        for( var i in lst ){
            if(lst[i].value == value) {
                return true;
            }
        }
        return false;
    },

    // DE449740
    onChangeServiceSetting: function (cmp, event) {
        var SRNData = cmp.get('v.SRNData');
        SRNData.RequiredInfo.PlaceOfService = '';
        cmp.set('v.SRNData', SRNData);
    }


})