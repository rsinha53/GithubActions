({
    doInit : function(component, event, helper) {
        helper.ssnFormat(component , event ,helper);
        helper.dateFormat(component , event ,helper);
        helper.employeDetails(component , event , helper);
        helper.getMiddleName(component, event, helper);
        helper.setAutodocCardData(component, event, helper);
    },
	provDataChange: function(cmp) {
        var childComponent = cmp.find("memberDetails");
        childComponent.autodocByDefault();
    }
})