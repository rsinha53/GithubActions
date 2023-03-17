({
    initializeObjects: function (cmp) {
        var flowDetails = {
            "interactionType": "Incoming Call",
            "contactName": "",
            "contactNumber":"",
            "contactExt":"",
            "contactFirstName":"",
            "contactLastName":"",
            //US2903847
            "IVRInfo":"",
            "isGenesys":false,
            "GeneysysQuestionType":""
        };
        cmp.set("v.flowDetails", flowDetails);
    },

    populatePickListOptions: function (cmp) {
        var interactionTypeOptionsArray = ["Incoming Call", "Outbound Call", "Research", "Email", "Fax", "Portal", "Mail", "Text", "Walk-In", "Chat", "Claim"];
        var interactionTypeOptions = [];
        for (var i = 0; i < interactionTypeOptionsArray.length; i++) {
            interactionTypeOptions.push({
                label: interactionTypeOptionsArray[i],
                value: interactionTypeOptionsArray[i]
            });
        }
        cmp.set('v.interactionTypeOptions', interactionTypeOptions);
        this.getStateOptions(cmp);
    },

    closeInteractionOverviewTabs: function (cmp) {
        var workspaceAPI = cmp.find("workspace");
        if (!$A.util.isEmpty(workspaceAPI)) {
            workspaceAPI.getAllTabInfo().then(function (response) {
                    if (!$A.util.isEmpty(response)) {
                        for (var i = 0; i < response.length; i++) {
                            if (response[i].pageReference.attributes.componentName == "c__ACET_InteractionOverview") {
                                var focusedTabId = response[i].tabId;
                                workspaceAPI.closeTab({
                                    tabId: focusedTabId
                                });
                            }
                        }
                    }
                })
                .catch(function (error) {
                    console.log(error);
                });
        }
    },
    
    openMisDirect:function(cmp){
        var exploreOriginator= 'Provider';
       	var providerDetails = cmp.get("v.providerDetails");
        var memberDetails = cmp.get("v.memberDetails");
        if( !$A.util.isUndefinedOrNull(providerDetails) && !$A.util.isUndefinedOrNull(providerDetails.isNoProviderToSearch) && providerDetails.isNoProviderToSearch
          && !$A.util.isUndefinedOrNull(memberDetails) && !$A.util.isUndefinedOrNull(memberDetails.isNoMemberToSearch) && !memberDetails.isNoMemberToSearch ){
            exploreOriginator = 'Member';
        }
        console.log('Selected Provider Details'+ JSON.stringify(cmp.get("v.selectedProviderDetails")));
        console.log('Selected Provider Details'+ JSON.stringify(cmp.get("v.providerDetails")));
        console.log('Selected Member Details'+ JSON.stringify(cmp.get("v.memberDetails")));
         console.log('Selected Member Details In Advance Search'+ JSON.stringify(cmp.get("v.selectedMemberDetails")));
        var workspaceAPI = cmp.find("workspace");
        //US2598275: Updates to Contact Name Entry Field
        _setandgetvalues.setContactValue('exploreContactData',cmp.get("v.flowDetails.contactName"),cmp.get("v.flowDetails.contactNumber"),cmp.get("v.flowDetails.contactExt"),cmp.get("v.flowDetails.contactFirstName"),cmp.get("v.flowDetails.contactLastName"));
        workspaceAPI.getEnclosingTabId().then(function(enclosingTabId) {
            if(enclosingTabId == false){
                workspaceAPI.openTab({
                    pageReference: {
                        "type": "standard__component",
                        "attributes": {
                            "componentName": "c__SAE_MisdirectComponent"
                        },
                        "state": {
                            "c__contactUniqueId": "exploreContactData",
							"c__focusedTabId": "exploretab",
                            "c__exploreOriginator":exploreOriginator,
                            "c__flowInfo":cmp.get("v.flowDetails"),
                            "c__isVCCD" : cmp.get("v.isVCCD"),
                            "c__VCCDRespId" : cmp.get("v.VCCDObjRecordId"),
                            "c__selectedProviderDetails" : cmp.get("v.selectedProviderDetails"),//US3612768 - Sravan
                            "c__memberDetails" : cmp.get("v.memberDetails"),//US3612768 - Sravan
                            "c__providerDetails" : cmp.get("v.providerDetails"),//US3612768 - Sravan
                            "c__selectedMemberDetails" : cmp.get("v.selectedMemberDetails"),//US3612768 - Sravan
                            "c__isOther" : cmp.get("v.isOther")//US3612768 - Sravan
                        }
                    },
                    focus: true
                }).then(function(response) {
                    workspaceAPI.getTabInfo({
                        tabId: response
                    }).then(function(tabInfo) {
                        var focusedTabId = tabInfo.tabId;
                        workspaceAPI.setTabLabel({
                            tabId: focusedTabId,
                            label: "Misdirect"
                        });
                        workspaceAPI.setTabIcon({
                            tabId: focusedTabId,
                            icon: "standard:decision",
                            iconAlt: "Misdirect"
                        });
                    });
                }).catch(function(error) {
                    console.log(error);
                });
            }
        });
    },

    getQuestionTypeforGenesys : function(cmp,flowDetails,questionType){
        var action = cmp.get('c.getQuestionTypeValueforIVR');
        action.setParams({
            'QuestionTypeCode': questionType
        });
        action.setCallback(this, function (actionResult) {
            var state = actionResult.getState();
            var questionMapping = actionResult.getReturnValue();
            if (state === "SUCCESS") {
                flowDetails.GeneysysQuestionType = questionMapping;
                cmp.set("v.flowDetails", flowDetails);
            }
        });
        $A.enqueueAction(action);
    },

    getStateOptions: function (cmp) {
		var action = cmp.get('c.getStateValues');
		action.setCallback(this, function (actionResult) {
			var stateOptions = [];
			for (var i = 0; i < actionResult.getReturnValue().length; i++) {
				stateOptions.push({
					label: actionResult.getReturnValue()[i].DeveloperName,
					value: actionResult.getReturnValue()[i].DeveloperName
				});
			}
			stateOptions.unshift({
				label: '--None--',
				value: ''
			});
			cmp.set('v.stateOptions', stateOptions);
		});
		$A.enqueueAction(action);
	},

})