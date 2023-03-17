({
    setFilterCondition : function(component, event, helper) {
        console.log(' inside Issue filter condition ');
        let objInterval = setInterval(function() {
            try {
            component.find('idServiceRequest').getFilterConditionForIssue(component.get("v.whereTTSTopics"));
            clearInterval(objInterval);
            } catch(exception) {
                clearInterval(objInterval);
                console.log(' exception ' + exception);
            }
        }, 500);
    }
})