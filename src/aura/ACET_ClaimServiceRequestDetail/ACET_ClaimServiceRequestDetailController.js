({
    init: function (cmp, event, helper) {
        var pageReference = cmp.get("v.pageReference");
        cmp.set("v.issueId", pageReference.state.c__issueId);
        cmp.set("v.issueType", pageReference.state.c__issueType);
        cmp.set("v.recordId", pageReference.state.c__recordId);
        cmp.set("v.taxId", pageReference.state.c__taxId);
        cmp.set("v.parentUniqueId", pageReference.state.c__parentUniqueId);
        cmp.set("v.cmpUniqueId", new Date().getTime());
    },

    openORSDetail: function (cmp, event) {
        var orsId = event.currentTarget.getAttribute("data-orsId");
        let openedTabs = cmp.get("v.openedTabs");
        openedTabs.push(orsId);
        cmp.set("v.openedTabs", openedTabs);
        $A.util.addClass(event.currentTarget, orsId);
        $A.util.addClass(event.currentTarget, "disableLink");
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
                        "c__caseId": orsId,
                        "c__parentUniqueId": cmp.get("v.cmpUniqueId"),
                        "c__sfCaseId": cmp.get("v.recordId"),
                        "c__isFacetsDataPresent": false,
                        "c__facetsResponse": null,
                        "c__recordId": cmp.get("v.recordId"),
                        "c__idType": "ORS"
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
                    iconAlt: "Service Request Detail"
                });
            }).catch(function (error) {
                console.log(error);
            });
        });
    },

    openClaimAttachment: function (cmp, event, helper) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title: "Warning",
            message: "You are being redirected to Doc360 to view your document.",
            duration: "20000",
            key: "info_alt",
            type: "warning",
            mode: "dismissible"
        });
        toastEvent.fire();

        var attachId = event.currentTarget.getAttribute("data-fileId");
        $A.util.addClass(event.currentTarget, attachId);
        $A.util.addClass(event.currentTarget, "disableLink");
        var action = cmp.get("c.getDoc360Url");
        action.setParams({
            //"attachmentId": attachId,
            "taxId": cmp.get("v.taxId"),
            "claimNumber": cmp.get("v.externalIdDetails.claimNumber"),
            "tcktNumber": cmp.get("v.issueId")
        });
        action.setCallback(this, function (response) {
            let state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                if (!$A.util.isEmpty(result)) {
                    setTimeout(function () {
                        window.open(result, "_blank");
                    }, 2500);
                } else {
                    helper.fireToastMessage("No Document found");
                }
            } else {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " +
                            errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
                helper.fireToastMessage("No Document found");
            }
        });
        $A.enqueueAction(action);
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

    getClaimReconDetail: function (cmp, event, helper) {
        cmp.set("v.externalIdDetailsLoaded", false);
        cmp.set("v.attachmentsLoaded", false);
        helper.getReconDetails(cmp, event, helper);
    },

    chevToggle: function (cmp) {
        var iconName = cmp.find("additionalDetailsChevronAI").get("v.iconName");
        console.log("showAdditionalDetails: " + cmp.get("v.showAdditionalDetails"));
        if (iconName === "utility:chevrondown") {
            cmp.set("v.icon", "utility:chevronright");
            cmp.set("v.showAdditionalDetails", "false");
        } else {
            cmp.set("v.icon", "utility:chevrondown");
            cmp.set("v.showAdditionalDetails", "true");
        }
        console.log("showAdditionalDetails: " + cmp.get("v.showAdditionalDetails"));
    },

    onHistoryColumnSort: function (cmp, event, helper) {
        let column = event.currentTarget.getAttribute("data-column");
        let sortOrder = event.currentTarget.getAttribute("data-sortOrder");
        let filteredHistoryList = cmp.get("v.filteredHistoryList");
        if (sortOrder == "asc") {
            event.currentTarget.setAttribute("data-sortOrder", "des");
            sortOrder = "des";
            cmp.set("v.historySortingIcon", "utility:arrowdown");
        } else {
            event.currentTarget.setAttribute("data-sortOrder", "asc");
            sortOrder = "asc";
            cmp.set("v.historySortingIcon", "utility:arrowup");
        }
        filteredHistoryList = helper.sortObjectList(filteredHistoryList, column, sortOrder);
        cmp.set("v.filteredHistoryList", filteredHistoryList);
        cmp.set("v.historySortColumn", column);
    },

    onHistorySearch: function (cmp, event, helper) {
        let searchText = cmp.find("historySearchBox").get("v.value").toLowerCase().trim();
        if ($A.util.isEmpty(searchText)) {
            cmp.set("v.filteredHistoryList", cmp.get("v.historyList"));
        } else {
            cmp.set("v.filteredHistoryList", helper.filterData(cmp, cmp.get("v.filteredHistoryList"), searchText));
        }
    },

    onAttachmentSearch: function (cmp, event, helper) {
        let searchText = cmp.find("additionalDetailsSearchBox").get("v.value").toLowerCase().trim();
        if ($A.util.isEmpty(searchText)) {
            cmp.set("v.filteredAttachments", cmp.get("v.attachmentsList"));
        } else {
            var result = helper.filterData(cmp, cmp.get("v.filteredAttachments"), searchText);
            cmp.set("v.filteredAttachments", result);
        }
    },

    onAttachmentColumnSort: function (cmp, event, helper) {
        let column = event.currentTarget.getAttribute("data-column");
        let sortOrder = event.currentTarget.getAttribute("data-sortOrder");
        let filteredAttachmentsList = cmp.get("v.filteredAttachments");
        if (sortOrder == "asc") {
            event.currentTarget.setAttribute("data-sortOrder", "des");
            sortOrder = "des";
            cmp.set("v.attachmentSortingIcon", "utility:arrowdown");
        } else {
            event.currentTarget.setAttribute("data-sortOrder", "asc");
            sortOrder = "asc";
            cmp.set("v.attachmentSortingIcon", "utility:arrowup");
        }
        filteredAttachmentsList = helper.sortObjectList(filteredAttachmentsList, column, sortOrder);
        cmp.set("v.filteredAttachments", filteredAttachmentsList);
        cmp.set("v.attachmentSortColumn", column);
    },

    onTabClosed: function (cmp, event, helper) {
        let tabId = event.getParam('tabId');
        if (tabId == cmp.get("v.tabId")) {
            var tabCloseEvt = $A.get("e.c:ACET_SRICloseTabEvent");
            tabCloseEvt.setParams({
                "closedTabId": tabId,
                "parentUniqueId": cmp.get("v.parentUniqueId"),
                "orsId": cmp.get("v.issueId")
            });
            tabCloseEvt.fire();
        }
    },

    onTabFocused: function (cmp, event, helper) {
        let focusedTabId = event.getParam('currentTabId');
        let tabId = cmp.get("v.tabId");
        if ($A.util.isEmpty(tabId)) {
            cmp.set("v.tabId", focusedTabId);
        }
    }
})