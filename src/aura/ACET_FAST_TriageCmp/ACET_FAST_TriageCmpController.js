({
    
    getCaseRec: function(component, event, helper){
        
        var caseId = component.get("v.recordId");
        var action = component.get("c.getCaseRecord"); 
        action.setParams({
            "caseRecId":caseId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS"){
                var result = response.getReturnValue();
                component.set("v.caseRec",result);
                var caseRecord=component.get("v.caseRec");
                var vaildationFailReason='';
                if(caseRecord.CPU_Processing_Status__c=='Case Items Enriched'){
                    vaildationFailReason='All case Items are set to Enriched';
                    
                    helper.showSpinner(component,event);
                    helper.showToast(component,event,'ERROR','ERROR',vaildationFailReason);
                    $A.get("e.force:closeQuickAction").fire();
                    helper.hideSpinner(component,event);
                } else if(caseRecord.CPU_Processing_Status__c=='Case Items Partially Enriched'){
                    
                    
                    var action=component.get("c.publishPFEvent");
                    action.setParams({ 
                        "casRec":caseRecord
                    });
                    action.setCallback(this, function(response){ 
                        var state = response.getState();
                        if (state === "SUCCESS")
                        { 
                            var res = response.getReturnValue();
                            vaildationFailReason='Platform event # '+res+' successfuly published';
                            
                            helper.showSpinner(component,event);
                            helper.showToast(component,event,'Success','Success',vaildationFailReason); 
                            $A.get("e.force:closeQuickAction").fire();
                            helper.hideSpinner(component,event);
                        }
                    });
                    $A.enqueueAction(action);
                    
                    
                }
                    else  if(caseRecord.CPU_Processing_Status__c!='Case Items Partially Enriched'){
                        vaildationFailReason='Triage can be done for only Partially Enriched cases';
                        
                        helper.showSpinner(component,event);
                        helper.showToast(component,event,'ERROR','ERROR',vaildationFailReason);
                        $A.get("e.force:closeQuickAction").fire();
                        helper.hideSpinner(component,event);
                    }     
                
            }
        });
        $A.enqueueAction(action);
    }
})