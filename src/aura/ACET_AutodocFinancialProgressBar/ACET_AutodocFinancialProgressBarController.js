({
	togglePopup : function(cmp, event) {
		let showPopup = event.currentTarget.getAttribute("data-popupId");
		cmp.find(showPopup).toggleVisibility();
	}
})