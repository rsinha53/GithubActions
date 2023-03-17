({
    
    doInit : function (component, event, helper) {
    	var action = component.get("c.isManageProviderGroup");
        action.setCallback(this, function(response) {
            if(component.isValid() && response !==null && response.getState()=='SUCCESS'){
            var isManageProviderGroup=response.getReturnValue();
                if(isManageProviderGroup === false){
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        message: 'You do not have permission to Create Provider Affiliation',   
                        key: 'info_alt',
                        type: 'error',
                        mode: 'pester',
                        duration:' 5000'
                    });
                    toastEvent.fire();
                    $A.get('e.force:closeQuickAction').fire();
                }else{
                  helper.fetchInitData(component)
      			  .then(result => {
						helper.assignValues(component, result);
        		  })
        		 .catch(error => {
            			console.log('Error Occured: '+JSON.stringify(error));
        		 })  
                }            
           }
        });
     	$A.enqueueAction(action);
        
	},
            
    closeModal : function(component, event, helper) {
        $A.get("e.force:closeQuickAction").fire();   
    },
    
	handleSave: function(component, event, helper) {
        
        //Validation - Check if Program and Population are selected
        let programSelected = component.find("program").get("v.value");
        let populationSelected = component.find("population").get("v.value");
        
        if(!programSelected){
            helper.showToast(component, 'error', 'ERROR', 'Program selection required');
            return;
        }
        if(!populationSelected){
            helper.showToast(component, 'error', 'ERROR', 'Population selection required');
            return;
        }        
        
		helper.createAccount(component, populationSelected, programSelected)

	}   
    
})