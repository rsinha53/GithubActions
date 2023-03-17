({

	//Added by Vinay for E and I Sorting
	sortBy: function (component, field, fieldObject) {
		var eiList = component.get("v.eAndIContractData");
		var sortAsc = component.get("v.sortAsc"),
			sortField = component.get("v.sortField"),
			records = eiList.processed;

		sortAsc = sortField != field || !sortAsc;
		if (!$A.util.isEmpty(records)) {
			records.sort(function (a, b) {
				a = a[fieldObject];
				b = b[fieldObject];
				var t1 = a[field] == b[field],
					t2 = (!a[field] && b[field]) || (a[field] < b[field]);
				return t1 ? 0 : (sortAsc ? -1 : 1) * (t2 ? 1 : -1);
			});
		}
		component.set("v.sortAsc", sortAsc);
		component.set("v.sortField", field);
		component.set("v.eAndIContractData.processed", records);
		component.set("v.eAndIContractData.display", records.slice(0, 11));
	},

	//for C And S tab sorting
	sortByCNS: function (component, field, fieldObject) {
		var eiList = component.get("v.cAndSContractData");
		var sortAsc = component.get("v.sortAsc"),
			sortField = component.get("v.sortField"),
			records = eiList.filtered;

		sortAsc = sortField != field || !sortAsc;
		if (!$A.util.isEmpty(records)) {
			records.sort(function (a, b) {
				a = a[fieldObject];
				b = b[fieldObject];
				var t1 = a[field] == b[field],
					t2 = (!a[field] && b[field]) || (a[field] < b[field]);
				return t1 ? 0 : (sortAsc ? -1 : 1) * (t2 ? 1 : -1);
			});
		}
		component.set("v.sortAsc", sortAsc);
		component.set("v.sortField", field);
		component.set("v.cAndSContractData.filtered", records);
		component.set("v.cAndSContractData.display", records.slice(0, 11));
	},

	//for M And R tab sorting
	sortByMNR: function (component, field, fieldObject) {
		var eiList = component.get("v.mAndRContractData");
		var sortAsc = component.get("v.sortAsc"),
			sortField = component.get("v.sortField"),
			records = eiList.processed;

		sortAsc = sortField != field || !sortAsc;
		if (!$A.util.isEmpty(records)) {
			records.sort(function (a, b) {
				a = a[fieldObject];
				b = b[fieldObject];
				var t1 = a[field] == b[field],
					t2 = (!a[field] && b[field]) || (a[field] < b[field]);
				return t1 ? 0 : (sortAsc ? -1 : 1) * (t2 ? 1 : -1);
			});
		}
		component.set("v.sortAsc", sortAsc);
		component.set("v.sortField", field);
		component.set("v.mAndRContractData.processed", records);
		component.set("v.mAndRContractData.display", records.slice(0, 11));
	},

	// filter contract summary
	filter: function (cmp, unfilteredList) {
		let filteredList;
        if(!$A.util.isEmpty(unfilteredList)){
		let searchText = cmp.find("searchBox").get("v.value").toLowerCase().trim();

		if ($A.util.isEmpty(searchText)) {
			filteredList = unfilteredList;
		} else {
			filteredList = unfilteredList.filter(function (obj, index) {
				return JSON.stringify(Object.values(obj.contractSummary)).toLowerCase().includes(searchText);
			});
		}
        }
		return filteredList;
	},

	// filter only active contract summary
	filterActiveData: function (isActive, unfilteredList) {
        if(!$A.util.isEmpty(unfilteredList)){
		if (isActive) {
			return unfilteredList.filter(function (obj) { return obj.contractSummary.status; });
		}
        }
		return unfilteredList;
	},

	filterENIAccordingToMember: function(cmp, unfilteredList) {
        if(!$A.util.isEmpty(unfilteredList)){
		if(!cmp.get("v.isENIAll")) {
			if(cmp.get("v.isMemberFocused")) {
				let filterParameters = cmp.get("v.filterParameters");
				return unfilteredList.filter(function (obj) {
					let marketSite = obj.contractSummary.marketNumber.split("-");
					return (filterParameters.productType==obj.contractSummary.product || parseInt(filterParameters.marketSite)==parseInt(marketSite[0]) || filterParameters.marketType==obj.contractSummary.marketType);
				});
			} else {
				return this.filterActiveData(true, unfilteredList);
			}
		}
        }
		return unfilteredList;
	},

	filterMNRAccordingToMember: function(cmp, unfilteredList) {
        if(!$A.util.isEmpty(unfilteredList)){
		if(!cmp.get("v.isMNRAll")) {
			if(cmp.get("v.isMemberFocused")) {
				let filterParameters = cmp.get("v.filterParameters");
				return unfilteredList.filter(function (obj) {
					return (filterParameters.cosmosDiv==obj.contractSummary.div || filterParameters.cosmosPanelNbr==obj.contractSummary.panel);
				});
			} else {
				return this.filterActiveData(true, unfilteredList);
			}
		}
        }
		return unfilteredList;
	},

	getCNSContractData: function(cmp) {
		// show spinner
		cmp.set("v.showSpinner", true);
		// get provider details
		let parameters = cmp.get("v.contractApiParameters");

		let action = cmp.get("c.getCAndSContractsData");
		action.setParams({
			"providerId": parameters.providerId,
			"taxId": parameters.taxId,
			"addressId": parameters.addressId,
			"isActive": false
		});
		action.setCallback(this, function (response) {

			if (response.getState() === "SUCCESS") {
				let cnsContractDetails = response.getReturnValue();

				if(!$A.util.isEmpty(cnsContractDetails) && cnsContractDetails.length > 0){
					if(cnsContractDetails[0].Success){
						let filtered = this.filterActiveData(!cmp.get("v.isCNSAll"), cnsContractDetails);
							let cAndSContractData = {
								"display": filtered.slice(0, 11),
								"filtered": filtered,
							"unfiltered": cnsContractDetails
							};
							cmp.set("v.cAndSContractData", cAndSContractData);
							cmp.set("v.cnsTableIsEmpty", false);
						} else {
							let toastEvent = $A.get("e.force:showToast");
							toastEvent.setParams({
								"title": "Error!",
							"message": "Failed to retrieve C&S Contract Data! : " + cnsContractDetails[0].Message,
								"type": "error",
								"mode": "pester",
								"duration": "10000"
							});
							toastEvent.fire();
							// no contract data to this provider due to some exception in server
							cmp.set("v.cnsTableIsEmpty", true);
						}
					} else {
					cmp.set("v.cnsTableIsEmpty", true);
				}

			} else {
				let toastEvent = $A.get("e.force:showToast");
				toastEvent.setParams({
					"title": "Error!",
					"message": "Failed to retrieve C&S Contract Data!",
					"type": "error",
					"mode": "pester",
					"duration": "10000"
				});
				toastEvent.fire();
				// no contract data to this provider due to some exception in server
						cmp.set("v.cnsTableIsEmpty", true);
					}
			// hide spinner
			cmp.set("v.showSpinner", false);
		});
		$A.enqueueAction(action);
	},

	getENIContractData: function(cmp) {
		// show spinner
		cmp.set("v.showSpinner", true);
		// get provider details
		let parameters = cmp.get("v.contractApiParameters");

		let action = cmp.get("c.getEAndIContractsData");
		action.setParams({
			"providerId": parameters.providerId,
			"taxId": parameters.taxId,
			"addressSeq": parameters.addressSeq, // US2696849 - Thanish - 22nd Jul 2020
			"isActive": false
		});
		action.setCallback(this, function (response) {
			if(response.getState() === "SUCCESS") {
				let eniContractDetails = response.getReturnValue();

				if(!$A.util.isEmpty(eniContractDetails) && eniContractDetails.length > 0){
					if(eniContractDetails[0].Success){
						let filtered = this.filterActiveData(true, eniContractDetails);
						let processed;
						if(cmp.get("v.isENIAll")){
							processed = eniContractDetails;
						} else {
							processed = this.filterENIAccordingToMember(cmp, filtered);
						}

							let eAndIContractData = {
							"display": processed.slice(0, 11),
							"processed": processed,
								"filtered": filtered,
							"unfiltered": eniContractDetails
							};
							cmp.set("v.eAndIContractData", eAndIContractData);
							cmp.set("v.eniTableIsEmpty", false);
						} else {
							let toastEvent = $A.get("e.force:showToast");
							toastEvent.setParams({
								"title": "Error!",
							"message": "Failed to retrieve E&I Contract Data! : " + eniContractDetails[0].Message,
								"type": "error",
								"mode": "pester",
								"duration": "10000"
							});
							toastEvent.fire();
							// no contract data to this provider due to some exception in server
							cmp.set("v.eniTableIsEmpty", true);
						}
					} else {
						cmp.set("v.eniTableIsEmpty", true);
					}

						} else {
							let toastEvent = $A.get("e.force:showToast");
							toastEvent.setParams({
								"title": "Error!",
					"message": "Failed to retrieve E&I Contract Data!",
								"type": "error",
								"mode": "pester",
								"duration": "10000"
							});
							toastEvent.fire();
							// no contract data to this provider due to some exception in server
				cmp.set("v.eniTableIsEmpty", true);
						}
			// hide spinner
			cmp.set("v.showSpinner", false);
		});
		$A.enqueueAction(action);
	},

	getMNRContractData: function(cmp) {
		// show spinner
		cmp.set("v.showSpinner", true);
		// get provider details
		let parameters = cmp.get("v.contractApiParameters");

		let action = cmp.get("c.getMAndRContractsData");
		action.setParams({
			"providerId": parameters.providerId,
			"taxId": parameters.taxId,
			"addressId": parameters.addressId, // US2696849 - Thanish - 22nd Jul 2020
			"isActive": false
		});
		action.setCallback(this, function (response) {
			if(response.getState() === "SUCCESS") {
				let mnrContractDetails = response.getReturnValue();

				if(!$A.util.isEmpty(mnrContractDetails) && mnrContractDetails.length > 0){
					if(mnrContractDetails[0].Success){
						let filtered = this.filterActiveData(true, mnrContractDetails);
						let processed;
						if(cmp.get("v.isMNRAll")){
							processed = mnrContractDetails;
					} else {
							processed = this.filterMNRAccordingToMember(cmp, filtered);
					}

						let mAndRContractData = {
							"display": processed.slice(0, 11),
							"processed": processed,
							"filtered": filtered,
							"unfiltered": mnrContractDetails
						};
						cmp.set("v.mAndRContractData", mAndRContractData);
						cmp.set("v.mnrTableIsEmpty", false);
				} else {
					let toastEvent = $A.get("e.force:showToast");
					toastEvent.setParams({
						"title": "Error!",
							"message": "Failed to retrieve M&R Contract Data! : " + mnrContractDetails[0].Message,
						"type": "error",
						"mode": "pester",
						"duration": "10000"
					});
					toastEvent.fire();
					// no contract data to this provider due to some exception in server
						cmp.set("v.mnrTableIsEmpty", true);
					}
				} else {
					cmp.set("v.mnrTableIsEmpty", true);
				}

			} else {
				let toastEvent = $A.get("e.force:showToast");
				toastEvent.setParams({
					"title": "Error!",
					"message": "Failed to retrieve M&R Contract Data!",
					"type": "error",
					"mode": "pester",
					"duration": "10000"
				});
				toastEvent.fire();
				// no contract data to this provider due to some exception in server
				cmp.set("v.mnrTableIsEmpty", true);
			}
			// hide spinner
			cmp.set("v.showSpinner", false);
		});
		$A.enqueueAction(action);
	}

})