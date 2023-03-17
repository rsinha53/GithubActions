({
    // Creating Canceled Case on landing on the page 
    createMisdirectCase: function(component,event,helper,intType,intId,srk,callTopic,hgltInfo ){
        var action = component.get("c.createMisdirectCase");
        action.setParams({
            "intId": intId,
            "intType": intType,
            "srk": srk,
            "callTopic":callTopic,
            "highlightsPanelInfo":hgltInfo
        });
        action.setCallback(this, function(a) {
            var state = a.getState();
            if(state == "SUCCESS"){
                var result = a.getReturnValue();
                if(!$A.util.isEmpty(result) && !$A.util.isUndefined(result)){
                    console.log(' Create Misdirect Case'+JSON.stringify(result));
                    component.set("v.caseObj",result);
                }
            }
        });
        $A.enqueueAction(action);
        
    },
    //Updating Case with Reason selected on click of Save
    saveMisdirectCase : function(component, event, helper,callTopic) {
        console.log('upsert');
        var workspaceAPI = component.find("workspace");
        var caseObj = component.get("v.caseObj");
        var comments = component.get("v.comments");
        var reason = component.get("v.reason");
        //var srk = component.get("v.srk");
        
        component.find('InputSelectDynamic').set("v.errors", null);
        var result = true;
        
        if(reason == ''){
            result = false;
            component.find('InputSelectDynamic').set("v.errors", [{message:"Error: You must enter a value under the Misdirect Reason "}]);
        }
        
        console.log('~~~~'+comments+reason);
        console.log('~~~~'+JSON.stringify(caseObj));
        
        if(result){
            var action = component.get("c.upsertMisdirectedCase");
            action.setParams({
                "caseObj":caseObj,
                "reason":reason,
                "comments": comments
            });
            
            action.setCallback(this, function(a) {
                var state = a.getState();
                if(state == "SUCCESS"){
                    var result = a.getReturnValue();
                    if(!$A.util.isEmpty(result) && !$A.util.isUndefined(result)){
                        console.log('Inside Upsert Misdirect'+JSON.stringify(result));
                        
                        workspaceAPI.getEnclosingTabId().then(function(tabId) {
                            console.log('!!!!'+tabId+callTopic);
                            // Close the parent tab when misdirected case is saved from Search and Detail page 
                            if($A.util.isUndefined(callTopic) || $A.util.isEmpty(callTopic) || callTopic.includes('Overview')){
                                workspaceAPI.getFocusedTabInfo().then(function(response) {
                                    var focusedTabId = response.parentTabId;
                                    workspaceAPI.closeTab({
                                        tabId: focusedTabId
                                    });
                                })
                                .catch(function(error) {
                                    console.log(error);
                                });
                                
                            }
                            // Close only Misdirect tab when misdirected case is saved from Topic page
                            else{
                                workspaceAPI.closeTab({
                                        tabId: tabId
                                    });
                            }
                        });
                    }
                }
            });
            $A.enqueueAction(action);
            
        }
    },

    //US2132858: Close View Auth Tabs upon Misdirect and TTS Save
    closeViewAuthTabs: function(component, event, helper){

        var workspaceAPI = component.find("workspace");        
        var varEnclosingTabId;
        workspaceAPI.getEnclosingTabId().then(function (enclosingTabId) {            
            varEnclosingTabId = enclosingTabId;
        });
        //getAllTabInfo
        workspaceAPI.getAllTabInfo().then(function (tabInfo) {
            
            if (tabInfo.length > 0){                
                
                for (var i=0; i<tabInfo.length; i++){                    
                    if (varEnclosingTabId.split("_")[0] == tabInfo[i].tabId){ 

                        for (var j=0; j<tabInfo[i].subtabs.length; j++){                            

                            if (tabInfo[i].subtabs[j].title.includes("Auth -")){                             
                                workspaceAPI.closeTab({tabId: tabInfo[i].subtabs[j].tabId});                          
                            }
                        }
                    
                    }
                }
                
            }
        });
    },
    isJSON : function(component, event, str){
        try {
            return JSON.parse(str);
        } catch (e) {
            return false;
        }
    }
})