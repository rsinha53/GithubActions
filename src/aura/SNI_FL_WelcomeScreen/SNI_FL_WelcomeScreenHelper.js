({
	removeModal : function(component, event, helper) {
		component.set('v.visible', false);
        var homePageGreyOut = document.getElementsByClassName("SNI_FL_HomeId"); 
        for (var i=0; i<homePageGreyOut.length; i++) {
            $A.util.removeClass(homePageGreyOut[i], 'SNI_FL_HomeGreyOut');
        }
	}
})