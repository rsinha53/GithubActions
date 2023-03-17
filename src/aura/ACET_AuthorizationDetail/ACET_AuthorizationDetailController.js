({
    openMisdirectComp: function (component, event, helper) {
        helper.openMisDirect(component, event, helper);
    },
    
    doInit: function(cmp, event, helper) {
        // Autodoc multiple pages - Lahiru - 3rd Mar 2020
        cmp.set("v.uniqueKey", new Date().getTime());

        //window.scrollTo(0, 0);
        var pageReference = cmp.get("v.pageReference");
        helper.showAuthDetailSpinner(cmp);
        helper.getMemberIdGroupIdAuthDtl(cmp);
        var authDetails = JSON.parse(pageReference.state.c__authDetails);
        cmp.set('v.authDetailsObj', authDetails.AuthDetailsResponse);
        //US2325822 View Authorizations - ECAA Letter Button Landing Page UI - Sarma - 30-01-2020
        authDetails.srn = pageReference.state.c__SRN;
        cmp.set('v.authDetailsObj_StatusCard', authDetails);
        cmp.set('v.interactionRec', JSON.parse(pageReference.state.c__interactionRec));
        cmp.set('v.isMedicaidPlan', pageReference.state.c__isMedicaidPlan);
        //Swapna
        cmp.set('v.isClaimDetail', pageReference.state.c__isClaimDetail);
        cmp.set('v.currentIndexOfOpenedTabs', pageReference.state.c__currentIndexOfOpenedTabs);
        cmp.set('v.claimNo', pageReference.state.c__claimNo);
        cmp.set('v.currentIndexOfAuthOpenedTabs', pageReference.state.c__currentIndexOfAuthOpenedTabs);
        cmp.set('v.maxAutoDocAuthComponents', pageReference.state.c__maxAutoDocAuthComponents);
       //Swapna

        //US2330408  - Avish
		cmp.set("v.memberId",pageReference.state.c__memberId);
        cmp.set("v.interactionOverviewTabId",pageReference.state.c__interactionOverviewTabId);
        //US2330408  - Ends

        cmp.set('v.authType', pageReference.state.c__authType);
        cmp.set('v.LengthOfStay', pageReference.state.c__LengthOfStay);
        cmp.set('v.SRN', pageReference.state.c__SRN);

        // US2301790
        cmp.set('v.AutodocPageFeature', pageReference.state.c__AutodocPageFeature);
        cmp.set('v.AutodocKey', pageReference.state.c__AutodocKey);
		cmp.set('v.contactUniqueId', pageReference.state.c__contactUniqueId);

        //US2382470
        cmp.set('v.assignmentFlag', pageReference.state.c__assignmentFlag);

         //US2076634 - HIPAA Guidelines Button - Sravan - Start
         var hipaaEndPointUrl = pageReference.state.c__hipaaEndpointUrl;
         cmp.set("v.hipaaEndpointUrl",hipaaEndPointUrl);
         //US2076634 - HIPAA Guidelines Button - Sravan - End

        cmp.set("v.autodocUniqueId", pageReference.state.c__autodocUniqueId);
        cmp.set("v.autodocUniqueIdCmp", pageReference.state.c__autodocUniqueIdCmp);
        // US2304398	Enhancements, Pending work and Defects  Authorizations - Sarma

        //US3653687
        cmp.set("v.policy", pageReference.state.c__policy);
        cmp.set("v.memberCardData", pageReference.state.c__memberCardData);
        cmp.set("v.policySelectedIndex", pageReference.state.c__policySelectedIndex);


        if(pageReference.state.c__isClaim ){
        	cmp.set("v.isClaim", true);
        }

        if(!cmp.get('v.isClaim')){
            var callTopicLst = JSON.parse(pageReference.state.c__callTopicLstSelected);
            cmp.set("v.callTopicLstSelected",callTopicLst );
            cmp.set("v.callTopicTabId",pageReference.state.c__callTopicTabId);
        }

        if (!$A.util.isUndefinedOrNull(cmp.get("v.authDetailsObj").providers)) {
            var providers = cmp.get("v.authDetailsObj").providers;
            for (var i = 0; i < providers.length; i++) {
                var npi = '';
                var tin = '';
                var mpin = '';
                //US3653687
                var addrSeq = '';
                if (!$A.util.isUndefinedOrNull(providers[i].providerIdentifiers)) {
                    var providerIdentifiers = providers[i].providerIdentifiers;

                    for (var j = 0; j < providerIdentifiers.length; j++) {

                        if (providerIdentifiers[j].typeCodeDesc == 'Federal Tax ID') {
                            tin = providerIdentifiers[j].id;
                        } else if (providerIdentifiers[j].typeCodeDesc == 'NPI') {
                            npi = providerIdentifiers[j].id;
                        } else if (providerIdentifiers[j].typeCodeDesc == 'NDBMpin') {
                            mpin = providerIdentifiers[j].id;
                        }else if (providerIdentifiers[j].typeCodeDesc == 'NDBAddressSequenceNbr') {
                            //US3653687
                            addrSeq = providerIdentifiers[j].id;
                        }
                    }
                }
                providers[i].npi = npi;
                providers[i].tin = tin;
                providers[i].mpin = mpin;

                //US3653687
                var providerDetails = new Object();
                providerDetails.taxId = tin;
                providerDetails.providerId = mpin;
                providerDetails.addressSequence = addrSeq;
                providerDetails.isPhysician = providers[i].categoryCode == 'P' ? true : false;
                providerDetails.FullName = providers[i].categoryCode == 'P' ? providers[i].firstName + ' ' + providers[i].lastName : providers[i].organizationName;

                providers[i].providerDetails = providerDetails;


                // KAVINDA
                if (!$A.util.isUndefinedOrNull(providers[i].specialtyType)) {
                    var specialtyType = providers[i].specialtyType;
                    var desc_x = '';
                    for (var j = 0; j < specialtyType.length; j++) {
                        if (!$A.util.isUndefinedOrNull(specialtyType[j].desc_x)) {
                            desc_x += (specialtyType[j].desc_x + ', ');
                        }
                    }
                    desc_x = desc_x.replace(/,\s*$/, "");
                    if (desc_x.length == 0 || desc_x == '' || desc_x == null) {
                        desc_x = '--';
                    }
                    providers[i].specialtyTypeDesc = desc_x;
                }

            }
            var authDetailsObj = cmp.get("v.authDetailsObj");
            authDetailsObj.providers = providers;
            cmp.set("v.authDetailsObj", authDetailsObj);

            //US2301790
            setTimeout(function () {
                let tabKey = cmp.get("v.AutodocKey");
                window.lgtAutodoc.initAutodoc(tabKey + cmp.get("v.uniqueKey")); // Autodoc multiple pages - Lahiru - 3rd Mar 2020
                window.scrollTo(0, 0);
            }, 1000);

        }
        helper.hideAuthDetailSpinner(cmp);
    },

    // US2271237 - View Authorizations - Update Policies in Auto Doc : Kavinda
    handlePolicyClick: function (cmp, event, helper) {
        cmp.set('v.IsAutoDocEnable', false);
    },

    //US2076634 - HIPAA Guidelines Button - Sravan
    handleHippaGuideLines : function(component, event, helper) {
        var hipaaEndPointUrl = component.get("v.hipaaEndpointUrl");
        if(!$A.util.isUndefinedOrNull(hipaaEndPointUrl) && !$A.util.isEmpty(hipaaEndPointUrl)){
            window.open(hipaaEndPointUrl, '_blank');
        }
        component.set("v.isHipaa",true);

        var cardDetails = new Object();
        cardDetails.componentName = "HIPAA Guidelines";
        cardDetails.componentOrder = 0;
        cardDetails.noOfColumns = "slds-size_1-of-1";
        cardDetails.type = "card";
        cardDetails.allChecked = false;
        cardDetails.cardData = [
            {
                "checked": true,
                "disableCheckbox": true,
                "fieldName": "HIPAA Guidelines",
                "fieldType": "outputText",
                "fieldValue": "Accessed"
            }
        ];
        _autodoc.setAutodoc(component.get("v.autodocUniqueId"), 0, cardDetails);
	},
    //US2554307: View Authorizations Details Page - Add Alerts Button
    setMmberIdGroupIdAuthDtl : function(component, event, helper) {
        var memberId = event.getParam("memberIdAuthDtl");
        var GroupId = event.getParam("groupIdAuthDtl");
        var taxId = event.getParam("alertTaxId");
        var providerId = event.getParam("alertProviderId");
        component.set("v.groupIdAuthDtl",GroupId);
        component.set("v.alertProviderId",providerId);
        component.set("v.alertTaxId",taxId);
        component.set("v.memberIdAuthDtl",memberId);


    },
    //US2554307: View Authorizations Details Page - Add Alerts Button
    getAlertsAuthDetails : function(component, event, helper) {
        component.find("alertsAI_AuthDetails").getAlertsOnAuthDetailsPage();
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
        }
        else {
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