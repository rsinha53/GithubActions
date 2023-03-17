({
    handleUnAuthMsg : function(component, event, helper) {
        var unAuthorizedMsg = event.getParam("unAuthorizedMsg");
        var mediClaimDetails = event.getParam("mediClaimDetails");
        component.set("v.unAuthorizedMsg", unAuthorizedMsg);
        component.set("v.mediClaimDetails", mediClaimDetails);
        component.set("v.isChartVisible", true);
        component.set("v.showSpinner", false);
    },
    
    handleMouseOver : function(component, event, helper){
        component.set("v.togglehover",true);
    },
    
    handleMouseOut : function(component, event, helper){
        component.set("v.togglehover",false);
    },
    
    openProviderSearch: function (component, event, helper) {
        acetDashboardRedirectToIsetPage('providerSearchAndDetailsPage');
    }
})