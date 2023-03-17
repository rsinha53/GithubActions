({
    doInit: function(component, event, helper) {
        helper.createObjectData(component, event);
    },
    Save: function(component, event, helper) {
        if (helper.validateRequired(component, event)) {
            var recId=component.get("v.recordId");
            var action = component.get("c.savePIRRPReference");
            var lstPIRRefs = component.get("v.lstPIRRPRefs");
            //alert(JSON.stringify(component.get("v.lstPIRRPRefs")));//PIR_Resolution_Partner__c
            action.setParams({
                "lstPIRRPRefs": component.get("v.lstPIRRPRefs")
            });
            // set call back 
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        title : 'Success',
                        message: 'References saved successfully',
                        duration:' 3000',
                        key: 'info_alt',
                        type: 'success',
                        mode: 'pester'
                    });
                    toastEvent.fire();
                    $A.get("e.force:closeQuickAction").fire();
                    $A.get('e.force:refreshView').fire();
                    var appSaveEvent = $A.get("e.c:ACETLGT_PIRRPRefDynamicEvent");
                    appSaveEvent.setParams({
                        "message" : "Records Successfully Inserted"});
                    appSaveEvent.fire();
                }
            });
            $A.enqueueAction(action);
        }
    },
 
    // function for create new object Row in Contact List 
    addNewRow: function(component, event, helper) { 
        helper.createObjectData(component, event);
    },

    removeDeletedRow: function(component, event, helper) { 
        var index = event.getParam("indexVar");
        var AllRowsList = component.get("v.lstPIRRPRefs");
        AllRowsList.splice(index, 1); 
        component.set("v.lstPIRRPRefs", AllRowsList);
    }
})