({
    getAppealDetail : function(cmp) {
        var action = cmp.get("c.getAppealInfo");
        action.setParams({
            "appealId":  cmp.get("v.appealName"),
            "taxId": cmp.get("v.taxId")
        });
        action.setCallback(this, function (response) {
            let state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                cmp.set("v.appealCardDetails", result.appealDetailCard);
                cmp.set("v.detCardDetails", result.determinationCard);
                cmp.set("v.impItemTableDetails", result.impactedItemsTable);
                cmp.set("v.commentTableDetails", result.appealCommentsTable);
                cmp.set("v.letterTableDetails", result.appealLettersTable);
            } else {
                //this.fireToastMessage("Unexpected error occured. Please try again. If problem persists, contact help desk.");
            }
        });
        $A.enqueueAction(action);
    }
})