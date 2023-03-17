({
    retrieveList : function(component, event, helper) {
        helper.getReferenceRecords(component,event);
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