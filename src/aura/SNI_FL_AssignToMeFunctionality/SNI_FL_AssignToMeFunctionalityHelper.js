({
    getMessageRequestQueueData : function(component, event, helper) {
        var RecId = component.get('v.RecId');
        var UserId = component.get('v.LoggedUserId');
        var action = component.get("c.getMessageRequestQueueDetails"); 
        action.setParams({
            "messageReqId": RecId,
            "userId":UserId
        });
        action.setCallback(this,function(response){
           
            var state = response.getState();            
            if (state === "SUCCESS") {                
                console.log("Success: " + state);
                $A.get("e.force:closeQuickAction").fire();
                $A.get('e.force:refreshView').fire();
                
            }
            else {
                console.log("Failed with state: " + state);
            }   
        });
        
        
        $A.enqueueAction(action);
	}
})