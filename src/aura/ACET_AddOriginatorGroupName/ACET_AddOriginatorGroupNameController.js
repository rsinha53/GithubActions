({
	myAction : function(component, event, helper) {
        var recId = component.get("v.recordId");
		 var urlEvent = $A.get("e.force:navigateToURL");
                          urlEvent.setParams({
                               "url": "/lightning/n/FPS_Explorer?c__recordId="+recId+"&c__isUpdateCase=true"
                               });
                       urlEvent.fire();
        
       /* var workspaceAPI = component.find("workspace");
        workspaceAPI.openTab({
            pageReference: {
                "type": "standard__webPage",
                "attributes": {
                    "url": "/lightning/n/FPS_Explorer"
                },
                "state": {
                    "c__CaseRecord": component.get("v.recordId"),
                }
            },
            focus: true
        }).then(function(response) {
            
            workspaceAPI.getTabInfo({
                tabId: response
                
            }).then(function(tabInfo) {
                
                workspaceAPI.setTabLabel({
                    tabId: tabInfo.tabId,
                    label: 'FPS Explore'
                });
                workspaceAPI.setTabIcon({
                    tabId: tabInfo.tabId,
                    icon: "standard:people",
                    iconAlt: "Member"
                });
                
            });
        }).catch(function(error) {
            console.log(error);
        });*/
        
	}
})