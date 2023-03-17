({
    doInit: function(cmp, event, helper) {
        var pageReference = cmp.get("v.pageReference");
        helper.getFocusedTabIdHelper(cmp, event);
        cmp.set('v.documentID',pageReference.state.docID);
        cmp.set('v.memberTabId',pageReference.state.memberTabId);
        cmp.set('v.iframeUrl',pageReference.state.iframeUrl);   
        
        var action = cmp.get('c.getEDMSLink');

        action.setCallback(this, function (response) {
            var state = response.getState(); // get the response state
            if (state == 'SUCCESS') {
                var result = response.getReturnValue();
                //if (result.statusCode == 200) {                    
                    cmp.set("v.endPointEDMS",result.endPointURL);
                    console.log(cmp.get("v.endPointEDMS"));
               /* } else { //if (result.statusCode == 500 ) 
                    
                } */
            }
            
        });
        $A.enqueueAction(action); 
        
    },
    
	onEDMSTabClosed : function(cmp, event, helper) {
        var closedTabId = event.getParam('tabId');
        if (closedTabId == cmp.get("v.currentTabId")) {
            var appEvent = $A.get("e.c:ACET_EDMSClosedTabEvent");
            let mapSubTabID = new Map();
            mapSubTabID.set(cmp.get('v.documentID'),closedTabId);
            console.log(mapSubTabID);
            if(appEvent != undefined){
                appEvent.setParams({
                    "memberTabId": cmp.get('v.memberTabId'),
                    "docID": cmp.get("v.documentID"),
                    "subTabID": closedTabId,
                    "documentTabID" : cmp.get("v.documentTabID")
                });
                appEvent.fire();
            }
        }
	}
})