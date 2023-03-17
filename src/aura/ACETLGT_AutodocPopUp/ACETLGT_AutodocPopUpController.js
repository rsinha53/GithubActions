({
	doInit : function(component, event, helper) {  
          
        var action = component.get( "c.firstMethod" );
        var cseId = component.get("v.recordId");
        var randomnumber = Math.floor((Math.random()*100)+1);
        window.open("/apex/ACETLGT_AutoDoc?id="+cseId,"_blank","toolbar=yes,scrollbars=yes,resizable=yes,top=200,left=400,width=1000,height=800").focus();  
                    
        action.setCallback(this, function(response){  
            var state = response.getState();  
            if (state === "SUCCESS") {  
                  $A.get("e.force:closeQuickAction").fire(); 
            }  
        });  
        $A.enqueueAction(action);  
          
    }
})