({
    doInit : function(component, event, helper) {
        var action = component.get("c.checkUserEditPermission");
        
        action.setCallback(this, function(response){
            var stateResponse = response.getState();
            if(stateResponse == 'SUCCESS') {
                var result = response.getReturnValue();
                if(result != '' && result){
                   component.set("v.canEdit",result);
                }
            }
        });
        $A.enqueueAction(action);
        
       var actionGetPrgAssociat = component.get("c.fetchExistProgAssociations");
        actionGetPrgAssociat.setParams({
             "membId": component.get("v.recordId")
            
        });
        actionGetPrgAssociat.setCallback(this, function(response) {
             var state = response.getState();
             if (state === "SUCCESS") {
                var optionsList = [];
                var retVal = response.getReturnValue();
                for (var temp in retVal) {
                     optionsList.push(retVal[temp]);
                }
                component.set("v.selectedLookUpRecords",optionsList);
            }
        });
       $A.enqueueAction(actionGetPrgAssociat);
	},
	myAction : function(component, event, helper) {
		//selectedLookUpRecords, get already selected items..
	},
    onClickOfEnter : function(component,event, helper) {

    },
    saveProgAssociation : function(component,event, helper) {
        var actionSavePrgAssoc = component.get("c.saveProgAssociations");
        actionSavePrgAssoc.setParams({
             "membId": component.get("v.recordId"),
             "selectedPrgAssc": component.get("v.selectedLookUpRecords"),
        });
        actionSavePrgAssoc.setCallback(this, function(response) {
             var state = response.getState();
            if (state === "SUCCESS") {
                helper.fireToastMessage("Success!",'Program Association(s) saved Successfully', "Success", "dismissible", "10000");
            }

        });
       $A.enqueueAction(actionSavePrgAssoc);
    }
})