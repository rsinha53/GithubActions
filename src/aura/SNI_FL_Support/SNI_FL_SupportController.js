({
    
    doInit : function(component, event, helper) {
        
        var action2 = component.get('c.HSIDmemUrls');
        action2.setCallback(this, function(response) {
            var state = response.getState();
            console.log('getAccountDetail----state---'+state);
            if (state == "SUCCESS") {
                console.log('>>>>>>is member or not<<<<<<<'+response.getReturnValue());
                component.set('v.displayHSIDmemSupportTab', response.getReturnValue());
            }
            
        });        
       
        $A.enqueueAction(action2);
    },
	openPrivacyPolicy : function(component, event, helper) {
       //window.open(window.location.href+"privacy-policy", '_blank');
       window.open($A.get("$Label.c.DigitalOnboarding_Privacy_Policy"), '_blank');
        //component.set("v.displayPrivacyPolicy",true);
	},
    openTerms : function(component, event, helper) {
		//window.open(window.location.href+"terms-of-use", '_blank');
		window.open($A.get("$Label.c.DigitalOnboarding_Terms_Of_Use"), '_blank');
        //component.set("v.displayTerms",true);
	},
    redirectToSettings : function(component, event, helper){
        let currentUser = $A.get("$SObjectType.CurrentUser.Id");
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": '/settings/'+currentUser 
        });
        urlEvent.fire(); 
    }
})