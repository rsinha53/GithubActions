({
    //US2584896 - Snapshot - Financials - As of Date E&I - Sravan
    //US2584899 - Snapshot - Financials - As of Date M&R - Sravan
    doInit: function(component, event, helper){
        try{
            var today = $A.localizationService.formatDate(new Date(), "YYYY-MM-DD");
            component.set('v.today', today);
            if(!$A.util.isUndefinedOrNull(component.get("v.eligibleDate")) && !$A.util.isEmpty(component.get("v.eligibleDate"))){
               helper.checkValidDate(component, event, helper);
            }
        } catch(exception) {
            console.log(' In Financial Card Exception ');
        }
    },

    onRefresh: function(cmp,event,helper){
        cmp.set('v.clickRefresh',!cmp.get('v.clickRefresh'));
    },

    //US2584896 - Snapshot - Financials - As of Date E&I - Sravan
    //US2584899 - Snapshot - Financials - As of Date M&R - Sravan
    handleSearch : function(component, event, helper) {
        var asOfDate = component.get("v.today");
        var inputDateField = component.find("inputDateField");
        var sourceCode = component.get("v.highlightedPolicySourceCode");
        var eligibleDate = component.get("v.eligibleDate");
        if(sourceCode == 'CO' || sourceCode == 'CS'){
            if(!$A.util.isUndefinedOrNull(asOfDate) && !$A.util.isEmpty(asOfDate)){
                if(!$A.util.isUndefinedOrNull(eligibleDate) && !$A.util.isEmpty(eligibleDate)){
                    var policyDates =  eligibleDate.split("-");
                    var policyStartDate = policyDates[0];
                    var policyEndDate = policyDates[1];
                    //To check whether the as of date is greater than start date
                    var startDateCheck = helper.dateComparator(component,policyStartDate,asOfDate,'LESSER THAN',true);
                    //To check whether the as of date is lesser than end date
                    var endDateCheck = helper.dateComparator(component,policyEndDate,asOfDate,'GREATER THAN',true);
                    if(startDateCheck ||endDateCheck){
                        inputDateField.setCustomValidity('Date outside the selected policy eligible dates, select corresponding policy line.');
                        inputDateField.reportValidity();
                    }
                    else{
                        inputDateField.setCustomValidity('');
                        inputDateField.reportValidity();

                    }
                }
            }
        }

    },
    onChange : function(component, event, helper){
        //Resetting the values on change of policy
        component.set("v.notWithInEligibleDates",false);
        var inputDateField = component.find("inputDateField");
        inputDateField.setCustomValidity('');
        inputDateField.reportValidity();
        component.set("v.today",$A.localizationService.formatDate(new Date(), "YYYY-MM-DD"));
        helper.checkValidDate(component, event, helper);
    }
})