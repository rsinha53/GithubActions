({
    init : function(cmp, event, helper) {
        var sendToListInputs = {
            "advocateRole": "Select",
            "teamQuickList": "",
            "office": "Select",
            "department": "Select",
            "team": "Select",
            "individual": "",
            "state": "Select",
            'issue': "Select",
            "city": "",
            "phoneNumber": "",
            "comments": "",
            "officeAPI": "",
            "departmentAPI": "",
            "teamAPI": "",
            "memberName": "",
            "memberId": "",
            "memberDOB": "",
            "providerName": "",
            "NPI": "",
            "MPIN": "",
            "TIN": "",
            "escalationReason": "Select"

        };
        cmp.set("v.sendToListInputs", sendToListInputs);
        
        cmp.set('v.typeOptions',  '--None--');
        cmp.set('v.topicOptions',  '--None--');
        cmp.set('v.subtypeOptions', '--None--');
        helper.getData(cmp);
        helper.getTopics(cmp);
        helper.getORSMetaDataRecords(cmp);
        let objSendToHeader = {};
        objSendToHeader = {
            'strReferringToHeader': 'Send To',
            'showRefferingToName': true
        };
        cmp.set("v.objSendToHeader", objSendToHeader);
        
    },
    handleClick: function(cmp, event, helper) {
        //var exterId = event.getSource().getLocalId();
        cmp.set('v.selectedExtId',event.currentTarget.id);
        cmp.set('v.isShow',!cmp.get('v.isShow'));
        console.log('Clicked Resolve');
    },
    closePopup: function(cmp, event, helper) {
        cmp.set('v.isShow',!cmp.get('v.isShow'));
    },
    closeNOpenSend2: function(cmp, event, helper) {
        var whichOne = event. getSource(). getLocalId();
        if(whichOne=='routeId')
        {
            cmp.set('v.routeOrCloseCase','routeCase');
            if(cmp.get('v.wqSubtype')!='--None--')
            {
                cmp.set('v.wqSubtype','--None--');
            }
            if(cmp.get('v.wqType')!='--None--')
            {
                cmp.set('v.wqType','--None--');
            }
            if(cmp.get('v.wqTopic')!='--None--')
            {
                cmp.set('v.wqTopic','--None--');
            }
            
            cmp.set('v.typeOptions',  '--None--');
            cmp.set('v.subtypeOptions', '--None--');
            cmp.set('v.showPicklistPopup',true);
            // cmp.set('v.disabledRadio',false);
            //cmp.set('v.disableRoleField',false);
            //cmp.set('v.disableQuickListField',false);
            //cmp.set('v.disableOfficeField',false);
            //cmp.set('v.disableDepartmentField',false);
            //cmp.set('v.disableTeamField',false);
            //cmp.set('v.disableIndividualField',false);
            
        }
        else if(whichOne=='closeCase')
        {
            cmp.set('v.routeOrCloseCase','closeCase');
         	cmp.set('v.disabledRadio',true); 
            cmp.set('v.disableRoleField',true);
            cmp.set('v.disableQuickListField',true);
            cmp.set('v.disableOfficeField',true);
            cmp.set('v.disableDepartmentField',true);
            cmp.set('v.disableTeamField',true);
            cmp.set('v.disableIndividualField',true);
            cmp.set('v.officeFieldsRequiredSymbol',false);
            cmp.set('v.IsDelegatedSpeciality',true);
            cmp.set('v.isShowSend',!cmp.get('v.isShowSend'));
            
        }
        cmp.set('v.isShow',false);
    },
    switchToClose: function(cmp, event, helper) {
        cmp.set('v.isShow',false);
        cmp.set('v.isShowSend',!cmp.get('v.isShowSend'));
    },
    onTopicChange: function(cmp, event, helper) {
        var topicVal=cmp.get('v.wqTopic');
        if(($A.util.isEmpty(topicVal)) || (topicVal=='--None--'))
        {
            var data = ['--None--'];
            var subData = ['--None--'];
            cmp.set('v.typeOptions',data);
            cmp.set('v.subtypeOptions',subData)
            cmp.set('v.wqType','--None--');
            cmp.set('v.wqSubtype','--None--');            
        }else
        {
            var data = ['--None--','Issue Routed'];
            var subData = ['--None--'];
            cmp.set('v.typeOptions',data);
            cmp.set('v.subtypeOptions',subData)
            cmp.set('v.wqType','--None--');
            cmp.set('v.wqSubtype','--None--');
        }
        if(!($A.util.isEmpty(topicVal)) && (topicVal!='--None--'))
        {
            cmp.set('v.isShowTopicError', false);
            $A.util.removeClass(cmp.find('wqTopic'), 'slds-has-error');
        }
        cmp.set('v.isShowTypeError', false);
        $A.util.removeClass(cmp.find('wqtype'),'slds-has-error');
        cmp.set('v.isShowSubTypeError', false);
        $A.util.removeClass(cmp.find('wqSubtype'), 'slds-has-error');   
    },
    searchText: function(cmp, event, helper) {
        var data = cmp.get("v.fullData");
        let inputValue=event.getSource().get('v.value').toUpperCase();
        
        if(inputValue == ""){
            cmp.set("v.data", data);
            //var tableDetails = cmp.get("v.tableDetails");
            //cmp.set("v.currentStartNumber",tableDetails.startNumber);
            //cmp.set("v.currentEndNumber",tableDetails.endNumber);
        }else{
            var filteredData = filterValuePart(data, inputValue);

            function filterValuePart(arr, part) {
            return arr.filter(function(obj) {
            return Object.keys(obj)
                            .some(function(k) { 
                                    return obj[k].indexOf(part) !== -1; 
                                });
            });
            }
            var sortData=helper.sortAllData(cmp,'created','Accending',filteredData);
            cmp.set("v.data", sortData);
        }
        
    },
    onTypeChange: function(cmp, event, helper) {
        var data = [];
        data.push('--None--');
        var wqType=cmp.get('v.wqType');
        if(!($A.util.isEmpty(wqType)) && (wqType!='--None--'))
        {
            cmp.set('v.isShowTypeError', false);
            $A.util.removeClass(cmp.find('wqtype'),'slds-has-error');
            cmp.set('v.isShowSubTypeError', false);
        	$A.util.removeClass(cmp.find('wqSubtype'), 'slds-has-error');
            var spinner = cmp.find('subtypeSpinnerId');
            $A.util.removeClass(spinner, 'slds-hide');
            $A.util.addClass(spinner, 'slds-show');
            var action=cmp.get("c.getSubTypeValues");
            action.setParams({
                topic: cmp.get('v.wqTopic'), 
                type: cmp.get('v.wqType')
            });
            action.setCallback(this, function (response) {
                var state = response.getState();
                var result = response.getReturnValue();
                if (state == "SUCCESS") {
                    var reqValues=["Authorization Discrepancy","Benefit Discrepancies","Clerical Request","Dispute Allowed Amount",
                                   "Medical/Reimbursement Policy","Misquote of Information","Paid Correctly, Pre-Appeal Reconsideration",
                                   "Referral Discrepancy","Stop Pay and Reissue","Timely Filing Discrepancy"]
                    for(var i=0;i<result.length;i++)
                    {
                        if(cmp.get('v.wqTopic')=='View Claims')
                        {
                            if(reqValues.includes(result[i]))
                            {
                                 data.push(result[i]);
                            }
                        }
                        else
                        {
                            data.push(result[i]);
                            
                        }
                    }
                    cmp.set('v.wqSubtype','--None--');
                    cmp.set("v.subtypeOptions", data.sort());
                }
                $A.util.removeClass(spinner, 'slds-show');
                $A.util.addClass(spinner, 'slds-hide');
            });
            $A.enqueueAction(action);
        }else
        {
            cmp.set('v.wqSubtype','--None--');
            cmp.set("v.subtypeOptions", data);
            cmp.set('v.isShowSubTypeError', false);
        	$A.util.removeClass(cmp.find('wqSubtype'), 'slds-has-error');
        }
    },
    onsubtypeChange : function(cmp, event, helper) {
        var wqSubtype=cmp.get('v.wqSubtype');
        if(!($A.util.isEmpty(wqSubtype)) && (wqSubtype != '--None--'))
        {
            cmp.set('v.isShowSubTypeError', false);
            $A.util.removeClass(cmp.find('wqSubtype'), 'slds-has-error');            
        }
    },
    closeModal : function(cmp, event, helper) {
        cmp.set('v.showPicklistPopup',false);
        helper.resetData(cmp);
    },
    callSendTo : function(cmp, event, helper) {
        var topicVal=cmp.get('v.wqTopic');
        var wqType=cmp.get('v.wqType');
        var wqSubtype=cmp.get('v.wqSubtype');
        if(($A.util.isEmpty(topicVal)) || (topicVal=='--None--'))
        {
            $A.util.addClass(cmp.find('wqTopic'), 'slds-has-error');
            cmp.set('v.isShowTopicError', true);
        }else if(($A.util.isEmpty(wqType)) || (wqType=='--None--'))
        {
            $A.util.addClass(cmp.find('wqtype'), 'slds-has-error');
            cmp.set('v.isShowTypeError', true);
            
        }else if(($A.util.isEmpty(wqSubtype))|| (wqSubtype == '--None--'))
        {
            $A.util.addClass(cmp.find('wqSubtype'), 'slds-has-error');
            cmp.set('v.isShowSubTypeError', true);
            
        }else
        {
            var whereConditionForAdvocate='';
            var whereTTSTopic='';
            if(topicVal=='View Claims')
            {
                whereTTSTopic=whereConditionForAdvocate='Topic__c = '+ "'" +topicVal+"'"+' AND Type__c ='+ "'"+'Issue Routed'+"'"+' AND Subtype__c ='+"'"+wqSubtype+"'";
            }
            else
            {
                whereTTSTopic=whereConditionForAdvocate='Topic__c = '+ "'" +topicVal+"'"+' AND Type__c ='+ "'"+'Issue Routed'+"'"+' AND Subtype__c ='+"'"+wqSubtype+"'";
            }
            
            
            cmp.set("v.whereConditionForAdvocate",whereConditionForAdvocate);
            cmp.set("v.whereTTSTopic",whereTTSTopic);
            //component.set("v.whereTTSTopic", 'Topic__c =' + "'" + 'View Claims' + "'" + ' AND Type__c =' + "'" + 'Issue Routed' + "'" + ' AND Subtype__c =' + "'" + pageReference.state.c__ttsSubType + "'");
            //component.set("v.whereConditionForAdvocate", 'Topic__c =' + "'" + 'View Claims' + "'" + ' AND Type__c =' + "'" + 'Issue Routed' + "'");
            
            cmp.set('v.showPicklistPopup',false);
            cmp.set('v.disabledRadio',false);
            cmp.set('v.disableRoleField',false);
            cmp.set('v.disableQuickListField',true);
            cmp.set('v.disableOfficeField',true);
            cmp.set('v.disableDepartmentField',true);
            cmp.set('v.disableTeamField',true);
            cmp.set('v.disableIndividualField',true);
            cmp.set('v.isShow',false);
            cmp.set('v.isShowSend',!cmp.get('v.isShowSend'));
        }
    },

    closeSendTo : function(cmp, event, helper) {
        cmp.set('v.isShow',false);
        cmp.set('v.isShowSend',false);
        helper.resetData(cmp);
    }, 

    selectedSendValueChanged : function(cmp, event, helper) {
       let selectedSendValue = cmp.get('v.selectedSendValue');
       
       if(selectedSendValue == 'office'){
        let advocateRoleField = cmp.find('idSendToNonClaims').find('advocateRoleId').find('comboboxFieldAI');
        let teamQuickListField = cmp.find('idSendToNonClaims').find('teamQuickListId').find('comboboxFieldAI');
        advocateRoleField.setCustomValidity('');
        advocateRoleField.reportValidity();
        teamQuickListField.setCustomValidity('');
        teamQuickListField.reportValidity();

       } else if (selectedSendValue == 'teamList'){
        let officeField = cmp.find('idSendToNonClaims').find('officeId').find('comboboxFieldAI');
        let departmentField = cmp.find('idSendToNonClaims').find('departmentId').find('comboboxFieldAI');
        let teamField = cmp.find('idSendToNonClaims').find('teamId').find('comboboxFieldAI');

        officeField.setCustomValidity('');
        officeField.reportValidity();
        departmentField.setCustomValidity('');
        departmentField.reportValidity();
        teamField.setCustomValidity('');
        teamField.reportValidity();

       }
    },
 
    fireValidations : function(cmp, event, helper) {
        debugger;
        let allValid = true;
        let sendToListInputsValues=cmp.get('v.sendToListInputs');
        cmp.find('idSendToNonClaims').find("advocateRoleId").checkValidation();
        cmp.find('idSendToNonClaims').find("teamQuickListId").checkValidation();
        cmp.find('idSendToNonClaims').find("officeId").checkValidation();
        cmp.find('idSendToNonClaims').find("departmentId").checkValidation();
        cmp.find('idSendToNonClaims').find("teamId").checkValidation();

        let advocateRoleField = cmp.find('idSendToNonClaims').find('advocateRoleId').find('comboboxFieldAI');
        let teamQuickListField = cmp.find('idSendToNonClaims').find('teamQuickListId').find('comboboxFieldAI');
        let officeField = cmp.find('idSendToNonClaims').find('officeId').find('comboboxFieldAI');
        let departmentField = cmp.find('idSendToNonClaims').find('departmentId').find('comboboxFieldAI');
        let teamField = cmp.find('idSendToNonClaims').find('teamId').find('comboboxFieldAI');
        let commentField =  cmp.find('commentsId');

        if(cmp.get('v.routeOrCloseCase') == 'routeCase'){

            if(cmp.get('v.selectedSendValue') != 'office'){
                if(advocateRoleField.get('v.value') == 'Select'){
                    advocateRoleField.setCustomValidity('Complete this field.');
                    allValid = false;
                } else {
                    advocateRoleField.setCustomValidity('');
                }
                advocateRoleField.reportValidity();
    
                if(teamQuickListField.get('v.value') == 'Select'){
                    teamQuickListField.setCustomValidity('Complete this field.');
                    allValid = false;
                } else {
                    teamQuickListField.setCustomValidity('');
                }
                teamQuickListField.reportValidity();
            } else{
                advocateRoleField.setCustomValidity('');
                advocateRoleField.reportValidity();
                teamQuickListField.setCustomValidity('');
                teamQuickListField.reportValidity();
            }

            if(officeField.get('v.value') == 'Select'){
                officeField.setCustomValidity('Complete this field.');
                allValid = false;
            } else {
                officeField.setCustomValidity('');
            }
            officeField.reportValidity();

            if(departmentField.get('v.value') == 'Select'){
                departmentField.setCustomValidity('Complete this field.');
                allValid = false;
            } else {
                departmentField.setCustomValidity('');
            }
            departmentField.reportValidity();

            if(teamField.get('v.value') == 'Select'){
                teamField.setCustomValidity('Complete this field.');
                allValid = false;
            } else {
                teamField.setCustomValidity('');
            }
            teamField.reportValidity();
        }  

        let commentText = commentField.get('v.value');
        if(commentText.length == 0 || commentText.length > 2000){
            commentField.reportValidity();
            allValid = false;
        }

        if(allValid){ 
            helper.callUpdateORSService(cmp,commentText,helper);
        } 
    },
    openServiceRequestDetail: function (cmp, event, helper) {
        // US2041480 - Thanish 31st March 2020
        //let clickedLink = event.currentTarget;
        //$A.util.addClass(clickedLink, "disabledLink");
        
        var workspaceAPI = cmp.find("workspace");
        var extId = event.currentTarget.getAttribute("data-extId");
        console.log(extId);
        
        $A.util.addClass(event.currentTarget, "disableLink");
        workspaceAPI.openTab({
            pageReference: {
                "type": "standard__component",
                "attributes": {
                    "componentName": "c__ACET_ServiceRequestDetail"
                },
                "state": {
                    "c__caseId": extId,
                    "c__sfCaseId": '',
                    "c__parentUniqueId": cmp.get("v.cmpUniqueId"),
                    "c__idType": ''
                }
            },
            focus: true
        }).then(function(response) {
            
            workspaceAPI.getTabInfo({
                tabId: response
            }).then(function (tabInfo) {
                
                var focusedTabId = tabInfo.tabId;
                $A.util.addClass(event.currentTarget, focusedTabId);
                workspaceAPI.setTabLabel({
                    tabId: focusedTabId,
                    label: extId
                });
                workspaceAPI.setTabIcon({
                    tabId: focusedTabId,
                    icon: "action:record",
                    iconAlt: "Service Request Detail"
                });
            });
        }).catch(function(error) {
            console.log(error);
        });
        
    },

    handleSRITabClosed: function(cmp, event, helper) {
        if(event.getParam("parentUniqueId") == cmp.get("v.cmpUniqueId")) {
            let elementList = document.getElementsByClassName(event.getParam("closedTabId"));
            let elementList2 = document.getElementsByClassName("disableLink");
            if(elementList.length > 0) {
                $A.util.removeClass(elementList[0], "disableLink");
                $A.util.removeClass(elementList[0], event.getParam("closedTabId"));
            } else if(elementList2.length > 0){
                $A.util.removeClass(elementList2[0], "disableLink");
                $A.util.removeClass(elementList2[0], event.getParam("closedTabId"));
            }
        }
    }
})