({
    getORSFollowups : function(component, event, helper){
        var action = component.get("c.getFollowUps");
        var memberId = component.get("v.decodedMemberId");
        var officeId = component.get("v.officeId");
        var logonId = component.get("v.logonId");
       // memberId = '474706605',officeId='673',logonId='JR2';
        action.setParams({ memberId : memberId,
                          officeId : officeId,
                          logonId : logonId}); 
        action.setCallback(this, function(response) {
            var state = response.getState();       
            if (state === "SUCCESS") {
                var wrapper = response.getReturnValue(); 
               if(wrapper != null && !$A.util.isEmpty(wrapper) && !$A.util.isUndefined(wrapper)){
                    console.log('ors commitments response'+JSON.stringify(wrapper));
                    if(!$A.util.isEmpty(wrapper.systemErrorMsg)){
                        component.set('v.systemErrMsg',wrapper.systemErrorMsg);
                    }else{
                    component.set('v.followupsTwlvMnthRlngDataAvlbl', wrapper.tweleveMonthDataAvailable);
                    component.set('v.commitmentsDetails',wrapper.commitments);
                    }
                }
            }
        });
        $A.enqueueAction(action);  
        
    }
})