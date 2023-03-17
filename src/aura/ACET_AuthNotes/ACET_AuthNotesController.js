({
    //US2061071 
    doInit: function (cmp, event, helper) {
        setTimeout(function () {
            helper.initAuthTable(cmp, helper);
        }, 1000);
    },
    chevToggle : function(component, event, helper) {
        if(component.get('v.toggleName') == 'slds-show'){
            component.set("v.toggleName", "slds-hide");
        }
        else{
            component.set("v.toggleName", "slds-show");
        }
    },
})