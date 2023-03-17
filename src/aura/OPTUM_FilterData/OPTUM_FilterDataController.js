({
    showResults: function(component, event, helper) {
        helper.showResult(component, event, helper);
    },
    clear: function(component, event, helper) {
        helper.clearFilters(component, event, helper);
    },
    reset: function(component, event, helper) {
        helper.ResetData(component, event, helper);
    },
    callShowfilter: function(component, event, helper) {
        helper.showFilter(component, event, helper);
    },
})