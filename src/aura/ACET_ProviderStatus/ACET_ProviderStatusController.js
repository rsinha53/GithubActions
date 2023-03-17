({
	toggleSection: function (component, event, helper) {
		var sectionAuraId = event.target.getAttribute("data-auraId");
		var sectionDiv = component.find(sectionAuraId).getElement();
  
		var sectionState = sectionDiv.getAttribute('class').search('slds-is-open');
  
		if (sectionState == -1) {
			sectionDiv.setAttribute('class', 'slds-section slds-is-open');

			switch(component.get("v.sourceCode")) {
				case 'CO':
					if($A.util.isEmpty(component.get("v.mnrProviderStatus"))){
						helper.getMAndRProviderStatus(component);
					}
				  	break;
				case 'CS':
					if($A.util.isEmpty(component.get("v.eniProviderStatus"))){
						helper.getEAndINewProviderStatus(component,helper);
					}
					break;
				case 'AP':
					if($A.util.isEmpty(component.get("v.cspProviderStatus"))){
						helper.getCSPProviderStatus(component);
					}
				  	break;
				default:
			}
		} else {
			sectionDiv.setAttribute('class', 'slds-section slds-is-close');
		}
	},

	selectAll: function (cmp, event) {
		var providerStatus;
		var cardDetails;
		var sourceCode = cmp.get("v.sourceCode");

		if(sourceCode == "CO"){
			providerStatus = cmp.get("v.mnrProviderStatus");
			cardDetails = cmp.get("v.mnrProviderStatus.mnrCardDetails");
		} else if(sourceCode == "CS"){
			providerStatus = cmp.get("v.eniProviderStatus");
			cardDetails = cmp.get("v.eniProviderStatus.eniCardDetails");
        } else if(sourceCode == "AP") {
            providerStatus = cmp.get("v.cspProviderStatus");
			cardDetails = cmp.get("v.cspProviderStatus.mnrCardDetails");
		}
		if(!$A.util.isEmpty(cardDetails)){
			for(var i=0; i<cardDetails.cardData.length; i++){
				if(event.getSource().get("v.checked")){
					cardDetails.cardData[i].checked = true;
				} else{
					cardDetails.cardData[i].checked = false;
				}
			}
		}

		_autodoc.setAutodoc(cmp.get("v.autodocUniqueId"), cmp.get("v.autodocUniqueIdCmp"), cardDetails);
		if(sourceCode == "CO"){
			providerStatus.mnrCardDetails = cardDetails;
			cmp.set("v.mnrProviderStatus", providerStatus);
		} else if(sourceCode == "CS"){
			providerStatus.eniCardDetails = cardDetails;
			cmp.set("v.eniProviderStatus", providerStatus);
        } else if(sourceCode == "AP") {
            providerStatus.mnrCardDetails = cardDetails;
			cmp.set("v.cspProviderStatus", providerStatus);
		}
	}
})