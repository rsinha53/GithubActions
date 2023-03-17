({
    doInit : function(component, event, helper) {
       console.log('fetchExistingEscGroups------');
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
        
       var actionGetEsvGrp = component.get("c.fetchExistingEscGroups");
        actionGetEsvGrp.setParams({
             "caseId": component.get("v.recordId")
            
        });
        actionGetEsvGrp.setCallback(this, function(response) {
             var state = response.getState();
             console.log('fetchExistingEscGroups--state-123---'+state);
             if (state === "SUCCESS") {
                console.log('fetchExistingEscGroups--response----'+response.getReturnValue());
                var optionsList = [];
                var retVal = response.getReturnValue();
                for (var temp in retVal) {
                     optionsList.push(retVal[temp]);
                }
                component.set("v.selectedLookUpRecords",optionsList);
            }
        });
       $A.enqueueAction(actionGetEsvGrp);
	},
	myAction : function(component, event, helper) {
		//selectedLookUpRecords, get already selected items..
	},
    onClickOfEnter : function(component,event, helper) {
        /*
        if (event.which == 13){
           
            console.log('hits :: '+component.find('GlobalAutocomplete').get("v.listOfSearchRecords"));
            if (component.find('GlobalAutocomplete').get("v.listOfSearchRecords") == null){
                
                var a = component.get('c.showDetails');
                $A.enqueueAction(a);
                
            }
            
        }
        */
    },
    saveEscalationGrp : function(component,event, helper) {
        var actionSaveEsvGrp = component.get("c.saveEscalationGrps");
        actionSaveEsvGrp.setParams({
             "caseId": component.get("v.recordId"),
            "selEscGrps": component.get("v.selectedLookUpRecords"),
        });
        actionSaveEsvGrp.setCallback(this, function(response) {
             var state = response.getState();
            console.log("saveEscalationGrp state----"+state);
            if (state === "SUCCESS") {
              // $A.get('e.force:refreshView').fire();
                helper.fireToastMessage("Success!",'Escalated Group(s) saved Successfully', "Success", "dismissible", "10000");
            }

        });
       $A.enqueueAction(actionSaveEsvGrp);
    }
})