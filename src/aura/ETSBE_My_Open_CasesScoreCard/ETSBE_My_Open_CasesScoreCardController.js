({
     scriptsLoaded : function(component, event, helper) {
        console.log('Script loaded..'); 
        
    },
	caseScoreCard : function(component, event, helper) {
       
		var params = event.getParam('arguments');
        var selectedUser='';
         var selectedBUnit='';
        if (params) {
            selectedUser = params.selectedUSer;
            selectedBUnit = params.selectedBU;
        }
       helper.showSpinner(component, event, helper);
        var action = component.get("c.openCases");
         action.setParams({"UserName":selectedUser,"SelectedBU":selectedBUnit});
        var self = this;
        action.setCallback(this, function(a){
            console.log(a.getReturnValue());
              helper.hideSpinner(component, event, helper);
            // Display toast message to indicate load status
            //var toastEvent = $A.get("e.force:showToast");
            if(action.getState() ==='SUCCESS'){
                component.set("v.scoreCardList", a.getReturnValue());
               
            }else{
               
            }
            //toastEvent.fire();
        });
         $A.enqueueAction(action);
    },
    
    showSpinner: function(component, event, helper) {
        // make Spinner attribute true for displaying loading spinner 
        component.set("v.spinner", true); 
    },
     
    // function automatic called by aura:doneWaiting event 
    hideSpinner : function(component,event,helper){
        // make Spinner attribute to false for hiding loading spinner    
        component.set("v.spinner", false);
    },
	
})