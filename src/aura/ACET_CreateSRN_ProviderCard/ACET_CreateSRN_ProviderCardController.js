({
    doInit: function (cmp, event, helper) {
        let srnProviderDetailObject = cmp.get('v.srnProviderDetailObject');

        if (!cmp.get('v.isNetworkStatusCalloutDone')) {
            if (!$A.util.isUndefinedOrNull(srnProviderDetailObject.createSrnNetworkStatusRequestParams && !srnProviderDetailObject.isMainCard)) {
                let createSrnNetworkStatusRequestParams = srnProviderDetailObject.createSrnNetworkStatusRequestParams;
                if (!$A.util.isUndefinedOrNull(createSrnNetworkStatusRequestParams.status) && (createSrnNetworkStatusRequestParams.status == '--')) {
                    if (createSrnNetworkStatusRequestParams.sourceCode == 'CO') {
                        helper.getMAndRProviderStatus(cmp, createSrnNetworkStatusRequestParams);
                    } else if (createSrnNetworkStatusRequestParams.sourceCode == 'CS') {
                        helper.getEAndIProviderStatus(cmp, createSrnNetworkStatusRequestParams);
                    }
                    cmp.set('v.isNetworkStatusCalloutDone', true);
                }
            }
        }
        // US3507490	Mapping for Contract Org Type and Amendment Sarma - 19th May 2021
        if(!srnProviderDetailObject.isMainCard){

            helper.getAdditionalProviderDetails(cmp,  helper);

        }
    },

    providerObjectOnchange: function (cmp, event, helper) {

    },

    openProviderLookup: function (cmp, event, helper) {
        cmp.set('v.isShowProviderLookup', true);
    },

    // US2816983	Populate Selected Provider from Provider Lookup on Create SRN Page - Sarma - 28/09/2020
    closeProviderCard: function (cmp, event, helper) {
        let srnProviderDetailList = cmp.get('v.srnProviderDetailList');
        let srnProviderDetailObject = cmp.get('v.srnProviderDetailObject');
        let compName = srnProviderDetailObject.compName;

        // US3077461	Validations Part 4 - Inpatient/Outpatient/Outpatient Facility - Ability to Remove Provider Card When Needed - Sarma - 18/11/2020
        // Adding if else condition to remove Default provider details

        if(srnProviderDetailObject.isMainCard){

            srnProviderDetailObject.isShowProviderDetails = false;
            cmp.set('v.srnProviderDetailObject',srnProviderDetailObject);

            for (var i = 0; i < srnProviderDetailList.length; i++) {
                if (srnProviderDetailList[i].compName == compName) {
                   srnProviderDetailList[i] = srnProviderDetailObject;
                }
            }
        } else {

            for (var i = 0; i < srnProviderDetailList.length; i++) {
                if (srnProviderDetailList[i].compName == compName) {
                    srnProviderDetailList.splice(i, 1);
                }
            }
        }
        cmp.set('v.srnProviderDetailList', srnProviderDetailList);

        // DE389721
        srnProviderDetailList = cmp.get('v.srnProviderDetailList');

        if (srnProviderDetailList.length == 1 || srnProviderDetailList.length == 2) {
            if ((srnProviderDetailList.length == 1 && !srnProviderDetailList[0].isShowProviderDetails) || (srnProviderDetailList.length == 2 && !srnProviderDetailList[0].isShowProviderDetails && srnProviderDetailList[1].isShowProviderDetails)) {
                srnProviderDetailList[0].providerRoleDetails.isProviderPCP = false;
                srnProviderDetailList[0].providerRoleDetails.isProviderFacility = false;
                srnProviderDetailList[0].providerRoleDetails.isProviderAttending = false;
                srnProviderDetailList[0].providerRoleDetails.isProviderRequesting = false;
                srnProviderDetailList[0].providerRoleDetails.isProviderAdmitting = false;
                srnProviderDetailList[0].providerRoleDetails.isProviderServicing = false;
            }
        }
        cmp.set('v.srnProviderDetailList', srnProviderDetailList);

        // US2971523
        helper.fireRoleChangesEvent(cmp, event);

    },
    //  US2954656	TECH - Submit the Authorization Summary & Confirmation Page: Provider Details - Integration - Sarma - 16/10/2020
    handleRoleCheckboxAction: function (cmp, event, helper) {

        let srnProviderDetailList = cmp.get('v.srnProviderDetailList');
        let srnProviderDetailObject = cmp.get('v.srnProviderDetailObject');
        let providerRoleDetails = srnProviderDetailObject.providerRoleDetails;

        providerRoleDetails.isProviderFacility = cmp.get('v.isProviderFacility');
        providerRoleDetails.isProviderAttending = cmp.get('v.isProviderAttending');
        providerRoleDetails.isProviderRequesting = cmp.get('v.isProviderRequesting');
        providerRoleDetails.isProviderAdmitting = cmp.get('v.isProviderAdmitting');
        providerRoleDetails.isProviderServicing = cmp.get('v.isProviderServicing');

        // US2971523
        providerRoleDetails.isProviderPCP = cmp.get('v.isProviderPCP');

        srnProviderDetailObject.providerRoleDetails = providerRoleDetails;
        cmp.set('v.srnProviderDetailObject', srnProviderDetailObject);

        // update provider List
        let compName = srnProviderDetailObject.compName;

        for (var i = 0; i < srnProviderDetailList.length; i++) {
            if (srnProviderDetailList[i].compName == compName) {
                srnProviderDetailList[i] = srnProviderDetailObject;
            }
        }
        cmp.set('v.srnProviderDetailList', srnProviderDetailList);

        // US2971523
        helper.fireRoleChangesEvent(cmp, event);

    },

    // US2971523
    fireValidations: function (cmp, event, helper) {
        // US3094699
        if (!$A.util.isUndefinedOrNull(event.getParam("tabId")) && event.getParam("tabId") == cmp.get('v.srnTabId')) {
        helper.executeValidations(cmp, event);
        }
    },


})