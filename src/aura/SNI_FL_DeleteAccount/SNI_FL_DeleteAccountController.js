({
	// US2718898 :Code Added By Chandan-start
    warnDelete: function(component, event, helper) {
        component.set("v.isDeleteModalOpen", true);
    },
    
    closeWarning: function(component, event, helper) {
        component.set("v.isDeleteModalOpen", false);
    },
    // added by fps
    careteamcall: function(component,event,helper){     
      helper.updateCareTeam(component,event,helper);  
    },
    authPassword : function(component, event, helper) {            
        
        component.set("v.showError", false);
        component.set("v.errorMessage", '');
        var password =component.get("v.checkPassword");
        console.log('password entered in authPassword='+password);
        if(password){
         var action1 = component.get('c.authenticatePassword');
         action1.setParams({
             "password": password
         });
        action1.setCallback(this, function(response) {
            var state = response.getState();
            console.log('authenticatePassword----state---'+state);
            if (state == "SUCCESS") {
                //console.log('User='+response.getReturnValue());
                //if(response.getReturnValue()!=null){
                    helper.updateCareTeam(component, event, helper);
                //}
            }
            else{
                 var errors = response.getError();         
                 console.log('Error: '+errors[0].message);
                 component.set("v.showError", true);
                 component.set("v.errorMessage", 'Invalid password, please enter correct password to proceed.');
            }
        });
        $A.enqueueAction(action1);
        }
        else{
            console.log('inside else block');
            component.set("v.showError", true);
            component.set("v.errorMessage", 'Your password is required to delete your account.');
            /*var titleField = component.find("checkPassword");
            $A.util.addClass(titleField, 'slds-has-error');
            var validationmessage = component.find("commentValidationMessage");
            $A.util.removeClass(validationmessage, 'none');
            $A.util.addClass(validationmessage, 'slds-visible'); */ 
            return false;
        } 
	}
})