({
	getAlerts : function(component, event, helper) {
         helper.getAlertsFromObject(component); 
        
	},
    getAlertsOnSnapShots : function(component, event, helper) {
        
        helper.getAlertsOnShapShotpage(component);
       
    },
	 getAlertsOnclickPolicies : function(component, event, helper) {
        
        helper.getAlertOnClickPolicy(component,event);
       
    },
    //US2554307: View Authorizations Details Page - Add Alerts Button
    getAlertsOnAuthDetailsPage : function(component, event, helper) {

        helper.getAlertOnAuthDetailsPage(component,event);

    },

     getAlertsOnCreateReferralPage : function(component, event, helper) {

        helper.getAlertOnCreateReferralPage(component,event);

    },
     //US2876410 ketki 9/15:  Launch Claim Detail Page
    getAlertsOnClaimDetailsPage : function(component, event, helper) {
        helper.getAlertOnClaimDetailsPage(component,event);
    },
    openAlertPopUp : function(component, event, helper){
        var isInteractionPage = component.get("v.isInteractionPage");
        var isProviderSnapshot = component.get("v.isProviderSnapshot");
    	component.set("v.isMemberAlertModalOpen",true);
     
	},
    closeAlertsModal : function(component, event, helper){
       component.set("v.isMemberAlertModalOpen",false);
    },
    
    createInteraction: function(component,event,helper){
        helper.createInteractionAlertHelper(component,alert)
    },
    // US3480373: Service Request Detail Page Alignment - Krish - 5 May 2021 Start
    getAlertsOnServiceRequestDetail : function(component, event, helper){
        helper.getAlertsOnServiceRequestDetail(component);
    }
    
})