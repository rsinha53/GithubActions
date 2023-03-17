({
	handleClick : function(cmp, event, helper) {
        var toggleCmp = cmp.find("errorMsgId");
        $A.util.toggleClass(toggleCmp, "slds-fall-into-ground");
	},
    
    handleClose : function(cmp, event, helper) {
        debugger;
        var toggleCmp = cmp.find("errorMsgId");
        $A.util.toggleClass(toggleCmp, "slds-rise-from-ground");
    }
})