({
    openMisdirectComp: function (component, event, helper) {
        helper.openMisDirect(component, event, helper);
    },
    
    openCommentsBox : function (component, event, helper) {
        debugger;
        var isCommentsBox = event.getParam("isCommentsBox");
		component.set("v.isCommentsBox",isCommentsBox);
	},
    
    // US3536342 - Thanish - 3rd Jun 2021
    togglePopup : function(cmp, event) {
        let showPopup = event.currentTarget.getAttribute("data-popupId");
        cmp.find(showPopup).toggleVisibility();
    },
    
    // US3536342 - Thanish - 3rd Jun 2021
    handleKeyup : function(cmp) {
        var inputCmp = cmp.find("overAllCommentsBoxId");
        var value = inputCmp.get("v.value");
        var errorMessage = 'Error!  You have reached the maximum character limit.  Add additional comments in Case Details as a new case comment.';
        if (value.length >= 2000) {
            inputCmp.setCustomValidity(errorMessage);
            inputCmp.reportValidity();
        } else {
            inputCmp.setCustomValidity('');
            inputCmp.reportValidity();
        }
    },

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
    
	doInit : function(component, event, helper) {
        helper.showLookupSpinner(component);
        helper.getEnclosingTabIdHelper(component, event);
        var pageReference = component.get("v.pageReference");
		var providerNotFound = pageReference.state.c__providerNotFound; 
        var noMemberToSearch = pageReference.state.c__noMemberToSearch;
        var isProviderSearchDisabled = pageReference.state.c__isProviderSearchDisabled; 
        component.set("v.isProviderSearchDisabled", isProviderSearchDisabled);
        var mnf = pageReference.state.c__mnf;
        component.set("v.noMemberToSearch", noMemberToSearch);
        component.set("v.providerNotFound", providerNotFound);
        component.set("v.mnf", mnf);

        component.set("v.interactionOverviewTabId", pageReference.state.c__interactionOverviewTabId); //DE364195 - Avish
       

        //US3259671 - Sravan - Start
        var interactionOverviewTabId = component.get("v.interactionOverviewTabId");
        if(!$A.util.isUndefinedOrNull(interactionOverviewTabId) && !$A.util.isEmpty(interactionOverviewTabId)){
            var interactionOverviewData = JSON.parse(JSON.stringify(_setAndGetSessionValues.getInteractionDetails(interactionOverviewTabId)));
            var flowDetails = interactionOverviewData.flowDetails;
            component.set("v.flowDetails",flowDetails);
            console.log('Flow Details'+ JSON.stringify(flowDetails));
        }
        //US3259671 - Sravan - End

        var isPhysician = pageReference.state.c__isPhysician;
        component.set("v.isPhysician", isPhysician);

        //US2076634 - HIPAA Guidelines Button - Sravan - Start
        var hipaaEndPointUrl = pageReference.state.c__hipaaEndpointUrl;
        component.set("v.hipaaEndpointUrl",hipaaEndPointUrl);
        //US2076634 - HIPAA Guidelines Button - Sravan - End

        //US2897253 - VCCD - Member/Provider Snapshot Page - Topic Integration - Sravan
                var isVCCD = pageReference.state.c__isVCCD;
                var VCCDQuestionType = pageReference.state.c__VCCDQuestionType;
                var postVCCDEvent = $A.get("e.c:ACET_PostVCCD");
                postVCCDEvent.setParams({"isVCCD":isVCCD,"VCCDQuestionType":VCCDQuestionType,"pageName":"Provider Snapshot"});
                postVCCDEvent.fire();

        //DE347387 Praveen
        var providerDetailsForRoutingScreen = pageReference.state.c__providerDetailsForRoutingScreen;
        component.set("v.providerDetailsForRoutingScreen", providerDetailsForRoutingScreen);
        var flowDetailsForRoutingScreen = pageReference.state.c__flowDetailsForRoutingScreen;
        component.set("v.flowDetailsForRoutingScreen", flowDetailsForRoutingScreen);
        console.log('Flow Details'+ JSON.stringify(component.get("v.flowDetailsForRoutingScreen")));

        // US1816853 - Sanka
        var taxId = pageReference.state.c__taxId != null ? pageReference.state.c__taxId : '';
        var providerId = pageReference.state.c__providerId != null ? pageReference.state.c__providerId : '';
        var addrSequence = pageReference.state.c__addrSequence != null ? pageReference.state.c__addrSequence : '';
        var interactionName = pageReference.state.c__interactionName != null ? pageReference.state.c__interactionName : '';
        var interactionId = pageReference.state.c__interactionId != null ? pageReference.state.c__interactionId : '';

        //DE378161
        var autodockey =  interactionId + taxId + providerId + Date.now();

        component.set("v.autodocUniqueId",autodockey );
        // US3507762 - Create Overall Save Case Button on Provider Snapshot Page - Thanish - 20th May 2021
        var openedTopicUniqueIds = [];
        openedTopicUniqueIds.push(autodockey + "providerDetails"); // DE456072 - Thanish - 17th Jun 2021
        component.set("v.openedTopicUniqueIds",openedTopicUniqueIds);
        // US2091974 - Sanka - Case Creation
        var subjectDetails = pageReference.state.c__subjectDetails != null ? pageReference.state.c__subjectDetails : new Object();
        
        // US1918689 - Thanish - 13th Nov 2019 - passing addressID of physician.
        var addressId = $A.util.isEmpty(pageReference.state.c__addressId) ? 'physiciandetails' : pageReference.state.c__addressId;
        component.set("v.autodocPageFeature", addressId);

        // Thanish - optimizing contract summary - 4th Nov 2020
        component.set("v.taxId", taxId);
        component.set("v.providerId", providerId);
        component.set("v.addrSequence", addrSequence);
        component.set("v.addressId", addressId);
        component.set("v.interactionName", interactionName);
        component.set("v.interactionId", interactionId);
        component.set("v.interactionRec", pageReference.state.c__interactionRec);

        // US3389424: View Payments - Select Claim # Hyperlink in Payment Details - Swapnil
        var interactionCard= pageReference.state.c__interactionCard != null ? pageReference.state.c__interactionCard : new Object();
        component.set("v.interactionCard", interactionCard);
        var contactCard= pageReference.state.c__contactDetails != null ? pageReference.state.c__contactDetails : new Object();
        component.set("v.contactCard", contactCard);

        // US2091974 - Sanka - Case Creation
        component.set("v.subjectDetails",subjectDetails);

        helper.getProviderData(component, event, helper);
        
        //Added by Vinay
        component.find("alertsAI").alertsMethodShapshots();
        
        // US1959855 - Thanish - 23rd January 2020
        // Populating case wrapper
        let caseWrapper = new Object();
        // Flow details
        caseWrapper.noProviderToSearch = isProviderSearchDisabled;
        caseWrapper.providerNotFound = providerNotFound;
		caseWrapper.noMemberToSearch = noMemberToSearch;
		caseWrapper.mnf = mnf;
        // Provider details
        caseWrapper.providerId = providerId;
        caseWrapper.TaxId = taxId;
        caseWrapper.providerContactId = pageReference.state.c__interactionRec.Originator__c;
		caseWrapper.OriginatorName = '';
		caseWrapper.OriginatorType = 'Provider';
		caseWrapper.Interaction = interactionId;
        caseWrapper.OriginatorContactName = subjectDetails.contactName;
        //US2740876 - Sravan - Start
        caseWrapper.OriginatorFirstName = component.get("v.flowDetailsForRoutingScreen").contactFirstName;
        caseWrapper.OriginatorLastName =  component.get("v.flowDetailsForRoutingScreen").contactLastName;
        //US2740876 - Sravan - End
        // Subject Card
		caseWrapper.SubjectName = subjectDetails.fullName;
		caseWrapper.SubjectType = subjectDetails.subjectType;
		caseWrapper.SubjectDOB = subjectDetails.DOB;
		caseWrapper.SubjectId = subjectDetails.subjectId;
        caseWrapper.SubjectGroupId = subjectDetails.subjectGroupId;
        
        //US2699902 - Avish
        caseWrapper.contactNumber = subjectDetails.contactNumber;
        caseWrapper.contactExt = subjectDetails.contactExt;

        // US2815284 - Sanka
        caseWrapper.refreshUnique = autodockey;

        //DE347387 Praveen
        var providerDetailsForRoutingScreen = pageReference.state.c__providerDetailsForRoutingScreen;
        component.set("v.providerDetailsForRoutingScreen", providerDetailsForRoutingScreen);
        var flowDetailsForRoutingScreen = pageReference.state.c__flowDetailsForRoutingScreen;
        component.set("v.flowDetailsForRoutingScreen", flowDetailsForRoutingScreen);

        // DE348406 - Sanka - 20th Jul 2020
        if(providerDetailsForRoutingScreen != null){
            caseWrapper.plFirstName = providerDetailsForRoutingScreen.firstName;
            caseWrapper.plLastName = providerDetailsForRoutingScreen.lastName;
            caseWrapper.plMpin = providerDetailsForRoutingScreen.corpMPIN;
            caseWrapper.plProviderID = providerDetailsForRoutingScreen.providerId;
            caseWrapper.plState = providerDetailsForRoutingScreen.state;
            caseWrapper.plStreet1 = providerDetailsForRoutingScreen.addressLine1;
            caseWrapper.plStreet2 = providerDetailsForRoutingScreen.addressLine2;
            caseWrapper.plZip = providerDetailsForRoutingScreen.zip;
            caseWrapper.plTaxId = providerDetailsForRoutingScreen.taxId;
            caseWrapper.providerNPI = providerDetailsForRoutingScreen.npi;
            caseWrapper.degree = providerDetailsForRoutingScreen.degreeCode;
            caseWrapper.providerMpin = providerDetailsForRoutingScreen.corpMPIN;
            caseWrapper.providerTpsm = providerDetailsForRoutingScreen.tpsmIndicator;
            //US2784325
            caseWrapper.phoneNumber = providerDetailsForRoutingScreen.EffectivePhoneNumber;
            caseWrapper.providerInfoCity =  providerDetailsForRoutingScreen.AddressCity;
        }

        //DefaultCase item
        var caseItem = new Object();
        caseItem.uniqueKey = taxId;
        caseItem.isResolved = true;
        caseItem.topic = 'Provider Details';//US3071655 - Sravan
        var caseItemList = [];
        caseItemList.push(caseItem);
        caseWrapper.caseItems = caseItemList;

        component.set("v.caseWrapper", caseWrapper);
        //component.find("caseHistoryCard").callCasesFromORS();

        // DE380979 - Thanish - Snapshot duplicate fix
        var snapshotLink = document.getElementById(pageReference.state.c__ioProviderSnapshotLinkId);
        if(!$A.util.isEmpty(snapshotLink)){
            $A.util.removeClass(snapshotLink, "disableLink");
        }
        // US3536342 - Thanish - 3rd Jun 2021 - removed old code
    },

    handleTopicClick: function (component, event, helper) {
         component.set("v.paymentTopicNO", 1);
        component.set("v.providerTopicNO", 2);
        if (event.getParam("clickedTopic") == 'Provider Lookup') {
            component.set("v.showProviderLookup", true);
            // DE456072 - Thanish - 17th Jun 2021
            var openedTopicUniqueIds = component.get("v.openedTopicUniqueIds");
            openedTopicUniqueIds.push(component.get("v.autodocUniqueId") + "providerLookup");
            component.set("v.openedTopicUniqueIds",openedTopicUniqueIds);

            var providerLookup = component.find("providerLookup");
            if(!$A.util.isUndefinedOrNull(providerLookup)){
            setTimeout(function () {
                component.find("providerLookupPrvdSnapshot").getElement().scrollIntoView({
                    behavior: "smooth",
                    block: 'start',
                	inline: 'nearest'
                });
            }, 100);
	}
        }

        if (event.getParam("clickedTopic") == 'Provider Lookup SearchResults') {
            var providerLookup = component.find("providerLookup");
            if(!$A.util.isUndefinedOrNull(providerLookup)){
                setTimeout(function () {
                    component.find("providerLookup").find("providerLookupPrvdSearchResults").getElement().scrollIntoView({
                        behavior: "smooth",
                        block: 'start',
                        inline: 'nearest'
                    });
                }, 100);
	        }
        }

    },

    viewPaymentTopicClick: function(component, event, helper){
        component.set("v.paymentTopicNO", 2);
        component.set("v.providerTopicNO", 1);
        component.set("v.ViewPayment", true);
                    setTimeout(function () {
                 component.find("paymentInfo").getElement().scrollIntoView({behavior: "smooth",block: "start"});
                }, 100);
        },

    handleHippaGuideLines: function (cmp, event, helper) {
        var hipaaCard = new Object();
        hipaaCard.type = 'card';
        hipaaCard.componentName = 'HIPAA Guidelines';
        hipaaCard.noOfColumns = 'slds-size_6-of-12';
        hipaaCard.componentOrder = 0; // DE373867 - Thanish - 8th Oct 2020
        var cardData = [];
        cardData.push(new fieldDetails(true,false,true,'HIPAA Guidelines','Accessed','outputText')); // DE373867 - Thanish - 8th Oct 2020
        hipaaCard.cardData = cardData;        
        _autodoc.setAutodoc(cmp.get("v.autodocUniqueId"),cmp.get("v.autodocUniqueId"), hipaaCard);
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
        //callcontainer
        component.set("v.callTopicName",selectedPillId);
        var callTopicName = selectedPillId;
        helper.navigateToCallTopicEvent(component, event, helper,callTopicName);
    },

    // US3536342 - Thanish - 3rd Jun 2021
    toggleSection: function (cmp, event, helper) {
        cmp.set("v.showHighlightsPanel", !cmp.get("v.showHighlightsPanel"));
        $A.util.toggleClass(event.currentTarget, "isOpened");
    },

    toggleComments: function (cmp, event, helper) {
        cmp.set("v.showComments", !cmp.get("v.showComments"));
        $A.util.toggleClass(event.currentTarget, "isOpened");
    },

    navigateToCallTopicScroll: function(component, event, helper) {
        var callTopicName = component.get("v.callTopicName");
        helper.navigateToCallTopicEvent(component, event, helper,callTopicName);
        /*if (!$A.util.isUndefinedOrNull(callTopicName) && callTopicName == "Provider Lookup") {
            component.find("providerLookupPrvdSnapshot").getElement().scrollIntoView({
                behavior: 'smooth',
                block: 'start',
                inline: 'nearest'
            });
        }
        component.set("v.callTopicName","");*/
    },
    navigateToCallTopicEventHandler: function(component, event, helper) {
        var selectedPillId = event.getParam("callTopicName");
        var callTopicTabId = event.getParam("tabId");
        if(component.get("v.callTopicTabId") === callTopicTabId){
            component.set("v.callTopicName",selectedPillId);
            var callTopicName = selectedPillId;
            helper.navigateToCallTopicEvent(component, event, helper,callTopicName);
        }
    },
    // US3516117: Create Overall Auto Doc Button on Provider Snapshot Page - Krish - 19th May 2021
    getAllAutoDoc: function (cmp, event, helper) {
        console.log(cmp.get("v.autodocUniqueId"));
        var autoItems = _autodoc.getAllAutoDoc(cmp.get("v.autodocUniqueId"), true);
        cmp.set("v.tableDetails_prev", autoItems.selectedList);
        cmp.set("v.showpreview", true);
        console.log(JSON.stringify(autoItems));
    },
    // US3507762 - Create Overall Save Case Button on Provider Snapshot Page - Thanish - 20th May 2021
    openSaveCase: function (cmp, event, helper) {
        var returnObject = _autodoc.getAllAutoDoc(cmp.get("v.autodocUniqueId"), false);
        var autodocValue = returnObject.selectedList;
        var unresolved = returnObject.unresolvedTopics;
        var jsString = JSON.stringify(autodocValue);
        var disableButtons = !(cmp.get("v.hasUnresolvedCNS") || cmp.get("v.hasUnresolvedENI") || cmp.get("v.hasUnresolvedMNR"));
        if (unresolved.size > 0 || !disableButtons) {
            var warningStr = '<ul>';
            var topics = Array.from(unresolved);
            if (unresolved.size > 0) {
                topics.forEach(element => {
                    if(!$A.util.isEmpty(element)){
                        warningStr += '<li>' + element + '</li>';
    }
                });
            }
            if (!disableButtons) {
                warningStr += '<li>Provider Details</li>';
            }
            warningStr += '</ul>';
            cmp.set("v.warningMessage", warningStr);
            cmp.set("v.showWarning", true);
        } else {
            var caseWrapper = cmp.get("v.caseWrapper");
            caseWrapper.savedAutodoc = jsString;
            cmp.set("v.caseWrapper", caseWrapper);
            cmp.set("v.showSaveCase", true);
        }
    },

    closeWarning: function (cmp, event, helper) {
        cmp.set("v.showWarning", false);
    },

    // US3536342 - Thanish - 3rd Jun 2021
    onTabFocused: function (cmp, event, helper) {
        let focusedTabId = event.getParam('currentTabId');
        if($A.util.isEmpty(cmp.get("v.currentTabId"))) {
            cmp.set("v.currentTabId", focusedTabId);
        }
    },
    scrollToTop : function (cmp, event, helper) {
        window.scroll({
            top: 0,
              behavior: 'smooth'
        });
    },

    // DE491765
    handleContractSnipperChange: function(cmp){
        var contractSpinner = cmp.get('v.contractSpinner');
        if(!contractSpinner){
            cmp.set('v.isSaveCaseDisabled', false);
        }else{
            cmp.set('v.isSaveCaseDisabled', true);
        }
    }
})