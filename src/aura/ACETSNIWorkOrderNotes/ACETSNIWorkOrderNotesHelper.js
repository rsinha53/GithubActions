({
	getAuthDetails: function (cmp, event, helper) {
      //  console.log('--------init---helper-----');
        //console.log('-------recordId--------'+cmp.get("v.recordId"));
        var action = cmp.get("c.getAuthorizeDetails");
        action.setParams({ recid: cmp.get("v.recordId") });
        action.setCallback(this, function (response) {
            var state = response.getState();
            console.log('sttae'+ state);
            if (state == "SUCCESS") {
                var data = response.getReturnValue();
                                
               // console.log('---------data------'+JSON.stringify(data));
                if (!$A.util.isUndefinedOrNull(data)) {
                    cmp.set('v.authorizeDetails', data);
                    console.log('check'+JSON.stringify(data));
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
    },



})