({
    getMemberPolicyNetworkDetails: function (cmp, transactionId, indexNo, helper) {
        cmp.set('v.loaded', true);
        var action = cmp.get("c.getMemberPolicyNetworkInfo");
        action.setParams({
            transactionId: transactionId
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                //US1888880
                //helper.hidePolicySpinner(cmp);
                var responseData = response.getReturnValue();
                var tableData = cmp.get("v.data");
                if (responseData.statusCode == 200) {
                    if (responseData.networkStatus == "In-Network") {
                        tableData[indexNo].providerStatusIcon = "action:approval";
                        tableData[indexNo].providerStatusIconVariant = "";
                        tableData[indexNo].providerStatus = "INN";
                    } else if (responseData.networkStatus == "Out-of-Network") {
                        tableData[indexNo].providerStatusIcon = "utility:warning";
                        tableData[indexNo].providerStatusIconVariant = "warning";
                        tableData[indexNo].providerStatus = "OON";
                    }
                } else if (responseData.statusCode == 400) {
                    tableData[indexNo].providerStatusIcon = "utility:stop";
                    tableData[indexNo].providerStatusIconVariant = "error";
                    tableData[indexNo].providerStatus = null;
                } else {
                    //helper.fireToastMessage("error!", responseData.statusMessage, "error", "dismissible", "10000");
                    tableData[indexNo].providerStatusIcon = "utility:stop";
                    tableData[indexNo].providerStatusIconVariant = "error";
                    tableData[indexNo].providerStatus = null;
                }
                cmp.set("v.data", tableData);
                helper.fireNetworkStatusEvent(cmp,indexNo);
            } else if (state === "ERROR") {
                //US1888880
                helper.hidePolicySpinner(cmp);
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " +
                                    errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }           
            
            //US1974546 - Coverage Level Integration 
            //Sanka Dharmasena - 28/08/2019
            //helper.getCoverageLevel(cmp, transactionId, indexNo, helper);
            
            cmp.set('v.loaded', false);
        });
        $A.enqueueAction(action);
        
        //Fire financial event
    },
    
    getMemberPolicyDetails: function (cmp, transactionId, indexNo, helper) {
        // US2579637
        helper.fireNetworkStatusEvent(cmp,indexNo);
        helper.getExtendedData(cmp, transactionId, indexNo, helper);
    },
    //US2644766 - PCP Indicator UI and  Implementation - Durga [08/06/2020]
    getPCPRedirectURL : function(cmp,event,helper){
        var PCPRedirectURLAction = cmp.get("c.getPCPURL");
        PCPRedirectURLAction.setCallback( this, function( response ) {
            let state = response.getState();
            if( state === "SUCCESS") {
                window.open(response.getReturnValue(), '_blank');
            } else {
                
            }
        });
        $A.enqueueAction(PCPRedirectURLAction);
        
    },
    
    // TECH - US2692129 - Edited Signature
    getPolicyDataIntoAlert: function (component, event, helper, selectedGroup) {
        var providerTabId = component.get("v.providerTabId");
        var memberTabId = component.get("v.memberTabId");
        // var selectedGroup = event.currentTarget.getAttribute("data-group");
        var clickEvent = component.getEvent("SAE_PolicyClickforAlerts");
        clickEvent.setParams({
            "data_group": selectedGroup,
            "providerTabId": providerTabId,
            "memberTabId": memberTabId
        });
        clickEvent.fire();
    },
    
    sortData: function (cmp, fieldName, sortDirection) {
        var data = cmp.get("v.data");
        var reverse = sortDirection !== 'asc';
        data.sort(this.sortBy(fieldName, reverse))
        cmp.set("v.data", data);
    },
    sortBy: function (field, reverse, primer) {
        var key = primer ?
            function (x) {
                return primer(x[field])
            } :
        function (x) {
            return x[field]
        };
        reverse = !reverse ? 1 : -1;
        return function (a, b) {
            return a = key(a), b = key(b), reverse * ((a > b) - (b > a));
        }
    },
    executeFilter: function (component, event, helper) {
        
        // DE310436
        helper.showPolicySpinner(component);
        
        var filterIsActive = component.get('v.filterIsActive');
        var filterIsMedicalOnly = component.get('v.filterIsMedicalOnly');
        var policyList = component.get('v.dataORG');
        var newData = [];
        
        if (filterIsActive && !filterIsMedicalOnly) {
            
            for (var k in policyList) {
                if (policyList.hasOwnProperty(k)) {
                    var planStatus = policyList[k].planStatus;
                    var IsMedicalClaim = policyList[k].IsMedicalPolicy;
                    var IsActivePolicy = (planStatus != "false");
                    if (IsActivePolicy) {
                        newData.push(policyList[k]);
                    }
                }
            }
        } else if (!filterIsActive && filterIsMedicalOnly) {
            
            for (var k in policyList) {
                if (policyList.hasOwnProperty(k)) {
                    var planStatus = policyList[k].planStatus;
                    var IsMedicalClaim = policyList[k].IsMedicalPolicy;
                    var IsActivePolicy = (planStatus == "true");
                    if (IsMedicalClaim) {
                        newData.push(policyList[k]);
                    }
                }
            }
        } else if (filterIsActive && filterIsMedicalOnly) {
            for (var k in policyList) {
                if (policyList.hasOwnProperty(k)) {
                    var planStatus = policyList[k].planStatus;
                    var IsMedicalClaim = policyList[k].IsMedicalPolicy;
                    var IsActivePolicy = (planStatus != "false");
                    if (IsMedicalClaim && IsActivePolicy) {
                        newData.push(policyList[k]);
                    }
                }
            }
        } else if (!filterIsActive && !filterIsMedicalOnly) {
            
            for (var k in policyList) {
                newData.push(policyList[k]);
            }
        }
        
        component.set('v.data', newData);
        
        // DE310436
        // Autodoc bug fix - Thanish - 24th feb 2020
        setTimeout(function(){
            var tabKey = component.get("v.AutodocKey");
            window.lgtAutodoc.initAutodoc(tabKey);
            // DE310306 - Thanish - 13th Mar 2020 - Removed buggy code
            helper.hidePolicySpinner(component);
        }, 500);
        
        //
        var highlightedRecordAvailable = false;
        for (var i in newData) {
            if (newData[i].SelectedItem == true) {
                highlightedRecordAvailable = true;
                //US1901028 - Sarma - Member CDHP Integration
                this.fireNetworkStatusEvent(component, i);
            }
        }
        if (!highlightedRecordAvailable && newData.length > 0) {
            //US2166406 - Sanka
            this.fireNetworkStatusEvent(component, 0);
            for (var i in policyList) {
                policyList[i].SelectedItem = false;
            }
            //if (newData.length > 0) {
            newData[0].SelectedItem = true;
            /*** DE294039  Added by Avish**/
            var srnEvent = $A.get("e.c:SAE_AuthSRNCreateEvent");
            // US2536127 - Avish
            var planStatus;
            if(policyList[k].planStatus == "false"){
                planStatus = true;
            }else{
                planStatus = false;
            }
            srnEvent.setParams({
                "termedFlag": policyList[k].termedFlag,
                "policyStatus": planStatus,
                "memberTabId": component.get("v.memberTabId"),
                "policyNumber" : policyList[k].GroupNumber
            });
            srnEvent.fire();
            /*** DE294039 Ends***/
            //}
        }
        
        
    },
    
    handleCheckBoxesOnload: function(component,event,helper){
        var filterIsActive = component.get('v.filterIsActive');
        var filterIsMedicalOnly = component.get('v.filterIsMedicalOnly');
        var policyList = component.get('v.dataORG');
        var newData = [];
        var activeFound = false;
        var medicalFound = false;
        var nonmedicalFound = false;
        for(var k in policyList){
            if(policyList[k].planStatus == "true"){
                activeFound = true;
            }
            if(policyList[k].Plan.startsWith("Medical")){
                medicalFound = true;
            }
            if(policyList[k].Plan.startsWith("Non Medical")){
                nonmedicalFound = true;
            }
            break;
        }
        
        if (policyList.length == 0) {
            helper.fireToastMessage("error!", 'No policies found.', "error", "dismissible", "10000");
            var appEvent = $A.get("e.c:SAE_DisableTopicWhenNoPolicies");
            appEvent.setParams({
                "isDisableTopic": false
            });
            appEvent.fire();
        }
        
        if(!activeFound){
            helper.fireToastMessage("Warning!", 'No active policies available.', "warning", "dismissible", "10000");
            
        }
        if(!medicalFound){
            helper.fireToastMessage("Warning!", 'No medical policies available.', "warning", "dismissible", "10000");
            
        }
        component.set("v.filterIsActive", activeFound);
        if(medicalFound){
            component.set("v.filterIsMedicalOnly", medicalFound);
        }else if(nonmedicalFound){
            component.set("v.filterIsMedicalOnly", false);
        }
    },
    
    fireNetworkStatusEvent : function (component,indexNo){
        var tableData = component.get("v.data");
        var selectedpolicy = tableData[indexNo].financials;
        var providerStatus = tableData[indexNo].providerStatus;
        var eligibleDates = tableData[indexNo].eligibleDates;
        //US2584896 - Snapshot - Financials - As of Date E&I - Sravan - Start
        var policyStatus = tableData[indexNo].planStatus;
        component.set("v.policyStatus",policyStatus);
        //US2584896 - Snapshot - Financials - As of Date E&I - Sravan - End


        //
        var networkEvent = component.getEvent("networkStatus");
        networkEvent.setParams({
            "selectedPolicy" : selectedpolicy,
            "networkStatus" : providerStatus,
            "eligibleDates" : eligibleDates
        });
        
        networkEvent.fire();
    },//US1888880 - Malinda : Spinner-show method
    showPolicySpinner: function (component) {
        var spinner = component.find("policy-spinner");
        $A.util.removeClass(spinner, "slds-hide");
        $A.util.addClass(spinner, "slds-show");
    },//US1888880 - Malinda : Spinner-hide method
    hidePolicySpinner: function (component) {
        var spinner = component.find("policy-spinner");
        $A.util.removeClass(spinner, "slds-show");
        $A.util.addClass(spinner, "slds-hide");
        //return null;
    },
    fireToast: function (message) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "Error!",
            "message": message,
            "message": message,
            "type": "error",
            "mode": "sticky"
        });
        toastEvent.fire();
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
    //US1761826 - UHC/Optum Exclusion UI - START
    fetchOptumExclusionGroupIds : function(component, event, helper) {
        
        let action = component.get("c.getOptumExlusions");
        action.setCallback( this, function( response ) {
            let state = response.getState();
            if( state === "SUCCESS") {
                
                component.set( "v.lstExlusions", response.getReturnValue() );
            } else {
                
            }
        });
        $A.enqueueAction(action);
    },
    fireShowComponentEvent:function(component, event, helper, visible) {
        let shoHideEvent = $A.get("e.c:SAE_HideComponentsForExclusions");
        shoHideEvent.setParams({
            "hide_component": visible,
            "originPage" : component.get('v.AutodocPageFeature')   // UHG Access Uniquness fix
        });
        shoHideEvent.fire();
        //helper.hidePolicySpinner(component);
    },
    
    getExtendedData: function (cmp, transactionId, indexNo, helper) {
        
        var action = cmp.get("c.getExtendedResult");
        action.setParams({
            transactionId: transactionId
        });
        action.setCallback(this, function (response) {
            if (response.getState() == 'SUCCESS') {
                
                var result = response.getReturnValue();
                
                var tableData = cmp.get("v.data");
                var extendedData;
                
                if(result.statusCode == 200){
                    helper.hidePolicySpinner(cmp);
                    //Optimization
                    if (!$A.util.isUndefinedOrNull(result.extendedResultObject)) {
                        
                        extendedData = result.extendedResultObject;
                        if (!$A.util.isUndefinedOrNull(extendedData.planLevelBenefitsRes)) {
                            cmp.set('v.planLevelBenefitsRes', extendedData.planLevelBenefitsRes);
                        }
                        
                        if (!$A.util.isUndefinedOrNull(extendedData.houseHoldWrapper)) {
                            cmp.set('v.extendedHouseholdData', extendedData.houseHoldWrapper);
                        }
                        if (!$A.util.isUndefinedOrNull(extendedData.cobWrapper)) {
                            cmp.set('v.extendedCOBData', extendedData.cobWrapper);
                        }
                        if (!$A.util.isUndefinedOrNull(extendedData.policyResultWrapper)) {
                            
                            var policyDetails = extendedData.policyResultWrapper;
                            
                            if ( !$A.util.isUndefinedOrNull(policyDetails.resultWrapper) && !$A.util.isUndefinedOrNull(policyDetails.resultWrapper.policyRes)) {
                                extendedData.policyResultWrapper.resultWrapper.policyRes.transactionId = transactionId; //US2669563-MVP- Member Snapshot - Policy Details - Populate Payer ID-Durga
                                tableData[indexNo].CoverageType = policyDetails.resultWrapper.policyRes.coverageLevel;
                                tableData[indexNo].sourceCode = policyDetails.resultWrapper.policyRes.sourceCode;
                                tableData[indexNo].sourceCodeDetail = policyDetails.resultWrapper.policyRes.sourceCodeDetail;
                                tableData[indexNo].relationshipCode = policyDetails.resultWrapper.policyRes.relationshipCode;
                                var relationshipCode;
                                //US2584896 - Snapshot - Financials - As of Date E&I - Sravan - Start
                                cmp.set("v.highlightedPolicySourceCode",policyDetails.resultWrapper.policyRes.sourceCode);
                                cmp.set("v.isSourceCodeChanged",!cmp.get("v.isSourceCodeChanged"));
                                //US2584896 - Snapshot - Financials - As of Date E&I - Sravan - End

                                //US2423120, US2517602, US2517604 Added by Praveen start
                                var selectedPolicyList = cmp.get("v.selectedPolicyLst");
                                for (var i in selectedPolicyList) {
                                    if (selectedPolicyList[i].selectedTranId == transactionId) {
                                        selectedPolicyList[i].selectedSourceCode = policyDetails.resultWrapper.policyRes.sourceCode;
                                        selectedPolicyList[i].selectedRelationshipCode = policyDetails.resultWrapper.policyRes.relationshipCode;
                                        relationshipCode = selectedPolicyList[i].selectedRelationshipCode;
                                    }
                                    
                                    //Setting Case wrapper relationshipCode
                                    var caseWrapper = cmp.get('v.caseWrapper');
                                    caseWrapper.createORSCase = policyDetails.resultWrapper.policyRes.sourceCode != 'AP' ? true : false;
                                    caseWrapper.policyNumber = policyDetails.resultWrapper.policyRes.policyNumber;
                                    caseWrapper.dependentNumber = policyDetails.resultWrapper.policyRes.dependentSequenceNumber;//US2784325 - TECH: Case Details - Caller ANI/Provider Add'l Elements Mapped to ORS - Durga
                                    cmp.set("v.higlightGrpNumber",policyDetails.resultWrapper.policyRes.policyNumber);
                                    caseWrapper.RelationshipCode = relationshipCode;
                                    cmp.set('v.caseWrapper', caseWrapper);
                                }
                                //US2423120, US2517602, US2517604 Added by Praveen End
                                
                                if (!$A.util.isUndefinedOrNull(policyDetails.resultWrapper.policyRes.groupNumber) && !$A.util.isUndefinedOrNull(tableData[indexNo].GroupNumber)) {
                                    let wordTocheck = 'Unable to determine';
                                    if ($A.util.isEmpty(tableData[indexNo].GroupNumber) || tableData[indexNo].GroupNumber.includes(wordTocheck)) {
                                        tableData[indexNo].GroupNumber = policyDetails.resultWrapper.policyRes.groupNumber;
                                    }
                                }
                                cmp.set("v.data", tableData);
                                let hasAccess = cmp.get("v.uhgAccess");
                                let lstExclusions = cmp.get("v.lstExlusions");
                                let mapExclusions = new Map();
                                for(let i=0; lstExclusions.length > i; i++) {
                                    mapExclusions.set(lstExclusions[i].MasterLabel,lstExclusions[i].MasterLabel);
                                }
                                
                                var isRestrictedPolicy = false;
                                var isOffshoreUser = policyDetails.resultWrapper.policyRes.isOffShoreUser;
                                var originatorType = cmp.get("v.originatorType");
                                var caseWrapper = cmp.get('v.caseWrapper');
                                //Fix for offshore Restriction
                                caseWrapper.onShoreRestriction = 'No';

                                if(mapExclusions.has(tableData[indexNo].GroupNumber) && !hasAccess) {
                                    helper.fireShowComponentEvent(cmp, event, helper, false);
                                }
                                
                                // US2678265 MVP - Offshore Restriction - Implementation for Member &  Provider Interaction - Starts
                                else if(!$A.util.isUndefinedOrNull(policyDetails.resultWrapper.policyRes.policyRestrictionLevelList)){
                                    
                                    
                                    var policyRestrictionLevelList = policyDetails.resultWrapper.policyRes.policyRestrictionLevelList;
                                    if(policyRestrictionLevelList.length > 0){
                                        for(var i=0 ; i < policyRestrictionLevelList.length; i++){
                                            if(policyRestrictionLevelList[i] == 'L7'){
                                                isRestrictedPolicy = true;
                                                caseWrapper.onShoreRestriction = 'Yes';
                                                break;
                                            } else if(policyRestrictionLevelList[i] == 'L5' && (originatorType == 'Provider' || originatorType == 'Other')){
                                                isRestrictedPolicy = true;
                                                caseWrapper.onShoreRestriction = 'Yes';
                                                break;
                                            } else if(policyRestrictionLevelList[i] == 'L3' && (originatorType == 'Member')){
                                                isRestrictedPolicy = true;
                                                caseWrapper.onShoreRestriction = 'Yes';
                                                break;
                                            }
                                        }
                                    }
                                    
                                    cmp.set('v.caseWrapper', caseWrapper);
                                    
                                    if (isRestrictedPolicy && isOffshoreUser ){
                                        
                                        helper.fireShowComponentEvent(cmp, event, helper, false);
                                        setTimeout(function(){
                                            var tabKey = cmp.get("v.AutodocKey");
                                            window.lgtAutodoc.initAutodoc(tabKey);
                                        },100);
                                    } else {
                                        
                                        helper.fireShowComponentEvent(cmp, event, helper, true);
                                    }
                                }
                                // US2678265 - End
                            }
                            // US2678265 Sarma - 7/7/2020
                            // changing policy details assiging place to resolve autodoc initialization issue during policy switch
                            // US2330408  - Avish
                            var interactionOverviewData = _setAndGetSessionValues.getInteractionDetails(cmp.get("v.interactionOverviewTabId"));
                            
                            var flowDetails = interactionOverviewData.flowDetails;
                            var providerDetails = interactionOverviewData.providerDetails;
                            var memberDetails = interactionOverviewData.membersData;
                            var extendedDetails = extendedData.policyResultWrapper.resultWrapper;
                            
                            for(var i = 0; i < memberDetails.length; i++){
                                if(memberDetails[i].memberId == cmp.get("v.memberId")){
                                    var tableDataList = cmp.get("v.data");
                                    for(var j = 0; j < tableDataList.length; j++){
                                        if(tableDataList[j].SelectedItem){
                                            memberDetails[i].policyName = tableDataList[j].Policy;
                                            memberDetails[i].sourceCode = tableDataList[j].sourceCode;
                                            providerDetails.status = tableDataList[j].providerStatus;
                                            _setAndGetSessionValues.updateProviderDetails(cmp.get("v.interactionOverviewTabId"), providerDetails);
                                            _setAndGetSessionValues.updateMemberDetails(cmp.get("v.interactionOverviewTabId"), memberDetails[i]);
                                            break;
                                        }
                                    }
                                    memberDetails[i].DIV = extendedDetails.policyRes.cosmosDivision;
                                    memberDetails[i].groupPanelNumber = extendedDetails.policyRes.groupPanelNumber;
                                    if(!$A.util.isUndefinedOrNull(extendedDetails.policyRes.groupNumber) && !$A.util.isEmpty(extendedDetails.policyRes.groupNumber)){
                                        if(extendedDetails.policyRes.groupNumber.charAt(0) == 0){
                                            memberDetails[i].groupNumber  = extendedDetails.policyRes.groupNumber.slice(1,extendedDetails.policyRes.groupNumber.length);                                            
                                        }else{
                                            memberDetails[i].groupNumber  = extendedDetails.policyRes.groupNumber;
                                        }
                                        _setAndGetSessionValues.updateMemberDetails(cmp.get("v.interactionOverviewTabId"), memberDetails[i]);
                                        break;
                                    }									                                    
                                }
                            }
                            
                            // US2330408  - Ends
                            cmp.set('v.policyDetails', extendedData.policyResultWrapper);
                        }
                    }
                } else {
                    helper.hidePolicySpinner(cmp);
                    // US1964371: Error Code Handling - Extended Coverage Attribute Service - KAVINDA
                    if(!$A.util.isUndefinedOrNull(result.extendedData)){
                        if(!$A.util.isUndefinedOrNull(result.extendedData.faultCode) && result.extendedData.faultCode != '' && !$A.util.isUndefinedOrNull(result.message) && result.message != ''){
                            this.fireToastMessage("Error!", (result.message + '('+result.extendedData.faultCode+')'), "error", "dismissible", "10000");
                        } else{
                            this.fireToastMessage("Error!", (result.message), "error", "dismissible", "10000");
                        }
                    } else{
                        this.fireToastMessage("Error!", (result.message), "error", "dismissible", "10000");
                    }
                    
                }
                if(cmp.get("v.data")[indexNo].PlanSubString.includes('Non Medical')) {
                    cmp.set("v.isSaveCaseDisabled", true);
                } else {
                    cmp.set("v.isSaveCaseDisabled", false);
                }
                //optimization ends
            }
            
        });
        $A.enqueueAction(action);
    },
    
    // US1753077 - Pilot Enhancement - Save Case - Validations and Additional Functionality: Kavinda
    setPoliciesCountAndData: function (cmp) {
        var caseWrapper = cmp.get('v.caseWrapper');
        caseWrapper.PolicyCount = (cmp.get('v.data') == undefined ? 0 : cmp.get('v.data').length);
        caseWrapper.CaseCreationFrom = 'Member_Snapshot_Policies';
        cmp.set('v.caseWrapper', caseWrapper);
    },
    
    // TECH - US2692129
    handleHighlightHelper: function (component, event, helper) {
        // US2718107 - Thanish - 8th Jul 2020
        component.set("v.showCOBHistory", false);
        component.set("v.isShowCobHistory", false);
        component.set("v.showPCPHistory", false);
        
        helper.showPolicySpinner(component);
        
        var selectedPolicyAttributes = component.get("v.selectedPolicyAttributes");
        
        //future : call getPolicyDetails apex controller method to do the job
        var selectedPlan = selectedPolicyAttributes.selectedPlan;
        var selectedGroup = selectedPolicyAttributes.selectedGroup;
        var selectedsourcecode = selectedPolicyAttributes.selectedsourcecode;
        var selectedmemId = selectedPolicyAttributes.selectedmemId;
        var selectedTranId = selectedPolicyAttributes.selectedTranId;
        var endDate = selectedPolicyAttributes.endDate;
        
        var selectedPolicyList = component.get("v.selectedPolicyLst");
        
        //Setting Case wrapper group id
        var caseWrapper = component.get('v.caseWrapper');
        caseWrapper.SubjectGroupId = selectedGroup;
        component.set('v.caseWrapper', caseWrapper);
        
        var trid = new Set();
        for (var i in selectedPolicyList) {
            trid.add(selectedPolicyList[i].selectedTranId);
        }
        
        //US2554307
        component.set("v.memberIdAuthDtl",selectedmemId);
        component.set("v.groupIdAuthDtl",selectedGroup);
        
        //US2423120, US2517602, US2517604 Added by Praveen start
        if (trid.has(selectedTranId)) {
            console.log('selectedGroup set has' + selectedGroup);
        } else {
            let selectedPolicy = {};
            selectedPolicy.selectedGroup = selectedGroup;
            selectedPolicy.selectedSourceCode = selectedsourcecode;
            selectedPolicy.selectedPlan = selectedPlan;
            selectedPolicy.selectedTranId = selectedTranId;
            selectedPolicy.endDate = endDate;
            selectedPolicy.memberId = selectedmemId;
            selectedPolicyList.push(selectedPolicy);
        }
        component.set("v.selectedPolicyLst", selectedPolicyList);
        //US2423120, US2517602, US2517604 Praveen End
        
        //US2137922: Added by Ravindra
        var selectedRowIndex = selectedPolicyAttributes.selectedRowIndex;
        component.set("v.policySelectedIndex", selectedRowIndex);
        
        var tableDataList = component.get("v.data");
        for (var k in tableDataList) {
            if (k == selectedRowIndex) {
                tableDataList[k].SelectedItem = true;
            } else {
                tableDataList[k].SelectedItem = false;
            }
        }
        component.set("v.data", tableDataList);
        
        if(window.jQuery){
            setTimeout(function(){
                var contextVar = '#' + component.get('v.AutodocKey');
                var tableId = '#'+component.get("v.componentId");
                $(contextVar).find(tableId).find("input[type='checkbox'].autodoc").prop('checked', false);
                $(contextVar).find("tr.highlight").find("input[type='checkbox'].autodoc").prop('checked', true);
            },10);
        }
        
        //US1761826 - UHC/Optum Exclusion UI - START
        let lstExclusions = component.get("v.lstExlusions");
        let mapExclusions = new Map();
        for (let i = 0; lstExclusions.length > i; i++) {
            mapExclusions.set(lstExclusions[i].MasterLabel, lstExclusions[i].MasterLabel);
        }
        
        let hasAccess = component.get("v.uhgAccess");
        
        // if (mapExclusions.has(selectedGroup) && !hasAccess) {
        //     helper.fireShowComponentEvent(component, event, helper, false);
        // } else {
        //     helper.fireShowComponentEvent(component, event, helper, true);
        //     //alert('providerStatus -> ' + tableDataList[selectedRowIndex].providerStatus);
        //     if (tableDataList[selectedRowIndex].providerStatus == "") {
        //         helper.getMemberPolicyNetworkDetails(component, tableDataList[selectedRowIndex].transactionId, selectedRowIndex, helper);
        //         //alert(1);
        //         helper.getMemberPolicyDetails(component, tableDataList[selectedRowIndex].transactionId, selectedRowIndex, helper);
        //     } else {
        //         //Added
        //         helper.getMemberPolicyDetails(component, tableDataList[selectedRowIndex].transactionId, selectedRowIndex, helper);
        //         helper.fireNetworkStatusEvent(component, selectedRowIndex);
        //     }
        // }
        //US1761826 - UHC/Optum Exclusion UI - END
        
        // New Change
        var providerDetails = component.get("v.providerDetails");
        if(tableDataList[selectedRowIndex].SelectedItem && !$A.util.isEmpty(tableDataList[selectedRowIndex].GroupNumber ) && tableDataList[selectedRowIndex].GroupNumber  != 'Unable to determine'){
            if (mapExclusions.has(tableDataList[selectedRowIndex].GroupNumber	) && !hasAccess) {
                if (!$A.util.isEmpty(providerDetails) && !$A.util.isEmpty(providerDetails.isNoProviderToSearch) && !providerDetails.isNoProviderToSearch) {
                    helper.getMemberPolicyNetworkDetails(component, tableDataList[selectedRowIndex].transactionId, selectedRowIndex, helper);
                }
                helper.getMemberPolicyDetails(component, tableDataList[selectedRowIndex].transactionId, selectedRowIndex , helper);
            }else{
                if (!$A.util.isEmpty(providerDetails) && !$A.util.isEmpty(providerDetails.isNoProviderToSearch) && !providerDetails.isNoProviderToSearch) {
                    helper.getMemberPolicyNetworkDetails(component, tableDataList[selectedRowIndex].transactionId, selectedRowIndex, helper);
                }
                helper.getMemberPolicyDetails(component, tableDataList[selectedRowIndex].transactionId, selectedRowIndex , helper);
            }
        }else if (tableDataList[selectedRowIndex].providerStatus == "") {
            if (!$A.util.isEmpty(providerDetails) && !$A.util.isEmpty(providerDetails.isNoProviderToSearch) && !providerDetails.isNoProviderToSearch) {
                helper.getMemberPolicyNetworkDetails(component, tableDataList[selectedRowIndex].transactionId, selectedRowIndex, helper);
            }
            helper.fireShowComponentEvent(component, event, helper, true);
            helper.getMemberPolicyDetails(component, tableDataList[selectedRowIndex].transactionId, selectedRowIndex, helper);
        } else {
            helper.getMemberPolicyDetails(component, tableDataList[selectedRowIndex].transactionId, selectedRowIndex, helper);
            helper.fireNetworkStatusEvent(component, selectedRowIndex);
        }
        // End
        
        // Optimization
        var selectedPolicyContactAddress = selectedPolicyAttributes.selectedPolicyContactAddress;
        var city = selectedPolicyAttributes.city;
        var state = selectedPolicyAttributes.state;
        var zip = selectedPolicyAttributes.zip;
        component.set('v.contactAddress', selectedPolicyContactAddress);
        component.set('v.city', city);
        component.set('v.state', state);
        component.set('v.zip', zip);
        helper.getPolicyDataIntoAlert(component, event, helper, selectedGroup);
        
        component.set('v.initialClick', false);
        
        //US2061732 - Added by Avish
        for (var k in tableDataList) {
            var srnEvent = $A.get("e.c:SAE_AuthSRNCreateEvent");
            if (tableDataList[k].SelectedItem) {
                // US2536127 - Avish
                var planStatus;
                if (tableDataList[k].planStatus == 'false') {
                    planStatus = true;
                } else {
                    planStatus = false;
                }
                srnEvent.setParams({
                    "termedFlag": tableDataList[k].termedFlag,
                    "policyStatus": planStatus,
                    "memberTabId": component.get("v.memberTabId"),
                    "policyNumber": tableDataList[k].GroupNumber
                });
                srnEvent.fire();
                break;
            }
        }
    },
    //US2718111: View Authorizations - Switching Policies and Auto Doc - Error Message Need to Save a Case
    closeAuthDetailSubTabs: function (component, event, helper) {
        console.log("memberTabId policy ===> "+component.get('v.memberTabId'));
        var appEvent = $A.get("e.c:ACET_PolicySwithchAuthDetailsClose");
        appEvent.setParams({ "memberTabId" : component.get('v.memberTabId') });
        appEvent.fire();
    },
    
    // Thanish - 16th Jul 220 - DE347218
    refreshHouseholdAutodoc : function(component, event){
        var householdCMP = document.getElementById(component.get("v.AutodocKey") + "household");
        if(householdCMP != null && householdCMP != undefined){
            var autodocCheckboxes = householdCMP.getElementsByTagName("input");
            var box;
            for(box of autodocCheckboxes){
                box.checked = false;
            }
        }
    }
})