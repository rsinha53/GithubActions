({
    showResult: function(component, event, helper) {
        component.set("v.showError", true);
        var cmpEvent = component.getEvent("OPTUM_FilterDataEvent");
        cmpEvent.setParams({
            "Start_Date": component.get("v.Start_Date")
        });
        cmpEvent.setParams({
            "End_Date": component.get("v.End_Date")
        });
        cmpEvent.setParams({
            "minAmountVal": component.get("v.minAmountVal")
        });
        cmpEvent.setParams({
            "maxAmountVal": component.get("v.maxAmountVal")
        });
        cmpEvent.setParams({
            "status": component.get("v.selectedValue")
        });
        cmpEvent.setParams({
            "receiptStatus": component.get("v.receiptStatusselectedValue")
        });
        cmpEvent.fire();
    },
    clearFilters: function(component, event, helper) {
        helper.clearFilterValues(component, event, helper);
        component.set("v.showfilter", false);
    },
    clearFilterValues: function(component, event, helper) {
        component.set("v.Start_Date", "");
        component.set("v.End_Date", "");
        component.set("v.minAmountVal", "");
        component.set("v.maxAmountVal", "");
        component.set("v.receiptStatusselectedValue", "Select a value");
        component.set("v.selectedValue", "Select a value");
        component.set("v.showError", false);
    },
    ResetData: function(component, event, helper) {
        helper.clearFilterValues(component, event, helper);
        component.set('v.isVisible', false);
        component.set('v.isVisible', true);
        var cmpEvent = component.getEvent("OPTUM_ResetDataEvent");
        cmpEvent.setParams({
            "resetData": component.get("v.resData")
        });
        cmpEvent.fire();
    },
    showFilter: function(component, event, helper) {
        if (component.get("v.showfilter") == true) {
            component.set("v.showfilter", false);
        } else {
            component.set("v.showfilter", true);
        }
    },
})