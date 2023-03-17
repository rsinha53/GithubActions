({
    onLoad: function(component, event, helper) {
        try {
        let objNetworkHeader = {},
            objServiceRequestHeader = {},
            objAdditionRequestHeader = {},
                objCOBInfo = {},
            objSendToHeader = {};


        objNetworkHeader = {
            'strReferringToHeader': 'Network Management Request:',
            'showRefferingToName': true,
            'strReferringToName': ''
        };

            objCOBInfo ={
                'processingCOB' : '',
                'voiceMail' : '',
                'nameofIns' : '',
                'numofOtherIns': '',
                'pHname':'',
                'pHSSN' : '',
                'phDOB' : '',
                'othInsPhone': '',
                'OthEffDate1':'',
                'OthEffDate2':''
            };
            component.set('v.objCOBInfo',objCOBInfo);
            console.log('=@objCOBInfo'+JSON.stringify(component.get('v.objCOBInfo')));

        objServiceRequestHeader = {
            'strReferringToHeader': 'Service Request Requirement',
            'showRefferingToName': false
        };
        objAdditionRequestHeader = {
            'strReferringToHeader': 'Additional Request Details',
            'showRefferingToName': false
        };
        objSendToHeader = {
            'strReferringToHeader': 'Send To',
            'showRefferingToName': false
        };
        component.set("v.objServiceRequestHeader", objServiceRequestHeader);
        component.set("v.objAdditionRequestHeader", objAdditionRequestHeader);
        component.set("v.objSendToHeader", objSendToHeader);
        helper.getORSMetaDataRecords(component, event, helper);
        helper.wrapperResults(component, event, helper);
        var pageReference = component.get("v.pageReference");
        var caseResponse = pageReference.state.c__caseResponse;
        var isProvider = pageReference.state.c__isProvider;
		//DE436123 -Sravan - Start
        component.set("v.providerFlow",isProvider);
        //DE436123 -Sravan - End
            //US3182829 - Sravan - Start
            var policyState = pageReference.state.c__policyState;
            var requestResource = '';
            var caseWrapper = pageReference.state.c__caseWrapper;
            if(caseWrapper.AddInfoTopic == 'Member Not Found'){
                if(caseWrapper.stateCode == 'AZ' || caseWrapper.stateCode == 'KS' || caseWrapper.stateCode == 'WA'){
                    requestResource = '3 - Provider 330 Request';
                }
                else{
                    requestResource = 'C-Call Center';
                }
            }
            else{
                if(policyState == 'AZ' || policyState == 'KS' || policyState == 'WA'){
                    requestResource = '3 - Provider 330 Request';
                }
                else{
                    requestResource = 'C-Call Center';
                }
            }
            component.set("v.requestResource",requestResource);
            //US3182829 - Sravan - End

            //US3376219 - Sravan - Start
            var memberNotFoundDetails = pageReference.state.c__memberNotFoundDetails;
            var freeFormCommentsVal = pageReference.state.c__freeFormCommentsVal;
            var comments = '';
            if(!$A.util.isUndefinedOrNull(memberNotFoundDetails) && !$A.util.isEmpty(memberNotFoundDetails)){
                comments = memberNotFoundDetails+'\n'+freeFormCommentsVal;
            }
            else{
                comments = freeFormCommentsVal;
            }
            //US3376219 - Sravan - End
            let objSubscriberAndProviderDetails = {};

            if(pageReference.state.c__isExchangePolicy) {
                component.set("v.showIsExchangeCard", true);
                component.set("v.caseWrapper", pageReference.state.c__caseWrapper);
                //US3075630
                component.set("v.ttsTopic", pageReference.state.c__ttsTopic);
                var providerDetails = component.get("v.providerDetailsForRoutingScreen");
                if (!$A.util.isEmpty(providerDetails)) {
                    component.set("v.providerDetails", providerDetails);
                }

                if (pageReference.state.c__ttsTopic == 'Provider Lookup') {
                    component.set("v.facetsTitle", "Service Request Requirement");
                    component.set("v.isProviderLookupWitNoOption", false);
                } else {
                    component.set("v.facetsTitle", component.get("v.caseWrapper.ttsSubType"));
                }
                return;
            }

            if(pageReference && pageReference.state && pageReference.state.c__caseWrapper) {
                var plFirstName = '';
                var plLastName = '';
                if(!$A.util.isUndefinedOrNull(pageReference.state.c__caseWrapper['SubjectName']) && !$A.util.isEmpty(pageReference.state.c__caseWrapper['SubjectName'])){
                    objSubscriberAndProviderDetails['subscriberName'] = pageReference.state.c__caseWrapper['SubjectName'];
                }
                else{
                    objSubscriberAndProviderDetails['subscriberName'] = '--';
                }
                if(!$A.util.isUndefinedOrNull(pageReference.state.c__caseWrapper['SubjectId']) && !$A.util.isEmpty(pageReference.state.c__caseWrapper['SubjectId'])){
                    if(pageReference.state.c__caseWrapper['AddInfoTopic'] != 'Member Not Found'){
                    objSubscriberAndProviderDetails['subscriberId'] = pageReference.state.c__caseWrapper['SubjectId'];
                }
                else{
                    objSubscriberAndProviderDetails['subscriberId'] = '--';
                }
                }
                else{
                    objSubscriberAndProviderDetails['subscriberId'] = '--';
                }
                if(!$A.util.isUndefinedOrNull(pageReference.state.c__caseWrapper['plFirstName']) && !$A.util.isEmpty(pageReference.state.c__caseWrapper['plFirstName'])){
                    plFirstName = pageReference.state.c__caseWrapper['plFirstName'];
                }
                if(!$A.util.isUndefinedOrNull(pageReference.state.c__caseWrapper['plLastName']) && !$A.util.isEmpty(pageReference.state.c__caseWrapper['plLastName'])){
                    plLastName = pageReference.state.c__caseWrapper['plLastName'];
                }
                var providerName = plFirstName+ ' '+plLastName;
                console.log('Provider Name'+ providerName);
                if(providerName != null  && providerName != undefined && providerName!= ' ') {
                    objSubscriberAndProviderDetails['providerName'] = providerName;
                } else {
                    objSubscriberAndProviderDetails['providerName'] = '--';
                }
                if(!$A.util.isUndefinedOrNull(pageReference.state.c__caseWrapper['CSPProviderId']) && !$A.util.isEmpty(pageReference.state.c__caseWrapper['CSPProviderId'])){
                    objSubscriberAndProviderDetails['cspProviderId'] = pageReference.state.c__caseWrapper['CSPProviderId'];
                }
                else{
                    objSubscriberAndProviderDetails['cspProviderId'] = '--';
                }
                objSubscriberAndProviderDetails['requestSource'] = 'C-Call Center';
                component.set("v.objSubscriberAndProviderDetails", objSubscriberAndProviderDetails);
                console.log('objSubscriberAndProviderDetails'+ JSON.stringify(objSubscriberAndProviderDetails));
            }

            if (pageReference && pageReference.state && pageReference.state.c__isFacetsCase) {
                component.set("v.isFacets", true);
                component.set("v.strTatProvided","");
                component.set("v.strTabLabel","AP");
            } else if( !isProvider && !pageReference.state.c__isFacetsCase ) {
                component.set("v.isFacets", false);
                component.set("v.strTabLabel","CO-CS");
            } else {
                component.set("v.strTabLabel","--");
            }

            if (isProvider) {
                component.set("v.isMemberLookup", false);
            } else {
                component.set("v.isMemberLookup", true);
            }

            if(component.get("v.isFacets") && pageReference.state.c__ttsTopic == 'Provider Lookup') {
                objNetworkHeader = {
                    'strReferringToHeader': 'Network Management Request:',
                    'showRefferingToName': true,
                    'strReferringToName': ''
                };
                component.set("v.showContactName",true);
                component.set("v.showExceptedPaymentAmount",true);
                component.set("v.strDefaultExceptedPaymentAmount",'10');
                component.set("v.strIssueMetadataName","ACET_Macess_Network_Management__mdt");
                component.set("v.strIssueSearchName","Issue_Code__c");
                component.set("v.strIssueOrderByName","Order__c");
                component.set("v.facetsReasonCategory",'Network Management');
                component.set("v.strTatProvided",'10');
            } else if (component.get("v.isFacets") && pageReference.state.c__caseWrapper.ttsSubType == 'COB Investigation Initiated') {
                objNetworkHeader = {
                    'strReferringToHeader': 'COB Investigation Request:',
                    'showRefferingToName': true,
                    'strReferringToName': ''
                };
                component.set("v.showHOPandTable",false);
                component.set("v.showContactName",true);
                component.set("v.showExceptedPaymentAmount",false);
                component.set("v.strIssueMetadataName","ACET_Macess_COB_Request__mdt");
                component.set("v.strIssueSearchName","Issue_Code__c");
                component.set("v.strIssueOrderByName","Order__c");
                component.set("v.facetsReasonCategory",'COB Request');
                component.set("v.strTatProvided",'');
                component.set("v.isProvider", true);
            } else if (component.get("v.isFacets") && pageReference.state.c__caseWrapper.ttsSubType == 'Eligibility Investigation Initiated') {
                objNetworkHeader = {
                    'strReferringToHeader': 'Eligibility Investigation Request:',
                    'showRefferingToName': true,
                    'strReferringToName': ''
                };
                component.set("v.showHOPandTable",false);
                component.set("v.showContactName",true);
                component.set("v.showExceptedPaymentAmount",false);
                component.set("v.strIssueMetadataName","ACET_Macess_Enrollment_Request__mdt");
                component.set("v.strIssueSearchName","Issue_Code__c");
                component.set("v.strIssueOrderByName","Order__c");
                component.set("v.facetsReasonCategory",'Enrollment Request');
                component.set("v.strTatProvided",'');
                component.set("v.isProvider", true);
            } else {
                component.set("v.strIssueMetadataName","SAE_Reason_Codes__mdt");
                component.set("v.strIssueSearchName","Issue__c");
                component.set("v.strIssueOrderByName","Issue__c");
                component.set("v.isProvider", isProvider);
                component.set("v.strTatProvided",'15');
                component.set("v.showSendToSection",true);
            }

            component.set("v.objNetworkHeader", objNetworkHeader);

            var caseResponse = pageReference.state.c__caseResponse;
        var isMemberLookup = pageReference.state.c__isMemberLookup;
        var caseWrapper = pageReference.state.c__caseWrapper;

        var mapClaimSummaryDetails = JSON.parse(pageReference.state.c__mapClaimSummaryDetails);
        component.set("v.mapClaimSummaryDetails", mapClaimSummaryDetails);
            var providerDetailsForRoutingScreen = pageReference.state.c__providerDetailsForRoutingScreen;
            component.set("v.providerDetailsForRoutingScreen", providerDetailsForRoutingScreen);
        component.set("v.data", caseWrapper);
        var strTopic = pageReference.state.c__ttsTopic;
        var strSubTopic = pageReference.state.c__ttsSubType;
        //US3068299 - Sravan - 21/11/2020 - Start
        var finalPolicyMap = pageReference.state.c__finalPolicyMap;
        var memberMap = pageReference.state.c__memberMap;
        component.set("v.finalPolicyMap", finalPolicyMap);
        component.set("v.memberMap", memberMap);
        //US3068299 - Sravan - 21/11/2020 - End
        //US3117073 - Sravan - 29/12/2020 - Start
        var memberPolicyNumberMap = pageReference.state.c__memberPolicyNumberMap;
        component.set("v.memberPolicyNumberMap", memberPolicyNumberMap);
        console.log('memberPolicyNumberMap in routing comp' + JSON.stringify(memberPolicyNumberMap));
        //US3117073 - Sravan - 29/12/2020 - End


        //US3259671 - Sravan - Start
        var flowDetails = pageReference.state.c__flowDetails;
            //US3182779 - Sravan - Start
            if(!$A.util.isUndefinedOrNull(flowDetails) && !$A.util.isEmpty(flowDetails)){
                if($A.util.isUndefinedOrNull(flowDetails.conStartTime) || $A.util.isEmpty(flowDetails.conStartTime)){
                    flowDetails.conStartTime = '9:00';
                }
                if($A.util.isUndefinedOrNull(flowDetails.conEndTime) || $A.util.isEmpty(flowDetails.conEndTime)){
                    flowDetails.conEndTime = '5:00';
                }
                if($A.util.isUndefinedOrNull(flowDetails.conStartType) || $A.util.isEmpty(flowDetails.conStartType)){
                    flowDetails.conStartType = 'AM';
                }
                if($A.util.isUndefinedOrNull(flowDetails.conEndType) || $A.util.isEmpty(flowDetails.conEndType)){
                    flowDetails.conEndType = 'PM';
                }
                if($A.util.isUndefinedOrNull(flowDetails.conTimeZone) || $A.util.isEmpty(flowDetails.conTimeZone)){
                    flowDetails.conTimeZone = 'Central - CST';
                }
            }
            //US3182779 - Sravan - End
        component.set("v.flowDetails",flowDetails);
            console.log('Flow Details'+ JSON.stringify(flowDetails));
        //US3259671 - Sravan - End


        //added by sravani
        component.set("v.viewClaims", strTopic);
        component.set("v.viewClaimsSubType", strSubTopic);
        if (pageReference.state.c__ttsTopic == 'View Claims') {
            component.set("v.isClaim", true)
        }

        // End of addition
        // US2543182 - Thanish - 6th May 2020
        component.set("v.ttsTopic", pageReference.state.c__ttsTopic);
        component.set("v.whereTTSTopic", 'Topic__c = ' + "'" + pageReference.state.c__ttsTopic + "'");
            if (pageReference.state.c__ttsTopic != 'View Claims'
                && pageReference.state.c__caseWrapper.ttsSubType != 'COB Investigation Initiated'
                && pageReference.state.c__caseWrapper.ttsSubType != 'Eligibility Investigation Initiated' &&
                !component.get("v.isFacets")) {
            component.set("v.strIssueFilterCondition", 'Topic__c = ' + "'" + pageReference.state.c__ttsTopic + "'");
        }
        component.set("v.strWhereCondition", 'Topic__c = ' + "'" + pageReference.state.c__ttsTopic);
        //US2883416 - Change Functionality on Routing Screen - Sravan - Start
        component.set("v.whereConditionForDepartment", 'Topic__c = ' + "'" + pageReference.state.c__ttsTopic + "'");
        component.set("v.whereConditionForTeam", 'Topic__c = ' + "'" + pageReference.state.c__ttsTopic + "'");
        //US2883416 - Change Functionality on Routing Screen - Sravan - End
        component.set("v.AutodocPageFeature", pageReference.state.c__pagefeature);
        component.set("v.AutodocKey", pageReference.state.c__AutodocKey);
        component.set("v.uhcProduct", pageReference.state.c__uhcProduct);
            component.set("v.sendToListInputs.comments",comments);
        component.set("v.caseWrapper", caseWrapper);
            if (pageReference.state.c__ttsTopic != 'View Claims' && component.get("v.showHOPandTable")) {
            helper.getSpecialityData(component, event, helper, caseWrapper);
        }
        //DE418730 - Sravan - start
        component.set("v.whereConditionForAdvocate", 'Topic__c = '+ "'" +pageReference.state.c__ttsTopic+"'"+' AND Type__c ='+ "'"+'Issue Routed'+"'"+' AND Subtype__c ='+"'"+pageReference.state.c__ttsSubType+"'");
        //DE418730 - Sravan - end
        if (pageReference.state.c__ttsTopic == 'View Claims') {
            component.set("v.whereTTSTopic", 'Topic__c =' + "'" + 'View Claims' + "'" + ' AND Type__c =' + "'" + 'Issue Routed' + "'" + ' AND Subtype__c =' + "'" + pageReference.state.c__ttsSubType + "'");
            component.set("v.disableRoleField", false);
            component.set("v.disableQuickListField", false);
            component.set("v.hideEntireSection", false);
            component.set("v.isClaimView", true)
            component.set("v.whereConditionForAdvocate", 'Topic__c =' + "'" + 'View Claims' + "'" + ' AND Type__c =' + "'" + 'Issue Routed' + "'");
            component.set("v.quickListFieldsRequiredSymbol", false);

        }

        component.set("v.caseResponse", caseResponse);
        component.set("v.sendToListInputs.memberName", caseWrapper.SubjectName);
        component.set("v.sendToListInputs.memberId", caseWrapper.SubjectId);
        component.set("v.sendToListInputs.memberDOB", caseWrapper.SubjectDOB);
        helper.getReasonCodesRecords(component, event, helper);

        //DE347387: ORS Issue - Provider information is missing in ORS routing Screen
        var providerDetailsForRoutingScreen = pageReference.state.c__providerDetailsForRoutingScreen;
        component.set("v.providerDetailsForRoutingScreen", providerDetailsForRoutingScreen);
        var flowDetailsForRoutingScreen = pageReference.state.c__flowDetailsForRoutingScreen;
        component.set("v.flowDetailsForRoutingScreen", flowDetailsForRoutingScreen);
        helper.getContactDetails(component, event, helper);
            if(component.get("v.showHOPandTable")) {
        helper.getDelegatedProviderInfo(component);
            }
        window.scroll(0, 0);

        } catch(exception) {
            console.log(' Exception ' + exception );
        }
        /*var pageReference = component.get("v.pageReference");
        if (pageReference && pageReference.state && pageReference.state.c__isFacetsCase) {
            component.set("v.isFacets", true);
            component.set("v.caseWrapper", pageReference.state.c__caseWrapper);
            //US3075630
            component.set("v.ttsTopic", pageReference.state.c__ttsTopic);
            var providerDetails = component.get("v.providerDetailsForRoutingScreen");
            if (!$A.util.isEmpty(providerDetails)) {
                component.set("v.providerDetails", providerDetails);
            }

            if (pageReference.state.c__ttsTopic == 'Provider Lookup') {
                component.set("v.facetsTitle", "Service Request Requirement");
                component.set("v.isProviderLookupWitNoOption", false);
            } else {
                component.set("v.facetsTitle", component.get("v.caseWrapper.ttsSubType"));
            }
        }*/
    },


    openMisdirectComp: function(cmp, event, helper) {
        helper.openMisDirect(cmp);
    },
    topFocus: function(cmp, event, helper) {
       setTimeout(function() {
                 cmp.find("ClaimServiceRoutings").getElement().scrollIntoView({
                        behavior: 'smooth',
                        block: 'center',
                        inline: 'nearest'
                    });
                 }, 100);
     },

    getContactNumber: function(component, event, helper) {
        debugger;
        //DE347387: ORS Issue - Provider information is missing in ORS routing Screen
        var providerDetails = event.getParam("providerDetails");
        component.set("v.providerDetails", providerDetails);
        var contactNumber = event.getParam("contactNumber");
        var contactExt = event.getParam("contactExt");

        var contactNum = contactNumber;
        var s = ("" + contactNum).replace(/\D/g, '');
        var m = s.match(/^(\d{3})(\d{3})(\d{4})$/);
        var formattedPhone = (!m) ? null : m[1] + "-" + m[2] + "-" + m[3]; // (!m) ? null : "(" + m[1] + ") " + m[2] + "-" + m[3]
        //var contactNumberExt = providerDetails.contactNumber +' (Ext '+providerDetails.contactExt+')';
        var contactNumberExt = formattedPhone + ' Ext(' + contactExt + ')';
        if (!$A.util.isUndefinedOrNull(contactNumberExt)) {
            //component.set("v.sendToListInputs.phoneNumber",providerDetails.contactNumber);
            component.set("v.sendToListInputs.phoneNumber", contactNumberExt);
        }

    },

    handleKeyup: function(component, event, helper) {
        var elem = event.getSource().get('v.value');
        var max = 2000;
        var remaining = max - elem.length;

        component.set('v.charsRemaining', remaining);
    },

    quickListChange: function(component, event) {

        var allList = component.get("v.sendToListInputs");
        var teamQuickList = allList.teamQuickList;
        var orsMap = component.get("v.orsMap");
        for (var i in orsMap) {
            if (orsMap[i].Team_Quick_List__c == teamQuickList) {
                component.set("v.sendToListInputs.office", orsMap[i].Office__c);
                component.set("v.sendToListInputs.department", orsMap[i].Department__c);
                component.set("v.sendToListInputs.team", orsMap[i].Team__c);
                component.set("v.sendToListInputs.officeAPI", orsMap[i].Office_API__c);
                component.set("v.sendToListInputs.departmentAPI", orsMap[i].Department_API__c);
                component.set("v.sendToListInputs.teamAPI", orsMap[i].Team_API__c);
            }
        }
    },
    officeChange: function(component, event) {
        var allList = component.get("v.sendToListInputs");
        var office = allList.office;
        var orsMap = component.get("v.orsMap");
        for (var i in orsMap) {
            if (orsMap[i].Office__c == office) {
                component.set("v.sendToListInputs.officeAPI", orsMap[i].Office_API__c);
            }
        }
    },
    departmentChange: function(component, event) {
        var allList = component.get("v.sendToListInputs");
        var department = allList.department;
        var orsMap = component.get("v.orsMap");
        for (var i in orsMap) {
            if (orsMap[i].Department__c == department) {
                component.set("v.sendToListInputs.departmentAPI", orsMap[i].Department_API__c);
            }
        }
    },
    teamChange: function(component, event) {
        var allList = component.get("v.sendToListInputs");
        var team = allList.team;
        var orsMap = component.get("v.orsMap");
        for (var i in orsMap) {
            if (orsMap[i].Team__c == team) {
                component.set("v.sendToListInputs.teamAPI", orsMap[i].Team_API__c);
            }
        }
    },

    switchYesOrNo: function(component, event, helper) {
        var selectRadio = event.getParam('value');
        component.set("v.selectedRadioValue", selectRadio);
        if (selectRadio == 'No') {
            component.set("v.hideEntireSection", true);
            component.set("v.disableRoleField", false);
            component.set("v.disableQuickListField", false);
            component.set("v.quickListFieldsRequiredSymbol", false);

        } else if (selectRadio == 'Yes') {
            component.set("v.hideEntireSection", false);
        }
    },

    switchYesOrNoFacets: function(component, event, helper) {
        var selectRadio = event.getParam('value');
        component.set("v.selectedRadioValue", selectRadio);
        if (selectRadio == 'No') {
            component.set("v.isProviderLookupWitNoOption", true);
        } else if (selectRadio == 'Yes') {
            component.set("v.isProviderLookupWitNoOption", false);
        }
    },

    chooseSendOptions: function(component, event, helper) {
        var selectList = event.getParam('value');
        component.set("v.selectedSendValue", selectList);
        if (selectList == 'teamList') {
            component.set("v.quickListFieldsRequiredSymbol", false);
            component.set("v.officeFieldsRequiredSymbol", true);
            component.set("v.disableRoleField", false);
            component.set("v.disableQuickListField", false);
            component.set("v.disableOfficeField", true);
            component.set("v.disableDepartmentField", true);
            component.set("v.disableTeamField", true);
        } else if (selectList == 'office') {
            component.set("v.officeFieldsRequiredSymbol", false);
            component.set("v.quickListFieldsRequiredSymbol", true);
            component.set("v.disableOfficeField", false);
            //US2883416 - Change Functionality on Routing Screen - Sravan - Start
            //component.set("v.disableDepartmentField",false);
            //component.set("v.disableTeamField",false);
            //US2883416 - Change Functionality on Routing Screen - Sravan - End
            component.set("v.disableRoleField", true);
            component.set("v.disableQuickListField", true);
        }
    },
    togglePopup: function(cmp, event) {
        let showPopup = event.currentTarget.getAttribute("data-popupId");
        cmp.find(showPopup).toggleVisibility();
    },
	
	validation : function(component, event, helper) {
        var issueId = component.find('idServiceRequestTabs').find('idServiceRequest').find('issueId').find('comboboxFieldAI').get("v.value");
        var endTimeId = component.find('idServiceRequestTabs').find('idServiceRequest').find('endTimeId').find('comboboxFieldAI').get("v.value");
        var startTimeId = component.find('idServiceRequestTabs').find('idServiceRequest').find('startTimeId').find('comboboxFieldAI').get("v.value");
        component.set('v.showError',false);
        if(issueId =="Select"){            
            component.find('idServiceRequestTabs').find('idServiceRequest').find('issueId').validation();
            component.find('idServiceRequestTabs').find('idServiceRequest').find('issueId').find('comboboxFieldAI').reportValidity();
            //return;
        }
        if(startTimeId =="Select"){
            component.find('idServiceRequestTabs').find('idServiceRequest').find('startTimeId').validation();
            component.find('idServiceRequestTabs').find('idServiceRequest').find('startTimeId').find('comboboxFieldAI').reportValidity();
            //return;
        }
        if(endTimeId =="Select"){
            component.find('idServiceRequestTabs').find('idServiceRequest').find('endTimeId').validation();
            component.find('idServiceRequestTabs').find('idServiceRequest').find('endTimeId').find('comboboxFieldAI').reportValidity();
            //return;
        }
        return;
    },

    createCase: function(component, event, helper) {
        component.set("v.isSubmitClicked", true);
        helper.showSpinner(component, event, helper);
        var allList = component.get("v.sendToListInputs");

        //var stateId = component.find('stateId').find('StateAI').find('comboboxFieldAI').get("v.value");
        var issueId = component.find('idServiceRequestTabs').find('idServiceRequest').find('issueId').find('comboboxFieldAI').get("v.value");
        var advocateRoleId = component.find('idServiceRequestTabs').find('idSendToNonClaims').find('advocateRoleId').find('comboboxFieldAI').get("v.value");
        var teamQuickListId = component.find('idServiceRequestTabs').find('idSendToNonClaims').find('teamQuickListId').find('comboboxFieldAI').get("v.value");
        var officeId = component.find('idServiceRequestTabs').find('idSendToNonClaims').find('officeId').find('comboboxFieldAI').get("v.value");
        var departmentId = component.find('idServiceRequestTabs').find('idSendToNonClaims').find('departmentId').find('comboboxFieldAI').get("v.value");
        var teamId = component.find('idServiceRequestTabs').find('idSendToNonClaims').find('teamId').find('comboboxFieldAI').get("v.value");
        var contactNumber = component.find('idServiceRequestTabs').find('idServiceRequest').find('idContactNumber').get("v.value");
        var manualEnteredComments = !$A.util.isEmpty(allList.comments) ? allList.comments : '';
        var isAllValid = false;
        //component.find("stateId").find('StateAI').checkValidation();

        component.find('idServiceRequestTabs').find('idServiceRequest').find('idContactNumber').checkValidity();
        component.find('idServiceRequestTabs').find('idServiceRequest').find('idContactNumber').reportValidity();

		var validation = component.get('c.validation');
        $A.enqueueAction(validation);

        var controlAuraIds = [];
        controlAuraIds = ["commentsBoxId"];
        if (!component.get('v.isDoesNotKnowChecked')) {
            controlAuraIds = ["commentsBoxId", "idPaymentAmount"];
        }

        isAllValid = helper.validateAllFields(component, event, controlAuraIds, 'idServiceRequestTabs', 'idAdditionalRequest');
        let regularExpression = /^(0*[1-9][0-9]*(\.[0-9]+)?|0+\.[0-9]*[1-9][0-9]*)$/;
        if (!component.get("v.isDoesNotKnowChecked") && !regularExpression.test(component.get("v.strPaymentAmount")) && !component.get("v.isClaim")) {
            isAllValid = false;
        }

        if (isAllValid && issueId != 'Select' && officeId != 'Select' && departmentId != 'Select' &&
            teamId != 'Select' && (contactNumber != '' && contactNumber != null && contactNumber != undefined) && ((component.get("v.selectedSendValue") == 'teamList' && advocateRoleId != 'Select' &&
                teamQuickListId != 'Select') || component.get("v.selectedSendValue") == 'office')) {
            //Case creation - Sravan
            var myPageRef = component.get("v.pageReference");
            //DE325770-Sravan
            var caseData = myPageRef.state.c__caseWrapper;
            let caseWrapper = {};
            if (!$A.util.isUndefinedOrNull(caseData)) {
                for (let keyVal in caseData) {
                    if (!$A.util.isUndefinedOrNull(caseData[keyVal])) {
                        caseWrapper[keyVal] = caseData[keyVal];
                    }
                }
            }

            //Case Item Issue
            var caseItems = caseWrapper.caseItems;
            if (caseItems != null || caseItems != undefined) {
                caseWrapper.caseItems = Object.values(caseItems);
            } else {
                caseWrapper.caseItems = [];
            }
            //End

            helper.setResolvedData(component, event, helper);
            caseWrapper.savedAutodoc = component.get("v.caseWrapper.savedAutodoc");

            if (!$A.util.isUndefinedOrNull(caseWrapper)) {

                caseWrapper.issueId = issueId;
                caseWrapper.departmentAPI = allList.departmentAPI;
                caseWrapper.officeAPI = allList.officeAPI;
                caseWrapper.teamAPI = allList.teamAPI;
                caseWrapper.manualEnteredComments = manualEnteredComments;

                //US3259671 - Sravan - Start
                var flowDetails = component.get("v.flowDetails");
                if(!$A.util.isUndefinedOrNull(flowDetails) && !$A.util.isEmpty(flowDetails)){
                    var hoursOfOperation = {};
                    var validation = 0;

                    if(!$A.util.isUndefinedOrNull(flowDetails.conStartTime) && !$A.util.isEmpty(flowDetails.conStartTime) && flowDetails.conStartTime != 'Select'){
                        hoursOfOperation.startTime = flowDetails.conStartTime;
                    }
                    else{
                        validation = validation+1;
                    }
                    if(!$A.util.isUndefinedOrNull(flowDetails.conEndTime) && !$A.util.isEmpty(flowDetails.conEndTime) && flowDetails.conEndTime != 'Select'){
                        hoursOfOperation.endTime = flowDetails.conEndTime;
                    }
                    else{
                        validation = validation+1;
                    }
                    hoursOfOperation.startTimeType = flowDetails.conStartType;
                    hoursOfOperation.endTimeType = flowDetails.conEndType;
                    hoursOfOperation.timeZone = flowDetails.conTimeZone;
                    caseWrapper.hoursOfOperation = hoursOfOperation;
                    component.set("v.hoursOfOperation", hoursOfOperation);

                    if(validation > 0){
                        component.set("v.validateHoursOfOperation",true);
                        helper.hideSpinner(component,event,helper);
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "title": "We hit a snag.",
                            "message": "Complete Hours of Operation.",
                            "type": "error"
                        });
                        toastEvent.fire();
                        return;
                    }


                }
                helper.commentsUI(component, event, helper);
                var finalComments = component.get("v.comments");
                var concatComments = component.get("v.concatComments");
                console.log('concatComments' + concatComments);
                console.log('Final Comments:::' + finalComments)
                caseWrapper.comments = finalComments;
                caseWrapper.concatinatedComments = concatComments;

                //US3259671 - Sravan - End
                //US3068299 - Sravan - 21/11/2020 - Start
                caseWrapper.createORSCase = true;



                component.set("v.caseWrapper", caseWrapper);
                var lstUnResolvedProviders = component.get("v.lstUnResolvedProviders") ;

           		if(caseWrapper.AddInfoTopic == "Provider Details"){
                    if( !$A.util.isEmpty(lstUnResolvedProviders) && lstUnResolvedProviders[0].IsDelegatedSpeciality){
						caseWrapper.AddInfoOrginType='Issue Resolved';
                    }
            	}
                //US3068299 - Sravan - 21/11/2020 - End
                var strWrapper = JSON.stringify(caseWrapper);
                var isProvider = component.get("v.isProvider");
                var createCase = component.get("c.saveCase");
                createCase.setParams({
                    'strRecord': strWrapper,
                    'isProvider': isProvider
                });
                createCase.setCallback(this, function(response) {
                    var state = response.getState();
                    if (state == 'SUCCESS') {
                        var caseId = response.getReturnValue();
                        component.set("v.caseId", caseId);
                        //US3068299 - Sravan - 21/11/2020 - Start
                        helper.createExternalCases(component, event, helper);
                        //US3068299 - Sravan - 21/11/2020 - End

                    } else if (state == 'INCOMPLETE') {
                        helper.hideSpinner(component, event, helper);
                    } else if (state == 'ERROR') {
                        var errors = response.getError();
                        if (errors) {
                            if (errors[0] && errors[0].message) {
                                console.log("Error message: " + errors[0].message);
                            }
                        } else {
                            console.log("Unknown error");
                        }
                        helper.hideSpinner(component, event, helper);
                    }
                });
                $A.enqueueAction(createCase);
            } else {
                helper.hideSpinner(component, event, helper);
            }
        } else {
            helper.hideSpinner(component, event, helper);
        }

    },

    // US2543182 - Thanish - 13th May 2020
    openTTSPopUp: function(component, event, helper) {
        var workspaceAPI = component.find("workspace");
        workspaceAPI.closeTab({
            tabId: component.get("v.tabId")
        });
    },

    // US2543182 - Thanish - 13th May 2020
    onSOPLinkClick: function(cmp) {
        cmp.set("v.isSOPLinkClicked", true);
    },

    onTabFocused: function(cmp, event, helper) {
        let focusedTabId = event.getParam('currentTabId');
        let tabId = cmp.get("v.tabId");

        if ($A.util.isEmpty(tabId)) {
            cmp.set("v.tabId", focusedTabId);
        }
    },

    onTabClosed: function(cmp, event, helper) {
        var pageReference = cmp.get("v.pageReference");
        if (event.getParam('tabId') == cmp.get("v.tabId")) {
            var appEvent = $A.get("e.c:ACET_OpenTTSPopUPFromRouting");
            appEvent.setParams({
                "autodocKey": cmp.get("v.AutodocKey"), // DE376017 - Thanish - 16th Oct 2020
                "openPopup": !cmp.get("v.isSubmitClicked"),
                "linkClicked": cmp.get("v.isSOPLinkClicked"),
                "isCancelClicked": cmp.get("v.IsDelegatedSpeciality"),
                "strDelegatedData": cmp.get("v.strDelegatedData")
            });
            appEvent.fire();
        }
        if (pageReference.state.c__ttsTopic == 'View Claims' && cmp.get("v.isClosedPopup")) {
            if (event.getParam('tabId') == cmp.get("v.tabId")) {
                var appEvent = $A.get("e.c:ACET_OpenTTSPopUPForClaim");

                appEvent.fire();
            }
        }
    },

    issueChange: function(component, event, helper) {
        component.set("v.sendToListInputs.issue", component.get("v.strIssue"));
        var allList = component.get("v.sendToListInputs");
        var issue = allList.issue;
        var reasonCodeMap = component.get("v.reasonCodesMap");
        for (var i in reasonCodeMap) {
            if (reasonCodeMap[i].Issue__c == issue) {
                component.set("v.reasonCode", reasonCodeMap[i].Reason__c);
                component.set("v.category", reasonCodeMap[i].Category__c);
            }
        }
    },

    handleDoesNotKnowChecked: function(component, event, helper) {
        console.log(' Event ' + event);
    },
    setProviderDetails: function(component, event, helper) {
        debugger;
        var providerDetails = event.getParam("providerDetails");
        component.set("v.providerDetails", providerDetails);
        console.log('provider details event' + JSON.stringify(providerDetails));
        var contactNum = providerDetails.contactNumber;
        var s = ("" + contactNum).replace(/\D/g, '');
        var m = s.match(/^(\d{3})(\d{3})(\d{4})$/);
        var formattedPhone = (!m) ? null : m[1] + "-" + m[2] + "-" + m[3]; //(!m) ? null : "(" + m[1] + ") " + m[2] + "-" + m[3];
        var contactNumberExt = formattedPhone + ' Ext(' + providerDetails.contactExt + ')';
        if (!$A.util.isEmpty(contactNumberExt)) {
            component.set("v.sendToListInputs.phoneNumber", contactNumberExt);
        }
    },

    //US2883416 - Change Functionality on Routing Screen - Sravan
    enableDepartment: function(component, event, helper) {

        var whereTTSTopic = component.get("v.whereTTSTopic");
        var whereCondition = whereTTSTopic + ' AND ' + 'Office__c = ' + "'" + component.get("v.sendToListInputs").office + "'";
        component.set("v.whereConditionForDepartment", whereCondition);
        component.set("v.departmentReload", !component.get("v.departmentReload"));
        component.set("v.disableDepartmentField", false);
        if (component.get("v.sendToListInputs").office == 'Select') {
            var sendToListInputs = component.get("v.sendToListInputs");
            sendToListInputs.department = 'Select';
            component.set("v.sendToListInputs", sendToListInputs);
        }
    },
    //US2883416 - Change Functionality on Routing Screen - Sravan
    enableTeam: function(component, event, helper) {

        var whereTTSTopic = component.get("v.whereTTSTopic");
        var whereCondition = whereTTSTopic + ' AND ' + 'Office__c = ' + "'" + component.get("v.sendToListInputs").office + "'" + ' AND ' + 'Department__c = ' + "'" + component.get("v.sendToListInputs").department + "'";
        component.set("v.whereConditionForTeam", whereCondition);
        component.set("v.teamReload", !component.get("v.teamReload"));
        component.set("v.disableTeamField", false);
        if (component.get("v.sendToListInputs").department == 'Select') {
            var sendToListInputs = component.get("v.sendToListInputs");
            sendToListInputs.team = 'Select';
            component.set("v.sendToListInputs", sendToListInputs);
        }
    },
    //auto select
    ///added sravani
    advoacteRoleChange: function(component, event, helper) {
        var pageReference = component.get("v.pageReference");
        if (pageReference.state.c__ttsTopic == 'View Claims') {

            var allList = component.get("v.sendToListInputs");
            var advocateRole = allList.advocateRole;
            var whereTTSTopic = component.get("v.whereTTSTopic");
            if (component.get("v.sendToListInputs").advocateRole != 'Select') {
                var whereCondition = 'Topic__c =' + "'" + 'View Claims' + "'" + ' AND Type__c =' + "'" + 'Issue Routed' + "'" + ' AND ' + 'Advocate_Role__c = ' + "'" + advocateRole + "'";
                if (pageReference.state.c__ttsSubType.includes('Stop Pay and Reissue')) {
                    whereCondition = whereCondition + ' AND Subtype__c =' + "'" + 'Stop Pay Reissue' + "'";
                } else {
                    whereCondition = whereCondition + ' AND Subtype__c =' + "'" + pageReference.state.c__ttsSubType + "'";
                }
                component.set("v.whereTTSTopic", whereCondition);

                var sendToListInputs = component.get("v.sendToListInputs");
                sendToListInputs.teamQuickList = 'Select';
                component.set("v.sendToListInputs", sendToListInputs);
                console.log('advoacte role' + whereCondition)
                component.set("v.TeamQuickListReload", !component.get("v.TeamQuickListReload"));
                component.set("v.officeReload", !component.get("v.officeReload"));
                component.set("v.disableTeamField", true);
            }



        }
    },
    onTeamQuickChange: function(component, event, helper) {
        var pageReference = component.get("v.pageReference");
        if (pageReference.state.c__ttsTopic == 'View Claims') {

            var allList = component.get("v.sendToListInputs");
            var office = allList.office;
            component.set("v.whereTTSTopic", '');
            //if(component.get("v.sendToListInputs").office!='Select'){
            var whereCondition = 'Topic__c =' + "'" + 'View Claims' + "'" + ' AND Type__c =' + "'" + 'Issue Routed' + "'";
            if (pageReference.state.c__ttsSubType.includes('Stop Pay and Reissue')) {
                whereCondition = whereCondition + ' AND Subtype__c =' + "'" + 'Stop Pay Reissue' + "'";
            } else {
                whereCondition = whereCondition + ' AND Subtype__c =' + "'" + pageReference.state.c__ttsSubType + "'";
            }
            component.set("v.whereTTSTopic", whereCondition);
            console.log('office' + whereCondition);
            component.set("v.officeReload", !component.get("v.officeReload"));
            // }

            console.log('officeReload' + whereCondition)


        }
    },

    ShowSendTO: function(cmp, event, helper) {
        var sendItem = event.getParam("sendToCmp");
        cmp.set('v.isShowCmp', sendItem);
    },
    //sravani End

    onChangeOffice: function(component, event, helper) {},


    // function automatic called by aura:waiting event
    showSpinner: function(component, event, helper) {
        // remove slds-hide class from mySpinner
        var spinner = component.find("mySpinner");
        $A.util.removeClass(spinner, "slds-hide");
    },

    // function automatic called by aura:doneWaiting event
    hideSpinner: function(component, event, helper) {
        // add slds-hide class from mySpinner
        var spinner = component.find("mySpinner");
        $A.util.addClass(spinner, "slds-hide");
    },
    toggleFlag: function(cmp, event, helper) {
        cmp.set('v.isShowCmp', cmp.get('v.isShowCmp') ? false : true);
    },

    // US2948257: Update TAT Section to match Claims Routing - UI
    onRadioBtnSelect: function(cmp, event) {
        cmp.set("v.selectedRadioBtnValue", event.currentTarget.getAttribute("data-value"));
    },

    valueChangeValidation: function(component, event, helper) {
        component.set("v.isNotValidSFNo", false);
        var inputField = component.find('idSFNo');
        var value = inputField.get('v.value');
        if (value != '' && value.length == 19) {
            inputField.set('v.validity', {
                valid: false,
                badInput: true
            });
            inputField.reportValidity();
        }
    },

    submitFacetsCase: function(component, event, helper) {
        if(component.get("v.showIsExchangeCard")) {
        var inputField = component.find("idSFNo").getElement().value;
        var pattern = '^(?=.*[a-zA-Z])(?=.*[0-9])[A-Za-z0-9]+$';
        if (inputField.length < 19 || inputField == '' || inputField.match(pattern) == null) {
            component.find("idSFNoCard").getElement().classList.add('slds-has-error');
            component.set("v.isNotValidSFNo", true);
            return;
        } else {
            component.find("idSFNoCard").getElement().classList.remove('slds-has-error');
            component.set("v.isNotValidSFNo", false);
        }
        }
        helper.showSpinner(component, event, helper);
        var myPageRef = component.get("v.pageReference");
        let caseWrapper = myPageRef.state.c__caseWrapper;
        var caseItems = caseWrapper.caseItems;
        if (caseItems != null || caseItems != undefined) {
            caseWrapper.caseItems = Object.values(caseItems);
        } else {
            caseWrapper.caseItems = [];
        }
        //US3068299 - Sravan - 21/11/2020 - Start
        caseWrapper.createFacetsCase = true;
        //US3068299 - Sravan - 21/11/2020 - End

        caseWrapper.facetsReasonCategory = component.get("v.facetsReasonCategory");
        caseWrapper.requestResource = component.get("v.requestResource");
        //US3182829 - Sravan - End


        //US3182779 - Sravan - Start
        //Issue Id Validation
        var sendToListInputs = component.get("v.sendToListInputs");
        var inputFieldsError = 0;
        if(!component.get("v.showIsExchangeCard")) {
            //US3182829 - Sravan - Start
            var issueId = component.find('idServiceRequestTabs').find('idServiceRequest').find('issueId').find('comboboxFieldAI').get("v.value");
            caseWrapper.issueId = issueId;
            let mandatoryFields = [];
            if(!component.get("v.showExceptedPaymentAmount")) {
                mandatoryFields = ["commentsBoxId", "tatId"];
            } else {
                mandatoryFields = ["commentsBoxId"];
            }
            let COBreqiredFields = ["processingCOB","voiceMail","nameofIns","numofOtherIns","pHname","pHSSN","phDOB","othInsPhone","OthEffDate1","OthEffDate2"];
            var facetsCategory =component.get("v.facetsReasonCategory");

            let regularExpression = /^(0*[1-9][0-9]*(\.[0-9]+)?|0+\.[0-9]*[1-9][0-9]*)$/, strTatProvided = component.find('idServiceRequestTabs').find('idAdditionalRequest').find('tatId').get('v.value');
            if (!component.get("v.showExceptedPaymentAmount") && strTatProvided && !regularExpression.test(strTatProvided)) {
                inputFieldsError = inputFieldsError+1;
            }
            for (var i in mandatoryFields) {
                let mandatoryFieldCmp = component.find('idServiceRequestTabs').find('idAdditionalRequest').find(mandatoryFields[i]);
                if (mandatoryFieldCmp.get("v.value") == '' || mandatoryFieldCmp.get("v.value") == null || mandatoryFieldCmp.get("v.value") == undefined) {
                    inputFieldsError = inputFieldsError+1;
                }
                else{
                    //US3182829 - Sravan
                    if(mandatoryFields[i] == 'commentsBoxId'){
                        caseWrapper.additionalRequestComments = mandatoryFieldCmp.get("v.value");
                    }
                    if(mandatoryFields[i] == 'tatId'){
                        caseWrapper.tatValue =  mandatoryFieldCmp.get("v.value");
                        caseWrapper.additionalRequestComments = caseWrapper.additionalRequestComments+ '\n'+ 'TAT : '+caseWrapper.tatValue;

                    }
                }
                mandatoryFieldCmp.checkValidity();
                mandatoryFieldCmp.reportValidity();
            }
            if(!$A.util.isUndefinedOrNull(facetsCategory) &&  !$A.util.isEmpty(facetsCategory) && facetsCategory == 'COB Request'){
                for(var i  in COBreqiredFields){
                    let mandatoryFieldCmp = component.find('idServiceRequestTabs').find('idServiceRequest').find(COBreqiredFields[i]);
                    console.log('==objCOBInfo'+JSON.stringify(component.get('v.objCOBInfo')));
                    if (  mandatoryFieldCmp.get("v.value") == '' || mandatoryFieldCmp.get("v.value") == null || mandatoryFieldCmp.get("v.value") == undefined) {
                        console.log('==objCOBInfo'+JSON.stringify( mandatoryFieldCmp.get("v.value") ));
                        inputFieldsError = inputFieldsError+1;
                    }
                    else{
                        //US3182829 - Sravan
                        if(COBreqiredFields[i] == 'processingCOB'){
                            caseWrapper.processingCOB = mandatoryFieldCmp.get("v.value");
                            caseWrapper.additionalRequestComments = caseWrapper.additionalRequestComments+ '\n'+ 'Are you processing COB for more than one member of the household : '+caseWrapper.processingCOB;
                        }
                        if(COBreqiredFields[i] == 'voiceMail'){
                            caseWrapper.voiceMail =  mandatoryFieldCmp.get("v.value");
                            caseWrapper.additionalRequestComments = caseWrapper.additionalRequestComments+ '\n'+ 'Does the member give permission to leave detailed voice mail : '+caseWrapper.voiceMail;
                        }
                        if(COBreqiredFields[i] == 'nameofIns'){
                            caseWrapper.nameofInsurance =  mandatoryFieldCmp.get("v.value");
                            caseWrapper.additionalRequestComments = caseWrapper.additionalRequestComments+ '\n'+ 'What is the other insurance : '+caseWrapper.nameofInsurance;
                        }
                        if(COBreqiredFields[i] == 'numofOtherIns'){
                            caseWrapper.numofOtherInsurance =  mandatoryFieldCmp.get("v.value");
                            caseWrapper.additionalRequestComments = caseWrapper.additionalRequestComments+ '\n'+ 'What is the Policy number of other insurance: '+caseWrapper.numofOtherInsurance;
                        }
                        if(COBreqiredFields[i] == 'pHname'){
                            caseWrapper.placeHolderName =  mandatoryFieldCmp.get("v.value");
                            caseWrapper.additionalRequestComments = caseWrapper.additionalRequestComments+ '\n'+ 'Policy holder name : '+caseWrapper.placeHolderName;
                        }
                        if(COBreqiredFields[i] == 'pHSSN'){
                            caseWrapper.placeHolderSSN =  mandatoryFieldCmp.get("v.value");
                            caseWrapper.additionalRequestComments = caseWrapper.additionalRequestComments+ '\n'+ 'Policy holder SSN : '+caseWrapper.placeHolderSSN;
                        }
                        if(COBreqiredFields[i] == 'phDOB'){
                            caseWrapper.placeHolderDOB =  mandatoryFieldCmp.get("v.value");
                            caseWrapper.additionalRequestComments = caseWrapper.additionalRequestComments+ '\n'+ 'Policy holder DOB : '+caseWrapper.placeHolderDOB;
                        }
                        if(COBreqiredFields[i] == 'othInsPhone'){
                            caseWrapper.otherInsPhone =  mandatoryFieldCmp.get("v.value");
                            caseWrapper.additionalRequestComments = caseWrapper.additionalRequestComments+ '\n'+ 'Other Insurance Phone : '+caseWrapper.otherInsPhone;

                        }
                        if(COBreqiredFields[i] == 'OthEffDate1'){
                            caseWrapper.OthEffDate1 =  mandatoryFieldCmp.get("v.value");
                            caseWrapper.additionalRequestComments = caseWrapper.additionalRequestComments+ '\n'+ 'Other Insurance Effective Date: '+caseWrapper.OthEffDate1;
                        }
                        if(COBreqiredFields[i] == 'OthEffDate2'){
                            caseWrapper.OthEffDate2 =  mandatoryFieldCmp.get("v.value");
                            caseWrapper.additionalRequestComments = caseWrapper.additionalRequestComments+ '\n'+ 'Other Insurance Term Date: '+caseWrapper.OthEffDate2;

                        }
                    }
                    mandatoryFieldCmp.checkValidity();
                    mandatoryFieldCmp.reportValidity();
                }
            }
            if(!$A.util.isUndefinedOrNull(sendToListInputs) &&  !$A.util.isEmpty(sendToListInputs)){
                if(!$A.util.isUndefinedOrNull(sendToListInputs.issue) &&  !$A.util.isEmpty(sendToListInputs.issue)){
                    if(sendToListInputs.issue == 'Select'){
                        component.find('idServiceRequestTabs').find('idServiceRequest').find('issueId').checkValidation();
                        component.find('idServiceRequestTabs').find('idServiceRequest').find('issueId').find('comboboxFieldAI').reportValidity();
                        inputFieldsError = inputFieldsError+1;
                    }
                }
                else{
                    component.find('idServiceRequestTabs').find('idServiceRequest').find('issueId').checkValidation();
                    component.find('idServiceRequestTabs').find('idServiceRequest').find('issueId').find('comboboxFieldAI').reportValidity();
                    inputFieldsError = inputFieldsError+1;
                }
            }
            var flowDetails = component.get("v.flowDetails");
            if(!$A.util.isUndefinedOrNull(flowDetails) && !$A.util.isEmpty(flowDetails)){
                var hoursOfOperation = {};
                var validation = 0;

                if(!$A.util.isUndefinedOrNull(flowDetails.conStartTime) && !$A.util.isEmpty(flowDetails.conStartTime) && flowDetails.conStartTime != 'Select'){
                    hoursOfOperation.startTime = flowDetails.conStartTime;
                }
                else{
                    validation = validation+1;
                }
                if(!$A.util.isUndefinedOrNull(flowDetails.conEndTime) && !$A.util.isEmpty(flowDetails.conEndTime) && flowDetails.conEndTime != 'Select'){
                    hoursOfOperation.endTime = flowDetails.conEndTime;
                }
                else{
                    validation = validation+1;
                }
                hoursOfOperation.startTimeType = flowDetails.conStartType;
                hoursOfOperation.endTimeType = flowDetails.conEndType;
                hoursOfOperation.timeZone = flowDetails.conTimeZone;
                caseWrapper.hoursOfOperation = hoursOfOperation;
                if(validation > 0){
                    component.set("v.validateHoursOfOperation",true);
                    helper.hideSpinner(component,event,helper);
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "We hit a snag.",
                        "message": "Complete Hours of Operation.",
                        "type": "error"
                    });
                    toastEvent.fire();
                    component.set("v.showSpinnerForFacetsSubmit",false);
                    return;
                }
            }
            if(inputFieldsError > 0){
                component.set("v.showSpinnerForFacetsSubmit",false);
                return;
            }
        }
        //US3182779 - Sravan - End
        if (!$A.util.isUndefinedOrNull(caseWrapper)) {
            helper.setResolvedData(component, event, helper);
            caseWrapper.savedAutodoc = component.get("v.caseWrapper.savedAutodoc");
            caseWrapper.strFacetsRoutingComments = inputField;
            let isProvider = component.get("v.providerFlow");
            console.log('In isProvider Value'+ isProvider);
            let strWrapper = JSON.stringify(caseWrapper);
            let createCase = component.get("c.saveCase");
            createCase.setParams({
                'strRecord': strWrapper,
                'isProvider': isProvider
            });
            createCase.setCallback(this, function(response) {
                var state = response.getState();
                let toastEvent = $A.get("e.force:showToast");
                if (state == 'SUCCESS') {
                    var caseId = response.getReturnValue();
                    component.set("v.caseId", caseId);
                    //US3068299 - Sravan - 21/11/2020 - Start
                    helper.createExternalCases(component, event, helper);
                    //US3068299 - Sravan - 21/11/2020 - End
                } else if (state == 'INCOMPLETE') {
                    helper.hideSpinner(component, event, helper);
                } else if (state == 'ERROR') {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("Error message: " + errors[0].message);
                        }
                    } else {
                        console.log("Unknown error");
                    }
                    helper.hideSpinner(component, event, helper);
                }
            });
            $A.enqueueAction(createCase);
        }
    },

    closeRoutingTab: function(component, event) {
        component.set("v.isCancelClicked", true);
        var message = event.getParam("strData");
        component.set('v.strDelegatedData', message);
        var workspaceAPI = component.find("workspace");
        workspaceAPI.getFocusedTabInfo().then(function(response) {
                var focusedTabId = response.tabId;
                workspaceAPI.closeTab({
                    tabId: focusedTabId
                });
            })
            .catch(function(error) {
                console.log(error);
            });
    }
})