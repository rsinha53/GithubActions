({
    doInit : function(component, event, helper) {
        helper.showSpinner(component, event);
        var caseRecId = component.get("v.recordId");
        var action = component.get("c.getCaseRecord");
        action.setParams({
            "caseId":caseRecId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS"){
                var result = response.getReturnValue();
                component.set("v.caseWrap",result);
                if(result.hasCaseClonedEarlier===true){
                    helper.closePopUpWindow(component, event);
                    helper.showToast(component, event,'Cloned Case','warning', 'Record Has Already Cloned');
                }
                helper.hideSpinner(component, event);
            }
            else{
                helper.hideSpinner(component, event);
            }
        });
        $A.enqueueAction(action);
    },
    closePopup: function(component, event, helper){
        helper.closePopUpWindow(component, event);
    },
    cloneWithNewIntId: function(component, event, helper){
        component.set("v.caseWrap.cloneInteraction",true);
        helper.cloneCase(component, event);
    },
    cloneWithOldIntId: function(component, event, helper){
        component.set("v.caseWrap.cloneInteraction",false);
        helper.cloneCase(component, event);
    },
})