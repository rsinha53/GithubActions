({
    doInit: function (component, event, helper) {
        setTimeout(function () { $A.get('e.force:closeQuickAction').fire(); }, 3)    
        var userId = $A.get("$SObjectType.CurrentUser.Id");
        component.set('v.userIdValue', userId);
        var AccID = component.get('v.recordId');
        var userPermission = component.get('c.getUserProfilePermissionSet'); 
        userPermission.setCallback(this, function(a){
            var state = a.getState();
            if(state == 'SUCCESS') {

                const result = a.getReturnValue();
                var user = result.userObj;
                var permissionSet = result.PermissionSet;
                var setlabels = [];
                permissionSet.forEach(function(record){
                    console.log('----'+JSON.stringify(record));
                    setlabels.push(record.PermissionSet.Label);
                })
                console.log('setlabels='+JSON.stringify(setlabels));
                let SNI_FL_3WayCommunication = $A.get("$Label.c.SNI_FL_3WayCommunication");
                console.log("Failed with state: " +SNI_FL_3WayCommunication);
                //let permissions = permissionSet.filter(item => item!=null?item.PermissionSet!=null?item.PermissionSet.Label:'':'' == SNI_FL_3WayCommunication);
                
                
                var action = component.get("c.checkUHGRestriction"); 
                //var action = component.get("c.checkProfileValidity");
                action.setParams({
                    "AccountId": AccID
                });
                action.setCallback(this,function(response){
                    var state = response.getState();            
                    if (state === "SUCCESS") {
                        component.set("v.isValidAccess", response.getReturnValue());
                        var isValidAccess = component.get('v.isValidAccess');
                        if(isValidAccess == false)
                        {
                            var errorMessage = $A.get("$Label.c.SNI_FL_AccessError");
                            var toastEvent = $A.get("e.force:showToast");
                            toastEvent.setParams({
                                //title : 'Warning',
                                message: 'You do not have access to this restricted file.',   
                                key: 'info_alt',
                                type: 'info',
                                mode: 'sticky'
                            }); 
                            toastEvent.fire();
                            $A.get('e.force:closeQuickAction').fire(); 
                        }  
                        else //if not UHG restricted file               
                        {
                            if((user.UserRole.Name.includes('Registered Nurse') || user.UserRole.Name.includes('Regional PDC')) && setlabels.includes(SNI_FL_3WayCommunication)){
                                helper.getAccountNameByID(component,event,AccID);                
                            }else{
                            var action = component.get("c.CheckUnregisteredMember");
                            action.setParams({
                                "AccountId": AccID
                            });
                            action.setCallback(this, function (response) {
                                var state = response.getState();
                                if (state === "SUCCESS") {
                                    //$A.get('e.force:closeQuickAction').fire();  
                                    component.set("v.isValidMember", response.getReturnValue());
                                    var isValidMember = component.get('v.isValidMember');
                                    /*If not a valid member*/
                                    if (isValidMember == false) {
                                        var errorMessage = $A.get("$Label.c.SNI_FL_MemberRegistrationStatus");
                                        var toastEvent = $A.get("e.force:showToast");
                                        toastEvent.setParams({
                                            message: errorMessage,
                                            key: 'info_alt',
                                            type: 'info',
                                            mode: 'sticky'
                                        });
                                        toastEvent.fire();
                                        $A.get('e.force:closeQuickAction').fire();                   					
                                    } else {
                                        /*Existing part for specific family*/
                                        var AccID = component.get('v.recordId');
                                        //******DE417471 Updated by Sameera ACDC***** */
                                        var action = component.get("c.getAccountNameByID1");
                                        action.setParams({
                                            "accountID": AccID
                                        });
                                        action.setCallback(this, function (response) {
                                            var state = response.getState();
                                            
                                            if (state === "SUCCESS") {
                                                var result = response.getReturnValue();
                                                console.log('result--'+JSON.stringify(result));
                                                var FamilyPermissionSet = $A.get("$Label.c.SNI_FL_FamilyLinkPermission");
                                                var EnrollPermissionSet = $A.get("$Label.c.SNI_FL_ProviderMessagingPermission");
                                                
                                                
                                                if(result.setPermissionSet && result.setPermissionSet.includes(FamilyPermissionSet) && result.setPermissionSet.includes(EnrollPermissionSet)){
                                                    
                                                    helper.getAccountNameByID(component,event,AccID);
                                                    
                                                }else if(result.setPermissionSet && result.setPermissionSet.includes(FamilyPermissionSet)){
                                                    
                                                    helper.getAccountNameByID(component,event,AccID);
                                                    
                                                }else{
                                                    
                                                    var errorMessage = $A.get("$Label.c.SNI_FL_AccessError");
                                                    console.log('errorMessage--'+errorMessage);
                                                    var toastEvent = $A.get("e.force:showToast");
                                                    toastEvent.setParams({
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
                                                console.log("Failed with state: " + state);
                                                $A.get('e.force:closeQuickAction').fire();                   					
                                            }
                                        });
                                        $A.enqueueAction(action);
                                        //*****DE417471****** */
                                        /*upto here*/
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
                    }
                    else {
                        console.log("Failed with state: " + state);
                        $A.get('e.force:closeQuickAction').fire();                   					
                    }   
                });
                
                $A.enqueueAction(action);    
                    
                
                
            }else{
                let errors = a.getError();
                let message = 'Unknown error'; // Default error message
                // Retrieve the error message sent by the server
                if (errors && Array.isArray(errors) && errors.length > 0) {
                    message = errors[0].message;
                }
                // Display the message
                console.error(message);
            }
        });
        $A.enqueueAction(userPermission);
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
                        "c__titleName": component.get('v.accountName') + " " + "Family Messages",
                        "c__accountOwner": component.get('v.accOwner'),
                        "c__isBackupAgentView": true,
                        "c__familyId": component.get('v.recordId'),
                        "showToggle": true,
                        "c__isFamilyLevel": true,
                        "c__isProviderMsgLevel": false,
                        "c__isSpecificView": true
                    }
                },
                parentTabId: response,
                //recordId : component.get('v.recordId'),
                focus: true
            });
        }).catch(function (error) {
            console.log(error);
        });
    },
    
    UHGRestriction:function(component, event, helper) {
        var AccID = component.get('v.recordId');
        var action = component.get("c.checkUHGRestriction"); 
        action.setParams({
            "AccountId": AccID
        });
        action.setCallback(this,function(response){
            var state = response.getState();            
            if (state === "SUCCESS") {
                component.set("v.isValidAccess", response.getReturnValue());
                var isValidAccess = component.get('v.isValidAccess');
                if(isValidAccess == false)
                {
                    var errorMessage = $A.get("$Label.c.SNI_FL_AccessError");
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        //title : 'Warning',
                        message: 'You do not have access to this restricted file',   
                        duration: '5',
                        key: 'info_alt',
                        type: 'info',
                        mode: 'dismissible'
                    });
                    toastEvent.fire();
                    
                }  else{
                    console.log('isValidAccess else ' + component.get('v.isValidAccess'));
                }
                
            }
            else {
                console.log("Failed with state: " + state);
            }   
        });
        
        
        $A.enqueueAction(action);
    }
})