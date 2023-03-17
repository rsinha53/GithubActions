({
    checkAccessPermissionForCurrentUser: function (component, event, helper) {
        var action = component.get("c.checkManageProviderGroupUserId"); 
        action.setCallback(this,function(response){
            var state = response.getState();            
            if (state === "SUCCESS") {
                if(response.getReturnValue()){
                    var a = component.get('c.loadProviderLevelMessage');
                    $A.enqueueAction(a);
                }else{
                    this.helprCheckPermissions(component, event, helper);
                }
            }else{
                $A.get('e.force:closeQuickAction').fire(); 
            }
            
        });
        $A.enqueueAction(action);
        
    },
    helprCheckPermissions: function (component, event, helper) {
         var AccID = component.get('v.recordId');
        var workspaceAPI = component.find("workspace");
        var action = component.get("c.checkProfileValidity"); 
        action.setCallback(this,function(response){
            var state = response.getState();            
            if (state === "SUCCESS") {
                if(response.getReturnValue() != true){
                    var errorMessage = $A.get("$Label.c.SNI_FL_AccessError");
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        //title : 'Warning',
                        message: errorMessage,   
                        duration: '5',
                        key: 'info_alt',
                        type: 'info',
                        mode: 'sticky'
                    });
                    toastEvent.fire();
                    $A.get('e.force:closeQuickAction').fire();
                }else{
                    //
                    var action = component.get("c.checkUHGRestrictionForProviderMessaging");
                    action.setParams({
                        "accountId": AccID
                    });
                    action.setCallback(this, function (response) {
                        var state = response.getState();
                        
                        if (state === "SUCCESS") {
                            component.set("v.isValidAccess", response.getReturnValue());
                            var isValidAccess = component.get('v.isValidAccess');
                            if(isValidAccess == false)
                            {
                                var errorMessage = $A.get("$Label.c.SNI_FL_AccessError");
                                var toastEvent = $A.get("e.force:showToast");
                                toastEvent.setParams({
                                    message: 'You do not have access to this restricted file.',   
                                    key: 'info_alt',
                                    type: 'info',
                                    mode: 'sticky'
                                });
                                toastEvent.fire();
                                $A.get('e.force:closeQuickAction').fire(); 
                            }else{
                                var proAction = component.get("c.checkProviderAffiliationForProviderMessaging");
                                proAction.setParams({
                                    "accountId": AccID
                                });
                                proAction.setCallback(this, function (response) {
                                    var state = response.getState();
                                    console.log("state: " + state);
                                    if (state === "SUCCESS") {
                                        component.set("v.isproValidAccess", response.getReturnValue());
                                        var isproValidAccess = component.get('v.isproValidAccess');
                                        
                                        if(isproValidAccess == 'No')
                                        {
                                            var toastEvent = $A.get("e.force:showToast");
                                            toastEvent.setParams({
                                                message: 'You are required to be assigned the same Provider Affiliation as the member to view Provider messages.',   
                                                key: 'info_alt',
                                                type: 'info',
                                                mode: 'sticky'
                                            });
                                            toastEvent.fire();
                                            $A.get('e.force:closeQuickAction').fire(); 
                                        } else {
                                                var a = component.get('c.loadProviderLevelMessage');
                                                $A.enqueueAction(a);
                                            }
                                    }
                                    else {
                                        console.log("Failed with state: " + state);
                                        $A.get('e.force:closeQuickAction').fire();                   					
                                    }
                                });
                                $A.enqueueAction(proAction);
                                
                            }
                        }
                        else {
                            console.log("Failed with state: " + state);
                            $A.get('e.force:closeQuickAction').fire();                   					
                        }
                    });
                    $A.enqueueAction(action);
                }
            }
            else {
                console.log("Failed with state: " + state);
            }   
        });
        $A.enqueueAction(action);
    }
})