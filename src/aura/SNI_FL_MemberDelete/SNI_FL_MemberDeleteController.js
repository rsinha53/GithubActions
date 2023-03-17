({
    handleConfirmDialog : function(component, event, helper) {
        component.set('v.showConfirmDialog', true);
    },
     
    handleConfirmDialogYes : function(component, event, helper) {
        console.log('Yes');
        var recId = component.get("v.recordId");
        var action = component.get("c.deletememberaffiliation");
        action.setParams({
            recId : recId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state === 'SUCCESS') {
                component.set('v.showConfirmDialog', false);
                window.location.href = "/lightning/o/Member_Affiliation__c/list?filterName=All";
                
            } else {     
            }
        });
        $A.enqueueAction(action);
        $A.get('e.force:refreshView').fire();
    },
     
    handleConfirmDialogNo : function(component, event, helper) {
        console.log('No');
        component.set('v.showConfirmDialog', false);
        $A.get("e.force:closeQuickAction").fire();
    },
})