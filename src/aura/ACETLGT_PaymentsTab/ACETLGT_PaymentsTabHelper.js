({
	openCheckImgWindow: function(component, event, helper, seriesDesginator, checkNumber) {
        //build action to open check image window - look at open cirrus link
        var action = component.get("c.getCheckImageUrl");
        var checkImageUrl;
        action.setParams({
            SeriesDesignator: seriesDesginator,
            CheckEFTNumber: checkNumber
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                checkImageUrl = response.getReturnValue();
                window.open(checkImageUrl, '_blank', 'toolbars=0, width=1333, height=706 ,left=0 ,top=0 ,scrollbars=1 ,resizable=1');
            }
        });
        $A.enqueueAction(action);
    }
})