({
    doInit : function(component, event, helper) {
        var accId = component.get("v.recordId");
        var action = component.get("c.getAccountDetails");
        action.setParams({
            "accId":accId
        });
        console.log(accId);
        action.setCallback(this, function(response) {
            var state = response.getState();
            console.log('state'+state);
            if (state === "SUCCESS") {
                var showModal = component.get('v.showModal');
                component.set('v.showModal', !showModal);
                component.set("v.showModal",true);
                console.log("From server: " + response.getReturnValue());
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    component.set("v.showErrors",true);
                    component.set("v.errorMessage",errors[0].message);
                    console.log("Error message: " + 
                                errors[0].message);
                    var dismissActionPanel = $A.get("e.force:closeQuickAction");
                    dismissActionPanel.fire();
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Error!",
                        "message": errors[0].message,
                        type: 'error'
                    });
                    toastEvent.fire();
                } else {
                    console.log("Unknown error");
                }
            }
        });
        // Queue this action to send to the server
        $A.enqueueAction(action);
    },
    apexcall : function(component, event, helper) {
        var showSpinner = component.get('v.showSpinner');
        component.set('v.showSpinner', true);
        var hideModal = component.get('v.showModal');
        component.set('v.showModal', !hideModal);
        var accId = component.get("v.recordId");
        var action = component.get("c.sendSMSNotification");
        action.setParams({
            "accId":accId
        });
        var result;
        action.setCallback(this, function(response){
            var state = response.getState();
            var successMessage = $A.get("$Label.c.SMS_Successful_Message");
            var failureMessage = $A.get("$Label.c.SMS_Failure_Message");
            if(state == 'SUCCESS') {
                result = response.getReturnValue();
                if(result == 'Success'){
                    var dismissActionPanel = $A.get("e.force:closeQuickAction");
                    dismissActionPanel.fire();
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Success!",
                        "message": successMessage,
                        type: 'success'
                    });
                    toastEvent.fire();
                }else if(result == 'Failure'){
                    var dismissActionPanel = $A.get("e.force:closeQuickAction");
                    dismissActionPanel.fire();
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Error!",
                        "message": failureMessage,
                        type: 'error'
                    });
                    toastEvent.fire();
                }else {
                    var dismissActionPanel = $A.get("e.force:closeQuickAction");
                    dismissActionPanel.fire();
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Error!",
                        "message": failureMessage,
                        type: 'error'
                    });
                    toastEvent.fire();
                    console.log("Unknown error");
                }
                
            }else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    component.set("v.showErrors",true);
                    component.set("v.errorMessage",errors[0].message);
                    console.log("Error message: " + 
                                errors[0].message);
                    var dismissActionPanel = $A.get("e.force:closeQuickAction");
                    dismissActionPanel.fire();
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Error!",
                        "message": errors[0].message,
                        type: 'error'
                    });
                    toastEvent.fire();
                } else {
                    console.log("Unknown error");
                }
            }
            console.log('value>>'+result);
        });
        
        $A.enqueueAction(action);
    },
    
    closeQuickAction : function(component, event, helper) {
        var dismissActionPanel = $A.get("e.force:closeQuickAction");
        dismissActionPanel.fire();
    },
    
})