({
    init: function (component, event, helper) {

        // US2452317 - Thanish - 25th Mar 2020 - moved code to save case function
        helper.showCaseSpinner(component);

        helper.loadTtsTopics(component, event, helper);
        component.set('v.typeOptions', '--None--');
        component.set('v.subtypeOptions', '--None--');

        //US1875495
        let caseVal = component.get('v.caseWrapper');
        caseVal.AddInfoTopic = component.get("v.Topic");
        caseVal.Status = 'Open';
        component.set('v.caseWrapper', caseVal);

        // US2581517 - Thanish - 11th May 2020
        //helper.processSelectedAutodoc(component, event, helper);

        //DE378289 - Praveen - 10/22/2020 - Regression defect
        var subjectId = caseVal.SubjectId;
        if (component.get("v.isMemberSnapshot") && !$A.util.isUndefinedOrNull(subjectId)) {
            var appEvent = $A.get("e.c:ACET_GetPoliciesList");
            appEvent.setParams({
                "subjectId": subjectId
            });
            appEvent.fire();
        }

        //US3071655 - Sravan - Start
        // External Id Issue
        if (component.get("v.onlyRoute")) {
        helper.getSelectedPolicies(component, event, helper);
        }
        var routingAvailabilityWarningMessage = 'Note!  Case creation for Issue Routed is only available for  C&S Medical Policy.';
        component.set("v.routingAvailabilityWarningMessage", routingAvailabilityWarningMessage);
        //US3071655 - Sravan - End

        //var tabId = component.get('v.freezePanelId');
        var highlightPanel = document.getElementById("highlightPanel");
        if (!$A.util.isUndefinedOrNull(highlightPanel)) {
            //highlightPanel.classList.remove("highlightPanelPosition");
            //highlightPanel.classList.add("caseModelOpened");
        }


    },

    closeModal: function (component, event, helper) {
        let cmpEvent = component.getEvent("closeModalBox");
        cmpEvent.fire();

        // US2091974 - Sanka - Case Creation
        component.set("v.isModalOpen", false);
    },
    onTypeChange: function (component, event, helper) {

        // US1753077 - Pilot Enhancement - Save Case - Validations and Additional Functionality: Kavinda - START
        let caseVal = component.get('v.caseWrapper');
        caseVal.AddInfoOrginType = '';
        caseVal.AddInfoOrginSubType = '';
        
        helper.loadSubType(component, event, helper);
        //US1875495

        // US1753077 - Pilot Enhancement - Save Case - Validations and Additional Functionality: Kavinda - END
        component.set('v.cseSubtype', '');
        let selectedValue = component.get("v.cseType");
        if (selectedValue === 'Issue Resolved') {
            caseVal.Status = 'Closed';
            caseVal.AddInfoOrginSubType = '';
        }

        // US2091974 - Sanka - Case Creation
        if (selectedValue == 'Issue Routed') {
            caseVal.Status = 'Closed';
            caseVal.AddInfoOrginSubType = '';
        }

        // US2509591
        if (component.get("v.showAutodocWarningMessage")) {
            if(selectedValue == "System Unavailable") {
                component.set('v.isButtonDisabled', false);   
            } else {
                component.set('v.isButtonDisabled', true);  
            }
        } else {
            component.set('v.isButtonDisabled', false);
        }
        component.set("v.showResolvedMessage", false);
        component.set("v.showUnResolvedMessage", false);
        // End

        //US3071655 - Sravan - Start
        component.set("v.showRoutingAvailabilityWarningMessage", false);
        //US3071655 - Sravan - End
        component.set("v.showRoutingMessageforFacetsANDORSCases", false);
        //US2951245 - Sravan - Start
        component.set("v.showRoutingOnlyNotForMedicaid", false);
        //US2951245 - Sravan - End
        caseVal.AddInfoOrginType = selectedValue;
        component.set('v.caseWrapper', caseVal);
    },
    onsubtypeChange: function (component, event, helper) {
        //US1875495
        let caseVal = component.get('v.caseWrapper');
        let selectedValue = component.get("v.cseSubtype");

        if (selectedValue != '--None--' && component.get('v.Topic') != undefined && component.get('v.Topic') != null && component.get('v.Topic') == 'View Member Eligibility') {
            var SubmitId = component.find("SubmitId");
            SubmitId.focus();
        }

        if (selectedValue !== '--None--') {
            caseVal.AddInfoOrginSubType = selectedValue;
            component.set('v.caseWrapper', caseVal);
        }
        
        if (component.get("v.showAutodocWarningMessage")) {
            if(component.get('v.cseType') == "System Unavailable") {
                component.set('v.isButtonDisabled', false);   
            } else {
                component.set('v.isButtonDisabled', true);  
            }
        } else {
            component.set('v.isButtonDisabled', false);
        }

        // US3125332 - Thanish - 6th Jan 2021
        // Commenting as part of Save case validations - Nikhil
        /*if (component.get("v.showAutodocWarningMessage") && caseVal.AddInfoTopic == "View PCP Referrals") {
            if ((caseVal.AddInfoOrginType == "Issue Resolved" && caseVal.AddInfoOrginSubType == "Referral Not on File") || (caseVal.AddInfoOrginType == "Research" && caseVal.AddInfoOrginSubType == "Task Needed") || (caseVal.AddInfoOrginType == "System Unavailable")) {
                component.set('v.isButtonDisabled', false);
            } else {
                component.set('v.isButtonDisabled', true);
            }
        }
        if (component.get("v.showAutodocWarningMessage") && caseVal.AddInfoTopic == "View Claims") {
            if ((caseVal.AddInfoOrginType == "Issue Resolved" && caseVal.AddInfoOrginSubType == "Claim Not on File") || (caseVal.AddInfoOrginType == "Research" && caseVal.AddInfoOrginSubType == "Task Needed") || (caseVal.AddInfoOrginType == "System Unavailable")) {
                component.set('v.isButtonDisabled', false);
            } else {
                component.set('v.isButtonDisabled', true);
            }
        }*/
    },
    saveCase: function (component, event, helper) {
        helper.showCaseSpinner(component);
        var caseWrapper = component.get("v.caseWrapper");
        // External Id Issue
        if (component.get("v.omitRoute")) {
            helper.getSelectedPolicies(component, event, helper);
        }
        //US3691709 - Sravan
        if(caseWrapper.AddInfoTopic == 'Provider Not Found'){
            helper.getSelectedPolicies(component, event, helper);
        }
        component.set('v.isButtonDisabled', true);



        //event.getSource().set("v.label", "Submitting...");
        let caseVal = component.get('v.caseWrapper');
        // Save Case Consolidation - US3424763
        // var autodocValue = _autodoc.getAutodoc(component.get("v.autodocUniqueId"));
        var autodocValue = [];
        // check if the main save case - Save Case Consolidation - US3424763
        if (component.get("v.omitRoute")) {
            // Checking autodoc related to specific topic to maintain the logics on warning messages etc.
            var autodocUniqueId = component.get("v.autodocUniqueId");
            let idToTopic = new Map([
                ['View Member Eligibility', autodocUniqueId],
                ['Member Not Found', autodocUniqueId],
                ['View Authorizations', autodocUniqueId + 'Auth'],
                ['Plan Benefits', autodocUniqueId + 'Financials'],
                ['View PCP Referrals', autodocUniqueId + 'Referrals'],
                ['Provider Lookup', autodocUniqueId + 'providerLookup'],
                ['View Claims', autodocUniqueId + 'claim'],
                ['View Payments', autodocUniqueId + 'payment'], //US3632386: View Payments - Auto Doc - Swapnil
                ['View Appeals', autodocUniqueId + 'appeals']
            ]);
            // autodocValue = _autodoc.getAllAutoDoc(component.get("v.autodocUniqueId"), false).selectedList;
            autodocValue = _autodoc.getAutodoc(idToTopic.get(caseVal.AddInfoTopic));
        } else {
            autodocValue = _autodoc.getAutodoc(component.get("v.autodocUniqueId"));
        }

        // US350783 - Case Consolidation - Validations
        var showAutodocWarning = caseVal.AddInfoTopic != 'View Member Eligibility' ? "true" : "false";

        //var autodocValue = _autodoc.getAutodoc(component.get("v.autodocUniqueId"));
        //var showAutodocWarning = "true";
        if ($A.util.isEmpty(autodocValue)) {
            showAutodocWarning = "true";
        } else {
            for (var i = 0; i < autodocValue.length; i++) {
                if (autodocValue[i].type == "card" && autodocValue[i].componentName != "Member Details" && !$A.util.isEmpty(autodocValue[i].cardData) && ($A.util.isEmpty(autodocValue[i].ignoreAutodocWarningMsg) || !autodocValue[i].ignoreAutodocWarningMsg)) { // DE373558 - Thanish - 14th Oct 2020
                    showAutodocWarning = "false";
                } else if (autodocValue[i].type == "table" && autodocValue[i].componentName != "Policies" && !$A.util.isEmpty(autodocValue[i].selectedRows) && ($A.util.isEmpty(autodocValue[i].ignoreAutodocWarningMsg) || !autodocValue[i].ignoreAutodocWarningMsg)) { // DE373558 - Thanish - 14th Oct 2020
                    showAutodocWarning = "false";
                } else if (autodocValue[i].type == "financials" &&
                    (autodocValue[i].Individual.tierone.Deductible.isAutodoc || autodocValue[i].Individual.tierone.OutofPocket.isAutodoc ||
                        autodocValue[i].Individual.tierone.MedicalLifeMaximum.isAutodoc || autodocValue[i].Individual.tierone.OutofPocket2.isAutodoc ||
                        autodocValue[i].Individual.tierone.CopayMax.isAutodoc || autodocValue[i].Individual.tierone.CrossApplyOutofPocket.isAutodoc ||
                        autodocValue[i].Individual.tierone.CrossApplyCopay.isAutodoc || autodocValue[i].Individual.tierone.CrossApplyCore.isAutodoc ||
                        autodocValue[i].Individual.inNetwork.Deductible.isAutodoc || autodocValue[i].Individual.inNetwork.OutofPocket.isAutodoc ||
                        autodocValue[i].Individual.inNetwork.MedicalLifeMaximum.isAutodoc || autodocValue[i].Individual.inNetwork.OutofPocket2.isAutodoc ||
                        autodocValue[i].Individual.inNetwork.CopayMax.isAutodoc || autodocValue[i].Individual.inNetwork.CombinedDeductible.isAutodoc ||
                        autodocValue[i].Individual.inNetwork.CombinedOOP.isAutodoc || autodocValue[i].Individual.inNetwork.CrossApplyOutofPocket.isAutodoc ||
                        autodocValue[i].Individual.inNetwork.CrossApplyCopay.isAutodoc || autodocValue[i].Individual.inNetwork.CrossApplyCore.isAutodoc ||
                        autodocValue[i].Individual.outofNetwork.Deductible.isAutodoc || autodocValue[i].Individual.outofNetwork.OutofPocket.isAutodoc ||
                        autodocValue[i].Individual.outofNetwork.MedicalLifeMaximum.isAutodoc || autodocValue[i].Individual.outofNetwork.OutofPocket2.isAutodoc ||
                        autodocValue[i].Individual.outofNetwork.CopayMax.isAutodoc || autodocValue[i].Individual.outofNetwork.CombinedDeductible.isAutodoc ||
                        autodocValue[i].Individual.outofNetwork.CombinedOOP.isAutodoc || autodocValue[i].Individual.outofNetwork.CrossApplyOutofPocket.isAutodoc ||
                        autodocValue[i].Individual.outofNetwork.CrossApplyCopay.isAutodoc || autodocValue[i].Individual.outofNetwork.CrossApplyCore.isAutodoc ||
                        autodocValue[i].Family.tierone.Deductible.isAutodoc || autodocValue[i].Family.tierone.OutofPocket.isAutodoc ||
                        autodocValue[i].Family.tierone.MedicalLifeMaximum.isAutodoc || autodocValue[i].Family.tierone.OutofPocket2.isAutodoc ||
                        autodocValue[i].Family.tierone.CopayMax.isAutodoc || autodocValue[i].Family.tierone.CrossApplyOutofPocket.isAutodoc ||
                        autodocValue[i].Family.tierone.CrossApplyCopay.isAutodoc || autodocValue[i].Family.tierone.CrossApplyCore.isAutodoc ||
                        autodocValue[i].Family.inNetwork.Deductible.isAutodoc || autodocValue[i].Family.inNetwork.OutofPocket.isAutodoc ||
                        autodocValue[i].Family.inNetwork.MedicalLifeMaximum.isAutodoc || autodocValue[i].Family.inNetwork.OutofPocket2.isAutodoc ||
                        autodocValue[i].Family.inNetwork.CopayMax.isAutodoc || autodocValue[i].Family.inNetwork.CombinedDeductible.isAutodoc ||
                        autodocValue[i].Family.inNetwork.CombinedOOP.isAutodoc || autodocValue[i].Family.inNetwork.CrossApplyOutofPocket.isAutodoc ||
                        autodocValue[i].Family.inNetwork.CrossApplyCopay.isAutodoc || autodocValue[i].Family.inNetwork.CrossApplyCore.isAutodoc ||
                        autodocValue[i].Family.outofNetwork.Deductible.isAutodoc || autodocValue[i].Family.outofNetwork.OutofPocket.isAutodoc ||
                        autodocValue[i].Family.outofNetwork.MedicalLifeMaximum.isAutodoc || autodocValue[i].Family.outofNetwork.OutofPocket2.isAutodoc ||
                        autodocValue[i].Family.outofNetwork.CopayMax.isAutodoc || autodocValue[i].Family.outofNetwork.CombinedDeductible.isAutodoc ||
                        autodocValue[i].Family.outofNetwork.CombinedOOP.isAutodoc || autodocValue[i].Family.outofNetwork.CrossApplyOutofPocket.isAutodoc ||
                        autodocValue[i].Family.outofNetwork.CrossApplyCopay.isAutodoc || autodocValue[i].Family.outofNetwork.CrossApplyCore.isAutodoc)) {
                    showAutodocWarning = "false";
                }
            }
        }

        //let caseVal = component.get('v.caseWrapper');
        // US2452317 - Thanish - 25th Mar 2020
        if (component.get("v.enableAutodocWarningMessage") && !component.get("v.showAutodocWarningMessage")
            && showAutodocWarning == "true" && caseVal.AddInfoOrginType != "System Unavailable"
            && caseWrapper.AddInfoOrginSubType !='Claim Not on File'
            && caseWrapper.AddInfoOrginSubType !='Referral Not on File' && caseWrapper.AddInfoOrginSubType !='Payment Not Found') {
            component.set("v.showAutodocWarningMessage", true);


            helper.hideCaseSpinner(component);
            //Commenting as part of validations on save case - Nikhil
            /*if(caseVal.AddInfoTopic != "Plan Benefits") {
                // US3125332 - Thanish - 6th Jan 2021
                if(caseVal.AddInfoTopic == "View PCP Referrals"){
                    if((caseVal.AddInfoOrginType == "Issue Resolved" && caseVal.AddInfoOrginSubType == "Referral Not on File") || (caseVal.AddInfoOrginType == "Research" && caseVal.AddInfoOrginSubType == "Task Needed") || (caseVal.AddInfoOrginType == "System Unavailable")){
                        component.set('v.isButtonDisabled', false);
                    } else{
                        component.set('v.isButtonDisabled', true);
                    }
                }else if(caseVal.AddInfoTopic == "View Claims"){
                    if((caseVal.AddInfoOrginType == "Issue Resolved" && caseVal.AddInfoOrginSubType != "Claim Not on File") || (caseVal.AddInfoOrginType == "Issue Routed")){
                        component.set('v.isButtonDisabled', true);
                    } else{
                        component.set('v.isButtonDisabled', false);
                    }
                }else {
                    component.set('v.isButtonDisabled', false);
                }
            }*/
            event.getSource().set("v.label", "Submit");
        } else {
            //US1875495
            // let caseVal = component.get('v.caseWrapper');

            //US1851066	Pilot - Case - Save Button & Case Creation Validations - 15/10/2019 - Sarma
            var isValidationSuccess = helper.fireSaveCaseValidations(component, event, helper);
            if (!isValidationSuccess) {
                helper.hideCaseSpinner(component);
                component.set('v.isButtonDisabled', false);
                event.getSource().set("v.label", "Submit");
                return;
            }

            //US3071655 - Sravan - Start
            var orsFlowPolicies = component.get("v.orsFlowPolicies");
            var facetFlowPolicies = component.get("v.facetFlowPolicies");
            var caseType = component.get("v.cseType");
            var selectedPolicyList = component.get("v.selectedPolicies");
            //US3075630
            var facetPoliceSet = [];
            var orsPoliceSet = [];
            if (!$A.util.isUndefinedOrNull(selectedPolicyList) && !$A.util.isEmpty(selectedPolicyList)) {
                for (var each in selectedPolicyList) {
                    if (!$A.util.isUndefinedOrNull(selectedPolicyList[each].selectedSourceCode) && !$A.util.isEmpty(selectedPolicyList[each].selectedSourceCode)) {
                        console.log('=I am in' + JSON.stringify(selectedPolicyList[each].selectedSourceCode));
                        var sourceCode = selectedPolicyList[each].selectedSourceCode;
                        var currentSourceCode = '';
                        if (sourceCode.includes("-")) {
                            var sourceArray = sourceCode.split("-");
                            currentSourceCode = sourceArray[0].trim();
                        } else {
                            currentSourceCode = selectedPolicyList[each].selectedSourceCode;
                        }
                        if (!$A.util.isEmpty(currentSourceCode)) {
                            if (currentSourceCode == 'AP') {
                                facetPoliceSet.push(currentSourceCode);
                            } else if (currentSourceCode == 'CO' || currentSourceCode == 'CS') {
                                orsPoliceSet.push(currentSourceCode);
                            }
                        }
                    }
                }
            }
            //US3075630
            var caseTopic = component.get("v.Topic");
            if (caseType == 'Issue Routed') {

                //US3075630
                if (orsFlowPolicies.length >= 1 && facetFlowPolicies.length >= 1 && caseTopic == 'Provider Lookup') {
                    component.set("v.enableAutodocWarningMessage", true);
                    component.set("v.showRoutingMessageforFacetsANDORSCases", true);
                    helper.hideCaseSpinner(component);
                    return;
                }

                //US2951245 - Sravan - Start
                var caseWrapper = component.get("v.caseWrapper");
                if (caseWrapper.mnfExternalId != 'Medicaid' && caseTopic == 'Member Not Found') {
                    component.set("v.enableAutodocWarningMessage", true);
                    component.set("v.showRoutingOnlyNotForMedicaid", true);
                    helper.hideCaseSpinner(component);
                    return;
                }
                //US2951245 - Sravan - End

                if (!$A.util.isUndefinedOrNull(orsFlowPolicies) && !$A.util.isEmpty(orsFlowPolicies)) {
                    if (caseTopic == 'View Member Eligibility') {
                        component.set("v.enableAutodocWarningMessage", true);
                        component.set("v.showRoutingAvailabilityWarningMessage", true);
                        helper.hideCaseSpinner(component);
                        return;
                    }
                }
            }


            if ((caseTopic == 'Provider Details' || caseTopic == 'Provider Lookup' || caseTopic == 'View Member Eligibility') && !helper.checkCaseItemStatus(component)) {
                event.getSource().set("v.label", "Submit");
                helper.hideCaseSpinner(component);
                return;
            }
            //US3071655 - Sravan - End

            helper.caseCreation(component, event, helper);

            //helper.processSelectedAutodoc(component, event, helper);
        }

        //helper.processSelectedAutodoc(component, event, helper);

    },
    /*setSelectedPolicies : function(component, event, helper) {
            //US2423120, US2517602, US2517604 Praveen
            var selectedPolicyList = event.getParam("selectedPolicyList");
            var memberMap = event.getParam("memberMap");
            console.log('selectedPolicyList TTS model'+JSON.stringify(selectedPolicyList));
            console.log('selectedPolicyList TTS model'+JSON.stringify(memberMap));
            component.set("v.selectedPolicies",selectedPolicyList);
            component.set("v.memberMap",memberMap);
    }, Commented code as part of multiple ors fix - sravan*/

    enterKeyPress: function (cmp, event, helper) {
        if (event.keyCode === 13 && cmp.get('v.Topic') != undefined && cmp.get('v.Topic') != null && cmp.get('v.Topic') == 'View Member Eligibility') {
            var keyAction = cmp.get('c.saveCase');
            $A.enqueueAction(keyAction);
        }
    },

    // Save Case Consolidation - US3424763
    routePolicyIssue: function (cmp, event, helper) {
        cmp.set("v.cseType", 'Issue Routed');
        cmp.set("v.cseSubtype", 'Network Management Request');
        helper.caseCreation(cmp, event, helper);
    },

    onTopicChange: function (cmp, event, helper) {
        var selectedTopic = cmp.get("v.cseTopic");
        cmp.set("v.Topic", selectedTopic);
        cmp.set("v.cseType", '--None--');
        cmp.set("v.cseSubtype", '--None--');
        helper.loadTtsTopics(cmp, event, helper);
        cmp.set('v.isButtonDisabled', false);
        cmp.set('v.showAutodocWarningMessage', false);
    }
})