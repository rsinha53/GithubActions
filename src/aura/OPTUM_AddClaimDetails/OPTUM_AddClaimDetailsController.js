({
    getData: function(component, event, helper) {
        helper.fetchData(component, event, helper);
    },
    onChange: function(component, event, helper) {
        component.set("v.flag", false);
    },
})