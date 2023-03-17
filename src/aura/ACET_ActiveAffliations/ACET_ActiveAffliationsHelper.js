({
    getAffData : function(cmp) {
        var action = cmp.get("c.getAffiliationData");
        var errMessage = 'Unexpected Error Occurred in the Active Affiliations Card. Please try again. If problem persists please contact the help desk.';
        action.setParams({
            providerId: cmp.get("v.providerId"),
            taxId: cmp.get("v.taxId")
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var pDetails = response.getReturnValue();
                // US3691213
                if (cmp.get("v.isLookup")) {
                    var caseItemsExtId = cmp.get("v.selectedRowData").caseItemsExtId;
                    pDetails.tableBody.forEach(tableRow => {
                        tableRow.caseItemsExtId = caseItemsExtId;
                    });
                }
                cmp.set("v.affData",pDetails);
                //Bharat
                var claimNo = cmp.get("v.claimNo");
                var maxAutoDocComponents = cmp.get("v.maxAutoDocComponents");
                var currentIndexOfOpenedTabs = cmp.get("v.currentIndexOfOpenedTabs");

                // US3291540
                if(pDetails.statusCode != 200){
                    this.showToastMessage("We Hit a Snag.", errMessage, "error", "dismissible", "30000");
                }else{
                    cmp.set("v.isServiceSuccess", true);
                }

                console.log("claimNo in Active"+claimNo);
                console.log("isClaim in bef Active"+cmp.get("v.isClaim"));
               if(cmp.get("v.isClaim")){
                  console.log("isClaim in  afer Active"+cmp.get("v.isClaim"));
                                   var affData=cmp.get("v.affData");

                affData.componentName=affData.componentName+": "+claimNo;
				affData.autodocHeaderName=affData.autodocHeaderName+": "+claimNo;
                  affData.componentOrder=20.04+(maxAutoDocComponents*currentIndexOfOpenedTabs);

                }
                //Bharat
            } else if (state === "INCOMPLETE") {
                this.showToastMessage("We Hit a Snag.", errMessage, "error", "dismissible", "30000");
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
                this.showToastMessage("We hit a snag.", errMessage, "error", "dismissible", "30000");
            }
        });
        $A.enqueueAction(action);
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
})