({
    // DE418896 - Thanish - 22nd Mar 2021
    doInit : function(cmp, event, helper){
        helper.setEmptyAutoDocData(cmp);
    },
    
    handleAutodocRefresh: function(cmp, event) {
        if (event.getParam("autodocUniqueId") == cmp.get("v.autodocUniqueId")) {
            var tableDetails = cmp.get("v.tableDetails");
            tableDetails.selectedRows = [];
            tableDetails.allChecked = false;
            var tableBody = tableDetails.tableBody;
            for(var i of tableBody) {
                if(!i.isMainMember) {
                    i.checked = false;
                }
            }
            tableDetails.tableBody = tableBody;
            cmp.set("v.tableDetails", tableDetails); 
        }
    },

    houseHoldChange : function(component, event, helper){
        helper.updateHouseHold(component);
        helper.setAutodocTableData(component); // US2808743 - Thanish - 4th Sep 2020 - New Autodoc Framework
    },

    /**
     * US1776651 - Malinda
     * Open Snapshot sub tab for Hosuehold memebrs
    **/
    navigateToSnapshot:function(component,event,helper){

        /*	HOT FIX : Regression issues 10 - Interaction# not populated for
			the Household members when accessed from Household card (Malinda)
    	*/
        let interactionRecord = component.get("v.interactionRecd");

        var workspaceAPI = component.find("workspace");
        var houseHoldMemberList = component.get("v.houseHoldData");
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
							
								matchingTabs.push(response[i]);
								break;
                            } else if(memUniqueId === memParent) {
                               
								matchingTabs.push(response[i]);
								break;
                            } else if (memUniqueId === houseHoldUnique) {
                                
                                matchingTabs.push(response[i]);
                                break;
                            }
						} else {
							
						}
					}
				}

			}

            //Open Sub Tab
            if(!$A.util.isEmpty(houseHoldMemberList) && houseHoldMemberList.length > 1 && !isMainMember) {
                if(matchingTabs.length === 0) {
                    // US2230775 - Thanish - 18th Aug 2020 - removed unwanted code
                    workspaceAPI.getEnclosingTabId().then(function(enclosingTabId) {
                        workspaceAPI.openSubtab({
                            parentTabId: enclosingTabId,
                            pageReference: {
                                "type": "standard__component",
                                "attributes": {
                                    "componentName": "c__SAE_SnapshotOfMemberAndPolicies" // c__<comp Name>
                                },
                                "state": {
                                    "c__interactionCard":interactionCard,
                                    "c__contactName": contactName ,  // US2060237
                                    "c__searchOption": "NameDateOfBirth",
                                    "c__memberId": selectedMemberId,
                                    "c__groupId":groupId,
                                    "c__memberDOB": selectedMemberDob,
                                    "c__memberFN": selectedMemberFirstName,
                                    "c__memberLN": selectedMemberLasttName,
                                    "c__memberGrpN": memberGrpN,
                                    "c__memberUniqueId": memUniqueId,
                                    "c__subjectCard": null,
                                    "c__houseHoldUnique": memUniqueId,
				    				// US2060237	Other Card Validation - Snapshot - Other (Third Party) - 10/10/2019 - Sarma
                                    "c__providerNotFound": providerNotFound,
                                    "c__noMemberToSearch": noMemberToSearch,
                                    "c__isProviderSearchDisabled": isProviderSearchDisabled,
                                    "c__interactionRecord":interactionRecord,
                                    "c__mnf":'',
                                    "c__isOtherSearch" : isOtherSearch,
                                    "c__otherDetails" : otherCardDataObj,
                                    "c__isAdditionalMemberIndividualSearch" : false,
                                    "c__isfindIndividualFlag" : false,
                                    "c__memberCardFlag" : true, //DE282930	House Hold Card issue - 25/11/2019 - Sarma
                                    "c__payerID" : component.get('v.payerID'),// US1944108
                                    //US2669563-MVP- Member Snapshot - Policy Details - Populate Payer ID-Durga
                                    "c__payerMap":component.get('v.policywithPayerIdMap'),
                                    "c__searchPayerID":component.get('v.searchQueryPayerId'),
                                    "c__isDependent":true,
                                    "c__contactCard":component.get("v.contactCard"),//vishnu
                                    "c__relatioship":memRelationship, //Added by Vinay for Case History Table
									"c__providerDetailsForRoutingScreen": component.get("v.providerDetailsForRoutingScreen"),//US2740876 - Sravan
                                    "c__flowDetailsForRoutingScreen": component.get("v.flowDetailsForRoutingScreen"),//US2740876 - Sravan
									"c__providerDetails":component.get("v.providerDetails"),
                                    "c__interactionOverviewTabId": component.get("v.interactionOverviewTabId") //US2491365 - Avish
                                }
                            }
                        }).then(function(subtabId) {
                            // US2230775 - Thanish - 18th Aug 2020
                            var tabLabel = "";
                            if(!$A.util.isEmpty(selectedMemberFirstName)){
                                tabLabel = selectedMemberFirstName.charAt(0).toUpperCase() + selectedMemberFirstName.slice(1).toLowerCase() + " ";
                            }
                            if(!$A.util.isEmpty(selectedMemberLasttName)){
                                tabLabel = tabLabel + selectedMemberLasttName.charAt(0).toUpperCase() + selectedMemberLasttName.slice(1).toLowerCase();
                            }
                            workspaceAPI.setTabLabel({
                                tabId: subtabId,
                                label: tabLabel
                            });
                            workspaceAPI.setTabIcon({
                                tabId: subtabId,
                                icon: "custom:custom38",
                                iconAlt: "Snapshot"
                            });
                        }).catch(function(error) {
                        
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
                      

                        var focusTabId = currentTab.tabId;
                        var tabURL = currentTab.url;

                        workspaceAPI.openTab({
                            url: currentTab.url
                        }).then(function(response) {
                            workspaceAPI.focusTab({tabId : response});
                       }).catch(function(error) {
                           
                        });
                    }

                }

            } else {
               
            }
        })
    },

    selectAll: function (cmp, event) {
        var checked = event.getSource().get("v.checked");
        var tableDetails = cmp.get("v.tableDetails");
        var tableBody = tableDetails.tableBody;
        var selectedRows = tableDetails.selectedRows;
        var selectedRowsUniqueKey = new Set();
        for (var i of selectedRows) {
            selectedRowsUniqueKey.add(i.uniqueKey);
        }
        if (checked) {
            if (!$A.util.isEmpty(selectedRows)) {
                for (var i of tableBody) {
                    if(!i.isMainMember) {
                        i.checked = true;
                        if (!selectedRowsUniqueKey.has(i.uniqueKey)) {
                            selectedRows.push(i);
                        }
                    }
                }
            } else {
                for (var i of tableBody) {
                    if(!i.isMainMember) {
                        i.checked = true;
                        selectedRows.push(i);
                    }
                }
            }
        } else {
            var unselectedRowUniqueKey = new Set();
            for (var i of tableBody) {
                i.checked = false;
                unselectedRowUniqueKey.add(i.uniqueKey);
            }
            selectedRows = selectedRows.filter(function (value, index, arr) {
                if (unselectedRowUniqueKey.has(value.uniqueKey)) {
                    return false;
                } else {
                    return true;
                }
            });
        }
        tableDetails.selectedRows = selectedRows;
        tableDetails.tableBody = tableBody;
        cmp.set("v.tableDetails", tableDetails);
        _autodoc.setAutodoc(cmp.get("v.autodocUniqueId"), cmp.get("v.policySelectedIndex"), tableDetails);
    },

    rowAutodocCheck: function (cmp, event, helper) {
        var checked = event.getSource().get("v.checked");
        var currentRowIndex = event.getSource().get("v.name");
        var tableDetails = cmp.get("v.tableDetails");
        var selectedRows = tableDetails.selectedRows;
        var currentRow = tableDetails.tableBody[currentRowIndex];
        if(currentRow.uniqueKey == cmp.get("v.selectedPolicyKey")){
            checked = true;
        }
        if (checked) {
            if (!$A.util.isEmpty(selectedRows)) {
                var existingRecord = false;
                for (var i of selectedRows) {
                    if (i.uniqueKey == currentRow.uniqueKey) {
                        i = currentRow;
                        existingRecord = true;
                        break;
                    }
                }
                if (!existingRecord) {
                    selectedRows.push(currentRow);
                }
            } else {
                selectedRows.push(currentRow);
            }
            tableDetails.tableBody[currentRowIndex].checked = true;
        } else {
            selectedRows = selectedRows.filter(function (value, index, arr) {
                return value.uniqueKey != currentRow.uniqueKey;
            });
            tableDetails.tableBody[currentRowIndex].checked = false;
        }
        tableDetails.selectedRows = selectedRows;
        cmp.set("v.tableDetails", tableDetails);
        _autodoc.setAutodoc(cmp.get("v.autodocUniqueId"), cmp.get("v.policySelectedIndex"), tableDetails);
    },
})