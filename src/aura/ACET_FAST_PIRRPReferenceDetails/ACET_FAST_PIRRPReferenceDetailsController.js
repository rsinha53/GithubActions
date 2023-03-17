({
    doInit:function(component, event, helper){
      
      var resolutionPId=component.get("v.recordId"); 
           var action=component.get("c.getRPRecord");
        action.setParams({ 
            "caseItemRPRecId":resolutionPId
        });
        action.setCallback(this, function(response){ 
            var state = response.getState();
            if (state === "SUCCESS")
            {
                var res = response.getReturnValue();
                component.set("v.resPtrRec", res);
            }
        });
        $A.enqueueAction(action);
    },    
    closeAction: function(component, event, helper){
    
       var dismissActionPanel = $A.get("e.force:closeQuickAction");
        dismissActionPanel.fire();
    },
    onRecordSubmit: function(component, event, helper) {
        event.preventDefault(); // stop form submission
        var fields = event.getParam("fields");
        
        if(helper.validateMandatoryFields(component, event, helper)) { 
            component.find("ReferenceForm").submit(fields);
           // helper.showRefSaveToast(component, event, helper);            
        }
    },
    handleOnSuccess : function(component, event, helper){ 
         var payload = event.getParams().response;
        console.log('==PayloadId==:'+payload.id);
        var refNumber = component.get("v.refNumber");

        //helper.refreshFocusedTab(component, event, helper,payload.id); 

        var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        title : 'Success',
                        message: 'Reference record saved successfully',
                        duration:' 3000',
                        key: 'info_alt',
                        type: 'success',
                        mode: 'dismissible'
                    });
                    toastEvent.fire();
                    $A.get("e.force:closeQuickAction").fire();
                    $A.get('e.force:refreshView').fire();
           
    }  
})