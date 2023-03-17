({
   getLastCallDate : function(component, event, helper){
        var action = component.get("c.getSelectIssues");
        var memberId = component.get("v.decodedMemberId");
        var officeId = component.get("v.officeId");
        var logonId = component.get("v.logonId");
        action.setParams({ memberId : memberId,
                          officeId : officeId,
                          logonId : logonId}); 
        action.setCallback(this, function(response) {
            var state = response.getState();       
            if (state === "SUCCESS") {
                var selectIssueDetails = response.getReturnValue(); 
                
                if(selectIssueDetails != null && selectIssueDetails.length > 0){
                    for(var i in selectIssueDetails){
                        if((i == 0) && (!$A.util.isEmpty(selectIssueDetails[i])) && (!$A.util.isUndefined(selectIssueDetails[i]))){
                            var originatedDate = selectIssueDetails[i];
                            component.set("v.originatedDate", originatedDate);
                        }
                        
                        if((i == 1) && (!$A.util.isEmpty(selectIssueDetails[i])) && (!$A.util.isUndefined(selectIssueDetails[i]))){
                            var contactReasonDescription = selectIssueDetails[i];
                            component.set("v.contactReasonDescription", contactReasonDescription);
                        }
                        
                        if((i == 2) && (!$A.util.isEmpty(selectIssueDetails[i])) && (!$A.util.isUndefined(selectIssueDetails[i]))){
                            var issueId = selectIssueDetails[i];
                            this.getLastCallDetails(component, issueId);
                        }
                    }  
                }
            }
			component.set('v.showSpinner',false);									 
        });
        $A.enqueueAction(action);  
        
    },
    
    getLastCallDetails : function(component, issueId){
        
        var action = component.get("c.getReadIssueDetails");
        var memberId = component.get("v.decodedMemberId");
        var officeId = component.get("v.officeId");
        var logonId = component.get("v.logonId");
        action.setParams({ memberId : memberId,
                          issueId : issueId,
                          officeId : officeId,
                          logonId : logonId}); 
        action.setCallback(this, function(response) {
            var state = response.getState();       
            if (state === "SUCCESS") {
                var lastCallCategory = response.getReturnValue(); 
                if((!$A.util.isEmpty(lastCallCategory)) && !$A.util.isUndefined(lastCallCategory)){
                    component.set("v.reasonCategory", lastCallCategory); 
                }
            }
        });
        $A.enqueueAction(action);  
    }
})