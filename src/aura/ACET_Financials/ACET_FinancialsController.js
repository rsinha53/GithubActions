({ 
    //Test commit to sae branch
    doInit: function (cmp, event, helper) {
        console.log(cmp.get("v.memberTabId"))
        console.log(cmp.get("v.AutodocPageFeature"))
        
        // --------- Get today's date ------------
        var today = $A.localizationService.formatDate(new Date(), "MM-DD-YYYY");
        
        var selectedPolicyDt=cmp.get("v.policyList");
        if(!$A.util.isUndefinedOrNull(selectedPolicyDt))
        {
            selectedPolicyDt=selectedPolicyDt[cmp.get("v.policySelectedIndex")];
        }
        cmp.set("v.selectedPolicy", selectedPolicyDt);
        
        cmp.set('v.today', today);
        //helper.setInitData(cmp, event, helper);
        
        // US2718114 - Thanish - 2nd Jul 2020
        var caseNotSavedTopics = cmp.get("v.caseNotSavedTopics");
        if(!caseNotSavedTopics.includes("Plan Benefits")){
            caseNotSavedTopics.push("Plan Benefits");
        }
        cmp.set("v.caseNotSavedTopics", caseNotSavedTopics);
        
        //19th Aug 2019 - US1773564 - Member CDHP UI - SARMA : Start
        var memid =  cmp.get("v.memberId");
        if(memid=='956876492'){
            cmp.set("v.isBgCol", true);
            cmp.set("v.cdhpVal", 'HRA Balance $X.XX');
        }
        if(memid=='959654871'){
            cmp.set("v.isBgCol", true);
            cmp.set("v.cdhpVal", 'This member has an HSA');
        }
        //19th Aug 2019 - US1773564 - Member CDHP UI - SARMA : End
        
        // US2442658
        cmp.set("v.AutodocKeyMemberDtl", cmp.get('v.AutodocKey')); 
        cmp.set('v.AutodocPageFeatureMemberDtl', cmp.get('v.AutodocPageFeature'));
        //helper.setDefaultAutodoc(cmp);
        //helper.getFinancialObject(cmp);
        helper.callEligibilityService(cmp, event, helper);
    },
    
    selectAllIndividual : function(cmp, event) {
        var financialJSON = cmp.get("v.financialObject");
        if(cmp.get("v.selectedTab") == 'tierOne') {
            financialJSON.Individual.tierone.Deductible.isAutodoc = event.getSource().get("v.checked");
            financialJSON.Individual.tierone.OutofPocket.isAutodoc = event.getSource().get("v.checked");
            financialJSON.Individual.tierone.MedicalLifeMaximum.isAutodoc = event.getSource().get("v.checked");
            if(financialJSON.Individual.tierone.OOP_Limit_2_Found) {
                financialJSON.Individual.tierone.OutofPocket2.isAutodoc = event.getSource().get("v.checked");
            }
            if(financialJSON.copayMaxAmount >= 0) {
                financialJSON.Individual.tierone.CopayMax.isAutodoc = event.getSource().get("v.checked");
            }
            financialJSON.Individual.tierone.CrossApplyOutofPocket.isAutodoc = event.getSource().get("v.checked");
            financialJSON.Individual.tierone.CrossApplyCopay.isAutodoc = event.getSource().get("v.checked");
            financialJSON.Individual.tierone.CrossApplyCore.isAutodoc = event.getSource().get("v.checked");
        } else if(cmp.get("v.selectedTab") == 'inNetwork') {
            financialJSON.Individual.inNetwork.Deductible.isAutodoc = event.getSource().get("v.checked");
            financialJSON.Individual.inNetwork.OutofPocket.isAutodoc = event.getSource().get("v.checked");
            financialJSON.Individual.inNetwork.MedicalLifeMaximum.isAutodoc = event.getSource().get("v.checked");
            if(financialJSON.Individual.inNetwork.OOP_Limit_2_Found) {
                financialJSON.Individual.inNetwork.OutofPocket2.isAutodoc = event.getSource().get("v.checked");
            }
            if(financialJSON.copayMaxAmount >= 0) {
                financialJSON.Individual.inNetwork.CopayMax.isAutodoc = event.getSource().get("v.checked");
            }
            if(financialJSON.Individual.inNetwork.CombinedDeductible.comDedVal == 'Y' || financialJSON.Individual.inNetwork.CombinedDeductible.comDedVal == 'N') {
                financialJSON.Individual.inNetwork.CombinedDeductible.isAutodoc = event.getSource().get("v.checked");
            }
            if(financialJSON.Individual.inNetwork.CombinedOOP.comOopVal == 'Y' || financialJSON.Individual.inNetwork.CombinedOOP.comOopVal == 'N') {
                financialJSON.Individual.inNetwork.CombinedOOP.isAutodoc = event.getSource().get("v.checked");
            }
            financialJSON.Individual.inNetwork.CrossApplyOutofPocket.isAutodoc = event.getSource().get("v.checked");
            financialJSON.Individual.inNetwork.CrossApplyCopay.isAutodoc = event.getSource().get("v.checked");
            financialJSON.Individual.inNetwork.CrossApplyCore.isAutodoc = event.getSource().get("v.checked");   
        } else if(cmp.get("v.selectedTab") == 'outNetwork') {
            financialJSON.Individual.outofNetwork.Deductible.isAutodoc = event.getSource().get("v.checked");
            financialJSON.Individual.outofNetwork.OutofPocket.isAutodoc = event.getSource().get("v.checked");
            financialJSON.Individual.outofNetwork.MedicalLifeMaximum.isAutodoc = event.getSource().get("v.checked");
            if(financialJSON.Individual.outofNetwork.OOP_Limit_2_Found) {
                financialJSON.Individual.outofNetwork.OutofPocket2.isAutodoc = event.getSource().get("v.checked");
            }
            if(financialJSON.copayMaxAmount >= 0) {
                financialJSON.Individual.outofNetwork.CopayMax.isAutodoc = event.getSource().get("v.checked");
            }
            if(financialJSON.Individual.outofNetwork.CombinedDeductible.comDedVal == 'Y' || financialJSON.Individual.outofNetwork.CombinedDeductible.comDedVal == 'N') {
                financialJSON.Individual.outofNetwork.CombinedDeductible.isAutodoc = event.getSource().get("v.checked");
            }
            if(financialJSON.Individual.outofNetwork.CombinedOOP.comOopVal == 'Y' || financialJSON.Individual.outofNetwork.CombinedOOP.comOopVal == 'N') {
                financialJSON.Individual.outofNetwork.CombinedOOP.isAutodoc = event.getSource().get("v.checked");
            }
            financialJSON.Individual.outofNetwork.CrossApplyOutofPocket.isAutodoc = event.getSource().get("v.checked");
            financialJSON.Individual.outofNetwork.CrossApplyCopay.isAutodoc = event.getSource().get("v.checked");
            financialJSON.Individual.outofNetwork.CrossApplyCore.isAutodoc = event.getSource().get("v.checked");   
        }
        cmp.set("v.financialObject", financialJSON);
         if(cmp.get("v.isClaimDetail")){
          _autodoc.setAutodoc(cmp.get("v.autodocUniqueId"),cmp.get("v.autodocUniqueIdCmp"), financialJSON);
         }
        else{
        _autodoc.setAutodoc(cmp.get("v.autodocUniqueId"),cmp.get("v.autodocUniqueIdCmp") + cmp.get("v.policySelectedIndex"), financialJSON);
        }
    },
    
    selectAllFamily : function(cmp, event) {
        var financialJSON = cmp.get("v.financialObject");
        if(cmp.get("v.selectedTab") == 'tierOne') {
            financialJSON.Family.tierone.Deductible.isAutodoc = event.getSource().get("v.checked");
            financialJSON.Family.tierone.OutofPocket.isAutodoc = event.getSource().get("v.checked");
            financialJSON.Family.tierone.MedicalLifeMaximum.isAutodoc = event.getSource().get("v.checked");
            if(financialJSON.Family.tierone.OOP_Limit_2_Found) {
                financialJSON.Family.tierone.OutofPocket2.isAutodoc = event.getSource().get("v.checked");
            }
            if(financialJSON.copayMaxAmount >= 0) {
                financialJSON.Family.tierone.CopayMax.isAutodoc = event.getSource().get("v.checked");
            }
            financialJSON.Family.tierone.CrossApplyOutofPocket.isAutodoc = event.getSource().get("v.checked");
            financialJSON.Family.tierone.CrossApplyCopay.isAutodoc = event.getSource().get("v.checked");
            financialJSON.Family.tierone.CrossApplyCore.isAutodoc = event.getSource().get("v.checked");
        } else if(cmp.get("v.selectedTab") == 'inNetwork') {
            financialJSON.Family.inNetwork.Deductible.isAutodoc = event.getSource().get("v.checked");
            financialJSON.Family.inNetwork.OutofPocket.isAutodoc = event.getSource().get("v.checked");
            financialJSON.Family.inNetwork.MedicalLifeMaximum.isAutodoc = event.getSource().get("v.checked");
            if(financialJSON.Family.inNetwork.OOP_Limit_2_Found) {
                financialJSON.Family.inNetwork.OutofPocket2.isAutodoc = event.getSource().get("v.checked");
            }
            if(financialJSON.copayMaxAmount >= 0) {
                financialJSON.Family.inNetwork.CopayMax.isAutodoc = event.getSource().get("v.checked");
            }
            if(financialJSON.Family.inNetwork.CombinedDeductible.comDedVal == 'Y' || financialJSON.Family.inNetwork.CombinedDeductible.comDedVal == 'N') {
                financialJSON.Family.inNetwork.CombinedDeductible.isAutodoc = event.getSource().get("v.checked");
            }
            if(financialJSON.Family.inNetwork.CombinedOOP.comOopVal == 'Y' || financialJSON.Family.inNetwork.CombinedOOP.comOopVal == 'N') {
                financialJSON.Family.inNetwork.CombinedOOP.isAutodoc = event.getSource().get("v.checked");
            }
            financialJSON.Family.inNetwork.CrossApplyOutofPocket.isAutodoc = event.getSource().get("v.checked");
            financialJSON.Family.inNetwork.CrossApplyCopay.isAutodoc = event.getSource().get("v.checked");
            financialJSON.Family.inNetwork.CrossApplyCore.isAutodoc = event.getSource().get("v.checked");   
        } else if(cmp.get("v.selectedTab") == 'outNetwork') {
            financialJSON.Family.outofNetwork.Deductible.isAutodoc = event.getSource().get("v.checked");
            financialJSON.Family.outofNetwork.OutofPocket.isAutodoc = event.getSource().get("v.checked");
            financialJSON.Family.outofNetwork.MedicalLifeMaximum.isAutodoc = event.getSource().get("v.checked");
            if(financialJSON.Family.outofNetwork.OOP_Limit_2_Found) {
                financialJSON.Family.outofNetwork.OutofPocket2.isAutodoc = event.getSource().get("v.checked");
            }
            if(financialJSON.copayMaxAmount >= 0) {
                financialJSON.Family.outofNetwork.CopayMax.isAutodoc = event.getSource().get("v.checked");
            }
            if(financialJSON.Family.outofNetwork.CombinedDeductible.comDedVal == 'Y' || financialJSON.Family.outofNetwork.CombinedDeductible.comDedVal == 'N') {
                financialJSON.Family.outofNetwork.CombinedDeductible.isAutodoc = event.getSource().get("v.checked");
            }
            if(financialJSON.Family.outofNetwork.CombinedOOP.comOopVal == 'Y' || financialJSON.Family.outofNetwork.CombinedOOP.comOopVal == 'N') {
                financialJSON.Family.outofNetwork.CombinedOOP.isAutodoc = event.getSource().get("v.checked");
            }
            financialJSON.Family.outofNetwork.CrossApplyOutofPocket.isAutodoc = event.getSource().get("v.checked");
            financialJSON.Family.outofNetwork.CrossApplyCopay.isAutodoc = event.getSource().get("v.checked");
            financialJSON.Family.outofNetwork.CrossApplyCore.isAutodoc = event.getSource().get("v.checked");   
        }
        cmp.set("v.financialObject", financialJSON);
         if(cmp.get("v.isClaimDetail")){
          _autodoc.setAutodoc(cmp.get("v.autodocUniqueId"),cmp.get("v.autodocUniqueIdCmp"), financialJSON);
         }
        else{
        _autodoc.setAutodoc(cmp.get("v.autodocUniqueId"),cmp.get("v.autodocUniqueIdCmp") + cmp.get("v.policySelectedIndex"), financialJSON);
        }
    },
    
    dataChange: function (cmp, event, helper) {
        helper.callEligibilityService(cmp, event, helper);
       /* helper.setInitData(cmp, event, helper);
        helper.setDefaultAutodoc(cmp);
        helper.getFinancialObject(cmp);
        cmp.set("v.tier1HeaderChecked", false);
        cmp.set("v.innHeaderChecked", false);
        cmp.set("v.oonHeaderChecked", false);
        cmp.set("v.tier1FamilyHeader", false);
        cmp.set("v.innFamilyHeader", false);
        cmp.set("v.oonFamilyHeader", false);*/
    },

    financialsDataChange: function (cmp, event, helper) {
        helper.setInitData(cmp, event, helper);
        helper.setDefaultAutodoc(cmp);
        helper.getFinancialObject(cmp);
        cmp.set("v.tier1HeaderChecked", false);
        cmp.set("v.innHeaderChecked", false);
        cmp.set("v.oonHeaderChecked", false);
        cmp.set("v.tier1FamilyHeader", false);
        cmp.set("v.innFamilyHeader", false);
        cmp.set("v.oonFamilyHeader", false);
    },
    
    setDefaultTab: function (cmp, event, helper) {
        helper.setDefaultTab(cmp, event, helper);
    },
    
    setINNData: function (cmp, event, helper) {
        var financeData = cmp.get("v.financialsData");
        if (financeData != null) {
            cmp.set("v.innetwork", financeData.inNetwork);
        }
        cmp.set("v.innFlag", false);
        //helper.initAutoDocTab(cmp, event, helper);
    },
    
    setOONData: function (cmp, event, helper) {
        var financeData = cmp.get("v.financialsData");
        if (financeData != null) {
            cmp.set("v.outnetwork", financeData.onNetwork);
        }
        cmp.set("v.oonFlag", false);
        //helper.initAutoDocTab(cmp, event, helper);
    },
    
    setTierData: function (cmp, event, helper) {
        var financeData = cmp.get("v.financialsData");
        if (financeData != null) {
            cmp.set("v.tierone", financeData.tierOne);
        }
        cmp.set("v.tierFlag", false);
        //helper.initAutoDocTab(cmp, event, helper);
    },
    
    refreshTableData : function(cmp, event, helper) {
        cmp.set("v.selectedTab", event.currentTarget.getAttribute("data-tab"));
        var financeData = cmp.get("v.financialsData");
        if (financeData != null) {
            cmp.set("v.innetwork", financeData.inNetwork);
            cmp.set("v.tierone", financeData.tierOne);
            cmp.set("v.outnetwork", financeData.onNetwork);
        }
        //helper.initAutoDocTab(cmp, event, helper);
    },
    resetChecks : function(cmp, event, helper) {
        var financeData = cmp.get("v.financialsData");
        
        var selectedPolicyDt=cmp.get("v.policyList");
        if(!$A.util.isUndefinedOrNull(selectedPolicyDt))
        {
            selectedPolicyDt=selectedPolicyDt[cmp.get("v.policySelectedIndex")];
        }
        cmp.set("v.selectedPolicy", selectedPolicyDt);
        
        if (!$A.util.isUndefinedOrNull(financeData)) {
            cmp.set("v.innetwork", financeData.inNetwork);
            cmp.set("v.tierone", financeData.tierOne);
            cmp.set("v.outnetwork", financeData.onNetwork);
            cmp.set("v.innFlag", true);
            cmp.set("v.tierFlag", true);
            cmp.set("v.oonFlag", true);
        }
        helper.setDefaultTab(cmp, event, helper);
        //helper.initAutoDocTab(cmp, event, helper);
    },

    // DE461925 - Clearing checkboxes after save case - Krish - 9th Aug 2021
    clearAutodoc: function(cmp){
        cmp.set("v.tier1HeaderChecked", false);
        cmp.set("v.innHeaderChecked", false);
        cmp.set("v.oonHeaderChecked", false);
        cmp.set("v.tier1FamilyHeader", false);
        cmp.set("v.innFamilyHeader", false);
        cmp.set("v.oonFamilyHeader", false);
    }
})