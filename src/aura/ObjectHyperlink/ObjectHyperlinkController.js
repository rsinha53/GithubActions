({
	navigateToSObject : function(component, event, helper) {
		var sObjId = component.get("v.sObjectId");          
        console.log('sObjId: ' + sObjId);
        var navToSObjEvt = $A.get("e.force:navigateToSObject");
        console.log('navToSObjEvt: ' + navToSObjEvt);
        navToSObjEvt.setParams({
            "recordId": sObjId,
            "slideDevName": "detail"
        });	
        navToSObjEvt.fire(); 
	}
})