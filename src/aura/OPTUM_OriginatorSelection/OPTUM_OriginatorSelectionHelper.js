({
	openTab : function(component, event, helper) {
    var workspaceAPI = component.find("workspace");
        workspaceAPI.openTab({
            pageReference: {
                "type": "standard__component",
                "attributes": {
                    "componentName": "c__OPTUM_NotionalClaimTransactions"  // c__<comp Name>
                },
                "state": {
                    "c__acctType": component.get("v.acctType"),
                    "c__colorPalette": component.get("v.colorPalette"),
                    "c__memberDetail": component.get("v.md"),
                    
                }
            },
            focus: true
        }).then((response) => {
               workspaceAPI.setTabLabel({
                  tabId: response,
                  label: "Claims"
               });
             workspaceAPI.setTabIcon({
                    tabId: response,
                    icon: "utility:description",
                    iconAlt: "Description"
                });
        }).catch(function(error) {
            console.log(error+"error@123");
        });
},
})