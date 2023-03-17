({
    addProviderCardToAuth: function (cmp, compName, isMainCard, isShowProviderDetails, hscProviderDetails, createSrnNetworkStatusRequestParams) {

        // US3002566	Bring Back Network Status for Provider - Sarma - 23/10/2020

        let policyDetails = cmp.get('v.policy');
        let memberCardData = cmp.get('v.memberCardData');
        let policySelectedIndex = cmp.get('v.policySelectedIndex');
        var insuranceTypeCode = '';
        var policyCoverageType = '';
        var lineOfBusiness = '';//US3116511 TTAP Vishnu
        if (!$A.util.isEmpty(memberCardData)) {
            if (!$A.util.isUndefinedOrNull(memberCardData.CoverageLines[policySelectedIndex])) {
                if (!$A.util.isUndefinedOrNull(memberCardData.CoverageLines[policySelectedIndex].insuranceTypeCode)) {
                    insuranceTypeCode = memberCardData.CoverageLines[policySelectedIndex].insuranceTypeCode;
                }
                if (!$A.util.isUndefinedOrNull(memberCardData.CoverageLines[policySelectedIndex].actualCoverageType)) {
                    policyCoverageType = memberCardData.CoverageLines[policySelectedIndex].actualCoverageType;
                }
                //US3116511 TTAP Vishnu
                if (!$A.util.isUndefinedOrNull(memberCardData.CoverageLines[policySelectedIndex].lineOfBusiness)) {
                    lineOfBusiness = memberCardData.CoverageLines[policySelectedIndex].lineOfBusiness;
                }
            }
        }


        if (!$A.util.isUndefinedOrNull(policyDetails) && !$A.util.isUndefinedOrNull(policyDetails.resultWrapper) && !$A.util.isUndefinedOrNull(policyDetails.resultWrapper.policyRes)) {
            createSrnNetworkStatusRequestParams.productType = policyDetails.resultWrapper.policyRes.productType;
            createSrnNetworkStatusRequestParams.marketSite = policyDetails.resultWrapper.policyRes.marketSite;
            createSrnNetworkStatusRequestParams.marketType = policyDetails.resultWrapper.policyRes.marketType;
            createSrnNetworkStatusRequestParams.cosmosDiv = policyDetails.resultWrapper.policyRes.cosmosDivision;
            createSrnNetworkStatusRequestParams.providerDiv = policyDetails.resultWrapper.policyRes.providerDiv;//US3574032
            createSrnNetworkStatusRequestParams.cosmosPanelNbr = policyDetails.resultWrapper.policyRes.groupPanelNumber;
            createSrnNetworkStatusRequestParams.policyNumber = policyDetails.resultWrapper.policyRes.policyNumber;
            createSrnNetworkStatusRequestParams.subscriberID = policyDetails.resultWrapper.policyRes.subscriberID;
            createSrnNetworkStatusRequestParams.coverageLevelNum = policyDetails.resultWrapper.policyRes.coverageLevelNum;
            createSrnNetworkStatusRequestParams.sourceCode = policyDetails.resultWrapper.policyRes.sourceCode;
            createSrnNetworkStatusRequestParams.insuranceTypeCode = insuranceTypeCode;
            createSrnNetworkStatusRequestParams.coverageStartDate = policyDetails.resultWrapper.policyRes.coverageStartDate; // US3244384 - Sarma
            createSrnNetworkStatusRequestParams.coverageEndDate = policyDetails.resultWrapper.policyRes.coverageEndDate; // US3244384 - Sarma

        }

        //    US2971523
        let srnProviderDetailList = cmp.get('v.srnProviderDetailList');
        let srnProviderObject = {
            "hscProviderDetails": hscProviderDetails,
            "compName": compName,
            "isMainCard": isMainCard,
            "isShowProviderDetails": isShowProviderDetails,
            "providerRoleDetails": {
                "isProviderFacility": false,
                "isProviderAttending": false,
                "isProviderRequesting": false,
                "isProviderAdmitting": false,
                "isProviderServicing": false,
                "isProviderPCP": false
            },
            "createSrnNetworkStatusRequestParams": createSrnNetworkStatusRequestParams,
            "policyCoverageType" : policyCoverageType,
            "insuranceTypeCode":insuranceTypeCode,//US3116511 TTAP Vishnu
            "lineOfBusiness":lineOfBusiness//US3116511 TTAP Vishnu
        };
        srnProviderDetailList.push(srnProviderObject);
        cmp.set('v.srnProviderDetailList', srnProviderDetailList);
        cmp.set("v.isShowProviderLookup", false);
    },

    // US2894783
    createSRNDataAndErrorObjects: function (cmp, event) {

        var interactionCard = cmp.get('v.interactionCard');
        var dt = new Date();

        var SRNData = {};
        SRNData.CommContact = {
            Source: 'Phone',
            ContactNumber: interactionCard.contactNumber.replace(/\D/g, ""), // US2950839,
            ContactNumberFormatted: interactionCard.contactNumber, // US2950839,
            Ext: interactionCard.contactExt, // US2950839
            Fax: '',
            Email: '',
            Name: interactionCard.contactName, // US2950839
            Role: '',
            Department: '',
            Date: $A.localizationService.formatDate(dt, "MM/DD/YYYY"),
            Time: $A.localizationService.formatDateTime(dt, "hh:mm:ss A"),
            DateTimeFormatted: $A.localizationService.formatDateTime(dt, "YYYY-MM-DDTHH:mm:ss.SSSZ"),
            MedicalRecord: ''
        };

        // US3065991
        SRNData.RequiredInfo = {
            ServiceSetting: 'Outpatient',
            Reference_or_Procedure: 'Select',
            CaseBuildAddInfo: '',
            providerRoles:'',
            ReviewPriority: '',
            ServiceStartDt: '',
            HasAdmitted: 'No',
            ServiceEndDt: '',
            PlaceOfService: '',
            ActualAdmissionDt: '',
            ActualDischargeDt: '',
            ServiceDetail: '',
            ServiceDescription: '',
            Subcategory: '',
            PrimaryCode: '',
            PrimaryDescription: '',
            AdmittingCode: '',
            AdmittingDescription: '',
            DiagnosisData: [],
            ProcedureData: [],
            ModifierData: [],
            isSAIOpen: false,
            isCBInfoOpen: true,
            NoteType: 'HSC',
            SubjectType: 'Administrative',
            NoteDetails: '',
            DischargeDisposition: ''
        };
        // US2950839
        SRNData.SubmitInfo = {
            AlternativeFax: '',
            ConfirmFax: false,
            SendMail: false,
        }
        cmp.set('v.SRNData', SRNData);

        // US2971523
        var providerRoleDetails = {
            'PCP': '',
            'Facility': '',
            'Attending': '',
            'Requesting': '',
            'Admitting': '',
            'Servicing': ''
        }
        cmp.set('v.providerRoleDetails', providerRoleDetails);

    },

    // US2971523
    executeRoleValidations: function (cmp, event) {
        var providerRoleDetails = cmp.get('v.providerRoleDetails');
        providerRoleDetails.PCP = '';
        providerRoleDetails.Facility = '';
        providerRoleDetails.Attending = '';
        providerRoleDetails.Requesting = '';
        providerRoleDetails.Admitting = '';
        providerRoleDetails.Servicing = '';
        var srnProviderDetailList = cmp.get('v.srnProviderDetailList');
        for (var i = 0; i < srnProviderDetailList.length; i++) {
            if (!$A.util.isUndefinedOrNull(srnProviderDetailList[i].providerRoleDetails)) {
                var prodtl = srnProviderDetailList[i].providerRoleDetails;
                if (prodtl.isProviderPCP) {
                    providerRoleDetails.PCP = i;
                }
                if (prodtl.isProviderFacility) {
                    providerRoleDetails.Facility = i;
                }
                if (prodtl.isProviderAttending) {
                    providerRoleDetails.Attending = i;
                }
                if (prodtl.isProviderRequesting) {
                    providerRoleDetails.Requesting = i;
                }
                if (prodtl.isProviderAdmitting) {
                    providerRoleDetails.Admitting = i;
                }
                if (prodtl.isProviderServicing) {
                    providerRoleDetails.Servicing = i;
                }
            }
        }
        cmp.set('v.providerRoleDetails', providerRoleDetails);
    },

    // US3094699
    generateUniqueString: function (cmp, event) {
        var ts = String(new Date().getTime()),
            i = 0,
            out = '';
        for (i = 0; i < ts.length; i += 2) {
            out += Number(ts.substr(i, 2)).toString(36);
        }
        return ('srntab' + out);
    },
    getAuthGridData: function (cmp, event) {
        var action = cmp.get('c.getAuthGridData');
        action.setCallback(this, function (response) {
            let state = response.getState();
            if (state == "SUCCESS") {
                var sourceType=cmp.get('v.sourceType');
                let result = response.getReturnValue();
                let refOrProcessVal = [];
                var i=0;
                let authEntryGrid = new Map();
                for (let a = 0; a < result.length; a++) {
                    if(sourceType=='CS' && (result[a].LOB__c=='E&I Only'  || result[a].LOB__c=='Both'))
                    {
                        refOrProcessVal[i++] = result[a].Reference_or_Procedure__c;
                        authEntryGrid.set(result[a].Reference_or_Procedure__c, result[a]);
                    }
                    else if(sourceType=='CO' && (result[a].LOB__c=='M&R Only'  || result[a].LOB__c=='Both'))
                    {
                        refOrProcessVal[i++] = result[a].Reference_or_Procedure__c;
                        authEntryGrid.set(result[a].Reference_or_Procedure__c, result[a]);
                    }else if( sourceType != 'CO' && sourceType != 'CS' )
                    {
                        refOrProcessVal[i++] = result[a].Reference_or_Procedure__c;
                        authEntryGrid.set(result[a].Reference_or_Procedure__c, result[a]);
    }

                }
                refOrProcessVal.sort();
                cmp.set('v.authEntryGrid', authEntryGrid);
            }
        });
        $A.enqueueAction(action);
    }
})