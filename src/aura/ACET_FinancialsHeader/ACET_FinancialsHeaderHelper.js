({

    //US2584896 - Snapshot - Financials - As of Date E&I - Sravan
    //US2584899 - Snapshot - Financials - As of Date M&R - Sravan
    dateComparator : function(component,policyDate,asOfDate,comparator,splitDate) {
        var policyDateAttributes = policyDate.split("/");
        var asOfDateAttributes;
        if(splitDate){
            asOfDateAttributes = asOfDate.split("-");
        }
        else{
            asOfDateAttributes = asOfDate;
        }

        var policyDateForComparison;
        var asOfDateForComparison;
        var returnVal = false;
        if(!$A.util.isUndefinedOrNull(policyDateAttributes) && !$A.util.isEmpty(policyDateAttributes)){
            var policyDateMonth = policyDateAttributes[0] - 1;
            var policyDateDay = policyDateAttributes[1];
            var policyDateYear = policyDateAttributes[2];
            policyDateForComparison = new Date(policyDateYear,policyDateMonth,policyDateDay);
        }
        if(!$A.util.isUndefinedOrNull(asOfDateAttributes) && !$A.util.isEmpty(asOfDateAttributes)){
            var asOfDateYear = splitDate ? asOfDateAttributes[0] : asOfDateAttributes.getFullYear();
            var asOfDateMonth = splitDate ? asOfDateAttributes[1] - 1 : asOfDateAttributes.getMonth();
            var asOfDateDay = splitDate ? asOfDateAttributes[2] : asOfDateAttributes.getDate();
            asOfDateForComparison = new Date(asOfDateYear,asOfDateMonth,asOfDateDay);
        }
        console.log('policyDateForComparison'+ policyDateForComparison);
        console.log('asOfDateForComparison'+ asOfDateForComparison);
        if(comparator == 'LESSER THAN'){
            if(policyDateForComparison > asOfDateForComparison){
                returnVal = true
            }
        }
        else if(comparator == 'GREATER THAN'){
            if(policyDateForComparison < asOfDateForComparison){
               returnVal = true;
            }
        }
        return returnVal;
    },

    //US2584896 - Snapshot - Financials - As of Date E&I - Sravan
    //US2584899 - Snapshot - Financials - As of Date M&R - Sravan
    checkValidDate: function(component, event, helper){
            var policyStatus = component.get("v.policyStatus");
            var planStatus = '';
            if(policyStatus == 'true'){
                planStatus = 'ACTIVE';
            }
            else{
                planStatus = 'IN-ACTIVE';
            }
            if(planStatus == 'IN-ACTIVE'){
            var count = 0;
            var eligible = true;
            var sourceCode = component.get("v.highlightedPolicySourceCode");
            if(sourceCode == 'CO'){
                count = 1825;
                component.set("v.defaultMessage",false);
            }
            else if(sourceCode == 'CS'){
                count = 365;
                component.set("v.defaultMessage",true);
            }
            else if(sourceCode == 'AP'){
                eligible = false;
            }
            if(eligible){
    			var priorDate = new Date();
    			console.log('Prior Date'+ priorDate);
                var eligibleDate = component.get("v.eligibleDate");
                console.log('Init Eligible Date'+ eligibleDate);
                if(!$A.util.isUndefinedOrNull(eligibleDate) && !$A.util.isEmpty(eligibleDate)){
                    var policyDates =  eligibleDate.split("-");
                    var policyEndDate = policyDates[1];
                    var month = priorDate.getMonth()+1;
                    var asOfDate = priorDate.getFullYear()+'/'+month+'/'+priorDate.getDate();
                    var asOfDateForComparison = new Date(asOfDate);
                    var policyEndDateForComparison = new Date(policyEndDate);
                    console.log('policyEndDateForComparison'+ policyEndDateForComparison);
                    console.log('asOfDateForComparison'+ asOfDateForComparison);
                    var diffTime = Math.abs(policyEndDateForComparison - asOfDateForComparison);
                    var diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24));
                    console.log("milliseconds"+ diffTime);
                    console.log("days" + diffDays);
                    if(diffDays > count){
                        component.set("v.notWithInEligibleDates",true);
                    }
                    else{
                        component.set("v.notWithInEligibleDates",false);
                    }

                }
            }
        }
    }

})