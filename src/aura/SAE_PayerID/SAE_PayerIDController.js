({
    onInit: function(cmp, event, helper) {
        helper.resetAll(cmp, event, helper);
    },

    typeTextChange: function(cmp, event, helper) {
        helper.filterPayerIDs(cmp, event, helper);
    },

    getRowInfo: function(cmp, event, helper) {
        var selValue = event.currentTarget.getAttribute("data-value");
        var selLabel = event.currentTarget.getAttribute("data-label");
        cmp.set('v.typeText', selLabel);
        cmp.set('v.display', false);
        cmp.set('v.payerValue', selValue);
        cmp.set('v.payerLabel', selLabel);
    },

    inputClick: function(cmp, event, helper) {
        var dataList = cmp.get("v.dataList");
        cmp.set('v.dataListFilter', dataList);
        cmp.set('v.display', true);
    },

    disabledChange: function(cmp, event, helper) {
        var disabled = cmp.get('v.disabled');
        if (disabled){
            helper.resetAll(cmp, event, helper);
        }
    }

})