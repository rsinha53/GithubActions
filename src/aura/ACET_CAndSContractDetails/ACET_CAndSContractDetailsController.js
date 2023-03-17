// US2186401 - Thanish - 23rd Dec 2019
({
	// Purpose - To initiate autodoc when contract data changes.
	onInit : function(cmp) {
		setTimeout(function () {
            window.lgtAutodoc.initAutodoc(cmp.get("v.AutodocKey"));
        }, 1);
	},

	// Purpose - To show or hide hover popup depending on its current state.
	togglePopup : function(cmp, event) {
		let showPopup = event.currentTarget.getAttribute("data-popupId");
		cmp.find(showPopup).toggleVisibility();
	},

	// US2263567 - Thanish - 29th Jan 2020
    closeContractDetails : function(cmp) {
		let parent = cmp.get("v.parent");
		if(!$A.util.isEmpty(parent)) {
			parent.removeContractDetail(cmp.get("v.id"), "cns");
		}
    }
})