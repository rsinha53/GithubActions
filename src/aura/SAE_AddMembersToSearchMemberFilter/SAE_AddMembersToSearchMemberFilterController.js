({
	onLoad: function(cmp, event, helper) {
		cmp.set('v.members', cmp.get('v.membersORG'));
		cmp.set('v.showResults', true);
		cmp.find("selbox").focus();
        cmp.set('v.IsOnLoad', true);
        cmp.set('v.SelectedMember', null);
	},
    
    handleMemberSearchResultsChange : function(cmp, event, helper) {
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
                "birthDate":""
            };
            
            findIndividualObj.row = selectedCard.row;
            findIndividualObj.isfindIndividual = selectedCard.isFindIndividualSearch; 
            findIndividualObj.showDropDown = true;
            findIndividualObj.isclear = false;
            findIndividualObj.enableContinueBtn = false;
            findIndividualObj.multipleMemberResponses = selectedCard.multipleMemberResponses;
            findIndividualObj.filterMemberResponses = selectedCard.multipleMemberResponses;
            cmp.set("v.members",findIndividualObj);
            window.setTimeout(
                $A.getCallback(function () {
                    cmp.find("selbox").focus();
                }), 1000
            );
        }
    },
    
    showResults: function(cmp, event, helper) {
        var members = cmp.get('v.members');
        var addMembers = cmp.get("v.addMembers");
        if(addMembers[cmp.get("v.row")].row == members.row){
        	members.showDropDown = !members.showDropDown;
            cmp.set("v.members",members);
        }
	},
    
    changeSearchValue: function (cmp, event, helper) {
        helper.filterMemberResults(cmp, event, helper);
	},
	
	getRowValues:function(cmp,event,helper){
        var members = cmp.get('v.members');
        var addMembers = cmp.get("v.addMembers");
        if(addMembers[cmp.get("v.row")].row == members.row){
            var selectedItem = event.currentTarget;// this will give current element
            var recIndex = selectedItem.dataset.row;// this will give the count row index
            
            var address = members.multipleMemberResponses[recIndex].address.addressLine1 + ' ' + members.multipleMemberResponses[recIndex].address.city + ' '
            + members.multipleMemberResponses[recIndex].address.stateCode + ' ' + members.multipleMemberResponses[recIndex].address.postalCode;
            var selectedName = members.multipleMemberResponses[recIndex].sourceSysCode + ' ' + members.multipleMemberResponses[recIndex].fullName + ' ' + 
                address + ' ' + members.multipleMemberResponses[recIndex].birthDate;
            
            members.selectedSearchMember = selectedName;
            members.showDropDown = false;
            members.enableContinueBtn = true;
            members.firstName = members.multipleMemberResponses[recIndex].firstName;
            members.lastName = members.multipleMemberResponses[recIndex].lastName;
            members.birthDate = members.multipleMemberResponses[recIndex].birthDate;
            
            cmp.set("v.members",members);
            addMembers[cmp.get("v.row")].selectedMemberDetails = selectedName;
            addMembers[cmp.get("v.row")].enableContinueBtn = true;
            cmp.get("v.addMembers",addMembers);
            
            let selectedMemberDetails = {
                "sourceCode": members.multipleMemberResponses[recIndex].sourceSysCode,
                "Name": members.multipleMemberResponses[recIndex].fullName,
                "DOB": members.multipleMemberResponses[recIndex].birthDate,
                "firstName": members.multipleMemberResponses[recIndex].firstName,
                "lastName": members.multipleMemberResponses[recIndex].lastName,
                "memberID": cmp.get('v.memberId')
            };
            
            cmp.set("v.SelectedMember",selectedMemberDetails);
        }        

	},
     //US2020384 : START (Updates to Additional Member Search Integration - Malinda)
    openSubjectCard:function(cmp,event,helper) {
        
        var members = cmp.get('v.members');
        var addMembers = cmp.get("v.addMembers");
        if(addMembers[cmp.get("v.row")].row == members.row){
            if(!$A.util.isEmpty(members.selectedSearchMember)){
                //DE285901
                let selectedMember = cmp.get("v.SelectedMember");
                let searchedMemberList =  cmp.get("v.searchedMembers");
                let isOtherFlow = cmp.get("v.isOtherFlow");
                let interactionObj = cmp.get("v.interactionRecord");
                
                //Dup-Check
                let UniqueIdSet = cmp.get("v.DupCheckSet");
                if ($A.util.isUndefinedOrNull(UniqueIdSet)) {
                    UniqueIdSet = new Set();
                } 
                
                if ($A.util.isUndefinedOrNull(searchedMemberList)) {
                    searchedMemberList = [];
                }
                
                if (!$A.util.isUndefinedOrNull(searchedMemberList) && searchedMemberList.length > 0) {
                    
                    for (let i = 0; i < searchedMemberList.length; i++) {
                        
                        let memIdString = searchedMemberList[i];                
                        let fullNameSplit = '';
                        let memUniqueKey = '';
                        
                        if (!$A.util.isUndefinedOrNull(memIdString)) {
                            let splitedValuesArray = memIdString.split(";");
                            
                            if (!$A.util.isUndefinedOrNull(splitedValuesArray) && splitedValuesArray.length > 0) {
                                
                                if (splitedValuesArray.length == 4) {
                                    memUniqueKey = memIdString;
                                } else if (splitedValuesArray.length == 5) {
                                    memUniqueKey = memIdString;
                                } else if (splitedValuesArray.length == 8) {
                                    
                                    if (!$A.util.isUndefinedOrNull(splitedValuesArray[6])) {
                                        let nameArray = splitedValuesArray[6].split(' ');
                                        fullNameSplit = nameArray[0] + ';' + nameArray[1];
                                        
                                    }
                                    
                                    memUniqueKey = splitedValuesArray[0] + ';' + splitedValuesArray[5] + ';' + fullNameSplit + ';' + splitedValuesArray[7];
                                }
                            }
                        }
                        
                        UniqueIdSet.add(memUniqueKey);             
                    }
                    
                }
                
                let selectedMemberUniqueId = '';
                if (!$A.util.isUndefinedOrNull(selectedMember)) {
                    let searchPrefix = '';
                    let fullName = '';
                    if (isOtherFlow) {
                        searchPrefix = 'Other;';
                        fullName = selectedMember.firstName.toUpperCase() + ' ' + selectedMember.lastName.toUpperCase();
                    } else if (!$A.util.isUndefinedOrNull(interactionObj) && !$A.util.isUndefinedOrNull(interactionObj.taxIdOrNPI)) {
                        searchPrefix = interactionObj.taxIdOrNPI + ';';   
                        fullName = selectedMember.firstName.toUpperCase() + ' ' + selectedMember.lastName.toUpperCase();           
                    }
                    selectedMemberUniqueId = searchPrefix + selectedMember.memberID + ';' + fullName + ';' + selectedMember.DOB;
                }
                
                if (!UniqueIdSet.has(selectedMemberUniqueId)) {            
                    UniqueIdSet.add(selectedMemberUniqueId);
                    searchedMemberList.push(selectedMemberUniqueId);
                    cmp.set('v.DupCheckSet', UniqueIdSet);
                    cmp.set('v.searchedMembers', searchedMemberList);
                    let cmpEvent = $A.get("e.c:SAE_AddMembersStandaloneSearchSelectedMemberEvent");
                    cmpEvent.setParams({
                        "selectedMemberDetails": cmp.get('v.SelectedMember'),
                        "selectedMemberRow": cmp.get('v.row'),
                        "isIndividualSearch": true,
                        "memberUniqueId": cmp.get('v.memberUniqueId')
                    });
                    cmpEvent.fire();
                } else {
                    let toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Information!",
                        "message": "Member was already searched.",
                        "type": "warning"
                    });
                    toastEvent.fire();
                } 
            }            
        }                     
    }
    //US2020384 : END
    
})