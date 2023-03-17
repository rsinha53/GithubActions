({
    showMisdirectSpinner: function (cmp) {
        var spinner = cmp.find("misdirect-spinner");
        $A.util.removeClass(spinner, "slds-hide");
        $A.util.addClass(spinner, "slds-show");
    },
    
    hideMisdirectSpinner: function (cmp) {
        var spinner = cmp.find("misdirect-spinner");
        $A.util.removeClass(spinner, "slds-show");
        $A.util.addClass(spinner, "slds-hide");
    },
    
    keepOnlyDigits: function (cmp, event) {
        var regEx = /[^0-9 ]/g;
        var fieldValue = event.getSource().get("v.value");
        if (fieldValue.match(regEx)) {
            event.getSource().set("v.value", fieldValue.replace(regEx, ''));
        }
    },
    
    keepOnlyText: function(cmp,event){
        var regEx = /[^a-zA-Z ]/g;
        var fieldValue = event.getSource().get("v.value");
        if (fieldValue.match(regEx)) {            
            event.getSource().set("v.value", fieldValue.replace(regEx, ''));
        }
    },
    
    misDirectReasonsHelper: function (component, event, helper) {
        
        var action = component.get('c.getMisdirectReasonValues');
        var reasonVals = component.find("misReasonsId");
        var opts = [];
        action.setCallback(this, function (a) {
            opts.push({
                class: "optionClass",
                label: "None",
                value: ""
            });
            for (var i = 0; i < a.getReturnValue().length; i++) {
                opts.push({
                    "class": "optionClass",
                    label: a.getReturnValue()[i],
                    value: a.getReturnValue()[i]
                });
            }
            reasonVals.set("v.options", opts);
            
        });
        $A.enqueueAction(action);
    },
    // Case creation method with case wrapper : Sarma : US US1889740
    createMisdirectCase:function (component, event, helper) {
        var misdirectReason = component.find('misReasonsId').get('v.value');
        //US2598275: Updates to Contact Name Entry Field
        //var contactName = component.find('contactID').get('v.value');
        var contactName = component.get('v.contactName');
        var contactNumber = component.find('contactNumberID').get('v.value'); 
        var caseCommenttxt = component.find('commentsId').get('v.value'); 
        var contactDetails = _setandgetvalues.getContactValue(component.get("v.contactUniqueId"));
        var action = component.get('c.createCase');
        var mnf = component.get('v.mnf');
        var isMms = component.get('v.isMms');
        var workspaceAPI = component.find("workspace");
        var caseWrapper = {}; // cmp.get('v.SAETTSCaseWrapper');
        
        caseWrapper.Status = 'canceled';
        caseWrapper.Interaction = component.get('v.interactionID');
        // Originator
        caseWrapper.OriginatorName = component.get('v.originatorName');
        //US3612768 - Sravan - Start
        if(!$A.util.isUndefinedOrNull(component.get("v.selectedProviderName")) && !$A.util.isEmpty(component.get("v.selectedProviderName"))){
         	caseWrapper.OriginatorName = component.get("v.selectedProviderName");

        }
        if(!$A.util.isUndefinedOrNull(component.get("v.selectedProviderPhone")) && !$A.util.isEmpty(component.get("v.selectedProviderPhone"))){
            caseWrapper.OriginatorPhone = component.get("v.selectedProviderPhone");
        }
        var providerDetails = component.get("v.providerDetails");
        console.log('Provider Details'+ JSON.stringify(providerDetails));
        var isOther = component.get("v.isOther");;
        caseWrapper.isOtherSearch = !isOther;
        var isNoProviderToSearch = component.get("v.isNoProviderToSearch");;
        caseWrapper.noProviderToSearch = isNoProviderToSearch;
        var isProviderNotFound = component.get("v.isProviderNotFound");;
        caseWrapper.providerNotFound = isProviderNotFound;
        var providerId  = component.get("v.providerId");
        var isNoMemberToSearch = component.get("v.isNoMemberToSearch");
        caseWrapper.noMemberToSearch = isNoMemberToSearch;
        var isMemberNotFound = component.get("v.isMemberNotFound");
        if(isMemberNotFound){
           caseWrapper.mnf = 'mnf';
        }
        else{
           caseWrapper.mnf = ' ';
        }
        if(!$A.util.isUndefinedOrNull(providerId) && !$A.util.isEmpty(providerId)){
        	caseWrapper.providerId = providerId;
        }
        //US3612768 - Sravan - End
        if(!$A.util.isEmpty(contactDetails)) {
            caseWrapper.contactNumber = contactDetails.contactNumber;
            caseWrapper.contactExt = contactDetails.contactExt;
            //US3612768 - Sravan - Start
            if(!$A.util.isUndefinedOrNull(isOther) && !$A.util.isEmpty(isOther)){
            if(!isOther){
                     var contactNumber = '';
                     var ext = '';
                     if(!$A.util.isUndefinedOrNull(caseWrapper.contactNumber) && !$A.util.isEmpty(caseWrapper.contactNumber)){
                        contactNumber =  caseWrapper.contactNumber.trim();
                     }
                if(!$A.util.isUndefinedOrNull(caseWrapper.contactExt) && !$A.util.isEmpty(caseWrapper.contactExt)){
                        ext =  caseWrapper.contactExt.trim();
                     }
                     if(!$A.util.isUndefinedOrNull(ext) && !$A.util.isEmpty(ext)){
                		caseWrapper.OriginatorPhone = contactNumber + '	Ext ' +ext;
                }
                else{
                		caseWrapper.OriginatorPhone = contactNumber;
                }
               caseWrapper.OriginatorName = component.get("v.contactFirstName")+' '+component.get("v.contactLastName");
            }
            }
          	//US3612768 - Sravan - ENd
        }
        caseWrapper.OriginatorType = component.get("v.exploreOriginator");
        caseWrapper.OriginatorContactName = contactName;
        //US2740876 - Sravan - Start
        caseWrapper.OriginatorFirstName = component.get("v.contactFirstName");
        caseWrapper.OriginatorLastName =  component.get("v.contactLastName");
        //US2740876 - Sravan - End
        // Subject : Empty if member not found or multiple member search
        if(isMms){
            caseWrapper.SubjectName = 'Multiple Member Search'; //US1974270 - Sarma
            caseWrapper.SubjectType = 'Member'; //US1974270 - Sarma
            caseWrapper.SubjectDOB = '';
            caseWrapper.SubjectId = '';
            caseWrapper.SubjectGroupId = '';
        } else{
            if(mnf=='mnf'){
                caseWrapper.SubjectName = component.get('v.subjectName');
                caseWrapper.SubjectType = 'Member';
                caseWrapper.SubjectDOB = component.get('v.subjectDOB');
                //US3172545 - No Provider to Search to MNF - Sravan - Start
                caseWrapper.SubjectId = component.get('v.subjectID');
                //US3172545 - No Provider to Search to MNF - Sravan - End
                caseWrapper.SubjectGroupId = '';
            } else{
                caseWrapper.SubjectName = component.get('v.subjectName');
                caseWrapper.SubjectType = 'Member';
                caseWrapper.SubjectDOB = component.get('v.subjectDOB');
                caseWrapper.SubjectId = component.get('v.subjectID');
                caseWrapper.SubjectGroupId = component.get('v.subjectGrpID');
                if(!$A.util.isUndefinedOrNull(component.get("v.highlightedPolicyNumber")) && !$A.util.isEmpty(component.get("v.highlightedPolicyNumber"))){
                     caseWrapper.SubjectGroupId = component.get('v.highlightedPolicyNumber');//US3816776 - Sravan
                }
                //DE441126 - start
                caseWrapper.uhgRestriction = component.get('v.uhgRestriction');
                caseWrapper.onShoreRestriction = component.get('v.onShoreRestriction');
                //DE441126 - ends
                //US2740876 - Sravan - Start
                caseWrapper.strSourceCode = component.get('v.subjectSourceCode');
                 if(!$A.util.isUndefinedOrNull(component.get("v.highlightedPolicySourceCode")) && !$A.util.isEmpty(component.get("v.highlightedPolicySourceCode"))){
            		caseWrapper.strSourceCode = component.get("v.highlightedPolicySourceCode");//US3816776 - Sravan
        		}
                //US2740876 - Sravan - End

            }
        }
        //Durga
        var isVCCD = component.get('v.isVCCD');
        console.log('== isVCCD is '+isVCCD);
        var VCCDRecordId = component.get('v.VCCDObjRecordId');
        console.log('==VCCD Record id is'+component.get('v.VCCDObjRecordId'));

        // Additional Info
        caseWrapper.MisdirectReason = misdirectReason;
        caseWrapper.misdirectComments = caseCommenttxt;
        caseWrapper.createORSCase = true;
        component.set('v.caseWrapper', caseWrapper);
        console.log('isNoProviderToSearch'+ caseWrapper.isNoProviderToSearch);
        console.log('isProviderNotFound'+ caseWrapper.isProviderNotFound);
        var strWrapper = JSON.stringify(caseWrapper);
        console.log('The case wrapper in misdirect'+strWrapper);

        action.setParams({
            'strWrapper': strWrapper,
            'commentString': caseCommenttxt,
            'isVCCD':isVCCD,
            'VCCDRecordId': VCCDRecordId,
            "flowDetails":component.get("v.flowDetails") //US2903847
        });
        
        action.setCallback(this, function (response) {
            var state = response.getState(); // get the response state
            if (state === "SUCCESS") {
                var response = response.getReturnValue();
                var actionORS = component.get("c.CreateORSRecord");
                actionORS.setParams({
                    'strRecord': strWrapper,
                    'caseId': response
                });
                actionORS.setCallback(this, function(responseORS) {
                    var state = responseORS.getState();
                    var orsId = responseORS.getReturnValue();
                    // Navigate to case regardless of ORS creation state
                    if (state === "SUCCESS") {
                        console.log("Created : " + orsId);
                    } else if (state === "INCOMPLETE") {
                        
                    } else if (state === "ERROR") {
                        var errors = responseORS.getError();
                        if (errors) {
                            if (errors[0] && errors[0].message) {
                                console.log("Error message: " +
                                            errors[0].message);
                            }
                        } else {
                            console.log("Unknown error");
                        }
                    }
                    helper.hideMisdirectSpinner(component);
                    helper.closeFocusedTab(component, event, helper);
                });
                $A.enqueueAction(actionORS);
                // End
            }
        });
        $A.enqueueAction(action);
    },
    
    closeFocusedTab: function (component, event, helper) {
        var workspaceAPI = component.find("workspace");
        var matchingTabs = [];
        //Checking for Opened Tabs
        if(component.get("v.focusedTabId") == 'exploretab') {
            var navigationItemAPI = component.find("navigationItemAPI");
            workspaceAPI.getFocusedTabInfo().then(function(response) {
                var focusedTabId = response.tabId;
                workspaceAPI.closeTab({
                    tabId: focusedTabId
                });
            })
            .then(function(tabInfo) {
                navigationItemAPI.focusNavigationItem().then(function(response) {
                    console.log('response::'+JSON.stringify(response));
                })
            })
            .catch(function(error) {
                console.log(error);
            });
            return;
        }
        workspaceAPI.getAllTabInfo().then(function (response) {
            if (!$A.util.isEmpty(response)) {
                for (var i = 0; i < response.length; i++) {
                    for (var j = 0; j < response[i].subtabs.length; j++) {
                        if (response[i].subtabs.length > 0) {
                            var tabUniqueId = component.get("v.focusedTabId");
                            if (response[i].subtabs[j].tabId === tabUniqueId) {
                                matchingTabs.push(response[i].subtabs[j]);
                                break;
                            }
                        }
                    }
                }
                if($A.util.isEmpty(matchingTabs)) {
                    for (var i = 0; i < response.length; i++) {
                        if(response[i].tabId === component.get("v.focusedTabId")) {
                            matchingTabs.push(response[i]);
                            break;
                        } 
                    }
                }
            }
            
            var focusTabId = matchingTabs[0].tabId;
            var tabURL = matchingTabs[0].url;
            
            workspaceAPI.openTab({
                url: tabURL
            }).then(function (response) {
                workspaceAPI.focusTab({
                    tabId: response
                });
            }).catch(function (error) {
                console.log(error);
            });
        })
        workspaceAPI.getFocusedTabInfo().then(function (response) {
            var focusedTabId = response.tabId;
            workspaceAPI.closeTab({
                tabId: focusedTabId
            });
        })
        .catch(function (error) {
            console.log(error);
        });
    },

    getCallHandlingOneSourceURL: function(cmp, event, helper){
        var action = cmp.get("c.getCallHandlingOneSourceURL");
        action.setCallback(this,function(response){
            var state = response.getState();
            if(state == 'SUCCESS'){
                var responseUrl = response.getReturnValue();
                cmp.set("v.callHandlingOneSourceURL",responseUrl);
            }
        })
        $A.enqueueAction(action);
    }
    
})