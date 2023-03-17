({
	doInit : function(component, event, helper) {
		helper.getORSFollowups(component, event, helper);
	},
    dueDateFlagButton: function(component, event, helper) {
        component.set("v.isdueDateTextBoxVisible", true);
    },
    closeAdvocateActionBoxButton : function(component, event, helper) {
        component.set("v.isdueDateTextBoxVisible", false);
    },
    handleMouseOver : function(component, event, helper){
        // to show the mouse hover
        component.set("v.hoverRow", parseInt(event.target.dataset.index));
    },
    handleMouseOut : function(component, event, helper){
        // to hide the mouse hover
        component.set("v.hoverRow",-1);
    }
})