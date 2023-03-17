({
	deactivateUser : function(component, event, helper) {
        
        var familyId = component.get("v.selectFamilyId");
        var polcymem =  component.get('c.HSIDmemUrls');
        
        var ans;
        polcymem.setCallback(this, function(response) {
            ans= response.getReturnValue();
        //    console.log('returned value ->'+ans);
        });
        
        var action = component.get('c.deactivateUser');
        action.setParams({
            "familyId": familyId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            console.log('deactivateUser----state---'+state);
            if (state === "SUCCESS" && ans) {
                console.log('Deactivate Status='+response.getReturnValue());
                component.set("v.isDeleteModalOpen", false);
                window.open($A.get("$Label.c.CACLandingPageURL"),'_self');
            }
               else if (state === "SUCCESS"){
                   
                   window.open($A.get("$Label.c.CACLoginpageURL"),'_self');
               } 
                //
                //console.log('URL is='+ window.location.reload());
                //$A.get('e.force:refreshView').fire();
            
            else{
                 var errors = response.getError();         
                 console.log('Error while deactivating '+errors[0].message);
                 component.set("v.showError", true);
                 component.set("v.errorMessage", errors[0].message);
            }
             
        });
        $A.enqueueAction(polcymem);
        $A.enqueueAction(action);
        
            
        
	},
    updateCareTeam : function(component, event, helper) {
        //To avoid mixed dml and also to achieve the page log out action in sequence hence calling apex twice
        
        var familyId = component.get("v.selectFamilyId");
        var action = component.get('c.careTeamUpdate');
        action.setParams({
            "familyId": familyId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            console.log('updateCareTeam----state---'+state);
            if (state == "SUCCESS") {
                console.log('updateCareTeam Status='+response.getReturnValue());
                helper.deactivateUser(component,event,helper);
            }
            else{
                 var errors = response.getError();         
                 console.log('Error while deactivating '+errors[0].message);
                 component.set("v.showError", true);
                 component.set("v.errorMessage", errors[0].message);
            }
        });
        $A.enqueueAction(action);
        
	}
})