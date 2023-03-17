({
    // US2931847 - TECH - Modified Signature
    searchHelper: function (component, event, getInputkeyWord, autoRoute) {
        // call the apex class method
        var action = component.get("c.fetchLookUpValues");
        // set param to method
        action.setParams({
            'searchKeyWord': getInputkeyWord,
            'ObjectName' : component.get("v.objectAPIName"),
            'ExcludeitemsList' : component.get("v.lstSelectedRecords"),
            'detailpagename' : component.get("v.detailPgName"),
            'originatortype' : component.get("v.originatorName")
        });
        // set a callBack
        action.setCallback(this, function(response) {
           // $A.util.removeClass(component.find("mySpinner"), "slds-show");
            var state = response.getState();
            console.log("-------"+state);
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                // if storeResponse size is equal 0 ,display No Records Found... message on screen.                }
                if (storeResponse.length == 0) {
                    component.set("v.Message", 'No Records Found...');
                } else {
                    component.set("v.Message", '');
                    // set searchResult list with return value from server.
                }
                component.set("v.listOfSearchRecords", storeResponse);

                // US2931847 - TECH
                if (!$A.util.isEmpty(autoRoute) && autoRoute) {
                    this.openTopicFromEvent(component);
                }

                //US2570805 - VCCD - Member Snapshot call topic Integration - Sravan - Start
                    //US2789379 - Advocate can not add or search topic when he provided topic through VCC. - Start
                    let objSelectedResponse = component.get("v.lstSelectedRecords");
                    let initiallySelectedTopics = [];
                    if(!$A.util.isUndefinedOrNull(objSelectedResponse) && !$A.util.isEmpty(objSelectedResponse)){
                        objSelectedResponse.forEach(function(selectedRec){
                            initiallySelectedTopics.push(selectedRec.Id);
                        });
                    }
                if(component.get("v.isVCCD")){
                   if(!$A.util.isUndefinedOrNull(storeResponse) && !$A.util.isEmpty(storeResponse)){
                        storeResponse.forEach(function(objKey){
                                if(objKey && objKey.Name && objKey.Name.includes(component.get("v.VCCDQuestionType"))){
                                    if(!$A.util.isUndefinedOrNull(objSelectedResponse) && !$A.util.isEmpty(objSelectedResponse)){
                                        console.log('Record'+ JSON.stringify(objSelectedResponse));
                                        if(!$A.util.isUndefinedOrNull(initiallySelectedTopics) && !$A.util.isEmpty(initiallySelectedTopics) && !initiallySelectedTopics.includes(objKey.Id)){
                                            objSelectedResponse.push(objKey);
                                        }
                                    }
                                    else{
                                        objSelectedResponse.push(objKey);
                                    }
                            }
                        });
                        }
                        if(!$A.util.isUndefinedOrNull(objSelectedResponse) && !$A.util.isEmpty(objSelectedResponse)){
                            component.set("v.lstSelectedRecords",objSelectedResponse);
                     component.set("v.topicPresent",true);
                   }
                   }


                   //ketki open member snapshot from claim
				   var preSelectedTopic = component.get("v.preSelectedTopic");

                   if(!$A.util.isUndefinedOrNull(preSelectedTopic) && !$A.util.isEmpty(preSelectedTopic)){
                       if(!$A.util.isUndefinedOrNull(storeResponse) && !$A.util.isEmpty(storeResponse)){
                            storeResponse.forEach(function(objKey){
                                    if(objKey && objKey.Name && objKey.Name.includes(preSelectedTopic)){
                                        if(!$A.util.isUndefinedOrNull(objSelectedResponse) && !$A.util.isEmpty(objSelectedResponse)){
                                            console.log('Record'+ JSON.stringify(objSelectedResponse));
                                            if(!$A.util.isUndefinedOrNull(initiallySelectedTopics) && !$A.util.isEmpty(initiallySelectedTopics) && !initiallySelectedTopics.includes(objKey.Id)){
                                                objSelectedResponse.push(objKey);
                                            }
                                        }
                                        else{
                                            objSelectedResponse.push(objKey);
                                        }
                                }
                            });
                            }
                            if(!$A.util.isUndefinedOrNull(objSelectedResponse) && !$A.util.isEmpty(objSelectedResponse)){
                                component.set("v.lstSelectedRecords",objSelectedResponse);
                         component.set("v.topicPresent",true);
                   	}
                   }
                   //ketki open member snapshot from claim end

                    //US2570805 - VCCD - Member Snapshot call topic Integration - Sravan - End

                    //US2789379 - Advocate can not add or search topic when he provided topic through VCC. - End

            }
        });
        // enqueue the Action
        $A.enqueueAction(action);
    },

    // US2465305
    getObjectMappingByName: function(cmp, topicValue) {
        if (topicValue == "Plan Benefits") {
            return 'PlanBenefits';
        }
        /*US1958804 */
        if (topicValue == "View Claims") {
            return 'ViewClaims';
        }
        if (topicValue == "View Payments") {
            return 'ViewPayments';
        }
        if (topicValue == "Provider Lookup") {
            return 'ProviderLookup';
        }
         if (topicValue == "View PCP Referrals") {
            return 'ViewPCPReferrals';
        }
        if (topicValue == "View Authorizations") {
            return 'ViewAuthorizations';
        }
        // US3802608 - Thanish - 25th Aug 2021
        if (topicValue == "View Appeals") {
            return 'ViewAppeals';
        }
    },
    
    // US2465305
    // US2931847 - TECH - Modified Signature
    createCallTopicOrder: function (cmp) {
        var selecteditem = cmp.get("v.lstSelectedRecords");
        if (selecteditem.length == 0) {
            return;
        }
        var currentSelection = cmp.get('v.currentSelection');
        var callTopicOrder = new Object();
        var i = 1;
        let keys = currentSelection.length;
        --keys;
        for(var x = keys; 0 <= x; x--){
            for (const topicName of currentSelection[x]) {
                var objVal = this.getObjectMappingByName(cmp, topicName);
                callTopicOrder[objVal] = i;
                ++i;
            }
        }
		// DE357978
        if (selecteditem.length == 1) {
            for (var key in callTopicOrder) {
                if (callTopicOrder.hasOwnProperty(key)) {
                    if(callTopicOrder[key] > 1){
                        callTopicOrder[key] = 1;
                    }
                }
            }
        } 
        cmp.set('v.callTopicOrder', callTopicOrder);
    },

    // US2465305
    createCallTopicOrderOnClose: function(cmp, event, helper, topicName) {
        var selecteditem = cmp.get("v.lstSelectedRecords");
        if (selecteditem.length == 0) {
            return;
        }
        var tempSelection = cmp.get('v.tempSelection');
        if (tempSelection != undefined && tempSelection.length > 0) {
            for(var x = 0; x < tempSelection.length; x++){
                if(tempSelection[x] == topicName){
                    tempSelection.splice(x, 1);
                }
            }
            cmp.set("v.tempSelection", tempSelection);
        } else {
            var i = 1;
            var tempSel = [];
            for(var x = 0; x < selecteditem.length; x++){
                tempSel.push(selecteditem[x].Name);
                ++i;
        }
            var currentSelection = [];
            currentSelection.push(tempSel);
            cmp.set('v.currentSelection', currentSelection);
    }
    },

    // US2931847 - TECH
    openTopicFromEvent: function (cmp) {
        var listSelectedItems = !$A.util.isEmpty(cmp.get("v.lstSelectedRecords")) ? cmp.get("v.lstSelectedRecords") : [];
        var tempSelection = cmp.get('v.tempSelection');
        var currentSelection = cmp.get('v.currentSelection');

        var hasProviderLookup = false;
        for (let i = 0; i < listSelectedItems.length; i++) {
            if (listSelectedItems[i].Name == 'Provider Lookup') {
                hasProviderLookup = true;
                break;
            }
        }

        cmp.get("v.listOfSearchRecords").forEach(element => {
            if (element.Name == 'Provider Lookup' && !hasProviderLookup) {
                listSelectedItems.push(element);
                tempSelection.push(element.Name);
            }
        });

        if (hasProviderLookup) {
            var tabId;
            var workspaceAPI = cmp.find("workspace");
            workspaceAPI.getEnclosingTabId().then(function (ctabId) {
                    tabId = ctabId;
                    console.log('tabIdtabId '+tabId);
                    // DE432212
                    var appEvent = $A.get("e.c:ACET_RefreshDataFromHeaderEvt");
                    appEvent.setParams({
                        "tabId": tabId
                    });
                    appEvent.fire();
                })
                .catch(function (error) {
                    console.log(error);
                });

        }

        cmp.set("v.lstSelectedRecords", listSelectedItems);
        cmp.set('v.tempSelection', tempSelection);

        var topicClick = cmp.getEvent("topicClick");
        topicClick.setParams({
            "clickedTopic": "Provider Lookup"
        });
        topicClick.fire();

        if (tempSelection.length > 0) {
            currentSelection.push(tempSelection);
            cmp.set('v.currentSelection', currentSelection);
        }
        cmp.set('v.tempSelection', []);

        this.createCallTopicOrder(cmp);
    }

})