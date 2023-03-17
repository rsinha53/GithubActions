({
    cloneCase: function(component, event){
        this.showSpinner(component, event);
        var wJSONVar = JSON.stringify(component.get("v.caseWrap"));
        console.log('wJSONVar==>'+wJSONVar);
        var action = component.get("c.cloneCaseAndRelatedRecords");
        action.setParams({
            "wrapperJSON" : wJSONVar
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === "SUCCESS"){
                var finalResult = response.getReturnValue();
                if(finalResult.isSuccess===false){
                    this.showToast(component, event,'ERROR','ERROR',finalResult.message);
                }else{
                    var workspaceAPI = component.find("workspace");
                    workspaceAPI.openTab({
                        url: '/lightning/r/Case/'+finalResult.caseId+'/view',
                        focus: true
                    }).then(function(response) {})
                    .catch(function(error) {
                    });
                    this.showToast(component, event,'SUCCESS','SUCCESS',finalResult.message);
                    this.closePopUpWindow(component, event);
                    
                }
                this.hideSpinner(component, event);
            }
            else{
                this.hideSpinner(component, event);
            }
        });
        $A.enqueueAction(action); 
    },
    showToast: function(component, event, title,type,message ){
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": title,
            "type": type,
            "message": message
        });
        toastEvent.fire();
    },
    closePopUpWindow: function(component, event){
        $A.get("e.force:closeQuickAction").fire();
    },
    showSpinner: function(component, event){
        var spinner = component.find("dropdown-spinner");
        $A.util.removeClass(spinner, "slds-hide");
    },
    hideSpinner: function(component, event){
        var spinner = component.find("dropdown-spinner");
        $A.util.addClass(spinner, "slds-hide");
    }
})