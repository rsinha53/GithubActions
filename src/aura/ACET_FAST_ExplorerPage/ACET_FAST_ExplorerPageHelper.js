({
    initializeObjects: function (cmp) {
        var flowDetails = {
            "interactionType": "Email",
            "contactName": "",
            "contactNumber":"",
            "contactExt":"",
            "contactFirstName":"",
            "contactLastName":"",
            //US2903847
            "IVRInfo":"",
            "isGenesys":false,
            "GeneysysQuestionType":"",
            "caseRecordType":"Proactive Action"
            
        };
        cmp.set("v.flowDetails", flowDetails);
    },
	
    handleOnChangehelper: function(cmp,event){
         var flowDetails = cmp.get("v.flowDetails");
        flowDetails.caseRecordType=cmp.get("v.caseRecordType");
        var providerSrchComp = cmp.find("providerSearchCmp");
      //  var providerContactComp = cmp.find("providerContactCmp");
        
        //providerSrchComp.handleNoProviderToSearch(); 

        providerSrchComp.caseRecordTypepass(cmp.get("v.caseRecordType"));
      //  providerContactComp.providerContactCaseRecordTypepass(cmp.get("v.caseRecordType"));
        
        var selectedProviderDetails={};
        //Get the event
        var appEvent = $A.get("e.c:ACETFast_ProviderFlowDetailsEvent"); 
        //Set event attribute value
        appEvent.setParams({"providerFlowDetails" : cmp.get("v.flowDetails"),
                           "selectedProviderDetails" : selectedProviderDetails});
       
        appEvent.fire();        
    },
    
    populatePickListOptions: function (cmp) {
        var interactionTypeOptionsArray = ["Research", "Email", "Fax", "Portal", "Mail", "Text", "Walk-In", "Chat", "Claim"];
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
        var providerContactDetails = cmp.get("v.providerContactDetails");
        if( !$A.util.isUndefinedOrNull(providerDetails) && !$A.util.isUndefinedOrNull(providerDetails.isNoProviderToSearch) && providerDetails.isNoProviderToSearch
          && !$A.util.isUndefinedOrNull(providerContactDetails) && !$A.util.isUndefinedOrNull(providerContactDetails.isNoMemberToSearch) && !providerContactDetails.isNoMemberToSearch ){
            exploreOriginator = 'Member';
        }
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
                            "c__VCCDRespId" : cmp.get("v.VCCDObjRecordId")
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
    
    setCaseRecordTypevalue: function (cmp,event) {
        var action = cmp.get("c.getUserDetails");
                action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS"){
                var result = response.getReturnValue();
                cmp.set("v.userDetails",result);
                console.log('-result-'+ JSON.stringify(result) );
                console.log('-role-'+ result.UserRoleId);
               
                if(result.UserRoleId != undefined && result.UserRole.Name == 'PIR - Reactive Resolution'){
                    cmp.set("v.caseRecordType","Reactive Resolution");
                    this.handleOnChangehelper(cmp,event);
                }
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