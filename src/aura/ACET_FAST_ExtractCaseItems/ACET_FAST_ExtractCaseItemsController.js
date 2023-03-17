({
    getCaseWrapper: function(component, event, helper) {
        helper.showSpinner(component,event);
        var caseRecId = component.get("v.recordId");
        var action = component.get("c.getRelatedCaseItemCount");
        action.setParams({ "caseID" : caseRecId});
        action.setCallback(this, function(response){
            var state = response.getState();
            console.log('state==>'+state);
            if(state === "SUCCESS"){
                var result = response.getReturnValue();
                if(result.caseItemCount==0){
                    helper.showToast(component, event,'No Case Items','warning', 'There are no Case Items assigned to the Case');
                    helper.closePopUpWindow(component, event); 
                    helper.hideSpinner(component,event);
                }else{
                    component.set("v.cWrap",result);
                    helper.hideSpinner(component,event);
                }
            }else{
                helper.showToast(component, event,'Error','error', state);
                helper.hideSpinner(component,event);   
            }
        });
        $A.enqueueAction(action);
    },
    generateReport: function(component, event, helper){
      	helper.attachCaseItems(component, event, helper);
    },
    closePopUp: function(component, event, helper){
        helper.closePopUpWindow(component, event);
    }
})