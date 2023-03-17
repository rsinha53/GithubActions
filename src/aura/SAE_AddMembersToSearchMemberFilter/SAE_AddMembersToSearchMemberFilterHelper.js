({
	filterMemberResults: function(cmp, event, helper) {
        var members = cmp.get('v.members');
        var addMembers = cmp.get("v.addMembers");
        if(addMembers[cmp.get("v.row")].row == members.row){
            var findIndividualSearchResults = members.filterMemberResponses;
            var value = event.getParam("value").toLowerCase();
            
            var membersLst = [];
            for (var i = 0; i < findIndividualSearchResults.length; i++) {
                if( (findIndividualSearchResults[i].sourceSysCode.toLowerCase().indexOf(value) != -1) || (findIndividualSearchResults[i].fullName.toLowerCase().indexOf(value) != -1) || 
                   (findIndividualSearchResults[i].birthDate.indexOf(value) != -1) || (findIndividualSearchResults[i].address.stateCode.toLowerCase().indexOf(value) != -1)){
                    membersLst.push(findIndividualSearchResults[i]);
                }
            }
            
            
            if ($A.util.isEmpty(membersLst)) {
                members.multipleMemberResponses = members.filterMemberResponses;
            } else {
                console.log(members.selectedSearchMember);
                members.multipleMemberResponses = membersLst;
            }
            
            members.enableContinueBtn = false;
            cmp.set("v.members",members);
        }         
    }
})