({
	//this function will allow to set member affiliation pop up to open or close by passing in boolean
     setModel : function(component,event,OpenClose){
        var cmpEvent = component.getEvent("IspopupOpened");
        cmpEvent.setParams({
            CloseMemberAffiliationPopup : OpenClose  });
        cmpEvent.fire();
    },
    
    //This function navigate to older message component as member affiliation, and close member affiliation pop up
    navigateOlderMessage: function(component,event,helper){
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
                            "c__familyId": component.get("v.selectedAffiliationID"),
                            "c__AccountName": component.get("v.AccountName"),
                            "c__RequestType" : "memberAffiliation"
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
        	helper.setModel(component,event,false);
        }).catch(function(error) {
            console.log(error);
        });
	}
})