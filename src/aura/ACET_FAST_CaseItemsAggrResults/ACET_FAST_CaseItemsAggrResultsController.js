({
	getAggrResults : function(component, event, helper) {
        var casId= component.get("v.recordId");
       var action = component.get("c.getAggregateInfo");
        action.setParams({
            "caseId":casId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS" ){
                var result = response.getReturnValue();
                component.set("v.cItemAggrDetails",result);
                var platforms = [];
                var conts = result.caseItemsbyPlatform;
                for(var key in conts){
                   
                       platforms.push({value:conts[key], key:key});
                }
                component.set("v.platform", platforms);
                
                var Lob = [];
                var conts = result.caseItemsbyLob;
                for(var key in conts){
                 
                    Lob.push({value:conts[key], key:key});
                }
                component.set("v.lineOfBusiness", Lob);
            }
        });
        $A.enqueueAction(action);
		
	}
})