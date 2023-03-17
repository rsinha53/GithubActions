({
    searchHelper : function(component,event,getInputkeyWord) {
        // call the apex class method 
        var action = component.get("c.fetchEscGroups");        
        // set param to method  
       
        action.setParams({
            'searchKeyWord': getInputkeyWord,
            'ExcludeitemsList' : component.get("v.lstSelectedRecords")
            
        });
        // set a callBack    
        action.setCallback(this, function(response) {
           // $A.util.removeClass(component.find("mySpinner"), "slds-show");
            var state = response.getState();
            console.log("---state----"+state);
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                // if storeResponse size is equal 0 ,display No Records Found... message on screen.                }
                if (storeResponse.length == 0) {
                    component.set("v.Message", 'No Records Found...');
                } else {
                    component.set("v.Message", '');
                    // set searchResult list with return value from server.
                }
                var storeResponsestr = JSON.stringify(storeResponse);
                var lstSelectedRecords = component.get("v.lstSelectedRecords");
                component.set("v.listOfSearchRecords", storeResponse);    
            }
        });
        // enqueue the Action  
        $A.enqueueAction(action);
    }
})