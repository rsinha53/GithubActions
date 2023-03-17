({
	doInit : function(component, event, helper) {
		 let action = component.get("c.validateBeforeSimonRequest");
        
        var recordId = component.get("v.recordId");
        
        action.setParams({ caseId: recordId });
        action.setCallback(this, function(response) {
            let state = response.getState();
            var reqData = response.getReturnValue();
            if (state === "SUCCESS") {
                var toastEvent = $A.get("e.force:showToast");
                var message;
                var type;
                var casenumber = response.getReturnValue(); 
                if(casenumber.indexOf(';')>0){
                    
                    casenumber = casenumber.substr(0,casenumber.length-1);
                    console.log('case num'+casenumber);
                    component.set("v.caseNumber",casenumber);
                    $A.createComponent("c:ERM_OverlayLibraryModal", {},
                           function(content, status) {
                               if (status === "SUCCESS") {
                                   var modalBody = content;
                                   
                                   component.find('overlayLib').showCustomModal({
                                       header: "",
                                       body: modalBody, 
                                       showCloseButton: false,
                                       closeCallback: function(ovl) {
                                           console.log('Overlay is closing');
                                       }
                                   }).then(function(overlay){
                                       console.log("Overlay is made");
                                   });
                               }
                           });
                    
                }
                else if(casenumber == 'error'){
                    message = 'Please complete all required fields in the Request Detail Page in order to submit your case';
                    type='error';
                }
                else if(casenumber == 'dualerror'){
                    message = 'Please enter a minimum of 2 rows for Plan Codes';
                    type='error';
                }
                else if(casenumber == 'attacherror'){
                    message = 'You must add a file attachment';
                    type='error';
                }
                else if(casenumber == 'polerror'||casenumber == 'employeeError'){
                    message = 'At least one policy is needed for this Request!';
                    type='error';
                }
                else if(casenumber == 'duperror'){
                    message = 'You must attach files, add comments or add enrollees';
                    type='error';
                }
                    else if(casenumber == 'w2error'){
                        message = 'At least one Report Date is required';
                    	type='error'; 
                    }
                    else if (casenumber == 'brokerError'){
                      message = 'At least one user is needed for this request!';
                    type='error';  
                        
                    }
                else if (casenumber == 'commenterror'){
                      message = 'You must submit comments';
                    type='error';  
                        
                    }
                toastEvent.setParams({
                    
                    "type":type,
                    "message": message
                });
                toastEvent.fire();

                if(type=='error'){
                    $A.get("e.force:closeQuickAction").fire();
                }
                
            }
        });
        $A.enqueueAction(action);
	},
    handleApplicationEvent : function(component, event,helper) {
       // alert('hi inside');
         var message = event.getParam("message");
        //var message = event.getParam("message");
        //alert('@@@ ==> ' + message);
        if(message == 'Ok')
        {
             
            
            let action = component.get("c.sendRequestToERM");
        
            var recordId = component.get("v.recordId");
            
            action.setParams({ caseObjectId: recordId });
            action.setCallback(this, function(response) {
                let state = response.getState();
                var reqData = JSON.parse(response.getReturnValue());
                console.log('Data returned' +reqData);
                
                if (state === "SUCCESS") {
                    if(reqData.status == '200'){
                    var toastEvent = $A.get("e.force:showToast");
            		toastEvent.setParams({
                    
                    "type":'success',
                    "message": 'Case '+component.get("v.caseNumber")+' has been Submitted'
                });
                toastEvent.fire();
                        
                    }else{
                        var toastEvent = $A.get("e.force:showToast");
            		toastEvent.setParams({
                    
                    "type":'error',
                    "message": reqData.returnMessage
                });
                toastEvent.fire();
                    }
                    $A.get("e.force:closeQuickAction").fire();
                    window.setTimeout(
                $A.getCallback(function() {
                    component.set("v.spinner",false);
                    $A.get('e.force:refreshView').fire()
            		
                }), 5000
               );
                }
            });
            $A.enqueueAction(action);
        // if the user clicked the OK button do your further Action here
        }
       else if(message == 'Cancel')
      {
          $A.get("e.force:closeQuickAction").fire();
        // if the user clicked the Cancel button do your further Action here for canceling
      }
    }
})