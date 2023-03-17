({
    getCaseComments : function(component,event,helper) {
        var action = component.get("c.getCaseComments");
        action.setParams({
            "caseId": component.get("v.caseId")
        });
        
        action.setCallback(this, function(a) {
            var state = a.getState();
            var result = a.getReturnValue();
            console.log('Case Comments query result'+JSON.stringify(result));
            var newlst =[];
            
            if (state === "SUCCESS") {
                
                for(var i = 0; i < result.length; i++){
                    result[i].CreatedDate = $A.localizationService.formatDateTime(result[i].CreatedDate , "MM/DD/YYYY hh:mm a");
                    newlst.push(result[i]);
                }
                
                component.set("v.caseComment", newlst);
            }
        });
        $A.enqueueAction(action);
        
    },
    getExternalId : function(component,event,helper) {
        var action = component.get("c.getExternalId");
        action.setParams({
            "caseId": component.get("v.caseId")
        });
        
        action.setCallback(this, function(a) {
            var state = a.getState();
            var result = a.getReturnValue();
            console.log('Case Comments query result'+JSON.stringify(result)+result.length);
            var ext ='';
            
            if (state === "SUCCESS") {
                for(var i = 0; i < result.length; i++){
                    console.log(result[i].ExternalID__c);
                    if(i==0)
                        ext= result[i].ExternalID__c;
                    else
                        ext = ext+', '+result[i].ExternalID__c;
                }
                //ext.substring(0,ext.length-2);
                console.log(ext);
                component.set("v.externalId", ext);
            }
        });
        $A.enqueueAction(action);
        
    }
})