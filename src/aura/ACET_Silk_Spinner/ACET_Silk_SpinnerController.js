({
	//Call by aura:waiting event  
    handleShowSpinner: function(component, event, helper) {
        component.set("v.showSpinner", true); 
    },
    //Call by aura:doneWaiting event 
    handleHideSpinner : function(component,event,helper){
        component.set("v.showSpinner", false);
    }
})