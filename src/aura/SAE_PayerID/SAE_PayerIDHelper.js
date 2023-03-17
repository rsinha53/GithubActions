({
    filterPayerIDs: function(cmp, event, helper) {
        var typeText = cmp.get('v.typeText');
        var dataList = cmp.get("v.dataList");
        if (typeText == undefined || typeText == '') {
            cmp.set('v.dataListFilter', dataList);
            cmp.set('v.display', false);
            return;
        }
        typeText = typeText.toLowerCase();
        var dataListFilter = [];
        for (var i = 0; i < dataList.length; i++) {
            if ((dataList[i].value.toLowerCase().indexOf(typeText) != -1) || (dataList[i].label.toLowerCase().indexOf(typeText) != -1)) {
                dataListFilter.push(dataList[i]);
            }
        }
        if (dataListFilter.length > 0) {
            cmp.set('v.dataListFilter', dataListFilter);
            cmp.set('v.display', true);
        } else {
            cmp.set('v.dataListFilter', dataList);
        }
    },

    resetAll: function(cmp, event, helper) {
        if(cmp.get('v.cardNumber')){
            var defaultPayerValue = cmp.get('v.defaultPayerValue');
            var defaultPayerLabel = cmp.get('v.defaultPayerLabel');
            var dataList = cmp.get("v.dataList");
            cmp.set('v.dataListFilter', dataList);
            cmp.set('v.payerValue', defaultPayerValue);
            cmp.set('v.typeText', defaultPayerLabel)
            cmp.set('v.payerLabel', defaultPayerLabel);
            cmp.set('v.display', false);
        }
        
    }

})