({
    doInit  : function(component, event, helper){
        var action= component.get("c.getStreamrequestdata");
        action.setParams({ caseId: component.get("v.recordId") });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                if(result.Case__r.Status=='Denied'){
                    component.set("v.deniadPickVal",true);                   
                }else if(result.Case__r.Status=='Closed'){
                    component.set("v.closedPickVal",true);
                }
                if(result.Appealed__c==true){
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({                   
                        "type":"error",
                        "message": "Request can only be appealed once",
                        "mode": 'dismissible',
                        "duration": '5000'
                    });
                    toastEvent.fire();                
                    var dismissActionPanel = $A.get("e.force:closeQuickAction");
                    dismissActionPanel.fire();                  
                }               
            }     
        });        
        $A.enqueueAction(action);               
    },
    
    setAppealPickLstVal : function(component, event, helper) {       
        var appealVal= component.find("apealVal").get("v.value");
        component.set("v.AppealReason",appealVal);
        
    },
    
    insertAppealdata  : function(component, event, helper) {  
        var action = component.get("c.appealDataInsertion");
        action.setParams({
            CaseObjId : component.get("v.recordId"),
            appealPickVal : component.get("v.selectedAppealVal"),
            appealNotes : component.get("v.Stream_Request_Details__c.Appeal_Notes__c")
            
        }); 
        action.setCallback(this,function(response){
            var state = response.getState();
            if(state ==="SUCCESS"){
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({                    
                    "type":"success",
                    "title": "Success!",
                    "message": "Record is Appealed"
                });
                toastEvent.fire();
                
            } else if(state === "ERROR"){
                var errors = action.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        alert(errors[0].message);
                    }
                }
            }
            var dismissActionPanel = $A.get("e.force:closeQuickAction");
            dismissActionPanel.fire();
            $A.get('e.force:refreshView').fire();
        });       
        $A.enqueueAction(action); 
    },
    
    hideModel: function(component, event, helper) {
        var dismissActionPanel = $A.get("e.force:closeQuickAction");
        dismissActionPanel.fire();        
    }
    
})