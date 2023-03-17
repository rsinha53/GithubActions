({
    addSearchedMember: function (cmp, event) {
        if(!cmp.get('v.isOtherSearch')){
            // Fix - DE246060 - Ravindra - 17-07-2019
            if (event.getParam("clearMemberSearchArray")) {
                //var memberSearches = [];
                //cmp.set("v.memberSearches", memberSearches);
                var memberSearches = cmp.get("v.memberSearches");
                
                for (var i = 0; i < memberSearches.length; i++) {
                    if(memberSearches[i] != undefined){
                        var alreadySearchedMemberArray = memberSearches[i].split(";");
                        if (event.getParam("providerUniqueId") == alreadySearchedMemberArray[0]) {
                            if (memberSearches.length == 1) {
                                memberSearches = [];
                            } else {
                                memberSearches = memberSearches.splice(i, 1);
                            }
                        
                        }
                    }
                }
                cmp.set("v.memberSearches", memberSearches);
                /**** Code added by Avish on 07/25/2019 ***/
                cmp.set("v.subjectCard", '');
                cmp.set("v.interactionCard", null);
                cmp.set("v.checkFlagmeberCard",false);
                cmp.set("v.mnfDetailsLst", '');
                /** code ends here ***/
            } else {
                var memberSearches = cmp.get("v.memberSearches");
                memberSearches.push(event.getParam("searchedMember"));
                cmp.set("v.memberSearches", memberSearches);
            }
        }
    },
    
    setProviderDetails: function (cmp, event, helper) {
        cmp.set("v.providerValidated", event.getParam("providerValidated"));
        cmp.set("v.providerDetails", event.getParam("providerDetails"));
        cmp.set("v.isProviderSearchDisabled", event.getParam("isProviderSearchDisabled"));
        cmp.set("v.providerNotFound", event.getParam("providerNotFound"));
        
        cmp.set("v.providerSelected", event.getParam("providerSelected"));
    },
    
    navigateToInteraction : function(cmp,event,helper){
        helper.navigateToInteractionHelper(cmp,event,helper,true);
    },
    
    handleChange: function (cmp, event) {
        var selectedOptionValue = event.getParam("value");
    },
    
    chooseCallOPtions:function (cmp, event) {
        var selectedCallVal = event.getParam("value");
        cmp.set("v.interactionType",selectedCallVal);        
    },
    
    checkProviderValidation:function(cmp,event,helper){
        
        
        //Group all the fields ids into a JS array
        var controlAuraIds = ["taxID","contactNameId"];
        //reducer function iterates over the array and return false if any of the field is invalid otherwise true.
        let isAllValid = controlAuraIds.reduce(function(isValidSoFar, controlAuraId){
            //fetches the component details from the auraId
            var inputCmp = cmp.find(controlAuraId);
            //displays the error messages associated with field if anys
            inputCmp.reportValidity();
            //form will be invalid if any of the field's valid property provides false value.
            return isValidSoFar && inputCmp.checkValidity();
        },true);
    },
    
    getMemberRowInfoFromResults: function (cmp, event, helper) {
        debugger;
        var selectedMemberDetails = event.getParam('selectedMemberDetails');
        //rr
        cmp.set("v.selectedMemberDetails", selectedMemberDetails);
        var sourceSystem = selectedMemberDetails.sourceCode;
        var name = selectedMemberDetails.Name;
        var dob = selectedMemberDetails.DOB;
        
        //US2589590 - Avish
        var address = selectedMemberDetails.address.addressLine1 + ' ' + selectedMemberDetails.address.city + ' '
        + selectedMemberDetails.address.postalCode + ' ' + selectedMemberDetails.address.stateCode;
        var totalRow = sourceSystem + ' ' + name + ' ' + address + ' ' + dob;
        cmp.set("v.searchMemberResults", totalRow);
        
        // US1699139 - Continue button - Sanka
        cmp.set("v.validFlowMember", true);

        /***DE284690 - Avish - Removed below code snippet ***/
    },

    init : function(component, event, helper) {
        var staticLabel = $A.get("$Label.c.ph_DOB");
    },
    checkValidation:function(cmp,event,helper){
        helper.getProviderDetails(cmp);
        
        if (cmp.get("v.providerSelected") || cmp.get("v.providerNotFound") || cmp.get("v.isProviderSearchDisabled") || cmp.get("v.isOtherSearch")) {
        } else {
            helper.fireToastMessage("Error!", "Complete provider search.", "error", "dismissible", "10000");
           return;
        }
        
        // US2031725 - Validation for Explore - Other (Third Party) - Kavinda
        var isOtherSearch = cmp.get('v.isOtherSearch');
        if (isOtherSearch) {
            helper.executeOtherSearchValidations(cmp, event, helper);
            var isValidOtherSearch = cmp.get('v.isValidOtherSearch');
            if (!isValidOtherSearch){
                return;
            }
            
        }
        
        //US1708392 - Malinda
        var memId = cmp.find('memberId').get('v.value'); 
        var memFirstName = cmp.find('memFirstNameId').get('v.value'); 
        var memLastName = cmp.find('memLastNameId').get('v.value'); 
        var memDOB = cmp.find('inputDOB').get('v.value'); 
        var memGroupNo = cmp.find('memGroupNumberId').get('v.value');  
        var memZCodeIdVal = cmp.find('memZipCodeId').get('v.value');
        var memPhoneNumVal = cmp.find('memPhoneNumber').get('v.value');
        var memstateVal = cmp.find('stateMemId').find('provStateId').get("v.value");
        
        
        var dobId = cmp.find('inputDOB');
        var memFNameId = cmp.find('memFirstNameId');
        var memLNameId = cmp.find('memLastNameId');
        var memGroupId = cmp.find('memGroupNumberId');
        var memZCodeId = cmp.find('memberId');
        var memPhoneNum = cmp.find('memPhoneNumber');
        
        cmp.set("v.responseData",null);
        
        if(cmp.get('v.showHideMemAdvSearch') == true){
            cmp.set("v.displayMNFFlag",true);
        }else{
            cmp.set("v.displayMNFFlag",false);
        }
        
        $A.util.removeClass(cmp.find("msgtxt"), "slds-show")
        
        
        var isAllValid = false;
        var controlAuraIds =  [];
        if(cmp.get('v.disableProviderSec') == true){
            if(cmp.get('v.showHideMemAdvSearch')){
                controlAuraIds = ["memberId","inputDOB","memPhoneNumber","memZipCodeId","memContactId","memFirstNameId","memLastNameId", "memContactNumber"]; //"stateMemId" // US416376
                isAllValid = helper.validateAllFields(cmp, event, controlAuraIds);
            }else{
                controlAuraIds = ["memberId","inputDOB","memContactId", "memContactNumber"]; //"stateMemId" // US416376
                isAllValid = helper.validateAllFields(cmp, event, controlAuraIds);
            }
        }else{
            if(cmp.get('v.disableProviderSec')){
                controlAuraIds = ["memberId","inputDOB","memContactId", "memContactNumber"]; // US416376
                isAllValid = helper.validateAllFields(cmp, event, controlAuraIds);
            }else{
                controlAuraIds = ["memberId","inputDOB"];
                isAllValid = helper.validateAllFields(cmp, event, controlAuraIds);
            }
        }        
        
        //DE260181 - Sanka
        if(cmp.get('v.disableProviderSec') && !cmp.get('v.isOtherSearch')){
            var fieldElement = cmp.find("memContactId");
            if(!fieldElement.checkValidity()){
                isAllValid = false;
                fieldElement.reportValidity();
                
                //Fix - Error Message not getting displayed
                $A.util.removeClass(fieldElement, "hide-error-message");
            }
        }
        
        if(isAllValid ){

            var controlAuraIds2 = ["memFirstNameId","memLastNameId"];
            var isFLNamesValid = controlAuraIds2.reduce(function(isValidSoFar, controlAuraId){
                //fetches the component details from the auraId
                var inputCmp = cmp.find(controlAuraId);
                //displays the error messages associated with field if any
                inputCmp.reportValidity();
                //form will be invalid if any of the field's valid property provides false value.
                return isValidSoFar && inputCmp.checkValidity();
            },true);

            //US1708392 start - Sanka
            if(cmp.get("v.showHideMemAdvSearch")){
                var FnameComp = cmp.find("memFirstNameId");
                var LnameComp = cmp.find("memLastNameId");
                if(FnameComp.get("v.value") != ""){
                    //US1797978 - Malinda
                    isFLNamesValid = helper.validateNamesWildCard(cmp,event,helper,true, FnameComp,3);
                    if(!isFLNamesValid) {
                        $A.util.removeClass(cmp.find("msgtxt"), "slds-show")
                        $A.util.addClass(cmp.find("msgtxt"), "slds-hide");
                        $A.util.removeClass(cmp.find("msgTxtFname"), "slds-hide")
                        $A.util.addClass(cmp.find("msgTxtFname"), "slds-show");
                    } else {
                        $A.util.removeClass(cmp.find("msgTxtFname"), "slds-show")
                        $A.util.addClass(cmp.find("msgTxtFname"), "slds-hide");
                    }
                }            
                if(LnameComp.get("v.value") != ""){
                    //US1797978 - Malinda
                    var isLNamesValid = helper.validateNamesWildCard(cmp,event,helper,false, LnameComp,4);
                    if(!isLNamesValid) {
                        $A.util.removeClass(cmp.find("msgtxt"), "slds-show")
                        $A.util.addClass(cmp.find("msgtxt"), "slds-hide");
                        $A.util.removeClass(cmp.find("msgTxtLname"), "slds-hide")
                        $A.util.addClass(cmp.find("msgTxtLname"), "slds-show");
                    } else {
                        $A.util.removeClass(cmp.find("msgTxtLname"), "slds-show")
                        $A.util.addClass(cmp.find("msgTxtLname"), "slds-hide");
                    } 
                }
                //US1797978 - Malinda - zip
                var zipInput = cmp.find("memZipCodeId").get("v.value");
                if($A.util.isEmpty(zipInput)) {
                    $A.util.removeClass(cmp.find("msgTxtZip"), "slds-show")
                    $A.util.addClass(cmp.find("msgTxtZip"), "slds-hide");
                    //$A.util.removeClass(cmp.find("msgtxt"), "slds-hide")
                    //$A.util.addClass(cmp.find("msgtxt"), "slds-show");
                } else if(zipInput.length < 5) {
                    $A.util.removeClass(cmp.find("msgtxt"), "slds-show")
                    $A.util.addClass(cmp.find("msgtxt"), "slds-hide");
                    $A.util.removeClass(cmp.find("msgTxtZip"), "slds-hide")
                    $A.util.addClass(cmp.find("msgTxtZip"), "slds-show");
                } else {
                    $A.util.removeClass(cmp.find("msgTxtZip"), "slds-show")
                    $A.util.addClass(cmp.find("msgTxtZip"), "slds-hide");
                }
                //US1797978 - Malinda - phone
                var phoneInput = cmp.find("memPhoneNumber").get("v.value");
                if($A.util.isEmpty(phoneInput)) {
                    $A.util.removeClass(cmp.find("msgTxtPhone"), "slds-show")
                    $A.util.addClass(cmp.find("msgTxtPhone"), "slds-hide");
                    //$A.util.removeClass(cmp.find("msgtxt"), "slds-hide")
                    //$A.util.addClass(cmp.find("msgtxt"), "slds-show");
                }else if(phoneInput.length < 10) {
                    $A.util.removeClass(cmp.find("msgtxt"), "slds-show")
                    $A.util.addClass(cmp.find("msgtxt"), "slds-hide");
                    $A.util.removeClass(cmp.find("msgTxtPhone"), "slds-hide")
                    $A.util.addClass(cmp.find("msgTxtPhone"), "slds-show");
                } else {
                    $A.util.removeClass(cmp.find("msgTxtPhone"), "slds-show")
                    $A.util.addClass(cmp.find("msgTxtPhone"), "slds-hide");
                }
            }                      
            //end

            if(!$A.util.isEmpty(memId)){
                if((!$A.util.isEmpty(memFirstName) && !$A.util.isEmpty(memLastName) && !$A.util.isEmpty(memDOB) && !$A.util.isEmpty(memGroupNo) && 
                   $A.util.isEmpty(memstateVal) && $A.util.isEmpty(memZCodeIdVal) && $A.util.isEmpty(memPhoneNumVal)) || 
                   (!$A.util.isEmpty(memFirstName) && !$A.util.isEmpty(memLastName) && !$A.util.isEmpty(memDOB) && 
                   $A.util.isEmpty(memstateVal) && $A.util.isEmpty(memZCodeIdVal) && $A.util.isEmpty(memPhoneNumVal) && $A.util.isEmpty(memGroupNo)) || 
                   (!$A.util.isEmpty(memLastName) && !$A.util.isEmpty(memDOB) && $A.util.isEmpty(memFirstName) && 
                   $A.util.isEmpty(memstateVal) && $A.util.isEmpty(memZCodeIdVal) && $A.util.isEmpty(memPhoneNumVal) && $A.util.isEmpty(memGroupNo)) || 
                   (!$A.util.isEmpty(memFirstName) && !$A.util.isEmpty(memLastName) && $A.util.isEmpty(memDOB) && 
                   $A.util.isEmpty(memstateVal) && $A.util.isEmpty(memZCodeIdVal) && $A.util.isEmpty(memPhoneNumVal) && $A.util.isEmpty(memGroupNo)) || 
                   (!$A.util.isEmpty(memFirstName) && !$A.util.isEmpty(memDOB) && $A.util.isEmpty(memLastName) && 
                   $A.util.isEmpty(memstateVal) && $A.util.isEmpty(memZCodeIdVal) && $A.util.isEmpty(memPhoneNumVal) && $A.util.isEmpty(memGroupNo)) || 
                   (!$A.util.isEmpty(memDOB)) || 
                   ($A.util.isEmpty(memFirstName) && $A.util.isEmpty(memLastName) &&
                    $A.util.isEmpty(memDOB) && $A.util.isEmpty(memGroupNo) && (!$A.util.isEmpty(memZCodeIdVal)) && 
                    (!$A.util.isEmpty(memPhoneNumVal)) && (!$A.util.isEmpty(memstateVal))) ||
                  ($A.util.isEmpty(memFirstName) && $A.util.isEmpty(memLastName) &&
                    $A.util.isEmpty(memDOB) && $A.util.isEmpty(memGroupNo) && ($A.util.isEmpty(memZCodeIdVal)) && 
                    ($A.util.isEmpty(memPhoneNumVal)) && ($A.util.isEmpty(memstateVal)))){
                    isAllValid = true;
                    $A.util.removeClass(cmp.find("msgtxt"), "slds-show")
                    $A.util.addClass(cmp.find("msgtxt"), "slds-hide");
                    cmp.set("v.validationFlag",false);
                    cmp.set("v.fieldValidationFlag",false);
                }else{
                    cmp.set("v.mnf",'');
                    cmp.set("v.invalidResultFlag",false);
                    isAllValid = false;    
                    
                    cmp.set("v.validationFlag",true); 
                }
            }else if($A.util.isEmpty(memId) && (!$A.util.isEmpty(memFirstName) && !$A.util.isEmpty(memLastName) && !$A.util.isEmpty(memDOB))){
                isAllValid = true;
                $A.util.removeClass(cmp.find("msgtxt"), "slds-show")
               $A.util.addClass(cmp.find("msgtxt"), "slds-hide");
               cmp.set("v.validationFlag",false);
               cmp.set("v.fieldValidationFlag",false);     
            }else{
                cmp.set("v.mnf",'');
                cmp.set("v.invalidResultFlag",false);
                isAllValid = false;    
                
                cmp.set("v.validationFlag",true);   
            }
            
        }else{
            isAllValid = false;
            cmp.set("v.mnf",'');
            cmp.set("v.invalidResultFlag",false);
            $A.util.removeClass(cmp.find("msgtxt"), "slds-show")
            $A.util.addClass(cmp.find("msgtxt"), "slds-hide"); 
        }                             
        
        
        if(isAllValid != undefined && isAllValid != false){
            // if(isAllValid == undefined || isAllValid){  
            //alert("success!");
            
            // Fix - DE246060 - Sanka Dharmasena - 10.07.2019
            //helper.checkOpnedTab(cmp);
            
            //Avish US2416377
            if(!!$A.util.isEmpty(cmp.get("v.providerNotFound"))) {
                _setandgetvalues.setContactValue('exploreContactData',cmp.get("v.memberContactNameVal"),cmp.get("v.contactNumber"),cmp.get("v.contactExt"));
            }            
            
            //mm
            var providerDetails = cmp.get("v.providerDetails");
            var memberSearches = cmp.get("v.memberSearches");
            var isProviderSearchDisabled = cmp.get("v.isProviderSearchDisabled");
            var memberAlreadySearched = false;
            var providerUniqueId = "";
            //US2132239 : Member Only - No Provider to Search
            let memUniqueId = '';

            if (isProviderSearchDisabled) {
                providerUniqueId = "No Provider To Search";
                cmp.set("v.providerDetails",null);
                providerDetails = null;
            } else if (isOtherSearch){
                providerUniqueId = "Other";
            } else if (!isProviderSearchDisabled){
                providerUniqueId = providerDetails.taxIdOrNPI;
            }

            if(!$A.util.isEmpty(memDOB)){
                var memberDOBArray = memDOB.split("-");
                var memberDOB = memberDOBArray[1] + "/" + memberDOBArray[2] + "/" + memberDOBArray[0];
                memDOB = memberDOB;
            }
            
            if (!$A.util.isEmpty(providerDetails) && providerDetails != null) {
                for (var i = 0; i < memberSearches.length; i++) {
                    if(cmp.get('v.showHideMemAdvSearch')){
                    var alreadySearchedMemberArray = memberSearches[i].split(";");
                        if (providerDetails.taxIdOrNPI == alreadySearchedMemberArray[0] &&
                            (memId == alreadySearchedMemberArray[1] &&
                            ((memFirstName.toUpperCase() + " " + memLastName.toUpperCase() == alreadySearchedMemberArray[2].toUpperCase())
                            && memDOB == alreadySearchedMemberArray[3]))) {
                            memberAlreadySearched = true;
                            //US2132239 : Member Only - No Provider to Search
                            memUniqueId =  memberSearches[i];
                        break;
                    }
                    }else{
                        var alreadySearchedMemberArray = memberSearches[i].split(";");
                        if (providerDetails.taxIdOrNPI == alreadySearchedMemberArray[0] &&
                            (memId == alreadySearchedMemberArray[1] && (memDOB == alreadySearchedMemberArray[3]))) {
                            memberAlreadySearched = true;
                            //US2132239 : Member Only - No Provider to Search
                            memUniqueId =  memberSearches[i];
                            break;
                        }
                    }

                }
            } else {
                //var providerUniqueId = "No Provider To Search";;
                for (var i = 0; i < memberSearches.length; i++) {
                    if(memberSearches[i] != undefined){
                        var alreadySearchedMemberArray = memberSearches[i].split(";");
                        if ((alreadySearchedMemberArray[0] == 'No Provider To Search' || alreadySearchedMemberArray[0] == 'Other') &&
                            (memId == alreadySearchedMemberArray[1] || memFirstName.toUpperCase() + " " + memLastName.toUpperCase() == alreadySearchedMemberArray[2].toUpperCase()) &&
                            memDOB == alreadySearchedMemberArray[3]) {
                            memberAlreadySearched = true;
                            //US2132239 : Member Only - No Provider to Search
                            memUniqueId =  memberSearches[i];
                            break;
                        }
                    }
                }
            }
            //US2132239 : Member Only - No Provider to Search
            if (cmp.get("v.findIndividualWSFlag") && cmp.get('v.isOtherSearch')) {
                memberAlreadySearched = false;
            }

            if (memberAlreadySearched) {
                //US2132239 : Member Only - No Provider to Search
                let mapTabMemUniqueIds;
                let mapTabProviderUniqueIds;
                let mapTabsOtherUniqueIds;
                if (isProviderSearchDisabled) {
                    console.log('###CTRL-OPEN-INTERACTION : NO-PROVIDER-TO-SEARCH');
                    mapTabMemUniqueIds = new Map();
                } else if (isOtherSearch) {
                    console.log('###CTRL-OPEN-INTERACTION : OTHER');
                    mapTabsOtherUniqueIds = new Map();
                } else if (!isProviderSearchDisabled) {
                    console.log('###CTRL-OPEN-INTERACTION : PROVIDER-SEARCH');
                    mapTabProviderUniqueIds = new Map();
                }

                var workspaceAPI = cmp.find("workspace");
                //US2132239 : Member Only - No Provider to Search
                let toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Information!",
                    "message": "Member was already searched.",
                    "type": "warning"
                });
                workspaceAPI.getAllTabInfo().then(function (response) {
                    if (!$A.util.isEmpty(response)) {
                        
                        let isOtherSearch = cmp.get('v.isOtherSearch');

                        for (var i = 0; i < response.length; i++) {
                            //US2132239 : Member Only - No Provider to Search
                            if (isProviderSearchDisabled) {
                                mapTabMemUniqueIds.set(response[i].pageReference.state.c__memberUniqueId,response[i]);
                            } else if (isOtherSearch) {
                                console.log('###CTRL-OPEN-INTERACTION : OTHER');
                                mapTabsOtherUniqueIds.set(response[i].pageReference.state.c__memberUniqueId,response[i]);
                            } else if (!isProviderSearchDisabled) {
                                console.log('###CTRL-OPEN-INTERACTION : PROVIDER-SEARCH');
                                mapTabProviderUniqueIds.set(response[i].pageReference.state.c__providerUniqueId,response[i]);
                            }

                            //US2132239 : Member Only - No Provider to Search
                            if(!isOtherSearch) {
                                var providerDetails = cmp.get('v.providerDetails');
                                if (isProviderSearchDisabled || (response[i].pageReference.state.c__providerUniqueId == providerUniqueId)) {
                                    var appEvent = $A.get("e.c:SAE_RefreshProviderCardAE");
                                    appEvent.setParams({
                                        "providerDetails": providerDetails,
                                        "providerUniqueId": providerUniqueId
                                    });
                                    appEvent.fire();
                                }
                            }

                            //US2132239 : Member Only - No Provider to Search
                            //rr
                            /*
                            var providerDetails = cmp.get('v.providerDetails');
                            if (isProviderSearchDisabled || (response[i].pageReference.state.c__providerUniqueId == providerUniqueId)) {
                                helper.getProviderDetails(cmp);
                                var appEvent = $A.get("e.c:SAE_RefreshProviderCardAE");
                               appEvent.setParams({
                                    "providerDetails": providerDetails,
                                                                                                                                       "providerUniqueId": providerUniqueId
                                });
                                appEvent.fire();
                               workspaceAPI.openTab({
                                    url: response[i].url
                                }).then(function (response) {
                                    workspaceAPI.focusTab({
                                        tabId: response
                                    });
                                    var tabLabel = providerDetails.lastName.charAt(0).toUpperCase() + providerDetails.lastName.slice(1);
                                    workspaceAPI.setTabLabel({
                                        tabId: response,
                                        label: tabLabel
                                    });
                                }).catch(function (error) {
                                    console.log(error);
                                });

                                var toastEvent = $A.get("e.force:showToast");
                                toastEvent.setParams({
                                    "title": "Information!",
                                    "message": "Member was already searched.",
                                    "type": "warning"
                                });
                                toastEvent.fire();


                            }
                            */
                        }

                        //US2132239 : Member Only - No Provider to Search
                        let matchingTab;
                        let tabLabel;
                        if (isProviderSearchDisabled) {
                            if (!$A.util.isEmpty(mapTabMemUniqueIds)) {
                                if(mapTabMemUniqueIds.has(memUniqueId)) {
                                    matchingTab = mapTabMemUniqueIds.get(memUniqueId);
                                    toastEvent.fire();
                                }

                            } else {
                                console.log('###mapTabMemUniqueIds IS EMPTY!');
                            }
                        //US2132239 : Member Only - No Provider to Search
                        } else if (isOtherSearch) {                            

                            if (!$A.util.isEmpty(mapTabsOtherUniqueIds)) {
                                if(mapTabsOtherUniqueIds.has(memUniqueId)) {
                                    matchingTab = mapTabsOtherUniqueIds.get(memUniqueId);
                                    toastEvent.fire();
                                }

                            } else {
                                console.log('###mapTabsOtherUniqueIds IS EMPTY!');
                            }
                        //US2132239 : Member Only - No Provider to Search
                        } else if (!isProviderSearchDisabled) {
                            if (!$A.util.isEmpty(mapTabProviderUniqueIds)) {
                                if(mapTabProviderUniqueIds.has(providerUniqueId)) {
                                    tabLabel = providerDetails.lastName.charAt(0).toUpperCase() + providerDetails.lastName.slice(1);
                                    matchingTab = mapTabProviderUniqueIds.get(providerUniqueId);
                                    toastEvent.fire();
                                }
                            } else {
                                console.log('###mapTabProviderUniqueIds IS EMPTY!');
                            }
                        }

                        console.log('###CTRL-MATCHING-TAB:',matchingTab);

                        //US2132239 : Member Only - No Provider to Search
                        workspaceAPI.openTab({
                            url: matchingTab.url
                        }).then(function (response) {
                            workspaceAPI.focusTab({
                                tabId: matchingTab.tabId
                            });
                            if(!isProviderSearchDisabled && !isOtherSearch) {
                                workspaceAPI.setTabLabel({
                                    tabId: matchingTab.tabId,
                                    label: tabLabel
                                });
                            }
                        }).catch(function (error) {
                            console.log('###TAB-ERROR:',error.toString());
                        });

                    }
                })
                //mm
            } else {
                helper.showMemberSpinner(cmp);
                helper.searchResMembers(cmp, event, helper);
            }
            cmp.set("v.mnf",'');
        } else{
            cmp.set('v.invalidResultFlag',false);
        }  
        
        // US1857809 - TA5477968 - Thanish - start
        // Purpose - Display error message appropriately under member ID field when search button clicked 
        var memIDRequired = cmp.find('memberId').get('v.required');
        var memIDSize = cmp.find('memberId').get('v.value').length;
        var memIdField = cmp.find('memberId');
        if(memIDRequired && (!memIDSize>0)){
            $A.util.removeClass(memIdField, "hide-error-message");
        }
        else{
               $A.util.addClass(memIdField, "hide-error-message");
        }
        // Thanish - End
    },
    onClickMemberClear:function(cmp,event,helper){
        // US1699139 - Continue button - Sanka
        cmp.set('v.validFlowMember',false);

        var todayDate = $A.localizationService.formatDate(new Date(), "YYYY-MM-DD");
        
        
        var memId = cmp.find('memberId');
        var dobId = cmp.find('inputDOB');
        var memFNameId = cmp.find('memFirstNameId');
        var memLNameId = cmp.find('memLastNameId');
        var memGroupId = cmp.find('memGroupNumberId');
        var memZCodeId = cmp.find('memZipCodeId');
        var memPhoneNum = cmp.find('memPhoneNumber');
        //US1797978 - Malinda
        var memContactId = cmp.find('memContactId');
        cmp.set('v.searchMemberResults', "");
        cmp.set("v.display",false);
        
        dobId.set('v.value',todayDate);
        dobId.set('v.value',''); 
        
        // US1944108 - Accommodate Multiple Payer ID's - Kavinda - START
        var defaultPayerValue = cmp.get('v.defaultPayerValue');
        var defaultPayerLabel = cmp.get('v.defaultPayerLabel');
        cmp.set('v.payerValue', defaultPayerValue);
        cmp.set('v.payerLabel', defaultPayerLabel);
        cmp.set('v.typeText', defaultPayerLabel);
        cmp.set('v.displayPayer', false);
        // US1944108 - Accommodate Multiple Payer ID's - Kavinda - END
        
        //Values set to null
        cmp.find("memberId").set("v.value", "");
        cmp.find("inputDOB").set("v.value", "");
        cmp.find("memFirstNameId").set("v.value", "");
        cmp.find("memLastNameId").set("v.value", "");
        cmp.find("memGroupNumberId").set("v.value", "");
        cmp.find("memZipCodeId").set("v.value", "");
        cmp.find("memPhoneNumber").set("v.value", "");  
        //cmp.find("memContactId").set("v.value", "");      //DE339250 - commented
        //US1797978 - Malinda     
        //Added by Vinaybabu for Contact Name Clear Issue
        if (!$A.util.isEmpty(memContactId)) {
            memContactId.set("v.value", "");
            $A.util.removeClass(memContactId, "slds-has-error");
            $A.util.removeClass(memContactId, "show-error-message");
            $A.util.addClass(memContactId, "hide-error-message");
            _setandgetvalues.setContactValue('exploreContactData','','','');
        }

        cmp.set('v.isDobRequired', false);
        cmp.set('v.mnfCheckBox', false);

        // US416376
        var memContactNumber = cmp.find('memContactNumber');
        var memContactEXT = cmp.find('memContactEXT');
        /*** DE339250  ***/
        if (!$A.util.isEmpty(memContactNumber)) {
            memContactNumber.set('v.value', '');
        }
        if (!$A.util.isEmpty(memContactEXT)) {
            memContactEXT.set('v.value', '');
        }
        /*** DE339250  - Ends ***/
        $A.util.removeClass(memContactNumber, "slds-has-error");
        $A.util.removeClass(memContactNumber, "show-error-message");
        $A.util.addClass(memContactNumber, "hide-error-message");
        // memContactNumber.reportValidity(); 
        $A.util.removeClass(memContactEXT, "slds-has-error");
        $A.util.removeClass(memContactEXT, "show-error-message");
        $A.util.addClass(memContactEXT, "hide-error-message");
        // memContactEXT.reportValidity(); 


        //Clearing the Error messages and redborders 
        $A.util.removeClass(memId, "slds-has-error"); 
        $A.util.addClass(memId, "hide-error-message"); 
        $A.util.removeClass(memId, "show-error-message"); // DE255724 - Thanish - 26th Aug 2019.
        $A.util.removeClass(memFNameId, "slds-has-error"); 
        $A.util.addClass(memFNameId, "hide-error-message"); 
        $A.util.removeClass(memLNameId, "slds-has-error"); 
        $A.util.addClass(memLNameId, "hide-error-message"); 
        $A.util.removeClass(memGroupId, "slds-has-error"); 
        $A.util.addClass(memGroupId, "hide-error-message"); 
        $A.util.removeClass(memZCodeId, "slds-has-error"); 
        $A.util.addClass(memZCodeId, "hide-error-message"); 
        $A.util.removeClass(memPhoneNum, "slds-has-error"); 
        $A.util.addClass(memPhoneNum, "hide-error-message");
        //US1797978 - Malinda
        cmp.set('v.fieldValidationFlag',false);
        cmp.set('v.validationFlag',false);
        cmp.set('v.mapError',null);
        //US1797978 - Malinda - zip
        $A.util.removeClass(cmp.find("msgTxtZip"), "slds-show")
        $A.util.addClass(cmp.find("msgTxtZip"), "slds-hide");
        //US1797978 - Malinda - phone
        $A.util.removeClass(cmp.find("msgTxtPhone"), "slds-show")
        $A.util.addClass(cmp.find("msgTxtPhone"), "slds-hide");
        var stateCmp = cmp.find("stateMemId");
        var retnMsg = stateCmp.clearMethod();  
        $A.util.removeClass(stateCmp, "slds-has-error"); 
        $A.util.addClass(stateCmp, "hide-error-message");
        var fNameErrorMsg = cmp.find("msgTxtFname");
        var lNameErrorMsg = cmp.find("msgTxtLname");
        $A.util.removeClass(fNameErrorMsg, "slds-show"); 
        $A.util.addClass(fNameErrorMsg, "slds-hide"); 
        $A.util.removeClass(lNameErrorMsg, "slds-show"); 
        $A.util.addClass(lNameErrorMsg, "slds-hide"); 
        $A.util.removeClass(memContactId, "slds-has-error");  
                              $A.util.addClass(memContactId, "hide-error-message");        
        $A.util.removeClass(memContactId, "show-error-message");
        
        //Wildcard Clear - Sanka
        cmp.set("v.hasFirstNameError",false);
        cmp.set("v.hasLastNameError",false);
        
        $A.util.removeClass(cmp.find("msgtxt"), "slds-show")
        $A.util.addClass(cmp.find("msgtxt"), "slds-hide");
        cmp.find("inputDOB").reportValidity();
        //US1797978 - Malinda
        //REgression fix by Avish on 10/31/2019
        var memberSearches = cmp.get("v.memberSearches");
        memberSearches = [];
        cmp.set("v.memberSearches",memberSearches);
        //Regression fix ends
        var isAdvancedHidden = cmp.get("v.showHideMemAdvSearch");
        if(isAdvancedHidden === false) {
            cmp.set('v.isDobRequired', true);
            return null;
        }    
        
        cmp.set('v.showHideMemAdvSearch', false);
        cmp.set("v.isMemIdRequired", true);
        cmp.set("v.isDobRequired", true);
        cmp.set("v.contactRequired", true);
        var mnfVal = 'test';
        cmp.set("v.mnf", mnfVal);
        
        var appEvent = $A.get("e.c:SAE_ProviderToMember");
        var isCheckedVal = cmp.get('v.mnfCheckBox');
        appEvent.setParams({"isCheckedMemNotFound": false });
        
    },
    showMemAdvaceSearch:function(cmp,event,helper){
        cmp.set('v.showHideMemAdvSearch',false);
        //US1708392 - Malinda
        cmp.set("v.isMemIdRequired", true);
        cmp.set("v.isDobRequired", true);
        
        var checkBoxVar = cmp.get("v.mnfCheckBoxHide");
        cmp.set("v.mnfCheckBoxShow",checkBoxVar);
    },
    hideMemAdvaceSearch: function(cmp,event,helper){
        cmp.set('v.showHideMemAdvSearch',true);
        //US1708392 - Malinda
        cmp.set("v.isMemIdRequired", false);
        cmp.set("v.isDobRequired", false); 
        
        var checkBoxVar = cmp.get("v.mnfCheckBoxShow");
        cmp.set("v.mnfCheckBoxHide",checkBoxVar);
        
    },
    checkIfNotNumber: function(component, event, helper) {
        var letters = /[^a-zA-Z0-9 ]/g;
        var getMemId = component.get("v.input");
        if (getMemId.match(letters)) {
            // alert('test');
            getMemId = getMemId.replace(letters, '');
            component.set("v.input",getMemId);
        }
    },
    
    checkIfNotNumberZip: function(component, event, helper) {
        var letters = /[^0-9 ]/g;
        var getZip = component.get("v.inputZip");
        if (getZip.match(letters)) {
            getZip = getZip.replace(letters, '');
            component.set("v.inputZip",getZip);
        }
    },
    
    checkIfNotNumberPhone: function(component, event, helper) {
        var letters = /[^0-9 ]/g;
        var getPhone = component.get("v.inputPhone");
        if (getPhone.match(letters)) {
            getPhone = getPhone.replace(letters, '');
            component.set("v.inputPhone",getPhone);
        }
    },
    openMemberRecords : function(cmp, event, helper){
        debugger;
        var openMem = cmp.get('v.display');
        /*if(!cmp.set('v.IsOnLoad')){
               cmp.set('v.display',!openMem);
        }
        cmp.set('v.IsOnLoad', false); */
        if(cmp.get("v.responseData") != undefined && cmp.get("v.responseData") != null){
            cmp.set('v.display',!openMem);
            helper.sendMemberDetails(cmp);
        }
    },
    closeMemberRecords : function(cmp, event, helper){
        cmp.set('v.display',false);
    },
    checkGroupValidity: function(cmp, event, helper) {
        var groupInput = cmp.find("memGroupNumberId");
        var validity = groupInput.get("v.validity");
       helper.validateFields(cmp, event, helper, groupInput, validity.valid);
    },
    
    checkPhoneNumber: function(cmp, event, helper) {
        var phoneInput = cmp.find("memPhoneNumber");
        var validity = phoneInput.get("v.validity");
        
        helper.validateFields(cmp, event, helper, phoneInput, validity.valid);
    },
    
    checkZipCode: function(cmp, event, helper) {
        var zipInput = cmp.find("memZipCodeId");
        var validity = zipInput.get("v.validity");
        helper.validateFields(cmp, event, helper, zipInput, validity.valid);
    },
    
    checkContactName: function(cmp, event, helper) {
        var contactNameInput = cmp.find("memContactId");
        var validity = contactNameInput.get("v.validity");
        
        
        helper.validateFields(cmp, event, helper, contactNameInput, validity.valid);
        _setandgetvalues.setContactValue('exploreContactData',cmp.get("v.memberContactNameVal"),cmp.get("v.contactNumber"),cmp.get("v.contactExt"));
    },
    handleChangeMNF: function(cmp, event, helper) {
        //cmp.set('v.showHideMemAdvSearch',true);
    },
    assignInteractionID: function(cmp,event,helper){
        //Get the event message attribute
        var interactionIDVal = event.getParam("interactionEventID");
        //Set the handler attributes based on event data
        cmp.set("v.interactionID", interactionIDVal);
    },
    handleSatetChange:function(cmp,event,helper){
        cmp.set("v.selectedState", event.getParam("selectedState"));
        
    },
    enableContactName:function(cmp,event,helper){
        var noProviderVal = event.getParam('isChecked');
        cmp.set('v.disableProviderSec',noProviderVal);
        var conName = event.getParam('contactName');
        cmp.set('v.memberContactNameVal',conName);

        // US416376  
        var contactNumber = event.getParam('contactNumber');
        cmp.set("v.contactNumber", contactNumber);

        var contactExt = event.getParam('contactExt');
        cmp.set("v.contactExt", contactExt);
        
    },
    handleChangeMNF: function(cmp, event, helper) {
        
        var appEvent = $A.get("e.c:SAE_ProviderToMember");
        var isCheckedVal = cmp.get('v.mnfCheckBox');
        appEvent.setParams({"isCheckedMemNotFound": isCheckedVal });
        appEvent.fire();
        
        
        cmp.set('v.showHideMemAdvSearch',true);
        
        var memFNameId = cmp.find('memFirstNameId');
        var memLNameId = cmp.find('memLastNameId');                
        var memPhoneNum = cmp.find('memPhoneNumber');
        var memState = cmp.find('stateMemId');
        
        
        $A.util.removeClass(memFNameId, "hide-error-message"); 
        $A.util.removeClass(memLNameId, "hide-error-message"); 
        $A.util.removeClass(memPhoneNum, "hide-error-message"); 
        $A.util.removeClass(memState, "hide-error-message"); 
        
        if(cmp.get('v.mnfCheckBox') == false)
            helper.navigateToInteractionHelper(cmp, event, helper,false);
    },
    assignInteractionID: function(cmp,event,helper){
        //Get the event message attribute
        var interactionIDVal = event.getParam("interactionEventID");
        //Set the handler attributes based on event data
        cmp.set("v.interactionID", interactionIDVal);
    },
    
    // US1857809 - TA5477968 - Thanish - Start
    // Purpose - Display error message appropriately under member ID field when search button clicked 
    memberIDfieldOnBlur: function (cmp, event, helper) {
        var memId = cmp.find('memberId');
        $A.util.addClass(memId, "show-error-message");
    },
    
    memberDOBfieldOnBlur: function (cmp, event, helper) {
        var dob = cmp.find('inputDOB');
        $A.util.addClass(dob, "show-error-message");
    },
    
    memberFNfieldOnBlur: function (cmp, event, helper) {
        var FN = cmp.find('memFirstNameId');
        $A.util.addClass(FN, "show-error-message");
    },
    
    memberLNfieldOnBlur: function (cmp, event, helper) {
        var LN = cmp.find('memLastNameId');
        $A.util.addClass(LN, "show-error-message");
    },
    
    memberPhonefieldOnBlur: function (cmp, event, helper) {
        var Phone = cmp.find('memPhoneNumber');
        $A.util.addClass(Phone, "show-error-message");
    },
    // Thanish - End
    
    //DE260181 - Sanka
    memContactOnblur: function (cmp, event, helper) {
        var fieldElement = cmp.find("memContactId");
        $A.util.removeClass(fieldElement, "hide-error-message");
    },
    
    //DE260181 - Sanka
    handleMemberValidity: function(cmp,event,helper){
               //DE264357
        var memberDisabled = cmp.get("v.disableMemberSec");
        if(memberDisabled){
          cmp.set("v.memberValidated", true);
            return;
        }
        var elements = [];
        //Added by Avish as a part US2070352 on 09/30/2019
        if(cmp.get('v.disableProviderSec')){
            elements = ["memberId","inputDOB","memContactId", "memContactNumber"]; // US2045625 // US416376
        }else{
            elements = ["memberId","inputDOB"];
        }
        //US2070352  Ends
        var ErrorCount = 0;
        for (var i in elements) {
            var fieldElement = cmp.find(elements[i]);
            if (!$A.util.isUndefined(fieldElement)) {
                if (!fieldElement.checkValidity()) {
                    ErrorCount++;
                    //Fix - Error Message not getting displayed
                    $A.util.removeClass(fieldElement, "hide-error-message");
                } 
                fieldElement.reportValidity();
            }
        }
        
        if(ErrorCount > 0){
            cmp.set("v.memberValidated",false);
        }
        else{
            cmp.set("v.memberValidated",true);
        }
    },
    changeSearchValue: function (cmp, event, helper) {
        helper.filterMemberResults(cmp, event, helper);
    },
               
    // US1699139 - Continue button - Sanka
    noMemberCheck : function (cmp, event, helper){
        var checked = cmp.get('v.disableMemberSec');
        cmp.set('v.validFlowMember',checked);

        // DE289290 - Avish 
        var memberSearches = cmp.get("v.memberSearches");
        memberSearches = [];
        cmp.set("v.memberSearches",memberSearches);
        // DE289290 - Ends 
    },
	
	// US2291032: Pilot Minot Changes - Move Continue Button to the Top - KAVINDA
    openInteractionFindIndividual: function (cmp, event, helper) {
        var compEvent = cmp.getEvent("ACET_OpenInteractionFindIndividual");
        compEvent.fire();
    },

    // US416376
    checkMandatoryFields: function(cmp, event, helper) {
        var fieldName = event.getSource().get("v.name");
        if (fieldName == "memContactNumberID" || fieldName == "memContactEXTID") {
            helper.keepOnlyDigits(cmp, event);
        }
        var memContactNumber = cmp.find("memContactNumber");
        var validity = memContactNumber.get("v.validity");
        helper.validateFields(cmp, event, helper, memContactNumber, validity.valid);
        _setandgetvalues.setContactValue('exploreContactData',cmp.get("v.memberContactNameVal"),cmp.get("v.contactNumber"),cmp.get("v.contactExt"));
    },

    // US416376
    handleMNFChange: function(cmp, event, helper) {
        var isOtherSearch = cmp.get('v.isOtherSearch'); // DE321696
        var isProviderSearchDisabled = cmp.get("v.isProviderSearchDisabled"); //DE333959 - Avish
        if(event.getParam("value") && isProviderSearchDisabled && !isOtherSearch){ //DE333959 - Avish
            var contactNumber = cmp.get('v.contactNumber');
            cmp.set('v.inputPhone', contactNumber);
        }
    },
    // Praveen
    getContactDetails: function(cmp, event, helper) {
        debugger;
        var appEvent = $A.get("e.c:ACET_SendContactNumber");
        var contactNumber = cmp.get('v.contactNumber');
        var contactExt = cmp.get('v.contactExt');
        appEvent.setParams({ 
            "contactNumber" : contactNumber,
            "contactExt" : contactExt
        });
		appEvent.fire();
    },
    
    /**
     * To Handle VCCD Application Event .
     *
     * @param objComponent To access dom elements.
     * @param objEvent To handle events.
     * @param objHelper To handle events.
     */
    handleVCCDEvent : function (objComponent, objEvent, objHelper) {
        let strMessage = objEvent.getParam("message");
        if($A.util.isUndefinedOrNull(strMessage) === false && strMessage !== '') {
            try {
                let objMessage = JSON.parse(strMessage);
                objComponent.set("v.input",objMessage.objRecordData.MemberId__c);
                console.log('==@@'+JSON.stringify(objMessage));
                objComponent.set("v.isVCCD",objMessage.isVCCD);//US2631703 - Durga- 08th June 2020
                objComponent.set("v.VCCDObjRecordId",objMessage.objRecordData.Id);//US2631703 - Durga- 08th June 2020
                //US2570805 - Sravan - Start
                objComponent.set("v.VCCDQuestionType",objMessage.objRecordData.QuestionType__c);
                //US2570805 - Sravan - Stop
                if($A.util.isUndefinedOrNull(objMessage.objRecordData.SubjectDOB__c) === false) {
                    objComponent.find("inputDOB").set("v.value", objMessage.objRecordData.SubjectDOB__c);
                }
                objEvent.stopPropagation();
            } catch (exception) {
                console.log('Inside VCCD Handle Exception' + exception);
            }
        }
    },

})