({
    doInit : function(component, event, helper) { 
        
        var action = component.get( "c.firstMethod" );
        var cseId = component.get("v.recordId");
        var randomnumber = Math.floor((Math.random()*100)+1);
        var workspaceAPI = component.find("workspace");
        action.setCallback(this, function(response){ 
            var state = response.getState(); 
            
            if (state === "SUCCESS") { 
                
                workspaceAPI.isConsoleNavigation().then(function(resp) {
                    var urlBaseStr = response.getReturnValue();
                    
                   //  var orgUrl = urlBaseStr + "/apex/ACETLGT_AutoRouteCase?id="+cseId;
                    var orgUrl =urlBaseStr+"/lightning/cmp/c__ACETLGT_AutoRouteCase?c__id="+cseId;
                    
                    if(resp){
                        workspaceAPI.getFocusedTabInfo().then(function(resp) {
                            
                    sessionStorage.setItem('caseRoute '+cseId,resp.tabId);
                            workspaceAPI.openSubtab({
                                parentTabId : resp.tabId,
                                url: orgUrl,
                                focus: true,
                                label: "Route"
                            })
                        })    
                    }else{
                        window.open(orgUrl,"_blank","Autodoc",randomnumber,"width=800,height=700,top=300,left=450,scrollbars=yes,resizable=yes"); 
                    }
                    
                })
                .catch(function(error) {
                    console.log(error);
                });
                $A.get("e.force:closeQuickAction").fire();
            } 
        }); 
        $A.enqueueAction(action); 
        
    }
})