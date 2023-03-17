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
        action.setParams({
            objectName: cmp.get("v.objectName"),
            searchFieldName: cmp.get("v.searchFieldName"),
            orderBy: cmp.get("v.orderBy"),
            whereCondition:cmp.get("v.whereCondition")
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var responseData = response.getReturnValue();
                if (responseData.success) {
                    var comboboxRecords = responseData.comboboxRecords;
                    console.log('objectName'+cmp.get("v.objectName")+'searchFieldName'+cmp.get("v.searchFieldName")+'orderBy'+cmp.get("v.orderBy")+'whereCondition'+cmp.get("v.whereCondition"))
                    console.log('comboboxRecords',comboboxRecords)
                    cmp.set("v.comboboxRecords", comboboxRecords);
                    var filteredComboboxRecords = [];
                    //US2670819 - Provider Lookup - Fixes - Sravan - Start
                    if(!implementScrollFunc){
                        filteredComboboxRecords.unshift({
                            "selected": false,
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
                     console.log('comboboxRecords',comboboxRecords);
                    for (var i in comboboxRecords) {
                        //US2670819 - Provider Lookup - Fixes - Sravan - Start
                        if(!implementScrollFunc){
                            filteredComboboxRecords.push({
                                "selected": false,
                                "value": comboboxRecords[i]
                            });
                        }
                        else{
                            filteredComboboxRecords.push({
                                "label": comboboxRecords[i],
                                "value": comboboxRecords[i]
                            });

                        }
                        //US2670819 - Provider Lookup - Fixes - Sravan - End
                    }
                    /*//chandra US2904624 start
                    console.log('filteredComboboxRecords',filteredComboboxRecords);

                    if((!$A.util.isUndefinedOrNull(filteredComboboxRecords) && (!$A.util.isUndefinedOrNull(filteredComboboxRecords[1])) ) && (filteredComboboxRecords[1].value=='Paid Correctly, Pre-Appeal Reconsideration' || filteredComboboxRecords[1].value=='Stop Pay and Reissue'))
                    {
                        filteredComboboxRecords=filteredComboboxRecords[1];
                        cmp.set("v.searchKeyword", filteredComboboxRecords.value);
                        cmp.set("v.selectedRecord", filteredComboboxRecords.value);
                        cmp.set("v.toggleInputs", false);
                        cmp.find("dropDownListAI").set("v.isTrue", false);
                        cmp.set("v.isValueSelected",!cmp.get("v.isValueSelected"));
                    }//chandra US2904624 end*/
                    var filteredComboboxRecordsAll=[];
                    for(var i in filteredComboboxRecords){
                        if(filteredComboboxRecords[i].value !="All"){
                            filteredComboboxRecordsAll.push(filteredComboboxRecords[i]);
                        }
                    }
                    cmp.set("v.filteredComboboxRecords", filteredComboboxRecordsAll);

                    console.log('Como Records'+ JSON.stringify(filteredComboboxRecords) );
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