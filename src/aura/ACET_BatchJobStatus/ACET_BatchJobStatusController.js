({
    doInit: function (cmp, event, helper) {
        var action = cmp.get('c.getBatchJobStatus');
        action.setParams({
            "serviceRecordId": cmp.get("v.recordId")
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state == 'SUCCESS') {
                var result = response.getReturnValue();
                cmp.set('v.cronTriggerRecord', result);
            } else {
                cmp.set('v.cronTriggerRecord', null);
            }
        });
        $A.enqueueAction(action);
    },

    startJob: function (cmp, event, helper) {
        var action = cmp.get('c.initiateJob');
        action.setParams({
            "serviceName": cmp.get("v.serviceName")
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            var result = response.getReturnValue();
            alert(result);
        });
        $A.enqueueAction(action);
    }
})