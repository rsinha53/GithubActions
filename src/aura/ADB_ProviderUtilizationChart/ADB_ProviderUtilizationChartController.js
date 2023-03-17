({
    onInit: function(component, event, helper){
        helper.getProviderUtilizationChart(component, event, helper);
    },
    
    scriptsLoaded: function(component, event, helper) {
        helper.loadChart(component, event, helper);
    },
    
    handleMouseOverTopic : function(component, event, helper){
        component.set("v.togglehovertopic",true);
    },
    
    handleMouseOutTopic : function(component, event, helper){
        component.set("v.togglehovertopic",false);
    },
    
    clickFlag : function (component, event, helper) {
        component.set("v.openFlagModal",true);
    },
    
    closeAdvocateActionBoxButton : function(component, event, helper) {
        component.set("v.openFlagModal", false);
    },
    
    closePUChartWindow : function(component, event, helper) {
        component.set("v.openPUChartWindow", false);
    },
    
    handleMouseOverFlag : function(component, event, helper){
        component.set("v.togglehoverFlag",true);
    },
    
    handleMouseOutFlag : function(component, event, helper){
        component.set("v.togglehoverFlag",false);
    }
})