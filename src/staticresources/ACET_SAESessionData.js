window._setAndGetSessionValues = (function () {
    var sessionDataMap = new Map();

    return {
        setInteractionDetails: function (interactionOverviewTabId, flowDetails, providerDetails, memberDetails, interactionDetails,highlightPanelData) {
            var membersData = [];
            var highlightPanelsData = [];
            if (!memberDetails.isNoMemberToSearch) {
                membersData.push(memberDetails);
            }
            var interactionData = {
                flowDetails: flowDetails,
                providerDetails: providerDetails,
                membersData: membersData,
                interactionDetails: interactionDetails,
                highlightPanelsData: highlightPanelsData,
                highlightPanelToDisplay: '',
                focusedCount: 0
            };
            sessionDataMap.set(interactionOverviewTabId, interactionData);
            return membersData.length - 1;
        },

        updateFlowDetails: function (interactionOverviewTabId, flowDetails) {
            var interactionData = sessionDataMap.get(interactionOverviewTabId);
            interactionData.flowDetails = flowDetails;
            sessionDataMap.set(interactionOverviewTabId, interactionData);
            return null;
        },

        updateProviderDetails: function (interactionOverviewTabId, providerDetails) {
            var interactionData = sessionDataMap.get(interactionOverviewTabId);
            interactionData.providerDetails = providerDetails;
            sessionDataMap.set(interactionOverviewTabId, interactionData);
            return null;
        },
        
        // US2330408  - Avish
        updateMemberDetails: function (interactionOverviewTabId, memberDetails) {
            var interactionData = sessionDataMap.get(interactionOverviewTabId);
            var membersData = interactionData.membersData;
            for(var i = 0; i < membersData.length; i++){
                if(membersData[i].memberId == memberDetails.memberId){
                    interactionData.membersData[i] = memberDetails;
                }
            }
            sessionDataMap.set(interactionOverviewTabId, interactionData);
            return null;
        },
		// US2330408  - Ends
        
        updateFocusedCount: function (interactionOverviewTabId) {
            var interactionData = sessionDataMap.get(interactionOverviewTabId);
            interactionData.focusedCount = ++interactionData.focusedCount;
            sessionDataMap.set(interactionOverviewTabId, interactionData);
            return null;
        },

        setInteractionRecordDetails: function (interactionOverviewTabId, interactionDetails) {
            var interactionData = sessionDataMap.get(interactionOverviewTabId);
            interactionData.interactionDetails = interactionDetails;
            sessionDataMap.set(interactionOverviewTabId, interactionData);
            return null;
        },

        getInteractionDetails: function (interactionOverviewTabId) {
            if (sessionDataMap.get(interactionOverviewTabId) != null) {
                return sessionDataMap.get(interactionOverviewTabId);
            }
            return null;
        },

        getSessionData: function (interactionOverviewTabId) {
            return sessionDataMap;
        },

        addNewHighLightMember: function (interactionOverviewTabId, panelData) {
            var interactionData = sessionDataMap.get(interactionOverviewTabId);
            var highlightPanelsData = interactionData.highlightPanelsData;
            var highlightPanelMap = new Map();
            var panelArray = [];
            for(var i = 0; i < highlightPanelsData.length; i++){
                var uniqueName = highlightPanelsData[i].memberID + highlightPanelsData[i].memberName;
                highlightPanelMap.set(uniqueName.replace(' ',''),highlightPanelsData[i]);
            }
            var panelName = (panelData.memberID + panelData.memberName).replace(' ','');
            if(!highlightPanelMap.has(panelName)){
                highlightPanelMap.set(panelName,panelData);
            }
            highlightPanelMap.forEach(function(value, key) {
                panelArray.push(value);
            }) 
            
            interactionData.highlightPanelsData = panelArray;
            interactionData.highlightPanelToDisplay = highlightPanelMap.get(panelName);
            sessionDataMap.set(interactionOverviewTabId, interactionData);
            return null;
        },

        addNewMember: function (interactionOverviewTabId, memberDetails) {
            var interactionData = sessionDataMap.get(interactionOverviewTabId);
            var membersData = interactionData.membersData;
            if(membersData.length == 0){
                if (!memberDetails.isNoMemberToSearch) {
                    membersData.push(memberDetails);
                }
            }else{
                for(var i = 0; i < membersData.length; i++){
                    if( (membersData[i].memberId != memberDetails.memberId && membersData[i].firstName != memberDetails.firstName &&
                         membersData[i].lastName != memberDetails.lastName) || membersData[i].memberId != memberDetails.memberId && membersData[i].dob != memberDetails.dob &&
                      membersData[i].firstName != memberDetails.firstName && membersData[i].lastName != memberDetails.lastName){
                        if (!memberDetails.isNoMemberToSearch) {
                            membersData.push(memberDetails);
                            break;
                        }
                    }
                }
            }
            sessionDataMap.set(interactionOverviewTabId, interactionData);
            return membersData.length - 1;
        },

        removeInteractionDetails: function (interactionOverviewTabId) {
            sessionDataMap.delete(interactionOverviewTabId);
            return null;
        },

        removeMember: function (interactionOverviewTabId, memberDetails) {
            debugger;
            var interactionData = sessionDataMap.get(interactionOverviewTabId);
            var membersData = interactionData.membersData;
            console.log(JSON.stringify(membersData));
            console.log(JSON.stringify(memberDetails));
            for (var k = 0; k < membersData.length; k++) {
                if (memberDetails.isMemberNotFound) {
                    if (memberDetails.firstName.toUpperCase() == membersData[k].firstName.toUpperCase() && memberDetails.lastName.toUpperCase() == membersData[k].lastName.toUpperCase() && memberDetails.dob == membersData[k].dob) {
                        membersData.splice(k, 1);
                    }
                } else {
                    if (memberDetails.subjectCard.memberId == membersData[k].memberId && memberDetails.subjectCard.memberDOB == membersData[k].dob &&
                        memberDetails.subjectCard.firstName.toUpperCase() == membersData[k].firstName.toUpperCase() && memberDetails.subjectCard.lastName.toUpperCase() == membersData[k].lastName.toUpperCase()) {
                        membersData.splice(k, 1);
                    }
                }
            }

            sessionDataMap.set(interactionOverviewTabId, interactionData);
            return null;
        },//setting map id and any type of value
        settingValue: function (ids,resValue) {
            sessionDataMap.set(ids, resValue);
            return null;
        },//getting value if there
        gettingValue: function (ids) {
            if (sessionDataMap.get(ids) != null) {
                return sessionDataMap.get(ids);
            }
            return null;
        }
    };
}());