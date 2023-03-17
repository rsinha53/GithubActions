({
    // When a keyword is entered in search box
    filterOptions: function (cmp, event, helper) {
        cmp.set('v.value', '');
        cmp.set("v.options", []);
        cmp.set("v.message", '');
        $A.util.removeClass(cmp.find('resultsDiv'), 'slds-is-open');
        if (!$A.util.isEmpty(cmp.get('v.searchString'))) {
            cmp.set('v.hasError', false);
            cmp.set('v.errorMsg', '');
            var delay = cmp.get('v.delay');
            var minChar = cmp.get('v.minChar');
            var searchText = cmp.get('v.searchString');
            searchText = searchText.toUpperCase();
            if (cmp.get('v.codeType') == 'DiagnosisCode') {
                searchText = helper.validateCodesWithDot(cmp, searchText);
            }
            cmp.set('v.searchString', searchText);
            var timer = cmp.get('v.timer');
            cmp.set("v.options", []);
            clearTimeout(timer);
            if (searchText.length >= minChar) {
                cmp.set("v.message", "Loading...");
                var timer = window.setTimeout(
                    $A.getCallback(function () {
                        if (cmp.isValid()) {
                            cmp.set("v.message", "Loading...");
                            $A.util.addClass(cmp.find('resultsDiv'), 'slds-is-open');
                            helper.getKLData(cmp);
                        }
                        clearTimeout(timer);
                        cmp.set('v.timer', null);
                    }), delay);
                cmp.set('v.timer', timer);
            }
        } else {
            helper.fireErrors(cmp);
            // US3518478
            helper.resetData(cmp, event);
        }
    },

    // When an item is selected
    selectItem: function (cmp, event, helper) {
        if (!$A.util.isEmpty(event.currentTarget.id)) {
            helper.selectItemHelper(cmp, event);
        }
    },

    // To close the dropdown if clicked outside the dropdown.
    blurEvent: function (cmp, event, helper) {
        helper.blurEventHelper(cmp, event);
    },

    alphanumericAndNoSpecialCharacters: function (cmp, event, helper) {
        helper.keepAlphanumericAndNoSpecialCharacters(cmp, event);
    },

    fireErrors: function (cmp, event, helper) {
        helper.fireErrors(cmp);
    },

    makeRequired: function (cmp, event, helper) {
        helper.makeRequired(cmp);
    },

    removeRequired: function (cmp, event, helper) {
        helper.removeRequired(cmp);
    },

    makeHighlighted: function (cmp, event, helper) {
        helper.makeHighlighted(cmp);
    },
    // US3437462	Plan Benefits: Benefit & PA Check Results: Validations - Sarma - 09 Mar 2021
    addDeletedError: function (cmp, event, helper) {
        helper.addDeletedError(cmp);
    },

    //US3507481- To autoSelect a code - Swapnil
    onChangeautoPopulateString: function(cmp, event, helper) {
        var autoSelect= cmp.get("v.autoSelect");
        var isCopy = cmp.get("v.isCopy");
        var autoPopulateString = cmp.get('v.autoPopulateString');
        if( (autoSelect || isCopy) && autoPopulateString != "") {
            cmp.set('v.searchString', autoPopulateString);
            if(autoSelect) {
            helper.getKLData( cmp );
        }
    }
    }

})