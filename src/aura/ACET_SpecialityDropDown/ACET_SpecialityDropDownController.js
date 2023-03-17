({
    doInit: function (cmp, event, helper) {
        helper.getComboboxRecords(cmp);
    },

    checkValidation: function (cmp, event) {
        var searchKeyword = cmp.get("v.searchKeyword");
        var comboboxFieldCmp = cmp.find("comboboxFieldAI");
        if (searchKeyword == "Select") {
            cmp.set("v.notSelectedFromList", true);
            comboboxFieldCmp.setCustomValidity("Complete this field.");
        }
    },

    populateSelectedValue: function (cmp, event) {
        var currentTarget = event.currentTarget;
        var selectedIndex = currentTarget.getAttribute("data-Index");
        var filteredComboboxRecords = cmp.get("v.filteredComboboxRecords");
        var selectedRecord = filteredComboboxRecords[selectedIndex];
        cmp.set("v.searchKeyword", selectedRecord.label);
        cmp.set("v.selectedRecord", selectedRecord.value);
        cmp.set("v.toggleInputs", false);
        cmp.find("dropDownListAI").set("v.isTrue", false);
    },

    onfocus: function (cmp, event, helper) {
        var searchKeyword = cmp.get("v.searchKeyword");
        if (!$A.util.isEmpty(searchKeyword)) {
            var comboboxRecords = cmp.get("v.comboboxRecords");
            var filteredComboboxRecords = [];
            for (var i in comboboxRecords) {
                if (searchKeyword == "Select") {
                    filteredComboboxRecords.push({
                        "selected": false,
                        "label": comboboxRecords[i].label,
                        "value": comboboxRecords[i].value
                    });
                } else if (comboboxRecords[i].label.toLowerCase().startsWith(searchKeyword.toLowerCase())) {
                    filteredComboboxRecords.push({
                        "selected": comboboxRecords[i].label.toLowerCase() == searchKeyword.toLowerCase() ? true : false,
                        "label": comboboxRecords[i].label,
                        "value": comboboxRecords[i].value
                    });
                }
            }
            filteredComboboxRecords.unshift({
                "selected": false,
                "value": "Select",
                "label": "Select"
            });
            cmp.set("v.filteredComboboxRecords", filteredComboboxRecords);
            if (searchKeyword != "Select") {
                helper.setUnderLine(cmp, searchKeyword);
            } else {
                cmp.set("v.searchKeyword", "");
            }
        }
        cmp.find("dropDownListAI").set("v.isTrue", true);
    },

    onblur: function (cmp, event) {
        // wait time to avoid conflict with populateSelectedValue function
        if (cmp.get("v.searchKeyword") == "") {
            cmp.set("v.searchKeyword", "Select")
        }
        window.setTimeout(
            $A.getCallback(function () {
                cmp.find("dropDownListAI").set("v.isTrue", false);
                var searchKeyword = cmp.get("v.searchKeyword");
                var comboboxRecords = cmp.get("v.comboboxRecords");
                var comboboxFieldCmp = cmp.find("comboboxFieldAI");
                var comboboxRecordsLabelsSet = cmp.get("v.comboboxRecordsLabelsSet");
                if (comboboxRecordsLabelsSet.has(searchKeyword) == -1 && searchKeyword != "Select") {
                    cmp.set("v.notSelectedFromList", true);
                    comboboxFieldCmp.setCustomValidity("Please select value from list");
                } else {
                    cmp.set("v.notSelectedFromList", false);
                    comboboxFieldCmp.setCustomValidity("");
                }
                comboboxFieldCmp.reportValidity();
            }), 300
        );
    },

    onchange: function (cmp, event, helper) {
        var searchKeyword = cmp.get("v.searchKeyword");
        var comboboxRecords = cmp.get("v.comboboxRecords");
        var filteredComboboxRecords = [];
        for (var i in comboboxRecords) {
            if (comboboxRecords[i].label.toLowerCase().includes(searchKeyword.toLowerCase())) {
                filteredComboboxRecords.push({
                    "selected": false,
                    "label": comboboxRecords[i].label,
                    "value": comboboxRecords[i].value
                });
            }
        }
        filteredComboboxRecords.unshift({
            "selected": false,
            "label": "Select",
            "value": "Select"
        });
        cmp.set("v.filteredComboboxRecords", filteredComboboxRecords);
        if (searchKeyword != "Select") {
            helper.setUnderLine(cmp, searchKeyword);
        }
    },

    refreshField: function (cmp, event, helper) {
        cmp.set("v.searchKeyword", "Select");
    },


})