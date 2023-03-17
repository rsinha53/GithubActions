({
    doInit: function (cmp, event, helper) {
        // US2428601 - Btn Autodoc
        let today = new Date();
        let cmpId = today.getTime();
        cmp.set('v.cmpId',cmpId);

        helper.addCmpToList(cmp);

        if(cmp.get("v.isMainComponent")){
            setTimeout(function () {
                helper.setCardDetails(cmp);
            }, 100);
        }

        //US2917421
        let workspaceAPI = cmp.find("workspace");
        workspaceAPI.getEnclosingTabId().then(function (tabId) {
                cmp.set("v.enclosingTabId", tabId);
            })
            .catch(function (error) {
                console.log(error);
            });
    },

    openAuthorizationDetail: function (cmp, event, helper) {
        cmp.set('v.isShowLink',false); //US2670259 Swapnil
		helper.showAuthStatusSpinner(cmp);

        var selecetedCallTopicListstr = JSON.stringify(cmp.get("v.callTopicLstSelected"));

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
                            "c__autodocUniqueId": cmp.get("v.autodocUniqueId"),
                            "c__autodocUniqueIdCmp": cmp.get("v.autodocUniqueIdCmp"),
                            "c__interactionOverviewTabId" : cmp.get("v.interactionOverviewTabId"), //US2330408  - Avish
                            "c__memberId": cmp.get("v.memberId"),
                            "c__callTopicLstSelected" : selecetedCallTopicListstr,
                            "c__callTopicTabId" : cmp.get("v.callTopicTabId"),
                            "c__policy" : cmp.get("v.policy"), //US3653687
                            "c__memberCardData": cmp.get('v.memberCardData'),
                            "c__policySelectedIndex": cmp.get('v.policySelectedIndex')
                        }
                    },

                    focus: true

                }).then(function (response) {

                    mapOpenedTabs.set(srnTabUniqueId, response);
                    cmp.set('v.TabMap', mapOpenedTabs);
                    cmp.set('v.currentTabId',response); //US2670259 Swapnil

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
        var cardDetails = cmp.get("v.cardDetails");
        var index = cardDetails.cardData.findIndex(function(data){
            return data.fieldName == "ICUE Letter";
        });
        if(index == -1){
        cardDetails.cardData.push({
            "checked": true,
            "fieldName": "ICUE Letter",
            "fieldType": "hiddenOutputText",
            "fieldValue": "Accessed",
            "showCheckbox": false,
            "isReportable": true // US2834058 - Thanish - 13th Oct 2020
        });
            _autodoc.setAutodoc(cmp.get("v.autodocUniqueId"), cmp.get("v.autodocUniqueIdCmp"), cardDetails);
        helper.updateCmpCardDetails(cardDetails, cmp.get("v.SRN"));
        }

        //var ICUELetterURL = 'https://icue.uhc.com/icue/';
        //window.open(ICUELetterURL, 'ICUE Letter', 'toolbars=0,width=1200,height=800,left=0,top=0,scrollbars=1,resizable=1');
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
                helper.focusICUEtab(cmp,event,cmp.get('v.SRN'));
            }else{
                helper.openICUEtab(cmp,event);
            }
        }
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
        var cardDetails = cmp.get("v.cardDetails");
        var index = cardDetails.cardData.findIndex(function(data){
            return data.fieldName == "ECAA"; // DE426567 - Thanish - 24th Mar 2021
        });

        if(index == -1){
        cardDetails.cardData.push({
            "checked": true,
            "fieldName": "ECAA", // DE426567 - Thanish - 24th Mar 2021
            "fieldType": "hiddenOutputText",
            "fieldValue": "Accessed",
            "showCheckbox": false,
            "isReportable": true
        });
            _autodoc.setAutodoc(cmp.get("v.autodocUniqueId"), cmp.get("v.autodocUniqueIdCmp"), cardDetails);
        helper.updateCmpCardDetails(cardDetails, cmp.get("v.SRN"));
        }

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
        var cardDetails = cmp.get("v.cardDetails");
        var index = cardDetails.cardData.findIndex(function(data){
            return data.fieldName == "Edit/Escalate Auth";
        });

        if(index == -1){
        cardDetails.cardData.push({
            "checked": true,
            "fieldName": "Edit/Escalate Auth",
            "fieldType": "hiddenOutputText",
            "fieldValue": "Accessed",
            "showCheckbox": false,
            "isReportable": true // US2834058 - Thanish - 13th Oct 2020
        });
            _autodoc.setAutodoc(cmp.get("v.autodocUniqueId"), cmp.get("v.autodocUniqueIdCmp"), cardDetails);
        helper.updateCmpCardDetails(cardDetails, cmp.get("v.SRN"));
        }

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
        //US2670259 Swapnil
        var closedTabId = event.getParam('tabId');
        var currentTabId=cmp.get('v.currentTabId');
        if(currentTabId == closedTabId) {
            cmp.set('v.isShowLink',true);
            cmp.set('v.currentTabId',closedTabId+'closed');
        }
        else if(!$A.util.isUndefinedOrNull(currentTabId) && !currentTabId.includes('closed')){
            cmp.set('v.isShowLink',false);
        }
        //US2670259 Swapnil ends
    },
    // DE378121 - Thanish - 22nd Oct 2020
    authStatusDetailsChanged: function(cmp, event, helper){
        if(!$A.util.isEmpty(cmp.get("v.autodocUniqueId")) && !$A.util.isEmpty(cmp.get("v.autodocUniqueIdCmp"))){
            helper.setCardDetails(cmp);
        }
    },

    selectAll: function (cmp, event, helper) {
        var checked = event.getSource().get("v.checked");
        var cardDetails = cmp.get("v.cardDetails");
        var cardData = cardDetails.cardData;
        for (var i of cardData) {
            if (i.showCheckbox && !i.defaultChecked) {
                i.checked = checked;
            }
        }
        _autodoc.setAutodoc(cmp.get("v.autodocUniqueId"), cmp.get("v.autodocUniqueIdCmp"), cardDetails);
        helper.updateCmpCardDetails(cardDetails, cmp.get("v.SRN"));
    },

    handleSelectCheckBox: function (cmp, event, helper) {
        var cardDetails = cmp.get("v.cardDetails");
        _autodoc.setAutodoc(cmp.get("v.autodocUniqueId"), cmp.get("v.autodocUniqueIdCmp"), cardDetails);
        helper.updateCmpCardDetails(cardDetails, cmp.get("v.SRN"));
    },

    // US3125332 - Thanish - 7th Jan 2021
    handleAutodocRefresh : function(cmp, event, helper) {
        if(cmp.get("v.enableRefreshAutodoc") && (event.getParam("autodocUniqueId") == cmp.get("v.autodocUniqueId"))){
            helper.refreshAutodoc(cmp);
        }
    }
})