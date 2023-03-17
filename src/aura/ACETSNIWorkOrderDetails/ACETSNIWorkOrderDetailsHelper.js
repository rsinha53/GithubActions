({
	getAuthDetails: function (cmp, event, helper) {
        
        var action = cmp.get("c.getAuthorizeDetails");
        action.setParams({ recid: cmp.get("v.recordId") });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state == "SUCCESS") {
                var data = response.getReturnValue();
                console.log('---------data------'+data);
                if (!($A.util.isUndefinedOrNull(data))) {
                    cmp.set('v.authorizeDetails', data);
                    var priroAuthEvt = $A.get("e.c:ACETSNIICUEPriorAuth");
                    console.log('priorAuthOwner---------------'+data.priorAuthOwner);
       console.log('hostSysDatTime---------------'+data.hostSysDatTime);
       console.log('canceledReason---------------'+data.canceledReason);
                        priroAuthEvt.setParams({ 
                            "priorAuthOwner" : data.priorAuthOwner,
                            "hostSysDatTime" : data.hostSysDatTime,
                            "canceledReason" : data.canceledReason
                        });
                        priroAuthEvt.fire();
                    console.log('---------success------'+JSON.stringify(data));
                }
            } else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
						console.log('----Exception----'+errors[0].message);
                    }
                } 
            }
        });
        $A.enqueueAction(action);
    }
     
})