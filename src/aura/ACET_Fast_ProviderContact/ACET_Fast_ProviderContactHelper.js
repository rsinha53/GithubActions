({
    initializeMemberDetails: function (cmp) {
        var providerContactDetails = {
            "providerContactName": "",
            "providerContactPreference": "",
            "providerContactPhone": "",
            "providerContactEmail": "",
            "parProvider": ""
        };
        cmp.set("v.providerContactDetails", providerContactDetails);
    },
    
    showToastMessage: function (title, message, type, mode, duration) {
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
})