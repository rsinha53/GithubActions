({
    onLoad : function(cmp,event,helper) {
        helper.showPolicySpinner(cmp);
        cmp.set("v.newReferralNumber","");
        cmp.set("v.offlstofViewPCPReferrals", null);
        cmp.set("v.onlstofViewPCPReferrals", null);
        cmp.set("v.lstofViewPCPReferrals",null);
        cmp.set("v.success_icon", $A.get('$Resource.SLDS') + '/assets/icons/action/approval_60.png');
        //cmp.set("v.fail_icon", $A.get('$Resource.SLDS') + '/assets/icons/action/close_60.png');
        helper.initHanlder(cmp,event,helper);
        // US3507751 - Save Case Consolidation
        var caseNotSavedTopics = cmp.get("v.caseNotSavedTopics");
        if (!caseNotSavedTopics.includes("View PCP Referrals")) {
            caseNotSavedTopics.push("View PCP Referrals");
        }
        cmp.set("v.caseNotSavedTopics", caseNotSavedTopics);
    },
    
	 // US3505126: Remove  Auto Doc Buttons: & Save Case - Krish - 19th May 2021
    /*
    openCommentsBox: function (component, event, helper) {
        component.set("v.isCommentsBox", true);
        component.set("v.disableCommentButton", true);
    }, */
    togglePopup : function(cmp, event) {
        let showPopup = event.currentTarget.getAttribute("data-popupId");
        cmp.find(showPopup).toggleVisibility();
    },
    
    handleKeyup : function(cmp) {
        var inputCmp = cmp.find("commentsBoxId");
        var value = inputCmp.get("v.value");
        var max = 2000;
        var remaining = max - value.length;
        cmp.set('v.charsRemaining', remaining);
        var errorMessage = 'Error!  You have reached the maximum character limit.  Add additional comments in Case Details as a new case comment.';
        if (value.length >= 2000) {
            inputCmp.setCustomValidity(errorMessage);
            inputCmp.reportValidity();
        } else {
            inputCmp.setCustomValidity('');
            inputCmp.reportValidity();
        }
    },
     // US3505126: Remove  Auto Doc Buttons: & Save Case - Krish - 19th May 2021
    /*
    // US2856421-Creating a Case for View PCP Referrals for ACET- UI
    openModal: function (component, event, helper) {

        helper.handleSaveModal(component, event, helper);
    },
    closeModal: function (component, event, helper) {
        // Set isModalOpen attribute to false
        component.set("v.isModalOpen", false);

    }, */

     activeToggle : function(component,event,helper){
        var activeState = ! component.get("v.isOnlyActive");
        component.set("v.isOnlyActive",activeState);
       
    },

    openCreateReferral: function(cmp,event,helper){
        var memberId = 'Create Referral';
        var InteractionRec = cmp.get("v.interactionRec");
        var providerLookupDetails= {
            "memberTabId" : cmp.get("v.memberTabId"),
            "interactionRec":cmp.get("v.interactionRec"),
            "contactUniqueId": cmp.get("v.contactUniqueId"),
            "noMemberToSearch" : cmp.get("v.noMemberToSearch"),
			"memberCardSnap" : cmp.get("v.memberCardSnap"),
			"policyDetails" : cmp.get('v.policy'),
			"memberPolicies" : JSON.stringify(cmp.get("v.memberPolicies")),
            "policySelectedIndex": cmp.get("v.policySelectedIndex"),
            "autodocPageFeature" : cmp.get("v.AutodocPageFeature"),
            "AutodocKey" : cmp.get("v.AutodocKey"),
            "AutodocPageFeatureMemberDtl" : cmp.get("v.AutodocPageFeatureMemberDtl"),
			"componentId" : cmp.get('v.componentId'),
			"isHippaInvokedInProviderSnapShot" : cmp.get('v.isHippaInvokedInProviderSnapShot'),
			"hipaaEndpointUrl" : cmp.get('v.hipaaEndpointUrl'),
            "caseNotSavedTopics" : cmp.get("v.caseNotSavedTopics"),
			"providerSearchResultsADMultiplePages" : cmp.get("v.providerSearchResultsADMultiplePages"),
            "AutodocKeyMemberDtl" : cmp.get("v.AutodocKeyMemberDtl"),
            "caseNotSavedTopics" : cmp.get("v.caseNotSavedTopics"),
            "providerDetailsForRoutingScreen" : cmp.get("v.providerDetailsForRoutingScreen"),
            "flowDetailsForRoutingScreen" : cmp.get("v.flowDetailsForRoutingScreen"),
            "memberCardData": cmp.get("v.memberCardData"),
			"interactionCard" : cmp.get('v.interactionCard'),
			"contactName" : cmp.get('v.contactName'),
			"selectedTabType" : cmp.get('v.selectedTabType'),
			"originatorType" : cmp.get('v.originatorType'), 
            "interactionOverviewTabId" : cmp.get("v.interactionOverviewTabId")
        };
		
        var workspaceAPI = cmp.find("workspace");
        var snapShotId;
        workspaceAPI.getEnclosingTabId().then(function (enclosingTabId) {
            
             snapShotId = enclosingTabId;
            workspaceAPI.openSubtab({
                parentTabId: enclosingTabId,
                pageReference: {
                    "type": "standard__component",
                    "attributes": {
                        "componentName": "c__ACET_CreateViewPCPReferral"
                    },
                    "state": {
                        "c__originatorType": cmp.get("v.originatorType"),
                        "c__interactionRec": InteractionRec,
                        "c__autodocUniqueId": cmp.get("v.autodocUniqueId"),
                        "c__hipaaEndpointUrl" : cmp.get("v.hipaaEndpointUrl"),
                        "c__isHippaInvokedInProviderSnapShot" : cmp.get("v.isHippaInvokedInProviderSnapShot"),
                        "c__policy" : cmp.get("v.policy"),
                        "c__providerLookupInfo" : providerLookupDetails,
                        "c__selectedSourceCode" :cmp.get("v.selectedSourceCode")
                        }
                    },
                    focus: true
                }).then(function (subtabId) {
                
                _setAndGetSessionValues.settingValue(subtabId,snapShotId);
                    workspaceAPI.setTabLabel({
                        tabId: subtabId,
                        label: memberId
                    });
                    workspaceAPI.setTabIcon({
                        tabId: subtabId,
                        icon: "standard:groups",
                        iconAlt: "Create Referral"
                    });
                }).catch(function (error) {
                    console.log(error);
                });
        });

    },
    
    afterCreateReferralRecord : function(component,event,helper){
        var isReferral = event.getParam("isReferral");
        var memberTabId = component.get('v.memberTabId');
        var memberTabIdEvent = event.getParam("memberTabId");
        if(!isReferral){
            return;
        }
        if(memberTabId != memberTabIdEvent){
            return;
        }
            if(!$A.util.isUndefinedOrNull(event.getParam("SRNNumber")) && (!$A.util.isEmpty(event.getParam("SRNNumber")))){
                debugger;
                component.set('v.newReferralNumber', event.getParam("SRNNumber"));
                component.set("v.offlstofViewPCPReferrals", null);
                component.set("v.onlstofViewPCPReferrals", null);
                component.set("v.lstofViewPCPReferrals",null);
                component.set("v.offCalloutDone",false);
        		component.set("v.onCalloutDone",false);
                helper.processInputRequest(component,event,helper);
            }

    },
    //US285583
    getNewReferrals : function(component,event,helper){
        helper.showPolicySpinner(component);
        component.set("v.newReferralNumber","");
        component.set("v.offlstofViewPCPReferrals", null);
        component.set("v.onlstofViewPCPReferrals", null);
        component.set("v.lstofViewPCPReferrals",null);
        component.set("v.policyChangeAlloffButton",true);
        component.set("v.offCalloutDone",false);
        component.set("v.onCalloutDone",false);
        component.set("v.isOnlyActive",false);
        helper.processInputRequest(component,event,helper);
        component.set("v.policyChangeAlloffButton",false);
        helper.hidePolicySpinner(component);
    },

    // US3505126: Remove  Auto Doc Buttons: & Save Case - Krish - 19th May 2021
    /*
    openPreview: function (component, event, helper) {
        var defaultAutoDoc = helper.getAutoDocObject(component);
        component.set("v.tableDetails_prev", defaultAutoDoc);
        component.set("v.isPreviewOpen", true);
    }, */

    activateAllReferrals : function(component,event,helper){
        //component.set("v.newReferralNumber","");
         helper.showPolicySpinner(component);
        if(!component.get("v.policyChangeAlloffButton")){
            if(component.get("v.isOnlyActive") ){
                if(!component.get("v.onCalloutDone")){
                    helper.processInputRequest(component,event,helper);
                }
                else{
                    component.set("v.lstofViewPCPReferrals",component.get("v.onlstofViewPCPReferrals"));
                    helper.createTableData(component);
                }

            }
            if(!component.get("v.isOnlyActive") ){
                if(!component.get("v.offCalloutDone")){
                     helper.processInputRequest(component,event,helper);
                }
                else{
                   component.set("v.lstofViewPCPReferrals",component.get("v.offlstofViewPCPReferrals"));
                    helper.createTableData(component);
                }

            }

        }

         helper.hidePolicySpinner(component);
    },

    handleAutodocRefresh: function (cmp, event, helper) {
        if (event.getParam("autodocUniqueId") == cmp.get("v.autodocUniqueId")) {
            _autodoc.resetAutodoc(cmp.get("v.autodocUniqueId"));
            helper.setDefaultAutodoc(cmp, true); // DE492618 - Thanish - 23rd Sept 2021
            var caseWrapper = cmp.get("v.caseWrapper");
            caseWrapper.savedAutodoc = '';
            caseWrapper.caseItems = [];
            cmp.set("v.caseWrapper", caseWrapper);
        }
    },

    // US3208169, US2917434
    navigateToLookup: function (cmp, event, helper) {
        event.stopPropagation(); // to stop this cmp event propagating to grandparent cmps
        var eventData = event.getParam("selectedRows");
        var cellIndex = event.getParam("currentCellIndex");
        var cellData = eventData.rowColumnData[cellIndex].cellData;
        var searchObject = new Object();
        searchObject.taxId = cellData.provTin;
        // searchObject.firstName = cellData.fName; // DE458124: Referral Results Remove first name in provider lookup hyperlinks - Krish - 8th July 2021
        searchObject.lastName = cellData.lName;
        searchObject.filterType = 'P';
        var linkClick = cmp.getEvent("headerClick");
        linkClick.setParams({
            "data": searchObject
        });
        linkClick.fire();
		if(cmp.get("v.isClaim")){
            var taxId = cellData.provTin; 
            var providerId='';
            helper.getProviderData(cmp, event, helper, taxId, providerId, cellIndex);    
        }						 
    },
    // Save Case Consolidation - US3424763
    setCaseWrapper: function(cmp, event, helper) {
        // DE482674 - Thanish - 1st Sep 2021
        var tableDetails = cmp.get("v.referralsTableData");
        if(tableDetails.selectedRows.length > 0){
            helper.setDefaultAutodoc(cmp, false); // DE492618 - Thanish - 23rd Sept 2021
        } else{
            helper.setDefaultAutodoc(cmp, true); // DE492618 - Thanish - 23rd Sept 2021
        }

        helper.handleSaveModal(cmp, event, helper);
    },
})