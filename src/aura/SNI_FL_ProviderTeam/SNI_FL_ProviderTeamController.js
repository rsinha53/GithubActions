({
    
    doInit : function (component, event, helper) {
    	var action = component.get("c.isManageProviderGroup");
        action.setCallback(this, function(response) {
            if(component.isValid() && response !==null && response.getState()=='SUCCESS'){
            var isManageProviderGroup=response.getReturnValue();
                if(isManageProviderGroup === false){
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        message: 'You do not have permission to Create Provider Team',   
                        key: 'info_alt',
                        type: 'error',
                        mode: 'pester',
                        duration:' 5000'
                    });
                    toastEvent.fire();
                    $A.get('e.force:closeQuickAction').fire();
                    
                }            
           }
        });
     	$A.enqueueAction(action);
	},
            
    closeModal : function(component, event, helper) {
        $A.get("e.force:closeQuickAction").fire();   
    },
    
	handleSave: function(component, event, helper) {
        
       // let Salutation = component.find("Salutation").get("v.value");
       // let FirstName = component.find("FirstName").get("v.value");
        let TeamName = component.find("TeamName").get("v.value");
         if(!TeamName){
            helper.showToast(component, 'error', 'ERROR', 'Team Name required');
            return;
        }
        helper.createAccount(component,TeamName);

	}   
    
})