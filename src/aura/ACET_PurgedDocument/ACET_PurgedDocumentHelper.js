({
    getDocument: function (cmp) {
        var errorMessage = "Unexpected error occured. Please try again. If problem persists, contact help desk.";
        var action = cmp.get("c.getPurgedDocument");
        action.setParams({
            "objectId": cmp.get("v.objectId")
        });
        action.setCallback(this, function (response) {
            let state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                if (!$A.util.isEmpty(result) && result.isSuccess) {
                    cmp.set("v.documentContent", result.response);
                } else {
                    console.log("%c" + JSON.stringify(result), "color:red");
                    this.fireToastMessage(errorMessage);
                }
            } else {
                console.log("%c" + JSON.stringify(response), "color:red");
                this.fireToastMessage(errorMessage);
            }
            cmp.set("v.showSpinner", false);
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
})