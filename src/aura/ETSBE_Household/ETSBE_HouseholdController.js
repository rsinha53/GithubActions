({
	doInit : function(component, event, helper) {
		//helper.callHouseHoldWS(component, event, helper);
		var houseHoldList = component.get("v.houseHoldData");        
		helper.householddata(component,event.helper);
	},

    houseHoldChange : function(component, event, helper){

        helper.householddata(component,event.helper);
    },

    handlePolicyClick : function(component, event, helper) {
        var transactionId = event.getParam("transaction_id");
        var contactAddress = event.getParam("contact_address");
        //US1888880
        let isFireSpinner = event.getParam("show_spinner");        

        component.set("v.transId", transactionId);
        component.set("v.conAddress", contactAddress);
        //US1888880
        component.set("v.isFireSpinner", isFireSpinner);
    },

    runExtendedService : function(component, event, helper) {
        var trId = component.get("v.transId");
        var conAdr = component.get("v.conAddress");
        //US1761826 - UHC/Optum Exclusion UI - START
        let allowCallouts = component.get("v.allowCallouts");
       // if(allowCallouts){
       		helper.callHouseHoldWS(component, event, helper);
        //}
    },
    
    /**
     * US1776651 - Malinda
     * Open Snapshot sub tab for Hosuehold memebrs
    **/
    navigateToSnapshot:function(component,event,helper){

        /*	HOT FIX : Regression issues 10 - Interaction# not populated for
			the Household members when accessed from Household card (Malinda)
    	*/
        debugger;
        let interactionRecord = component.get("v.interactionRecd");

        var workspaceAPI = component.find("workspace");
        var houseHoldMemberList = component.get("v.ChangedHouseHoldData");
        var interactionCard = component.get("v.interactionCard");
        var contactName =  component.get("v.contactName");
        var searchOption =  component.get("v.searchOption");
        var memberGrpN =  component.get("v.memberGrpN");
        var memParentId = component.get("v.membTabId");
        var isMainMember = false;

        //Table Row values
        var selectedMemberId = event.currentTarget.getAttribute("data-memberId");
        var selectedMemberDob = event.currentTarget.getAttribute("data-dob");
        var selectedMemberFirstName= event.currentTarget.getAttribute("data-firstName");
        var selectedMemberLasttName= event.currentTarget.getAttribute("data-lastName");
        var memUniqueId = event.currentTarget.getAttribute("data-unique");
        var memRelationship = event.currentTarget.getAttribute("data-role");
        var groupId = event.currentTarget.getAttribute("data-GroupId");
        //DE282930	House Hold Card issue - 25/11/2019 - Sarma
        var isMainMemb = event.currentTarget.getAttribute("data-isMainMember");
        if(isMainMemb == 'true'){
            return;
        }
        //Handle the selected row        

        //DOB convertion
        let tempDate = new Date(selectedMemberDob.toString())        
        let formatted_date = tempDate.getFullYear() + '-' + ('0' + (tempDate.getMonth()+1)).slice(-2) + '-' + ('0' + tempDate.getDate()).slice(-2);

        //Unique Id hack
        if(selectedMemberId == null) {
            memUniqueId = 'xxxxx'+formatted_date;
        } else {
            //memUniqueId = selectedMemberId + formatted_date;
            //DE281466	HouseHold issue with Twins : Adding first name to tab uniqueness - 22/11/2019 - Sarma
            memUniqueId = selectedMemberId + selectedMemberDob + selectedMemberFirstName;
        }

        memUniqueId = memUniqueId.concat('_sub');

        // US2060237	Other Card Validation - Snapshot - Other (Third Party) - 10/10/2019 - Sarma
        var isOtherSearch = component.get("v.isOtherSearch");
        var otherCardDataObj = component.get("v.otherCardDataObj");
        var providerNotFound = component.get("v.providerNotFound");
        var noMemberToSearch = component.get("v.noMemberToSearch");
        var isProviderSearchDisabled = component.get("v.isProviderSearchDisabled");
        var isfindIndividualFlag = component.get("v.isfindIndividualFlag");
        var memberCardFlag = component.get("v.memberCardFlag");
        var isAdditionalMemberSearchfindIndividual = component.get("v.isAdditionalMemberSearchfindIndividual");
        // US2060237 -  End

        //Member MAP        
        let mapHouseHold = new Map();
        let tempMemId = 'xxxxx';
        if(!$A.util.isEmpty(houseHoldMemberList)) {
            for (let i = 0; houseHoldMemberList.length > i; i++) {
                if(!$A.util.isEmpty(houseHoldMemberList[i].memberId)) {
                    tempMemId = houseHoldMemberList[i].memberId;
                }
                let tempDate = new Date(houseHoldMemberList[i].dob.toString())
        		let formatted_date = tempDate.getFullYear() + '-' + ('0' + (tempDate.getMonth()+1)).slice(-2) + '-' + ('0' + tempDate.getDate()).slice(-2);
                //HOT-FIX : Duplicate Tab Fix
                //DE281466	HouseHold issue with Twins : Adding first name to tab uniqueness - 22/11/2019 - Sarma
                let memFirstName = houseHoldMemberList[i].memFirstName;
                let memId = tempMemId + formatted_date + memFirstName; //houseHoldMemberList[i].dob.toString(); //US2070352 Added by Avish - selectedMemberDob
                memId = memId.concat('_sub');
                mapHouseHold.set(memId,houseHoldMemberList[i]);
            }
        }

        //Finding main member
        if(mapHouseHold.has(memUniqueId) && mapHouseHold.get(memUniqueId).isMainMember) {
            isMainMember = true;
        }

        var matchingTabs = [];

		//Open Sub Tab - Checking duplicate tabs
		workspaceAPI.getAllTabInfo().then(function(response) {            
            if(!$A.util.isEmpty(response)) {
				for(var i = 0; i < response.length; i++) {
                    var memParent = response[i].pageReference.state.c__memberUniqueId;
                    // Adding null check 
                    // DE286683	Provider flow - no member to search - Household is not working
                    if(!$A.util.isUndefinedOrNull(memParent)){
                    memParent = memParent.concat('_sub');
                    }
                   
					for(var j = 0; j < response[i].subtabs.length; j++) {
						if(response[i].subtabs.length > 0){                            
							var	tabMemUniqueId = response[i].subtabs[j].pageReference.state.c__memberUniqueId;
                            var houseHoldUnique = response[i].subtabs[j].pageReference.state.c__houseHoldUnique;
							
							if(memUniqueId === tabMemUniqueId) {
								console.log('TAB MATCH!!');
								matchingTabs.push(response[i]);
								break;
                            } else if(memUniqueId === memParent) {
                                console.log('PARENT TAB MATCH!!');
								matchingTabs.push(response[i]);
								break;
                            } else if (memUniqueId === houseHoldUnique) {
                                console.log('INT Overview Tab Match');
                                matchingTabs.push(response[i]);
                                break;
                            }
						} else {
							console.log('FIRST SUB TAB');
						}
					}
				}

			}

            //Open Sub Tab
            if(!$A.util.isEmpty(houseHoldMemberList) && houseHoldMemberList.length > 1 && !isMainMember) {
                if(matchingTabs.length === 0) {
                    console.log('##HOUSEHOLD-MEMBER-TAB-OPENED-FOR:',selectedMemberFirstName);
                    var tabName = selectedMemberFirstName;
                    var memberResultinfo = component.get("v.selectedMemberInfo");
                   // alert(memberResultinfo);
                    
                    var custmrAdmininfo = component.get("v.selectedCustomerAdmin");
                    
                    var groupinfo = component.get("v.selectedGroup");
                    
                     var selectedMember = {
    "memberID": selectedMemberId,
    "searchOption": "NameDateOfBirth",
                         "firstName":    selectedMemberFirstName,
                         "lastName":selectedMemberLasttName,
                         "DOB":selectedMemberDob
                         
};
                    //alert(selectedMemberId);
                     //alert(selectedMember);
                    workspaceAPI.getEnclosingTabId().then(function(enclosingTabId) {
                        workspaceAPI.openSubtab({
                            parentTabId: enclosingTabId,
                            pageReference: {
                                "type": "standard__component",
                                "attributes": {
                                    "componentName": "c__ETSBE_GeneralInfo" // c__<comp Name>
                                },
                                "state": {
                                    
                                    "c__AdminInfo" : custmrAdmininfo,
                                    "c__MemberInfo": selectedMember, // US2060237
                                    "c__GroupInfo":groupinfo,
                                    "c__InteractionRecord" : interactionRecord,
                                    "c__isHouseHoldMemClicked" : true,
                                    "c__SpecialInstructionInfo" : component.get("v.specialInstructionsInfo"),
                                    "c__FlowType" : component.get("v.FlowType"),
                                    "c__isMockEnabled" : component.get("v.isMockEnabled")
                                }
                            }
                        }).then(function(subtabId) {
                            
                            // US1911471 - Thanish - (18th July 2019) - Add tab label and icon - start
                            //var tabLabel = tabName.charAt(0).toUpperCase() + tabName.slice(1).toLowerCase();
                            workspaceAPI.setTabLabel({
                                tabId: subtabId,
                                label: tabName
                            });
                            workspaceAPI.setTabIcon({
                                tabId: subtabId,
                                icon: "custom:custom38",
                                iconAlt: "Snapshot"
                            });
                            // US1911471 - Thanish - (18th July 2019) - end
                        }).catch(function(error) {
                            console.log(error);
                        });

                    });
                } else { //Tab focus for opened tabs
                    //Sanpshot - opned tabs
                    let mapOpenedTabs = new Map();
                    for(var i = 0; i < response.length; i++) {
                        for(var j = 0; j < response[i].subtabs.length; j++) {
                            let subTab = response[i].subtabs[j];
                            if (subTab.pageReference.state.c__houseHoldUnique != "") {
                                mapOpenedTabs.set(subTab.pageReference.state.c__houseHoldUnique, subTab);
                            } else {
                            mapOpenedTabs.set(subTab.pageReference.state.c__memberUniqueId,subTab);
                            }
                        }
                    }

                    if(mapOpenedTabs.has(memUniqueId)) {
                        let currentTab = mapOpenedTabs.get(memUniqueId);
                        console.log('##HOUSE-HOLD-SUB_NOT-OPENED');
                        
                        var focusTabId = currentTab.tabId;
                        var tabURL = currentTab.url;
                        
                        workspaceAPI.openTab({
                            url: currentTab.url
                        }).then(function(response) {
                            workspaceAPI.focusTab({tabId : response});
                       }).catch(function(error) {
                            console.log(error);
                        });
                    }

                }

            } else {
                console.log('##HOUSEHOLD-MEMBER-TAB-NOT-OPENED-FOR:',selectedMemberFirstName);
            }
        })
    }
})