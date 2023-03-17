({
    doinit: function(component, event, helper) {
        component.set("v.accountList",event.getParam("accountList"));
        component.set("v.rowIndex",event.getParam("index"));
        component.set("v.accountType", event.getParam("accountType"));
        console.log("External Accounts Synthticid" + component.get("v.accountList[0].syntheticId"));
        var sid= component.get("v.accountList[0].syntheticId");
        component.set("v.Syntheticid",sid);
        helper.getexternalaccounts(component, event, helper);
       
    }    
   
})