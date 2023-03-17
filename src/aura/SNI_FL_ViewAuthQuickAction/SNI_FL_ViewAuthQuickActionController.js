({
	doInit : function(component, event, helper) {
		var roiId = component.get("v.recordId");
        var isctm = false;
		var iframeurl ='/apex/Family_Link?recid='+roiId+'&isctm='+isctm;
        component.set("v.iframeurl", iframeurl);
	}
})