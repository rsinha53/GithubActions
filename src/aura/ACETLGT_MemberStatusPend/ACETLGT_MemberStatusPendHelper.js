({
	
    getHoldRestrictions: function(component,event,helper,groupNumber,memberId){
        var actionHr = component.get("c.getHoldRestrictions");
        actionHr.setStorable();
        
        if ( groupNumber!=undefined && memberId != undefined) {
            component.set("v.MemberdetailHR");

            // Setting the apex parameters
            actionHr.setParams({
                groupNumber: groupNumber,
                memberId: memberId
            });

            //Setting the Callback
            actionHr.setCallback(this, function(a) {
                //get the response state
                var state = a.getState();              
                
                if (state == "SUCCESS") {
                    console.log('getIholdrest State Success');
                    var result = a.getReturnValue();                                  
                    if (!$A.util.isEmpty(result) && !$A.util.isUndefined(result)) {
                        if (!$A.util.isEmpty(result.resultWrapper) && !$A.util.isUndefined(result.resultWrapper)) {

                            component.set("v.MemberdetailHR", result.resultWrapper.holdCodeList);
                            console.log('------Holds---->>>>>'+ JSON.stringify(result.resultWrapper.holdCodeList) ); 
                            
                        }
                    }
                } else if (state == "ERROR") {
                    component.set("v.MemberdetailHR");
                }
                
            });

            //adds the server-side action to the queue        
            $A.enqueueAction(actionHr);
        }
        
    }
})