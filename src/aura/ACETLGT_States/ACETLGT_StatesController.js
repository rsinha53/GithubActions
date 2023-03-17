({
	doInit : function(component, event, helper) {
        
        component.set("v.showError", true);
        var statecmp = component.find("selstate");

        console.log('tess::'+statecmp);
        //$A.util.addClass(statecmp, "slds-has-error");
		
	}
})