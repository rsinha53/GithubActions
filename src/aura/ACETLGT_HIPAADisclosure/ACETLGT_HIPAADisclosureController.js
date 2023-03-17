({
	doInit : function(component, event, helper) {
	},
    
    originatorChanged : function(component, event, helper) {
        //	calling helper and populate categories
        helper.getCategories(component, helper);
    },
    
    openHipaa : function(component, event, helper) {
        //	Get the One source URL from custom lables
        var oneSourceURL = $A.get("$Label.c.ACETLGT_HIPAAOneSource");
        window.open(oneSourceURL, 'HIPPA One Source','width=600,height=400,resizable=yes,scrollbars=yes');
    }
})