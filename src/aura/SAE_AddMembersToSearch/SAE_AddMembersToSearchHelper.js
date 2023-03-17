({
	copyTextHelper : function(component,event,text) {
        debugger;
        // Create an hidden input
        var hiddenInput = document.createElement("input");
        // passed text into the input
        hiddenInput.setAttribute("value", text);
        // Append the hiddenInput input to the body
        document.body.appendChild(hiddenInput);
        // select the content
        hiddenInput.select();
        // Execute the copy command
        document.execCommand("copy");
        // Remove the input from the body after copy text
        document.body.removeChild(hiddenInput); 
        // store target button label value
        var orignalLabel = event.getSource().get("v.label");
        // change button icon after copy text
        //event.getSource().set("v.iconName" , 'utility:check');
        // change button label with 'copied' after copy text 
        event.getSource().set("v.label" , 'copied');
        
        // set timeout to reset icon and label value after 700 milliseconds 
        setTimeout(function(){ 
            //event.getSource().set("v.iconName" , 'utility:copy_to_clipboard'); 
            event.getSource().set("v.label" , orignalLabel);
        }, 700);
        
    },
	
    showMemberSpinner: function (component) {
        var spinner = component.find("memberSearchIO-spinner");
        $A.util.removeClass(spinner, "slds-hide");
        $A.util.addClass(spinner, "slds-show");
    },
    hideMemberSpinner: function (component) {
        var spinner = component.find("memberSearchIO-spinner");
        $A.util.removeClass(spinner, "slds-show");
        $A.util.addClass(spinner, "slds-hide");
    },
    getStateValuesMDT: function(component,event) {
        var action = component.get('c.getStateValues');
        action.setCallback(this, function(actionResult) {

            var opts = [];
            for(var i=0;i<actionResult.getReturnValue().length;i++){
                opts.push({
                    label:actionResult.getReturnValue()[i].DeveloperName,
                    value:actionResult.getReturnValue()[i].DeveloperName
                });
            }
            //US1797978 - Malinda
            opts.unshift({label:'--None--',value:''});
            component.set('v.options',opts);
        });
        $A.enqueueAction(action);
    },
    /* US2076569 Avish */
    verifyDuplicateMember:function (cmp, event, cardNo,helper) {
        var addMembers = cmp.get('v.addMembers');
        var searchDetails = addMembers[cardNo];
        var uniqueMembersList = cmp.get("v.uniqueMembersList");
        var memberDOB;
        var compareToDOB;
        if(!$A.util.isEmpty(searchDetails.dob)){
            var tempDOB = searchDetails.dob.split('-');
            memberDOB = tempDOB[1] + '/' + tempDOB[2] + '/' + tempDOB[0];
            memberDOB = helper.formatDateMMDDYYYY(cmp,memberDOB.split('/'));
        }
        for (var i=0;i <uniqueMembersList.length;i++) {
            if(searchDetails.showAdvance){
                var alreadySearchedMemberArray = uniqueMembersList[i].split(";");
                compareToDOB = helper.formatDateMMDDYYYY(cmp,alreadySearchedMemberArray[3].split('/'));
                if (cmp.get("v.providerUniqueId") == alreadySearchedMemberArray[0] &&
                   ((searchDetails.firstName.toUpperCase() + " " + searchDetails.lastName.toUpperCase()) ==  alreadySearchedMemberArray[2].toUpperCase()) &&
                   memberDOB == compareToDOB){
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Information!",
                        "message": "Member was already searched.",
                        "type": "warning"
                    });
                    toastEvent.fire();
                    return true;
                }
            }else{
                if(i != undefined){
                    var alreadySearchedMemberArray = uniqueMembersList[i].split(";");
                    var checkHyphen;
                    if(alreadySearchedMemberArray[3].indexOf('-') != -1){
                        var mnfDOB = alreadySearchedMemberArray[3].split('/');
                        checkHyphen = mnfDOB[1] + '/' + mnfDOB[2] + '/' + mnfDOB[0];
                        compareToDOB = helper.formatDateMMDDYYYY(cmp,checkHyphen.split('/'));
                    }else{
                        compareToDOB = helper.formatDateMMDDYYYY(cmp,alreadySearchedMemberArray[3].split('/'));
                    }
                    var isOtherSearch = cmp.get("v.isOtherSearch");
                    if(isOtherSearch){
                        if (((searchDetails.memberName == alreadySearchedMemberArray[1]) && (memberDOB == compareToDOB))) {
                            var toastEvent = $A.get("e.force:showToast");
                            toastEvent.setParams({
                                "title": "Information!",
                                "message": "Member was already searched.",
                                "type": "warning"
                            });
                            toastEvent.fire();
                            return true;
                        }
                    }else{
                        if (cmp.get("v.providerUniqueId") == alreadySearchedMemberArray[0] &&
                            ((searchDetails.memberName == alreadySearchedMemberArray[1]) && (memberDOB == compareToDOB))) {
                            var toastEvent = $A.get("e.force:showToast");
                            toastEvent.setParams({
                                "title": "Information!",
                                "message": "Member was already searched.",
                                "type": "warning"
                            });
                            toastEvent.fire();
                            return true;
                        }
                    }

                }

            }

        }
    },
    /* US2076569 Ends */
    checkDuplicateMember: function (cmp, event, memberId, memberFirstName, memberLastName, memberDOB) {
        //mm
        // check member uniqueness
        //var searchedMemberArray = searchedMember.split(";");
        var uniqueMembersList = cmp.get("v.uniqueMembersList");
        for (var i of uniqueMembersList) {
            if(i != undefined){
                var alreadySearchedMemberArray = i.split(";");

                if ((cmp.get("v.providerUniqueId") == alreadySearchedMemberArray[0]) &&
                    (memberId == alreadySearchedMemberArray[1] || ((memberFirstName.toLowerCase() + " " + memberLastName.toLowerCase() == alreadySearchedMemberArray[2].toLowerCase()) && memberDOB == alreadySearchedMemberArray[3]))) {
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Information!",
                        "message": "Member was already searched.",
                        "type": "warning"
                    });
                    toastEvent.fire();
                    return true;
                }
            }
        }
        return false;
        //mm
    },

    fireToast: function(message){
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "Error!",
            "message": message,
            "type" : "error",
            "mode" : "sticky"
        });
        toastEvent.fire();
    },
    navigateToMNFSubjectCard: function (cmp, event, helper,cardNo) {

        var addMembers = cmp.get('v.addMembers');
        var searchDetails = addMembers[cardNo];
        //searchDetails.mnfSubjectCard = true;
        //
        var addMembers = cmp.get('v.addMembers');
        if (!$A.util.isEmpty(searchDetails.phone)) {
            var mnfPhoneNumber = searchDetails.phone;
            // US1895326   Added by Avish on 07/04/2019
            var mnfPhoneFormat;
            if(mnfPhoneNumber.length == 10){
                mnfPhoneFormat = mnfPhoneNumber.substring(0, 3) + '-' + mnfPhoneNumber.substring(3, 6) + '-' + mnfPhoneNumber.substring(6, 10);
                //Ends US1895326
                searchDetails.phoneAfterUpdate = mnfPhoneFormat;
            }
        }

        // US2021743 - Thanish - 3rd October 2019
        var dob = searchDetails.dob;
        if(!$A.util.isEmpty(dob)){
            if(dob.includes('-')){ //DE321672 - Avish
                dob = dob.split("-");
                searchDetails.dob = dob[1] + "/" + dob[2] + "/" + dob[0];
            }
        }
        // End of Code - US2021743 - Thanish - 3rd October 2019

        var mandatoryFieldCmp = "";
        var validationCounter = 0;

        if (addMembers[cardNo].mnfCheckBox && addMembers[cardNo].showAdvance) {
            var mandatoryFields = ["memFirstNameId", "memLastNameId", "phoneId","stateMemId"];
            var isAllValid = helper.validateAllFields(cmp, event, mandatoryFields, cardNo);
            if(isAllValid){

                if ((!$A.util.isEmpty(addMembers[cardNo].firstName) || !$A.util.isEmpty(addMembers[cardNo].lastName))) {
                    var mandatoryFieldsFNLN = ["memFirstNameId", "memLastNameId"];
                    var isAllValidFNLN = helper.validateFNLN(cmp, mandatoryFieldsFNLN, event, cardNo);
                    if(isAllValidFNLN){
                        validationCounter = 0;
                    }else{
                        validationCounter++;
                    }
                }

                validationCounter = 0;
            }else{
                validationCounter++;
            }
            if (validationCounter == 0) {

                addMembers[cardNo].mnfSubjectCard = true;
                addMembers[cardNo].showCard = true; //fixed by Avish on 08/23/2019 as a part of regression
                addMembers[cardNo].addMemberCard = false;
                addMembers[cardNo].showAdvance = false;

                cmp.set('v.addMembers', addMembers);
                //US1889740 - Sarma (Date: 6th Aug 2019) - Misdirect Case creation : Enabling MMS during MNF flow
        		cmp.set('v.isMms', true);
            }
        }
    },

    validateAllFields: function (cmp, event, mandatoryFields, cardNo) {
        debugger;
        var validationSuccess = false;
        var mandatoryFieldCmp = "";
        var validationCounter = 0;
        var addMembers = cmp.get('v.addMembers');
        addMembers[cardNo].mapError = [];
        for (var i in mandatoryFields) {
            mandatoryFieldCmp = cmp.find(mandatoryFields[i]);
            if (!$A.util.isUndefined(mandatoryFieldCmp)) {
                if (!Array.isArray(mandatoryFieldCmp)) {
                    console.log('labelName@@@ ' + mandatoryFieldCmp.get("v.label"));
                    if (!mandatoryFieldCmp.checkValidity()) {
                        validationCounter++;
                        addMembers[cardNo].mapError.push({key: mandatoryFieldCmp.getLocalId(), value: mandatoryFieldCmp.get('v.label')});
                        addMembers[cardNo].fieldValidationFlag = true;
                        cmp.set('v.addMembers', addMembers);
                    }
                    mandatoryFieldCmp.reportValidity();
                } else {
                    for (var i in mandatoryFieldCmp) {
                        if (!mandatoryFieldCmp[i].checkValidity() && mandatoryFieldCmp[i].get("v.name") == cardNo) {
                            if (!mandatoryFieldCmp[i].checkValidity()) {
                                validationCounter++;
                                addMembers[cardNo].mapError.push({key: mandatoryFieldCmp[i].getLocalId(), value: mandatoryFieldCmp[i].get('v.label')});
                                addMembers[cardNo].fieldValidationFlag = true;
                                cmp.set('v.addMembers', addMembers);
                            }
                            mandatoryFieldCmp[i].reportValidity();
                        }
                    }
                }
            }
        }
        if(validationCounter == 0){
            validationSuccess = true;
            addMembers[cardNo].fieldValidationFlag = false;
            cmp.set('v.addMembers', addMembers);
        }
        return validationSuccess;
    },
    validateFNLN: function (cmp, mandatoryFields, event,cardNo) {
        debugger;
        var validationSuccess = false;
        var mandatoryFieldCmp = "";
        var validationCounter = 0;
        for (var i in mandatoryFields) {
            mandatoryFieldCmp = cmp.find(mandatoryFields[i]);
            if (!$A.util.isUndefined(mandatoryFieldCmp)) {
                if (!Array.isArray(mandatoryFieldCmp)) {
                    if(mandatoryFieldCmp.get("v.label") == 'First Name'){
                        var charString = mandatoryFieldCmp.get("v.value");
                        var lastchar = charString[charString.length - 1];
                        if (lastchar == "*" && charString.length < 3){
                            validationCounter++;
                            mandatoryFieldCmp.setCustomValidity("Enter at least two character followed by an asterisk, and no character after the asterisk, in order to perform a wildcard search on the first name field (example: ab*)");
                            mandatoryFieldCmp.reportValidity();
                        }else if(charString.includes("*") && lastchar != "*" && charString.length >= 3){
                            validationCounter++;
                            mandatoryFieldCmp.setCustomValidity("Enter at least two character followed by an asterisk, and no character after the asterisk, in order to perform a wildcard search on the first name field (example: ab*)");
                            mandatoryFieldCmp.reportValidity();
                        }else{
                            mandatoryFieldCmp.setCustomValidity("");
                            mandatoryFieldCmp.reportValidity();
                        }
                    }else if(mandatoryFieldCmp.get("v.label") == 'Last Name'){
                        var charString = mandatoryFieldCmp.get("v.value");
                        var lastchar = charString[charString.length - 1];
                        if (lastchar == "*" && charString.length < 4){
                            validationCounter++;
                            mandatoryFieldCmp.setCustomValidity("Enter at least three characters followed by an asterisk, and no character after the asterisk, in order to perform a wildcard search on the last name field (example: abc*)");
                            mandatoryFieldCmp.reportValidity();
                        }else if(charString.includes("*") && lastchar != "*" && charString.length >= 4){
                            validationCounter++;
                            mandatoryFieldCmp.setCustomValidity("Enter at least three characters followed by an asterisk, and no character after the asterisk, in order to perform a wildcard search on the last name field (example: abc*)");
                            mandatoryFieldCmp.reportValidity();
                        }else{
                            mandatoryFieldCmp.setCustomValidity("");
                            mandatoryFieldCmp.reportValidity();
                        }
                    }
                }else{
                    for (var i in mandatoryFieldCmp) {
                        if (mandatoryFieldCmp[i].get("v.name") == cardNo) {
                            if(mandatoryFieldCmp[i].get("v.label") == 'First Name'){
                                var charString = mandatoryFieldCmp[i].get("v.value");
                                var lastchar = charString[charString.length - 1];
                                if (lastchar == "*" && charString.length < 3){
                                    validationCounter++;
                                    mandatoryFieldCmp[i].setCustomValidity("Enter at least two character followed by an asterisk, and no character after the asterisk, in order to perform a wildcard search on the first name field (example: ab*)");
                                    mandatoryFieldCmp[i].reportValidity();
                                }else if(charString.includes("*") && lastchar != "*" && charString.length >= 3){
                                    mandatoryFieldCmp[i].setCustomValidity("Enter at least two character followed by an asterisk, and no character after the asterisk, in order to perform a wildcard search on the first name field (example: ab*)");
                                    mandatoryFieldCmp[i].reportValidity();
                                    validationCounter++;
                                }else{
                                    mandatoryFieldCmp[i].setCustomValidity("");
                                    mandatoryFieldCmp[i].reportValidity();
                                }
                            }else if(mandatoryFieldCmp[i].get("v.label") == 'Last Name'){
                                var charString = mandatoryFieldCmp[i].get("v.value");
                                var lastchar = charString[charString.length - 1];
                                if (lastchar == "*" && charString.length < 4){
                                    validationCounter++;
                                    mandatoryFieldCmp[i].setCustomValidity("Enter at least three characters followed by an asterisk, and no character after the asterisk, in order to perform a wildcard search on the last name field (example: abc*)");
                                    mandatoryFieldCmp[i].reportValidity();
                                }else if(charString.includes("*") && lastchar != "*" && charString.length >= 4){
                                    mandatoryFieldCmp[i].setCustomValidity("Enter at least three characters followed by an asterisk, and no character after the asterisk, in order to perform a wildcard search on the last name field (example: abc*)");
                                    mandatoryFieldCmp[i].reportValidity();
                                    validationCounter++;
                                }else{
                                    mandatoryFieldCmp[i].setCustomValidity("");
                                    mandatoryFieldCmp[i].reportValidity();
                                }
                            }
                        }
                    }
                }
            }
        }

        if(validationCounter == 0){
            validationSuccess = true;
        }
        return validationSuccess;
    },

    fireToastMessage: function (title, message, type, mode, duration) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": title,
            "message": message,
            "type": type,
            "mode": mode,
            "duration": duration
        });
        toastEvent.fire();
    },
    clearFieldValues: function (cmp, event,srcName) {

        var addMembers = cmp.get('v.addMembers');
        var openedCardsCount = cmp.get('v.addMembers');
        var memberNameCmp = "";
        var todayDate = $A.localizationService.formatDate(new Date(), "YYYY-MM-DD");

        memberNameCmp = cmp.find("memberId");
        var dateCmp = cmp.find("inputDOB");

        addMembers[srcName].showAdvance = false;
        addMembers[srcName].mnfCheckBox = false;
        addMembers[srcName].firstName = "";
        addMembers[srcName].memberName = "";
        addMembers[srcName].dob = null;
        addMembers[srcName].lastName = "";
        addMembers[srcName].state = "";
        addMembers[srcName].phone = "";
        addMembers[srcName].mnf = "";
        addMembers[srcName].groupNumber = '';
        addMembers[srcName].zip = '';
        addMembers[srcName].validationFlag = false;
        addMembers[srcName].fieldValidationFlag = false;
        addMembers[srcName].mapError = null;
        addMembers[srcName].combiErrorMsg = false;
        addMembers[srcName].isMultipleMemberResponse = false;
        addMembers[srcName].multipleMemberResponses = [];
        $A.util.removeClass(addMembers[srcName], "slds-has-error");
        $A.util.removeClass(addMembers[srcName], "hide-error-message");
        $A.util.removeClass(addMembers[srcName], "slds-form-element__help");
        cmp.set('v.addMembers', addMembers);
    },
    clearFieldValidations: function (cmp, mandatoryFields, event,cardNo) {
        debugger;
        var mandatoryFieldCmp = "";
        for (var i in mandatoryFields) {
            mandatoryFieldCmp = cmp.find(mandatoryFields[i]);
            if (!$A.util.isUndefined(mandatoryFieldCmp)) {
                if (!Array.isArray(mandatoryFieldCmp)) {
                    if (mandatoryFieldCmp.get("v.type") == "date") {
                        if ($A.util.isEmpty(mandatoryFieldCmp.get("v.value"))) {
                            mandatoryFieldCmp.set("v.value", $A.localizationService.formatDate(new Date(), "YYYY-MM-DD"));
                            mandatoryFieldCmp.setCustomValidity("");
                            mandatoryFieldCmp.reportValidity();
                            mandatoryFieldCmp.set("v.value", null);
                        }
                    } else {
                        mandatoryFieldCmp.set("v.value", "1");
                        mandatoryFieldCmp.setCustomValidity("");
                        mandatoryFieldCmp.reportValidity();
                        mandatoryFieldCmp.set("v.value", null);
                    }
                }else{
                    for (var i in mandatoryFieldCmp) {
                        if (mandatoryFieldCmp[i].get("v.name") == cardNo) {
                            if (mandatoryFieldCmp[i].get("v.type") == "date") {
                                if ($A.util.isEmpty(mandatoryFieldCmp[i].get("v.value"))) {
                                    mandatoryFieldCmp[i].set("v.value", $A.localizationService.formatDate(new Date(), "YYYY-MM-DD"));
                                    mandatoryFieldCmp[i].setCustomValidity("");
                                    mandatoryFieldCmp[i].reportValidity();
                                    mandatoryFieldCmp[i].set("v.value", null);
                                    $A.util.removeClass(mandatoryFieldCmp[i], "slds-has-error");
                                    $A.util.removeClass(mandatoryFieldCmp[i], "show-error-message");
                                    $A.util.removeClass(mandatoryFieldCmp[i], "slds-form-element__help");
                                }
                            } else {
                                mandatoryFieldCmp[i].set("v.value", "1");
                                mandatoryFieldCmp[i].setCustomValidity("");
                                mandatoryFieldCmp[i].reportValidity();
                                mandatoryFieldCmp[i].set("v.value", null);
                                $A.util.removeClass(mandatoryFieldCmp[i], "slds-has-error");
                                $A.util.removeClass(mandatoryFieldCmp[i], "show-error-message");
                                $A.util.removeClass(mandatoryFieldCmp[i], "slds-form-element__help");
                            }
                        }
                    }


                }
            }
        }
    },
    keepOnlyDigits: function (cmp, event,cardNo) {
        var regEx = /[^0-9 ]/g;
        var addMembers = cmp.get('v.addMembers');
        var searchDetails = addMembers[cardNo];
        //var fieldValue = event.getSource().get("v.value");
        var fieldValue = searchDetails.zip;

        if (fieldValue.match(regEx)) {
            event.getSource().set("v.value", fieldValue.replace(regEx, ''));
        }
    },

    checkIfNotNumberPhone: function (cmp, event,cardNo) {
        var regEx = /[^0-9 ]/g;
        var addMembers = cmp.get('v.addMembers');
        var searchDetails = addMembers[cardNo];
        //var fieldValue = event.getSource().get("v.value");
        var fieldValue = searchDetails.phone;

        if (fieldValue.match(regEx)) {
            event.getSource().set("v.value", fieldValue.replace(regEx, ''));
        }
    },

    checkIfNotNumberMember: function (cmp, event,cardNo) {
        var regEx = /[^a-zA-Z0-9 ]/g;
        var addMembers = cmp.get('v.addMembers');
        var searchDetails = addMembers[cardNo];
        var fieldValue = searchDetails.memberName;

        if (fieldValue.match(regEx)) {
            event.getSource().set("v.value", fieldValue.replace(regEx, ''));
        }
    },

    formatDateMMDDYYYY: function(cmp,dobToFormat){
        var dobMM;
        var dobDD;
        var dob;
        //ADD A NULL CHECK
        if(dobToFormat[0] != undefined && dobToFormat[0].length > 0 && dobToFormat[0].charAt(0) == '0'){
            dobMM = dobToFormat[0];
        }else{
            dobMM = dobToFormat[0];
        }

        if(dobToFormat[1] != undefined && dobToFormat[1].length > 0 && dobToFormat[1].charAt(0) == '0'){
            dobDD = dobToFormat[1];
        }else{
            dobDD = dobToFormat[1];
        }
        dob = dobMM + '/' + dobDD + '/' + dobToFormat[2];
        return dob;
    }

})