({
   showToast: function(component, event, title,type,message ){
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": title,
            "type": type,
            "message": message
        });
        toastEvent.fire();
    },
    closePopUpWindow: function(component, event){
        $A.get("e.force:closeQuickAction").fire();
    }
})