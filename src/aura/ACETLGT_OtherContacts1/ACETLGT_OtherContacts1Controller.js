({
	init: function (cmp, event, helper) {
        
	},
    handleSetActiveSection: function (cmp, event, helper) {
           var activeSectionName = cmp.find("OtherContactsSec").get('v.activeSectionName');
        if(!$A.util.isEmpty(activeSectionName)){
            var tabKey = 'OtherContactsSec'+cmp.get("v.AutodocKey");
                    window.lgtAutodoc.initAutodoc(tabKey);
        }

    }
})