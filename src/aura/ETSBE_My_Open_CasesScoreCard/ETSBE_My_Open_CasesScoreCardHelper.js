({
	hideSpinner: function(component, event, helper) {
        component.set("v.Spinner", false);
    },

    showSpinner: function(component, event, helper) {
        component.set("v.Spinner", true);
    },
})