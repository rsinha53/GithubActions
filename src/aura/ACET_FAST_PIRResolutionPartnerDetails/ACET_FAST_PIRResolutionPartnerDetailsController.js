({
    doInit:function(component, event, helper){
        
        var casItemRec = component.get("v.caseItemRecord");
        var rpIdVar=casItemRec.Resolution_Partner__c; 
        if(rpIdVar!='' && rpIdVar!=null && rpIdVar!=undefined){
            // alert('hey');
            var action = component.get("c.getRPRecord");
            action.setParams({
                "caseItemRPRecId":rpIdVar
            });
            action.setCallback(this, function(response) {
                var state = response.getState();
                console.log('state==>'+state);
                if(state === "SUCCESS"){
                    var result = response.getReturnValue();
                    component.set("v.resPtrRec",result);
                    
                }
                
            });
            $A.enqueueAction(action);
            // alert(JSON.stringify(component.get("v.rPRec")));
        }
        
        var caseId =casItemRec.Case__c;
        
        if(caseId!='' && caseId!=null && caseId!=caseId){
            var action = component.get("c.getCaseRecord");
            action.setParams({
                "caseRecId":caseId
            });
            action.setCallback(this, function(response) {
                var state = response.getState();
                console.log('state==>'+state);
                
                if(state === "SUCCESS"){
                    var result = response.getReturnValue();
                    component.set("v.caseRec",result); 
                    component.set("v.caseRecType",result.Case_Type__c);
                    // alert(JSON.stringify(result));
                }
                
            });
            $A.enqueueAction(action);
            // alert(JSON.stringify(component.get("v.rPRec")));
        } 
        
    },
    
    
    closeAction: function(component, event, helper){
        component.set("v.editPIRVar",false);
    },
    
    onRecordSubmit: function(component, event, helper) {
        event.preventDefault(); // stop form submission
        var fields = event.getParam("fields");
        var resolutionPId = component.get("v.resolutionPId");
        
        if(helper.validateMandatoryFields(component, event, helper)) {
            if(resolutionPId != null){
                 component.find('FastForm').submit(fields);
            } else{
                var rPID=helper.valdRPRecord(component, event, fields.Provider_Matrix_Reactive__c,fields.Case__c,fields);            
            }
            
        }
    },
    
    handleOnSuccess : function(component, event, helper){
        //var record = event.getParam("response");
        var payload = event.getParams().response;
        console.log(payload.id);
        var recId = payload.id;
        var action = component.get("c.getRPName");        
        action.setParams({
            "recId": recId
        });      
        action.setCallback(this, function(response) {
            var state = response.getState();
            console.log('state-->'+state);
            if (state === "SUCCESS") {
                var finalResult = response.getReturnValue();
                console.log('rpName-->'+finalResult.rpName);
                helper.updateCasItem(component, event, recId,finalResult);
            }
            
        });
        $A.enqueueAction(action);  
        
        
    }
    
    
})