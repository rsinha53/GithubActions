({
	doInit : function(component, event, helper) {
        helper.showECAASpinner(component);
        helper.getFocusedTabIdHelper(component, event);
        var pageReference = component.get("v.pageReference");
        var recId = pageReference.state.uid;
        var searchParam = pageReference.state.c__searchParam;
        var businessFlow = pageReference.state.c__businessFlow;
        var documentType = pageReference.state.c__documentType;
        component.set("v.recId", recId);
        component.set("v.searchParam", searchParam);
        component.set("v.businessFlow",businessFlow);
        component.set("v.documentType",documentType);
		var action = component.get("c.findICUELetter");
        action.setParams({srnNumber :searchParam,documentType: documentType });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state == "SUCCESS") {
                var data = response.getReturnValue();
                if (data.statusCode == 200) {
                    if (!($A.util.isUndefinedOrNull(data))) {
                    component.set('v.letterDetails', data.resultWrapper.icueletterResLst); 
                    component.set('v.indexName', data.indexName); 
                    }
                    helper.hideECAASpinner(component);
                    helper.fireToastMessage("Error!", data.message, "error", "dismissible", "10000");
                } else {
                    helper.hideECAASpinner(component);
                    helper.fireToastMessage("Error!", data.message, "error", "dismissible", "10000");
                }
            } else{
                helper.hideECAASpinner(component);
            }
        });
        $A.enqueueAction(action);
	}
})