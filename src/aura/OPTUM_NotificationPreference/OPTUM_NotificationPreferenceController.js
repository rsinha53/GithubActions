({
    updateData : function(component, event, helper) {
       component.set("v.accountList",event.getParam("accountList"));
       component.set("v.rowIndex",event.getParam("index"));
       component.set("v.accountType", event.getParam("accountType"));
       component.set("v.faroId", event.getParam("faroId"));
       helper.notifications(component, event, helper);
    }
})