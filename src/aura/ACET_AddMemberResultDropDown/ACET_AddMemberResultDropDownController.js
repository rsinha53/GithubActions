({
	handleMemberSearchResultsChange : function(cmp, event, helper) {
        cmp.get("v.row");
        JSON.parse(JSON.stringify(cmp.get("v.addMembers")));
		JSON.parse(JSON.stringify(cmp.get("v.findIndividualSearchResults")));
        
        var selectedCard = cmp.get("v.findIndividualSearchResults");
        var addMembers = cmp.get("v.addMembers")[cmp.get("v.row")];
        if(addMembers.row == selectedCard.row){
            var findIndividualObj = {
                "row":0,
                "isfindIndividual":false,
                "showDropDown": false,
                "isclear": false,
                "multipleMemberResponses":[],
                "filterMemberResponses":[],
                "selectedMemberDetails" : "",
                "selectedSearchMember" : "",
                "enableContinueBtn": false,
                "firstName":"",
                "lastName":"",
                "birthDate": "",
                "sourceCode": ""
            };
            
            if(selectedCard.isClear){
                findIndividualObj.row = selectedCard.row;
                findIndividualObj.isfindIndividual = false; 
                findIndividualObj.showDropDown = false;
                findIndividualObj.isclear = false;
                findIndividualObj.enableContinueBtn = false;
                findIndividualObj.multipleMemberResponses = "";
                findIndividualObj.filterMemberResponses = ""; 
                findIndividualObj.sourceCode = "";
            }else{                
                findIndividualObj.row = selectedCard.row;
                findIndividualObj.isfindIndividual = selectedCard.isFindIndividualSearch; 
                findIndividualObj.showDropDown = true;
                findIndividualObj.isclear = false;
                findIndividualObj.enableContinueBtn = false;
                findIndividualObj.multipleMemberResponses = selectedCard.multipleMemberResponses;
                findIndividualObj.filterMemberResponses = selectedCard.multipleMemberResponses;                
                findIndividualObj.sourceCode = selectedCard.sourceSysCode;
            }
			cmp.set("v.selectedIndividualMemberDetails",findIndividualObj); 
        }
	},
    
    selectMember: function (cmp, event) {
        cmp.get("v.row");
        JSON.parse(JSON.stringify(cmp.get("v.addMembers")));
        JSON.parse(JSON.stringify(cmp.get("v.selectedIndividualMemberDetails")));
        
        var selectedCard = cmp.get("v.selectedIndividualMemberDetails");
        var addMembers = cmp.get("v.addMembers");
        if(addMembers[cmp.get("v.row")].row == selectedCard.row){
            
            var selectedItem = event.currentTarget;// this will give current element
            var recIndex = selectedItem.dataset.row;// this will give the count row index
            
            var address;
            var selectedName;
            if(!$A.util.isUndefinedOrNull(selectedCard.multipleMemberResponses[recIndex].address)){
                var address = selectedCard.multipleMemberResponses[recIndex].address.addressLine1 + ' ' + selectedCard.multipleMemberResponses[recIndex].address.city + ' '
                + selectedCard.multipleMemberResponses[recIndex].address.stateCode + ' ' + selectedCard.multipleMemberResponses[recIndex].address.postalCode;
                selectedName = selectedCard.multipleMemberResponses[recIndex].sourceSysCode + ' ' + selectedCard.multipleMemberResponses[recIndex].fullName + ' ' + 
                    address + ' ' + selectedCard.multipleMemberResponses[recIndex].birthDate;
            }else{
                selectedName = selectedCard.multipleMemberResponses[recIndex].sourceSysCode + ' ' + selectedCard[recIndex].fullName + ' ' + selectedCard[recIndex].birthDate;
            }
            selectedCard.selectedSearchMember = selectedName;
            selectedCard.showDropDown = false;
            selectedCard.enableContinueBtn = true;
            selectedCard.firstName = selectedCard.multipleMemberResponses[recIndex].firstName;
            selectedCard.lastName = selectedCard.multipleMemberResponses[recIndex].lastName;
            selectedCard.birthDate = selectedCard.multipleMemberResponses[recIndex].birthDate;
            selectedCard.sourceCode = selectedCard.multipleMemberResponses[recIndex].sourceSysCode;
            cmp.set("v.selectedIndividualMemberDetails",selectedCard);
            addMembers[cmp.get("v.row")].selectedMemberDetails = selectedName;
            addMembers[cmp.get("v.row")].enableContinueBtn = true;
            cmp.get("v.addMembers",addMembers);
            cmp.set("v.memberDetails",selectedCard);
        }
    	
    },
    
    openMemberDropdown: function (cmp, event) {
        
        var selectedCard = cmp.get("v.selectedIndividualMemberDetails");
        var addMembers = cmp.get("v.addMembers");
        if(addMembers[cmp.get("v.row")].row == selectedCard.row){
            selectedCard.showDropDown = true;
            cmp.set("v.selectedIndividualMemberDetails",selectedCard);
        }
    },
    filterMemberSearch: function (cmp, event) {
        JSON.parse(JSON.stringify(cmp.get("v.addMembers")));
        JSON.parse(JSON.stringify(cmp.get("v.selectedIndividualMemberDetails")));
        var inputValue = event.currentTarget.value;
        var selectedCard = cmp.get("v.selectedIndividualMemberDetails");
        var addMembers = cmp.get("v.addMembers");
        var membersToFilter = [];
        if (addMembers[cmp.get("v.row")].row == selectedCard.row) {
            var filteredFindIndividualSearchResults = selectedCard.filterMemberResponses.filter(function (memberRecord) {
                return memberRecord.firstName.toLowerCase().includes(inputValue.toLowerCase()) ||
                    memberRecord.lastName.toLowerCase().includes(inputValue.toLowerCase()) ||
                    memberRecord.sourceSysCode.toLowerCase().includes(inputValue.toLowerCase()) ||
                    memberRecord.birthDate.includes(inputValue);
            });
            /*for (var i = 0; i < selectedCard.filterMemberResponses.length; i++) {
                if ((selectedCard.filterMemberResponses[i].sourceSysCode.toLowerCase().indexOf(inputValue.toLowerCase()) != -1) || (selectedCard.filterMemberResponses[i].fullName.toLowerCase().indexOf(inputValue.toLowerCase()) != -1) ||
                    (selectedCard.filterMemberResponses[i].birthDate.indexOf(inputValue.toLowerCase()) != -1)) {
                    membersToFilter.push(selectedCard.filterMemberResponses[i]);
                }
            }*/
            
            if ($A.util.isEmpty(filteredFindIndividualSearchResults)) {
                selectedCard.multipleMemberResponses = selectedCard.filterMemberResponses;
            }else{
                selectedCard.multipleMemberResponses = filteredFindIndividualSearchResults;
            }
            cmp.set("v.selectedIndividualMemberDetails", selectedCard);
            
        }        
    }
})