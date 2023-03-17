({
	showResults : function (component, event, helper) {
		console.log('Inside OC');
        helper.showSpinner2(component,event,helper);
        var result = true;
        var action = component.get("c.getSearchResults");
        var identifier = component.get("v.identifier");
        var identifierType = component.get("v.identifierType");
        action.setStorable();
        if (result){
		component.set("v.Memberdetail");
         
            // Setting the apex parameters
            action.setParams({
                srk : identifier,
                identifier : identifierType
            });
        
 			//Setting the Callback
            action.setCallback(this,function(a){
                //get the response state
                var state = a.getState();
                console.log('----state--1111-'+state);
                //check if result is successfull
                if(state == "SUCCESS"){
                    var result = a.getReturnValue();
                    console.log('------result-----11111---'+result);
                    if(!$A.util.isEmpty(result) && !$A.util.isUndefined(result)){
                    	if (!$A.util.isEmpty(result.resultWrapper) && !$A.util.isUndefined(result.resultWrapper)){
                            
                        component.set("v.Memberdetail",result.resultWrapper);
                        console.log(component.get("v.Memberdetail"));
                        }
                    }
                } else if(state == "ERROR"){
                   	component.set("v.Memberdetail");
        		}
                helper.hideSpinner2(component,event,helper);
            });
            
            //adds the server-side action to the queue        
            $A.enqueueAction(action);
        }
      	console.log('-result-11111->'+ result);
	    return result;
	},
    hideSpinner2: function(component, event, helper) {        
        component.set("v.Spinner", false);
        console.log('OC Hide');
    },
    // this function automatic call by aura:waiting event  
    showSpinner2: function(component, event, helper) {
        // make Spinner attribute true for display loading spinner 
        component.set("v.Spinner", true);
        console.log('OC show');
	}
})