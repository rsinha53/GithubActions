({
	handleSectionToggle : function(cmp, event, helper) {
        var openSections = event.getParam('openSections');
        if (openSections.length > 0) {
            cmp.set('v.RequiredInfo.isCBInfoOpen', true);
        
        }
	}
})