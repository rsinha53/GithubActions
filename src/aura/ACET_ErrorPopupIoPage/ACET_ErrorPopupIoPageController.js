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
        $A.util.addClass(cmp.find("errorIcon"), "errorIconShadow");
		let popupId = cmp.get("v.popupUniqueId");
        let cardNo = cmp.get("v.cardNo");
		// move popup upwards according to its height
        let popupSectionMargin = document.getElementById(popupId + 'popupSection').offsetHeight + 10;
        //let popupSectionMargin = document.getElementById('snagPopupRegionError' + cardNo).offsetHeight + 10;
		document.getElementById(popupId + "popupSection").style.marginTop = "-" + popupSectionMargin + "px"; 
		// show popup
		document.getElementById( popupId + "popupRegion").style.visibility = 'visible';

		// add error icon shadow
		
	},

	hidePopup : function(cmp) {
        $A.util.removeClass(cmp.find("errorIcon"), "errorIconShadow");
		let popupId = cmp.get("v.popupUniqueId");
        let cardNo = cmp.get("v.cardNo");
		// move popup upwards according to its height
        let popupSectionMargin = document.getElementById(popupId + 'popupSection').offsetHeight + 10;
        //let popupSectionMargin = document.getElementById('snagPopupRegionError' + cardNo).offsetHeight + 10;
		document.getElementById(popupId + "popupSection").style.marginTop = "-" + popupSectionMargin + "px"; 
		// show popup
		document.getElementById( popupId + "popupRegion").style.visibility = 'hidden';

		// remove error icon shadow
		
	},
    
    showHidePopUpHandler : function(cmp, event, helper) {
        var cardNo = cmp.get("v.cardNo");
        var cardNoError = cmp.get("v.cardNumberError");
        if(cardNo === cardNoError){
            if(cmp.get("v.showHidePopUp")){
                $A.util.addClass(cmp.find("errorIcon"), "errorIconShadow");
                var showPopup = cmp.get('c.showPopup');
                $A.enqueueAction(showPopup);
            }else{
                var hidePopup = cmp.get('c.hidePopup');
                $A.enqueueAction(hidePopup);
            }
        }
        
		
	},

	onRender : function(cmp) {
		let popupId = cmp.get("v.popupUniqueId");
		// hide the popup after rendering
        var showHidePopUpHandler = cmp.get('c.showHidePopUpHandler');
        $A.enqueueAction(showHidePopUpHandler);
        cmp.set("v.showHidePopUpTr",true);
	}
})