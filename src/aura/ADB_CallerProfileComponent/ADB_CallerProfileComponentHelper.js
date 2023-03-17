({
    copyTextHelper : function(component,event,text) {
        // Create an hidden input
        var hiddenInput = document.createElement("input");
        // passed text into the input
        hiddenInput.setAttribute("value", text);
        // Append the hiddenInput input to the body
        document.body.appendChild(hiddenInput);
        // select the content
        hiddenInput.select();
        // Execute the copy command
        document.execCommand("copy");
        // Remove the input from the body after copy text
        document.body.removeChild(hiddenInput); 
        // store target button label value
        var orignalLabel = event.getSource().get("v.label");
        // change button icon after copy text
        event.getSource().set("v.iconName" , 'utility:check');
        // change button label with 'copied' after copy text 
        event.getSource().set("v.label" , 'copied');
        
        // set timeout to reset icon and label value after 1000 milliseconds 
        setTimeout(function(){ 
            event.getSource().set("v.iconName" , ''); 
            event.getSource().set("v.label" , orignalLabel);
        }, 1000);
    },

	getCurrentCall: function(component, event, helper) {
        var action = component.get("c.getCurrentCall");
        var callStatus = component.get("v.currentCall");
        action.setParams({ callStatus : callStatus});
        action.setCallback(this, function(response) {
            var state = response.getState();      
            if (state === "SUCCESS") {
                var currentCall = response.getReturnValue();
                component.set("v.currentCall", currentCall);
            }
        });
        $A.enqueueAction(action);
    }
    //NOT FOR QA201. Commented to avoid database interaction for Account, Notes and preferred Name due to License limitations.
    /*handlePreferredNameSaving: function(component, event, helper){
        var accVal = component.get("v.accVals"); 
        var preferredName = component.get("v.preferredName"); 
        console.log("vallsss :: "+ preferredName)
        
        var action = component.get("c.savePreferredName");
        
        action.setParams({ 
            				preffedName : preferredName,
                          	accID : accVal
                         
                         });

        action.setCallback(this, function(response) {
            var state = response.getState();

            if (state === "SUCCESS") {
                console.log("CP Response From server:pref name saving " + JSON.stringify(response.getReturnValue()));
                var res = response.getReturnValue();
                
                 if(!$A.util.isEmpty(res) && !$A.util.isUndefined(res)){
                     console.log("CP Response From server:pref name  " + res.Preferred_Name__pc);        
                             component.set("v.preferredName",res.Preferred_Name__pc);
            	}
            }

        });
        $A.enqueueAction(action);
        
        
    },
    
    updateNotes: function(component, event, helper){
        var accVal = component.get("v.accVals");
        var qkNotes = component.get("v.quickNotes");
        var dateUpdatedOn = component.get("v.noteUpdatedDate");
        console.log("vallsss :: "+ qkNotes+dateUpdatedOn);
        console.log(JSON.stringify(accVal));
        
        var action = component.get("c.updateAccounts");
        
        action.setParams({ 
            				quickNotes : qkNotes,
                          	accID : accVal,
            				dateUpdatedOn : dateUpdatedOn
                         
                         });

        action.setCallback(this, function(response) {
            var state = response.getState();

            if (state === "SUCCESS") {
                console.log("CP Response From server: " + JSON.stringify(response.getReturnValue()));
                var res = response.getReturnValue();
                
                 if(!$A.util.isEmpty(res) && !$A.util.isUndefined(res)){
                     
        				component.set("v.quickNotes",res.Quick_Notes__c);
        				component.set("v.noteUpdatedDate",res.Updated_Quick_Notes_On__c );
            	}
            }

        });
        $A.enqueueAction(action);
        
        
    },
    
    // function to save database for my uhc registration
    saveUhcData : function(component,event,helper) {        
        
        var memberId = component.get("v.decodedMemberId")
        var memDob = component.get("v.memberDOB");
        var memFirstName = component.get("v.memFirstName");
        var memLastName = component.get("v.memLastName");
        var memberPolicy = component.get("v.policy");
        var agentId = component.get("v.agentId");
        var flagAction = event.getSource().get("v.label");
        var lastLogOnLocation = component.get("v.lastLogOnLocation");
        var registrationStatus = component.get("v.registeredStatus");
        
        var action = component.get("c.saveUhcRegistration");
        action.setParams({memberId : memberId,
                          memDob : memDob,
                          memFirstName : memFirstName,
                          memLastName : memLastName,
                          memberPolicy : memberPolicy,
                          agentId: agentId,
                          flagAction : flagAction,
                          registrationStatus : registrationStatus,
                          lastLogOnLocation : lastLogOnLocation,});
        action.setCallback(this, function(response) {
            var state = response.getState(); 
            if (state === "SUCCESS") {
                console.log('Hit database');
                // this will fire the refresh of the page
                var evt = $A.get('e.force:refreshView');
                console.log('evt', evt);
                if (evt){
                    evt.fire();
                } 
            }
        });
        $A.enqueueAction(action); 
    },
    
    // function to save database for my uhc registration
    saveUhcflagData : function(component,event,helper, flagAction) {        
        
        var cdb_XREFId = component.get("v.decodedMemberId");
        //var cdb_XREFId = "155624450";
        var lastLogOnLocation = component.get("v.lastLogOnLocation");
        var registrationStatus = component.get("v.registeredStatus");
        var action = component.get("c.saveUhcflagRegistration");
        action.setParams({ memberId : cdb_XREFId,
                          flagAction : flagAction,
                          registrationStatus : registrationStatus,
                          lastLogOnLocation : lastLogOnLocation,});
        action.setCallback(this, function(response) {
            var state = response.getState();  
            
            if (state === "SUCCESS") {
                
                // this will fire the refresh of the page
                var evt = $A.get('e.force:refreshView');
                console.log('evt', evt);
                if (evt){
                    evt.fire();
                }
            }
            
                
        });
        $A.enqueueAction(action); 
    }*/
    // - NOT FOR QA201. Commented to avoid database interaction for Account, Notes and preferred Name due to License limitations.
    
})