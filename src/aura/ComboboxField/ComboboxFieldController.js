({
    doInit: function (cmp, event, helper) {
        helper.getComboboxRecords(cmp);
    },
    
    checkValidation :function (cmp,event){
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
        console.log('filteredComboboxRecordsooooooo',filteredComboboxRecords);
        var selectedRecord = filteredComboboxRecords[selectedIndex];
        cmp.set("v.searchKeyword", selectedRecord.value);
        cmp.set("v.selectedRecord", selectedRecord.value);
        cmp.set("v.toggleInputs", false);
        cmp.find("dropDownListAI").set("v.isTrue", false);
        //US2883416 - Change Functionality on Routing Screen - Sravan - Start
        //chandra-start
        // if((cmp.get('v.subTypeVal')!= 'Paid Correctly, Pre-Appeal Reconsideration') && (cmp.get('v.subTypeVal')!='Stop Pay and Reissue'))
             cmp.set("v.isValueSelected",!cmp.get("v.isValueSelected"));

        //chandra-End
		//US2883416 - Change Functionality on Routing Screen - Sravan - End
    },

    /* onblur: function (cmp, event, helper) {
        var searchKeyword = cmp.get("v.searchKeyword");
        if (!$A.util.isEmpty(searchKeyword) && searchKeyword == "Select") {
            var fieldElement = cmp.find("comboboxFieldAI");
            fieldElement.setCustomValidity("Enter Value");
            fieldElement.reportValidity();
        }
    }, */

    onfocus: function (cmp, event, helper) {
        var searchKeyword = cmp.get("v.searchKeyword");

        if (!$A.util.isEmpty(searchKeyword)) {
            var comboboxRecords = cmp.get("v.comboboxRecords");
            var filteredComboboxRecords = [];
            for (var i in comboboxRecords) {
                if (searchKeyword == "Select") {
                    filteredComboboxRecords.push({
                        "selected": false,
                        "value": comboboxRecords[i]
                    });
                } else if (comboboxRecords[i].toLowerCase().startsWith(searchKeyword.toLowerCase())) {
                    filteredComboboxRecords.push({
                        "selected": comboboxRecords[i].toLowerCase() == searchKeyword.toLowerCase() ? true : false,
                        "value": comboboxRecords[i]
                    });
                }
            }
            filteredComboboxRecords.unshift({
                "selected": false,
                "value": "Select"
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
            /* var fieldElement = cmp.find("comboboxFieldAI");
            fieldElement.setCustomValidity("Enter Value");
            fieldElement.reportValidity(); */
        }
        window.setTimeout(
            $A.getCallback(function () {
                if(!$A.util.isEmpty(cmp.find("dropDownListAI"))){
                    cmp.find("dropDownListAI").set("v.isTrue", false);
                    var searchKeyword = cmp.get("v.searchKeyword");
                    var comboboxRecords = cmp.get("v.comboboxRecords");
                    var comboboxFieldCmp = cmp.find("comboboxFieldAI");
                    if (comboboxRecords.indexOf(searchKeyword) == -1 && searchKeyword != "Select") {
                        cmp.set("v.notSelectedFromList", true);
                        comboboxFieldCmp.setCustomValidity("Please select value from list");
                    } else {
                        cmp.set("v.notSelectedFromList", false);
                        comboboxFieldCmp.setCustomValidity("");
                        var cmpEvent = cmp.getEvent("ACET_CreateAuthGridValChange");
                        cmpEvent.setParams({
                            "selectedValue" : searchKeyword
                        });
                        cmpEvent.fire();
                    }
                    comboboxFieldCmp.reportValidity();
                }
            }), 300
        );
    },
  validation : function(cmp, event, helper) {
    var comboboxFieldAI=cmp.find("comboboxFieldAI");
    var showError=cmp.get("v.showError");
         if(comboboxFieldAI.get('v.value')=="Select" && !showError ){
                comboboxFieldAI.setCustomValidity("This field is required");
             }
          else{
          comboboxFieldAI.setCustomValidity(" ");
          comboboxFieldAI.setCustomValidity("");
        }
          comboboxFieldAI.reportValidity();
    },
   stopValidation: function(cmp, event, helper) {
     var comboboxFieldAI=cmp.find("comboboxFieldAI");
         if(comboboxFieldAI.get('v.value')=="Select"){
                comboboxFieldAI.setCustomValidity(" ");
                comboboxFieldAI.setCustomValidity("");
                comboboxFieldAI.reportValidity();
      }
    },
    stopError: function(cmp, event, helper) {
     var comboboxFieldAI=cmp.find("comboboxFieldAI");
         if(comboboxFieldAI.get('v.value')!="Select"){
                comboboxFieldAI.setCustomValidity(" ");
                comboboxFieldAI.setCustomValidity("");
                comboboxFieldAI.reportValidity();
      }
    },
    onchange: function (cmp, event, helper) {
        var searchKeyword = cmp.get("v.searchKeyword");

        /*if (searchKeyword.includes("Select")) {
            searchKeyword = searchKeyword.charAt(searchKeyword.length - 1) == "t" ? "" : searchKeyword.charAt(searchKeyword.length - 1);
            cmp.set("v.searchKeyword", searchKeyword);
        }*/
        var comboboxRecords = cmp.get("v.comboboxRecords");
        var filteredComboboxRecords = [];
        for (var i in comboboxRecords) {
            if (comboboxRecords[i].toLowerCase().includes(searchKeyword.toLowerCase())) {
                filteredComboboxRecords.push({
                    "selected": false,
                    "value": comboboxRecords[i]
                });
            }
        }
        filteredComboboxRecords.unshift({
            "selected": false,
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

    //US2883416 - Change Functionality on Routing Screen - Sravan
    reload : function(component, event, helper){
        helper.getComboboxRecords(component);
    },

    updateSelecetedValue : function(cmp, event, helper) {
        let strSelectedValue, params;
        try{
            params = event.getParam('arguments');
            if(params) {
                strSelectedValue = params.strVal;
                cmp.set("v.searchKeyword", strSelectedValue);
                window.setTimeout(
                    $A.getCallback(function () {
                        if(!$A.util.isEmpty(cmp.find("dropDownListAI"))){
                            cmp.find("dropDownListAI").set("v.isTrue", false);
                            var searchKeyword = cmp.get("v.searchKeyword");
                            var comboboxRecords = cmp.get("v.comboboxRecords");
                            var comboboxFieldCmp = cmp.find("comboboxFieldAI");
                            if (comboboxRecords.indexOf(searchKeyword) == -1 && searchKeyword != "Select") {
                                cmp.set("v.notSelectedFromList", true);
                                comboboxFieldCmp.setCustomValidity("Please select value from list");
                            } else {
                                cmp.set("v.notSelectedFromList", false);
                                comboboxFieldCmp.setCustomValidity("");
                            }
                            comboboxFieldCmp.reportValidity();
                        }
                    }), 300
                );
            }
        } catch(exception) {

        }
    },

    callGetComboBoxRecords : function(component,event, helper) {
        helper.getComboboxRecords(component);
    }



})