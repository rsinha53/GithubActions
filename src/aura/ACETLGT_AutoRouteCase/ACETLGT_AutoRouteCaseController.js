({
    init : function(component, event, helper) {
        if(!component.get("v.recordId")){
            component.set("v.recordId",component.get("v.pageReference").state.c__id);
        }
        var action = component.get('c.validateCasePermission');
        action.setParams({
            caseId : component.get('v.recordId')
        });
        action.setCallback(this,function(response){
            if(response.getState()=='SUCCESS'){
                var result = response.getReturnValue();
                if(!result.isEditable){
                    component.set('v.isEditable',false);
                }
                else{
                    component.set('v.typeSubTypeDependency',
                                  JSON.parse(result.typeSubTypeDependency));  
								  console.log(result.caseObj);
                    component.set('v.caseObj',result.caseObj); 
                }
                helper.handleCreateLoad(component, event, helper);
            }
            else{
                helper.handleOnError(component,'Unexpected error occured',true);
            }
        });
        $A.enqueueAction(action);
    }, 
    
   
    
    submit : function(component,event,helper){
        var action = component.get('c.invokeRoute');
        action.setParams({
            caseId : component.get('v.recordId'),
            type : component.get('v.caseObj.Type__c').replace("'s","\\'s"),
            subtype: component.get('v.caseObj.Subtype__c'),
            priority: component.get('v.caseObj.Priority') 
        });
        action.setCallback(this,function(response){
            var result = response.getReturnValue();
            if(response.getState()=='SUCCESS'){
                if(result.isSuccess){
                    helper.handleOnSuccess(component,result.message,helper);
                }
                else{
                    helper.handleOnError(component,result.message,true);    
                }
            }
            else{
                helper.handleOnError(component,'Unexpected error occured',true);
            }
        });
        $A.enqueueAction(action);
    },
    
    handleReset: function(component, event,helper) { 
        helper.handleResetHelper(component,500);
    },
    typeChanged : function(component, event, helper){
        var type = component.get('v.caseObj.Type__c');
        helper.setSubTypeOptions(component,type);
        component.set('v.caseObj.Subtype__c','');
    }
    
})