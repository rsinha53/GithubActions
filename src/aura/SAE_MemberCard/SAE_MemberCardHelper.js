({
    showMemberSpinner: function (component) {
        var spinner = component.find("memberSearch-spinner");
        $A.util.removeClass(spinner, "slds-hide");
        $A.util.addClass(spinner, "slds-show");
    },
    hideMemberSpinner: function (component) {
        var spinner = component.find("memberSearch-spinner");
        $A.util.removeClass(spinner, "slds-show");
        $A.util.addClass(spinner, "slds-hide");
    },
	searchResMembers: function (component, event, helper) {

        var action = component.get('c.searchMembers');
        //Added by Avish as a part US2070352
        component.set("v.searchMemberResults",'');
        component.set("v.responseData",'');
        //US2070352 Ends
        var inputMemberId = component.find('memberId');
        var memberIdVal = inputMemberId.get('v.value');

        var inputMemberDOB = component.find('inputDOB');
        var memberDOBVal = inputMemberDOB.get('v.value');

        var inputMemberFN = component.find('memFirstNameId');
        var memberFNVal = component.get('v.memFirstName'); //inputMemberFN.get('v.value');

        var inputMemberLN = component.find('memLastNameId');
        var memberLNVal = component.get('v.memLastName'); //inputMemberLN.get('v.value');

        var inputMemberGrpN = component.find('memGroupNumberId');
        var memberGrpNVal = component.get('v.groupNumber'); //inputMemberGrpN.get('v.value');

        //Added by Avish as a part US2070352
        if(memberIdVal != '' && $A.util.isEmpty(memberLNVal) && $A.util.isEmpty(memberLNVal) &&
           $A.util.isEmpty(memberGrpNVal) && (memberDOBVal == '' || memberDOBVal == null)){ //Added by Avish as a part US2070352 on 09/30/2019
            component.set("v.findIndividualWSFlag", true);
        }else{
            component.set("v.findIndividualWSFlag", false);
        }
        //US2070352 Ends

        var searchOptionVal = "";
        if (memberIdVal != '' && (!$A.util.isEmpty(memberFNVal)) && (!$A.util.isEmpty(memberLNVal)) && (!$A.util.isEmpty(memberGrpNVal)) && memberDOBVal != '') {
            searchOptionVal = 'MemberIDNameGroupNumberDateOfBirth';
        } else if (memberIdVal != '' && (!$A.util.isEmpty(memberFNVal)) && (!$A.util.isEmpty(memberLNVal)) && memberDOBVal != '') {
            searchOptionVal = 'MemberIDNameDateOfBirth';
        } else if (memberIdVal != '' && (!$A.util.isEmpty(memberFNVal)) && (!$A.util.isEmpty(memberLNVal))) {
            searchOptionVal = 'MemberIDName';
        } else if (memberIdVal != '' && (!$A.util.isEmpty(memberLNVal)) && memberDOBVal != '') {
            searchOptionVal = 'MemberIDLastNameDateOfBirth';
        } else if (memberIdVal != '' && (!$A.util.isEmpty(memberFNVal)) && memberDOBVal != '') {
            searchOptionVal = 'MemberIDFirstNameDateOfBirth';
        } else if ((!$A.util.isEmpty(memberFNVal)) && (!$A.util.isEmpty(memberLNVal)) && memberDOBVal != '') {
            searchOptionVal = 'NameDateOfBirth';
        } else if (memberIdVal != '' && memberDOBVal != '') {
            searchOptionVal = 'MemberIDDateOfBirth';
        }

        component.set("v.searchOptionVal", searchOptionVal);
       // var taxIdInput = component.find('taxID');
       // var taxIdVal = taxIdInput.get('v.value');
       // console.log('memberIdVal@@ ' + memberIdVal + ' >>taxIdVal>> ' + taxIdVal);
       /* action.setParams({
            "memberId": memberIdVal,
            "memberDOB": memberDOBVal,
            "firstName": memberFNVal,
            "lastName": memberLNVal,
            "groupNumber": memberGrpNVal,
            "searchOption": searchOptionVal
        });*/
        var providerDetails = component.get("v.providerDetails");
        var providerFlow = "";
        var isProviderSearchDisabled = component.get("v.isProviderSearchDisabled");
		var isOtherSearch  = component.get("v.isOtherSearch");
        var providerNotFound = component.get("v.providerNotFound");
        if (isProviderSearchDisabled) {
            providerFlow = "No Provider To Search";
        } else if (providerNotFound) {
            providerFlow = "Provider Not Found";
        } else if (isOtherSearch) {
            providerFlow = "Other";
        }
        component.set("v.providerFlow",providerFlow);
        // US1944108 - Accommodate Multiple Payer ID's - Kavinda: START
        var payerValue = component.get('v.payerValue');
        // US1944108 - Accommodate Multiple Payer ID's - Kavinda: END
        var memberDetails = {
            "memberId": memberIdVal,
            "memberDOB": memberDOBVal,
            "firstName": memberFNVal,
            "lastName": memberLNVal,
            "groupNumber": memberGrpNVal,
            "searchOption": searchOptionVal,
            "payerID":   payerValue, //"87726", US1944108 - Accommodate Multiple Payer ID's
            "providerLastName": isProviderSearchDisabled || providerNotFound || isOtherSearch? "" : providerDetails.lastName,
            "providerFirstName": isProviderSearchDisabled || providerNotFound || isOtherSearch ? "" : providerDetails.firstName,
            "npi": isProviderSearchDisabled || providerNotFound || isOtherSearch ? "" : providerDetails.npi,
            "providerFlow": providerFlow
        };
        var memberDetailsJSON = JSON.stringify(memberDetails);
        action.setParams({
            "memberDetails": memberDetailsJSON
        });

        action.setCallback(this, function (response) {

            var state = response.getState(); // get the response state
            if (state == 'SUCCESS') {
                var result = response.getReturnValue();
                 component.set("v.respStatusCode",result.statusCode);
                //console.log('##RESP:'+JSON.stringify(result));
                console.log('code?>>>> ' + result.statusCode);
                if (result.statusCode == 200) {
                    component.set("v.searchBtnFlag", true);
                    component.set("v.display", false);
                    component.set("v.checkFlagmeberCard",true); //Added By Avish on 07/25/2019
                    if(component.get("v.findIndividualWSFlag")){
                        component.set("v.display", true);
                        component.set("v.responseData", result.resultWrapper.lstSAEMemberStandaloneSearch);
                        component.set("v.responseDataOrg", result.resultWrapper.lstSAEMemberStandaloneSearch);
                        console.log('testing findIndividual....');
                        console.log(component.get("v.responseData"));
                        this.sendMemberDetails(component);
                    }else{
                        if (component.find('memberId').get('v.value') == '859690190') {
                            component.set("v.responseData", result.resultWrapper.memberProviderResultlst[0]);
                        } else {
                            component.set("v.responseData", result.resultWrapper.memberProviderResultlst);
                        }
                        component.set("v.interactionCard", result.resultWrapper.interactionView);
                        var subjectCard = result.resultWrapper.subjectCard;
                        subjectCard.searchOption = searchOptionVal;
                        // var memberDOBArray = memberDOBVal.split("-");
                        //subjectCard.memberDOB = memberDOBArray[1] + "/" + memberDOBArray[2] + "/" + memberDOBArray[0];
                        component.set("v.subjectCard", subjectCard);

                   		// DE282735 - Thanish - 29th Nov 2019 - Removed bug code.
                    }
					console.log('**********');
                    console.log(component.get("v.responseData"));
                    component.set("v.mnf", '');
                    if (component.get('v.responseData') == undefined) {
                        component.set('v.invalidResultFlag', true);
                    } else {
                        component.set('v.invalidResultFlag', false);
                    }
                    this.hideMemberSpinner(component);
                } else if (result.statusCode == 400 && (searchOptionVal == "NameDateOfBirth" || searchOptionVal == "MemberIDDateOfBirth")) {
                    //this.fireToastMessage("Error!", result.message, "dismissible", "5000");
                    this.hideMemberSpinner(component);
                    this.fireToastMessage("Error!", result.message.replace(". ", ". \n"), "error", "dismissible", "10000");
                } else if (result.statusCode == 404 ) {
                    //this.fireToastMessage("Error!", result.message, "dismissible", "5000");
                    this.hideMemberSpinner(component);
                    if(result.message != undefined){
                        this.fireToastMessage("Error!", result.message.replace(". ", ". \n"), "error", "dismissible", "10000");
                    }

                } else {
                    //var responseMsg = result.message;
                    //var jsonString = JSON.parse(responseMsg);
                    this.hideMemberSpinner(component);
                    component.set('v.showServiceErrors', true);
                    if (component.get("v.showHideMemAdvSearch") == true && component.get("v.displayMNFFlag") == true) {
                        component.set("v.mnf", 'mnf');
                        component.set("v.checkFlagmeberCard",false); //Added By Avish on 07/25/2019
                    }
                    //component.set('v.serviceMessage',jsonString.message);
                    // US1813580 - Error Message Translation
                    component.set('v.serviceMessage', result.message);
                    // If need
                    helper.fireToast(result.message,"10000");
                }
            }
        });
        $A.enqueueAction(action);
    },

    sendMemberDetails: function (cmp) {
        debugger;
        /* US2076569 Avish */
        var searchResults = cmp.get("v.responseData");
        var providerDetails = cmp.get('v.providerDetails');
        var providerUniqueId = '';
        var isProviderSearchDisabled = cmp.get("v.isProviderSearchDisabled");
        var isOtherSearch = cmp.get('v.isOtherSearch');

        if(searchResults.length > 0){
            if (isProviderSearchDisabled) {
                providerUniqueId = "No Provider To Search";
            } else if (isOtherSearch){
                providerUniqueId = "Other";
            } else if (!isProviderSearchDisabled){
                providerUniqueId = providerDetails.taxIdOrNPI;
            }
            /* US2076569 Avish */

            var appEvent = $A.get("e.c:SAE_ProviderSearchResultsEvent");
            appEvent.setParams({
                "providerResults": searchResults,
                "findIndividualFlag": cmp.get("v.findIndividualWSFlag"),
                "memberID" : cmp.find('memberId').get('v.value'),
                "flowType":"Member",
                "providerSearchFlag" : cmp.get('v.disableProviderSec'),
                "isOtherFlag" : cmp.get('v.isOtherSearch'),
                "contactName" : (isProviderSearchDisabled && !isOtherSearch) ? cmp.find('memContactId').get('v.value'):'', //DE339250 - Avish
                "contactNumber" : (isProviderSearchDisabled && !isOtherSearch) ? cmp.find('memContactNumber').get('v.value'):'', //DE339250 - Avish
                "providerId" : providerUniqueId,
                "interactionCard": cmp.get("v.providerDetails"),
                "providerFlow" : cmp.get("v.providerFlow")
            });
            appEvent.fire();
        }
    },

    validateAllFields: function (cmp, event, mandatoryFields) {
        debugger;
        var validationSuccess = false;
        var mandatoryFieldCmp = "";
        var validationCounter = 0;
        var errMap = [];
        cmp.set("v.mapError",errMap);

        for (var i in mandatoryFields) {
            mandatoryFieldCmp = cmp.find(mandatoryFields[i]);
            if (!$A.util.isUndefined(mandatoryFieldCmp)) {
                if (!mandatoryFieldCmp.checkValidity()) {
                    validationCounter++;
                    errMap.push({key: mandatoryFieldCmp.getLocalId(), value: mandatoryFieldCmp.get('v.label')});
                    cmp.set("v.mapError",errMap);
                    cmp.set("v.fieldValidationFlag",true);
                }
                mandatoryFieldCmp.reportValidity();
            }
        }

        if(validationCounter == 0){
            validationSuccess = true;
            cmp.set("v.fieldValidationFlag",false);
        }
        return validationSuccess;
    },

    getProviderDetails: function (cmp) {
        var appEvent = $A.get("e.c:SAE_GetProviderDetailsAE");
	    appEvent.setParams({
	        "requestedCmp": "AuthenticateCall"
	    });
        appEvent.fire();
    },

    openInteractionOverview: function (component, helper) {
        //US2132239 : Member Only - No Provider to Search
        var workspaceAPI = component.find("workspace");
        var mvfcheckFlag = component.get('v.mnfCheckBox');
        var contactId = component.find('memContactId');
        var contactNumber = component.find('memContactNumber');
        var contactIdVal = '';
        var contactNumberVal = '';
        if(contactId != undefined && contactId != null){
            contactIdVal = contactId.get('v.value');
        }else{
            contactIdVal = "";
        }
        if(contactNumber != undefined && contactNumber != null){
            contactNumberVal = contactNumber.get('v.value');
        }else{
            contactNumberVal = "";
        }


        var inputMemberId = component.find('memberId');
        var memberIdVal = inputMemberId.get('v.value');

        var inputMemberDOB = component.find('inputDOB');
        var memberDOBVal = inputMemberDOB.get('v.value');

        var inputMemberFN = component.find('memFirstNameId');
        var memberFNVal = component.get('v.memFirstName');

        var inputMemberLN = component.find('memLastNameId');
        var memberLNVal = component.get('v.memLastName');

        var inputMemberGrpN = component.find('memGroupNumberId');
        var memberGrpNVal = component.get('v.groupNumber');

        var mnfMemberFN = component.find('memFirstNameId').get('v.value');
        var mnfMemberLN = component.find('memLastNameId').get('v.value');
        var mnfDOB = component.find('inputDOB').get('v.value');
        if(mnfDOB != undefined && mnfDOB != null){
            var mnfDOBArray = mnfDOB.split("-");
            mnfDOB = mnfDOBArray[1] + "/" + mnfDOBArray[2] + "/" + mnfDOBArray[0];
        }
        var mnfPhoneNumber = component.find('memPhoneNumber').get('v.value');
        var mnfstateVal = component.find('stateMemId').find('provStateId').get("v.value");

        var mnfPhoneFormat = mnfPhoneNumber.substring(0,3) + '-' + mnfPhoneNumber.substring(3,6) + '-' + mnfPhoneNumber.substring(6,10);

        //US2132239 : Member Only - No Provider to Search
        let otherCard;

        //US1719505 Malinda
        //Get member first name for Snapshot tab's label
        var memDetails = component.get("v.responseData");
        var memFirstNameParam = '';

        if (memDetails != null && memDetails.length > 0) {
            memFirstNameParam = memDetails[0].firstName;
        }

        var memUniqueId;
        var matchingTabs = [];

        //rr
        var providerDetails = component.get('v.providerDetails');
        if(!$A.util.isEmpty(providerDetails)) {
            contactIdVal = providerDetails.contactName;
            contactNumberVal = providerDetails.contactNumber;
        }
        var providerUniqueId = '';  //US2132239 : Member Only - No Provider to Search
        var isProviderSearchDisabled = component.get("v.isProviderSearchDisabled");
	    var isOtherSearch = component.get('v.isOtherSearch');

        //US2132239 : Member Only - No Provider to Search (START)
        if (isProviderSearchDisabled) {
            providerUniqueId = "No Provider To Search";
        } else if (isOtherSearch) {
            providerUniqueId = "Other";
            otherCard = component.get("v.otherDetails")
            memUniqueId = 'Other;' + otherCard.firstName + ';' + otherCard.lastName + ';' + otherCard.contactType + ';' + otherCard.phoneNumber;
            contactIdVal = otherCard.firstName+' '+otherCard.lastName;
            contactNumberVal = otherCard.phoneNumber;
        } else if (!isProviderSearchDisabled) {
            providerUniqueId = providerDetails.taxIdOrNPI;
        }
        //US2132239 : Member Only - No Provider to Search (END)

        //******* Code Updated by Avish on 07/25/2019*******

        //US2132239 : Member Only - No Provider to Search
        let findIndividualParentTabId = '';

        var memberSearches = component.get("v.memberSearches");
        if(!component.get('v.mnfCheckBox') && !isOtherSearch){
            var subjectCard = component.get('v.subjectCard');
            //US2132239 : Member Only - No Provider to Search
            findIndividualParentTabId = subjectCard.memberId;
            if (subjectCard != null && subjectCard != "null" && subjectCard != '') {
                if(memberSearches.length == 0){
                    memUniqueId = providerUniqueId + ";" + subjectCard.memberId + ";" + memDetails[0].firstName + " " + memDetails[0].lastName + ";" + memDetails[0].dob;
                    memberSearches.push(memUniqueId);
                }else{
                    for (var i = 0; i < memberSearches.length; i++) {
                        var alreadySearchedMemberArray = memberSearches[i].split(";");
                        if(subjectCard.memberId != alreadySearchedMemberArray[1] &&
                            ((memDetails[0].firstName + " " + memDetails[0].lastName != alreadySearchedMemberArray[2])
                            && memDetails[0].dob != alreadySearchedMemberArray[3])){
                            memUniqueId = providerUniqueId + ";" + subjectCard.memberId + ";" + memDetails[0].firstName + " " + memDetails[0].lastName + ";" + memDetails[0].dob;
                            memberSearches.push(memUniqueId);

                        }
                    }
                }
            }
        }else if (!isOtherSearch) {
            if(memberSearches.length == 0){
                memUniqueId = providerUniqueId + ";" + memberIdVal + ";" + mnfMemberFN + " " + mnfMemberLN + ";" + memberDOBVal;
                memberSearches.push(memUniqueId);
            }else{
                for (var i = 0; i < memberSearches.length; i++) {
                    var alreadySearchedMemberArray = memberSearches[i].split(";");
                    if(memberIdVal != alreadySearchedMemberArray[1] &&
                        ((mnfMemberFN + " " + mnfMemberLN != alreadySearchedMemberArray[2])
                        && memberDOBVal != alreadySearchedMemberArray[3])){
                        memUniqueId = providerUniqueId + ";" + memberIdVal+ ";" + mnfMemberFN+ ";" + mnfMemberLN+ ";" +  memberDOBVal;
                        memberSearches.push(memUniqueId);
                    }
                }
            }
        }
            component.set("v.memberSearches", memberSearches);
		//***** Code ends here

        //US2132239 : Member Only - No Provider to Search
        let mapOpenedTabMemberIds;

        //US2132239 : Member Only - No Provider to Search (START)
        workspaceAPI.getAllTabInfo().then(function (response) {
            //US2132239 : Member Only - No Provider to Search
            mapOpenedTabMemberIds = new Map();
            if (!$A.util.isEmpty(response)) {
                for (var i = 0; i < response.length; i++) {
                    var tabMemUniqueId = response[i].pageReference.state.c__memberUniqueId;

                    //US2132239 : Member Only - No Provider to Search
                    mapOpenedTabMemberIds.set(tabMemUniqueId,response[i]);

                    let isOtherSearch = component.get('v.isOtherSearch');

                    //Checking Search Type
                    if (isProviderSearchDisabled) {
                        if (memUniqueId === tabMemUniqueId) {
                            matchingTabs.push(response[i]);
                        }
                    } else if (isOtherSearch) {
                        if (memUniqueId === tabMemUniqueId) {
                            matchingTabs.push(response[i]);
                        }
                    } else if (!isProviderSearchDisabled && !isOtherSearch) {
                        if (providerUniqueId === response[i].pageReference.state.c__providerUniqueId) {
                            matchingTabs.push(response[i]);
                        }
                    }
                }
            }

            if (matchingTabs.length === 0) {
                component.set("v.interactionID", '');
                /*** Added by Avish US1895939 **/
                var provdDetailsObj = component.get("v.providerDetails");
                //US1909381 - Sarma - 05/09/2019 - Interaction Overview - Other (Third Party) : null check on the provide details obj
                if(provdDetailsObj != null && provdDetailsObj != undefined){
                    // US1699139 - Continue button - Sanka - Fix
                    var firstName = !$A.util.isEmpty(provdDetailsObj.firstName) ? provdDetailsObj.firstName.toUpperCase() : '';
                    var lastName = !$A.util.isEmpty(provdDetailsObj.lastName) ? provdDetailsObj.lastName.toUpperCase() : '';
                provdDetailsObj.firstName = firstName;
                provdDetailsObj.lastName  = lastName;
                component.set("v.providerDetails",provdDetailsObj);
                }
                /** US1895939 ends ***/

                /*** Code Added by Avish 07/25/2019 ***/
                if(component.get('v.mnf') == 'mnf'){
                    component.set("v.interactionCard", null);
                    component.set("v.subjectCard", '');
                    component.set("v.checkFlagmeberCard",false);
                }
                /** Code ends here ***/

								// US2047577 - Thanish - 20th Sept 2019
				var tempProviderDetails = component.get("v.providerDetails");
                var isOtherSearch = component.get('v.isOtherSearch');


                // End of Code - US2047577 - Thanish - 20th Sept 2019

                // US1944108 - Accommodate Multiple Payer ID's - Kavinda
                if(component.get('v.mnf') == 'mnf'){
                    //US2132239 : Member Only - No Provider to Search (22 NOV 2019)
                    if (isOtherSearch) {
                        providerUniqueId = memUniqueId;
                    }
                } else {
                    var subjectCard = component.get("v.subjectCard");
                    var payerValue = component.get('v.payerValue');
                    subjectCard.payerID = payerValue;
                    component.get("v.subjectCard", subjectCard);
                }

                //close tab after refreshing tab or logout session
                var interactionOverviewStatus = _setAndGetInteractionOverviewStatus.setValue(true);

                //US2132239 : Member Only - No Provider to Search (START)
                console.log('Member Card Helper');
                console.log('Qtype'+component.get("v.VCCDQuestionType"));
                workspaceAPI.openTab({
                    pageReference: {
                        "type": "standard__component",
                        "attributes": {
                            "componentName": "c__SAE_InteractionOverview"
                        },
                        "state": {

                            "c__providerUniqueId": providerUniqueId,
                            "c__ParentTabIdForFindIndividuals": findIndividualParentTabId, //US2132239 : Member Only - No Provider to Search - PART2
                            "c__contactName": contactIdVal,
                            "c__contactNumber": contactNumberVal,
			                "c__noMemberToSearch": component.get('v.disableMemberSec'),
                            "c__interactionCard": component.get('v.interactionCard'),
                            "c__subjectCard": component.get('v.subjectCard'),
                            "c__memberId": memberIdVal,
                            "c__memberDOB": memberDOBVal,
                            "c__memberFN": memFirstNameParam,
                            "c__memberLN": memberLNVal,
                            "c__memberGrpNo": memberGrpNVal,
                            "c__searchOption": component.get('v.searchOptionVal'),
                            "c__mnf": component.get('v.mnf'),
                            "c__mnfMemberFN": mnfMemberFN.toUpperCase(),
                            "c__mnfMemberLN": mnfMemberLN.toUpperCase(),
                            "c__mnfDOB": mnfDOB,
                            "c__mnfPhoneNumber": mnfPhoneFormat,
                            "c__mnfState": mnfstateVal,
                            "c__intType": component.get("v.interactionType"),
                            //US1719505 Malinda
                            "c__memberUniqueId": memUniqueId,
                            "c__interactionID": component.get("v.interactionID"),
                            "c__statusCode":component.get("v.respStatusCode"),
                            "c__tabOpened": true,
                            "c__providerDetails": tempProviderDetails, // US2047577 - Thanish - 20th Sept 2019
                            "c__isProviderSearchDisabled": component.get("v.isProviderSearchDisabled"),
                            "c__providerNotFound":component.get("v.providerNotFound"),
                            "c__checkFlagmeberCard" : component.get("v.checkFlagmeberCard"), //Added by Avish on 07/25/2019
                            "c__providerType" : component.get("v.providerType"), // US1807554 - Thanish - 19th August 2019.
			                "c__otherDetails" : component.get("v.otherDetails"), //US1909381 - Sarma - 05/09/2019
                            "c__isOtherSearch" : component.get("v.isOtherSearch"), //US1909381 - Sarma - 05/09/2019,
                            "c__isVCCD" : component.get("v.isVCCD"), //US2631703 - Durga- 08th June 2020
                            "c__VCCDRespId":component.get("v.VCCDObjRecordId"),//US2631703 - Durga- 08th June 2020
                            "c__VCCDQuestionType":component.get("v.VCCDQuestionType"),//US2570805 - Sravan - 08/06/2020
                            "c__findIndividualFlag": false
                        }
                    },
                    focus: true
                }).then(function (response) {
                    workspaceAPI.getTabInfo({
                        tabId: response
                    }).then(function (tabInfo) {
                        var focusedTabId = tabInfo.tabId;
                        var IOLabel= '';
                        // ******** US1831550 Thanish (Date: 8th July 2019) start ********

                        if(component.get('v.mnf') == 'mnf'){
                            //US2132239 : Member Only - No Provider to Search (START)
                            if(!component.get("v.isProviderSearchDisabled") || component.get("v.providerNotFound")) {
                                var providerLName = component.get("v.providerDetails.lastName");
                                if(component.get("v.isOtherSearch")){
                                   //US2018128 changes vishnu
                                    var otherLastname = component.get("v.otherDetails.conName");
                                    IOLabel = otherLastname;
                                } else {
                                    if (!$A.util.isEmpty(providerLName)) {
                                        IOLabel = providerLName.charAt(0) + providerLName.slice(1).toLowerCase();
                                    } else {
                                        IOLabel = "Interaction Overview";
                                    }
                                }
                            } else {
                            IOLabel = mnfMemberLN.charAt(0) + mnfMemberLN.slice(1).toLowerCase();
                            }
                            //US2132239 : Member Only - No Provider to Search (END)

                        }else{
                            if(component.get("v.isProviderSearchDisabled")){
                                IOLabel = component.get('v.subjectCard').lastName.charAt(0) + component.get('v.subjectCard').lastName.slice(1).toLowerCase();
                            }else{
                                var providerLName = component.get("v.providerDetails.lastName");

                                // If the value in "interactionCard" attribute is null or empty then show "Interaction Overview" as the label.
                                //US1909381 - Sarma - 05/09/2019 - Interaction Overview - Other (Third Party) : if other search, other last name will be the label
                                if(component.get("v.isOtherSearch")){
                                    //US2018128 changes vishnu
                                    var otherLastname = component.get("v.otherDetails.conName");
                                    IOLabel = otherLastname;
                                } else {
                                    if (!$A.util.isEmpty(providerLName)) {
                                        IOLabel = providerLName.charAt(0) + providerLName.slice(1).toLowerCase();
                                    } else {
                                        IOLabel = "Interaction Overview";
                                    }
                                }
                            }
                        }

                        workspaceAPI.setTabLabel({
                            tabId: focusedTabId,
                            label: IOLabel
                        });
                        workspaceAPI.setTabIcon({
                            tabId: focusedTabId,
                            icon: "standard:contact_list",
                            iconAlt: "Interaction Overview : "
                        });
                        // ******** US1831550 Thanish end ********

                    });
                }).catch(function (error) {
                    console.log(error);
                });
            } else {

                //US2132239 : Member Only - No Provider to Search
                let isOtherSearch = component.get('v.isOtherSearch');
                var focusTabId = matchingTabs[0].tabId;
                var tabURL = matchingTabs[0].url;
                //US2132239 : Member Only - No Provider to Search
                if(!$A.util.isEmpty(mapOpenedTabMemberIds)) {
                    if(mapOpenedTabMemberIds.has(memUniqueId)) {
                        let selectedTab = mapOpenedTabMemberIds.get(memUniqueId);
                        focusTabId = selectedTab.tabId;
                        tabURL = selectedTab.url;
                        let toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "title": "Information!",
                            "message": "Member was already searched.",
                            "type": "warning"
                        });
                        if (!isOtherSearch) {
                            toastEvent.fire();
                        }
                    }
                } else {
                    //US2132239 : Member Only - No Provider to Search
                var appEvent = $A.get("e.c:SAE_SubjectCardAE");

                /*** Code added by Avish on 07/25/2019 ***/

                    if(component.get('v.mnf') == 'mnf'){
                        component.set("v.checkFlagmeberCard",true);
                    }

                    if(component.get('v.mnf') != 'mnf'){

                        appEvent.setParams({
                            "subjectCard": component.get("v.subjectCard"),
                            "searchedMember": memUniqueId,
                            "existingMemberCardFlag": component.get("v.checkFlagmeberCard"),
                            "providerUniqueId": providerUniqueId,
                            "providerDetails": component.get('v.providerDetails')
                        });
                    } else {
                        appEvent.setParams({
                            "searchedMember": memUniqueId,
                            "mnfMemberFN": mnfMemberFN.toUpperCase(),
                            "mnfMemberLN": mnfMemberLN.toUpperCase(),
                            "mnfDOB": mnfDOB,
                            "mnfMemberState": mnfstateVal,
                            "mnfMemberPhNo": mnfPhoneFormat,
                            "mnf":component.get('v.mnf'),
                            "mnfIntDetailLst":component.get("v.mnfDetailsLst"),
                            "providerUniqueId": providerUniqueId,
                            "providerDetails": component.get('v.providerDetails')
                        });
                    }

                    /*** code end here ***/

                    appEvent.fire();
                }

                if(!isProviderSearchDisabled || isOtherSearch) {

                    var appEvent = $A.get("e.c:SAE_SubjectCardAE");

                    /*** Code added by Avish on 07/25/2019 ***/

                if(component.get('v.mnf') == 'mnf'){
                    component.set("v.checkFlagmeberCard",true);
                }

                if(component.get('v.mnf') != 'mnf'){

                    // PreProd regression Issues - Kavinda
                    // Issue in snapshot for 2nd subject card - Start
                    var subjectCard = component.get("v.subjectCard");
                    var payerValue = component.get('v.payerValue');
					subjectCard.payerID = payerValue;
                    component.set("v.subjectCard", subjectCard);
                    // Issue in snapshot for 2nd subject card - END

                    appEvent.setParams({
                        "subjectCard": component.get("v.subjectCard"),
                        "searchedMember": memUniqueId,
                        "existingMemberCardFlag": component.get("v.checkFlagmeberCard"),
                        "providerUniqueId": providerUniqueId,
                        "providerDetails": component.get('v.providerDetails')
                    });
                }else{
                    //US2132239 : Member Only - No Provider to Search (22 NOV 2019)
                    if (isOtherSearch) {
                        providerUniqueId = memUniqueId;
                    }
                    appEvent.setParams({
                        "searchedMember": memUniqueId,
                        "mnfMemberFN": mnfMemberFN.toUpperCase(),
                        "mnfMemberLN": mnfMemberLN.toUpperCase(),
                        "mnfDOB": mnfDOB,
                        "mnfMemberState": mnfstateVal,
                        "mnfMemberPhNo": mnfPhoneFormat,
                        "mnf":component.get('v.mnf'),
                        "mnfIntDetailLst":component.get("v.mnfDetailsLst"),
                        "providerUniqueId": providerUniqueId,
                        "providerDetails": component.get('v.providerDetails')
                    });
                }
                /*** code end here ***/

                appEvent.fire();

                }

                workspaceAPI.openTab({
                    url: tabURL
                }).then(function (response) {
                    workspaceAPI.focusTab({
                        tabId: focusTabId
                    });
                }).catch(function (error) {
                    console.log(error);
                });
            }
        })
        //US2132239 : Member Only - No Provider to Search (END)

    },

    navigateToInteractionHelper:function(cmp,event,helper,flagMNFnav){
		var memConVal = '';
        if(cmp.get("v.isProviderSearchDisabled")){
            memConVal = cmp.find('memContactId').get('v.value');
        }
       
        var controlAuraIds =  [];

        var memFNameId = cmp.find('memFirstNameId');
        var memLNameId = cmp.find('memLastNameId');
        var memPhoneNum = cmp.find('memPhoneNumber');
        var memState = cmp.find('stateMemId');

        $A.util.removeClass(memFNameId, "hide-error-message");
        $A.util.removeClass(memLNameId, "hide-error-message");
        $A.util.removeClass(memPhoneNum, "hide-error-message");
        $A.util.removeClass(memState, "hide-error-message");

        //if(!$A.util.isEmpty(memConVal)){
        if(cmp.get('v.disableMemberSec') == true){
            controlAuraIds = ["memFirstNameId","memLastNameId","memPhoneNumber","memContactId","inputDOB","stateMemId"];
        }else{
            controlAuraIds = ["memFirstNameId","memLastNameId","memPhoneNumber","inputDOB","stateMemId"];
        }
        var memFN = cmp.find('memFirstNameId').get('v.value');
        var memLN = cmp.find('memLastNameId').get('v.value');
        var mnfDOB = cmp.find('inputDOB').get('v.value');
        var memPhNo = cmp.find('memPhoneNumber').get('v.value');
        var memDOB = cmp.find('inputDOB').get('v.value');

        var errMap = [];
        cmp.set("v.mapError",errMap);
        cmp.set("v.validationFlag",false);
        cmp.set("v.fieldValidationFlag",false);

        //reducer function iterates over the array and return false if any of the field is invalid otherwise true.
        var isAllValid = controlAuraIds.reduce(function(isValidSoFar, controlAuraId){
            //fetches the component details from the auraId
            var inputCmp='';
            if(!$A.util.isEmpty(controlAuraId)){
                if(controlAuraId == 'stateMemId'){
                    var tempState = cmp.find('stateMemId').find('provStateId').get("v.value");
                    var elem = cmp.find('stateMemId').find('provStateId');
                    if($A.util.isEmpty(tempState)){
                        cmp.find('stateMemId').find('provStateId').reportValidity();

                        if(!$A.util.isUndefined(cmp.find('stateMemId').find('provStateId'))){
                            var isErrorFlag = cmp.find('stateMemId').find('provStateId').reportValidity();
                            if(isErrorFlag == false){
                                errMap.push({key: controlAuraId, value: cmp.find('stateMemId').find('provStateId').get('v.label')});
                                cmp.set("v.mapError",errMap);
                                cmp.set("v.fieldValidationFlag",true);

                            }
                        }
                        return false;
                    }else{
                        return true;
                    }

                }else{
                    inputCmp = cmp.find(controlAuraId);
                    if(!$A.util.isUndefined(inputCmp)){
                        var isErrorFlag = inputCmp.reportValidity();
                        if(isErrorFlag == false){
                            //errMap.set(controlAuraId,inputCmp.get('v.label'));
                            errMap.push({key: controlAuraId, value: inputCmp.get('v.label')});
                            cmp.set("v.mapError",errMap);
                            cmp.set("v.fieldValidationFlag",true);

                        }
                    }
                    inputCmp.reportValidity();
                }
                //form will be invalid if any of the field's valid property provides false value.
                return true;
            }else{

                inputCmp = cmp.find(controlAuraId);
                inputCmp.reportValidity();
                if(!$A.util.isUndefined(inputCmp)){
                    var isErrorFlag = inputCmp.reportValidity();
                    if(isErrorFlag == false){
                        //errMap.set(controlAuraId,inputCmp.get('v.label'));
                        errMap.push({key: controlAuraId, value: inputCmp.get('v.label')});
                        cmp.set("v.mapError",errMap);
                        cmp.set("v.fieldValidationFlag",true);

                    }
                }
                //form will be invalid if any of the field's valid property provides false value.
                return false;
            }
            //displays the error messages associated with field if any

        },true);

        if(!$A.util.isEmpty(memConVal)){
            if(isAllValid ){
                if((!$A.util.isEmpty(memFN) && !$A.util.isEmpty(memLN) && !$A.util.isEmpty(memPhNo) && memPhNo.length == 10 && !$A.util.isEmpty(memDOB) && !$A.util.isEmpty(memConVal))){
                    isAllValid = true;
                    cmp.set("v.validationFlag",false);
                } else {
                    isAllValid = false;
                    cmp.set("v.validationFlag",true);
                }
            }else{
                isAllValid = false;
                cmp.set("v.validationFlag",true);
            }
        }else{

            if(isAllValid ){
                if((!$A.util.isEmpty(memFN) && !$A.util.isEmpty(memLN) && !$A.util.isEmpty(memPhNo) && memPhNo.length == 10 && !$A.util.isEmpty(memDOB))){
                    isAllValid = true;
                    cmp.set("v.validationFlag",false);
                } else {
                    isAllValid = false;
                }
            }else{
                isAllValid = false;
            }
        }

        var mnfData = cmp.get("v.mnfDetailsLst");
        var isExistingMNFMember = false;

        //US2132239 : Member Only - No Provider to Search
        let memNotFoundUniqueId = '';
        let mapMemNotFoundTabs;

        if(!isExistingMNFMember){
            var mnfstateVal2 = cmp.find('stateMemId').find('provStateId').get("v.value");
            for(var i in mnfData){
                if(memFN.toUpperCase() == mnfData[i].mnfMemberFN && memLN.toUpperCase() == mnfData[i].mnfMemberLN && mnfstateVal2 == mnfData[i].mnfState
                   && memPhNo == mnfData[i].mnfPhoneNumber){
                    isExistingMNFMember = true;
                }
            }

            //US2132239 : Member Only - No Provider to Search (START)
            if (cmp.get('v.mnf') == 'mnf') {
                let memUniquePrefix = '';
                let memberNotFoundId = cmp.find('memberId').get('v.value');
                let memberNotFoundFirstName = memFN;
                let memberNotFoundLastName = memLN;
                let memberNotFoundDob = mnfDOB;
                //Creating unique Id for duplicate Tab checking in MNF flow
                let isProviderSearchDisabled = cmp.get("v.isProviderSearchDisabled");
                if (isProviderSearchDisabled) {
                    memUniquePrefix = 'No Provider To Search';
                } else if (!isProviderSearchDisabled) {
                    let providerDetails = cmp.get("v.providerDetails");
                    //US2132239 : Member Only - No Provider to Search (22 NOV 2019)
                    if (cmp.get("v.isOtherSearch")) {
                        memUniquePrefix = 'OTHER-MNF';
                    } else {
                        memUniquePrefix = providerDetails.taxIdOrNPI;
                    }

                }
                memNotFoundUniqueId = memUniquePrefix + ';' + memberNotFoundId + ';' + memberNotFoundFirstName + ' ' + memberNotFoundLastName + ';' + memberNotFoundDob;

            }
            //US2132239 : Member Only - No Provider to Search (END)

            mnfData.push({
                //US2132239 : Member Only - No Provider to Search
                'mnfUniqueId':memNotFoundUniqueId,
                'mnf': cmp.get('v.mnf'),
                'mnfMemberFN': memFN.toUpperCase(),
                'mnfMemberLN': memLN.toUpperCase(),
                "mnfDOB": mnfDOB,
                'mnfState': mnfstateVal2,
                'mnfPhoneNumber': memPhNo
            });

            cmp.set("v.mnfDetailsLst",mnfData);
        }

        if (isAllValid != undefined && isAllValid != false && flagMNFnav) {
            var memberSearches = cmp.get("v.memberSearches");
            var memDOB = cmp.find('inputDOB').get('v.value');
            var memId = cmp.find('memberId').get('v.value');
            if (memberSearches.indexOf(memId + memDOB) != -1 || isExistingMNFMember) {

                var workspaceAPI = cmp.find("workspace");
                workspaceAPI.getAllTabInfo().then(function (response) {

                    if (!$A.util.isEmpty(response)) {
                    //US2132239 : Member Only - No Provider to Search
                    mapMemNotFoundTabs = new Map();
                    let toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Information!",
                        "message": "Member was already searched.",
                        "type": "warning"
                    });

                        for (var i = 0; i < response.length; i++) {
                            //US2132239 : Member Only - No Provider to Search
                            if(cmp.get('v.mnf') == 'mnf') {
                                mapMemNotFoundTabs.set(response[i].pageReference.state.c__memberUniqueId,response[i]);
                            } else {
                                if (response[i].pageReference.state.c__tabOpened) {
                                workspaceAPI.openTab({
                                    url: response[i].url
                                }).then(function (response) {
                                    workspaceAPI.focusTab({
                                        tabId: response
                                    });
                                }).catch(function (error) {
                                    console.log(error);
                                });
                            }

                    }
                        }
                        //US2132239 : Member Only - No Provider to Search
                        if(!$A.util.isEmpty(mapMemNotFoundTabs) && cmp.get('v.mnf') == 'mnf') {
                            if(mapMemNotFoundTabs.has(memNotFoundUniqueId)) {
                                let toastEvent = $A.get("e.force:showToast");
                                toastEvent.setParams({
                                    "title": "Information!",
                                    "message": "Member was already searched.",
                                    "type": "warning"
                                });
                                toastEvent.fire();
                                if(!cmp.get('v.isOtherSearch') && !cmp.get('v.isProviderSearchDisabled')){
                                    helper.getProviderDetails(cmp);
                                    var providerDetails = cmp.get('v.providerDetails');
                                    var providerUniqueId = providerDetails.taxIdOrNPI;
                                    
                                    var appEvent = $A.get("e.c:SAE_RefreshProviderCardAE");
                                    appEvent.setParams({
                                        "providerDetails": providerDetails,
                                        "providerUniqueId": providerUniqueId
                                    });
                                    appEvent.fire();
                                    //helper.openInteractionOverview(cmp, event, helper);
                                }
                                let selectedMnfTab = mapMemNotFoundTabs.get(memNotFoundUniqueId);
                                workspaceAPI.openTab({
                                    url: selectedMnfTab.url
                                }).then(function (response) {
                                    workspaceAPI.focusTab({
                                        tabId: selectedMnfTab.tabId
                                    });
                                    workspaceAPI.getTabInfo({
                                        tabId: response
                                    }).then(function (tabInfo) {
                                        var focusedTabId = tabInfo.tabId;
                                        var IOLabel= '';
                                        if(!cmp.get('v.isOtherSearch') && !cmp.get('v.isProviderSearchDisabled')){
                                            var providerLName = cmp.get("v.providerDetails.lastName");
                                            if (!$A.util.isEmpty(providerLName)) {
                                                IOLabel = providerLName.charAt(0) + providerLName.slice(1).toLowerCase();
                                            } else {
                                                IOLabel = "Interaction Overview";
                                            }
                                        }
                                        workspaceAPI.setTabLabel({
                                            tabId: focusedTabId,
                                            label: IOLabel
                                        });
                                        workspaceAPI.setTabIcon({
                                            tabId: focusedTabId,
                                            icon: "standard:contact_list",
                                            iconAlt: "Interaction Overview : "
                                        });
                                    });
                                }).catch(function (error) {
                                    console.log('###MNF-TAB-ERROR:',error.toString());
                                });
                             } else {
                                //US2132239 : Member Only - No Provider to Search (22 NOV 2019)
                                helper.openInteractionOverview(cmp, event, helper);
                            }
                        }

                    }
                })

                //
            } else {
            helper.openInteractionOverview(cmp,event,helper);
            }
        }
    },


    //US1708392 - Validation Start - Sanka
    validateNamesWildCard: function (component, event, helper, isFirstName, inputComp, charlengthNum) {
        //component.set("v.hasFirstNameError",false);
        //component.set("v.hasLastNameError",false);
        var charString = inputComp.get("v.value");
        var lastchar = charString[charString.length - 1];

        if (lastchar == "*" && charString.length < charlengthNum) {
            if (isFirstName) {
                component.set("v.hasFirstNameError", true);
            } else {
                component.set("v.hasLastNameError", true);
            }
            $A.util.addClass(inputComp, "slds-has-error");
            return false;
        } else if (charString.includes("*") && lastchar != "*" && charString.length >= charlengthNum) {
            if (isFirstName) {
                component.set("v.hasFirstNameError", true);
            } else {
                component.set("v.hasLastNameError", true);
            }
            $A.util.addClass(inputComp, "slds-has-error");
            return false;
        } else {
            component.set("v.hasFirstNameError", false);
            component.set("v.hasLastNameError", false);
            $A.util.removeClass(component, "slds-has-error");
            $A.util.addClass(component, "hide-error-message");
            return true;
        }
    },

    setErrorMessage: function (component, event, helper, errorMessage) {
        component.set("v.errorMessage", errorMessage);
        component.set("v.hasErrorMessage", true);
    },

    validateFields: function (component, event, helper, inputComp, status) {
        if (!status) {
            $A.util.removeClass(inputComp, "hide-error-message");
            $A.util.addClass(inputComp, "slds-has-error");
            inputComp.reportValidity();
        } else {
            $A.util.removeClass(inputComp, "slds-has-error");
            $A.util.addClass(inputComp, "hide-error-message");
        }
    },

    fireToast: function (message,duration) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "Error!",
            "message": message,
            "message": message,
            "type": "error",
            "mode": "dismissable",
			"duration": duration
        });
        toastEvent.fire();
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

    // Fix - DE246060 - Sanka Dharmasena - 10.07.2019
    checkOpnedTab: function (component) {
        var workspaceAPI = component.find("workspace");
        var memSearch = [];
        component.set("v.memberSearches", memSearch);

        workspaceAPI.getAllTabInfo().then(function (response) {
            if (!$A.util.isEmpty(response)) {
                for (var i = 0; i < response.length; i++) {
                    if (response[i].pageReference.state.c__tabOpened) {
                        //matchingTabs.push(response[i]);
                        console.log(JSON.stringify(response));
                        memSearch.push(response[i].pageReference.state.c__memberUniqueId);
                    }
                }
            }
        });

        component.set("v.memberSearches", memSearch);
    },

    // US2031725 - Validation for Explore - Other (Third Party) - Kavinda
    executeOtherSearchValidations: function (cmp, event, helper) {
        var appEvent = $A.get("e.c:ACETLink_fireOtherSearchValidations");
        appEvent.setParams({"message" : "SAE_MemberCardHelper"});
        appEvent.fire();
    },

    filterMemberResults: function(cmp, event, helper) {
        debugger;
        var membersORG = cmp.get("v.responseData");
        var responseDataOrg = cmp.get("v.responseDataOrg");
        var value = event.getParam("value").toLowerCase();
        if(value == undefined || value == ''){
            cmp.set('v.responseData', responseDataOrg);
            cmp.set('v.display', true);
            this.sendMemberDetails(cmp);
            return;
        }
        cmp.set('v.display', true);

        var members = [];
        for (var i = 0; i < membersORG.length; i++) {
            if( (membersORG[i].sourceSysCode .toLowerCase().indexOf(value) != -1) || (membersORG[i].fullName .toLowerCase().indexOf(value) != -1) || (membersORG[i].birthDate .indexOf(value) != -1)){
                members.push(membersORG[i]);
            }
        }
        if(members.length > 0){
            cmp.set('v.responseData', members);
        }else{
            cmp.set('v.responseData', responseDataOrg);
        }

        var selectedRec = cmp.get('v.searchMemberResults');
    },
    // US416376
    keepOnlyDigits: function (cmp, event) {
        var regEx = /[^0-9 ]/g;
        var fieldValue = event.getSource().get("v.value");
        if (fieldValue.match(regEx)) {
            event.getSource().set("v.value", fieldValue.replace(regEx, ''));
        }
    },
    
    // US416376
    keepOnlyText: function(cmp,event){
        var regEx = /[^a-zA-Z ]/g;
        var fieldValue = event.getSource().get("v.value");
        if (fieldValue.match(regEx)) {            
            event.getSource().set("v.value", fieldValue.replace(regEx, ''));
        }
    },
})