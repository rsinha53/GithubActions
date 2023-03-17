({
    showSuccess : function(component, event, helper) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title : 'Success',
            message: 'Associated Case Added successfully!',
            duration:' 5000',
            key: 'info_alt',
            type: 'success',
            mode: 'pester'
        });
        toastEvent.fire();
        window.location.reload(); // this line added by Ravi teja 
    },
    showError : function(component, event, helper) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title : 'Error',
            message:'Error occured. Please try again.',
            duration:' 5000',
            key: 'info_alt',
            type: 'error',
            mode: 'pester'
        });
        toastEvent.fire();
    },
    deleteRecord : function(component, event) {
        component.set("v.isLoading", true);
        var CaseRecd = event.getParam('row'); 
        
        var action = component.get("c.delCase");
        action.setParams({
            "AssosiateCaseId": CaseRecd.AssosiateCaseId
        });
        action.setCallback(this, function(response) {
            component.set("v.isLoading", false);            
            if (response.getState() === "SUCCESS" ) {
                
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title : 'Success',
                    message: 'The record has been delete successfully!',
                    duration:' 5000',
                    key: 'info_alt',
                    type: 'success',
                    mode: 'pester'
                });
                toastEvent.fire();
                window.location.reload();
            }
            else{
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title : 'Error',
                    message:JSON.stringify(response.getError()),
                    duration:' 5000',
                    key: 'info_alt',
                    type: 'error',
                    mode: 'pester'
                });
                toastEvent.fire();
            }
        });
        $A.enqueueAction(action);        
    }
});