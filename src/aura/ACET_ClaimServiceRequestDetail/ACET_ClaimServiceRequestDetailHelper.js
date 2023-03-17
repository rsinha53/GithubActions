({
    getReconDetails: function (cmp, event, helper) {
        var action = cmp.get("c.getReconTicketDetails");
        action.setParams({
            "tcktNumber": cmp.get("v.issueId"),
            "taxId": cmp.get("v.taxId")
        });
        action.setCallback(this, function (response) {
            let state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                if (!$A.util.isEmpty(result)) {
                    cmp.set("v.externalIdDetails", result.externalIdDetails);
                    cmp.set("v.historyList", result.historyList);
                    cmp.set("v.filteredHistoryList", result.historyList);
                    cmp.set("v.historySortingIcon", "utility:arrowdown");
                    cmp.set("v.historySortColumn", "dateAndTime");
                }
                this.getClaimAttachmentList(cmp, event, helper);
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
                this.fireToastMessage("Unexpected error occured. Please try again. If problem persists, contact help desk.");
            }
            cmp.set("v.externalIdDetailsLoaded", true);
            // US3480373: Service Request Detail Page Alignment - Krish - 5 May 2021
            cmp.find('alertsAI').getAlertsOnServiceRequestDetail();
        });
        $A.enqueueAction(action);
    },

    getClaimAttachmentList: function (cmp, event, helper) {
        var action = cmp.get("c.getClaimAttachmentList");
        action.setParams({
            "tcktNumber": cmp.get("v.issueId"),
            "taxId": cmp.get("v.taxId")
        });
        action.setCallback(this, function (response) {
            let state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                if (!$A.util.isEmpty(result)) {
                    cmp.set("v.attachmentsList", result.attachmentList);
                    cmp.set("v.filteredAttachments", result.attachmentList);
                    cmp.set("v.attachmentSortingIcon", "utility:arrowdown");
                    cmp.set("v.attachmentSortColumn", "dateAndTime");
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
                this.fireToastMessage("Unexpected error occured. Please try again. If problem persists, contact help desk.");
            }
            cmp.set("v.attachmentsLoaded", true);
        });
        $A.enqueueAction(action);
    },

    fireToastMessage: function (message) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "",
            "message": message,
            "type": "error",
            "mode": "pesky",
            "duration": "10000"
        });
        toastEvent.fire();
    },

    sortObjectList: function (dataList, sortingProperty, sortOrder) {
        dataList.sort(function (a, b) {
            if (a[sortingProperty] < b[sortingProperty]) {
                if (sortOrder == "asc") {
                    return -1;
                } else {
                    return 1;
                }
            } else if (a[sortingProperty] > b[sortingProperty]) {
                if (sortOrder == "asc") {
                    return 1;
                } else {
                    return -1;
                }
            } else {
                return 0;
            }
        });
        return dataList;
    },

    convertDateTimeToUserTimeZone: function (dateTimeToConvert, inputTimeZone, outputTimeZone) {
        var dttocon = dateTimeToConvert;
        var res = dttocon.split("/");
        var adateval = res[0];
        var atimeval = res[1];
        var datearray = adateval.split("-");
        var timearray = atimeval.split(":");
        var dttoconstr = res[0] + " " + res[1];
        var dt = new Date(dttoconstr);
        var datetimetemp;
        $A.localizationService.WallTimeToUTC(dt, inputTimeZone, function (walltime) {
            datetimetemp = $A.localizationService.formatDate(walltime, "yyyy-MM-dd HH:mm:ss");
        });
        var dtoutput = new Date(datetimetemp);
        var displayValue;
        $A.localizationService.UTCToWallTime(dtoutput, outputTimeZone, function (walltime) {
            displayValue = $A.localizationService.formatDate(walltime, "MM/dd/yyyy h:mm a");
        })
        return displayValue;
    },

    filterData: function (cmp, unfilteredList, searchText) {
        if ($A.util.isEmpty(searchText)) {
            return unfilteredList;
        } else {
            let filteredData = unfilteredList.filter(function (obj) {
                // get all attributes of the object as string, convert to lowercase and then filter
                return JSON.stringify(Object.values(obj)).toLowerCase().includes(searchText);
            });
            return filteredData;
        }
    },
})