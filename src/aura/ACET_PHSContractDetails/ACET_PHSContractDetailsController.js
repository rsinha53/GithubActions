// US2186401 - Thanish - 26th Dec 2019
({
	// Purpose - To show or hide hover popup depending on its current state.
	togglePopup : function(cmp, event) {
		let showPopup = event.currentTarget.getAttribute("data-popupId");
		cmp.find(showPopup).toggleVisibility();
	},
    closeClaimDetail: function(component,event,helper){
		component.set("v.closeClaimDetails",false);
    }
})