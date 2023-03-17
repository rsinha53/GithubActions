({
    onRenderHandler : function(objComponent, objEvent, objHelper) {
        let appEvent = $A.get("e.c:ACET_VCCDInBoundRouting");
        const objWorkSpaceAPI = objComponent.find("workspace");
        //To hold the focus tab Id
        let focusedTabId = '';
        //To identify the tab to be focus after refresh
        objWorkSpaceAPI.getFocusedTabInfo().then(function(response){
            focusedTabId = response.tabId;
            let objResponse = {};
            if(response && response.pageReference && response.pageReference.attributes && response.pageReference.attributes.attributes && response.pageReference.attributes.attributes.address) {
               const urlInfo = new URL(response.pageReference.attributes.attributes.address);
                objResponse = {"Ani__c" : urlInfo.searchParams.get('ENT_FromAddress'), 
                                   "ClaimId__c" : urlInfo.searchParams.get('ENT_ClaimId'), 
                                   "ClaimsDOSMD__c" : urlInfo.searchParams.get('ENT_ICMClaimsDOS'),
                                   "MemberId__c" : urlInfo.searchParams.get('ENT_SubjectConstituentID'), 
                                   "MSID__c" : urlInfo.searchParams.get('ENT_AgentID'),
                                   "NPI__c" : urlInfo.searchParams.get('ENT_ContactConstituentID'), 
                                   "ProductType__c" : urlInfo.searchParams.get('ENT_ICMProductType'),
                                   "QuestionType__c" : urlInfo.searchParams.get('ENT_ICMQuestionType'),
                                   "SubjectDOB__c" : urlInfo.searchParams.get('ENT_SubjectDOB'),
                                   "TaxId__c" : urlInfo.searchParams.get('ENT_ContactGroupID'),
                                   "Ucid__c" : urlInfo.searchParams.get('Cisco_Gucid'),
                               	   "TFN__c" : urlInfo.searchParams.get('ENT_ToAddress')};
                console.log(' String URL Params ' + JSON.stringify(objResponse));
                let objMessage = {"isVCCD" : false , "objRecordData" : objResponse, "isGenesys" : true};
                let appEvent = $A.get("e.c:ACET_VCCDInBoundRouting");
                appEvent.setParams({"message" : JSON.stringify(objMessage)});
                appEvent.fire();                
                objWorkSpaceAPI.closeTab({tabId: focusedTabId});
            } else if (response && response.url) {
                let lstUrls = response.url.split('#');
                if(lstUrls.length == 1) {
                    objWorkSpaceAPI.closeTab({tabId: focusedTabId});
                    return;
                }
                let lstValues = response.url.split('#')[1].replace('{','').replace('}','').split(',');
                objResponse = {};
                lstValues.forEach(function(strKey) {
                    if(strKey && strKey.split(':').length > 0) {
                        let lstKeyValues = strKey.split(':');
                        objResponse[lstKeyValues[0]] = lstKeyValues[1];
                    }
                });
                let objMessage = {"isVCCD" : false , "objRecordData" : objResponse, "isGenesys" : true};
                let appEvent = $A.get("e.c:ACET_VCCDInBoundRouting");
                appEvent.setParams({"message" : JSON.stringify(objMessage)});
                appEvent.fire();                
                objWorkSpaceAPI.closeTab({tabId: focusedTabId});
            }
        }).catch(function () { /* Do Nothing */ });
    },
})