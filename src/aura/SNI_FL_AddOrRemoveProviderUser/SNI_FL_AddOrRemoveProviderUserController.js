({
	doInit : function(component, event, helper) {
        var action = component.get("c.isManageProviderGroup");
        action.setCallback(this, function(response) {
            if(component.isValid() && response !==null && response.getState()=='SUCCESS'){
            var isManageProviderGroup=response.getReturnValue();
                if(isManageProviderGroup === false){
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        message: 'You do not have permission to Add/Remove Provider User',   
                        key: 'info_alt',
                        type: 'error',
                        mode: 'pester',
                        duration:' 5000'
                    });
                    toastEvent.fire();
                    $A.get('e.force:closeQuickAction').fire();
                    
                }else{
                     var action1 = component.get("c.getProviderUserAff");
        			 action1.setParams({
            			ProviderAfiliationid: component.get("v.recordId")
        			 });
        			 action1.setCallback(this, function(response){
            		 var state = response.getState(); // get the response state
            
		             if(state == 'SUCCESS') {
         		         var storeResponse = response.getReturnValue();
                		 if(storeResponse.allProviderUserStr !== undefined){
                    	 var allProviderUserValues = [];
                    	 	for (var i = 0; i < storeResponse.allProviderUserStr.length; i++) {
	                      		allProviderUserValues.push({
	                        	label: storeResponse.allProviderUserStr[i],
	                        	value: storeResponse.allProviderUserStr[i]
    	                  	});
                          }
                          component.set("v.ProviderUserListStr",allProviderUserValues);
                          component.set("v.ProviderUserList",storeResponse.allProviderUserobj);
                	 }
               
                	if(storeResponse.AcrselectedStr !== undefined){
                    	component.set("v.selectedProviderUserListStr",storeResponse.AcrselectedStr);
                    	component.set("v.selectedProviderUserList",storeResponse.Acrselectedobj);
                    }
            }
                     });
                     $A.enqueueAction(action1);
            }             
                
            }
        });
     	$A.enqueueAction(action);
		
	},
    SaveSelectedProviderUser : function(component, event, helper){
        var action = component.get("c.AddRemoveProviderUser");
        action.setParams({
            TeamId: component.get("v.recordId"),
            AllProviderUser: component.get("v.ProviderUserList"),
            selectedProviderUserList: component.get("v.selectedProviderUserList"),
            SelectedProviderUserStr: component.get("v.selectedProviderUserListStr")
        });
        action.setCallback(this, function(response){
            var state = response.getState(); // get the response state
            if(state == 'SUCCESS') {
                var result = response.getReturnValue();
                var toastEvent = $A.get("e.force:showToast");
        		toastEvent.setParams({
            		"title": 'SUCCESS',
            		"message": result,
            		"type": 'success'
        		});
        		toastEvent.fire();  
                $A.get("e.force:closeQuickAction").fire();
                  
            }
        });
        $A.enqueueAction(action);

    },
    closeModal : function(component, event, helper) {
        $A.get("e.force:closeQuickAction").fire();   
    }
})