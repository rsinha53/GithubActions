({
    
    doInit : function(component, event, helper) {
		
        var spinner = component.find("dropdown-spinner");
        $A.util.removeClass(spinner, "slds-hide");
        
        var action = component.get("c.getUser");               
        action.setCallback(this, function(response) {    
            var state = response.getState();            
            if (state === "SUCCESS") {
                var userResponseData = response.getReturnValue();  
                if(userResponseData != undefined && userResponseData != null) {
                    var userRolesAccessible = ["System Administrator","BEO Child Case","BEO Claims Complex","BEO Dedicated Eligibility"];
                    if(userRolesAccessible.includes(userResponseData.Role_Name__c)) {
                        helper.getCaseData(component, event, helper);                       
                    } else {
                        $A.get("e.force:closeQuickAction").fire();
                    	helper.fireToastMessage("Error!", "No Access to create a Child Case", "error", "dismissible", "10000");     
                    }
                }
            } 
            var spinner2 = component.find("dropdown-spinner");
            $A.util.addClass(spinner2, "slds-hide");
        });        
        $A.enqueueAction(action);        
	}
})