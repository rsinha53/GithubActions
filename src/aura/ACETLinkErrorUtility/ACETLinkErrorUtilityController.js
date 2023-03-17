({
    
	handleClick : function(cmp, event, helper) {
		/*$A.util.addClass(cmp.find("errorMsgId"), "slds-rise-from-ground");
        $A.util.removeClass(cmp.find("errorMsgId"), "slds-fall-into-ground"); */
        var toggleCmp = cmp.find("errorMsgId");
        $A.util.toggleClass(toggleCmp, "slds-fall-into-ground");
	},
    handleClose : function(cmp, event, helper) {
        debugger;
        var toggleCmp = cmp.find("errorMsgId");
        $A.util.toggleClass(toggleCmp, "slds-rise-from-ground");
    }
})