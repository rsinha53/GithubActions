({    
    doInit:function(component,event,helper){  
        var myPageRef = component.get("v.pageReference");
        var agentID = $A.get("$SObjectType.CurrentUser.Id");
        var pageSize = component.get("v.pageSize");
        var pageNumber = component.get("v.pageNumber");
        if(myPageRef != null)
        {  
            var workspaceAPI = component.find("workspace");
            workspaceAPI.getFocusedTabInfo().then(function(response) {
                var focusedTabId = response.tabId;
                
                workspaceAPI.isSubtab({
                    tabId: response.tabId                
                }).then(function(response) {
                    if (response) {
                        
                        workspaceAPI.setTabLabel({
                            tabId: focusedTabId,
                            label: " Messages"
                        });
                        workspaceAPI.setTabIcon({
                            tabId: focusedTabId,
                            icon: "utility:email",
                            iconAlt: "Messages"
                        });
                    }
                    else {
                        
                        workspaceAPI.getAllTabInfo().then(function(response) {                            
                            var tabobj = response;                            
                            if(response[0].subtabs.length>0){                             
                                workspaceAPI.getFocusedTabInfo().then(function(response) {
                                    
                                    var focusedTabId = response.tabId;
                                    workspaceAPI.setTabLabel({
                                        tabId: focusedTabId,
                                        label: " Messages"
                                    });
                                    workspaceAPI.setTabIcon({
                                        tabId: focusedTabId,
                                        icon: "utility:email",
                                        iconAlt: "Messages"
                                    });
                                }).catch(function(error) {
                                    console.log(error);
                                });
                            }
                        })
                        .catch(function(error) {
                            console.log('2 er:: '+error);
                        });
                    }
                });
            })
            .catch(function(error) {
                console.log(error);
            });
            
            var familyID = myPageRef.state.c__familyId;            
            component.set('v.familyId', familyID);
            var titleName = myPageRef.state.c__titleName;            
            component.set('v.titleName', titleName);
            var isBackupAgentView = myPageRef.state.c__isBackupAgentView;             
            component.set('v.isBackupAgentView', isBackupAgentView);            
            var showToggle =  true;            
            component.set('v.showToggle', showToggle);
            var isFamilyLevel = myPageRef.state.c__isFamilyLevel;
            component.set('v.isFamilyLevel', isFamilyLevel);
            var isProviderMsgLevel = myPageRef.state.c__isProviderMsgLevel;
            component.set('v.isProviderMsgLevel', isProviderMsgLevel);
            component.set('v.isHistProvider',isProviderMsgLevel);
			var isSpecificView = myPageRef.state.c__isSpecificView;
            component.set('v.isSpecificView', isSpecificView);
            var accOwner = myPageRef.state.c__accountOwner;
            component.set('v.accountOwner', accOwner);
            
            var action = component.get("c.getAccountNameByID");
            action.setParams({
                "accountID":familyID
            });        
            action.setCallback(this,function(response){
                var state = response.getState();
                var result = response.getReturnValue();
                if (state === "SUCCESS") {
                    component.set("v.AccountName", result.AccName);                   
                }
                else {
                    console.log("Failed with state: " + state);
                }   
            });
            $A.enqueueAction(action);
            
            //Executes when user click account and messages button
            var isBackupAgent = true;

            if(isFamilyLevel || isProviderMsgLevel){
                helper.getListOfDirectMessages(component,event,familyID,pageSize,pageNumber,isFamilyLevel,agentID,isBackupAgent);
            }
            
        }else{ 
            //Executes When user clikcs my messages
            var isBackupAgentView = component.get("v.isBackupAgentView");
            var selectedTabId = component.get("v.selectedTabId");
            var isBackupAgent = true;
            var isProviderMsgLevel = component.get("v.isProviderMsgLevel");

            if(!isBackupAgentView){
                if(selectedTabId != null && selectedTabId != undefined && selectedTabId != '') {
                    agentID = selectedTabId;
                    isBackupAgent = false;
                    helper.getListOfDirectMessages(component,event,null,pageSize,pageNumber,false,agentID,isBackupAgent);      
                }
            } else {
                helper.getListOfDirectMessages(component,event,null,pageSize,pageNumber,false,agentID,isBackupAgent);    
            }

        } 
    },

    //Call doInit to retrieve all message again and update message list
    //Author:Sameera ACDC
    retrieveAllMessages:function(component,event,helper){
      	var myPageRef = component.get("v.pageReference");
        var pageSize = component.get("v.pageSize");
        var pageNumber = component.get("v.pageNumber");
        var familyAgentID = $A.get("$SObjectType.CurrentUser.Id");
        var familyID = component.get("v.familyId");
        var isBackupAgentView = component.get("v.isBackupAgentView");
        var selectedTabId = component.get("v.selectedTabId");
        var isBackupAgent = true;
        if(!$A.util.isUndefinedOrNull(myPageRef)){
            var isFamilyLevel = myPageRef.state.c__isFamilyLevel; 
            component.set("v.isFamilyLevel",isFamilyLevel);
            helper.getListOfDirectMessages(component,event,familyID,pageSize,pageNumber,isFamilyLevel,familyAgentID,isBackupAgent);
        } else if(!isBackupAgentView){
            familyAgentID = selectedTabId;
            isBackupAgent = false;
            helper.getListOfDirectMessages(component,event,null,pageSize,pageNumber,false,familyAgentID,isBackupAgent);      
        } else {
            helper.getListOfDirectMessages(component,event,null,pageSize,pageNumber,false,familyAgentID,isBackupAgent);
        }
       
     	//Clear selected message from the commonmessage view
        component.set('v.selectedDirectMessage',"");
    },
    
    //Handles paginations
    paginationHandler:function(component,event,helper){
        
        var isFamilyLevel = component.get("v.isFamilyLevel");
        var familyAgentID = $A.get("$SObjectType.CurrentUser.Id");
        var pageSize = component.get("v.pageSize");
        var pageNumber = event.getParam("pageNumber");
        var isBackupAgentView = component.get("v.isBackupAgentView");
        var selectedTabId = component.get("v.selectedTabId");
        var isBackupAgent = true;
        var isProviderMsgLevel = component.get("v.isProviderMsgLevel");
        if(isFamilyLevel || isProviderMsgLevel){
            var familyID = component.get('v.familyId');
            helper.getListOfDirectMessages(component,event,familyID,pageSize,pageNumber,isFamilyLevel,familyAgentID,isBackupAgent);     
        } else if(!isBackupAgentView){
            familyAgentID = selectedTabId;
            isBackupAgent = false;
            helper.getListOfDirectMessages(component,event,null,pageSize,pageNumber,false,familyAgentID,isBackupAgent);      
        }
        else {
            helper.getListOfDirectMessages(component,event,null,pageSize,pageNumber,false,familyAgentID,isBackupAgent);            
        }
        //Clear selected message from the commonmessage view
        component.set("v.selectedDirectMessage", "");

    },

    getDirectMessageForSelectedMessage:function(component,event,helper){
        component.set("v.commentPageSize",10);
        component.set("v.commentPageNumber",2);
        var feedID = event.getParam("directMessageFeedID");
        component.set('v.selectedFeedIdValue',feedID);
        
        helper.getDirectMessage(component,feedID);
    },
    
    getLstFlgedMsgs:function(component,event,helper){
        var lstFlgedMsgs = event.getParam("lstDirectMessages");
        var pageNumber = component.get("v.pageNumber");
        var pageSize = component.get("v.pageSize");

        component.set("v.lstDirectMessages",[]);
        component.set("v.lstDirectMessages",lstFlgedMsgs);
        component.set("v.recordStart",lstFlgedMsgs[0].recordStart);
        component.set("v.totalRecords",lstFlgedMsgs[0].totalRecords);
        component.set("v.pageNumber",pageNumber);
        
        if(lstFlgedMsgs[0].recordEnd > lstFlgedMsgs[0].totalRecords){
            component.set("v.recordEnd", lstFlgedMsgs[0].totalRecords);
        } else {
            component.set("v.recordEnd", lstFlgedMsgs[0].recordEnd);
        }
        component.set("v.totalPages", Math.ceil(lstFlgedMsgs[0].totalRecords / pageSize));
		
    },
    
    handleTabSelectEvent:function(component,event,helper){
        var selectedTabName = event.getParam("selectedTabName");
        component.set("v.selectedTabName", selectedTabName);
    }
})