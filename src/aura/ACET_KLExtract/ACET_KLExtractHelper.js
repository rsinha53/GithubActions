({
    selectItemHelper: function (cmp, event) {
        var searchString = cmp.get('v.searchString');
        var options = cmp.get('v.options');
        var selectedId = event.currentTarget.id;
        var element = options[selectedId].value;
                    var compEvent = cmp.getEvent("sendData");
                    compEvent.setParams({
                        "selectedKLRecord": element
                    });
                    compEvent.fire();
                    searchString = element.Name;
        cmp.set('v.value', searchString);
        cmp.set('v.selectedCodeDesc', element.Code_Description__c); // US3437462
            cmp.set('v.searchString', searchString);
        $A.util.removeClass(cmp.find('resultsDiv'), 'slds-is-open');
    },

    blurEventHelper: function (cmp, event) {
        var selectedValue = cmp.get('v.value');
        cmp.set('v.searchString', selectedValue);
            $A.util.removeClass(cmp.find('resultsDiv'), 'slds-is-open');
        this.fireErrors(cmp);
        // US3518478
        this.resetData(cmp, event);
    },

    getKLData: function (cmp) {
        cmp.set('v.loading', true);
        var searchString = cmp.get('v.searchString');
        var action = cmp.get("c.getKLData");
        action.setParams({
            "key": searchString,
            "codeType": cmp.get('v.codeType')
        });
        cmp.set("v.options", []);
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var options = response.getReturnValue();
                //US3507481- To autoSelect a code - Swapnil
                if (cmp.get('v.autoSelect') && options.length == 1) {
                    var Procedure = cmp.get('v.Procedure');
                    if (Procedure.ProcedureCode == '') {
                        Procedure.ProcedureCode = options[0].Name;
                        Procedure.ProcedureDesc = options[0].Code_Description__c;
                        Procedure.ProcedureType = options[0].Code_Type__c;
                        cmp.set('v.Procedure', Procedure);
                    }  // US3507481 ends
                } else {
                    if ($A.util.isUndefinedOrNull(options) || options.length == 0) {
                        cmp.set("v.message", "No results found for '" + searchString + "'");
                    } else {
                        // if (options.length > 700) {
                        //     cmp.set("v.options", []);
                        //     cmp.set("v.message", "Data is too heavy, Please narrow down the sarch");
                        // } else {
                            var optionsList = [];
                            for (var key in options) {
                                optionsList.push({ key: options[key].Name, value: options[key] });
                            }
                            cmp.set("v.options", optionsList);
                        cmp.set("v.message", '');
                        // }
                    }
                }
                cmp.set('v.loading', false);
            } else {
                console.log('error :', action.getError());
                cmp.set('v.loading', false);
            }
        });
        $A.enqueueAction(action);
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

    validateCodesWithDot: function (cmp, fieldValue) {
        cmp.set('v.hasError', false);
        cmp.set('v.errorMsg', '');
        if (fieldValue.length > 0) {
            if (fieldValue.length < 3) {
                cmp.set('v.hasError', true);
                cmp.set('v.errorMsg', 'Invalid input.');
            } else if (fieldValue.length > 3) {
                var fs = fieldValue.substring(0, 3);
                var sc = '';
                if (fieldValue.length == 4 && fieldValue.substr(fieldValue.length - 1) == '.') {
                    fieldValue = fs;
                } else {
                    if (fieldValue.indexOf('.') !== -1) {
                        sc = fieldValue.substring(4, fieldValue.length);
                    } else {
                        sc = fieldValue.substring(3, fieldValue.length);
                    }
                    fieldValue = (fs + '.' + sc);
                }
            }
        }
        return fieldValue;
    },

    fireErrors: function (cmp) {
        cmp.set('v.hasError', false);
        cmp.set('v.errorMsg', '');
        if (cmp.get('v.conditionalRequired')) {
            // if (!$A.util.isEmpty(cmp.get('v.searchString'))) {
            //     cmp.set('v.hasError', true);
            //     cmp.set('v.errorMsg', 'Complete this field.');
            // } else {
            //     cmp.set('v.hasError', false);
            //     cmp.set('v.errorMsg', '');
            // }
        } else {
            if (cmp.get('v.required')) {
                if ($A.util.isEmpty(cmp.get('v.searchString'))) {
                    cmp.set('v.hasError', true);
                    cmp.set('v.errorMsg', 'Complete this field.');
                }
            }
        }
        // if (cmp.get('v.required')) {
        //     if ($A.util.isEmpty(cmp.get('v.searchString'))) {
        //         cmp.set('v.hasError', true);
        //         cmp.set('v.errorMsg', 'Complete this field.');
        //     }
        // } else if (cmp.get('v.conditionalRequired')) {
        // if (!$A.util.isEmpty(cmp.get('v.searchString'))) {
        //     cmp.set('v.hasError', true);
        //     cmp.set('v.errorMsg', 'Complete this field.');
        // } else {
        //     cmp.set('v.hasError', false);
        //     cmp.set('v.errorMsg', '');
        // }
        // }
    },

    makeRequired: function (cmp, event, helper) {
        cmp.set('v.hasError', true);
        cmp.set('v.errorMsg', 'Complete this field.');
    },

    removeRequired: function (cmp, event, helper) {
        cmp.set('v.hasError', false);
        cmp.set('v.errorMsg', '');
    },

    makeHighlighted: function (cmp, event, helper) {
        cmp.set('v.hasError', true);
        cmp.set('v.errorMsg', '');
    },
    // US3437462	Plan Benefits: Benefit & PA Check Results: Validations - Sarma - 09 Mar 2021
    addDeletedError: function (cmp, event, helper) {
        cmp.set('v.hasError', true);
        if(cmp.get('v.codeType') == 'ProcedureCode'){
            cmp.set('v.errorMsg', 'Invalid Procedure code');
        } else if(cmp.get('v.codeType') == 'DiagnosisCode'){
            cmp.set('v.errorMsg', 'Invalid Diagnosis code');
        }
    },

    // US3518478
    resetData: function (cmp, event) {
        if ($A.util.isEmpty(cmp.get('v.searchString'))) {
            var cmp = cmp.getEvent("sendData");
            var element = {
                'Code_Type__c': '',
                'Id': '',
                'Name': '',
                'Code_Description__c': ''
            };
            cmp.setParams({
                "selectedKLRecord": element
            });
            cmp.fire();
        }
    }
})