({
    init : function(cmp, event, helper)
    {
        helper.formatDate(cmp, event);
        var reqInfo=cmp.get('v.reqInfo');
        var cbInfo=reqInfo.CaseBuildAddInfo;
        var cbInfo='';
        cmp.set('v.caseBuildInfo',cbInfo)
        var workspaceAPI = cmp.find("workspace");
        var snapId;
        workspaceAPI.getFocusedTabInfo().then(function(response) {
             cmp.set('v.currenttabId',response.tabId);
            helper.createProviderRequestDetails(cmp, event , response.tabId ); // US3587915
            helper.fetchProviderDetails(cmp, helper);
         }).catch(function(error) {
            console.log(error);
        });
        
    },
    
	editAuth : function(cmp, event, helper) {
        cmp.set("v.showICUE",false);
		 let cmpEvent = cmp.getEvent("closePreviewModalBox");
        cmpEvent.fire();
	},
    
    submitAuth : function(cmp, event, helper) {
        helper.createProviderDetails(cmp, event);
        cmp.set("v.showICUE",false);
       var currentid=_setAndGetSessionValues.gettingValue(cmp.get('v.currenttabId'));
        var extended=_setAndGetSessionValues.gettingValue("Policy:"+currentid+":"+currentid);
       var memberData=_setAndGetSessionValues.gettingValue("Member:"+currentid+":"+currentid);
        // US3507486 - Create Auth  Update Funding Arrangement Value : Sarma - 10th May 2021
        var rced = _setAndGetSessionValues.gettingValue("RCED:"+currentid+":"+currentid);
        var spinner = cmp.find('srncspinner');
        $A.util.removeClass(spinner,'slds-hide');
        $A.util.addClass(spinner, 'slds-show');
        // Old Imp
        // var authData = {
        //     "memberCardData" : JSON.stringify(cmp.get("v.memberCardSnap")),
        //     "providerDetail" : JSON.stringify(cmp.get("v.hscProviders")),
        //     "SRNData" : JSON.stringify(cmp.get("v.SRNData")),
        //     "extendeResult": JSON.stringify(extended),
        //     "memberDataResult": JSON.stringify(memberData),
        //     "policyCoverageType" : cmp.get('v.policyCoverageType'),
        //     "creationDateNTime" : $A.localizationService.formatDateTime(new Date(), "YYYY-MM-DDTHH:mm:ss.SSSZ"),
        //     "lineOfBusiness":cmp.get('v.lineOfBusiness'),//US3116511 TTAP Vishnu
        //     "insuranceTypeCode":cmp.get('v.insuranceTypeCode'),//US3116511 TTAP Vishnu
        //     "RcedData" : JSON.stringify(rced) // US3507486 - Sarma
        // };
		// var action = cmp.get('c.createSRN');
        // action.setParams({
    	// 	"authData" : JSON.stringify(authData)
        // });


        // US3587913	Create Auth : Call new API for Case Provider Search - Member Mappings - Sarma - 18th June 2021
        // New Action method for the new Webservice class method
		var srnDt=cmp.get("v.SRNData");
		if(srnDt.RequiredInfo.HasAdmitted!="Yes")
		{
			srnDt.RequiredInfo.ActualDischargeDt=null;
		}
		var authData = {
			"SRNData" : JSON.stringify(srnDt),
            "creationDateNTime" : $A.localizationService.formatDateTime(new Date(), "YYYY-MM-DDTHH:mm:ss.SSSZ"),
        };
		var action = cmp.get('c.createAuthorization');
        action.setParams({
    		"authData" : JSON.stringify(authData),
            "caseDetails" : cmp.get('v.caseDetailsForCreateAuth')
        }); 
        // US3587913 Ends

        action.setCallback(this, function (response) {
            var errorCodeVal = ["400", "500", "424"];
            let state = response.getState();
            if (state == "SUCCESS") {
                let result = response.getReturnValue();
                if (!$A.util.isUndefinedOrNull(result) && (!$A.util.isEmpty(result))) {

                    if(result.responseType == 'TTAP'){
                        var autoDocString = helper.createAutoDoc(cmp,'');
                        cmp.set('v.autoDocString',autoDocString);
                        cmp.set("v.flipflop", false);
                        cmp.set('v.isTtapEligible',true);
                        cmp.set('v.ttapUrl',result.redirectUrl);

                    }
                    else {
                    if (result.responseCode == '201') {
                            cmp.set('v.disclaimerMsg', result.disclaimerText.join(' '));
                        cmp.set("v.flipflop", false);
                            // US2356238	Create Authorizations - Determine if Code is TTAP Eligible - Sarma - 19/11/2020


                        // Preview Autodoc - US2819895 - Sanka
                        var autoDocString = helper.createAutoDoc(cmp, result.primaryServiceReferenceNum);
                            cmp.set('v.autoDocString',autoDocString);
                            cmp.set('v.createdAuthNumber',result.primaryServiceReferenceNum);

                    // US2819909
                            // US2356238 - Moving the event to btn click as part of new implementation
                            // var appEvent = $A.get("e.c:ACET_CreateSRN_RecordCreatedEvent");
                            // appEvent.setParams({
                            //     "SRNNumber": result.primaryServiceReferenceNum,
                            //     "autoDocString": autoDocString,
                            //     "memberTabId": cmp.get("v.memberTabId") // US3026437
                            // });
                            // appEvent.fire();

                        }
                        /*else if(result.responseCode=='400')
                        {
                            helper.fireToastMessage("Error!", 'Access ICUE for Auth Creation.', "error", "dismissible", "6000");

                    }
                    else if (errorCodeVal.includes(result.responseCode)) {
                        helper.fireToastMessage("Error!", 'Unexpected error occurred. Please try again. If problem persists contact help desk.', "error", "dismissible", "6000");
                        }
                        else if (result.responseCode == '404') {
                        helper.fireToastMessage("Error!", 'No Results Found.', "error", "dismissible", "60000");
                        }*/
                        else{
                            // US3295179: Services Failed Messages (Create Authorization Page)
                            cmp.set("v.showICUE",true);
                            helper.fireToastMessage("We hit a snag.", 'Unexpected Error Occurred with Submit Authorization. Please try again. If problem persists please contact the help desk.', "error", "dismissible", "30000");
                    }
                    }
                }else{
                    // US3295179: Services Failed Messages (Create Authorization Page)
                    cmp.set("v.showICUE",true);
                    helper.fireToastMessage("We hit a snag.", 'Unexpected Error Occurred with Submit Authorization. Please try again. If problem persists please contact the help desk.', "error", "dismissible", "30000");
                }

                $A.util.removeClass(spinner,'slds-show');
                $A.util.addClass(spinner, 'slds-hide');
            }
        });
        $A.enqueueAction(action);
	},
    closeTab : function(cmp, event, helper) {
        var currentid=cmp.get('v.currenttabId');
        var snapTab=_setAndGetSessionValues.gettingValue(currentid);
        var workspaceAPI = cmp.find("workspace");
        workspaceAPI.getFocusedTabInfo().then(function(response) {
            workspaceAPI.focusTab({tabId : snapTab});
            workspaceAPI.closeTab({tabId: currentid});
        }).catch(function(error) {
            console.log(error);
        });
        // US2356238 - Create Authorizations - Determine if Code is TTAP Eligible - Sarma - 19/11/2020
        var appEvent = $A.get("e.c:ACET_CreateSRN_RecordCreatedEvent");
        appEvent.setParams({
            "SRNNumber": cmp.get("v.createdAuthNumber"),
            "autoDocString": cmp.get("v.autoDocString"),
            "memberTabId": cmp.get("v.memberTabId") // US3026437
        });
        appEvent.fire();
    },
     // US2356238 Create Authorizations - Determine if Code is TTAP Eligible - Sarma - 19/11/2020
     navigateToUrl: function (cmp, event, helper) {
        if(!cmp.get('v.isTtapDisabled')){
            var ttapUrl = cmp.get('v.ttapUrl');
            window.open(ttapUrl, ttapUrl);
			let autoDocString=cmp.get('v.autoDocString');
            cmp.set('v.autoDocString',autoDocString.replace("TTAP link not accessed.", "TTAP link accessed."));
            cmp.set('v.isTtapDisabled',true)
    }
    },
    callICUE: function (cmp, event, helper) {
        /*<aura:attribute name="isICUEButtonClicked" type="Boolean" default="false"/>
    <aura:attribute name="isURLAccessed" type="Boolean" default="false"/>*/
        var appEvent = $A.get("e.c:ACET_CreateSRNAppEvent");
        appEvent.setParams({
            "memberTabId": cmp.get('v.memberTabId'),
            "isSrnClick": true
        });
        appEvent.fire();
    }
})