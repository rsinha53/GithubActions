({
    init : function(component, event, helper) {
        helper.showSpinner(component);
        var recordId = component.get("v.recordId");
        var action = component.get("c.reProcessCase");
        action.setParams({"caseId":recordId});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state === "SUCCESS"){
                helper.showToast(component, 'Success', 'success', 'Case Successfully Reprocessed');
            }else{
                helper.showToast(component, 'Error', 'error', 'There was an error while reprocessing the code please contact system adinistrator');
            }
            helper.closePopUpWindow(component);
            helper.hideSpinner(component);
        });
        $A.enqueueAction(action);
    }
})