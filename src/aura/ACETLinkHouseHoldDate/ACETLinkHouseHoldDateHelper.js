({
	helperMethod : function() {
		
	},
       fireToast: function (message) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "Error!",
            "message": message,
            "message": message,
            "type": "error",
            "mode": "sticky",
            "duration": "1000"
        });
        toastEvent.fire();
    }
})