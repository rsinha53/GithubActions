({
	doInit : function(component, event, helper) {
		var action = component.get('c.CaseRecordsData');
        action.setCallback(this, function (actionResult) {
            var state = actionResult.getState();
            console.log('Hstate--'+state);
            if (state === "SUCCESS") {
                var successData = actionResult.getReturnValue();
                console.log('casesuccessData--'+JSON.stringify(successData));
                console.log('casesuccessData--'+successData.length);
                component.set("v.Caselist",successData);
                component.set("v.CaseCount",successData.length);
                component.set("v.displayTable",true);
                if(successData.length == 0){
                    component.set("v.displayError",true);
                }
                
            }
        });
        $A.enqueueAction(action);
        
        component.set("v.sortField", 'CreatedDate');
	},
    
    sortBySLA : function(component, event, helper) {
        helper.sortBy(component, "CreatedDate");
    },
})