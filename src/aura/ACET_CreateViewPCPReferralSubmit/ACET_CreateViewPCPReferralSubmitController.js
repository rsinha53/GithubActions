({
	init : function(component, event, helper) {
        var workspaceAPI = component.find("workspace");
        
        workspaceAPI.getFocusedTabInfo().then(function(response) {
             component.set('v.currenttabId',response.tabId);
            
         }).catch(function(error) {
            console.log(error);
        });
	},
    editReferral : function(component,event,helper){
         let cmpEvent = component.getEvent("closePreviewModalBox"); 
        cmpEvent.fire();
    },
    submitReferral : function(component,event,helper){
         //let cmpEvent = component.getEvent("closePreviewModalBox"); 
        //cmpEvent.fire();
        var currentid=component.get('v.currenttabId');
        var snapTab=_setAndGetSessionValues.gettingValue(currentid);
        var workspaceAPI = component.find("workspace");
        workspaceAPI.getFocusedTabInfo().then(function(response) {
            workspaceAPI.focusTab({tabId : snapTab});
            workspaceAPI.closeTab({tabId: currentid});
        }).catch(function(error) {
            console.log(error);
        });
         helper.showToastMessage("Success!","The referral has been created sucessfully.", "success", "dismissible", "10000");
        var appEvent = $A.get("e.c:ACET_CreateSRN_RecordCreatedEvent");
        appEvent.setParams({
            "SRNNumber": component.get("v.createdReferralNumber"),
            "memberTabId" : component.get("v.memberTabId"),
            "isReferral" : true
        });
        appEvent.fire();
       
    },
    closeTab : function(component,event,helper){
        
    },
})