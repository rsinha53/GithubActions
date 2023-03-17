({
    // toggleChev: function(cmp, event) {
    //     var cmpTarget = cmp.find('changeIt');
    //     var chevtype = cmp.get("v.icon");
    //     if (chevtype == "utility:chevronright") {
    //         $A.util.addClass(cmpTarget, 'slds-is-open');
    //         chevtype = "utility:chevrondown";
    //         cmp.set('v.RequiredInfo.isSAIOpen', true);
    //     } else {
    //         chevtype = "utility:chevronright";
    //         $A.util.removeClass(cmpTarget, 'slds-is-open');
    //         cmp.set('v.RequiredInfo.isSAIOpen', false);
    //     }
    //     cmp.set('v.icon', chevtype);
    // },

    handleSectionToggle: function(cmp, event) {
        var openSections = event.getParam('openSections');
        if (openSections.length > 0) {
            cmp.set('v.RequiredInfo.isSAIOpen', true);
        } /*else {
            cmp.set('v.RequiredInfo.isSAIOpen', false);
        }*/
    }

})