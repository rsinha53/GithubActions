({
    // helper function: US2645901 - Sunil Vennam
    loadCommitmentsDetails : function(component, event, helper){
        console.log('calling api for Optum Followups');
        component.set("v.spinner", true);
        var xrefId = component.get("v.memberXrefId");
        console.log('optum followups'+xrefId);
       // var xrefId ="30944303";
        var action = component.get("c.fetchCommitmentsDetails");
        action.setParams({
            xrefId: xrefId
        });
        action.setCallback(this,function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                var results = response.getReturnValue();
                if(!$A.util.isEmpty(results) && !$A.util.isUndefined(results)){
                    console.log('results.tweleveMonthDataAvailable : ', results.tweleveMonthDataAvailable);
                    component.set("v.followupsTwlvMnthRlngDataAvlbl", results.tweleveMonthDataAvailable);
                    if(!$A.util.isEmpty(results.commitments) && !$A.util.isUndefined(results.commitments)){
                        console.log('results commitments', results.commitments);
                        component.set("v.commitmentsDetails", results.commitments);
                    }else{
                        component.set("v.noCommitments", true);
                    }
                }else{
                    component.set("v.noCommitments", true);
                }
            }else{
                component.set("v.noCommitments", true);
            }
            component.set("v.spinner", false);
        });
        $A.enqueueAction(action);
    },
})