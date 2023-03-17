({
	doInit : function(component, event, helper) {
        // For getting authorization details
        helper.getAuthorizationDetails(component, event, helper);
	},    
     openAuthNumberUrl: function (component, event, helper) {
        // to navigate to Notification tab in ISET
		acetDashboardRedirectToIsetPage('notificationsPage');
    },  
    authNumberUrl: function (component, event, helper) {
        var htmlcmp = event.currentTarget;
        var authNumber = htmlcmp.getAttribute("data-authNumber");
        console.log('ACET Dashboard: '+authNumber);
        // to navigate to Navigate tab from ISET and view selected Authorization
        acetDashboardOnAuthorizationSelection(authNumber);
    },
    dispAdvoActionBox: function (component, event, helper) {
        component.set("v.openModal",true);
    }
})