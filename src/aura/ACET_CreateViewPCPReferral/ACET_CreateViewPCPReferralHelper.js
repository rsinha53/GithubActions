({
	 openMisDirect: function (component, event, helper) {
        var workspaceAPI = component.find("workspace");
        var interactionRecord = component.get("v.interactionRec");
        workspaceAPI.getEnclosingTabId().then(function (enclosingTabId) {
            if (enclosingTabId == false) {
                workspaceAPI.openTab({
                    pageReference: {
                        "type": "standard__component",
                        "attributes": {
                            "componentName": "c__SAE_MisdirectComponent" // c__<comp Name>
                        },
                        "state": {
                        }
                    },
                    focus: true
                }).then(function (response) {
                    workspaceAPI.getTabInfo({
                        tabId: response
                    }).then(function (tabInfo) {
                        
                        var focusedTabId = tabInfo.tabId;
                        workspaceAPI.setTabLabel({
                            tabId: focusedTabId,
                            label: "Misdirect"
                        });
                      
                        workspaceAPI.setTabIcon({
                            tabId: focusedTabId,
                            icon: "standard:decision",
                            iconAlt: "Misdirect"
                        });
                       
                    });
                }).catch(function (error) {
                 
                });
            } else {
                workspaceAPI.openSubtab({
                    parentTabId: enclosingTabId,
                    pageReference: {
                        "type": "standard__component",
                        "attributes": {
                            "componentName": "c__SAE_MisdirectComponent" // c__<comp Name>
                        },
                        "state": {
                            "c__originatorType": component.get('v.originatorType'),
                            "c__interactionID": interactionRecord.Id,
                            "c__contactUniqueId":interactionRecord.Id,
							"c__focusedTabId": enclosingTabId
                        }
                    }
                }).then(function (subtabId) {

                    workspaceAPI.setTabLabel({
                        tabId: subtabId,
                        label: "Misdirect" //set label you want to set
                    });
                    
                    workspaceAPI.setTabIcon({
                        tabId: subtabId,
                        icon: "standard:decision",
                        iconAlt: "Misdirect"
                    });
                   
                }).catch(function (error) {
                   
                });
            }

        });
    },
    
    getReasonforRefferalEntryCodes : function(cmp,event,helper){
        var sourceCode = cmp.get("v.selectedSourceCode");
         var action = cmp.get("c.getSAEReferralEntryReasonCodes");
         action.setParams({
            "sourceCode": sourceCode
       });
        action.setCallback(this, function(a) {
            var state = a.getState();
            if(state == "SUCCESS"){
                var result = a.getReturnValue();
                console.log('==result'+JSON.stringify(result));
                if(!$A.util.isUndefinedOrNull(result) && !$A.util.isEmpty(result)){
                    cmp.set("v.lstofReferralReasonEntries",result);
                }
            }
        });
         $A.enqueueAction(action);
    },
    filterSelectionRelatedReasonCodes : function(cmp,event,helper,isAPSourceCode){
        var selectedFieldOption = '';
        if(!isAPSourceCode){
            selectedFieldOption = cmp.get("v.selectedneedAssisatanceOption");
        }
        else{
           selectedFieldOption = cmp.get("v.selectedExchangePlanValue");
        }
        var defaultOption= {"label": "Select", "value": ""};
        var lstOfReasonEntryOptions = [defaultOption];
		var reasonEntryMap = {};
		reasonEntryMap['Select'] = '';
        var lstOfReasonForReferralEntries= cmp.get("v.lstofReferralReasonEntries");
        if(!$A.util.isUndefinedOrNull(lstOfReasonForReferralEntries) && !$A.util.isEmpty(lstOfReasonForReferralEntries)){
                    lstOfReasonForReferralEntries.forEach(reason => {
                        if(reason.Field_Option__c == selectedFieldOption){

                        var item = {"label":reason.Picklist_UI_Value__c,"value":reason.Picklist_UI_Value__c};
                                   lstOfReasonEntryOptions.push(item);
                    reasonEntryMap[reason.Picklist_UI_Value__c] = reason;

                }
            });
            cmp.set("v.ReferralEntryReasonOptions",lstOfReasonEntryOptions);
            cmp.set("v.refferalEntryReasonMap",reasonEntryMap);
        }

    },
     processPolicyInfo : function(cmp,event,helper){
        console.log('===@@@policy is '+JSON.stringify(cmp.get("v.policy")));

        var lookupdateils = cmp.get("v.objProviderLookupDetails");
        if(!$A.util.isEmpty(lookupdateils) && !$A.util.isEmpty(lookupdateils.memberCardData) && !$A.util.isEmpty(lookupdateils.policySelectedIndex)){
            var memberCardData = lookupdateils.memberCardData;
            var policySelectedIndex = lookupdateils.policySelectedIndex;
            var ProviderName= '--';
            var providerPCPName = memberCardData.CoverageLines[policySelectedIndex].pcpAssignment.providerPCP;
             //cmp.set("v.objMemberDetails", memberCardData.CoverageLines[policySelectedIndex].patientInfo);
            var patientInfo =  memberCardData.CoverageLines[policySelectedIndex].patientInfo;
            if(!$A.util.isEmpty(patientInfo)){
                let ObjmemberData = {
                    "memberName" :($A.util.isEmpty(patientInfo.fullName) ? "--" : patientInfo.fullName),
                    "memberId" :($A.util.isEmpty(patientInfo.MemberId) ? "--" : patientInfo.MemberId),
                    "memberDOB": ($A.util.isEmpty(patientInfo.dob) ? "--" : patientInfo.dob)
                };
                cmp.set("v.objMemberDetails",ObjmemberData);
            }
            console.log('=@#providerPCPName'+providerPCPName);
            console.log('=@#objMemberDetails'+JSON.stringify(cmp.get("v.objMemberDetails")));
            providerPCPName = providerPCPName.trim();
            var isPCPONFile = true;
            if($A.util.isEmpty(providerPCPName) || providerPCPName.includes("No PCP")){
                isPCPONFile = false;
                let objPcpDataHeader = {'strReferringToHeader' : 'Referring Provider: ', 'strReferringToName': 'x', 'showRefferingToName':true};
                cmp.set("v.objPcpReferralDataHeader", objPcpDataHeader);
                let objPcpBodyData = {'isOutputText': true,
                                      'isPcponFile' : false,
                                      'strTaxID' :'999999999',
                                      'strNPI':  '--',
                                      'strPhoneNumber':'999-999-9999',
                                      'strAddress':'--',
                                      'strPrimarySpecialty':'--',
                                      'strStatus':'INN',
                                      'strProviderName' : 'x'};
                    cmp.set("v.objPcpReferralDataBody", objPcpBodyData);
                cmp.set("v.isPCPONFile", false);
            }
            else{
                ProviderName = providerPCPName;
                var pcpInfo = cmp.get("v.policy.resultWrapper.policyRes.primaryCareProvider");
                if(!$A.util.isEmpty(pcpInfo)){
                    

                    let objPcpDataHeader = {'strReferringToHeader' : 'Referring Provider: ', 'strReferringToName': ProviderName, 'showRefferingToName':true};
                    cmp.set("v.objPcpReferralDataHeader", objPcpDataHeader);
                    let addressString = '';
                    if((!$A.util.isEmpty(pcpInfo.pcpProvideraddressLine1) && pcpInfo.pcpProvideraddressLine1!="N/A")) {
                        addressString = addressString+pcpInfo.pcpProvideraddressLine1 + ',';
                    }
                     if((!$A.util.isEmpty(pcpInfo.pcpProvideraddressLine2) && pcpInfo.pcpProvideraddressLine2!="N/A")) {
                        addressString = addressString +pcpInfo.pcpProvideraddressLine2 + ',';
                    }
                     if((!$A.util.isEmpty(pcpInfo.pcpProvidercity) && pcpInfo.pcpProvidercity!="N/A")) {
                        addressString = addressString +pcpInfo.pcpProvidercity + ',';
                    }
                     if((!$A.util.isEmpty(pcpInfo.pcpProviderstate) && pcpInfo.pcpProviderstate!="N/A")) {
                        addressString = addressString +pcpInfo.pcpProviderstate + ',';
                    }
                     if((!$A.util.isEmpty(pcpInfo.pcpProviderzip) && pcpInfo.pcpProviderzip!="N/A")) {
                        addressString = addressString +pcpInfo.pcpProviderzip;
                    }
                    var regEx = /,\s*$/;
                    addressString = addressString.replace(regEx, "");
                    let objPcpBodyData = {'isOutputText': true,
                                          'strTaxID' : ($A.util.isEmpty(pcpInfo.taxId) || pcpInfo.taxId=="N/A") ? "--" : pcpInfo.taxId,
                                          'strNPI':  ($A.util.isEmpty(pcpInfo.providerNpi) || pcpInfo.providerNpi=="N/A") ? "--" : pcpInfo.providerNpi,
                                          'strPhoneNumber': ($A.util.isEmpty(pcpInfo.pcpPhoneNumber) || pcpInfo.pcpPhoneNumber=="N/A") ? "--" : pcpInfo.pcpPhoneNumber,
                                          'strAddress':($A.util.isEmpty(addressString) || addressString =="N/A") ? "--" : addressString,
                                          'strPrimarySpecialty':($A.util.isEmpty(pcpInfo.pcpSpeciality) || pcpInfo.pcpSpeciality=="N/A") ? "--" : pcpInfo.pcpSpeciality,
                                          'strStatus':'INN',
                                          'isPcponFile' : true,
                                          'strProviderName': ProviderName};
                    cmp.set("v.objPcpReferralDataBody", objPcpBodyData);

                }
            }
            console.log('=@#isPCPONFile'+isPCPONFile);
        }
        if(!$A.util.isEmpty(lookupdateils) && !$A.util.isEmpty(lookupdateils.memberTabId)){
           	cmp.set("v.memberTabId",lookupdateils.memberTabId);
           }

    },

    getMemberIdGroupIdAuthDtl: function (cmp) {
        var appEvent = $A.get("e.c:ACET_GetMemberIdGroupIdAuthDtl");
		appEvent.fire();
    }
})