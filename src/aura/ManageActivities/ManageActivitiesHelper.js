({
	getAccountDetailsHelper: function(component, event, helper, acctId){
        var action = component.get("c.getAccountDetails");
        action.setParams({
            "acctId": acctId
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
				console.log("SUCCESS");
                var responseData = response.getReturnValue();
                window.open($A.get("$Label.c.LeaguePortal")+'?familyId='+ responseData.memberId,'_blank');
                helper.closeTab(component, event, helper);
            }else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "title": "Error",
                            "message": errors[0].message,
                            "type": "error",
                            "duration": "3000"
                        });
                        toastEvent.fire();
                        helper.closeTab(component, event, helper);
                    }
                } 
            }
            
        });
        $A.enqueueAction(action);
    }, 
    
    closeTab: function(component, event, helper){
        try{
            var workspaceAPI = component.find("workspace");
            workspaceAPI.getFocusedTabInfo().then(function(response) {
                var focusedTabId = response.tabId;
                workspaceAPI.closeTab({tabId: focusedTabId});
                window.history.back();
            })
            .catch(function(error) {
                console.log(error);
            });
        }catch(exception){
            console.log(exception);
        }
    }

})