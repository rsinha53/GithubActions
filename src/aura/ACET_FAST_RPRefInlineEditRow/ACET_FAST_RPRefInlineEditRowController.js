({
    retrieveList : function(component, event, helper) {
        helper.getReferenceRecords(component,event);
    },
    onEdit: function(component, event, helper){
        var editRecordEvent = $A.get("e.force:editRecord");
        editRecordEvent.setParams({
            "recordId": component.get("v.singleRec.RefId")
        });
        editRecordEvent.fire();
    },
    onView: function(component, event, helper){
        var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
            "recordId": component.get("v.singleRec.RefId"),
            "slideDevName": "Detail"
        });
        navEvt.fire();
    },
})