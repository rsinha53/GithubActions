({
    onInit: function(cmp, event, helper) {
        var doShrink = cmp.get('v.doShrink');
        if(!doShrink){
            cmp.set('v.dataValueRendered', cmp.get('v.dataValue'));
            return;
        } else {
            // Manipulcate Text/Desc
            var dataValue = cmp.get('v.dataValue');
            var charactorLimit = cmp.get('v.charactorLimit');
            var str = '--';
            if (!$A.util.isUndefinedOrNull(dataValue) && dataValue.length > 0) {
                if (dataValue.length >= charactorLimit) {
                    str = dataValue.substring(0, charactorLimit) + '...';
                } else {
                    str = dataValue;
                }
            }
            cmp.set('v.dataValueRendered', str);
        }

        // Manipulcate Title
        var dataDesc = cmp.get('v.dataDesc');
        if (!$A.util.isUndefinedOrNull(dataDesc) && dataDesc.length > 0) {
            cmp.set('v.title', dataDesc);
        } else {
            cmp.set('v.title', dataValue);
        }

    }
})