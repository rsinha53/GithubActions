({
    handleCancel : function(component, event, helper) {
        //closes the modal or popover from the component
        var appEvent = $A.get("e.c:ERM_OverlayLibraryModalEvent");
        appEvent.setParams({
            "message" : "Cancel" });
        appEvent.fire();
        component.find("overlayLib").notifyClose();
    },
    handleOK : function(component, event, helper) {
         var appEvent = $A.get("e.c:ERM_OverlayLibraryModalEvent");
        appEvent.setParams({
            "message" : "Ok" });
        appEvent.fire();
        component.find("overlayLib").notifyClose();
    }
})