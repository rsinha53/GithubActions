({
    setAddMembers: function (cmp, event, helper) {
        if(cmp.get("v.isOtherSearch") == event.getParam("isOther")){
            cmp.set("v.interactionRec", event.getParam("interactionRec"));
            cmp.set("v.interactionCard", event.getParam("interactionCard"));
            cmp.set("v.contactName", event.getParam("contactName"));
        }
    },
	
	handleSelect: function (component, event,helper) {
        // This will contain the string of the "value" attribute of the selected
        // lightning:menuItem
        debugger;
        var selectedMenuItemValue = event.getParam("value");
        var source = event.getSource();
        var srcName = source.get('v.name');
        var addmembers = component.get('v.addMembers');
        var searchMember = addmembers[srcName].subjectCard;
        
        if(selectedMenuItemValue =='CopySSN'){
            var textforcopy = searchMember.SSN;
            helper.copyTextHelper(component,event,textforcopy);
        }else if(selectedMenuItemValue =='CopyEEID'){
            var textforcopy = searchMember.EEID;
            helper.copyTextHelper(component,event,textforcopy);
        }else if(selectedMenuItemValue =='UnMaskSSN'){
            var unMask = component.find("formattedSSN");
            if($A.util.isArray(unMask)){
                unMask = unMask[srcName];
            }
            $A.util.removeClass(unMask, "slds-hide");
            var mask = component.find("maskedSSN");
            if($A.util.isArray(mask)){
                mask = mask[srcName];
            }
            $A.util.addClass(mask, "slds-hide");
        }
        else if(selectedMenuItemValue =='UnMaskEEID'){
            var unMask = component.find("unMaskedEEID");
            if($A.util.isArray(unMask)){
                unMask = unMask[srcName];
            }
            $A.util.removeClass(unMask, "slds-hide");
            var mask = component.find("maskedEEID");
            if($A.util.isArray(mask)){
                mask = mask[srcName];
            }
            $A.util.addClass(mask, "slds-hide");
        }
    },
	
    onLoad: function (cmp, event, helper) {
        var items = [];
        for (var i = 1; i < 21; i++) {
            var item = {
                "label": i,
                "value": i.toString(),
            };
            items.push(item);
        }
        cmp.set("v.numbers", items);
        cmp.set("v.selMemberChild", new Object());
    },

    navigateToSnapshot: function (cmp, event, helper) {
        var selectedCard = event.target.getAttribute("data-index");
        var selectedCardMemberType = event.target.getAttribute("data-memberType");
        var subjectCard;
        var mnfDetails;
        var memUniqueId;
        var houseHoldUnique;
        var mnf = "";
        if (selectedCardMemberType == "Searched Member") {
            subjectCard = cmp.get("v.addMembers")[selectedCard].subjectCard;
            memUniqueId = subjectCard.memberId + subjectCard.memberDOB + subjectCard.firstName;
            memUniqueId = memUniqueId.concat('_sub');
            // US1974034 - Thanish (Date: 21st Aug 2019) - Case creation member not found part 2
            // DE281466	HouseHold issue with Twins : Adding first name to tab uniqueness - 22/11/2019 - Sarma
            houseHoldUnique = subjectCard.memberId + subjectCard.memberDOB + subjectCard.firstName + '_sub';

            // US1944108 - Accommodate Multiple Payer ID's - Kavinda
            var payerValue;
            if(cmp.get("v.addMembers")[selectedCard].payerObj != undefined && cmp.get("v.addMembers")[selectedCard].payerObj != null){
                payerValue = cmp.get("v.addMembers")[selectedCard].payerObj.payerValue;
            }
            else {
                payerValue = '87726';
            }
            subjectCard.payerID = payerValue;

        } else if (selectedCardMemberType == "Member not found") {
            //mnfDetails = cmp.get("v.mnfDetailslst")[selectedCard];
            subjectCard = cmp.get("v.addMembers")[selectedCard];
            mnfDetails = {
                "mnfState": subjectCard.state,
                "mnfPhoneNumber": subjectCard.phoneAfterUpdate,
                "mnfMemberFN": subjectCard.firstName,
                "mnfMemberLN": subjectCard.lastName,
                "mnfDOB": subjectCard.dob
            };
            mnf = "mnf";
            memUniqueId = mnfDetails.mnfMemberFN + mnfDetails.mnfMemberLN + mnfDetails.mnfDOB;
            memUniqueId = memUniqueId.concat('_sub');
            //US1974034 - Thanish (Date: 21st Aug 2019) - Case creation member not found part 2
            houseHoldUnique = "";
        }
        var workspaceAPI = cmp.find("workspace");
        var contactName = cmp.get("v.contactName");
        var matchingTabs = [];
        // US2060237	Other Card Validation - Snapshot - Other (Third Party) - 10/10/2019 - Sarma
        var isOtherSearch = cmp.get("v.isOtherSearch");
        var otherCardDataObj = cmp.get("v.otherCardDataObj");
        var memberCardFlag = cmp.get("v.memberCardFlag");

        var addMembers = cmp.get("v.addMembers");
        addMembers[selectedCard].isdelete = false;
        cmp.set("v.addMembers",addMembers);

        //Checking for Opened Tabs
        workspaceAPI.getAllTabInfo().then(function (response) {
            if (!$A.util.isEmpty(response)) {
                for (var i = 0; i < response.length; i++) {
                    for (var j = 0; j < response[i].subtabs.length; j++) {
                        if (response[i].subtabs.length > 0) {
                            var tabMemUniqueId = response[i].subtabs[j].pageReference.state.c__memberUniqueId;
                            if (memUniqueId === tabMemUniqueId) {

                                matchingTabs.push(response[i].subtabs[j]);
                                break;
                            } else {
                                console.log('NO MATCH!!');
                            }
                        } else {
                            console.log('FIRST SUB TAB');
                        }
                    }
                }
            }
            //Open Tab
            if (matchingTabs.length === 0) {
                //DE295763 - Added by Avish
                var  noMemberFlag;
                if(cmp.get("v.noMemberToSearch")){
                    noMemberFlag = !cmp.get("v.noMemberToSearch");
                }else{
                    noMemberFlag = cmp.get("v.noMemberToSearch");
                }
                //DE295763 - Ends

                //US2020384
                //var tabName = cmp.get("v.memberFN");
                workspaceAPI.getEnclosingTabId().then(function (enclosingTabId) {
                    workspaceAPI.openSubtab({
                        parentTabId: enclosingTabId,
                        pageReference: {
                            "type": "standard__component",
                            "attributes": {
                                "componentName": "c__SAE_SnapshotOfMemberAndPolicies"
                            },
                            "state": {
                                "c__interactionCard": cmp.get('v.interactionCard'),
                                "c__contactName": contactName,
                                "c__memberUniqueId": memUniqueId,
                                "c__interactionRecord": cmp.get("v.interactionRec"),
                                "c__searchOption": mnf == "mnf" ? "" : subjectCard.searchOption,
                                "c__mnf": mnf,
                                "c__subjectCard": mnf == "mnf" ? mnfDetails : subjectCard,
                                // US1974034 - Thanish (Date: 21st Aug 2019) - Case creation member not found part 2
                                "c__houseHoldUnique": houseHoldUnique,
                                "c__providerNotFound": cmp.get("v.providerNotFound"),
                                "c__noMemberToSearch": noMemberFlag, //DE295763 - Added by Avish
								"c__isProviderSearchDisabled": cmp.get("v.isProviderSearchDisabled"),
                                "c__isAdditionalMemberIndividualSearch": cmp.get("v.isIndividualSearchOpenSnapshotPage"), //US2020384
                                // US2060237	Other Card Validation - Snapshot - Other (Third Party) - 14/10/2019 - Sarma

                                "c__isOtherSearch" : isOtherSearch,
                                "c__otherDetails" : otherCardDataObj,
                                "c__memberCardFlag" : memberCardFlag
                            }
                        },
                        focus: !event.ctrlKey
                    }).then(function (subtabId) {

                        var memberFN = "";
                        if (mnf == 'mnf') {
                            memberFN = mnfDetails.mnfMemberFN
                        } else {
                            memberFN = subjectCard.firstName;
                        }
                        var tabLabel = memberFN.charAt(0).toUpperCase() + memberFN.slice(1).toLowerCase();
                        workspaceAPI.setTabLabel({
                            tabId: subtabId,
                            label: tabLabel
                        });
                        workspaceAPI.setTabIcon({
                            tabId: subtabId,
                            icon: "custom:custom38",
                            iconAlt: "Snapshot"
                        });
                    }).catch(function (error) {
                        console.log(error);
                    });
                });
            } else {
                console.log('##ML:SUB_NOT-OPEN');

                var focusTabId = matchingTabs[0].tabId;
                var tabURL = matchingTabs[0].url;
                //var subTabURL = matchingTabs[0].subtabs[0].url;

                workspaceAPI.openTab({
                    //url: matchingTabs[0].subtabs[0].url
                    url: tabURL
                }).then(function (response) {
                    workspaceAPI.focusTab({
                        tabId: response
                    });
                }).catch(function (error) {
                    console.log(error);
                });
            }
        })
    },

    showMembers: function (component, event, helper) {

        component.set('v.showSections', true);
        var addMem = component.get('v.addMembers');
        //US2076569 Avish
        var memCardArray = [];
        var memberCard = 0;

        for(i in addMem){
            if(addMem.length == 1){
                if(!addMem[i].hasOwnProperty('row')){
                    memberCard = 0;
                    addMem = [];
                    component.set('v.addMembers', addMem);
                }
                memberCard = 1;
                break;
            }

        }
        memberCard = addMem.length;
        //US2076569 Ends

        var numberOfSections = component.find('numbersId').get('v.value');

        numberOfSections = parseInt(numberOfSections);
        var j = parseInt(numberOfSections) + parseInt(memberCard);  //US2076569 Avish

        // US1944108 - Accommodate Multiple Payer ID's - Kavinda
        var defaultPayerValue = component.get('v.defaultPayerValue');
        var defaultPayerLabel = component.get('v.defaultPayerLabel');


        for (var i = memberCard; i < j; i++) {

            var memberVar = {
                "row": i,
                "showCard": false,
                "showAdvance": false,
                "memberName": "",
                "dob": "",
                "firstName": "",
                "lastName": "",
                "groupNumber": "",
                "searchOption": "",
                "zip": "",
                "state": "",
                "phone": "",
                "phoneAfterUpdate":"",
                "subjectCard": "",
                "displayMNFFlag": false,
                "mnf": "",
                "mnfCheckBox": false,
                "fieldValidationFlag": false,
                "validationFlag": false,
                "mnfSubjectCard": false,
                "addMemberCard": true,
                "isFindIndividualSearch": false,
                "selectedSearchMember":"",
                "enableContinueBtn":false,
                "selectedMemberDetails":"",
                "isMultipleMemberResponse": false,
                "multipleMemberResponses" : [], //US2020384 : Updates to Additional Member Search Integration - Malinda
                "mapError": [],
                "isdelete" : false,
                "payerObj" : {"payerValue":defaultPayerValue, "payerLabel":defaultPayerLabel ,"displayPayer": false ,"typeText":""} // US1944108 - Accommodate Multiple Payer ID's - Kavinda
            };
            addMem.push(memberVar);
        }

        component.set('v.addMembers', addMem);
        helper.getStateValuesMDT(component, event);
    },

    openMembersSelection: function (cmp, event, helper) {
        cmp.set('v.showMembersSelction', true);
        $A.util.removeClass(cmp.find("hideNumberSelctions"), "slds-hide");
    },

    //US2076569 Avish
    resetMembers: function (cmp, event, helper) {
        var addMembers = cmp.get('v.addMembers');
        var resetAll = [];
        var selectedCard = [];
        for (var i = 0; i < addMembers.length; i++) {
            if(addMembers[i].showCard){
                //var addMemberCard = addMembers.splice(i, 1);
                selectedCard.push(addMembers[i]);
            }else{
                resetAll.push(addMembers[i]);
            }
        }
        if(resetAll.length == addMembers.length){
            cmp.set('v.showSections', false);
            $A.util.addClass(cmp.find("hideNumberSelctions"), "slds-hide");
            cmp.set('v.showMembersSelction', "");
            cmp.set('v.showSections', false);
            cmp.set('v.addMembers', []);
            //US1889740 - Sarma (Date: 6th Aug 2019) - Misdirect Case creation : disabling MMS during reset btn click
            cmp.set('v.isMms', false);
        }

        if(selectedCard.length > 0){
            for (var i = 0; i < selectedCard.length; i++){

                if(i != selectedCard[i].row){
                    selectedCard[i].row = i;
                }
            }

        }
        cmp.set("v.addMembers", selectedCard);
    },

    deleteCard: function(cmp, event, helper){
        debugger;
        var source = event.getSource();
        var srcName = source.get('v.name');
        var addMembers = cmp.get('v.addMembers');
        var searchedMember = addMembers[srcName];
        var uniqueMembersList = cmp.get("v.uniqueMembersList");

        for (var k = 0; k < uniqueMembersList.length;k++) {

            var alreadySearchedMemberArray;
            if(uniqueMembersList[k] != null){
                alreadySearchedMemberArray = uniqueMembersList[k].split(";");
                var tempDOBformat;
                var dob;
                var existingDOBformat;
                if(alreadySearchedMemberArray[3].indexOf('-') != -1){
                    var mnfDOB = alreadySearchedMemberArray[3].split('-');
                    var existingDOBformat = mnfDOB[1] + '/' + mnfDOB[2] + '/' + mnfDOB[0];
                    dob = helper.formatDateMMDDYYYY(cmp,existingDOBformat.split('/'));
                }else{
                    existingDOBformat = alreadySearchedMemberArray[3];
                    dob = helper.formatDateMMDDYYYY(cmp,existingDOBformat.split('/'));
                }
                var dobCompare;// = helper.formatDateMMDDYYYY(cmp,tempDOBformat);
                if(addMembers[srcName].subjectCard.memberDOB.indexOf('-') != -1){
                    var mnfDOB = addMembers[srcName].subjectCard.memberDOB.split('-');
                    tempDOBformat = mnfDOB[1] + '/' + mnfDOB[2] + '/' + mnfDOB[0];
                    dobCompare = helper.formatDateMMDDYYYY(cmp,tempDOBformat.split('/'));
                }else{
                    tempDOBformat = addMembers[srcName].subjectCard.memberDOB.split('/');
                    dobCompare = helper.formatDateMMDDYYYY(cmp,tempDOBformat);
                }
                /** DE285471 - Avish **/
                var deleteFlag = false;
                if(addMembers[srcName].showAdvance){
                    if(!$A.util.isEmpty(addMembers[srcName].memberName) && !$A.util.isEmpty(addMembers[srcName].subjectCard.firstName) && !$A.util.isEmpty(addMembers[srcName].subjectCard.lastName)){
                        if(((addMembers[srcName].subjectCard.firstName.toLowerCase() + " " + addMembers[srcName].subjectCard.lastName.toLowerCase()) == alreadySearchedMemberArray[2].toLowerCase())
                           && (addMembers[srcName].memberName == alreadySearchedMemberArray[1])){
                            deleteFlag = true;
                        }
                    }else if(!$A.util.isEmpty(dob) && !$A.util.isEmpty(addMembers[srcName].subjectCard.firstName) && !$A.util.isEmpty(addMembers[srcName].subjectCard.lastName)){
						if(((addMembers[srcName].subjectCard.firstName.toLowerCase() + " " + addMembers[srcName].subjectCard.lastName.toLowerCase()) == alreadySearchedMemberArray[2].toLowerCase())
                           && dob == dobCompare){
                            deleteFlag = true;
                        }
                    }

                }else{
                    if((addMembers[srcName].memberName == alreadySearchedMemberArray[1]) && (((addMembers[srcName].subjectCard.firstName.toLowerCase() + " " + addMembers[srcName].subjectCard.lastName.toLowerCase()) == alreadySearchedMemberArray[2].toLowerCase())
                    	&& dob == dobCompare)){
                        deleteFlag = true;
                    }
                }
                if(deleteFlag){
                    /** DE285471 - Avish Ends**/
                    if(addMembers[srcName].showCard){
                        addMembers.splice(srcName, 1);
                        //cmp.set("v.addMembers", addMembers);
                        uniqueMembersList.splice(k, 1);
                    }
                    // addMembers[srcName].payerId = {};
                    //delete addMembers['payerObj'];

                    for (var i = 0; i < addMembers.length; i++){

                        if(i != addMembers[i].row){
                            addMembers[i].row = i;
                           /* addMembers[i].showCard = false;
                            addMembers[i].showAdvance = false;
                            addMembers[i].memberName = '';
                            addMembers[i].dob = '';
                            addMembers[i].memberName = '';
                            addMembers[i].lastName = '';
                            addMembers[i].groupNumber = '';
                            addMembers[i].searchOption = '';
                            addMembers[i].zip = '';
                            addMembers[i].state = '';
                            addMembers[i].phone = '';
                            addMembers[i].subjectCard = '';
                            addMembers[i].displayMNFFlag = false;
                            addMembers[i].mnf = '';
                            addMembers[i].mnfCheckBox = false;
                            addMembers[i].fieldValidationFlag = false;
                            addMembers[i].validationFlag = false;
                            addMembers[i].mnfSubjectCard = false;
                            addMembers[i].addMemberCard = true;
                            addMembers[i].isMultipleMemberResponse = false;
                            addMembers[i].multipleMemberResponses = [];
                            addMembers[i].mapError = [];
                            addMembers[i].isdelete = false;
                            addMembers[i].payerObj = {"payerValue":cmp.get('v.defaultPayerValue'), "payerLabel":cmp.get('v.defaultPayerLabel') ,"displayPayer": false ,"typeText":""};//'{"payerValue":'+ cmp.get('v.defaultPayerValue') +', "payerLabel": '+cmp.get('v.defaultPayerLabel')+',"displayPayer":'+ false+',"typeText":""}';
                            */
                        }
                        //addMembers[i].row = i;
                        cmp.set("v.addMembers", addMembers);
                    }
                    break;
                }
            }
        }


        if(addMembers.length == 0){
            cmp.set('v.showSections', false);
            $A.util.addClass(cmp.find("hideNumberSelctions"), "slds-hide");
            cmp.set('v.showMembersSelction', "");
            cmp.set('v.showSections', false);
            cmp.set('v.addMembers', []);
            //US1889740 - Sarma (Date: 6th Aug 2019) - Misdirect Case creation : disabling MMS during reset btn click
            cmp.set('v.isMms', false);
        }else{
            cmp.set("v.addMembers", addMembers);
            cmp.set("v.showSections",false);
            cmp.set("v.showSections",true);
        }
        //cmp.set("v.addMembers", addMembers);
        cmp.set("v.uniqueMembersList", uniqueMembersList);
    },//US2076569 Ends

    openMNFCard: function (cmp, event, helper) {
        var source = event.getSource();
        var srcName = source.get('v.name');
        helper.navigateToMNFSubjectCard(cmp, event, helper,srcName);
    },

    openSubjectCard: function (cmp, event, helper) {
        var source = event.getSource();
        var srcName = source.get('v.name');
        var addMembers = cmp.get('v.addMembers');

        if(addMembers.length > 0){
        
            let isIndividualSearch = false; //US2020384
            isIndividualSearch = event.getParam("isIndividualSearch"); //US2020384
            let selectedMember = event.getParam("selectedMemberDetails"); //US2020384
            let selectedCard;
            if(event.getParam("selectedMemberRow") != undefined){
                selectedCard = event.getParam("selectedMemberRow"); //US2020384
                srcName = selectedCard;
            }else{
                selectedCard = srcName;
            }
            var searchDetails = addMembers[srcName];

            //US2020384 : START (Updates to Additional Member Search Integration - Malinda)

            var uniqueMembersList = cmp.get("v.uniqueMembersList");

            var memberAlreadySearched = false;
            var firstNameParam = '';
            var lastNameParam = '';
            if(searchDetails != undefined || searchDetails != null){
                if(!$A.util.isEmpty(searchDetails.firstName) && searchDetails.firstName.length > 0){ // DE285319: Kavinda
                    firstNameParam = searchDetails.firstName.trim();
                    firstNameParam = firstNameParam.charAt(0).toUpperCase() + firstNameParam.slice(1).toLowerCase();
                }
                if(!$A.util.isEmpty(searchDetails.lastName && searchDetails.lastName.length > 0)){ // DE285319: Kavinda
                    lastNameParam = searchDetails.lastName.trim();
                    lastNameParam = lastNameParam.charAt(0).toUpperCase() + lastNameParam.trim().slice(1).toLowerCase();
                }
                var dobParam;
                if(!$A.util.isEmpty(searchDetails.dob && searchDetails.dob.length > 0)){ // DE285319: Kavinda
                    var dobMember = searchDetails.dob.split('-');
                    dobParam = dobMember[1]+'/'+dobMember[2]+'/'+dobMember[0];
                }

            }

            if(isIndividualSearch && !$A.util.isEmpty(selectedMember)) {
                helper.showMemberSpinner(cmp);
                console.log('###SELECTED-MEMEBR-FROM-FIND-INDIVIDUAL-INSIDE');
                let memberObj = {
                    memberId: selectedMember.memberID, //USS2221006
                    addMemberCard : false,
                    displayMNFFlag : false,
                    dob : selectedMember.DOB,
                    fieldValidationFlag : false,
                    firstName : selectedMember.firstName,
                    groupNumber : "",
                    isMultipleMemberResponse : false,
                    lastName : selectedMember.lastName,
                    mapError : [],
                    memberName : "",
                    memberProviderResultlst : [],
                    mnf : "",
                    mnfCheckBox : false,
                    mnfSubjectCard : false,
                    multipleMemberResponses : [],
                    phone : "",
                    phoneAfterUpdate : "",
                    row : 0,
                    searchOption : "",
                    showAdvance : false,
                    showCard : true,
                    state : "",
                    subjectCard : [],
                    validationFlag : false,
                    zip : ""
                };

                cmp.set("v.isIndividualSearchOpenSnapshotPage", true);
                /* US2076569 Avish */
                var uniqueMembersList = cmp.get("v.uniqueMembersList");
                if(memberObj != null && memberObj != undefined){
                    for (var i=0;i <uniqueMembersList.length;i++) {
                        var alreadySearchedMemberArray = uniqueMembersList[i].split(";");
                        var tempDOBformat;// = alreadySearchedMemberArray[3].split('/');

                        var dob = ""; // Thanish - DE285319 - 5th Dec 2019
                        if(alreadySearchedMemberArray[3].indexOf('-') != -1){
                            var mnfDOB = alreadySearchedMemberArray[3].split('-');
                            var checkHyphen = mnfDOB[1] + '/' + mnfDOB[2] + '/' + mnfDOB[0];
                            dob = helper.formatDateMMDDYYYY(cmp,checkHyphen.split('/'));
                        }else{
                            // Thanish - DE285319 - 5th Dec 2019
                            if(alreadySearchedMemberArray[0] == 'Other'){
                                if(!$A.util.isEmpty(alreadySearchedMemberArray[4]) && alreadySearchedMemberArray[4].indexOf('/') != -1){
                                    tempDOBformat = alreadySearchedMemberArray[4].split('/');
                                    dob = helper.formatDateMMDDYYYY(cmp,tempDOBformat);
                                }
                        }else{
                            tempDOBformat = alreadySearchedMemberArray[3].split('/');
                            dob = helper.formatDateMMDDYYYY(cmp,tempDOBformat);
                            } // End of Code - Thanish - DE285319 - 5th Dec 2019
                        }
                    }
                }
                /* US2076569 Ends */

                var action = cmp.get('c.findMembers');
                let memberDOB;
                if(!$A.util.isEmpty( memberObj.dob)) {
                let memberDOBArray = memberObj.dob.split('/');
                memberDOB = memberDOBArray[2] + "-" + memberDOBArray[0] + "-" + memberDOBArray[1];
                }


                // US1944108 - Accommodate Multiple Payer ID's
                var payerValue;
                if(addMembers[selectedCard] != undefined && addMembers[selectedCard].payerObj != undefined && addMembers[selectedCard].payerObj != null){
                    payerValue = addMembers[selectedCard].payerObj.payerValue;
                }
                else {
                    payerValue = '87726';
                }
                var providerInfo = cmp.get('v.interactionCard');

                // Thanish - DE285319 - 5th Dec 2019
                // E2E Fix - 06/12/2019 - Sarma
                if(cmp.get('v.isOtherSearch') || cmp.get('v.providerNotFound')){
                    action.setParams({
                        "memberId": memberObj.memberId, //USS2221006
                        "memberDOB": memberDOB,
                        "firstName": memberObj.firstName,
                        "lastName": memberObj.lastName,
                        "groupNumber": '',
                        "searchOption": 'MemberIDNameDateOfBirth',
                        'payerID': payerValue,// US1944108
                        "providerFN": "",
                        "providerLN": "",
                        "providerNPI": "",
                        "providerFlow": 'Other'
                    });
                } else{
                action.setParams({
                    "memberId": memberObj.memberId, //USS2221006
                    "memberDOB": memberDOB,
                    "firstName": memberObj.firstName,
                    "lastName": memberObj.lastName,
                    "groupNumber": '',
                    "searchOption": 'MemberIDNameDateOfBirth',
                    'payerID': payerValue,// US1944108
                    "providerFN": providerInfo.firstName,
                    "providerLN": providerInfo.lastName,
                    "providerNPI": providerInfo.npi,
                    "providerFlow": cmp.get('v.providerFlow')
                });
                } // End of Code - Thanish - DE285319 - 5th Dec 2019

                action.setCallback(this, function (response) {
                    var state = response.getState();
                    if (state == 'SUCCESS') {
                        cmp.set('v.isMms', true);
                        var result = response.getReturnValue();

                        if (result.statusCode == 200) {
                            helper.hideMemberSpinner(cmp);
                            addMembers[selectedCard].showCard = true;
                            addMembers[selectedCard].addMemberCard = false;
                            addMembers[selectedCard].subjectCard = result.resultWrapper.subjectCard;
                            addMembers[selectedCard].subjectCard.searchOption = 'NameDateOfBirth';
                            addMembers[selectedCard].memberProviderResultlst = result.resultWrapper.memberProviderResultlst;
                            addMembers[selectedCard].mnf = '';
                            addMembers[selectedCard].isdelete = true;
                            var ssnValue = addMembers[selectedCard].subjectCard.SSN;
                            var eeIdValue = addMembers[selectedCard].subjectCard.EEID;
                            addMembers[selectedCard].subjectCard.maskedSSN = 'xxx-xx-'+ssnValue.substring(5,9);
                            addMembers[selectedCard].subjectCard.formattedSSN = ssnValue.substring(0,3)+'-'+ssnValue.substring(3,5)+'-'+ssnValue.substring(5,9);
                            addMembers[selectedCard].subjectCard.maskedEEID = 'xxxxx'+eeIdValue.substring(5,9);
                            cmp.set('v.addMembers', addMembers);
                            //mm
                            //uniqueMember = addMembers[srcName].subjectCard.memberId + ";" + addMembers[srcName].subjectCard.firstName + " " + addMembers[srcName].subjectCard.lastName + ";" + searchDetails.dob;
                            /* US2076569 Avish */
                            var memberDOB;
                            if(!$A.util.isEmpty(memberObj.dob)) {
                                var memberDOBArray = memberObj.dob.split("/");
                                memberDOB = memberDOBArray[0] + "/" + memberDOBArray[1] + "/" + memberDOBArray[2];
                            }
                            var uniqueMembersList = cmp.get("v.uniqueMembersList");
                            if(!addMembers[selectedCard].mnfCheckBox){
                                if(uniqueMembersList.length == 0){
                                    uniqueMember = cmp.get("v.providerUniqueId") + ";" + addMembers[selectedCard].subjectCard.memberId + ";" + addMembers[selectedCard].memberProviderResultlst[0].firstName.toUpperCase() + " " + addMembers[selectedCard].memberProviderResultlst[0].lastName.toUpperCase() + ";" + memberDOB;
                                    uniqueMembersList.push(uniqueMember);
                                }else{
                                    for (var i = 0; i < uniqueMembersList.length; i++) {
                                        var alreadySearchedMemberArray = uniqueMembersList[i].split(";");
                                        if(isIndividualSearch){
                                            if(addMembers[selectedCard].subjectCard.memberId != alreadySearchedMemberArray[1] && 
                                            ((addMembers[selectedCard].memberProviderResultlst[0].firstName.toUpperCase() + " " + addMembers[selectedCard].memberProviderResultlst[0].lastName.toUpperCase())  != alreadySearchedMemberArray[2] &&
                                                addMembers[selectedCard].subjectCard.memberDOB != alreadySearchedMemberArray[3])){
                                                uniqueMember = cmp.get("v.providerUniqueId") + ";" + addMembers[selectedCard].subjectCard.memberId + ";" + addMembers[selectedCard].memberProviderResultlst[0].firstName.toUpperCase() + " " + addMembers[selectedCard].memberProviderResultlst[0].lastName.toUpperCase() + ";" + memberDOB;
                                                uniqueMembersList.push(uniqueMember);                                            
                                                break;
                                            }
                                        }else{
                                            if(addMembers[selectedCard].subjectCard.memberId != alreadySearchedMemberArray[1] ||
                                            ((addMembers[selectedCard].memberProviderResultlst[0].firstName.toUpperCase() + " " + addMembers[selectedCard].memberProviderResultlst[0].lastName.toUpperCase())  != alreadySearchedMemberArray[2] &&
                                                memberDOB != alreadySearchedMemberArray[3])){
                                                uniqueMember = cmp.get("v.providerUniqueId") + ";" + addMembers[selectedCard].subjectCard.memberId + ";" + addMembers[selectedCard].memberProviderResultlst[0].firstName.toUpperCase() + " " + addMembers[selectedCard].memberProviderResultlst[0].lastName.toUpperCase() + ";" + memberDOB;
                                                uniqueMembersList.push(uniqueMember);
                                                break;
                                            }
                                        }                                    
                                    }
                                }
                            }else{
                                if(uniqueMembersList.length == 0){
                                    uniqueMember = cmp.get("v.providerUniqueId") + ";" + addMembers[selectedCard].subjectCard.memberId + ";" + addMembers[selectedCard].firstName.toUpperCase() + " " + addMembers[selectedCard].lastName.toUpperCase() + ";" + memberDOB;
                                    uniqueMembersList.push(uniqueMember);
                                }else{

                                }
                            }

                            //uniqueMembersList.push(uniqueMember);
                            
                            var setMemberUnique = new Set();
                            uniqueMembersList.forEach(item => setMemberUnique.add(item));
                            var setUniquememberlts = Array.from(setMemberUnique);
                            cmp.set("v.uniqueMembersList", setUniquememberlts);
                            var appEvent = $A.get("e.c:SAE_SearchedMembersAE");
                            appEvent.setParams({
                                "searchedMember": uniqueMember
                            });
                            appEvent.fire();
                            /* US2076569 Ends */
                            helper.hideMemberSpinner(cmp);
                        } else {
                            helper.hideMemberSpinner(cmp);
                            if (addMembers[selectedCard].showAdvance == true && addMembers[selectedCard].displayMNFFlag == true) {
                                addMembers[selectedCard].mnf = 'mnf';
                            }
                            cmp.set('v.addMembers', addMembers);

                            helper.fireToastMessage('Error!',result.message.replace(". ", ". \n"),'error','dismissible','10000');
                        }
                    }else{
                        helper.hideMemberSpinner(cmp);
                    }
                });
                $A.enqueueAction(action);


            } else {
                console.log('###SINGLE-MEMBER-FLOW(DEFAULT)');
                cmp.set("v.isIndividualSearchOpenSnapshotPage", false);
                //mm
                var isAllValid = false;
                if (!searchDetails.showAdvance) {
                    var mandatoryFields = ["inputDOB", "memberId"]; //, "memFirstNameId", "memLastNameId", "phoneId","zipCodeId"
                    isAllValid = helper.validateAllFields(cmp, event, mandatoryFields, srcName);

                } else {
                    var mandatoryFields = ["inputDOB", "memFirstNameId", "memLastNameId", "phoneId","zipCodeId"];
                    isAllValid = helper.validateAllFields(cmp, event, mandatoryFields, srcName);
                }
                if (isAllValid) {

                    if (!$A.util.isEmpty(searchDetails.memberName) && !$A.util.isEmpty(searchDetails.dob)) {
                        isAllValid = true;
                    } else if (!$A.util.isEmpty(searchDetails.dob) && !$A.util.isEmpty(searchDetails.firstName) && !$A.util.isEmpty(searchDetails.lastName)) {
                        isAllValid = true;
                    }

                    if ((!$A.util.isEmpty(searchDetails.firstName) || !$A.util.isEmpty(searchDetails.lastName))) {
                        var mandatoryFields = ["memFirstNameId", "memLastNameId"];
                        isAllValid = helper.validateFNLN(cmp, mandatoryFields, event, srcName);
                    }

                    if (!$A.util.isEmpty(searchDetails.phone) || !$A.util.isEmpty(searchDetails.zip)) {
                        var mandatoryFields = ["phoneId","zipCodeId"];
                        isAllValid = helper.validateAllFields(cmp, event, mandatoryFields, srcName);
                    }

                    if(!$A.util.isEmpty(searchDetails.memberName)){
                        if((!$A.util.isEmpty(searchDetails.firstName) && !$A.util.isEmpty(searchDetails.lastName) && !$A.util.isEmpty(searchDetails.dob) && !$A.util.isEmpty(searchDetails.groupNumber) &&
                            $A.util.isEmpty(searchDetails.state) && $A.util.isEmpty(searchDetails.zip) && $A.util.isEmpty(searchDetails.phone)) ||
                        (!$A.util.isEmpty(searchDetails.firstName) && !$A.util.isEmpty(searchDetails.lastName) && !$A.util.isEmpty(searchDetails.dob) &&
                            $A.util.isEmpty(searchDetails.state) && $A.util.isEmpty(searchDetails.zip) && $A.util.isEmpty(searchDetails.phone) && $A.util.isEmpty(searchDetails.groupNumber)) ||
                        (!$A.util.isEmpty(searchDetails.lastName) && !$A.util.isEmpty(searchDetails.dob) && $A.util.isEmpty(searchDetails.firstName) &&
                            $A.util.isEmpty(searchDetails.state) && $A.util.isEmpty(searchDetails.zip) && $A.util.isEmpty(searchDetails.phone) && $A.util.isEmpty(searchDetails.groupNumber)) ||
                        (!$A.util.isEmpty(searchDetails.firstName) && !$A.util.isEmpty(searchDetails.lastName) && $A.util.isEmpty(searchDetails.dob) &&
                            $A.util.isEmpty(searchDetails.state) && $A.util.isEmpty(searchDetails.zip) && $A.util.isEmpty(searchDetails.phone) && $A.util.isEmpty(searchDetails.groupNumber)) ||
                        (!$A.util.isEmpty(searchDetails.firstName) && !$A.util.isEmpty(searchDetails.dob) && $A.util.isEmpty(searchDetails.lastName) &&
                            $A.util.isEmpty(searchDetails.state) && $A.util.isEmpty(searchDetails.zip) && $A.util.isEmpty(searchDetails.phone) && $A.util.isEmpty(searchDetails.groupNumber)) ||
                        (!$A.util.isEmpty(searchDetails.dob)) ||
                        ($A.util.isEmpty(searchDetails.firstName) && $A.util.isEmpty(searchDetails.lastName) && $A.util.isEmpty(searchDetails.dob) &&
                            $A.util.isEmpty(searchDetails.groupNumber) && (!$A.util.isEmpty(searchDetails.zip)) && (!$A.util.isEmpty(searchDetails.phone)) &&
                            (!$A.util.isEmpty(searchDetails.state))) ||
                        ($A.util.isEmpty(searchDetails.firstName) && $A.util.isEmpty(searchDetails.lastName) &&
                            $A.util.isEmpty(searchDetails.dob) && $A.util.isEmpty(searchDetails.groupNumber) && ($A.util.isEmpty(searchDetails.zip)) &&
                            ($A.util.isEmpty(searchDetails.phone)) && ($A.util.isEmpty(searchDetails.state)))
                        ){
                            isAllValid = true;
                            addMembers[srcName].validationFlag = false;
                            addMembers[srcName].fieldValidationFlag = false;
                            cmp.set('v.addMembers', addMembers);
                        }else{
                            isAllValid = false;
                            addMembers[srcName].validationFlag = true;
                            cmp.set('v.addMembers', addMembers);
                        }
                    }else if($A.util.isEmpty(searchDetails.memberName) && (!$A.util.isEmpty(searchDetails.firstName) && !$A.util.isEmpty(searchDetails.lastName) && !$A.util.isEmpty(searchDetails.dob))){
                        isAllValid = true;
                        addMembers[srcName].validationFlag = false;
                        addMembers[srcName].fieldValidationFlag = false;
                        cmp.set('v.addMembers', addMembers);
                    }else{
                        isAllValid = false;
                        addMembers[srcName].validationFlag = true;
                        cmp.set('v.addMembers', addMembers);
                    }

                }

                /* US2076569 Avish */

                var uniqueMembersList = cmp.get("v.uniqueMembersList");
                for (var i of uniqueMembersList) {
                    if(i == undefined){
                        uniqueMembersList = [];
                        break;
                    }
                }
                cmp.set("v.uniqueMembersList", uniqueMembersList);

                if(helper.verifyDuplicateMember(cmp, event,srcName,helper)){
                    return;
                }
                /*US2076569 Ends */

                if (isAllValid) {
                    helper.showMemberSpinner(cmp);
                    var uniqueMember = "";
                    var memberDOB = "";
                    if (!$A.util.isEmpty(searchDetails.dob)) {
                        var memberDOBArray = searchDetails.dob.split("-");
                        memberDOB = memberDOBArray[1] + "/" + memberDOBArray[2] + "/" + memberDOBArray[0];
                    }

                    if (searchDetails.showAdvance == true) {
                        searchDetails.displayMNFFlag = true;
                    } else {
                        searchDetails.displayMNFFlag = false;
                    }

                    //
                    var memberIdVal = searchDetails.memberName;
                    var searchOptionVal = "";

                    //US2020384 : START (Updates to Additional Member Search Integration - Malinda)
                    if(memberIdVal != '' && $A.util.isEmpty(searchDetails.firstName) && $A.util.isEmpty(searchDetails.lastName) &&
                    $A.util.isEmpty(searchDetails.groupNumber) && (searchDetails.dob == '' || searchDetails.dob == null)) {
                        cmp.set("v.isIndividualSearch", true);
                        console.log('###INDIVIDUAL-SEARCH (MULTIMPLE-RESULTS) - FLOW');
                    }else{
                        cmp.set("v.isIndividualSearch", false);
                        console.log('###NON-INDIVIDUAL-SEARCH (SINGLE-RESULTS) - FLOW');
                    }
                    //US2020384 : END

                    if (memberIdVal != '' && (!$A.util.isEmpty(searchDetails.firstName)) && (!$A.util.isEmpty(searchDetails.lastName)) && (!$A.util.isEmpty(searchDetails.groupNumber)) && searchDetails.dob != '') {
                        searchOptionVal = 'MemberIDNameGroupNumberDateOfBirth';
                    } else if (memberIdVal != '' && (!$A.util.isEmpty(searchDetails.firstName)) && (!$A.util.isEmpty(searchDetails.lastName)) && searchDetails.dob != '') {
                        searchOptionVal = 'MemberIDNameDateOfBirth';
                    } else if (memberIdVal != '' && (!$A.util.isEmpty(searchDetails.firstName)) && (!$A.util.isEmpty(searchDetails.lastName))) {
                        searchOptionVal = 'MemberIDName';
                    } else if (memberIdVal != '' && (!$A.util.isEmpty(searchDetails.lastName)) && searchDetails.dob != '') {
                        searchOptionVal = 'MemberIDLastNameDateOfBirth';
                    } else if (memberIdVal != '' && (!$A.util.isEmpty(searchDetails.firstName)) && searchDetails.dob != '') {
                        searchOptionVal = 'MemberIDFirstNameDateOfBirth';
                    } else if ((!$A.util.isEmpty(searchDetails.firstName)) && (!$A.util.isEmpty(searchDetails.lastName)) && searchDetails.dob != '') {
                        searchOptionVal = 'NameDateOfBirth';
                    } else if (memberIdVal != '' && searchDetails.dob != '') {
                        searchOptionVal = 'MemberIDDateOfBirth';
                    }

                    //US1944108 - Accommodate Multiple Payer ID's
                    var payerValue;
                    if(addMembers[srcName].payerObj != undefined && addMembers[srcName].payerObj != null){
                        payerValue = addMembers[srcName].payerObj.payerValue;
                    }
                    else {
                        payerValue = '87726';
                    }
                    var providerInfo = cmp.get('v.interactionCard');
                    var action = cmp.get('c.findMembers');

                    // Thanish - DE285319 - 5th Dec 2019
                    // E2EFix - 06/12/2019 - Sarma
                    if(!cmp.get('v.isOtherSearch') && !cmp.get('v.providerNotFound')){
                    action.setParams({
                        "memberId": searchDetails.memberName,
                        "memberDOB": searchDetails.dob,
                        "firstName": searchDetails.firstName,
                        "lastName": searchDetails.lastName,
                        "groupNumber": searchDetails.groupNumber,
                        "searchOption": searchOptionVal,
                        "payerID": payerValue,  // US1944108
                        "providerFN": providerInfo.firstName,
                        "providerLN": providerInfo.lastName,
                        "providerNPI": providerInfo.npi,
                        "providerFlow": cmp.get('v.providerFlow')
                    });
                    } else{
                        action.setParams({
                            "memberId": searchDetails.memberName,
                            "memberDOB": searchDetails.dob,
                            "firstName": searchDetails.firstName,
                            "lastName": searchDetails.lastName,
                            "groupNumber": searchDetails.groupNumber,
                            "searchOption": searchOptionVal,
                            "payerID": payerValue,  // US1944108
                            "providerFN": "",
                            "providerLN": "",
                            "providerNPI": "",
                            "providerFlow": 'Other'
                        });
                    } // End of Code - Thanish - DE285319 - 5th Dec 2019

                    action.setCallback(this, function (response) {
                        var state = response.getState();
                        if (state == 'SUCCESS') {
                            //US1889740 - Sarma (Date: 6th Aug 2019) - Misdirect Case creation : Enabling MMS on Success search
                            cmp.set('v.isMms', true);
                            var result = response.getReturnValue();

                            if (result.statusCode == 200) {
                                helper.hideMemberSpinner(cmp);
                                //US2020384 : START (Updates to Additional Member Search Integration - Malinda)
                                if(cmp.get("v.isIndividualSearch")) {
                                    let lstMemberResponse = result.resultWrapper.lstSAEMemberStandaloneSearch;

                                    if(!$A.util.isEmpty(lstMemberResponse)) {

                                        let lstMainMembers = cmp.get('v.addMembers');

                                        if(!$A.util.isEmpty(lstMainMembers)) {

                                            lstMainMembers[srcName].isMultipleMemberResponse = true;
                                            lstMainMembers[srcName].isFindIndividualSearch = true;
                                            lstMainMembers[srcName].multipleMemberResponses = lstMemberResponse;
                                            cmp.set("v.findIndividualSearchResults",lstMainMembers[srcName]);
                                            cmp.set('v.addMembers',lstMainMembers);
                                            cmp.set('v.showResults',true);
                                            cmp.set('v.searchValue','');
                                        } else {
                                            console.log('###MAIN-MEMBERS-EMPTY');
                                        }

                                    } else {
                                        console.log('###INDIVIDUAL-SEARCH-RESULT-EMPTY');
                                    }
                                } else {
                                    //cmp.set("v.subjectCard", result.resultWrapper.subjectCard);
                                    addMembers[srcName].showCard = true;
                                    addMembers[srcName].addMemberCard = false;
                                    addMembers[srcName].subjectCard = result.resultWrapper.subjectCard;
                                    addMembers[srcName].subjectCard.searchOption = searchOptionVal;
                                    addMembers[srcName].memberProviderResultlst = result.resultWrapper.memberProviderResultlst;
                                    addMembers[srcName].mnf = '';
                                    addMembers[srcName].isdelete = true;
                                    
                                    var ssnValue = addMembers[srcName].subjectCard.SSN;
                                    var eeIdValue = addMembers[srcName].subjectCard.EEID;
                                    addMembers[srcName].subjectCard.maskedSSN = 'xxx-xx-'+ssnValue.substring(5,9);
                                    addMembers[srcName].subjectCard.formattedSSN = ssnValue.substring(0,3)+'-'+ssnValue.substring(3,5)+'-'+ssnValue.substring(5,9);
                                    addMembers[srcName].subjectCard.maskedEEID = 'xxxxx'+eeIdValue.substring(5,9);
                                    cmp.set('v.addMembers', addMembers);
                                    //mm
                                    //uniqueMember = addMembers[srcName].subjectCard.memberId + ";" + addMembers[srcName].subjectCard.firstName + " " + addMembers[srcName].subjectCard.lastName + ";" + searchDetails.dob;
                                    if(!$A.util.isEmpty(searchDetails.dob)){
                                        var memberDOBArray = searchDetails.dob.split("-");
                                        var memberDOB = memberDOBArray[1] + "/" + memberDOBArray[2] + "/" + memberDOBArray[0];
                                    }
                                    //uniqueMember = cmp.get("v.providerUniqueId") + ";" + addMembers[srcName].subjectCard.memberId + ";" + addMembers[srcName].memberProviderResultlst[0].firstName + " " + addMembers[srcName].memberProviderResultlst[0].lastName + ";" + memberDOB;
                                    var uniqueMembersList = cmp.get("v.uniqueMembersList");
                                    /* US2076569 Avish */
                                    for (var i of uniqueMembersList) {
                                        if(i == undefined){
                                            uniqueMembersList = [];
                                            break;
                                        }
                                }
                                if(uniqueMembersList.length == 0){
                                    uniqueMember = cmp.get("v.providerUniqueId") + ";" + addMembers[srcName].subjectCard.memberId + ";" + addMembers[srcName].memberProviderResultlst[0].firstName + " " + addMembers[srcName].memberProviderResultlst[0].lastName + ";" + memberDOB;
                                    uniqueMembersList.push(uniqueMember);
                                }else{
                                    var isOtherSearch = cmp.get("v.isOtherSearch");
                                    if(isOtherSearch){
                                        var compareToDOB;
                                        console.log(JSON.stringify(addMembers[srcName].subjectCard));
                                        console.log(addMembers[srcName].dob.indexOf('-'));
                                        if(addMembers[srcName].dob.indexOf('-') != -1){
                                            var mnfDOB = addMembers[srcName].dob.split('-');
                                            checkHyphen = mnfDOB[1] + '/' + mnfDOB[2] + '/' + mnfDOB[0];
                                            compareToDOB = helper.formatDateMMDDYYYY(cmp,checkHyphen.split('/'));
                                        }
                                        
                                        if(addMembers[srcName].showAdvance){
                                            for (var i=0;i <uniqueMembersList.length;i++) {
                                                var alreadySearchedMemberArray = uniqueMembersList[i].split(";");
                                                if((addMembers[srcName].memberName != alreadySearchedMemberArray[1]) || 
                                                    (((addMembers[srcName].firstName + " " + addMembers[srcName].lastName) != alreadySearchedMemberArray[2]) &&
                                                    (compareToDOB != alreadySearchedMemberArray[3]))){
                                                    uniqueMember = 'Other' + ";" + addMembers[srcName].subjectCard.memberId + ";" + addMembers[srcName].subjectCard.firstName + " " + addMembers[srcName].subjectCard.lastName + ";" + addMembers[srcName].subjectCard.memberDOB;
                                                    uniqueMembersList.push(uniqueMember);
                                                    break;
                                                }
                                            }
                                        }else{
                                            for (var i=0;i < uniqueMembersList.length;i++) {
                                                var alreadySearchedMemberArray = uniqueMembersList[i].split(";");
                                                if((addMembers[srcName].memberName != alreadySearchedMemberArray[1]) ||   
                                                    (compareToDOB != alreadySearchedMemberArray[3])){
                                                    uniqueMember = 'Other' + ";" + addMembers[srcName].subjectCard.memberId + ";" + addMembers[srcName].subjectCard.firstName + " " + addMembers[srcName].subjectCard.lastName + ";" + addMembers[srcName].subjectCard.memberDOB;
                                                    uniqueMembersList.push(uniqueMember);
                                                    break;
                                                }
                                            }
                                        }
                                        
                                    }else{
                                        for (var i=0;i <uniqueMembersList.length;i++) {
                                            var alreadySearchedMemberArray = uniqueMembersList[i].split(";");
                                            if((addMembers[srcName].memberName != alreadySearchedMemberArray[1]) ||
                                                (((addMembers[srcName].firstName + " " + addMembers[srcName].lastName) != alreadySearchedMemberArray[2]) &&
                                                (addMembers[srcName].dob != alreadySearchedMemberArray[3]))){
                                                uniqueMember = cmp.get("v.providerUniqueId") + ";" + addMembers[srcName].subjectCard.memberId + ";" + addMembers[srcName].memberProviderResultlst[0].firstName + " " + addMembers[srcName].memberProviderResultlst[0].lastName + ";" + memberDOB;
                                                uniqueMembersList.push(uniqueMember);
                                                break;
                                            }
                                        }
                                    }
                                    
                                }
                                    cmp.set("v.uniqueMembersList", uniqueMembersList);
                                    var appEvent = $A.get("e.c:SAE_SearchedMembersAE");
                                    appEvent.setParams({
                                        "searchedMember": uniqueMember
                                    });
                                    appEvent.fire();
                                    /* US2076569 Ends */
                                }
                                //US2020384 : END
                                helper.hideMemberSpinner(cmp);
                                //mm
                            } else {
                                helper.hideMemberSpinner(cmp);
                                if (addMembers[srcName].showAdvance == true && addMembers[srcName].displayMNFFlag == true) {
                                    addMembers[srcName].mnf = 'mnf';
                                }
                                cmp.set('v.addMembers', addMembers);
                                console.log('addMembers@@@ ' + addMembers);
                                //helper.fireToast(result.message);

                                // US1857711 - Error Message Handling
                                // Sanka Dharmasena - 17.07.2019
                                helper.fireToastMessage('Error!',result.message.replace(". ", ". \n"),'error','dismissible','10000');
                            }
                        }else{
                            helper.hideMemberSpinner(cmp);
                        }
                    });
                    $A.enqueueAction(action);
                }
            }
        }
    },

    clearMemberCardInputs: function (cmp, event, helper) {
        debugger;
        var source = event.getSource();
        var srcName = source.get('v.name');
        helper.clearFieldValues(cmp, event, srcName);
        var mandatoryFields = ["inputDOB", "memberId"]; //,"memberId","memFirstNameId","memLastNameId","stateMemId","phoneId"
        helper.clearFieldValidations(cmp, mandatoryFields, event, srcName);

        // US1944108 - Accommodate Multiple Payer ID's - Kavinda - START
        var defaultPayerValue = cmp.get('v.defaultPayerValue');
        var defaultPayerLabel = cmp.get('v.defaultPayerLabel');
        var addMembers = cmp.get('v.addMembers');
        var index = source.get('v.name');
        var payerObj = {};
        payerObj.payerValue = defaultPayerValue;
        payerObj.payerLabel = defaultPayerLabel;
        payerObj.typeText = defaultPayerLabel;
        payerObj.displayPayer = false;
        addMembers[index].payerObj = payerObj;
        $A.util.removeClass(addMembers[index], "slds-has-error");
        $A.util.removeClass(addMembers[index], "show-error-message");
        $A.util.removeClass(addMembers[index], "slds-form-element__help");
        $A.util.addClass(addMembers[index], "hide-error-message");

        cmp.set('v.addMembers', addMembers);

        // US1944108 - Accommodate Multiple Payer ID's - Kavinda - END

    },

    clickAdvanceSearch: function (cmp, event, helper) {
        var srcName = event.target.tabIndex;
        var addFields = cmp.get('v.addMembers');
        addFields[srcName].showAdvance = true;


        cmp.set('v.addMembers', addFields);
    },

    hideAdvanceSearch: function (cmp, event, helper) {
        var srcName = event.target.tabIndex;
        var addFields = cmp.get('v.addMembers');
        addFields[srcName].showAdvance = false;

        cmp.set('v.addMembers', addFields);
    },

	//Fixed As a part of Regression defects 08232019
    onChangePhone: function (cmp, event, helper) {
        var source = event.getSource();
        var srcName = source.get('v.name');
        helper.checkIfNotNumberPhone(cmp, event,srcName);
    },
    onChangeZipCode: function (cmp, event, helper) {
        var source = event.getSource();
        var srcName = source.get('v.name');
        helper.keepOnlyDigits(cmp, event,srcName);
    },
    //Ends
    onChangeMemberID: function (cmp, event, helper) {
        var source = event.getSource();
        var srcName = source.get('v.name');
        helper.checkIfNotNumberMember(cmp, event,srcName);
    },

    handleChangeMNF: function (cmp, event, helper) {
        var source = event.getSource();
        var cardNo = source.get('v.name');

        if (!source.get('v.checked')) {
            var mandatoryFields = ["memFirstNameId", "memLastNameId", "stateMemId", "phoneId"];
            helper.validateAllFields(cmp, event, mandatoryFields, cardNo);
        }
    }
})