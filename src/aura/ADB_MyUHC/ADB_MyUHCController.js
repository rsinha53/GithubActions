({
    onInit : function(component, event, helper) {
        var isIntegrationUser = component.get("v.isIntegrationUser");
        if(isIntegrationUser){
            helper.myUhcServiceDetails(component, event, helper);
        }
    },
    
    doInit : function(component, event, helper) {
        var isIntegrationUser = component.get("v.isIntegrationUser");
        if(! isIntegrationUser){
            helper.myUhcServiceDetails(component, event, helper);
        }
    },
    flagButton: function(component, event, helper) {
        component.set("v.openMyUhcPopup", true);
    },
    
    closeAdvocateActionBoxButton : function(component, event, helper) {
        component.set("v.openMyUhcPopup", false);
    },
    
    //Get Advocate Action Text Box Hover
    handleMouseOverTextBox : function(component, event, helper){
        component.set("v.togglehovertextbox",true);
    },
    
    //Remove Advocate Action Text Box Hover
    handleMouseOutTextBox : function(component, event, helper){
        component.set("v.togglehovertextbox",false);
    }
})