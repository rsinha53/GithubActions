({
	helperInitMethod : function(component, event, helper) {
		 var userId = $A.get("$SObjectType.CurrentUser.Id");
		console.log(userId);
        component.set("v.currentUser",userId);
        var action = component.get("c.getdocuments");
        action.setParams({
            familyaccId: component.get("v.familyId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state == "SUCCESS") {
                var result = response.getReturnValue();
                component.set("v.familydocwrap",result);
            }else{
                  var urlEvent = $A.get("e.force:navigateToURL");
                  urlEvent.setParams({
                    url: "/error"
                  });
                  urlEvent.fire();
            }
        });
        $A.enqueueAction(action);
	}
})