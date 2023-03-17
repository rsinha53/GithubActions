({
	doInit : function(component, event, helper) {
        var recordId = component.get('v.recordId');
        component.set("v.RecId",recordId);
        var userId = $A.get("$SObjectType.CurrentUser.Id");
        component.set("v.LoggedUserId",userId);
        
        helper.getMessageRequestQueueData(component, event, helper);
	}
})