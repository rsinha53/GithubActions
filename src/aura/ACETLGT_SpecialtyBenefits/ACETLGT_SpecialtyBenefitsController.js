({
	selectChange : function(component, event, helper) {
        console.log('Toggled');
        component.set("v.isToggled", !component.get("v.isToggled"));
    }
})