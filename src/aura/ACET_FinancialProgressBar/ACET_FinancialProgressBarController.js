({
	togglePopup : function(cmp, event) {
		let showPopup = event.currentTarget.getAttribute("data-popupId");
		cmp.find(showPopup).toggleVisibility();
	},
    
    handleSelectCheckBox: function (cmp, event) {
        var financialCardDetails = cmp.get("v.financialCardDetails");
        _autodoc.setAutodoc(cmp.get("v.autodocUniqueId"),cmp.get("v.autodocUniqueIdCmp"), financialCardDetails);
    },
    // US3507751 - Save Case Consolidation
    handleAutodocRefresh: function (cmp, event, helper){
        if(event.getParam("autodocUniqueId") == cmp.get("v.autodocUniqueId")){
            cmp.set("v.headerChecked", false);
        }
    },
    
    doInit : function(cmp, event, helper) {

    }
})