({
    getProviderData: function (cmp) {
        var action = cmp.get("c.getAdditionalAddressesService");
        var startNo = (cmp.get("v.pageNumber") - 1) * 50;
        var errMessage = 'Unexpected Error Occurred in the Additional Addresses Card. Please try again. If problem persists please contact the help desk.';
        action.setParams({
            providerId: cmp.get("v.providerId"),
            taxId: cmp.get("v.taxId"),
            start: startNo,
            endCount: 50,
            filtered : cmp.get("v.isCombo"),
            onlyActive : cmp.get("v.isActive")
        });
        
        action.setCallback(this, function (response) {
            var state = response.getState();
            var result = response.getReturnValue();
            if (state === "SUCCESS") {
                if(result.statusCode == 200) {
                    // US3691213
                    if (cmp.get("v.isLookup")) {
                        var caseItemsExtId = cmp.get("v.selectedRowData").caseItemsExtId;
                        result.tableBody.forEach(tableRow => {
                            tableRow.caseItemsExtId = caseItemsExtId;
                        });
                    }
                    cmp.set("v.additionalAddressList", result);
                    cmp.set("v.filteredAddressList", result);
                    cmp.set("v.webservicecalled",true);   

                    var claimNo = cmp.get("v.claimNo");
                var maxAutoDocComponents = cmp.get("v.maxAutoDocComponents");
                var currentIndexOfOpenedTabs = cmp.get("v.currentIndexOfOpenedTabs");

                console.log("claimNo in Active"+claimNo);
                console.log("isClaim in bef Active"+cmp.get("v.isClaim"));
               if(cmp.get("v.isClaim")){
                  console.log("isClaim in  afer Active"+cmp.get("v.isClaim"));
                                   var filteredAddressList=cmp.get("v.filteredAddressList");

               console.log("affData in  afer Active"+cmp.get("v.affData"));
                filteredAddressList.componentName=filteredAddressList.componentName+": "+claimNo;
				filteredAddressList.autodocHeaderName=filteredAddressList.autodocHeaderName+": "+claimNo;
                  filteredAddressList.componentOrder=20.06+(maxAutoDocComponents*currentIndexOfOpenedTabs);

                }
                } else {
                    cmp.set("v.additionalAddressList", result);
                    cmp.set("v.filteredAddressList", result);
                    cmp.set("v.webservicecalled", false);
                    this.showToastMessage("We Hit a Snag.", errMessage, "error", "dismissible", "30000");
                }
            } else {
                console.log('FAIL## ' + JSON.stringify(response.getReturnValue()));
                this.showToastMessage("We Hit a Snag.", errMessage, "error", "dismissible", "30000");
            }
            this.hideSpinner(cmp);
        });
        
        $A.enqueueAction(action);
    },
    
    fireErrorToastMessage: function (message) {
		var toastEvent = $A.get("e.force:showToast");
		toastEvent.setParams({
			"title": "Error",
			"message": message,
			"type": "error",
			"mode": "pesky",
			"duration": "10000"
		});
		toastEvent.fire();
	},

	showToastMessage: function (title, message, type, mode, duration) {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "We hit a snag.",
                "message": message,
                "type": type,
                "mode": mode,
                "duration": duration
            });
            toastEvent.fire();
        },
    
    showSpinner: function (cmp) {
        var spinner = cmp.find("add-spinner");
        $A.util.removeClass(spinner, "slds-hide");
        $A.util.addClass(spinner, "slds-show");
    },

    hideSpinner: function (cmp) {
        var spinner = cmp.find("add-spinner");
        $A.util.removeClass(spinner, "slds-show");
        $A.util.addClass(spinner, "slds-hide");
    },
    
})