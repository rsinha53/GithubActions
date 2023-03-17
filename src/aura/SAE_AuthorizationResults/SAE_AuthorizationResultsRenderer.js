({
	afterRender: function (cmp,  helper) {
		this.superAfterRender();

		//US2253899
		let tabUniqueId = cmp.get("v.tabUniqueId");
		let setOpenedTabs = cmp.get("v.OpenedTabIdSet");
		//Duplicate Tab Check
		if ($A.util.isUndefinedOrNull(setOpenedTabs)) {
			setOpenedTabs = new Set();
		}
		if (!$A.util.isUndefinedOrNull(tabUniqueId) && !setOpenedTabs.has(tabUniqueId)) {
			setOpenedTabs.add(tabUniqueId);
			cmp.set("v.OpenedTabIdSet", setOpenedTabs);
			helper.findAuthorizationResults(cmp,  helper);
			// US2566675 FF - Create SRN Button Functionality with Error ICUE is Down - Enhancements - Sarma
			helper.getDowntimFormDetails(cmp, helper);
		}
		
	}
})