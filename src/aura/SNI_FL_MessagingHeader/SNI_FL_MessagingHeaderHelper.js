({
    loadDirectMessageList : function(component,event,helper){

		var isFlagged = component.get("v.isFlagged");
        var familyID = component.get("v.familyId");
        var pageSize = 10;
        var pageNumber = 1;
        var isFamilyLevel = component.get("v.isFamilyLevel") == null || undefined ? false : component.get("v.isFamilyLevel");
        var action = component.get("c.getDirectMessageList");
        var isBackupAgent = component.get("v.isBackupAgentView");
        var isProviderMsgLevel = component.get("v.isProviderMsgLevel");
        var selectedId = "empty";
        var isUnread = false;
        var familyAgentID = '';
        var isProvider = component.get("v.isProvider");;
        if(!isBackupAgent){
            familyAgentID = component.get("v.selectedTabId");
        } else {
            familyAgentID = $A.get("$SObjectType.CurrentUser.Id");
        }

        action.setParams({
            "isFamilyLevel":isFamilyLevel,
            "agentID":familyAgentID,
            "familiyAccountID":familyID,
            "pageNumber":pageNumber,
            "pageSize":pageSize,
            "isFlagged":isFlagged ,
            "isBackupAgent":isBackupAgent,
            "isProviderMsgLevel":isProviderMsgLevel,
            "isProvider":isProvider,
            "selectedId": selectedId, // added by Nanthu to track related to selected messages
            "isUnread": isUnread // added by Nanthu to get FL unread messages
        });
        action.setCallback(this,function(response){
            
            if(response.getState()=='SUCCESS'){
                
                var lstOfDirectMessages = response.getReturnValue();
                if(!$A.util.isEmpty(lstOfDirectMessages)){                  
                    component.set("v.lstDirectMessages",lstOfDirectMessages);         
                    component.set("v.recordStart",lstOfDirectMessages[0].recordStart);
                    component.set("v.totalRecords",lstOfDirectMessages[0].totalRecords);
                    component.set("v.pageNumber",pageNumber);
                    if(lstOfDirectMessages[0].recordEnd > lstOfDirectMessages[0].totalRecords){
                        component.set("v.recordEnd", lstOfDirectMessages[0].totalRecords);
                    } else {
                        component.set("v.recordEnd", lstOfDirectMessages[0].recordEnd);
                    }
                    component.set("v.totalPages", Math.ceil(lstOfDirectMessages[0].totalRecords / pageSize));
                }else{
                    component.set("v.lstDirectMessages",null);
                }
            }
        });
        $A.enqueueAction(action);        
    },
    
    NavigateOlderMessage: function(component, event,requestType,id){
        var workspaceAPI = component.find("workspace");
        workspaceAPI.getTabInfo().then(function (tabInfo) {
            var focusedTabId = tabInfo.tabId;
            workspaceAPI.openSubtab({
                parentTabId: focusedTabId,
                pageReference: {
                    "type": "standard__component",
                    "attributes": {
                        "componentName": "c__SNI_FL_SENSOlderMessages"
                    },
                    "state": {
                        "c__familyId": id,
                        "c__AccountName": component.get("v.AccountName"),
                        "c__RequestType": requestType
                    }
                },
                focus: true
            }).then((response) => {
                workspaceAPI.setTabIcon({
                tabId: response,
                icon: "utility:email",
                iconAlt: "Older Messages"
            })
            workspaceAPI.setTabLabel({
                tabId: response,
                label: " Older Messages"
            })
        });
    }).catch(function(error) {
    console.log(error);
});
},
    //Validate whether advisor belongs to a program afliations
    //ACDC Sameera
    validateProviderAfliations:function(component,event){

        var action = component.get("c.checkProviderAfliationsForAdvisor");

        action.setParams({
            advisorId: $A.get("$SObjectType.CurrentUser.Id")
        });

        action.setCallback(this,function(response){

            if((response.getState()=='SUCCESS') && (response.getReturnValue())){
                component.set("v.IsOpenNewProviderMsg",true);
            }else{
                component.find('notifLib').showToast({
                    
                    "mode":"sticky",    
                    "message": "You are required to be assigned a Provider Affilation to send Provider Messages"
                });
            }
            
        });

        $A.enqueueAction(action);
    },
    
    getMAID: function(component,event,helper){
        var action = component.get("c.getMAID");
        action.setParams({
            "accountID": component.get("v.familyId")
        });
        action.setCallback(this,function(response){
            var state = response.getState();
            if(state == 'SUCCESS'){
                var mAResponse = response.getReturnValue();
                component.set('v.memberId',mAResponse);
                helper.NavigateOlderMessage(component, event,"memberAffiliation",component.get("v.memberId"));
            }
        });
        $A.enqueueAction(action);
    }
})