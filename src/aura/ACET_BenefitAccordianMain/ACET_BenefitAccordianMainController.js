({   
    onInit : function(component, event, helper) {
    },

    chevToggle : function(component, event, helper) {
        var iconName = component.find("chevInactive").get("v.iconName");
        
        if(iconName === "utility:chevrondown"){
            component.set("v.icon", "utility:chevronright");
            component.set("v.toggleName", "slds-hide");
            
        }else{
            component.set("v.icon", "utility:chevrondown");
            component.set("v.toggleName", "slds-show");
        }
    },
})