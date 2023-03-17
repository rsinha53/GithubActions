({
    populatePickListOptions: function (cmp) {
        var interactionTypeOptionsArray = ["Incoming Call", "Outbound Call", "Research", "Email", "Fax", "Portal", "Mail", "Text", "Walk-In", "Chat", "Claim"];
        var interactionTypeOptions = [];
        for (var i = 0; i < interactionTypeOptionsArray.length; i++) {
            interactionTypeOptions.push({
                label: interactionTypeOptionsArray[i],
                value: interactionTypeOptionsArray[i]
            });
        }
        cmp.set('v.interactionTypeOptions', interactionTypeOptions);
    },
})