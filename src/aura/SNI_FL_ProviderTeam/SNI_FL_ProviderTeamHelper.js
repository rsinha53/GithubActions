({
	    
    createAccount : function(component,TeamName){
        var action = component.get("c.createProviderTeam");
       
        action.setParams({
            ProviderAffiliation : component.get("v.accountRecord.Id"),
           
            TeamName : TeamName
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state === 'SUCCESS') {
                let result = response.getReturnValue();
                console.log('result: '+JSON.stringify(result));
                let resultParsed = JSON.parse(result);
                this.showToast(component, 'success', 'SUCCESS', 'Created New Provider Team: '+resultParsed.LastName);
                $A.get("e.force:closeQuickAction").fire(); 
                $A.get('e.force:refreshView').fire();
            } else {
                let error = response.getError();
                console.log('Error Occured: ' + JSON.stringify(error));
                if(error[0] && error[0].fieldErrors &&
                   error[0].fieldErrors.Name[0] && 
                   error[0].fieldErrors.Name[0].message){
                  	console.log('Error Occured: resultErrorParsed' + error[0].fieldErrors.Name[0].message);
                	this.showToast(component, 'error', 'ERROR', 'Error creating Provider Team. Please try again.: '+ error[0].fieldErrors.Name[0].message);
                }else{
                     this.showToast(component, 'error', 'ERROR', 'Error creating Provider Team. Please try again.: '+  JSON.stringify(error));
                }$A.get("e.force:closeQuickAction").fire();      
            }
        });
        $A.enqueueAction(action);            
    },
    
    showToast : function(component, type, title, message) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": title,
            "message": message,
            "type": type
        });
        toastEvent.fire();
    }    
})