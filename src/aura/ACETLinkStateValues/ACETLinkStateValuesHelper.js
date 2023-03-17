({
	getStateValuesMDT: function(component,event) {
        var action = component.get('c.getStateValues');
        action.setCallback(this, function(actionResult) {
           
            var opts = [];
            for(var i=0;i<actionResult.getReturnValue().length;i++){
                opts.push({
                    label:actionResult.getReturnValue()[i].DeveloperName,
                    value:actionResult.getReturnValue()[i].DeveloperName
                });
            }
             //US1797978 - Malinda
            opts.unshift({label:'--None--',value:''});
            component.set('v.options',opts);
        });
        $A.enqueueAction(action);
    }
})