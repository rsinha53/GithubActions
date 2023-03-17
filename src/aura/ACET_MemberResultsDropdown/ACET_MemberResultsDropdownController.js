({
	handleMemberSearchResultsChange: function (cmp, event) {

		console.log(JSON.parse(JSON.stringify(event.getParam("value"))));
		console.log(JSON.parse(JSON.stringify(cmp.get("v.findIndividualSearchResults"))));
		var memberDetails = cmp.get("v.memberDetails");
		console.log(JSON.parse(JSON.stringify(cmp.get("v.memberDetails"))));
		if (Array.isArray(cmp.get("v.memberDetails"))) {
			alert('test!!');
			cmp.set("v.filteredFindIndividualSearchResults", (event.getParam("value")));
		} else {
			cmp.set("v.filteredFindIndividualSearchResults", event.getParam("value"));
		}
		cmp.set("v.selectedIndividualMemberDetails", null);
		cmp.find("memberResultsDropDownAI").set("v.value", "");
		if ($A.util.isEmpty(event.getParam("value"))) {
			cmp.set("v.showMemberDropdown", false);
		} else {
			cmp.set("v.showMemberDropdown", true);
		}
	},

	openMemberDropdown: function (cmp) {
		if (!$A.util.isEmpty(cmp.get("v.filteredFindIndividualSearchResults"))) {
			cmp.set("v.showMemberDropdown", true);
		}
	},

	filterMemberSearch: function (cmp, event) {
		var findIndividualSearchResults = cmp.get("v.findIndividualSearchResults");
		if (!$A.util.isEmpty(findIndividualSearchResults)) {
			var inputValue = event.currentTarget.value;
			var filteredFindIndividualSearchResults = findIndividualSearchResults.filter(function (memberRecord) {
				return memberRecord.firstName.toLowerCase().includes(inputValue.toLowerCase()) ||
					memberRecord.lastName.toLowerCase().includes(inputValue.toLowerCase()) ||
					memberRecord.sourceSysCode.toLowerCase().includes(inputValue.toLowerCase()) ||
					memberRecord.birthDate.includes(inputValue);
			});
			if ($A.util.isEmpty(filteredFindIndividualSearchResults)) {
				cmp.set("v.filteredFindIndividualSearchResults", findIndividualSearchResults);
			} else {
				cmp.set("v.filteredFindIndividualSearchResults", filteredFindIndividualSearchResults);
			}
		}
	},

	selectMember: function (cmp, event) {
		cmp.set("v.selectedIndividualMemberDetails", cmp.get("v.filteredFindIndividualSearchResults")[event.currentTarget.getAttribute("data-row-index")]);
		cmp.set("v.showMemberDropdown", false);
		var memberDetails = cmp.get("v.memberDetails");
		memberDetails.isFindIndividualSearch = true;
		memberDetails.isValidMember = false;
		memberDetails.isMemberNotFound = false;
		memberDetails.isNoMemberToSearch = false;
        //US3612768 - Sravan - Start
        memberDetails.subjectName = cmp.get("v.filteredFindIndividualSearchResults")[event.currentTarget.getAttribute("data-row-index")].fullName;
        memberDetails.sourceCode =  cmp.get("v.filteredFindIndividualSearchResults")[event.currentTarget.getAttribute("data-row-index")].sourceSysCode;
        //US3612768 - Sravan - End
		cmp.set("v.memberDetails", memberDetails);
		console.log(JSON.stringify(cmp.get("v.memberDetails")));
	},

})