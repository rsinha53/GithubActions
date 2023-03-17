({
    onDoInit : function(component, event, helper) {
       let provideLookupDetails = component.get("v.objProviderLookupDetails");
       component.set('v.interactionRec', provideLookupDetails.interactionRec);
       component.set('v.contactUniqueId', provideLookupDetails.contactUniqueId);
       component.set('v.noMemberToSearch', provideLookupDetails.noMemberToSearch);
       component.set('v.memberCardSnap', provideLookupDetails.memberCardSnap);
       component.set('v.policyDetails', provideLookupDetails.policyDetails);
       component.set('v.memberPolicies', JSON.parse(provideLookupDetails.memberPolicies));
       component.set('v.policySelectedIndex', provideLookupDetails.policySelectedIndex);
       component.set('v.AutodocKey', provideLookupDetails.AutodocKey);
       component.set('v.AutodocPageFeatureMemberDtl', provideLookupDetails.AutodocPageFeatureMemberDtl);
       component.set('v.AutodocKeyMemberDtl', provideLookupDetails.AutodocKeyMemberDtl);
       component.set('v.providerSearchResultsADMultiplePages', provideLookupDetails.providerSearchResultsADMultiplePages);
       component.set('v.componentId', provideLookupDetails.componentId);
       component.set('v.hipaaEndpointUrl', provideLookupDetails.hipaaEndpointUrl);
       component.set('v.isHippaInvokedInProviderSnapShot', provideLookupDetails.isHippaInvokedInProviderSnapShot);
       component.set('v.caseNotSavedTopics', provideLookupDetails.caseNotSavedTopics);
       component.set('v.providerDetailsForRoutingScreen', provideLookupDetails.providerDetailsForRoutingScreen);
       component.set('v.flowDetailsForRoutingScreen', provideLookupDetails.flowDetailsForRoutingScreen);
       component.set('v.memberCardData', provideLookupDetails.memberCardData);
       component.set('v.interactionCard', provideLookupDetails.interactionCard);
       component.set('v.contactName', provideLookupDetails.contactName);
       component.set('v.selectedTabType', provideLookupDetails.selectedTabType);
       component.set('v.interactionOverviewTabId',provideLookupDetails.interactionOverviewTabId);
       //component.set('v.isShowProviderLookup', true);
    },

    showProviderLookUp : function(component, event, helper) {
        component.set('v.isShowProviderLookup', true);
    },

    getAllDetails : function(component, event, helper) {
        console.log(' Params ' + event.getParams().value);
    }
})