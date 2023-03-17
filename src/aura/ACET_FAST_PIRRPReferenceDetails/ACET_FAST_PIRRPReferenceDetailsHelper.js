({
    showSpinner: function(component, event){
        var spinner = component.find("dropdown-spinner");
        $A.util.removeClass(spinner, "slds-hide");
    },
    hideSpinner: function(component, event){
        var spinner = component.find("dropdown-spinner");
        $A.util.addClass(spinner, "slds-hide");
    },
   validateMandatoryFields: function(component, event){
        var isValidationSucces = true;
        var emptyFields=[]; 
       
      if($A.util.isEmpty(component.find("refNum").get("v.value"))){emptyFields.push("Reference # \n");}
     if($A.util.isEmpty(component.find("slaRoute").get("v.value"))){emptyFields.push("SLA Routed date");}    
         if(emptyFields.length>0){
            isValidationSucces=false; 
            var fieldsToShow = '';
            for (var i = 0; i < emptyFields.length; i++) {
                fieldsToShow = fieldsToShow+'* '+emptyFields[i]+' \n';
            }
            this.showToast(component,event,"Below fields are required","Error",fieldsToShow,5000);
        }
        return isValidationSucces;
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

     showRefSaveToast: function(component, event, title ){
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title":'Success',
            "type": 'success',
            "message": 'Patner Reference record has been saved successfully'
            
        });
        toastEvent.fire();

    },
   
    refreshFocusedTab : function(component, event, helper,payLoadId) {
     
                var workspaceAPI = component.find("workspace");
                workspaceAPI.getFocusedTabInfo().then(function(response) {
                    var focusedTabId = response.tabId;
                    workspaceAPI.closeTab({tabId: focusedTabId});
                    $A.get('e.force:refreshView').fire();
                    workspaceAPI.openTab({
                        url: '/lightning/r/PIR_Resolution_Partners_Reference__c/'+ payLoadId +'/view',
                        focus: true
                    }).then(function(response) {})
                    .catch(function(error) {
                    });
                })
    }
})