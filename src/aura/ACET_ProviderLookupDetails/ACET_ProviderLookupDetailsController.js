({
    openMisdirectComp: function (component, event, helper) {
        helper.openMisDirect(component, event, helper);
    },
    //Swapna
     selectAll: function (cmp, event) {
       var checked = event.getSource().get("v.checked");
        var cardDetails = cmp.get("v.providerData");
        var cardData = cardDetails.cardData;
        for (var i of cardData) {
            if (i.showCheckbox && !i.Checked) {
                i.checked = checked;
            }
        }
        cmp.set("v.providerData", cardDetails);
        //_autodoc.setAutodoc(cmp.get("v.autodocUniqueId"), cardDetails);
        _autodoc.setAutodoc(cmp.get("v.autodocUniqueId"),cmp.get("v.autodocUniqueIdCmp"), cardDetails);
    },
    //Swapna
    navigateToDetail:function(component,event,helper){

        var intId = event.currentTarget.getAttribute("data-intId");


        var workspaceAPI = component.find("workspace");
        workspaceAPI.openSubtab({
            pageReference: {
                type: 'standard__recordPage',
                attributes: {
                    actionName: 'view',
                    objectApiName: 'Interaction__c',
                    recordId : intId
                },
            },
            focus: true
        }).then(function(response) {
            workspaceAPI.getTabInfo({
                tabId: response

            }).then(function(tabInfo) {
                });
            }).catch(function(error) {
                console.log(error);
            });
    },
    
    doInit: function (cmp, event, helper) {
        helper.showLookupSpinner(cmp);

        // US2320729 - Thanish - 2nd Mar 2020
        cmp.set("v.uniqueKey", new Date().getTime());
        // US1958723 - Provider Lookup UI
        var pageReference = cmp.get("v.pageReference");
        //Added by Vinayto get the selectedRowData
        var providerDetails1 = pageReference.state.c__slectedRowLinkData;

        var autodocUniqueId = pageReference.state.c__autodocUniqueId;// + providerDetails.providerId + providerDetails.addressId;
        cmp.set("v.autodocUniqueId",autodocUniqueId);
        cmp.set("v.autodocUniqueIdCmp", pageReference.state.c__autodocUniqueIdCmp);
        cmp.set("v.claimNo", pageReference.state.c__claimNo);
        console.log("claim No Provider"+pageReference.state.c__claimNo);
                console.log("claim No Provider ui"+cmp.get("v.claimNo"));

        cmp.set("v.currentIndexOfOpenedTabs", pageReference.state.c__currentIndexOfOpenedTabs);
        cmp.set("v.maxAutoDocComponents", pageReference.state.c__maxAutoDocComponents);

        cmp.set("v.isMemberFocused", !pageReference.state.c__isProviderSnapshot); // US2623985 - Thanish - 10th Jun 2020
        cmp.set("v.filterParameters", pageReference.state.c__contractFilterData); // US2623985 - Thanish - 10th Jun 2020
        cmp.set("v.provSearchResultsUniqueId", pageReference.state.c__provSearchResultsUniqueId); // DE307193 - Thanish 20th March 2020
        cmp.set("v.resultsTableRowData", pageReference.state.c__resultsTableRowData); // DE307193 - Thanish 20th March 2020
        var providerDetails = pageReference.state.c__providerDetails;
        var providerNotFound = pageReference.state.c__providerNotFound;
        cmp.get("v.providerNotFound",providerNotFound);
        var noMemberToSearch = pageReference.state.c__noMemberToSearch;
        cmp.get("v.noMemberToSearch",noMemberToSearch);
        cmp.set("v.contactUniqueId",pageReference.state.c__contactUniqueId);
        //US2076634 - HIPAA Guidelines Button - Sravan - Start
        var hipaaEndPointUrl = pageReference.state.c__hipaaEndpointUrl;
        cmp.set("v.hipaaEndpointUrl",hipaaEndPointUrl);
        //US2076634 - HIPAA Guidelines Button - Sravan - End
		var currentRowIndex = pageReference.state.c__currentRowIndex;
        cmp.set("v.currentRowIndex",currentRowIndex);
        //DE347387 Praveen
        var providerDetailsForRoutingScreen = pageReference.state.c__providerDetailsForRoutingScreen;
        cmp.set("v.providerDetailsForRoutingScreen", providerDetailsForRoutingScreen);
        var flowDetailsForRoutingScreen = pageReference.state.c__flowDetailsForRoutingScreen;
        cmp.set("v.flowDetailsForRoutingScreen", flowDetailsForRoutingScreen);
var claimNo = cmp.get("v.claimNo");
		console.log("claimNo Provider"+claimNo);
       // US1958736 - Thanish - 5th Feb 2020 - removing hardcoded values and integrating dynamic values
        providerDetails.interactionId = pageReference.state.c__interactionRec.Id;
        providerDetails.interactionName = pageReference.state.c__interactionRec.Name;
        providerDetails.providerNotFound = false;
        providerDetails.isProviderSearchDisabled = false;
        var sourceCode = pageReference.state.c__sourceCode;
        cmp.set("v.sourceCode",sourceCode);
       providerDetails.isPhysician = providerDetails.isPhysician == "true" || providerDetails.isPhysician == true ? true : false;


        // US2320729 - Thanish - 27th Feb 2020
        cmp.set("v.AutodocKey", pageReference.state.c__autodocKey);
        cmp.set("v.autodocPageFeature", pageReference.state.c__autodocPageFeature);
        cmp.set("v.autodocUniqueId", pageReference.state.c__autodocPageFeature);
        // End of Code - US2320729 - Thanish - 27th Feb 2020

        cmp.set("v.providerDetails", providerDetails);
        cmp.set("v.taxId", providerDetails.taxId);
        cmp.set("v.providerId", providerDetails.providerId);

        // US1958736 - Thanish - 6th Feb 2020 - removing static data and binding dynamic data
        var memberDetails = pageReference.state.c__memberDetails;
        memberDetails.hasMember = memberDetails.noMemberToSearch == "false" || memberDetails.noMemberToSearch == false ? true : false;
        cmp.set("v.memberDetails", memberDetails);

        //US2491365 - Avish
        cmp.set("v.memberId", memberDetails.memberId);
        cmp.set("v.interactionOverviewTabId", pageReference.state.c__interactionOverviewTabId);

        // Case Creation
        var subjectDetails = new Object();
        cmp.set("v.subjectDetails", subjectDetails);

        cmp.set("v.interactionRec", pageReference.state.c__interactionRec);

        //KJ open provider lookup from claim
        cmp.set("v.isClaim", pageReference.state.c__isClaim);

        if(!cmp.get("v.isClaim")){
            var callTopicLst = JSON.parse(pageReference.state.c__callTopicLstSelected);
            cmp.set("v.callTopicLstSelected",callTopicLst );
    	}

        cmp.set("v.callTopicTabId",pageReference.state.c__callTopicTabId);

        let strBenefitPlanId = pageReference.state.c__benefitPlanId;

        helper.getProviderData(cmp);
        // US2696849 - Thanish - 22nd Jul 2020
        cmp.set("v.contractApiParameters",{ "taxId" : providerDetails.taxId, "providerId" : providerDetails.providerId, "addressId" : providerDetails.addressId, "addressSeq" : providerDetails.addressSequence, "benefitPlanId":strBenefitPlanId});
		//Jitendra
        // /US3446590 - Thanish - 21st Apr 2021
        cmp.set("v.transactionId", pageReference.state.c__transactionId);
		if(cmp.get("v.isClaim")){
        setTimeout(function() {
                 cmp.find("Providerlookup").getElement().scrollIntoView({
                        behavior: 'smooth',
                        block: 'center',
                        inline: 'nearest'
                    });
                 }, 100);
        }						 
    },

    // DE307193 - Thanish - 12th Mar 2020
    onTabClosed: function (cmp, event, helper) {
        let tabId = event.getParam('tabId');
 		 if(!cmp.get("v.isClaim")){ ////KJ open provider lookup from claim
            if(tabId == cmp.get("v.tabId")) {
                let tabClosedEvt = $A.get("e.c:ACET_EnableAutoDocLink");
                tabClosedEvt.setParams({
                    //"provSearchResultsUniqueId" : cmp.get("v.provSearchResultsUniqueId"),
                    "closedTabId" : tabId,
                    "openedLinkData":cmp.get("v.resultsTableRowData"),
                    "currentRowIndex":cmp.get("v.currentRowIndex")
                    //"lookupResultsTableRowData": cmp.get("v.resultsTableRowData")
                });
                tabClosedEvt.fire();
            }
        }
    },

    // DE307193 - Thanish - 12th Mar 2020
    onTabFocused: function (cmp, event, helper) {
        let focusedTabId = event.getParam('currentTabId');
        let tabId = cmp.get("v.tabId");

        if($A.util.isEmpty(tabId)) {
            cmp.set("v.tabId", focusedTabId);
        }
    },
    
    //US2076634 - HIPAA Guidelines Button - Sravan
	handleHippaGuideLines: function (cmp, event, helper) {
        var hipaaCard = new Object();
        hipaaCard.type = 'card';
        hipaaCard.componentName = 'HIPAA Guidelines';
        hipaaCard.noOfColumns = 'slds-size_6-of-12';
        hipaaCard.componentOrder = 1.5;
        var cardData = [];
        cardData.push(new fieldDetails(true,false,true,'HIPAA Guidelines','Accessed','outputText'));
        hipaaCard.cardData = cardData;        
        _autodoc.setAutodoc(cmp.get("v.autodocUniqueId"),cmp.get("v.autodocUniqueIdCmp"), hipaaCard);
        function fieldDetails(c, dc, sc, fn, fv, ft) {
            this.checked = c;
            this.defaultChecked = dc;
            this.showCheckbox = sc;
            this.fieldName = fn;
            this.fieldValue = fv;
            this.fieldType = ft;
        }
        
        var hipaaEndPointUrl = cmp.get("v.hipaaEndpointUrl");
		if (!$A.util.isUndefinedOrNull(hipaaEndPointUrl) && !$A.util.isEmpty(hipaaEndPointUrl)) {
			window.open(hipaaEndPointUrl, '_blank');
		}
        
	},

    navigateToCallTopic : function(component, event, helper){
       var selectedPillId = event.getSource().get("v.label");
        component.set("v.callTopicName",selectedPillId);
        var calltopictabid = component.get("v.callTopicTabId");
        var workspaceAPI = component.find("workspace");
        workspaceAPI.focusTab({
            tabId : calltopictabid
        }).then(function(response) {
            console.log("tabfocused");
            var focusCalltopicTab = component.get('c.focusCalltopicTab');
            $A.enqueueAction(focusCalltopicTab);
       }).catch(function(error) {
            console.log(error);
        });
    },

    toggleSection: function (component, event, helper) {
        var sectionAuraId = event.target.getAttribute("data-auraId");
        var sectionDiv = component.find(sectionAuraId).getElement();

        var sectionState = sectionDiv.getAttribute('class').search('slds-is-close');

        if (sectionState == -1) {
            sectionDiv.setAttribute('class', 'slds-section slds-is-close');
            component.set("v.showHighlightsPanel",false);//US3189884 - Sravan
        } else {
            sectionDiv.setAttribute('class', 'slds-section slds-is-open');
            component.set("v.showHighlightsPanel",true);//US3189884 - Sravan
	}
    },

    focusCalltopicTab: function (component, event, helper) {
        var selectedPillId = component.get("v.callTopicName");
        var tabIdFreezePanel = component.get("v.callTopicTabId");
        var appEvent = $A.get("e.c:ACET_navigateToCallTopic");
        appEvent.setParams({
            "callTopicName" : selectedPillId,
            "tabId":tabIdFreezePanel
        });
        setTimeout(function(){
            appEvent.fire();
        }, 100);
    },
})