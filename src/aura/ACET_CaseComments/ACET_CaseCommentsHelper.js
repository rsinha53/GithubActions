({
    getCaseComments: function (component, event, helper) {
        var action = component.get("c.getCaseComments");
        action.setParams({
            caseId: component.get("v.recordId")
        });

        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.tableData", response.getReturnValue());
                if (response.getReturnValue() != null) {
                    component.set("v.rowCount", response.getReturnValue().length);
                }
            } else if (state === "INCOMPLETE") {
                // do something
            } else if (state === "ERROR") {
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
        });
        $A.enqueueAction(action);

        let timeInterval = {
            updatedDuration: "a few seconds",
            intervalCount: 0,
            func: null
        }
        component.set("v.timeInterval", timeInterval);
        this.updateRefreshTime(component);
    },

    insertCaseComments: function (component, event, helper) {
        component.set("v.showSpinner", true);

        var action = component.get("c.insertCaseComments");
        action.setParams({
            caseId: component.get("v.recordId"),
            caseComment: component.get("v.newCaseComment").CommentBody,
            isPublic: component.get("v.newCaseComment").IsPublic
        });

        action.setCallback(this, function (response) {
            var state = response.getState();

            if (state === "SUCCESS") {
                // US3183012
                 helper.getCaseComments(component, event, helper);
                 component.set("v.showSpinner", false);
                 component.set("v.showNewPopup", false);

				// Commenting as part of US3183012
                /*var feedback = response.getReturnValue();
                if (feedback.success) {
                    var action = component.get("c.updateORSCaseComments");
                    action.setParams({
                        caseId: component.get("v.recordId"),
                        comment: component.get("v.newCaseComment").CommentBody
                    });
                    action.setCallback(this, function (response) {
                        var state = response.getState();
                        // US2101461 - Thanish - 23rd Jun 2020 - Error Code Handling ...
                        if(state === "SUCCESS") {
                            var responseList = response.getReturnValue();
                            if(responseList.length > 0) {
                                if(responseList[0].responseStatus != 200 && responseList[0].responseStatus != 201){//DE391654: Defect Fix
                                    this.fireToast(responseList[0].responseStatusMessage);
                                }
                            }
                        } else {
                            this.fireToast("Unexpected error occured. Please try again. If problem persists contact help desk.");
                        }
                        component.set("v.showSpinner", false);
                    });
                    $A.enqueueAction(action);

                    helper.getCaseComments(component, event, helper);
                    component.set("v.showNewPopup", false);
                }else{
                    component.set("v.showSpinner", false);
                    this.fireToast(feedback.message);
                }*/

            } else if (state === "INCOMPLETE") {
                component.set("v.showSpinner", false);
                // do something

            } else if (state === "ERROR") {
                component.set("v.showSpinner", false);
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
        });
        $A.enqueueAction(action);
    },

    updateRefreshTime: function (cmp) {
        let timeInterval = cmp.get("v.timeInterval");

        // clear running time interval ...
        if (!$A.util.isEmpty(timeInterval.func)) {
            clearInterval(timeInterval.func);
            timeInterval.intervalCount = 0;
            timeInterval.updatedDuration = "a few seconds";
            cmp.set("v.timeInterval", timeInterval);
        }

        // create new time interval ...
        let refreshTimeInterval = setInterval(function () {
            timeInterval.intervalCount = timeInterval.intervalCount + 1;

            if (timeInterval.intervalCount == 1) {
                timeInterval.updatedDuration = "a minute";
            } else if (timeInterval.intervalCount < 60) {
                timeInterval.updatedDuration = timeInterval.intervalCount + " minutes";
            } else if (timeInterval.intervalCount < 120) {
                timeInterval.updatedDuration = "an hour";
            } else {
                timeInterval.updatedDuration = Math.floor(timeInterval.intervalCount / 60) + " hours";
            }

            cmp.set("v.timeInterval", timeInterval);
        }, 60000);

        timeInterval.func = refreshTimeInterval;
        cmp.set("v.timeInterval", timeInterval);
    },

    // US2101461 - Thanish - 23rd Jun 2020 - Error Code Handling ...
    fireToast: function (message) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "Error in Case Comments!",
            "message": message,
            "type": "error",
            "mode": "dismissible",
            "duration" : "5000"
        });
        toastEvent.fire();
    },
})