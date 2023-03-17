({
	fireToast: function (message, errorCode) {
        var errorType;
        if(errorCode == 200 || errorCode == 204){
            errorType = "info";
        } else {
            errorType = "error";
        }
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "Error!",
            "message": message,
            "type": errorType,
            "mode": "sticky"
        });
        toastEvent.fire();
    }
})