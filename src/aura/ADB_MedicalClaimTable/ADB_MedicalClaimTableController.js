({
    onInit: function(component, event, helper){
        helper.getMedicalClaims(component, event, helper);
    },
    
    openMedicalClaims : function (component, event, helper) {
		acetDashboardRedirectToIsetPage('claimsSearchAndDetailsPage');  
    }
})