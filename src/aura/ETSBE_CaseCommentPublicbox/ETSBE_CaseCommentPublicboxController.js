({
    doInit : function(component, event, helper) {
        component.set("v.ParentId",component.get("v.pageReference").state.c__ParentID);
         var addCommentAction = component.get("c.getCaserecordtype");
                addCommentAction.setParams({
                    "caseId": component.get("v.pageReference").state.c__ParentID
                  
                });
         addCommentAction.setCallback(this, function(response) {
                    var state = response.getState();
                    
                    if(state === "SUCCESS") {
                        component.set("v.recordtypeName",response.getReturnValue());
                        //alert(response.getReturnValue());
                    }
         });
        $A.enqueueAction(addCommentAction);
        
    },
    
    
    save: function(component, event, helper) {
        console.log('handleAddComment  ' + component.get("v.recordId"));
        var bodyCmp = component.find('commentField');
        var bodyCmpValue = bodyCmp.get("v.value");
        //Custom regular expression for phone number
        var isAllValid;
        //Check for regular expression match with the field value
        if($A.util.isUndefinedOrNull(bodyCmpValue) || bodyCmpValue=='' ) {
            //set the custom error message
            isAllValid=false;
            component.set("v.showErrors",true);
            component.set("v.message",'These required fields must be completed: Body');
            bodyCmp.set('v.validity', {valid:false, badInput :true});
            $A.util.addClass(bodyCmp, "slds-has-error"); // remove red border
            $A.util.removeClass(bodyCmp, "hide-error-message");
            bodyCmp.reportValidity();
        }else{
            //reset the error message
            isAllValid = true;
            component.set("v.showErrors",false);
            $A.util.removeClass(bodyCmp, "slds-has-error"); // remove red border
            $A.util.addClass(bodyCmp, "hide-error-message");
            bodyCmp.setCustomValidity("");
        }
        if(isAllValid){
            var recId=component.get("v.recordId");
            var parId= component.get("v.ParentId")
            var counter=component.get('v.counter')+1;
            component.set('v.counter',counter);
            if(component.get('v.recordtypeName') == 'Stream'){
                counter=0;
                
            }
            if(counter==1){
                var checkBox = component.find("checkId").get("v.checked");
                if (checkBox== true){
                    var toastEvent = $A.get("e.force:showToast");
                    // alert('checked');
                    toastEvent.setParams({
                        
                        message: 'The Public Box has been checked, please verify comments should remain public.',
                        duration:'5000',
                        key: 'info_alt',
                        type: 'warning',
                        mode: 'dismissible'
                    });
                    toastEvent.fire();
                    
                } else {
                    
                    //alert('Unchecked');
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        
                        message: 'The Public Box must be checked for business partners to see the information in the case comments.',
                        duration:'5000',
                        key: 'info_alt',
                        type: 'warning',
                        mode: 'dismissible'
                    });
                    toastEvent.fire();
                } 
            } else{
                
                
                // Prepare the action to create new case comment
               
                var addCommentAction = component.get("c.addCaseComment");
                addCommentAction.setParams({
                    "commentBody": component.get("v.newComment"),
                    "caseId": component.get("v.ParentId"),
                    "Published":component.get("v.publiccheckbox")
                });
                
                // Configure the response handler for the action
                addCommentAction.setCallback(this, function(response) {
                    var state = response.getState();
                    
                    if(state === "SUCCESS") {
                        
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            message: 'Case Comment was created.',
                            duration:' 5000',
                            key: 'info_alt',
                            type: 'success',
                            mode: 'dismissible'
                        });
                        toastEvent.fire();
                        var res =response.getReturnValue();
                        component.set("v.caseComment",res) ; 
                        component.set("v.isDisabled",true) ; 
                        
                     
                        
                        var workspaceAPI = component.find("workspace");
                        
                        workspaceAPI.getFocusedTabInfo().then(function(tresponse) {
                            var focusedTabId = tresponse.tabId;
                            workspaceAPI.closeTab({tabId: focusedTabId});
                              $A.get('e.force:refreshView').fire();
                        })
                        .catch(function(error) {
                            console.log(error);
                        });
                       
                        
                    }
                   
                        else if(state === "ERROR"){
                var errors = addCommentAction.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        component.set("v.showErrors",true);
                        var errormessage = errors[0].message.split(',')[1];
                        component.set("v.message",errormessage.replace(': []','') );
                        //alert(errors[0].message);
                    }
                }
                        
                        console.log('Problem saving casecomment, response state: ' + state);
                    }
                        else {
                            console.log('Unknown problem, response state: ' + state);
                        }
                    
                    
                });
                
                // Send the request to create the new comment
                $A.enqueueAction(addCommentAction);        
            }
        }
    },
    /*checkValidity:function(component, helper, event){
        
           var val=component.find("commentField").get('v.value');
        if(val!==null && val!=undefined){
        console.log(val)
      component.set('v.showErrors',false);
        }
    },*/
    cancel : function(component, helper, event)
    {
        var workspaceAPI = component.find("workspace");
        workspaceAPI.getFocusedTabInfo().then(function(response) {
            var focusedTabId = response.tabId;
            
            workspaceAPI.closeTab({tabId: focusedTabId});
        })
        .catch(function(error) {
            console.log(error);
        });
        
    }
})