({
    openMisdirectComp: function (component, event, helper) {
        helper.openMisDirect(component, event, helper);
    },
    
    openCommentsBox : function (component, event, helper) {
        debugger;
        var isCommentsBox = event.getParam("isCommentsBox");
        component.set("v.isCommentsBox",isCommentsBox);
    },
    
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
        var pageReference = component.get("v.pageReference");
		var providerNotFound = pageReference.state.c__providerNotFound; 
        var noMemberToSearch = pageReference.state.c__noMemberToSearch;
        var mnf = pageReference.state.c__mnf;
        component.set("v.noMemberToSearch", noMemberToSearch);
        component.set("v.providerNotFound", providerNotFound);
        component.set("v.mnf", mnf);
        var isProviderSearchDisabled = pageReference.state.c__isProviderSearchDisabled; 
      
        component.set("v.isProviderSearchDisabled", isProviderSearchDisabled);

        //US2076634 - HIPAA Guidelines Button - Sravan - Start
        var hipaaEndPointUrl = pageReference.state.c__hipaaEndpointUrl;
        component.set("v.hipaaEndpointUrl",hipaaEndPointUrl);
        //US2076634 - HIPAA Guidelines Button - Sravan - End

        //US2330408 - Avish
        component.set("v.interactionOverviewTabId",pageReference.state.c__interactionOverviewTabId);

        //US2897253 - VCCD - Member/Provider Snapshot Page - Topic Integration - Sravan
        var isVCCD = pageReference.state.c__isVCCD;
        var VCCDQuestionType = pageReference.state.c__VCCDQuestionType;
        var postVCCDEvent = $A.get("e.c:ACET_PostVCCD");
        postVCCDEvent.setParams({"isVCCD":isVCCD,"VCCDQuestionType":VCCDQuestionType,"pageName":"Provider Snapshot"});
        postVCCDEvent.fire();

        //DE347387 - Praveen
        var providerDetailsForRoutingScreen = pageReference.state.c__providerDetailsForRoutingScreen;
        component.set("v.providerDetailsForRoutingScreen", providerDetailsForRoutingScreen);
        var flowDetailsForRoutingScreen = pageReference.state.c__flowDetailsForRoutingScreen;
        component.set("v.flowDetailsForRoutingScreen", flowDetailsForRoutingScreen);

        // US1816890 - Sanka
        var taxId = pageReference.state.c__taxId != null ? pageReference.state.c__taxId : '';
        var providerId = pageReference.state.c__providerId != null ? pageReference.state.c__providerId : '';
        var addrSequence = pageReference.state.c__addrSequence != null ? pageReference.state.c__addrSequence : '';
        var interactionName = pageReference.state.c__interactionName != null ? pageReference.state.c__interactionName : '';
        var interactionId = pageReference.state.c__interactionId != null ? pageReference.state.c__interactionId : '';
        var autodockey =  interactionId+ taxId +providerId;

        component.set("v.AutodocKey",autodockey );
        // US2091974 - Sanka - Case Creation
        var subjectDetails = pageReference.state.c__subjectDetails != null ? pageReference.state.c__subjectDetails : new Object();

        // US1918689 - Thanish - 13th Nov 2019 - passing addressID of physician.
        var addressId = $A.util.isEmpty(pageReference.state.c__addressId) ? 'physiciandetails' : pageReference.state.c__addressId;
        component.set("v.autodocPageFeature", addressId);

        component.set("v.taxId", taxId);
        component.set("v.providerId", providerId);
        component.set("v.addrSequence", addrSequence);
        component.set("v.interactionName", interactionName);
        component.set("v.interactionId", interactionId);
        component.set("v.interactionRec", pageReference.state.c__interactionRec);
        // US2696849 - Thanish - 22nd Jul 2020
        component.set("v.contractApiParameters", { "taxId" : taxId, "providerId" : providerId, "addressId" : addressId, "addressSeq" : addrSequence});

        // US2091974 - Sanka - Case Creation
        component.set("v.subjectDetails",subjectDetails);

        helper.getProviderData(component, event, helper);
        //helper.getMemberCaseHistory(component,component.get("v.taxId")); //US2465288 - Avish
        
        //Added by Vinay for Alerts US
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
        // Subject Card
		caseWrapper.SubjectName = subjectDetails.fullName;
		caseWrapper.SubjectType = subjectDetails.subjectType;
		caseWrapper.SubjectDOB = subjectDetails.DOB;
		caseWrapper.SubjectId = subjectDetails.subjectId;
        caseWrapper.SubjectGroupId = subjectDetails.subjectGroupId;
        
        //US2699902 - Avish
        caseWrapper.contactNumber = subjectDetails.contactNumber;
        caseWrapper.contactExt = subjectDetails.contactExt; 

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

        component.set("v.caseWrapper", caseWrapper);
		 //component.find("caseHistoryCard").callCasesFromORS();
    },

    // US2192945 - Sanka
    handleTopicClick: function (component, event) {
        if (event.getParam("clickedTopic") == 'Provider Lookup') {
            component.set("v.showProviderLookup", true);
            setTimeout(function () {
                component.find("providerLookup").getElement().scrollIntoView({
                    behavior: "smooth",
                    block: "start"
                });
            }, 100);
	}
    },

     viewPaymentTopicClick: function(component, event, helper){
        component.set("v.ViewPayment",true);
         setTimeout(function () {
             component.find("paymentInfo").getElement().scrollIntoView({behavior: "smooth",block: "start"});
         }, 100);
    },
    //US2076634 - HIPAA Guidelines Button - Sravan
    handleHippaGuideLines : function(component, event, helper) {
		var hipaaEndPointUrl = component.get("v.hipaaEndpointUrl");
        if(!$A.util.isUndefinedOrNull(hipaaEndPointUrl) && !$A.util.isEmpty(hipaaEndPointUrl)){
            window.open(hipaaEndPointUrl, '_blank');
        }
        component.set("v.isHippaInvokedInProviderSnapShot",true);
    }
})