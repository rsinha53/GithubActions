({
    init: function (component, event, helper) {
        //TTS Modal Case Creation : US1852201 
        helper.loadTtsTopics(component, event, helper);
        
    },
    
    dataChange: function (component, event, helper) {
        debugger;
        //US1761826 - UHC/Optum Exclusion UI - START
        helper.fetchOptumExclusionGroupIds(component, event, helper);
        var policyList = component.get("v.policyList");
        //alert(JSON.stringify(policyList));
        var fetchData = [];
       
        for (var k in policyList) {
            /*if (component.get("v.initialLoading") && policyList[k].highlightedPolicy) {
                helper.getMemberPolicyNetworkDetails(component, policyList[k].transactionId, k , helper);
            }*/
            if (policyList.hasOwnProperty(k)) {
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
                    providerStatus: "Select to view",
                    Referral: policyList[k].referral,
                    prodStatus: policyList[k].planStatus,
                    transactionId: policyList[k].transactionId,
                    concatAddress: policyList[k].concatAddress,
                    financials: policyList[k].financialWrapper
                    //idCard: 'View'
                };
                //US2061732 - Added by Avish
                if(policyList[k].highlightedPolicy && policyList[k].planStatus == "false"){
                	helper.hidePolicySpinner(component);
                    var srnEvent = $A.get("e.c:ETSBE_AuthSRNCreateEvent");
                    srnEvent.setParams({
                        "termedFlag": policyList[k].termedFlag,
                        "memberTabId": component.get("v.memberTabId")
                    });
                    srnEvent.fire();
                }
                //US2061732 - Ends
                //policyList[k].highlightedPolicy = false;
            }
        }
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
            /*{
            label: 'ID Card',
            type: 'url',
            fieldName: "idCard",
            typeAttributes: {
                label: {
                    fieldName: 'idCard'
                },
                color: '#006DCC'
            },
            sortable: true
        }*/
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
        var tableData = component.get("v.data");
        if (component.get("v.initialLoading") && tableData.length >= 1 && allowCallouts && hasAccess) {
            //alert('POLICY-CALLOUT-FIRED!');
            helper.getMemberPolicyNetworkDetails(component, tableData[0].transactionId, 0 , helper);
            component.set("v.initialLoading", false);
        } else {
            //alert('POLICY-CALLOUT-NOT-FIRED!');
            if(tableData.length > 0){
                helper.getCoverageLevel(component, tableData[0].transactionId, 0 , helper);
            }
        }
        
        //US2138475 - Autodoc Policy Click - Sanka
        var componentId = component.get('v.AutodocPageFeature') + 'policyTable';
        component.set('v.componentId',componentId);

        //US2038277 - Autodoc Integration - Sanka
        //setTimeout(function(){
            //var tabKey = component.get("v.AutodocKey");
           // window.lgtAutodoc.initSAEAutodoc();
            //window.lgtAutodoc.initAutodoc(tabKey);
        //},1500);
        
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

    doFilter: function (component, event, helper) {
        debugger;
        helper.executeFilter(component, event, helper);
    },

    selectAllCheckbox: function (component, event, helper) {},

    checkboxSelect: function (component, event, helper) {},

    handleHighlight: function (component, event, helper) {
        //debugger;
        var htmlcmp = event.currentTarget;
        
        //future : call getPolicyDetails apex controller method to do the job
        var selectedPlan = event.currentTarget.getAttribute("data-plan");
        var selectedGroup = event.currentTarget.getAttribute("data-group");
        var selectedTranId = event.currentTarget.getAttribute("data-trid");
        var endDate = event.currentTarget.getAttribute("data-endDate");
        
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
        
        let allowCallouts = component.get("v.allowCallouts"); 
	//US1933887 - UHG Access
        //Sanka D. - 31.07.2019
        let hasAccess = component.get("v.uhgAccess");
        
        // Changed - US1933887 - Sanka
    if (mapExclusions.has(selectedGroup) && !hasAccess) {
            helper.fireShowComponentEvent(component, event, helper, false);
        } else {
            helper.fireShowComponentEvent(component, event, helper, true);
            if (tableDataList[selectedRowIndex].providerStatus == "Select to view") {
                //US1888880
                helper.showPolicySpinner(component);
                helper.getMemberPolicyNetworkDetails(component, tableDataList[selectedRowIndex].transactionId, selectedRowIndex, helper);
            } else {
                helper.fireNetworkStatusEvent(component, selectedRowIndex);
            }
        }    
        //US1761826 - UHC/Optum Exclusion UI - END  

        //console.log('selectedTranId::'+selectedTranId);
        helper.firePolicyClick(component, event, helper);
        //helper.getPolicyDataIntoAlert(component, event, helper);

        //US2138475 - Policy Click Autodoc Change
        var initialClick = component.get('v.initialClick');
        // if(!initialClick){
        /*setTimeout(function(){
            // window.lgtAutodoc.initSAEAutodoc();
            var autoDocKey = component.get("v.AutodocPageFeature");
            var tabKey = component.get("v.AutodocKey");
            //console.log("======Tbkey ---->>"+tabKey);
            window.lgtAutodoc.saveAutodocSelections(autoDocKey,tabKey);
            window.lgtAutodoc.clearAutodocSelections(autoDocKey,tabKey);


        },1);*/
        //  }

        component.set('v.initialClick',false);

        //US2061732 - Added by Avish
        /*for(var k in tableDataList){
            var srnEvent = $A.get("e.c:SAE_AuthSRNCreateEvent");
            if(tableDataList[k].SelectedItem){                                
                srnEvent.setParams({
                    "termedFlag": tableDataList[k].termedFlag,
                    "memberTabId": component.get("v.memberTabId")
                });
                srnEvent.fire();
                break;
            }
        }*/
        //US2061732 - Ends

    },
    
    //TTS Modal Case Creation : US1852201 : START
    openModal: function(component, event, helper) {
        // Set isModalOpen attribute to true        
        component.set("v.isModalOpen", true);
	    
	// US1753077 - Pilot Enhancement - Save Case - Validations and Additional Functionality: Kavinda - START
        helper.setPoliciesCountAndData(component);
        // US1753077 - Pilot Enhancement - Save Case - Validations and Additional Functionali/ty: Kavinda - END
    },
    
    onTopicChange : function(component, event, helper) {
        
    },
    onTypeChange : function(component, event, helper) {
        
       
        
    },
    onsubtypeChange : function(component, event, helper) {
    },
    
    closeModal: function(component, event, helper) {
        // Set isModalOpen attribute to false  
        component.set("v.isModalOpen", false);
        
    },
    
    wrapperChange : function(component, event, helper) {   
        //let val = component.get('v.caseWrapper');
        //console.log('###MNF-PARAMS:',JSON.stringify(val));
    },
    
    //TTS Modal Case Creation : US1852201 : END,
    submitDetails : function(component, event, helper) {
        component.set('v.cseTopic', component.find("csetopic").get("v.value"));
        component.set('v.cseType', component.find("csetype").get("v.value"));
        component.set('v.cseSubtype', component.find("csesubtype").get("v.value"));
        component.set('v.IsCaseSaved', true);
        component.set('v.isModalOpen', false);
        component.find("csetopic").set("v.value", '--None--');
        component.find("csetype").set("v.value", '--None--');
        component.find("csesubtype").set("v.value", '--None--');
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
    }
    
});