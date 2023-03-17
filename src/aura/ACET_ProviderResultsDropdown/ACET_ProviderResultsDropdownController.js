({
	handleProviderSearchResultsChange: function (cmp, event) {
		cmp.set("v.filteredProviderSearchResults", event.getParam("value"));
		cmp.set("v.selectedProviderDetails", null);
		var providerDetails = cmp.get("v.providerDetails");
		providerDetails.isValidProvider = false;
		/* providerDetails.isProviderNotFound = false;
		providerDetails.isNoProviderToSearch = false;
		providerDetails.isOther = false;*/
		cmp.set("v.providerDetails", providerDetails); 
		cmp.find("providerResultsDropDownAI").set("v.value", "");
		if ($A.util.isEmpty(event.getParam("value"))) {
			cmp.set("v.showProviderDropdown", false);
		} else {
			cmp.set("v.showProviderDropdown", true);
		}
	},

	openProviderDropdown: function (cmp) {
		if (!$A.util.isEmpty(cmp.get("v.filteredProviderSearchResults"))) {
			cmp.set("v.showProviderDropdown", true);
		}
	},

	filterProviderSearch: function (cmp, event) {
		var providerSearchResults = cmp.get("v.providerSearchResults");
		if (!$A.util.isEmpty(providerSearchResults)) {
			var filteredProviderSearchResults = providerSearchResults.filter(function (providerRecord) {
				return providerRecord.physicianFacilityInformation.facilityName.toLowerCase().includes(event.getSource().get("v.value").toLowerCase()) ||
					(providerRecord.physicianFacilityInformation.firstName + ' ' + providerRecord.physicianFacilityInformation.lastName).toLowerCase().includes(event.getSource().get("v.value").toLowerCase()) ||
					providerRecord.physicianFacilityInformation.taxId.taxId.toLowerCase().includes(event.getSource().get("v.value").toLowerCase());
			});
			if ($A.util.isEmpty(filteredProviderSearchResults)) {
				cmp.set("v.filteredProviderSearchResults", providerSearchResults);
			} else {
				cmp.set("v.filteredProviderSearchResults", filteredProviderSearchResults);
			}
		}
	},

	selectProvider: function (cmp, event) {
		cmp.set("v.selectedProviderDetails", cmp.get("v.filteredProviderSearchResults")[event.currentTarget.getAttribute("data-row-index")]);
		cmp.set("v.showProviderDropdown", false);
		var providerDetails = cmp.get("v.providerDetails");
		providerDetails.isValidProvider = true;
		providerDetails.isProviderNotFound = false;
		providerDetails.isNoProviderToSearch = false;
		providerDetails.isOther = false;
		cmp.set("v.providerDetails", providerDetails);
	},

})