({	
    // US2021959 :Code Added By Chandan-start
    setShowSpinner:function (cmp, event,helper) {
        var eventValue= event.getParam("ShowSpinnerValue");
        cmp.set("v.showSpinner", false);
        console.log( cmp.get("v.showSpinner"));
        
    }, // US2021959 :Code Added By Chandan-End
	addSearchedMember: function (cmp, event) {
        // Fix - DE246060 - Ravindra - 17-07-2019
        if (event.getParam("clearMemberSearchArray")) {
            var memberSearches = [];
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
    },
    setProviderDetails: function (cmp, event, helper) {
        cmp.set("v.providerValidated", event.getParam("providerValidated"));
        cmp.set("v.providerDetails", event.getParam("providerDetails"));
        cmp.set("v.isProviderSearchDisabled", event.getParam("isProviderSearchDisabled"));
        cmp.set("v.providerNotFound", event.getParam("providerNotFound"));
    },
    enableContactName:function(cmp,event,helper){
        var noProviderVal = event.getParam('isChecked');
        cmp.set('v.disableProviderSec',noProviderVal);
        var conName = event.getParam('contactName');
        cmp.set('v.memberContactNameVal',conName);
        
    },
    handleSatetChange:function(cmp,event,helper){
        cmp.set("v.selectedState", event.getParam("selectedState"));
        console.log( cmp.get("v.selectedState"));
    },
    onClickMemberClear:function(cmp,event,helper){
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
        
        dobId.set('v.value',todayDate);
        dobId.set('v.value',''); 
        
        //Values set to null
        cmp.find("memberId").set("v.value", "");
        cmp.find("inputDOB").set("v.value", "");
        cmp.find("memFirstNameId").set("v.value", "");
        cmp.find("memLastNameId").set("v.value", "");
        cmp.find("memGroupNumberId").set("v.value", "");
        cmp.find("memZipCodeId").set("v.value", "");
        cmp.find("memPhoneNumber").set("v.value", "");        
        //US1797978 - Malinda     
        //cmp.find("memContactId").set("v.value", "");        
        cmp.set('v.isDobRequired', false); 
        cmp.set('v.mnfCheckBox',false);
        
        //Clearing the Error messages and redborders 
        $A.util.removeClass(memId, "slds-has-error"); 
        $A.util.addClass(memId, "hide-error-message"); 
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
        $A.util.removeClass(memContactId, "slds-has-error"); 
        $A.util.addClass(memContactId, "hide-error-message"); 
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
        
        //Wildcard Clear - Sanka
        cmp.set("v.hasFirstNameError",false);
        cmp.set("v.hasLastNameError",false);
        
        $A.util.removeClass(cmp.find("msgtxt"), "slds-show")
        $A.util.addClass(cmp.find("msgtxt"), "slds-hide");
        cmp.find("inputDOB").reportValidity();
        //US1797978 - Malinda
        var isAdvancedHidden = cmp.get("v.showHideMemAdvSearch");
        if(isAdvancedHidden === false) {
            cmp.set('v.isDobRequired', true);
            return null;
        }    
        
        cmp.set('v.showHideMemAdvSearch', false);
        cmp.set("v.isMemIdRequired", true);
        cmp.set("v.isDobRequired", true);
        var mnfVal = 'test';
        cmp.set("v.mnf", mnfVal);
        
        var appEvent = $A.get("e.c:ACETLinkProvidertoMember");
        var isCheckedVal = cmp.get('v.mnfCheckBox');
        appEvent.setParams({"isCheckedMemNotFound": false });
        appEvent.fire();
        
        
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
    memberIDfieldOnBlur: function (cmp, event, helper) {
        var memId = cmp.find('memberId');
        $A.util.removeClass(memId, "hide-error-message");
    },
    checkContactName: function(cmp, event, helper) {
        var contactNameInput = cmp.find("memContactId");
        var validity = contactNameInput.get("v.validity");
        console.log('**********');
        console.log(validity);
        //alert(validity.valid);
        helper.validateFields(cmp, event, helper, contactNameInput, validity.valid);
    },
    hideMemAdvaceSearch: function(cmp,event,helper){
        cmp.set('v.showHideMemAdvSearch',true);
        //US1708392 - Malinda
        cmp.set("v.isMemIdRequired", false);
        cmp.set("v.isDobRequired", false); 
        console.log('----hide----');
        var checkBoxVar = cmp.get("v.mnfCheckBoxShow");
        cmp.set("v.mnfCheckBoxHide",checkBoxVar);
        
    },
    showMemAdvaceSearch:function(cmp,event,helper){
        cmp.set('v.showHideMemAdvSearch',false);
        //US1708392 - Malinda
        cmp.set("v.isMemIdRequired", true);
        cmp.set("v.isDobRequired", true);
        console.log('----show----');
        var checkBoxVar = cmp.get("v.mnfCheckBoxHide");
        cmp.set("v.mnfCheckBoxShow",checkBoxVar);
    },
    handleChangeMNF: function(cmp, event, helper) {
        //cmp.set('v.showHideMemAdvSearch',true);
    },
    checkGroupValidity: function(cmp, event, helper) {
        var groupInput = cmp.find("memGroupNumberId");
        var validity = groupInput.get("v.validity");
        helper.validateFields(cmp, event, helper, groupInput, validity.valid);
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
    checkValidation:function(cmp,event,helper){
        helper.getProviderDetails(cmp);
        //US1708392 - Malinda
        var memId = cmp.find('memberId').get('v.value'); 
        var memFirstName = cmp.find('memFirstNameId').get('v.value'); 
        var memLastName = cmp.find('memLastNameId').get('v.value'); 
        var memDOB = cmp.find('inputDOB').get('v.value'); 
        var memGroupNo = cmp.find('memGroupNumberId').get('v.value');   
        
        console.log('!!!!!!!!!');
        // var memId = cmp.find('memberId');
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
        console.log('displayMNFFlag**'+cmp.get("v.displayMNFFlag"));
        $A.util.removeClass(cmp.find("msgtxt"), "slds-show")
        
        console.log('^^^^^^^^^');
        console.log(cmp.get('v.disableProviderSec'));
        var controlAuraIds =  [];
        if(cmp.get('v.disableProviderSec') == true){
            controlAuraIds = ["memberId","inputDOB","memPhoneNumber","memZipCodeId","memContactId","memFirstNameId","memLastNameId"]; //"stateMemId"
        }else{
            controlAuraIds = ["memberId","inputDOB","memPhoneNumber","memZipCodeId","memFirstNameId","memLastNameId"];
        }
        
        
        //reducer function iterates over the array and return false if any of the field is invalid otherwise true.
        var isAllValid = controlAuraIds.reduce(function(isValidSoFar, controlAuraId){
            //fetches the component details from the auraId
            var inputCmp='';
            console.log('controlAuraId@@ ' + controlAuraId);
            if(!$A.util.isEmpty(controlAuraId)){
                inputCmp = cmp.find(controlAuraId); 
                
                inputCmp.reportValidity();
                //form will be invalid if any of the field's valid property provides false value.
                return true;
            }else{
                inputCmp.reportValidity();
                //form will be invalid if any of the field's valid property provides false value.
                return false;
            }
            //displays the error messages associated with field if any
            
        },true);
        console.log('newcheck***'+isAllValid);
        if(isAllValid ){
            if((!$A.util.isEmpty(memId) && !$A.util.isEmpty(memFirstName) && !$A.util.isEmpty(memLastName) && !$A.util.isEmpty(memDOB) && !$A.util.isEmpty(memGroupNo) ) ||
               (!$A.util.isEmpty(memId) && !$A.util.isEmpty(memFirstName) && !$A.util.isEmpty(memLastName) && !$A.util.isEmpty(memDOB)) ||
               (!$A.util.isEmpty(memId) && !$A.util.isEmpty(memLastName) && !$A.util.isEmpty(memDOB)) ||
               (!$A.util.isEmpty(memId) && !$A.util.isEmpty(memFirstName) && !$A.util.isEmpty(memLastName)) ||
               (!$A.util.isEmpty(memId) && !$A.util.isEmpty(memFirstName) && !$A.util.isEmpty(memDOB)) ||
               (!$A.util.isEmpty(memFirstName) && !$A.util.isEmpty(memLastName) && !$A.util.isEmpty(memDOB)) ||
               (!$A.util.isEmpty(memId) && !$A.util.isEmpty(memDOB))) { 
                isAllValid = true;
                $A.util.removeClass(cmp.find("msgtxt"), "slds-show")
                $A.util.addClass(cmp.find("msgtxt"), "slds-hide");
                
            } else {
                cmp.set("v.mnf",'');
                cmp.set("v.invalidResultFlag",false);
                isAllValid = false;
                $A.util.removeClass(cmp.find("msgtxt"), "slds-hide");
                $A.util.addClass(cmp.find("msgtxt"), "slds-show");                   
            }  
            
        }else{
            isAllValid = false;
            cmp.set("v.mnf",'');
            cmp.set("v.invalidResultFlag",false);
            $A.util.removeClass(cmp.find("msgtxt"), "slds-show")
            $A.util.addClass(cmp.find("msgtxt"), "slds-hide"); 
        }
        console.log('###@@@ ' + cmp.get("v.invalidResultFlag"));
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
        
        console.log('isAllValid@@@' + isAllValid);
        if(isAllValid != undefined && isAllValid != false){
            // if(isAllValid == undefined || isAllValid){  
            //alert("success!");
            
            // Fix - DE246060 - Sanka Dharmasena - 10.07.2019
            //helper.checkOpnedTab(cmp);
            
            //mm
            helper.showGlobalSpinner(cmp); // US2021959 :Code Added By Chandan-start
            var memberSearches = cmp.get("v.memberSearches");
            var memberAlreadySearched = false;
            for (var i = 0; i < memberSearches.length; i++) {
                var alreadySearchedMemberArray = memberSearches[i].split(";");
                if ((memId == alreadySearchedMemberArray[0] || memFirstName + " " + memLastName == alreadySearchedMemberArray[1]) && memDOB == alreadySearchedMemberArray[2]) {
                    memberAlreadySearched = true;
                    break;
                }
            }
            //if (memberSearches.indexOf(memId + memDOB) != -1) {
            if (memberAlreadySearched) {
                var workspaceAPI = cmp.find("workspace");
                workspaceAPI.getAllTabInfo().then(function (response) {
                    if (!$A.util.isEmpty(response)) {
                        for (var i = 0; i < response.length; i++) {
                            debugger;
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
                })
                //mm
            } else {
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
        console.log('Provider validation...');
        
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
    init : function(component, event, helper) {
        var staticLabel = $A.get("$Label.c.ph_DOB");
    },
    openMemberRecords : function(cmp, event, helper){
        var openMem = cmp.get('v.display');
        cmp.set('v.display',!openMem);
    },
    closeMemberRecords : function(cmp, event, helper){
        cmp.set('v.display',false);
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
    },assignInteractionID: function(cmp,event,helper){
        //Get the event message attribute
        var interactionIDVal = event.getParam("interactionEventID");
        //Set the handler attributes based on event data
        cmp.set("v.interactionID", interactionIDVal);
    },
})