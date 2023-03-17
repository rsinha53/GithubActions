({
    doInit: function (component, event, helper) {
        
        
        window.setTimeout(
            $A.getCallback(function() {
                $A.get("e.force:closeQuickAction").fire();
            }), 2000
        );
        var userId = $A.get("$SObjectType.CurrentUser.Id");
        component.set('v.userIdValue', userId);
        helper.checkAccessPermissionForCurrentUser(component, event, helper);
    },
    
  loadProviderLevelMessage: function(component, event, helper){
        /*Existing part for specific person account*/
        
        var workspaceAPI = component.find("workspace");
        var AccID = component.get('v.recordId');

        //****DE413563 Updated by Vamsi ACDC */
        var action = component.get("c.getAccountNameByID1");
        action.setParams({
            "accountID": AccID
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                component.set('v.AccountName', result.strName);
                var FamilyPermissionSet = $A.get("$Label.c.SNI_FL_FamilyLinkPermission");
                var EnrollPermissionSet = $A.get("$Label.c.SNI_FL_ProviderMessagingPermission");
                                
                if(result.setPermissionSet && result.setPermissionSet.includes(FamilyPermissionSet) && result.setPermissionSet.includes(EnrollPermissionSet)){
                    var a = component.get('c.OpenNewTab');
                    $A.enqueueAction(a);   
                }else if(result.setPermissionSet && result.setPermissionSet.includes(EnrollPermissionSet)){
                    var a = component.get('c.OpenNewTab');
                    $A.enqueueAction(a);  
                }else{
                    
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
                }
                
              
            }
            else {
                $A.get('e.force:closeQuickAction').fire();                   					
            }
        });
        $A.enqueueAction(action);
        //****DE413563 Updated by Vamsi ACDC */
        /*upto here*/
    },
    
    OpenNewTab: function (component, event, helper) {
        var workspaceAPI = component.find("workspace");
        var AccID = component.get('v.recordId');
        workspaceAPI.openTab({
            url: '/lightning/r/Account/' + AccID + '/view',
            focus: true
        }).then(function (response) {
            workspaceAPI.openSubtab({
                pageReference: {
                    "type": "standard__component",
                    "attributes": {
                        componentName: "c__SNI_FL_AgentView"
                    },
                    "state": {
                        "c__isConnectAPI": false,
                        "c__titleName": component.get('v.AccountName') + " Messages",
                        "c__isBackupAgentView": true,
                        "c__familyId": AccID,
                        "showToggle": true,
                        "c__isFamilyLevel": false,
                        "c__isProviderMsgLevel": true,
                        "c__isSpecificView":false
                    }
                },
                parentTabId: response,
                //recordId : component.get('v.recordId'),
                focus: true
          
            });
        }).catch(function (error) {
        });

    }
})