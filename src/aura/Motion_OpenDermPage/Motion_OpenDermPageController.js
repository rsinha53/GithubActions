({
	doInit: function(component,event,helper) {
    if (component.get("v.pageReference") != null){  
            var state = component.get("v.pageReference").state;
            var isCsMbr = state.c__isCaseMember;
            var regmbrId=state.c__registeredMemberId;
			var elgmbrId = state.c__eligibleMemberId;									  
        	var originatortype = state.c__originatorType;
        if((isCsMbr) &&((elgmbrId==null || elgmbrId=='')&& (regmbrId==null || regmbrId==''))){
        	component.set("v.errorMessage", $A.get("$Label.c.Motion_Individual_Error_Message"));
            component.set("v.showpopup",true);               
        }else if((isCsMbr) && (regmbrId==null || regmbrId=='')){
            component.set("v.errorMessage", $A.get("$Label.c.Motion_Derm_Member_Error_Message"));
           component.set("v.showpopup",true);
        }else {
           
            component.set("v.showpopup",false);                
            var action = component.get("c.getDermURL");
       		action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var homePageNewslabel = response.getReturnValue();
                homePageNewslabel = homePageNewslabel+'?memberID='+regmbrId;
                window.open(homePageNewslabel);
                component.set("v.errorMessage", "DERM Page launched Successfully");
           		component.set("v.showpopup",true);
            }
            else {
                console.log("Failed with state: " + state);
            }
        });
        $A.enqueueAction(action);	
        }
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