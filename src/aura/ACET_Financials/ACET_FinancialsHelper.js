({
    setDefaultTab: function (cmp, event, helper) {
        console.log('=@#FinanicalTier1'+JSON.stringify(cmp.get("v.isTierOne")));
        //US2973232
        if(cmp.get("v.isProviderAndMemberFlow")) {
            if(cmp.get("v.highlightedPolicySourceCode") == 'CS' && cmp.get("v.networkStatus") == "Tier 1") {
                cmp.set("v.selectedTab", "tierOne");
            } else {
                if(cmp.get("v.networkStatus") == 'INN') {
                   cmp.set("v.selectedTab", "inNetwork");
                } else if(cmp.get("v.networkStatus") == 'OON') {
                   cmp.set("v.selectedTab", "outNetwork");
                } else {
                    // Do Nothing
                }
            }
        } else {
            helper.handleDefaultChange(cmp, event, helper);
        }
    },

    handleDefaultChange : function (cmp, event, helper) {
        if(!$A.util.isUndefinedOrNull(cmp.get("v.isTierOne")) && cmp.get("v.isTierOne")){
            cmp.set("v.selectedTab", "tierOne");
        }
        else{
        var selectedPolicyDt;
        if (!$A.util.isUndefinedOrNull(cmp.get("v.policyList"))) {
            var selectedPolicyDt = cmp.get("v.policyList");
            selectedPolicyDt = selectedPolicyDt[cmp.get("v.policySelectedIndex")];
        }
        if (!$A.util.isUndefinedOrNull(selectedPolicyDt) && (!$A.util.isUndefinedOrNull(selectedPolicyDt.finDeOutFlgs))) {
            if (selectedPolicyDt.finDeOutFlgs.deductibleInfoFlg == true) {
                if (selectedPolicyDt.finDeOutFlgs.deindividualFlg == true) {
                    if (selectedPolicyDt.finDeOutFlgs.deIndTier1Flg == true) {
                        cmp.set("v.selectedTab", "tierOne");
                    } else if (selectedPolicyDt.finDeOutFlgs.deIndInnFlg == true) {
                        cmp.set("v.selectedTab", "inNetwork");
                    } else {
                        cmp.set("v.selectedTab", "outNetwork");
                    }
                } else if (selectedPolicyDt.finDeOutFlgs.deFamilyFlg == true) {
                    if (selectedPolicyDt.finDeOutFlgs.deFlmTier1Flg == true) {
                        cmp.set("v.selectedTab", "tierOne");
                    } else if (selectedPolicyDt.finDeOutFlgs.deFlmInnFlg == true) {
                        cmp.set("v.selectedTab", "inNetwork");
                    } else {
                        cmp.set("v.selectedTab", "outNetwork");
                    }
                } else {
                    cmp.set("v.selectedTab", "outNetwork");
                }
            } else if (selectedPolicyDt.finDeOutFlgs.outofpocketInfoFlg == true) {
                if (selectedPolicyDt.finDeOutFlgs.outindividualFlg == true) {
                    if (selectedPolicyDt.finDeOutFlgs.outIndTier1Flg == true) {
                        cmp.set("v.selectedTab", "tierOne");
                    } else if (selectedPolicyDt.finDeOutFlgs.outIndInnFlg == true) {
                        cmp.set("v.selectedTab", "inNetwork");
                    } else {
                        cmp.set("v.selectedTab", "outNetwork");
                    }
                } else if (selectedPolicyDt.finDeOutFlgs.outFamilyFlg == true) {
                    if (selectedPolicyDt.finDeOutFlgs.outFlmTier1Flg == true) {
                        cmp.set("v.selectedTab", "tierOne");
                    } else if (selectedPolicyDt.finDeOutFlgs.outFlmInnFlg == true) {
                        cmp.set("v.selectedTab", "inNetwork");
                    } else {
                        cmp.set("v.selectedTab", "outNetwork");
                    }
                } else {
                    cmp.set("v.selectedTab", "outNetwork");
                }
            } else {
                cmp.set("v.selectedTab", "outNetwork");
            }
        } else {
            cmp.set("v.selectedTab", "outNetwork");
        }
        }
    },
    
    setInitData: function (cmp, event, helper) {
        var financeData = cmp.get("v.financialsData");
        if (!$A.util.isUndefinedOrNull(financeData)) {
            cmp.set("v.yearType", financeData.yearType);
            cmp.set("v.displayYear", financeData.displayYear);
        }
        
        if (!$A.util.isUndefinedOrNull(financeData)) {
            cmp.set("v.innetwork", financeData.inNetwork);
            cmp.set("v.outnetwork", financeData.onNetwork);
            cmp.set("v.tierone", financeData.tierOne);
        }
        
        helper.setDefaultTab(cmp, event, helper);
        
        //US1901028 - Sarma - Member CDHP Integration - 29/08/2019 : Start
        var policyData = cmp.get("v.policyDetails");
        
        /*** US1944144  - Added on 03/19/2020 - Avish ***/ //DE318082 - Adding null & Undefine check
        if (!$A.util.isUndefinedOrNull(policyData) && !$A.util.isUndefinedOrNull(policyData.resultWrapper) && !$A.util.isUndefinedOrNull(policyData.resultWrapper.policyRes)) {
            if ((policyData.resultWrapper.policyRes.isComPlan || policyData.resultWrapper.policyRes.isPHSPlan) && (policyData.resultWrapper.policyRes.nonEmbeddedFamilyStatusIndicator != null) ? policyData.resultWrapper.policyRes.nonEmbeddedFamilyStatusIndicator.toUpperCase() == 'SINGLE' : '') {
                cmp.set("v.isAggregateIndividualIndicator", true);
                cmp.set("v.isFamilyAccumulation", true);
                cmp.set("v.isAggregateFamilyIndicator", false);
                cmp.set("v.isEmbeddedIndividualIndicator", false);
                cmp.set("v.isEmbeddedFamilyIndicator", false);
            } else if ((policyData.resultWrapper.policyRes.isComPlan || policyData.resultWrapper.policyRes.isPHSPlan) && (policyData.resultWrapper.policyRes.nonEmbeddedFamilyStatusIndicator != null) ? policyData.resultWrapper.policyRes.nonEmbeddedFamilyStatusIndicator.toUpperCase() == 'FAMILY' : '') {
                cmp.set("v.isAggregateIndividualIndicator", true);
                cmp.set("v.isAggregateFamilyIndicator", true);
                cmp.set("v.isFamilyAccumulation", false);
                cmp.set("v.isEmbeddedIndividualIndicator", false);
                cmp.set("v.isEmbeddedFamilyIndicator", false);
            } else if ((policyData.resultWrapper.policyRes.isComPlan || policyData.resultWrapper.policyRes.isPHSPlan) && (policyData.resultWrapper.policyRes.nonEmbeddedFamilyStatusIndicator != null) ? policyData.resultWrapper.policyRes.nonEmbeddedFamilyStatusIndicator.toUpperCase() == 'NONE' : '') {
                cmp.set("v.isFamilyAccumulation", false);
                cmp.set("v.isAggregateIndividualIndicator", false);
                cmp.set("v.isAggregateFamilyIndicator", false);
                cmp.set("v.isEmbeddedIndividualIndicator", true);
                cmp.set("v.isEmbeddedFamilyIndicator", true);
            } else if (policyData.resultWrapper.policyRes.isMedicarePlan || policyData.resultWrapper.policyRes.isMedicaidPlan) {
                cmp.set("v.isFamilyAccumulation", true);
                cmp.set("v.isAggregateIndividualIndicator", false);
                cmp.set("v.isAggregateFamilyIndicator", false);
                cmp.set("v.isEmbeddedIndividualIndicator", false);
                cmp.set("v.isEmbeddedFamilyIndicator", false);
            }
        }
        
        /*** US1944144 Ends ***/
        
        // DE283795 - null check on policy wrapper - 27/11/2019 - Sarma //DE318082 - Adding null & Undefine check
        if (!$A.util.isUndefinedOrNull(financeData) && !$A.util.isUndefinedOrNull(policyData) && !$A.util.isUndefinedOrNull(policyData.resultWrapper) && !$A.util.isUndefinedOrNull(policyData.resultWrapper.policyRes)) {
            var isCdhp = policyData.resultWrapper.policyRes.isCdhp;
            var isComPlan = policyData.resultWrapper.policyRes.isComPlan;
            var isHsa = policyData.resultWrapper.policyRes.isHsa;
            var isHra = financeData.isHra;
            var hraVal = financeData.hraVal;
            
            cmp.set("v.isCdhp", isCdhp);
            if (isCdhp && isComPlan) {
                if (isHsa) {
                    cmp.set("v.cdhpVal", 'This member has an HSA');
                }
                if (isHra) {
                    cmp.set("v.cdhpVal", 'HRA Balance $' + Number(hraVal).toFixed(2));
                }
            }
        }
    },
    
    setDefaultAutodoc: function(cmp){
        // DE456923 - Thanish - 30th Jun 2021
        if(!cmp.get("v.isClaimDetail")){
            var defaultAutoDocPolicy = _autodoc.getAutodocComponent(cmp.get("v.memberautodocUniqueId"),cmp.get("v.policySelectedIndex"),'Policies');
            var defaultAutoDocMember = _autodoc.getAutodocComponent(cmp.get("v.memberautodocUniqueId"),cmp.get("v.policySelectedIndex"),'Member Details');
            var memberAutodoc = new Object();
            memberAutodoc.type = 'card';
            memberAutodoc.componentName = "Member Details";
            memberAutodoc.autodocHeaderName = "Member Details";
            memberAutodoc.noOfColumns = "slds-size_6-of-12";
            memberAutodoc.componentOrder = 2;
            memberAutodoc.ignoreClearAutodoc = false;
            memberAutodoc.ignoreAutodocWarningMsg = true;
            var cardData = [];
            cardData = defaultAutoDocMember.cardData.filter(function(el){
                if(!$A.util.isEmpty(el.defaultChecked) && el.defaultChecked) {
                    return el;
                }
            });
            memberAutodoc.cardData = cardData;
            var autodocSubId = cmp.get("v.autodocUniqueId") + cmp.get("v.policySelectedIndex");

            var policyAutodoc = new Object();
            policyAutodoc.type = "table";
            policyAutodoc.autodocHeaderName = "Policies";
            policyAutodoc.componentName = "Policies";
            policyAutodoc.tableHeaders = ["GROUP #", "SOURCE", "PLAN", "TYPE", "PRODUCT", "COVERAGE LEVEL", "ELIGIBILITY DATES", "STATUS", "REF REQ", "PCP REQ", "RESOLVED"];
            policyAutodoc.tableBody = defaultAutoDocPolicy.tableBody;
            policyAutodoc.selectedRows = defaultAutoDocPolicy.selectedRows;
            policyAutodoc.callTopic = 'View Member Eligibility';
            policyAutodoc.componentOrder = 0;
            policyAutodoc.ignoreClearAutodoc = false;
            policyAutodoc.ignoreAutodocWarningMsg = true;
            _autodoc.setAutodoc(cmp.get("v.autodocUniqueId"), autodocSubId, policyAutodoc);
            _autodoc.setAutodoc(cmp.get("v.autodocUniqueId"), autodocSubId, memberAutodoc);
        }
    },
    
    getFinancialObject: function (cmp) {
        var financialsData = cmp.get("v.financialsData");
        var selectedPolicy = cmp.get("v.selectedPolicy");
        var planLevelBenefitsRes = cmp.get("v.planLevelBenefitsRes");
        var financialJSON = cmp.get("v.financialObject");
         var currentIndexOfOpenedTabs = cmp.get("v.currentIndexOfOpenedTabs");
         var maxAutoDocComponents = cmp.get("v.maxAutoDocComponents");
         var claimNo=cmp.get("v.claimNo");
        var isClaimDetail=cmp.get("v.isClaimDetail");
        financialJSON = {
            "type": "financials",
            "autodocHeaderName": isClaimDetail?("Financials: "+claimNo) : "Financials" ,
            "claimsExtId": isClaimDetail ? claimNo : '', //Claim External Id
            "componentName": isClaimDetail? ("Financials: "+claimNo) :"Financials" ,
            "componentOrder": isClaimDetail? (20 +(maxAutoDocComponents*currentIndexOfOpenedTabs)):3 ,
            "policyNumber": cmp.get("v.policyNumber"),
            "financialDate": cmp.get("v.today"),
            "yearType": cmp.get("v.yearType"),
            "displayYear": cmp.get("v.displayYear"),
            "isCdhp": false,
            "isFamilyAccumulation": cmp.get("v.isFamilyAccumulation"),
            "copayMaxAmount": !$A.util.isUndefinedOrNull(planLevelBenefitsRes) ? planLevelBenefitsRes.copayMaxAmount : "",
            "Individual": {
                "tierone": {
                    "OOP_Limit_2_Found": financialsData.tierOne.OOP_Limit_2_Found,
                    "Deductible": {
                        "Description": "Deductible",
                        "isAutodoc": false,
                        "Percentage": financialsData.tierOne.dedFound ? financialsData.tierOne.dedPrecentage : 0.00,
                        "SpentAmount": financialsData.tierOne.dedFound ? this.convert(cmp,financialsData.tierOne.dedSatisfied) : '0.00',
                        "TotalAmount": financialsData.tierOne.dedFound ? this.convert(cmp,financialsData.tierOne.deductible) : '0.00',
                        "RemainingAmount": financialsData.tierOne.dedFound ? this.convert(cmp,financialsData.tierOne.dedAmountRem) : '0.00',
                        "isAggregateIndividualIndicator": cmp.get("v.isAggregateIndividualIndicator"),
                        "isAggregateFamilyIndicator": cmp.get("v.isAggregateFamilyIndicator"),
                        "isEmbeddedIndividualIndicator": cmp.get("v.isEmbeddedIndividualIndicator"),
                        "moveTop": "-130",
                        "moveLeft": "0",
                        "showDeductMsg": selectedPolicy.finDeOutFlgs.deductibleInfoFlg
                    },
                    "OutofPocket2": {
                        "Description": "Out-of-Pocket 2",
                        "isAutodoc": false,
                        "Percentage": financialsData.tierOne.OOP_Limit_2_Found ? financialsData.tierOne.OOP_Limit_2_Precentage : 0,
                        "SpentAmount": financialsData.tierOne.OOP_Limit_2_Found ? this.convert(cmp,financialsData.tierOne.OOP_Limit_2_Satisfied) : '0.00',
                        "TotalAmount": financialsData.tierOne.OOP_Limit_2_Found ? this.convert(cmp,financialsData.tierOne.OOP_Limit_2) : '0.00',
                        "RemainingAmount": financialsData.tierOne.OOP_Limit_2_Found ? this.convert(cmp,financialsData.tierOne.OOP_Limit_2_Rem) : '0.00'
                    },
                    "OutofPocket": {
                        "Description": "Out-of-Pocket",
                        "isAutodoc": false,
                        "Percentage": financialsData.tierOne.outOPFound ? financialsData.tierOne.oopPrecentage : 0,
                        "SpentAmount": financialsData.tierOne.outOPFound ? this.convert(cmp,financialsData.tierOne.outOPSatisfied) : '0.00',
                        "TotalAmount": financialsData.tierOne.outOPFound ? this.convert(cmp,financialsData.tierOne.outOP) : '0.00',
                        "RemainingAmount": financialsData.tierOne.outOPFound ? this.convert(cmp,financialsData.tierOne.outOPRemAmount) : '0.00'
                    },
                    "MedicalLifeMaximum": {
                        "Description": "Medical Life Maximum",
                        "isAutodoc": false,
                        "Percentage": !$A.util.isUndefinedOrNull(planLevelBenefitsRes) ? planLevelBenefitsRes.medLifMaxPercent : "",
                        "SpentAmount": !$A.util.isUndefinedOrNull(planLevelBenefitsRes) ? this.convert(cmp,planLevelBenefitsRes.medLifMaxApplied) : "",
                        "TotalAmount": !$A.util.isUndefinedOrNull(planLevelBenefitsRes) ? this.convert(cmp,planLevelBenefitsRes.medLifMaxAmt) : "",
                        "RemainingAmount": !$A.util.isUndefinedOrNull(planLevelBenefitsRes) ? this.convert(cmp,planLevelBenefitsRes.medLifMaxRemain) : "",
                        "showRemaining": true
                    },
                    "CopayMax": {
                        "Description": "Copay Max",
                        "isAutodoc": false,
                        "TotalAmount": !$A.util.isUndefinedOrNull(planLevelBenefitsRes) ? this.convert(cmp,planLevelBenefitsRes.copayMaxAmount) : ""
                    },
                    "CrossApplyOutofPocket": {
                        "isAutodoc": false,
                        "iscrsAplOop": true,
                        "crsAplOopSignVal": !$A.util.isUndefinedOrNull(planLevelBenefitsRes) ? planLevelBenefitsRes.crsApplyOopInd : ""
                    },
                    "CrossApplyCopay": {
                        "iscrsAplCopy": true,
                        "crsAplCopySignVal": !$A.util.isUndefinedOrNull(planLevelBenefitsRes) ? planLevelBenefitsRes.crsApplyCopayInd : "",
                        "isAutodoc": false
                    },
                    "CrossApplyCore": {
                        "iscrsAplCore": true,
                        "crsAplCoreSignVal": !$A.util.isUndefinedOrNull(planLevelBenefitsRes) ? planLevelBenefitsRes.crsApplyCoreInd : "",
                        "isAutodoc": false
                    }
                },
                "inNetwork": {
                    "OOP_Limit_2_Found": financialsData.inNetwork.OOP_Limit_2_Found,
                    "Deductible": {
                        "Description": "Deductible",
                        "isAutodoc": false,
                        "Percentage": financialsData.inNetwork.dedFound ? financialsData.inNetwork.dedPrecentage : 0,
                        "SpentAmount": financialsData.inNetwork.dedFound ? this.convert(cmp,financialsData.inNetwork.dedSatisfied) : '0.00',
                        "TotalAmount": financialsData.inNetwork.dedFound ? this.convert(cmp,financialsData.inNetwork.deductible) : '0.00',
                        "RemainingAmount": financialsData.inNetwork.dedFound ? this.convert(cmp,financialsData.inNetwork.dedAmountRem) : '0.00',
                        "isAggregateIndividualIndicator": cmp.get("v.isAggregateIndividualIndicator"),
                        "isAggregateFamilyIndicator": cmp.get("v.isAggregateFamilyIndicator"),
                        "isEmbeddedIndividualIndicator": cmp.get("v.isEmbeddedIndividualIndicator"),
                        "moveTop": "-130",
                        "moveLeft": "0",
                        "showDeductMsg": selectedPolicy.finDeOutFlgs.deductibleInfoFlg
                    },
                    "OutofPocket2": {
                        "Description": "Out-of-Pocket 2",
                        "isAutodoc": false,
                        "Percentage": financialsData.inNetwork.OOP_Limit_2_Found ? financialsData.inNetwork.OOP_Limit_2_Precentage : 0,
                        "SpentAmount": financialsData.inNetwork.OOP_Limit_2_Found ? this.convert(cmp,financialsData.inNetwork.OOP_Limit_2_Satisfied) : '0.00',
                        "TotalAmount": financialsData.inNetwork.OOP_Limit_2_Found ? this.convert(cmp,financialsData.inNetwork.OOP_Limit_2) : '0.00',
                        "RemainingAmount": financialsData.inNetwork.OOP_Limit_2_Found ? this.convert(cmp,financialsData.inNetwork.OOP_Limit_2_Rem) : '0.00'
                    },
                    "OutofPocket": {
                        "Description": "Out-of-Pocket",
                        "isAutodoc": false,
                        "Percentage": financialsData.inNetwork.outOPFound ? financialsData.inNetwork.oopPrecentage : 0,
                        "SpentAmount": financialsData.inNetwork.outOPFound ? this.convert(cmp,financialsData.inNetwork.outOPSatisfied) : '0.00',
                        "TotalAmount": financialsData.inNetwork.outOPFound ? this.convert(cmp,financialsData.inNetwork.outOP) : '0.00',
                        "RemainingAmount": financialsData.inNetwork.outOPFound ? this.convert(cmp,financialsData.inNetwork.outOPRemAmount) : '0.00'
                    },
                    "MedicalLifeMaximum": {
                        "Description": "Medical Life Maximum",
                        "isAutodoc": false,
                        "Percentage": !$A.util.isUndefinedOrNull(planLevelBenefitsRes) ? planLevelBenefitsRes.medLifMaxPercent : "",
                        "SpentAmount": !$A.util.isUndefinedOrNull(planLevelBenefitsRes) ? this.convert(cmp,planLevelBenefitsRes.medLifMaxApplied) : "",
                        "TotalAmount": !$A.util.isUndefinedOrNull(planLevelBenefitsRes) ? this.convert(cmp,planLevelBenefitsRes.medLifMaxAmt) : "",
                        "RemainingAmount": !$A.util.isUndefinedOrNull(planLevelBenefitsRes) ? this.convert(cmp,planLevelBenefitsRes.medLifMaxRemain) : "",
                        "showRemaining": true
                    },
                    "CopayMax": {
                        "Description": "Copay Max",
                        "isAutodoc": false,
                        "TotalAmount": !$A.util.isUndefinedOrNull(planLevelBenefitsRes) ? this.convert(cmp,planLevelBenefitsRes.copayMaxAmount) : ""
                    },
                    "CrossApplyOutofPocket": {
                        "isAutodoc": false,
                        "iscrsAplOop": true,
                        "crsAplOopSignVal": !$A.util.isUndefinedOrNull(planLevelBenefitsRes) ? planLevelBenefitsRes.crsApplyOopInd : ""
                    },
                    "CrossApplyCopay": {
                        "iscrsAplCopy": true,
                        "crsAplCopySignVal": !$A.util.isUndefinedOrNull(planLevelBenefitsRes) ? planLevelBenefitsRes.crsApplyCopayInd : "",
                        "isAutodoc": false
                    },
                    "CrossApplyCore": {
                        "iscrsAplCore": true,
                        "crsAplCoreSignVal": !$A.util.isUndefinedOrNull(planLevelBenefitsRes) ? planLevelBenefitsRes.crsApplyCoreInd : "",
                        "isAutodoc": false
                    },
                    "CombinedDeductible": {
                        "isComDed": true,
                        "comDedVal": !$A.util.isUndefinedOrNull(planLevelBenefitsRes) ? planLevelBenefitsRes.cmbInnDeductInd : "",
                        "isAutodoc": false
                    },
                    "CombinedOOP": {
                        "isComOop": true,
                        "isAutodoc": false,
                        "comOopVal": !$A.util.isUndefinedOrNull(planLevelBenefitsRes) ? planLevelBenefitsRes.cmbInnOopInd : ""
                    }
                },
                "outofNetwork": {
                    "OOP_Limit_2_Found": financialsData.onNetwork.OOP_Limit_2_Found,
                    "Deductible": {
                        "Description": "Deductible",
                        "isAutodoc": false,
                        "Percentage": financialsData.onNetwork.dedFound ? financialsData.onNetwork.dedPrecentage : 0,
                        "SpentAmount": financialsData.onNetwork.dedFound ? this.convert(cmp,financialsData.onNetwork.dedSatisfied) : '0.00',
                        "TotalAmount": financialsData.onNetwork.dedFound ? this.convert(cmp,financialsData.onNetwork.deductible) : '0.00',
                        "RemainingAmount": financialsData.onNetwork.dedFound ? this.convert(cmp,financialsData.onNetwork.dedAmountRem) : '0.00',
                        "isAggregateIndividualIndicator": cmp.get("v.isAggregateIndividualIndicator"),
                        "isAggregateFamilyIndicator": cmp.get("v.isAggregateFamilyIndicator"),
                        "isEmbeddedIndividualIndicator": cmp.get("v.isEmbeddedIndividualIndicator"),
                        "moveTop": "-130",
                        "moveLeft": "0",
                        "showDeductMsg": selectedPolicy.finDeOutFlgs.deductibleInfoFlg
                    },
                    "OutofPocket2": {
                        "Description": "Out-of-Pocket 2",
                        "isAutodoc": false,
                        "Percentage": financialsData.onNetwork.OOP_Limit_2_Found ? financialsData.onNetwork.OOP_Limit_2_Precentage : 0,
                        "SpentAmount": financialsData.onNetwork.OOP_Limit_2_Found ? this.convert(cmp,financialsData.onNetwork.OOP_Limit_2_Satisfied) : '0.00',
                        "TotalAmount": financialsData.onNetwork.OOP_Limit_2_Found ? this.convert(cmp,financialsData.onNetwork.OOP_Limit_2) : '0.00',
                        "RemainingAmount": financialsData.onNetwork.OOP_Limit_2_Found ? this.convert(cmp,financialsData.onNetwork.OOP_Limit_2_Rem) : '0.00'
                    },
                    "OutofPocket": {
                        "Description": "Out-of-Pocket",
                        "isAutodoc": false,
                        "Percentage": financialsData.onNetwork.outOPFound ? financialsData.onNetwork.oopPrecentage : 0,
                        "SpentAmount": financialsData.onNetwork.outOPFound ? this.convert(cmp,financialsData.onNetwork.outOPSatisfied) : '0.00',
                        "TotalAmount": financialsData.onNetwork.outOPFound ? this.convert(cmp,financialsData.onNetwork.outOP) : '0.00',
                        "RemainingAmount": financialsData.onNetwork.outOPFound ? this.convert(cmp,financialsData.onNetwork.outOPRemAmount) : '0.00'
                    },
                    "MedicalLifeMaximum": {
                        "Description": "Medical Life Maximum",
                        "isAutodoc": false,
                        "Percentage": !$A.util.isUndefinedOrNull(planLevelBenefitsRes) ? planLevelBenefitsRes.medLifMaxPercent : "",
                        "SpentAmount": !$A.util.isUndefinedOrNull(planLevelBenefitsRes) ? this.convert(cmp,planLevelBenefitsRes.medLifMaxApplied) : "",
                        "TotalAmount": !$A.util.isUndefinedOrNull(planLevelBenefitsRes) ? this.convert(cmp,planLevelBenefitsRes.medLifMaxAmt) : "",
                        "RemainingAmount": !$A.util.isUndefinedOrNull(planLevelBenefitsRes) ? this.convert(cmp,planLevelBenefitsRes.medLifMaxRemain) : "",
                        "showRemaining": true
                    },
                    "CopayMax": {
                        "Description": "Copay Max",
                        "isAutodoc": false,
                        "TotalAmount": !$A.util.isUndefinedOrNull(planLevelBenefitsRes) ? this.convert(cmp,planLevelBenefitsRes.copayMaxAmount) : ""
                    },
                    "CrossApplyOutofPocket": {
                        "isAutodoc": false,
                        "iscrsAplOop": true,
                        "crsAplOopSignVal": !$A.util.isUndefinedOrNull(planLevelBenefitsRes) ? planLevelBenefitsRes.crsApplyOopInd : ""
                    },
                    "CrossApplyCopay": {
                        "iscrsAplCopy": true,
                        "crsAplCopySignVal": !$A.util.isUndefinedOrNull(planLevelBenefitsRes) ? planLevelBenefitsRes.crsApplyCopayInd : "",
                        "isAutodoc": false
                    },
                    "CrossApplyCore": {
                        "iscrsAplCore": true,
                        "crsAplCoreSignVal": !$A.util.isUndefinedOrNull(planLevelBenefitsRes) ? planLevelBenefitsRes.crsApplyCoreInd : "",
                        "isAutodoc": false
                    },
                    "CombinedDeductible": {
                        "isComDed": true,
                        "comDedVal": !$A.util.isUndefinedOrNull(planLevelBenefitsRes) ? planLevelBenefitsRes.cmbOonDeductInd : "",
                        "isAutodoc": false
                    },
                    "CombinedOOP": {
                        "isComOop": true,
                        "isAutodoc": false,
                        "comOopVal": !$A.util.isUndefinedOrNull(planLevelBenefitsRes) ? planLevelBenefitsRes.cmbOonOopInd : ""
                    }
                }
            },
            "Family": {
                "tierone": {
                    "OOP_Limit_2_Found_Family": financialsData.tierOne.OOP_Limit_2_Found_Family,
                    "Deductible": {
                        "Description": "Deductible",
                        "isAutodoc": false,
                        "Percentage": financialsData.tierOne.dedFoundFam ? financialsData.tierOne.dedFamPrecentage : 0,
                        "SpentAmount": financialsData.tierOne.dedFoundFam ? this.convert(cmp,financialsData.tierOne.dedSatisfiedFam) : '0.00',
                        "TotalAmount": financialsData.tierOne.dedFoundFam ? this.convert(cmp,financialsData.tierOne.deductibleFam) : '0.00',
                        "RemainingAmount": financialsData.tierOne.dedFoundFam ? this.convert(cmp,financialsData.tierOne.dedAmountRemFam) : '0.00',
                        "isAggregateFamilyIndicator": cmp.get("v.isAggregateFamilyIndicator"),
                        "isEmbeddedIndividualIndicator": cmp.get("v.isEmbeddedFamilyIndicator"),
                        "moveTop": "-130",
                        "moveLeft": "0",
                        "showDeductMsg": selectedPolicy.finDeOutFlgs.deductibleInfoFlg
                    },
                    "OutofPocket2": {
                        "Description": "Out-of-Pocket 2",
                        "isAutodoc": false,
                        "Percentage": financialsData.tierOne.OOP_Limit_2_Found_Family ? financialsData.tierOne.OOP_Limit_2_Precentage_Family : 0,
                        "SpentAmount": financialsData.tierOne.OOP_Limit_2_Found_Family ? this.convert(cmp,financialsData.tierOne.OOP_Limit_2_Satisfied_Family) : '0.00',
                        "TotalAmount": financialsData.tierOne.OOP_Limit_2_Found_Family ? this.convert(cmp,financialsData.tierOne.OOP_Limit_2_Family) : '0.00',
                        "RemainingAmount": financialsData.tierOne.OOP_Limit_2_Found_Family ? this.convert(cmp,financialsData.tierOne.OOP_Limit_2_Rem_Family) :'0.00'
                    },
                    "OutofPocket": {
                        "Description": "Out-of-Pocket",
                        "isAutodoc": false,
                        "Percentage": financialsData.tierOne.outOPFoundFam ? financialsData.tierOne.oopFamPrecentage : 0,
                        "SpentAmount": financialsData.tierOne.outOPFoundFam ? this.convert(cmp,financialsData.tierOne.outOPSatisfiedFam) : '0.00',
                        "TotalAmount": financialsData.tierOne.outOPFoundFam ? this.convert(cmp,financialsData.tierOne.outOPFam) : '0.00',
                        "RemainingAmount": financialsData.tierOne.outOPFoundFam ? this.convert(cmp,financialsData.tierOne.outOPRemAmountFam) : '0.00'
                    },
                    "MedicalLifeMaximum": {
                        "Description": "Medical Life Maximum",
                        "isAutodoc": false,
                        "Percentage": !$A.util.isUndefinedOrNull(planLevelBenefitsRes) ? planLevelBenefitsRes.medLifMaxPercent : "",
                        "SpentAmount": !$A.util.isUndefinedOrNull(planLevelBenefitsRes) ? this.convert(cmp,planLevelBenefitsRes.medLifMaxApplied) : "",
                        "TotalAmount": $A.util.isUndefinedOrNull(planLevelBenefitsRes) ? "" : this.convert(cmp,planLevelBenefitsRes.medLifMaxAmt),
                        "RemainingAmount": $A.util.isUndefinedOrNull(planLevelBenefitsRes) ? "" : this.convert(cmp,planLevelBenefitsRes.medLifMaxRemain),
                        "showRemaining": true
                    },
                    "CopayMax": {
                        "Description": "Copay Max",
                        "isAutodoc": false,
                        "TotalAmount": $A.util.isUndefinedOrNull(planLevelBenefitsRes) ? "" : this.convert(cmp,planLevelBenefitsRes.copayMaxAmount)
                    },
                    "CrossApplyOutofPocket": {
                        "isAutodoc": false,
                        "iscrsAplOop": true,
                        "crsAplOopSignVal": $A.util.isUndefinedOrNull(planLevelBenefitsRes) ? "" : planLevelBenefitsRes.crsApplyOopInd
                    },
                    "CrossApplyCopay": {
                        "iscrsAplCopy": true,
                        "crsAplCopySignVal": $A.util.isUndefinedOrNull(planLevelBenefitsRes) ? "" : planLevelBenefitsRes.crsApplyCopayInd,
                        "isAutodoc": false
                    },
                    "CrossApplyCore": {
                        "iscrsAplCore": true,
                        "crsAplCoreSignVal": $A.util.isUndefinedOrNull(planLevelBenefitsRes) ? "" : planLevelBenefitsRes.crsApplyCoreInd,
                        "isAutodoc": false
                    }
                },
                "inNetwork": {
                    "OOP_Limit_2_Found_Family": financialsData.inNetwork.OOP_Limit_2_Found_Family,
                    "Deductible": {
                        "Description": "Deductible",
                        "isAutodoc": false,
                        "Percentage": financialsData.inNetwork.dedFoundFam ? financialsData.inNetwork.dedFamPrecentage : 0,
                        "SpentAmount": financialsData.inNetwork.dedFoundFam ? this.convert(cmp,financialsData.inNetwork.dedSatisfiedFam) : '0.00',
                        "TotalAmount": financialsData.inNetwork.dedFoundFam ? this.convert(cmp,financialsData.inNetwork.deductibleFam) : '0.00',
                        "RemainingAmount": financialsData.inNetwork.dedFoundFam ? this.convert(cmp,financialsData.inNetwork.dedAmountRemFam) : '0.00',
                        "isAggregateFamilyIndicator": cmp.get("v.isAggregateFamilyIndicator"),
                        "isEmbeddedIndividualIndicator": cmp.get("v.isEmbeddedFamilyIndicator"),
                        "moveTop": "-130",
                        "moveLeft": "0",
                        "showDeductMsg": selectedPolicy.finDeOutFlgs.deductibleInfoFlg
                    },
                    "OutofPocket2": {
                        "Description": "Out-of-Pocket 2",
                        "isAutodoc": false,
                        "Percentage": financialsData.inNetwork.OOP_Limit_2_Found_Family ? financialsData.inNetwork.OOP_Limit_2_Precentage_Family : 0,
                        "SpentAmount": financialsData.inNetwork.OOP_Limit_2_Found_Family ? this.convert(cmp,financialsData.inNetwork.OOP_Limit_2_Satisfied_Family) : '0.00',
                        "TotalAmount": financialsData.inNetwork.OOP_Limit_2_Found_Family ? this.convert(cmp,financialsData.inNetwork.OOP_Limit_2_Family) : '0.00',
                        "RemainingAmount": financialsData.inNetwork.OOP_Limit_2_Found_Family ? this.convert(cmp,financialsData.inNetwork.OOP_Limit_2_Rem_Family) : '0.00'
                    },
                    "OutofPocket": {
                        "Description": "Out-of-Pocket",
                        "isAutodoc": false,
                        "Percentage": financialsData.inNetwork.outOPFoundFam ? financialsData.inNetwork.oopFamPrecentage : 0,
                        "SpentAmount": financialsData.inNetwork.outOPFoundFam ? this.convert(cmp,financialsData.inNetwork.outOPSatisfiedFam) : '0.00',
                        "TotalAmount": financialsData.inNetwork.outOPFoundFam ? this.convert(cmp,financialsData.inNetwork.outOPFam) : '0.00',
                        "RemainingAmount": financialsData.inNetwork.outOPFoundFam ? this.convert(cmp,financialsData.inNetwork.outOPRemAmountFam) : '0.00'
                    },
                    "MedicalLifeMaximum": {
                        "Description": "Medical Life Maximum",
                        "isAutodoc": false,
                        "Percentage": $A.util.isUndefinedOrNull(planLevelBenefitsRes) ? "" : planLevelBenefitsRes.medLifMaxPercent,
                        "SpentAmount": $A.util.isUndefinedOrNull(planLevelBenefitsRes) ? "" : this.convert(cmp,planLevelBenefitsRes.medLifMaxApplied),
                        "TotalAmount": $A.util.isUndefinedOrNull(planLevelBenefitsRes) ? "" : this.convert(cmp,planLevelBenefitsRes.medLifMaxAmt),
                        "RemainingAmount": $A.util.isUndefinedOrNull(planLevelBenefitsRes) ? "" : this.convert(cmp,planLevelBenefitsRes.medLifMaxRemain),
                        "showRemaining": true
                    },
                    "CopayMax": {
                        "Description": "Copay Max",
                        "isAutodoc": false,
                        "TotalAmount": $A.util.isUndefinedOrNull(planLevelBenefitsRes) ? "" : this.convert(cmp,planLevelBenefitsRes.copayMaxAmount)
                    },
                    "CrossApplyOutofPocket": {
                        "isAutodoc": false,
                        "iscrsAplOop": true,
                        "crsAplOopSignVal": $A.util.isUndefinedOrNull(planLevelBenefitsRes) ? "" : planLevelBenefitsRes.crsApplyOopInd
                    },
                    "CrossApplyCopay": {
                        "iscrsAplCopy": true,
                        "crsAplCopySignVal": $A.util.isUndefinedOrNull(planLevelBenefitsRes) ? "" : planLevelBenefitsRes.crsApplyCopayInd,
                        "isAutodoc": false
                    },
                    "CrossApplyCore": {
                        "iscrsAplCore": true,
                        "crsAplCoreSignVal": $A.util.isUndefinedOrNull(planLevelBenefitsRes) ? "" : planLevelBenefitsRes.crsApplyCoreInd,
                        "isAutodoc": false
                    },
                    "CombinedDeductible": {
                        "isComDed": true,
                        "comDedVal": $A.util.isUndefinedOrNull(planLevelBenefitsRes) ? "" : planLevelBenefitsRes.cmbInnDeductInd,
                        "isAutodoc": false
                    },
                    "CombinedOOP": {
                        "isComOop": true,
                        "isAutodoc": false,
                        "comOopVal": $A.util.isUndefinedOrNull(planLevelBenefitsRes) ? "" : planLevelBenefitsRes.cmbInnOopInd
                    }
                },
                "outofNetwork": {
                    "OOP_Limit_2_Found_Family": financialsData.onNetwork.OOP_Limit_2_Found_Family,
                    "Deductible": {
                        "Description": "Deductible",
                        "isAutodoc": false,
                        "Percentage": financialsData.onNetwork.dedFoundFam ? financialsData.onNetwork.dedFamPrecentage : 0,
                        "SpentAmount": financialsData.onNetwork.dedFoundFam ? this.convert(cmp,financialsData.onNetwork.dedSatisfiedFam) : '0.00',
                        "TotalAmount": financialsData.onNetwork.dedFoundFam ? this.convert(cmp,financialsData.onNetwork.deductibleFam) : '0.00',
                        "RemainingAmount": financialsData.onNetwork.dedFoundFam ? this.convert(cmp,financialsData.onNetwork.dedAmountRemFam) : '0.00',
                        "isAggregateFamilyIndicator": cmp.get("v.isAggregateFamilyIndicator"),
                        "isEmbeddedIndividualIndicator": cmp.get("v.isEmbeddedFamilyIndicator"),
                        "moveTop": "-130",
                        "moveLeft": "0",
                        "showDeductMsg": selectedPolicy.finDeOutFlgs.deductibleInfoFlg
                    },
                    "OutofPocket2": {
                        "Description": "Out-of-Pocket 2",
                        "isAutodoc": false,
                        "Percentage": financialsData.onNetwork.OOP_Limit_2_Found_Family ? financialsData.onNetwork.OOP_Limit_2_Precentage_Family : 0,
                        "SpentAmount": financialsData.onNetwork.OOP_Limit_2_Found_Family ? this.convert(cmp,financialsData.onNetwork.OOP_Limit_2_Satisfied_Family) : '0.00',
                        "TotalAmount": financialsData.onNetwork.OOP_Limit_2_Found_Family ? this.convert(cmp,financialsData.onNetwork.OOP_Limit_2_Family) : '0.00',
                        "RemainingAmount": financialsData.onNetwork.OOP_Limit_2_Found_Family ? this.convert(cmp,financialsData.onNetwork.OOP_Limit_2_Rem_Family) : '0.00'
                    },
                    "OutofPocket": {
                        "Description": "Out-of-Pocket",
                        "isAutodoc": false,
                        "Percentage": financialsData.onNetwork.outOPFoundFam ? financialsData.onNetwork.oopFamPrecentage : 0,
                        "SpentAmount": financialsData.onNetwork.outOPFoundFam ? this.convert(cmp,financialsData.onNetwork.outOPSatisfiedFam) : '0.00',
                        "TotalAmount": financialsData.onNetwork.outOPFoundFam ? this.convert(cmp,financialsData.onNetwork.outOPFam) : '0.00',
                        "RemainingAmount": financialsData.onNetwork.outOPFoundFam ? this.convert(cmp,financialsData.onNetwork.outOPRemAmountFam) : '0.00'
                    },
                    "MedicalLifeMaximum": {
                        "Description": "Medical Life Maximum",
                        "isAutodoc": false,
                        "Percentage": $A.util.isUndefinedOrNull(planLevelBenefitsRes) ? "" : planLevelBenefitsRes.medLifMaxPercent,
                        "SpentAmount": $A.util.isUndefinedOrNull(planLevelBenefitsRes) ? "" : this.convert(cmp,planLevelBenefitsRes.medLifMaxApplied),
                        "TotalAmount": $A.util.isUndefinedOrNull(planLevelBenefitsRes) ? "" : this.convert(cmp,planLevelBenefitsRes.medLifMaxAmt),
                        "RemainingAmount": $A.util.isUndefinedOrNull(planLevelBenefitsRes) ? "" : this.convert(cmp,planLevelBenefitsRes.medLifMaxRemain),
                        "showRemaining": true
                    },
                    "CopayMax": {
                        "Description": "Copay Max",
                        "isAutodoc": false,
                        "TotalAmount": $A.util.isUndefinedOrNull(planLevelBenefitsRes) ? "" : this.convert(cmp,planLevelBenefitsRes.copayMaxAmount)
                    },
                    "CrossApplyOutofPocket": {
                        "isAutodoc": false,
                        "iscrsAplOop": true,
                        "crsAplOopSignVal": $A.util.isUndefinedOrNull(planLevelBenefitsRes) ? "" : planLevelBenefitsRes.crsApplyOopInd
                    },
                    "CrossApplyCopay": {
                        "iscrsAplCopy": true,
                        "crsAplCopySignVal": $A.util.isUndefinedOrNull(planLevelBenefitsRes) ? "" : planLevelBenefitsRes.crsApplyCopayInd,
                        "isAutodoc": false
                    },
                    "CrossApplyCore": {
                        "iscrsAplCore": true,
                        "crsAplCoreSignVal": $A.util.isUndefinedOrNull(planLevelBenefitsRes) ? "" : planLevelBenefitsRes.crsApplyCoreInd,
                        "isAutodoc": false
                    },
                    "CombinedDeductible": {
                        "isComDed": true,
                        "comDedVal": $A.util.isUndefinedOrNull(planLevelBenefitsRes) ? "" : planLevelBenefitsRes.cmbOonDeductInd,
                        "isAutodoc": false
                    },
                    "CombinedOOP": {
                        "isComOop": true,
                        "isAutodoc": false,
                        "comOopVal": $A.util.isUndefinedOrNull(planLevelBenefitsRes) ? "" : planLevelBenefitsRes.cmbOonOopInd
                    }
                }
            }
        };
        cmp.set("v.financialObject", financialJSON);
        
    },
    
    initAutoDocTab: function (cmp, event, helper) {
        var callTopicOrder = cmp.get('v.callTopicOrder');
        var callTopicOrderCount = Object.keys(callTopicOrder).length;
        var timer = 100;
        if (callTopicOrderCount > 1) {
            timer = 2000;
        }
        setTimeout(function () {
            var tabKey = cmp.get("v.AutodocKey");
            window.lgtAutodoc.initAutodoc(tabKey);
            
            var AutodocKey = cmp.get('v.AutodocKey');
            var elenm = '.' + AutodocKey + ' .autodoc';
            $(elenm).on('click', function () {
                cmp.set('v.AutodocPageFeatureMemberDtl', cmp.get('v.AutodocPageFeature'));
                cmp.set("v.AutodocKeyMemberDtl", cmp.get("v.AutodocKey"));
            });
            
        }, timer);
        
        // US2618180
        //helper.fireCallTopicAutodoc(cmp, event, helper);
        
    },
    
    // US2618180
    fireCallTopicAutodoc: function (cmp, event, helper) {
        var appEvent = $A.get("e.c:ACET_CallTopicAutodoc");
        appEvent.setParams({
            memberTabId: cmp.get('v.memberTabId'),
            AutodocKey: cmp.get('v.AutodocKey'),
            AutodocPageFeature: cmp.get('v.AutodocPageFeature')
        });
        appEvent.fire();
    },
    convert:function(cmp,setValue) {
        var actualVal=String(setValue).split('.');
        if(actualVal[1]!=undefined)
        {
            if(actualVal[1].length==0)
            {
               return actualVal[0]+'.00';
            }else if(actualVal[1].length==1)
            {
              	return actualVal[0]+'.'+actualVal[1]+'0';
            }else
            {
               return actualVal[0]+'.'+actualVal[1];
            }
        }else
        {
            return actualVal[0]+'.00';
        }
    },
    callEligibilityService: function (component, event, helper) {
         component.set("v.showSpinnerFinancials", true);
        //var action = component.get("c.callEligibilityServicesFinancials");
        var action = component.get("c.fourthCallout");
        var policyRec = component.get("v.selectedPolicy");
        var selectedPolicyDt;
        var eligibleDates;
        var eligibleDatesList;
        var startDateList;
        var endDateList;
        var memberId = ""
        var GroupNumber = "";
        if (!$A.util.isUndefinedOrNull(component.get("v.policyList"))) {
            var selectedPolicyDt = component.get("v.policyList");
            selectedPolicyDt = selectedPolicyDt[component.get("v.policySelectedIndex")];
            if (!$A.util.isUndefinedOrNull(selectedPolicyDt)) {
                eligibleDates = selectedPolicyDt.eligibleDates;
                eligibleDatesList = eligibleDates.split(" ");
                startDateList = eligibleDatesList[0].split("/");
                endDateList = eligibleDatesList[2].split("/");
                memberId = !$A.util.isUndefinedOrNull(selectedPolicyDt.patientInfo) ? selectedPolicyDt.patientInfo.MemberId:"";
                GroupNumber = selectedPolicyDt.GroupNumber;
            }

        }

        //var eligibleDates = selectedPolicyDt.eligibleDates;//"01/01/2019 - 03/18/2021";
        //var eligibleDatesList = eligibleDates.split(" ");
        //var startDateList = eligibleDatesList[0].split("/");
        //var endDateList = eligibleDatesList[2].split("/");
        var startDate="";
        if (!$A.util.isUndefinedOrNull(startDateList) && startDateList.length ==3 ) {
            startDate = startDateList[2]+"-"+startDateList[0]+"-"+startDateList[1];
        }
        var endDate="";
        if (!$A.util.isUndefinedOrNull(endDateList) && endDateList.length ==3 ) {
            endDate = endDateList[2]+"-"+endDateList[0]+"-"+endDateList[1];
        }
        //var startDate = startDateList[2]+"-"+startDateList[0]+"-"+startDateList[1];
        //var endDate = endDateList[2]+"-"+endDateList[0]+"-"+endDateList[1];
        //var memberId = selectedPolicyDt.patientInfo.MemberId;
        //var memDob = component.get("v.memberDOB");
        //var memDobLst = memDob.split("/");
        //var memberDOB = memDobLst[2]+"-"+memDobLst[0]+"-"+memDobLst[1];
        //var GroupNumber = selectedPolicyDt.GroupNumber;
        var memDob = component.get("v.memberDOB");
        var memDobLst;
        var memberDOB="";
        if(!$A.util.isUndefinedOrNull(memDob)){
            memDobLst = memDob.split("/");
            memberDOB = memDobLst[2]+"-"+memDobLst[0]+"-"+memDobLst[1];
        }
        if(!component.get("v.isClaimDetails")){
            helper.getPayerId(component);
        }

        //var isCalloutFourth = true; component.get("v.memberId"),component.get("v.policyNumber"),
        var memberDetails = {
            memberId: memberId,
            memberDOB: memberDOB,
            firstName: component.get("v.memberFN"),
            lastName: component.get("v.memberLN"),
            groupNumber: GroupNumber,
            searchOption: 'NameDateOfBirth',
            serviceStart:startDate,
            serviceEnd:endDate,
            payerID: component.get("v.currentPayerId"),
            sourceCode : component.get("v.highlightedPolicySourceCode"),
            isFourthCallout : true
        };
        action.setParams({
            memberDetails : memberDetails,
            providerDetails: component.get("v.providerDetails")
        });
        //displayYear: true
        action.setCallback(this, function(response){
            var state = response.getState();
            var resultFourthCall = response.getReturnValue();
            resultFourthCall = JSON.parse(resultFourthCall);

            if(state == "SUCCESS" && resultFourthCall.statusCode == 200){
                component.set("v.showSpinnerFinancials", false);
                var policyRec = component.get("v.selectedPolicy");
                var coverageLines = resultFourthCall.resultWrapper.CoverageLines;

                //for(var i = 0; i < coverageLines.length; i++) {
                    //if(coverageLines[i].highlightedPolicy == true) {
                    //if(coverageLines[i].transactionId == policyRec.transactionId) {
                        var financialWrapper = coverageLines[0].financialWrapper;
                        var yearTypeBenefits = coverageLines[0].financialWrapper.yearType;
                        var displayYearBenefits = coverageLines[0].financialWrapper.displayYear;
                        component.set("v.financialsData",financialWrapper);
                        component.set("v.isFinancialDataFetched",true);
                        component.set("v.yearTypeBenefits",yearTypeBenefits);
                        component.set("v.displayYearBenefits",displayYearBenefits);
                    //}
                //}

            }else{
                //Error Handling
                component.set("v.showSpinnerFinancials", false);
                helper.getFinancialObject_Error(component);
                //var indexStr = resultFourthCall.message.indexOf("(");
                //var res = resultFourthCall.message.substring(0,indexStr);
                //helper.fireToastMessage("We hit a snag.", res, "error", "dismissible", "6000");
                //component.set("v.showSpinnerFinancials", false);
                var res;
                if (!$A.util.isUndefinedOrNull(resultFourthCall) && !$A.util.isUndefinedOrNull(resultFourthCall.message)) {
                var indexStr = resultFourthCall.message.indexOf("(");
                    res = resultFourthCall.message.substring(0,indexStr);
                }else{
                    res = "Unexpected error occurred with Finalcial Results. Please try again. If problem persists please contact the help desk. (999)";
                }
                helper.fireToastMessage("We hit a snag.", res, "error", "dismissible", "30000");

            }
             if(!$A.util.isUndefinedOrNull(resultFourthCall) && !$A.util.isUndefinedOrNull(resultFourthCall.showRefershError) && resultFourthCall.showRefershError){
                    helper.fireToastMessage("We hit a snag.", "The financial card failed to load. Please refresh.", "error", "dismissible", "30000");
            }
        });
        $A.enqueueAction(action);
    },

    fireToastMessage: function (title, message, type, mode, duration) {
		var toastEvent = $A.get("e.force:showToast");
		toastEvent.setParams({
			"title": title,
			"message": message,
			"type": type,
			"mode": mode,
			"duration": duration
		});
		toastEvent.fire();
	},

    getFinancialObject_Error: function (cmp) {
        var financialsData = cmp.get("v.financialsData");
        var selectedPolicy = cmp.get("v.selectedPolicy");
        var planLevelBenefitsRes = cmp.get("v.planLevelBenefitsRes");
        var financialJSON = cmp.get("v.financialObject");
         var currentIndexOfOpenedTabs = cmp.get("v.currentIndexOfOpenedTabs");
         var maxAutoDocComponents = cmp.get("v.maxAutoDocComponents");
         var claimNo=cmp.get("v.claimNo");
        var isClaimDetail=cmp.get("v.isClaimDetail");
        financialJSON = {
            "type": "financials",
            "autodocHeaderName": isClaimDetail?("Financials: "+claimNo) : "Financials" ,
            "componentName": isClaimDetail? ("Financials: "+claimNo) :"Financials" ,
            "reportingHeader" : 'Financials',
            "componentOrder": isClaimDetail? (19 +(maxAutoDocComponents*currentIndexOfOpenedTabs)):3 ,
            "policyNumber": cmp.get("v.policyNumber"),
            "financialDate": cmp.get("v.today"),
            "yearType": cmp.get("v.yearType"),
            "displayYear": cmp.get("v.displayYear"),
            "isCdhp": false,
            "isFamilyAccumulation": cmp.get("v.isFamilyAccumulation"),
            "copayMaxAmount": !$A.util.isUndefinedOrNull(planLevelBenefitsRes) ? planLevelBenefitsRes.copayMaxAmount : "",
            "Individual": {
                "tierone": {
                    "OOP_Limit_2_Found": false,
                    "Deductible": {
                        "Description": "Deductible",
                        "isAutodoc": false,
                        "Percentage": 0.00,
                        "SpentAmount": '0.00',
                        "TotalAmount": '0.00',
                        "RemainingAmount": '0.00',
                        "isAggregateIndividualIndicator": cmp.get("v.isAggregateIndividualIndicator"),
                        "isAggregateFamilyIndicator": cmp.get("v.isAggregateFamilyIndicator"),
                        "isEmbeddedIndividualIndicator": cmp.get("v.isEmbeddedIndividualIndicator"),
                        "moveTop": "-130",
                        "moveLeft": "0",
                        "showDeductMsg": selectedPolicy.finDeOutFlgs.deductibleInfoFlg
                    },
                    "OutofPocket2": {
                        "Description": "Out-of-Pocket 2",
                        "isAutodoc": false,
                        "Percentage": 0,
                        "SpentAmount": '0.00',
                        "TotalAmount": '0.00',
                        "RemainingAmount": '0.00'
                    },
                    "OutofPocket": {
                        "Description": "Out-of-Pocket",
                        "isAutodoc": false,
                        "Percentage": 0,
                        "SpentAmount": '0.00',
                        "TotalAmount": '0.00',
                        "RemainingAmount": '0.00'
                    },
                    "MedicalLifeMaximum": {
                        "Description": "Medical Life Maximum",
                        "isAutodoc": false,
                        "Percentage": !$A.util.isUndefinedOrNull(planLevelBenefitsRes) ? planLevelBenefitsRes.medLifMaxPercent : "",
                        "SpentAmount": !$A.util.isUndefinedOrNull(planLevelBenefitsRes) ? this.convert(cmp,planLevelBenefitsRes.medLifMaxApplied) : "",
                        "TotalAmount": !$A.util.isUndefinedOrNull(planLevelBenefitsRes) ? this.convert(cmp,planLevelBenefitsRes.medLifMaxAmt) : "",
                        "RemainingAmount": !$A.util.isUndefinedOrNull(planLevelBenefitsRes) ? this.convert(cmp,planLevelBenefitsRes.medLifMaxRemain) : "",
                        "showRemaining": true
                    },
                    "CopayMax": {
                        "Description": "Copay Max",
                        "isAutodoc": false,
                        "TotalAmount": !$A.util.isUndefinedOrNull(planLevelBenefitsRes) ? this.convert(cmp,planLevelBenefitsRes.copayMaxAmount) : ""
                    },
                    "CrossApplyOutofPocket": {
                        "isAutodoc": false,
                        "iscrsAplOop": true,
                        "crsAplOopSignVal": !$A.util.isUndefinedOrNull(planLevelBenefitsRes) ? planLevelBenefitsRes.crsApplyOopInd : ""
                    },
                    "CrossApplyCopay": {
                        "iscrsAplCopy": true,
                        "crsAplCopySignVal": !$A.util.isUndefinedOrNull(planLevelBenefitsRes) ? planLevelBenefitsRes.crsApplyCopayInd : "",
                        "isAutodoc": false
                    },
                    "CrossApplyCore": {
                        "iscrsAplCore": true,
                        "crsAplCoreSignVal": !$A.util.isUndefinedOrNull(planLevelBenefitsRes) ? planLevelBenefitsRes.crsApplyCoreInd : "",
                        "isAutodoc": false
                    }
                },
                "inNetwork": {
                    "OOP_Limit_2_Found": false,
                    "Deductible": {
                        "Description": "Deductible",
                        "isAutodoc": false,
                        "Percentage": 0,
                        "SpentAmount": '0.00',
                        "TotalAmount": '0.00',
                        "RemainingAmount": '0.00',
                        "isAggregateIndividualIndicator": cmp.get("v.isAggregateIndividualIndicator"),
                        "isAggregateFamilyIndicator": cmp.get("v.isAggregateFamilyIndicator"),
                        "isEmbeddedIndividualIndicator": cmp.get("v.isEmbeddedIndividualIndicator"),
                        "moveTop": "-130",
                        "moveLeft": "0",
                        "showDeductMsg": selectedPolicy.finDeOutFlgs.deductibleInfoFlg
                    },
                    "OutofPocket2": {
                        "Description": "Out-of-Pocket 2",
                        "isAutodoc": false,
                        "Percentage": 0,
                        "SpentAmount": '0.00',
                        "TotalAmount": '0.00',
                        "RemainingAmount": '0.00'
                    },
                    "OutofPocket": {
                        "Description": "Out-of-Pocket",
                        "isAutodoc": false,
                        "Percentage": 0,
                        "SpentAmount": '0.00',
                        "TotalAmount": '0.00',
                        "RemainingAmount": '0.00'
                    },
                    "MedicalLifeMaximum": {
                        "Description": "Medical Life Maximum",
                        "isAutodoc": false,
                        "Percentage": !$A.util.isUndefinedOrNull(planLevelBenefitsRes) ? planLevelBenefitsRes.medLifMaxPercent : "",
                        "SpentAmount": !$A.util.isUndefinedOrNull(planLevelBenefitsRes) ? this.convert(cmp,planLevelBenefitsRes.medLifMaxApplied) : "",
                        "TotalAmount": !$A.util.isUndefinedOrNull(planLevelBenefitsRes) ? this.convert(cmp,planLevelBenefitsRes.medLifMaxAmt) : "",
                        "RemainingAmount": !$A.util.isUndefinedOrNull(planLevelBenefitsRes) ? this.convert(cmp,planLevelBenefitsRes.medLifMaxRemain) : "",
                        "showRemaining": true
                    },
                    "CopayMax": {
                        "Description": "Copay Max",
                        "isAutodoc": false,
                        "TotalAmount": !$A.util.isUndefinedOrNull(planLevelBenefitsRes) ? this.convert(cmp,planLevelBenefitsRes.copayMaxAmount) : ""
                    },
                    "CrossApplyOutofPocket": {
                        "isAutodoc": false,
                        "iscrsAplOop": true,
                        "crsAplOopSignVal": !$A.util.isUndefinedOrNull(planLevelBenefitsRes) ? planLevelBenefitsRes.crsApplyOopInd : ""
                    },
                    "CrossApplyCopay": {
                        "iscrsAplCopy": true,
                        "crsAplCopySignVal": !$A.util.isUndefinedOrNull(planLevelBenefitsRes) ? planLevelBenefitsRes.crsApplyCopayInd : "",
                        "isAutodoc": false
                    },
                    "CrossApplyCore": {
                        "iscrsAplCore": true,
                        "crsAplCoreSignVal": !$A.util.isUndefinedOrNull(planLevelBenefitsRes) ? planLevelBenefitsRes.crsApplyCoreInd : "",
                        "isAutodoc": false
                    },
                    "CombinedDeductible": {
                        "isComDed": true,
                        "comDedVal": !$A.util.isUndefinedOrNull(planLevelBenefitsRes) ? planLevelBenefitsRes.cmbInnDeductInd : "",
                        "isAutodoc": false
                    },
                    "CombinedOOP": {
                        "isComOop": true,
                        "isAutodoc": false,
                        "comOopVal": !$A.util.isUndefinedOrNull(planLevelBenefitsRes) ? planLevelBenefitsRes.cmbInnOopInd : ""
                    }
                },
                "outofNetwork": {
                    "OOP_Limit_2_Found": false,
                    "Deductible": {
                        "Description": "Deductible",
                        "isAutodoc": false,
                        "Percentage": 0,
                        "SpentAmount": '0.00',
                        "TotalAmount": '0.00',
                        "RemainingAmount": '0.00',
                        "isAggregateIndividualIndicator": cmp.get("v.isAggregateIndividualIndicator"),
                        "isAggregateFamilyIndicator": cmp.get("v.isAggregateFamilyIndicator"),
                        "isEmbeddedIndividualIndicator": cmp.get("v.isEmbeddedIndividualIndicator"),
                        "moveTop": "-130",
                        "moveLeft": "0",
                        "showDeductMsg": selectedPolicy.finDeOutFlgs.deductibleInfoFlg
                    },
                    "OutofPocket2": {
                        "Description": "Out-of-Pocket 2",
                        "isAutodoc": false,
                        "Percentage": 0,
                        "SpentAmount": '0.00',
                        "TotalAmount": '0.00',
                        "RemainingAmount": '0.00'
                    },
                    "OutofPocket": {
                        "Description": "Out-of-Pocket",
                        "isAutodoc": false,
                        "Percentage": 0,
                        "SpentAmount": '0.00',
                        "TotalAmount": '0.00',
                        "RemainingAmount": '0.00'
                    },
                    "MedicalLifeMaximum": {
                        "Description": "Medical Life Maximum",
                        "isAutodoc": false,
                        "Percentage": !$A.util.isUndefinedOrNull(planLevelBenefitsRes) ? planLevelBenefitsRes.medLifMaxPercent : "",
                        "SpentAmount": !$A.util.isUndefinedOrNull(planLevelBenefitsRes) ? this.convert(cmp,planLevelBenefitsRes.medLifMaxApplied) : "",
                        "TotalAmount": !$A.util.isUndefinedOrNull(planLevelBenefitsRes) ? this.convert(cmp,planLevelBenefitsRes.medLifMaxAmt) : "",
                        "RemainingAmount": !$A.util.isUndefinedOrNull(planLevelBenefitsRes) ? this.convert(cmp,planLevelBenefitsRes.medLifMaxRemain) : "",
                        "showRemaining": true
                    },
                    "CopayMax": {
                        "Description": "Copay Max",
                        "isAutodoc": false,
                        "TotalAmount": !$A.util.isUndefinedOrNull(planLevelBenefitsRes) ? this.convert(cmp,planLevelBenefitsRes.copayMaxAmount) : ""
                    },
                    "CrossApplyOutofPocket": {
                        "isAutodoc": false,
                        "iscrsAplOop": true,
                        "crsAplOopSignVal": !$A.util.isUndefinedOrNull(planLevelBenefitsRes) ? planLevelBenefitsRes.crsApplyOopInd : ""
                    },
                    "CrossApplyCopay": {
                        "iscrsAplCopy": true,
                        "crsAplCopySignVal": !$A.util.isUndefinedOrNull(planLevelBenefitsRes) ? planLevelBenefitsRes.crsApplyCopayInd : "",
                        "isAutodoc": false
                    },
                    "CrossApplyCore": {
                        "iscrsAplCore": true,
                        "crsAplCoreSignVal": !$A.util.isUndefinedOrNull(planLevelBenefitsRes) ? planLevelBenefitsRes.crsApplyCoreInd : "",
                        "isAutodoc": false
                    },
                    "CombinedDeductible": {
                        "isComDed": true,
                        "comDedVal": !$A.util.isUndefinedOrNull(planLevelBenefitsRes) ? planLevelBenefitsRes.cmbOonDeductInd : "",
                        "isAutodoc": false
                    },
                    "CombinedOOP": {
                        "isComOop": true,
                        "isAutodoc": false,
                        "comOopVal": !$A.util.isUndefinedOrNull(planLevelBenefitsRes) ? planLevelBenefitsRes.cmbOonOopInd : ""
                    }
                }
            },
            "Family": {
                "tierone": {
                    "OOP_Limit_2_Found_Family": false,
                    "Deductible": {
                        "Description": "Deductible",
                        "isAutodoc": false,
                        "Percentage": 0,
                        "SpentAmount": '0.00',
                        "TotalAmount": '0.00',
                        "RemainingAmount": '0.00',
                        "isAggregateFamilyIndicator": cmp.get("v.isAggregateFamilyIndicator"),
                        "isEmbeddedIndividualIndicator": cmp.get("v.isEmbeddedFamilyIndicator"),
                        "moveTop": "-130",
                        "moveLeft": "0",
                        "showDeductMsg": selectedPolicy.finDeOutFlgs.deductibleInfoFlg
                    },
                    "OutofPocket2": {
                        "Description": "Out-of-Pocket 2",
                        "isAutodoc": false,
                        "Percentage": 0,
                        "SpentAmount": '0.00',
                        "TotalAmount": '0.00',
                        "RemainingAmount": '0.00'
                    },
                    "OutofPocket": {
                        "Description": "Out-of-Pocket",
                        "isAutodoc": false,
                        "Percentage": 0,
                        "SpentAmount": '0.00',
                        "TotalAmount": '0.00',
                        "RemainingAmount": '0.00'
                    },
                    "MedicalLifeMaximum": {
                        "Description": "Medical Life Maximum",
                        "isAutodoc": false,
                        "Percentage": !$A.util.isUndefinedOrNull(planLevelBenefitsRes) ? planLevelBenefitsRes.medLifMaxPercent : "",
                        "SpentAmount": !$A.util.isUndefinedOrNull(planLevelBenefitsRes) ? this.convert(cmp,planLevelBenefitsRes.medLifMaxApplied) : "",
                        "TotalAmount": $A.util.isUndefinedOrNull(planLevelBenefitsRes) ? "" : this.convert(cmp,planLevelBenefitsRes.medLifMaxAmt),
                        "RemainingAmount": $A.util.isUndefinedOrNull(planLevelBenefitsRes) ? "" : this.convert(cmp,planLevelBenefitsRes.medLifMaxRemain),
                        "showRemaining": true
                    },
                    "CopayMax": {
                        "Description": "Copay Max",
                        "isAutodoc": false,
                        "TotalAmount": $A.util.isUndefinedOrNull(planLevelBenefitsRes) ? "" : this.convert(cmp,planLevelBenefitsRes.copayMaxAmount)
                    },
                    "CrossApplyOutofPocket": {
                        "isAutodoc": false,
                        "iscrsAplOop": true,
                        "crsAplOopSignVal": $A.util.isUndefinedOrNull(planLevelBenefitsRes) ? "" : planLevelBenefitsRes.crsApplyOopInd
                    },
                    "CrossApplyCopay": {
                        "iscrsAplCopy": true,
                        "crsAplCopySignVal": $A.util.isUndefinedOrNull(planLevelBenefitsRes) ? "" : planLevelBenefitsRes.crsApplyCopayInd,
                        "isAutodoc": false
                    },
                    "CrossApplyCore": {
                        "iscrsAplCore": true,
                        "crsAplCoreSignVal": $A.util.isUndefinedOrNull(planLevelBenefitsRes) ? "" : planLevelBenefitsRes.crsApplyCoreInd,
                        "isAutodoc": false
                    }
                },
                "inNetwork": {
                    "OOP_Limit_2_Found_Family": false,
                    "Deductible": {
                        "Description": "Deductible",
                        "isAutodoc": false,
                        "Percentage": 0,
                        "SpentAmount": '0.00',
                        "TotalAmount": '0.00',
                        "RemainingAmount": '0.00',
                        "isAggregateFamilyIndicator": cmp.get("v.isAggregateFamilyIndicator"),
                        "isEmbeddedIndividualIndicator": cmp.get("v.isEmbeddedFamilyIndicator"),
                        "moveTop": "-130",
                        "moveLeft": "0",
                        "showDeductMsg": selectedPolicy.finDeOutFlgs.deductibleInfoFlg
                    },
                    "OutofPocket2": {
                        "Description": "Out-of-Pocket 2",
                        "isAutodoc": false,
                        "Percentage": 0,
                        "SpentAmount": '0.00',
                        "TotalAmount": '0.00',
                        "RemainingAmount": '0.00'
                    },
                    "OutofPocket": {
                        "Description": "Out-of-Pocket",
                        "isAutodoc": false,
                        "Percentage": 0,
                        "SpentAmount": '0.00',
                        "TotalAmount": '0.00',
                        "RemainingAmount": '0.00'
                    },
                    "MedicalLifeMaximum": {
                        "Description": "Medical Life Maximum",
                        "isAutodoc": false,
                        "Percentage": $A.util.isUndefinedOrNull(planLevelBenefitsRes) ? "" : planLevelBenefitsRes.medLifMaxPercent,
                        "SpentAmount": $A.util.isUndefinedOrNull(planLevelBenefitsRes) ? "" : this.convert(cmp,planLevelBenefitsRes.medLifMaxApplied),
                        "TotalAmount": $A.util.isUndefinedOrNull(planLevelBenefitsRes) ? "" : this.convert(cmp,planLevelBenefitsRes.medLifMaxAmt),
                        "RemainingAmount": $A.util.isUndefinedOrNull(planLevelBenefitsRes) ? "" : this.convert(cmp,planLevelBenefitsRes.medLifMaxRemain),
                        "showRemaining": true
                    },
                    "CopayMax": {
                        "Description": "Copay Max",
                        "isAutodoc": false,
                        "TotalAmount": $A.util.isUndefinedOrNull(planLevelBenefitsRes) ? "" : this.convert(cmp,planLevelBenefitsRes.copayMaxAmount)
                    },
                    "CrossApplyOutofPocket": {
                        "isAutodoc": false,
                        "iscrsAplOop": true,
                        "crsAplOopSignVal": $A.util.isUndefinedOrNull(planLevelBenefitsRes) ? "" : planLevelBenefitsRes.crsApplyOopInd
                    },
                    "CrossApplyCopay": {
                        "iscrsAplCopy": true,
                        "crsAplCopySignVal": $A.util.isUndefinedOrNull(planLevelBenefitsRes) ? "" : planLevelBenefitsRes.crsApplyCopayInd,
                        "isAutodoc": false
                    },
                    "CrossApplyCore": {
                        "iscrsAplCore": true,
                        "crsAplCoreSignVal": $A.util.isUndefinedOrNull(planLevelBenefitsRes) ? "" : planLevelBenefitsRes.crsApplyCoreInd,
                        "isAutodoc": false
                    },
                    "CombinedDeductible": {
                        "isComDed": true,
                        "comDedVal": $A.util.isUndefinedOrNull(planLevelBenefitsRes) ? "" : planLevelBenefitsRes.cmbInnDeductInd,
                        "isAutodoc": false
                    },
                    "CombinedOOP": {
                        "isComOop": true,
                        "isAutodoc": false,
                        "comOopVal": $A.util.isUndefinedOrNull(planLevelBenefitsRes) ? "" : planLevelBenefitsRes.cmbInnOopInd
                    }
                },
                "outofNetwork": {
                    "OOP_Limit_2_Found_Family": false,
                    "Deductible": {
                        "Description": "Deductible",
                        "isAutodoc": false,
                        "Percentage":  0,
                        "SpentAmount": '0.00',
                        "TotalAmount": '0.00',
                        "RemainingAmount": '0.00',
                        "isAggregateFamilyIndicator": cmp.get("v.isAggregateFamilyIndicator"),
                        "isEmbeddedIndividualIndicator": cmp.get("v.isEmbeddedFamilyIndicator"),
                        "moveTop": "-130",
                        "moveLeft": "0",
                        "showDeductMsg": selectedPolicy.finDeOutFlgs.deductibleInfoFlg
                    },
                    "OutofPocket2": {
                        "Description": "Out-of-Pocket 2",
                        "isAutodoc": false,
                        "Percentage": 0,
                        "SpentAmount": '0.00',
                        "TotalAmount": '0.00',
                        "RemainingAmount": '0.00'
                    },
                    "OutofPocket": {
                        "Description": "Out-of-Pocket",
                        "isAutodoc": false,
                        "Percentage": 0,
                        "SpentAmount": '0.00',
                        "TotalAmount": '0.00',
                        "RemainingAmount": '0.00'
                    },
                    "MedicalLifeMaximum": {
                        "Description": "Medical Life Maximum",
                        "isAutodoc": false,
                        "Percentage": $A.util.isUndefinedOrNull(planLevelBenefitsRes) ? "" : planLevelBenefitsRes.medLifMaxPercent,
                        "SpentAmount": $A.util.isUndefinedOrNull(planLevelBenefitsRes) ? "" : this.convert(cmp,planLevelBenefitsRes.medLifMaxApplied),
                        "TotalAmount": $A.util.isUndefinedOrNull(planLevelBenefitsRes) ? "" : this.convert(cmp,planLevelBenefitsRes.medLifMaxAmt),
                        "RemainingAmount": $A.util.isUndefinedOrNull(planLevelBenefitsRes) ? "" : this.convert(cmp,planLevelBenefitsRes.medLifMaxRemain),
                        "showRemaining": true
                    },
                    "CopayMax": {
                        "Description": "Copay Max",
                        "isAutodoc": false,
                        "TotalAmount": $A.util.isUndefinedOrNull(planLevelBenefitsRes) ? "" : this.convert(cmp,planLevelBenefitsRes.copayMaxAmount)
                    },
                    "CrossApplyOutofPocket": {
                        "isAutodoc": false,
                        "iscrsAplOop": true,
                        "crsAplOopSignVal": $A.util.isUndefinedOrNull(planLevelBenefitsRes) ? "" : planLevelBenefitsRes.crsApplyOopInd
                    },
                    "CrossApplyCopay": {
                        "iscrsAplCopy": true,
                        "crsAplCopySignVal": $A.util.isUndefinedOrNull(planLevelBenefitsRes) ? "" : planLevelBenefitsRes.crsApplyCopayInd,
                        "isAutodoc": false
                    },
                    "CrossApplyCore": {
                        "iscrsAplCore": true,
                        "crsAplCoreSignVal": $A.util.isUndefinedOrNull(planLevelBenefitsRes) ? "" : planLevelBenefitsRes.crsApplyCoreInd,
                        "isAutodoc": false
                    },
                    "CombinedDeductible": {
                        "isComDed": true,
                        "comDedVal": $A.util.isUndefinedOrNull(planLevelBenefitsRes) ? "" : planLevelBenefitsRes.cmbOonDeductInd,
                        "isAutodoc": false
                    },
                    "CombinedOOP": {
                        "isComOop": true,
                        "isAutodoc": false,
                        "comOopVal": $A.util.isUndefinedOrNull(planLevelBenefitsRes) ? "" : planLevelBenefitsRes.cmbOonOopInd
                    }
                }
            }
        };
        cmp.set("v.financialObject", financialJSON);

    },

    getPayerId: function(component){
        var memberData = component.get("v.memberCardSnap");
        var payerIDTest = component.get("v.currentPayerId");
        var policymap;
        var isDependent = component.get("v.isDependent");
        var searchQueryPayerId;
        var currentTranscationId;

        if (!$A.util.isUndefinedOrNull(memberData) && !$A.util.isEmpty(memberData)) {
            if(!$A.util.isUndefinedOrNull(memberData.policyandPayerMap) && !$A.util.isEmpty(memberData.policyandPayerMap) &&
               !$A.util.isUndefinedOrNull(memberData.searchQueryPayerId) && !$A.util.isEmpty(memberData.searchQueryPayerId)){
                policymap = memberData.policyandPayerMap;
            }else if(!$A.util.isUndefinedOrNull(memberData.searchQueryPayerId) && !$A.util.isEmpty(memberData.searchQueryPayerId)){
                searchQueryPayerId = memberData.searchQueryPayerId;
            }else{
                searchQueryPayerId = "87726";
            }
        }

        var isActiveFound =false;
        var strDependentActiveValue='';
        if(currentTranscationId != '' && policymap != null && !$A.util.isEmpty(policymap) ){
            for(var key in policymap){
                var currentPayerIdValue = policymap[key].split(';;');
                if(key == currentTranscationId){
                    isActiveFound = true;
                    component.set("v.currentPayerId",currentPayerIdValue[0]);
                }
                if(currentPayerIdValue[1] == 'T'){
                    strDependentActiveValue = currentPayerIdValue[0];
                }
            }
            if(isActiveFound == false ){
                if(isDependent && strDependentActiveValue != '' ){
                    component.set("v.currentPayerId",strDependentActiveValue);
                }
                else if(searchQueryPayerId){
                    component.set("v.currentPayerId",searchQueryPayerId);
                }

            }
        }else if(!$A.util.isUndefinedOrNull(searchQueryPayerId) && searchQueryPayerId!= '--' && searchQueryPayerId!= ''){
            component.set("v.currentPayerId",searchQueryPayerId);
        }else{
            searchQueryPayerId = "87726";
        }
    }
    
})