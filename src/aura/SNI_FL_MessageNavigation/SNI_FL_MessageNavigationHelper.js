({
	//******DE417471 Updated by Sameera ACDC***** */
	getAccountNameByID : function(component,event,AccID) {

		var action = component.get("c.getAccountNameByID");
        action.setParams({
             "accountID": AccID
        });
        action.setCallback(this, function (response) {

            var state = response.getState();
			var result = response.getReturnValue();
			
            if (state === "SUCCESS") {

                
                component.set('v.accountName', result.AccName);
                component.set('v.accOwner', result.AccOwner);
                var a = component.get('c.OpenNewTab');
                $A.enqueueAction(a);
            }
            else {
                console.log("Failed with state: " + state);
                $A.get('e.force:closeQuickAction').fire();                   					
            }
        });
        $A.enqueueAction(action);
	}
})