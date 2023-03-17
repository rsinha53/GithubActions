({
    doInit: function (cmp, event, helper) {
        cmp.find("interactionCardSpinnerAI").set("v.isTrue", true);
        var interactionOverviewTabId = cmp.get("v.pageReference").state.c__interactioOverviewTabUniqueId;
        helper.getEnclosingTabIdHelper(cmp, event);
        var isVCCD = cmp.get("v.pageReference").state.c__isVCCD;
        var VCCDRespId = cmp.get("v.pageReference").state.c__VCCDRespId;
        var VCCDQuestionType = cmp.get("v.pageReference").state.c__VCCDQuestionType;
        var selectedMemberSource = cmp.get("v.pageReference").state.c__Code; //US2699880-Interaction Overview Page - Remove EEID & SSN Fields and Add 'Source Code' Field
       var strEmails = cmp.get("v.pageReference").state.c__EmailAddress;
        cmp.set("v.isVCCD",isVCCD);
        cmp.set("v.VCCDObjRecordId",VCCDRespId);
        cmp.set("v.VCCDQuestionType",VCCDQuestionType);
        cmp.set("v.selectedMemberSource",selectedMemberSource);//US2699880-Interaction Overview Page - Remove EEID & SSN Fields and Add 'Source Code' Field
       cmp.set("v.strEmails", strEmails);
        try {
            var sessionData = _setAndGetSessionValues.getSessionData(interactionOverviewTabId);
        } catch (e) {
            helper.closeInteractionOverviewTabs(cmp);
            var timer = setTimeout(function () {
                helper.closeInteractionOverviewTabs(cmp);
            }, 3000);
        }
        cmp.set("v.interactionOverviewTabId", interactionOverviewTabId);
        var interactionOverviewData = JSON.parse(JSON.stringify(_setAndGetSessionValues.getInteractionDetails(interactionOverviewTabId)));
        helper.getInteractionRecordDetails(cmp, interactionOverviewData);
        var flowDetails = interactionOverviewData.flowDetails;
        
        var contactNumber;
        if(!$A.util.isUndefinedOrNull(flowDetails.contactNumber)){
          contactNumber  = flowDetails.contactNumber;
          flowDetails.contactNumber = '('+contactNumber.substring(0, 3) + ') ' + contactNumber.substring(3, 6) + '-' + contactNumber.substring(6, 10);
        }else{
            
             flowDetails.contactNumber = '';
        }
       
        
        var providerDetails = interactionOverviewData.providerDetails;
        if(!$A.util.isEmpty(providerDetails.phoneNumber)){
        var phoneNumber = providerDetails.phoneNumber;
            if(!phoneNumber.includes("(")){
                phoneNumber = '('+phoneNumber.substring(0, 3) + ') ' + phoneNumber.substring(3, 6) + '-' + phoneNumber.substring(6, 10);
            }
            providerDetails.phoneNumber = phoneNumber;
        }
        if(!$A.util.isUndefinedOrNull(flowDetails) && !$A.util.isEmpty(flowDetails)){
            var conStartTime = '';
            var conStartType = '';
            var conEndTime = '';
            var conEndType = '';
            var conTimeZone = '';
            if(flowDetails.hasOwnProperty('conStartTime')){
                conStartTime = flowDetails.conStartTime;
            }
            if(flowDetails.hasOwnProperty('conStartType')){
                conStartType = flowDetails.conStartType;
            }
            if(flowDetails.hasOwnProperty('conEndTime')){
                conEndTime = flowDetails.conEndTime;
            }
            if(flowDetails.hasOwnProperty('conEndType')){
                conEndType = flowDetails.conEndType;
            }
            if(flowDetails.hasOwnProperty('conTimeZone')){
                conTimeZone = flowDetails.conTimeZone;
            }
            if(!$A.util.isEmpty(conStartTime) && !$A.util.isEmpty(conStartType) && !$A.util.isEmpty(conEndTime) && !$A.util.isEmpty(conEndType) && !$A.util.isEmpty(conTimeZone)){
                var hoursOfOperation = conStartTime+ ' '+conStartType+' to '+conEndTime+' '+conEndType+' '+conTimeZone;
                cmp.set("v.hoursOfOperation",hoursOfOperation);
            }

        }
        cmp.set("v.flowDetails", flowDetails);
        console.log("isVCCD >>"+isVCCD);
        if(isVCCD)
        cmp.set("v.iVRDetails", flowDetails.IVRInfo);
        console.log(JSON.parse(JSON.stringify(cmp.get("v.iVRDetails"))));
        console.log(JSON.parse(JSON.stringify(cmp.get("v.flowDetails"))));
        cmp.set("v.providerDetails", providerDetails);
        cmp.set("v.memberDetails", interactionOverviewData.membersData);
        if(!$A.util.isUndefinedOrNull(interactionOverviewData.membersData) && !$A.util.isEmpty(interactionOverviewData.membersData)){
        cmp.set("v.insuranceTypeCode", interactionOverviewData.membersData[0].insuranceTypeCode);
        console.log("v.insuranceTypeCode"+ cmp.get('v.insuranceTypeCode'));
        }
        //US2717679: Interaction Overview Page - Member Card Alignment - Praveen -start
        var numberOfMembers = interactionOverviewData.membersData.length;
        if(numberOfMembers==1){
            cmp.set("v.enableAddMembersToSearch", true);
        }
        if(numberOfMembers>1){
            if((numberOfMembers % 2) === 0 ){
                cmp.set("v.enableAddMembersToSearch", false);
            }else{
                cmp.set("v.enableAddMembersToSearch", true);
            }
        }

        var memDetailsCheck = cmp.get("v.memberDetails");

        if(!$A.util.isEmpty(memDetailsCheck)){
            var mdc;
            for(mdc in memDetailsCheck){
                if(memDetailsCheck[mdc].isValidMember){
                    cmp.set("v.enableAddMembersToSearchMf", true);
                    break;
                }
            }
            var mnfdc;
            for(mnfdc in memDetailsCheck){
                if(memDetailsCheck[mnfdc].isMemberNotFound){
                    cmp.set("v.enableAddMembersToSearchMnf", true);
                    break;
                }
            }
        }
        //US2717679: Interaction Overview Page - Member Card Alignment - Praveen - end
        //US2873801 - Genesys - Member Snapshot Page - Topic Integration - Sravan
        //US2880283 - Genesys - Provider Snapshot Page - Topic Integration - Sravan
        helper.setTopicValue(cmp, event, helper);
    },

    onTabFocused: function (cmp, event, helper) {
		helper.updateInteractionDetails(cmp, event);
    },
    
    onTabClosed: function (cmp, event, helper) {
        var currentTabId = cmp.get("v.currentTabId");
        var closedTabId = event.getParam('tabId');
        if (currentTabId == closedTabId) {
            try {
                _setAndGetSessionValues.removeInteractionDetails(cmp.get("v.interactionOverviewTabId"));
            } catch (e) {}
        }
    },
    
    openMisdirectComp: function (cmp, event, helper) {
        helper.openMisDirect(cmp);
    },
    
    navigateToInteractionDetail: function (cmp, event) {
        var intId = event.currentTarget.getAttribute("data-intId");
        var workspaceAPI = cmp.find("workspace");
        workspaceAPI.openSubtab({
            pageReference: {
                type: 'standard__recordPage',
                attributes: {
                    actionName: 'view',
                    objectApiName: 'Interaction__c',
                    recordId: intId
                },
            },
            focus: true
        }).then(function (response) {
            workspaceAPI.getTabInfo({
                tabId: response
            }).then(function (tabInfo) {});
        }).catch(function (error) {
            console.log(error);
        });
    },
    
    navigateToProviderSnapshot: function (cmp, event) {// DE380979 - Thanish - Snapshot duplicate fix
        let today = new Date();
        event.currentTarget.id = today.getTime();
        $A.util.addClass(event.currentTarget, "disableLink");

        var workspaceAPI = cmp.find("workspace");
        var memberDetails = cmp.get("v.memberDetails");
        var providerDetails = cmp.get("v.providerDetails");
        var interactionDetails = cmp.get("v.interactionDetails");
        var flowDetails = cmp.get("v.flowDetails");
        var provType = providerDetails.filterType;
        let subjectDetails = new Object();
        subjectDetails.subjectType = 'Member';
        
        let contactName = flowDetails.contactName;
        let contactNumber;
         if(!$A.util.isUndefinedOrNull(flowDetails.contactNumber)){
            contactNumber = flowDetails.contactNumber;
         }else{
             contactNumber = '';
         }
  
        
        subjectDetails.contactName = contactName;
        subjectDetails.contactNumber = contactNumber;
        subjectDetails.contactExt = flowDetails.contactExt; //US2699902 - Avish
        
        let interactionCard = new Object();
        interactionCard.firstName = providerDetails.firstName;
        interactionCard.lastName = providerDetails.lastName;
        interactionCard.taxIdOrNPI = providerDetails.taxId;
        interactionCard.filterType = providerDetails.filterType;
        interactionCard.npi = providerDetails.npi;
        interactionCard.phone = providerDetails.phoneNumber;
        interactionCard.primarySpeaciality = providerDetails.primarySpeciality;
        interactionCard.contactName = flowDetails.contactName;
        interactionCard.contactNumber = contactNumber;//flowDetails.contactNumber;
        interactionCard.contactExt = flowDetails.contactExt;
        interactionCard.conName = flowDetails.contactName;
        interactionCard.contactType = providerDetails.contactType;
        interactionCard.conNumber = contactNumber;// flowDetails.contactNumber;
        interactionCard.otherConExt = flowDetails.contactExt;
        
        //US3389424: View Payments - Select Claim # Hyperlink in Payment Details - Swapnil
        var contactDetails = {
            "contactName": flowDetails.contactName,
            "contactNumber": contactNumber,//flowDetails.contactNumber,
            "contactExt": flowDetails.contactExt
        }; //US3389424 ends

        /*if (memberDetails[0].isMemberNotFound) {
            subjectDetails.fullName = memberDetails[0].firstName + ' ' + memberDetails[0].lastName;
            subjectDetails.DOB = memberDetails.dob;
            subjectDetails.subjectGroupId = '';
            subjectDetails.subjectId = '';
        }
        if (!memberDetails.isNoMemberToSearch && !memberDetails.isMemberNotFound) {
            subjectDetails.fullName = memberDetails[0].firstName + ' ' + memberDetails[0].lastName;
            subjectDetails.DOB = memberDetails[0].dob;
            subjectDetails.subjectGroupId = memberDetails[0].groupNumber;
            subjectDetails.subjectId = memberDetails[0].memberId;
        }
        if (memberDetails[0].isNoMemberToSearch) {*/
        subjectDetails.subjectType = 'Provider';
        subjectDetails.fullName = providerDetails.firstName + " " + providerDetails.lastName;
        subjectDetails.DOB = '--';
        subjectDetails.subjectGroupId = '--';
        subjectDetails.subjectId = '--';
		//}
        if (!providerDetails.isProviderNotFound) {
            var tabUniqueKey = providerDetails.taxId + providerDetails.providerId + providerDetails.addressId;
            var foundTab = new Object();
            foundTab.tabId = '';
            foundTab.tabUrl = '';
            
            workspaceAPI.getAllTabInfo().then(function (response) {
                for (var i = 0; i < response.length; i++) {
                    var subtabArray = response[i].subtabs;
                    for (var j = 0; j < subtabArray.length; j++) {
                        var item = subtabArray[j];
                        if (item.pageReference.state.c__tabUniqueKey == tabUniqueKey) {
                            foundTab.tabId = subtabArray[j].tabId;
                            foundTab.tabUrl = subtabArray[j].url;
                            break;
                        }
                    }
                }
                
                if ((provType == "Physician" || provType == "P") && foundTab.tabId == '') {
                    // US2230775 - Thanish - 18th Aug 2020
                    var tabLabel = ""; 
                    if (!$A.util.isEmpty(providerDetails.firstName)) {
                        tabLabel = tabLabel + providerDetails.firstName.charAt(0) + providerDetails.firstName.slice(1).toLowerCase();
                        if (!$A.util.isEmpty(providerDetails.lastName)) {
                            tabLabel = tabLabel + " " + providerDetails.lastName.charAt(0) + providerDetails.lastName.slice(1).toLowerCase();
                        }
                    } else {
                        tabLabel = "Provider Snapshot";
                    }
                    workspaceAPI.getEnclosingTabId().then(function (enclosingTabId) {
                        workspaceAPI.openSubtab({
                            parentTabId: enclosingTabId,
                            pageReference: {
                                "type": "standard__component",
                                "attributes": {
                                    "componentName": "c__ACET_ProviderSnapshot"
                                },
                                "state": {
                                    "c__interactionOverviewTabId": cmp.get("v.interactionOverviewTabId"), //DE364195 - Avish
                                    "c__mnf": !$A.util.isEmpty(memberDetails) ? (memberDetails[0].isMemberNotFound ? "mnf" : "") : "",
                                    "c__providerNotFound": providerDetails.isProviderNotFound,
                                    "c__noMemberToSearch": !$A.util.isEmpty(memberDetails) ? memberDetails[0].isNoMemberToSearch : true,
                                    "c__isProviderSearchDisabled": providerDetails.isNoProviderToSearch,
                                    "c__taxId": providerDetails.taxId,
                                    "c__providerId": providerDetails.providerId,
                                    "c__addrSequence": providerDetails.addressSequenceId,
                                    "c__interactionId": cmp.get("v.interactionDetails.Id"),
                                    "c__interactionName": cmp.get("v.interactionDetails.Name"),
                                    "c__interactionRec": cmp.get("v.interactionDetails"),
                                    "c__subjectDetails": subjectDetails,
                                    "c__addressId": providerDetails.addressId,
                                    "c__tabUniqueKey": tabUniqueKey,
                                    "c__hipaaEndpointUrl": cmp.get("v.hipaaEndpointUrl"),//US2076634 - Sravan - 22/06/2020
                                    "c__providerDetailsForRoutingScreen": cmp.get("v.providerDetails"),//DE34738 - Praveen - 15/07/2020
                                    "c__isVCCD": cmp.get("v.isVCCD"), //US2897253 - Sravan
                                    "c__VCCDQuestionType": cmp.get("v.VCCDQuestionType"),//US2897253 - Sravan
                                    "c__flowDetailsForRoutingScreen": cmp.get("v.flowDetails"),
                                    "c__isPhysician": true, //Sanka
                                    "c__ioProviderSnapshotLinkId": event.currentTarget.id, // DE380979 - Thanish - Snapshot duplicate fix
                                    "c__interactionCard": interactionCard, 	//US3389424 Swapnil
                                    "c__contactDetails": contactDetails
                                }
                            },
                            focus: true
                        }).then(function (subtabId) {
                            workspaceAPI.setTabLabel({
                                tabId: subtabId,
                                label: tabLabel
                            });
                            workspaceAPI.setTabIcon({
                                tabId: subtabId,
                                icon: "custom:custom86",
                                iconAlt: "Snapshot"
                            });
                        }).catch(function (error) {
                            console.log(error);
                        });
                    });
                } else if ((provType == "Facility" || provType == "O") && foundTab.tabId == '') {
                    // US2230775 - Thanish - 18th Aug 2020
                    var tabLabel = "";
                    if (!$A.util.isEmpty(providerDetails.firstName)) {
                        var nameList = providerDetails.firstName.split(" ");
                        var name;
                        for(name of nameList){
                            tabLabel = tabLabel + " " + name.charAt(0) + name.slice(1).toLowerCase();
                        }

                    } else if(!$A.util.isEmpty(providerDetails.lastName)) {
                        var nameList = providerDetails.lastName.split(" ");
                        var name;
                        for(name of nameList){
                            tabLabel = tabLabel + " " + name.charAt(0) + name.slice(1).toLowerCase();
                        }
                    } else {
                        tabLabel = "Provider Snapshot";
                    }
                    
                    workspaceAPI.getEnclosingTabId().then(function (enclosingTabId) {
                        workspaceAPI.openSubtab({
                            parentTabId: enclosingTabId,
                            pageReference: {
                                "type": "standard__component",
                                "attributes": {
                                    "componentName": "c__ACET_ProviderSnapshot" //Facility component needs to be placed
                                },
                                "state": {
                                    "c__interactionOverviewTabId": cmp.get("v.interactionOverviewTabId"), //DE364195 - Avish
                                    "c__mnf": !$A.util.isEmpty(memberDetails) ? (memberDetails[0].isMemberNotFound ? "mnf" : "") : "",
                                    "c__providerNotFound": providerDetails.isProviderNotFound,
                                    "c__noMemberToSearch": !$A.util.isEmpty(memberDetails) ? memberDetails[0].isNoMemberToSearch : true,
                                    "c__isProviderSearchDisabled": providerDetails.isNoProviderToSearch,
                                    "c__taxId": providerDetails.taxId,
                                    "c__providerId": providerDetails.providerId,
                                    "c__addrSequence": providerDetails.addressSequenceId,
                                    "c__interactionId": cmp.get("v.interactionDetails.Id"),
                                    "c__interactionName": cmp.get("v.interactionDetails.Name"),
                                    "c__interactionRec": cmp.get("v.interactionDetails"),
                                    "c__subjectDetails": subjectDetails,
                                    "c__addressId": providerDetails.addressId,
                                    "c__tabUniqueKey": tabUniqueKey,
                                    "c__hipaaEndpointUrl": cmp.get("v.hipaaEndpointUrl"),//US2076634 - Sravan - 22/06/2020
                                    "c__providerDetailsForRoutingScreen": cmp.get("v.providerDetails"),
                                    "c__isVCCD": cmp.get("v.isVCCD"), //US2897253 - Sravan
                                    "c__VCCDQuestionType": cmp.get("v.VCCDQuestionType"),//US2897253 - Sravan
                                    "c__flowDetailsForRoutingScreen": cmp.get("v.flowDetails"),
                                    "c__isPhysician": false, //Sanka
                                    "c__ioProviderSnapshotLinkId": event.currentTarget.id, // DE380979 - Thanish - Snapshot duplicate fix
                                    "c__interactionCard": interactionCard, 	//US3389424 Swapnil
                                    "c__contactDetails": contactDetails
                                }
                            },
                            focus: true
                        }).then(function (subtabId) {
                            workspaceAPI.setTabLabel({
                                tabId: subtabId,
                                label: tabLabel
                            });
                            workspaceAPI.setTabIcon({
                                tabId: subtabId,
                                icon: "custom:custom86",
                                iconAlt: "Snapshot"
                            });
                        }).catch(function (error) {
                            console.log(error);
                        });
                    });
                } else {
                    workspaceAPI.openTab({
                        url: foundTab.tabUrl,
                    }).then(function (response) {
                        workspaceAPI.focusTab({
                            tabId: foundTab.tabId
                        });
                    })
                    .catch(function (error) {
                        console.log(error);
                    });

                    // DE380979 - Thanish - Snapshot duplicate fix
                    $A.util.removeClass(event.currentTarget, "disableLink");
                }
            })
            .catch(function (error) {
                console.log(error);
            });
        } else {
            // US2230775 - Thanish - 18th Aug 2020
            var tabLabel = "";
            if (!$A.util.isEmpty(providerDetails.firstName)) {
                tabLabel = tabLabel + " " + providerDetails.firstName.charAt(0).toUpperCase() + providerDetails.firstName.slice(1).toLowerCase();
                if (!$A.util.isEmpty(providerDetails.lastName)) {
                    tabLabel = tabLabel + " " + providerDetails.lastName.charAt(0).toUpperCase() + providerDetails.lastName.slice(1).toLowerCase();
                }
            } else if (!$A.util.isEmpty(providerDetails.lastName)) {
                tabLabel = tabLabel + " " + providerDetails.lastName.charAt(0).toUpperCase() + providerDetails.lastName.slice(1).toLowerCase();
            } else {
                tabLabel = "Provider Snapshot";
            }
            
            var caseWrapper = {
                "Interaction": interactionDetails.Id,
                "Status": "Open",
                "OriginatorName": providerDetails.firstName + ' ' + providerDetails.lastName,
                "OriginatorType": "Provider",
                "OriginatorContactName": flowDetails.contactName,
                "OriginatorFirstName":cmp.get("v.flowDetails").contactFirstName,//US2740876 - Sravan
                "OriginatorLastName":cmp.get("v.flowDetails").contactLastName,//US2740876 - Sravan
                "SubjectName": !$A.util.isEmpty(memberDetails) ? memberDetails[0].firstName + ' ' + memberDetails[0].lastName : '',
                "SubjectType": !$A.util.isEmpty(memberDetails) ? (memberDetails[0].isNoMemberToSearch ? 'Provider' : 'Member') : '',
                "SubjectDOB": !$A.util.isEmpty(memberDetails) ? memberDetails[0].memberDOB : '',
                "SubjectId": !$A.util.isEmpty(memberDetails) ? memberDetails[0].memberId : '',
                "SubjectGroupId": !$A.util.isEmpty(memberDetails) ? memberDetails[0].groupNumber : '',
                "TaxId": providerDetails.taxIdOrNPI,
                "noProviderToSearch": providerDetails.isNoProviderToSearch,
                "providerNotFound": providerDetails.isProviderNotFound,
                "noMemberToSearch": !$A.util.isEmpty(memberDetails) ? memberDetails[0].isNoMemberToSearch : true,
                "mnf": !$A.util.isEmpty(memberDetails) ? memberDetails[0].isMemberNotFound : false,
                "phoneNumber": providerDetails.EffectivePhoneNumber,
                "providerInfoCity":providerDetails.AddressCity,
                "isOtherSearch": providerDetails.isOther,
            };
            
            var tabUniqueKey_PNF = providerDetails.taxIdOrNPI + providerDetails.firstName + providerDetails.lastName;
            var foundTab_PNF = new Object();
            foundTab_PNF.tabId = '';
            foundTab_PNF.tabUrl = '';
            
            workspaceAPI.getAllTabInfo().then(function (response) {
                for (var i = 0; i < response.length; i++) {
                    var subtabArray = response[i].subtabs;
                    for (var j = 0; j < subtabArray.length; j++) {
                        var item = subtabArray[j];
                        if (item.pageReference.state.c__tabUniqueKey_PNF == tabUniqueKey_PNF) {
                            foundTab_PNF.tabId = subtabArray[j].tabId;
                            foundTab_PNF.tabUrl = subtabArray[j].url;
                            break;
                        }
                    }
                }
                
                if (foundTab_PNF.tabId == '') {
                    workspaceAPI.getEnclosingTabId().then(function (enclosingTabId) {
                        workspaceAPI.openSubtab({
                            parentTabId: enclosingTabId,
                            pageReference: {
                                "type": "standard__component",
                                "attributes": {
                                    "componentName": "c__ACET_ProviderNotFoundSnapshot" //Provider Not found snapshot to be placed
                                },
                                "state": {
                                    "c__caseWrapper": caseWrapper,
                                    "c__interactionCard": interactionCard,
                                    "c__contactName": flowDetails.contactName,
                                    "c__contactNumber": flowDetails.contactNumber,
                                    "c__contactExt": flowDetails.contactExt, //US2699902 - Avish
                                    "c__interactionRec": cmp.get("v.interactionDetails"),
                                    "c__tabUniqueKey_PNF": tabUniqueKey_PNF,
                                    "c__hipaaEndpointUrl": cmp.get("v.hipaaEndpointUrl"),//US2076634 - Sravan - 22/06/2020
                                    "c__providerDetailsForRoutingScreen": cmp.get("v.providerDetails"),//DE34738 - Praveen - 15/07/2020
                                    "c__flowDetailsForRoutingScreen": cmp.get("v.flowDetails"),
                                    "c__ioProviderSnapshotLinkId": event.currentTarget.id // DE380979 - Thanish - Snapshot duplicate fix
                                }
                            },
                            focus: true
                        }).then(function (subtabId) {
                            workspaceAPI.setTabLabel({
                                tabId: subtabId,
                                label: tabLabel
                            });
                            workspaceAPI.setTabIcon({
                                tabId: subtabId,
                                icon: "custom:custom86",
                                iconAlt: "Snapshot"
                            });
                        }).catch(function (error) {
                            console.log(error);
                        });
                    });
                } else {
                    workspaceAPI.openTab({
                        url: foundTab_PNF.tabUrl,
                    }).then(function (response) {
                        workspaceAPI.focusTab({
                            tabId: foundTab_PNF.tabId
                        });
                    })
                    .catch(function (error) {
                        console.log(error);
                    });
                    // DE380979 - Thanish - Snapshot duplicate fix
                    $A.util.removeClass(event.currentTarget, "disableLink");
                }
            })
            .catch(function (error) {
                console.log(error);
            });
        }
    },
    
    navigateToMemberSnapshot: function (cmp, event) {
        // DE380979 - Thanish - Snapshot duplicate fix
        let today = new Date();
        event.currentTarget.id = today.getTime();
        $A.util.addClass(event.currentTarget, "disableLink");

        var memberDetails = cmp.get("v.memberDetails");
        var providerDetails = cmp.get("v.providerDetails");
        providerDetails.phone = providerDetails.phoneNumber;
        var interactionDetails = cmp.get("v.interactionDetails");
        var flowDetails = cmp.get("v.flowDetails");
        providerDetails.contactName = flowDetails.contactName;
        providerDetails.contactNumber = flowDetails.contactNumber;
        providerDetails.contactExt = flowDetails.contactExt;
        var selectedCard = event.target.getAttribute("data-Index");
        var subjectCardList = [];
        let subjectCard = new Object();
        for (var i = 0; i < memberDetails.length; i++) {
            subjectCard = new Object();
            subjectCard.subjectName = 'Subject' + ' ' + ':' + ' ' + memberDetails[i].firstName + ' ' + memberDetails[i].middleName + ' ' + memberDetails[i].lastName;
            subjectCard.memberId = memberDetails[i].memberId;
            subjectCard.memberName = memberDetails[i].firstName + ' ' + memberDetails[i].middleName + ' ' + memberDetails[i].lastName;
            subjectCard.mnfMemberFN = subjectCard.firstName = memberDetails[i].firstName;
            subjectCard.middleName = memberDetails[i].middleName;
            subjectCard.mnfMemberLN = subjectCard.lastName = memberDetails[i].lastName;
            subjectCard.mnfDOB = subjectCard.memberDOB = memberDetails[i].dob;
            subjectCard.gender = memberDetails[i].gender;
            subjectCard.relationship = memberDetails[i].relationship;
            subjectCard.age = memberDetails[i].age;
            subjectCard.groupNumber = memberDetails[i].groupNumber;
            subjectCard.ssn = memberDetails[i].ssn;
            subjectCard.eeId = memberDetails[i].eeId;
            subjectCard.maskedSSN = 'xxx-xx-' + subjectCard.ssn.substring(5, 9);
            subjectCard.formattedSSN = subjectCard.ssn.substring(0, 3) + '-' + subjectCard.ssn.substring(3, 5) + '-' + subjectCard.ssn.substring(5, 9);
            subjectCard.maskedEEID = 'xxxxx' + subjectCard.eeId.substring(5, 9);
            subjectCard.mnfState = memberDetails[i].state;
            subjectCard.mnfPhoneNumber = memberDetails[i].phoneNumber;
            //DE343974 - Payer ID fetching as per the Member drop down value, not from the real time service - Durga
           	subjectCard.searchQueryPayerId = memberDetails[i].searchQueryPayerId;
            subjectCard.payerID = memberDetails[i].payerId;
            subjectCard.policyandPayerMap = memberDetails[i].policyandPayerMap;
            subjectCard.emails = memberDetails[i].emails;
			//Blinker
			subjectCard.FISourceCode = memberDetails[i].FISourceCode;
            subjectCardList.push(subjectCard);
        }
        var providerUniqueId = "";
        if (providerDetails.isNoProviderToSearch) {
            providerUniqueId = "No Provider To Search";
        } else if (providerDetails.isOther) {
            providerUniqueId = "Other";
        } else if (!providerDetails.isNoProviderToSearch) {
            providerUniqueId = providerDetails.taxId;
        }
        var memUniqueId = providerUniqueId + memberDetails[selectedCard].memberId + memberDetails[selectedCard].memberDOB + memberDetails[selectedCard].firstName;
        var houseHoldUnique = providerUniqueId + memberDetails[selectedCard].memberId + memberDetails[selectedCard].memberDOB + memberDetails[selectedCard].firstName + '_sub';
        if (memberDetails[selectedCard].isMemberNotFound) {
            memUniqueId = providerUniqueId + memberDetails[selectedCard].firstName + memberDetails[selectedCard].lastName + memberDetails[selectedCard].memberDOB;
            houseHoldUnique = "";
        }
        
        let interactionCard = new Object();
        interactionCard.firstName = providerDetails.firstName;
        interactionCard.lastName = providerDetails.lastName;
        interactionCard.taxId = providerDetails.taxId;
        interactionCard.taxIdOrNPI = providerDetails.taxId ? providerDetails.taxId : providerDetails.taxIdOrNPI;
        interactionCard.filterType = providerDetails.filterType;
        interactionCard.npi = providerDetails.npi;
        interactionCard.phone = providerDetails.phoneNumber;
        interactionCard.primarySpeaciality = providerDetails.primarySpeciality;
        interactionCard.contactName = flowDetails.contactName;
        interactionCard.contactNumber = flowDetails.contactNumber;
        interactionCard.contactExt = flowDetails.contactExt;
        interactionCard.conName = flowDetails.contactName;
        interactionCard.contactType = providerDetails.contactType;
        interactionCard.conNumber = flowDetails.contactNumber;
        interactionCard.otherConExt = flowDetails.contactExt;
		interactionCard.corpMpin = providerDetails.corpMPIN;
        interactionCard.providerId = providerDetails.providerId;
        interactionCard.state = providerDetails.state;
		interactionCard.addressLine1 = providerDetails.addressLine1;
        interactionCard.addressLine2 = providerDetails.addressLine2;
        interactionCard.zip = providerDetails.zip;
        interactionCard.degreeCode = providerDetails.degreeCode;
        interactionCard.tpsmIndicator = providerDetails.tpsmIndicator;
        // US2931847
        interactionCard.addressId = providerDetails.addressId;

        
        var workspaceAPI = cmp.find("workspace");
        var matchingTabs = [];
        workspaceAPI.getAllTabInfo().then(function (response) {
            if (!$A.util.isEmpty(response)) {
                for (var i = 0; i < response.length; i++) {
                    for (var j = 0; j < response[i].subtabs.length; j++) {
                        if (response[i].subtabs.length > 0) {
                            var tabMemUniqueId = response[i].subtabs[j].pageReference.state.c__memberUniqueId;
                            if (memUniqueId === tabMemUniqueId) {
                                matchingTabs.push(response[i].subtabs[j]);
                                break;
                            }
                        }
                    }
                }
            }
            
            if (matchingTabs.length === 0) {
                var tabName = memberDetails[selectedCard].firstName;
                var contactDetails = {
                    "contactName": flowDetails.contactName,
                    "contactNumber": flowDetails.contactNumber,
                    "contactExt": flowDetails.contactExt
                };
                
                workspaceAPI.getEnclosingTabId().then(function (enclosingTabId) {
                    workspaceAPI.openSubtab({
                        parentTabId: enclosingTabId,
                        pageReference: {
                            "type": "standard__component",
                            "attributes": {
                                "componentName": "c__SAE_SnapshotOfMemberAndPolicies"
                            },
                            "state": {
                                "c__interactionOverviewTabId": cmp.get("v.interactionOverviewTabId"), //DE364195 - Avish
                                "c__interactionCard": interactionCard,
                                "c__subjectCard": subjectCardList[selectedCard],
                                "c__contactCard": contactDetails,
                                "c__contactName": flowDetails.contactName,
                                "c__contactNumber": flowDetails.contactNumber,
                                "c__memberUniqueId": memUniqueId,
                                "c__interactionRecord": cmp.get("v.interactionDetails"),
                                "c__searchOption": memberDetails[selectedCard].isMemberNotFound ? "" : (subjectCardList[selectedCard] != undefined ? subjectCardList[selectedCard].searchOption : ''),
                                "c__mnf": memberDetails[selectedCard].isMemberNotFound ? "mnf" : "",
                                "c__houseHoldUnique": houseHoldUnique,
                                "c__providerNotFound": providerDetails.isProviderNotFound,
                                "c__noMemberToSearch": memberDetails[selectedCard].isNoMemberToSearch,
                                "c__isProviderSearchDisabled": providerDetails.isNoProviderToSearch,
                                "c__isOtherSearch": providerDetails.isOther,
                                "c__otherDetails": interactionCard,
                                "c__isfindIndividualFlag": memberDetails[selectedCard].isFindIndividualSearch,
                                "c__memberContactName": flowDetails.contactName,
                                "c__memberContactNumber": flowDetails.contactNumber,
                                "c__memberCardFlag": !memberDetails[selectedCard].isNoMemberToSearch,
                                "c__providerUniqueId": providerUniqueId,
                                "c__interactionType": providerDetails.interactionType,
                                "c__isVCCD": cmp.get("v.isVCCD"), //US2631703 - Durga- 08th June 2020
                                "c__VCCDQuestionType": cmp.get("v.VCCDQuestionType"), //US2570805 - Sravan - 08/06/2020,
                                "c__iVRDetails": cmp.get("v.iVRDetails"), //US2858385 - Rizwan - 03/12/2021,
                                "c__hipaaEndpointUrl": cmp.get("v.hipaaEndpointUrl"),//US2076634 - Sravan - 22/06/2020
                                "c__providerDetails": providerDetails,
                                "c__providerDetailsForRoutingScreen": cmp.get("v.providerDetails"),//DE34738 - Praveen - 15/07/2020
                                "c__flowDetailsForRoutingScreen": cmp.get("v.flowDetails"),
                                "c__ioMemberSnapshotLinkId": event.currentTarget.id, // DE380979 - Thanish - Snapshot duplicate fix
                                "c__addressId": providerDetails.addressId,//US3145625 - Sravan
                                "c__memberEmails" : subjectCardList[selectedCard].emails,
                                "c__insuranceTypeCode":cmp.get("v.insuranceTypeCode")
                            }
                        },
                        focus: !event.ctrlKey
                    }).then(function (subtabId) {
                        // US2230775 - Thanish - 18th Aug 2020
                        var tabLabel = '';
                        if (!$A.util.isEmpty(memberDetails[selectedCard].firstName)) {
                            tabLabel = memberDetails[selectedCard].firstName.charAt(0).toUpperCase() + memberDetails[selectedCard].firstName.slice(1).toLowerCase() + " ";
                        }
                        if (!$A.util.isEmpty(memberDetails[selectedCard].lastName)) {
                            tabLabel = tabLabel + memberDetails[selectedCard].lastName.charAt(0).toUpperCase() + memberDetails[selectedCard].lastName.slice(1).toLowerCase();
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
                    }).catch(function (error) {
                        console.log(error);
                    });
                });
            } else {
                var focusTabId = matchingTabs[0].tabId;
                var tabURL = matchingTabs[0].url;
                workspaceAPI.openTab({
                    url: tabURL
                }).then(function (response) {
                    workspaceAPI.focusTab({
                        tabId: response
                    });
                }).catch(function (error) {
                    console.log(error);
                });
                // DE380979 - Thanish - Snapshot duplicate fix
                $A.util.removeClass(event.currentTarget, "disableLink");
            }
        })
    },
    
    handleSelect: function (cmp, event, helper) {
        var selectedMenuItemValue = event.getParam("value");
        var source = event.getSource();
        var srcName = source.get('v.name');
        var memberDetails = cmp.get('v.memberDetails');
        if (selectedMenuItemValue == 'CopySSN') {
            var textforcopy = memberDetails[srcName].ssn;
            helper.copyFieldValue(cmp, event, textforcopy);
        } else if (selectedMenuItemValue == 'CopyEEID') {
            var textforcopy = memberDetails[srcName].eeId;
            helper.copyFieldValue(cmp, event, textforcopy);
        } else if (selectedMenuItemValue == 'UnMaskSSN') {
            var unMask = cmp.find("formattedSSN");
            if ($A.util.isArray(unMask)) {
                unMask = unMask[srcName];
            }
            $A.util.removeClass(unMask, "slds-hide");
            var mask = cmp.find("maskedSSN");
            if ($A.util.isArray(mask)) {
                mask = mask[srcName];
            }
            $A.util.addClass(mask, "slds-hide");
        } else if (selectedMenuItemValue == 'UnMaskEEID') {
            var unMask = cmp.find("unMaskedEEID");
            if ($A.util.isArray(unMask)) {
                unMask = unMask[srcName];
            }
            $A.util.removeClass(unMask, "slds-hide");
            var mask = cmp.find("maskedEEID");
            if ($A.util.isArray(mask)) {
                mask = mask[srcName];
            }
            $A.util.addClass(mask, "slds-hide");
        }
    },
    //DE347387: ORS Issue - Provider information is missing in ORS routing Screen
    handlerGetContactNumber: function (cmp, event, helper) {
        /*var interactionOverviewTabId = cmp.get("v.pageReference").state.c__interactioOverviewTabUniqueId;
        var interactionOverviewData = JSON.parse(JSON.stringify(_setAndGetSessionValues.getInteractionDetails(interactionOverviewTabId)));
        var flowDetails = interactionOverviewData.flowDetails;
        var providerDetails = interactionOverviewData.providerDetails;
        //var flowDetails = cmp.get("v.flowDetails");
        //var providerDetails = cmp.get("v.providerDetails");
        var appEvent = $A.get("e.c:ACET_SendContactNumber");
        appEvent.setParams({
            "contactName": flowDetails.contactName,
            "contactNumber": flowDetails.contactNumber,
            "contactExt": flowDetails.contactExt,
            "providerDetails": providerDetails
            });
		appEvent.fire();*/
    }
})