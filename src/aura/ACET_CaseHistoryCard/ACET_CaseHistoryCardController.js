({
    /*
     * This finction defined column header
     * and calls getAccounts helper method for column data
     * editable:'true' will make the column editable
     * */
    doInit : function(cmp, event, helper) { 
        // US2041480 - Thanish 31st March 2020
        cmp.set("v.cmpUniqueId", new Date().getTime());
        debugger;
        cmp.set("v.currentStartNumber",cmp.get("v.currentPageNumber"));
        cmp.set("v.currentEndNumber",cmp.get("v.pageSize"));

        console.log(cmp.get('v.memberID'));
    },
    //Start of US3511613 - Raviteja - Team Blinkers May 18 2021
    openexternalid: function(cmp, event, helper) {
        var cardDetails = new Object();
        	cardDetails.componentName = "Case History";
            cardDetails.componentOrder = 2;
            cardDetails.noOfColumns = "slds-size_6-of-12";
            cardDetails.type = "card";
            cardDetails.allChecked = false;
            cardDetails.cardData = [
                {
                    "checked": true,
                    "fieldName": "External ID Search",
                    "fieldType": "outputText",
                    "fieldValue": "External ID Search was accessed",
                    "showCheckbox": true,
                    "isReportable":true
                }
            ];
            _autodoc.setAutodoc(cmp.get("v.autodocUniqueId"), cmp.get("v.autodocUniqueIdCmp"), cardDetails);
            
        var workspaceAPI = cmp.find("workspace");
        workspaceAPI.getEnclosingTabId().then(function (enclosingTabId) {
            workspaceAPI.openSubtab({
                parentTabId: enclosingTabId,
                pageReference: {
                    "type": "standard__component",
                    "attributes": {
                        "componentName": "c__ACET_ExternalIdSearch"
                    },
                    "state": {
                        "c__memberid": cmp.get("v.memberID"),
                        "c__alertProviderId":cmp.get("v.alertProviderId"),
                        "c__alertMemberId":cmp.get("v.alertMemberId"),
                        "c__alertGroupId":cmp.get("v.alertGroupId"),
                        "c__alertTaxId":cmp.get("v.alertTaxId"),
                        "c__policyGroupId":cmp.get("v.policyGroupId"),
                        "c__policyMemberId":cmp.get("v.policyMemberId"),
                        "c__interactionRecId":cmp.get("v.interactionRecId"),
                        "c__providerNotFound":cmp.get("v.providerNotFound"),
                        "c__noMemberToSearch":cmp.get("v.noMemberToSearch"),
                        "c__isProviderSearchDisabled":cmp.get("v.isProviderSearchDisabled"),
                        "c__houseHoldMemberId":cmp.get("v.houseHoldMemberId"),
                        "c__mnf":cmp.get("v.mnf"),
                        "c__FISourceCode":cmp.get("v.FISourceCode")
                        
                    }
                  },
                    focus: true
                }).then(function (subtabId) {
                    workspaceAPI.setTabLabel({
                        tabId: subtabId,
                        label: 'External Id Search'
                    });
                    workspaceAPI.setTabIcon({
                        tabId: subtabId,
                        icon: "standard:search",
                        iconAlt: "External Id Search"
                    });
                }).catch(function (error) {
                    console.log(error);
                });
        });
        
    },
    //End of US3511613
	callCasesFromORS : function(cmp, event, helper) {   
        cmp.set("v.paginationBtnDisable",true);
		helper.casesFROMORSService(cmp, event, helper)
	},
    
    initializeTable: function(cmp,event){
        debugger;
        var params = event.getParam('arguments');
        if (params) {
            //cmp.set("v.CaseTableLst",params.tableProperties);
        }
        //cmp.get("v.CaseTableLst");
    },
    
    showResults: function(cmp, event, helper) {
        if (cmp.get("v.memberTabId") == event.getParam("memberTabId")) {
            cmp.set("v.memberID", event.getParam("memberID"));
            cmp.set("v.xRefId", event.getParam("xRefId"));
            cmp.set("v.xRefIdORS", event.getParam("xRefIdOrs"));
			cmp.set("v.flowType", event.getParam("flowType"));
            var caseHistoryList = [];
            cmp.set("v.caseHistoryList",caseHistoryList);
            cmp.set("v.isServiceCalled",false);
            cmp.set("v.toggleName", "slds-hide");
            
            /*cmp.set("v.lastsixchecked", true);
            cmp.set("v.providerChecked", true);
            cmp.set("v.isIndividual", true);
            helper.showResults(cmp, event, helper); */
        }
    },
    
    showResultsToggle: function(cmp, event, helper) {
        helper.showResultsToggle(cmp, event, helper);
    },
    
    showCaseSpinner: function(cmp, event, helper) {
        helper.showCaseSpinner(cmp);
    },
    
    //Method gets called by onsort action,
    handleSort : function(component,event,helper){
        debugger;
        //Returns the field which has to be sorted
        var fieldName = event.currentTarget.getAttribute("data-fieldName");        
        //returns the direction of sorting like asc or desc
        //var sortDirection = event.getParam("sortDirection");
        //Set the sortBy and SortDirection attributes
        //component.set("v.sortBy",sortBy);
        var sortDirection = component.get("v.arrowDirection");
        component.set("v.selectedTabsoft",fieldName);
        //component.set("v.sortDirection",sortDirection);
        // call sortData helper function
        helper.sortData(component,fieldName,sortDirection);
    },
    
    onNext : function(component, event, helper) { 
        debugger;
        if(component.get("v.isSpireOnlyCases")){
        var pageNumber = component.get("v.currentPageNumber");
        
        component.set("v.currentStartNumber", (pageNumber * component.get("v.pageSize"))+1);
        var endNumber = component.get("v.currentStartNumber");
        component.set("v.currentEndNumber", (endNumber + component.get("v.pageSize")) - 1);
        component.set("v.currentPageNumber", pageNumber+1);
        helper.buildData(component, helper);
        }else if(!component.get("v.isAllORSCasesFetched") && !component.get("v.isCandSPolicy") ){
            helper.showCaseSpinner(component);
            helper.casesFROMORSService(component, event, helper);
        }else if(component.get("v.isCandSPolicy") && !component.get("v.isAllFACETCasesFetched")){
            helper.showCaseSpinner(component);
            helper.getFACETCases(component, event, helper);
        }

    },
    
    onPrev : function(component, event, helper) {        
        debugger;
        var pageNumber = component.get("v.currentPageNumber");
        component.set("v.currentPageNumber", pageNumber-1);
        component.set("v.currentStartNumber", (component.get("v.currentStartNumber") - component.get("v.pageSize")));
        component.set("v.currentEndNumber", (component.get("v.currentStartNumber") + component.get("v.pageSize")) - 1);
        helper.buildData(component, helper);
    },
    
    processMe : function(component, event, helper) {
        debugger;
        component.set("v.currentPageNumber", parseInt(event.target.name));
        var pageNumber = component.get("v.currentPageNumber");
        var pageSize = component.get("v.pageSize");
        var x = (pageNumber-1)*pageSize;
        component.set("v.currentStartNumber", parseInt(x) + 1);
        component.set("v.currentEndNumber", parseInt(x) + parseInt(pageSize));
        console.log(component.get("v.currentStartNumber"));
        helper.buildData(component, helper);
        var selectedTabsoft = component.get("v.selectedTabsoft");
        var arrowDirection = component.get("v.arrowDirection");
        helper.sortData(component,selectedTabsoft,arrowDirection);
    },
    
    onFirst : function(component, event, helper) {        
        component.set("v.currentPageNumber", 1);
        component.set("v.currentStartNumber", component.get("v.currentPageNumber"));
        component.set("v.currentEndNumber", component.get("v.pageSize"));
        helper.buildData(component, helper);
    },
    
    onLast : function(component, event, helper) {        
        component.set("v.currentPageNumber", component.get("v.totalPages"));  
        var pageNumber = component.get("v.currentPageNumber");
        var pageSize = component.get("v.pageSize");
        var allData = component.get("v.allData");
        var x = (pageNumber-1)*pageSize;
        component.set("v.currentStartNumber", x + 1);
        component.set("v.currentEndNumber", allData.length);
        helper.buildData(component, helper);
    },
    
    searchValueFunc: function(cmp,event,helper){
        helper.filterCaseResults(cmp, event, helper);
    },
    
    changePageSize: function(cmp,event,helper){
        debugger;
        var pgeSize = cmp.find("selectPageSizeId").get("v.value");
        var value = event.getParam("value");
        var caseHistoryList = cmp.get("v.allData");
        cmp.set("v.currentPageNumber", 1);
        cmp.set("v.currentStartNumber", 1);
        if(pgeSize == 'All'){
            cmp.set("v.pageSize",caseHistoryList.length);
            cmp.set("v.currentEndNumber",caseHistoryList.length);
            cmp.set("v.totalPages", 1);
        }else{
            cmp.set("v.pageSize",parseInt(pgeSize));
            cmp.set("v.currentEndNumber",cmp.get("v.pageSize"));
            if(Math.ceil(caseHistoryList.length/cmp.get("v.pageSize")) == 0){
                cmp.set("v.totalPages", 1);
            }else{
                cmp.set("v.totalPages", Math.ceil(caseHistoryList.length/cmp.get("v.pageSize")));
            }
        }        
                
        helper.buildData(cmp, helper);
    },
    
    openCaseDetail: function (component, event, helper) {
        debugger;
        var caseId = event.currentTarget.getAttribute("data-caseId");
        console.log(caseId);
        
        var workspaceAPI = component.find("workspace");
        workspaceAPI.openSubtab({
            pageReference: {
                type: 'standard__recordPage',
                attributes: {
                    actionName: 'view',
                    objectApiName: 'Case',
                    recordId : caseId  
                },
            },
            focus: true
        }).then(function(response) {
            workspaceAPI.getTabInfo({
                tabId: response
                
            }).then(function(tabInfo) {

            });
        }).catch(function(error) {
            console.log(error);
        });
    },
    openServiceRequestDetail: function (cmp, event, helper) {
        // US2041480 - Thanish 31st March 2020
        let clickedLink = event.currentTarget;
        $A.util.addClass(clickedLink, "disabledLink");

        var caseId = event.currentTarget.getAttribute("data-caseId");
        var idType = event.currentTarget.getAttribute("data-idtype");
        var sfCaseId = event.currentTarget.getAttribute("data-sfCaseId");
        console.log(caseId);

        // US3480373 - Krish - 11th May 2021
        var memberId = cmp.get("v.memberID");
        
        var workspaceAPI = cmp.find("workspace");
        workspaceAPI.getEnclosingTabId().then(function (enclosingTabId) {
            workspaceAPI.openSubtab({
                parentTabId: enclosingTabId,
                pageReference: {
                    "type": "standard__component",
                    "attributes": {
                        "componentName": "c__ACET_ServiceRequestDetail"
                    },
                    "state": {
                        // US2041480 - Thanish 31st March 2020
                        "c__caseId": caseId,
                        "c__sfCaseId": sfCaseId,
                        "c__parentUniqueId": cmp.get("v.cmpUniqueId"),
                        "c__idType": idType,
                        "c__memberId": memberId, // US3480373 - Krish - 11th May 2021
                        "c__memberEEID": cmp.get("v.subjectCard.EEID") // US3177995 - Thanish - 22nd Jun 2021
                        }
                    },
                    focus: true
                }).then(function (subtabId) {
                    // US2041480 - Thanish 31st March 2020
                    $A.util.addClass(clickedLink, subtabId);

                // US3537364
                var openedTabs = cmp.get("v.openedTabs");
                if ($A.util.isEmpty(openedTabs)) {
                    openedTabs = new Map();
                }
                // openedTabs.set(caseId,subtabId);
                openedTabs[caseId] = subtabId;
                cmp.set("v.openedTabs", openedTabs);
                console.log(JSON.stringify(cmp.get("v.openedTabs")));
                // End


                    workspaceAPI.setTabLabel({
                        tabId: subtabId,
                        label: caseId
                    });
                    workspaceAPI.setTabIcon({
                        tabId: subtabId,
                        icon: "action:record",
                        iconAlt: "Service Request Detail"
                    });
                }).catch(function (error) {
                    console.log(error);
                });
        });
    },

    // US2041480 - Thanish 31st March 2020
    handleSRITabClosed : function (cmp, event, helper) {
        if(event.getParam("parentUniqueId") == cmp.get("v.cmpUniqueId")) {
            let elementList = document.getElementsByClassName(event.getParam("closedTabId"));
            if(elementList.length > 0) {
                $A.util.removeClass(elementList[0], "disabledLink");
                $A.util.removeClass(elementList[0], event.getParam("closedTabId"));

                //US3537364
                var caseId = elementList[0].getAttribute("data-caseId");
                var openedTabs = cmp.get("v.openedTabs");
                const mapEx = new Map(Object.entries(openedTabs));
                mapEx.delete(caseId);
                cmp.set("v.openedTabs", mapEx)
            }
        }
    },


         handleRemovePill: function (cmp, event, helper) {
             var name = event.getParam("item").name;
             // alert(name + ' pill was removed!');
             var items = cmp.get('v.items');
             var item = event.getParam("index");
             items.splice(item, 1);
             cmp.set('v.items', items);

             var itemTemp = new Object();
             itemTemp.name = event.getParam("item").name;
             itemTemp.label = event.getParam("item").label;
             var itemsAvailable = cmp.get("v.itemsAvailable");
             itemsAvailable.push(itemTemp);
             cmp.set('v.itemsAvailable', itemsAvailable);

             helper.addRemoveFilters(cmp, event, helper);
         },

         addPilltoList: function (cmp, event, helper) {
             var selectedLabel = event.currentTarget.getAttribute("data-label");
             var selectedname = event.currentTarget.getAttribute("data-name");
             var selectedIndex = event.currentTarget.getAttribute("data-index");

             var itemsAvailable = cmp.get("v.itemsAvailable");
             itemsAvailable.splice(selectedIndex, 1);
             cmp.set('v.itemsAvailable', itemsAvailable);

             var itemTemp = new Object();
             itemTemp.name = selectedname;
             itemTemp.label = selectedLabel;
             var items = cmp.get('v.items');
             items.push(itemTemp);
             cmp.set('v.items', items);

             helper.addRemoveFilters(cmp, event, helper);
    },

    toggleFamily: function (cmp, event, helper){
        var toggleCmp = cmp.find("toggleButtonId");
        cmp.set("v.isToggleOnOff", cmp.get("v.isIndividual"));
        toggleCmp.changeToggleFilter();
        //US3579548 - Sravan - Start
        var providerChecked = cmp.get("v.providerChecked");
        var lastsixchecked = cmp.get("v.lastsixchecked");
        var isIndividual = cmp.get("v.isIndividual");
        var isSpireOnlyCases = cmp.get("v.isSpireOnlyCases");
        if(providerChecked == false || lastsixchecked == false || isIndividual == false || isSpireOnlyCases == false){
            cmp.set("v.additonalRecordsNotFound",true);
        }
        else{
           cmp.set("v.additonalRecordsNotFound",false);
        }
        //US3579548 - Sravan - End

    },

    addRemoveFilters: function (cmp, event, helper){
        //US3579548 - Sravan - Start
        var providerChecked = cmp.get("v.providerChecked");
        var lastsixchecked = cmp.get("v.lastsixchecked");
        var isIndividual = cmp.get("v.isIndividual");
        var isSpireOnlyCases = cmp.get("v.isSpireOnlyCases");
        if(providerChecked == false || lastsixchecked == false || isIndividual == false || isSpireOnlyCases == false){
            cmp.set("v.additonalRecordsNotFound",true);
        }
        else{
           cmp.set("v.additonalRecordsNotFound",false);
        }
        //US3579548 - Sravan - End
        //helper.addRemoveFilters(cmp, event, helper);
        if(!cmp.get("v.isSpireOnlyCases") && !cmp.get("v.isAllORSCasesFetched") && cmp.get("v.isContinueORSFetch") && !cmp.get("v.isCandSPolicy")){
            helper.casesFROMORSService(cmp, event, helper);
        }else if(!cmp.get("v.isSpireOnlyCases") && cmp.get("v.isCandSPolicy") && !cmp.get("v.isAllFACETCasesFetched")){
            helper.getFACETCases(cmp, event, helper);
        }else{
        helper.addRemoveFilters(cmp, event, helper);
        }
    },

    toggleAll: function (cmp, event, helper){
        /*var toggleState = ! cmp.get("v.showAllToggle");
        cmp.set("v.showAllToggle",toggleState);
        if(toggleState){
            cmp.set("v.lastsixchecked",false);
            cmp.set("v.providerChecked",false);
        }else{
            cmp.set("v.lastsixchecked",true);
            cmp.set("v.providerChecked",true);
        }*/
        //US3579548 - Sravan - Start
        var providerChecked = cmp.get("v.providerChecked");
        var lastsixchecked = cmp.get("v.lastsixchecked");
        var isIndividual = cmp.get("v.isIndividual");
        var isSpireOnlyCases = cmp.get("v.isSpireOnlyCases");
        if(providerChecked == false || lastsixchecked == false || isIndividual == false || isSpireOnlyCases == false){
            cmp.set("v.additonalRecordsNotFound",true);
        }
        else{
           cmp.set("v.additonalRecordsNotFound",false);
        }
        //US3579548 - Sravan - End
        helper.addRemoveFilters(cmp, event, helper);
    },
    chevToggle : function(cmp, event, helper) {
        //console.log("relationShipcode:: "+cmp.get("v.relationShipcode"));
        /*if(cmp.get("v.isProvider")){
            cmp.set("v.pageSize", 50);
        }else{
            cmp.set("v.isSpireOnlyCases", false);
        }*/



        var GroupNumber = "";
        if (!$A.util.isUndefinedOrNull(cmp.get("v.policyList"))) {
            var selectedPolicyDt = cmp.get("v.policyList");
            selectedPolicyDt = selectedPolicyDt[cmp.get("v.policySelectedIndex")];
            if (!$A.util.isUndefinedOrNull(selectedPolicyDt)) {
                GroupNumber = selectedPolicyDt.GroupNumber;
            }

        }


        var isCaseHistoryShown = cmp.get("v.isCaseHistoryShown");
        if(!isCaseHistoryShown){
            cmp.set("v.isCaseHistoryShown",true);
        }
        if (!$A.util.isEmpty(cmp.get("v.memberDOB")) && !isCaseHistoryShown) {
            var dobMem = cmp.get("v.memberDOB").split('/');
            //cmp.set("v.xRefId", cmp.get("v.memberFN") + cmp.get("v.memberLN") + dobMem[0] + dobMem[1] + dobMem[2] + cmp.get("v.memberID") + cmp.get("v.memberGrpN"));
            let caseVal = cmp.get('v.caseWrapper');
            var casename = caseVal.SubjectName;
            casename = casename.split(" ").join("");
            var caseDob = caseVal.SubjectDOB;
            caseDob = caseDob.split("/").join("");

            var xRefId = casename + caseDob + caseVal.SubjectId + caseVal.SubjectGroupId;
            cmp.set("v.xRefId",xRefId);

            var xRefId = cmp.get("v.xRefId");
            //var EEID = component.get("v.memberSubscriberId");
            //cmp.set("v.xRefIdORS", cmp.get("v.memberFN") + cmp.get("v.memberLN") + cmp.get("v.memberID") + '0' + cmp.get("v.memberGrpN"));
            cmp.set("v.xRefIdORS", cmp.get("v.memberFN") + cmp.get("v.memberLN") + cmp.get("v.memberSubscriberId") + '0' + GroupNumber);
        }
        if(cmp.get('v.toggleName') == 'slds-show'){
            cmp.set("v.toggleName", "slds-hide");
        }
        else{
            cmp.set("v.toggleName", "slds-show");
            if(!cmp.get("v.isServiceCalled")){
                helper.showCaseSpinner(cmp);
                helper.getMemberCaseHistory(cmp,cmp.get("v.memberID"),cmp.get("v.xRefId"));
                cmp.set("v.paginationBtnDisable",true);
                //helper.casesFROMORSService(cmp, event, helper);
            }
        }
    },
    callNextORScases: function (cmp, event, helper) {
            var moreORScases = cmp.get("v.moreData");
            if(moreORScases && cmp.get("v.isContinueORSFetch") && !cmp.get("v.isProvider")){
                var casesFrom = cmp.get('c.callCasesFromORS');
                $A.enqueueAction(casesFrom);
            }

    },
    fetchORScases: function (cmp, event, helper) {
        helper.showCaseSpinner(cmp);
         //US3579548 - Sravan - Start
         var providerChecked = cmp.get("v.providerChecked");
         var lastsixchecked = cmp.get("v.lastsixchecked");
         var isIndividual = cmp.get("v.isIndividual");
         var isSpireOnlyCases = cmp.get("v.isSpireOnlyCases");
         if(providerChecked == false || lastsixchecked == false || isIndividual == false || isSpireOnlyCases == false){
             cmp.set("v.additonalRecordsNotFound",true);
         }
         else{
             cmp.set("v.additonalRecordsNotFound",false);
          }
        //US3579548 - Sravan - End
        if(!cmp.get("v.isSpireOnlyCases") && !cmp.get("v.isAllORSCasesFetched") && !cmp.get("v.isORSCalled") && !cmp.get("v.isCandSPolicy")){
           helper.getMemberCaseHistory(cmp, cmp.get("v.memberID"), cmp.get("v.xRefId"));
		   helper.casesFROMORSService(cmp, event, helper);
        }else if(!cmp.get("v.isSpireOnlyCases") && cmp.get("v.isCandSPolicy") && !cmp.get("v.isAllFACETCasesFetched")){
            helper.getFACETCases(cmp, event, helper);
        }else{
			helper.getMemberCaseHistory(cmp, cmp.get("v.memberID"), cmp.get("v.xRefId"));
            helper.addRemoveFilters(cmp, event, helper);
        }
    },
    fetchLastSixtyDaysORS: function (cmp, event, helper) {
        helper.showCaseSpinner(cmp);
        if(!cmp.get("v.isSpireOnlyCases") && !cmp.get("v.isAllORSCasesFetched") && (cmp.get("v.isContinueORSFetch") || cmp.get("v.moreData"))){
            helper.casesFROMORSService(cmp, event, helper);
        }else{
            helper.addRemoveFilters(cmp, event, helper);
        }
    },

    handleRefresh: function (cmp, event, helper) {
        var uniqueId = event.getParam("uniqueId");
        var pageId = cmp.get("v.refreshUnique");
        if (!$A.util.isEmpty(uniqueId) && uniqueId == pageId) {
            cmp.set("v.enableMemberFilter", true);
            cmp.set("v.toggleName", "slds-show");
            helper.showCaseSpinner(cmp);
            helper.getMemberCaseHistory(cmp, cmp.get("v.memberID"), cmp.get("v.xRefId"));
            cmp.set("v.paginationBtnDisable", true);
        }
    },

    policyChangeHandlerNew: function (cmp, event, helper) {
        var selectedPolicy =  cmp.get("v.policyDetails");
        var cspPolicy ="";
        if(!$A.util.isUndefinedOrNull(selectedPolicy)
           && !$A.util.isUndefinedOrNull(selectedPolicy.resultWrapper)
          && !$A.util.isUndefinedOrNull(selectedPolicy.resultWrapper.policyRes)){
            cspPolicy =  selectedPolicy.resultWrapper.policyRes.sourceCode;
        }

        console.log('cspPolicy'+JSON.stringify(cspPolicy));
        if(cspPolicy==="AP"){
            cmp.set("v.isCandSPolicy",true);
        }else{
            cmp.set("v.isCandSPolicy",false);
        }


    },
    // US3177995 - Thanish - 22nd Jun 2021
    onPurgedCheck: function(cmp, event, helper){
        if(event.getParam("checked")){
            helper.getPurgedORSRecords(cmp);
        } else{
            helper.removePurgedORSRecords(cmp);
        }
    },

    openPurgedDetails: function(cmp, event, helper){
        var objectId = event.currentTarget.getAttribute("data-objectId");
        var externalId = event.currentTarget.getAttribute("data-externalId");

        var workspaceAPI = cmp.find("workspace");
        workspaceAPI.getEnclosingTabId().then(function (enclosingTabId) {
            workspaceAPI.openSubtab({
                parentTabId: enclosingTabId,
                pageReference: {
                    "type": "standard__component",
                    "attributes": {
                        "componentName": "c__ACET_PurgedDocument"
                    },
                    "state": {
                        "c__objectId": objectId,
                    }
                },
                focus: true
            }).then(function (subtabId) {
                workspaceAPI.setTabLabel({
                    tabId: subtabId,
                    label: externalId
                });
                workspaceAPI.setTabIcon({
                    tabId: subtabId,
                    icon: "action:record",
                    iconAlt: "Purged ORS Detail"
                });
            }).catch(function (error) {
                console.log(error);
            });
        });
    }
})