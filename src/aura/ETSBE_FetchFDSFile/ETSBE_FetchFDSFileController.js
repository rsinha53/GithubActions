({
    init : function(component, event, helper) {
        debugger;
        var pageReference = component.get("v.pageReference");
        component.set("v.fileID", pageReference.state.c__fileID);
        
        var action = component.get("c.fetchFDSFile");
        action.setParams({"fileID":component.get("v.fileID")});
        action.setCallback(this, function(res){
            //alert(response.response.getReturnValue();());
           console.log('URL==> ' + res.getReturnValue());
               window.open(res.getReturnValue(),'_self');
            window.setTimeout(
                $A.getCallback(function() {
                    //alert('hi');
                    
                     window.close();
                }), 10000
            );
            
        });
        $A.enqueueAction(action);
    }
})