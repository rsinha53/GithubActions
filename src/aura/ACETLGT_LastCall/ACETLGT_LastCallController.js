({
	doInit : function(component, event, helper) {
        var actionlastcall = component.get("c.getLastCalldetails");
        component.set("v.showSpinner",true);
        actionlastcall.setParams({
            surrogate: component.get("v.surrogateKey")
        });
        actionlastcall.setCallback(this, function(response) {
            var state = response.getState();      
            if (state === "SUCCESS") {
                if(response.getReturnValue()!=null){
                	component.set("v.lastcall",response.getReturnValue());
                    component.set("v.nolastcall",false);
                }else{
                    component.set("v.nolastcall",true);
                }
            }
            component.set("v.showSpinner",false);
        });
        $A.enqueueAction(actionlastcall);
	},
})