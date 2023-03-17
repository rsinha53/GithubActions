({
	searchHelper : function(component,event,getInputkeyWord) {
	  // call the apex class method 
     var action = component.get("c.fetchLookUpValues");
      // set param to method  
        action.setParams({
            'searchKeyWord': getInputkeyWord,
            'ObjectName' : component.get("v.objectAPIName")
          });
      // set a callBack    
        action.setCallback(this, function(response) {
          $A.util.removeClass(component.find("mySpinner"), "slds-show");
            var state = response.getState();
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
              // if storeResponse size is equal 0 ,display No Result Found... message on screen.                }
                if (storeResponse.length == 0) {
                    component.set("v.Message", 'No Result Found...');
                } else {
                    component.set("v.Message", '');
                }
                // set searchResult list with return value from server.
                console.log('incomingSearch: '+JSON.stringify(storeResponse))
                component.set("v.listOfSearchRecords", storeResponse);
                
               /* var obj = component.get("v.objectAPIName");
                console.log('obj: '+obj);
                if(obj == 'user'){
                    component.set("v.listOfUserRecords", storeResponse);
                    //component.set("v.listOfQueueRecords", true);
                }
                else if(obj == 'queue'){
                    //component.set("v.listOfUserRecords", true);
                    component.set("v.listOfQueueRecords", storeResponse);
                }*/
               // var areWeSettingValues = component.get("v.listOfSearchRecords");
              //  console.log('areWeSettingValues? '+JSON.stringify(areWeSettingValues));
            }
 
        });
      // enqueue the Action  
        $A.enqueueAction(action);
    
	},
})