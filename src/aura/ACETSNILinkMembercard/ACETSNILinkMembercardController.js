({	
    
    firstpop:function (cmp, event,helper) {
        cmp.set("v.showMemDetailsModal1", true);
        cmp.set('v.showMemDetailsModal',false);
        
    },
    multipopup:function (cmp, event,helper) {
        
        
        var memberdeta =cmp.get('v.memberDetails.newMemberMatch');
        console.log('memberdeta'+memberdeta);
        var viewIndividualpopupa = cmp.get('v.viewIndividualpopupa');
        console.log('viewIndividualpopupa--14--'+viewIndividualpopupa);
        if(memberdeta.length -1 > viewIndividualpopupa){
            viewIndividualpopupa = viewIndividualpopupa + 1;
            cmp.set('v.viewIndividualpopupa',viewIndividualpopupa);
            cmp.set('v.viewIndividualpopupb',viewIndividualpopupa);
            cmp.set('v.showMemDetailsModal',true);
            cmp.set('v.showMemDetailsModal1',false);
            cmp.set("v.saveDisableFrstPopUp",true);
        }else{
            cmp.set('v.showMemDetailsModal',false);
            cmp.set('v.showMemDetailsModal1',false);
            $A.enqueueAction(cmp.get('c.saveDetails'));
        }
    },
    firstpopno:function (cmp, event,helper) {
        
        var memberdeta =cmp.get('v.memberDetails.newMemberMatch');
        //console.log('memberdeta'+JSON.stringify(memberdeta));
        var viewIndividualpopupa = cmp.get('v.viewIndividualpopupa');
        //console.log('viewIndividualpopupa--'+viewIndividualpopupa);
        if(memberdeta.length -1 > viewIndividualpopupa){
            //console.log('inside if-- 35');
            var adduser =cmp.get('v.addnewUser');
            var selMap = cmp.get("v.selectedRow");
            var rowSelAction = adduser[viewIndividualpopupa];
            var selectedRowArray = [];
            selectedRowArray.push({'sobjectType':'AccountContactRelation'});
            selMap[rowSelAction.serviceMember] = selectedRowArray[0];
            cmp.set("v.selectedRow",selMap);
            viewIndividualpopupa = viewIndividualpopupa + 1;
            cmp.set('v.viewIndividualpopupa',viewIndividualpopupa);
            cmp.set('v.viewIndividualpopupb',viewIndividualpopupa);
        }else{
            var adduser =cmp.get('v.addnewUser');
            var selMap = cmp.get("v.selectedRow");
            var rowSelAction = adduser[viewIndividualpopupa];
            var selectedRowArray = [];
            selectedRowArray.push({'sobjectType':'AccountContactRelation'});
            selMap[rowSelAction.serviceMember] = selectedRowArray[0];
            cmp.set("v.selectedRow",selMap);
            cmp.set('v.showMemDetailsModal',false);
            cmp.set('v.showMemDetailsModal1',false);
            $A.enqueueAction(cmp.get('c.saveDetails'));
        }
        
    },
    
    openRetryModalWhenNo: function (cmp, event,helper) {
        var buttonName = event.getSource().get("v.name");
        cmp.set('v.buttonName', buttonName);
        var houseHoldDataList = cmp.get("v.houseHoldData");
        var lstEids = [];
        for(var i = 0; i<houseHoldDataList.length;i++){
            lstEids.push(houseHoldDataList[i].enterpriseId);
        }
        if(buttonName === 'memberInfoChangePopUpButton'){
            var action = cmp.get("c.validateMembers");
            action.setParams({	
                "lstEids": lstEids	           	
            });	
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state == "SUCCESS") { 
                    var memebersNotExist = response.getReturnValue();
                    if(memebersNotExist === false){
                        var memberdeta =cmp.get('v.memberDetails.newMemberMatch');
                        //console.log('memberdeta'+JSON.stringify(memberdeta));
                        var viewIndividualpopupa = cmp.get('v.viewIndividualpopupa');
                        //console.log('viewIndividualpopupa--'+viewIndividualpopupa);
                        if(memberdeta.length -1 > viewIndividualpopupa){
                            //console.log('inside if-- 35');
                            var adduser =cmp.get('v.addnewUser');
                            var selMap = cmp.get("v.selectedRow");
                            var rowSelAction = adduser[viewIndividualpopupa];
                            var selectedRowArray = [];
                            selectedRowArray.push({'sobjectType':'AccountContactRelation'});
                            selMap[rowSelAction.serviceMember] = selectedRowArray[0];
                            cmp.set("v.selectedRow",selMap);
                            viewIndividualpopupa = viewIndividualpopupa + 1;
                            cmp.set('v.viewIndividualpopupa',viewIndividualpopupa);
                            cmp.set('v.viewIndividualpopupb',viewIndividualpopupa);
                        }else{
                            var adduser =cmp.get('v.addnewUser');
                            var selMap = cmp.get("v.selectedRow");
                            var rowSelAction = adduser[viewIndividualpopupa];
                            var selectedRowArray = [];
                            selectedRowArray.push({'sobjectType':'AccountContactRelation'});
                            selMap[rowSelAction.serviceMember] = selectedRowArray[0];
                            cmp.set("v.selectedRow",selMap);
                            cmp.set('v.showMemDetailsModal',false);
                            cmp.set('v.showMemDetailsModal1',false);
                            $A.enqueueAction(cmp.get('c.saveDetails'));
                        }                
                    }else{                        
                        cmp.set('v.showMemDetailsModal',false);        
                        cmp.set('v.showMemDetailsModalSecnd',false);
                        cmp.set("v.retryModal", true);
                    }
                }
            });
        }else if(buttonName === 'duplicatePoliciesButton'){
            var action = cmp.get("c.validateMembers");
            action.setParams({	
                "lstEids": lstEids	           	
            });	
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state == "SUCCESS") { 
                    var memebersNotExist = response.getReturnValue();
                    if(memebersNotExist === false){
                        
                        var memberdeta =cmp.get('v.memberDetails.newMemberMatch');
                        var viewIndividualpopupc = cmp.get('v.viewIndividualpopupc');
                        
                        if(memberdeta.length -1 > viewIndividualpopupc){
                            var adduser =cmp.get('v.addnewUser');
                            var selMap = cmp.get("v.selectedRow");
                            var rowSelAction = adduser[viewIndividualpopupc];
                            var selectedRowArray = [];
                            selectedRowArray.push({'sobjectType':'AccountContactRelation'});
                            selMap[rowSelAction.serviceMember] = selectedRowArray[0];
                            cmp.set("v.selectfedRow",selMap);
                            viewIndividualpopupc = viewIndividualpopupc + 1;
                            cmp.set('v.viewIndividualpopupc',viewIndividualpopupc);
                            cmp.set('v.viewIndividualpopupd',viewIndividualpopupc);
                        }else{
                            var adduser =cmp.get('v.addnewUser');
                            var selMap = cmp.get("v.selectedRow");
                            var rowSelAction = adduser[viewIndividualpopupc];
                            var selectedRowArray = [];
                            selectedRowArray.push({'sobjectType':'AccountContactRelation'});
                            selMap[rowSelAction.serviceMember] = selectedRowArray[0];
                            cmp.set("v.selectedRow",selMap);
                            cmp.set('v.showMemDetailsModal',false);
                            cmp.set('v.showMemDetailsModal1',false);
                            cmp.set('v.showMemDetailsModalSecnd',false);
                            cmp.set('v.showMemDetailsModalSecnd1',false);
                            $A.enqueueAction(cmp.get('c.saveDetails'));
                        }
                    }else{                        
                        cmp.set('v.showMemDetailsModal',false);        
                        cmp.set('v.showMemDetailsModalSecnd',false);
                        cmp.set("v.retryModal", true);
                    }
                }
            });
        }
        
        $A.enqueueAction(action);        
        
    },
    retryModalAction: function (cmp, event,helper) {
        var memberdata =cmp.get('v.memberDetails.newMemberMatch');
        var buttonName = cmp.get('v.buttonName');
        if(buttonName === 'memberInfoChangePopUpButton'){
            if(memberdata.length >= 1){
                cmp.set("v.retryModal", false);                
                cmp.set('v.showMemDetailsModal',true);                     
            }else{
                cmp.set("v.retryModal", false);                
            }   
        }else if(buttonName === 'duplicatePoliciesButton'){
            cmp.set("v.retryModal", false);                
            cmp.set('v.showMemDetailsModalSecnd',true);                     
        }     
    },
    
    secondpopyes:function (cmp, event,helper) {
        
        var memberdeta =cmp.get('v.memberDetails.newMemberMatch');
        var viewIndividualpopupc = cmp.get('v.viewIndividualpopupc');
        var membernew =memberdeta[viewIndividualpopupc]; 
        var memdata =[];
        var splitName =[];
        var multirowcheck;
        var rows;
        var rows1;
        
        rows = JSON.stringify(membernew);
        var checkMemName = rows.indexOf("memName");
        if (checkMemName == -1) {
            rows1 = rows.substring(rows.indexOf("value")+8,(rows.length)-2);
        } else {
            rows1 = rows.substring(rows.indexOf("value")+8,rows.indexOf("memName")-2); 
        }
        
        //rows1 = rows1.replace(']','');
        multirowcheck =rows1.indexOf("},{");
        console.log('multirowcheck '+multirowcheck);
        console.log(rows);
        console.log(rows1);
        
        if(multirowcheck !== -1){
            cmp.set("v.showMemDetailsModalSecnd1", true);
            cmp.set('v.showMemDetailsModalSecnd',false);
        }else{
            console.log('rows---'+rows1);
            if (checkMemName == 0) {
                var selectedRow = JSON.parse('['+rows1+']');
            } else {
                var selectedRow = JSON.parse('['+rows1);
            }
            var selMap = cmp.get("v.selectedRow");
            var rowSelAction = selectedRow;
            var selectedRowArray = [];
            selectedRowArray.push({'sobjectType':'AccountContactRelation',
                                   'ContactId':rowSelAction[0].ContactId,
                                   'AccountId':rowSelAction[0].AccountId,
                                   'Relationship__c' :rowSelAction[0].Relationship__c,
                                   'Id':rowSelAction[0].Id,
                                   'Contact':rowSelAction[0].Contact
                                  });
            selMap[rowSelAction[0].serviceMember] = selectedRowArray[0];
            cmp.set("v.selectedRow",selMap);
            console.log('viewIndividualpopupa---94--'+viewIndividualpopupc);
            if(memberdeta.length -1 > viewIndividualpopupc){
                viewIndividualpopupc = viewIndividualpopupc + 1;
                cmp.set('v.viewIndividualpopupc',viewIndividualpopupc);
                cmp.set('v.viewIndividualpopupd',viewIndividualpopupc);
                cmp.set("v.showMemDetailsModalSecnd1", false);
                cmp.set('v.showMemDetailsModalSecnd',true);
            }else{
                cmp.set('v.showMemDetailsModal',false);
                cmp.set('v.showMemDetailsModal1',false);
                cmp.set('v.showMemDetailsModalSecnd',false);
                cmp.set('v.showMemDetailsModalSecnd1',false);
                $A.enqueueAction(cmp.get('c.saveDetails'));
            }
            
        }
        
        
        
        
    },
    secondmultipopup:function (cmp, event,helper) {
        var memberdeta =cmp.get('v.memberDetails.newMemberMatch');
        var viewIndividualpopupc = cmp.get('v.viewIndividualpopupc');
        
        if(memberdeta.length -1 > viewIndividualpopupc){
            viewIndividualpopupc = viewIndividualpopupc + 1;
            cmp.set('v.viewIndividualpopupc',viewIndividualpopupc);
            cmp.set('v.viewIndividualpopupd',viewIndividualpopupc);
            cmp.set('v.showMemDetailsModalSecnd',true);
            cmp.set('v.showMemDetailsModalSecnd1',false);
            cmp.set("v.saveDisableScndPopUp",true);
        }else{
            cmp.set('v.showMemDetailsModalSecnd',false);
            cmp.set('v.showMemDetailsModalSecnd1',false);
            $A.enqueueAction(cmp.get('c.saveDetails'));
        }
    },
    secondpopno:function (cmp, event,helper) {
        
        var memberdeta =cmp.get('v.memberDetails.newMemberMatch');
        var viewIndividualpopupc = cmp.get('v.viewIndividualpopupc');
        
        if(memberdeta.length -1 > viewIndividualpopupc){
            var adduser =cmp.get('v.addnewUser');
            var selMap = cmp.get("v.selectedRow");
            var rowSelAction = adduser[viewIndividualpopupc];
            var selectedRowArray = [];
            selectedRowArray.push({'sobjectType':'AccountContactRelation'});
            selMap[rowSelAction.serviceMember] = selectedRowArray[0];
            cmp.set("v.selectfedRow",selMap);
            viewIndividualpopupc = viewIndividualpopupc + 1;
            cmp.set('v.viewIndividualpopupc',viewIndividualpopupc);
            cmp.set('v.viewIndividualpopupd',viewIndividualpopupc);
        }else{
            var adduser =cmp.get('v.addnewUser');
            var selMap = cmp.get("v.selectedRow");
            var rowSelAction = adduser[viewIndividualpopupc];
            var selectedRowArray = [];
            selectedRowArray.push({'sobjectType':'AccountContactRelation'});
            selMap[rowSelAction.serviceMember] = selectedRowArray[0];
            cmp.set("v.selectedRow",selMap);
            cmp.set('v.showMemDetailsModal',false);
            cmp.set('v.showMemDetailsModal1',false);
            cmp.set('v.showMemDetailsModalSecnd',false);
            cmp.set('v.showMemDetailsModalSecnd1',false);
            $A.enqueueAction(cmp.get('c.saveDetails'));
        }
        
    },
    // US2021959 :Code Added By Chandan-start
    setShowSpinner:function (cmp, event,helper) {
        console.log('Insidee');
        var sniNotElligible= event.getParam("sniNotElligible"); //US2216710 :Code Added By Chandan
        console.log('---sniNotElligible',sniNotElligible);
        cmp.set("v.showSpinner", false);
        console.log( cmp.get("v.showSpinner"));
        //US2216710 :Code Added By Chandan - Start
        if(sniNotElligible){
            //cmp.openModel(cmp, event,helper); 
            cmp.set("v.isModalOpen", true);
        } //US2216710 :Code Added By Chandan - End
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
        /*US2851554: SNI Core - Multiple Policies disable save until selection*/
        cmp.set("v.saveDisableFrstPopUp",true);
        cmp.set("v.saveDisableScndPopUp",true);
        var defaultMap = {};
        cmp.set("v.selectedRow",defaultMap);
        /*End of US2851554*/
        helper.getProviderDetails(cmp);
        //US1708392 - Malinda
        var memId =cmp.find('memberId').get('v.value'); 
        //alert(memID);
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
        var columnHeaders =[{label: 'Name', fieldName: 'Name', type: 'text'},{label: 'Date Of Birth', fieldName: 'DateOfBirth', type: 'text' },{label: 'Relationship', fieldName: 'Relationship__c', type: 'text'}] ;
        component.set('v.columnsFirstPopUp',columnHeaders);
        component.set("v.frstPopHeaderTextTitle",'a member listed below, but some information about them');
        component.set("v.frstPopHeaderTextSubtitle",'(such as their name, DOB, or relationship) has changed?');
        
        var columnHeadersB =[{label: 'Name', fieldName: 'Name', type: 'text'},{label: 'Date Of Birth', fieldName: 'DateOfBirth', type: 'text' },{label: 'Relationship', fieldName: 'Relationship__c', type: 'text'}] ;
        component.set('v.columnsFirstPopUpB',columnHeadersB);
        component.set("v.frstPopHeaderTextTitleB",'Select the row from the list below to update with the changed information:');
        component.set("v.frstPopHeaderTextSubtitleB",'');
        
        var columnHeader =[{label: 'Name', fieldName: 'Name', type: 'text'},{label: 'Member ID', fieldName: 'Member_ID__c', type: 'text' },{label: 'Policy Number', fieldName: 'Policy_ID__c', type: 'text' },{label: 'Relationship', fieldName: 'Relationship__c', type: 'text'},{label: 'Assigned Advisor', fieldName: 'Assigned_Advisor__c', type: 'text'}] ;
        component.set('v.columnsSecondPopUp',columnHeader);
        component.set("v.scndPopHeaderTextTitle",'We’ve identified another SENS Person Account with the same Name and DOB. Is this member ');
        component.set("v.scndPopHeaderTextSubtitle",' also associated with the existing policy below?');
        component.set("v.scndPopHeaderTextTitleB",'Select the row from the list that ');
        component.set("v.scndPopHeaderTextSubtitleB",'is associated with:');
        var memId = localStorage.getItem('memId');
        var memDOB = localStorage.getItem(memId+'_memDOB');
        var WorkOrderId = localStorage.getItem('workOrderId');
        
        component.set('v.workorderids',WorkOrderId);
        
        var isACETNavigation = localStorage.getItem('isACETNavigation');
        if(memId && memDOB && isACETNavigation){
            if(memId.toString()!='null' && memDOB.toString()!='null'){
                if(WorkOrderId){
                    var subscriberId = memId.substring(0,9);
                }else{
                    var subscriberId = memId.substring(0,9)+'00';
                }
                component.set('v.memId',subscriberId);
                component.set('v.memDOB',memDOB);
                component.set('v.Oxford_isOxford',localStorage.getItem(memId+'_isOxford'));
                component.set('v.Oxford_surrogateKey',localStorage.getItem(memId+'_surrogateKey'));  
                component.set('v.Oxford_groupNumber',localStorage.getItem(memId+'_groupNumber'));
                component.set('v.Oxford_effectiveDate',localStorage.getItem(memId+'_effectiveDate'));
                component.set('v.Oxford_benefitBundleOptionId',localStorage.getItem(memId+'_benefitBundleOptionId'));
                component.set('v.Oxford_benefitPlanId',localStorage.getItem(memId+'_benefitPlanId'));
                component.find('memberId').set('v.value',subscriberId);
                component.find('inputDOB').set('v.value',memDOB);
                var action = component.get('c.checkValidation');
                $A.enqueueAction(action);
                localStorage.removeItem('memId');
                localStorage.removeItem('isACETNavigation');// = null;
                localStorage.removeItem(memId+'_isOxford');// = null;
                //localStorage.removeItem(memId+'_surrogateKey'); 
                localStorage.removeItem(memId+'_groupNumber');// = null;
                //localStorage.removeItem(memId+'_effectiveDate');
                localStorage.removeItem(memId+'_benefitBundleOptionId');// = null;
                
            }
        }
        localStorage.removeItem('workOrderId');
        console.log('localStorage.clear();',localStorage.getItem('workOrderId'));
        //component.set('v.memberDetailsInstances',memberDetailsInstances[0]);
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
    // US2216710 :Code Added By Chandan-start
    openModel: function(component, event, helper) {
        component.set("v.isModalOpen", true);
    },
    
    closeModel: function(component, event, helper) {
        component.set("v.retryModal", false);                
        component.set("v.isModalOpen", false);
        component.set("v.showMemDetailsModal",false);
        component.set("v.showMemDetailsModal1",false);
        component.set("v.showMemDetailsModalSecnd",false);
        component.set("v.showMemDetailsModalSecnd1",false);
        component.set("v.viewIndividualpopupa",0);
        component.set("v.viewIndividualpopupb",0);
        component.set("v.viewIndividualpopupc",0);
        component.set("v.viewIndividualpopupd",0);
        helper.hideGlobalSpinner(component); // added by Cherry to hide spinner
    },
    
    submitDetails: function(component, event, helper) {
        try{
            helper.showGlobalSpinner(component); 
            var houseDetail = component.find('house');
            var memberDOBVal;
            var memberIdVal;
            var plcId;
            console.log("v.houseHoldData:"+component.get("v.houseHoldData"));
            var houseHoldList =component.get("v.houseHoldData");
            var sniEligible=false;
            console.log('householdlist= in submit method');
            console.log(houseHoldList);
            for(var i=0; i< houseHoldList.length;i++){
                
                if(houseHoldList[i].isMainMember == true) {
                    plcId = houseHoldList[i].policyId;
                    memberDOBVal = houseHoldList[i].dob;
                    memberIdVal = houseHoldList[i].memberId;
                }
            }
            var policyIdVar;
            plcId = plcId.toString();
            if (plcId.length < 9) {
                policyIdVar = ('0000000000' + plcId).slice(-9);
            }
            else{
                policyIdVar = plcId;
            }
            var advFullName ;
            var assignedToVal ; //=component.get("v.assignedToVal")
            var lob =component.get("v.lob");
            //geting work order id 
            var workOrd =component.get("v.workorderids");
            var productTypes =component.get("v.productTypes");
            var serviceGroup =component.get("v.serviceGroup");
            console.log('lob for not elligible----------'+lob);
            console.log('productTypes for not elligible----------'+productTypes);
            console.log('serviceGroup for not elligible----------'+serviceGroup);
            
            var action = component.get("c.fetchLoginUser");
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state == "SUCCESS") {
                    var storeResponse = response.getReturnValue();
                    // set current user information on userInfo attribute
                    console.log('storeResponse');
                    console.log(storeResponse);
                    console.log('storeResponse.Name')
                    console.log(storeResponse.Name)
                    assignedToVal=storeResponse.FederationIdentifier;
                    console.log('assignedToVal@@@@@='+assignedToVal);
                    houseDetail.createAccount(houseHoldList,memberDOBVal,workOrd,memberIdVal,advFullName,sniEligible,policyIdVar,plcId,assignedToVal,lob,productTypes,serviceGroup);
                    
                    
                }
            });
            $A.enqueueAction(action);
            //console.log('assignedToVal!!!!!!!!='+assignedToVal);
            component.set("v.isModalOpen", false);
        }
        catch(e) {
            component.set("v.isModalOpen", false);
            console.log("Error happened:"+e.message);
            var errMsg = 'Unexpected error occurred. Please try again.';
            component.set('v.showServiceErrors', true);
            if (component.get("v.showHideMemAdvSearch") == true && component.get("v.displayMNFFlag") == true) {
                component.set("v.mnf", 'mnf');
                component.set("v.checkFlagmeberCard",false);
            }
            component.set('v.serviceMessage', errMsg);
            helper.fireToast(errMsg);
            helper.hideGlobalSpinner(component); // US2021959 :Code Added By Chandan
            
        }
    },// US2216710 :Code Added By Chandan-End
    
    saveDetails: function(component, event, helper) {
        //debugger;
        console.log('inside saveDetails');
        helper.showGlobalSpinner(component); 
        var houseDetail = component.find('house');
        //work order added: Code added by Ankit
        var workOrd =component.get("v.workorderids");
        ////end
        var memDetailwrapper = component.get("v.memberDetails");
        console.log('memDetailwrapper---'+JSON.stringify(memDetailwrapper));
        if( memDetailwrapper.isAcetSearch != 'SearchACET')
            memDetailwrapper.isAcetSearch = 'SearchFamily' ; 
        var serviceMemDetails = memDetailwrapper.newMemberMatch;
        console.log('serviceMemDetails---818--'+JSON.stringify(serviceMemDetails));
        var selectedOption = component.get("v.selectedRow");
        console.log('selectedOption---'+JSON.stringify(selectedOption));
        //alert('rowSelAction'+JSON.stringify(selectedOption));
        memDetailwrapper.selectedMemberDetails =selectedOption;
        
        houseDetail.createAccount(memDetailwrapper,null,workOrd,component.get("v.memId"),null,null,component.get("v.polId"),null,null);
        var setMap ={};
        component.set("v.selectedRow", setMap);
        component.set("v.showMemDetailsModal", false);
        component.set("v.showMemDetailsModalSecnd", false);
        // helper.hideGlobalSpinner(component);
        
    },
    rowselect : function(component, event, helper){
        var memberLis =component.get("v.memberDetails.newMemberMatch");
        console.log(memberLis.length);
        var popId =event.getSource().getLocalId();
        var selMap = component.get("v.selectedRow");
        var rowSelAction = event.getParam("selectedRows");
        //alert('rowselect-->'+JSON.stringify(rowSelAction));
        var selectedRowArray = [];
        selectedRowArray.push({'sobjectType':'AccountContactRelation',
                               'ContactId':rowSelAction[0].ContactId,
                               'AccountId':rowSelAction[0].AccountId,
                               'Relationship__c' :rowSelAction[0].Relationship__c,
                               'Id':rowSelAction[0].Id,
                               'Contact':rowSelAction[0].Contact
                              });
        selMap[rowSelAction[0].serviceMember] = selectedRowArray[0];
        component.set("v.selectedRow",selMap);
        /*US2851554: SNI Core - Multiple Policies disable save until selection*/
        if(popId == 'frstPopUp'){
            component.set("v.saveDisableFrstPopUp",false);
        }
        if(popId == 'secondPopUp'){
            component.set("v.saveDisableScndPopUp",false);
        }
        console.log('recordselcted'+Reflect.ownKeys(selMap).length);
        /*US2851554: SNI Core - Multiple Policies disable save until selection*/
    },
    //Cherry- added to handle Wizard popup
    openRefferal: function(component, event, helper){
        component.set("v.showRefferal", true);
        
    },
    closeRefferal: function(component, event, helper){
        component.set("v.showRefferal", false);
    },
    closeshowDataTableForMultipleEntriesPopUp: function(component, event, helper){
        component.set("v.showDataTableForMultipleEntries", false);
    },
    openWizard : function(component, event, helper){
        component.set("v.showWizard", true);
        component.set("v.showRefferal", false);
    },
    
    closeWizard : function(component, event, helper){
        component.set("v.showWizard", false);
        $A.get('e.force:refreshview').fire();
    },
    updateSelectedText: function (component, event, helper) {
        var selectedRows = event.getParam('selectedRows');
        component.set("v.dataSelected",selectedRows[0]);
        console.log('selected one. ' + selectedRows[0]);
    },
    openSelectedEntry: function (component, event, helper) {
        var selectedRows = component.get("v.dataSelected");	
        console.log('selected one. ' + JSON.stringify(selectedRows));	
        console.log('member id is** : ' + component.find("memberId").get("v.value")); 	
        console.log('IsSandbox : ' + selectedRows.IsSandbox);   	
        console.log('mapNameToWebservice : ' + selectedRows.mapNameToWebservice);   	
        console.log('token : ' + selectedRows.token);   	
        console.log('referralIdentifier : ' + selectedRows.referralIdentifier);   	
        console.log('CHNEligible : ' + selectedRows.CHNEligible + selectedRows.referralIdentifier);   
        console.log('API Identifier'+selectedRows.apiIdentifier);
        var workOrderId = '';	
        if(!selectedRows.hasOwnProperty('woId')) {	
            workOrderId = '';	
        }else{	
            if(selectedRows.woId == undefined || selectedRows.woId == '' || selectedRows.woId == null){	
                workOrderId = '';	
            }	
            else{	
                workOrderId = selectedRows.woId;	
            }	
        } 	
        component.set("v.showDataTableForMultipleEntries", false);	
        var action = component.get('c.setWrapperData');	
        action.setParams({	
            "apiIdentifier": selectedRows.apiIdentifier,	
            "memberId": component.find("memberId").get("v.value"),	
            "IsSandbox":  selectedRows.IsSandbox,	
            "mapNameToWebservice" : selectedRows.mapNameToWebservice,	
            "token" : selectedRows.token,	
            "woId" : workOrderId,	
            "memberDOB": component.find("inputDOB").get("v.value"),	
            "firstName": component.find("memFirstNameId").get("v.value"),	
            "lastName": component.find("memLastNameId").get("v.value"),	
            "groupNumber": component.find("memGroupNumberId").get("v.value"),	
            "searchOption": component.get("v.searchOptionVal")	
        });	
        action.setCallback(this, function (response) {	
            var state = response.getState(); 	
            var result = response.getReturnValue();	
            if (state == 'SUCCESS') {	
                console.log('check sttus:::' + result.statusCode);	
                if(result.statusCode == 200){ 	
                    component.set("v.houseHoldData",result.houseHoldResultWrapper.houseHoldList);	
                    component.set("v.memberDetails", result.houseHoldResultWrapper.memberDetails);	
                    console.log('memberDetails'+ JSON.stringify(component.get("v.memberDetails")));	
                    console.log('showMemDetailsModal'+ component.get("v.showMemDetailsModal"));	
                    if (result.CHNEligible == false && result.CHNQualified == false && (result.houseHoldResultWrapper.memberDetails.accountId == null || result.houseHoldResultWrapper.memberDetails.accountId == '')) {	
                        component.set("v.showRefferal", true);	
                        helper.hideGlobalSpinner(component);	
                    }	
                    else{	
                        var accountId = result.houseHoldResultWrapper.memberDetails.accountId;	
                        console.log('accountId-'+accountId);	
                        if(accountId  != null || accountId != undefined){	
                            var IdsPersonFamilyAccount = accountId.split('@');	
                            if(document.location.pathname.indexOf("/lightning/") != 0){	
                                var navEvt = $A.get("e.force:navigateToSObject");	
                                navEvt.setParams({	
                                    "recordId": IdsPersonFamilyAccount[2],	
                                });	
                                navEvt.fire();	
                            }else{	
                                var workspaceAPI = component.find("workspace");	
                                console.log('workspaceAPI'+workspaceAPI);	
                                workspaceAPI.openTab({	
                                    url: '/lightning/r/Account/'+IdsPersonFamilyAccount[1]+'/view',	
                                    focus: true	
                                    
                                }).then(function(response) {	
                                    var setEvent = component.getEvent("setShowSpinner");	
                                    setEvent.fire();	
                                    if(IdsPersonFamilyAccount[0]=='ITE'){	
                                        console.log('IdsPersonFamilyAccount[0]='+IdsPersonFamilyAccount[0]);	
                                        workspaceAPI.openSubtab({	
                                            parentTabId: response,	
                                            url: '/lightning/r/Account/'+IdsPersonFamilyAccount[2]+'/view',	
                                            focus: true	
                                        });	
                                    }	
                                    var focusedTabId = response;	
                                    workspaceAPI.refreshTab({	
                                        tabId: focusedTabId,	
                                        includeAllSubtabs: true	
                                    });	
                                }).catch(function(error) {	
                                    
                                });	
                            }	
                        }	
                        helper.hideGlobalSpinner(component);                     	
                    }	
                }else if (result.statusCode == 400 && (component.get("v.searchOptionVal") == "NameDateOfBirth" || component.get("v.searchOptionVal") == "MemberIDDateOfBirth")) {	
                    helper.fireToastMessage("Error!", result.message.replace(". ", ". \n"), "error", "dismissible", "10000");	
                    helper.hideGlobalSpinner(component); 	
                }else if (result.statusCode == 404 && result.CHNEligible == false && result.CHNQualified == false && result.message!=null && result.message == "Eligibilities Not Found.") {	
                    component.set("v.showRefferal", true);	
                    helper.hideGlobalSpinner(component);	
                }else {	
                    component.set('v.showServiceErrors', true);	
                    if (component.get("v.showHideMemAdvSearch") == true && component.get("v.displayMNFFlag") == true) {	
                        component.set("v.mnf", 'mnf');	
                        component.set("v.checkFlagmeberCard",false); //Added By Avish on 07/25/2019	
                    }	
                    component.set('v.serviceMessage', result.message);	
                    helper.fireToast(result.message);	
                    helper.hideGlobalSpinner(component); 	
                }	
            }else{	
                helper.hideGlobalSpinner(component); 	
            }	
        });	
        $A.enqueueAction(action);                      
    }
})