({
	doInit : function(component, event, helper) {
		
        var action = component.get("c.getUserDetails");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS"){
                var result = response.getReturnValue();
                component.set("v.userDetails",result);
                console.log('-result-'+ JSON.stringify(result) );
                console.log('-role-'+ result.UserRoleId);
               
                if(result.UserRoleId != undefined && result.UserRole.Name == 'OPO PIR'){
                    component.set("v.OPOuser",true);
                }else{
                    component.set("v.OPOuser",false);
                }
            }
        });
        $A.enqueueAction(action);
        
        var caseId = component.get("v.recordId");
        var action = component.get("c.getPIRRecId");
        action.setParams({ "caseRecId":caseId });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS"){
                var result = response.getReturnValue();
                console.log('pip result--'+JSON.stringify(result));
                component.set("v.pirId",result.Id);
                component.set("v.pirDetails",result);
                var today = new Date();
                component.set("v.ReopenDateTime",today.toISOString());
            }
        });
        $A.enqueueAction(action);
        
        var usraction = component.get("c.getValiduser");
        usraction.setParams({ "caseRecId":caseId });
        usraction.setCallback(this, function(response) {
            
            var state = response.getState();
            if (state === "SUCCESS"){
                var result = response.getReturnValue();
                console.log('result-'+result);
                if(result == false){
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        title : 'Error!',
                        message: 'Only SMEs, Supervisors and OPO PIR team members can edit cases they do not own.',
                        type: 'error',
                        mode: 'sticky'
                    });
                    toastEvent.fire();
                    $A.get("e.force:closeQuickAction").fire();
                }
                
            }
        });
        $A.enqueueAction(usraction);
        
	},
    
    handleOnSubmit : function(component, event, helper){
        event.preventDefault();
        var today = new Date();
        var updateRec = event.getParam("fields");
        
        var ttoday=helper.getDate(component, event);
        var userSelectedDate = component.find('ReOpenedDate').get('v.value');
        userSelectedDate = $A.localizationService.formatDate(userSelectedDate, "YYYY-MM-DD");
        
        if(userSelectedDate > ttoday){
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                title:"Error",type:'error',
                message:'The date cant be set to future date.'
            });
            toastEvent.fire();
            return;
        }else{
            console.log('else---');
            if(updateRec.Status__c == 'Closed'){
                updateRec.Status__c = 'Reopen'
                updateRec.Reopened_Date__c = today.toISOString();
                console.log('submitRec---'+JSON.stringify(updateRec));
                component.find("pirReopen").submit(updateRec);
            }else{
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": 'Error!', "type": 'error',
                    "message": 'Record can be submitted on closed cases or PIR is in open status.'
                });
                toastEvent.fire();
            }
            
        } 
    },
    
    handleOnSuccess : function(component, event, helper){
        var caseId = component.get("v.recordId");
        var action = component.get("c.updateCaseRecord");
        action.setParams({
            "caseRecId":caseId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            console.log('==='+state);
            console.log('==='+response.getReturnValue());
            if (state === "SUCCESS"){
                var result = response.getReturnValue();
               console.log('--Ok');
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": 'Success!',
                    "type": 'success',
                    "message": 'Record updated Successfully.'
                });
                toastEvent.fire();
                $A.get("e.force:closeQuickAction").fire();
                $A.get('e.force:refreshView').fire();
            }else if(state === "ERROR"){
                var result = response.getError()[0].message;
                console.log('error--'+result);
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title: 'Error!',
                    type: 'error',
                    mode: 'sticky',
                    message: result 
                });
                toastEvent.fire();
                
                var action = component.get("c.updatePIR");
                action.setParams({
                    "caseRecId":caseId
                });
                action.setCallback(this, function(response) {
                    var state = response.getState();
                    if (state === "SUCCESS"){
                        var result = response.getReturnValue();
                        
                    }
                });
                $A.enqueueAction(action);
                $A.get("e.force:closeQuickAction").fire();
            }
        });
        $A.enqueueAction(action);
    },
    
    handleOnError : function(component, event, helper){
        event.preventDefault();
        var updateRec = event.getParam("fields");
        console.log('substatus---'+updateRec.Status__c);
        updateRec.Status__c == 'Closed'
        console.log('submitRec---'+JSON.stringify(updateRec));
        component.find("pirReopen").submit(updateRec);
    },
    
    handleClose : function(component, event, helper){
        $A.get("e.force:closeQuickAction").fire();
    },
    
})