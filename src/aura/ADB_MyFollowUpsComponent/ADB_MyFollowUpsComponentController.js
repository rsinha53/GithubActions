({
    handleMouseOver : function(component, event, helper){
        // to show the mouse hover
        component.set("v.hoverRow", parseInt(event.target.dataset.index));
    },
    
    handleMouseOut : function(component, event, helper){
        // to hide the mouse hover
        component.set("v.hoverRow",-1);
    },
    
    serviceReqHyperlinkUrl: function (component, event, helper) {
        var htmlcmp = event.currentTarget;
        var requestId = htmlcmp.getAttribute("data-requestId");
        console.log('ACET Dashboard: Req '+requestId);
        // to navigate to Navigate tab from ISET and view selected servce request number
        acetDasboardOnFollowUpSelection(requestId);
    },
    
    showMyFllowUpsCard: function (component, event, helper) {
        component.set("v.isMyFllowUpsShow","false");
    },
    
    hideMyFllowUpsCard: function (component, event, helper) {
        component.set("v.isMyFllowUpsShow","true");
        var val = component.get("v.calloutStatus");
        if(val == undefined){
            helper.getSelectWorkloadList(component,helper);
            component.set("v.calloutStatus","Active");
        }
    }
})