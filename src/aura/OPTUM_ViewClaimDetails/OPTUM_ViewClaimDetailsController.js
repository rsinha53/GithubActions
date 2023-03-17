({
    handleClaimEvent : function(component, event, helper) {
        console.log("ViewDetails" + event.getParam("data"));
        component.set("v.data", event.getParam("data"));
        helper.dateFormat(component , event ,helper);
		helper.setAutodocCardData(component, event, helper);
        helper.autoDenialHistory(component, event, helper);

    }
    
})