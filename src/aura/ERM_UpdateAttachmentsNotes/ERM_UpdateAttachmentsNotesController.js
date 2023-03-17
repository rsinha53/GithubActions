({
    doInit : function(component, event, helper) {
        debugger;
        let action = component.get("c.sendUpdateRequestToERM");       
        var recordId = component.get("v.recordId");
         
        
        
        action.setParams({ caseId: recordId });
        
        action.setCallback(this, function(response) {
            let state = response.getState();
            var reqData = JSON.parse(response.getReturnValue());
            
            console.log(reqData);
            if (state === "SUCCESS") {
                
                if(reqData.status != '200' ){
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({                   
                        "type":'error',
                        "message": reqData.returnMessage
                    });
                    toastEvent.fire();
                }else {
                    
                                       
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        
                        "type":'success',
                        "message": reqData.returnMessage
                    });
                    toastEvent.fire();
                    
                }
                if(reqData.status =='200' || reqData.status =='500' ){
                let action2 = component.get("c.updatecaseStatusToOpen");
        		action2.setParams({ caseId: component.get("v.recordId") });
                action2.setCallback(this, function(response) {
                    var stareqData = JSON.parse(response.getReturnValue());
                    if(stareqData.status=='500'){
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({                   
                            "type":'error',
                            "message": 'Failed to update Status'
                        });
                        toastEvent.fire();
                    }
                });
                $A.enqueueAction(action2);
                }
                $A.get('e.force:refreshView').fire()
                $A.get("e.force:closeQuickAction").fire();
            }
        });
        
        $A.enqueueAction(action);
        
        // if the user clicked the OK button do your further Action here
    }
,
// function automatic called by aura:waiting event  
    showSpinner: function(component, event, helper) {
        // make Spinner attribute true for displaying loading spinner 
        component.set("v.spinner", true); 
    },
     
    // function automatic called by aura:doneWaiting event 
    hideSpinner : function(component,event,helper){
        // make Spinner attribute to false for hiding loading spinner    
        component.set("v.spinner", false);
    }    
})