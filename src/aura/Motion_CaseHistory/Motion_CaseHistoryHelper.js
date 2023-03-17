({
    fetchCaseHelper : function(component, event, helper) {
        var action = component.get("c.getCases");
        action.setParams({
            pageNumber : component.get("v.pageNumber"),
            pageSize : 5,
            eligibleMemberId : component.get("v.eligibleMemberId"),
            registeredMemberId : component.get("v.registeredMemberId"),
            isCheckboxDisabled : component.get("v.actionBtnFlag")
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                component.set("v.TableDetail", result);
                component.set("v.maxPageNumber", result.noOfPages);
                component.set("v.currentStartNumber", result.startNumber);
                component.set("v.currentEndNumber",result.endNumber);
            }
        });
        $A.enqueueAction(action);
    }
})