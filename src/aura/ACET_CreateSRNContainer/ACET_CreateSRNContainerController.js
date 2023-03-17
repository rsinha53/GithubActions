({
    init: function (cmp, event, helper) {

        //  US2816912	Build UI for Create SRN for Add New Provider with Provider Look-up - 2/9/2020 - Sarma

        var pageReference = cmp.get("v.pageReference");
        cmp.set('v.memberTabId', pageReference.state.c__memberTabId);
        cmp.set('v.interactionRec', pageReference.state.c__interactionRec);
        cmp.set('v.contactUniqueId', pageReference.state.c__contactUniqueId);
        cmp.set('v.memberCardSnap', pageReference.state.c__memberCardSnap);
        cmp.set('v.policyDetails', pageReference.state.c__policyDetails);
        cmp.set('v.memberPolicies', JSON.parse(pageReference.state.c__memberPolicies));
        cmp.set('v.policySelectedIndex', pageReference.state.c__policySelectedIndex);
        cmp.set('v.AutodocPageFeature', pageReference.state.c__AutodocPageFeature);
        cmp.set('v.AutodocKey', pageReference.state.c__AutodocKey);
        cmp.set('v.providerSearchResultsADMultiplePages', pageReference.state.c__providerSearchResultsADMultiplePages);
        cmp.set('v.AutodocKeyMemberDtl', pageReference.state.c__AutodocKeyMemberDtl);
        cmp.set('v.AutodocPageFeatureMemberDtl', pageReference.state.c__AutodocPageFeatureMemberDtl);
        cmp.set('v.componentId', pageReference.state.c__componentId);
        cmp.set('v.isHippaInvokedInProviderSnapShot', pageReference.state.c__isHippaInvokedInProviderSnapShot);
        cmp.set('v.hipaaEndpointUrl', pageReference.state.c__hipaaEndpointUrl);
        cmp.set('v.caseNotSavedTopics', pageReference.state.c__caseNotSavedTopics);
        cmp.set('v.providerDetailsForRoutingScreen', pageReference.state.c__providerDetailsForRoutingScreen);
        cmp.set('v.flowDetailsForRoutingScreen', pageReference.state.c__flowDetailsForRoutingScreen);
        cmp.set('v.memberCardData', pageReference.state.c__memberCardData);
        cmp.set('v.interactionCard', pageReference.state.c__interactionCard);
        cmp.set('v.contactName', pageReference.state.c__contactName);
        cmp.set('v.selectedTabType', pageReference.state.c__selectedTabType);
        cmp.set('v.originatorType', pageReference.state.c__originatorType); //US2816983 
        cmp.set('v.interactionOverviewTabId', pageReference.state.c__interactionOverviewTabId); //US2954656
        cmp.set('v.delegationValue', pageReference.state.c__delegationValue);
        cmp.set('v.patientInfo', pageReference.state.c__patientInfo);

        // US2891067
        cmp.set('v.policy', pageReference.state.c__policy);

        var policyDetails = cmp.get('v.policy');
        var delegationValue = cmp.get('v.delegationValue');
      /*  if(delegationValue !="No"){
            cmp.set("v.showDelegatedToIntake",true);
        } */
        if(!$A.util.isUndefinedOrNull(policyDetails) && !$A.util.isUndefinedOrNull(policyDetails.resultWrapper)
        && !$A.util.isUndefinedOrNull(policyDetails.resultWrapper.policyRes) && !$A.util.isUndefinedOrNull(policyDetails.resultWrapper.policyRes.sourceCode)){
         	cmp.set('v.sourceType',policyDetails.resultWrapper.policyRes.sourceCode);
         if(policyDetails.resultWrapper.policyRes.sourceCode == "CO" && delegationValue == "No"){
             cmp.set('v.isNaviHealthNo',true);
         }
         if(policyDetails.resultWrapper.policyRes.sourceCode == "CO" && delegationValue != "No"){
             cmp.set('v.isNaviHealthNoQn',true);
             cmp.set("v.showDelegatedToIntake",true);
             
         }

         var refeorProceWhere = '';
            if (policyDetails.resultWrapper.policyRes.sourceCode == "CS") {
                refeorProceWhere = 'LOB__c =' + "'" + 'Both' + "'" + ' OR LOB__c =' + "'" + 'E&I Only' + "'";
            } else if (policyDetails.resultWrapper.policyRes.sourceCode == "CO") {
                refeorProceWhere = 'LOB__c =' + "'" + 'Both' + "'" + ' OR LOB__c =' + "'" + 'M&R Only' + "'";
            }
            cmp.set('v.isProSelected', true);
            cmp.set('v.refeorProceWhere', refeorProceWhere);
     }

        // US2894783
        helper.createSRNDataAndErrorObjects(cmp, event);

        cmp.set('v.uniqueId', Date.now() + Math.random().toString());

        // US3094699
        cmp.set('v.srnTabId', helper.generateUniqueString(cmp, event));
		helper.getAuthGridData(cmp, event);
    },

    changelstYesNo: function (cmp, event, helper) {

        if (event.getParam("value") == 'No') {
            cmp.set('v.type', 'Outpatient');
        }

        if (event.getParam("value") == 'Yes') {
            var appEvent = $A.get("e.c:ACET_CreateSRNAppEvent");
            appEvent.setParams({
                "memberTabId": cmp.get('v.memberTabId')
            });
            appEvent.fire();
        }

    },

    handleAddProviderEvent: function (cmp, event, helper) {
        var memberTabId = event.getParam("memberTabId");

        if (memberTabId == cmp.get("v.memberTabId")) {
            let createSrnNetworkStatusRequestParams = event.getParam("createSrnNetworkStatusRequestParams");
            let networkStatusTypeDesc = '';
            let networkStatusType = '';
            if (createSrnNetworkStatusRequestParams.status == 'INN') {
                networkStatusType = '1';
                networkStatusTypeDesc = 'INN';
            } else if (createSrnNetworkStatusRequestParams.status == 'ONN') {
                networkStatusType = '2';
                networkStatusTypeDesc = 'ONN';
            } else if (createSrnNetworkStatusRequestParams.status == 'Tier1') {
                networkStatusType = '1';
                networkStatusTypeDesc = 'INN';
            }
            var hscProviderDetails = event.getParam("hscProviderDetails");
            hscProviderDetails.networkStatusType = networkStatusType;
            hscProviderDetails.networkStatusTypeDesc = networkStatusTypeDesc;
            // US2816983	Populate Selected Provider from Provider Lookup on Create SRN Page - Sarma - 28/09/2020
            let today = new Date();
            let compName = 'SRNProviderCard' + today.getTime();

            helper.addProviderCardToAuth(cmp, compName, false, true, hscProviderDetails, createSrnNetworkStatusRequestParams);
        }

    },

    changeType: function (cmp, event, helper) {
        var type = event.getParam("value");

        var SRNData = cmp.get('v.SRNData');
        SRNData.RequiredInfo.ServiceSetting = type;
        if (type != 'Inpatient') {
            SRNData.RequiredInfo.ServiceDescription = 'Scheduled';
        } else {
            SRNData.RequiredInfo.ServiceDescription = '';
        }
        cmp.set('v.SRNData', SRNData);
    },

    addPrimaryProvider: function (cmp, event, helper) {
        var interactionOverviewData = _setAndGetSessionValues.getInteractionDetails(cmp.get("v.interactionOverviewTabId"));
        JSON.parse(JSON.stringify(interactionOverviewData));
        var providerDetails = interactionOverviewData.providerDetails;

        // US2816983	Populate Selected Provider from Provider Lookup on Create SRN Page - Sarma - 28/09/2020
        let today = new Date();
        let compName = 'SRNProviderCard' + today.getTime();
        let isShowProviderDetails = false;
        let hscProviderDetails = new Object();
        if (cmp.get('v.originatorType') == "Provider") {
            isShowProviderDetails = true;
            let networkStatusTypeDesc = cmp.get('v.selectedTabType');
            let networkStatusType = '';
            if (networkStatusTypeDesc == 'INN') {
                networkStatusType = '1';
            } else if (networkStatusTypeDesc == 'ONN') {
                networkStatusType = '2';
            } else if (networkStatusTypeDesc == 'Tier1') {
                networkStatusType = '1';
                networkStatusTypeDesc = 'INN';
            }
            hscProviderDetails = {
                "acoID": providerDetails.acoID,
                "acoName": providerDetails.acoName,
                "address1": providerDetails.addressLine1,
                "address2": providerDetails.addressLine2,
                "businessName": providerDetails.businessName,
                "city": providerDetails.AddressCity,
                "countyName": providerDetails.countyName,
                "efficiencyOutcomeType": providerDetails.efficiencyOutcomeType,
                "firstName": providerDetails.firstName,
                "lastName": providerDetails.lastName,
                "middleName": providerDetails.middleName,
                "primaryPhone": providerDetails.phoneNumberSRN,
                "providerCategory": providerDetails.providerCategory,
                "providerContractOrgs": providerDetails.providerContractOrgs,
                "providerEffectiveDate": providerDetails.providerEffectiveDate,
                "providerIdentifiers": providerDetails.providerIdentifiers,
                "providerSeqNum": "",
                "providerTerminationDate": providerDetails.providerTerminationDate,
                "qualityOutcomeType": providerDetails.qualityOutcomeType,
                "specialtyType": providerDetails.primarySpecialityType,
                "specialtyTypeDesc": providerDetails.primarySpeciality,
                "state": providerDetails.state,
                "uhpdTierDemotInd": providerDetails.uhpdTierDemotInd,
                "tpsmType": providerDetails.tpsmIndicator,
                "zip": providerDetails.zip,
                "zipSuffix": providerDetails.zipSuffix,
                "networkStatusType": networkStatusType,
                "networkStatusTypeDesc": networkStatusTypeDesc
            };

            var createSrnNetworkStatusRequestParams = new Object();

            createSrnNetworkStatusRequestParams.providerId = providerDetails.providerId;
            createSrnNetworkStatusRequestParams.addressId = providerDetails.addressId
            createSrnNetworkStatusRequestParams.addressSequence = providerDetails.addressSequenceId;
            createSrnNetworkStatusRequestParams.taxId = providerDetails.taxId;
            createSrnNetworkStatusRequestParams.status = providerDetails.status;
            createSrnNetworkStatusRequestParams.npi = providerDetails.npi;
        }
        helper.addProviderCardToAuth(cmp, compName, true, isShowProviderDetails, hscProviderDetails, createSrnNetworkStatusRequestParams);
    },

    // US2971523
    providerRoleChanges: function (cmp, event, helper) {
        helper.executeRoleValidations(cmp, event);
    },

    //US3499742- Genetic Testing Link for E&I and M&R
    handleGeneticRadioChange: function(cmp, event, helper) {
        console.log('handleGeneticRadioChange');
        var fieldName = event.getSource().get("v.name");
        if(fieldName == 'radioGenetic' + cmp.get('v.uniqueId')) {
            cmp.set('v.isGeneticTestingTeam','');
            cmp.set('v.IsNewBorn','');
        }
    },
    callDoc: function (cmp, event, helper) {
        var appEvent = $A.get("e.c:ACET_CreateSRNAppEvent");
        appEvent.setParams({
            "memberTabId": cmp.get('v.memberTabId'),
            "isGTClick":true
        });
        appEvent.fire();
    },
    listValueChange: function (cmp, event, helper) {
        try {
            var selectedValue = event.getParam("selectedValue");
            var authEntryGrid = cmp.get('v.authEntryGrid');
            var srnData = cmp.get('v.SRNData');
            var oldValue = cmp.get('v.oldValue');
            if ((authEntryGrid != null) && (!$A.util.isUndefinedOrNull(authEntryGrid.get(selectedValue))))//       && ())
            {
                //cmp.set('v.sampleVis',true);
                if (selectedValue == oldValue) {
                    event.stopPropagation();
                }
                //oldValue=srnData.RequiredInfo.Reference_or_Procedure;
                cmp.set('v.oldValue', selectedValue);
                if (!$A.util.isUndefinedOrNull(authEntryGrid.get(selectedValue).Notes__c)) {

                    srnData.RequiredInfo["CaseBuildAddInfo"] = authEntryGrid.get(selectedValue).Notes__c;
                } else {
                    srnData.RequiredInfo["CaseBuildAddInfo"] = '';
    }
                //Spire_Service_Setting__c

                cmp.set('v.type', authEntryGrid.get(selectedValue).Spire_Service_Setting__c);
                srnData.RequiredInfo["providerRoles"] = authEntryGrid.get(selectedValue).Provider_Roles__c;
                srnData.RequiredInfo["ServiceSetting"] = authEntryGrid.get(selectedValue).Spire_Service_Setting__c;
                srnData.RequiredInfo["ServiceDetail"] = authEntryGrid.get(selectedValue).Spire_Service_Detail__c;
                srnData.RequiredInfo["PlaceOfService"] = authEntryGrid.get(selectedValue).Spire_Place_of_Service__c;
                srnData.RequiredInfo["ServiceDescription"] = ( authEntryGrid.get(selectedValue).Spire_Service_Description__c == 'Emergent or Urgent' ? 'Emergent' : authEntryGrid.get(selectedValue).Spire_Service_Description__c );

                cmp.set('v.sampleVis', true);
                cmp.set('v.SRNData', srnData);
                cmp.set('v.isProSelected', true);
            } else {
                //cmp.set('v.sampleVis',false);
            }
        } catch (err) {

        }
    },
    postActValueChange: function (cmp, event, helper) {
        cmp.set('v.IsNewBorn','');
        //cmp.set('v.ispostAcuteNo',cmp.get('v.postAcuteCareValue')=='No'?true:false);
        //cmp.set('v.sampleVis',(cmp.get('v.postAcuteCareValue')=='No' && cmp.get('v.IsNewBorn')=='No')?true:false);
    }
})