// US1965220 - Thanish - 16th Jan 2020
({
    onInit : function(cmp) {
        let today = new Date();
        cmp.set("v.popupUniqueId", today.getTime());
    },
    
	toggleVisibility : function(cmp) {
		let popupId = cmp.get("v.popupUniqueId");
		// move popup upwards according to its height
        let popupSectionMargin = document.getElementById(popupId + 'popupSection').offsetHeight + 10;
		document.getElementById(popupId + "popupSection").style.marginTop = "-" + popupSectionMargin + "px"; 

		// toggle popup visibility
		if(document.getElementById(popupId + "popupRegion").style.visibility == 'hidden'){
			document.getElementById( popupId + "popupRegion").style.visibility = 'visible';
		} else {
			document.getElementById(popupId + "popupRegion").style.visibility = 'hidden';
		}

		// toggle error icon shadow
		$A.util.toggleClass(cmp.find("errorIcon"), "errorIconShadow");
	},

	showPopup : function(cmp) {
		let popupId = cmp.get("v.popupUniqueId");
		// move popup upwards according to its height
        let popupSectionMargin = document.getElementById(popupId + 'popupSection').offsetHeight + 10;
		document.getElementById(popupId + "popupSection").style.marginTop = "-" + popupSectionMargin + "px"; 
		// show popup
		document.getElementById( popupId + "popupRegion").style.visibility = 'visible';

		// add error icon shadow
		$A.util.addClass(cmp.find("errorIcon"), "errorIconShadow");
	},

	hidePopup : function(cmp) {
		let popupId = cmp.get("v.popupUniqueId");
		// move popup upwards according to its height
        let popupSectionMargin = document.getElementById(popupId + 'popupSection').offsetHeight + 10;
		document.getElementById(popupId + "popupSection").style.marginTop = "-" + popupSectionMargin + "px"; 
		// show popup
		document.getElementById( popupId + "popupRegion").style.visibility = 'hidden';

		// remove error icon shadow
		$A.util.removeClass(cmp.find("errorIcon"), "errorIconShadow");
	},

	onRender : function(cmp) {
		let popupId = cmp.get("v.popupUniqueId");
		// hide the popup after rendering
		document.getElementById(popupId + "popupRegion").style.visibility = "hidden";
	}
})