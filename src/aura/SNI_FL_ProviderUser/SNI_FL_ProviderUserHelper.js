({
	    
    createAccount : function(component,Salutation,FirstName,LastName,Email){
        var action = component.get("c.createProviderUser");
       
        var Name = component.get("v.accountRecord")!=null?component.get("v.accountRecord").Id:null;
  
        action.setParams({
            providerAffilition : Name,
            Salutation : Salutation,
            FirstName : FirstName,
            LastName : LastName,
            Email  : Email
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state === 'SUCCESS') {
                let result = response.getReturnValue();
                console.log('result: '+JSON.stringify(result));
                let resultParsed = JSON.parse(result);
                this.showToast(component, 'success', 'SUCCESS', 'Created New Provider User: '+resultParsed.LastName);
                $A.get("e.force:closeQuickAction").fire(); 
                $A.get('e.force:refreshView').fire();
            } else {
                let error = response.getError();
                console.log('Error Occured: ' + JSON.stringify(error));
                if(error[0] && error[0].fieldErrors &&
                   error[0].fieldErrors.Name[0] && 
                   error[0].fieldErrors.Name[0].message){
                  	console.log('Error Occured: resultErrorParsed' + error[0].fieldErrors.Name[0].message);
                	this.showToast(component, 'error', 'ERROR', 'Error creating Provider User. Please try again.: '+ error[0].fieldErrors.Name[0].message);
                }else{
                     this.showToast(component, 'error', 'ERROR', 'Error creating Provider User. Please try again.: '+  JSON.stringify(error));
                }$A.get("e.force:closeQuickAction").fire();      
            }
        });
        $A.enqueueAction(action);            
    },
    getUserInfo: function(component){
        var action = component.get("c.isManageProviderGroup");
        action.setCallback(this, function(response) {
            if(component.isValid() && response !==null && response.getState()=='SUCCESS'){
            var isFecPro=response.getReturnValue();
                if(isFecPro === false){
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        message: 'You do not have permission to create Provider User',   
                        key: 'info_alt',
                        type: 'error',
                        mode: 'sticky'
                    });
                    toastEvent.fire();
                    $A.get('e.force:closeQuickAction').fire();
                    
                }else{
                     component.set('v.isFecPro',isFecPro);
                }             
                
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