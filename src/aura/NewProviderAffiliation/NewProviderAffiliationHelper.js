({
	fetchInitData : function(component) {
        return new Promise(function(resolve, reject){
            var action = component.get("c.getData_NewProviderAffiliation");
            action.setCallback(this, function(response) {
                var state = response.getState();
                if(state === 'SUCCESS') {
                    resolve(response.getReturnValue());
                } else reject(response.getError());
            });
            $A.enqueueAction(action);
        });
	},
    
    assignValues : function(component, result) {
        var programs = [];
        for(var key in result){
            console.log('key: '+key);
            if(key){
                if(key === 'RecordTypeId') {
                    component.set("v.RecordTypeId", result[key]);
                    continue;
                }
                programs.push({value:key, key:result[key]});
            }
            component.set("v.programs", programs);            
        }
        console.log('programs: '+JSON.stringify(component.get("v.programs")));
        console.log('RecordtypeId: '+component.get("v.RecordTypeId"));        
    },
    
    createAccount : function(component, populationSelected, programId){
        var action = component.get("c.createAccount");
        action.setParams({
            population : populationSelected,
            programId : programId,
            parentId : component.get("v.accountRecord.Id"),
            parentAccountName : component.get("v.accountRecord.Name")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state === 'SUCCESS') {
                let result = response.getReturnValue();
                console.log('result: '+JSON.stringify(result));
                let resultParsed = JSON.parse(result);
                this.showToast(component, 'success', 'SUCCESS', 'Created New Provider Affiliation: '+resultParsed.Name);
                $A.get("e.force:closeQuickAction").fire();
                $A.get('e.force:refreshView').fire();
            } else {
                let error = response.getError();
                console.log('Error Occured: ' + JSON.stringify(error));
                if(error[0] && error[0].fieldErrors &&
                   error[0].fieldErrors.Name[0] && 
                   error[0].fieldErrors.Name[0].message){
                  	console.log('Error Occured: resultErrorParsed' + error[0].fieldErrors.Name[0].message);
                	this.showToast(component, 'error', 'ERROR', 'Error creating Provider Affiliation. Please try again.: '+ error[0].fieldErrors.Name[0].message);
                }else{
                     this.showToast(component, 'error', 'ERROR', 'Error creating Provider Affiliation. Please try again.: '+  JSON.stringify(error));
                }
               $A.get("e.force:closeQuickAction").fire();      
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