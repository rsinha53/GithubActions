({
    
    onInit: function(cmp, event, helper) {

        var RequiredInfo = cmp.get('v.RequiredInfo'); 
        var Procedure = {
            ProcedureCode: '',
            ProcedureDesc: '',
            ProcedureType: '',
            StandardOfMeasures: '',
            Count: '',
            Frequency: '',
            Total: '',
            DMEProcurementType: '',
            DMETotalCost: ''
        };
        RequiredInfo.ProcedureData.push(Procedure);
        cmp.set('v.Procedure', Procedure);
        cmp.set('v.RequiredInfo', RequiredInfo);
     
    },

    alphanumericAndNoSpecialCharacters: function (cmp, event, helper) {
        helper.keepAlphanumericAndNoSpecialCharacters(cmp, event);
    },

    bindValues: function(cmp, event, helper) {

        var RequiredInfo = cmp.get('v.RequiredInfo');
        var Procedure = cmp.get('v.Procedure');
        var index = cmp.get('v.index');
        //US3068996 lower to upper convert
        cmp.set('v.Procedure.ProcedureCode',Procedure.ProcedureCode.toUpperCase());
        Procedure.ProcedureCode=Procedure.ProcedureCode.toUpperCase()
        RequiredInfo.ProcedureData[index] = Procedure;
        cmp.set('v.RequiredInfo', RequiredInfo);
     
    },

    fireValidations: function (cmp, event, helper) {
        // US3094699
        if (!$A.util.isUndefinedOrNull(event.getParam("tabId")) && event.getParam("tabId") == cmp.get('v.srnTabId')) {
        helper.executeValidations(cmp, event);
        }
    },

    // US3050746
    deleteAdditionalRow: function (cmp, event, helper) {
        var cmpEvent = cmp.getEvent("ACET_CreateSRN_AdditionalCodesRemoveEvent");
        cmpEvent.setParams({
            "type": "Procedure",
            "index": cmp.get('v.index')
        });
        cmpEvent.fire();
    },

     handleKLData: function (cmp, event, helper) {
            var message = event.getParam("selectedKLRecord");
            var Proceduredt = cmp.get("v.Procedure");
            Proceduredt.ProcedureDesc = message.Code_Description__c;
            Proceduredt.ProcedureType = message.Code_Type__c;
            cmp.set("v.Procedure", Proceduredt);
    },

    // US3222360
    onChangeRequiredInfo: function (cmp, event, helper) {
        helper.onChangeServiceDetail(cmp, event);
        helper.onChangePlaceOfService(cmp, event);
    },

    // US3222360
    onChangeServiceDetailAttr: function (cmp, event, helper) {
        helper.onChangeServiceDetailAttr(cmp, event);
    },

    // US2816952 / US3222360
    keepOnlyDigits: function (cmp, event) {
        var regEx = /[^0-9 ]/g;
        var fieldValue = event.getSource().get("v.value");
        if (fieldValue.match(regEx)) {
            event.getSource().set("v.value", fieldValue.replace(regEx, ''));
        }
    },

    //US3507481 Swapnil
    onChangePlaceOfServiceAttr: function(cmp, event) {
        var oldValue = event.getParam("oldValue");
        var value = event.getParam("value");
        var ProcedureData = cmp.get('v.RequiredInfo').ProcedureData;
        if(!$A.util.isEmpty(value) && oldValue != value){
            if (value == 'Observation' && ProcedureData.length == 1 && cmp.get('v.Procedure').ProcedureCode == "") {
                cmp.set('v.autoSelect', true);
                cmp.set('v.autoPopulateString', '99218');
            } else {
                cmp.set('v.autoSelect', false);
            }
        }
    }

    
})