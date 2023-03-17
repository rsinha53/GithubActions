({

    reloadContent: function(component, event, helper) {

        // US2465305: MVP - Navigation of Multiple Topics on a Snapshot Page (Part 3)
        setTimeout(function() {
            var callTopicOrder = component.get("v.callTopicOrder");
                if (!$A.util.isUndefinedOrNull(callTopicOrder.ViewAuthorizations) && callTopicOrder.ViewAuthorizations == 1) {
                    component.find("AuthorizationResultsMbSnapshot").getElement().scrollIntoView({
                        behavior: 'smooth',
                        block: 'center',
                        inline: 'nearest'
                    });
                } else if (!$A.util.isUndefinedOrNull(callTopicOrder.ProviderLookup) && callTopicOrder.ProviderLookup == 1) {
                    component.find("provdrLookupMbSnapshot").getElement().scrollIntoView({
                        behavior: 'smooth',
                        block: 'center',
                        inline: 'nearest'
                    });
                } else if (!$A.util.isUndefinedOrNull(callTopicOrder.PlanBenefits) && callTopicOrder.PlanBenefits == 1) {
                     component.find("BenefitDetailsMbSnapshot").getElement().scrollIntoView({
                        behavior: 'smooth',
                        block: 'center',
                        inline: 'nearest'
                    });
                } else if (!$A.util.isUndefinedOrNull(callTopicOrder.ViewClaims) && callTopicOrder.ViewClaims == 1) {
                    component.find("ClaimInformationMbSnapshot").getElement().scrollIntoView({
                        behavior: 'smooth',
                        block: 'center',
                        inline: 'nearest'
                    });
                }
            	/*US1958804*/
                else if (!$A.util.isUndefinedOrNull(callTopicOrder.ViewPayments) && callTopicOrder.ViewPayments == 1) {
                    console.log('payments selected');
                    component.find("PaymentInformationMbSnapshot").getElement().scrollIntoView({
                        behavior: 'smooth',
                        block: 'center',
                        inline: 'nearest'
                    });
                    }
                else if (!$A.util.isUndefinedOrNull(callTopicOrder.ViewPCPReferrals) && callTopicOrder.ViewPCPReferrals == 1) {
                    component.find("ViewPCPReferralsMbSnapshot").getElement().scrollIntoView({
                        behavior: 'smooth',
                        block: 'start',
                        inline: 'nearest'
                    });
                }
                // US3802608 - Thanish - 25th Aug 2021
                else if (!$A.util.isUndefinedOrNull(callTopicOrder.ViewAppeals) && callTopicOrder.ViewAppeals == 1) {
                    component.find("ViewAppealsMbSnapshot").getElement().scrollIntoView({
                        behavior: 'smooth',
                        block: 'start',
                        inline: 'nearest'
                    });
                }
        }, 100);

    },

    navigateToCallTopic: function(component, event, helper) {
        setTimeout(function() {
            //var callTopicName = component.get("v.callTopicName");
            //var callTopicName = event.getParam('selectedCallTopic');
            var params = event.getParam('arguments');
            var callTopicName;
            if (params) {
                var callTopicName = params.selectedCallTopic;
            }
            if (!$A.util.isUndefinedOrNull(callTopicName) && callTopicName == "View Authorizations") {
                component.find("AuthorizationResultsMbSnapshot").getElement().scrollIntoView({
                    behavior: 'smooth',
                    block: 'center',
                    inline: 'nearest'
                });
            } else if (!$A.util.isUndefinedOrNull(callTopicName) && callTopicName == "Provider Lookup") {
                component.find("provdrLookupMbSnapshot").getElement().scrollIntoView({
                    behavior: 'smooth',
                    block: 'center',
                    inline: 'nearest'
                });
            } else if (!$A.util.isUndefinedOrNull(callTopicName) && callTopicName == "Plan Benefits") {
                component.find("BenefitDetailsMbSnapshot").getElement().scrollIntoView({
                    behavior: 'smooth',
                    block: 'center',
                    inline: 'nearest'
                });
            } else if (!$A.util.isUndefinedOrNull(callTopicName) && callTopicName == "View Claims") {
                component.find("ClaimInformationMbSnapshot").getElement().scrollIntoView({
                    behavior: 'smooth',
                    block: 'center',
                    inline: 'nearest'
                });
            }else if (!$A.util.isUndefinedOrNull(callTopicName) && callTopicName == "View Payments") {
                component.find("paymentInfo-comp").getElement().scrollIntoView({
                    behavior: 'smooth',
                    block: 'center',
                    inline: 'nearest'
                });
            }else if (!$A.util.isUndefinedOrNull(callTopicName) && callTopicName == "View PCP Referrals") {
                component.find("ViewPCPReferralsMbSnapshot").getElement().scrollIntoView({
                    behavior: 'smooth',
                    block: 'center',
                    inline: 'nearest'
                });
            } else if (!$A.util.isUndefinedOrNull(callTopicName) && callTopicName == "View Appeals") {
                component.find("ViewAppealsMbSnapshot").getElement().scrollIntoView({
                    behavior: 'smooth',
                    block: 'center',
                    inline: 'nearest'
                });
            }
            component.set("v.callTopicName","");
        }, 100);
    },

    handleTopicClick : function(component, event) {
        if (event.getParam("clickedTopic") == 'Provider Lookup SearchResults') {
            var providerLookup = component.find("lookupForm");
            if(!$A.util.isUndefinedOrNull(providerLookup)){
                setTimeout(function () {
                    component.find("lookupForm").find("providerLookupPrvdSearchResults").getElement().scrollIntoView({
                        behavior: "smooth",
                        block: 'start',
                        inline: 'nearest'
                    });
                }, 100);
	        }
        }
    }
})