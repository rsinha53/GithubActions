({
	doInit: function(component,event,helper) {
    if (component.get("v.pageReference") != null){  
            var state = component.get("v.pageReference").state;
            var isCsMbr = state.c__isCaseMember;
            var regmbrId=state.c__registeredMemberId;
        	var originatortype = state.c__originatorType;
                       
            var action = component.get("c.getConsoleURL");
       		action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var homePageNewslabel = response.getReturnValue();
               
                window.open(homePageNewslabel);
                component.set("v.errorMessage", "Console Page launched Successfully");
           		component.set("v.showpopup",true);
            }
            else {
                console.log("Failed with state: " + state);
            }
        });
        $A.enqueueAction(action);	
        }
    
        
    },
    closeModel:function(component,event,helper){
        component.set("v.showpopup",false);
        var workspaceAPI = component.find("workspace");
        workspaceAPI.getEnclosingTabId().then(function(tabId) {
        	workspaceAPI.closeTab({
        	tabId: tabId
        	});
        });
	},
    
})