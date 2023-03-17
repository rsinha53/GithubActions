({
    doInit: function(component,event,helper) {
        var workspaceAPI = component.find("workspace");
        workspaceAPI.getEnclosingTabId().then(function(response) {
            var focusedTabId = response.tabId;
            workspaceAPI.setTabLabel({
                tabId: focusedTabId,
                label: 'Change Owner'
            });
        })
        var state = component.get("v.pageReference").state;
        var caseId=state.c__caseId;
        component.set('v.caseId',caseId);
    },
    
    onChange : function (component, event, helper) {       
        var objectname = component.find('select').get('v.value'); 
    },
    
    handleQueueButton : function (component, event, helper){
        
        component.set("v.userBrand" , 'neutral');
        component.set("v.queueBrand" ,'brand');
        component.set("v.selectedObject", 'queue');
        component.set("v.labelName", 'Search by Queue');
    },
    
    handleUserButton : function (component, event, helper){
        component.set("v.userBrand" , 'brand');
        component.set("v.queueBrand" ,'neutral');
        component.set("v.selectedObject", 'user');
        component.set("v.labelName", 'Search by Name');
    },
    
    
    handleComponentEvent : function(component, event, helper) {        
        var selectedAccountGetFromEvent = event.getParam("recordByEvent");
        component.set("v.selectedRecord" , selectedAccountGetFromEvent);         
    },
    
    closeTab : function(component, event, helper){
        var workspaceAPI = component.find("workspace");
                    workspaceAPI.getFocusedTabInfo().then(function(response) {
                        var focusedTabId = response.tabId;
                        workspaceAPI.closeTab({tabId: focusedTabId});
                    })
                    .catch(function(error) {
                        console.log(error);
                    });        
    },
    
    updateCase : function(component, event, helper) {
        
        var caseid = component.get('v.caseId');
        var sRecord = component.get('v.selectedRecord');
        var obj = component.get('v.selectedObject');
        var action = component.get("c.updateCaseOwner");
        var workspaceAPI = component.find("workspace");
        
        // set param to method  
        action.setParams({
            'caseId': caseid,
            'selectedrecord' : sRecord,
            'obj' : obj
        });
        // set a callBack 
        action.setCallback(this, function(response) {
            var state = response.getState();
            console.log('state: '+state);
            if (state === "SUCCESS") {
                var results=response.getReturnValue();
                if(results === 'Apex Success'){
                    component.set("v.showpopup",true);
                    console.log('Inside If: '+results);
                    
                    var workspaceAPI = component.find("workspace");
                    workspaceAPI.getFocusedTabInfo().then(function(response) {
                        var focusedTabId = response.tabId;
                        workspaceAPI.closeTab({tabId: focusedTabId});
                    })
                    .catch(function(error) {
                        console.log(error);
                    });

                    setTimeout(function(){ location.reload("/lightning/r/Case/"+caseid+"/view"); }, 200);
                    
                }
                else if(results === 'TTS Validation Fail'){   
                    var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "title": "Error!",
                            "message": "Topic Type and Topic Subtype are required."
                        });
                        toastEvent.fire();
                   
                }
            }              
            else{
                console.log('Print something.');
            }            
        });   
        
        $A.enqueueAction(action);               
    }
    
})