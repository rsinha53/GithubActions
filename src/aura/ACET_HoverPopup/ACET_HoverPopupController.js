({
    onInit : function(cmp) {
        let today = new Date();
        cmp.set("v.popupUniqueId", today.getTime());
    },
    
	toggleVisibility : function(cmp) {
		let popupId = cmp.get("v.popupUniqueId");
		// move popup upwards according to its height
        let popupSectionMargin = document.getElementById(popupId + 'popup').offsetHeight + 10;
		document.getElementById(popupId + "popupSection").style.marginTop = "-" + popupSectionMargin + "px"; 

		// toggle popup visibility
		if(document.getElementById(popupId + "popupRegion").style.visibility == 'hidden'){
			document.getElementById( popupId + "popupRegion").style.visibility = 'visible';
		} else {
			document.getElementById(popupId + "popupRegion").style.visibility = 'hidden';
		}
	},

	onRender : function(cmp) {
		let popupId = cmp.get("v.popupUniqueId");
		// hide the popup after rendering
		document.getElementById(popupId + "popupRegion").style.visibility = "hidden";
	}
})