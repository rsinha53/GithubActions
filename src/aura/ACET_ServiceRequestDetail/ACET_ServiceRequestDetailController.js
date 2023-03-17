({
    init : function(cmp, event, helper) {
        cmp.set("v.isIssueDetailsLoaded", false);
        cmp.set("v.commentsValue", '');
        cmp.set("v.cmpUniqueId", new Date().getTime());
        var tabledata = [];
        tabledata = {
            "DateCreated": "--",
            "IdType": "--",
            "ExternalId": "--",
            "isLink": false
        };
        cmp.set("v.externalIdRecs", tabledata);
        // US3480373: Service Request Detail Page Alignment - Krish - 5 May 2021
        cmp.set("v.filteredExternalIdRecs", tabledata);
        var pageReference = cmp.get("v.pageReference");
        cmp.set("v.caseId", pageReference.state.c__caseId);
        cmp.set("v.sfCaseId", pageReference.state.c__sfCaseId);
        cmp.set("v.parentUniqueId", pageReference.state.c__parentUniqueId);
        cmp.set("v.memberId", pageReference.state.c__memberId); // US3480373: Service Request Detail Page Alignment - Krish - 5 May 2021
        cmp.set("v.memberEEID", pageReference.state.c__memberEEID); // US3177995 - Thanish - 22nd Jun 2021
        //US3145625 - Sravan - Start
        cmp.set("v.recordId",pageReference.state.c__recordId);
        console.log('The acet case id'+ JSON.stringify(cmp.get("v.recordId")));
        //US3145625 - Sravan - End
        helper.getORSIssueDetails(cmp, event, helper, pageReference.state.c__idType);
        var idType= pageReference.state.c__idType;
        if(!$A.util.isUndefinedOrNull(idType) && !$A.util.isEmpty(idType) ){ //&& idType == 'FACETS'
            cmp.set("v.idType",idType);
            if( (cmp.get("v.isFacetsEnabled") =='TRUE' && idType == 'FACETS') || idType == 'ORS'){
                cmp.set("v.DisplayCommentSec",true);
            }
        }
    },

    enableORSIdLink: function (cmp, event) {
        if (event.getParam("parentUniqueId") == cmp.get("v.cmpUniqueId")) {
            let elementList = document.getElementsByClassName(event.getParam("orsId"));
            if (elementList.length > 0) {
                $A.util.removeClass(elementList[0], "disableLink");
                $A.util.removeClass(elementList[0], event.getParam("closedTabId"));

                let openedTabs = cmp.get("v.openedTabs");
                if (openedTabs.length > 0) {
                    let index;
                    for (index = 0; index < openedTabs.length; index++) {
                        if (openedTabs[index] == event.getParam("orsId")) {
                            openedTabs.splice(index, 1);
                            cmp.set("v.openedTabs", openedTabs);
                            break;
                        }
                    }
                }
            }
        }
    },

    openClaimServiceRequestDetail: function (cmp, event, helper) {
        var orsId = event.currentTarget.getAttribute("data-orsId");
        var issueType = event.currentTarget.getAttribute("data-IdType");
        helper.openServiceRequestDetail(cmp, event, helper, orsId, issueType);
    },

    getRelatedExternalIds: function (cmp, event, helper) {
        cmp.set("v.isExternalIdsLoaded", false);
        var claimNumber = cmp.get("v.claimNumber")
        helper.getClaimRelatedRecords(cmp, event, helper, claimNumber);
    },

    onColumnSort : function(cmp, event, helper) {
        let column = event.currentTarget.getAttribute("data-column");
        let sortOrder = event.currentTarget.getAttribute("data-sortOrder");
        let filteredHistoryList = cmp.get("v.filteredHistoryList");

        if(sortOrder == "asc") {
            event.currentTarget.setAttribute("data-sortOrder", "des");
            sortOrder = "des";
            cmp.set("v.sortingIcon", "utility:arrowdown");
        } else {
            event.currentTarget.setAttribute("data-sortOrder", "asc");
            sortOrder = "asc";
            cmp.set("v.sortingIcon", "utility:arrowup");
        }

        filteredHistoryList = helper.sortObjectList(filteredHistoryList, column, sortOrder);
        cmp.set("v.filteredHistoryList", filteredHistoryList);
        cmp.set("v.historySortColumn", column);
    },

    onTabFocused: function (cmp, event, helper) {
        let focusedTabId = event.getParam('currentTabId');
        let tabId = cmp.get("v.tabId");

        if($A.util.isEmpty(tabId)) {
            cmp.set("v.tabId", focusedTabId);
        }
    },

    onTabClosed : function(cmp, event, helper) {
        let tabId = event.getParam('tabId');

        if(tabId == cmp.get("v.tabId") || ( cmp.get("v.parentUniqueId") == "ACET_WorkQueue" && $A.util.isEmpty(cmp.get("v.tabId")) ) ) {
            var tabCloseEvt = $A.get("e.c:ACET_SRICloseTabEvent");
            tabCloseEvt.setParams({
                "closedTabId" : tabId,
                "parentUniqueId" : cmp.get("v.parentUniqueId"),
                "orsId" : cmp.get("v.caseId")
            });
            tabCloseEvt.fire();
        }
    },
     handleKeyup : function(cmp) {
        var inputCmp = cmp.find("commentsBoxId");
        var value = inputCmp.get("v.value");
        value= value.trim();
        var max = 2000;
        var remaining = max - value.length;
        cmp.set('v.charsRemaining', remaining);
         var errorMessage = 'Error!  You have reached the maximum character limit.  Add additional comments in Case Details as a new case comment.';
         var errorMessage2 = 'Please enter comments.';
         if(value.length == 0){
             inputCmp.setCustomValidity(errorMessage2);
             inputCmp.reportValidity();
         }
        else if (value.length >= 2000) {
            inputCmp.setCustomValidity(errorMessage);
            inputCmp.reportValidity();
        }
        else {
            inputCmp.setCustomValidity('');
            inputCmp.reportValidity();
        }
    },
    addcomments : function(cmp,event,helper){
        var inputCmp = cmp.find("commentsBoxId");
        var value = inputCmp.get("v.value");
        value= value.trim();
        var errorMessage = 'Please enter comments.';
        if(!$A.util.isEmpty(value) && value.length > 0 ){
            if(!$A.util.isUndefinedOrNull(cmp.get("v.sfCaseId")) &&  !$A.util.isEmpty(cmp.get("v.sfCaseId"))){
                helper.insertCaseCommentsWithSF(cmp, event, helper);
            }
            if(cmp.get("v.idType") == 'ORS'){
                helper.insertOnlyORSComments(cmp, event, helper);
            }
            if(cmp.get("v.idType") == 'FACETS'){
                helper.insertFacetsComments(cmp, event, helper);
            }

        }
        else{
            inputCmp.setCustomValidity(errorMessage);
            inputCmp.reportValidity();
        }
    },

    onSearch : function(cmp, event, helper) {
        if($A.util.isEmpty(cmp.find("searchBox").get("v.value"))) {
            cmp.set("v.filteredHistoryList", cmp.get("v.issueDetails.historyList"));
        } else {
            cmp.set("v.filteredHistoryList", helper.filter(cmp, cmp.get("v.filteredHistoryList")));
        }
    },
    // US3480373: Service Request Detail Page Alignment - Krish - 5 May 2021
    onExternalIdSearch : function(cmp, event, helper){
        if ($A.util.isEmpty(cmp.find("externalIdSearchBox").get("v.value"))) {
            cmp.set("v.filteredExternalIdRecs", cmp.get("v.externalIdRecs"));
        } else {
            cmp.set("v.filteredExternalIdRecs", helper.filterExternalIdRecords(cmp, cmp.get("v.externalIdRecs")));
        }
    },
    toggleSection : function(component, event){
        var sectionAuraId = event.target.getAttribute("data-auraId");
        var sectionDiv = component.find(sectionAuraId).getElement();
        var sectionState = sectionDiv.getAttribute('class').search('slds-is-open');
        if (sectionState == -1) {
            sectionDiv.setAttribute('class', 'slds-section slds-is-open');
        } else {
            sectionDiv.setAttribute('class', 'slds-section slds-is-close');
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
        var orsId = event.currentTarget.getAttribute("data-orsId");

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
                    label: orsId
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