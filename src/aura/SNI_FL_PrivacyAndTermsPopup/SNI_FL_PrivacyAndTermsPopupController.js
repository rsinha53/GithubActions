({
	doInit : function(component, event, helper) {
	},
    closePrivacyModel : function(component, event, helper) {
		component.set("v.displayPrivacyPolicy",false);
	},
    closeTermsModel : function(component, event, helper) {
        component.set("v.displayTerms",false);
    }
})