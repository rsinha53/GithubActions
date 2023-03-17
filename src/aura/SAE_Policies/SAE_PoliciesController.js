({
    init: function (component, event, helper) {
        localStorage.removeItem(component.get("v.AutodocPageFeature"));
        component.set('v.AutodocPageFeatureMemberDtl', component.get('v.AutodocPageFeature'));
        component.set("v.AutodocKeyMemberDtl", component.get("v.AutodocKey"));
    },
    
    openCommentsBox : function (component, event, helper) {
        component.set("v.isCommentsBox",true);
        component.set("v.disableCommentButton",true);
    },
    
    togglePopup : function(cmp, event) {
        let showPopup = event.currentTarget.getAttribute("data-popupId");
        cmp.find(showPopup).toggleVisibility();
    },
    
    handleKeyup : function(cmp) {
        var inputCmp = cmp.find("commentsBoxId");
        var value = inputCmp.get("v.value");
        var max = 2000;
        var remaining = max - value.length;
        cmp.set('v.charsRemaining', remaining);
        var errorMessage = 'Error!  You have reached the maximum character limit.  Add additional comments in Case Details as a new case comment.';
        if (value.length >= 2000) {
            inputCmp.setCustomValidity(errorMessage);
            inputCmp.reportValidity();
        } else {
            inputCmp.setCustomValidity('');
            inputCmp.reportValidity();
        }
    },
    
    //RemoveExisting AutoDoc Preview
    removeStorage: function (component, event, helper) {
        localStorage.removeItem(component.get("v.AutodocPageFeature"));
    },
    
    dataChange: function (component, event, helper) {
        var policyList = component.get("v.policyList");
        if(policyList.length == 0){
            helper.hidePolicySpinner(component);
        }else {
            
            helper.showPolicySpinner(component);
            //US1761826 - UHC/Optum Exclusion UI - START
            helper.fetchOptumExclusionGroupIds(component, event, helper);            
            var fetchData = [];
            //US2423120 - Sravan - Start
            var memberMap = {};
            //US2423120 - Sravan - End
            
            for (var k in policyList) {
                /*if (component.get("v.initialLoading") && policyList[k].highlightedPolicy) {
                    helper.getMemberPolicyNetworkDetails(component, policyList[k].transactionId, k , helper);
                }*/
                if (policyList.hasOwnProperty(k)) {
                    var srcCode = (policyList[k].SourceCode !=null) ? policyList[k].SourceCode : "--";
                    //policyList[k].planStatusIcon = 'action:approval';
                    fetchData[k] = {
                        SelectedItem : policyList[k].highlightedPolicy,
                        
                        //US:US1842940 : Start
                        Plan: policyList[k].CoverageType,
                        PlanSubString: policyList[k].CoverageType.substring(0,20),
                        GroupNumber: policyList[k].GroupNumber,
                        Type: policyList[k].CoverageType,
                        //US1974546 - Sanka
                        CoverageType: "--",
                        //Policy: 'Federal employees health benefit plan Policy',
                        //PolicySubString: 'Federal employees health benefit plan Policy'.substring(0,20),
                        Policy: policyList[k].PolicyName,
                        PolicySubString: policyList[k].PolicyName.substring(0,20),
                        //US:US1842940 : End
                        
                        IsMedicalPolicy: !policyList[k].nonMedicalPolicyBoolean,
                        endDate: policyList[k].EndDate, //US2061732 - Added by Avish
                        termedFlag: policyList[k].termedFlag, //US2061732 - Added by Avish
                        eligibleDates: policyList[k].eligibleDates,
                        planStatus: policyList[k].planStatus,
                        planStatusIcon: policyList[k].planStatus == "true" ?
                        "action:approval" : "action:close", // Change Icons according to the requirement
                        providerStatusIcon: "",
                        providerStatusIconVariant: "",
                        providerStatus: "",
                        Referral: policyList[k].referral,
                        prodStatus: policyList[k].planStatus,
                        transactionId: policyList[k].transactionId,
                        //concatAddress: policyList[k].concatAddress,
                        financials: policyList[k].financialWrapper,
                        sourceCode: srcCode,
                        sourceCodeDetail: "--",
                        //sourceCode: "--",
                        relationshipCode : policyList[k].relationshipCode,
                        //Added by Vinay for Address display in Policy Detail Card
                        addressLine1: policyList[k].addressLine1,
                        city: policyList[k].city,
                        state: policyList[k].state,
                        zip: policyList[k].zip,
                        //idCard: 'View'
                        //US2423120 - Sravan - Start
                        memberId: policyList[k].patientInfo.MemberId
                        //US2423120 - Sravan - End
                    };
                    //US2423120 - Sravan - Start
                    memberMap[policyList[k].patientInfo.MemberId] = policyList[k].patientInfo;
                    //US2423120 - Sravan - End
                    
                    //US2061732 - Added by Avish
                    if(policyList[k].highlightedPolicy){
                        //US2423120, US2517602, US2517604 Praveen start
                        var selectedPolicyList = component.get("v.selectedPolicyLst");
                        let selectedPolicy = {};
                        selectedPolicy.selectedGroup = policyList[k].GroupNumber;
                        selectedPolicy.selectedSourceCode = (policyList[k].SourceCode !=null) ? policyList[k].SourceCode : "";
                        selectedPolicy.selectedPlan = policyList[k].CoverageType.substring(0,20);
                        selectedPolicy.selectedTranId = policyList[k].transactionId;
                        selectedPolicy.endDate = policyList[k].EndDate;
                        selectedPolicy.selectedRelationshipCode = policyList[k].RelationshipCode;
                        selectedPolicy.memberId = policyList[k].patientInfo.MemberId;
                        
                        selectedPolicyList.push(selectedPolicy);
                        
                        component.set("v.selectedPolicyLst",selectedPolicyList);
                        //US2423120, US2517602, US2517604 Praveen end
                        //US2554307
                        component.set("v.memberIdAuthDtl",policyList[k].patientInfo.MemberId);
                        component.set("v.groupIdAuthDtl",policyList[k].GroupNumber);
                        
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
                    }
                    //US2061732 - Ends
                    //policyList[k].highlightedPolicy = false;
                }
            }
            //US2423120 - Sravan - Start
            component.set("v.memberMap",memberMap);
            //US2423120 - Sravan - End
            
            //component.set("v.policyList", policyList);
            component.set("v.columns", [{
                label: "Plan",
                type: "text",
                fieldName: "Plan",
                typeAttributes: {
                    border: "none"
                },
                sortable: true
            },
                                        {
                                            label: "Group #",
                                            type: "text",
                                            fieldName: "GroupNumber",
                                            sortable: true
                                        },
                                        {
                                            label: "Policy",
                                            fieldName: "Policy",
                                            type: "url",
                                            typeAttributes: {
                                                label: {
                                                    fieldName: "Policy"
                                                },
                                                color: "#006DCC"
                                            },
                                            sortable: true
                                        },
                                        {
                                            label: "Coverage Level",
                                            type: "text",
                                            fieldName: "Coverage Level",
                                            sortable: true
                                        },
                                        {
                                            label: "Eligible Dates",
                                            type: "text",
                                            initialWidth: 200,
                                            fieldName: "eligibleDates",
                                            sortable: true
                                        },
                                        {
                                            label: "Plan Status",
                                            type: "text",
                                            fieldName: "",
                                            cellAttributes: {
                                                /*iconName: 'action:approval'*/
                                                iconName: {
                                                    fieldName: "planStatusIcon"
                                                }
                                            }
                                        },
                                        {
                                            label: "Referral",
                                            type: "text",
                                            fieldName: "Referral",
                                            sortable: true
                                        },
                                        {
                                            label: "Provider Status",
                                            type: "text",
                                            fieldName: "prodStatus",
                                            cellAttributes: {
                                                /*iconName: "action:new_campaign",
                        class: "oonImageCls"*/
                                                iconName: {
                                                    fieldName: "providerStatusIcon"
                                                }
                                            },
                                            sortable: true
                                        }
                                        
                                       ]);
            component.set("v.data", fetchData);
            component.set("v.dataORG", fetchData);
            helper.handleCheckBoxesOnload(component, event, helper);
            helper.executeFilter(component, event, helper);
            //US1761826 - UHC/Optum Exclusion UI - START
            let allowCallouts = component.get("v.allowCallouts");
            //US1933887 - UHG Access
            //Sanka D. - 31.07.2019
            let hasAccess = component.get("v.uhgAccess");
            //ra
            let lstExclusions = component.get("v.lstExlusions");
            let mapExclusions = new Map();
            for(let i=0; lstExclusions.length > i; i++) {
                mapExclusions.set(lstExclusions[i].MasterLabel,lstExclusions[i].MasterLabel);
            }
            //Ends 
            var tableData = component.get("v.dataORG");
            var providerDetails = component.get("v.providerDetails");
            if (component.get("v.initialLoading") && tableData.length >= 1 && allowCallouts && hasAccess) {
                //alert('POLICY-CALLOUT-FIRED!');
                if (!$A.util.isEmpty(providerDetails) && !$A.util.isEmpty(providerDetails.isNoProviderToSearch) && !providerDetails.isNoProviderToSearch) {
                    helper.getMemberPolicyNetworkDetails(component, tableData[0].transactionId, 0 , helper);   
                }
                helper.getMemberPolicyDetails(component, tableData[0].transactionId, 0 , helper);
                component.set("v.initialLoading", false);
            }else if(tableData[0].SelectedItem && !$A.util.isEmpty(tableData[0].GroupNumber ) && tableData[0].GroupNumber  != 'Unable to determine'){
                if(mapExclusions.has(tableData[0].GroupNumber) && !hasAccess) {
                    if (!$A.util.isEmpty(providerDetails) && !$A.util.isEmpty(providerDetails.isNoProviderToSearch) && !providerDetails.isNoProviderToSearch) {
                        helper.getMemberPolicyNetworkDetails(component, tableData[0].transactionId, 0 , helper);   
                    }
                    helper.getMemberPolicyDetails(component, tableData[0].transactionId, 0 , helper);
                }else{
                    if (!$A.util.isEmpty(providerDetails) && !$A.util.isEmpty(providerDetails.isNoProviderToSearch) && !providerDetails.isNoProviderToSearch) {
                        helper.getMemberPolicyNetworkDetails(component, tableData[0].transactionId, 0 , helper);   
                    }
                    helper.getMemberPolicyDetails(component, tableData[0].transactionId, 0 , helper);
                }
            }else{
                for (var k in tableData) {                
                    if (tableData.hasOwnProperty(k) && tableData[k].SelectedItem) {
                        if (!$A.util.isEmpty(providerDetails) && !$A.util.isEmpty(providerDetails.isNoProviderToSearch) && !providerDetails.isNoProviderToSearch) {
                            helper.getMemberPolicyNetworkDetails(component, tableData[k].transactionId, k , helper);
                        }
                        helper.getMemberPolicyDetails(component, tableData[k].transactionId, k , helper);
                    }
                }
                
            }
            
            //US2138475 - Autodoc Policy Click - Sanka
            var componentId = component.get('v.AutodocPageFeature') + 'policyTable';
            component.set('v.componentId',componentId);
            
            //US2038277 - Autodoc Integration - Sanka
            setTimeout(function(){
                var tabKey = component.get("v.AutodocKey");
                window.lgtAutodoc.initAutodoc(tabKey);
            },150);
        }
        
    },
    
    handleSort: function (component, event, helper) {
        //Returns the field which has to be sorted
        var sortBy = event.getParam("fieldName");
        //returns the direction of sorting like asc or desc
        var sortDirection = event.getParam("sortDirection");
        //Set the sortBy and SortDirection attributes
        component.set("v.sortBy", sortBy);
        component.set("v.sortDirection", sortDirection);
        // call sortData helper function
        helper.sortData(component, sortBy, sortDirection);
    },
    
    //US2644766 - PCP Indicator UI and  Implementation - Durga [08/06/2020]
    navigateToValidateLink : function(component,event,helper){
        try{
            var htmlcmp = event.currentTarget;
            var selectedRowIndex = htmlcmp.getAttribute("data-indexValue");
            var element = "v.data"+"["+selectedRowIndex+"]";
            var elementValue= component.get(element);
            elementValue.isValidated = true;
            component.set(element,elementValue);
            helper.getPCPRedirectURL(component,event,helper);
        }
        catch(exception){
            console.log('=exception in NavigateToValidatelink='+exception);
        }
    },
    
    doFilter: function (component, event, helper) {
        helper.executeFilter(component, event, helper);
    },
    
    // Keep the old method for potential future code reversals
    handleHighlightOld: function (component, event, helper) {
        
        helper.showPolicySpinner(component);
        
        var htmlcmp = event.currentTarget;
        
        //future : call getPolicyDetails apex controller method to do the job
        var selectedPlan = event.currentTarget.getAttribute("data-plan");
        var selectedGroup = event.currentTarget.getAttribute("data-group");
        var selectedsourcecode = event.currentTarget.getAttribute("data-polsourcecode");
        var selectedmemId = event.currentTarget.getAttribute("data-polmemberid");
        var selectedTranId = event.currentTarget.getAttribute("data-trid");
        var endDate = event.currentTarget.getAttribute("data-endDate");
        var selectedrelationshipCode = event.currentTarget.getAttribute("data-relationshipCode");
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
        
        //for (var i in selectedPolicyList) {
        //US2423120, US2517602, US2517604 Added by Praveen start
        if (trid.has(selectedTranId)) {
            console.log('selectedGroup set has'+selectedGroup);
        }else{
            let selectedPolicy = {};
            selectedPolicy.selectedGroup = selectedGroup;
            selectedPolicy.selectedSourceCode = selectedsourcecode;
            selectedPolicy.selectedRelationshipCode = selectedrelationshipCode;
            selectedPolicy.selectedPlan = selectedPlan;
            selectedPolicy.selectedTranId = selectedTranId;
            selectedPolicy.endDate = endDate;
            selectedPolicy.memberId = selectedmemId;
            selectedPolicyList.push(selectedPolicy);
        }
        //}
        component.set("v.selectedPolicyLst",selectedPolicyList);
        //US2423120, US2517602, US2517604 Praveen End
        //US2137922: Added by Ravindra
        var selectedRowIndex = htmlcmp.getAttribute("data-index");
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
        
        //US1761826 - UHC/Optum Exclusion UI - START
        let lstExclusions = component.get("v.lstExlusions");
        let mapExclusions = new Map();
        for(let i=0; lstExclusions.length > i; i++) {
            mapExclusions.set(lstExclusions[i].MasterLabel,lstExclusions[i].MasterLabel);
        }
        
        let hasAccess = component.get("v.uhgAccess");
        
        if(tableDataList[selectedRowIndex].SelectedItem && !$A.util.isEmpty(tableDataList[selectedRowIndex].GroupNumber ) && tableDataList[selectedRowIndex].GroupNumber  != 'Unable to determine'){
            if (mapExclusions.has(tableDataList[selectedRowIndex].GroupNumber	) && !hasAccess) {
                helper.hidePolicySpinner(component);
                helper.getMemberPolicyDetails(component, tableDataList[selectedRowIndex].transactionId, selectedRowIndex , helper);
                helper.fireShowComponentEvent(component, event, helper, false);
            }else{
                helper.getMemberPolicyNetworkDetails(component, tableDataList[selectedRowIndex].transactionId, selectedRowIndex, helper);
                helper.getMemberPolicyDetails(component, tableDataList[selectedRowIndex].transactionId, selectedRowIndex , helper);
            }
        }else if (tableDataList[selectedRowIndex].providerStatus == "") {        
            
            //DE317070
            //US2634539: AutoDoc for provider lookup results Praveen CR
            var autoDocKey = component.get("v.AutodocPageFeature");
            var tabKey = component.get("v.AutodocKey");
            document.getElementById(component.get('v.componentId')).setAttribute("data-auto-doc-feature", autoDocKey);
            (document.getElementById(tabKey+tabKey) != null) ? document.getElementById(tabKey+tabKey).setAttribute("data-auto-doc-feature", autoDocKey):'';
            (document.getElementById(tabKey+tabKey+'memberdetails') != null) ? document.getElementById(tabKey+tabKey+'memberdetails').setAttribute("data-auto-doc-feature", autoDocKey):'';
            window.lgtAutodoc.saveAutodocSelections(autoDocKey); // Autodoc Metallica Code Merge - Thanish - 19th Feb 2020
            window.lgtAutodoc.clearAutodocSelections(autoDocKey); // Autodoc Metallica Code Merge - Thanish - 19th Feb 2020
            (document.getElementById(tabKey+tabKey+'memberdetails') != null) ? document.getElementById(tabKey+tabKey+'memberdetails').removeAttribute("data-auto-doc-autosave"):'';
            
            // US2271237 - View Authorizations - Update Policies in Auto Doc : Kavinda
            // US2618180
            document.getElementById(component.get('v.componentId')).setAttribute("data-auto-doc-feature", tabKey + 'Auth');
            (document.getElementById(tabKey+tabKey+'memberdetailsclone') != null) ? document.getElementById(tabKey+tabKey+'memberdetailsclone').setAttribute("data-auto-doc-feature", tabKey + 'Auth'):'';
            (document.getElementById(tabKey+tabKey+'memberdetailsclone2') != null) ? document.getElementById(tabKey+tabKey+'memberdetailsclone2').setAttribute("data-auto-doc-feature", tabKey + 'Auth'):'';
            window.lgtAutodoc.saveAutodocSelections(tabKey + 'Auth');
            (document.getElementById(tabKey+tabKey+'memberdetailsclone') != null) ? document.getElementById(tabKey+tabKey+'memberdetailsclone').removeAttribute("data-auto-doc-autosave"):'';
            // End
            
            // US2442658
            // US2618180
            document.getElementById(component.get('v.componentId')).setAttribute("data-auto-doc-feature", autoDocKey + 'Financials');
            (document.getElementById(tabKey+tabKey+'memberdetailsclone') != null) ? document.getElementById(tabKey+tabKey+'memberdetailsclone').setAttribute("data-auto-doc-feature", autoDocKey + 'Financials'):'';
            (document.getElementById(tabKey+tabKey+'memberdetailsclone2') != null) ? document.getElementById(tabKey+tabKey+'memberdetailsclone2').setAttribute("data-auto-doc-feature", autoDocKey + 'Financials'):'';
            window.lgtAutodoc.saveAutodocSelections(autoDocKey + 'Financials');
            window.lgtAutodoc.clearAutodocSelections(autoDocKey + 'Financials');
            (document.getElementById(tabKey+tabKey+'memberdetailsclone') != null) ? document.getElementById(tabKey+tabKey+'memberdetailsclone').removeAttribute("data-auto-doc-autosave"):'';
            //document.getElementById(tabKey+tabKey+'memberdetails').removeAttribute("data-auto-doc-autosave");
            
            //AutoDoc for provider lookup results Praveen CR Start
            var pagenum = component.get("v.providerPageNumber");
            
            document.getElementById(component.get('v.componentId')).setAttribute("data-auto-doc-feature", tabKey + 'providerLookupResults');
            (document.getElementById(tabKey+tabKey) != null) ? document.getElementById(tabKey+tabKey).setAttribute("data-auto-doc-feature", tabKey + 'providerLookupResults'):'';
            (document.getElementById(tabKey+tabKey+'memberdetails') != null) ? document.getElementById(tabKey+tabKey+'memberdetails').setAttribute("data-auto-doc-feature", tabKey + 'providerLookupResults'):'';
            
            if(pagenum != undefined)
                window.lgtAutodoc.storePaginationData(pagenum,tabKey);
            window.lgtAutodoc.saveAutodocSelections(tabKey + 'providerLookupResults',tabKey);
            //window.lgtAutodoc.saveProviderLookupResultsSelections(tabKey + 'providerLookupResults',tabKey);
            (document.getElementById(tabKey+tabKey+'memberdetails') != null) ? document.getElementById(tabKey+tabKey+'memberdetails').removeAttribute("data-auto-doc-autosave"):'';
            
            //AutoDoc for provider lookup results Praveen CR End
            document.getElementById(component.get('v.componentId')).setAttribute("data-auto-doc-feature", autoDocKey);
            (document.getElementById(tabKey+tabKey) != null) ? document.getElementById(tabKey+tabKey).setAttribute("data-auto-doc-feature", autoDocKey):'';
            (document.getElementById(tabKey+tabKey+'memberdetails') != null) ? document.getElementById(tabKey+tabKey+'memberdetails').setAttribute("data-auto-doc-feature", autoDocKey):'';
            var tabidprvd = component.get('v.lgt_dt_table_ID');
            console.log('lgt_dt_table_ID ::: ==> '+component.get('v.lgt_dt_table_ID'));
            var prvdtbltext='';
            if(tabidprvd != undefined || tabidprvd != null){
                prvdtbltext = document.getElementById(component.get('v.lgt_dt_table_ID')).children[0].children[0].children[0].children[0].textContent;
            }
            if(prvdtbltext==="Provider Lookup Results"){
                document.getElementById(component.get('v.lgt_dt_table_ID')).firstElementChild.remove();
            }
            helper.fireShowComponentEvent(component, event, helper, true);
            helper.getMemberPolicyDetails(component, tableDataList[selectedRowIndex].transactionId, selectedRowIndex, helper);
        } else {
            helper.fireNetworkStatusEvent(component, selectedRowIndex);
        }
        //US1761826 - UHC/Optum Exclusion UI - END
        
        // Optimization
        var selectedPolicyContactAddress = event.currentTarget.getAttribute("data-addressLine1");
        var city = event.currentTarget.getAttribute("data-city");
        var state = event.currentTarget.getAttribute("data-state");
        var zip = event.currentTarget.getAttribute("data-zip");
        component.set('v.contactAddress',selectedPolicyContactAddress);
        component.set('v.city',city);
        component.set('v.state',state);
        component.set('v.zip',zip);
        helper.getPolicyDataIntoAlert(component, event, helper);
        
        component.set('v.initialClick',false);
        
        //US2061732 - Added by Avish
        for(var k in tableDataList){
            var srnEvent = $A.get("e.c:SAE_AuthSRNCreateEvent");
            if(tableDataList[k].SelectedItem){
                // US2536127 - Avish
                var planStatus;
                if(tableDataList[k].planStatus == 'false'){
                    planStatus = true;
                }else{
                    planStatus = false;
                }
                srnEvent.setParams({
                    "termedFlag": tableDataList[k].termedFlag,
                    "policyStatus": planStatus,
                    "memberTabId": component.get("v.memberTabId"),
                    "policyNumber" : tableDataList[k].GroupNumber
                });
                srnEvent.fire();
                break;
            }
        }
        //US2061732 - Ends
        
        // DE310306 - Thanish - 13th Mar 2020 - Removed buggy code
    },
    
    //TTS Modal Case Creation : US1852201 : START
    openModal: function(component, event, helper) {
        //US2396655 - Make Autodoc available for multiple pages
        component.set("v.isAutodocForMultiplePages", false);
        // US2320729 - Thanish - 2nd Mar 2020 - to toggle auto doc multiple pages attribute in provider search results programatically
        component.set("v.providerSearchResultsADMultiplePages", false);
        
        // DE301090
        component.set('v.AutodocPageFeatureMemberDtl', component.get('v.AutodocPageFeature'));
        component.set("v.AutodocKeyMemberDtl", component.get("v.AutodocKey")); // US2543737 - Thanish - 22nd Apr 2020
        
        // Set isModalOpen attribute to true
        component.set("v.isModalOpen", true);
        
        // US1753077 - Pilot Enhancement - Save Case - Validations and Additional Functionality: Kavinda - START
        helper.setPoliciesCountAndData(component);
        // US1753077 - Pilot Enhancement - Save Case - Validations and Additional Functionali/ty: Kavinda - END
    },
    
    
    closeModal: function(component, event, helper) {
        // Set isModalOpen attribute to false
        component.set("v.isModalOpen", false);
    },
    
    // US2200492: Pilot - Member Snapshot Page Enhancement - KAVINDA
    handleSelect: function(cmp, event) {
        var selectedMenuItemValue = event.getParam("value");
        var thGroup = cmp.find("thGroup");
        var menuItem = thGroup.find(function(menuItem) {
            if (menuItem.get("v.value") === selectedMenuItemValue) {
                menuItem.set("v.checked", true);
            } else {
                menuItem.set("v.checked", false);
            }
        });
        
    },
    
    // US2200492: Pilot - Member Snapshot Page Enhancement - KAVINDA
    columnOptionsChange: function(cmp, event) {
        var selectedColumn = cmp.get('v.selectedColumn');
        var selectedOption = cmp.get('v.selectedOption');
        var columnOptions = cmp.get('v.columnOptions');
        columnOptions[selectedColumn] = selectedOption;
        cmp.set('v.columnOptions', columnOptions);
    },
    
    openModel: function (component) {
        // DE310515
        component.set('v.AutodocPageFeatureMemberDtl', component.get('v.AutodocPageFeature'));
        // US2543737 - Thanish - 22nd Apr 2020
        component.set("v.AutodocKeyMemberDtl", component.get("v.AutodocKey"));
        component.set("v.isAutodocForMultiplePages", false); //US2396655 - Make Autodoc available for multiple pages
        component.set("v.providerSearchResultsADMultiplePages", false); // US2320729 - Thanish - 2nd Mar 2020 - to toggle auto doc multiple pages attribute in provider search results programatically
        //US2076634 - HIPAA Guidelines Button - Sravan
        var isHippaInvokedInProviderSnapShot = component.get("v.isHippaInvokedInProviderSnapShot");
        if(isHippaInvokedInProviderSnapShot){
            document.getElementById(component.get("v.AutodocKey")+'HIPPA').setAttribute("data-auto-doc-feature",component.get('v.AutodocPageFeature'));
        }
        component.set("v.isPreviewOpen", true);
    },
    
    getSelectedPolicies: function (component, event, helper) {
        debugger;
        //US2423120, US2517602, US2517604 - Praveen
        var appEvent = $A.get("e.c:ACET_SetPoliciesList");
        var selectedPolicyList = component.get('v.selectedPolicyLst');
        appEvent.setParams({
            "selectedPolicyList" : selectedPolicyList,
            "memberMap" : component.get('v.memberMap')
        });
        appEvent.fire();
    },
    setProviderLookupPageNum: function (component, event, helper) {
        var pageNumber = event.getParam("providerPageNumber");
        var tableId = event.getParam("tableIdPrvd");
        component.set("v.providerPageNumber", pageNumber);
        component.set("v.lgt_dt_table_ID", tableId);
    },
    //US2554307: View Authorizations Details Page - Add Alerts Button Praveen CR
    setMmberIdGroupIdAuthDtl: function (component, event, helper) {
        var appEvent = $A.get("e.c:ACET_SetMmberIdGroupIdAuthDtl");
        appEvent.setParams({
            "memberIdAuthDtl" : component.get('v.memberIdAuthDtl'),
            "groupIdAuthDtl" : component.get('v.groupIdAuthDtl'),
            "alertProviderId" : component.get('v.alertProviderId'),
            "alertTaxId" : component.get('v.alertTaxId')
        });
        appEvent.fire();
    },
    
    // US2718107 - Thanish - 30th June 2020
    handleAutodocWarningYes: function (cmp, event, helper) {
        window.localStorage.clear();
        helper.handleHighlightHelper(cmp, event, helper);
        //US2718111: View Authorizations - Switching Policies and Auto Doc - Praveen
        helper.closeAuthDetailSubTabs(cmp, event, helper);
        cmp.set("v.showAutodocWarning", false);
        
        // Thanish - 16th Jul 220 - DE347218
        helper.refreshHouseholdAutodoc(cmp, event);
    },
    
    handleAutodocWarningNo: function (cmp, event, helper) {
        cmp.set("v.showAutodocWarning", false);
    },
    
    // TECH - US2692129
    handleHighlight: function (cmp, event, helper)
    {
        cmp.set("v.boolSaveCaseDisabledWarning", false);
        // DE347217 - Thanish - 16th Jul 2020
        var trClassList = event.currentTarget.parentNode.classList;
        
        if(!trClassList.contains("highlight")){
            var selectedPolicyAttributes = {};
            selectedPolicyAttributes.selectedPlan = event.currentTarget.getAttribute("data-plan");
            selectedPolicyAttributes.selectedGroup = event.currentTarget.getAttribute("data-group");
            selectedPolicyAttributes.selectedsourcecode = event.currentTarget.getAttribute("data-polsourcecode");
            selectedPolicyAttributes.selectedrelationshipCode = event.currentTarget.getAttribute("data-relationshipCode");
            selectedPolicyAttributes.selectedmemId = event.currentTarget.getAttribute("data-polmemberid");
            selectedPolicyAttributes.selectedTranId = event.currentTarget.getAttribute("data-trid");
            selectedPolicyAttributes.endDate = event.currentTarget.getAttribute("data-endDate");
            selectedPolicyAttributes.selectedRowIndex = event.currentTarget.getAttribute("data-index");
            selectedPolicyAttributes.selectedPolicyContactAddress = event.currentTarget.getAttribute("data-addressLine1");
            selectedPolicyAttributes.city = event.currentTarget.getAttribute("data-city");
            selectedPolicyAttributes.state = event.currentTarget.getAttribute("data-state");
            selectedPolicyAttributes.zip = event.currentTarget.getAttribute("data-zip");
            cmp.set("v.selectedPolicyAttributes",selectedPolicyAttributes);
            //alert(JSON.stringify(cmp.get("v.providerDetails")));
            
            if(event.currentTarget.getAttribute("data-plansubstring").includes('Non Medical')) {
                cmp.set("v.boolSaveCaseDisabledWarning", true);
            }

            // US2718112 - Thanish - 2nd Jul 2020
            if(window.jQuery)
            {
                var contextVar = '#' + cmp.get('v.AutodocKey');
                //US2718111: View Authorizations - Switching Policies and Auto Doc
                var contextClass = '.' + cmp.get('v.AutodocKey');
                var caseNotSavedTopics = cmp.get("v.caseNotSavedTopics");
                var warningTopics = [];
                
                // checking member eligibility autodoc ...
                if(caseNotSavedTopics.includes("View Member Eligibility")){
                    var memEligibilityCheckedBoxes = $(contextVar).find("input[type='checkbox'].autodoc:checked").length;
                    if(memEligibilityCheckedBoxes > 0){
                        warningTopics.push("View Member Eligibility");
                    }
                }
                // checking provider lookup autodoc ...
                if(caseNotSavedTopics.includes("Provider Lookup")){
                    var provLookupCheckedBoxes = $(contextVar + 'providerLookup').find("input[type='checkbox'].autodoc:checked").length;
                    if(provLookupCheckedBoxes > 0){
                        warningTopics.push("Provider Lookup");
                    }
                }
                // checking plan benefits autodoc
                if(caseNotSavedTopics.includes("Plan Benefits")){
                    var planBenefitsCheckedBoxes = $(contextVar + 'planBenefits').find("input[type='checkbox'].autodoc:checked").length;
                    if(planBenefitsCheckedBoxes > 0){
                        warningTopics.push("Plan Benefits");
                    }
                }
                
                //US2718111: View Authorizations - Switching Policies and Auto Doc - Error Message Need to Save a Case - Praveen - Start
                // checking View Authorizations autodoc
                if(caseNotSavedTopics.includes("View Authorizations")){
                    var AuthorizationsCheckedBoxes = $(contextVar + 'viewauthorizations').find("input[type='checkbox'].autodoc:checked").length;
                    var AuthorizationsDetailsCheckedBoxes = $(contextClass + 'viewauthorizationsdetails').find("input[type='checkbox'].autodoc:checked").length;
                    if(AuthorizationsCheckedBoxes > 0 || AuthorizationsDetailsCheckedBoxes > 0){
                        warningTopics.push("View Authorizations");
                    }
                }
                //US2718111: View Authorizations - Switching Policies and Auto Doc - Error Message Need to Save a Case - Praveen -End
                
                // show warning message ...
                if(warningTopics.length > 0){
                    var warningsTopicsStr='';
                    var count = 1;
                    for(var i in warningTopics){
                        if(warningTopics.length === count){
                            warningsTopicsStr = warningsTopicsStr+warningTopics[i];
                        }else{
                            warningsTopicsStr = warningsTopicsStr+warningTopics[i]+', ';
                        }
                        count++;
                    }
                    //var warningStr = 'Any unsaved cases for ' + warningTopics.toString() + ' auto doc and free form comments for the current policy will not be saved. Do you wish to continue?';
                    var warningStr = 'Any unsaved cases for ' + warningsTopicsStr + ' auto doc and free form comments for the current policy will not be saved. Do you wish to continue?';
                    cmp.set("v.autodocWarningDescription",warningStr);
                    cmp.set("v.showAutodocWarning",true);
                }else{
                    //alert('hit');
                    helper.handleHighlightHelper(cmp, event, helper);
                }
            }
        }
    },
    
    // US2718112 - Thanish - 2nd Jul 2020
    handleACETCaseCreated : function (cmp, event){
        var caseNotSavedTopics = cmp.get("v.caseNotSavedTopics");
        var index = caseNotSavedTopics.indexOf("View Member Eligibility");
        if(index >= 0){
            caseNotSavedTopics.splice(index, 1);
        }
        cmp.set("v.caseNotSavedTopics", caseNotSavedTopics);
    }
    
});