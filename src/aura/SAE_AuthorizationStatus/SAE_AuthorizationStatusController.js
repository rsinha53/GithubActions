({
    doInit: function (cmp, event, helper) {
        //US2061071

        setTimeout(function () {
            let tabKey = cmp.get("v.AutodocKey");
            window.lgtAutodoc.initAutodoc(tabKey);
            //DE349016
            cmp.set('v.isComponentFullyLoaded',true);
        }, 1000);

        // US2428601 - Btn Autodoc
        let today = new Date();
        let cmpId = today.getTime();
        cmp.set('v.cmpId',cmpId);
    },
    openAuthorizationDetail: function (cmp, event, helper) {
		helper.showAuthStatusSpinner(cmp);
        //US2308090
        let workspaceAPI = cmp.find("workspace");

        workspaceAPI.getAllTabInfo().then(function (response) {

            let mapOpenedTabs = cmp.get('v.TabMap');
            let srnTabUniqueId = cmp.get('v.memberTabId') + cmp.get('v.authID');

            if ($A.util.isUndefinedOrNull(mapOpenedTabs)) {
                mapOpenedTabs = new Map();
            }

            if (!$A.util.isUndefinedOrNull(response)) {
                for (let i = 0; i < response.length; i++) {
                    if (!$A.util.isUndefinedOrNull(response[i].subtabs.length) && response[i].subtabs.length > 0) {
                        for (let j = 0; j < response[i].subtabs.length; j++) {
                            let uniqueMemberId = response[i].subtabs[j].pageReference.state.c__srnTabUnique;
                            let subTabResponse = response[i].subtabs[j];
                            mapOpenedTabs.set(uniqueMemberId, subTabResponse);
                        }
                    }
                }
            }

            //Duplicate Found
            if (mapOpenedTabs.has(srnTabUniqueId)) {

                let tabResponse = mapOpenedTabs.get(srnTabUniqueId);

                //cmp.set('v.TabMap', mapOpenedTabs);

                workspaceAPI.openTab({
                    url: tabResponse.url
                }).then(function (response) {
                    workspaceAPI.focusTab({
                        tabId: response
                    });
                }).catch(function (error) {
                });


            } else { 

                workspaceAPI.openSubtab({

                    pageReference: {
                        "type": "standard__component",
                        "attributes": {
                            "componentName": "c__ACET_AuthorizationDetail"
                        },
                        "state": {
                            "c__authDetails": JSON.stringify(cmp.get('v.authStatusDetails')),
                            "c__authType": cmp.get('v.authType'),
                            "c__LengthOfStay": cmp.get('v.LengthOfStay'),
                            "c__SRN": cmp.get('v.SRN'),
                            "c__srnTabUnique": srnTabUniqueId,
                            "c__interactionRec": JSON.stringify(cmp.get('v.interactionRec')), //US2325822
                            "c__isMedicaidPlan": cmp.get('v.isMedicaidPlan'),
                            "c__AutodocPageFeature": cmp.get('v.AutodocPageFeature'), //US2301790
                            "c__AutodocKey": cmp.get("v.AutodocKey"), // Autodoc multiple pages - Lahiru - 3rd Mar 2020
                            "c__assignmentFlag": false, //US2382470
                            "c__contactUniqueId": cmp.get("v.contactUniqueId"),
                            "c__hipaaEndpointUrl":cmp.get("v.hipaaEndpointUrl"),//US2076634 - Sravan - 22/06/2020
                            "c__interactionOverviewTabId" : cmp.get("v.interactionOverviewTabId"), //US2330408  - Avish
                            "c__memberId" : cmp.get("v.memberId")
                        }
                    },

                    focus: true

                }).then(function (response) {

                    mapOpenedTabs.set(srnTabUniqueId, response);
                    cmp.set('v.TabMap', mapOpenedTabs);

                    workspaceAPI.setTabLabel({
                        tabId: response,
                        label: cmp.get('v.SRN')
                    });
                    workspaceAPI.setTabIcon({
                         tabId: response,
                        icon: "utility:play",
                        iconAlt: "Auth Details"
                    });

                }).catch(function (error) {
                  
                });
            }

        }).catch(function (error) {
          
        });

    },

    // US2263100 - View Authrizations and Notifications - Results and Status Wrap Text UI
    closeAuthStatus: function (cmp, event, helper) {
        //DE349016
        if(cmp.get('v.isComponentFullyLoaded')){
        var cmpEvent = cmp.getEvent("ACET_AuthorizationStatusClose");
        cmpEvent.setParams({
            "tabId": cmp.get('v.memberTabId'),
            "authCompId": cmp.get('v.compName')
        });
        cmpEvent.fire();
        }
    },

    //US2262689 - Load ECAA and ICUE Letter
    loadICUE: function (cmp, event, helper) {
        //US2428601
        var cmpId = cmp.get('v.cmpId');
        cmp.set('v.isICUEBtnClicked',true);
        document.getElementById(cmpId).getElementsByTagName('input')[0].checked = true;

        var ICUELetterURL = 'https://icue.uhc.com/icue/';
        window.open(ICUELetterURL, 'ICUE Letter', 'toolbars=0,width=1200,height=800,left=0,top=0,scrollbars=1,resizable=1');
    },

    /*** DE334279 - Avish **/
    checkduplicateTab: function (cmp, event, helper) {
        console.log(event.getParam("uniqueSRNTabId"));
        var uniqueSRNLst = cmp.get('v.uniqueSRN');
        if(!$A.util.isEmpty(event.getParam("uniqueSRNTabId"))){
            if(uniqueSRNLst.length == 0){
                uniqueSRNLst.push(event.getParam("uniqueSRNTabId"));
            }else{
                for (var i = 0; i < uniqueSRNLst.length; i++) {
                    if(event.getParam("uniqueSRNTabId") != uniqueSRNLst[i]){
                        uniqueSRNLst.push(event.getParam("uniqueSRNTabId"));
                        break;
                    }
                }
            } 
            cmp.set('v.uniqueSRN',uniqueSRNLst);
        } 
    },
    
    handleClosedTabID: function (cmp, event){
        if(!$A.util.isEmpty(event.getParam("srn"))){
            var uniqueSRNLst = cmp.get('v.uniqueSRN');
            for (var i = 0; i < uniqueSRNLst.length; i++) {
                if(uniqueSRNLst[i] != undefined){
                    var srnVal = uniqueSRNLst[i];
                    
                    if (event.getParam("srn") == uniqueSRNLst[i]) {
                        if(event.getParam("docIDToClose").length > 0){
                            cmp.set("v.docIdLst",event.getParam("docIDToClose"));
                        }
                        if(uniqueSRNLst.length == 1){
                            uniqueSRNLst = [];
                        }else{
                            uniqueSRNLst = uniqueSRNLst.splice(i, 1);
                        }

                        var workspaceAPI = cmp.find("workspace");
                        workspaceAPI.getAllTabInfo().then(function(response) {
                            if(!$A.util.isEmpty(response)){
                                for(var i = 0; i < response.length; i++){
                                    console.log(response[i].pageReference.attributes.componentName);
                                    for(var j = 0; j < response[i].subtabs.length; j++){
                                        if(response[i].subtabs[j].pageReference.attributes.componentName == "c__ACET_EDMSIframe"){
                                            if(cmp.get("v.docIdLst").length > 0 ){
                                                for(var k = 0; k<cmp.get("v.docIdLst").length; k++){
                                                    if(cmp.get("v.docIdLst")[k] == response[i].subtabs[j].title){
                                                        var focusedTabId = response[i].subtabs[j].tabId;
                                                        workspaceAPI.closeTab({tabId: focusedTabId});
                                                    }
                                                }
                                            }
                                            
                                        }
                                    }
                                }
                            }
                        })
                        .catch(function(error) {
                            console.log(error);
                        });
                    }
                }
            }
            cmp.set("v.uniqueSRN", uniqueSRNLst);
        }
    },
    /*** DE334279 - Avish **/

    loadECAA: function (cmp, event, helper) {
        //US2428601
        var cmpId = cmp.get('v.cmpId');
        cmp.set('v.isECAABtnClicked',true);
        document.getElementById(cmpId).getElementsByTagName('input')[0].checked = true;

        /*** DE334279 - Avish **/
        var uniqueSRNLst = cmp.get('v.uniqueSRN');
        if(!$A.util.isEmpty(cmp.get('v.SRN'))){
            
            var srnOpened = false;
            if(uniqueSRNLst.length > 0){
                for (var i = 0; i < uniqueSRNLst.length; i++) {
                    if(cmp.get('v.SRN') == uniqueSRNLst[i]){
                        srnOpened = true;
                        break;
                    }
                }
            }
            if(srnOpened){
                helper.focusSRNTab(cmp,event,cmp.get('v.SRN'));
            }else{
                helper.openSRNTab(cmp,event);
            }
        }
        /*** DE334279 **/
    },

    editSRN: function (cmp, event, helper) {
       
        // US2428601
        var cmpId = cmp.get('v.cmpId');
        document.getElementById(cmpId).getElementsByTagName('input')[0].checked = true;
        cmp.set('v.isEditSrnBtnClicked',true);
        cmp.set("v.spinnerFlag",true);
       
        var actionicue = cmp.get("c.editICUEURL");
        actionicue.setParams({
            "srnNumber": cmp.get('v.SRN'),
            "originatorType": 'Member'
        });

        actionicue.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                
                cmp.set("v.ICUEURL", storeResponse);
                helper.getICUEURL(cmp, event, helper);
            }
        });
        $A.enqueueAction(actionicue);
    },

    onTabClosed: function (cmp, event) {

        let mapOpenedTabs = cmp.get('v.TabMap');
        let srnTabUniqueId = cmp.get('v.memberTabId') + cmp.get('v.authID');

        if (!$A.util.isUndefinedOrNull(mapOpenedTabs) && mapOpenedTabs.has(srnTabUniqueId)) {
            mapOpenedTabs.delete(srnTabUniqueId);
            cmp.set('v.TabMap', mapOpenedTabs);
        }
    },

    // US2271237 - View Authorizations - Update Policies in Auto Doc : Kavinda
    handlePolicyClick: function (cmp, event, helper) {
       cmp.set('v.IsAutoDocEnable', false);
    },
    // DE322503 - Resetting button autodoc during case save - Sarma
    resetBtnAutodoc: function (component,event) {
        var originPage = event.getParam("AutodocPageFeature");
        if(originPage == component.get('v.AutodocPageFeature')){
            var cmpId = component.get('v.cmpId');
            document.getElementById(cmpId).getElementsByTagName('input')[0].checked = false; 
            component.set("v.isEditSrnBtnClicked", false);
            component.set("v.isICUEBtnClicked", false);
            component.set("v.isECAABtnClicked", false);
        }
    },
})