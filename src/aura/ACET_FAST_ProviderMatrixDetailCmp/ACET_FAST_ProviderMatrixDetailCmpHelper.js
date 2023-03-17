({
    openPopOver: function(component, event){
        component.set("v.openPopUp",true);
    },
    closePopUp: function(component, event){
        component.set("v.openPopUp",false);
    },
    showSpinner: function(component, event){
        var spinner = component.find("dropdown-spinner");
        $A.util.removeClass(spinner, "slds-hide");
    },
    hideSpinner: function(component, event){
        var spinner = component.find("dropdown-spinner");
        $A.util.addClass(spinner, "slds-hide");
    },
    showToast : function(component, event, title, type, message){
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": title,
            "type": type,
            "message": message,
        });
        toastEvent.fire();
    },
})