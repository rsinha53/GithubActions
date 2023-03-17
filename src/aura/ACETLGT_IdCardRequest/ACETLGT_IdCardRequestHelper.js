({    
    
    hideSpinner2: function(component, event, helper) {        
        component.set("v.Spinner", false);
        console.log('Hide');
    },
    
    // this function automatic call by aura:waiting event  
    showSpinner2: function(component, event, helper) {
        // make Spinner attribute true for display loading spinner 
        component.set("v.Spinner", true);
        console.log('show');
	},
    
    submitOrderHandler: function(component, event, helper) {
        helper.showSpinner(component);
        var action = component.get("c.submitOrder");
        var highlightPanel = component.get("v.highlightPanel");
        var GrpNum = component.get("v.grpNum");
        var memberId;
        var currIndex;
        var ctarget = event.currentTarget;
        currIndex = ctarget.getAttribute("data-currindex");
        memberId = ctarget.getAttribute("data-memberId");
        console.log('>>>>req'+memberId+'//'+GrpNum+'//'+highlightPanel.benefitBundleOptionId+'//'+currIndex);
        // Setting the apex parameters
        action.setParams({
            memberEid: memberId,
            selectedGroupId: GrpNum,
            benefitBundleId: highlightPanel.benefitBundleOptionId
        });
        
        //Setting the Callback
        action.setCallback(this,function(result){
            component.set("v.isFailedUpdate", false);
            component.set("v.isSuccessUpdate", false);
            //get the response state
            var state = result.getState();

            //check if result is successfull
            if(state == "SUCCESS") {
                var result = result.getReturnValue();
                var members = component.get("v.FamilyMemberList");
                var thisMember = members[currIndex];
                                
                if (!$A.util.isEmpty(result) && !$A.util.isUndefined(result)){
                    console.log('>>>>'+result.ErrorMessage);
                    if(result.ErrorMessage != '') { 
                        component.set("v.isFailedUpdate", true);
                        component.set("v.isSuccessUpdate", false);
                        component.set("v.errorMessage", result.ErrorMessage);
                        thisMember.orderSubmitted = false;
                        
                    } else {                                    
                        console.log('Inside token map');
                        Object.keys(result.tokenMap).forEach(function(memberId) {	// this'll be 1 iteration always
                            thisMember.token = result.tokenMap[memberId];  
                        }); 
                        component.set("v.isFailedUpdate", false);
                        component.set("v.isSuccessUpdate", true);
                        thisMember.orderSubmitted = true;
                        
                    }
                }
                members[currIndex] = thisMember;
                console.log(members[currIndex]);
                component.set("v.FamilyMemberList", members);
                
            } else {
                component.set("v.isFailedUpdate", true);
                component.set("v.isSuccessUpdate", false);
                component.set("v.errorMessage", $A.get("$Label.c.ACETUnexpectedErrorMessage"));             
            }
        });
        
        //adds the server-side action to the queue        
        $A.enqueueAction(action);
    },
    
    showSpinner: function(cmp){        
        cmp.set("v.isUpdating",true);        
    },
    
    hideSpinner: function(cmp){        
        cmp.set("v.isUpdating",false);        
    },
    
    displayToast: function(title, messages, component, helper, event){
        
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": title,
            "message": messages,
            "type": "error",
            "mode": "dismissible",
            "duration": "10000"
        });
        toastEvent.fire();
        
        return;
        
    },  
    
})