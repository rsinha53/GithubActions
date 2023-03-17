({
    doInit: function(component, event, helper) {
        var newaccount = component.get('v.AccShortName');
        helper.updateContributions(component,event,helper,newaccount);
    },
    // check account dynamically : US2693051 - Sunil Vennam
    chkAccount : function(component, event, helper) {
       var newAccount = event.getParam("value");
        console.log('modified account name'+newAccount);
        helper.updateContributions(component,event,helper,newAccount);
    },
})