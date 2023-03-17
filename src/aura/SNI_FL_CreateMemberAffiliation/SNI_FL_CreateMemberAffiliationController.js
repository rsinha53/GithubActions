({
    doInit : function (component, event, helper) {
    	helper.fetchInitData(component)
        .then(result => {
			helper.assignValues(component, result);
            helper.getUserInfo(component, result);
        })
        .catch(error => {
            console.log('Error Occured: '+JSON.stringify(error));
        })
	},
    closeModal : function(component, event, helper) {
        $A.get("e.force:closeQuickAction").fire();   
    },
    
    selectRow: function (component, event, helper) {
        var selectedRows = event.getParam('selectedRows');
        component.set("v.selectedUsers",selectedRows);
    },
    
    onselect : function(component, event, helper) {
        var providergroup =   component.find("providergroup").get("v.value");
        if ($A.util.isEmpty(providergroup) ){
            component.find("providerAffiliation").set("v.value",'')
            component.set("v.data",null);
            return '';   
        }
        var programValue = component.get("v.programValue");
        var populationSelected = component.find("population").get("v.value");
        var action = component.get("c.fetchLookUpValues");
        action.setParams({
            programValue: programValue,
            populationSelected : populationSelected,
            providergroup : String(providergroup)
        });
        action.setCallback(this, function(response){
            var state = response.getState(); // get the response state
            if(state == 'SUCCESS') {
                var storeResponse = response.getReturnValue();
                console.log('storerespomse',storeResponse)
                if (!storeResponse.isTrue) {
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        title : 'Error',
                        message:'provider group not offering selected program for choosen population',
                        duration:' 5000',
                        key: 'info_alt',
                        type: 'error',
                        mode: 'pester'
                    });
                    toastEvent.fire();    
                }else{
                    component.find("providerAffiliation").set("v.value",storeResponse.ProviderAff);
                }
            }else{
                const errorMsg = response.getError()[0].message;
                console.log('errorMsg---------'+errorMsg);
                
            }
        });
        $A.enqueueAction(action);
     
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
        
    },
    
})