({

    // US2894783
    addAdditionalDiagnosisCodes: function (cmp, event, helper) {
        helper.createAdditionalDiagnosisCodes(cmp, event);
    },

    // US2894783
    addAdditionalProcedureCodes: function (cmp, event, helper) {
        helper.createAdditionalProcedureCodes(cmp, event);
    },

    // US2894783
    addAdditionalModifierCodes: function (cmp, event, helper) {
        helper.createAdditionalModifierCodes(cmp, event);
    },

    // US2894783
    bindValues: function (cmp, event, helper) {
        var fieldName = event.getSource().get("v.name");
        if (fieldName == 'ServiceStartDt' || fieldName == 'ServiceSetting') { // US3026437
            helper.add90DatesToServiceStartDate(cmp, event);
            // DE449740
            // helper.onChangeServiceSetting(cmp, event);
            // US3065991
            helper.bindValues(cmp, event);
        } else if (fieldName == 'PrimaryCode' || fieldName == 'AdmittingCode') {
            helper.validateCodesWithDot(cmp, event);
        } else if (fieldName == 'ReviewPriority') {
            // US2964353
            helper.onChangeReviewPriority(cmp, event);
        } else if(fieldName =='NoteDetails') {
            //US2978756
            helper.setRemainingChars(cmp,event);
        } else if (fieldName == 'PlaceOfService') {
            // US3065991
            helper.onChangePlaceOfService(cmp, event);
        } else {
            helper.bindValues(cmp, event);
        }
    },

    alphanumericAndNoSpecialCharacters: function (cmp, event, helper) {
        helper.keepAlphanumericAndNoSpecialCharacters(cmp, event);
    },

    keepOnlyDigits: function (cmp, event, helper) {
        helper.keepOnlyDigits(cmp, event);
    },

    fireValidations: function (cmp, event, helper) {
        // US3094699
        if (!$A.util.isUndefinedOrNull(event.getParam("tabId")) && event.getParam("tabId") == cmp.get('v.srnTabId')) {
        helper.executeValidations(cmp, event);
        }
    },

    handleTypeChange: function (cmp, event, helper) {
        // DE445499: Create Auth Additional Case Types Available for Outpatient
        var value = event.getParam("value");
        var listServiceDetail = cmp.get('v.lstService');
        if(value== 'Outpatient' && ( !helper.containsValue(listServiceDetail, 'Pharmacy') && !helper.containsValue(listServiceDetail, 'Dialysis') ) ) {
            listServiceDetail.push( {'label': 'Pharmacy', 'value': 'Pharmacy'},
									{'label': 'Dialysis', 'value': 'Dialysis'} );
            cmp.set('v.lstService', listServiceDetail);
        } else if(value!= 'Outpatient' && helper.containsValue(listServiceDetail, 'Pharmacy') && helper.containsValue(listServiceDetail, 'Pharmacy') ) {
            for(var i in listServiceDetail ){
                if(listServiceDetail[i].value == 'Pharmacy') {
                    listServiceDetail.splice(i, 1);
                    //i=listServiceDetail.length-1;
                }
                if(listServiceDetail[i].value == 'Dialysis') {
                    listServiceDetail.splice(i, 1);
                }
            }
            cmp.set('v.lstService', listServiceDetail);
        } // DE445499
        // DE449740
        helper.onChangeServiceSetting(cmp, event);
        helper.resetValidations(cmp, event);
    },

    // US3050746
    handleAdditionalRow: function (cmp, event, helper) {
        if (!$A.util.isUndefinedOrNull(event.getParam("type")) && !$A.util.isUndefinedOrNull(event.getParam("index"))) {
            var index = event.getParam("index");
            var type = event.getParam("type");
            var SRNData = cmp.get('v.SRNData');
            if (type == 'Diagnosis') {
                var DiagnosisData = SRNData.RequiredInfo.DiagnosisData;
                var DiagnosisCardList = cmp.get('v.DiagnosisCardList');
                for (var i = 0; i < DiagnosisCardList.length; i++) {
                    if (DiagnosisCardList[i].get('v.index') == index) {
                        var Diagnosis = DiagnosisCardList[i].get('v.Diagnosis');
                        DiagnosisCardList.splice(i, 1);
                        for (var x = 0; x < DiagnosisData.length; x++) {
                            if (DiagnosisData[x].DiagnosisCode == Diagnosis.DiagnosisCode && DiagnosisData[x].DiagnosisDesc == Diagnosis.DiagnosisDesc) {
                                DiagnosisData.splice(x, 1);
                                SRNData.RequiredInfo.DiagnosisData = DiagnosisData;
                            }
                        }
                        cmp.set('v.DiagnosisCardList', DiagnosisCardList);
                        break;
                    }
                }
            } else if (type == 'Procedure') {
                var ProcedureData = SRNData.RequiredInfo.ProcedureData;
                var ProcedureCardList = cmp.get('v.ProcedureCardList');
                for (var i = 0; i < ProcedureCardList.length; i++) {
                    if (ProcedureCardList[i].get('v.index') == index) {
                        var Procedure = ProcedureCardList[i].get('v.Procedure');
                        ProcedureCardList.splice(i, 1);
                        for (var x = 0; x < ProcedureData.length; x++) {
                            if (ProcedureData[x].ProcedureCode == Procedure.ProcedureCode && ProcedureData[x].ProcedureDesc == Procedure.ProcedureDesc
                                && ProcedureData[x].ProcedureType == Procedure.ProcedureType) {
                                ProcedureData.splice(x, 1);
                                SRNData.RequiredInfo.ProcedureData = ProcedureData;
                            }
                        }
                        cmp.set('v.ProcedureCardList', ProcedureCardList);
                        break;
                    }
                }
            }
            console.log(JSON.stringify(cmp.get('v.SRNData').RequiredInfo.ProcedureData));
    }
    },
    //US2979450 Integration for procedure and diagnosis codes _vishnu
	handleKLData: function (cmp, event, helper)
    {	var fieldName=event.getSource().getLocalId();
     	var objectDt = event.getParam("selectedKLRecord");
     	if(fieldName=='PrimaryCode')
        {
            cmp.set("v.SRNData.RequiredInfo.PrimaryDescription",objectDt.Code_Description__c);

        }else if(fieldName=='AdmittingCode')
        {
         	cmp.set("v.SRNData.RequiredInfo.AdmittingDescription",objectDt.Code_Description__c);
    }
    }
})