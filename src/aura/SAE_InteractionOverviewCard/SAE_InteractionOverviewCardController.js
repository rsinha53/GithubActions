({
	myAction : function(component, event, helper) {
		
	},

	// US2931847 - TECH - Sanka
	// US3504373	Unable to Determine  Policy - Save Case - Sarma - 05th May 2021 - Disable link during policy restriction
	headerClick: function (cmp, event, helper) {
		if(cmp.get("v.isShowComponentBasedOnExclusions")){
            var headerClick = cmp.getEvent("headerClick");
            headerClick.setParams({
                "data": cmp.get("v.interactionCard")
            });
            headerClick.fire();

            // DE492760 - Thanish - 23rd Sept 2021
            var caseNotSavedTopics = cmp.get("v.caseNotSavedTopics");
            if(!caseNotSavedTopics.includes("Provider Lookup")){
                caseNotSavedTopics.push("Provider Lookup");
            }
            cmp.set("v.caseNotSavedTopics", caseNotSavedTopics);
	    }
	},

	//  US2728364: Auto Doc: Member Snapshot - Have Provider Card Included in Eligibility Auto Doc Automatically - Krish - 6th July 2021
	setAutodoc: function(cmp, event, helper){

        var interactionCard = cmp.get("v.interactionCard");
        if(!$A.util.isUndefinedOrNull(interactionCard) && !$A.util.isEmpty(interactionCard)){
            helper.setAutodocCardData(cmp);
        }
    }
})