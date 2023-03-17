({
    onLoad: function(component,event,helper){
         var pageReference = component.get("v.pageReference");
        var originatorType = pageReference.state.c__originatorType;
        component.set("v.originatorType",originatorType);
        var interactionRecord = pageReference.state.c__interactionRec;
        component.set("v.interactionRec",interactionRecord);
        var autodocUniqueId = pageReference.state.c__autodocUniqueId;
        component.set("v.autodocUniqueId",autodocUniqueId);
         var hipaaEndpointUrl = pageReference.state.c__hipaaEndpointUrl;
        component.set("v.hipaaEndpointUrl",hipaaEndpointUrl);
         var isHippaInvokedInProviderSnapShot = pageReference.state.c__isHippaInvokedInProviderSnapShot;
        component.set("v.isHippaInvokedInProviderSnapShot",isHippaInvokedInProviderSnapShot);
        var policy= pageReference.state.c__policy;
        component.set("v.policy",policy);
        var providerLookupDetails =  pageReference.state.c__providerLookupInfo;
        component.set("v.objProviderLookupDetails",providerLookupDetails);
        console.log('=@#ProviderLookupDetails'+JSON.stringify(providerLookupDetails));
        var selectedSourceCode =  pageReference.state.c__selectedSourceCode;
        component.set("v.selectedSourceCode",selectedSourceCode);
        component.set("v.APSourceCodeURL","https://kmead.uhc.com/filestorage/KM/files/uploaded/Community_&_State_-_Provider_Pre-Service_and_Post-Service_Authorizations_Time1606370525111.htm?gtxResourceFileName=Community_&_State_-_Provider_Pre-Service_and_Post-Service_Authorizations.htm&mode=download#Referral_required");
         helper.getMemberIdGroupIdAuthDtl(component);
        helper.getReasonforRefferalEntryCodes(component,event,helper);

        let objPcpReferToDataHeader = {'strReferringToHeader' : 'Referred to Provider: ', 'showRefferingToName':true};
        component.set("v.objPcpReferralToDataHeader", objPcpReferToDataHeader);
        let objPcpReferToDataBody = {'isOutputText': true, 'isInputText':false,'isPcponFile' : true};
        component.set("v.objPcpReferralToDataBody", objPcpReferToDataBody);
        helper.processPolicyInfo(component,event,helper);
    },
    
    setMmberIdGroupIdAuthDtl : function(component, event, helper) {
        var memberId = event.getParam("memberIdAuthDtl");
        var GroupId = event.getParam("groupIdAuthDtl");
        var taxId = event.getParam("alertTaxId");
        var providerId = event.getParam("alertProviderId");
        component.set("v.groupIdAuthDtl",GroupId);
        component.set("v.alertProviderId",providerId);
        component.set("v.alertTaxId",taxId);
        component.set("v.memberIdAuthDtl",memberId);


    },
    
    getAlertFORReferral : function(component, event, helper) {
        component.find("alertsAI_CreateReferral").getAlertsOnCreateReferralPage();
    },
    
    handleRadioChange : function(component,event,helper){
        let strSourceName = event.getSource().get('v.name');

        if(strSourceName) {
            if(strSourceName === 'incorrectPCPradioGroup') {
                //DO Nothing
            } else if(strSourceName === 'needAssisatanceradioGroup') {

        if((component.get("v.selectedSourceCode") == 'CO' || component.get("v.selectedSourceCode") == 'CS') && component.get("v.selectedneedAssisatanceOption") == 'No' ){
            component.set("v.showReasonforREField",true);
                    helper.filterSelectionRelatedReasonCodes(component,event,helper,false);
        }
        if( component.get("v.selectedSourceCode") == 'AP' && component.get("v.selectedneedAssisatanceOption") == 'No' ){
            component.set("v.showisExchangePlan",true);
                    if(component.get("v.selectedExchangePlanValue") == 'Yes' || component.get("v.selectedExchangePlanValue") == 'No'){
                        component.set("v.showReasonforREField",true);
        }
                }

        if( component.get("v.selectedneedAssisatanceOption") == 'Yes'){
            component.set("v.showisExchangePlan",false);
            component.set("v.showReasonforREField",false);
        }

            } else if(strSourceName === 'isExchangePlan') {

         component.set("v.showReasonforREField",true);
                component.set("v.selectedNoteValue","");
                component.set("v.selectedReasoneFORREValue","");
                helper.filterSelectionRelatedReasonCodes(component,event,helper,true);

                if(component.get("v.selectedReasoneFORREValue") && component.get("v.selectedReasoneFORREValue") !== 'None of these situations apply') {
                    component.set('v.showReferringCards', true);
                } else {
                    component.set('v.showReferringCards', false);
                }

            } else if(strSourceName === 'reasonFORRE') {
       
                var selectedValue = event.getParam("value");
                var rMap = component.get("v.refferalEntryReasonMap");
                var selectedReasonRecord = rMap[selectedValue];
                component.set("v.objSelectedValidationRecord", selectedReasonRecord);
                component.set("v.selectedNoteValue","");
                if(!$A.util.isUndefinedOrNull(selectedReasonRecord) && !$A.util.isEmpty(selectedReasonRecord)){
                    component.set("v.selectedNoteValue",selectedReasonRecord.Note__c);
                }

                //Jitendra
                let objPcpReferToDataHeader = {'strReferringToHeader' : 'Referred to Provider: ', 'showRefferingToName':true};
                component.set("v.objPcpReferralToDataHeader", objPcpReferToDataHeader);
                let objPcpReferToDataBody = {'isOutputText': true, 'isInputText':false, 'isPcponFile' : true};
                component.set("v.objPcpReferralToDataBody", objPcpReferToDataBody);
                helper.processPolicyInfo(component,event,helper);
                component.set("v.strReasonForReferral", selectedValue);
                if(selectedValue !== 'None of these situations apply') {
                    component.set('v.showReferringCards', true);
                } else {
                    component.set('v.showReferringCards', false);
                }

            }
        }
    },
    
	 handleHippaGuideLines : function(component, event, helper) {
		var hipaaEndPointUrl = component.get("v.hipaaEndpointUrl");
        if(!$A.util.isUndefinedOrNull(hipaaEndPointUrl) && !$A.util.isEmpty(hipaaEndPointUrl)){
            window.open(hipaaEndPointUrl, '_blank');
        }
        component.set("v.isHippaInvokedInProviderSnapShot",true);

        
        var cardDetails = new Object();
        cardDetails.componentName = "HIPAA Guidelines";
        cardDetails.componentOrder = 0;
        cardDetails.noOfColumns = "slds-size_1-of-1";
        cardDetails.type = "card";
        cardDetails.allChecked = false;
        cardDetails.cardData = [
            {
                "checked": true,
                "disableCheckbox": true,
                "fieldName": "HIPAA Guidelines",
                "fieldType": "outputText",
                "fieldValue": "Accessed"
            }
        ];
        _autodoc.setAutodoc(component.get("v.autodocUniqueId"), 0, cardDetails);
    },
    openMisdirectComp: function (component, event, helper) {
        helper.openMisDirect(component, event, helper);
    },

    handleReferralChanges: function(component, event, helper) {
        if(component.get("v.objPcpReferralDataBody") &&
            component.get("v.objPcpReferralToDataBody") &&
            component.get("v.objPcpReferralDataBody")['strStatus'] === 'INN' &&
            component.get("v.objPcpReferralToDataBody")['strStatus'] === 'INN') {
            component.set("v.boolIsSubmitDisabled",false);
        } else {
            component.set("v.boolIsSubmitDisabled",true);
        }
    },
})