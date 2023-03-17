({
    setUnderLine: function (cmp, searchKeyword) {
        var timer = cmp.get('v.timer');
        clearTimeout(timer);
        var timer = setTimeout(function () {
            var comboboxValueElement = cmp.find("comboboxValueAI");
            if (Array.isArray(comboboxValueElement)) {
                for (var i in comboboxValueElement) {
                    var str = comboboxValueElement[i].getElement().innerHTML;
                    if (searchKeyword == "") {
                        break;
                    } else if (str != "Select") {
                        var index = str.toLowerCase().indexOf(searchKeyword.toLowerCase());
                        var strWithUnderline = "";
                        if (index == -1) {
                            strWithUnderline = str;
                        } else {
                            strWithUnderline = str.substr(0, index) + "<u><b>" + str.substr(index, searchKeyword.length) + "</u></b>" + str.substr(index + searchKeyword.length, str.length - 1);
                        }
                        comboboxValueElement[i].getElement().innerHTML = strWithUnderline;
                    }
                }
                clearTimeout(timer);
                cmp.set('v.timer', null);
            }

        }, 300);
        cmp.set('v.timer', timer);
    },

    getComboboxRecords: function (cmp) {
       //US2670819 - Provider Lookup - Fixes - Sravan - Start
       var implementScrollFunc = cmp.get("v.implementScrollFunc");
       if(!implementScrollFunc){
        cmp.find("comboboxFieldAI").set("v.isLoading", true);
       }

       //US2670819 - Provider Lookup - Fixes - Sravan - End
        cmp.set("v.errorMessage", null);
        var action = cmp.get("c.getComboboxRecords");
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var responseData = response.getReturnValue();
                if (responseData.success) {
                    var comboboxRecords = responseData.comboboxRecords;
                    cmp.set("v.comboboxRecords", comboboxRecords);
                    var filteredComboboxRecords = [];
                    //US2670819 - Provider Lookup - Fixes - Sravan - Start
                    if(!implementScrollFunc){
                    filteredComboboxRecords.unshift({
                        "selected": false,
                        "label": "Select",
                        "value": "Select"
                    });
                    }
                    else{
                        filteredComboboxRecords.unshift({
                            "label": "--None--",
                            "value": "Select"
                        });

                    }
                    //US2670819 - Provider Lookup - Fixes - Sravan - End
                    var comboboxRecordsLabelsSet = new Set();
                    for (var i in comboboxRecords) {
                        //US2670819 - Provider Lookup - Fixes - Sravan - Start
                        if(!implementScrollFunc){
                        filteredComboboxRecords.push({
                            "selected": false,
                            "label": comboboxRecords[i].label,
                            "value": comboboxRecords[i].value
                        });
                        }
                        else{
                            filteredComboboxRecords.push({
                                "label": comboboxRecords[i].label,
                                "value": comboboxRecords[i].value
                             });

                        }
                        //US2670819 - Provider Lookup - Fixes - Sravan - End

                        comboboxRecordsLabelsSet.add(comboboxRecords[i].label);
                    }
                    cmp.set("v.filteredComboboxRecords", filteredComboboxRecords);
                    cmp.set("v.comboboxRecordsLabelsSet", comboboxRecordsLabelsSet);
                }
            } else if (state === "ERROR") {
                cmp.set("v.errorMessage", "Something went wrong please refresh page and try again.");
            }
            //US2670819 - Provider Lookup - Fixes - Sravan - Start
            if(!implementScrollFunc){
            cmp.find("comboboxFieldAI").set("v.isLoading", false);

            }
            //US2670819 - Provider Lookup - Fixes - Sravan - End
        });
        $A.enqueueAction(action);
    },
   
})