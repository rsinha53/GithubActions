({
	getCategories : function(component, helper) {
        component.set("v.showSpinner", true);
        var hlgtInfo = component.get("v.highlightPanel");
        var subjectDOB = '';
        var originatorDOB = '';
        var originatorRel='';
        if(hlgtInfo != undefined){
            originatorDOB = hlgtInfo.originatorDOB;
            originatorRel = (hlgtInfo.originatorRel)?hlgtInfo.originatorRel:'';
            if(hlgtInfo.MemberDOB != null && hlgtInfo.MemberDOB != undefined) {
                subjectDOB = hlgtInfo.MemberDOB.split(' ')[0];
            }
        }
        console.log('>>>subj'+subjectDOB+'>>>org'+originatorDOB);
		var action = component.get("c.getHipaaCategories");
        action.setParams({ 
            interactionId : component.get("v.interactionId"),
            subDOB : subjectDOB,
            orgDOB : originatorDOB,
            orgRel : originatorRel
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log(response.getReturnValue());
                component.set("v.categories", response.getReturnValue());
            }
            else if (state === "INCOMPLETE") {
                // do something
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                    errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
            component.set("v.showSpinner", false);
        });
        
        $A.enqueueAction(action);
	}
})