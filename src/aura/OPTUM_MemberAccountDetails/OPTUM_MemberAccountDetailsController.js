({  
    
    updateData: function(component, event, helper) {
        
		//DE432638 Autodoc selection stays in memory
		component.set("v.autodocUniqueId", event.getParam("autodocUniqueId"));
        component.set("v.autodocUniqueIdCmp", event.getParam("autodocUniqueIdCmp"));
        
        component.set("v.accountList",event.getParam("accountList"));
        component.set("v.rowIndex",event.getParam("index"));
        component.set("v.accountType", event.getParam("accountType"));
        helper.getAccountDetails(component , event ,helper);
        helper.fireEvent(component , event ,helper);
        
    },
    
    handleActive: function(component, event, helper) {
        var tab = event.getSource();
        var tabID = tab.get('v.id');
        if(tabID=='Account Details'){
           helper.injectComponent('c:OPTUM_AccountDetailsTab', tab);
        }
       helper.fireSwitchTabEvent(component , event ,helper);
        helper.getAccountDetails(component , event ,helper);    
        // helper.dateFormat(component , event ,helper);
    },
  
})