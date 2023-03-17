({
    showToast : function(message, type) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            //"title": "Success!",
            "message": message,
            "type": type
            //"mode": "dismissable",
            //"duration": "7000"
        });
        toastEvent.fire();
    },
    
    processRequest : function(component, event, helper){
        component.set("v.showModal", false);
        //alert(component.get("v.searchVal"));
        //alert(component.find("sourcePickList").get("v.value"));
        var title = '';
        var type = '';
        var message = '';
        //alert(component.get("v.searchVal"));
       // var searchstr=component.get("v.searchVal");
       // searchstr=searchstr.replaceAll( '\\s+', '');
        var action = component.get("c.getStreamRequestDetails");
        action.setParams({ searchString : component.get("v.searchVal"),
                          platform : component.find("sourcePickList").get("v.value")});
        
        action.setCallback(this,function(response){
            var state = response.getState();
            //alert(response.getState());
            console.log('list to return' +JSON.stringify(response.getReturnValue()));  
            if(state == "SUCCESS" && response.getReturnValue().length>0){ 
                component.set("v.showData", true);
                 component.set("v.nullResults",false);
                component.set("v.listToDiplay", response.getReturnValue());
                title = 'Success';
                type = 'Success';
                //message = 'Entered Search Results';
                message='';
                helper.showToast(message, type);
            } 
            else if(state == "ERROR"){
                component.set("v.listToDiplay", 'No Records Found');
                component.set("v.nullResults",true);
                component.set("v.showData", false);
                title = 'Error';
                type = 'error';
                message = 'Error Occurs';
                helper.showToast(message, type);
            }else{
                component.set("v.showData", false);
                component.set("v.nullResults",true);
                title = 'No Records';
                type = 'Success';
                message = 'No records Found';
                helper.showToast(message, type);
            }
            
        });
        
        $A.enqueueAction(action);
        
    }
    
    
})