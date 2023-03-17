({
    doInit : function(component, event, helper) {
        helper.getUserDetail(component, event);
        helper.getReactiveRPRec(component, event);
        helper.getProactiveRPRec(component, event);
        
    },
    
    sortByCD : function(component, event, helper) {
        helper.sortBy(component, "CreatedDate");
    },
    sortBypastDays : function(component, event, helper) {
        helper.sortBy(component, "Days_Past_SLA__c");
    },
    
})