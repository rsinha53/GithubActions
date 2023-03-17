({
    doInit : function(component, event, helper) {
        //Added Vamsi 
        helper.hlprGetBackupAdvisors(component,event,helper);                
        var userId = $A.get("$SObjectType.CurrentUser.Id");
        component.set("v.userIdValue", userId);
        var action = component.get("c.checkProfileValidity"); 
        action.setCallback(this,function(response){
            var state = response.getState();            
            if (state === "SUCCESS") {
                component.set("v.isValidProfile",response.getReturnValue());
                var isValidProfile = component.get('v.isValidProfile');
                if(isValidProfile == false)
                {
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
                }                
            }
            else {
                console.log("Failed with state: " + state);
            }   
        });
        $A.enqueueAction(action);
    },
    
    handleEvent : function(component, event, helper) {

        var selectedUsers = event.getParam("Users");
        component.set("v.backupAgents", selectedUsers);
        component.set("v.openBackupAgentModal", false);
        var isAdvisorBlock = event.getParam("isAdvisorBlock");
        component.set("v.isbackupAdvisor", isAdvisorBlock);
        var detail = [];
        var newlst = [];
        newlst.push(detail);
        if(selectedUsers.length>0){
            for(var i=0; i < selectedUsers.length  && i <= 10 ; i++) {
                
                $A.createComponent("lightning:tab", {
                    "label" : selectedUsers[i].Name,
                    "id" : selectedUsers[i].Advisor__c ,
                    "onactive" : component.getReference("c.addContent", selectedUsers[i])
                }, function(newTab, status, error){
                    if(status === "SUCCESS"){
                        newlst.push(newTab);
                        component.set("v.agenttabs", newlst);
                    } else {
                        throw new Error(error);
                    }    
                });
            }  
        }else{
            component.set("v.agenttabs", []);
        }
        
        
    },
    addContent : function(component, event, helper){
        var tab = event.getSource();
       $A.createComponent('c:SNI_FL_AgentView', {
            'isConnectAPI' : true,
           //  'titleName' : tab.get("v.label"),
            'isBackupAgentView' : false,
            'selectedTabId' : tab.get("v.id")
        }, function (newContent, status, error) {  
            if (status === 'SUCCESS') {
                tab.set('v.body', newContent);
            } else {
                console.log(error);
            }
        })
    },

    tabSelected : function(component, event, helper) {
        var backupAgents = component.get("v.backupAgents");
        var selectedTabId = event.getSource().get('v.selectedTabId');   

        var selectedTabName ='';
        if(!$A.util.isUndefinedOrNull(backupAgents) && !$A.util.isEmpty(backupAgents)){
            for(var i = 0; i<backupAgents.length; i++){
                if(selectedTabId == backupAgents[i].Advisor__c){
                    selectedTabName = backupAgents[i].Name;                
                }
            }
        }
        var cmpEvent = $A.get("e.c:SNI_FL_TabSelectedEvent");

        cmpEvent.setParams({
            "selectedTabId" : selectedTabId,
            "selectedTabName" : selectedTabName + " Messages"
        });
        cmpEvent.fire();
 
    },

})