({ 

checkResearch : function(component,event,helper){
        
        var action = component.get("c.getUser");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
            	var storeResponse = response.getReturnValue();
                component.set("v.userInfo", storeResponse);
                var userProfileName = component.get("v.userInfo").Profile_Name__c;
                if (userProfileName == $A.get("$Label.c.ETSBE_ResearchUserProfile")){           
                   component.set("v.isResearchUser", "true");
                   component.set("v.disbutton", true); 
                }
            }
        });
        $A.enqueueAction(action);
    }  
})