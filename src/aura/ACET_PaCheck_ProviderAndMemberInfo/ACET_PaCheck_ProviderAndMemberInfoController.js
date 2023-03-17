({
	doInit : function(component, event, helper){
		helper.getProviderNotificationTool(component, event, helper);
	},
    onMemberInfoChange : function(cmp,event,helper){
       helper.processMemberInfo(cmp,event,helper);
    },
    /*togglePopup : function(cmp, event) {
        let showPopup = event.currentTarget.getAttribute("data-popupId");
        var tooltip = document.getElementById(showPopup);
        tooltip.style.left = tooltip.dataset.left + "px";
    },*/
	generateSessionData : function(cmp, event, helper){

		// US3089172	Plan Benefits: Benefit Check with PA Button Search DataPopulation
		if(!cmp.get('v.isDataPopulated')){

			let providerInfo = {
				"servicingProvider" : "--",
				"npi" : "--",
			}

			var interactionOverviewData = _setAndGetSessionValues.getInteractionDetails(cmp.get("v.interactionOverviewTabId"));
			JSON.parse(JSON.stringify(interactionOverviewData));
			var providerDetails = interactionOverviewData.providerDetails;
	 
			if(!$A.util.isEmpty(providerDetails.firstName)){
				providerInfo.servicingProvider = providerDetails.firstName + ' ' + providerDetails.lastName;

			} else if(!$A.util.isEmpty(providerDetails.lastName)){
				providerInfo.servicingProvider =  providerDetails.lastName;
			}

			// if NPI available should take that, else only conisder TAX ID
			if(!$A.util.isEmpty(providerDetails.npi) && providerDetails.npi != '--'){
				providerInfo.npi = providerDetails.npi;
			} else if(!$A.util.isEmpty(providerDetails.taxId)){
				providerInfo.npi = providerDetails.taxId;
			}

			// US3089172	Plan Benefits: Benefit Check with PA Button Search DataPopulation
			cmp.set('v.isDataPopulated',true)
			cmp.set('v.providerInfo',providerInfo);
		}
    },
	//US3487597 - Sravan - Start
	handleProvideNGT : function(component, event,helper){
		var providerNotificationTool = component.get("v.providerNotificationTool");
        if(!$A.util.isUndefinedOrNull(providerNotificationTool) && !$A.util.isEmpty(providerNotificationTool)){
            window.open(providerNotificationTool, '_blank');
        }
	}
	//US3487597 - Sravan - End
})